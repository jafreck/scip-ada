# scip-ada Design Analysis

## 1. Problem Statement

No SCIP indexer exists for Ada/SPARK. The Sourcegraph SCIP ecosystem covers ~14 languages — Ada is not among them. Building `scip-ada` would enable Ada codebases to be indexed by any SCIP-consuming tool (Sourcegraph, Lore, etc.).

## 2. Is GNAT Open Source?

**Yes, completely.** GNAT is part of GCC, licensed under **GPL-3 with GCC Runtime Library Exception** — meaning proprietary Ada code can be compiled with it. FSF GNAT ships with every major Linux distro.

AdaCore also offers GNAT Pro (commercial support), but the compiler itself is fully open.

## 3. SCIP Schema Requirements

An SCIP index consists of:

```
Index
├─ metadata: Metadata (tool info, project root)
├─ documents: Document[] (per-file data)
│   ├─ language: "ada"
│   ├─ relativePath: string
│   ├─ occurrences: Occurrence[]
│   │   ├─ range: [startLine, startChar, endChar] or [startLine, startChar, endLine, endChar]
│   │   ├─ symbol: string (fully qualified symbol identifier)
│   │   └─ symbolRoles: bitset (Definition=1, Import=2, WriteAccess=4, ReadAccess=8, ...)
│   └─ symbols: SymbolInformation[]
│       ├─ symbol: string
│       ├─ kind: Kind enum (Class, Method, Function, Variable, ...)
│       ├─ displayName: string
│       ├─ documentation: string[]
│       └─ relationships: Relationship[] (is_reference, is_implementation, is_type_definition)
└─ externalSymbols: SymbolInformation[] (symbols from other packages)
```

### Symbol String Format

```
<symbol> ::= <scheme> ' ' <package> ' ' <descriptor>+
           | 'local ' <local-id>

<package> ::= <manager> ' ' <name> ' ' <version>

<descriptor> ::= <name> '/'    -- Namespace (package)
               | <name> '#'    -- Type
               | <name> '.'    -- Term/field
               | <name> '(' [disambig] ').'  -- Method/subprogram
               | '[' <name> ']'  -- TypeParameter (generic formal)
               | '(' <name> ')'  -- Parameter
```

**Ada mapping examples:**
- `scip-ada gnat ada_runtime 2024 Ada/Text_IO/Put_Line().` → `Ada.Text_IO.Put_Line`
- `scip-ada . my_project . My_Package/My_Type#` → `My_Package.My_Type`
- `scip-ada . my_project . My_Package/Process(+1).` → overloaded `My_Package.Process`

The SCIP `Language` enum already includes `Ada = 39`.

## 4. Candidate Data Sources

### 4.1 GNAT `.ali` Files

GNAT produces `.ali` (Ada Library Information) files as a side effect of every compilation. These contain:

- **Dependency information** (which files depend on which)
- **Cross-reference data** — every entity reference in the compiled unit:
  - Entity kind (procedure, function, package, type, variable, etc.)
  - Defining occurrence (file, line, column)
  - All references (file, line, column, reference type: read/write/call/instantiation/etc.)

The ALI cross-reference format is documented in GNAT source `lib-writ.ads`. Example:

```
X 1 hello.ads
1U9*Hello 2:1 3U9*Hello_World 4:3
X 2 hello.adb
1K9*Hello 3:1 4P9 Sub{3|1K9}
```

Entity kind characters include:
- `K` = package, `U` = unit (subprogram), `P` = procedure, `V` = variable
- `R` = record type, `E` = enumeration type, `A` = array type
- `+` = generic formal, `*` = defining occurrence

Reference type characters include:
- `r` = reference, `m` = modification, `s` = subprogram call
- `i` = instantiation, `b` = body, `e` = end of spec

**Pros:**
- Already produced during normal compilation — zero extra analysis cost
- Contains fully resolved cross-references (compiler-verified)
- Covers the entire semantic model (generics, overloading, tagged dispatching)
- No additional dependencies beyond GNAT
- Text format, easy to parse

**Cons:**
- Requires a **successful compilation** — the code must be semantically valid
- Format is GNAT-internal (documented in `lib-writ.ads`, stable but not a public API)
- Doesn't include type signatures or hover documentation
- Missing some SCIP fields (no fine-grained `SymbolInformation.Kind`, no `Relationship.is_implementation`)

### 4.2 Libadalang

AdaCore's standalone library for parsing + name resolution. Key facts:

- **License: Apache 2.0 + LLVM Exception** (very permissive)
- 100% Ada 2012 syntax parsing, Ada 2022 in progress
- Error-tolerant — works on incomplete/erroneous code
- Lazy, on-demand semantic analysis
- Python, Ada, C, OCaml bindings
- ~300MB per 100k LOC in memory
- Active development — v26.0.0 released Nov 2025

API for cross-references:
```python
import libadalang as lal

ctx = lal.AnalysisContext()
unit = ctx.get_from_file("hello.adb")

for node in unit.root.findall(lal.Name):
    decl = node.p_referenced_decl()
    if decl:
        print(f"{node.text} at {node.sloc_range} -> {decl.text} at {decl.sloc_range}")
```

**Pros:**
- Apache 2.0 licensed — no GPL friction
- Works on incomplete/erroneous code (error recovery)
- Rich AST — type signatures, documentation comments, generic info
- Python bindings for fast prototyping
- Can compute `is_implementation` relationships for tagged types

**Cons:**
- Name resolution not as complete as GNAT's for corner cases
- Non-trivial dependency chain (langkit, gnatcoll, etc.)
- Slower than reading pre-computed `.ali` data
- Memory-heavy for large projects

### 4.3 Ada Language Server (LSP Wrapper)

Wrap ALS like `scip-rust` wraps rust-analyzer.

**Pros:** Least initial code, pre-built binaries available.

**Cons:**
- GPL-3 licensed (distribution implications)
- Slow — JSON-RPC overhead, designed for interactive use
- Can't bulk-extract all data efficiently
- ~450MB baseline + 300MB/100k LOC RAM

**Verdict: Not recommended.** The LSP wrapper approach is the worst of all worlds for batch indexing — slow, memory-heavy, and GPL-3.

## 5. Recommended Architecture: Hybrid `.ali` + Libadalang

### Why hybrid?

1. **`.ali` gives exact, compiler-verified cross-references** — every entity, every reference, every file. Free (already produced by compilation).

2. **Libadalang fills the gaps:**
   - Type signatures for hover docs (`procedure Foo (X : Integer) return Boolean`)
   - Documentation comments
   - `is_implementation` relationships for tagged type dispatching
   - Symbol kinds at finer granularity than ALI provides

### Data flow

```
┌─────────────┐     ┌──────────────┐     ┌─────────────┐
│  gprbuild    │────▷│  .ali files   │────▷│  ALI Parser  │
│  (compile)   │     │  (xref data)  │     │              │
└─────────────┘     └──────────────┘     └──────┬──────┘
                                                 │
                    ┌──────────────┐              │
                    │  libadalang   │─────────────┤
                    │  (types+docs) │     ┌───────▼───────┐
                    └──────────────┘     │  SCIP Emitter  │
                                         │  (protobuf)    │
                                         └───────────────┘
```

### Phase 1: ALI-only MVP

A standalone tool that:
1. Accepts a GPR project file or a directory of `.ali` files
2. Parses all `.ali` files — extracts cross-reference sections
3. Maps ALI entity kinds to SCIP `SymbolInformation.Kind`
4. Constructs SCIP symbol strings from Ada qualified names
5. Emits SCIP protobuf to `index.scip`

This alone provides "go to definition" and "find references."

### Phase 2: Libadalang enrichment

Add an optional libadalang pass that:
1. Parses source files to extract type signatures
2. Extracts leading comments as documentation
3. Computes tagged-type dispatch relationships
4. Provides finer `SymbolInformation.Kind` values

### Phase 3: SPARK annotations

Optional handling of SPARK-specific constructs:
- `Pre`/`Post` contracts as documentation
- `Ghost` entities flagged appropriately
- `Depends`/`Global` contracts encoded as additional docs

## 6. Ada-to-SCIP Mapping

### Entity Kind Mapping

| Ada Construct | ALI Kind | SCIP Kind |
|--------------|----------|-----------|
| Package spec | `K` | `Package` (35) |
| Package body | `K` (body) | `Package` (35) |
| Procedure | `U`/`V` | `Function` (17) |
| Function | `U`/`V` | `Function` (17) |
| Entry | `Y` | `Method` (26) |
| Record type | `R` | `Struct` (49) |
| Tagged type | `R` (tagged) | `Class` (7) |
| Interface type | — | `Interface` (21) |
| Enumeration type | `E` | `Enum` (11) |
| Enum literal | `n` | `EnumMember` (12) |
| Variable/Object | `v` | `Variable` (61) |
| Constant | `v` (const) | `Constant` (8) |
| Named number | `N` | `Constant` (8) |
| Generic formal type | `+` | `TypeParameter` (58) |
| Exception | `X` | `Event` (13) |
| Task type | `T` | `Class` (7) |
| Protected type | `P` | `Class` (7) |
| Subtype | — | `Type` (54) |
| Access type | — | `Type` (54) |

### Symbol String Construction

Ada's hierarchical namespace maps naturally to SCIP descriptors:

```
-- Ada: My_App.Utils.Math.Add (a function)
-- SCIP: scip-ada . my_app . My_App/Utils/Math/Add().

-- Ada: Sensors.Temperature_Sensor (a tagged type)
-- SCIP: scip-ada . sensors . Sensors/Temperature_Sensor#

-- Ada: Sensors.Temperature_Sensor.Read (a method)
-- SCIP: scip-ada . sensors . Sensors/Temperature_Sensor#Read().

-- Ada: Ada.Text_IO.Put_Line (standard library)
-- SCIP: scip-ada gnat ada_runtime . Ada/Text_IO/Put_Line().
```

Child packages use nested namespace descriptors:
```
-- Ada: Parent.Child.Grandchild.Proc
-- SCIP: scip-ada . project . Parent/Child/Grandchild/Proc().
```

Generic instantiations are disambiguated:
```
-- Ada: My_Lists is new Ada.Containers.Doubly_Linked_Lists (Integer)
-- SCIP: scip-ada . project . My_Package/My_Lists.
-- with relationship: is_reference to the generic template
```

### Reference Role Mapping

| ALI Ref Type | SCIP SymbolRole |
|-------------|----------------|
| `r` (reference) | `ReadAccess` (8) |
| `m` (modification) | `WriteAccess` (4) |
| `s` (subprogram call) | `ReadAccess` (8) |
| `b` (body) | `Definition` (1) |
| `c` (completion) | `Definition` (1) |
| `i` (instantiation) | `ReadAccess` (8) |
| `w` (with) | `Import` (2) |

## 7. Implementation Language

### Option A: Rust

**Recommended for distribution.**

- Single statically-linked binary, like other SCIP indexers
- `prost` crate for SCIP protobuf emission
- No runtime dependencies (important — Ada devs may not have Python/Node)
- Fast `.ali` file parsing

Would shell out to `gprbuild` for compilation, then parse `.ali` files directly.

### Option B: Python

**Best for prototyping.**

- Libadalang has first-class Python bindings
- `protobuf` package for SCIP emission
- Fastest time-to-working-prototype
- Distribute via `pip`

### Option C: Ada

- Use libadalang directly (it's an Ada library)
- Native performance
- Philosophically consistent
- Harder to distribute (GNAT needed to build)

### Recommendation

**Start in Python** for rapid prototyping with libadalang. **Port to Rust** for the production binary once the mapping is verified.

## 8. Milestones

| Milestone | Scope | Effort |
|-----------|-------|--------|
| **M1: ALI parser** | Parse `.ali` cross-reference sections, emit raw data | 1 week |
| **M2: SCIP emitter** | Map ALI data to SCIP protobuf, produce valid `index.scip` | 1 week |
| **M3: End-to-end** | `gprbuild` → `.ali` → SCIP pipeline, test on real Ada projects | 1 week |
| **M4: Libadalang enrichment** | Type signatures, docs, relationships | 2 weeks |
| **M5: SPARK support** | Contracts as docs, Ghost handling | 1 week |
| **M6: Rust port** | Rewrite core in Rust for single-binary distribution | 2-3 weeks |

## 9. SPARK-Specific Considerations

SPARK is a subset of Ada with formal verification annotations. For SCIP:

- **Code cross-references** come for free (SPARK is valid Ada)
- **Proof aspects** (`Pre`, `Post`, `Contract_Cases`) → encode as `SymbolInformation.documentation`
- **`Ghost` entities** → could use `SymbolRole.Generated` flag
- **`Depends`/`Global` contracts** → additional documentation, not SCIP relationships

For v1, treat SPARK as Ada. Annotations appear in source and are parseable but don't need special SCIP semantics.

## 10. SCIP Indexer Speed Comparison

For context on expected performance:

| Indexer | Backend | Speed (relative) |
|---------|---------|-------------------|
| scip-go | Custom (standalone) | Very fast — Go's simple type system |
| scip-typescript | Wraps `tsc` | Fast — incremental |
| scip-java | Wraps `javac` (SemanticDB) | Fast — piggybacks on build |
| scip-python | Custom (Pyright/tree-sitter) | Fast |
| scip-dotnet | Wraps Roslyn | Medium |
| scip-rust | Wraps rust-analyzer | Slow — full type inference + trait solving |
| scip-clang | Wraps clang | Slow — C++ is C++ |
| **scip-ada (projected)** | `.ali` files (pre-computed) | **Fast** — reading pre-computed data, no analysis |

The `.ali`-based approach should be among the fastest SCIP indexers because it reads pre-computed compiler output rather than performing its own analysis.

## 11. Lore Integration

Adding scip-ada to Lore requires three small changes:

### Registry entry (`src/scip/registry.ts`)
```typescript
ada: {
  command: 'scip-ada',
  args: ['index', '--project', '{project}', '--output', '{output}'],
}
```

### Install spec (`src/scip/installer.ts`)
```typescript
{
  command: 'scip-ada',
  languages: ['ada'],
  method: 'github-binary',
  repo: 'user/scip-ada',
  assetName: (tag) => `scip-ada-${tag}-${os}-${cpu}`,
}
```

### Build file indicators (`src/indexer/stages/scip-indexer.ts`)
```typescript
ada: ['*.gpr', 'alire.toml'],
```
