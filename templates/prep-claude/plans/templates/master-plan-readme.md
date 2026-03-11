# [PROJECT_NAME] — Planning Overview

## Why

[2-3 sentences — what problem this solves, who it's for, and what the end state looks like.]

---

## Tech Stack

| Layer | Choice |
|-------|--------|
| Framework | [e.g., Next.js 15 (App Router) + TypeScript] |
| Database | [e.g., PostgreSQL via Prisma] |
| Auth | [e.g., NextAuth.js with Google + credentials] |
| Styling | [e.g., Tailwind CSS + shadcn/ui] |
| Testing | [e.g., Vitest + Playwright] |
| Deployment | [e.g., Vercel + Supabase] |

---

## Agent Team

**Team:** [team preset name, e.g., "SaaS Product"]

| Agent | Role in this project |
|-------|---------------------|
| `coordinator` | Orchestrates task delegation and synthesis |
| `backend-architect` | [specific role] |
| `frontend-architect` | [specific role] |
| [additional agents] | [specific roles] |

---

## Stages & Dependencies

```
Stage 0: [TITLE]                              ✅ / ⏳ / ⬚
  [0A-0C] [summary] ──────────────────────────│

Stage 1: [TITLE]                              ✅ / ⏳ / ⬚
  [1A] [task] ─────────────────┐               │
  [1B] [task] ─────────────────├── 1A + 1B in PARALLEL
                               │               │
  [1C] [task] ──────────────── depends on 1A   │

Stage 2: [TITLE]                              ✅ / ⏳ / ⬚
  [2A] [task] ─────────────────┐               │
  [2B] [task] ─────────────────├── depends on Stage 1
                               │               │

[... additional stages ...]
```

Legend: ✅ Complete | ⏳ Active | ⬚ Pending

---

## Parallelization Map

| When | Run in parallel | Why safe |
|------|----------------|----------|
| [condition] | [tasks] | [reason they don't conflict] |
| [condition] | [tasks] | [reason] |

**Critical path:** [stage] → [stage] → [stage] → [stage]

---

## Stage Documents

| Stage | Document | Tasks | Purpose | Status |
|-------|----------|-------|---------|--------|
| 0 | [stage-0-foundation.md](active/stage-0-foundation.md) | [task summary] | [purpose] | Pending |
| 1 | [stage-1-data-layer.md](active/stage-1-data-layer.md) | [task summary] | [purpose] | Pending |
| 2 | [stage-2-api.md](active/stage-2-api.md) | [task summary] | [purpose] | Pending |
| [N] | [stage-N-title.md](active/stage-N-title.md) | [task summary] | [purpose] | Pending |

---

## How Stages Feed Into Each Other

[Describe which modules from earlier stages are reused or extended in later stages. This helps when reading a later stage to understand what already exists.]

| Early stage module | Reused in | How |
|-------------------|-----------|-----|
| [module/file] | Stage [N] | [description] |
| [module/file] | Stage [N] | [description] |

---

## Scope

### Phase 1 (Stages 0-[N])
[What's included in the first deliverable — the MVP or first milestone]

### Phase 2 (Stages [N]-[M])
[What gets added next — feature expansion, polish, or scaling]

### Future
- [Feature idea not yet planned]
- [Feature idea not yet planned]

---

## Project Structure

```
[project-name]/
  .claude/
    agents/         # Agent team
    rules/          # Project knowledge base
  plans/
    active/         # Stage plans
    archive/        # Completed stages
    templates/      # Plan templates
  src/              # Application source
    [key directories with brief purpose annotations]
  CLAUDE.md
```

---

## Testing Approach

| What | Test approach |
|------|---------------|
| [layer/module] | [how it's tested] |
| [layer/module] | [how it's tested] |
| [layer/module] | [how it's tested] |

---

## Development Workflow

1. Open the next pending stage document
2. Use `superpowers:executing-plans` to work through tasks
3. Each task follows: Steps → Test → Verify → Commit
4. After completing all tasks, run Stage Deliverable Verification
5. Move completed stage to `plans/archive/`
6. Update this README (mark stage as ✅ Complete)
7. Open the next stage
