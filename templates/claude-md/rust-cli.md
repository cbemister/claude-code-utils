# [Rust CLI Tool Name] - Project Documentation

## Overview
[Brief description of what this CLI tool does and its primary purpose]

## Tech Stack
- **Rust** [edition, e.g., 2021]
- **clap** for CLI argument parsing (derive API)
- **tokio** for async runtime
- **serde / serde_json** for serialization
- **[Config]** - config / figment
- **[HTTP Client]** - reqwest (if needed)
- **[Error Handling]** - anyhow / thiserror
- **[Logging]** - tracing / env_logger
- **[Testing]** - built-in test harness + assert_cmd for CLI tests

## Project Structure

### Single Crate
```
src/
├── main.rs             # Entry point — parse args, call run()
├── lib.rs              # Public library API (optional)
├── cli.rs              # clap structs and CLI definition
├── commands/           # One module per subcommand
│   ├── mod.rs
│   ├── init.rs
│   ├── build.rs
│   └── deploy.rs
├── config/             # Config file loading and types
│   ├── mod.rs
│   └── schema.rs
└── error.rs            # Custom error types

tests/
└── cli.rs              # Integration tests using assert_cmd

Cargo.toml
Cargo.lock
```

### Workspace (Multi-Crate)
```
Cargo.toml              # Workspace manifest

crates/
├── cli/                # Binary crate — argument parsing, UX
│   ├── src/main.rs
│   └── Cargo.toml
├── core/               # Library crate — core business logic
│   ├── src/lib.rs
│   └── Cargo.toml
└── config/             # Library crate — configuration types
    ├── src/lib.rs
    └── Cargo.toml
```

Workspace `Cargo.toml`:
```toml
[workspace]
members = ["crates/cli", "crates/core", "crates/config"]
resolver = "2"

[workspace.dependencies]
anyhow = "1"
serde = { version = "1", features = ["derive"] }
tokio = { version = "1", features = ["full"] }
```

## Cargo.toml
```toml
[package]
name = "[tool-name]"
version = "0.1.0"
edition = "2021"
description = "[Brief description]"

[[bin]]
name = "[tool-name]"
path = "src/main.rs"

[dependencies]
clap = { version = "4", features = ["derive", "env"] }
tokio = { version = "1", features = ["full"] }
serde = { version = "1", features = ["derive"] }
serde_json = "1"
anyhow = "1"
thiserror = "1"
tracing = "0.1"
tracing-subscriber = { version = "0.3", features = ["env-filter"] }

[dev-dependencies]
assert_cmd = "2"
predicates = "3"
tempfile = "3"
```

## Key Patterns

### CLI Definition (clap derive)
```rust
// src/cli.rs
use clap::{Parser, Subcommand};
use std::path::PathBuf;

#[derive(Parser)]
#[command(name = "[tool-name]", version, about)]
pub struct Cli {
    /// Path to config file
    #[arg(short, long, global = true, default_value = "[tool-name].toml")]
    pub config: PathBuf,

    /// Increase verbosity
    #[arg(short, long, global = true, action = clap::ArgAction::Count)]
    pub verbose: u8,

    #[command(subcommand)]
    pub command: Commands,
}

#[derive(Subcommand)]
pub enum Commands {
    /// Initialize a new project
    Init {
        /// Project name
        name: String,
        /// Use a specific template
        #[arg(short, long, default_value = "default")]
        template: String,
    },
    /// Build the project
    Build {
        /// Watch for changes
        #[arg(short, long)]
        watch: bool,
        /// Output directory
        #[arg(short, long, default_value = "dist")]
        output: PathBuf,
    },
}
```

### Entry Point
```rust
// src/main.rs
use anyhow::Result;
use clap::Parser;
use tracing_subscriber::{fmt, EnvFilter};

mod cli;
mod commands;
mod config;
mod error;

#[tokio::main]
async fn main() -> Result<()> {
    let cli = cli::Cli::parse();

    let log_level = match cli.verbose {
        0 => "warn",
        1 => "info",
        2 => "debug",
        _ => "trace",
    };

    tracing_subscriber::fmt()
        .with_env_filter(
            EnvFilter::try_from_default_env()
                .unwrap_or_else(|_| EnvFilter::new(log_level))
        )
        .init();

    let config = config::load(&cli.config)?;

    match cli.command {
        cli::Commands::Init { name, template } => {
            commands::init::run(&name, &template, &config).await?;
        }
        cli::Commands::Build { watch, output } => {
            commands::build::run(watch, &output, &config).await?;
        }
    }

    Ok(())
}
```

### Command Implementation
```rust
// src/commands/init.rs
use anyhow::{Context, Result};
use tracing::{info, debug};
use crate::config::Config;

pub async fn run(name: &str, template: &str, config: &Config) -> Result<()> {
    info!("Initializing project: {name}");
    debug!("Using template: {template}");

    let target_dir = std::path::Path::new(name);
    if target_dir.exists() {
        anyhow::bail!("directory '{name}' already exists");
    }

    tokio::fs::create_dir_all(target_dir)
        .await
        .with_context(|| format!("failed to create directory '{name}'"))?;

    copy_template(template, target_dir).await?;

    println!("Created project '{name}'");
    Ok(())
}

async fn copy_template(template: &str, dest: &std::path::Path) -> Result<()> {
    // Implementation
    Ok(())
}
```

### Custom Error Types (thiserror)
```rust
// src/error.rs
use thiserror::Error;

#[derive(Error, Debug)]
pub enum AppError {
    #[error("config file not found: {path}")]
    ConfigNotFound { path: String },

    #[error("invalid configuration: {0}")]
    InvalidConfig(String),

    #[error("network error: {0}")]
    Network(#[from] reqwest::Error),

    #[error("io error: {0}")]
    Io(#[from] std::io::Error),
}
```

### Configuration
```rust
// src/config/mod.rs
use anyhow::Result;
use serde::{Deserialize, Serialize};
use std::path::Path;

#[derive(Debug, Deserialize, Serialize)]
pub struct Config {
    pub output_dir: String,
    pub templates: TemplatesConfig,
}

#[derive(Debug, Deserialize, Serialize)]
pub struct TemplatesConfig {
    pub directory: String,
    pub default: String,
}

impl Default for Config {
    fn default() -> Self {
        Self {
            output_dir: "dist".to_string(),
            templates: TemplatesConfig {
                directory: "templates".to_string(),
                default: "default".to_string(),
            },
        }
    }
}

pub fn load(path: &Path) -> Result<Config> {
    if !path.exists() {
        return Ok(Config::default());
    }

    let content = std::fs::read_to_string(path)?;
    let config: Config = toml::from_str(&content)?;
    Ok(config)
}
```

## Testing

### Unit Tests
```rust
// src/config/mod.rs
#[cfg(test)]
mod tests {
    use super::*;
    use tempfile::NamedTempFile;
    use std::io::Write;

    #[test]
    fn test_load_default_config_when_missing() {
        let config = load(Path::new("nonexistent.toml")).unwrap();
        assert_eq!(config.output_dir, "dist");
    }

    #[test]
    fn test_load_config_from_file() {
        let mut file = NamedTempFile::new().unwrap();
        writeln!(file, r#"output_dir = "build""#).unwrap();

        let config = load(file.path()).unwrap();
        assert_eq!(config.output_dir, "build");
    }
}
```

### CLI Integration Tests (assert_cmd)
```rust
// tests/cli.rs
use assert_cmd::Command;
use predicates::prelude::*;

#[test]
fn test_help_output() {
    Command::cargo_bin("[tool-name]")
        .unwrap()
        .arg("--help")
        .assert()
        .success()
        .stdout(predicate::str::contains("Usage"));
}

#[test]
fn test_init_creates_directory() {
    let dir = tempfile::tempdir().unwrap();

    Command::cargo_bin("[tool-name]")
        .unwrap()
        .current_dir(dir.path())
        .args(["init", "my-project"])
        .assert()
        .success()
        .stdout(predicate::str::contains("Created project"));

    assert!(dir.path().join("my-project").exists());
}

#[test]
fn test_init_fails_if_directory_exists() {
    let dir = tempfile::tempdir().unwrap();
    std::fs::create_dir(dir.path().join("existing")).unwrap();

    Command::cargo_bin("[tool-name]")
        .unwrap()
        .current_dir(dir.path())
        .args(["init", "existing"])
        .assert()
        .failure()
        .stderr(predicate::str::contains("already exists"));
}
```

## Commands
```bash
cargo run -- --help               # Run with help flag
cargo run -- init my-project      # Run init subcommand
cargo run -- build --watch        # Run build in watch mode

cargo test                        # Run all tests
cargo test -- --nocapture         # Show println output
cargo test config::                # Run tests in config module
cargo nextest run                 # Faster test runner (cargo-nextest)

cargo build --release             # Optimized release binary
cargo build                       # Debug binary (faster compile)

cargo clippy                      # Lint
cargo clippy -- -D warnings       # Treat warnings as errors
cargo fmt                         # Format code
cargo fmt --check                 # Check formatting (CI)

cargo doc --open                  # Build and open docs
cargo audit                       # Check for security advisories
```

## Environment Variables
```bash
RUST_LOG=debug [tool-name] build  # Control log level
RUST_BACKTRACE=1 [tool-name] init # Show backtraces on error
```

## Code Style

### Rust Conventions
- Use `?` for error propagation — avoid `.unwrap()` in library code
- Prefer `anyhow::Result` in binary/command code, `thiserror` in library code
- Keep `main.rs` thin — delegate to `run()` functions in command modules
- Use `tracing::instrument` for span-based diagnostics on async functions

### Async Guidelines
- Add `#[tokio::main]` only in `main.rs`
- Prefer `tokio::fs` and `tokio::io` over blocking equivalents in async contexts
- Use `tokio::task::spawn_blocking` for CPU-bound work

---

## Notes
[Any additional project-specific conventions, third-party integrations, or important information]

## Resources
- [clap Documentation](https://docs.rs/clap)
- [tokio Documentation](https://tokio.rs/)
- [anyhow](https://docs.rs/anyhow) / [thiserror](https://docs.rs/thiserror)
- [assert_cmd](https://docs.rs/assert_cmd)
- [The Rust Book](https://doc.rust-lang.org/book/)
