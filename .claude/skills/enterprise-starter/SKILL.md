---
name: enterprise-starter
description: Scaffold the enterprise starter template into the current project directory. Creates the full .claude/ config layer including 8 specialized agents, rules knowledge base, hooks, plans structure, marketplace.json, MCP server stubs, and an enterprise CLAUDE.md. Use when starting a new project that needs enterprise-grade Claude Code configuration.
---

# Enterprise Starter Skill

Scaffold the enterprise Claude Code configuration layer into the current directory.

## Instructions

**IMPORTANT: Non-interactive where possible. Complete all steps without pausing unless a decision is required.**

### Step 1: Pre-flight Check

1. Check if `.claude/` already exists in the current directory
2. If it does, warn the user: "A .claude/ directory already exists. Use /enterprise-enhance to add enterprise features to an existing project instead. Continue anyway? (existing files will not be overwritten)"
3. If confirmed or if `.claude/` doesn't exist, proceed

Check git status:
```bash
git status 2>/dev/null || echo "Not a git repository"
```

If not a git repo, ask: "This directory is not a git repository. Initialize one? (recommended)"

### Step 2: Get Project Name

Ask the user for the project name if not provided:

```
What is your project name? (used to replace [PROJECT_NAME] placeholders)
```

Use the current directory name as the default suggestion.

### Step 3: Find Template Source

Locate the enterprise-starter template. Check these locations in order:
1. `~/.claude/skills/enterprise-starter/templates/enterprise-starter/` (if installed globally)
2. The claude-code-utils repository: Look for `templates/enterprise-starter/` relative to the skill location

Store the source path as `TEMPLATE_DIR`.

If the template cannot be found, print an error with instructions to install from the claude-code-utils repository.

### Step 4: Copy Template Files

Copy the following from `TEMPLATE_DIR` to the current directory, skipping files that already exist:

```bash
# Create directory structure
mkdir -p .claude/agents .claude/rules plans/active plans/archive plans/templates

# Copy agents
cp -n "$TEMPLATE_DIR/.claude/agents/"*.md .claude/agents/ 2>/dev/null || true
cp -n "$TEMPLATE_DIR/.claude/agents/README.md" .claude/agents/README.md 2>/dev/null || true

# Copy rules
cp -n "$TEMPLATE_DIR/.claude/rules/"*.md .claude/rules/ 2>/dev/null || true

# Copy settings.json (only if it doesn't exist)
if [ ! -f .claude/settings.json ]; then
  cp "$TEMPLATE_DIR/.claude/settings.json" .claude/settings.json
fi

# Copy plan templates
cp -n "$TEMPLATE_DIR/plans/templates/"*.md plans/templates/ 2>/dev/null || true

# Copy root config files (only if they don't exist)
[ ! -f marketplace.json ] && cp "$TEMPLATE_DIR/marketplace.json" marketplace.json
[ ! -f .mcp.json ] && cp "$TEMPLATE_DIR/.mcp.json" .mcp.json

# Copy CLAUDE.md (only if one doesn't exist)
if [ ! -f CLAUDE.md ]; then
  cp "$TEMPLATE_DIR/CLAUDE.md" CLAUDE.md
fi
```

### Step 5: Replace Placeholders

Replace `[PROJECT_NAME]` with the actual project name in all copied files:

```bash
PROJECT_NAME="[user-provided-name]"

# Replace in CLAUDE.md and all .claude/ files
find . -name "*.md" -o -name "*.json" | grep -E "(CLAUDE\.md|\.claude/|plans/|marketplace\.json|\.mcp\.json)" | while read -r file; do
  sed -i "s/\[PROJECT_NAME\]/$PROJECT_NAME/g" "$file" 2>/dev/null || true
done
```

### Step 6: Display Results

Print a clear summary:

```
================================================================
Enterprise Claude Code configuration installed!
================================================================

Created:
  .claude/agents/      — 8 enterprise specialist agents
  .claude/rules/       — Project knowledge base (customize these!)
  .claude/settings.json — Hooks + permission rules
  plans/templates/     — Feature, bugfix, and context-handoff templates
  marketplace.json     — Plugin marketplace catalog
  .mcp.json            — MCP server stubs
  CLAUDE.md            — Enterprise project instructions

================================================================
NEXT STEPS (required before using agents effectively):
================================================================

1. Customize .claude/rules/ files — replace [PLACEHOLDER] values:
   - architecture.md   ← most important, do this first
   - env.md            ← add your actual environment variables
   - security-policy.md
   - api-conventions.md
   - code-standards.md
   - testing-standards.md

2. Update marketplace.json:
   - Set owner.name and owner.email
   - Validate: claude plugin validate .

3. Update .mcp.json:
   - Fill in correct paths
   - Set environment variables for any servers you want to use

4. Install workflow skills (from ~/.claude/skills/ or ~/.claude/plugins/):
   - /create-plan, /plan-status, /summarize-session, /ship

5. Restart Claude Code to activate agents, rules, and hooks

================================================================
AGENT TEAM READY:
================================================================

  coordinator          — orchestrates complex multi-layer tasks (Opus)
  backend-architect    — API, database, service layer (Sonnet)
  frontend-architect   — UI components, state, accessibility (Sonnet)
  security-auditor     — OWASP, auth/authz, secrets review (Sonnet)
  test-engineer        — test strategy, coverage, automation (Sonnet)
  devops-engineer      — CI/CD, containers, infrastructure (Sonnet)
  code-reviewer        — quality, standards, pre-merge review (Sonnet)
  performance-analyst  — query optimization, bundle analysis (Sonnet)

================================================================
```

### Step 7: Validate marketplace.json

```bash
claude plugin validate . 2>&1 || echo "Note: Run 'claude plugin validate .' to validate marketplace.json after customizing"
```

### Step 8: Git Commit (Optional)

Ask the user: "Commit the enterprise configuration to git? (recommended)"

If yes:
```bash
git add .claude/ plans/ marketplace.json .mcp.json CLAUDE.md
git commit -m "chore: add enterprise Claude Code configuration

- 8 specialized agents (coordinator, backend-architect, frontend-architect,
  security-auditor, test-engineer, devops-engineer, code-reviewer, performance-analyst)
- .claude/rules/ knowledge base (customize for your project)
- Hooks: secret scan, auto-format, TypeScript check, bash protection
- plans/ structure with feature, bugfix, and context-handoff templates
- marketplace.json for plugin distribution
- .mcp.json MCP server configuration stubs"
```

---

## Error Handling

If template files cannot be found:
```
ERROR: Enterprise starter templates not found.

Install the claude-code-utils repository and run from there, or install
the enterprise-starter skill globally:

  git clone https://github.com/[owner]/claude-code-utils
  cd your-project
  /enterprise-starter
```

If files already exist and user declines to continue:
```
Aborted. Use /enterprise-enhance to selectively add enterprise features
to a project that already has Claude Code configuration.
```
