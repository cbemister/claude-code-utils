---
name: factory
description: Use when managing the software factory lifecycle — launching new products, building them, evolving them for revenue, or checking factory-wide status.
argument-hint: "[command] [project|idea] - Commands: launch, build, evolve, status, list"
---

# Factory

Top-level orchestrator for the software factory. Manages the full lifecycle: launch products, build them, evolve for revenue, track progress.

## Instructions

> **CRITICAL — NON-INTERACTIVE for build/evolve**: When running `build` or `evolve`, execute without pausing. For `launch`, follow the `/launch-app` interactive flow. For `status` and `list`, display and stop.

---

### Step 0: Parse Command

Read the `$ARGS` to determine the command:

- **`launch <idea>`** → Step 1
- **`build [project]`** → Step 2
- **`evolve [project]`** → Step 3
- **`status [project]`** → Step 4
- **`list`** → Step 5
- **No argument** → Step 5 (show list)

---

### Step 1: Launch (`/factory launch <idea>`)

1. Invoke `/launch-app` with the idea argument — this creates the project folder, configures the team, generates CLAUDE.md and all stage plans.

2. After `/launch-app` completes, register the project. Read the new project's `CLAUDE.md` to extract name, stack, and team.

3. Read or create `factory/registry.json` in the current directory (claude-code-utils root):
   ```bash
   mkdir -p factory
   ```

4. Add the project entry:
   ```json
   {
     "name": "[project-name]",
     "path": "../[project-name]",
     "stack": "[stack]",
     "team": "[team-preset]",
     "status": "planned",
     "created_at": "[ISO timestamp]",
     "current_cycle": 0,
     "latest_score": null,
     "baseline_score": null,
     "deploy_target": "vercel"
   }
   ```

5. Display summary:
   ```
   Project registered in factory.
   Next: Run /factory build [project-name] to start building.
   ```

---

### Step 2: Build (`/factory build [project]`)

1. Resolve project path:
   - If `[project]` provided, look it up in `factory/registry.json`
   - If not provided, use the current directory

2. Update registry status to `"building"`

3. Change to the project directory and invoke `/build-app`

4. After build completes, update registry status to `"built"`

---

### Step 3: Evolve (`/factory evolve [project]`)

1. Resolve project path (same as Step 2)

2. Change to the project directory

3. Read `factory/evolution-state.json` (create if missing — `/evaluate-product` will initialize it)

4. Based on current status, invoke the next skill in the evolution loop:

   | Status | Action |
   |--------|--------|
   | `""` / `"idle"` / `"approved"` | Invoke `/evaluate-product` |
   | `"evaluating"` | Invoke `/evaluate-product` (resume) |
   | `"hypothesizing"` | Invoke `/generate-hypotheses` |
   | `"planning"` | Invoke `/plan-optimization` |
   | `"building"` | Invoke `/build-app` |
   | `"preview_deployed"` / `"awaiting_approval"` | Display preview info and instructions (see below) |
   | `"rejected"` | Invoke `/generate-hypotheses` |

5. If status is `preview_deployed` or `awaiting_approval`, display:
   ```
   ================================================================
     Preview Deployed — Awaiting Human Approval
   ================================================================

     Cycle:    [N]
     Branch:   [preview branch name]
     Preview:  [expected preview URL]

     Hypotheses in this cycle:
       - [hypothesis title 1]
       - [hypothesis title 2]

     Actions:
       /evolution-gate approve    — merge to production
       /evolution-gate reject     — discard and try next
   ================================================================
   ```

6. Update registry with current cycle and latest score

---

### Step 4: Status (`/factory status [project]`)

#### Factory-wide status (no project specified):

1. Read `factory/registry.json`
2. For each project, read its `factory/evolution-state.json` if it exists
3. Display:

```
================================================================
  Software Factory Status
================================================================

  Registered Projects: N
  Currently Evolving:  M

  Project          Status     Cycle  Score  Baseline  Delta
  ─────────────────────────────────────────────────────────
  expense-tracker  evolving   3      78     62        +16
  blog-platform    built      0      —      —         —

  Next Action: [most important pending action]
================================================================
```

#### Per-project status (project specified):

1. Resolve project path
2. Read `factory/evolution-state.json`
3. Read all evaluations from `factory/evaluations/`
4. Display detailed evolution history:

```
================================================================
  Evolution Status: [project-name]
================================================================

  Status:    [current status]
  Cycle:     [N]

  Score History:
    Cycle 0 (baseline):        62/100
    Cycle 1 (social proof):    71/100  (+9)   approved
    Cycle 2 (form reduction):  78/100  (+7)   approved
    Cycle 3 (hero rewrite):    pending

  Current Hypothesis:
    [hypothesis title]
    Expected: +[X] composite score

  Rejected Hypotheses:
    - [title] — [reason]

  Next Action:
    [what needs to happen next]
================================================================
```

---

### Step 5: List (`/factory list`)

1. Read `factory/registry.json`
2. Display project list:

```
Registered Projects:

  1. expense-tracker  (nextjs-app, saas-product)  — evolving, cycle 3, score 78
  2. blog-platform    (nextjs-app, marketing)     — built, not yet evolving
  3. api-service      (express, enterprise)        — building, stage 4 of 7
```

---

## Registry Schema

File: `factory/registry.json` (in claude-code-utils root)

```json
{
  "version": 1,
  "projects": [
    {
      "name": "expense-tracker",
      "path": "../expense-tracker",
      "stack": "nextjs-app",
      "team": "saas-product",
      "status": "planned | building | built | evolving | idle",
      "created_at": "ISO timestamp",
      "current_cycle": 0,
      "latest_score": null,
      "baseline_score": null,
      "deploy_target": "vercel"
    }
  ]
}
```

---

## Error Recovery

| Scenario | Recovery |
|----------|----------|
| Registry doesn't exist | Create it with empty projects array |
| Project not in registry | Search for project directory by name in parent directories |
| Project directory missing | Report error, suggest re-running /factory launch |
| Evolution state missing | /evaluate-product will create it on first run |
