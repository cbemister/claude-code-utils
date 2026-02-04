# Git Worktree Workflow

A comprehensive guide to using git worktrees for parallel feature development with integrated planning.

## What are Git Worktrees?

Git worktrees allow you to have multiple working directories (checkouts) of the same repository simultaneously. Each worktree can be on a different branch.

**Traditional Workflow:**
```
project/
├── .git/
├── src/
└── ...
```

**Worktree Workflow:**
```
project/
├── .git/
├── main/              # Main worktree
│   ├── src/
│   └── ...
└── worktrees/         # Feature worktrees
    ├── feature-auth/
    │   ├── src/
    │   └── ...
    └── feature-payments/
        ├── src/
        └── ...
```

---

## Why Use Worktrees?

### Benefits

**1. Parallel Development**
- Work on multiple features simultaneously
- No need to stash or commit half-done work
- Switch contexts instantly (just `cd`)

**2. Clean Separation**
- Each feature has its own directory
- No mixing of changes
- Clear organization

**3. Fast Context Switching**
- No `git checkout` delays
- No node_modules reinstalls
- IDE state preserved per worktree

**4. PR Reviews**
- Check out PR in separate worktree
- Compare with main easily
- Test without disrupting current work

**5. Hot Fixes**
- Create hotfix worktree from main
- Fix and deploy without touching feature work
- Return to feature work instantly

---

## When to Use Worktrees

### ✅ Good Use Cases

- **Long-running features** (multiple days/weeks)
- **Parallel feature development** (working on 2+ features)
- **PR reviews** (check out PR without disrupting work)
- **Hot fixes** (urgent fix while feature in progress)
- **Experimentation** (try approach without committing)
- **Comparison** (compare implementations side-by-side)

### ❌ When NOT to Use

- **Quick one-commit fixes** (just use regular git)
- **Sequential work** (finish one feature before starting next)
- **Disk space concerns** (worktrees duplicate the working directory)
- **Simple projects** (overhead not worth it)

---

## Worktree + Plan Integration

This repository integrates worktrees with planning:

```
project/
├── worktrees/
│   └── feature-auth/        # Worktree for feature
│       ├── src/
│       └── ...
└── plans/
    └── active/
        └── feature-auth/     # Plan for same feature
            ├── plan.md
            ├── 01-research.md
            └── 02-implementation.md
```

**Benefits:**
- Worktree name matches plan directory
- Easy to find plan for current worktree
- Plan persists after worktree cleanup
- Track progress alongside code

---

## Basic Workflow

### 1. Create Feature Worktree

```bash
/worktree-create feature-name
```

This creates:
- `worktrees/feature-name/` - New worktree
- `feature/feature-name` - New branch
- `plans/active/feature-name/plan.md` - Initial plan

**Output:**
```
✅ Worktree created successfully!

📁 Location: worktrees/feature-name
🌿 Branch: feature/feature-name
📋 Plan: plans/active/feature-name/plan.md

Next steps:
1. cd worktrees/feature-name
2. Edit plans/active/feature-name/plan.md
3. Start working on your feature
```

---

### 2. Work in Worktree

```bash
cd worktrees/feature-name
```

Now you're in an isolated working directory:
- Make changes
- Commit regularly
- Push to remote
- All while main worktree is untouched

---

### 3. Update Plan

```bash
/plan-status feature-name
```

Track your progress:
- Check off completed tasks
- Update phase status
- Add notes and decisions

---

### 4. Sync with Main

Periodically sync with main branch:

```bash
cd worktrees/feature-name
/worktree-sync
```

This:
- Fetches latest from origin
- Rebases your feature on origin/main
- Keeps feature branch up to date

---

### 5. Create Pull Request

When ready:

```bash
cd worktrees/feature-name
git push -u origin feature/feature-name
gh pr create
```

Or use the commit-push-pr skill:
```bash
/commit-push-pr
```

---

### 6. Clean Up

After PR is merged:

```bash
/worktree-cleanup feature-name
```

This:
- Removes worktree directory
- Deletes local branch
- Optionally archives plan
- Optionally deletes remote branch

---

## Advanced Workflows

### Multiple Features in Parallel

```bash
# Start feature 1
/worktree-create user-auth
cd worktrees/user-auth
# Work on auth...

# Start feature 2 (from main worktree)
cd ~/project
/worktree-create payment-integration
cd worktrees/payment-integration
# Work on payments...

# Switch between them
cd ~/project/worktrees/user-auth      # Back to auth
cd ~/project/worktrees/payment-integration  # Back to payments
```

**Benefits:**
- No git checkout delays
- Separate node_modules per feature
- IDE remembers state per worktree
- No context switching overhead

---

### PR Review Workflow

```bash
# Checkout PR #123 for review
gh pr checkout 123
# Creates worktree: worktrees/pr-123

cd worktrees/pr-123
# Review code
# Run tests
# Make comments

# Clean up when done
cd ~/project
/worktree-cleanup pr-123
```

---

### Hot Fix While Working

```bash
# Currently working on feature
cd worktrees/feature-auth

# Urgent bug reported!
cd ~/project
/worktree-create hotfix-login-bug main
cd worktrees/hotfix-login-bug

# Fix bug
# Test
# Commit
# Push and create PR

# Back to feature work
cd ~/project/worktrees/feature-auth
# Continue where you left off
```

---

### Experimentation

```bash
# Try a different approach
/worktree-create experiment-new-architecture

cd worktrees/experiment-new-architecture
# Try experimental changes

# If it doesn't work out
cd ~/project
/worktree-cleanup experiment-new-architecture --force
# No trace left, back to main approach
```

---

## Directory Organization

### Recommended Structure

```
project/
├── .git/
├── main/                   # Main worktree (optional)
│   ├── src/
│   └── ...
├── worktrees/              # All feature worktrees
│   ├── feature-auth/
│   ├── feature-payments/
│   └── hotfix-bug-123/
└── plans/
    ├── active/             # Active feature plans
    │   ├── feature-auth/
    │   └── feature-payments/
    └── archived/           # Completed plans
        └── old-feature-20260204/
```

---

### Naming Conventions

**Worktrees:**
- `feature-name` - New features
- `fix-name` - Bug fixes
- `refactor-name` - Refactoring
- `experiment-name` - Experiments
- `pr-123` - PR reviews

**Branches:**
- `feature/feature-name`
- `fix/fix-name`
- `refactor/refactor-name`
- `experiment/experiment-name`

**Plans:**
- Same name as worktree
- Stored in `plans/active/{name}/`

---

## Best Practices

### 1. One Worktree Per Feature

Don't create too many worktrees:
- 2-4 active worktrees is manageable
- More than 5 gets confusing
- Clean up completed ones regularly

---

### 2. Keep Worktrees Synced

Sync with main branch regularly:

```bash
# Daily or before each work session
cd worktrees/feature-name
/worktree-sync
```

**Benefits:**
- Avoid merge conflicts later
- Catch integration issues early
- Keep branch up to date

---

### 3. Commit Regularly

Don't let worktrees get stale:
- Commit at least daily
- Push to remote frequently
- Don't leave uncommitted changes

---

### 4. Clean Up Promptly

Remove worktrees after PR merge:

```bash
# Immediately after merge
/worktree-cleanup feature-name
```

**Why:**
- Frees disk space
- Keeps workspace organized
- Prevents confusion

---

### 5. Use Plans

Update plan as you work:

```bash
/plan-status feature-name
```

- Check off completed tasks
- Update phase status
- Add notes about decisions

---

### 6. Separate node_modules

Each worktree has its own dependencies:

```bash
cd worktrees/feature-auth
npm install
# Separate node_modules from other worktrees
```

**Benefits:**
- Different dependency versions if needed
- No conflicts between worktrees
- Can test dependency upgrades in isolation

---

## Common Scenarios

### Scenario 1: Feature Development

```bash
# Day 1: Start feature
/worktree-create user-profile
cd worktrees/user-profile
# Edit plan
vim ../plans/active/user-profile/plan.md
# Start coding
git add .
git commit -m "Initial user profile structure"
git push -u origin feature/user-profile

# Day 2: Continue work
cd worktrees/user-profile
/worktree-sync  # Get latest from main
# Code more
git commit -m "Add profile editing"
git push

# Day 3: Ready for review
git push
gh pr create
/plan-status user-profile  # Check everything done

# Day 4: PR merged
cd ~/project
/worktree-cleanup user-profile
```

---

### Scenario 2: Urgent Hot Fix

```bash
# Working on feature
cd worktrees/big-feature

# Bug reported!
cd ~/project
/worktree-create hotfix-critical-bug main
cd worktrees/hotfix-critical-bug

# Fix
git add .
git commit -m "Fix critical bug in authentication"
git push -u origin feature/hotfix-critical-bug
gh pr create --title "HOTFIX: Auth bug"

# PR approved and merged
cd ~/project
/worktree-cleanup hotfix-critical-bug

# Back to feature work
cd worktrees/big-feature
/worktree-sync  # Get the hotfix
# Continue feature work
```

---

### Scenario 3: Compare Approaches

```bash
# Original approach
cd worktrees/feature-search

# Try alternative
cd ~/project
/worktree-create experiment-search-algorithm
cd worktrees/experiment-search-algorithm
# Implement alternative

# Compare
diff -r ../feature-search/src ../experiment-search-algorithm/src

# If better
cd ~/project
/worktree-cleanup feature-search
mv worktrees/experiment-search-algorithm worktrees/feature-search

# If worse
/worktree-cleanup experiment-search-algorithm
cd worktrees/feature-search
```

---

## Troubleshooting

### Problem: Worktree Already Exists

```
Error: fatal: 'worktrees/feature-name' already exists
```

**Solutions:**
```bash
# Option 1: Use existing worktree
cd worktrees/feature-name

# Option 2: Remove and recreate
/worktree-cleanup feature-name
/worktree-create feature-name
```

---

### Problem: Branch Conflict

```
Error: fatal: a branch named 'feature/feature-name' already exists
```

**Solutions:**
```bash
# Check existing branches
git branch -a

# Option 1: Use different name
/worktree-create feature-name-v2

# Option 2: Delete old branch
git branch -D feature/feature-name
/worktree-create feature-name
```

---

### Problem: Disk Space

```
Running out of disk space with multiple worktrees
```

**Solutions:**
```bash
# List all worktrees
git worktree list

# Clean up unused ones
/worktree-cleanup old-feature-1
/worktree-cleanup old-feature-2

# Remove node_modules if not actively working
cd worktrees/feature-name
rm -rf node_modules
```

---

### Problem: Lost in Worktrees

```
Too many worktrees, can't remember which is which
```

**Solutions:**
```bash
# List all with status
git worktree list

# Check plan status for all
/plan-status

# Clean up completed/stale ones
for dir in worktrees/*; do
  cd $dir
  git log --oneline -1
  cd ~/project
done
```

---

## Comparison: Traditional vs Worktree

### Traditional Git Workflow

```bash
# Working on feature A
git checkout feature-a
# Work, work, work

# Need to review PR
git stash  # Save work
git checkout main
git pull
git checkout pr-branch
# Review...

# Back to feature A
git checkout feature-a
git stash pop
npm install  # Reinstall if dependencies changed
# Continue work

# Need to fix bug
git stash
git checkout main
git checkout -b hotfix
# Fix bug...
git checkout feature-a
git stash pop
```

**Problems:**
- Constant stashing
- Context switching overhead
- Risk of forgetting to stash
- Slow checkout times
- Dependency reinstalls

---

### Worktree Workflow

```bash
# Working on feature A
cd worktrees/feature-a
# Work, work, work

# Need to review PR
cd ~/project
gh pr checkout 123
cd worktrees/pr-123
# Review...

# Back to feature A
cd ~/project/worktrees/feature-a
# Continue immediately where you left off

# Need to fix bug
cd ~/project
/worktree-create hotfix-bug
cd worktrees/hotfix-bug
# Fix bug...
cd ~/project/worktrees/feature-a
# Back to feature work
```

**Benefits:**
- No stashing needed
- Instant context switch (`cd`)
- Work preserved exactly as-is
- No re-installs
- Clean separation

---

## Integration with CI/CD

### Worktrees Don't Affect CI

CI/CD runs against branches, not worktrees:
- Each worktree = one branch
- Push to remote triggers CI
- Multiple worktrees = multiple PRs = parallel CI runs

---

### Testing Locally

Test all features easily:

```bash
# Test feature 1
cd worktrees/feature-auth
npm test

# Test feature 2
cd ~/project/worktrees/feature-payments
npm test

# Test main
cd ~/project  # or cd ~/project/main if using main worktree
npm test
```

---

## Team Usage

### Sharing Worktrees?

**Worktrees are local only:**
- Each developer has their own worktrees
- Worktrees don't sync via git
- Only branches sync to remote

**Plans can be shared:**
- Plans are committed to git
- Team can see each other's plans
- Stored in `plans/active/`

---

### Team Conventions

Agree on:
- Naming conventions (feature/fix/refactor)
- When to use worktrees
- When to clean up
- Plan template usage

---

## Resources

- [Git Worktree Docs](https://git-scm.com/docs/git-worktree)
- [Skills](../../.claude/skills/) - worktree-create, worktree-sync, worktree-cleanup
- [Plan Templates](../../plans/templates/) - Feature planning

---

## Quick Reference

```bash
# Create worktree with plan
/worktree-create feature-name

# Navigate
cd worktrees/feature-name

# Sync with main
/worktree-sync

# Check progress
/plan-status feature-name

# Clean up
/worktree-cleanup feature-name

# List all
git worktree list
```

---

## Conclusion

Git worktrees are powerful for:
- Parallel feature development
- Fast context switching
- PR reviews
- Hot fixes
- Experimentation

Combined with integrated planning:
- Track progress per feature
- Organize work systematically
- Share plans with team
- Maintain development history

Start using worktrees when:
- Working on 2+ features
- Features take multiple days
- Need to review PRs often
- Frequently need to hotfix
