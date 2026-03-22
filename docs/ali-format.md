# ALI Cross-Reference Format Reference

This document describes the cross-reference format in GNAT `.ali` files,
based on the spec in `lib-writ.ads` (GNAT compiler sources).

## File Structure

An `.ali` file is a text file with sections identified by a leading letter:

- `V` — Version information
- `M` — Main program information
- `A` — Args used in compilation
- `P` — Unit attributes
- `R` — Restrictions
- `I` — Interrupt state
- `U` — Unit information
- `W` — With (dependency) information
- `L` — Linker options
- `D` — Dependency information
- `X` — Cross-reference information ← **this is what we need**

## Cross-Reference Section (`X` lines)

### File header

```
X file_number file_name
```

Example: `X 1 hello.ads`

### Entity lines

Each entity line starts at column 1 with the format:

```
line type col level name [renaming] {references}
```

Where:
- `line` — line number of the defining occurrence
- `type` — single character entity type (see below)
- `col` — column number of the defining occurrence
- `level` — `*` for library-level, blank for nested
- `name` — entity name

### Entity Type Characters

| Char | Meaning |
|------|---------|
| `A` | Array type |
| `B` | Record (non-tagged) type body |
| `b` | Label |
| `C` | Component (record field) |
| `D` | Decimal fixed-point type |
| `E` | Enumeration type |
| `e` | Exception |
| `F` | Floating-point type |
| `G` | Generic package |
| `H` | Abstract type (tagged) |
| `I` | Integer type |
| `K` | Package |
| `k` | Generic package instantiation |
| `L` | Loop label |
| `M` | Modular type |
| `N` | Named number |
| `n` | Enumeration literal |
| `O` | Ordinary fixed-point type |
| `P` | Protected type |
| `p` | Protected type body |
| `R` | Record (tagged) type |
| `r` | Record (non-tagged) type |
| `S` | Subtype |
| `T` | Task type |
| `t` | Task body |
| `U` | Procedure (subprogram unit) |
| `u` | Generic procedure |
| `V` | Function (subprogram unit) |
| `v` | Generic function |
| `W` | Formal procedure (generic) |
| `X` | Formal function (generic) |
| `Y` | Entry |
| `y` | Entry family |
| `+` | Generic formal type parameter |

### Reference Characters

References follow the entity's defining occurrence on the same line:

```
file_number|line type col
```

Or within the same file:
```
line type col
```

| Char | Meaning |
|------|---------|
| `b` | Body |
| `c` | Completion of private or incomplete type |
| `d` | Discriminant |
| `e` | End of spec |
| `H` | Abstract occurrence of a type |
| `i` | Implicit reference (elaboration, etc.) |
| `l` | Label on END line |
| `m` | Modification (assignment target) |
| `o` | Own reference (in generic instantiation) |
| `p` | Primitive operation of a tagged type |
| `r` | Reference |
| `R` | Dispatching call |
| `s` | Static subprogram call |
| `t` | End of body |
| `w` | WITH line |
| `x` | Type extension |
| `z` | Formal generic parameter |

### Example

```
X 1 my_package.ads
1K9*My_Package 6e9 1|1b11
3R9*My_Type 5c9
4V14*Get_Value{1R9} 1|4b14
X 2 my_package.adb
1K11*My_Package 8t11
4V14*Get_Value 6r18
```

This encodes:
- `My_Package` (package) defined at 1:9, end-of-spec at 6:9, body in file 2 at 1:11
- `My_Type` (tagged record) defined at 3:9, completion at 5:9
- `Get_Value` (function) returning `My_Type`, defined at 4:14, body in file 2 at 4:14
- In the body: `Get_Value` is referenced at 6:18

## SCIP Mapping Strategy

1. Parse all `X` sections to build a global entity → references map
2. For each entity, construct an SCIP symbol string from its package/unit hierarchy
3. For each file, emit an SCIP `Document` with `Occurrence` entries for all references
4. Entity-defining occurrences get `symbolRoles = Definition`
5. Other references get appropriate roles based on the ALI reference character
