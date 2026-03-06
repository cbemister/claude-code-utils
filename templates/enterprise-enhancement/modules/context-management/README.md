# Context Management Module

Maintain context across long-running features and multiple Claude Code sessions.

## The Problem

Complex enterprise features often span days or weeks across many sessions. Without a system, each new session starts from scratch — wasting time re-reading code and re-establishing context.

## The Solution: Three-Layer Context System

```
Layer 1: Plans (what to build)
         plans/active/[feature]/plan.md
         Tracks phases, tasks, decisions — lives in git

Layer 2: Session memory (what happened)
         ~/.claude/projects/[slug]/memory/sessions/YYYY-MM-DD.md
         Written by /summarize-session — persists across sessions

Layer 3: Context handoff (how to resume)
         plans/active/[feature]/context-handoff.md
         Written manually at thread end, pasted at thread start
```

## Installation

1. Copy `plans/` folder to your project root (or merge with existing `plans/`)
2. Install the workflow skills from `~/.claude/skills/`:
   - `/create-plan` — initialize a new plan
   - `/plan-status` — view plan progress
   - `/summarize-session` — write session notes to memory
   - `/ship` — end-of-session workflow
3. Read `memory-setup.md` to understand where session notes are stored

## Workflow

### Starting a New Feature

```bash
/create-plan
# → Creates plans/active/[feature]/plan.md from template
# → Use the feature-plan.md template
```

### During a Session

Work through tasks in the plan. Update checkboxes as you go:
```markdown
- [x] Completed task
- [ ] Next task
```

### Ending a Session

```bash
/summarize-session
# → Writes to ~/.claude/projects/[slug]/memory/sessions/YYYY-MM-DD.md
# → Captures: what was built, decisions made, files changed, next steps
```

For long context gaps (coming back days later or switching threads):
1. Copy `plans/templates/context-handoff.md`
2. Fill it out (takes 5 minutes)
3. Save to `plans/active/[feature]/context-handoff.md`
4. Paste the contents at the start of the next thread

### Starting the Next Session

Claude Code auto-loads your memory file at session start. At the top of a new thread:

```
Continue work on [feature].
Context handoff: [paste context-handoff.md contents here]
```

## Plan Templates

| Template | Use for |
|---|---|
| `plans/feature-plan.md` | New features (research → design → implement → test) |
| `plans/bugfix-plan.md` | Bug investigation and fix |
| `plans/context-handoff.md` | Cross-thread context transfer |

## Memory File Location

Session notes are written to:
```
~/.claude/projects/[project-slug]/memory/sessions/YYYY-MM-DD.md
```

Where `[project-slug]` is derived from your project's directory path. The `/summarize-session` skill handles this automatically.
