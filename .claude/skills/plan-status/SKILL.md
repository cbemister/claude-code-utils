---
name: plan-status
description: Show current status and progress of active feature plans. Pass a stage filename to refresh it against the current codebase.
argument-hint: "[feature-name] | refresh <stage-file>"
---

# Plan Status

Display current status and progress for active feature plans.

## When to Use

Use this when:
- Want to see all active plans at a glance
- Need to check progress on a specific feature
- Daily standup / status review
- Deciding what to work on next

## Usage

```
/plan-status                          — show all active plans
/plan-status <feature-name>           — show details for specific plan
/plan-status refresh <stage-file>     — refresh a stage plan against current codebase
```

## Instructions

If first argument is `refresh`, run the **Refresh Stage Plan** flow below.
Otherwise, run the standard plan status display.

### Refresh Stage Plan (when `refresh <stage-file>` is passed)

Refreshes a stage plan to account for decisions and changes made during prior stages.

1. Find and read the stage plan file at `plans/active/$STAGE_FILE.md` (add `.md` if not present; also check `plans/archive/`)
2. Read the master plan at `plans/README.md`
3. Read completed stage plans from `plans/archive/` to understand what was actually built
4. Read project conventions: `CLAUDE.md`, `.claude/rules/architecture.md`, `.claude/rules/api-conventions.md`
5. Scan the actual codebase: list key source directories, grep for exported interfaces/types/functions this stage depends on, look at established patterns and test utilities
6. Compare the stage plan against reality — identify drift in file paths, imports, interfaces, dependencies, and architectural decisions
7. Rewrite the stage plan file with corrections: update file paths, imports, code snippets, test code, and verification commands to reflect the real codebase
8. Display summary of what changed:
   ```
   Stage [N] plan refreshed:
   Updated:
     - [task]: [what changed]
   Architecture notes:
     - [any decisions from prior stages that affect this stage]
   ```

---

### Without Feature Name: Show All Plans

```bash
echo "📋 Active Feature Plans"
echo "======================"
echo ""

# Check if plans directory exists
if [ ! -d "plans/active" ] || [ -z "$(ls -A plans/active 2>/dev/null)" ]; then
  echo "No active plans found"
  echo ""
  echo "Create a plan with: /create-plan <feature-name>"
  exit 0
fi

# Iterate through active plans
for plan_dir in plans/active/*; do
  if [ -d "$plan_dir" ]; then
    FEATURE_NAME=$(basename "$plan_dir")
    PLAN_FILE="$plan_dir/plan.md"

    if [ -f "$PLAN_FILE" ]; then
      # Extract frontmatter
      TITLE=$(grep "^title:" "$PLAN_FILE" | sed 's/title: *//')
      STATUS=$(grep "^status:" "$PLAN_FILE" | sed 's/status: *//')
      TYPE=$(grep "^type:" "$PLAN_FILE" | sed 's/type: *//')

      # Count completed phases
      TOTAL_PHASES=$(grep -c "  - id:" "$PLAN_FILE" || echo "0")
      COMPLETED_PHASES=$(grep "status: completed" "$PLAN_FILE" | wc -l || echo "0")

      # Status emoji
      case "$STATUS" in
        planning) STATUS_EMOJI="📝" ;;
        in_progress) STATUS_EMOJI="🚧" ;;
        testing) STATUS_EMOJI="🧪" ;;
        complete) STATUS_EMOJI="✅" ;;
        *) STATUS_EMOJI="❓" ;;
      esac

      echo "$STATUS_EMOJI  $FEATURE_NAME"
      echo "    Title: $TITLE"
      echo "    Status: $STATUS"
      echo "    Progress: $COMPLETED_PHASES/$TOTAL_PHASES phases"

      # Check for linked worktree
      if [ -d "worktrees/$FEATURE_NAME" ]; then
        echo "    Worktree: ✅ worktrees/$FEATURE_NAME"
      fi

      echo ""
    fi
  fi
done

echo "========================"
echo "Use: /plan-status <name> for details"
```

### With Feature Name: Show Detailed Status

```bash
FEATURE_NAME="$1"
PLAN_DIR="plans/active/$FEATURE_NAME"
PLAN_FILE="$PLAN_DIR/plan.md"

# Check if plan exists
if [ ! -f "$PLAN_FILE" ]; then
  echo "❌ Plan not found: $PLAN_FILE"
  echo ""
  echo "Available plans:"
  ls -1 plans/active/ 2>/dev/null || echo "  (none)"
  exit 1
fi

# Parse frontmatter
TITLE=$(grep "^title:" "$PLAN_FILE" | sed 's/title: *//')
STATUS=$(grep "^status:" "$PLAN_FILE" | sed 's/status: *//')
TYPE=$(grep "^type:" "$PLAN_FILE" | sed 's/type: *//')
CREATED=$(grep "^created:" "$PLAN_FILE" | sed 's/created: *//')

# Display header
echo "📋 Plan: $TITLE"
echo "========================================"
echo "Feature: $FEATURE_NAME"
echo "Type: $TYPE"
echo "Status: $STATUS"
echo "Created: $CREATED"
echo ""

# Show phases
echo "Phases:"
echo "-------"

# Extract phase information
awk '
  /^phases:/ { in_phases=1; next }
  in_phases && /^  - id:/ {
    id=$3
    getline; status=$3
    printf "  %s: %s\n", id, status
  }
  /^---/ && in_phases { exit }
' "$PLAN_FILE"

echo ""

# Count tasks
TOTAL_TASKS=$(grep -c "^\- \[ \]" "$PLAN_FILE" || echo "0")
COMPLETED_TASKS=$(grep -c "^\- \[x\]" "$PLAN_FILE" || echo "0")

echo "Tasks:"
echo "------"
echo "Total: $TOTAL_TASKS"
echo "Completed: $COMPLETED_TASKS"
if [ "$TOTAL_TASKS" -gt 0 ]; then
  PERCENT=$((COMPLETED_TASKS * 100 / TOTAL_TASKS))
  echo "Progress: $PERCENT%"

  # Progress bar
  BAR_WIDTH=20
  FILLED=$((PERCENT * BAR_WIDTH / 100))
  EMPTY=$((BAR_WIDTH - FILLED))
  printf "["
  printf "%${FILLED}s" | tr ' ' '█'
  printf "%${EMPTY}s" | tr ' ' '░'
  printf "] $PERCENT%%\n"
fi

echo ""

# Show open questions
OPEN_QUESTIONS=$(grep "^## Open Questions" -A 100 "$PLAN_FILE" | grep "^\- \[ \]" | wc -l)
if [ "$OPEN_QUESTIONS" -gt 0 ]; then
  echo "⚠️  Open Questions: $OPEN_QUESTIONS"
  echo ""
fi

# Show success criteria
echo "Success Criteria:"
echo "-----------------"
grep "^## Success Criteria" -A 20 "$PLAN_FILE" | grep "^\- \[" | head -5

echo ""

# Worktree status
if [ -d "worktrees/$FEATURE_NAME" ]; then
  echo "Worktree: ✅ worktrees/$FEATURE_NAME"
  cd "worktrees/$FEATURE_NAME"
  BRANCH=$(git branch --show-current)
  COMMITS=$(git log --oneline origin/main..HEAD 2>/dev/null | wc -l || echo "0")
  echo "Branch: $BRANCH"
  echo "Commits: $COMMITS"
  cd - > /dev/null
else
  echo "Worktree: ❌ Not created"
  echo "Create with: /worktree-create $FEATURE_NAME"
fi

echo ""
echo "========================================"
echo "Plan file: $PLAN_FILE"
```

## Example Usage

**Show all plans:**
```bash
/plan-status
```

Output:
```
📋 Active Feature Plans
======================

🚧  user-authentication
    Title: User Authentication System
    Status: in_progress
    Progress: 2/4 phases
    Worktree: ✅ worktrees/user-authentication

📝  payment-integration
    Title: Stripe Payment Integration
    Status: planning
    Progress: 0/3 phases

========================
Use: /plan-status <name> for details
```

**Show specific plan details:**
```bash
/plan-status user-authentication
```

Output:
```
📋 Plan: User Authentication System
========================================
Feature: user-authentication
Type: feature
Status: in_progress
Created: 2026-02-04

Phases:
-------
  research: completed
  design: completed
  implementation: in_progress
  testing: pending

Tasks:
------
Total: 18
Completed: 12
Progress: 66%
[█████████████░░░░░░░] 66%

Success Criteria:
-----------------
- [x] Users can sign up with email/password
- [x] Users can log in
- [ ] Password reset works
- [ ] Session management secure
- [ ] Tests pass

Worktree: ✅ worktrees/user-authentication
Branch: feature/user-authentication
Commits: 8

========================================
Plan file: plans/active/user-authentication/plan.md
```

## Status Dashboard View

For a quick team dashboard, you can create an alias:

```bash
alias plans='/plan-status'

# Show all plans
plans

# Show specific plan
plans user-auth
```

## Status Meanings

| Status | Emoji | Meaning |
|--------|-------|---------|
| `planning` | 📝 | Defining requirements, not started coding |
| `in_progress` | 🚧 | Active development |
| `testing` | 🧪 | Development complete, testing in progress |
| `review` | 👀 | In code review |
| `complete` | ✅ | Done and merged |
| `blocked` | 🛑 | Waiting on dependency |
| `paused` | ⏸️  | Temporarily stopped |

## Integration with Git

**Update status based on branch activity:**

```bash
# After making progress
cd worktrees/feature-name
# ... make changes ...
# Update plan status
sed -i 's/status: planning/status: in_progress/' plans/active/feature-name/plan.md
```

## Best Practices

**Daily Routine:**
1. Run `/plan-status` each morning
2. Review open questions
3. Update phase status as you progress
4. Mark tasks complete as you go

**Weekly Routine:**
1. Review all active plans
2. Archive completed plans
3. Re-prioritize if needed
4. Update estimates based on progress

**Status Updates:**
- Update `status:` field in frontmatter
- Update `phases[].status` as you complete each
- Check off `- [ ]` tasks as you finish them
- Add notes in the plan for important decisions

## Tips

**Keep Plans Updated:**
- Update immediately after completing phases
- Don't wait until end of day
- Real-time status is most useful

**Use with Stand-ups:**
- Quick overview of all active work
- Shows what's blocked
- Identifies what needs attention

**Tracking Progress:**
- Checkbox completion = task level
- Phase status = milestone level
- Overall status = project level

## Advanced: Auto-Update from Git

```bash
# Hook to update plan when pushing commits
# .git/hooks/pre-push

BRANCH=$(git branch --show-current)
FEATURE_NAME=$(echo $BRANCH | sed 's/feature\///')
PLAN_FILE="plans/active/$FEATURE_NAME/plan.md"

if [ -f "$PLAN_FILE" ]; then
  # Auto-update to in_progress if was planning
  sed -i 's/status: planning/status: in_progress/' "$PLAN_FILE"
fi
```

## Troubleshooting

**Plan not showing:**
- Check file is in `plans/active/`
- Verify `plan.md` exists
- Check YAML frontmatter is valid

**Progress not accurate:**
- Use consistent checkbox format: `- [ ]` and `- [x]`
- Don't use custom checkbox formats
- Ensure phases array in frontmatter is updated

**Worktree status wrong:**
- Verify worktree exists in `worktrees/`
- Check naming matches plan directory
- Use `/worktree-create` if missing
