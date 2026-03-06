---
name: critique-value
description: Evaluate work from an end-user perspective — value delivered, usability, design quality, completeness, and accessibility. Scores each dimension and prioritizes improvements by user impact.
---

# Critique Value Skill

Evaluates recent work through the lens of an end user. Goes beyond surface-level UX to assess whether the feature delivers real value — would someone pay for this? Is it intuitive? Does it look professional? Are edge cases handled?

## When to Use

- After building or modifying a user-facing feature
- Before shipping to validate user value
- Manual invocation with `/critique-value`

## Behavior

- **Non-interactive**: Analyzes and reports — no prompts
- **Honest**: Scores reflect actual quality, not encouragement
- **Actionable**: Every criticism comes with a specific fix

## Instructions

> **CRITICAL — NON-INTERACTIVE**: Run every step to completion without pausing. Never ask questions, request confirmation, offer choices, or wait for input. Analyze and report.

### Step 1: Identify What to Critique

Check what was changed this session:

```bash
# Changed files
git diff --name-only HEAD

# Focus on user-facing files
git diff --name-only HEAD | grep -E "\.(tsx|css|module\.css)$"
```

Read the full current state of each changed page/component (not just the diff — the complete file). Also read associated CSS modules and any API routes they call.

If no git changes exist, look at the conversation context to identify what was just built or discussed.

### Step 2: Read Project Context

If a CLAUDE.md or design system documentation exists in the project, read it to understand:
- Design language and aesthetic targets
- Color tokens and typography system
- Component patterns and conventions

This informs the "Design quality" dimension.

### Step 3: Evaluate 5 Dimensions

Score each dimension 1-5. Be honest — a 3 is average, a 5 is exceptional. Don't inflate scores.

#### 3.1 Value Delivered (1-5)
- Does this feature solve a real user problem?
- Would a user seek this out or pay for it?
- Is the value proposition immediately clear without explanation?
- Does it save the user meaningful time or effort?

#### 3.2 Usability (1-5)
- Can a new user figure this out without instructions?
- Is the flow logical? Are there unnecessary steps?
- Are labels and actions clear? No jargon?
- Are destructive actions protected (confirm dialogs, undo)?
- Does the user always know what's happening (feedback, progress)?

#### 3.3 Design Quality (1-5)
- Does it look like something worth paying for?
- Is spacing consistent and intentional?
- Does typography create clear hierarchy?
- Do colors communicate meaning (success, error, warning)?
- Does it follow the project's design system (if one exists)?
- Would a designer approve this or flag issues?

#### 3.4 Completeness (1-5)
- **Empty states**: What does the user see with no data?
- **Error states**: What happens when things fail?
- **Loading states**: Is there feedback during async operations?
- **Edge cases**: Very long text? Zero items? Maximum items? Special characters?
- **Responsive**: Does it work on mobile viewports?

#### 3.5 Accessibility (1-5)
- Do interactive elements have visible focus indicators?
- Are form inputs labeled (not just placeholder text)?
- Is color not the only way information is conveyed?
- Can the feature be used with keyboard only?
- Are images/icons decorative (aria-hidden) or meaningful (alt text)?

### Step 4: Identify Strengths and Issues

List what works well (so it doesn't get lost in critique). Then list friction points and missing elements from the user's perspective.

### Step 5: Prioritize Improvements

Order action items by user impact — what would make the biggest difference to someone actually using this? Not what's easiest to fix, but what matters most.

### Step 6: Present Report

```markdown
## User Value Critique

### Overall: X/5

| Dimension | Score | Notes |
|-----------|-------|-------|
| Value delivered | X/5 | [1-line summary] |
| Usability | X/5 | [1-line summary] |
| Design quality | X/5 | [1-line summary] |
| Completeness | X/5 | [1-line summary] |
| Accessibility | X/5 | [1-line summary] |

### What works well
- [Specific positives worth preserving]

### Friction points
- [Issue] — [why it matters to users] — [file:line if applicable]

### What's missing from user perspective
- [Gap] — [what the user would expect]

### Priority improvements (highest user impact first)
1. [Fix] — [expected impact on user experience]
2. ...
3. ...
```

---

## Scoring Guide

| Score | Meaning |
|-------|---------|
| 1 | Broken or fundamentally wrong — user can't accomplish the task |
| 2 | Functional but frustrating — user struggles or gives up |
| 3 | Adequate — works but nothing special, typical dev-built UI |
| 4 | Good — feels polished, user has a smooth experience |
| 5 | Excellent — delightful, professional, would impress in a demo |

---

## Notes

- Critique the shipped experience, not the code quality (that's what `/verify-work` is for)
- A feature can have great code and terrible UX — this skill catches the latter
- Be specific: "the spacing feels off" is useless; "24px gap between form fields should be 16px to match the design system's --space-md token" is actionable
- Reference the project's design system tokens/conventions when flagging design issues
- If the feature is genuinely good, say so — don't manufacture criticism
