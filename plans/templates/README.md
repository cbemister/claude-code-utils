# Plan Templates

Reusable templates for structured feature planning and development.

## Available Templates

### [feature-plan.md](./feature-plan.md)
Standard template for feature development with 4 phases:
- **Research** - Understand requirements and technical approach
- **Design** - Design data models, APIs, and UI
- **Implementation** - Build the feature
- **Testing** - Ensure quality and production-readiness

**Use for:**
- New features
- User-facing enhancements
- API development
- UI/UX work

**Example:**
```bash
/create-plan user-authentication
# or
/create-plan payment-integration --template=feature
```

---

### [bugfix-plan.md](./bugfix-plan.md)
Template for bug investigation and resolution with 3 phases:
- **Investigation** - Reproduce and identify root cause
- **Fix** - Implement the fix with tests
- **Verification** - Verify fix and prevent regressions

**Use for:**
- Bug fixes
- Production issues
- Regression fixes
- Critical patches

**Example:**
```bash
/create-plan login-failure --template=bugfix
```

---

### [refactor-plan.md](./refactor-plan.md)
Template for code refactoring with 4 phases:
- **Analysis** - Understand current implementation
- **Planning** - Design new architecture
- **Implementation** - Build new code
- **Migration** - Transition and remove old code

**Use for:**
- Technical debt reduction
- Architecture improvements
- Performance optimization
- Code modernization

**Example:**
```bash
/create-plan api-modernization --template=refactor
```

---

### [subplan-template.md](./subplan-template.md)
Template for individual phase sub-plans within a larger plan.

**Use for:**
- Breaking down complex phases
- Detailed phase tracking
- Collaborative work on specific phases
- Long-running phases requiring their own planning

**Example:**
```bash
/create-subplan research
# Creates: plans/active/feature-name/01-research.md
```

---

## Template Structure

All plan templates include:

### YAML Frontmatter
Metadata tracked by planning tools:
- `title` - Human-readable plan title
- `type` - Plan type (feature, bugfix, refactor, etc.)
- `status` - Current status (planning, in_progress, testing, complete)
- `created` - Creation date
- `worktree` - Linked worktree name
- `phases` - Array of phases with status

### Content Sections
- **Overview** - What and why
- **Success Criteria** - Checkboxes for completion
- **Phases** - Breakdown of work stages
- **Technical Details** - Implementation specifics
- **Risks & Mitigations** - Risk management
- **Open Questions** - Tracked questions
- **Timeline** - Dates and milestones

---

## Integration with Worktrees

Plans and worktrees work together:

1. **Create worktree with plan:**
   ```bash
   /worktree-create user-auth
   # Creates both worktree and plan
   ```

2. **Create plan first:**
   ```bash
   /create-plan user-auth
   # Edit plan
   /worktree-create user-auth
   # Creates worktree linked to plan
   ```

3. **Track progress:**
   ```bash
   /plan-status
   # Shows all active plans with progress
   ```

---

## Customizing Templates

### Creating Custom Templates

1. Copy an existing template
2. Modify phases and sections
3. Save as new template (e.g., `migration-plan.md`)
4. Reference in `/create-plan` command

### Template Variables

When creating plans from templates:
- `YYYY-MM-DD` → Replaced with current date
- `[Placeholders]` → Marked for manual completion
- `feature-name` → Replaced with provided feature name

---

## Best Practices

### Phase Breakdown
- **Research:** 10-20% of time
- **Design:** 15-25% of time
- **Implementation:** 40-50% of time
- **Testing:** 20-30% of time

### Task Granularity
- Each task should be < 4 hours
- Use checkboxes for visibility
- Link to specific files/PRs

### Success Criteria
- Should be testable/verifiable
- Include non-functional requirements
- Think about edge cases

### Status Updates
- Update `status` field as you progress
- Check off tasks as completed
- Add notes for important decisions

---

## Plan Workflow

```
1. Create Plan
   /create-plan feature-name [--template=TYPE]
   ↓
2. Edit Plan
   Fill in placeholders, define success criteria
   ↓
3. Create Worktree
   /worktree-create feature-name
   ↓
4. Work & Update
   Check off tasks, update status, add notes
   ↓
5. Check Status
   /plan-status feature-name
   ↓
6. Complete & Archive
   Move to plans/archived/ after merge
```

---

## Directory Structure

```
plans/
├── templates/              # Template files
│   ├── README.md
│   ├── feature-plan.md
│   ├── bugfix-plan.md
│   ├── refactor-plan.md
│   └── subplan-template.md
├── active/                 # Active plans
│   └── feature-name/
│       ├── plan.md         # Master plan
│       ├── 01-research.md  # Phase sub-plan
│       └── 02-design.md
└── archived/               # Completed plans
    └── feature-name-20260204/
        └── plan.md
```

---

## Tips

**Keep Plans Updated:**
- Update immediately after completing tasks
- Don't wait until end of day
- Real-time status is most useful

**Use Checkboxes:**
- Visible progress tracking
- Easy to see what's left
- Satisfying to check off

**Document Decisions:**
- Add notes section for key decisions
- Future you will thank you
- Helps with onboarding

**Link to Code:**
- Reference specific files and line numbers
- Link to PRs and commits
- Connect plan to implementation

---

## Questions?

See main documentation:
- [Getting Started Guide](../../docs/guides/getting-started.md)
- [Worktree Workflow](../../docs/best-practices/worktree-workflow.md)
- [Plan System](../../README.md)
