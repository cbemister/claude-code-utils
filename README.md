# Claude Code Shared Resources

A collection of shareable resources for Claude Code including sub-agents, skills, commands, templates, and best practices.

## Quick Start

### Option 1: Per-Project Installation
Copy the `.claude/` folder into your project:
```bash
git clone https://github.com/yourusername/claude-code-shared.git
cp -r claude-code-shared/.claude/ your-project/.claude/
```

### Option 2: Central Installation
Install to your user-level Claude config:
```bash
# Windows (PowerShell)
.\scripts\install.ps1

# Unix/macOS
./scripts/install.sh
```

## What's Included

### Sub-Agents (`.claude/agents/`)
Specialized AI assistants that handle specific tasks:

| Category | Model | Purpose |
|----------|-------|---------|
| **Explore** | Haiku | Fast, read-only codebase exploration |
| **Plan** | Opus | Complex architecture and feature planning |
| **Implement** | Sonnet | Code implementation and debugging |

### Skills (`.claude/skills/`)
Workflow automations invoked with `/skill-name`:
- `/ship` - End-of-session workflow (verify, commit, track)
- `/verify-work` - Pre-commit verification
- `/organize-commits` - Group changes into logical commits
- `/generate-tests` - Generate test files

### Commands (`.claude/commands/`)
One-off tasks:
- `/worktree-create` - Create git worktree for feature development
- `/create-plan` - Initialize a feature plan

### Templates (`templates/`)
- CLAUDE.md templates for different tech stacks
- Skill and agent authoring templates
- Plan templates

## Model Selection Guide

| Model | Use When |
|-------|----------|
| **Haiku** | File searches, exploration, simple tasks |
| **Sonnet** | Implementation, reviews, debugging |
| **Opus** | Architecture, complex planning |

## Documentation

- [Getting Started](docs/guides/getting-started.md)
- [Installation Guide](docs/guides/installation.md)
- [Model Selection](docs/best-practices/model-selection.md)
- [Creating Agents](docs/best-practices/agent-design.md)
- [Worktree Workflow](docs/best-practices/worktree-workflow.md)

## License

MIT
