# Plugin Installation Guide

This guide explains how to install and use the claude-code-shared repository as a Claude Code plugin.

## What is a Claude Code Plugin?

A plugin is a distributable package that provides skills, agents, and other resources to Claude Code. Plugins offer:

- **Namespaced skills** - Prevents conflicts with other skills
- **Version management** - Track and update plugin versions
- **Easy distribution** - Share with teams or the community
- **Centralized updates** - Update all resources at once

## Installation Methods Comparison

| Method | Scope | Namespace | Use Case |
|--------|-------|-----------|----------|
| **Plugin** | Per-project | `claude-code-shared:skill-name` | Team sharing, distribution |
| **Project-local** | Per-project | `skill-name` | Project-specific customization |
| **Personal** | All projects | `skill-name` | Individual workflow preferences |

## Installing as a Plugin

### Option 1: Clone and Symlink (Development)

For development or contributing to this plugin:

```bash
# Clone the repository
git clone https://github.com/your-username/claude-code-shared.git
cd claude-code-shared

# Symlink to your project
cd /path/to/your/project
ln -s /path/to/claude-code-shared .claude/plugins/claude-code-shared
```

### Option 2: Git Submodule (Team Projects)

For team projects with version control:

```bash
cd /path/to/your/project

# Add as submodule
git submodule add https://github.com/your-username/claude-code-shared.git .claude/plugins/claude-code-shared

# Commit the submodule
git add .gitmodules .claude/plugins/claude-code-shared
git commit -m "Add claude-code-shared plugin"
```

Team members can initialize with:
```bash
git submodule update --init --recursive
```

### Option 3: Direct Clone (Simple Setup)

For quick setup without version tracking:

```bash
cd /path/to/your/project
mkdir -p .claude/plugins
git clone https://github.com/your-username/claude-code-shared.git .claude/plugins/claude-code-shared
```

## Using Plugin Skills

After installation, restart Claude Code (close and reopen VSCode).

### Namespaced Invocation

Plugin skills use the plugin name as a namespace:

```
/claude-code-shared:create-plan
/claude-code-shared:ship
/claude-code-shared:verify-work
```

### Why Namespacing?

Namespacing prevents conflicts when:
- Multiple plugins provide similarly-named skills
- You have personal skills with the same names
- You want to explicitly use a plugin's version

## Alternative: Project-Local Installation

If you don't want namespacing and prefer direct skill names:

```bash
# Copy skills to project
cp -r .claude/plugins/claude-code-shared/.claude/skills/* .claude/skills/

# Now use without namespace
/create-plan
/ship
```

**Trade-off:** Loses plugin benefits (updates, versioning), but skills are directly accessible.

## Alternative: Personal Installation

To use across all your projects without a plugin:

```bash
cd /path/to/claude-code-shared

# Install to personal directory
./scripts/install-skills.sh

# Or install specific skill
./scripts/install-skills.sh create-plan
```

**Trade-off:** Skills available everywhere, but updates require manual reinstall.

## Updating the Plugin

### Git Submodule Method

```bash
cd /path/to/your/project/.claude/plugins/claude-code-shared
git pull origin main
cd /path/to/your/project
git add .claude/plugins/claude-code-shared
git commit -m "Update claude-code-shared plugin"
```

### Direct Clone Method

```bash
cd /path/to/your/project/.claude/plugins/claude-code-shared
git pull origin main
```

Restart Claude Code after updating.

## Available Skills

After installation, you'll have access to:

### Development Workflow
- `/claude-code-shared:ship` - Complete end-of-session workflow
- `/claude-code-shared:verify-work` - Pre-commit verification
- `/claude-code-shared:organize-commits` - Logical commit organization
- `/claude-code-shared:track-progress` - Changelog tracking

### Testing & Quality
- `/claude-code-shared:generate-tests` - Generate test files
- `/claude-code-shared:performance-check` - Performance analysis

### Git Workflow
- `/claude-code-shared:worktree-create` - Create git worktree
- `/claude-code-shared:worktree-sync` - Sync with base branch
- `/claude-code-shared:worktree-cleanup` - Remove worktrees

### Planning
- `/claude-code-shared:create-plan` - Initialize feature plan
- `/claude-code-shared:plan-status` - Show plan progress

### Project Scaffolding
- `/claude-code-shared:starter-project` - Generate starter projects

## Plugin Structure

For reference, the plugin structure is:

```
claude-code-shared/
├── .claude-plugin/
│   └── plugin.json           # Plugin manifest
├── .claude/
│   ├── agents/               # Sub-agents (explore, plan, implement)
│   └── skills/               # Skills (auto-discovered)
│       ├── create-plan/
│       ├── ship/
│       ├── verify-work/
│       └── ...
├── docs/                     # Documentation
├── scripts/                  # Installation scripts
└── templates/                # Reusable templates
```

## Troubleshooting

### Skills Not Appearing

1. Verify plugin installation:
   ```bash
   ls -la .claude/plugins/claude-code-shared
   ```

2. Check for `.claude-plugin/plugin.json`:
   ```bash
   cat .claude/plugins/claude-code-shared/.claude-plugin/plugin.json
   ```

3. Restart Claude Code completely (close and reopen VSCode)

### Namespace Too Long

If typing `claude-code-shared:` is too verbose:

**Option A:** Create project-local aliases by copying specific skills:
```bash
cp .claude/plugins/claude-code-shared/.claude/skills/ship .claude/skills/
# Now use: /ship
```

**Option B:** Install personally (no namespace needed):
```bash
cd .claude/plugins/claude-code-shared
./scripts/install-skills.sh
```

### Plugin Updates Not Showing

After pulling updates:
1. Restart Claude Code (close and reopen VSCode)
2. Check the plugin version:
   ```bash
   cat .claude/plugins/claude-code-shared/.claude-plugin/plugin.json
   ```

## Uninstalling

### Remove Plugin

```bash
# Remove from project
rm -rf .claude/plugins/claude-code-shared

# If using submodule
git submodule deinit -f .claude/plugins/claude-code-shared
git rm -f .claude/plugins/claude-code-shared
rm -rf .git/modules/.claude/plugins/claude-code-shared
```

### Remove Personal Skills

```bash
# Remove all installed skills
rm -rf ~/.claude/skills/create-plan
rm -rf ~/.claude/skills/ship
# ... etc

# Or remove all at once
rm -rf ~/.claude/skills/*
```

## See Also

- [Skill Authoring Best Practices](../best-practices/skill-authoring.md) - Creating custom skills
- [Getting Started](./getting-started.md) - Quick start guide
- [.claude/skills/README.md](../../.claude/skills/README.md) - Skill discovery details
