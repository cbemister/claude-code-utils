<!-- PASTE THIS SECTION INTO YOUR CLAUDE.md UNDER DEVELOPMENT WORKFLOW -->

## Context Management

For work that spans multiple sessions:

### Session Start
```
1. Check plan status: /plan-status
2. Review recent session notes in ~/.claude/projects/[PROJECT_SLUG]/memory/sessions/
3. Start on the highest-priority task in the active plan
```

### Session End
```
1. Run /summarize-session — writes notes to memory for next session
2. Run /ship — verify → organize commits → track progress
```

### Resuming After a Gap

For long breaks or switching threads, create a context handoff:
1. Copy `plans/templates/context-handoff.md` → fill it out (5 min)
2. Save as `plans/active/[feature]/context-handoff.md`
3. Paste contents at the top of the next thread

### Creating Plans

```bash
/create-plan     # Interactive plan creation from template
/plan-status     # View all active plans and task progress
```

Plans live in `plans/active/[feature]/plan.md` and are tracked in git.
