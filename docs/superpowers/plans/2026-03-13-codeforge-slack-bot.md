# CodeForge Slack Bot Implementation Plan

> **For agentic workers:** REQUIRED: Use superpowers:subagent-driven-development (if subagents available) or superpowers:executing-plans to implement this plan. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a Slack Bolt bot that turns CodeForge into a full control plane — slash commands, interactive buttons, threaded progress updates — all via Socket Mode from the local machine.

**Architecture:** Thin bridge pattern. The bot spawns existing runner scripts as child processes, watches their state files with `fs.watchFile()`, and posts rich Slack messages. No business logic in the bot — runners do all real work.

**Tech Stack:** TypeScript, Slack Bolt 4.x, Socket Mode, Node.js child_process

**Spec:** [docs/superpowers/specs/2026-03-13-codeforge-slack-bot-design.md](docs/superpowers/specs/2026-03-13-codeforge-slack-bot-design.md)

---

## File Structure

```
scripts/factory-bot/
├── package.json            # Dependencies: @slack/bolt, tsx, typescript
├── tsconfig.json           # Strict TS config
├── .env.example            # Template for required env vars
├── index.ts                # Bolt app init, command routing, startup
├── config.ts               # Load and validate env vars
├── commands/
│   ├── launch.ts           # /factory launch <idea>
│   ├── build.ts            # /factory build <project>
│   ├── evolve.ts           # /factory evolve <project>
│   ├── status.ts           # /factory status [project]
│   ├── list.ts             # /factory list
│   ├── approve.ts          # Button: approve evolution gate
│   └── reject.ts           # Button: reject evolution gate
├── lib/
│   ├── state-reader.ts     # Parse build-state.json & evolution-state.json
│   ├── process-mgr.ts      # Spawn/track child processes, one-per-project
│   ├── slack-fmt.ts        # Block Kit message builders
│   └── file-watcher.ts     # fs.watchFile wrapper with diff detection
└── __tests__/
    ├── state-reader.test.ts
    ├── slack-fmt.test.ts
    ├── process-mgr.test.ts
    ├── file-watcher.test.ts
    ├── commands/
    │   ├── status.test.ts
    │   ├── list.test.ts
    │   ├── build.test.ts
    │   ├── evolve.test.ts
    │   ├── launch.test.ts
    │   ├── approve.test.ts
    │   └── reject.test.ts
    └── fixtures/
        ├── build-state-in-progress.json
        ├── build-state-complete.json
        ├── evolution-state-gate.json
        ├── evolution-state-building.json
        └── registry.json
```

---

## Chunk 1: Project Scaffolding + Config + State Reader

### Task 1: Project scaffolding

**Files:**
- Create: `scripts/factory-bot/package.json`
- Create: `scripts/factory-bot/tsconfig.json`
- Create: `scripts/factory-bot/.env.example`
- Create: `scripts/factory-bot/.gitignore`

- [ ] **Step 1: Create package.json**

```json
{
  "name": "codeforge-bot",
  "private": true,
  "type": "module",
  "scripts": {
    "dev": "tsx index.ts",
    "build": "tsc",
    "start": "node dist/index.js",
    "test": "vitest run",
    "test:watch": "vitest"
  },
  "dependencies": {
    "@slack/bolt": "^4.1.0"
  },
  "devDependencies": {
    "@types/node": "^22.0.0",
    "typescript": "^5.7.0",
    "tsx": "^4.19.0",
    "vitest": "^3.0.0"
  }
}
```

- [ ] **Step 2: Create tsconfig.json**

```json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "Node16",
    "moduleResolution": "Node16",
    "outDir": "dist",
    "rootDir": ".",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "resolveJsonModule": true,
    "declaration": true,
    "declarationMap": true,
    "sourceMap": true
  },
  "include": ["*.ts", "commands/**/*.ts", "lib/**/*.ts"],
  "exclude": ["node_modules", "dist", "__tests__"]
}
```

- [ ] **Step 3: Create .env.example**

```bash
SLACK_BOT_TOKEN=xoxb-...          # Bot User OAuth Token
SLACK_APP_TOKEN=xapp-...          # App-Level Token (Socket Mode)
SLACK_SIGNING_SECRET=...          # Kept for future HTTP mode
FACTORY_ROOT=/c/Users/cbemister/Development/claude-code-utils
SLACK_CHANNEL=#codeforge          # Default notification channel
```

- [ ] **Step 4: Create .gitignore**

```
node_modules/
dist/
.env
```

- [ ] **Step 5: Run npm install**

Run: `cd scripts/factory-bot && npm install`
Expected: `node_modules/` created, `package-lock.json` generated

- [ ] **Step 6: Verify TypeScript compiles**

Run: `cd scripts/factory-bot && npx tsc --noEmit`
Expected: No errors (no source files yet, clean exit)

- [ ] **Step 7: Commit scaffolding**

```bash
git add scripts/factory-bot/package.json scripts/factory-bot/tsconfig.json scripts/factory-bot/.env.example scripts/factory-bot/.gitignore scripts/factory-bot/package-lock.json
git commit -m "feat(factory-bot): scaffold project with Bolt, TypeScript, Vitest"
```

---

### Task 2: Configuration module

**Files:**
- Create: `scripts/factory-bot/config.ts`
- Test: `scripts/factory-bot/__tests__/config.test.ts`

- [ ] **Step 1: Write failing test for config loading**

```typescript
// __tests__/config.test.ts
import { describe, it, expect, beforeEach, afterEach } from 'vitest';
import { loadConfig } from '../config.js';

describe('loadConfig', () => {
  const originalEnv = process.env;

  beforeEach(() => {
    process.env = { ...originalEnv };
  });

  afterEach(() => {
    process.env = originalEnv;
  });

  it('loads all required env vars', () => {
    process.env.SLACK_BOT_TOKEN = 'xoxb-test';
    process.env.SLACK_APP_TOKEN = 'xapp-test';
    process.env.SLACK_SIGNING_SECRET = 'secret';
    process.env.FACTORY_ROOT = '/tmp/factory';

    const config = loadConfig();
    expect(config.slackBotToken).toBe('xoxb-test');
    expect(config.slackAppToken).toBe('xapp-test');
    expect(config.signingSecret).toBe('secret');
    expect(config.factoryRoot).toBe('/tmp/factory');
    expect(config.slackChannel).toBe('#codeforge'); // default
  });

  it('throws if SLACK_BOT_TOKEN is missing', () => {
    process.env.SLACK_APP_TOKEN = 'xapp-test';
    process.env.FACTORY_ROOT = '/tmp/factory';
    delete process.env.SLACK_BOT_TOKEN;

    expect(() => loadConfig()).toThrow('SLACK_BOT_TOKEN');
  });

  it('throws if SLACK_APP_TOKEN is missing', () => {
    process.env.SLACK_BOT_TOKEN = 'xoxb-test';
    process.env.FACTORY_ROOT = '/tmp/factory';
    delete process.env.SLACK_APP_TOKEN;

    expect(() => loadConfig()).toThrow('SLACK_APP_TOKEN');
  });

  it('throws if FACTORY_ROOT is missing', () => {
    process.env.SLACK_BOT_TOKEN = 'xoxb-test';
    process.env.SLACK_APP_TOKEN = 'xapp-test';
    delete process.env.FACTORY_ROOT;

    expect(() => loadConfig()).toThrow('FACTORY_ROOT');
  });

  it('uses custom SLACK_CHANNEL when set', () => {
    process.env.SLACK_BOT_TOKEN = 'xoxb-test';
    process.env.SLACK_APP_TOKEN = 'xapp-test';
    process.env.FACTORY_ROOT = '/tmp/factory';
    process.env.SLACK_CHANNEL = '#builds';

    const config = loadConfig();
    expect(config.slackChannel).toBe('#builds');
  });
});
```

- [ ] **Step 2: Run test to verify it fails**

Run: `cd scripts/factory-bot && npx vitest run __tests__/config.test.ts`
Expected: FAIL — cannot find module '../config.js'

- [ ] **Step 3: Implement config.ts**

```typescript
// config.ts
export interface Config {
  slackBotToken: string;
  slackAppToken: string;
  signingSecret: string;
  factoryRoot: string;
  slackChannel: string;
}

function requireEnv(name: string): string {
  const value = process.env[name];
  if (!value) {
    throw new Error(`Missing required environment variable: ${name}`);
  }
  return value;
}

export function loadConfig(): Config {
  return {
    slackBotToken: requireEnv('SLACK_BOT_TOKEN'),
    slackAppToken: requireEnv('SLACK_APP_TOKEN'),
    signingSecret: process.env.SLACK_SIGNING_SECRET ?? '',
    factoryRoot: requireEnv('FACTORY_ROOT'),
    slackChannel: process.env.SLACK_CHANNEL ?? '#codeforge',
  };
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `cd scripts/factory-bot && npx vitest run __tests__/config.test.ts`
Expected: PASS — all 5 tests pass

- [ ] **Step 5: Commit**

```bash
git add scripts/factory-bot/config.ts scripts/factory-bot/__tests__/config.test.ts
git commit -m "feat(factory-bot): add config module with env validation"
```

---

### Task 3: Test fixtures

**Files:**
- Create: `scripts/factory-bot/__tests__/fixtures/build-state-in-progress.json`
- Create: `scripts/factory-bot/__tests__/fixtures/build-state-complete.json`
- Create: `scripts/factory-bot/__tests__/fixtures/evolution-state-gate.json`
- Create: `scripts/factory-bot/__tests__/fixtures/evolution-state-building.json`
- Create: `scripts/factory-bot/__tests__/fixtures/registry.json`

- [ ] **Step 1: Create build-state-in-progress fixture**

```json
{
  "version": 1,
  "project": "task-tracker",
  "team": "saas-product",
  "status": "in_progress",
  "current_stage": 1,
  "total_stages": 3,
  "iteration_count": 5,
  "started_at": "2026-03-13T10:00:00Z",
  "updated_at": "2026-03-13T10:30:00Z",
  "stages": [
    {
      "stage": 0,
      "title": "Foundation",
      "file": "plans/active/stage-0-foundation.md",
      "status": "complete",
      "started_at": "2026-03-13T10:00:00Z",
      "completed_at": "2026-03-13T10:15:00Z",
      "tasks": { "0A": "complete", "0B": "complete" },
      "verification": { "tier1": "passed", "tier2": "passed" },
      "retries": 0,
      "error": null,
      "preview_url": null
    },
    {
      "stage": 1,
      "title": "Core Features",
      "file": "plans/active/stage-1-core-features.md",
      "status": "in_progress",
      "started_at": "2026-03-13T10:15:00Z",
      "completed_at": null,
      "tasks": { "1A": "complete", "1B": "in_progress", "1C": "pending" },
      "verification": {},
      "retries": 0,
      "error": null,
      "preview_url": null
    },
    {
      "stage": 2,
      "title": "Polish",
      "file": "plans/active/stage-2-polish.md",
      "status": "pending",
      "started_at": null,
      "completed_at": null,
      "tasks": { "2A": "pending", "2B": "pending" },
      "verification": {},
      "retries": 0,
      "error": null,
      "preview_url": null
    }
  ]
}
```

- [ ] **Step 2: Create build-state-complete fixture**

```json
{
  "version": 1,
  "project": "task-tracker",
  "team": "saas-product",
  "status": "complete",
  "current_stage": 2,
  "total_stages": 3,
  "iteration_count": 12,
  "started_at": "2026-03-13T10:00:00Z",
  "updated_at": "2026-03-13T11:00:00Z",
  "stages": [
    {
      "stage": 0, "title": "Foundation", "file": "plans/active/stage-0-foundation.md",
      "status": "complete", "started_at": "2026-03-13T10:00:00Z", "completed_at": "2026-03-13T10:15:00Z",
      "tasks": { "0A": "complete", "0B": "complete" }, "verification": { "tier1": "passed", "tier2": "passed" },
      "retries": 0, "error": null, "preview_url": null
    },
    {
      "stage": 1, "title": "Core Features", "file": "plans/active/stage-1-core-features.md",
      "status": "complete", "started_at": "2026-03-13T10:15:00Z", "completed_at": "2026-03-13T10:45:00Z",
      "tasks": { "1A": "complete", "1B": "complete", "1C": "complete" }, "verification": { "tier1": "passed", "tier2": "passed" },
      "retries": 0, "error": null, "preview_url": null
    },
    {
      "stage": 2, "title": "Polish", "file": "plans/active/stage-2-polish.md",
      "status": "complete", "started_at": "2026-03-13T10:45:00Z", "completed_at": "2026-03-13T11:00:00Z",
      "tasks": { "2A": "complete", "2B": "complete" }, "verification": { "tier1": "passed", "tier2": "passed" },
      "retries": 0, "error": null, "preview_url": "https://task-tracker.vercel.app"
    }
  ]
}
```

- [ ] **Step 3: Create evolution-state-gate fixture**

```json
{
  "version": 1,
  "project": "task-tracker",
  "status": "preview_deployed",
  "current_cycle": 1,
  "total_cycles_completed": 0,
  "deploy_target": {
    "platform": "vercel",
    "production_branch": "main"
  },
  "baseline": {
    "evaluation_ref": "factory/evaluations/eval-2026-03-12-100000.json",
    "composite_score": 62
  },
  "cycles": [
    {
      "cycle": 0,
      "status": "approved",
      "evaluation_score": 62,
      "hypothesis_ids": ["hyp-0-001", "hyp-0-002"],
      "hypothesis_titles": ["Add clear CTA above fold", "Improve loading performance"],
      "stage_plan_ref": "plans/active/stage-opt-0.md",
      "preview_branch": "preview/evolution-cycle-0-cta-perf",
      "preview_url": "https://task-tracker-preview-0.vercel.app",
      "score_delta": 8,
      "rejection_reason": null
    },
    {
      "cycle": 1,
      "status": "pending",
      "evaluation_score": 70,
      "hypothesis_ids": ["hyp-1-001"],
      "hypothesis_titles": ["Add social proof section"],
      "stage_plan_ref": "plans/active/stage-opt-1.md",
      "preview_branch": "preview/evolution-cycle-1-social-proof",
      "preview_url": "https://task-tracker-preview-1.vercel.app",
      "score_delta": null,
      "rejection_reason": null
    }
  ],
  "rejected_hypotheses": []
}
```

- [ ] **Step 4: Create evolution-state-building fixture**

```json
{
  "version": 1,
  "project": "task-tracker",
  "status": "building",
  "current_cycle": 0,
  "total_cycles_completed": 0,
  "deploy_target": {
    "platform": "vercel",
    "production_branch": "main"
  },
  "baseline": {
    "evaluation_ref": "factory/evaluations/eval-2026-03-12-100000.json",
    "composite_score": 62
  },
  "cycles": [
    {
      "cycle": 0,
      "status": "in_progress",
      "evaluation_score": 62,
      "hypothesis_ids": ["hyp-0-001"],
      "hypothesis_titles": ["Add clear CTA above fold"],
      "stage_plan_ref": "plans/active/stage-opt-0.md",
      "preview_branch": null,
      "preview_url": null,
      "score_delta": null,
      "rejection_reason": null
    }
  ],
  "rejected_hypotheses": []
}
```

- [ ] **Step 5: Create registry fixture**

```json
{
  "version": 1,
  "projects": [
    {
      "name": "task-tracker",
      "path": "../task-tracker",
      "stack": "nextjs-app",
      "team": "saas-product",
      "status": "built",
      "created_at": "2026-03-12T09:00:00Z",
      "current_cycle": 0,
      "latest_score": 62,
      "baseline_score": 62,
      "deploy_target": "vercel"
    },
    {
      "name": "expense-tracker",
      "path": "../expense-tracker",
      "stack": "nextjs-app",
      "team": "saas-product",
      "status": "evolving",
      "created_at": "2026-03-10T14:00:00Z",
      "current_cycle": 2,
      "latest_score": 78,
      "baseline_score": 55,
      "deploy_target": "vercel"
    }
  ]
}
```

- [ ] **Step 6: Commit fixtures**

```bash
git add scripts/factory-bot/__tests__/fixtures/
git commit -m "test(factory-bot): add state file fixtures for all state types"
```

---

### Task 4: State reader

**Files:**
- Create: `scripts/factory-bot/lib/state-reader.ts`
- Test: `scripts/factory-bot/__tests__/state-reader.test.ts`

- [ ] **Step 1: Write failing tests for state reader**

```typescript
// __tests__/state-reader.test.ts
import { describe, it, expect } from 'vitest';
import { readFileSync } from 'node:fs';
import { join } from 'node:path';
import {
  parseBuildState,
  parseEvolutionState,
  parseRegistry,
  resolveProject,
  type BuildState,
  type EvolutionState,
  type Registry,
} from '../lib/state-reader.js';

const fixturesDir = join(import.meta.dirname, 'fixtures');

function readFixture(name: string): string {
  return readFileSync(join(fixturesDir, name), 'utf-8');
}

describe('parseBuildState', () => {
  it('parses in-progress build state', () => {
    const state = parseBuildState(readFixture('build-state-in-progress.json'));
    expect(state.status).toBe('in_progress');
    expect(state.project).toBe('task-tracker');
    expect(state.current_stage).toBe(1);
    expect(state.total_stages).toBe(3);
    expect(state.stages).toHaveLength(3);
    expect(state.stages[1].tasks).toEqual({
      '1A': 'complete',
      '1B': 'in_progress',
      '1C': 'pending',
    });
  });

  it('parses complete build state', () => {
    const state = parseBuildState(readFixture('build-state-complete.json'));
    expect(state.status).toBe('complete');
    expect(state.stages[2].preview_url).toBe('https://task-tracker.vercel.app');
  });

  it('throws on invalid JSON', () => {
    expect(() => parseBuildState('not json')).toThrow();
  });

  it('returns null fields as null', () => {
    const state = parseBuildState(readFixture('build-state-in-progress.json'));
    expect(state.stages[1].completed_at).toBeNull();
    expect(state.stages[1].error).toBeNull();
  });
});

describe('parseEvolutionState', () => {
  it('parses gate state (preview_deployed)', () => {
    const state = parseEvolutionState(readFixture('evolution-state-gate.json'));
    expect(state.status).toBe('preview_deployed');
    expect(state.current_cycle).toBe(1);
    expect(state.baseline.composite_score).toBe(62);
    expect(state.cycles).toHaveLength(2);
    expect(state.cycles[1].preview_url).toBe('https://task-tracker-preview-1.vercel.app');
  });

  it('parses building state', () => {
    const state = parseEvolutionState(readFixture('evolution-state-building.json'));
    expect(state.status).toBe('building');
    expect(state.cycles[0].hypothesis_titles).toEqual(['Add clear CTA above fold']);
  });
});

describe('parseRegistry', () => {
  it('parses registry with multiple projects', () => {
    const registry = parseRegistry(readFixture('registry.json'));
    expect(registry.projects).toHaveLength(2);
    expect(registry.projects[0].name).toBe('task-tracker');
    expect(registry.projects[1].latest_score).toBe(78);
  });
});

describe('resolveProject', () => {
  const registry: Registry = parseRegistry(readFixture('registry.json'));

  it('resolves by exact name', () => {
    const project = resolveProject(registry, 'task-tracker');
    expect(project).not.toBeNull();
    expect(project!.name).toBe('task-tracker');
  });

  it('returns null for unknown project', () => {
    const project = resolveProject(registry, 'nonexistent');
    expect(project).toBeNull();
  });

  it('is case-insensitive', () => {
    const project = resolveProject(registry, 'Task-Tracker');
    expect(project).not.toBeNull();
  });
});
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `cd scripts/factory-bot && npx vitest run __tests__/state-reader.test.ts`
Expected: FAIL — cannot find module '../lib/state-reader.js'

- [ ] **Step 3: Implement state-reader.ts**

```typescript
// lib/state-reader.ts
import { readFileSync } from 'node:fs';

// --- Build State Types ---

export interface BuildStage {
  stage: number;
  title: string;
  file: string;
  status: 'pending' | 'in_progress' | 'complete' | 'failed';
  started_at: string | null;
  completed_at: string | null;
  tasks: Record<string, string>;
  verification: Record<string, string>;
  retries: number;
  error: string | null;
  preview_url: string | null;
}

export interface BuildState {
  version: number;
  project: string;
  team: string;
  status: 'in_progress' | 'complete' | 'failed';
  current_stage: number;
  total_stages: number;
  iteration_count: number;
  started_at: string;
  updated_at: string;
  stages: BuildStage[];
}

// --- Evolution State Types ---

export interface EvolutionCycle {
  cycle: number;
  status: string;
  evaluation_score: number | null;
  hypothesis_ids: string[];
  hypothesis_titles: string[];
  stage_plan_ref: string;
  preview_branch: string | null;
  preview_url: string | null;
  score_delta: number | null;
  rejection_reason: string | null;
}

export interface EvolutionState {
  version: number;
  project: string;
  status: string;
  current_cycle: number;
  total_cycles_completed: number;
  deploy_target: {
    platform: string;
    production_branch: string;
  };
  baseline: {
    evaluation_ref: string;
    composite_score: number;
  };
  cycles: EvolutionCycle[];
  rejected_hypotheses: Array<{
    id: string;
    title: string;
    reason: string;
    cycle: number;
  }>;
}

// --- Registry Types ---

export interface RegistryProject {
  name: string;
  path: string;
  stack: string;
  team: string;
  status: string;
  created_at: string;
  current_cycle: number;
  latest_score: number | null;
  baseline_score: number | null;
  deploy_target: string;
}

export interface Registry {
  version: number;
  projects: RegistryProject[];
}

// --- Parsers ---

export function parseBuildState(json: string): BuildState {
  return JSON.parse(json) as BuildState;
}

export function parseEvolutionState(json: string): EvolutionState {
  return JSON.parse(json) as EvolutionState;
}

export function parseRegistry(json: string): Registry {
  return JSON.parse(json) as Registry;
}

// --- Helpers ---

export function resolveProject(
  registry: Registry,
  name: string,
): RegistryProject | null {
  const lower = name.toLowerCase();
  return registry.projects.find((p) => p.name.toLowerCase() === lower) ?? null;
}

export function readJsonFile<T>(path: string): T | null {
  try {
    return JSON.parse(readFileSync(path, 'utf-8')) as T;
  } catch {
    return null;
  }
}
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `cd scripts/factory-bot && npx vitest run __tests__/state-reader.test.ts`
Expected: PASS — all tests pass

- [ ] **Step 5: Commit**

```bash
git add scripts/factory-bot/lib/state-reader.ts scripts/factory-bot/__tests__/state-reader.test.ts
git commit -m "feat(factory-bot): add state reader with types for build, evolution, registry"
```

---

## Chunk 2: Slack Formatting + File Watcher

### Task 5: Slack message formatter

**Files:**
- Create: `scripts/factory-bot/lib/slack-fmt.ts`
- Test: `scripts/factory-bot/__tests__/slack-fmt.test.ts`

- [ ] **Step 1: Write failing tests for slack-fmt**

```typescript
// __tests__/slack-fmt.test.ts
import { describe, it, expect } from 'vitest';
import { readFileSync } from 'node:fs';
import { join } from 'node:path';
import {
  formatBuildStatus,
  formatEvolutionStatus,
  formatProjectList,
  formatGateMessage,
  formatTaskUpdate,
  formatStageStart,
  formatBuildComplete,
  formatBuildFailed,
} from '../lib/slack-fmt.js';
import { parseBuildState, parseEvolutionState, parseRegistry } from '../lib/state-reader.js';

const fixturesDir = join(import.meta.dirname, 'fixtures');
const readFixture = (name: string) => readFileSync(join(fixturesDir, name), 'utf-8');

describe('formatBuildStatus', () => {
  it('formats in-progress build as blocks', () => {
    const state = parseBuildState(readFixture('build-state-in-progress.json'));
    const blocks = formatBuildStatus(state);
    expect(blocks).toBeInstanceOf(Array);
    expect(blocks.length).toBeGreaterThan(0);
    // Header block with project name
    const header = blocks[0];
    expect(header.type).toBe('header');
    expect(header.text.text).toContain('task-tracker');
  });

  it('shows task counts per stage', () => {
    const state = parseBuildState(readFixture('build-state-in-progress.json'));
    const blocks = formatBuildStatus(state);
    const text = JSON.stringify(blocks);
    expect(text).toContain('1/3'); // stage 1: 1 complete out of 3
  });

  it('formats complete build with preview URL', () => {
    const state = parseBuildState(readFixture('build-state-complete.json'));
    const blocks = formatBuildStatus(state);
    const text = JSON.stringify(blocks);
    expect(text).toContain('Complete');
    expect(text).toContain('task-tracker.vercel.app');
  });
});

describe('formatEvolutionStatus', () => {
  it('formats gate state with scores', () => {
    const state = parseEvolutionState(readFixture('evolution-state-gate.json'));
    const blocks = formatEvolutionStatus(state);
    const text = JSON.stringify(blocks);
    expect(text).toContain('62'); // baseline score
    expect(text).toContain('preview_deployed');
  });
});

describe('formatProjectList', () => {
  it('formats registry as project list', () => {
    const registry = parseRegistry(readFixture('registry.json'));
    const blocks = formatProjectList(registry);
    const text = JSON.stringify(blocks);
    expect(text).toContain('task-tracker');
    expect(text).toContain('expense-tracker');
    expect(text).toContain('78'); // latest score
  });

  it('shows empty state when no projects', () => {
    const blocks = formatProjectList({ version: 1, projects: [] });
    const text = JSON.stringify(blocks);
    expect(text).toContain('No projects');
  });
});

describe('formatGateMessage', () => {
  it('includes approve and reject buttons', () => {
    const blocks = formatGateMessage('task-tracker', 'https://preview.vercel.app', 70, 62);
    const actions = blocks.find((b: any) => b.type === 'actions');
    expect(actions).toBeDefined();
    expect(actions.elements).toHaveLength(2);
    expect(actions.elements[0].text.text).toContain('Approve');
    expect(actions.elements[1].text.text).toContain('Reject');
  });

  it('includes action_id with project name', () => {
    const blocks = formatGateMessage('task-tracker', 'https://preview.vercel.app', 70, 62);
    const actions = blocks.find((b: any) => b.type === 'actions');
    expect(actions.elements[0].action_id).toBe('gate_approve:task-tracker');
    expect(actions.elements[1].action_id).toBe('gate_reject:task-tracker');
  });
});

describe('formatTaskUpdate', () => {
  it('formats completed task', () => {
    const text = formatTaskUpdate('1A', 'Scaffold Next.js', 'complete', 'abc1234');
    expect(text).toContain('1A');
    expect(text).toContain('Scaffold Next.js');
    expect(text).toContain('abc1234');
  });
});

describe('formatStageStart', () => {
  it('formats stage start with task count', () => {
    const text = formatStageStart(1, 'Core Features', 3);
    expect(text).toContain('Stage 1');
    expect(text).toContain('Core Features');
    expect(text).toContain('3');
  });
});

describe('formatBuildComplete', () => {
  it('includes start evolution button', () => {
    const blocks = formatBuildComplete('task-tracker', 3, 12);
    const actions = blocks.find((b: any) => b.type === 'actions');
    expect(actions).toBeDefined();
    expect(actions.elements[0].action_id).toBe('start_evolve:task-tracker');
  });
});

describe('formatBuildFailed', () => {
  it('includes resume button', () => {
    const blocks = formatBuildFailed('task-tracker', 'Task 1B compilation error');
    const actions = blocks.find((b: any) => b.type === 'actions');
    expect(actions).toBeDefined();
    expect(actions.elements[0].action_id).toBe('resume_build:task-tracker');
  });
});
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `cd scripts/factory-bot && npx vitest run __tests__/slack-fmt.test.ts`
Expected: FAIL — cannot find module '../lib/slack-fmt.js'

- [ ] **Step 3: Implement slack-fmt.ts**

```typescript
// lib/slack-fmt.ts
import type { BuildState, EvolutionState, Registry } from './state-reader.js';

type Block = Record<string, unknown>;

function header(text: string): Block {
  return { type: 'header', text: { type: 'plain_text', text, emoji: true } };
}

function section(text: string): Block {
  return { type: 'section', text: { type: 'mrkdwn', text } };
}

function divider(): Block {
  return { type: 'divider' };
}

function button(text: string, actionId: string, style?: 'primary' | 'danger'): Block {
  const btn: Record<string, unknown> = {
    type: 'button',
    text: { type: 'plain_text', text, emoji: true },
    action_id: actionId,
  };
  if (style) btn.style = style;
  return btn;
}

function taskStatusIcon(status: string): string {
  switch (status) {
    case 'complete': return ':white_check_mark:';
    case 'in_progress': return ':hourglass_flowing_sand:';
    case 'failed': return ':x:';
    default: return ':white_circle:';
  }
}

function stageStatusIcon(status: string): string {
  switch (status) {
    case 'complete': return ':large_green_circle:';
    case 'in_progress': return ':large_yellow_circle:';
    case 'failed': return ':red_circle:';
    default: return ':white_circle:';
  }
}

function countTasks(tasks: Record<string, string>, status: string): number {
  return Object.values(tasks).filter((s) => s === status).length;
}

// --- Public Formatters ---

export function formatBuildStatus(state: BuildState): Block[] {
  const statusLabel = state.status === 'complete' ? 'Complete' :
    state.status === 'failed' ? 'Failed' : 'Building';

  const blocks: Block[] = [
    header(`${state.project} — Build ${statusLabel}`),
    section(`*Status:* ${statusLabel} | *Stages:* ${state.current_stage + 1}/${state.total_stages} | *Iterations:* ${state.iteration_count}`),
    divider(),
  ];

  for (const stage of state.stages) {
    const total = Object.keys(stage.tasks).length;
    const done = countTasks(stage.tasks, 'complete');
    const icon = stageStatusIcon(stage.status);
    let line = `${icon} *Stage ${stage.stage}: ${stage.title}* — ${done}/${total} tasks`;
    if (stage.preview_url) line += ` | <${stage.preview_url}|Preview>`;
    blocks.push(section(line));
  }

  return blocks;
}

export function formatEvolutionStatus(state: EvolutionState): Block[] {
  const blocks: Block[] = [
    header(`${state.project} — Evolution`),
    section(`*Status:* ${state.status} | *Cycle:* ${state.current_cycle} | *Baseline:* ${state.baseline.composite_score}/100`),
    divider(),
  ];

  for (const cycle of state.cycles) {
    let line = `*Cycle ${cycle.cycle}:* ${cycle.hypothesis_titles.join(', ')}`;
    if (cycle.evaluation_score !== null) line += ` | Score: ${cycle.evaluation_score}`;
    if (cycle.score_delta !== null) line += ` (${cycle.score_delta > 0 ? '+' : ''}${cycle.score_delta})`;
    if (cycle.preview_url) line += ` | <${cycle.preview_url}|Preview>`;
    blocks.push(section(line));
  }

  return blocks;
}

export function formatProjectList(registry: Registry): Block[] {
  if (registry.projects.length === 0) {
    return [section('No projects registered. Run `/factory launch <idea>` to create one.')];
  }

  const blocks: Block[] = [header('Factory Projects')];

  for (const p of registry.projects) {
    let line = `*${p.name}* — ${p.stack} | ${p.status}`;
    if (p.latest_score !== null) line += ` | Score: ${p.latest_score}/100`;
    if (p.current_cycle > 0) line += ` | Cycle ${p.current_cycle}`;
    blocks.push(section(line));
  }

  return blocks;
}

export function formatGateMessage(
  project: string,
  previewUrl: string,
  currentScore: number,
  baselineScore: number,
): Block[] {
  const delta = currentScore - baselineScore;
  const deltaStr = delta > 0 ? `+${delta}` : `${delta}`;

  return [
    header(`${project} — Evolution Gate`),
    section(`Preview deployed and ready for review.\n\n*Preview:* <${previewUrl}|Open Preview>\n*Score:* ${currentScore}/100 (${deltaStr} from baseline ${baselineScore})`),
    {
      type: 'actions',
      elements: [
        button('Approve', `gate_approve:${project}`, 'primary'),
        button('Reject', `gate_reject:${project}`, 'danger'),
      ],
    },
  ];
}

export function formatTaskUpdate(
  taskId: string,
  title: string,
  status: string,
  commitHash?: string,
): string {
  const icon = taskStatusIcon(status);
  let text = `${icon} Task ${taskId}: ${title}`;
  if (commitHash) text += ` (\`${commitHash}\`)`;
  return text;
}

export function formatStageStart(stage: number, title: string, taskCount: number): string {
  return `:rocket: *Stage ${stage}: ${title}* — ${taskCount} tasks`;
}

export function formatBuildComplete(project: string, stages: number, commits: number): Block[] {
  return [
    section(`:tada: *${project}* build complete — ${stages} stages, ${commits} commits`),
    {
      type: 'actions',
      elements: [
        button('Start Evolution', `start_evolve:${project}`, 'primary'),
      ],
    },
  ];
}

export function formatBuildFailed(project: string, error: string): Block[] {
  return [
    section(`:x: *${project}* build failed\n\`\`\`${error}\`\`\``),
    {
      type: 'actions',
      elements: [
        button('Resume', `resume_build:${project}`),
        button('View Error', `view_error:${project}`),
      ],
    },
  ];
}
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `cd scripts/factory-bot && npx vitest run __tests__/slack-fmt.test.ts`
Expected: PASS — all tests pass

- [ ] **Step 5: Commit**

```bash
git add scripts/factory-bot/lib/slack-fmt.ts scripts/factory-bot/__tests__/slack-fmt.test.ts
git commit -m "feat(factory-bot): add Slack Block Kit message formatters"
```

---

### Task 6: File watcher

**Files:**
- Create: `scripts/factory-bot/lib/file-watcher.ts`
- Test: `scripts/factory-bot/__tests__/file-watcher.test.ts`

- [ ] **Step 1: Write failing tests for file watcher**

```typescript
// __tests__/file-watcher.test.ts
import { describe, it, expect, vi, afterEach } from 'vitest';
import { writeFileSync, unlinkSync, mkdtempSync } from 'node:fs';
import { join } from 'node:path';
import { tmpdir } from 'node:os';
import { StateFileWatcher } from '../lib/file-watcher.js';

describe('StateFileWatcher', () => {
  let tempDir: string;
  let tempFile: string;

  afterEach(() => {
    try { unlinkSync(tempFile); } catch {}
  });

  it('emits onChange when file content changes', async () => {
    tempDir = mkdtempSync(join(tmpdir(), 'watcher-'));
    tempFile = join(tempDir, 'state.json');
    writeFileSync(tempFile, JSON.stringify({ status: 'pending' }));

    const onChange = vi.fn();
    const watcher = new StateFileWatcher(tempFile, { intervalMs: 100 });
    watcher.onChange = onChange;
    watcher.start();

    // Modify file
    await new Promise((r) => setTimeout(r, 50));
    writeFileSync(tempFile, JSON.stringify({ status: 'in_progress' }));
    await new Promise((r) => setTimeout(r, 250));

    watcher.stop();
    expect(onChange).toHaveBeenCalled();
    const [newContent] = onChange.mock.calls[0];
    expect(JSON.parse(newContent).status).toBe('in_progress');
  });

  it('does not emit when content is unchanged', async () => {
    tempDir = mkdtempSync(join(tmpdir(), 'watcher-'));
    tempFile = join(tempDir, 'state.json');
    const content = JSON.stringify({ status: 'pending' });
    writeFileSync(tempFile, content);

    const onChange = vi.fn();
    const watcher = new StateFileWatcher(tempFile, { intervalMs: 100 });
    watcher.onChange = onChange;
    watcher.start();

    await new Promise((r) => setTimeout(r, 350));

    watcher.stop();
    expect(onChange).not.toHaveBeenCalled();
  });

  it('handles missing file gracefully', async () => {
    tempFile = join(tmpdir(), 'nonexistent-' + Date.now() + '.json');

    const onChange = vi.fn();
    const watcher = new StateFileWatcher(tempFile, { intervalMs: 100 });
    watcher.onChange = onChange;
    watcher.start();

    await new Promise((r) => setTimeout(r, 250));

    watcher.stop();
    expect(onChange).not.toHaveBeenCalled();
  });
});
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `cd scripts/factory-bot && npx vitest run __tests__/file-watcher.test.ts`
Expected: FAIL — cannot find module '../lib/file-watcher.js'

- [ ] **Step 3: Implement file-watcher.ts**

```typescript
// lib/file-watcher.ts
import { readFileSync, statSync } from 'node:fs';
import { createHash } from 'node:crypto';

export interface WatcherOptions {
  intervalMs?: number;
}

export class StateFileWatcher {
  private filePath: string;
  private intervalMs: number;
  private timer: ReturnType<typeof setInterval> | null = null;
  private lastHash: string | null = null;

  onChange: ((content: string) => void) | null = null;

  constructor(filePath: string, options: WatcherOptions = {}) {
    this.filePath = filePath;
    this.intervalMs = options.intervalMs ?? 2000;

    // Capture initial hash so we only fire on changes
    this.lastHash = this.computeHash();
  }

  start(): void {
    if (this.timer) return;
    this.timer = setInterval(() => this.poll(), this.intervalMs);
  }

  stop(): void {
    if (this.timer) {
      clearInterval(this.timer);
      this.timer = null;
    }
  }

  private poll(): void {
    const hash = this.computeHash();
    if (hash === null || hash === this.lastHash) return;

    this.lastHash = hash;
    try {
      const content = readFileSync(this.filePath, 'utf-8');
      this.onChange?.(content);
    } catch {
      // File may have been removed between hash check and read
    }
  }

  private computeHash(): string | null {
    try {
      statSync(this.filePath); // Ensure file exists
      const content = readFileSync(this.filePath, 'utf-8');
      return createHash('md5').update(content).digest('hex');
    } catch {
      return null;
    }
  }
}
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `cd scripts/factory-bot && npx vitest run __tests__/file-watcher.test.ts`
Expected: PASS — all 3 tests pass

- [ ] **Step 5: Commit**

```bash
git add scripts/factory-bot/lib/file-watcher.ts scripts/factory-bot/__tests__/file-watcher.test.ts
git commit -m "feat(factory-bot): add state file watcher with polling and change detection"
```

---

## Chunk 3: Process Manager

### Task 7: Process manager

**Files:**
- Create: `scripts/factory-bot/lib/process-mgr.ts`
- Test: `scripts/factory-bot/__tests__/process-mgr.test.ts`

- [ ] **Step 1: Write failing tests for process manager**

```typescript
// __tests__/process-mgr.test.ts
import { describe, it, expect, beforeEach } from 'vitest';
import { ProcessManager, type ManagedProcess } from '../lib/process-mgr.js';

describe('ProcessManager', () => {
  let mgr: ProcessManager;

  beforeEach(() => {
    mgr = new ProcessManager();
  });

  it('starts with empty process map', () => {
    expect(mgr.getAll()).toEqual([]);
  });

  it('tracks a registered process', () => {
    const proc: ManagedProcess = {
      projectName: 'test-project',
      type: 'build',
      process: null as any, // Mock — we test tracking, not spawning
      threadTs: '1234.5678',
      channelId: 'C123',
      startedAt: new Date(),
      stateFile: '/tmp/state.json',
    };
    mgr.register(proc);
    expect(mgr.get('test-project')).toBe(proc);
    expect(mgr.getAll()).toHaveLength(1);
  });

  it('rejects duplicate project', () => {
    const proc: ManagedProcess = {
      projectName: 'test-project',
      type: 'build',
      process: null as any,
      threadTs: '1234.5678',
      channelId: 'C123',
      startedAt: new Date(),
      stateFile: '/tmp/state.json',
    };
    mgr.register(proc);
    expect(() => mgr.register(proc)).toThrow('already running');
  });

  it('removes a process', () => {
    const proc: ManagedProcess = {
      projectName: 'test-project',
      type: 'build',
      process: null as any,
      threadTs: '1234.5678',
      channelId: 'C123',
      startedAt: new Date(),
      stateFile: '/tmp/state.json',
    };
    mgr.register(proc);
    mgr.remove('test-project');
    expect(mgr.get('test-project')).toBeUndefined();
  });

  it('allows re-registering after removal', () => {
    const proc: ManagedProcess = {
      projectName: 'test-project',
      type: 'build',
      process: null as any,
      threadTs: '1234.5678',
      channelId: 'C123',
      startedAt: new Date(),
      stateFile: '/tmp/state.json',
    };
    mgr.register(proc);
    mgr.remove('test-project');
    expect(() => mgr.register(proc)).not.toThrow();
  });

  it('tracks multiple projects concurrently', () => {
    mgr.register({
      projectName: 'project-a', type: 'build', process: null as any,
      threadTs: '1', channelId: 'C1', startedAt: new Date(), stateFile: '/a',
    });
    mgr.register({
      projectName: 'project-b', type: 'evolve', process: null as any,
      threadTs: '2', channelId: 'C1', startedAt: new Date(), stateFile: '/b',
    });
    expect(mgr.getAll()).toHaveLength(2);
  });
});
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `cd scripts/factory-bot && npx vitest run __tests__/process-mgr.test.ts`
Expected: FAIL — cannot find module '../lib/process-mgr.js'

- [ ] **Step 3: Implement process-mgr.ts**

```typescript
// lib/process-mgr.ts
import { spawn, type ChildProcess } from 'node:child_process';
import { join } from 'node:path';

export interface ManagedProcess {
  projectName: string;
  type: 'build' | 'evolve' | 'launch';
  process: ChildProcess;
  threadTs: string;
  channelId: string;
  startedAt: Date;
  stateFile: string;
}

export class ProcessManager {
  private processes = new Map<string, ManagedProcess>();

  register(proc: ManagedProcess): void {
    if (this.processes.has(proc.projectName)) {
      throw new Error(`Process already running for "${proc.projectName}"`);
    }
    this.processes.set(proc.projectName, proc);
  }

  get(projectName: string): ManagedProcess | undefined {
    return this.processes.get(projectName);
  }

  getAll(): ManagedProcess[] {
    return Array.from(this.processes.values());
  }

  remove(projectName: string): void {
    this.processes.delete(projectName);
  }

  isRunning(projectName: string): boolean {
    return this.processes.has(projectName);
  }

  spawnBuild(
    projectPath: string,
    factoryRoot: string,
    options: { skipPermissions?: boolean } = {},
  ): ChildProcess {
    const script = join(factoryRoot, 'scripts', 'build-app-runner.sh');
    const args = [script, '--skip-permissions', projectPath];
    return spawn('bash', args, {
      cwd: factoryRoot,
      env: { ...process.env, SLACK_WEBHOOK_URL: '' },
      stdio: ['ignore', 'pipe', 'pipe'],
    });
  }

  spawnEvolve(
    projectPath: string,
    factoryRoot: string,
    options: { skipPermissions?: boolean } = {},
  ): ChildProcess {
    const script = join(factoryRoot, 'scripts', 'evolution-runner.sh');
    const args = [script, '--skip-permissions', projectPath];
    return spawn('bash', args, {
      cwd: factoryRoot,
      env: { ...process.env, SLACK_WEBHOOK_URL: '' },
      stdio: ['ignore', 'pipe', 'pipe'],
    });
  }

  spawnLaunch(
    idea: string,
    factoryRoot: string,
  ): ChildProcess {
    const args = [
      '--print',
      '--dangerously-skip-permissions',
      '-p',
      `/factory launch ${idea}`,
    ];
    return spawn('claude', args, {
      cwd: factoryRoot,
      stdio: ['ignore', 'pipe', 'pipe'],
    });
  }
}
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `cd scripts/factory-bot && npx vitest run __tests__/process-mgr.test.ts`
Expected: PASS — all 6 tests pass

- [ ] **Step 5: Commit**

```bash
git add scripts/factory-bot/lib/process-mgr.ts scripts/factory-bot/__tests__/process-mgr.test.ts
git commit -m "feat(factory-bot): add process manager with spawn helpers and one-per-project guard"
```

---

## Chunk 4: Read-Only Commands (status, list)

### Task 8: Status command

**Files:**
- Create: `scripts/factory-bot/commands/status.ts`
- Test: `scripts/factory-bot/__tests__/commands/status.test.ts`

- [ ] **Step 1: Write failing test for status command**

```typescript
// __tests__/commands/status.test.ts
import { describe, it, expect, vi } from 'vitest';
import { readFileSync } from 'node:fs';
import { join } from 'node:path';
import { handleStatus } from '../../commands/status.js';
import { parseRegistry } from '../../lib/state-reader.js';

const fixturesDir = join(import.meta.dirname, '..', 'fixtures');
const readFixture = (name: string) => readFileSync(join(fixturesDir, name), 'utf-8');

// Mock ack and respond
function mockSlackContext() {
  return {
    ack: vi.fn(),
    respond: vi.fn(),
  };
}

describe('handleStatus', () => {
  it('responds with build status when project has build state', async () => {
    const ctx = mockSlackContext();
    const registry = parseRegistry(readFixture('registry.json'));

    await handleStatus({
      projectName: 'task-tracker',
      registry,
      buildStateJson: readFixture('build-state-in-progress.json'),
      evolutionStateJson: null,
      ack: ctx.ack,
      respond: ctx.respond,
    });

    expect(ctx.ack).toHaveBeenCalled();
    expect(ctx.respond).toHaveBeenCalled();
    const call = ctx.respond.mock.calls[0][0];
    expect(call.response_type).toBe('ephemeral');
    expect(call.blocks).toBeDefined();
  });

  it('responds with evolution status when project has evolution state', async () => {
    const ctx = mockSlackContext();
    const registry = parseRegistry(readFixture('registry.json'));

    await handleStatus({
      projectName: 'task-tracker',
      registry,
      buildStateJson: null,
      evolutionStateJson: readFixture('evolution-state-gate.json'),
      ack: ctx.ack,
      respond: ctx.respond,
    });

    expect(ctx.respond).toHaveBeenCalled();
    const call = ctx.respond.mock.calls[0][0];
    const text = JSON.stringify(call.blocks);
    expect(text).toContain('Evolution');
  });

  it('responds with not found for unknown project', async () => {
    const ctx = mockSlackContext();
    const registry = parseRegistry(readFixture('registry.json'));

    await handleStatus({
      projectName: 'nonexistent',
      registry,
      buildStateJson: null,
      evolutionStateJson: null,
      ack: ctx.ack,
      respond: ctx.respond,
    });

    expect(ctx.respond).toHaveBeenCalled();
    const call = ctx.respond.mock.calls[0][0];
    expect(call.text).toContain('not found');
  });
});
```

- [ ] **Step 2: Run test to verify it fails**

Run: `cd scripts/factory-bot && npx vitest run __tests__/commands/status.test.ts`
Expected: FAIL — cannot find module '../../commands/status.js'

- [ ] **Step 3: Implement status.ts**

```typescript
// commands/status.ts
import {
  parseBuildState,
  parseEvolutionState,
  resolveProject,
  type Registry,
} from '../lib/state-reader.js';
import { formatBuildStatus, formatEvolutionStatus } from '../lib/slack-fmt.js';

export interface StatusArgs {
  projectName: string;
  registry: Registry;
  buildStateJson: string | null;
  evolutionStateJson: string | null;
  ack: () => Promise<void>;
  respond: (msg: Record<string, unknown>) => Promise<void>;
}

export async function handleStatus(args: StatusArgs): Promise<void> {
  await args.ack();

  const project = resolveProject(args.registry, args.projectName);
  if (!project) {
    const names = args.registry.projects.map((p) => p.name).join(', ');
    await args.respond({
      response_type: 'ephemeral',
      text: `Project "${args.projectName}" not found. Registered: ${names || 'none'}`,
    });
    return;
  }

  // Prefer evolution state if available, fall back to build state
  if (args.evolutionStateJson) {
    const state = parseEvolutionState(args.evolutionStateJson);
    await args.respond({
      response_type: 'ephemeral',
      blocks: formatEvolutionStatus(state),
    });
    return;
  }

  if (args.buildStateJson) {
    const state = parseBuildState(args.buildStateJson);
    await args.respond({
      response_type: 'ephemeral',
      blocks: formatBuildStatus(state),
    });
    return;
  }

  await args.respond({
    response_type: 'ephemeral',
    text: `*${project.name}* — ${project.status} (no active state files found)`,
  });
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `cd scripts/factory-bot && npx vitest run __tests__/commands/status.test.ts`
Expected: PASS — all 3 tests pass

- [ ] **Step 5: Commit**

```bash
git add scripts/factory-bot/commands/status.ts scripts/factory-bot/__tests__/commands/status.test.ts
git commit -m "feat(factory-bot): add /factory status command"
```

---

### Task 9: List command

**Files:**
- Create: `scripts/factory-bot/commands/list.ts`
- Test: `scripts/factory-bot/__tests__/commands/list.test.ts`

- [ ] **Step 1: Write failing test for list command**

```typescript
// __tests__/commands/list.test.ts
import { describe, it, expect, vi } from 'vitest';
import { readFileSync } from 'node:fs';
import { join } from 'node:path';
import { handleList } from '../../commands/list.js';
import { parseRegistry } from '../../lib/state-reader.js';

const fixturesDir = join(import.meta.dirname, '..', 'fixtures');
const readFixture = (name: string) => readFileSync(join(fixturesDir, name), 'utf-8');

function mockSlackContext() {
  return { ack: vi.fn(), respond: vi.fn() };
}

describe('handleList', () => {
  it('lists all projects from registry', async () => {
    const ctx = mockSlackContext();
    const registry = parseRegistry(readFixture('registry.json'));

    await handleList({ registry, ack: ctx.ack, respond: ctx.respond });

    expect(ctx.ack).toHaveBeenCalled();
    expect(ctx.respond).toHaveBeenCalled();
    const call = ctx.respond.mock.calls[0][0];
    expect(call.response_type).toBe('ephemeral');
    const text = JSON.stringify(call.blocks);
    expect(text).toContain('task-tracker');
    expect(text).toContain('expense-tracker');
  });

  it('shows empty message when no projects', async () => {
    const ctx = mockSlackContext();
    const registry = { version: 1, projects: [] };

    await handleList({ registry, ack: ctx.ack, respond: ctx.respond });

    const call = ctx.respond.mock.calls[0][0];
    const text = JSON.stringify(call.blocks);
    expect(text).toContain('No projects');
  });
});
```

- [ ] **Step 2: Run test to verify it fails**

Run: `cd scripts/factory-bot && npx vitest run __tests__/commands/list.test.ts`
Expected: FAIL — cannot find module '../../commands/list.js'

- [ ] **Step 3: Implement list.ts**

```typescript
// commands/list.ts
import type { Registry } from '../lib/state-reader.js';
import { formatProjectList } from '../lib/slack-fmt.js';

export interface ListArgs {
  registry: Registry;
  ack: () => Promise<void>;
  respond: (msg: Record<string, unknown>) => Promise<void>;
}

export async function handleList(args: ListArgs): Promise<void> {
  await args.ack();
  await args.respond({
    response_type: 'ephemeral',
    blocks: formatProjectList(args.registry),
  });
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `cd scripts/factory-bot && npx vitest run __tests__/commands/list.test.ts`
Expected: PASS — all 2 tests pass

- [ ] **Step 5: Commit**

```bash
git add scripts/factory-bot/commands/list.ts scripts/factory-bot/__tests__/commands/list.test.ts
git commit -m "feat(factory-bot): add /factory list command"
```

---

## Chunk 5: Action Commands (build, evolve, launch)

### Task 10: Build command

**Files:**
- Create: `scripts/factory-bot/commands/build.ts`
- Test: `scripts/factory-bot/__tests__/commands/build.test.ts`

- [ ] **Step 1: Write failing test for build command**

```typescript
// __tests__/commands/build.test.ts
import { describe, it, expect, vi } from 'vitest';
import { readFileSync } from 'node:fs';
import { join } from 'node:path';
import { handleBuild } from '../../commands/build.js';
import { parseRegistry } from '../../lib/state-reader.js';
import { ProcessManager } from '../../lib/process-mgr.js';

const fixturesDir = join(import.meta.dirname, '..', 'fixtures');
const readFixture = (name: string) => readFileSync(join(fixturesDir, name), 'utf-8');

function mockSlackContext() {
  return { ack: vi.fn(), respond: vi.fn(), say: vi.fn() };
}

describe('handleBuild', () => {
  it('rejects unknown project', async () => {
    const ctx = mockSlackContext();
    const registry = parseRegistry(readFixture('registry.json'));
    const mgr = new ProcessManager();

    await handleBuild({
      projectName: 'nonexistent',
      registry,
      processMgr: mgr,
      factoryRoot: '/tmp',
      channelId: 'C123',
      ack: ctx.ack,
      respond: ctx.respond,
      say: ctx.say,
      startWatcher: vi.fn(),
    });

    expect(ctx.respond).toHaveBeenCalled();
    const call = ctx.respond.mock.calls[0][0];
    expect(call.text).toContain('not found');
  });

  it('rejects if project already has active process', async () => {
    const ctx = mockSlackContext();
    const registry = parseRegistry(readFixture('registry.json'));
    const mgr = new ProcessManager();
    mgr.register({
      projectName: 'task-tracker', type: 'build', process: null as any,
      threadTs: '1', channelId: 'C1', startedAt: new Date(), stateFile: '/tmp',
    });

    await handleBuild({
      projectName: 'task-tracker',
      registry,
      processMgr: mgr,
      factoryRoot: '/tmp',
      channelId: 'C123',
      ack: ctx.ack,
      respond: ctx.respond,
      say: ctx.say,
      startWatcher: vi.fn(),
    });

    expect(ctx.respond).toHaveBeenCalled();
    const call = ctx.respond.mock.calls[0][0];
    expect(call.text).toContain('already');
  });
});
```

- [ ] **Step 2: Run test to verify it fails**

Run: `cd scripts/factory-bot && npx vitest run __tests__/commands/build.test.ts`
Expected: FAIL — cannot find module '../../commands/build.js'

- [ ] **Step 3: Implement build.ts**

```typescript
// commands/build.ts
import { join, resolve } from 'node:path';
import { resolveProject, type Registry } from '../lib/state-reader.js';
import { ProcessManager } from '../lib/process-mgr.js';

export interface BuildArgs {
  projectName: string;
  registry: Registry;
  processMgr: ProcessManager;
  factoryRoot: string;
  channelId: string;
  ack: () => Promise<void>;
  respond: (msg: Record<string, unknown>) => Promise<void>;
  say: (msg: Record<string, unknown>) => Promise<{ ts: string }>;
  startWatcher: (projectName: string, stateFile: string, threadTs: string, channelId: string) => void;
}

export async function handleBuild(args: BuildArgs): Promise<void> {
  await args.ack();

  const project = resolveProject(args.registry, args.projectName);
  if (!project) {
    const names = args.registry.projects.map((p) => p.name).join(', ');
    await args.respond({
      response_type: 'ephemeral',
      text: `Project "${args.projectName}" not found. Registered: ${names || 'none'}`,
    });
    return;
  }

  if (args.processMgr.isRunning(project.name)) {
    await args.respond({
      response_type: 'ephemeral',
      text: `Project "${project.name}" already has an active process running.`,
    });
    return;
  }

  const projectPath = resolve(args.factoryRoot, project.path);
  const stateFile = join(projectPath, 'plans', 'build-state.json');

  // Post parent message for thread
  const parentMsg = await args.say({
    text: `:hammer_and_wrench: Building *${project.name}*...`,
    channel: args.channelId,
  });

  const child = args.processMgr.spawnBuild(projectPath, args.factoryRoot);

  args.processMgr.register({
    projectName: project.name,
    type: 'build',
    process: child,
    threadTs: parentMsg.ts,
    channelId: args.channelId,
    startedAt: new Date(),
    stateFile,
  });

  // Start file watcher for progress updates
  args.startWatcher(project.name, stateFile, parentMsg.ts, args.channelId);

  // Handle process exit
  child.on('exit', (code) => {
    args.processMgr.remove(project.name);
    // Exit handling is done via state file watcher — it detects complete/failed status
  });
}
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `cd scripts/factory-bot && npx vitest run __tests__/commands/build.test.ts`
Expected: PASS — both tests pass

- [ ] **Step 5: Commit**

```bash
git add scripts/factory-bot/commands/build.ts scripts/factory-bot/__tests__/commands/build.test.ts
git commit -m "feat(factory-bot): add /factory build command with process spawning"
```

---

### Task 11: Evolve command

**Files:**
- Create: `scripts/factory-bot/commands/evolve.ts`
- Test: `scripts/factory-bot/__tests__/commands/evolve.test.ts`

- [ ] **Step 1: Write failing test for evolve command**

```typescript
// __tests__/commands/evolve.test.ts
import { describe, it, expect, vi } from 'vitest';
import { readFileSync } from 'node:fs';
import { join } from 'node:path';
import { handleEvolve } from '../../commands/evolve.js';
import { parseRegistry } from '../../lib/state-reader.js';
import { ProcessManager } from '../../lib/process-mgr.js';

const fixturesDir = join(import.meta.dirname, '..', 'fixtures');
const readFixture = (name: string) => readFileSync(join(fixturesDir, name), 'utf-8');

function mockSlackContext() {
  return { ack: vi.fn(), respond: vi.fn(), say: vi.fn() };
}

describe('handleEvolve', () => {
  it('rejects unknown project', async () => {
    const ctx = mockSlackContext();
    const registry = parseRegistry(readFixture('registry.json'));
    const mgr = new ProcessManager();

    await handleEvolve({
      projectName: 'nonexistent',
      registry,
      processMgr: mgr,
      factoryRoot: '/tmp',
      channelId: 'C123',
      ack: ctx.ack,
      respond: ctx.respond,
      say: ctx.say,
      startWatcher: vi.fn(),
    });

    expect(ctx.respond.mock.calls[0][0].text).toContain('not found');
  });

  it('rejects if project already running', async () => {
    const ctx = mockSlackContext();
    const registry = parseRegistry(readFixture('registry.json'));
    const mgr = new ProcessManager();
    mgr.register({
      projectName: 'task-tracker', type: 'evolve', process: null as any,
      threadTs: '1', channelId: 'C1', startedAt: new Date(), stateFile: '/tmp',
    });

    await handleEvolve({
      projectName: 'task-tracker',
      registry,
      processMgr: mgr,
      factoryRoot: '/tmp',
      channelId: 'C123',
      ack: ctx.ack,
      respond: ctx.respond,
      say: ctx.say,
      startWatcher: vi.fn(),
    });

    expect(ctx.respond.mock.calls[0][0].text).toContain('already');
  });
});
```

- [ ] **Step 2: Run test to verify it fails**

Run: `cd scripts/factory-bot && npx vitest run __tests__/commands/evolve.test.ts`
Expected: FAIL — cannot find module '../../commands/evolve.js'

- [ ] **Step 3: Implement evolve.ts**

```typescript
// commands/evolve.ts
import { join, resolve } from 'node:path';
import { resolveProject, type Registry } from '../lib/state-reader.js';
import { ProcessManager } from '../lib/process-mgr.js';

export interface EvolveArgs {
  projectName: string;
  registry: Registry;
  processMgr: ProcessManager;
  factoryRoot: string;
  channelId: string;
  ack: () => Promise<void>;
  respond: (msg: Record<string, unknown>) => Promise<void>;
  say: (msg: Record<string, unknown>) => Promise<{ ts: string }>;
  startWatcher: (projectName: string, stateFile: string, threadTs: string, channelId: string) => void;
}

export async function handleEvolve(args: EvolveArgs): Promise<void> {
  await args.ack();

  const project = resolveProject(args.registry, args.projectName);
  if (!project) {
    const names = args.registry.projects.map((p) => p.name).join(', ');
    await args.respond({
      response_type: 'ephemeral',
      text: `Project "${args.projectName}" not found. Registered: ${names || 'none'}`,
    });
    return;
  }

  if (args.processMgr.isRunning(project.name)) {
    await args.respond({
      response_type: 'ephemeral',
      text: `Project "${project.name}" already has an active process running.`,
    });
    return;
  }

  const projectPath = resolve(args.factoryRoot, project.path);
  const stateFile = join(projectPath, 'factory', 'evolution-state.json');

  const parentMsg = await args.say({
    text: `:dna: Evolving *${project.name}*...`,
    channel: args.channelId,
  });

  const child = args.processMgr.spawnEvolve(projectPath, args.factoryRoot);

  args.processMgr.register({
    projectName: project.name,
    type: 'evolve',
    process: child,
    threadTs: parentMsg.ts,
    channelId: args.channelId,
    startedAt: new Date(),
    stateFile,
  });

  args.startWatcher(project.name, stateFile, parentMsg.ts, args.channelId);

  child.on('exit', () => {
    args.processMgr.remove(project.name);
  });
}
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `cd scripts/factory-bot && npx vitest run __tests__/commands/evolve.test.ts`
Expected: PASS — both tests pass

- [ ] **Step 5: Commit**

```bash
git add scripts/factory-bot/commands/evolve.ts scripts/factory-bot/__tests__/commands/evolve.test.ts
git commit -m "feat(factory-bot): add /factory evolve command"
```

---

### Task 12: Launch command

**Files:**
- Create: `scripts/factory-bot/commands/launch.ts`
- Test: `scripts/factory-bot/__tests__/commands/launch.test.ts`

- [ ] **Step 1: Write failing test for launch command**

```typescript
// __tests__/commands/launch.test.ts
import { describe, it, expect, vi } from 'vitest';
import { handleLaunch } from '../../commands/launch.js';
import { ProcessManager } from '../../lib/process-mgr.js';

function mockSlackContext() {
  return { ack: vi.fn(), respond: vi.fn(), say: vi.fn() };
}

describe('handleLaunch', () => {
  it('rejects empty idea', async () => {
    const ctx = mockSlackContext();
    const mgr = new ProcessManager();

    await handleLaunch({
      idea: '',
      processMgr: mgr,
      factoryRoot: '/tmp',
      channelId: 'C123',
      ack: ctx.ack,
      respond: ctx.respond,
      say: ctx.say,
    });

    expect(ctx.respond.mock.calls[0][0].text).toContain('idea');
  });

  it('rejects if a launch is already running', async () => {
    const ctx = mockSlackContext();
    const mgr = new ProcessManager();
    mgr.register({
      projectName: '__launch__', type: 'launch', process: null as any,
      threadTs: '1', channelId: 'C1', startedAt: new Date(), stateFile: '',
    });

    await handleLaunch({
      idea: 'task tracker app',
      processMgr: mgr,
      factoryRoot: '/tmp',
      channelId: 'C123',
      ack: ctx.ack,
      respond: ctx.respond,
      say: ctx.say,
    });

    expect(ctx.respond.mock.calls[0][0].text).toContain('already');
  });
});
```

- [ ] **Step 2: Run test to verify it fails**

Run: `cd scripts/factory-bot && npx vitest run __tests__/commands/launch.test.ts`
Expected: FAIL — cannot find module '../../commands/launch.js'

- [ ] **Step 3: Implement launch.ts**

The launch command is special — no state file. It streams stdout to a Slack thread, batched every 5 seconds.

```typescript
// commands/launch.ts
import { ProcessManager } from '../lib/process-mgr.js';

const LAUNCH_PROJECT_NAME = '__launch__';
const BATCH_INTERVAL_MS = 5000;

export interface LaunchArgs {
  idea: string;
  processMgr: ProcessManager;
  factoryRoot: string;
  channelId: string;
  ack: () => Promise<void>;
  respond: (msg: Record<string, unknown>) => Promise<void>;
  say: (msg: Record<string, unknown>) => Promise<{ ts: string }>;
}

export async function handleLaunch(args: LaunchArgs): Promise<void> {
  await args.ack();

  if (!args.idea.trim()) {
    await args.respond({
      response_type: 'ephemeral',
      text: 'Usage: `/factory launch <idea>` — provide an idea for the app.',
    });
    return;
  }

  if (args.processMgr.isRunning(LAUNCH_PROJECT_NAME)) {
    await args.respond({
      response_type: 'ephemeral',
      text: 'A launch is already in progress. Wait for it to complete.',
    });
    return;
  }

  const parentMsg = await args.say({
    text: `:rocket: Launching: *${args.idea}*`,
    channel: args.channelId,
  });

  const child = args.processMgr.spawnLaunch(args.idea, args.factoryRoot);

  args.processMgr.register({
    projectName: LAUNCH_PROJECT_NAME,
    type: 'launch',
    process: child,
    threadTs: parentMsg.ts,
    channelId: args.channelId,
    startedAt: new Date(),
    stateFile: '', // No state file for launch
  });

  // Batch stdout into periodic thread updates
  let buffer = '';
  let batchTimer: ReturnType<typeof setInterval> | null = null;

  const flushBuffer = async () => {
    if (!buffer.trim()) return;
    const chunk = buffer.slice(-3000); // Last 3000 chars to stay under Slack limits
    buffer = '';
    try {
      await args.say({
        text: `\`\`\`${chunk}\`\`\``,
        thread_ts: parentMsg.ts,
        channel: args.channelId,
      });
    } catch {
      // Slack rate limit — will catch up on next flush
    }
  };

  child.stdout?.on('data', (data: Buffer) => {
    buffer += data.toString();
  });

  child.stderr?.on('data', (data: Buffer) => {
    buffer += data.toString();
  });

  batchTimer = setInterval(flushBuffer, BATCH_INTERVAL_MS);

  child.on('exit', async (code) => {
    if (batchTimer) clearInterval(batchTimer);
    await flushBuffer(); // Final flush

    args.processMgr.remove(LAUNCH_PROJECT_NAME);

    if (code === 0) {
      await args.say({
        text: `:white_check_mark: Launch complete! Run \`/factory list\` to see the new project.`,
        thread_ts: parentMsg.ts,
        channel: args.channelId,
      });
    } else {
      await args.say({
        text: `:x: Launch failed (exit code ${code}).`,
        thread_ts: parentMsg.ts,
        channel: args.channelId,
      });
    }
  });
}
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `cd scripts/factory-bot && npx vitest run __tests__/commands/launch.test.ts`
Expected: PASS — both tests pass

- [ ] **Step 5: Commit**

```bash
git add scripts/factory-bot/commands/launch.ts scripts/factory-bot/__tests__/commands/launch.test.ts
git commit -m "feat(factory-bot): add /factory launch command with stdout streaming"
```

---

## Chunk 6: Gate Commands (approve, reject) + Button Handlers

### Task 13: Approve command (button handler)

**Files:**
- Create: `scripts/factory-bot/commands/approve.ts`
- Test: `scripts/factory-bot/__tests__/commands/approve.test.ts`

- [ ] **Step 1: Write failing test for approve handler**

```typescript
// __tests__/commands/approve.test.ts
import { describe, it, expect, vi, afterEach } from 'vitest';
import { writeFileSync, unlinkSync, mkdtempSync, readFileSync } from 'node:fs';
import { join } from 'node:path';
import { tmpdir } from 'node:os';
import { handleApprove } from '../../commands/approve.js';
import { ProcessManager } from '../../lib/process-mgr.js';

describe('handleApprove', () => {
  let tempDir: string;
  let stateFile: string;

  afterEach(() => {
    try { unlinkSync(stateFile); } catch {}
  });

  it('writes approved status to evolution state file', async () => {
    tempDir = mkdtempSync(join(tmpdir(), 'approve-'));
    stateFile = join(tempDir, 'evolution-state.json');
    writeFileSync(stateFile, JSON.stringify({
      version: 1, project: 'test', status: 'preview_deployed',
      current_cycle: 0, total_cycles_completed: 0,
      deploy_target: { platform: 'vercel', production_branch: 'main' },
      baseline: { evaluation_ref: '', composite_score: 50 },
      cycles: [], rejected_hypotheses: [],
    }));

    const ack = vi.fn();
    const update = vi.fn();
    const mgr = new ProcessManager();

    await handleApprove({
      projectName: 'test',
      stateFilePath: stateFile,
      processMgr: mgr,
      factoryRoot: '/tmp',
      userId: 'U123',
      userName: 'testuser',
      ack,
      updateMessage: update,
      spawnEvolveRunner: vi.fn(),
    });

    expect(ack).toHaveBeenCalled();
    const state = JSON.parse(readFileSync(stateFile, 'utf-8'));
    expect(state.status).toBe('approved');
  });

  it('updates Slack message to show approval', async () => {
    tempDir = mkdtempSync(join(tmpdir(), 'approve-'));
    stateFile = join(tempDir, 'evolution-state.json');
    writeFileSync(stateFile, JSON.stringify({
      version: 1, project: 'test', status: 'preview_deployed',
      current_cycle: 0, total_cycles_completed: 0,
      deploy_target: { platform: 'vercel', production_branch: 'main' },
      baseline: { evaluation_ref: '', composite_score: 50 },
      cycles: [], rejected_hypotheses: [],
    }));

    const ack = vi.fn();
    const update = vi.fn();
    const mgr = new ProcessManager();

    await handleApprove({
      projectName: 'test',
      stateFilePath: stateFile,
      processMgr: mgr,
      factoryRoot: '/tmp',
      userId: 'U123',
      userName: 'testuser',
      ack,
      updateMessage: update,
      spawnEvolveRunner: vi.fn(),
    });

    expect(update).toHaveBeenCalled();
    const updateCall = update.mock.calls[0][0];
    expect(updateCall.text).toContain('Approved');
    expect(updateCall.text).toContain('testuser');
  });

  it('spawns fresh evolution runner after approval', async () => {
    tempDir = mkdtempSync(join(tmpdir(), 'approve-'));
    stateFile = join(tempDir, 'evolution-state.json');
    writeFileSync(stateFile, JSON.stringify({
      version: 1, project: 'test', status: 'preview_deployed',
      current_cycle: 0, total_cycles_completed: 0,
      deploy_target: { platform: 'vercel', production_branch: 'main' },
      baseline: { evaluation_ref: '', composite_score: 50 },
      cycles: [], rejected_hypotheses: [],
    }));

    const spawnEvolveRunner = vi.fn();

    await handleApprove({
      projectName: 'test',
      stateFilePath: stateFile,
      processMgr: new ProcessManager(),
      factoryRoot: '/tmp',
      userId: 'U123',
      userName: 'testuser',
      ack: vi.fn(),
      updateMessage: vi.fn(),
      spawnEvolveRunner,
    });

    expect(spawnEvolveRunner).toHaveBeenCalledWith('test');
  });
});
```

- [ ] **Step 2: Run test to verify it fails**

Run: `cd scripts/factory-bot && npx vitest run __tests__/commands/approve.test.ts`
Expected: FAIL — cannot find module '../../commands/approve.js'

- [ ] **Step 3: Implement approve.ts**

```typescript
// commands/approve.ts
import { readFileSync, writeFileSync } from 'node:fs';
import { ProcessManager } from '../lib/process-mgr.js';

export interface ApproveArgs {
  projectName: string;
  stateFilePath: string;
  processMgr: ProcessManager;
  factoryRoot: string;
  userId: string;
  userName: string;
  ack: () => Promise<void>;
  updateMessage: (msg: Record<string, unknown>) => Promise<void>;
  spawnEvolveRunner: (projectName: string) => void | Promise<void>;
}

export async function handleApprove(args: ApproveArgs): Promise<void> {
  await args.ack();

  // Double-click prevention: update message first to remove buttons
  await args.updateMessage({
    text: `:white_check_mark: Approved by <@${args.userId}> (${args.userName}). Continuing evolution...`,
    blocks: [], // Remove all blocks (including buttons)
  });

  // Mutate state file: set status to approved
  const raw = readFileSync(args.stateFilePath, 'utf-8');
  const state = JSON.parse(raw);
  state.status = 'approved';
  writeFileSync(args.stateFilePath, JSON.stringify(state, null, 2));

  // Spawn fresh evolution runner
  args.spawnEvolveRunner(args.projectName);
}
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `cd scripts/factory-bot && npx vitest run __tests__/commands/approve.test.ts`
Expected: PASS — all 3 tests pass

- [ ] **Step 5: Commit**

```bash
git add scripts/factory-bot/commands/approve.ts scripts/factory-bot/__tests__/commands/approve.test.ts
git commit -m "feat(factory-bot): add gate approve handler with state mutation and runner spawn"
```

---

### Task 14: Reject command (button handler)

**Files:**
- Create: `scripts/factory-bot/commands/reject.ts`
- Test: `scripts/factory-bot/__tests__/commands/reject.test.ts`

- [ ] **Step 1: Write failing test for reject handler**

```typescript
// __tests__/commands/reject.test.ts
import { describe, it, expect, vi, afterEach } from 'vitest';
import { writeFileSync, unlinkSync, mkdtempSync, readFileSync } from 'node:fs';
import { join } from 'node:path';
import { tmpdir } from 'node:os';
import { handleReject } from '../../commands/reject.js';
import { ProcessManager } from '../../lib/process-mgr.js';

describe('handleReject', () => {
  let tempDir: string;
  let stateFile: string;

  afterEach(() => {
    try { unlinkSync(stateFile); } catch {}
  });

  it('writes rejected status to evolution state file', async () => {
    tempDir = mkdtempSync(join(tmpdir(), 'reject-'));
    stateFile = join(tempDir, 'evolution-state.json');
    writeFileSync(stateFile, JSON.stringify({
      version: 1, project: 'test', status: 'preview_deployed',
      current_cycle: 0, total_cycles_completed: 0,
      deploy_target: { platform: 'vercel', production_branch: 'main' },
      baseline: { evaluation_ref: '', composite_score: 50 },
      cycles: [], rejected_hypotheses: [],
    }));

    await handleReject({
      projectName: 'test',
      stateFilePath: stateFile,
      processMgr: new ProcessManager(),
      factoryRoot: '/tmp',
      userId: 'U123',
      userName: 'testuser',
      ack: vi.fn(),
      updateMessage: vi.fn(),
      spawnEvolveRunner: vi.fn(),
    });

    const state = JSON.parse(readFileSync(stateFile, 'utf-8'));
    expect(state.status).toBe('rejected');
  });

  it('updates Slack message to show rejection', async () => {
    tempDir = mkdtempSync(join(tmpdir(), 'reject-'));
    stateFile = join(tempDir, 'evolution-state.json');
    writeFileSync(stateFile, JSON.stringify({
      version: 1, project: 'test', status: 'preview_deployed',
      current_cycle: 0, total_cycles_completed: 0,
      deploy_target: { platform: 'vercel', production_branch: 'main' },
      baseline: { evaluation_ref: '', composite_score: 50 },
      cycles: [], rejected_hypotheses: [],
    }));

    const update = vi.fn();

    await handleReject({
      projectName: 'test',
      stateFilePath: stateFile,
      processMgr: new ProcessManager(),
      factoryRoot: '/tmp',
      userId: 'U123',
      userName: 'testuser',
      ack: vi.fn(),
      updateMessage: update,
      spawnEvolveRunner: vi.fn(),
    });

    expect(update.mock.calls[0][0].text).toContain('Rejected');
  });

  it('spawns fresh evolution runner after rejection', async () => {
    tempDir = mkdtempSync(join(tmpdir(), 'reject-'));
    stateFile = join(tempDir, 'evolution-state.json');
    writeFileSync(stateFile, JSON.stringify({
      version: 1, project: 'test', status: 'preview_deployed',
      current_cycle: 0, total_cycles_completed: 0,
      deploy_target: { platform: 'vercel', production_branch: 'main' },
      baseline: { evaluation_ref: '', composite_score: 50 },
      cycles: [], rejected_hypotheses: [],
    }));

    const spawnEvolveRunner = vi.fn();

    await handleReject({
      projectName: 'test',
      stateFilePath: stateFile,
      processMgr: new ProcessManager(),
      factoryRoot: '/tmp',
      userId: 'U123',
      userName: 'testuser',
      ack: vi.fn(),
      updateMessage: vi.fn(),
      spawnEvolveRunner,
    });

    expect(spawnEvolveRunner).toHaveBeenCalledWith('test');
  });
});
```

- [ ] **Step 2: Run test to verify it fails**

Run: `cd scripts/factory-bot && npx vitest run __tests__/commands/reject.test.ts`
Expected: FAIL — cannot find module '../../commands/reject.js'

- [ ] **Step 3: Implement reject.ts**

```typescript
// commands/reject.ts
import { readFileSync, writeFileSync } from 'node:fs';
import { ProcessManager } from '../lib/process-mgr.js';

export interface RejectArgs {
  projectName: string;
  stateFilePath: string;
  processMgr: ProcessManager;
  factoryRoot: string;
  userId: string;
  userName: string;
  ack: () => Promise<void>;
  updateMessage: (msg: Record<string, unknown>) => Promise<void>;
  spawnEvolveRunner: (projectName: string) => void | Promise<void>;
}

export async function handleReject(args: RejectArgs): Promise<void> {
  await args.ack();

  // Double-click prevention: update message first to remove buttons
  await args.updateMessage({
    text: `:x: Rejected by <@${args.userId}> (${args.userName}). Generating new hypotheses...`,
    blocks: [],
  });

  // Mutate state file: set status to rejected
  const raw = readFileSync(args.stateFilePath, 'utf-8');
  const state = JSON.parse(raw);
  state.status = 'rejected';
  writeFileSync(args.stateFilePath, JSON.stringify(state, null, 2));

  // Spawn fresh evolution runner (will pick up rejected status → generate-hypotheses)
  args.spawnEvolveRunner(args.projectName);
}
```

- [ ] **Step 4: Run tests to verify they pass**

Run: `cd scripts/factory-bot && npx vitest run __tests__/commands/reject.test.ts`
Expected: PASS — all 3 tests pass

- [ ] **Step 5: Commit**

```bash
git add scripts/factory-bot/commands/reject.ts scripts/factory-bot/__tests__/commands/reject.test.ts
git commit -m "feat(factory-bot): add gate reject handler with state mutation"
```

---

## Chunk 7: Main App (index.ts) + Integration

### Task 15: Main Bolt app

**Files:**
- Create: `scripts/factory-bot/index.ts`

- [ ] **Step 1: Implement index.ts — Bolt app with slash command routing and button handlers**

```typescript
// index.ts
import { App } from '@slack/bolt';
import { readFileSync, existsSync } from 'node:fs';
import { join, resolve } from 'node:path';
import { loadConfig } from './config.js';
import { ProcessManager } from './lib/process-mgr.js';
import { StateFileWatcher } from './lib/file-watcher.js';
import {
  parseRegistry,
  parseBuildState,
  parseEvolutionState,
  readJsonFile,
  type Registry,
  type BuildState,
  type EvolutionState,
} from './lib/state-reader.js';
import {
  formatBuildStatus,
  formatEvolutionStatus,
  formatGateMessage,
  formatTaskUpdate,
  formatStageStart,
  formatBuildComplete,
  formatBuildFailed,
} from './lib/slack-fmt.js';
import { handleStatus } from './commands/status.js';
import { handleList } from './commands/list.js';
import { handleBuild } from './commands/build.js';
import { handleEvolve } from './commands/evolve.js';
import { handleLaunch } from './commands/launch.js';
import { handleApprove } from './commands/approve.js';
import { handleReject } from './commands/reject.js';

const config = loadConfig();
const processMgr = new ProcessManager();
const watchers = new Map<string, StateFileWatcher>();

const app = new App({
  token: config.slackBotToken,
  appToken: config.slackAppToken,
  socketMode: true,
  signingSecret: config.signingSecret || undefined,
});

// --- Helpers ---

function registryPath(): string {
  return join(config.factoryRoot, 'factory', 'registry.json');
}

function loadRegistry(): Registry {
  return readJsonFile<Registry>(registryPath()) ?? { version: 1, projects: [] };
}

function readStateFile(path: string): string | null {
  try {
    return readFileSync(path, 'utf-8');
  } catch {
    return null;
  }
}

function startBuildWatcher(
  projectName: string,
  stateFile: string,
  threadTs: string,
  channelId: string,
): void {
  const watcher = new StateFileWatcher(stateFile);
  let lastSnapshot: string | null = null;

  watcher.onChange = async (content: string) => {
    try {
      const state = parseBuildState(content);
      const prev = lastSnapshot ? parseBuildState(lastSnapshot) : null;
      lastSnapshot = content;

      // Detect stage starts (including stage 0 on first snapshot)
      const stageChanged = prev === null || state.current_stage !== prev.current_stage;
      if (stageChanged) {
        const stage = state.stages[state.current_stage];
        if (stage) {
          const taskCount = Object.keys(stage.tasks).length;
          await app.client.chat.postMessage({
            token: config.slackBotToken,
            channel: channelId,
            thread_ts: threadTs,
            text: formatStageStart(stage.stage, stage.title, taskCount),
          });
        }
      }

      // Detect task completions
      for (const stage of state.stages) {
        const prevStage = prev?.stages.find((s) => s.stage === stage.stage);
        for (const [taskId, taskStatus] of Object.entries(stage.tasks)) {
          const prevStatus = prevStage?.tasks[taskId];
          if (taskStatus !== prevStatus && taskStatus === 'complete') {
            await app.client.chat.postMessage({
              token: config.slackBotToken,
              channel: channelId,
              thread_ts: threadTs,
              text: formatTaskUpdate(taskId, stage.title, 'complete'),
            });
          }
        }
      }

      // Update parent message with current status
      const stageInfo = state.stages[state.current_stage];
      const doneTasks = stageInfo
        ? Object.values(stageInfo.tasks).filter((s) => s === 'complete').length
        : 0;
      const totalTasks = stageInfo ? Object.keys(stageInfo.tasks).length : 0;
      await app.client.chat.update({
        token: config.slackBotToken,
        channel: channelId,
        ts: threadTs,
        text: `:hammer_and_wrench: Building *${state.project}* — Stage ${state.current_stage}/${state.total_stages} (${doneTasks}/${totalTasks} tasks)`,
      });

      // Handle completion
      if (state.status === 'complete') {
        watcher.stop();
        watchers.delete(projectName);
        await app.client.chat.postMessage({
          token: config.slackBotToken,
          channel: channelId,
          thread_ts: threadTs,
          text: '', // Blocks used instead
          blocks: formatBuildComplete(state.project, state.total_stages, state.iteration_count),
        });
      }

      // Handle failure
      if (state.status === 'failed') {
        watcher.stop();
        watchers.delete(projectName);
        const failedStage = state.stages.find((s) => s.status === 'failed');
        const error = failedStage?.error ?? 'Unknown error';
        await app.client.chat.postMessage({
          token: config.slackBotToken,
          channel: channelId,
          thread_ts: threadTs,
          text: '', // Blocks used instead
          blocks: formatBuildFailed(state.project, error),
        });
      }
    } catch (err) {
      console.error(`[watcher:${projectName}] Error processing state change:`, err);
    }
  };

  watcher.start();
  watchers.set(projectName, watcher);
}

function startEvolveWatcher(
  projectName: string,
  stateFile: string,
  threadTs: string,
  channelId: string,
): void {
  const watcher = new StateFileWatcher(stateFile);
  let lastStatus: string | null = null;

  watcher.onChange = async (content: string) => {
    try {
      const state = parseEvolutionState(content);

      if (state.status !== lastStatus) {
        lastStatus = state.status;

        // Post status change to thread
        await app.client.chat.postMessage({
          token: config.slackBotToken,
          channel: channelId,
          thread_ts: threadTs,
          text: `:gear: Evolution status: *${state.status}* (Cycle ${state.current_cycle})`,
        });

        // Update parent message
        await app.client.chat.update({
          token: config.slackBotToken,
          channel: channelId,
          ts: threadTs,
          text: `:dna: Evolving *${state.project}* — ${state.status} (Cycle ${state.current_cycle})`,
        });

        // Human gate reached — post approve/reject buttons
        if (state.status === 'preview_deployed' || state.status === 'awaiting_approval') {
          watcher.stop();
          watchers.delete(projectName);

          const cycle = state.cycles[state.current_cycle];
          const previewUrl = cycle?.preview_url ?? '(no preview URL)';
          const score = cycle?.evaluation_score ?? state.baseline.composite_score;

          await app.client.chat.postMessage({
            token: config.slackBotToken,
            channel: channelId,
            thread_ts: threadTs,
            text: '', // Blocks used instead
            blocks: formatGateMessage(
              state.project,
              previewUrl,
              score,
              state.baseline.composite_score,
            ),
          });
        }
      }
    } catch (err) {
      console.error(`[watcher:${projectName}] Error processing evolution state:`, err);
    }
  };

  watcher.start();
  watchers.set(projectName, watcher);
}

// --- Slash Command ---

app.command('/factory', async ({ command, ack, respond, say }) => {
  const text = command.text.trim();
  const parts = text.split(/\s+/);
  const subcommand = parts[0]?.toLowerCase() ?? '';
  const arg = parts.slice(1).join(' ');

  switch (subcommand) {
    case 'launch':
      await handleLaunch({
        idea: arg,
        processMgr,
        factoryRoot: config.factoryRoot,
        channelId: command.channel_id,
        ack,
        respond,
        say,
      });
      break;

    case 'build':
      await handleBuild({
        projectName: arg,
        registry: loadRegistry(),
        processMgr,
        factoryRoot: config.factoryRoot,
        channelId: command.channel_id,
        ack,
        respond,
        say,
        startWatcher: (name, sf, ts, ch) => startBuildWatcher(name, sf, ts, ch),
      });
      break;

    case 'evolve':
      await handleEvolve({
        projectName: arg,
        registry: loadRegistry(),
        processMgr,
        factoryRoot: config.factoryRoot,
        channelId: command.channel_id,
        ack,
        respond,
        say,
        startWatcher: (name, sf, ts, ch) => startEvolveWatcher(name, sf, ts, ch),
      });
      break;

    case 'status': {
      const registry = loadRegistry();
      const project = arg
        ? registry.projects.find((p) => p.name.toLowerCase() === arg.toLowerCase())
        : null;
      const projectPath = project ? resolve(config.factoryRoot, project.path) : '';

      await handleStatus({
        projectName: arg || '',
        registry,
        buildStateJson: projectPath
          ? readStateFile(join(projectPath, 'plans', 'build-state.json'))
          : null,
        evolutionStateJson: projectPath
          ? readStateFile(join(projectPath, 'factory', 'evolution-state.json'))
          : null,
        ack,
        respond,
      });
      break;
    }

    case 'list':
      await handleList({ registry: loadRegistry(), ack, respond });
      break;

    default:
      await ack();
      await respond({
        response_type: 'ephemeral',
        text: `Unknown subcommand: \`${subcommand}\`\n\nUsage:\n• \`/factory launch <idea>\`\n• \`/factory build <project>\`\n• \`/factory evolve <project>\`\n• \`/factory status [project]\`\n• \`/factory list\``,
      });
  }
});

// --- Button Handlers ---

// Gate approve
app.action(/^gate_approve:(.+)$/, async ({ action, ack, body, client }) => {
  const projectName = (action as any).action_id.split(':')[1];
  const registry = loadRegistry();
  const project = registry.projects.find(
    (p) => p.name.toLowerCase() === projectName.toLowerCase(),
  );
  if (!project) {
    await ack();
    return;
  }

  const projectPath = resolve(config.factoryRoot, project.path);
  const stateFile = join(projectPath, 'factory', 'evolution-state.json');

  await handleApprove({
    projectName: project.name,
    stateFilePath: stateFile,
    processMgr,
    factoryRoot: config.factoryRoot,
    userId: body.user.id,
    userName: body.user.name ?? body.user.id,
    ack,
    updateMessage: async (msg) => {
      await client.chat.update({
        token: config.slackBotToken,
        channel: (body as any).channel?.id ?? config.slackChannel,
        ts: (body as any).message?.ts ?? '',
        ...msg,
      });
    },
    spawnEvolveRunner: async (name) => {
      const channelId = (body as any).channel?.id ?? config.slackChannel;
      const projectPath = resolve(config.factoryRoot, project.path);
      const evoStateFile = join(projectPath, 'factory', 'evolution-state.json');

      // Post parent message first, then spawn — register synchronously before spawn
      const parentMsg = await app.client.chat.postMessage({
        token: config.slackBotToken,
        channel: channelId,
        text: `:dna: Continuing evolution for *${name}*...`,
      });

      const child = processMgr.spawnEvolve(projectPath, config.factoryRoot);

      processMgr.register({
        projectName: name,
        type: 'evolve',
        process: child,
        threadTs: parentMsg.ts!,
        channelId,
        startedAt: new Date(),
        stateFile: evoStateFile,
      });

      startEvolveWatcher(name, evoStateFile, parentMsg.ts!, channelId);
      child.on('exit', () => processMgr.remove(name));
    },
  });
});

// Gate reject
app.action(/^gate_reject:(.+)$/, async ({ action, ack, body, client }) => {
  const projectName = (action as any).action_id.split(':')[1];
  const registry = loadRegistry();
  const project = registry.projects.find(
    (p) => p.name.toLowerCase() === projectName.toLowerCase(),
  );
  if (!project) {
    await ack();
    return;
  }

  const projectPath = resolve(config.factoryRoot, project.path);
  const stateFile = join(projectPath, 'factory', 'evolution-state.json');

  await handleReject({
    projectName: project.name,
    stateFilePath: stateFile,
    processMgr,
    factoryRoot: config.factoryRoot,
    userId: body.user.id,
    userName: body.user.name ?? body.user.id,
    ack,
    updateMessage: async (msg) => {
      await client.chat.update({
        token: config.slackBotToken,
        channel: (body as any).channel?.id ?? config.slackChannel,
        ts: (body as any).message?.ts ?? '',
        ...msg,
      });
    },
    spawnEvolveRunner: async (name) => {
      const channelId = (body as any).channel?.id ?? config.slackChannel;
      const projectPath = resolve(config.factoryRoot, project.path);
      const evoStateFile = join(projectPath, 'factory', 'evolution-state.json');

      const parentMsg = await app.client.chat.postMessage({
        token: config.slackBotToken,
        channel: channelId,
        text: `:dna: Re-evolving *${name}* with new hypotheses...`,
      });

      const child = processMgr.spawnEvolve(projectPath, config.factoryRoot);

      processMgr.register({
        projectName: name,
        type: 'evolve',
        process: child,
        threadTs: parentMsg.ts!,
        channelId,
        startedAt: new Date(),
        stateFile: evoStateFile,
      });

      startEvolveWatcher(name, evoStateFile, parentMsg.ts!, channelId);
      child.on('exit', () => processMgr.remove(name));
    },
  });
});

// Resume build button
app.action(/^resume_build:(.+)$/, async ({ action, ack, body, say }) => {
  const projectName = (action as any).action_id.split(':')[1];
  await ack();

  const registry = loadRegistry();
  await handleBuild({
    projectName,
    registry,
    processMgr,
    factoryRoot: config.factoryRoot,
    channelId: (body as any).channel?.id ?? config.slackChannel,
    ack: async () => {},
    respond: async () => {},
    say,
    startWatcher: (name, sf, ts, ch) => startBuildWatcher(name, sf, ts, ch),
  });
});

// Start evolution button
app.action(/^start_evolve:(.+)$/, async ({ action, ack, body, say }) => {
  const projectName = (action as any).action_id.split(':')[1];
  await ack();

  const registry = loadRegistry();
  await handleEvolve({
    projectName,
    registry,
    processMgr,
    factoryRoot: config.factoryRoot,
    channelId: (body as any).channel?.id ?? config.slackChannel,
    ack: async () => {},
    respond: async () => {},
    say,
    startWatcher: (name, sf, ts, ch) => startEvolveWatcher(name, sf, ts, ch),
  });
});

// View error button
app.action(/^view_error:(.+)$/, async ({ action, ack, body, say }) => {
  const projectName = (action as any).action_id.split(':')[1];
  await ack();

  const registry = loadRegistry();
  const project = registry.projects.find(
    (p) => p.name.toLowerCase() === projectName.toLowerCase(),
  );
  if (!project) return;

  const projectPath = resolve(config.factoryRoot, project.path);
  const stateJson = readStateFile(join(projectPath, 'plans', 'build-state.json'));
  if (!stateJson) {
    await say({
      text: `No build state found for *${projectName}*.`,
      thread_ts: (body as any).message?.ts,
      channel: (body as any).channel?.id ?? config.slackChannel,
    });
    return;
  }

  const state = parseBuildState(stateJson);
  const failedStage = state.stages.find((s) => s.status === 'failed');
  const error = failedStage?.error ?? 'No error details available';

  await say({
    text: `:mag: *${projectName}* error details:\n\`\`\`${error}\`\`\``,
    thread_ts: (body as any).message?.ts,
    channel: (body as any).channel?.id ?? config.slackChannel,
  });
});

// --- Startup ---

async function startup(): Promise<void> {
  await app.start();
  console.log('CodeForge bot is running (Socket Mode)');

  // Scan for in-progress projects and post catch-up
  const registry = loadRegistry();
  for (const project of registry.projects) {
    if (project.status === 'building' || project.status === 'evolving') {
      try {
        await app.client.chat.postMessage({
          token: config.slackBotToken,
          channel: config.slackChannel,
          text: `:warning: Bot restarted. *${project.name}* was ${project.status} — run \`/factory ${project.status === 'building' ? 'build' : 'evolve'} ${project.name}\` to resume.`,
        });
      } catch (err) {
        console.error(`Failed to post catch-up for ${project.name}:`, err);
      }
    }
  }
}

startup();
```

- [ ] **Step 2: Verify TypeScript compiles**

Run: `cd scripts/factory-bot && npx tsc --noEmit`
Expected: No errors

- [ ] **Step 3: Commit**

```bash
git add scripts/factory-bot/index.ts
git commit -m "feat(factory-bot): add main Bolt app with command routing, button handlers, and startup"
```

---

### Task 16: Integration smoke test

**Files:**
- Create: `scripts/factory-bot/__tests__/integration.test.ts`

- [ ] **Step 1: Write integration test that verifies the full command parsing flow**

```typescript
// __tests__/integration.test.ts
import { describe, it, expect } from 'vitest';

// Integration tests verify module wiring — that all exports resolve
// and types are compatible. Full E2E requires a running Slack app.

describe('module integration', () => {
  it('all command modules export their handler', async () => {
    const { handleStatus } = await import('../commands/status.js');
    const { handleList } = await import('../commands/list.js');
    const { handleBuild } = await import('../commands/build.js');
    const { handleEvolve } = await import('../commands/evolve.js');
    const { handleLaunch } = await import('../commands/launch.js');
    const { handleApprove } = await import('../commands/approve.js');
    const { handleReject } = await import('../commands/reject.js');

    expect(typeof handleStatus).toBe('function');
    expect(typeof handleList).toBe('function');
    expect(typeof handleBuild).toBe('function');
    expect(typeof handleEvolve).toBe('function');
    expect(typeof handleLaunch).toBe('function');
    expect(typeof handleApprove).toBe('function');
    expect(typeof handleReject).toBe('function');
  });

  it('all lib modules export their interfaces', async () => {
    const { parseBuildState, parseEvolutionState, parseRegistry, resolveProject } =
      await import('../lib/state-reader.js');
    const { ProcessManager } = await import('../lib/process-mgr.js');
    const { StateFileWatcher } = await import('../lib/file-watcher.js');
    const { formatBuildStatus, formatProjectList, formatGateMessage } =
      await import('../lib/slack-fmt.js');

    expect(typeof parseBuildState).toBe('function');
    expect(typeof parseEvolutionState).toBe('function');
    expect(typeof parseRegistry).toBe('function');
    expect(typeof resolveProject).toBe('function');
    expect(typeof ProcessManager).toBe('function');
    expect(typeof StateFileWatcher).toBe('function');
    expect(typeof formatBuildStatus).toBe('function');
    expect(typeof formatProjectList).toBe('function');
    expect(typeof formatGateMessage).toBe('function');
  });

  it('config module exports loadConfig', async () => {
    const { loadConfig } = await import('../config.js');
    expect(typeof loadConfig).toBe('function');
  });
});
```

- [ ] **Step 2: Run all tests**

Run: `cd scripts/factory-bot && npx vitest run`
Expected: All tests pass

- [ ] **Step 3: Commit**

```bash
git add scripts/factory-bot/__tests__/integration.test.ts
git commit -m "test(factory-bot): add integration smoke test for all modules"
```

---

### Task 17: Final verification

- [ ] **Step 1: Run full test suite**

Run: `cd scripts/factory-bot && npx vitest run`
Expected: All tests pass

- [ ] **Step 2: TypeScript strict compilation check**

Run: `cd scripts/factory-bot && npx tsc --noEmit`
Expected: No errors

- [ ] **Step 3: Verify .gitignore excludes node_modules and dist**

Run: `cd scripts/factory-bot && cat .gitignore`
Expected: Contains `node_modules/`, `dist/`, `.env`

- [ ] **Step 4: Final commit if any adjustments were needed**

Only if fixes were required during verification.
