---
name: plan-optimization
description: Use when hypotheses have been generated and need to be converted into an executable stage plan. Produces a standard stage plan that /build-app executes unchanged.
---

# Plan Optimization

Convert batched hypotheses from `/generate-hypotheses` into a standard stage plan. The output uses the exact `stage-plan.md` template format so `/build-app` executes it without modification.

## Instructions

> **CRITICAL — NON-INTERACTIVE**: Execute all steps without pausing. Never ask questions, request confirmation, or wait for input. Read state, plan, write output, update state, stop.

---

### Step 0: Initialize

1. Read `factory/evolution-state.json`:
   - Verify status is `"planning"`
   - Set `CYCLE` to `current_cycle`
   - If status is not `"planning"`, display error and stop

2. Read the latest hypotheses file:
   - Find the most recent `factory/hypotheses/hyp-{CYCLE}-*.json`
   - Extract the `batched: true` hypotheses

3. Read project context:
   - `CLAUDE.md` — project name, stack, conventions
   - Current source files referenced in hypothesis `implementation_sketch`

---

### Step 1: Expand Implementation Sketches

For each batched hypothesis, expand the `implementation_sketch` into full task specifications:

1. **Read the actual source files** listed in `pages_affected` and `modifications`
2. **Identify exact changes** — what lines to modify, what components to create
3. **Define TypeScript interfaces** (or equivalent) for new components/data structures
4. **List file manifest** for each task: `new`, `modify`, or `extend` annotations
5. **Determine verification tier** per task:
   - Tier 1: Compiles/lints clean
   - Tier 2: Unit tests pass
   - Tier 3: E2E/integration tests pass

---

### Step 2: Determine Task Dependencies and Parallelization

1. Map dependencies between tasks across all hypotheses
2. Group independent tasks for parallel execution
3. Identify sequential chains (task B needs task A's output)
4. Create the parallelization diagram:

```
Task 1A (data model) ───────────────┐
Task 1B (utility function) ─────────┤── parallel
                                     ↓
Task 2A (component using 1A+1B) ──── sequential
Task 2B (integration) ──────────────── sequential (after 2A)
```

---

### Step 3: Assign Agents

Based on task type, assign agents from the project's team:

| Task Type | Recommended Agent |
|-----------|-------------------|
| Data models, API routes | backend-architect |
| UI components, pages | frontend-architect |
| Tests | test-engineer |
| Performance-sensitive | performance-analyst |
| Security-sensitive | security-auditor |

If the project doesn't have specific agents configured, use generic assignments (lead, support, review).

---

### Step 4: Write Stage Plan

Write `plans/active/stage-opt-{CYCLE}.md` using the optimization plan template format:

```markdown
---
title: "Optimization Cycle [CYCLE]: [Combined Hypothesis Titles]"
type: optimization
status: pending
created: [YYYY-MM-DD]
started: null
completed: null
parent: "evolution-cycle-[CYCLE]"
cycle: [CYCLE]
hypotheses: ["hyp-CYCLE-001", "hyp-CYCLE-002"]
baseline_score: [current composite score]
predicted_score: [expected composite score after optimization]
---

# Optimization Cycle [CYCLE]: [Combined Title]

## Context

This optimization implements [N] hypotheses from evolution cycle [CYCLE] to improve the product's composite score from [baseline] to [predicted].

**Hypotheses:**
1. **[Title 1]** — [rationale summary] (predicted +[X] composite)
2. **[Title 2]** — [rationale summary] (predicted +[X] composite)

**Current Score:** [baseline]/100
**Predicted Score:** [predicted]/100

---

## Agent Team Assignments

| Role | Agent | Responsibility |
|------|-------|----------------|
| **Lead** | [agent] | Owns [domain] |
| **Support** | [agent] | Verifies [concern] |
| **Review** | code-reviewer | Validates implementation quality |

---

## Dependencies

### Requires
- Evaluation data: `factory/evaluations/eval-[latest].json`
- Hypothesis specs: `factory/hypotheses/hyp-[CYCLE]-[latest].json`

### Produces
- Optimized codebase ready for preview deployment
- Updated components and pages per hypothesis specs

---

## Parallelization

[ASCII diagram from Step 2]

---

## Tasks

### Task [CYCLE].1: [Task Title]

**Hypothesis:** [hyp-ID]
**Agent:** [assigned agent]
**Verification:** Tier [N]

**Objective:** [what this task accomplishes]

**Files:**
| File | Action | Purpose |
|------|--------|---------|
| `src/components/X.tsx` | new | [what it does] |
| `src/app/page.tsx` | modify | [what changes] |

**Specification:**
[Detailed implementation spec — TypeScript interfaces, component structure, behavior]

**Verification Steps:**
- [ ] [Tier-appropriate checks]

---

### Task [CYCLE].2: [Task Title]
[Same structure...]

---

## Rollback Instructions

If this optimization is rejected:
1. Preview branch will be deleted by `/evolution-gate reject`
2. No changes reach production
3. Hypotheses are marked as rejected in evolution state
4. Next `/generate-hypotheses` run will skip similar approaches

---

## Stage Checkpoint

| Criterion | Target | Gate |
|-----------|--------|------|
| All tasks complete | 100% | hard |
| Verification passing | All tiers | hard |
| No new lint/type errors | 0 | hard |
| Predicted score achievable | +[X] composite | soft |
```

---

### Step 5: Refresh Against Codebase

Invoke the `/plan-next-stage` pattern — re-read the actual source files and verify:

1. All file paths in the plan exist (or are correctly marked as `new`)
2. Interfaces/types referenced are current
3. No conflicts with recent changes
4. Adjust the plan if the codebase has diverged from what hypotheses assumed

---

### Step 6: Update Evolution State

1. Read `factory/evolution-state.json`
2. Update status to `"building"`
3. Add cycle entry if not already present:
   ```json
   {
     "cycle": [CYCLE],
     "status": "building",
     "evaluation_score": null,
     "hypothesis_ids": ["hyp-CYCLE-001", "hyp-CYCLE-002"],
     "hypothesis_titles": ["Title 1", "Title 2"],
     "stage_plan_ref": "plans/active/stage-opt-[CYCLE].md",
     "preview_branch": null,
     "score_delta": null,
     "rejection_reason": null
   }
   ```
4. Write back

---

### Step 7: Display Summary

```
================================================================
  Optimization Plan Created
================================================================

  Project:     [name]
  Cycle:       [CYCLE]
  Hypotheses:  [count] batched
  Tasks:       [total tasks]
  Parallel:    [count parallelizable] | Sequential: [count sequential]

  Plan: plans/active/stage-opt-[CYCLE].md

  Baseline:    [X]/100
  Predicted:   [Y]/100 (+[delta])

  Next: Run /build-app to execute the optimization plan
================================================================
```

---

## Error Recovery

| Scenario | Recovery |
|----------|----------|
| No hypotheses files | Display error: "Run /generate-hypotheses first" |
| Source files moved/renamed | Update paths in plan, add note about drift |
| Hypothesis references deleted code | Adjust task to create from scratch instead of modify |
| plans/active/ doesn't exist | Create it: `mkdir -p plans/active` |
| Context exhausted mid-planning | Runner re-invokes; check for partial plan, resume |
