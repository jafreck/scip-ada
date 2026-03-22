# Lore Integration Plan

## Required Changes in Lore

Adding scip-ada to Lore requires three changes:

### 1. SCIP Indexer Registry (`src/scip/registry.ts`)

```typescript
ada: {
  command: 'scip-ada',
  args: ['index', '--project', '{project}', '--output', '{output}'],
}
```

### 2. Install Specification (`src/scip/installer.ts`)

```typescript
{
  command: 'scip-ada',
  languages: ['ada'],
  method: 'github-binary',
  repo: 'owner/scip-ada',
  assetName: (tag: string) => {
    const { os, cpu } = platform();
    const osStr = os === 'darwin' ? 'macos' : os;
    const cpuStr = cpu === 'x64' ? 'x86_64' : cpu;
    return `scip-ada-${tag}-${osStr}-${cpuStr}`;
  },
}
```

### 3. Build File Indicators (`src/indexer/stages/scip-indexer.ts`)

```typescript
ada: ['*.gpr', 'alire.toml'],
```

## Existing Lore Ada Support

Lore already has partial Ada support via tree-sitter fallback:

- File detection: `.ads`, `.adb` → `ada` (in `discovery/walker.ts`)
- Tree-sitter parser: `tree-sitter-ada` is available but may not be wired up
- LSP registry: not configured for Ada

With scip-ada, Lore would get **full semantic indexing** for Ada — resolved
symbols, call graphs, type relationships — upgrading from heuristic
tree-sitter extraction to compiler-verified precision.
