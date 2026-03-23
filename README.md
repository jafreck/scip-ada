<div align="center">
   <h1>scip-ada</h1>
   <p><strong>An SCIP indexer for Ada and SPARK</strong></p>
   <p>
      <img alt="Ada 2022" src="https://img.shields.io/badge/Ada-2022-0F766E?style=for-the-badge">
      <img alt="SPARK supported" src="https://img.shields.io/badge/SPARK-supported-4338CA?style=for-the-badge">
      <img alt="SCIP by Sourcegraph" src="https://img.shields.io/badge/SCIP-Sourcegraph-F96316?style=for-the-badge&logo=sourcegraph&logoColor=white">
   </p>
   <p>
      <a href="https://github.com/jafreck/scip-ada/actions/workflows/ci.yml"><img alt="CI" src="https://github.com/jafreck/scip-ada/actions/workflows/ci.yml/badge.svg"></a>
      <a href="LICENSE"><img alt="License" src="https://img.shields.io/badge/license-Apache--2.0-blue.svg"></a>
      <a href="https://alire.ada.dev/crates/scip_ada"><img alt="Alire" src="https://img.shields.io/badge/alire-scip__ada-orange"></a>
   </p>
</div>

An [SCIP](https://github.com/sourcegraph/scip) indexer for Ada and SPARK, producing language-agnostic code intelligence indices from Ada source code.

## Overview

`scip-ada` reads GNAT `.ali` (Ada Library Information) files — produced as a side effect of every GNAT compilation — and emits an `index.scip` file containing cross-reference data for all entities in your Ada project. An optional [libadalang](https://github.com/AdaCore/libadalang) enrichment pass adds type signatures, documentation comments, tagged-type dispatch relationships, and fine-grained symbol kinds.

The resulting `index.scip` can be consumed by any SCIP-compatible tool, including [Sourcegraph](https://sourcegraph.com), [Lore](https://github.com/AdalineAi/Lore), and others.

### Features

- **Zero-cost cross-references** — uses compiler-verified `.ali` data already produced by `gprbuild`
- **Libadalang enrichment** — type signatures, doc comments, tagged-type hierarchy, refined symbol kinds
- **Ada 2022 support** — handles all Ada 2022 constructs that GNAT recognizes
- **Single static binary** — no runtime dependencies, trivial deployment
- **Multi-platform** — Linux x86_64, macOS arm64/x86_64, Windows x86_64

## Installation

### Binary download (recommended)

Download a pre-built binary from the [latest release](https://github.com/jafreck/scip-ada/releases/latest):

| Platform | Binary |
|----------|--------|
| Linux x86_64 | `scip-ada-linux-x86_64` |
| macOS arm64 (Apple Silicon) | `scip-ada-macos-arm64` |
| macOS x86_64 (Intel) | `scip-ada-macos-x86_64` |
| Windows x86_64 | `scip-ada-windows-x86_64.exe` |

#### Linux

```bash
curl -Lo scip-ada https://github.com/jafreck/scip-ada/releases/latest/download/scip-ada-linux-x86_64
chmod +x scip-ada
sudo mv scip-ada /usr/local/bin/
```

#### macOS (Apple Silicon)

```bash
curl -Lo scip-ada https://github.com/jafreck/scip-ada/releases/latest/download/scip-ada-macos-arm64
chmod +x scip-ada
mv scip-ada /usr/local/bin/
```

#### macOS (Intel)

```bash
curl -Lo scip-ada https://github.com/jafreck/scip-ada/releases/latest/download/scip-ada-macos-x86_64
chmod +x scip-ada
mv scip-ada /usr/local/bin/
```

#### Windows

Download `scip-ada-windows-x86_64.exe` from the release page and place it on your `PATH`.

### Build from source with Alire

Requires [Alire](https://alire.ada.dev/) (the Ada package manager) and GNAT.

```bash
git clone https://github.com/jafreck/scip-ada.git
cd scip-ada
alr build --release
# Binary is at bin/scip_ada
```

To build without libadalang enrichment (smaller binary, fewer dependencies):

```bash
alr build --release -- -XENRICH=no
```

## Quick Start

### Prerequisites

Your Ada project must be compilable with GNAT. `scip-ada` reads the `.ali` files that GNAT produces during compilation, so you need to compile your project first.

### Step-by-step example

1. **Compile your Ada project** to generate `.ali` files:

   ```bash
   cd my_ada_project
   gprbuild -P my_project.gpr
   ```

2. **Run `scip-ada`** to produce an SCIP index:

   ```bash
   scip-ada index --project my_project.gpr
   ```

   This writes `index.scip` in the current directory.

3. **Verify the output** (optional, requires the [SCIP CLI](https://github.com/sourcegraph/scip)):

   Install `scip` from the Sourcegraph releases and place it on your `PATH`:

   ```bash
   mkdir -p "$HOME/bin"
   TAG="v0.6.1"
   OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
   ARCH="$(uname -m | sed -e 's/x86_64/amd64/')"
   curl -fsSL "https://github.com/sourcegraph/scip/releases/download/$TAG/scip-$OS-$ARCH.tar.gz" \
     | tar -xzf - -C "$HOME/bin" scip
   chmod +x "$HOME/bin/scip"
   ```

   ```bash
   scip print --json index.scip | head -20
   ```

### Example output

Given a simple Ada project:

```ada
-- hello.ads
package Hello is
   procedure Say_Hello (Name : String);
end Hello;

-- hello.adb
with Ada.Text_IO;
package body Hello is
   procedure Say_Hello (Name : String) is
   begin
      Ada.Text_IO.Put_Line ("Hello, " & Name & "!");
   end Say_Hello;
end Hello;
```

After compiling and running `scip-ada index --project hello.gpr --verbose`, the index will contain:

- **Definitions** for `Hello` (package), `Say_Hello` (procedure), `Name` (parameter)
- **References** to `Ada.Text_IO.Put_Line`, `String`, and other standard library symbols
- **SCIP symbols** like `scip-ada . hello . Hello/Say_Hello().`
- **Occurrences** with precise file, line, and column positions

## CLI Reference

```
scip-ada <command> [OPTIONS]
```

### Commands

| Command | Description |
|---------|-------------|
| `index` | Index an Ada project and produce `index.scip` |
| `version` | Print version information |

### `scip-ada index`

```
scip-ada index [OPTIONS]
```

One of `--project` or `--ali-dir` must be specified.

| Option | Short | Description |
|--------|-------|-------------|
| `--project <file.gpr>` | `-p` | GPR project file to index |
| `--ali-dir <path>` | `-d` | Directory containing `.ali` files (recursive scan) |
| `--output <path>` | `-o` | Output file path (default: `index.scip`) |
| `--verbose` | | Show detailed progress information |
| `--quiet` | `-q` | Suppress all output except errors |
| `--exclude <pattern>` | | Exclude files matching pattern (repeatable) |
| `--enrich` | | Force libadalang enrichment pass (default when libadalang is available) |
| `--no-enrich` | | Skip libadalang enrichment pass |
| `--help` | `-h` | Show help message |

### Examples

```bash
# Index a GPR project
scip-ada index --project my_project.gpr

# Index with custom output path
scip-ada index --project my_project.gpr --output my_index.scip

# Index a directory of .ali files
scip-ada index --ali-dir obj/

# Verbose output, exclude test files
scip-ada index --project my_project.gpr --verbose --exclude tests/

# Index without libadalang enrichment
scip-ada index --project my_project.gpr --no-enrich

# Print version
scip-ada version
```

## Supported Ada Constructs

`scip-ada` produces cross-reference data for all Ada constructs recognized by GNAT. The ALI parser handles all entity kind characters defined in GNAT's `lib-writ.ads`.

### Entity kinds

| Ada Construct | ALI Character | SCIP Kind |
|---------------|---------------|-----------|
| Package | `K` | Namespace |
| Generic package | `G` | Namespace |
| Generic package instantiation | `k` | Namespace |
| Procedure | `U` | Function |
| Function | `V` | Function |
| Generic procedure | `g` | Function |
| Generic function | `h` | Function |
| Procedure instantiation | `u` | Function |
| Function instantiation | `v` | Function |
| Formal procedure | `W` | Function |
| Formal function | `X` | Function |
| Abstract procedure | `x` | Function |
| Abstract function | `z` | Function |
| Tagged record type | `R` | Class |
| Abstract type | `H` | Class |
| Task type | `T` | Class |
| Protected type | `P` (as type) | Class |
| Record type (untagged) | `r` | Struct |
| Enumeration type | `E` | Enum |
| Enumeration literal | `n` | EnumMember |
| Record component / discriminant | `C` | Field |
| Integer type | `I` | Type |
| Float type | `F` | Type |
| Array type | `A` | Type |
| Boolean type | `B` | Type |
| Decimal fixed type | `D` | Type |
| Modular integer type | `M` | Type |
| Ordinary fixed type | `O` | Type |
| Access type | `P` (as access) | Type |
| Subtype | `S` | Type |
| Class-wide type | `c` | Type |
| Class-wide subtype | `J` | Type |
| Named number (constant) | `N` | Constant |
| Exception | `e` | Variable |
| Entry | `Y` | Method |
| Entry body | `y` | Method |
| Generic formal type | `+` | TypeParameter |
| Private generic formal | `*` | TypeParameter |
| Labels | `L`, `b` | Variable |

### Reference kinds

| Reference | ALI Character | SCIP Role |
|-----------|---------------|-----------|
| Read reference | `r` | ReadAccess |
| Modification | `m` | WriteAccess |
| Static call | `s` | ReadAccess |
| Dispatching call | `R` | ReadAccess |
| Implicit reference | `i` | ReadAccess |
| With clause (import) | `w` | Import |
| Definition | (defining `*`) | Definition |
| Body | `b` | Definition |

### Libadalang enrichment (when `--enrich` is active)

- **Type signatures** — subprogram parameter profiles shown in hover documentation
- **Documentation comments** — leading `--` comment blocks extracted and attached to symbols
- **Tagged type relationships** — `is_type_definition` for derived types, `is_implementation` for overriding operations
- **Fine-grained symbol kinds** — `Interface` kind for interface types, `abstract` display name for abstract types

### Ada 2022 constructs

`scip-ada` handles Ada 2022 constructs to the extent that GNAT represents them in `.ali` files. All Ada 2022 entity and reference characters are supported by the ALI parser. Constructs include:

- Declare expressions
- Delta aggregates
- Iterated component associations
- User-defined literals (`Integer_Literal`, `Real_Literal`, `String_Literal` aspects)
- Parallel blocks and loops
- `'Reduce` attribute
- Contract aspects (`Pre`, `Post`, `Contract_Cases`, etc.)

> **Note:** Ada 2022 support depends on compiler maturity. GNAT 15 supports all major Ada 2022 features. The `.ali` cross-reference format is stable across GNAT versions — new constructs reuse existing entity/reference characters, so no parser changes are typically needed.

## Known Limitations

- **Requires successful compilation** — `.ali` files are only produced when the code compiles. If your project doesn't compile, `scip-ada` cannot index it.
- **GNAT-specific** — only works with the GNAT compiler. Other Ada compilers (e.g., ObjectAda, Janus/Ada) are not supported.
- **No incremental indexing** — the entire project is re-indexed on each run. For large projects, this is still fast (`.ali` parsing is text I/O, not semantic analysis).
- **Column precision** — ALI files use byte offsets for columns. For ASCII-only source (typical Ada), this matches character positions exactly. For UTF-8 source, there may be minor column offset discrepancies.
- **Libadalang availability** — the enrichment pass requires libadalang. When building with `-XENRICH=no` or using `--no-enrich`, the index will lack type signatures, doc comments, and tagged-type relationships.
- **Operator symbols** — overloaded operators (e.g., `"+"`, `"*"`) are indexed but their symbol strings may be less readable than named subprograms.
- **Local symbols** — entities with purely local scope use SCIP `local N` symbols, which are file-scoped and cannot be cross-referenced across files.

## Architecture

See [docs/design.md](docs/design.md) for the full design analysis.

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

1. **ALI Parser** — reads `.ali` files produced by GNAT, extracts all entity definitions and cross-references
2. **Libadalang Enricher** (optional) — parses Ada source to add type signatures, doc comments, dispatch relationships, and refined symbol kinds
3. **SCIP Emitter** — maps ALI data to SCIP protobuf messages, constructs SCIP symbol strings, writes `index.scip`

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for development setup, testing, and contribution guidelines.

## License

Licensed under the Apache License, Version 2.0. See [LICENSE](LICENSE) for the full text.
