# Agent Design Best Practices

A comprehensive guide to designing effective, specialized Claude Code sub-agents.

## What Makes a Good Agent?

A well-designed agent is:
- **Specialized** - Expert in one domain
- **Autonomous** - Can work independently
- **Predictable** - Consistent behavior and output
- **Efficient** - Uses the right model and tools
- **Clear** - Explicit about capabilities and limits

---

## Agent Fundamentals

### Sub-Agent Purpose

Sub-agents allow the main Claude to delegate specialized tasks to focused experts. Each agent:
- Has specific expertise
- Uses appropriate tools
- Operates at the right capability level
- Returns structured results

---

## 1. Agent Specialization

### Single Responsibility Principle

Each agent should have ONE clear specialty:

**Good (Focused):**
```yaml
name: api-developer
description: Implement REST API endpoints following project conventions
```

```yaml
name: test-writer
description: Write comprehensive unit and integration tests
```

**Bad (Too Broad):**
```yaml
name: full-stack-developer
description: Build complete features including frontend, backend, database, and deployment
```

---

### Domain Expertise

Define the agent's area of expertise clearly:

```markdown
# API Developer - REST Endpoint Specialist

You are an expert in building REST API endpoints. Your expertise includes:
- RESTful design patterns
- Request validation with Zod
- Error handling and status codes
- Database queries with ORMs
- API security and authentication
- Response formatting
```

---

## 2. Delegation Triggers

### Description Field

The `description` field is **critical** - it tells main Claude when to delegate.

**Rules:**
- Use action verbs
- Be specific about scenarios
- Describe WHEN to delegate
- Keep under 200 characters
- Include "Use proactively" if agent should be preemptive

**Good Descriptions:**
```yaml
description: Explore and analyze codebase structure. Use proactively when understanding new code.

description: Implement REST API endpoints following project conventions. Use when building backend APIs.

description: Design system architecture for complex features. Use for architectural decisions.

description: Write comprehensive unit and integration tests. Use when test coverage is needed.
```

**Bad Descriptions:**
```yaml
description: Helps with APIs
# ❌ Too vague

description: This agent is used for exploring code
# ❌ Don't say "this agent is used"

description: Code analysis and exploration tool that can be invoked when you need to understand the structure of a codebase and find patterns
# ❌ Too wordy
```

---

## 3. Tool Selection

### Choose Appropriate Tools

Only request tools your agent needs:

**Exploration Agent (Read-Only):**
```yaml
name: codebase-explorer
tools: Read, Grep, Glob, Bash
disallowedTools: Write, Edit
model: haiku
```

**Implementation Agent (Full Access):**
```yaml
name: component-builder
tools: Read, Grep, Glob, Bash, Write, Edit
model: sonnet
```

**Planning Agent (Read-Only):**
```yaml
name: architecture-planner
tools: Read, Grep, Glob, Bash
disallowedTools: Write, Edit
model: opus
```

---

### Restrict When Appropriate

Use `disallowedTools` to prevent unintended modifications:

```yaml
name: security-auditor
tools: Read, Grep, Glob
disallowedTools: Write, Edit, Bash
# No modifications or command execution
```

---

## 4. Model Selection

### Match Model to Task Complexity

**Haiku - Fast Exploration:**
```yaml
name: pattern-finder
model: haiku
tools: Grep, Glob, Read
```
- File searching
- Pattern matching
- Simple analysis
- High-volume tasks

**Sonnet - Implementation:**
```yaml
name: bug-fixer
model: sonnet
tools: Read, Write, Edit, Grep, Glob, Bash
```
- Code generation
- Bug fixing
- Refactoring
- Test writing

**Opus - Complex Reasoning:**
```yaml
name: ui-ux-designer
model: opus
tools: Read, Write, Edit, Grep, Glob, Bash
```
- Architecture design
- Complex planning
- UI/UX design
- Critical decisions

See [Model Selection Guide](./model-selection.md) for details.

---

## 5. Permission Modes

### Choose Appropriate Mode

**default** - Standard permission checks:
```yaml
permissionMode: default
```
Use when: Safety is important, agent is new/untested

**acceptEdits** - Auto-accept file edits:
```yaml
permissionMode: acceptEdits
```
Use when: Agent is trusted to modify files

**plan** - Planning/read-only mode:
```yaml
permissionMode: plan
```
Use when: Agent explores and plans, doesn't implement

**dontAsk** - Minimal prompting:
```yaml
permissionMode: dontAsk
```
Use when: Automated workflows, high confidence

**bypassPermissions** - Full bypass:
```yaml
permissionMode: bypassPermissions
```
Use when: Fully automated, thoroughly tested agents

---

## 6. Workflow Design

### Structure the Agent's Process

Define a clear, repeatable workflow:

```markdown
## My Workflow

### Phase 1: Understand Context
1. Read relevant files
2. Analyze current patterns
3. Identify requirements

**Tools:** Read, Grep, Glob

### Phase 2: Design Solution
1. Plan approach
2. Consider edge cases
3. Design implementation

### Phase 3: Implement
1. Write code following conventions
2. Add error handling
3. Include tests

**Tools:** Write, Edit

### Phase 4: Verify
1. Check for issues
2. Ensure conventions followed
3. Report completion

**Output:** [Structured summary]
```

---

### Systematic Approach

Teach the agent to work systematically:

```markdown
## My Approach

I work systematically through these steps:

1. **Scan:** Use Glob to find all relevant files
2. **Read:** Examine each file thoroughly
3. **Analyze:** Look for patterns and issues
4. **Report:** Present findings in structured format

I do NOT:
- Make assumptions without verification
- Skip files that might be relevant
- Report findings I haven't validated
```

---

## 7. Output Format

### Consistent Structure

Define a clear output format:

```markdown
## Output Format

markdown
# [Task Title]

## Overview
[Brief summary of task and approach]

## Findings
- Finding 1
- Finding 2
- Finding 3

### Details
[Detailed analysis]

## Recommendations
1. Recommendation 1
2. Recommendation 2

## Next Steps
[What should happen next]

```

---

### Quality Standards

Set expectations for output quality:

```markdown
## Quality Standards

Before completing any task, I verify:

- [ ] I understood the request correctly
- [ ] I examined all relevant code
- [ ] My recommendations are actionable
- [ ] My output is clearly structured
- [ ] I highlighted anything unusual
- [ ] I suggested clear next steps
```

---

## 8. Boundaries & Constraints

### Define Capabilities

Be explicit about what the agent CAN do:

```markdown
## What I Can Do

✅ Implement REST API endpoints
✅ Add request validation with Zod
✅ Handle errors with proper status codes
✅ Write database queries
✅ Follow project conventions
✅ Add endpoint documentation
```

---

### Define Limitations

Be explicit about what the agent CANNOT do:

```markdown
## What I Cannot Do

❌ Design system architecture (delegate to architecture-planner)
❌ Write frontend code (delegate to component-builder)
❌ Perform database migrations (requires manual review)
❌ Deploy to production (requires human approval)
```

---

### When to Delegate

Teach the agent when to ask for help:

```markdown
## When to Escalate

I will ask for help when:
- Architecture decisions are needed → architecture-planner
- UI design is required → ui-ux-designer
- Complex algorithm optimization → performance-optimizer
- Security vulnerabilities found → security-auditor
```

---

## 9. Preloading Skills

### Include Relevant Skills

Preload skills the agent frequently uses:

```yaml
name: component-builder
skills:
  - component-states
  - micro-interactions
  - accessibility-audit
```

The agent can use these without loading them first.

---

### Avoid Over-Loading

Only preload skills the agent ALWAYS needs:

**Good:**
```yaml
name: api-developer
skills:
  - generate-tests
  - verify-work
```

**Bad:**
```yaml
name: api-developer
skills:
  - generate-tests
  - verify-work
  - worktree-create
  - plan-status
  - ui-transform
  # ❌ Too many, not all relevant
```

---

## 10. Error Handling

### Graceful Failures

Teach the agent to handle errors well:

```markdown
## When Things Go Wrong

If I encounter errors, I:

1. **Explain clearly** what went wrong
2. **Provide context** about why it failed
3. **Suggest alternatives** or workarounds
4. **Ask for clarification** if needed

### Example Error Response

markdown
## Issue Encountered

**Problem:** Could not find database schema files
**Cause:** No migration files in expected location
**Impact:** Cannot generate type-safe queries

### Recommended Solutions

**Option 1:** Create initial migration
- Run: npx drizzle-kit generate
- Review generated schema
- Apply with: npx drizzle-kit push

**Option 2:** Specify schema location
- Provide path to existing schema files
- I'll adapt to your structure

Which approach would you prefer?

```

---

## 11. Testing Your Agent

### Test Scenarios

Create test cases for your agent:

```markdown
## Test Cases

### Test 1: Basic API Endpoint
Input: "Create a GET /users endpoint"
Expected:
- Creates route.ts file
- Implements GET handler
- Adds validation
- Includes error handling

### Test 2: Complex Endpoint
Input: "Create POST /users with email validation"
Expected:
- Zod schema for email
- Proper error responses
- Success response
- Tests included

### Test 3: Error Handling
Input: Malformed request
Expected:
- Clear error message
- Suggests corrections
- Doesn't make assumptions
```

---

### Quality Checklist

- [ ] Agent is invoked for appropriate tasks
- [ ] Agent follows defined workflow
- [ ] Output format is consistent
- [ ] Error handling works correctly
- [ ] Tool restrictions are respected
- [ ] Model choice is appropriate
- [ ] Boundaries are enforced
- [ ] Delegation triggers work

---

## 12. Agent Categories

### Explore Agents

**Characteristics:**
```yaml
model: haiku
tools: Read, Grep, Glob, Bash
disallowedTools: Write, Edit
permissionMode: plan
```

**Purpose:** Fast, cheap exploration and analysis

**Examples:**
- codebase-explorer
- dependency-analyzer
- pattern-finder

---

### Plan Agents

**Characteristics:**
```yaml
model: opus
tools: Read, Grep, Glob, Bash
disallowedTools: Write, Edit
permissionMode: plan
```

**Purpose:** Complex planning and architecture

**Examples:**
- architecture-planner
- feature-planner
- ui-ux-designer

---

### Implement Agents

**Characteristics:**
```yaml
model: sonnet
tools: Read, Grep, Glob, Bash, Write, Edit
permissionMode: acceptEdits
```

**Purpose:** Building and modification

**Examples:**
- api-developer
- component-builder
- test-writer

---

## Common Patterns

### Pattern 1: Explorer Agent

```yaml
---
name: pattern-analyzer
description: Analyze code patterns and conventions across codebase
tools: Read, Grep, Glob, Bash
disallowedTools: Write, Edit
model: haiku
permissionMode: plan
---

# Pattern Analyzer

You analyze code to find patterns and conventions.

## My Workflow

1. **Search:** Use Grep to find code instances
2. **Read:** Examine matching files
3. **Analyze:** Identify common patterns
4. **Report:** Structured summary with examples

## Output Format

markdown
## Pattern Analysis: [Pattern Name]

### Occurrences
Found in X files

### Common Usage
[Most common pattern with example]

### Variations
- Variation 1
- Variation 2

### Recommendations
[Consistency suggestions]

```

---

### Pattern 2: Builder Agent

```yaml
---
name: component-creator
description: Build UI components following project design system
tools: Read, Grep, Glob, Bash, Write, Edit
model: sonnet
permissionMode: acceptEdits
skills:
  - component-states
  - micro-interactions
---

# Component Creator

You build UI components following project conventions.

## My Workflow

1. **Understand:** Read existing components
2. **Design:** Plan component structure
3. **Implement:** Write component code
4. **Polish:** Add states and interactions

## Output Format

Returns file path and summary of created component.
```

---

### Pattern 3: Planner Agent

```yaml
---
name: feature-architect
description: Design architecture for complex features
tools: Read, Grep, Glob, Bash
disallowedTools: Write, Edit
model: opus
permissionMode: plan
---

# Feature Architect

You design architecture for complex features.

## My Workflow

1. **Analyze:** Understand current architecture
2. **Design:** Create multiple approaches
3. **Evaluate:** Compare trade-offs
4. **Recommend:** Best approach with rationale

## Output Format

markdown
## Architecture Recommendation

### Current State
[Analysis]

### Approach 1: [Name]
**Pros:** ...
**Cons:** ...

### Approach 2: [Name]
**Pros:** ...
**Cons:** ...

### Recommendation
[Best approach and why]

### Implementation Plan
1. Step 1
2. Step 2

```

---

## Anti-Patterns to Avoid

### ❌ Too General

```yaml
# Bad: Tries to do everything
name: developer
description: Helps with all development tasks
```

```yaml
# Good: Focused specialty
name: api-developer
description: Implement REST API endpoints following conventions
```

---

### ❌ Wrong Model

```yaml
# Bad: Opus for simple search
name: file-finder
model: opus
tools: Glob, Grep
```

```yaml
# Good: Haiku for search
name: file-finder
model: haiku
tools: Glob, Grep
```

---

### ❌ Tool Overload

```yaml
# Bad: Requests all tools
name: code-reviewer
tools: Read, Write, Edit, Grep, Glob, Bash
```

```yaml
# Good: Only what's needed
name: code-reviewer
tools: Read, Grep, Glob
disallowedTools: Write, Edit
```

---

### ❌ Vague Workflow

```markdown
# Bad
## My Workflow
I look at code and make suggestions
```

```markdown
# Good
## My Workflow

### Phase 1: Code Analysis
1. Use Grep to find all test files
2. Read each test file
3. Check coverage with Bash

### Phase 2: Gap Identification
1. Compare tests to implementation
2. Identify untested code paths
3. Prioritize by importance

### Phase 3: Recommendations
1. List specific tests needed
2. Provide test examples
3. Estimate coverage improvement
```

---

## Agent Quality Checklist

Before deploying an agent:

**Configuration:**
- [ ] Name matches specialty
- [ ] Description triggers delegation appropriately
- [ ] Model choice is justified
- [ ] Tools are minimal but sufficient
- [ ] Permission mode is appropriate

**Behavior:**
- [ ] Workflow is clearly defined
- [ ] Output format is consistent
- [ ] Boundaries are explicit
- [ ] Error handling is thorough
- [ ] Delegation strategy is clear

**Testing:**
- [ ] Tested with valid inputs
- [ ] Tested with edge cases
- [ ] Tested error scenarios
- [ ] Output quality verified
- [ ] Cost is acceptable

**Documentation:**
- [ ] Expertise is clear
- [ ] Workflow is documented
- [ ] Examples are provided
- [ ] Limitations are explicit

---

## Resources

- [Template](../../templates/agents/agent-template.md) - Agent authoring template
- [Examples](../../.claude/agents/) - Real agent implementations
- [Model Selection](./model-selection.md) - Choosing the right model

---

## Quick Start

1. **Identify specialty:**
   - What specific problem does this solve?
   - What expertise is needed?

2. **Choose model:**
   - Exploration → Haiku
   - Implementation → Sonnet
   - Planning → Opus

3. **Select tools:**
   - Minimum needed
   - Restrict when possible

4. **Define workflow:**
   - Step-by-step process
   - Clear phases
   - Consistent output

5. **Test thoroughly:**
   - Various scenarios
   - Error conditions
   - Cost analysis

6. **Document clearly:**
   - When to use
   - What it does
   - What it doesn't do

Your agent is ready when it passes the quality checklist above.
