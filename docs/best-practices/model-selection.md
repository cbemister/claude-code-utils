# Model Selection Guide

Choosing the right Claude model for your sub-agents and tasks is critical for balancing cost, speed, and quality.

## Available Models

| Model | Cost (Input/Output) | Speed | Best For |
|-------|---------------------|-------|----------|
| **Haiku** | $0.25 / $1.25 per M tokens | Fast | Exploration, search, high-volume tasks |
| **Sonnet** | $3 / $15 per M tokens | Medium | Implementation, reviews, most dev work |
| **Opus** | $15 / $75 per M tokens | Slower | Architecture, complex planning, critical decisions |

---

## Model Selection Strategy

### Haiku - Fast & Economical

**When to Use:**
- File searching and exploration
- Pattern finding across codebase
- Simple analysis tasks
- High-volume, repetitive operations
- Read-only exploration
- Quick lookups and queries

**Cost Example:**
- 100K tokens input + 50K tokens output = $0.09
- Ideal for tasks you'll run frequently

**Agent Examples:**
```yaml
name: codebase-explorer
model: haiku
tools: Read, Grep, Glob, Bash
disallowedTools: Write, Edit
```

**Typical Use Cases:**
- "Find all API endpoints in the codebase"
- "What files import this module?"
- "Show me all components that use this pattern"
- "Analyze dependency tree"

**Performance Characteristics:**
- ✅ Very fast responses
- ✅ Low cost for exploration
- ✅ Great for read-only tasks
- ⚠️ May miss subtle nuances
- ⚠️ Better for structured tasks

---

### Sonnet - Balanced Workhorse

**When to Use:**
- Implementation and coding
- Code reviews
- Debugging and troubleshooting
- Test writing
- Component building
- Most development work
- Refactoring

**Cost Example:**
- 100K tokens input + 50K tokens output = $3.75
- Good balance for quality work

**Agent Examples:**
```yaml
name: api-developer
model: sonnet
tools: Read, Grep, Glob, Bash, Write, Edit
```

**Typical Use Cases:**
- "Build a REST API endpoint for user management"
- "Review this pull request for bugs and improvements"
- "Write unit tests for this module"
- "Debug why this function is failing"
- "Refactor this component for better performance"

**Performance Characteristics:**
- ✅ High-quality code generation
- ✅ Good understanding of context
- ✅ Reliable for complex tasks
- ✅ Best cost/quality ratio for dev work
- ✅ Handles most edge cases well

---

### Opus - Maximum Capability

**When to Use:**
- System architecture design
- Complex planning and strategy
- Critical decision making
- Difficult debugging
- UI/UX design (global systems)
- Performance optimization planning
- Security architecture

**Cost Example:**
- 100K tokens input + 50K tokens output = $5.25
- Use when quality is paramount

**Agent Examples:**
```yaml
name: architecture-planner
model: opus
tools: Read, Grep, Glob, Bash
permissionMode: plan
```

```yaml
name: ui-ux-designer
model: opus
tools: Read, Write, Edit, Grep, Glob, Bash
```

**Typical Use Cases:**
- "Design the architecture for a multi-tenant SaaS platform"
- "Plan our migration from monolith to microservices"
- "Create a comprehensive UI design system for our brand"
- "Analyze and optimize our database performance strategy"
- "Design a secure authentication system"

**Performance Characteristics:**
- ✅ Deepest understanding
- ✅ Best at complex reasoning
- ✅ Handles ambiguity well
- ✅ Creative problem solving
- ✅ Comprehensive analysis
- ⚠️ Slower responses
- ⚠️ Higher cost

---

## Decision Framework

### Start with These Questions

**1. Is this read-only exploration?**
→ Use **Haiku**

**2. Does this require writing code?**
→ Use **Sonnet**

**3. Is this a critical architectural decision?**
→ Use **Opus**

**4. Will I run this frequently?**
→ Prefer **Haiku** or **Sonnet**

**5. Is quality more important than cost?**
→ Use **Opus**

---

## Cost Optimization Strategies

### 1. Use the Right Tool for the Job

**Bad Example:**
```yaml
# Using Opus for simple file search
name: file-finder
model: opus  # ❌ Overkill
tools: Glob, Grep
```

**Good Example:**
```yaml
# Using Haiku for file search
name: file-finder
model: haiku  # ✅ Perfect fit
tools: Glob, Grep
```

---

### 2. Progressive Enhancement

Start cheap, upgrade when needed:

```yaml
# Step 1: Haiku explores and finds patterns
name: pattern-analyzer
model: haiku

# Step 2: Sonnet implements based on findings
name: pattern-implementer
model: sonnet

# Step 3: Opus designs if architecture is complex
name: architecture-designer
model: opus
```

---

### 3. Batch Similar Tasks

If running multiple similar explorations:
- Use **Haiku** for all
- Aggregate findings
- Use **Sonnet/Opus** for synthesis

---

### 4. Limit Scope for Expensive Models

When using Opus:
- Be specific about what you need
- Provide clear constraints
- Ask for focused output
- Don't use for general exploration

**Bad:**
> "Tell me everything about this codebase"

**Good:**
> "Design the authentication architecture based on these requirements: [specific list]"

---

## Real-World Examples

### Example 1: Feature Development

**Task:** Add user authentication

**Approach:**
1. **Haiku** - Explore existing auth patterns (Fast, $0.10)
2. **Opus** - Design auth architecture (Critical, $5.00)
3. **Sonnet** - Implement endpoints (Implementation, $4.00)
4. **Sonnet** - Write tests (Implementation, $2.00)
5. **Haiku** - Verify all endpoints work (Verification, $0.05)

**Total Cost:** ~$11.15
**Time Saved:** Significant with right model per task

---

### Example 2: Code Review

**Task:** Review a pull request

**Approach:**
1. **Haiku** - Find all changed files (Fast, $0.02)
2. **Sonnet** - Review code quality and bugs (Quality work, $3.50)
3. **Haiku** - Check test coverage (Simple check, $0.05)

**Total Cost:** ~$3.57
**Alternative:** Using Opus for everything: ~$20

---

### Example 3: Bug Investigation

**Task:** Find and fix a production bug

**Approach:**
1. **Haiku** - Search for error patterns (Fast search, $0.08)
2. **Sonnet** - Analyze root cause (Analysis, $3.00)
3. **Sonnet** - Implement fix (Implementation, $2.50)
4. **Haiku** - Verify fix across codebase (Verification, $0.10)

**Total Cost:** ~$5.68
**If bug is complex:** Upgrade step 2 to Opus ($8 instead of $3)

---

## Model Selection by Agent Type

### Explore Agents → Haiku
- codebase-explorer
- dependency-analyzer
- pattern-finder
- file-searcher
- documentation-crawler

**Why:** Read-only, high-volume, speed matters

---

### Implement Agents → Sonnet
- api-developer
- component-builder
- test-writer
- bug-fixer
- refactorer

**Why:** Writing code, need quality, cost-effective

---

### Plan Agents → Opus
- architecture-planner
- feature-planner
- ui-ux-designer
- performance-optimizer
- security-architect

**Why:** Critical decisions, complex reasoning, quality paramount

---

## Common Mistakes

### ❌ Using Opus for Everything
**Problem:** 10x cost increase for no benefit
**Solution:** Use Haiku/Sonnet for most work

### ❌ Using Haiku for Complex Reasoning
**Problem:** May miss important nuances
**Solution:** Use Sonnet or Opus for critical thinking

### ❌ Not Considering Task Frequency
**Problem:** Expensive model for repeated tasks
**Solution:** Optimize frequently-run agents with Haiku/Sonnet

### ❌ Vague Prompts with Expensive Models
**Problem:** Wasting Opus on broad exploration
**Solution:** Use Haiku to explore, Opus for focused decisions

---

## Budget Planning

### Monthly Budget Examples

**Small Project ($50/month):**
- Haiku: 80% of tasks
- Sonnet: 18% of tasks
- Opus: 2% of tasks (critical only)

**Medium Project ($200/month):**
- Haiku: 60% of tasks
- Sonnet: 35% of tasks
- Opus: 5% of tasks

**Large Project ($500/month):**
- Haiku: 50% of tasks
- Sonnet: 40% of tasks
- Opus: 10% of tasks

---

## Monitoring Costs

### Track Usage by Agent
```bash
# Monitor which agents use most tokens
cat ~/.claude/usage.log | grep agent-name
```

### Review and Optimize
1. Identify expensive agents
2. Check if Haiku could work
3. Test with cheaper model
4. Compare quality
5. Adjust as needed

---

## Quick Reference

| Task Type | Model | Why |
|-----------|-------|-----|
| File search | Haiku | Fast, cheap, perfect fit |
| Code exploration | Haiku | Read-only, high volume |
| Implementation | Sonnet | Quality code, cost-effective |
| Code review | Sonnet | Balanced quality/cost |
| Bug fixing | Sonnet | Good analysis + implementation |
| Architecture | Opus | Critical decisions |
| UI/UX design | Opus | Complex reasoning, creativity |
| Planning | Opus | Strategic thinking |
| Testing | Sonnet | Implementation work |
| Documentation | Haiku/Sonnet | Depends on complexity |

---

## Best Practices

1. **Start Cheap, Upgrade When Needed**
   - Begin with Haiku
   - Move to Sonnet if quality suffers
   - Use Opus only for critical work

2. **Specialize Your Agents**
   - Exploration agents: Haiku
   - Implementation agents: Sonnet
   - Planning agents: Opus

3. **Monitor and Adjust**
   - Track costs per agent
   - Review quality regularly
   - Optimize frequently-used agents

4. **Be Explicit**
   - Set `model:` in agent frontmatter
   - Don't rely on defaults
   - Document why you chose each model

5. **Test Before Committing**
   - Try Haiku first
   - Verify quality meets needs
   - Upgrade only if necessary

---

## Conclusion

**The Right Model = Best Value**

- Use **Haiku** for speed and volume
- Use **Sonnet** for quality work
- Use **Opus** for critical decisions

Most projects should be:
- 50-70% Haiku
- 25-40% Sonnet
- 5-10% Opus

This gives you speed, quality, and reasonable costs.
