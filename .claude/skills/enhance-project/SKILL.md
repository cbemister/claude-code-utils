---
name: enhance-project
description: Enhance existing projects with Claude Code agents, skills, and quality improvements. Analyzes your codebase and adds best-practice tooling.
hooks:
  SubagentStart:
    - hooks:
        - type: command
          command: |
            echo ""
            echo "┌─────────────────────────────────────┐"
            case "$AGENT_TYPE" in
              "codebase-explorer") echo "│ 🔍 Exploring codebase structure" ;;
              "dependency-analyzer") echo "│ 📦 Analyzing dependencies" ;;
              "pattern-finder") echo "│ 🎯 Finding code patterns" ;;
              "test-writer") echo "│ 🧪 Generating tests" ;;
              "refactor-planner") echo "│ 🔧 Planning refactoring" ;;
              "debugger") echo "│ 🐛 Debugging issues" ;;
              "feature-planner") echo "│ 📋 Planning improvements" ;;
              *) echo "│ 🤖 Agent: $AGENT_TYPE" ;;
            esac
            echo "└─────────────────────────────────────┘"
  SubagentStop:
    - hooks:
        - type: command
          command: "echo '   ✓ $AGENT_TYPE complete'"
  Stop:
    - hooks:
        - type: prompt
          prompt: |
            Verify that /enhance-project completed properly:

            1. Was the target project validated?
            2. Was the project type and tech stack detected?
            3. Were existing Claude Code resources checked?
            4. Did the selected enhancement phases complete?
            5. Was the enhancement report generated?

            Context: $ARGUMENTS

            Return {"ok": true} if the enhancement completed successfully.
            Return {"ok": false, "reason": "specific issue"} if incomplete.
          timeout: 30
---

# Enhance Existing Project

Add Claude Code agents and skills to an existing project, analyze the codebase, and generate improvement recommendations.

## When to Use

Use this skill when you want to:
- Add Claude Code agents and skills to an existing project
- Analyze an existing codebase for patterns and improvements
- Generate tests for existing code
- Create a development plan for an existing project
- Run quality checks on your codebase

## Usage

```bash
/enhance-project [path]
```

**Arguments:**
- `path` - Optional: path to project (defaults to current directory)

## Instructions

### Step 1: Validate Target Project

```bash
TARGET_DIR="${1:-.}"

# Resolve to absolute path
TARGET_DIR=$(cd "$TARGET_DIR" && pwd)

if [ ! -d "$TARGET_DIR" ]; then
  echo "❌ Directory does not exist: $TARGET_DIR"
  exit 1
fi

# Check if it's a valid project (has package.json, Cargo.toml, pyproject.toml, etc.)
if [ ! -f "$TARGET_DIR/package.json" ] && \
   [ ! -f "$TARGET_DIR/Cargo.toml" ] && \
   [ ! -f "$TARGET_DIR/pyproject.toml" ] && \
   [ ! -f "$TARGET_DIR/go.mod" ] && \
   [ ! -f "$TARGET_DIR/pom.xml" ] && \
   [ ! -f "$TARGET_DIR/build.gradle" ]; then
  echo "⚠️  No recognized project manifest found"
  echo "Supported: package.json, Cargo.toml, pyproject.toml, go.mod, pom.xml, build.gradle"
  # Continue anyway - might be a simple project
fi

cd "$TARGET_DIR" || exit 1
PROJECT_NAME=$(basename "$TARGET_DIR")

echo ""
echo "🔧 Enhancing project: $PROJECT_NAME"
echo "📁 Location: $TARGET_DIR"
echo ""
```

### Step 2: Detect Project Type and Tech Stack

```bash
# Claude: Analyze the project to detect:
# - Primary language (TypeScript, JavaScript, Python, Go, Rust, Java)
# - Framework (Next.js, Express, React, FastAPI, etc.)
# - Build tools (npm, yarn, pnpm, cargo, pip, go)
# - Testing framework (Jest, Vitest, Pytest, etc.)
# - Database (if present)

echo "📊 Analyzing project structure..."

# Use codebase-explorer agent to understand the project
# Claude: Invoke codebase-explorer agent with prompt:
# "Analyze this project and report:
#  - Primary language and version
#  - Framework(s) used
#  - Project structure pattern (monorepo, standard, etc.)
#  - Key directories and their purpose
#  - Build and test configuration"
```

### Step 3: Check Existing Claude Code Resources

```bash
echo ""
echo "🔍 Checking existing Claude Code resources..."

AGENTS_EXIST=false
SKILLS_EXIST=false
CLAUDE_MD_EXISTS=false
PLANS_EXIST=false

if [ -d ".claude/agents" ]; then
  AGENTS_EXIST=true
  AGENT_COUNT=$(find .claude/agents -name "*.md" 2>/dev/null | wc -l)
  echo "   ✓ Agents directory exists ($AGENT_COUNT agents)"
else
  echo "   ○ No agents directory"
fi

if [ -d ".claude/skills" ]; then
  SKILLS_EXIST=true
  SKILL_COUNT=$(find .claude/skills -maxdepth 2 -name "SKILL.md" 2>/dev/null | wc -l)
  echo "   ✓ Skills directory exists ($SKILL_COUNT skills)"
else
  echo "   ○ No skills directory"
fi

if [ -f "CLAUDE.md" ]; then
  CLAUDE_MD_EXISTS=true
  echo "   ✓ CLAUDE.md exists"
else
  echo "   ○ No CLAUDE.md"
fi

if [ -d "plans" ]; then
  PLANS_EXIST=true
  echo "   ✓ Plans directory exists"
else
  echo "   ○ No plans directory"
fi

echo ""
```

### Step 3b: Assess Existing CLAUDE.md Quality

If CLAUDE.md exists, evaluate its quality:

```bash
if [ "$CLAUDE_MD_EXISTS" = true ]; then
  echo "📊 Assessing CLAUDE.md quality..."

  # Claude: Analyze existing CLAUDE.md against quality criteria:
  #
  # COMPLETENESS (25 points):
  # - Has Overview section (5 pts)
  # - Has Tech Stack section (5 pts)
  # - Has Project Structure section (5 pts)
  # - Has Commands section (5 pts)
  # - Has Key Files section (5 pts)
  #
  # ACCURACY (25 points):
  # - Tech stack matches package.json/requirements.txt/etc (10 pts)
  # - File paths referenced actually exist (10 pts)
  # - Commands are correct and work (5 pts)
  #
  # SPECIFICITY (20 points):
  # - Contains project-specific patterns, not generic (10 pts)
  # - Has unique conventions documented (5 pts)
  # - Explains "why" not just "what" (5 pts)
  #
  # CODE EXAMPLES (15 points):
  # - Has actual code examples (10 pts)
  # - Examples are from this project (5 pts)
  #
  # MAINTENANCE (15 points):
  # - Versions match current dependencies (10 pts)
  # - No obviously stale information (5 pts)
  #
  # Calculate total score (0-100)
  # Generate improvement suggestions for areas scoring < 80%

  echo "   Quality score: $QUALITY_SCORE/100"

  if [ "$QUALITY_SCORE" -lt 80 ]; then
    echo "   ⚠️  Improvements recommended"
  else
    echo "   ✓ CLAUDE.md meets quality standards"
  fi

  echo ""
fi
```

### Step 4: Determine Enhancement Scope

Based on what exists, determine what needs to be added:

```bash
# Show enhancement options
echo "📋 Enhancement Options:"
echo ""
echo "   💡 Recommended: Run on a git branch for safe experimentation"
echo ""
echo "   1. Full Enhancement     - Resources + analysis + code improvements"
echo "   2. Resources Only       - Add agents, skills, CLAUDE.md (no code changes)"
echo "   3. Analysis Only        - Report only (no changes)"
echo "   4. Code Improvements    - Fix issues, refactor, add tests"
echo "   5. CLAUDE.md Review     - Review/improve existing CLAUDE.md only"
echo "   6. Custom               - Choose specific enhancements"
echo ""

# Claude: Present as selection menu and capture ENHANCEMENT_SCOPE
# Map: 1=full, 2=resources, 3=analysis, 4=improvements, 5=custom

# For custom, show checkboxes:
# [ ] Copy agents
# [ ] Copy skills
# [ ] Create/update CLAUDE.md
# [ ] Run codebase analysis
# [ ] Generate tests
# [ ] Apply code improvements (refactor, fix issues)
# [ ] Create development plan
# [ ] Run quality checks
# [ ] Check dependencies
```

### Step 5: Copy Agents (if selected)

```bash
if [ "$COPY_AGENTS" = true ]; then
  echo ""
  echo "📦 Phase 1: Adding Agents"
  echo ""

  mkdir -p .claude/agents

  # Determine which agents to copy based on project type
  # Claude: Based on detected tech stack, select appropriate agents:
  # - All projects: codebase-explorer, pattern-finder, debugger
  # - Web projects: ui-ux-designer, component-builder, api-developer
  # - API projects: api-developer, test-writer, architecture-planner
  # - Libraries: test-writer, pattern-finder, dependency-analyzer

  # Copy from shared resources
  SHARED_AGENTS_DIR="path/to/claude-code-shared/.claude/agents"

  # Copy explore agents (useful for all projects)
  cp -r "$SHARED_AGENTS_DIR/explore/"* .claude/agents/explore/ 2>/dev/null
  echo "   ✓ Added explore agents (codebase-explorer, dependency-analyzer, pattern-finder)"

  # Copy implement agents
  cp -r "$SHARED_AGENTS_DIR/implement/"* .claude/agents/implement/ 2>/dev/null
  echo "   ✓ Added implement agents (api-developer, component-builder, debugger, test-writer)"

  # Copy plan agents
  cp -r "$SHARED_AGENTS_DIR/plan/"* .claude/agents/plan/ 2>/dev/null
  echo "   ✓ Added plan agents (architecture-planner, feature-planner, refactor-planner)"

  # Copy design agents (for UI projects)
  if [ "$HAS_UI" = true ]; then
    cp -r "$SHARED_AGENTS_DIR/design/"* .claude/agents/design/ 2>/dev/null
    echo "   ✓ Added design agents (ui-ux-designer)"
  fi

  echo ""
fi
```

### Step 6: Copy Skills (if selected)

```bash
if [ "$COPY_SKILLS" = true ]; then
  echo "📦 Phase 2: Adding Skills"
  echo ""

  mkdir -p .claude/skills

  SHARED_SKILLS_DIR="path/to/claude-code-shared/.claude/skills"

  # Core workflow skills (all projects)
  CORE_SKILLS="ship verify-work organize-commits track-progress"

  # Development skills
  DEV_SKILLS="create-plan plan-status generate-tests performance-check"

  # Git workflow skills
  GIT_SKILLS="worktree-create worktree-sync worktree-cleanup"

  for skill in $CORE_SKILLS $DEV_SKILLS $GIT_SKILLS; do
    if [ -d "$SHARED_SKILLS_DIR/$skill" ]; then
      cp -r "$SHARED_SKILLS_DIR/$skill" .claude/skills/
    fi
  done

  echo "   ✓ Added workflow skills (ship, verify-work, organize-commits, track-progress)"
  echo "   ✓ Added development skills (create-plan, plan-status, generate-tests, performance-check)"
  echo "   ✓ Added git workflow skills (worktree-create, worktree-sync, worktree-cleanup)"
  echo ""
fi
```

### Step 7: Create/Update CLAUDE.md (if selected)

```bash
if [ "$CREATE_CLAUDE_MD" = true ]; then
  echo "📝 Phase 3: Creating/Updating CLAUDE.md"
  echo ""

  if [ "$CLAUDE_MD_EXISTS" = true ] && [ "$QUALITY_SCORE" -ge 80 ]; then
    echo "   ℹ️  Existing CLAUDE.md meets quality standards (score: $QUALITY_SCORE/100)"
    echo "   Skipping regeneration (use 'CLAUDE.md Review' option to force update)"
  else
    # Determine appropriate template based on detected tech stack
    echo "   ✓ Selecting appropriate template..."
    # Claude: Select template from templates/claude-md/ based on:
    # - Next.js detected → nextjs-app.md
    # - Express/Fastify/NestJS detected → api-service.md
    # - CLI tool (commander.js, yargs, etc.) → cli-tool.md
    # - React library detected → node-library.md
    # - Python project detected → python-app.md
    # - Phaser.js/game detected → game-browser.md
    # - Unknown/minimal → minimal.md

    # Use pattern-finder to understand project conventions
    echo "   ✓ Using pattern-finder to analyze conventions..."
    # Claude: Invoke pattern-finder agent with prompt:
    # "Analyze this project and identify:
    #  - Code style and formatting conventions
    #  - Naming conventions (files, functions, variables)
    #  - Import/module patterns
    #  - Error handling patterns
    #  - Testing patterns
    #  - Documentation patterns"

    # Generate CLAUDE.md from selected template
    # Claude: Create CLAUDE.md by:
    # 1. Start with selected template from templates/claude-md/
    # 2. Replace placeholders ([Project Name], etc.) with actual values
    # 3. Add patterns found by pattern-finder agent
    # 4. Fill in tech stack from detected dependencies
    # 5. Document actual project structure
    # 6. Add real file paths for key files
    # 7. Follow quality standards from docs/best-practices/claude-md-authoring.md
    # 8. Validate against quality criteria from Step 3b

    echo "   ✓ Generated CLAUDE.md from template: $SELECTED_TEMPLATE"

    # Calculate new quality score
    # Claude: Re-assess the generated CLAUDE.md using same criteria from Step 3b
    echo "   ✓ Quality score: $NEW_QUALITY_SCORE/100"
  fi

  if [ "$CLAUDE_MD_EXISTS" = true ] && [ "$IMPROVE_EXISTING" = true ]; then
    echo "   ✓ Improving existing CLAUDE.md..."
    # Claude: Instead of replacing, improve existing CLAUDE.md:
    # 1. Identify sections scoring below 80% (from Step 3b assessment)
    # 2. For Completeness: Add missing required sections
    # 3. For Accuracy: Update file paths, tech stack versions, commands
    # 4. For Specificity: Replace generic content with project-specific patterns
    # 5. For Code Examples: Add real code examples from the project
    # 6. For Maintenance: Update outdated dependency versions
    # 7. Preserve all custom content and non-generic sections
    # 8. Validate final result meets quality standards

    echo "   ✓ Improved existing CLAUDE.md (preserved custom content)"
    echo "   ✓ New quality score: $IMPROVED_SCORE/100"
  fi

  echo ""
fi
```

### Step 8: Run Codebase Analysis (if selected)

```bash
if [ "$RUN_ANALYSIS" = true ]; then
  echo ""
  echo "🔍 Phase 4: Codebase Analysis (PARALLEL)"
  echo ""

  # ⚡ PERFORMANCE TIP: These three agents are independent and should run in parallel

  # Run all three simultaneously for faster analysis
  echo "   ✓ Running analysis agents in parallel..."

  # Claude: Invoke these three agents simultaneously (parallel Task calls):

  # 1. codebase-explorer - Map project structure
  # "Analyze this project and report:
  #  - Primary language and version
  #  - Framework(s) used
  #  - Project structure pattern (monorepo, standard, etc.)
  #  - Key directories and their purpose
  #  - Build and test configuration"

  # 2. dependency-analyzer - Check dependencies
  # "Analyze dependencies in this project:
  #  - Check for security vulnerabilities
  #  - Identify outdated packages
  #  - Find unused dependencies
  #  - Check for circular dependencies
  #  - Verify license compatibility"

  # 3. pattern-finder - Identify code patterns
  # "Analyze this project and identify:
  #  - Code style and formatting conventions
  #  - Naming conventions (files, functions, variables)
  #  - Import/module patterns
  #  - Error handling patterns
  #  - Testing patterns
  #  - Documentation patterns"

  # Wait for all three agents to complete
  # Synthesize findings from all three agents

  echo ""
fi
```

### Step 9: Generate Tests (if selected)

```bash
if [ "$GENERATE_TESTS" = true ]; then
  echo ""
  echo "🧪 Phase 5: Test Generation"
  echo ""

  # Identify untested code
  echo "   ✓ Analyzing test coverage..."

  # Use test-writer to generate tests for untested files
  echo "   ✓ Using test-writer to generate tests..."
  # Claude: Invoke test-writer agent with prompt:
  # "Generate tests for untested code in this project:
  #  - Identify files without test coverage
  #  - Generate unit tests for utilities
  #  - Generate integration tests for APIs
  #  - Generate component tests for UI
  #  - Follow existing test patterns"

  # Use /generate-tests skill for additional coverage
  echo "   ✓ Using /generate-tests skill..."
  # Claude: Invoke /generate-tests skill

  echo ""
fi
```

### Step 10: Apply Code Improvements (if selected)

**IMPORTANT:** This step makes actual code changes. Recommended to run on a git branch.

```bash
if [ "$APPLY_IMPROVEMENTS" = true ]; then
  echo ""
  echo "🔧 Phase 6: Code Improvements"
  echo ""

  # ⚡ PERFORMANCE TIP: Run verification checks in parallel
  echo "   ✓ Running quality checks in parallel..."

  # Claude: Invoke these simultaneously:
  # - /verify-work (security, best practices, standards)
  # - /performance-check (performance anti-patterns)
  # Store results from both for fixing

  # Use refactor-planner to identify refactorings
  echo "   ✓ Using refactor-planner to identify improvements..."
  # Claude: Invoke refactor-planner agent with prompt:
  # "Analyze this project and identify refactoring opportunities:
  #  - Code duplication to extract
  #  - Complex functions to simplify
  #  - Outdated patterns to modernize
  #  - Missing abstractions
  #  - Type safety improvements"

  # Fix security issues found by verify-work
  if [ "$HAS_SECURITY_ISSUES" = true ]; then
    echo "   ✓ Fixing security vulnerabilities..."
    # Claude: Apply fixes for security issues found
  fi

  # Fix performance issues
  if [ "$HAS_PERFORMANCE_ISSUES" = true ]; then
    echo "   ✓ Resolving performance bottlenecks..."
    # Claude: Apply performance fixes
  fi

  # Apply refactorings
  echo "   ✓ Applying code improvements..."
  # Claude: Apply refactorings from refactor-planner

  # Use debugger for any bugs found
  if [ "$HAS_BUGS" = true ]; then
    echo "   ✓ Using debugger to fix issues..."
    # Claude: Invoke debugger agent to fix bugs
  fi

  echo ""
fi
```

### Step 11: Create Development Plan (if selected)

```bash
if [ "$CREATE_PLAN" = true ]; then
  echo ""
  echo "📋 Phase 6: Development Plan"
  echo ""

  mkdir -p plans/active

  # Use feature-planner to analyze and plan
  echo "   ✓ Using feature-planner to analyze improvement opportunities..."
  # Claude: Invoke feature-planner agent with prompt:
  # "Analyze this existing project and identify:
  #  - Code quality improvements needed
  #  - Missing features that would be valuable
  #  - Refactoring opportunities
  #  - Performance optimizations
  #  - Security improvements
  #  Create a prioritized task list"

  # Use /create-plan to generate plan file
  echo "   ✓ Using /create-plan to create development plan..."
  # Claude: Invoke /create-plan skill with name "improvements"

  echo ""
fi
```

### Step 12: Organize Commits (if changes were made)

```bash
if [ "$HAS_CHANGES" = true ]; then
  echo ""
  echo "📦 Phase 7: Organizing Commits"
  echo ""

  # Use /organize-commits to create logical commits
  echo "   ✓ Using /organize-commits to create logical commits..."
  # Claude: Invoke /organize-commits skill to create commits like:
  # - "feat: add Claude Code agents and skills"
  # - "refactor: improve code structure" (if code improvements applied)
  # - "fix: resolve security issues" (if security fixes applied)
  # - "test: add comprehensive test coverage" (if tests generated)
  # - "perf: optimize performance bottlenecks" (if perf improvements applied)
  # - "docs: add CLAUDE.md and improve documentation"

  # Use /track-progress to record enhancements
  echo "   ✓ Using /track-progress to record enhancements..."
  # Claude: Invoke /track-progress skill

  echo ""
fi
```

### Step 13: Generate Enhancement Report

```bash
echo ""
echo "================================================================"
echo "✅ Enhancement Complete: $PROJECT_NAME"
echo "================================================================"
echo ""

# Count what was added/analyzed
if [ "$COPY_AGENTS" = true ]; then
  AGENT_COUNT=$(find .claude/agents -name "*.md" 2>/dev/null | wc -l)
  echo "📦 Agents added: $AGENT_COUNT"
fi

if [ "$COPY_SKILLS" = true ]; then
  SKILL_COUNT=$(find .claude/skills -maxdepth 2 -name "SKILL.md" 2>/dev/null | wc -l)
  echo "📦 Skills added: $SKILL_COUNT"
fi

if [ "$CREATE_CLAUDE_MD" = true ]; then
  echo "📝 CLAUDE.md created with project conventions"
fi

if [ "$RUN_ANALYSIS" = true ]; then
  echo "🔍 Codebase analysis complete"
fi

if [ "$GENERATE_TESTS" = true ]; then
  TEST_COUNT=$(find . -name "*.test.*" -o -name "*.spec.*" 2>/dev/null | wc -l)
  echo "🧪 Tests: $TEST_COUNT test files"
fi

if [ "$CREATE_PLAN" = true ]; then
  echo "📋 Development plan: plans/active/improvements/plan.md"
fi

echo ""

# Show CLAUDE.md improvement suggestions if quality is below threshold
if [ "$CLAUDE_MD_EXISTS" = true ] && [ "$QUALITY_SCORE" -lt 80 ]; then
  echo "📋 CLAUDE.md Improvement Suggestions:"
  echo ""
  # Claude: Output specific suggestions based on scoring from Step 3b:
  #
  # For COMPLETENESS issues:
  # - "Add Overview section explaining what the project does"
  # - "Add Tech Stack section with framework versions"
  # - "Add Project Structure section with directory layout"
  # - "Add Commands section with dev/build/test commands"
  # - "Add Key Files section with important file purposes"
  #
  # For ACCURACY issues:
  # - "Update Next.js version from 13 to 14 in Tech Stack"
  # - "Fix path to database schema (should be drizzle/schema.ts not db/schema.ts)"
  # - "Update 'npm run dev' command (actual command is 'npm start')"
  #
  # For SPECIFICITY issues:
  # - "Replace generic component pattern with actual custom hook pattern found in codebase"
  # - "Document the withAuth wrapper pattern used in all protected routes"
  # - "Add project-specific validation pattern (Zod schemas in schemas/ directory)"
  #
  # For CODE EXAMPLES issues:
  # - "Add code example showing the actual API route pattern used in app/api/"
  # - "Add example of how authentication middleware is used"
  # - "Show actual database query pattern from services/ layer"
  #
  # For MAINTENANCE issues:
  # - "Update PostgreSQL version from 14 to 15"
  # - "Remove reference to old auth library (now using NextAuth)"
  # - "Update Node version requirement to match package.json engines field"
  echo ""
fi

echo "🎯 Next Steps:"
echo ""
echo "   1. Review CLAUDE.md for accuracy"
echo "   2. Check plans/active/improvements/plan.md for suggested tasks"
echo "   3. Explore .claude/agents/ to see available agents"
echo "   4. Use /plan-status to track your improvements"
echo ""
echo "💡 Suggested Commands:"
echo ""
echo "   /plan-status              - View your improvement plan"
echo "   /verify-work              - Run quality checks"
echo "   /ship                     - Commit your progress"
echo ""
```

## Example Usage

### Enhance Current Project
```bash
/enhance-project
```

### Enhance Specific Project
```bash
/enhance-project ../my-existing-app
```

### Full Enhancement with Analysis
```bash
/enhance-project .
# Select: 1 (Full Enhancement)
```

## What Gets Added

Based on selection, the skill can add:

- **Agents** - All 11 sub-agents organized by category
- **Skills** - All 11 workflow skills
- **CLAUDE.md** - Project-specific conventions and instructions
- **plans/** - Development plan directory with improvement tasks
- **Tests** - Generated tests for untested code

## Enhancement vs Starter Project

| Aspect | `/starter-project` | `/enhance-project` |
|--------|-------------------|-------------------|
| **Target** | New projects | Existing projects |
| **Creates files** | Yes (scaffold) | Minimal (resources only) |
| **Analyzes code** | No existing code | Yes, deeply |
| **Generates tests** | For new code | For existing code |
| **Creates plan** | Getting-started | Improvements |
| **Respects existing** | N/A | Yes, non-destructive |

## Tips

- **Backup first**: While non-destructive, consider committing before enhancing
- **Review CLAUDE.md**: The generated conventions may need adjustment
- **Check the plan**: The improvement plan prioritizes based on analysis
- **Incremental enhancement**: Use "Custom" to add resources gradually
- **Re-run analysis**: Use "Analysis Only" after making changes

## Troubleshooting

**No project manifest found**
- The skill works without one but may not detect the tech stack accurately
- Add a package.json, Cargo.toml, etc. for better detection

**Agents/skills not copied**
- Ensure the shared resources directory is accessible
- Check that source files exist in claude-code-shared

**CLAUDE.md seems inaccurate**
- Review and edit manually
- Re-run with "Create/update CLAUDE.md" to regenerate
