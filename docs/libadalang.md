# Libadalang Integration Notes

## Overview

[Libadalang](https://github.com/AdaCore/libadalang) is AdaCore's library for
parsing and semantic analysis of Ada code. Licensed under **Apache 2.0 + LLVM
Exception** — the most permissive license in the Ada tooling ecosystem.

## Key APIs for SCIP

### Name Resolution
```python
import libadalang as lal

ctx = lal.AnalysisContext()
unit = ctx.get_from_file("hello.adb")

for name in unit.root.findall(lal.Name):
    decl = name.p_referenced_decl()
    if decl:
        print(f"{name.text} -> {decl.p_defining_name().text}")
```

### Type Information
```python
for expr in unit.root.findall(lal.Expr):
    typ = expr.p_expression_type()
    if typ:
        print(f"{expr.text} : {typ.p_defining_name().text}")
```

### Subprogram Signatures
```python
for subp in unit.root.findall(lal.SubpDecl):
    spec = subp.f_subp_spec
    params = spec.f_subp_params
    ret = spec.f_subp_returns
    # Build signature string from these
```

### Tagged Type Hierarchies
```python
for typ in unit.root.findall(lal.TypeDecl):
    if typ.p_is_tagged_type():
        # Find parent type
        parent = typ.p_base_type()
        # Find all primitive operations
        prims = typ.p_get_primitives()
```

## Use in scip-ada

Libadalang is used for **enrichment only** — data that `.ali` files don't provide:

1. **Type signatures** — for `SymbolInformation.signature_documentation`
2. **Documentation comments** — leading comments before declarations
3. **Implementation relationships** — `p_base_type()` for tagged type hierarchies
4. **Fine-grained Kind** — distinguish `Struct` vs `Class` (tagged), `Interface`, etc.

## Installation

### Via Alire (recommended)
```sh
alr get libadalang
alr build
```

### Via pip (Python bindings)
```sh
pip install libadalang
```

### From source
See https://github.com/AdaCore/libadalang/blob/master/user_manual/building.rst

## Memory Characteristics

- ~300MB per 100k lines of Ada code
- 450MB baseline for the runtime
- Generics and tagged types increase usage
- Aggregate projects may multiply usage

## Limitations

- Name resolution is not 100% complete for all Ada constructs
- Some complex generics may not resolve
- Ada 2022 support is in progress (not yet complete)
- Requires Ada project configuration (`.gpr` file) for full resolution
