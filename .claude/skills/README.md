# Skills

Workflow automations and reusable procedures for development tasks.

## Installation Options

Claude Code discovers skills from three locations:
1. **Project** - `.claude/skills/<name>/SKILL.md` (this directory!)
2. **Personal** - `~/.claude/skills/<name>/SKILL.md`
3. **Enterprise** - Managed by your organization

### Option 1: Project-Local (Recommended for Teams)

**Skills in this directory work immediately** - no installation needed!

This repo's skills are already in `.claude/skills/` and will work in any project that includes this repo. Just restart Claude Code.

**Use when:**
- Working on a team project
- Want skills version-controlled with your project
- Skills are project-specific

### Option 2: Personal Installation (Recommended for Individual Use)

Install skills to your personal `~/.claude/skills/` to use across ALL projects.

```bash
# Install all skills globally
./scripts/install-skills.sh

# Or install specific skill
./scripts/install-skills.sh create-plan
```

**Use when:**
- Want skills available in all your projects
- Personal workflow preferences
- Skills are general-purpose

### Required Structure

Each skill must be a directory with `SKILL.md` inside:
```
.claude/skills/           # Project-local
└── create-plan/
    └── SKILL.md

~/.claude/skills/         # Personal (global)
└── create-plan/
    └── SKILL.md
```

> **Note:** After adding skills or changing their location, restart Claude Code (close and reopen VSCode).

---

## Available Skills

### Development Workflow
- **ship** - Complete end-of-session workflow (verify → commit → track)
- **verify-work** - Comprehensive pre-commit verification (security, performance, standards)
- **organize-commits** - Group changes into logical commits with conventional format
- **track-progress** - Record work to changelog and progress tracking

### Testing & Quality
- **generate-tests** - Generate test files following project patterns
- **benchmark-performance** - Static analysis for performance anti-patterns
- **verify-performance** - API performance regression testing

### Git Workflow (NEW)
- **worktree-create** - Create git worktree for parallel development
- **worktree-sync** - Sync worktree with base branch
- **worktree-cleanup** - Remove completed worktrees

### Planning (NEW)
- **create-plan** - Initialize feature plan with phases
- **plan-status** - Show current plan progress

### Project Scaffolding (NEW)
- **starter-project** - Generate starter projects with agents/skills pre-configured
  - Categories: SaaS app, API service, component library, CLI tool, e-commerce, browser game
  - Each includes: CLAUDE.md, relevant agents, workflow skills, initial plan, working foundation

## Usage

Skills are invoked with `/skill-name`:

```
/ship
/verify-work
/organize-commits
```

## Skill Chaining

Some skills automatically invoke others:
- `/ship` → `/verify-work` → `/organize-commits` → `/track-progress`

## Creating Custom Skills

See [Skill Authoring Best Practices](../../docs/best-practices/skill-authoring.md) for guidelines.
