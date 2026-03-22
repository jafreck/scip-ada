# Comparison of SCIP Indexer Approaches

## Speed Characteristics

Language servers (LSP) are designed for **interactive use** — low-latency
responses to single-file edits. SCIP indexers need **batch throughput** —
process every symbol in every file as fast as possible.

### Why wrapping a language server is slower

1. **LSP builds in-memory state** for interactive features (completions,
   diagnostics, hover) — SCIP only needs occurrence-level symbol resolution.

2. **LSP is designed for incremental updates** to single files, not batch
   indexing — the architecture is optimized for latency, not throughput.

3. **Protocol overhead** — JSON-RPC serialization/deserialization for every
   query adds up when processing thousands of files.

4. **Feature bloat** — the language server computes features (inlay hints,
   code lenses, semantic tokens) that SCIP doesn't need.

### Why `.ali` files are fast

GNAT `.ali` files contain **pre-computed** cross-reference data. The compiler
has already done the hard work of:

- Resolving all names to their definitions
- Computing overload resolution
- Handling generic instantiations
- Resolving tagged type dispatching

Reading this data is a **text parsing** problem, not a **semantic analysis**
problem. The expected performance is comparable to `scip-go` (which also
reads pre-computed data from Go's type checker).

### Comparison Table

| Indexer | Approach | Speed | Why |
|---------|----------|-------|-----|
| scip-go | Custom, direct `go/types` API | Very fast | Simple types, pre-computed |
| scip-typescript | Wraps `tsc` | Fast | Incremental, well-optimized |
| scip-java | Compiler plugin (SemanticDB) | Fast | Piggybacks on build |
| scip-python | Custom (Pyright + tree-sitter) | Fast | Standalone |
| scip-dotnet | Wraps Roslyn | Medium | Full analysis |
| scip-rust | Wraps rust-analyzer | Slow | Full type inference + traits |
| scip-clang | Wraps clang | Slow | C++ complexity |
| **scip-ada** (projected) | `.ali` files | **Fast** | Pre-computed data |

### Benefit of building from scratch vs. using ALS

Building a dedicated SCIP indexer from `.ali` files is expected to be:
- **2-10× faster** than wrapping ALS via LSP
- **Much lower memory** — `.ali` parsing is streaming, not in-memory
- **No runtime dependency** on ALS — just needs GNAT (already required to compile Ada)
- **More complete** — `.ali` files contain data that ALS may not expose via LSP
