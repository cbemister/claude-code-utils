# Stage Library: CLI Tool (Node.js / Rust / Go)

> **Reference material for the project-planner agent.**
> Use this file when generating stage plans for command-line tools and developer utilities.
> Covers CLI tools built with Node.js (Commander.js, Ink, oclif), Rust (clap, ratatui),
> or Go (cobra, bubbletea). Includes both simple single-purpose scripts and multi-command
> developer tools with config files.

---

## Archetype Overview

CLI tools expose functionality through a terminal interface. They accept structured
arguments and flags, read from stdin or files, write to stdout/stderr, and exit with
meaningful exit codes. Complex tools have a command hierarchy (e.g., `tool auth login`,
`tool db migrate`). Distribution is via npm, cargo, homebrew, or a GitHub Releases
binary. Configuration is stored in a local config file or environment variables.

Key characteristics:
- Binary entry point with a clear command structure
- Argument parsing library handles flags, positional args, and help text
- Output to stdout (data), stderr (logs/errors), with color when TTY is detected
- Non-zero exit codes on failure (consumers depend on this for scripting)
- Config file in `~/.config/<tool>/config.json` or `~/.toolrc`
- Update checker notifying users when a newer version is available
- Packaged and distributed via a package registry or binary release

---

## Typical Stage Progression

### Stage 1 — Foundation

**Goal:** Binary entry point compiles and runs; "hello world" command works; CI configured.

**Key Deliverables:**
- Project initialized with argument parsing library (Commander, clap, cobra)
- Binary entry point defined in package.json / Cargo.toml / go.mod
- `--version` flag returns current version
- `--help` flag generates usage text automatically
- TypeScript strict mode / Rust / Go static typing configured
- Linting and formatting configured
- CI pipeline running build and lint on every push

**Typical Tasks:**
- Initialize project with package manager
- Install argument parsing library
- Create binary entry point with version and help flags
- Configure TypeScript strict mode or language-specific typing
- Add linting and formatting tools
- Set up GitHub Actions CI workflow
- Write README with quick start section

**Recommended Agents:**
| Role | Agent | Responsibility |
|------|-------|----------------|
| Lead | `feature-builder` | Project scaffold, argument parser setup |
| Review | `codebase-explorer` | Verifies conventions match target language idioms |

---

### Stage 2 — Argument Parsing

**Goal:** Complete command hierarchy defined; all flags, options, and positional args parsed correctly.

**Key Deliverables:**
- All commands and subcommands defined (even if not yet implemented)
- Every command has: description, usage example, required args, optional flags
- Help text generated automatically from definitions
- Invalid command or missing required arg exits with code `1` and helpful message
- Argument types validated (numbers parsed, file paths checked for existence)
- Shell completion scripts generated (bash, zsh, fish) if applicable

**Typical Tasks:**
- Define top-level command structure
- Define all subcommands with descriptions
- Add required and optional flags to each command
- Add positional argument definitions
- Wire up type coercion (string → number, string → enum)
- Add validation for required arguments
- Add shell completion generation (if the framework supports it)
- Test help text output for every command

**Recommended Agents:**
| Role | Agent | Responsibility |
|------|-------|----------------|
| Lead | `feature-builder` | Command definitions and argument parsing |
| Review | `codebase-explorer` | Checks UX of help text and flag naming conventions |

---

### Stage 3 — Core Commands

**Goal:** Every command executes its intended action end-to-end with real logic.

**Key Deliverables:**
- Each command implemented with full business logic
- Commands read input from the correct sources (args, stdin, files, environment)
- Commands write results to stdout in correct format
- Progress indicators for long-running operations
- Commands are idempotent where applicable (running twice is safe)
- Exit codes consistent: `0` success, `1` general error, `2` misuse

**Typical Tasks:**
- Implement each command's core logic
- Add stdin pipe detection (`process.stdin.isTTY` or equivalent)
- Add file input/output handling
- Add progress indicator for operations > 1 second (spinner or progress bar)
- Verify exit codes are correct for all outcomes
- Add `--dry-run` flag to destructive commands

**Recommended Agents:**
| Role | Agent | Responsibility |
|------|-------|----------------|
| Lead | `feature-builder` | Command implementation |
| Support | `api-developer` | API or database integrations used by commands |

---

### Stage 4 — Output Formatting

**Goal:** Output is human-readable by default and machine-parseable on request; colors respect TTY and NO_COLOR.

**Key Deliverables:**
- Default output is formatted for human reading (tables, aligned columns)
- `--json` flag outputs raw JSON for scripting
- `--quiet` flag suppresses everything except errors
- Colors enabled only when stdout is a TTY and `NO_COLOR` is not set
- Error messages go to stderr; data output goes to stdout
- Consistent output structure: headers, dividers, data rows, summary line

**Typical Tasks:**
- Install output library (chalk + cli-table3, or colored + prettytable)
- Create output helper functions (table, list, key-value, success/error)
- Implement TTY detection for color enablement
- Respect `NO_COLOR` and `FORCE_COLOR` environment variables
- Add `--json` flag to commands returning structured data
- Add `--quiet` flag suppressing progress output
- Audit that all data goes to stdout and all logs go to stderr

**Recommended Agents:**
| Role | Agent | Responsibility |
|------|-------|----------------|
| Lead | `component-builder` | Output formatting utilities |
| Review | `feature-builder` | Checks stdout/stderr split and flag consistency |

---

### Stage 5 — Config Management

**Goal:** Tool reads from and writes to a persistent config file; config is mergeable with flags.

**Key Deliverables:**
- Config file location follows OS conventions (`~/.config/<tool>/config.json`)
- `<tool> config set <key> <value>` and `<tool> config get <key>` commands
- `<tool> config list` shows current config
- Config values can be overridden by environment variables
- Environment variables override config file; CLI flags override everything
- Config schema validated on read with helpful error for malformed config

**Typical Tasks:**
- Define config schema (keys, types, defaults)
- Create config read/write utility
- Implement `config set`, `config get`, `config list` commands
- Add environment variable override layer
- Add CLI flag override layer (flag > env > config > default)
- Validate config on startup and report malformed values
- Add `config reset` command for fresh start

**Recommended Agents:**
| Role | Agent | Responsibility |
|------|-------|----------------|
| Lead | `feature-builder` | Config file management and precedence logic |
| Review | `architecture-planner` | Reviews precedence chain and schema design |

---

### Stage 6 — Error Handling

**Goal:** All errors are caught, contextualized, and reported with actionable messages.

**Key Deliverables:**
- Every thrown error caught at command boundary — no raw stack traces to users
- Error messages include: what failed, why, and what to do next
- Debug mode (`--debug` or `DEBUG=tool:*`) shows full stack traces
- Network errors include retry guidance
- File-not-found errors show the path that was missing
- All commands exit with non-zero code on any failure

**Typical Tasks:**
- Add top-level try/catch (or `recover` in Go) in each command handler
- Create error formatter that strips stack traces in non-debug mode
- Create typed error classes (NetworkError, ConfigError, AuthError)
- Add `--debug` flag enabling verbose error output
- Add `DEBUG` environment variable for trace-level logging
- Test every error path exits with non-zero code
- Add `--no-color` / `NO_COLOR` respect to error output

**Recommended Agents:**
| Role | Agent | Responsibility |
|------|-------|----------------|
| Lead | `feature-builder` | Error handling architecture |
| Review | `codebase-explorer` | Audits all command paths for uncaught errors |

---

### Stage 7 — Testing

**Goal:** Test suite covers all commands; CI enforces coverage.

**Key Deliverables:**
- Unit tests for parsing and business logic functions
- Integration tests running the CLI binary with real subprocess calls
- All commands tested: happy path, missing args, invalid input, error cases
- Tests stub external API calls and file system where needed
- Coverage report showing ≥ 80% line coverage
- Tests pass in CI without a network connection

**Typical Tasks:**
- Configure test runner (Vitest, Jest, `cargo test`, `go test`)
- Write unit tests for utility and business logic functions
- Write integration tests invoking binary as a subprocess
- Mock external HTTP calls (MSW or equivalent)
- Mock file system operations in unit tests
- Add coverage reporting to CI
- Enforce coverage threshold in CI

**Recommended Agents:**
| Role | Agent | Responsibility |
|------|-------|----------------|
| Lead | `test-writer` | All test files |
| Support | `feature-builder` | Subprocess test harness setup |

---

### Stage 8 — Packaging and Distribution

**Goal:** Tool installable via standard package manager; binaries published to GitHub Releases.

**Key Deliverables:**
- `package.json` / `Cargo.toml` / `go.mod` production-ready (name, version, description, license)
- Binary installable in one command (`npm install -g`, `cargo install`, `brew install`)
- Cross-platform binaries built for Linux, macOS (x86_64 + arm64), Windows
- GitHub Release created automatically by CI on version tag
- Homebrew formula or npm publish workflow configured
- Install instructions in README
- CHANGELOG.md with version history

**Typical Tasks:**
- Finalize package metadata (name, description, keywords, license, author)
- Configure binary entry point (`bin` in package.json, `[[bin]]` in Cargo.toml)
- Write GitHub Actions release workflow triggered by git tag
- Add cross-compilation targets (GoReleaser, `cross` for Rust, `pkg` for Node)
- Publish to npm / crates.io / configure Homebrew tap
- Write install instructions for each distribution method
- Create CHANGELOG.md
- Tag and publish v1.0.0

**Recommended Agents:**
| Role | Agent | Responsibility |
|------|-------|----------------|
| Lead | `feature-builder` | Build and release pipeline |
| Review | `codebase-explorer` | Verifies no dev-only code or test credentials in release build |

---

## Common Parallelization Patterns

```
Stage 1 (Foundation) — must complete first
        ↓
Stage 2 (Argument Parsing) — defines the command surface
        ↓
Stage 3 (Core Commands) ──────────────────────────────────┐
Stage 4 (Output Formatting) ──────────────────────────────┤── can run in parallel
Stage 5 (Config Management) ──────────────────────────────┘
        ↓
        all three required before:
        ↓
Stage 6 (Error Handling) — wraps completed commands
Stage 7 (Testing) — can begin on completed commands
        ↓
Stage 8 (Packaging) — requires everything to be stable
```

Within Stage 3, individual commands can be implemented in parallel if they don't
share significant internal utilities (implement shared utils first, then parallelize).

---

## Technology-Specific Verification Commands

```bash
# Node.js / TypeScript CLI

# Typecheck
npx tsc --noEmit

# Lint
npx eslint src/ --ext .ts

# Run tests
npx vitest run
# or
npx jest

# Run CLI locally (without installing)
node dist/index.js --help
# or via ts-node
npx ts-node src/index.ts --help

# Build
npm run build

# Link locally for testing (installs binary on PATH)
npm link

# Pack and inspect tarball
npm pack && tar -tzf *.tgz

# ---

# Rust

# Build (debug)
cargo build

# Build (release)
cargo build --release

# Run tests
cargo test

# Lint
cargo clippy -- -D warnings

# Format check
cargo fmt --check

# Run locally
cargo run -- --help

# Cross-compile (using cross)
cross build --target x86_64-unknown-linux-gnu --release

# ---

# Go

# Build
go build -o dist/tool ./cmd/tool

# Run tests
go test ./... -cover

# Lint
golangci-lint run

# Format check
gofmt -l .

# Run locally
go run ./cmd/tool --help

# Cross-compile
GOOS=linux GOARCH=amd64 go build -o dist/tool-linux-amd64 ./cmd/tool
GOOS=darwin GOARCH=arm64 go build -o dist/tool-darwin-arm64 ./cmd/tool
GOOS=windows GOARCH=amd64 go build -o dist/tool-windows-amd64.exe ./cmd/tool

# GoReleaser dry run
goreleaser release --snapshot --clean
```

---

## Common Stage Dependencies

| Stage | Hard Requires | Can Parallelize With |
|-------|---------------|----------------------|
| Foundation | nothing | — |
| Argument Parsing | Foundation | — |
| Core Commands | Argument Parsing | Output Formatting, Config |
| Output Formatting | Foundation | Core Commands, Config |
| Config Management | Argument Parsing | Core Commands, Output Formatting |
| Error Handling | Core Commands | Testing (partially) |
| Testing | Core Commands, Error Handling | — |
| Packaging | Testing | — |

**CLI UX conventions to enforce throughout:**
- All flags have both short (`-v`) and long (`--verbose`) forms where appropriate
- Destructive commands require `--force` or interactive confirmation
- Long-running operations show a progress indicator; they never appear frozen
- `--help` available on every command and subcommand
- Exit code `0` only on true success; everything else is non-zero
- Output intended for piping goes to stdout; human messages go to stderr
