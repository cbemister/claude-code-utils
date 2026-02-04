---
name: skill-name
description: Clear, concise description of when Claude should use this skill. Use action verbs and be specific.
---

# Skill Name

[Longer description of what this skill does and its purpose]

## When to Use

Use this when:
- Specific scenario 1
- Specific scenario 2
- Specific scenario 3

**Do NOT use when:**
- Wrong scenario 1
- Wrong scenario 2

## Usage

```
/skill-name [arg1] [arg2] [--flag]
```

**Arguments:**
- `arg1` - Description of first argument (required/optional)
- `arg2` - Description of second argument (required/optional)
- `--flag` - Description of flag (optional)

## Instructions

### Step 1: [First Step Name]

[Description of what this step does]

```bash
# Example command or code
command --option value
```

**What this does:**
- Explanation point 1
- Explanation point 2

**Error handling:**
```bash
if [ condition ]; then
  echo "Error: descriptive message"
  exit 1
fi
```

---

### Step 2: [Second Step Name]

[Description of what this step does]

```bash
# Example command or code
```

**Options:**
- Option 1: When to use
- Option 2: When to use

---

### Step 3: [Third Step Name]

[Description of what this step does]

```bash
# Example command or code
```

**Output:**
```
Example output message
✅ Success indicator
```

---

## Example Usage

### Basic Example
```bash
/skill-name basic-arg
```

Output:
```
Processing basic-arg...
✅ Task completed successfully!

Result:
  - Item 1
  - Item 2

Next steps:
  1. Do this
  2. Do that
```

---

### Advanced Example
```bash
/skill-name advanced-arg --special-flag
```

Output:
```
Processing advanced-arg with special options...
⚙️  Running special processing...
✅ Advanced task completed!
```

---

## Best Practices

**When authoring this skill:**
- Best practice 1
- Best practice 2
- Best practice 3

**Common pitfalls:**
- ❌ Pitfall 1 to avoid
- ❌ Pitfall 2 to avoid

**Tips:**
- Tip 1 for better results
- Tip 2 for edge cases

---

## Integration with Other Skills

**Works well with:**
- `/other-skill` - When to combine
- `/another-skill` - How they complement

**Dependencies:**
- Requires: List any prerequisites
- Optional: List optional dependencies

---

## Troubleshooting

### Error: "[Common Error Message]"
**Cause:** Why this error happens
**Solution:** How to fix it

```bash
# Fix command
```

---

### Error: "[Another Common Error]"
**Cause:** Why this error happens
**Solution:** How to fix it

---

## Advanced Usage

### Custom Configuration

[If applicable, show how to customize behavior]

```bash
# Advanced usage pattern
/skill-name arg --option1 value1 --option2 value2
```

### Scripting

[If applicable, show how to use in scripts]

```bash
#!/bin/bash
# Example script using this skill

/skill-name arg1
if [ $? -eq 0 ]; then
  /skill-name arg2
fi
```

---

## Output Format

### Success Format
```
✅ [Success message]

[Details section]
  Key1: Value1
  Key2: Value2

Next steps:
  1. Step 1
  2. Step 2
```

### Error Format
```
❌ Error: [Error message]

Cause: [Why it failed]

Fix:
  1. Step 1 to resolve
  2. Step 2 to resolve
```

---

## Notes

[Any additional context, considerations, or important information]

### Performance Considerations
- Consideration 1
- Consideration 2

### Security Considerations
- Security point 1
- Security point 2

---

## Skill Authoring Tips

When creating your own skills based on this template:

1. **Clear Description:** The `description` field in frontmatter should clearly tell Claude when to use this skill
2. **Step-by-step:** Break complex operations into clear steps
3. **Error handling:** Always handle errors gracefully with helpful messages
4. **Examples:** Include realistic examples that users can copy
5. **Troubleshooting:** Document common issues and solutions
6. **Testing:** Test your skill with various inputs before using

---

## Related Skills

- [Related skill 1](../skills/related-skill.md)
- [Related skill 2](../skills/another-skill.md)

## Resources

- [Link to relevant documentation]
- [Link to tool being used]
