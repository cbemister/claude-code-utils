---
title: [Feature/Task Name] Context Handoff
type: context-handoff
created: YYYY-MM-DD
thread: [original-thread-id or description]
---

# Context Handoff: [Feature/Task Name]

Use this document to transfer context between Claude Code sessions. Paste its contents at the start of a new thread to resume work exactly where you left off.

---

## Current State

**What this is:** [1-2 sentences describing the feature/task]

**Overall status:** [e.g., "In progress — backend complete, frontend 50% done, tests not started"]

**Branch:** `[git branch name]`

---

## What Was Completed

- [x] [Completed task 1] — [file(s) changed]
- [x] [Completed task 2] — [file(s) changed]
- [x] [Completed task 3] — [file(s) changed]

---

## What Remains

- [ ] [Next task] — [brief description of what needs to happen]
- [ ] [Subsequent task] — [brief description]
- [ ] [Final task] — [brief description]

**Start here next session:** [The single most important next step]

---

## Key Decisions Made

| Decision | Rationale |
|---|---|
| [What was decided] | [Why this approach was chosen] |
| [What was decided] | [Why this approach was chosen] |

---

## Files Modified

```
[List files changed so far — helps orient a new session quickly]
src/
├── [file1] — [what changed]
├── [file2] — [what changed]
└── [file3] — [what changed]
```

---

## Known Issues / Blockers

- [Issue 1]: [Description and what's needed to unblock]
- [Blocker]: [What needs to be resolved and by whom]

---

## Architecture Notes

[Any architectural context the new session needs — patterns chosen, constraints discovered, things to avoid]

---

## How to Continue

```bash
# Check out the feature branch
git checkout [branch-name]

# Install any new dependencies
[install command if needed]

# Run tests to confirm current state
[test command]
```

**First thing to do:** [Specific, concrete action — not "continue where we left off"]

---

## References

- Plan file: `plans/active/[plan-name]/plan.md`
- Session notes: `~/.claude/projects/[project-slug]/memory/sessions/[date].md`
- Related PR: [URL or N/A]
