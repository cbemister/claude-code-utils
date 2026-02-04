# Installation Guide

Complete guide to installing and configuring Claude Code Shared Resources.

## Installation Methods

Choose the method that best fits your needs:

| Method | Best For | Scope |
|--------|----------|-------|
| **Per-Project** | Teams, shared resources | Single project |
| **Central** | Personal use, all projects | All projects |
| **Selective** | Pick what you need | Custom setup |

---

## Method 1: Per-Project Installation

Install resources into a specific project. Best for teams working on the same project.

### Step 1: Navigate to Project

```bash
cd /path/to/your/project
```

---

### Step 2: Clone Resources

```bash
# Clone into .claude directory
git clone https://github.com/username/claude-code-shared .claude

# OR if .claude already exists
git clone https://github.com/username/claude-code-shared temp-claude
mv temp-claude/* .claude/
rm -rf temp-claude
```

---

### Step 3: Verify Installation

```bash
# Check structure
ls .claude/

# Should see:
# agents/
# skills/
# settings.json (if exists)
```

---

### Step 4: Test

```bash
# Open Claude Code
claude

# Test an agent
> Explore the codebase structure

# Test a skill
/plan-status
```

---

### Step 5: Commit to Git (Optional)

If sharing with team:

```bash
git add .claude/
git commit -m "Add Claude Code shared resources"
git push
```

**Pros:**
- ✅ Team shares same agents and skills
- ✅ Version controlled with project
- ✅ Consistent across team

**Cons:**
- ❌ Need to update each project separately
- ❌ Can't share across personal projects

---

## Method 2: Central Installation

Install resources globally for use across all projects.

### Step 1: Clone to Home Directory

```bash
# Clone to ~/.claude
git clone https://github.com/username/claude-code-shared ~/.claude

# OR if ~/.claude already exists
cd ~/.claude
git pull origin main
```

---

### Step 2: Verify Installation

```bash
# Check structure
ls ~/.claude/

# Should see:
# agents/
# skills/
# templates/
# etc.
```

---

### Step 3: Test

```bash
# In any project
cd ~/any-project
claude

# Test an agent
> Find all API endpoints

# Test a skill
/worktree-create test-feature
```

---

### Step 4: Keep Updated

```bash
# Pull latest changes
cd ~/.claude
git pull origin main
```

**Pros:**
- ✅ Available in all projects
- ✅ Single place to update
- ✅ Personal customizations

**Cons:**
- ❌ Not shared with team
- ❌ Team members need separate install

---

## Method 3: Selective Installation

Install only what you need.

### Choose Components

**Example: Only Agents**
```bash
mkdir -p .claude/agents
cp -r ~/claude-code-shared/.claude/agents/* .claude/agents/
```

**Example: Only Skills**

> **Important:** Skills must be installed to `~/.claude/skills/<name>/SKILL.md` to work as slash commands.

```bash
# Use the install script
cd ~/claude-code-shared
./scripts/install-skills.sh

# Or install specific skills
./scripts/install-skills.sh worktree-create
./scripts/install-skills.sh worktree-sync
```

**Example: Only Templates**
```bash
mkdir -p templates
cp -r ~/claude-code-shared/templates/claude-md ./templates/
```

---

## Hybrid Approach

Combine central and per-project installation.

### Setup

```bash
# Central: Personal agents/skills
~/.claude/
├── agents/
│   └── my-personal-agents/
└── skills/
    └── my-personal-skills/

# Per-Project: Team resources
project/.claude/
├── agents/
│   └── team-agents/
└── skills/
    └── team-skills/
```

**Claude Code checks:**
1. Project `.claude/` first
2. User `~/.claude/` second
3. Merges resources from both

---

## Post-Installation Configuration

### 1. Create CLAUDE.md for Your Project

```bash
# Choose template based on stack
cp templates/claude-md/nextjs-app.md CLAUDE.md

# OR for libraries
cp templates/claude-md/node-library.md CLAUDE.md

# OR minimal
cp templates/claude-md/minimal.md CLAUDE.md
```

Edit `CLAUDE.md` to match your project:
- Replace `[Project Name]`
- Update tech stack
- Add project-specific patterns
- Document conventions

---

### 2. Initialize Plans Directory (Optional)

```bash
# Create plans structure
mkdir -p plans/active
mkdir -p plans/archived

# Copy templates
cp -r templates/plans/* plans/templates/ 2>/dev/null || true
```

---

### 3. Set Up Worktrees Directory (Optional)

```bash
# Create worktrees directory
mkdir -p worktrees

# Add to .gitignore
echo "worktrees/" >> .gitignore
```

---

### 4. Configure Git (Optional)

For worktree workflow:

```bash
# Set default branch (if not set)
git config init.defaultBranch main

# Enable push.autoSetupRemote
git config push.autoSetupRemote true
```

---

## Verification Checklist

### Check Installation

- [ ] Agents directory exists (`.claude/agents/` or `~/.claude/agents/`)
- [ ] Skills installed to user directory (`~/.claude/skills/<name>/SKILL.md`)
- [ ] Templates available (`templates/` or `~/.claude/templates/`)
- [ ] Documentation accessible (`docs/` or `~/.claude/docs/`)

---

### Test Functionality

```bash
# Test 1: List agents
ls .claude/agents/**/*.md

# Test 2: List installed skills
ls ~/.claude/skills/

# Test 3: Agent invocation
claude
> Explore the codebase
# Should delegate to codebase-explorer

# Test 4: Skill invocation (requires restart after install)
/plan-status
# Should show plans or "No active plans"

# Test 5: Worktree creation
/worktree-create test
cd worktrees/test
# Should work

# Cleanup
cd ..
/worktree-cleanup test --force
```

---

## Platform-Specific Instructions

### Windows

```powershell
# Per-project
cd C:\path\to\project
git clone https://github.com/username/claude-code-shared .claude

# Central
git clone https://github.com/username/claude-code-shared $env:USERPROFILE\.claude

# Test
claude
```

---

### macOS

```bash
# Per-project
cd /path/to/project
git clone https://github.com/username/claude-code-shared .claude

# Central
git clone https://github.com/username/claude-code-shared ~/.claude

# Test
claude
```

---

### Linux

```bash
# Per-project
cd /path/to/project
git clone https://github.com/username/claude-code-shared .claude

# Central
git clone https://github.com/username/claude-code-shared ~/.claude

# Test
claude
```

---

## Updating Resources

### Per-Project Updates

```bash
cd /path/to/project/.claude
git pull origin main
```

---

### Central Updates

```bash
cd ~/.claude
git pull origin main
```

---

### Selective Updates

```bash
# Update only agents
cd /path/to/project
cp -r ~/claude-code-shared/.claude/agents/* .claude/agents/

# Update only skills
cp -r ~/claude-code-shared/.claude/skills/* .claude/skills/
```

---

## Uninstallation

### Remove Per-Project Installation

```bash
cd /path/to/project
rm -rf .claude/
# Remove from git if committed
git rm -rf .claude/
git commit -m "Remove Claude Code resources"
```

---

### Remove Central Installation

```bash
rm -rf ~/.claude/
```

---

### Remove Selective Components

```bash
# Remove specific agents
rm .claude/agents/agent-name.md

# Remove specific skills
rm .claude/skills/skill-name.md
```

---

## Troubleshooting

### Problem: Agents Not Found

**Symptoms:**
- Claude doesn't delegate to agents
- Agent invocation fails

**Solution:**
```bash
# Check agent files exist
ls .claude/agents/**/*.md
ls ~/.claude/agents/**/*.md

# Check frontmatter is valid
head -20 .claude/agents/explore/codebase-explorer.md

# Verify YAML format (must have ---)
```

---

### Problem: Skills Not Found

**Symptoms:**
- `/skill-name` doesn't appear in autocomplete
- Skill not listed as slash command

**Cause:**
Skills must be installed to `~/.claude/skills/<name>/SKILL.md` directory structure. Skill source files in the repo must be installed to work as slash commands.

**Solution:**
```bash
# Check skill directories exist
ls ~/.claude/skills/

# Each skill needs this structure:
# ~/.claude/skills/skill-name/SKILL.md

# Install from this repo using the script:
cd /path/to/claude-code-shared
./scripts/install-skills.sh

# Or install specific skill:
./scripts/install-skills.sh skill-name

# Restart Claude Code (close and reopen VSCode)
```

---

### Problem: Permission Denied

**Symptoms:**
- Can't clone to directory
- Can't create directories

**Solution:**
```bash
# Check directory permissions
ls -la .

# Fix permissions
chmod 755 .claude
# OR
sudo chown -R $USER:$USER .claude
```

---

### Problem: Git Conflicts

**Symptoms:**
- `.claude/` already exists with different content
- Merge conflicts

**Solution:**
```bash
# Backup existing
mv .claude .claude-backup

# Install fresh
git clone https://github.com/username/claude-code-shared .claude

# Merge your customizations
cp .claude-backup/agents/my-custom-agent.md .claude/agents/
# etc.
```

---

## Advanced Configuration

### Custom Agent Directories

Organize agents by project type:

```
.claude/agents/
├── frontend/
│   └── react-component-builder.md
├── backend/
│   └── api-developer.md
└── shared/
    └── codebase-explorer.md
```

---

### Symbolic Links

Share between projects with symlinks:

```bash
# Create central repository
mkdir ~/claude-resources
git clone https://github.com/username/claude-code-shared ~/claude-resources

# Link from projects
cd /path/to/project1
ln -s ~/claude-resources/.claude .claude

cd /path/to/project2
ln -s ~/claude-resources/.claude .claude

# Update once, applies to all
cd ~/claude-resources
git pull
```

---

### Version Pinning

Pin to specific version:

```bash
# Clone
git clone https://github.com/username/claude-code-shared .claude

# Checkout specific version
cd .claude
git checkout v1.0.0

# Don't auto-update
# (skip git pull)
```

---

## Team Setup

### For Teams Using Per-Project

```bash
# 1. One person installs
git clone https://github.com/username/claude-code-shared .claude
git add .claude/
git commit -m "Add Claude Code resources"
git push

# 2. Others pull
git pull

# 3. Everyone tests
claude
> Explore the codebase
```

---

### For Teams Using Central + Custom

```bash
# Each team member:
# 1. Install central
git clone https://github.com/username/claude-code-shared ~/.claude

# 2. Add project-specific
# (team commits these)
mkdir -p .claude/agents/
# Add custom team agents

git add .claude/
git commit -m "Add team-specific agents"
```

---

## Migration Guide

### From Agile Toolkit

If you have skills from agile-toolkit:

```bash
# They're already included!
# These skills are in skills/:
- benchmark-performance.md
- generate-tests.md
- organize-commits.md
- ship.md
- track-progress.md
- verify-performance.md
- verify-work.md

# Plus new skills:
- worktree-create.md
- worktree-sync.md
- worktree-cleanup.md
- create-plan.md
- plan-status.md

# Install them all:
./scripts/install-skills.sh
```

---

### From Scratch

Starting fresh:

```bash
# 1. Install central
git clone https://github.com/username/claude-code-shared ~/.claude

# 2. Test in existing project
cd /path/to/project
claude
> Explore the codebase

# 3. Gradually adopt
# - Try agents (automatic)
# - Try skills (/skill-name)
# - Try worktrees (/worktree-create)
# - Try planning (/create-plan)
```

---

## Next Steps

After installation:

1. **Read [Getting Started](./getting-started.md)**
   - Learn basic workflows
   - Try your first agent
   - Create a plan

2. **Customize for Your Project**
   - Copy CLAUDE.md template
   - Add custom agents
   - Create custom skills

3. **Learn Best Practices**
   - [Model Selection](../best-practices/model-selection.md)
   - [Agent Design](../best-practices/agent-design.md)
   - [Skill Authoring](../best-practices/skill-authoring.md)

---

## Support

Having issues?

1. Check [Troubleshooting](#troubleshooting) above
2. Review [Getting Started](./getting-started.md)
3. Check existing agents/skills for examples
4. File an issue on GitHub

---

## Summary

**Per-Project:**
```bash
git clone https://github.com/username/claude-code-shared .claude
```

**Central:**
```bash
git clone https://github.com/username/claude-code-shared ~/.claude
```

**Test:**
```bash
claude
> Explore the codebase
/plan-status
```

You're ready to go! 🚀
