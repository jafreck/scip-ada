# Contributing to scip-ada

Thank you for your interest in contributing to scip-ada! This guide covers development setup, testing, and contribution workflows.

## Development Setup

### Prerequisites

- **GNAT** — the Ada compiler (GCC-based). Version 14 or later recommended.
- **Alire** — the Ada package manager. Install from [alire.ada.dev](https://alire.ada.dev/).
- **GPRbuild** — the Ada build system (usually installed alongside GNAT).

#### Linux (Debian/Ubuntu)

```bash
# Install GNAT and GPRbuild
sudo apt install gnat gprbuild

# Install Alire
curl -Lo alr https://github.com/alire-project/alire/releases/latest/download/alr-linux-x86_64
chmod +x alr
sudo mv alr /usr/local/bin/
```

#### macOS

```bash
# Install Alire (includes GNAT toolchain management)
brew install alire

# Or download directly:
curl -Lo alr https://github.com/alire-project/alire/releases/latest/download/alr-macos
chmod +x alr
mv alr /usr/local/bin/

# Alire will install the GNAT toolchain on first build
```

#### Windows

1. Download [`alr.exe`](https://github.com/alire-project/alire/releases/latest) and add it to your `PATH`.
2. Run `alr toolchain --select` to install a GNAT toolchain.
3. Use a terminal that supports Unix-style paths (Git Bash, MSYS2, or Windows Terminal with PowerShell).

> **Windows note:** The project builds and tests pass on Windows. Use `.\bin\scip_ada.exe` instead of `./bin/scip_ada`. Test fixtures use forward slashes internally; this is handled automatically.

### Building

```bash
git clone https://github.com/AdalineAi/scip-ada.git
cd scip-ada

# Full build (with libadalang enrichment)
alr build

# Build without libadalang (faster, fewer dependencies)
alr build -- -XENRICH=no

# Release build
alr build --release
```

### Running

```bash
# From the project root
./bin/scip_ada --help
./bin/scip_ada index --project my_project.gpr
./bin/scip_ada version
```

## Testing

### Unit tests

Unit tests use [AUnit](https://github.com/AdaCore/aunit) and cover the ALI parser, SCIP symbol construction, kind mapping, and protobuf encoding.

```bash
# Build and run unit tests
make test
```

Or manually:

```bash
alr build
alr exec -- gprbuild -P tests/scip_ada_tests.gpr
./bin/test_runner
```

### End-to-end tests

E2E tests compile Ada fixture projects, run `scip-ada` on them, and validate the output using the [SCIP CLI](https://github.com/sourcegraph/scip).

```bash
make e2e
```

Prerequisites for E2E tests:
- `scip` CLI installed from the Sourcegraph releases, for example:

    ```bash
    mkdir -p "$HOME/bin"
    TAG="v0.6.1"
    OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
    ARCH="$(uname -m | sed -e 's/x86_64/amd64/')"
    curl -fsSL "https://github.com/sourcegraph/scip/releases/download/$TAG/scip-$OS-$ARCH.tar.gz" \
        | tar -xzf - -C "$HOME/bin" scip
    chmod +x "$HOME/bin/scip"
    ```
- GNAT and GPRbuild available

### Test fixtures

Test fixtures are in `tests/fixtures/`. Each fixture is either:

- A `.ali` file (for parser unit tests)
- A directory containing an Ada project with source files and a `.gpr` file (for E2E tests)

#### Adding a new fixture

1. Create a new directory under `tests/fixtures/`:
   ```
   tests/fixtures/my_feature/
   ├── my_feature.gpr
   └── src/
       └── my_feature.adb
   ```

2. Ensure the project compiles: `cd tests/fixtures/my_feature && gprbuild -P my_feature.gpr`

3. For unit test fixtures, add a `.ali` file directly to `tests/fixtures/` and write corresponding AUnit tests in `tests/src/`.

4. For E2E fixtures, add the fixture to the E2E test script (`tests/e2e_test.sh`).

## Project Structure

```
src/
├── scip_ada.ads                    # Root package (version constant)
├── scip_ada-main.adb               # Entry point
├── scip_ada-cli.ads/.adb           # CLI argument parsing
├── scip_ada-project.ads/.adb       # GPR/directory project discovery
├── scip_ada-ali.ads                # ALI subsystem parent
├── scip_ada-ali-types.ads/.adb     # ALI data model
├── scip_ada-ali-parser.ads/.adb    # ALI file parser
├── scip_ada-scip.ads               # SCIP subsystem parent
├── scip_ada-scip-emitter.ads/.adb  # SCIP index construction
├── scip_ada-scip-symbols.ads/.adb  # SCIP symbol string builder
├── scip_ada-scip-mapping.ads/.adb  # ALI kind → SCIP kind mapping
├── scip_ada-scip-protobuf.ads/.adb # Minimal protobuf encoder
├── scip_ada-lal.ads                # LAL subsystem parent
├── lal/                            # Libadalang enrichment (real)
│   ├── scip_ada-lal-enricher.*     # Enrichment orchestrator
│   ├── scip_ada-lal-signatures.*   # Type signature extraction
│   ├── scip_ada-lal-docs.*         # Documentation comment extraction
│   ├── scip_ada-lal-kinds.*        # Fine-grained symbol kinds
│   └── scip_ada-lal-relationships.* # Tagged type relationships
└── lal_stubs/                      # Stub implementations (ENRICH=no)
```

## Code Style

- Follow standard Ada naming conventions (Mixed_Case for identifiers).
- Keep packages focused — one responsibility per child package.
- The project uses `-gnatwa` (all warnings) and `-gnatyg` (GNAT style checks) by default.
- Run `make format` to auto-format with `gnatpp` (optional).

## Pull Request Guidelines

1. **Fork and branch** — create a feature branch from `main`.
2. **Test** — ensure `make test` passes before submitting.
3. **Describe** — write a clear PR description explaining what and why.
4. **Scope** — keep PRs focused on a single change.

## Reporting Issues

Open an issue on GitHub with:
- Your platform (OS, GNAT version, Alire version)
- The Ada project you're indexing (or a minimal reproducer)
- The exact command you ran
- The error output or unexpected behavior
