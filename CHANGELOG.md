# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.1.0] - 2026-03-23

### Added

- **ALI parser** — reads GNAT `.ali` cross-reference data, handling all 30+ entity kind characters and 15+ reference kind characters from `lib-writ.ads`
- **SCIP protobuf emitter** — hand-written minimal protobuf encoder (varint + length-delimited wire types), no external protobuf dependency
- **SCIP symbol strings** — fully qualified symbol string construction with package/type/method/parameter descriptors, overload disambiguation, and child package chains
- **ALI→SCIP kind mapping** — maps all ALI entity kinds to SCIP `SymbolInformation.Kind` and reference kinds to SCIP `SymbolRole` bitsets
- **GPR project discovery** — lightweight GPR file parser to locate source directories and object directories for `.ali` file collection
- **Directory mode** — `--ali-dir` flag for projects without a `.gpr` file; recursively scans for `.ali` files
- **Libadalang enrichment** — optional pass adding type signatures, documentation comments, tagged-type dispatch relationships (`is_type_definition`, `is_implementation`), and fine-grained symbol kinds (`Interface`, abstract display names)
- **Ada 2022 support** — all Ada 2022 constructs recognized by GNAT are handled (declare expressions, delta aggregates, iterated component associations, user-defined literals, parallel blocks, `'Reduce`)
- **CLI** — `scip-ada index` and `scip-ada version` commands with `--project`, `--ali-dir`, `--output`, `--verbose`, `--quiet`, `--exclude`, `--enrich`, `--no-enrich` flags
- **Multi-platform builds** — CI on Linux x86_64, macOS arm64, macOS x86_64, Windows x86_64
- **Static binary distribution** — release workflow producing single-binary artifacts for all supported platforms
- **Conditional compilation** — `ENRICH` scenario variable selects libadalang (`yes`) or stub (`no`) implementation at build time
