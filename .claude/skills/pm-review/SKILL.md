---
name: pm-review
description: Product manager perspective — assess current product state against the plan, verify what's actually built, identify gaps, and recommend what to build next ordered by user impact.
---

# PM Review Skill

Evaluates the current state of the product from a product manager's perspective. Verifies actual progress against the plan, identifies what's truly shippable vs partial vs stubbed, and recommends priorities for the next work session.

## When to Use

- Starting a new development session to orient on what matters most
- After completing a phase to assess readiness for the next
- When deciding what to build next
- Manual invocation with `/pm-review`

## Behavior

- **Non-interactive**: Researches and reports — no prompts
- **Evidence-based**: Verifies claims by reading actual code, not just plan files
- **Opinionated**: Recommends specific priorities, doesn't just list options

## Instructions

> **CRITICAL — NON-INTERACTIVE**: Run every step to completion without pausing. Never ask questions, request confirmation, offer choices, or wait for input. Research and report.

### Step 1: Read the Plan

Read the project's planning documents to understand the intended roadmap:

```bash
# Find plan files
ls plan/ 2>/dev/null || ls docs/plan/ 2>/dev/null
```

Read:
- Master plan file (e.g., `plan/plan.md`)
- The current phase's detailed plan
- The next phase's detailed plan (to understand what's coming)
- CLAUDE.md for locked conventions and rules

Also read memory files if they exist (session summaries, MEMORY.md) for recent context.

### Step 2: Verify Actual State

Don't trust phase status claims — verify by checking what actually exists in the codebase.

```bash
# Recent development activity
git log --oneline -30

# Current branch status
git status --short

# What pages/routes exist
find src/app -name "page.tsx" -o -name "route.ts" 2>/dev/null
```

For each feature the plan claims is "complete", spot-check:
- Does the page/component file exist?
- Does it have real implementation (not placeholder/stub)?
- Does it have an API route if it needs one?
- Is there actual UI (not just a "Coming soon" message)?

### Step 3: Assess Each Area

#### 3.1 Phase Progress
Map the plan's phases to actual implementation status:

| Phase | Claimed | Verified | Notes |
|-------|---------|----------|-------|
| ... | ... | ... | ... |

Use these statuses:
- **Complete**: Feature is fully functional, tested (if tests exist), production-ready
- **Functional**: Works but has rough edges, missing polish, or no tests
- **Partial**: Core logic exists but significant pieces are missing
- **Stubbed**: File exists but contains placeholder content
- **Missing**: Doesn't exist yet

#### 3.2 MVP Readiness
If the project has an MVP milestone, assess:
- What's required for MVP to ship?
- What's actually done?
- What's the gap?
- Are there blockers?

#### 3.3 Scope Creep Check
Look for work that doesn't belong in the current phase:
- Features from future phases that were started early
- Unnecessary abstractions or premature optimization
- "Nice to have" additions that aren't in any plan

### Step 4: Identify User Value Gaps

Think from the end user's perspective:
- What would make the biggest difference to someone using this today?
- Are there rough edges that undermine trust (broken flows, missing feedback)?
- Is there a critical path that's incomplete?

### Step 5: Assess Technical Health

Quick scan for issues that could block future work:
- Accumulating tech debt (TODOs, hacks, workarounds)
- Missing error handling in critical paths
- Schema changes needed before next phase
- Dependencies that need updating

```bash
# Count TODOs and FIXMEs
grep -r "TODO\|FIXME\|HACK\|XXX" src/ --include="*.ts" --include="*.tsx" -c 2>/dev/null
```

### Step 6: Recommend Priorities

Based on all the above, recommend the top 3-5 priorities for the next work session. Order by:
1. **Blockers first**: Anything preventing the MVP/current phase from shipping
2. **User impact**: What delivers the most value to end users
3. **Technical risk**: What reduces risk of future rework
4. **Quick wins**: High-value, low-effort items

### Step 7: Present Report

```markdown
## PM Review

### Product Status
Phase X of Y — [1-2 sentence summary of where things stand]

### Progress Verification

| Feature | Plan Status | Actual Status | Notes |
|---------|-------------|---------------|-------|
| ... | ... | ... | ... |

### MVP Gap Analysis
**Ready to ship?** Yes / No — [reason]

Missing for MVP:
- [Gap] — [effort estimate: small/medium/large]

### Scope Check
- [Any out-of-phase work detected, or "Clean — all work is within current phase"]

### Recommended Next Priorities
1. **[Priority]** — [why this matters most] — [effort: S/M/L]
2. **[Priority]** — [why] — [effort]
3. **[Priority]** — [why] — [effort]

### Technical Health
- TODOs/FIXMEs: N found
- [Any concerning patterns or blockers]

### Risks
- [Risk] — [mitigation]
```

---

## Notes

- This skill reads code but never modifies it
- Effort estimates are rough: S = hours, M = a session, L = multiple sessions
- The "Verified" status matters more than the "Claimed" status — always check the actual files
- Enforce project rules (e.g., MVP boundary, no tech stack changes) in recommendations
- If the project has a locked phase plan, don't recommend skipping ahead
- Be direct about what's not ready — sugar-coating wastes the developer's time
