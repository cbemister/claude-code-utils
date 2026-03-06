---
title: [Bug Title]
type: bugfix
status: investigating
severity: high | medium | low
created: YYYY-MM-DD
worktree: fix-name
phases:
  - id: investigation
    status: pending
  - id: fix
    status: pending
  - id: verification
    status: pending
---

# Bug: [Bug Title]

## Problem Description
[Clear description of the bug and its impact]

## Reproduction Steps
1. Step 1
2. Step 2
3. Step 3

**Expected:** [What should happen]
**Actual:** [What actually happens]

## Impact
- **Users Affected:** [All users, specific segment, etc.]
- **Severity:** [High/Medium/Low]
- **Business Impact:** [Revenue, UX, reputation, etc.]

---

## Investigation

### Symptoms
- Symptom 1
- Symptom 2

### Root Cause
[To be determined — use `debugger` or `performance-analyst` agent]

**Affected Code Paths:**
- [file:line]

---

## Fix Plan

### Phase 1: Investigation
**Status:** Pending

**Tasks:**
- [ ] Reproduce bug locally
- [ ] Use `debugger` agent to identify root cause
- [ ] Assess scope of fix (isolated vs systemic)
- [ ] Check if security-auditor review is needed

**Outcome:** Clear root cause and fix strategy

---

### Phase 2: Implementation
**Status:** Pending

**Tasks:**
- [ ] Implement fix
- [ ] Add regression test for this exact bug (`test-engineer` agent)
- [ ] Review related code for similar issues
- [ ] Code review (`code-reviewer` agent)

**Outcome:** Bug fixed with regression test coverage

---

### Phase 3: Verification
**Status:** Pending

**Tasks:**
- [ ] Verify fix locally
- [ ] Run full test suite
- [ ] Deploy to staging and verify
- [ ] Monitor after production deploy

**Outcome:** Confirmed fix without regressions

---

## Solution
[Description of the fix once implemented]

### Code Changes
[Files modified and key changes]

### Test Coverage Added
[Regression tests added]

---

## Prevention
[How to prevent similar bugs — process, type safety, monitoring]

## Timeline
- **Discovered:** [YYYY-MM-DD]
- **Fix Deployed:** [YYYY-MM-DD]
- **Verified Fixed:** [YYYY-MM-DD]
