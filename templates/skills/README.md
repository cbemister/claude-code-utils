# Skill Authoring Templates

Templates and guides for creating custom Claude Code skills.

## What is a Skill?

A skill is a reusable workflow automation that users can invoke with `/skill-name`. Skills are markdown files with instructions that Claude follows to accomplish specific tasks.

**Location:**
- Project: `.claude/skills/` (checked into git)
- User: `~/.claude/skills/` (available in all projects)

**Format:**
- Markdown file with YAML frontmatter
- Filename: `skill-name.md`
- Invoked with: `/skill-name`

---

## Skill Template

Use [skill-template.md](./skill-template.md) as a starting point for creating your own skills.

### Template Structure

```markdown
---
name: skill-name
description: When Claude should use this skill
---

# Skill Name

[Instructions for Claude to follow]

## When to Use
[Scenarios]

## Instructions
[Step-by-step process]

## Examples
[Usage examples]
```

---

## Creating Your First Skill

### 1. Copy the Template

```bash
cp templates/skills/skill-template.md .claude/skills/my-skill.md
```

### 2. Customize the Frontmatter

```yaml
---
name: my-skill
description: Clear description of when to use this skill
---
```

**Important:**
- `name` must match filename (without `.md`)
- `description` tells Claude when to invoke this skill proactively

### 3. Write Instructions

Write clear, step-by-step instructions for Claude:

```markdown
## Instructions

### Step 1: Validate Input
Check that required arguments are provided.

bash
if [ -z "$1" ]; then
  echo "Error: Argument required"
  exit 1
fi


### Step 2: Process
[What to do with the input]

### Step 3: Output Result
[How to format the output]
```

### 4. Add Examples

Show realistic usage examples:

```markdown
## Example Usage

bash
/my-skill example-arg


Output:
✅ Task completed!
Result: [outcome]
```

### 5. Test Your Skill

```bash
# Invoke from Claude Code
/my-skill test-input
```

---

## Skill Design Principles

### 1. Single Responsibility
Each skill should do ONE thing well.

**Good:**
```markdown
name: run-tests
description: Run the test suite and report results
```

**Bad:**
```markdown
name: test-and-deploy
description: Run tests, build, deploy, and send notifications
```

### 2. Clear Triggers
The description should clearly indicate when to use this skill.

**Good:**
```yaml
description: Organize staged changes into logical commits with conventional commit messages
```

**Bad:**
```yaml
description: Helper for git stuff
```

### 3. Idempotent Operations
Skills should be safe to run multiple times.

**Good:**
```bash
# Creates worktree only if it doesn't exist
if [ ! -d "worktrees/$NAME" ]; then
  git worktree add "worktrees/$NAME"
fi
```

**Bad:**
```bash
# Fails if worktree already exists
git worktree add "worktrees/$NAME"
```

### 4. Helpful Output
Provide clear, actionable output.

**Good:**
```
✅ Worktree created successfully!

📁 Location: worktrees/feature-name
🌿 Branch: feature/feature-name

Next steps:
1. cd worktrees/feature-name
2. Start working on your feature
```

**Bad:**
```
Done.
```

---

## Skill Patterns

### Pattern 1: Validation & Execution

```markdown
### Step 1: Validate Input
bash
if [ -z "$1" ]; then
  echo "Error: Feature name required"
  echo "Usage: /skill-name <feature-name>"
  exit 1
fi


### Step 2: Execute
bash
# Main logic here


### Step 3: Report Success
bash
echo "✅ Task completed!"
echo "Details: ..."
```

---

### Pattern 2: Interactive Confirmation

```markdown
### Step 1: Show Preview
bash
echo "This will:"
echo "  - Action 1"
echo "  - Action 2"


### Step 2: Confirm
bash
read -p "Continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "Cancelled"
  exit 0
fi


### Step 3: Execute
[Action]
```

---

### Pattern 3: Error Recovery

```markdown
### Step 1: Attempt Operation
bash
if ! command_that_might_fail; then
  echo "⚠️  Warning: Primary method failed"
  echo "Trying alternative approach..."

  if ! alternative_command; then
    echo "❌ Error: Both methods failed"
    echo "Manual intervention required:"
    echo "  1. Step to fix"
    echo "  2. Then retry with: /skill-name"
    exit 1
  fi
fi

echo "✅ Success!"
```

---

## Common Use Cases

### Development Workflow Skills
- Running tests
- Building projects
- Deploying
- Code formatting
- Git operations

**Example:**
```yaml
name: quick-deploy
description: Build and deploy to staging environment
```

---

### Code Generation Skills
- Generating boilerplate
- Creating components
- Scaffolding features
- Adding tests

**Example:**
```yaml
name: create-component
description: Generate a new React component with tests and styles
```

---

### Analysis Skills
- Code review
- Performance profiling
- Dependency analysis
- Security audits

**Example:**
```yaml
name: analyze-bundle
description: Analyze bundle size and suggest optimizations
```

---

### Maintenance Skills
- Cleaning up files
- Updating dependencies
- Archiving old code
- Generating reports

**Example:**
```yaml
name: cleanup-branches
description: Remove merged git branches and their worktrees
```

---

## Best Practices

### Do:
- ✅ Write clear, step-by-step instructions
- ✅ Handle errors gracefully
- ✅ Provide helpful output messages
- ✅ Include usage examples
- ✅ Document arguments and flags
- ✅ Test with various inputs

### Don't:
- ❌ Make skills too complex (split into multiple skills)
- ❌ Assume perfect conditions (validate inputs)
- ❌ Use vague descriptions
- ❌ Skip error handling
- ❌ Forget to document edge cases
- ❌ Hard-code project-specific values

---

## Testing Your Skill

### Manual Testing Checklist

- [ ] Test with valid input
- [ ] Test with missing arguments
- [ ] Test with invalid arguments
- [ ] Test with edge cases
- [ ] Test error conditions
- [ ] Verify output format
- [ ] Check for side effects

### Example Test Cases

**Test Case 1: Valid Input**
```bash
/my-skill valid-argument
# Should succeed with clear output
```

**Test Case 2: Missing Input**
```bash
/my-skill
# Should show error and usage
```

**Test Case 3: Edge Case**
```bash
/my-skill edge-case-value
# Should handle gracefully
```

---

## Skill Organization

### Project-Specific Skills
Store in `.claude/skills/` and commit to git:
- Build scripts
- Deployment workflows
- Project-specific automation

### Personal Skills
Store in `~/.claude/skills/` for all projects:
- General utilities
- Personal workflows
- Cross-project tools

### Shared Skills
Create a git repository:
```bash
git clone https://github.com/username/claude-skills ~/.claude/skills
```

---

## Advanced Features

### Calling Other Skills

```markdown
### Step 1: Run Tests
Invoke the test-runner skill:
/run-tests

### Step 2: If Tests Pass
/deploy-staging
```

### Dynamic Behavior

```bash
# Detect project type
if [ -f "package.json" ]; then
  npm test
elif [ -f "Cargo.toml" ]; then
  cargo test
fi
```

### Parsing Output

```bash
# Capture and process command output
OUTPUT=$(command)
if echo "$OUTPUT" | grep -q "ERROR"; then
  echo "❌ Error detected"
  exit 1
fi
```

---

## Skill Maintenance

### Versioning
Track changes in git:
```bash
git commit -m "feat(skill): Add error recovery to my-skill"
git commit -m "fix(skill): Handle edge case in validation"
```

### Documentation
Keep the skill file as documentation:
- Clear description in frontmatter
- Comments in bash code
- Examples for users
- Troubleshooting section

### Updates
Review and update skills when:
- Project tools change
- Better patterns discovered
- User feedback received
- Bugs found

---

## Example Skills

### Simple Skill: Format Code
```markdown
---
name: format-code
description: Format all code using project formatter
---

# Format Code

Run the project's code formatter on all source files.

## Instructions

bash
if [ -f "package.json" ]; then
  npm run format
elif [ -f "pyproject.toml" ]; then
  black .
else
  echo "❌ No formatter configured"
  exit 1
fi

echo "✅ Code formatted successfully"
```

---

### Complex Skill: See Existing Skills

Check out the skills in `.claude/skills/`:
- [worktree-create.md](../../.claude/skills/worktree-create.md)
- [create-plan.md](../../.claude/skills/create-plan.md)
- [plan-status.md](../../.claude/skills/plan-status.md)

These demonstrate real-world skill patterns.

---

## Resources

- [Claude Code Skills Documentation](https://code.claude.com/docs/skills)
- [Bash Scripting Guide](https://www.gnu.org/software/bash/manual/)
- [Markdown Guide](https://www.markdownguide.org/)

---

## Contributing

Have a great skill to share?
1. Test it thoroughly
2. Document it well
3. Add to your skills repository
4. Share with the community
