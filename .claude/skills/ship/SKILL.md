---
name: ship
description: Complete end-of-session workflow - verify work quality, organize commits, and summarize what shipped. Use at the end of a development session to ship cleanly.
---

# Ship Skill

Complete end-of-session workflow: verify work, organize commits, and summarize what shipped.

## When to Use

Invoke with `/ship` when you're done with a development session and want to:
- Verify code quality and security
- Create clean, organized commits from your changes
- Get a summary of what was shipped

## Instructions

### Phase 0: Verify Work (Mandatory)

**IMPORTANT**: All code changes MUST pass verification before organizing commits.

1. **Run comprehensive verification** by invoking the `/verify-work` skill.

2. **Resolve all BLOCKING issues**:
   - Auto-fixes are applied silently by verify-work
   - If blocking issues remain that need manual fixes, stop and report them
   - Cannot proceed to Phase 1 until all blocking issues are resolved

3. **Run tests** if the project has a test suite:
   - Check for a test script in `package.json` (or equivalent for the project's runtime)
   - Run with the project's package manager/runtime (bun, npm, yarn, pnpm, etc.)
   - If tests fail, fix the issues before proceeding
   - If no test suite exists, skip this step

---

### Phase 1: Organize Commits

1. **Analyze Changes**
   ```bash
   git status
   git diff --stat HEAD
   ```

2. **Group into Logical Commits**
   Categorize by: feat, fix, refactor, style, docs, chore, test, perf

3. **Present Commit Plan**
   Show proposed groupings and ask for approval.

4. **Execute Commits**
   Create each commit with conventional commit messages.

---

### Phase 2: Ship Summary

After commits are created, print a brief summary of what was shipped:

```markdown
## Ship Summary

**Branch:** feature/my-feature
**Commits:** 3

1. feat: add user settings page
2. fix: correct validation on email field
3. chore: update dependencies

**Files changed:** 12 files (+340, -45)

Ready to push or create a PR.
```

This is informational only — no database writes, no external calls. Just a clean summary so you can see what was done at a glance.

---

## Quick Reference

| Phase | Action | Details |
|-------|--------|---------|
| 0 | Verify work | Run `/verify-work`, auto-fix, run tests |
| 1 | Organize commits | Group changes, create conventional commits |
| 2 | Ship summary | Print what was shipped |

## Example Flow

```
User: /ship

Claude: I'll help you ship your changes. First, let me verify code quality...

[Phase 0: Runs /verify-work]

Verification Results:
- Auto-fixed: 2 console.log statements removed
- All checks passed

Running tests... 45 tests passed.

[Phase 1: Analyzes changes]

I found 8 changed files across 3 categories:

1. feat(auth): add password reset flow (4 files)
2. fix(forms): correct email validation regex (2 files)
3. chore: update lock file (2 files)

Does this grouping look right?

User: yes

Claude: Creating commits...
- feat(auth): add password reset flow
- fix(forms): correct email validation regex
- chore: update lock file

[Phase 2: Summary]

## Ship Summary

**Branch:** feature/password-reset
**Commits:** 3

1. feat(auth): add password reset flow
2. fix(forms): correct email validation regex
3. chore: update lock file

**Files changed:** 8 files (+220, -15)

Ready to push or create a PR.
```

## Notes

- **Phase 0 is mandatory** — cannot skip verification
- Verification auto-fixes what it can, reports the rest without prompting
- Tests run automatically if a test suite exists
- Phase 2 is just a summary — no side effects, no tracking, no DB writes
- Commits follow conventional commit format with Co-Authored-By
- Works with any project — no project-specific assumptions
