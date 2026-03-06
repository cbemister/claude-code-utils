---
name: summarize-session
description: Capture a structured session work journal — what was built, decisions made, current state, and next steps. Writes to project memory for future session context.
---

# Summarize Session Skill

Captures the narrative of a development session as a persistent work journal. Distinct from auto-memory (which records stable patterns/conventions) — this records what happened, what was decided, and what to pick up next.

## When to Use

- End of a development session before closing the conversation
- After completing a significant chunk of work
- Manual invocation with `/summarize-session`

## Behavior

- **Non-interactive**: Scans context, writes file, prints summary — no prompts
- **Persistent**: Writes to project memory so future sessions have context
- **Additive**: Appends if a summary for today already exists

## Instructions

> **CRITICAL — NON-INTERACTIVE**: Run every step to completion without pausing. Never ask questions, request confirmation, offer choices, or wait for input. Scan, write, and report.

### Step 1: Gather Context

Review the conversation history to understand what was done this session. Also run:

```bash
# Recent commits from this session
git log --oneline -20

# Files changed (staged + unstaged)
git diff --stat HEAD

# Current branch and status
git status --short
```

### Step 2: Compose Summary

Based on the conversation context and git data, write a structured summary. Be concrete and specific — future sessions should be able to pick up exactly where this one left off.

```markdown
## Session: YYYY-MM-DD

### What was built
- [Concrete feature/change with file paths where relevant]

### Key decisions
- [Architectural or design choice] — [rationale]

### Files changed
- [List key files from git diff, grouped by area]

### Current state
- What works: [features that are functional]
- In progress: [anything partially done]
- Known issues: [bugs or blockers discovered]

### Next steps
- [Specific task to pick up next, ordered by priority]
```

### Step 3: Write to Project Memory

Determine the project memory directory path by resolving the current project slug from the working directory path. The pattern is:
`~/.claude/projects/<project-slug>/memory/sessions/`

Run these commands silently — no prompts, no confirmation, regardless of whether the directory exists:

```bash
# Silently ensure directory exists (no-op if already there)
SESSIONS_DIR="$HOME/.claude/projects/$(basename $(pwd))/memory/sessions"
mkdir -p "$SESSIONS_DIR"

# Check if today's file exists
ls "$SESSIONS_DIR/$(date +%Y-%m-%d).md" 2>/dev/null
```

Write to `YYYY-MM-DD.md` in that directory:
- If the file already exists: append `---` then the new summary
- If it doesn't exist: create the file with the summary

Never ask whether to create the directory or file — always proceed.

### Step 4: Print Summary

Output the full summary to chat so the user can see it immediately.

---

## Notes

- The summary should be scannable in under 30 seconds
- Use file paths and line numbers where relevant so future sessions can navigate quickly
- Don't include raw diffs — summarize what changed at a feature level
- "Next steps" is the most important section — be specific enough that a fresh session can start immediately
- Keep each summary under ~50 lines — concise beats comprehensive
