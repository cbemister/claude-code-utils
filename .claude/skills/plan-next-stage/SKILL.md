---
name: plan-next-stage
description: Refresh a stage plan to account for decisions and changes made during prior stages. Updates file paths, imports, and implementation details to reflect the actual codebase state.
args: "[stage-file] - Required: the stage plan filename, e.g. stage-4-ui-shell"
---

# Plan Next Stage

## Instructions

**IMPORTANT: Execute immediately. The user must provide a stage filename argument.**

Parse arguments:
- `$1` = stage file identifier (e.g., `stage-4-ui-shell` or `stage-4-ui-shell.md`)

If no argument was provided, use AskUserQuestion to ask which stage to refresh. List the stage files found in `plans/active/`.

---

### Step 1: Read Current State

1. Find and read the stage plan file:
   ```
   plans/active/$1.md  (add .md if not present)
   ```
   If not found, check `plans/archive/` as well.

2. Read the master plan README:
   ```
   plans/README.md
   ```

3. Read all completed stage plans (from `plans/archive/`) to understand what was built and any decisions that were made.

4. Read the project's current state:
   - `CLAUDE.md` — project overview and conventions
   - `.claude/rules/architecture.md` — current architecture
   - `.claude/rules/api-conventions.md` — current API patterns

---

### Step 2: Scan the Codebase

Use the Explore agent or Glob/Grep to understand what actually exists:

1. **Directory structure** — `ls` the key source directories to see what files were created by prior stages
2. **Key interfaces/types** — Grep for exported interfaces, types, and function signatures that this stage will depend on
3. **Existing patterns** — Look at how prior stages structured their code (imports, error handling, test patterns)
4. **Test infrastructure** — Check what test utilities, mocks, and patterns are already established

---

### Step 3: Identify Drift

Compare the stage plan against reality:

1. **File paths** — Do the files referenced in the plan exist at those paths? Have any been renamed or moved?
2. **Imports** — Do the import paths match the actual module structure?
3. **Interfaces** — Do the types and interfaces referenced match what was actually implemented?
4. **Dependencies** — Are there new libraries or patterns from prior stages that this stage should use?
5. **Architecture changes** — Did prior stages make architectural decisions that affect this stage's approach?

---

### Step 4: Update the Stage Plan

Rewrite the stage plan file with updates:

1. **Update file paths** to match the actual codebase structure
2. **Update imports** to use the real module paths
3. **Update code snippets** to use actual interfaces and types from the codebase
4. **Update test code** to use the established test utilities and patterns
5. **Update verification commands** to use the actual test runner config
6. **Add notes** where prior stage decisions affect the approach (e.g., "Stage 2 used Prisma instead of Drizzle, so use Prisma client here")
7. **Preserve the original structure** — keep the same tasks, ordering, and parallelization unless something fundamental changed

Write the updated plan back to the same file path.

---

### Step 5: Report Changes

Display a summary of what changed:

```
Stage [N] plan refreshed:

Updated:
  - [N]A: Updated file paths (src/lib/ → src/services/)
  - [N]B: Updated imports to use Prisma client from Stage 2
  - [N]C: Added test utility imports from src/test/helpers.ts
  - [N]D: No changes needed

Architecture notes:
  - Stage 2 chose Prisma over Drizzle — updated all ORM references
  - Auth middleware from Stage 3 is at src/middleware/auth.ts
```
