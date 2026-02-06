---
name: starter-project
description: Generate starter projects pre-configured with Claude Code agents and skills. Choose from SaaS app, API service, component library, CLI tool, e-commerce, or browser game templates.
---

# Starter Project Generator

Generate complete starter projects pre-configured to use all Claude Code shared resource agents and skills.

## When to Use

Use this skill when you want to:
- Start a new project with agents and skills pre-configured
- Learn how to use the shared resource agents through working examples
- Bootstrap a real project with best practices built-in
- Get suggested first features mapped to specific agents

## Usage

```bash
/starter-project [category] [name]
```

**Arguments:**
- `category` - Optional: saas, api, components, cli, ecommerce, game
- `name` - Optional: project name (will be prompted if not provided)

## Available Templates

1. **saas** - Full-stack Next.js SaaS application
2. **api** - Node.js REST API service
3. **components** - React component library with Storybook
4. **cli** - Command-line tool
5. **ecommerce** - Next.js e-commerce store
6. **game** - Browser-based game

## Instructions

### Step 1: Parse Arguments and Get Category

```bash
CATEGORY="${1:-}"
PROJECT_NAME="${2:-}"

# If no category provided, show interactive menu
if [ -z "$CATEGORY" ]; then
  echo "What type of starter project would you like to create?"
  echo ""
  echo "1. SaaS Web App      - Full-stack Next.js with auth and dashboard"
  echo "2. API Service       - Node.js REST API with testing"
  echo "3. Component Library - React components with Storybook"
  echo "4. CLI Tool          - Command-line application"
  echo "5. E-Commerce Store  - Next.js store with Stripe integration"
  echo "6. Browser Game      - Canvas/Phaser game"
  echo ""

  # Note: In practice, Claude will present this as a selection menu
  # and the user's choice will be captured

  # Map selection to category
  case "$SELECTION" in
    1|saas|"SaaS Web App") CATEGORY="saas" ;;
    2|api|"API Service") CATEGORY="api" ;;
    3|components|"Component Library") CATEGORY="components" ;;
    4|cli|"CLI Tool") CATEGORY="cli" ;;
    5|ecommerce|"E-Commerce Store") CATEGORY="ecommerce" ;;
    6|game|"Browser Game") CATEGORY="game" ;;
    *)
      echo "❌ Invalid selection"
      exit 1
      ;;
  esac
fi
```

### Step 2: Get Project Name

```bash
# If no project name provided, prompt for it
if [ -z "$PROJECT_NAME" ]; then
  echo ""
  echo "What would you like to name your project?"
  # User will provide PROJECT_NAME

  if [ -z "$PROJECT_NAME" ]; then
    echo "❌ Project name is required"
    exit 1
  fi
fi

# Convert to kebab-case
PROJECT_NAME=$(echo "$PROJECT_NAME" | tr '[:upper:]' '[:lower:]' | tr '_' '-' | tr ' ' '-')

echo ""
echo "Creating $CATEGORY project: $PROJECT_NAME..."
echo ""
```

### Step 3: Validate Target Directory

```bash
# Projects are created as sibling folders
TARGET_DIR="../$PROJECT_NAME"

if [ -d "$TARGET_DIR" ]; then
  echo "❌ Directory already exists: $TARGET_DIR"
  echo "Please choose a different name or remove the existing directory"
  exit 1
fi
```

### Step 4: Determine Template Configuration

Based on the category, set up the template configuration:

```bash
case "$CATEGORY" in
  saas)
    TEMPLATE_NAME="SaaS Web App"
    TECH_STACK="Next.js 14, TypeScript, Tailwind CSS, NextAuth, Drizzle ORM"
    AGENTS_TO_COPY="all"
    ;;
  api)
    TEMPLATE_NAME="API Service"
    TECH_STACK="Node.js, Express, TypeScript, Vitest"
    AGENTS_TO_COPY="explore/codebase-explorer explore/dependency-analyzer explore/pattern-finder plan/architecture-planner implement/api-developer implement/test-writer implement/debugger"
    ;;
  components)
    TEMPLATE_NAME="Component Library"
    TECH_STACK="React, TypeScript, Storybook, Vitest, CSS Modules"
    AGENTS_TO_COPY="explore/pattern-finder plan/feature-planner implement/component-builder implement/test-writer design/ui-ux-designer"
    ;;
  cli)
    TEMPLATE_NAME="CLI Tool"
    TECH_STACK="Node.js, TypeScript, Commander.js, Vitest"
    AGENTS_TO_COPY="explore/pattern-finder implement/test-writer implement/debugger"
    ;;
  ecommerce)
    TEMPLATE_NAME="E-Commerce Store"
    TECH_STACK="Next.js 14, TypeScript, Stripe, Drizzle ORM"
    AGENTS_TO_COPY="all"
    ;;
  game)
    TEMPLATE_NAME="Browser Game"
    TECH_STACK="TypeScript, Phaser.js, Vite"
    AGENTS_TO_COPY="explore/codebase-explorer implement/component-builder implement/debugger design/ui-ux-designer"
    ;;
  *)
    echo "❌ Unknown category: $CATEGORY"
    exit 1
    ;;
esac

echo "📦 Template: $TEMPLATE_NAME"
echo "🔧 Tech Stack: $TECH_STACK"
echo ""
```

### Step 4b: Select CLAUDE.md Template

Based on the project category, select the appropriate CLAUDE.md template:

```bash
case "$CATEGORY" in
  saas|ecommerce)
    CLAUDE_TEMPLATE="templates/claude-md/nextjs-app.md"
    ;;
  api)
    CLAUDE_TEMPLATE="templates/claude-md/api-service.md"
    ;;
  components)
    CLAUDE_TEMPLATE="templates/claude-md/node-library.md"
    ;;
  cli)
    CLAUDE_TEMPLATE="templates/claude-md/cli-tool.md"
    ;;
  game)
    CLAUDE_TEMPLATE="templates/claude-md/game-browser.md"
    ;;
  *)
    CLAUDE_TEMPLATE="templates/claude-md/minimal.md"
    ;;
esac

echo "📝 CLAUDE.md template: $CLAUDE_TEMPLATE"
```

### Step 5: Create Project Directory Structure

```bash
mkdir -p "$TARGET_DIR"
cd "$TARGET_DIR" || exit 1

echo "✓ Created project directory"
```

### Step 6: Copy Agents and Skills

```bash
# Copy relevant agents
mkdir -p .claude/agents

if [ "$AGENTS_TO_COPY" = "all" ]; then
  # Copy all agent categories
  cp -r "$(dirname "$SKILL_DIR")/../../agents/"* .claude/agents/
  echo "✓ Copied all agents (explore, plan, implement, design)"
else
  # Copy specific agents
  for agent_path in $AGENTS_TO_COPY; do
    agent_category=$(dirname "$agent_path")
    agent_name=$(basename "$agent_path")

    mkdir -p ".claude/agents/$agent_category"
    cp "$(dirname "$SKILL_DIR")/../../agents/$agent_path.md" ".claude/agents/$agent_category/" 2>/dev/null || true
  done
  echo "✓ Copied relevant agents"
fi

# Copy relevant skills (common workflow skills for all templates)
mkdir -p .claude/skills

SKILLS_TO_COPY="ship verify-work organize-commits track-progress generate-tests performance-check worktree-create worktree-sync worktree-cleanup create-plan plan-status"

for skill in $SKILLS_TO_COPY; do
  if [ -d "$(dirname "$SKILL_DIR")/../$skill" ]; then
    cp -r "$(dirname "$SKILL_DIR")/../$skill" .claude/skills/
  fi
done

echo "✓ Copied development workflow skills"
```

### Step 7: Use Agents and Skills to Build the Project

**IMPORTANT:** This step demonstrates all Claude Code resources working together. Each agent and skill is invoked to build different parts of the project.

```bash
echo ""
echo "📁 Phase 1: Setup & Planning"
echo ""

# Initialize git first (we'll use /organize-commits later for logical commits)
git init -q
echo "✓ Initialized git repository"

# Create plans directory
mkdir -p plans/active

# Use /create-plan to create the getting-started plan
echo "✓ Using /create-plan to initialize getting-started plan..."
# Claude: Invoke /create-plan skill with:
# Name: "getting-started"
# Template: guide
# This creates plans/active/getting-started/plan.md

# Use architecture-planner to design the project
echo "✓ Using architecture-planner to design project structure..."
# Claude: Invoke architecture-planner agent with prompt:
# "Design a $TEMPLATE_NAME project called $PROJECT_NAME with tech stack: $TECH_STACK
#  Include: project structure, data models (if applicable), API endpoints, component hierarchy"

echo ""
echo "🎨 Phase 2: Design"
echo ""

# Use ui-ux-designer to create the design system
echo "✓ Using ui-ux-designer to create design system..."
# Claude: Invoke ui-ux-designer agent with prompt:
# "Create a design system for $PROJECT_NAME ($TEMPLATE_NAME) with:
#  - Professional color palette (not AI-generic)
#  - Typography scale
#  - Spacing system
#  - Component designs for: Button, Input, Card
#  - Layout structure appropriate for $TEMPLATE_NAME"

# Use feature-planner to plan initial features
echo "✓ Using feature-planner to plan initial features..."
# Claude: Invoke feature-planner agent with prompt:
# "Plan the initial features for $PROJECT_NAME ($TEMPLATE_NAME).
#  Break down into small tasks suitable for the getting-started plan.
#  Map each task to the appropriate agent (api-developer, component-builder, etc.)"

echo ""
echo "⚡ Phase 3: Implementation"
echo ""

# Generate base configuration files first
echo "✓ Generating base configuration files..."
# Claude: Generate package.json, tsconfig.json, etc. based on $CATEGORY

# Create CLAUDE.md from template
echo "✓ Creating CLAUDE.md from template..."
# Claude: Create CLAUDE.md by:
# 1. Copy template from $CLAUDE_TEMPLATE (selected in Step 4b)
# 2. Replace [Project Name] with $PROJECT_NAME
# 3. Replace [Tool Name]/[CLI Tool Name] with $PROJECT_NAME
# 4. Fill in tech stack based on $TECH_STACK
# 5. Update project structure to match generated files
# 6. Add project-specific patterns based on $CATEGORY
# 7. Reference docs/best-practices/claude-md-authoring.md for quality standards
# 8. Remove template sections not applicable to $CATEGORY

# Use api-developer to create API endpoints
echo "✓ Using api-developer to create API endpoints..."
# Claude: Invoke api-developer agent with prompt:
# "Create initial API endpoints for $PROJECT_NAME:
#  - Health check at /api/health
#  - Auth endpoints (if applicable for $TEMPLATE_NAME)
#  - One CRUD resource appropriate for $TEMPLATE_NAME
#  - Include Zod validation, error handling, proper types"

# Use component-builder to build UI components
echo "✓ Using component-builder to build UI components..."
# Claude: Invoke component-builder agent with prompt:
# "Build the UI components designed by ui-ux-designer for $PROJECT_NAME:
#  - Apply the design system (colors, typography, spacing)
#  - Include TypeScript props and types
#  - Add accessibility features (ARIA, keyboard navigation)
#  - Create loading and error states
#  - Build: Button, Input, Card, and layout components"

echo ""
echo "🧪 Phase 4: Testing & Quality"
echo ""

# Use test-writer to generate tests
echo "✓ Using test-writer to generate tests..."
# Claude: Invoke test-writer agent with prompt:
# "Create comprehensive tests for $PROJECT_NAME:
#  - API endpoint tests (request/response validation, edge cases)
#  - UI component tests (rendering, interactions, accessibility)
#  - Utility tests (if any utilities were created)"

# Use /generate-tests skill
echo "✓ Using /generate-tests skill to ensure coverage..."
# Claude: Invoke /generate-tests skill to create any missing test files

# Use /verify-work to validate code
echo "✓ Using /verify-work to validate code quality..."
# Claude: Invoke /verify-work skill to check:
# - Security issues, best practices, code standards

# Use /performance-check
echo "✓ Using /performance-check to identify issues..."
# Claude: Invoke /performance-check skill

echo ""
echo "✅ Phase 5: Verification"
echo ""

# Use codebase-explorer to verify structure
echo "✓ Using codebase-explorer to verify project structure..."
# Claude: Invoke codebase-explorer agent to confirm structure matches design

# Use dependency-analyzer to check packages
echo "✓ Using dependency-analyzer to validate dependencies..."
# Claude: Invoke dependency-analyzer agent to check for issues

# Use pattern-finder to ensure consistency
echo "✓ Using pattern-finder to ensure consistency..."
# Claude: Invoke pattern-finder agent to verify patterns are consistent

echo ""
echo "📦 Phase 6: Ship"
echo ""

# Use /organize-commits to create logical commit history
echo "✓ Using /organize-commits to create commit history..."
# Claude: Invoke /organize-commits skill to create commits like:
# - "chore: initial project setup"
# - "feat(db): add database schema" (if applicable)
# - "feat(api): add API endpoints"
# - "feat(ui): add design system and components"
# - "test: add comprehensive test coverage"
# - "docs: add CLAUDE.md and README"

# Use /track-progress to record what was created
echo "✓ Using /track-progress to record generation..."
# Claude: Invoke /track-progress skill to document the generation

echo ""
```

### Step 8: Count What Was Created

```bash
# Show statistics about what the agents created
API_COUNT=$(find app/api -name "route.ts" 2>/dev/null | wc -l || echo "0")
COMPONENT_COUNT=$(find src/components -name "*.tsx" 2>/dev/null | wc -l || echo "0")
TEST_COUNT=$(find . -name "*.test.ts" -o -name "*.test.tsx" 2>/dev/null | wc -l || echo "0")

echo "🎯 What was created using agents:"
echo "   • architecture-planner → Project structure and data model"
echo "   • ui-ux-designer → Design system with components"
echo "   • api-developer → $API_COUNT API endpoints"
echo "   • component-builder → $COMPONENT_COUNT UI components"
echo "   • test-writer → $TEST_COUNT tests"
echo ""
```

### Step 9: Display Success Message

### Step 10: Display Success Message

```bash
echo "================================================================"
echo "✅ Successfully created $TEMPLATE_NAME: $PROJECT_NAME"
echo "================================================================"
echo ""
echo "📁 Location: $TARGET_DIR"
echo ""
echo "📋 Your getting-started plan: plans/active/getting-started/plan.md"
echo "   Created with /create-plan skill"
echo ""
echo "Next steps:"
echo ""
echo "  1. cd ../$PROJECT_NAME"

case "$CATEGORY" in
  saas|ecommerce)
    echo "  2. npm install"
    echo "  3. cp .env.example .env (and configure)"
    echo "  4. npm run db:push"
    echo "  5. npm run dev"
    ;;
  api)
    echo "  2. npm install"
    echo "  3. cp .env.example .env (and configure)"
    echo "  4. npm run dev"
    ;;
  components)
    echo "  2. npm install"
    echo "  3. npm run storybook"
    ;;
  cli)
    echo "  2. npm install"
    echo "  3. npm run build"
    echo "  4. npm link (to test globally)"
    ;;
  game)
    echo "  2. npm install"
    echo "  3. npm run dev"
    ;;
esac

echo ""
echo "💡 This project demonstrates all Claude Code resources working together!"
echo "   • 10 agents were used to design, build, and test"
echo "   • 7 skills were used for planning, quality, and commits"
echo ""
echo "Next Development:"
echo "   • Run '/plan-status' to see your getting-started plan"
echo "   • Use '/worktree-create' for parallel feature development"
echo "   • Use '/ship' at the end of each session"
echo ""
```

## Example Usage

### Create SaaS App Interactively
```bash
/starter-project
# Select: 1 (SaaS Web App)
# Enter name: my-awesome-saas
```

### Create API Service Directly
```bash
/starter-project api my-api-service
```

### Create Component Library
```bash
/starter-project components design-system
```

## What Gets Created

All projects include:
- **CLAUDE.md** - Generated from template (templates/claude-md/[category].md) following best practices from docs/best-practices/claude-md-authoring.md
- **.claude/agents/** - Relevant agents for the project type
- **.claude/skills/** - Development workflow skills
- **plans/active/getting-started/** - Initial development plan
- **README.md** - Setup and development instructions
- **Git repository** - Initialized with initial commit

Category-specific files and structure based on template.

## Post-Generation

After creating a starter project:
1. Navigate to the new directory
2. Install dependencies
3. Review the getting-started plan
4. Start building with suggested agents

The starter is a foundation - you continue development using the pre-configured agents and skills.

## Tips

- **Choose the right template**: Match your project type to get relevant agents
- **Review the plan**: Each template includes suggested first features
- **Explore the agents**: Check `.claude/agents/` to see what's available
- **Use the skills**: Workflow skills help maintain code quality
- **Customize freely**: The generated project is yours to modify

## Troubleshooting

**Directory already exists**
- Choose a different project name
- Or remove the existing directory

**Template not found**
- Ensure you're running this from the claude-code-shared repository
- Or that the skill is properly installed with template files

**Missing dependencies after generation**
- Run `npm install` in the generated project
- Check package.json for required Node version