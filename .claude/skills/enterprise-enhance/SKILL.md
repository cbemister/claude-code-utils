---
name: enterprise-enhance
description: Interactively add enterprise Claude Code features to an existing project. Pick and choose from: agent teams, rules knowledge base, context management, plugin marketplace, hooks, MCP servers, and CLAUDE.md snippets. Safely merges with existing configuration without overwriting.
---

# Enterprise Enhance Skill

Add enterprise Claude Code capabilities to an existing project, one module at a time.

## Instructions

**IMPORTANT: Non-interactive analysis phase, then interactive selection, then non-interactive installation.**

### Step 1: Analyze Existing Configuration

Survey what the project already has:

```bash
echo "=== Existing Claude Code Configuration ==="
echo ""
echo "Agents:"
ls .claude/agents/ 2>/dev/null && echo "  (found)" || echo "  (none)"
echo ""
echo "Rules:"
ls .claude/rules/ 2>/dev/null && echo "  (found)" || echo "  (none)"
echo ""
echo "Settings:"
[ -f .claude/settings.json ] && echo "  .claude/settings.json (exists)" || echo "  (none)"
echo ""
echo "Plans:"
[ -d plans/ ] && echo "  plans/ directory (exists)" || echo "  (none)"
echo ""
echo "Marketplace:"
[ -f marketplace.json ] && echo "  marketplace.json (exists)" || echo "  (none)"
echo ""
echo "MCP:"
[ -f .mcp.json ] && echo "  .mcp.json (exists)" || echo "  (none)"
echo ""
echo "CLAUDE.md:"
[ -f CLAUDE.md ] && echo "  CLAUDE.md (exists, $(wc -l < CLAUDE.md) lines)" || echo "  (none)"
```

### Step 2: Auto-select Missing Modules

Based on the analysis in Step 1, **automatically select all modules that aren't already installed.** Do not ask the user to pick — just install everything missing.

Display what will be installed:

```
================================================================
Enterprise Enhancement — Installing Missing Modules
================================================================

  ✓ agent-teams         — already installed, skipping
  + rules               — installing
  + context-management  — installing
  + hooks               — installing
  + mcp                 — installing
  + claude-md-snippets  — installing

  project-plans will run after modules are installed.
================================================================
```

The `project-plans` module always runs last (after context-management creates the plans/ directory). If the project already has plans/active/ with stage files, skip project-plans.

### Step 3: Find Template Source

Locate the enterprise-enhancement template directory. Check:
1. `~/.claude/plugins/*/templates/enterprise-enhancement/`
2. The claude-code-utils repository relative to skill location
3. Ask user for path if not found

### Step 4: Install Selected Modules

Install each selected module. **Never overwrite existing files without confirmation.**

#### agent-teams module

```bash
mkdir -p .claude/agents
# Copy agent files, skipping existing ones
for agent in coordinator backend-architect frontend-architect security-auditor test-engineer devops-engineer code-reviewer performance-analyst; do
  if [ ! -f ".claude/agents/$agent.md" ]; then
    cp "$TEMPLATE_DIR/.claude/agents/$agent.md" .claude/agents/ 2>/dev/null && echo "  + $agent.md" || echo "  ! Could not find $agent.md"
  else
    echo "  ~ $agent.md (already exists, skipped)"
  fi
done
```

#### rules module

```bash
mkdir -p .claude/rules
# Copy rule files, skipping existing ones
for rule in architecture api-conventions security-policy code-standards testing-standards env; do
  if [ ! -f ".claude/rules/$rule.md" ]; then
    cp "$TEMPLATE_DIR/.claude/rules/$rule.md" .claude/rules/ 2>/dev/null && echo "  + $rule.md" || echo "  ! Could not find $rule.md"
  else
    echo "  ~ $rule.md (already exists, skipped)"
  fi
done
```

**After copying, auto-populate rules from codebase analysis.** Read the project's package.json, CLAUDE.md, README, and source files to fill in:
- **architecture.md** — project structure, tech stack, data flow, key patterns (inferred from directory layout and dependencies)
- **api-conventions.md** — REST/GraphQL/tRPC conventions (inferred from existing endpoints or framework)
- **code-standards.md** — language standards, linting config, import conventions (inferred from tsconfig, eslint, prettier)
- **testing-standards.md** — test framework, naming patterns, coverage expectations (inferred from test files)
- **env.md** — environment variables (inferred from .env.example, .env.local, or code that reads process.env)
- **security-policy.md** — auth approach, OWASP considerations (inferred from auth middleware/libraries)

Write realistic, useful content using the Edit tool — not just variable names. These files should be immediately useful without manual editing.

#### context-management module

```bash
mkdir -p plans/active plans/archive plans/templates
# Copy plan templates, skipping existing ones
for template in feature-plan bugfix-plan stage-plan context-handoff; do
  if [ ! -f "plans/templates/$template.md" ]; then
    cp "$TEMPLATE_DIR/plans/templates/$template.md" plans/templates/ 2>/dev/null && echo "  + plans/templates/$template.md" || echo "  ! Not found"
  else
    echo "  ~ plans/templates/$template.md (already exists, skipped)"
  fi
done
```

#### project-plans module

This module automatically generates a project plan for agent teams. It analyzes the existing codebase to understand what's already built, then creates stages for what comes next.

```bash
mkdir -p plans/active plans/archive plans/templates
# Ensure stage-plan template exists
if [ ! -f "plans/templates/stage-plan.md" ]; then
  cp "$TEMPLATE_DIR/plans/templates/stage-plan.md" plans/templates/ 2>/dev/null && echo "  + plans/templates/stage-plan.md" || echo "  ! stage-plan.md template not found"
fi
```

**Step 1: Analyze the existing codebase automatically**

Before generating stages, understand what exists. Run these in parallel:

```bash
# Project structure
find . -type f -name "*.ts" -o -name "*.tsx" -o -name "*.js" -o -name "*.jsx" -o -name "*.py" -o -name "*.go" -o -name "*.rs" | head -50

# Package info
cat package.json 2>/dev/null || cat Cargo.toml 2>/dev/null || cat go.mod 2>/dev/null || cat pyproject.toml 2>/dev/null

# Existing tests
find . -type f -name "*.test.*" -o -name "*.spec.*" -o -name "*_test.*" | head -20

# Git log for recent work
git log --oneline -20 2>/dev/null

# CLAUDE.md for project context
cat CLAUDE.md 2>/dev/null
```

Use Grep and Glob tools to understand:
- What tech stack is in use
- What features are already built
- What patterns and conventions are established
- What the project does (from README, CLAUDE.md, or code)

**Step 2: Generate the stage breakdown automatically**

Based on codebase analysis, determine what stages the project needs next. Do NOT ask the user to describe milestones — infer them from the code.

For existing projects, typical stage patterns:

**Adding features to an existing app:**
- Stage N: [Feature name] data model + API
- Stage N+1: [Feature name] UI + integration
- Stage N+2: [Feature name] tests + polish

**Hardening / production-readiness:**
- Stage N: Error handling + validation
- Stage N+1: Auth + authorization
- Stage N+2: Performance + caching
- Stage N+3: CI/CD + deployment
- Stage N+4: Monitoring + observability

**Major refactor:**
- Stage N: Extract [module] interface
- Stage N+1: Implement new [module]
- Stage N+2: Migrate consumers
- Stage N+3: Remove old code + verify

Adapt based on what the codebase actually needs. Ask the user ONE question:

```
Based on your codebase, I can generate plans for:
  (a) [inferred direction based on code analysis — e.g., "Adding user dashboard + admin panel"]
  (b) [alternative direction — e.g., "Production hardening: auth, testing, deploy"]
  (c) Something else — describe briefly

Which direction? (a/b/c)
```

**Step 3: Write stage plan files directly**

Write each stage plan file directly to `plans/active/`. Do not copy templates — write the full content.

Each stage plan file must include:
1. YAML frontmatter (title, type: stage, status: pending, created date, dependencies)
2. Agent directive: `> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.`
3. **Goal**, **Architecture**, **Tech Stack**, **Dependencies**
4. Task breakdown

For task breakdowns:
- **First 3 stages:** FULL detail — specific files (using actual paths from the codebase), failing tests, implementation steps with code snippets, commit messages, deliverable verification
- **Remaining stages:** Goal, Architecture, Dependencies, and task titles with brief descriptions

Conventions to enforce:
- **Match existing patterns:** Use the same test framework, file structure, and naming conventions already in the codebase
- **Sequential dependencies:** Each stage builds on prior stages
- **Test-driven:** Every task starts with failing tests, then implementation
- **Atomic commits:** Each task ends with `git add [files]` + `git commit -m "..."`
- **Deliverable verification:** Each stage ends with verification commands
- **Realistic file paths:** Use actual paths from the codebase, not generic placeholders

**Step 4: Display summary**

```
================================================================
PROJECT PLAN GENERATED
================================================================

  plans/active/stage-01-[name].md        ★ full task breakdown
  plans/active/stage-02-[name].md        ★ full task breakdown
  plans/active/stage-03-[name].md        ★ full task breakdown
  plans/active/stage-04-[name].md          outline
  ...

★ = ready to execute with superpowers:executing-plans

To execute: open a stage plan and paste into a new Claude Code session.
To archive: mv plans/active/stage-01-*.md plans/archive/
================================================================
```

Do NOT ask for confirmation before writing — just generate the files. Speed over ceremony.

#### marketplace module

```bash
if [ ! -f marketplace.json ]; then
  cp "$TEMPLATE_DIR/marketplace.json" marketplace.json && echo "  + marketplace.json"
else
  echo "  ~ marketplace.json already exists"
  echo "    To update: manually merge from templates/enterprise-enhancement/modules/marketplace/marketplace.json"
fi
```

#### hooks module

Merge hooks into existing `settings.json`. **Read the existing file first**, then merge — do not overwrite.

Read the existing `.claude/settings.json`. If it doesn't exist, create the base structure. Then merge each hook array by appending new entries.

For each hook file (security-scan, auto-format, type-check, audit-log):
1. Read the hook's JSON content
2. Check if a hook with the same `matcher` already exists in the settings
3. If not, append it to the appropriate array (PreToolUse or PostToolUse)
4. Write the updated settings.json back

Also merge permission deny rules if not already present.

```
  + hooks/security-scan → .claude/settings.json (PreToolUse)
  + hooks/auto-format → .claude/settings.json (PostToolUse)
  + hooks/type-check → .claude/settings.json (PostToolUse)
  + hooks/audit-log → .claude/settings.json (PostToolUse)
```

#### mcp module

If `.mcp.json` doesn't exist, create it. Auto-detect which MCP servers are relevant based on the codebase:
- **github** — always include (every project uses git)
- **filesystem** — always include
- **postgres/sqlite** — include if the project uses a database (check dependencies for prisma, drizzle, better-sqlite3, pg, etc.)
- **slack** — skip unless the project has slack-related code

```bash
if [ ! -f .mcp.json ]; then
  echo '{ "mcpServers": {} }' > .mcp.json
fi
# Merge each relevant server into mcpServers object
```

Do not ask which servers to add — infer from the codebase and install relevant ones.

#### claude-md-snippets module

Append selected snippets to the existing CLAUDE.md.

For each snippet:
1. Check if a similar section already exists in CLAUDE.md (search for the header)
2. If not, append the snippet content at the end of CLAUDE.md
3. Report what was added

```bash
# Example for agent-team-guide snippet
if ! grep -q "## Agent Team" CLAUDE.md 2>/dev/null; then
  cat "$TEMPLATE_DIR/claude-md-snippets/agent-team-guide.md" >> CLAUDE.md
  echo "  + Appended 'Agent Team' section to CLAUDE.md"
else
  echo "  ~ 'Agent Team' section already exists in CLAUDE.md"
fi
```

### Step 5: Display Summary and Next Steps

```
================================================================
Enterprise Enhancement Complete!
================================================================

Installed:
[list of what was installed]

Skipped (already existed):
[list of what was skipped]

================================================================
READY TO GO:
================================================================

1. Review .claude/rules/ — auto-populated from your codebase.
   Refine if needed: architecture.md, env.md, security-policy.md

2. Execute your first stage plan (if project-plans was installed):
   - Open plans/active/stage-01-*.md
   - Paste into a new Claude Code session
   - Claude follows it task-by-task (TDD, commits, verification)

3. Restart Claude Code to activate new agents, rules, and hooks

================================================================
```

### Step 6: Git Commit

Automatically commit the enhancement:

```bash
git add .claude/ plans/ marketplace.json .mcp.json CLAUDE.md 2>/dev/null
git commit -m "chore: add enterprise Claude Code enhancements

Installed modules: [list of modules that were installed]
Skipped modules: [list of modules that were already present]"
```

---

## Error Handling

If settings.json merge fails (malformed JSON):
```
ERROR: .claude/settings.json is not valid JSON. Fix it before running /enterprise-enhance.
       Use a JSON validator: https://jsonlint.com
```

If template not found:
```
ERROR: Enterprise enhancement templates not found.
       Clone claude-code-utils and run from that directory, or ensure
       the enterprise-starter skill is installed globally.
```

If a module partially installs:
```
WARNING: Some files could not be copied. Check the errors above.
         You can run /enterprise-enhance again to retry missing files.
```
