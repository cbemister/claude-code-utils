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

### Initial Findings
- Finding 1
- Finding 2

### Root Cause
[To be determined during investigation]

**Affected Code Paths:**
- File 1: [file path]
- File 2: [file path]

---

## Fix Plan

### Phase 1: Investigation
**Status:** Pending
**Estimated:** [X hours/days]

**Tasks:**
- [ ] Reproduce bug locally
- [ ] Identify root cause
- [ ] Document affected code paths
- [ ] Assess scope of fix
- [ ] Review related code for similar issues

**Outcome:** Clear understanding of root cause and fix strategy

---

### Phase 2: Implementation
**Status:** Pending
**Estimated:** [X hours/days]

**Tasks:**
- [ ] Implement fix
- [ ] Add regression test for this bug
- [ ] Update related code if needed
- [ ] Code review
- [ ] Update documentation if needed

**Outcome:** Bug fixed with test coverage

---

### Phase 3: Verification
**Status:** Pending
**Estimated:** [X hours/days]

**Tasks:**
- [ ] Verify fix works locally
- [ ] Run full test suite
- [ ] Deploy to staging
- [ ] QA verification
- [ ] Monitor after production deploy

**Outcome:** Confidence that bug is fixed without regressions

---

## Solution
[Description of the fix once implemented]

### Code Changes
- Files modified
- Key changes made
- Why this approach

### Test Coverage
- Unit tests added
- Integration tests added
- Manual test scenarios

---

## Prevention
[How to prevent similar bugs in the future]

### Process Improvements
- Code review checklist items
- Testing strategies
- Monitoring/alerting

### Technical Improvements
- Refactoring opportunities
- Type safety additions
- Validation improvements

---

## Related Issues
- [Link to related bugs/issues]
- [Link to original bug report]

---

## Timeline
- **Discovered:** [YYYY-MM-DD]
- **Investigation Started:** [YYYY-MM-DD]
- **Fix Deployed:** [YYYY-MM-DD]
- **Verified Fixed:** [YYYY-MM-DD]
