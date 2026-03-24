---
name: generate-hypotheses
description: Use when evaluation data exists and optimization proposals are needed. Analyzes scores, user journey drop-off points, and prior attempts to produce ranked hypotheses batched 2-3 per cycle.
argument-hint: "[count] - Optional: number of hypotheses to generate (default: 5, max: 10)"
---

# Generate Hypotheses

Analyze evaluation data and produce ranked optimization proposals. Batches the top 2-3 hypotheses per evolution cycle for implementation.

## Instructions

> **CRITICAL — NON-INTERACTIVE**: Execute all steps without pausing. Never ask questions, request confirmation, or wait for input. Read state, analyze, generate, write output, update state, stop.

---

### Step 0: Initialize

1. Read `factory/evolution-state.json`:
   - Verify status is `"hypothesizing"` or `"rejected"` (if rejected, we're retrying with next batch)
   - Set `CYCLE` to `current_cycle`
   - If status is neither, display error and stop

2. Parse `$ARGS` for optional count (default: 5, max: 10)

3. Read the latest evaluation:
   - Find the most recent file in `factory/evaluations/eval-*.json`
   - Load its `scores`, `top_issues`, and `user_journeys`

4. Read hypothesis history:
   - Read all files in `factory/hypotheses/hyp-*.json`
   - Read `rejected_hypotheses` from evolution state
   - Build a set of previously attempted and rejected approaches

---

### Step 1: Analyze Evaluation Data

For each issue in `top_issues`, map it to a concrete improvement:

1. **Identify the root cause** — what in the codebase is causing this score deficit?
2. **Define the fix** — what specific change would address it?
3. **Estimate impact** — how many composite score points could this recover?
4. **Assess confidence** — how certain are we this fix will work? (0.0-1.0)
5. **Estimate effort** — `"small"` (1-2 tasks), `"medium"` (3-5 tasks), `"large"` (6+ tasks)

Additionally, analyze user journey drop-off points:
- Each drop-off point maps to at least one hypothesis
- Drop-off points get `+2` to `expected_impact`

---

### Step 2: Score and Rank

For each hypothesis, calculate priority:

```
effort_multiplier = { "small": 1, "medium": 2, "large": 3 }

priority_score = (expected_impact * confidence) / effort_multiplier
```

Apply modifiers:
- **Journey drop-off**: `expected_impact += 2` (already applied in Step 1)
- **Multi-journey issue** (appears in 2+ journeys): `confidence *= 1.2` (cap at 1.0)
- **Similar to rejected hypothesis**: `confidence *= 0.5`
- **Previously attempted** (same approach, different cycle): skip entirely

Sort by `priority_score` descending.

---

### Step 3: Batch Top Hypotheses

Select the top 2-3 hypotheses for this cycle:

1. Take the highest-priority hypothesis
2. Add the next highest that does NOT conflict (same files, overlapping changes)
3. If a third doesn't conflict with the first two, include it
4. If all remaining conflict, batch only 2

A hypothesis **conflicts** if it modifies the same primary files as an already-batched hypothesis in a way that could cause merge issues.

---

### Step 4: Generate Implementation Sketches

For each batched hypothesis, produce an implementation sketch:

```json
{
  "pages_affected": ["src/app/page.tsx"],
  "new_components": ["src/components/SocialProof.tsx"],
  "modifications": ["src/app/layout.tsx"],
  "estimated_tasks": 3,
  "key_changes": [
    "Add testimonial data to homepage",
    "Create SocialProof component with carousel",
    "Add trust badges below hero section"
  ]
}
```

Read the actual source files referenced to ensure the sketch is grounded in the real codebase.

---

### Step 5: Write Output Files

Generate a timestamp: `TIMESTAMP` = current ISO-8601 datetime formatted as `YYYY-MM-DD-HHmmss`

#### 5A: JSON Output

Write `factory/hypotheses/hyp-{CYCLE}-{TIMESTAMP}.json`:

```json
{
  "version": 1,
  "timestamp": "[ISO-8601]",
  "cycle": 1,
  "evaluation_ref": "factory/evaluations/eval-[latest].json",
  "total_generated": 5,
  "batched_count": 3,
  "hypotheses": [
    {
      "id": "hyp-1-001",
      "title": "Add social proof section below hero",
      "category": "conversion",
      "description": "Homepage lacks trust signals. Adding testimonials, logos, and stats below the hero would increase trust and reduce bounce rate.",
      "rationale": "Conversion audit scored trust_credibility at 2/5. User journey 'New visitor' drops off before CTA due to lack of social validation.",
      "expected_impact": 8,
      "confidence": 0.8,
      "effort": "small",
      "effort_multiplier": 1,
      "priority_score": 6.4,
      "batched": true,
      "addresses_issues": ["issue-1", "issue-3"],
      "addresses_journeys": ["New visitor"],
      "predicted_score_change": {
        "conversion.trust_credibility": "+2",
        "composite_score": "+5"
      },
      "implementation_sketch": {
        "pages_affected": ["src/app/page.tsx"],
        "new_components": ["src/components/SocialProof.tsx"],
        "modifications": [],
        "estimated_tasks": 3,
        "key_changes": [
          "Add testimonial data structure",
          "Create SocialProof component",
          "Integrate below hero on homepage"
        ]
      }
    }
  ],
  "skipped": [
    {
      "id": "hyp-1-004",
      "title": "...",
      "reason": "Similar to rejected hypothesis hyp-0-002",
      "priority_score": 3.2
    }
  ]
}
```

#### 5B: Markdown Report

Write `factory/hypotheses/hyp-{CYCLE}-{TIMESTAMP}.md`:

```markdown
# Optimization Hypotheses — Cycle [N]

**Project:** [name]
**Date:** [date]
**Current Score:** [X]/100
**Evaluation:** [ref]

---

## Batched for This Cycle (2-3)

### 1. [Title] ⭐ Priority: [score]
- **Category:** [dimension]
- **Impact:** [expected_impact]/10 | **Confidence:** [confidence] | **Effort:** [effort]
- **Addresses:** [issue IDs], [journey names]
- **Predicted Score Change:** [composite delta]
- **Rationale:** [why this will work]
- **Key Changes:**
  - [change 1]
  - [change 2]

### 2. [Title] ...

---

## Other Candidates (Not Batched)

| Rank | Title | Priority | Reason Not Batched |
|------|-------|----------|-------------------|
| 4 | [title] | [score] | Conflicts with #1 |
| 5 | [title] | [score] | Lower priority |

---

## Skipped

| Title | Reason |
|-------|--------|
| [title] | Similar to rejected hyp-0-002 |

---

## Next: Run /plan-optimization to convert these into a stage plan
```

---

### Step 6: Update Evolution State

1. Read `factory/evolution-state.json`
2. Update status to `"planning"`
3. Write back

---

### Step 7: Display Summary

```
================================================================
  Hypotheses Generated
================================================================

  Project:     [name]
  Cycle:       [N]
  Generated:   [total] hypotheses
  Batched:     [count] for this cycle

  Batched Hypotheses:
    1. [title] — priority [score], predicted +[X] score
    2. [title] — priority [score], predicted +[X] score
    3. [title] — priority [score], predicted +[X] score

  Output:
    JSON: factory/hypotheses/hyp-{CYCLE}-{TIMESTAMP}.json
    Report: factory/hypotheses/hyp-{CYCLE}-{TIMESTAMP}.md

  Next: Run /plan-optimization to create the stage plan
================================================================
```

---

## Error Recovery

| Scenario | Recovery |
|----------|----------|
| No evaluation files | Display error: "Run /evaluate-product first" |
| All hypotheses conflict | Batch only the top 1 |
| All hypotheses previously rejected | Generate from secondary issues, widen scope |
| Evaluation has no top_issues | Generate hypotheses from lowest-scoring dimensions |
| Context exhausted mid-generation | Runner re-invokes; check for partial output, resume |
