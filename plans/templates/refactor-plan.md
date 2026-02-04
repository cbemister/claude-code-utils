---
title: [Refactor Title]
type: refactor
status: planning
created: YYYY-MM-DD
worktree: refactor-name
phases:
  - id: analysis
    status: pending
  - id: planning
    status: pending
  - id: implementation
    status: pending
  - id: migration
    status: pending
---

# Refactor: [Refactor Title]

## Motivation
[Why this refactoring is needed - tech debt, performance, maintainability, etc.]

## Current State
[Description of current implementation and its problems]

**Pain Points:**
- Pain point 1
- Pain point 2
- Pain point 3

**Metrics (if applicable):**
- Performance: [current metrics]
- Code complexity: [current metrics]
- Test coverage: [current percentage]

## Target State
[Description of desired end state after refactoring]

**Benefits:**
- Benefit 1
- Benefit 2
- Benefit 3

**Metrics (if applicable):**
- Performance: [target metrics]
- Code complexity: [target metrics]
- Test coverage: [target percentage]

---

## Success Criteria
- [ ] All existing functionality preserved
- [ ] Tests pass (no regressions)
- [ ] Performance maintained or improved
- [ ] Code is more maintainable
- [ ] Documentation updated
- [ ] Team reviewed and approved

---

## Phases

### Phase 1: Analysis
**Status:** Pending
**Estimated:** [X days]

**Objectives:**
- Understand current implementation
- Identify all affected code paths
- Assess impact and risk

**Tasks:**
- [ ] Map current architecture
- [ ] Identify all dependencies
- [ ] Document current behavior
- [ ] List all files to be modified
- [ ] Assess test coverage

**Outcome:** Complete understanding of current system

---

### Phase 2: Planning
**Status:** Pending
**Estimated:** [X days]

**Objectives:**
- Design new architecture
- Plan migration strategy
- Identify risks

**Tasks:**
- [ ] Design new architecture/patterns
- [ ] Plan step-by-step migration
- [ ] Identify breaking changes
- [ ] Plan rollback strategy
- [ ] Review plan with team

**Outcome:** Approved refactoring plan

---

### Phase 3: Implementation
**Status:** Pending
**Estimated:** [X days]

**Objectives:**
- Implement new architecture
- Maintain backward compatibility during transition
- Ensure tests pass throughout

**Tasks:**
- [ ] Implement new code
- [ ] Add tests for new code
- [ ] Update existing code incrementally
- [ ] Maintain backward compatibility layer (if needed)
- [ ] Code review

**Outcome:** New implementation ready for migration

---

### Phase 4: Migration
**Status:** Pending
**Estimated:** [X days]

**Objectives:**
- Fully transition to new implementation
- Remove old code
- Verify no regressions

**Tasks:**
- [ ] Migrate all usages to new code
- [ ] Remove old code/backward compatibility
- [ ] Update documentation
- [ ] Full regression testing
- [ ] Deploy and monitor

**Outcome:** Refactoring complete, old code removed

---

## Technical Details

### Files to Modify
- File 1: [path and description of changes]
- File 2: [path and description of changes]

### New Files to Create
- File 1: [path and description]
- File 2: [path and description]

### Files to Delete
- File 1: [path and reason]
- File 2: [path and reason]

### Architecture Changes
[Diagrams, descriptions, or explanations of architectural changes]

### API Changes
- Breaking changes (if any)
- Deprecated APIs
- New APIs

---

## Migration Strategy

### Incremental vs Big Bang
[Chosen approach and justification]

### Backward Compatibility
[How to maintain compatibility during transition, if applicable]

### Rollback Plan
[How to rollback if issues are discovered]

### Feature Flags
[Whether feature flags will be used to control rollout]

---

## Risks & Mitigations

| Risk | Impact | Probability | Mitigation |
|------|--------|-------------|------------|
| Breaking existing functionality | High | Medium | Comprehensive test coverage |
| Performance regression | Medium | Low | Benchmark before/after |
| [Other risks] | High/Med/Low | High/Med/Low | [Strategy] |

---

## Testing Strategy

### Existing Tests
- [ ] All existing tests pass
- [ ] No test modifications needed (or justified modifications)

### New Tests
- [ ] Unit tests for new code
- [ ] Integration tests
- [ ] Performance tests

### Manual Testing
- [ ] Test scenario 1
- [ ] Test scenario 2

---

## Open Questions
- [ ] Question 1
- [ ] Question 2

## Notes
[Any additional context, decisions, or considerations]

---

## Timeline
- **Start Date:** [YYYY-MM-DD]
- **Target Completion:** [YYYY-MM-DD]
- **Actual Completion:** [YYYY-MM-DD]
