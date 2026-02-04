# Agent Authoring Templates

Templates and guides for creating custom Claude Code sub-agents.

## What is a Sub-Agent?

A sub-agent is a specialized instance of Claude with specific expertise, tools, and behavior. The main Claude can delegate tasks to sub-agents for focused work.

**Location:**
- Project: `.claude/agents/` (checked into git)
- User: `~/.claude/agents/` (available in all projects)

**Format:**
- Markdown file with YAML frontmatter
- Contains instructions defining agent behavior
- Can specify allowed tools, model, and permissions

---

## Agent Template

Use [agent-template.md](./agent-template.md) as a starting point for creating your own agents.

### Template Structure

```markdown
---
name: agent-name
description: When Claude should delegate to this agent
tools: Read, Grep, Glob
model: haiku
permissionMode: plan
---

# Agent Name - Purpose

You are a specialized agent for [domain].

## My Workflow
[Step-by-step process]

## Output Format
[How to present results]
```

---

## Creating Your First Agent

### 1. Copy the Template

```bash
cp templates/agents/agent-template.md .claude/agents/my-agent.md
```

### 2. Define the Agent

```yaml
---
name: my-agent
description: Analyze code quality and suggest improvements
tools: Read, Grep, Glob, Bash
disallowedTools: Write, Edit
model: sonnet
permissionMode: plan
---
```

### 3. Write the Instructions

Define the agent's expertise and workflow:

```markdown
# Code Quality Analyzer

You are a specialized agent for code quality analysis.

## My Workflow

### Phase 1: Scan Codebase
1. Use Glob to find all source files
2. Use Read to examine each file
3. Note quality issues

### Phase 2: Analyze Patterns
1. Identify code smells
2. Check for anti-patterns
3. Assess complexity

### Phase 3: Report
Present findings in structured format.
```

### 4. Test Your Agent

Claude will automatically delegate to your agent when the task matches the description.

---

## Agent Configuration

### Required Fields

**name**
```yaml
name: codebase-explorer
```
- Unique identifier (lowercase, hyphens)
- Must match filename (without `.md`)

**description**
```yaml
description: Explore and analyze codebase structure. Use proactively when understanding new code.
```
- When Claude should delegate to this agent
- Be specific about scenarios
- Use action verbs

### Optional Fields

**tools**
```yaml
tools: Read, Grep, Glob, Bash
```
- Allowed tools (inherits all if omitted)
- Restricts agent to specific capabilities

**disallowedTools**
```yaml
disallowedTools: Write, Edit
```
- Explicitly deny certain tools
- Useful for read-only agents

**model**
```yaml
model: haiku | sonnet | opus | inherit
```
- Which Claude model to use
- Default: inherits from parent

**permissionMode**
```yaml
permissionMode: default | acceptEdits | dontAsk | bypassPermissions | plan
```
- How to handle permissions
- Default: asks for sensitive operations

**skills**
```yaml
skills:
  - benchmark-performance
  - verify-work
```
- Pre-load specific skills
- Agent can use these without loading

---

## Agent Design Principles

### 1. Single Purpose
Each agent should have ONE clear specialty.

**Good:**
```yaml
name: api-developer
description: Implement REST API endpoints following project conventions
```

**Bad:**
```yaml
name: full-stack-developer
description: Build entire features including frontend, backend, database, and deployment
```

### 2. Clear Delegation Trigger
The description should clearly indicate when to delegate.

**Good:**
```yaml
description: Analyze database schema and suggest optimizations. Use proactively when working with database performance.
```

**Bad:**
```yaml
description: Helps with database stuff
```

### 3. Appropriate Tool Access

**Read-only agents:**
```yaml
tools: Read, Grep, Glob, Bash
disallowedTools: Write, Edit
```

**Implementation agents:**
```yaml
tools: Read, Grep, Glob, Bash, Write, Edit
```

### 4. Right Model for the Job

**Haiku** - Fast, cheap exploration:
```yaml
model: haiku
```
Use for: File searching, simple analysis, high-volume tasks

**Sonnet** - Balanced implementation:
```yaml
model: sonnet
```
Use for: Coding, reviews, debugging, most development work

**Opus** - Complex reasoning:
```yaml
model: opus
```
Use for: Architecture, complex planning, difficult problems

---

## Agent Patterns

### Pattern 1: Exploration Agent (Haiku)

```markdown
---
name: pattern-finder
description: Find code patterns and conventions across the codebase
tools: Read, Grep, Glob, Bash
disallowedTools: Write, Edit
model: haiku
permissionMode: plan
---

# Pattern Finder

You are a codebase pattern analysis specialist.

## My Workflow

### Phase 1: Search
Use Grep to find all instances of pattern.

### Phase 2: Analyze
Read matching files to understand usage.

### Phase 3: Report
Summarize patterns found with examples.

## Output Format

markdown
## Pattern Analysis: [Pattern Name]

### Occurrences
Found in X files across Y directories.

### Common Usage
[Most common pattern]

### Variations
- Variation 1
- Variation 2

### Recommendations
[Suggestions for consistency]
```

---

### Pattern 2: Implementation Agent (Sonnet)

```markdown
---
name: component-builder
description: Build UI components following project conventions and design system
tools: Read, Grep, Glob, Bash, Write, Edit
model: sonnet
permissionMode: acceptEdits
skills:
  - component-states
  - micro-interactions
---

# Component Builder

You are a UI component implementation specialist.

## My Workflow

### Phase 1: Understand Requirements
Read existing components to understand patterns.

### Phase 2: Implement
Create component with:
- TypeScript types
- Props interface
- Component logic
- Styles

### Phase 3: Polish
Add states, accessibility, documentation.

## Output Format

Return the component file path and summary of what was created.
```

---

### Pattern 3: Planning Agent (Opus)

```markdown
---
name: architecture-planner
description: Design system architecture for complex features and technical challenges
tools: Read, Grep, Glob, Bash
disallowedTools: Write, Edit
model: opus
permissionMode: plan
skills:
  - benchmark-performance
---

# Architecture Planner

You are a software architecture specialist.

## My Workflow

### Phase 1: Understand Context
Read codebase to understand current architecture.

### Phase 2: Design
Consider multiple approaches:
- Approach 1: Pros and cons
- Approach 2: Pros and cons

### Phase 3: Recommend
Recommend best approach with rationale.

## Output Format

markdown
## Architecture Recommendation

### Current State
[Analysis of current architecture]

### Proposed Approach
[Detailed design]

### Trade-offs
| Aspect | Pro | Con |
|--------|-----|-----|

### Implementation Plan
1. Step 1
2. Step 2
```

---

## Agent Categories

### Explore Agents (Read-Only, Haiku)
Fast, cheap exploration and analysis:
- codebase-explorer
- dependency-analyzer
- pattern-finder

**Characteristics:**
- Read-only tools
- Haiku model (fast, cheap)
- Plan permission mode
- Return structured summaries

---

### Plan Agents (Read-Only, Opus)
Complex planning and architecture:
- architecture-planner
- feature-planner
- refactor-planner

**Characteristics:**
- Read-only tools
- Opus model (complex reasoning)
- Plan permission mode
- Return detailed plans

---

### Implement Agents (Full Access, Sonnet)
Building and modification:
- api-developer
- component-builder
- test-writer

**Characteristics:**
- Full tool access
- Sonnet model (balanced)
- Accept edits mode
- Write working code

---

## Model Selection Guide

### Haiku ($0.25/$1.25 per M tokens)
**When to use:**
- File searching
- Code exploration
- Simple analysis
- High-volume tasks

**Example:**
```yaml
name: file-finder
model: haiku
tools: Glob, Grep
```

---

### Sonnet ($3/$15 per M tokens)
**When to use:**
- Implementation
- Code reviews
- Debugging
- Most dev work

**Example:**
```yaml
name: bug-fixer
model: sonnet
tools: Read, Write, Edit, Bash
```

---

### Opus ($15/$75 per M tokens)
**When to use:**
- Architecture
- Complex planning
- Difficult problems
- Critical decisions

**Example:**
```yaml
name: system-designer
model: opus
tools: Read, Grep, Glob
```

---

## Permission Modes

### default
Asks for permission for sensitive operations.
```yaml
permissionMode: default
```
**Use when:** Safety is important

---

### acceptEdits
Auto-accepts file edits.
```yaml
permissionMode: acceptEdits
```
**Use when:** Agent is trusted to make changes

---

### dontAsk
Minimal prompting.
```yaml
permissionMode: dontAsk
```
**Use when:** Automated workflows

---

### bypassPermissions
Full bypass (use carefully).
```yaml
permissionMode: bypassPermissions
```
**Use when:** Fully automated, trusted agents

---

### plan
Planning mode (read-only by default).
```yaml
permissionMode: plan
```
**Use when:** Exploration and analysis

---

## Agent Communication

### Delegation
Main Claude delegates to agents automatically when task matches description.

### Return Format
Agents should return clear, structured output:

```markdown
## Summary
[What was done]

## Findings
- Finding 1
- Finding 2

## Recommendations
1. Next step 1
2. Next step 2
```

### Context Preservation
Agents receive full conversation context before delegation.

---

## Best Practices

### Do:
- ✅ Define clear specialty and boundaries
- ✅ Choose appropriate model for task
- ✅ Restrict tools for read-only agents
- ✅ Provide structured output format
- ✅ Include workflow steps
- ✅ Test with various scenarios

### Don't:
- ❌ Make agents too general-purpose
- ❌ Use Opus for simple tasks
- ❌ Give write access to exploratory agents
- ❌ Skip error handling
- ❌ Forget to document constraints
- ❌ Duplicate existing agent capabilities

---

## Testing Your Agent

### Manual Testing

1. **Create test scenario:**
   ```
   "Analyze the authentication system and suggest improvements"
   ```

2. **Verify delegation:**
   Claude should automatically delegate to your agent if description matches.

3. **Check output:**
   Verify the agent follows the workflow and produces expected output.

### Test Checklist

- [ ] Agent is invoked for appropriate tasks
- [ ] Agent follows defined workflow
- [ ] Output format is consistent
- [ ] Error handling works
- [ ] Tool restrictions are respected
- [ ] Model choice is appropriate

---

## Agent Organization

### By Purpose

```
.claude/agents/
├── explore/           # Read-only exploration (Haiku)
│   ├── codebase-explorer.md
│   └── dependency-analyzer.md
├── plan/              # Planning (Opus)
│   ├── architecture-planner.md
│   └── feature-planner.md
└── implement/         # Implementation (Sonnet)
    ├── api-developer.md
    └── component-builder.md
```

### By Domain

```
.claude/agents/
├── frontend/
│   ├── component-builder.md
│   └── ui-designer.md
├── backend/
│   ├── api-developer.md
│   └── database-optimizer.md
└── testing/
    └── test-writer.md
```

---

## Advanced Features

### Preloading Skills

```yaml
skills:
  - benchmark-performance
  - component-states
```

Agent has these skills available without loading.

### Hooks (Advanced)

```yaml
hooks:
  PreToolUse: |
    # Code to run before each tool use
  PostToolUse: |
    # Code to run after each tool use
```

---

## Example Agents

See the agents in `.claude/agents/`:
- [explore/codebase-explorer.md](../../.claude/agents/explore/codebase-explorer.md)
- [plan/feature-planner.md](../../.claude/agents/plan/feature-planner.md)
- [implement/api-developer.md](../../.claude/agents/implement/api-developer.md)

These demonstrate real-world agent patterns.

---

## Cost Optimization

### Agent Efficiency

**Cost-Effective:**
```yaml
# Use Haiku for exploration
name: file-searcher
model: haiku
tools: Glob, Grep
```

**Cost-Conscious:**
```yaml
# Use Sonnet for implementation
name: feature-builder
model: sonnet
```

**When Worth the Cost:**
```yaml
# Use Opus for critical decisions
name: architecture-designer
model: opus
```

---

## Troubleshooting

### Agent Not Being Invoked
**Problem:** Claude doesn't delegate to your agent

**Solutions:**
- Make description more specific
- Use action verbs ("Analyze", "Build", "Design")
- Match user's language in description

### Agent Has Wrong Tools
**Problem:** Agent tries to use disallowed tools

**Solutions:**
- Add tool to `disallowedTools` list
- Be explicit about tool permissions
- Review tool usage in instructions

### Agent Too Expensive
**Problem:** Agent costs too much

**Solutions:**
- Use Haiku for simple tasks
- Use Sonnet instead of Opus
- Limit scope of agent

---

## Resources

- [Claude Code Sub-agents Docs](https://code.claude.com/docs/sub-agents)
- [Tool Reference](https://code.claude.com/docs/tools)
- [Model Comparison](https://www.anthropic.com/pricing)

---

## Contributing

Have a useful agent to share?
1. Test it thoroughly
2. Document it well
3. Choose appropriate model
4. Share with community
