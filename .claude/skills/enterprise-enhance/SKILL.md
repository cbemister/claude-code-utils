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

### Step 2: Present Module Selection

Show the user what's available and pre-check modules that aren't yet installed:

```
================================================================
Enterprise Enhancement Pack — Select Modules to Install
================================================================

Which modules would you like to add? (those already present are noted)

[ ] agent-teams          — 8 enterprise specialist agents
                           coordinator, backend-architect, frontend-architect,
                           security-auditor, test-engineer, devops-engineer,
                           code-reviewer, performance-analyst

[ ] rules                — Project knowledge base (.claude/rules/)
                           architecture, api-conventions, security-policy,
                           code-standards, testing-standards, env

[ ] context-management   — Plans + session memory workflow
                           feature/bugfix/context-handoff plan templates,
                           memory setup guide

[ ] marketplace          — Plugin marketplace (marketplace.json)
                           Publish your agents as installable plugins

[ ] hooks                — Safety + automation hooks
                           secret-scan, auto-format, type-check, audit-log

[ ] mcp                  — MCP server stubs
                           github, postgres, slack, filesystem

[ ] claude-md-snippets   — CLAUDE.md sections to add
                           agent-team-guide, rules-guide,
                           context-management, enterprise-standards

Select all that apply (or type 'all' for everything):
```

Use AskUserQuestion if running in an interactive context, otherwise prompt for a comma-separated list.

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

#### context-management module

```bash
mkdir -p plans/active plans/archive plans/templates
# Copy plan templates, skipping existing ones
for template in feature-plan bugfix-plan context-handoff; do
  if [ ! -f "plans/templates/$template.md" ]; then
    cp "$TEMPLATE_DIR/plans/templates/$template.md" plans/templates/ 2>/dev/null && echo "  + plans/templates/$template.md" || echo "  ! Not found"
  else
    echo "  ~ plans/templates/$template.md (already exists, skipped)"
  fi
done
```

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

If `.mcp.json` doesn't exist, create it with selected servers.
If it exists, show the user which servers are missing and let them choose which to add.

```bash
if [ ! -f .mcp.json ]; then
  echo '{ "mcpServers": {} }' > .mcp.json
fi
# Merge each selected server into mcpServers object
```

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
NEXT STEPS:
================================================================

[Show only relevant steps based on what was installed]

IF rules were installed:
  1. Customize .claude/rules/ files — replace [PLACEHOLDER] values
     Start with: architecture.md, then env.md, then the rest

IF agent-teams were installed:
  2. Restart Claude Code to activate new agents

IF marketplace was installed:
  3. Update marketplace.json with your owner details
     Validate: claude plugin validate .

IF mcp was installed:
  4. Set environment variables for MCP servers you enabled
     Reference: .claude/rules/env.md

IF hooks were installed:
  5. Review .claude/settings.json hooks — adjust patterns as needed

IF claude-md-snippets were installed:
  6. Open CLAUDE.md and customize the new sections

================================================================
```

### Step 6: Offer to Commit

```
Commit these changes to git? (y/n)
```

If yes, create a commit with a summary of what was added.

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
