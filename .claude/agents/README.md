# Sub-Agents

Specialized AI assistants for specific tasks. Each agent runs in its own context with custom tools and model configuration.

## Available Agents

### Explore Agents (Haiku, Read-Only)
Fast, cost-effective agents for codebase exploration:

- **codebase-explorer** - Deep analysis of project structure and patterns
- **dependency-analyzer** - Analyze dependencies and their relationships
- **pattern-finder** - Find code patterns and conventions

### Plan Agents (Opus, Read-Only)
Powerful agents for complex planning:

- **architecture-planner** - System design for complex features
- **feature-planner** - Feature breakdown and estimation
- **refactor-planner** - Refactoring strategy and planning

### Design Agents (Opus, Full Access)
Specialized agents for interface design and optimization:

- **ui-ux-designer** - Visual identity, design systems, and polished interfaces
- **mobile-designer** - Mobile-first design, touch interactions, and platform patterns
- **conversion-optimizer** - Conversion optimization, copywriting, and buyer journeys

### Implement Agents (Sonnet, Full Access)
Balanced agents for code implementation:

- **api-developer** - API endpoint implementation
- **component-builder** - UI component creation
- **test-writer** - Test file generation
- **debugger** - Bug investigation and fixes

## Usage

Claude automatically delegates to agents based on the task. You can also explicitly request:

```
Use the codebase-explorer agent to analyze this project
Have the debugger agent investigate this error
```

## Creating Custom Agents

Agents are Markdown files with YAML frontmatter:

```markdown
---
name: my-agent
description: When to use this agent
tools: Read, Grep, Glob
model: haiku
---

You are a specialist in [domain]. When invoked:
1. Understand the task
2. Execute systematically
3. Return clear results
```

See [Agent Design Best Practices](../../docs/best-practices/agent-design.md) for details.
