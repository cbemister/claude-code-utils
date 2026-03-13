---
title: "Optimization Cycle N: [Hypothesis Titles]"
type: evolution-optimization
status: pending
created: YYYY-MM-DD
started: null
completed: null
parent: "Evolution Cycle N"
cycle: N
hypotheses: ["hyp-N-001", "hyp-N-002"]
predicted_score_delta: "+X"
---

# Optimization Cycle N: [Hypothesis Titles]

## Context
[1-2 sentences: Why this optimization exists. Reference the evaluation that identified the issues and the hypotheses being implemented.]

**Evolution Cycle:** N
**Baseline Score:** [X]/100
**Predicted Score After:** [Y]/100 (+[delta])

---

## Hypotheses Being Implemented

| ID | Title | Priority | Expected Impact | Confidence |
|----|-------|----------|-----------------|------------|
| hyp-N-001 | [title] | [score] | [impact] | [confidence] |
| hyp-N-002 | [title] | [score] | [impact] | [confidence] |

**Evaluation Reference:** `factory/evaluations/eval-[timestamp].json`
**Hypothesis Reference:** `factory/hypotheses/hyp-[cycle]-[timestamp].json`

---

## Agent Team Assignments

| Role | Agent | Responsibility |
|------|-------|----------------|
| **Lead** | [agent-type] | Owns [subsystem/domain] |
| **Support** | [agent-type] | Verifies [pattern/concern] |
| **Review** | [agent-type] | Validates [quality gate] |

---

## Dependencies

### Requires (from current codebase)
- [Existing file/component] — [what it provides]

### Produces (for evaluation)
- [What the next evaluation cycle will measure]

---

## Parallelization

```
Task NA ──────────────────────┐
Task NB ──────────────────────┤── parallel
                              ↓
Task NC ──── depends on NA ───── sequential
```

---

## Tasks

### Task NA: [Task Name — from Hypothesis 1]

#### What
[One sentence — what this task produces]

#### Why
[One sentence — links to hypothesis rationale and expected score improvement]

#### Dependencies
- None / [NX]

#### Steps
1. [Step with enough detail to implement without ambiguity]
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

### Task NB: [Task Name — from Hypothesis 2]

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

---

## Rollback Instructions

If this optimization causes regressions or is rejected during review:

```bash
# Option 1: Revert the optimization commits
git log --oneline -N  # Find the optimization commits
git revert <commit-hash>..HEAD

# Option 2: Reset to pre-optimization state
git log --oneline | grep "Stage [previous]"  # Find last good commit
git reset --hard <commit-hash>
```

**Important:** After rollback, update `factory/evolution-state.json`:
- Set cycle status to `"rejected"`
- Add hypothesis IDs to `rejected_hypotheses`
- Set overall status to `"hypothesizing"`

---

## Stage Checkpoint: Success Criteria

| Criterion | Threshold |
|-----------|-----------|
| All tasks compile | `npx tsc --noEmit` — 0 errors |
| Tests pass | [test command] — all green |
| No performance regressions | `/verify-performance` — 0 new blocking |
| No security issues | `/verify-work` — 0 blocking |

**Proceed to preview deploy when:** All criteria met and no regressions detected.

---

## Commits

Expected commit sequence (one per task):

```
feat(evolution): [NA description]
feat(evolution): [NB description]
```

---

## Progress Log

### [YYYY-MM-DD]
**Completed:** [Task IDs]
**Decisions:** [Key decisions made during implementation]
**Blockers:** [Issues encountered]
