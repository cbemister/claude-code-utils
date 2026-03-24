---
name: worktree
description: Manage git worktrees for parallel feature development. Sub-commands: create, sync, cleanup
argument-hint: "create <feature-name> [base-branch] | sync [base-branch] | cleanup <feature-name> [--force]"
---

# Git Worktree Manager

Create, sync, and clean up git worktrees for isolated feature development.

## Usage

```
/worktree create <feature-name> [base-branch]
/worktree sync [base-branch]
/worktree cleanup <feature-name> [--force]
```

## Instructions

Parse the first argument as the sub-command and dispatch accordingly.

If no sub-command is provided, display:
```
Usage:
  /worktree create <feature-name> [base-branch]  — create new isolated worktree
  /worktree sync [base-branch]                   — sync current worktree with base
  /worktree cleanup <feature-name> [--force]     — remove worktree after merge
```

---

## Sub-command: create

Create a new git worktree for isolated feature development with automatic plan setup.

**When to use:** Starting a new feature that needs multiple commits, working on multiple features in parallel, or keeping the main branch clean during development.

### Step 1: Validate Inputs

Ensure feature name is provided (second argument). Convert to kebab-case:
```bash
FEATURE_NAME=$(echo "$2" | tr '[:upper:]' '[:lower:]' | tr '_' '-' | tr ' ' '-')
```

### Step 2: Determine Base Branch

Use third argument if provided, otherwise detect `main` or `master` from git refs.

### Step 3: Check Current State

Verify this is a git repository. Warn (but allow) if there are uncommitted changes. Fetch latest from origin.

### Step 4: Create Worktree

```bash
BRANCH_NAME="feature/$FEATURE_NAME"
WORKTREE_PATH="worktrees/$FEATURE_NAME"
mkdir -p worktrees
git worktree add "$WORKTREE_PATH" -b "$BRANCH_NAME" "origin/$BASE_BRANCH"
```

### Step 5: Initialize Plan

Create `plans/active/$FEATURE_NAME/plan.md` with frontmatter template (title, status: planning, worktree, created date) and sections for Overview, Success Criteria, Phases, Notes, and Open Questions.

### Step 6: Output

```
✅ Worktree created!
  Location: worktrees/$FEATURE_NAME
  Branch:   feature/$FEATURE_NAME
  Plan:     plans/active/$FEATURE_NAME/plan.md

Next: cd $WORKTREE_PATH, edit the plan, start building
When done: /worktree sync | /worktree cleanup $FEATURE_NAME
```

---

## Sub-command: sync

Sync the current feature worktree with its base branch.

**When to use:** Incorporating latest changes from main before a PR, during long-running feature development, or after team members land changes.

### Step 1: Verify Location

Check current directory is a worktree (path contains `/worktrees/`). Warn if not. Get current branch with `git branch --show-current`.

### Step 2: Determine Base Branch

Use argument if provided, otherwise detect from remote refs.

### Step 3: Require Clean Working Directory

If uncommitted changes exist, print status and exit with instructions to commit or stash first.

### Step 4: Fetch and Rebase

```bash
git fetch origin
BEHIND=$(git rev-list --count HEAD..origin/$BASE_BRANCH)
# If already up to date, exit with success
git rebase "origin/$BASE_BRANCH"
```

On rebase failure: show conflicting files and instructions to resolve then `git rebase --continue`, or abort with `git rebase --abort`.

On success: show summary and next steps (run tests, push with `--force-with-lease`).

---

## Sub-command: cleanup

Remove a git worktree and associated files after a feature is merged.

**When to use:** After a feature branch is merged to main, or when abandoning an experiment.

### Step 1: Validate

Require feature name (second argument). Check `worktrees/$FEATURE_NAME` exists.

### Step 2: Safety Checks (unless --force)

- Cannot remove the worktree you are currently inside
- Check if branch is merged into base: `git branch -r --merged origin/$BASE_BRANCH | grep feature/$FEATURE_NAME`
- Warn (with y/n prompt) if not merged or if uncommitted changes exist

### Step 3: Archive Plan (Optional)

If `plans/active/$FEATURE_NAME` exists, offer to archive it to `plans/archived/$FEATURE_NAME-$(date +%Y%m%d)`.

### Step 4: Remove Worktree

```bash
git worktree remove "$WORKTREE_PATH"
```

### Step 5: Delete Branches (Optional)

Offer to delete remote branch (`git push origin --delete feature/$FEATURE_NAME`) and local branch (`git branch -d feature/$FEATURE_NAME`).

### Step 6: Summary

Show what was removed and remaining worktrees via `git worktree list`.
