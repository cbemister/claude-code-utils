---
title: "Stage N: [Stage Title]"
type: build-phase
status: pending
created: YYYY-MM-DD
started: null
completed: null
parent: "[parent plan or project name]"
stage: N
depends_on: ["stage-N-1"]
---

# Stage N: [Stage Title]

## Context
[1-2 sentences: Why this stage exists and what it builds toward. Reference parent plan.]

**Parent Plan:** [Link to parent plan file]
**Stage:** N of [total]

---

## Agent Team Assignments

| Role | Agent | Responsibility |
|------|-------|----------------|
| **Lead** | [agent-type] | Owns [subsystem/domain] |
| **Support** | [agent-type] | Verifies [pattern/concern] |
| **Review** | [agent-type] | Validates [quality gate] |

---

## Dependencies

### Requires (from prior stages)
- [Stage X, Task Y] — [what it provides]
- [Stage X, Task Z] — [what it provides]

### Produces (for later stages)
- [What downstream stages need from this one]

### External Dependencies
- [Library, service, or API required]

---

## Parallelization

```
Task NA ──────────────────────┐
Task NB ──────────────────────┤── all parallel
Task NC ──────────────────────┘
                              ↓
Task ND ──── depends on NA ───── sequential
```

- **Parallel:** [NA, NB, NC] — no shared state, can run simultaneously
- **Sequential:** [ND depends on NA] — [reason]

---

## Tasks

### Task NA: [Task Name]

#### What
[One sentence — what this task produces]

#### Why
[One sentence — why it matters]

#### Dependencies
- None (first task) / [NX] — [reason]

#### Steps
1. [Step with enough detail to implement without ambiguity]
2. [Step — include code blocks for interfaces/signatures when helpful]
3. [Step]

```typescript
// Include TypeScript interfaces or function signatures when they reduce ambiguity
export interface ExampleResult {
  success: boolean;
  data: SomeType | null;
  error: string | null;
}
```

#### Files
- `path/to/file.ts` — **new** | **modify** | **extend**
- `path/to/other.ts` — **modify** (add X method)

#### Verify

**Tier 1 — Compiles:**
```bash
npx tsc --noEmit
# Expected: No errors in [module].ts
```

**Tier 2 — Unit/Integration:**
```bash
# [Command to run relevant tests]
# Expected: [specific output or assertion]
```

**Tier 3 — End-to-End:**
```bash
# [Command to exercise the full flow]
# Expected: [observable outcome with quantified threshold if applicable]
```

---

### Task NB: [Task Name]

#### What
[One sentence]

#### Why
[One sentence]

#### Dependencies
- None / [NX]

#### Steps
1. [Step]
2. [Step]

#### Files
- `path/to/file.ts` — **new** | **modify** | **extend**

#### Verify

**Tier 1 — Compiles:**
```bash
npx tsc --noEmit
```

**Tier 2 — Unit/Integration:**
```bash
# [Test command]
```

---

<!-- Repeat Task sections as needed: NC, ND, ... -->

---

## Porting Notes
<!-- Remove this section if not porting from an existing system -->

### Source Files
- `path/to/legacy/file.ext` (lines N-M) — [what to port]
- `path/to/legacy/other.ext` — [what to port]

### Critical Porting Notes
- [Domain-specific constraint that isn't obvious from reading the code]
- [Ordering dependency, runtime context issue, etc.]

---

## Stage Checkpoint: Success Criteria

| Criterion | Threshold |
|-----------|-----------|
| [Measurable criterion 1] | [Quantified threshold] |
| [Measurable criterion 2] | [Quantified threshold] |
| [Measurable criterion 3] | [Quantified threshold] |
| All tasks compile | `npx tsc --noEmit` — 0 errors |
| Tests pass | [test command] — all green |

**Proceed to Stage [N+1] when:** [Gate condition in plain language]

---

## Commits

Expected commit sequence (one per task):

```
feat(scope): [NA description]
feat(scope): [NB description]
feat(scope): [NC description]
```

---

## Progress Log

### [YYYY-MM-DD]
**Completed:** [Task IDs]
**Decisions:** [Key decisions made during implementation]
**Blockers:** [Issues encountered — resolved/ongoing]

---

## Notes & Learnings
<!-- Fill in after stage completion -->

### What Went Well
-

### What Could Be Improved
-

### Surprises
- [Unexpected issue and how it was resolved]
