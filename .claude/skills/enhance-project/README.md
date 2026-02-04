# Enhance Project Skill

Add Claude Code agents and skills to existing projects, analyze codebases, fix issues, and apply code improvements.

**Recommended:** Run on a git branch for safe experimentation with code changes.

## Overview

While `/starter-project` creates new projects from scratch, `/enhance-project` works with **existing projects** to add Claude Code resources and run comprehensive analysis.

## Usage

```bash
# Enhance current directory
/enhance-project

# Enhance specific project
/enhance-project ../my-existing-app
```

## Enhancement Options

### 1. Full Enhancement (Recommended on Branch)
Adds all resources, runs analysis, and applies code improvements:
- Copies all agents and skills
- Creates CLAUDE.md with detected conventions
- Runs codebase analysis
- Generates tests for untested code
- **Fixes security vulnerabilities**
- **Resolves performance issues**
- **Applies refactorings**
- Creates logical commits
- Creates improvement plan for remaining work

### 2. Resources Only (Safe, Non-Destructive)
Adds Claude Code resources without modifying code:
- Copies agents
- Copies skills
- Creates CLAUDE.md

### 3. Analysis Only (Safe, Non-Destructive)
Runs analyses without making changes:
- Codebase structure analysis
- Dependency audit
- Pattern identification
- Quality checks
- Generates report only

### 4. Code Improvements (Recommended on Branch)
Fixes issues and improves code quality:
- Fix security vulnerabilities
- Resolve performance bottlenecks
- Apply refactorings
- Add tests for untested code
- Create logical commits

### 5. Custom
Choose specific enhancements:
- [ ] Copy agents
- [ ] Copy skills
- [ ] Create/update CLAUDE.md
- [ ] Run codebase analysis
- [ ] Generate tests
- [ ] Create development plan
- [ ] Run quality checks

## Agents Used During Enhancement

| Agent | Purpose |
|-------|---------|
| `codebase-explorer` | Map project structure and architecture |
| `pattern-finder` | Identify existing conventions and patterns |
| `dependency-analyzer` | Audit dependencies for issues |
| `test-writer` | Generate tests for untested code |
| `feature-planner` | Create improvement task list |
| `architecture-planner` | Review architecture for issues |

## Skills Used During Enhancement

| Skill | Purpose |
|-------|---------|
| `/verify-work` | Check code quality |
| `/performance-check` | Identify performance issues |
| `/create-plan` | Create improvement plan |
| `/generate-tests` | Ensure test coverage |

## Output

After enhancement, your project will have:

```
your-project/
├── .claude/
│   ├── agents/          # All relevant agents
│   │   ├── explore/
│   │   ├── plan/
│   │   ├── implement/
│   │   └── design/
│   └── skills/          # Workflow skills
│       ├── ship/
│       ├── verify-work/
│       └── ...
├── plans/
│   └── active/
│       └── improvements/
│           └── plan.md  # Generated improvement plan
└── CLAUDE.md            # Project conventions
```

## Comparison with Starter Project

| Aspect | `/starter-project` | `/enhance-project` |
|--------|-------------------|-------------------|
| **For** | New projects | Existing projects |
| **Creates scaffold** | Yes | No |
| **Analyzes code** | No (nothing exists) | Yes (deeply) |
| **Generates tests** | For new code | For existing code |
| **Creates plan** | Getting-started | Improvements |
| **Fixes issues** | N/A | Yes (security, performance, bugs) |
| **Refactors code** | N/A | Yes (when option selected) |
| **Safe strategy** | New folder | **Run on git branch** |

## Examples

### Enhance a Legacy Project
```bash
cd ~/projects/legacy-app
/enhance-project

# Select: Full Enhancement
# Results: CLAUDE.md created, agents added, improvement plan generated
```

### Add Resources to Modern Project
```bash
/enhance-project ../my-nextjs-app

# Select: Resources Only
# Results: Agents and skills added, ready for use
```

### Audit Before Refactor
```bash
/enhance-project .

# Select: Analysis Only
# Results: Detailed report of patterns, dependencies, quality issues
```

## Best Practices

1. **Commit before enhancing** - While non-destructive, good practice
2. **Review CLAUDE.md** - Generated conventions may need adjustment
3. **Start with analysis** - Understand before adding resources
4. **Use improvement plan** - Prioritized tasks from analysis
5. **Re-run periodically** - As project evolves

## See Also

- [/starter-project](../starter-project/README.md) - Create new projects
- [/verify-work](../verify-work/README.md) - Quality checks
- [/create-plan](../create-plan/README.md) - Feature planning
