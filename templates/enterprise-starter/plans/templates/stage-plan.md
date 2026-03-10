---
title: "Stage [N]: [Stage Title]"
type: stage
status: pending
created: YYYY-MM-DD
dependencies: [list prior stages, e.g. "Stages 1-3"]
---

# Stage [N]: [Stage Title]

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** [1-2 sentences — what this stage achieves and why it matters]

**Architecture:** [How the pieces fit together — modules, data flow, integration points]

**Tech Stack:** [Languages, frameworks, and tools used in this stage]

**Dependencies:** [Which prior stages must be complete]

---

## Task 1: [Task Title]

**Files:**
- Create: `path/to/new-file.ts`
- Modify: `path/to/existing-file.ts`
- Create: `path/to/new-file.test.ts`

**Step 1: Write failing tests first**

```typescript
// path/to/new-file.test.ts
describe('[feature under test]', () => {
  it('[expected behavior]', () => {
    // Test implementation
  });
});
```

**Step 2: Run tests — verify they fail**

```bash
[test command]
```

Expected: Tests fail because implementation doesn't exist yet.

**Step 3: Implement**

[Description of what to build, with code snippets for key decisions]

**Step 4: Run tests — verify they pass**

```bash
[test command]
```

**Step 5: Commit**

```bash
git add [specific files]
git commit -m "[conventional commit message]"
```

---

## Task 2: [Task Title]

[Same structure as Task 1: Files → Tests → Fail → Implement → Pass → Commit]

---

## Stage [N] Deliverable Verification

```bash
# 1. All tests pass
[full test command]

# 2. Feature works end-to-end
[manual verification steps with expected output]

# 3. No regressions
[command to run broader test suite]
```
