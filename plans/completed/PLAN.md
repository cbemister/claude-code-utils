# Claude Code Shared Resources - Implementation Plan

## Overview
Create a shareable Claude Code resources repository with skills, commands, sub-agents, best practices, plan templates, and git worktree workflow support.

## Current State
- Location: `c:\Users\chris\Code-Projects\DevTools\claude-code-shared`
- 7 skills already in `.claude/skills/`:
  - `benchmark-performance.md`, `generate-tests.md`, `organize-commits.md`
  - `ship.md`, `track-progress.md`, `verify-performance.md`, `verify-work.md`
- No other configuration files yet

## Distribution Model
- **Per-project**: Copy/clone into project's `.claude/` folder
- **Central**: Install to `~/.claude/` for all projects
- Support both via installation scripts

---

## Proposed Directory Structure

```
claude-code-shared/
├── README.md                           # Project overview and quick start
├── CLAUDE.md                           # Instructions for Claude in this repo
├── INSTALL.md                          # Installation guide
├── CHANGELOG.md                        # Version history
│
├── .claude/
│   ├── settings.json                   # Default settings template
│   │
│   ├── agents/                         # Sub-agents by purpose
│   │   ├── README.md                   # Agent catalog
│   │   ├── explore/                    # Read-only exploration (Haiku)
│   │   │   ├── codebase-explorer.md
│   │   │   ├── dependency-analyzer.md
│   │   │   └── pattern-finder.md
│   │   ├── plan/                       # Planning agents (Opus)
│   │   │   ├── architecture-planner.md
│   │   │   ├── feature-planner.md
│   │   │   └── refactor-planner.md
│   │   └── implement/                  # Implementation agents (Sonnet)
│   │       ├── api-developer.md
│   │       ├── component-builder.md
│   │       └── test-writer.md
│   │
│   ├── commands/                       # Slash commands
│   │   ├── README.md
│   │   ├── git/                        # Git workflow
│   │   │   ├── worktree-create.md
│   │   │   ├── worktree-sync.md
│   │   │   ├── worktree-cleanup.md
│   │   │   └── pr-create.md
│   │   ├── plan/                       # Plan management
│   │   │   ├── create-plan.md
│   │   │   ├── create-subplan.md
│   │   │   ├── plan-status.md
│   │   │   └── plan-next.md
│   │   └── project/                    # Project utilities
│   │       ├── onboard.md
│   │       └── health-check.md
│   │
│   └── skills/                         # Existing + new skills
│       ├── README.md
│       ├── [7 existing skills]
│       ├── code-review.md              # [NEW]
│       └── security-audit.md           # [NEW]
│
├── plans/                              # Plan system
│   ├── README.md                       # Planning documentation
│   └── templates/
│       ├── feature-plan.md
│       ├── bugfix-plan.md
│       ├── refactor-plan.md
│       └── subplan-template.md
│
├── templates/                          # Reusable templates
│   ├── claude-md/                      # CLAUDE.md templates by stack
│   │   ├── nextjs-app.md
│   │   ├── node-library.md
│   │   └── minimal.md
│   ├── skills/                         # Skill authoring templates
│   │   └── skill-template.md
│   └── agents/                         # Agent authoring templates
│       └── agent-template.md
│
├── docs/                               # Documentation
│   ├── best-practices/
│   │   ├── model-selection.md          # Haiku/Sonnet/Opus guidance
│   │   ├── skill-authoring.md
│   │   ├── agent-design.md
│   │   └── worktree-workflow.md
│   └── guides/
│       ├── getting-started.md
│       └── installation.md
│
└── scripts/                            # Installation scripts
    ├── install.sh                      # Unix
    └── install.ps1                     # Windows
```

---

## Sub-Agent Format (Official Claude Code)

Sub-agents are **Markdown files with YAML frontmatter** stored in:
- Project: `.claude/agents/` (checked into version control)
- User: `~/.claude/agents/` (available in all projects)

### Required Fields
- `name` - Unique identifier (lowercase, hyphens)
- `description` - When Claude should delegate to this agent

### Optional Fields
- `tools` - Allowed tools (inherits all if omitted)
- `disallowedTools` - Tools to deny
- `model` - `haiku`, `sonnet`, `opus`, or `inherit` (default: inherit)
- `permissionMode` - `default`, `acceptEdits`, `dontAsk`, `bypassPermissions`, `plan`
- `skills` - Skills to preload into agent's context
- `hooks` - Lifecycle hooks (PreToolUse, PostToolUse, Stop)

### Example Sub-Agent File
```markdown
---
name: codebase-explorer
description: Explore and analyze codebase structure. Use proactively when understanding new code.
tools: Read, Grep, Glob, Bash
disallowedTools: Write, Edit
model: haiku
---

You are a codebase exploration specialist. When invoked:
1. Understand what the user wants to find
2. Search systematically using available tools
3. Return a clear summary of findings
```

---

## Model Selection Strategy

| Model | Cost | Speed | Use For |
|-------|------|-------|---------|
| **Haiku** | Low | Fast | File searches, read-only exploration, high-volume tasks |
| **Sonnet** | Medium | Medium | Implementation, reviews, debugging, most dev work |
| **Opus** | High | Slow | Architecture, complex planning, difficult problems |

---

## Plan/Sub-Plan System

### Plan Structure
Plans stored as markdown in `plans/active/<feature-name>/`:
- `plan.md` - Master plan with phases and success criteria
- `01-research.md`, `02-backend.md`, etc. - Sub-plans per phase

### Plan Frontmatter
```yaml
---
title: Add User Authentication
status: in_progress
worktree: auth-feature
phases:
  - id: research, status: completed
  - id: backend, status: in_progress
  - id: frontend, status: pending
---
```

### Commands
- `/create-plan <name>` - Initialize new feature plan
- `/create-subplan <phase>` - Create sub-plan for phase
- `/plan-status` - Show current plan progress
- `/plan-next` - Start next phase

---

## Git Worktrees Workflow

### Directory Structure
```
project/
├── main/                    # Main worktree
└── worktrees/               # Feature worktrees
    ├── feature-auth/
    └── fix-dashboard/
```

### Commands
- `/worktree-create <name>` - Create worktree + branch + plan
- `/worktree-sync` - Rebase on base branch
- `/worktree-cleanup` - Remove completed worktrees

### Integration with Plans
- Worktree name matches plan directory
- Plan status tracked in worktree branch
- Completed work merged via PR

---

## GitHub Distribution

### Installation Methods
1. **Full clone**: `git clone` entire repo to `~/.claude/`
2. **Selective**: Copy specific directories (agents, skills, etc.)
3. **Script**: Run `install.ps1` or `install.sh`

### Versioning
- Semantic versioning via git tags (v1.0.0, v1.1.0, etc.)
- CHANGELOG.md documents all changes
- Users can pin to specific versions

---

## Implementation Phases

### Phase 1: Foundation
- [ ] Create directory structure (`.claude/agents/`, `.claude/commands/`, etc.)
- [ ] Add README files for each section
- [ ] Create CLAUDE.md for this repo
- [ ] Initialize git repository

### Phase 2: Sub-Agents (PRIORITY)
Create agents in `.claude/agents/`:

**Explore Agents (Haiku, read-only)**
- [ ] `codebase-explorer.md` - Deep codebase analysis
- [ ] `dependency-analyzer.md` - Dependency tree analysis
- [ ] `pattern-finder.md` - Find code patterns and conventions

**Plan Agents (Opus, read-only)**
- [ ] `architecture-planner.md` - System design for complex features
- [ ] `feature-planner.md` - Feature breakdown and estimation
- [ ] `refactor-planner.md` - Refactoring strategy

**Implement Agents (Sonnet, full access)**
- [ ] `api-developer.md` - API endpoint implementation
- [ ] `component-builder.md` - UI component creation
- [ ] `test-writer.md` - Test implementation
- [ ] `debugger.md` - Bug investigation and fix

### Phase 3: Commands (Skills)
Create in `.claude/skills/`:
- [ ] `worktree-create.md` - Create worktree + branch + plan
- [ ] `worktree-sync.md` - Rebase on base branch
- [ ] `worktree-cleanup.md` - Remove completed worktrees
- [ ] `create-plan.md` - Initialize feature plan
- [ ] `plan-status.md` - Show plan progress

### Phase 4: Templates & Documentation
- [ ] Create plan templates in `plans/templates/`
- [ ] Create CLAUDE.md templates for different stacks
- [ ] Write best practices documentation (model selection, agent design)
- [ ] Write getting started guide

### Phase 5: Distribution
- [ ] Create installation scripts (PS1 + bash)
- [ ] Set up GitHub repository
- [ ] Add versioning and changelog
- [ ] Test installation on clean system

---

## Verification
- Test each agent with sample tasks
- Verify worktree workflow end-to-end
- Test plan creation and tracking
- Validate installation scripts on Windows and Unix
- Ensure existing 7 skills still work correctly
