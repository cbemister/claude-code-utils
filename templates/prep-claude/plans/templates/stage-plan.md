---
title: "Stage [N]: [Stage Title]"
type: stage
status: pending
created: YYYY-MM-DD
dependencies: [list prior stages, e.g. "Stages 0-2"]
agents:
  lead: [primary agent, e.g. "backend-architect"]
  support: [supporting agents, e.g. "frontend-architect, test-engineer"]
  review: [review agents, e.g. "security-auditor, code-reviewer"]
---

# Stage [N]: [Stage Title]

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

## Why This Stage

[2-3 sentences — what this stage achieves, why it matters, and why it's sequenced here. Explain the business context, not just the technical deliverable.]

## Architecture

[How the pieces fit together — modules, data flow, integration points. Include a brief ASCII diagram if the stage introduces new architectural components.]

```
[Component A] → [Component B] → [Component C]
      ↓                              ↓
[Component D]                  [Component E]
```

## Tech Stack

[Languages, frameworks, libraries, and tools used in this stage]

## Dependencies

- **Depends on:** [Which prior stages must be complete and what they provide]
- **Enables:** [What later stages this unlocks]

## Parallelization

[Explicit statement of which tasks can run in parallel vs. must be sequential]

```
[NA] [Task Title] ──────────────┐
[NB] [Task Title] ──────────────├── NA + NB in PARALLEL
                                │
[NC] [Task Title] ──────────── depends on NA
[ND] [Task Title] ──────────── depends on NA + NB
[NE] [Task Title] ──────────── depends on ND
```

## Agent Team Assignments

- **Lead:** `[agent]` — [what they own in this stage]
- **Support:** `[agent]` — [what they help with]
- **Review:** `[agent]` — [what they verify]

---

## Task [N]A: [Task Title]

**Agent:** `[assigned agent]`

**Files:**
- Create: `path/to/new-file.ts`
- Create: `path/to/new-file.test.ts`
- Modify: `path/to/existing-file.ts`

### What

[1-2 sentences describing what this task builds and why]

### Steps

1. [Step description]
   ```bash
   [command if applicable]
   ```

2. [Step description]

3. Create `path/to/file.ts`:
   ```typescript
   // Key implementation details — show interfaces, function signatures,
   // and non-obvious logic. Don't show boilerplate.
   ```

### Test

```typescript
// path/to/new-file.test.ts
describe('[feature under test]', () => {
  it('[expected behavior]', () => {
    // Test implementation
  });

  it('[edge case]', () => {
    // Edge case test
  });
});
```

### Verify

```bash
# Run tests for this task
[test command]

# Manual verification (if applicable)
[curl command, browser check, or CLI output to verify]
```

Expected: [What the output should look like]

### Commit

```bash
git add [specific files]
git commit -m "[type](scope): [description]"
```

---

## Task [N]B: [Task Title]

**Agent:** `[assigned agent]`

[Same structure as Task NA: Files → What → Steps → Test → Verify → Commit]

---

## Task [N]C: [Task Title]

**Agent:** `[assigned agent]`

[Same structure]

---

## Stage [N] Deliverable Verification

### Unit Tests
```bash
# All tests for this stage pass
[test command with filter]
```

### Integration Test
```bash
# Feature works end-to-end
[manual verification steps with expected output]
```

### No Regressions
```bash
# Full test suite still passes
[command to run all tests]
```

### Checklist

- [ ] All tasks committed with conventional commit messages
- [ ] No TypeScript errors (`npx tsc --noEmit`)
- [ ] No lint warnings (`[lint command]`)
- [ ] All new files have corresponding tests
- [ ] Architecture documented in `.claude/rules/architecture.md` (if changed)
- [ ] API conventions documented in `.claude/rules/api-conventions.md` (if new endpoints)
