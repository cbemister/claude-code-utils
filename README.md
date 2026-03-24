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
| **Design** | Opus | UI/UX design, mobile UX, conversion optimization |
| **Implement** | Sonnet | Code implementation and debugging |

### Agent Teams (`templates/enhance-app/teams/`)
Pre-configured teams optimized for different project types. Installed via `/enhance-app`.

| Team | Agents | Best For |
|------|--------|----------|
| Enterprise Engineering | 8 | APIs, data pipelines, complex backends |
| SaaS Product | 9 | SaaS apps, dashboards, subscription products |
| Internal Tool | 9 | Admin panels, developer tools |
| Game / Interactive | 7 | Games, creative tools, canvas apps |
| Marketing Site | 7 | Landing pages, marketing sites |

Use `/team-battle` to compare two teams on the same task side-by-side.

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
- Plan templates (feature, bugfix, refactor, stage plan)
- `enhance-app/` — Full project setup with agents, rules, hooks, and team presets

## VS Code: Install All Skills Easily

You can now install all skills with a single click using VS Code Tasks:

1. Open the Command Palette (`Ctrl+Shift+P` or `Cmd+Shift+P`)
2. Type `Run Task` and select it
3. Choose **Install Claude Code Skills (Windows)** or **Install Claude Code Skills (Unix)**

This will run the install script and set up all skills for you.

> **Note:** The VS Code task is defined in `.vscode/tasks.json`. You can edit this file to customize the install command or add more tasks for your workflow.

> **Sample `.vscode/tasks.json` for Install Skills:**
```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Install Claude Code Skills (Windows)",
      "type": "shell",
      "command": "./scripts/install-resources.bat",
      "group": { "kind": "build", "isDefault": false },
      "presentation": { "reveal": "always" },
      "problemMatcher": []
    },
    {
      "label": "Install Claude Code Skills (Unix)",
      "type": "shell",
      "command": "./scripts/install-resources.sh",
      "group": { "kind": "build", "isDefault": false },
      "presentation": { "reveal": "always" },
      "problemMatcher": []
    }
  ]
}
```

## Model Selection Guide

| Model | Use When |
|-------|----------|
| **Haiku** | File searches, exploration, simple tasks |
| **Sonnet** | Implementation, reviews, debugging |
| **Opus** | Architecture, complex planning, design |

## Documentation

- [Getting Started](docs/guides/getting-started.md)
- [Installation Guide](docs/guides/installation.md)
- [Model Selection](docs/best-practices/model-selection.md)
- [Creating Agents](docs/best-practices/agent-design.md) — includes team-based patterns
- [Team Selection](templates/enhance-app/teams/README.md) — compare and choose agent teams
- [Worktree Workflow](docs/best-practices/worktree-workflow.md)
- [Plan Templates](plans/templates/README.md) — feature, bugfix, refactor, stage plans

## License

MIT
