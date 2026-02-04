# Skills

Workflow automations and reusable procedures for development tasks.

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
