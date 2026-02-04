# Skill Authoring Best Practices

A comprehensive guide to creating high-quality, reusable Claude Code skills.

## What Makes a Good Skill?

A well-crafted skill is:
- **Focused** - Does one thing well
- **Reusable** - Works across projects
- **Clear** - Easy to understand and use
- **Reliable** - Handles errors gracefully
- **Documented** - Examples and troubleshooting included

---

## Skill Anatomy

### File Location

Claude Code discovers skills from multiple locations with different scopes:

```
# Project-local (works in this project)
.claude/skills/
└── skill-name/
    └── SKILL.md

# Personal (works in all projects)
~/.claude/skills/
└── skill-name/
    └── SKILL.md

# Enterprise (managed by organization)
(Configured via enterprise settings)
```

**Discovery Priority:** Enterprise > Personal > Project

See [.claude/skills/README.md](../../.claude/skills/README.md) for complete details on skill installation and discovery.

### Required Elements

```markdown
---
name: skill-name
description: Clear description of when Claude should use this skill
---

# Skill Name

[Documentation and instructions for Claude]

## When to Use
[Scenarios where this skill applies]

## Instructions
[Step-by-step process]

## Example Usage
[Realistic examples]
```

---

## 1. Naming Your Skill

### Frontmatter Name

**Rules:**
- Lowercase only
- Hyphens for spaces
- Must match filename (without `.md`)
- Descriptive and unique

**Good Names:**
```yaml
name: worktree-create
name: run-tests
name: generate-docs
name: cleanup-branches
```

**Bad Names:**
```yaml
name: wt-create      # Too abbreviated
name: Worktree_Create # Wrong case/separator
name: helper         # Too vague
name: doStuff        # Unclear
```

---

### Description Field

This is **critical** - it tells Claude when to invoke your skill proactively.

**Rules:**
- Use action verbs
- Be specific about scenarios
- Describe WHEN, not WHAT
- Keep under 200 characters

**Good Descriptions:**
```yaml
description: Create git worktree for parallel feature development with automatic plan initialization

description: Organize staged changes into logical commits with conventional commit messages

description: Run test suite and report failures with actionable suggestions

description: Analyze bundle size and suggest optimization opportunities
```

**Bad Descriptions:**
```yaml
description: Helper for git worktrees
# ❌ Vague, no scenario

description: Commits stuff
# ❌ Not descriptive enough

description: This skill is used when you want to create a new worktree for a feature and initialize a plan
# ❌ Too wordy, says "this skill is used"
```

---

## 2. Writing Instructions

### Structure

Use a clear step-by-step format:

```markdown
## Instructions

### Step 1: Validate Input

[What to check]

bash
# Validation code


### Step 2: Execute Main Task

[What to do]

bash
# Main logic


### Step 3: Report Results

[How to format output]

bash
# Output formatting

```

---

### Best Practices

**1. Start with Validation**

Always validate inputs first:

```bash
### Step 1: Validate Input

if [ -z "$1" ]; then
  echo "Error: Feature name required"
  echo "Usage: /skill-name <feature-name>"
  exit 1
fi

# Normalize input
FEATURE_NAME=$(echo "$1" | tr '[:upper:]' '[:lower:]' | tr '_' '-')
```

**2. Check Prerequisites**

Verify environment before proceeding:

```bash
### Step 2: Check Prerequisites

# Verify git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
  echo "Error: Not in a git repository"
  exit 1
fi

# Check for required tools
if ! command -v jq &> /dev/null; then
  echo "Error: jq is required but not installed"
  exit 1
fi
```

**3. Provide Clear Output**

Use formatting for readability:

```bash
### Step 5: Report Success

echo ""
echo "✅ Task completed successfully!"
echo ""
echo "📁 Created: $OUTPUT_PATH"
echo "🌿 Branch: $BRANCH_NAME"
echo ""
echo "Next steps:"
echo "  1. cd $OUTPUT_PATH"
echo "  2. Start working on your feature"
```

---

## 3. Error Handling

### Graceful Failures

Always handle errors with helpful messages:

```bash
# Attempt operation
if ! git worktree add "$PATH" -b "$BRANCH" "origin/main"; then
  echo "❌ Error: Failed to create worktree"
  echo ""
  echo "Possible causes:"
  echo "  - Worktree already exists"
  echo "  - Branch name conflicts"
  echo "  - No connection to origin"
  echo ""
  echo "Try:"
  echo "  git worktree list  # Check existing worktrees"
  echo "  git branch -a      # Check branch names"
  exit 1
fi
```

---

### Recovery Suggestions

When things fail, tell users how to recover:

```bash
if [ $? -ne 0 ]; then
  echo "⚠️  Warning: Tests failed"
  echo ""
  echo "To debug:"
  echo "  1. Run tests with verbose flag: npm test -- --verbose"
  echo "  2. Check test output for specific failures"
  echo "  3. Fix issues and re-run: /run-tests"
  echo ""
  echo "To skip for now:"
  echo "  git commit --no-verify"
  exit 1
fi
```

---

## 4. User Experience

### Interactive Confirmations

For destructive operations, always confirm:

```bash
### Step 3: Confirm Action

echo "⚠️  This will:"
echo "  - Delete worktree: $WORKTREE_PATH"
echo "  - Remove branch: $BRANCH_NAME"
echo ""
read -p "Continue? (y/n) " -n 1 -r
echo

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "Operation cancelled"
  exit 0
fi
```

---

### Progress Indicators

For long-running tasks:

```bash
echo "Building project..."
npm run build

echo "✅ Build complete"
echo ""
echo "Running tests..."
npm test

echo "✅ Tests passed"
```

---

### Helpful Defaults

Provide sensible defaults:

```bash
# Use provided base or detect default branch
if [ -n "$2" ]; then
  BASE_BRANCH="$2"
else
  # Auto-detect main/master
  if git show-ref --verify --quiet refs/heads/main; then
    BASE_BRANCH="main"
  elif git show-ref --verify --quiet refs/heads/master; then
    BASE_BRANCH="master"
  else
    echo "Error: Could not determine base branch"
    exit 1
  fi
fi

echo "Base branch: $BASE_BRANCH"
```

---

## 5. Documentation

### Example Usage Section

Always include realistic examples:

```markdown
## Example Usage

### Basic Usage
bash
/worktree-create feature-auth


Output:
✅ Worktree created successfully!

📁 Location: worktrees/feature-auth
🌿 Branch: feature/feature-auth
📋 Plan: plans/active/feature-auth/plan.md

Next steps:
1. cd worktrees/feature-auth
2. Edit plans/active/feature-auth/plan.md
3. Start working on your feature


### Advanced Usage
bash
/worktree-create feature-auth develop


Creates worktree based on 'develop' branch instead of 'main'.
```

---

### Troubleshooting Section

Document common issues:

```markdown
## Troubleshooting

### Error: "fatal: 'worktrees/X' already exists"
**Cause:** Worktree was already created
**Solution:**
bash
cd worktrees/X  # Use existing worktree
# OR
/worktree-cleanup X  # Remove and recreate


### Error: "fatal: invalid reference: origin/main"
**Cause:** Remote branch doesn't exist
**Solution:**
bash
git fetch origin  # Update remote refs
# Then retry


### Warning: Uncommitted changes
**Cause:** You have unstaged changes in current worktree
**Solution:**
bash
git add .
git commit -m "Save work before creating worktree"
# OR
git stash
# Then retry

```

---

## 6. Reusability

### Project-Agnostic

Write skills that work across projects:

**Good:**
```bash
# Detect project type
if [ -f "package.json" ]; then
  npm test
elif [ -f "Cargo.toml" ]; then
  cargo test
elif [ -f "go.mod" ]; then
  go test
else
  echo "Error: Unknown project type"
  exit 1
fi
```

**Bad:**
```bash
# ❌ Hard-coded to one project
cd /Users/me/my-project
npm test
```

---

### Configurable Behavior

Support customization through arguments:

```bash
# Support optional flags
FORCE_MODE=false
SKIP_TESTS=false

while [[ $# -gt 0 ]]; do
  case $1 in
    --force)
      FORCE_MODE=true
      shift
      ;;
    --skip-tests)
      SKIP_TESTS=true
      shift
      ;;
    *)
      FEATURE_NAME="$1"
      shift
      ;;
  esac
done
```

---

## 7. Idempotency

Skills should be safe to run multiple times:

**Good (Idempotent):**
```bash
# Only create if doesn't exist
if [ ! -d "worktrees/$NAME" ]; then
  git worktree add "worktrees/$NAME" -b "feature/$NAME"
  echo "✅ Worktree created"
else
  echo "ℹ️  Worktree already exists: worktrees/$NAME"
fi
```

**Bad (Not Idempotent):**
```bash
# ❌ Fails if already exists
git worktree add "worktrees/$NAME" -b "feature/$NAME"
```

---

## 8. Performance

### Optimize for Common Cases

```bash
# Fast path for simple case
if [ -f ".git/config" ]; then
  # Simple check for git repo
else
  # Slower comprehensive check
  git rev-parse --git-dir > /dev/null 2>&1
fi
```

---

### Avoid Unnecessary Operations

```bash
# ❌ Bad: Always fetches
git fetch origin
git worktree add ...

# ✅ Good: Only fetch if needed
if ! git show-ref --verify --quiet "refs/remotes/origin/main"; then
  echo "Fetching latest from origin..."
  git fetch origin
fi
git worktree add ...
```

---

## 9. Testing Your Skill

### Manual Testing Checklist

- [ ] Test with valid input
- [ ] Test with missing arguments
- [ ] Test with invalid arguments
- [ ] Test with edge cases
- [ ] Test error conditions
- [ ] Test in different project types
- [ ] Test after partial failure (cleanup)

### Test Script Template

```bash
#!/bin/bash
# test-skill.sh - Test the skill with various inputs

echo "Test 1: Valid input"
/skill-name valid-input
echo ""

echo "Test 2: Missing input"
/skill-name
echo ""

echo "Test 3: Invalid input"
/skill-name "@#$%"
echo ""

echo "Test 4: Edge case"
/skill-name "a"
```

---

## 10. Common Patterns

### Pattern 1: Validation → Execute → Report

```markdown
### Step 1: Validate Input
[Check arguments]

### Step 2: Execute Task
[Do the work]

### Step 3: Report Results
[Show output]
```

---

### Pattern 2: Check → Confirm → Execute → Verify

```markdown
### Step 1: Check Prerequisites
[Verify environment]

### Step 2: Confirm Action
[Ask user to confirm]

### Step 3: Execute
[Do the work]

### Step 4: Verify Success
[Confirm it worked]
```

---

### Pattern 3: Gather → Process → Output

```markdown
### Step 1: Gather Information
[Collect data]

### Step 2: Process
[Analyze and transform]

### Step 3: Output Results
[Present findings]
```

---

## Anti-Patterns to Avoid

### ❌ Too Complex

Don't cram multiple features into one skill:

```yaml
# Bad: Does too much
name: test-build-deploy-notify
description: Run tests, build, deploy, and send notifications
```

Split into focused skills:

```yaml
# Good: Focused skills
name: run-tests
name: build-project
name: deploy-staging
```

---

### ❌ Vague Instructions

```markdown
# Bad
## Instructions
Run the tests and stuff
```

```markdown
# Good
## Instructions

### Step 1: Detect Test Framework
Check package.json for test script

### Step 2: Run Tests
Execute npm test with appropriate flags

### Step 3: Parse Results
Extract pass/fail count and error details
```

---

### ❌ Silent Failures

```bash
# Bad: Fails silently
command_that_might_fail
# Continues anyway
```

```bash
# Good: Explicit error handling
if ! command_that_might_fail; then
  echo "❌ Error: Command failed"
  exit 1
fi
```

---

### ❌ Hard-Coded Values

```bash
# Bad
cd /Users/alice/projects/my-app
npm test
```

```bash
# Good
# Works from any directory in the project
PROJECT_ROOT=$(git rev-parse --show-toplevel)
cd "$PROJECT_ROOT"
npm test
```

---

## Skill Quality Checklist

Before publishing a skill, verify:

**Functionality:**
- [ ] Works on first try with valid input
- [ ] Handles errors gracefully
- [ ] Provides helpful error messages
- [ ] Safe to run multiple times (idempotent)
- [ ] Works across different project types

**Documentation:**
- [ ] Clear description in frontmatter
- [ ] Step-by-step instructions
- [ ] Realistic examples
- [ ] Troubleshooting section
- [ ] Lists all arguments/flags

**User Experience:**
- [ ] Clear, formatted output
- [ ] Uses emojis for visual clarity
- [ ] Confirms before destructive actions
- [ ] Provides "next steps" guidance
- [ ] Shows progress for long tasks

**Code Quality:**
- [ ] Validates all inputs
- [ ] Checks prerequisites
- [ ] No hard-coded paths
- [ ] Comments explain why, not what
- [ ] Consistent formatting

---

## Resources

- [Template](../../templates/skills/skill-template.md) - Skill authoring template
- [Examples](../../skills/) - Real skill implementations
- [Bash Guide](https://www.gnu.org/software/bash/manual/) - Bash reference

---

## Quick Start

1. **Copy template:**
   ```bash
   cp templates/skills/skill-template.md my-skill.md
   ```

2. **Customize frontmatter:**
   - Set `name` to match skill name (e.g., `my-skill`)
   - Write clear `description`

3. **Write instructions:**
   - Step-by-step process
   - Validate inputs
   - Handle errors

4. **Add examples:**
   - Basic usage
   - Advanced usage
   - Error scenarios

5. **Install to user directory:**
   ```bash
   mkdir -p ~/.claude/skills/my-skill
   cp my-skill.md ~/.claude/skills/my-skill/SKILL.md
   ```

6. **Restart Claude Code** (close and reopen VSCode)

7. **Test thoroughly:**
   - All input variations
   - Error conditions
   - Different projects

8. **Document issues:**
   - Common errors
   - Solutions
   - Tips

Your skill is ready when it passes the quality checklist above.
