---
name: evaluate-product
description: Use when a built product needs scoring across conversion, revenue, UX, performance, accessibility, completeness, and code quality. Chains existing audit skills into a composite 0-100 score with AI-simulated user journeys.
---

# Evaluate Product

Chain existing audit skills and AI-simulated user journeys into a composite product score (0-100). Produces structured JSON for machine consumption and a human-readable markdown report.

This is the entry point for the evolution loop. Run after a product is built (or after a previous optimization is deployed) to establish the current baseline and identify weak areas.

## Instructions

> **CRITICAL — NON-INTERACTIVE**: Execute all steps without pausing. Never ask questions, request confirmation, or wait for input. Read state, evaluate, score, write output, update state, stop.

---

### Step 0: Initialize

1. Check if `factory/evolution-state.json` exists:
   - If it exists, read it. Set `CYCLE` to `current_cycle`. Update status to `"evaluating"`. Write back.
   - If it doesn't exist, create the `factory/` directory structure:
     ```bash
     mkdir -p factory/evaluations factory/hypotheses
     ```
     Create `factory/evolution-state.json`:
     ```json
     {
       "version": 1,
       "project": "[from CLAUDE.md]",
       "status": "evaluating",
       "current_cycle": 0,
       "total_cycles_completed": 0,
       "deploy_target": { "platform": "vercel", "production_branch": "main" },
       "baseline": null,
       "cycles": [],
       "rejected_hypotheses": []
     }
     ```
     Set `CYCLE` to `0`.

2. Read project context:
   - `CLAUDE.md` — project name, stack, target users, key features
   - `plans/README.md` — intended feature set (if exists)
   - `plans/build-state.json` — what was actually built (if exists)

3. Generate a timestamp: `TIMESTAMP` = current ISO-8601 datetime formatted as `YYYY-MM-DD-HHmmss`

---

### Step 1: Run Automated Audits

Run the following existing skills **sequentially** (each produces its own analysis). Capture the key scores from each.

#### 1A: Conversion Audit

Invoke `/conversion-audit` mentally — read the project's pages/routes and apply the conversion-audit rubric yourself:

- Score each of the 5 dimensions (1-5): Page Structure, Copy Effectiveness, Trust & Credibility, Friction Level, Mobile Conversion
- Record the total score out of 25
- Record the top 3 critical issues with estimated lift

#### 1B: Revenue Paths Analysis (new)

Analyze revenue-specific signals by reading the codebase:

1. **Pricing Page** — Does one exist? Is pricing transparent? Are tiers clear? Is there a recommended/highlighted plan?
2. **Upsell Paths** — Are there upgrade prompts, feature gates, or premium CTAs within the app?
3. **Churn Risk Indicators** — Dead-end flows, confusing navigation, missing onboarding, no engagement hooks
4. **Monetization Surface Area** — How many touchpoints exist to capture value? (checkout, trials, demos, contact forms)

Score 1-5:

| Score | Revenue Paths |
|-------|---------------|
| 5 | Clear pricing, multiple upsell paths, strong retention hooks, broad monetization surface |
| 4 | Good pricing page, some upsell paths, decent retention |
| 3 | Basic pricing exists, few upsell opportunities, some churn risks |
| 2 | Pricing unclear or missing, no upsell paths, significant churn risks |
| 1 | No monetization, no pricing, no clear path to revenue |

#### 1C: User Value Critique

Apply the `/critique-value` rubric — score 5 dimensions (1-5): Value Delivered, Usability, Design Quality, Completeness, Accessibility. Record the average.

#### 1D: Performance Check

Apply `/verify-performance` rubric — count blocking issues, warnings, and optimizations. Score:

| Score | Performance |
|-------|-------------|
| 5 | 0 blocking, 0 warnings |
| 4 | 0 blocking, 1-2 warnings |
| 3 | 0 blocking, 3+ warnings |
| 2 | 1 blocking issue |
| 1 | 2+ blocking issues |

#### 1E: Accessibility Audit

Apply `/accessibility-audit` rubric — count issues by severity. Score:

| Score | Accessibility |
|-------|---------------|
| 5 | 0 critical, 0 high |
| 4 | 0 critical, 1-2 high |
| 3 | 0 critical, 3+ high, or 1 critical |
| 2 | 2+ critical issues |
| 1 | Inaccessible — major violations |

#### 1F: Product Completeness

Apply `/pm-review` rubric — count features complete vs planned. Score:

| Score | Completeness |
|-------|--------------|
| 5 | 100% features complete, production-ready |
| 4 | 80%+ complete, MVP ready |
| 3 | 60-80% complete, core works |
| 2 | 40-60% complete, significant gaps |
| 1 | <40% complete, not usable |

#### 1G: Code Quality

Apply `/verify-work` rubric — count blocking issues, warnings, TODOs. Score:

| Score | Code Quality |
|-------|--------------|
| 5 | 0 blocking, 0 warnings, clean |
| 4 | 0 blocking, few warnings |
| 3 | 0 blocking, several warnings |
| 2 | 1+ blocking issues |
| 1 | Multiple blocking issues, security vulnerabilities |

---

### Step 2: AI-Simulated User Journeys

Define 3-5 personas based on the project's target users (from CLAUDE.md). For each persona:

1. **Define the persona**: name, role, goal, technical comfort level
2. **Define 1-2 critical paths**: the user journey from entry to key conversion/value moment
3. **Walk each path** by reading the actual source code:
   - For each step, read the page/component the user would see
   - Assess: Is the next action obvious? Is there friction? Is feedback provided?
   - Rate friction: `none`, `low`, `medium`, `high`
   - Identify the **drop-off point** — where would this persona most likely abandon?
4. **Score the journey** 1-5 based on overall friction and likelihood of completion

**Example personas:**
- "New visitor" — lands on homepage, tries to understand what the product does, clicks CTA
- "Trial user" — signs up, completes onboarding, uses core feature for first time
- "Returning user" — logs in, completes a routine task, finds a secondary feature
- "Admin/power user" — manages settings, views analytics, handles edge cases

---

### Step 3: Calculate Composite Score

Apply weights to get a 0-100 composite score:

```
composite = (
  (conversion_total / 25 * 100) * 0.20 +     # Conversion Funnel (20%)
  (revenue_score / 5 * 100) * 0.15 +          # Revenue Paths (15%)
  (ux_average / 5 * 100) * 0.20 +             # UX / User Value (20%)
  (performance_score / 5 * 100) * 0.15 +      # Performance (15%)
  (accessibility_score / 5 * 100) * 0.10 +    # Accessibility (10%)
  (completeness_score / 5 * 100) * 0.10 +     # Product Completeness (10%)
  (code_quality_score / 5 * 100) * 0.10       # Code Quality (10%)
)
```

Round to nearest integer.

---

### Step 4: Identify Top Issues

From all the audit results and user journeys, compile the top issues ranked by impact:

For each issue:
- `id`: `"issue-{N}"` — sequential
- `category`: which dimension it belongs to
- `subcategory`: specific area within the dimension
- `description`: what the problem is
- `impact`: `"critical"` | `"high"` | `"medium"` | `"low"`
- `current_score_contribution`: how many points this costs
- `estimated_lift`: expected improvement if fixed (e.g., "+10-15% conversion")
- `source`: which audit identified it

Prioritize: user journey drop-off points > critical audit issues > high-impact improvements

---

### Step 5: Write Output Files

#### 5A: JSON Output

Write `factory/evaluations/eval-{TIMESTAMP}.json`:

```json
{
  "version": 1,
  "timestamp": "[ISO-8601]",
  "cycle": 0,
  "project": "[project-name]",
  "scores": {
    "conversion": {
      "score": 15,
      "max": 25,
      "breakdown": {
        "page_structure": 3,
        "copy_effectiveness": 3,
        "trust_credibility": 2,
        "friction_level": 4,
        "mobile_conversion": 3
      }
    },
    "revenue_paths": {
      "score": 3,
      "max": 5,
      "breakdown": {
        "pricing_page": 3,
        "upsell_paths": 2,
        "churn_risk": 3,
        "monetization_surface": 4
      }
    },
    "ux": {
      "score": 3.5,
      "max": 5,
      "breakdown": {
        "value_delivered": 4,
        "usability": 3,
        "design_quality": 3,
        "completeness": 4,
        "accessibility": 3
      }
    },
    "performance": {
      "score": 4,
      "max": 5,
      "blocking": 0,
      "warnings": 2,
      "optimizations": 1
    },
    "accessibility": {
      "score": 3,
      "max": 5,
      "critical": 0,
      "high": 3,
      "medium": 2
    },
    "completeness": {
      "score": 4,
      "max": 5,
      "features_complete": 8,
      "features_partial": 3,
      "features_missing": 2
    },
    "code_quality": {
      "score": 4,
      "max": 5,
      "blocking": 0,
      "warnings": 4
    }
  },
  "composite_score": 68,
  "composite_max": 100,
  "user_journeys": [
    {
      "persona": "New visitor landing on homepage",
      "goal": "Understand product and sign up",
      "steps": [
        { "action": "Lands on homepage", "page": "src/app/page.tsx", "assessment": "...", "friction": "low" },
        { "action": "Reads value prop", "page": "src/app/page.tsx", "assessment": "...", "friction": "medium" },
        { "action": "Clicks CTA", "page": "src/app/page.tsx", "assessment": "...", "friction": "low" },
        { "action": "Fills signup form", "page": "src/app/signup/page.tsx", "assessment": "...", "friction": "high" }
      ],
      "journey_score": 3,
      "drop_off_point": "signup form — too many fields",
      "recommendation": "Reduce signup to email-only, collect details later"
    }
  ],
  "top_issues": [
    {
      "id": "issue-1",
      "category": "conversion",
      "subcategory": "trust_credibility",
      "description": "No social proof above the fold",
      "impact": "high",
      "current_score_contribution": -2,
      "estimated_lift": "+10-15% conversion",
      "source": "conversion-audit"
    }
  ]
}
```

#### 5B: Markdown Report

Write `factory/evaluations/eval-{TIMESTAMP}.md`:

```markdown
# Product Evaluation Report

**Project:** [name]
**Date:** [date]
**Cycle:** [N]
**Composite Score:** [X]/100

---

## Score Breakdown

| Dimension | Weight | Score | Weighted |
|-----------|--------|-------|----------|
| Conversion Funnel | 20% | [X]/25 | [Y] |
| Revenue Paths | 15% | [X]/5 | [Y] |
| UX / User Value | 20% | [X]/5 | [Y] |
| Performance | 15% | [X]/5 | [Y] |
| Accessibility | 10% | [X]/5 | [Y] |
| Product Completeness | 10% | [X]/5 | [Y] |
| Code Quality | 10% | [X]/5 | [Y] |
| **Total** | **100%** | | **[composite]** |

---

## User Journey Analysis

### [Persona 1]
[Journey walkthrough with friction at each step]
**Drop-off point:** [where and why]
**Recommendation:** [fix]

### [Persona 2]
...

---

## Top Issues (Ranked by Impact)

### 1. [Issue Title]
- **Category:** [dimension]
- **Impact:** [critical/high/medium/low]
- **Problem:** [description]
- **Estimated Lift:** [expected improvement]
- **Fix:** [recommended action]

### 2. ...

---

## Strengths
- [What's working well — preserve these]

---

## Score History
| Cycle | Score | Delta | Key Change |
|-------|-------|-------|------------|
| 0 (baseline) | [X] | — | Initial build |
```

---

### Step 6: Update Evolution State

1. Read `factory/evolution-state.json`
2. If this is cycle 0 (baseline), set:
   ```json
   {
     "baseline": {
       "evaluation_ref": "factory/evaluations/eval-{TIMESTAMP}.json",
       "composite_score": [score]
     }
   }
   ```
3. Update status to `"hypothesizing"` (signals that evaluation is complete)
4. Write back `factory/evolution-state.json`

---

### Step 7: Display Summary

Print a concise summary:

```
================================================================
  Product Evaluation Complete
================================================================

  Project:     [name]
  Cycle:       [N]
  Score:       [X]/100

  Top 3 Issues:
    1. [issue title] — [estimated lift]
    2. [issue title] — [estimated lift]
    3. [issue title] — [estimated lift]

  Output:
    JSON: factory/evaluations/eval-{TIMESTAMP}.json
    Report: factory/evaluations/eval-{TIMESTAMP}.md

  Next: Run /generate-hypotheses to create optimization proposals
================================================================
```

---

## Real Analytics Transition

When real analytics data is available, create `factory/analytics-config.json`:

```json
{
  "enabled": false,
  "provider": "vercel-analytics",
  "metrics": {
    "bounce_rate": { "weight": 0.3 },
    "signup_rate": { "weight": 0.4 },
    "time_on_page": { "weight": 0.3 }
  },
  "ai_weight": 1.0,
  "real_weight": 0.0
}
```

When `enabled: true`, this skill will attempt to fetch real metrics and blend them with AI scores using the specified weights. Manually adjust `ai_weight` and `real_weight` as real traffic accumulates.

---

## Error Recovery

| Scenario | Recovery |
|----------|----------|
| Can't read source files | Score dimensions you can assess, note gaps in report |
| No CLAUDE.md | Use directory name as project name, skip persona customization |
| No plans/ directory | Skip completeness dimension, adjust weights proportionally |
| Partial evaluation (context exhausted) | Runner re-invokes; check for partial eval file, resume from last dimension |
