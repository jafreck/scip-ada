# scip-ada

An SCIP indexer for Ada/SPARK, producing [SCIP](https://github.com/sourcegraph/scip) indices from Ada source code.

## Status

**Pre-development** — this repository contains the design analysis and architecture for building an SCIP indexer for the Ada programming language. No code has been written yet.

## Why

No SCIP indexer exists for Ada or SPARK. The [Sourcegraph SCIP ecosystem](https://github.com/sourcegraph/scip) covers ~14 languages but Ada is not among them, despite `Ada = 39` being defined in the SCIP `Language` enum. This project would enable Ada codebases to be indexed by any SCIP-consuming tool, including [Lore](https://github.com/AdalineAi/Lore).

## Architecture

See [docs/design.md](docs/design.md) for the full design analysis.

### Summary

The recommended approach is a **hybrid** architecture:

1. **Primary: GNAT `.ali` file reader** — `.ali` files are produced as a side effect of every GNAT compilation and contain compiler-verified cross-reference data (every entity definition and reference, with file/line/column positions). This is free, accurate, and fast.

2. **Enrichment: libadalang** — fills gaps that `.ali` files don't cover: type signatures for hover docs, documentation comments, `is_implementation` relationships for tagged type dispatching, and finer-grained `SymbolInformation.Kind` values.

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

## Open Source Ecosystem

| Tool | License | Role |
|------|---------|------|
| GNAT (GCC) | GPL-3 + Runtime Exception | Ada compiler, produces `.ali` files |
| Libadalang | Apache 2.0 + LLVM Exception | Parsing + name resolution library |
| Ada Language Server | GPL-3 | LSP server (not used directly) |
| GPRbuild | GPL-3 + Runtime Exception | Ada build system |

## License

TBD
