# Session Memory Setup

Session memory persists context between Claude Code sessions using the `/summarize-session` skill.

## How It Works

The `/summarize-session` skill writes structured session notes to:

```
~/.claude/projects/<project-slug>/memory/sessions/YYYY-MM-DD.md
```

The `<project-slug>` is automatically derived from your project's working directory path.

**Example:** A project at `/home/user/projects/my-app` gets slug `my-app`.

## What Gets Written

Each session note contains:

```markdown
## Session: YYYY-MM-DD

### What was built
- Feature X: added [file] implementing [thing]

### Key decisions
- Used JWT tokens (not sessions): better for mobile clients

### Files changed
- src/auth/jwt.ts (new)
- src/routes/login.ts (modified)

### Current state
- What works: login flow end-to-end
- In progress: refresh token rotation
- Known issues: token expiry not propagating to client

### Next steps
1. Implement refresh token rotation in src/auth/jwt.ts
2. Add client-side token refresh interceptor
```

## Running It

```
/summarize-session
```

This is non-interactive — it scans the conversation, writes the file, and prints the summary. Run it at the end of every session before closing the thread.

## Reading Memory in the Next Session

Claude Code reads your memory files automatically. You can also explicitly reference them:

```
Read ~/.claude/projects/my-app/memory/sessions/ and summarize recent work.
```

## Team Memory

For team-shared context (not personal memory), use the plan files in `plans/active/` instead — they live in git and are visible to all contributors.

## MEMORY.md

For stable, persistent facts about the project (not session-specific), create:

```
~/.claude/projects/<project-slug>/memory/MEMORY.md
```

This is loaded into every session automatically and should contain:
- Key architectural decisions that don't change
- Important file paths and conventions
- Team preferences and workflow notes

**Keep MEMORY.md under 200 lines** — content beyond that is truncated.
