# Stage Library: Desktop App (Electron)

> **Reference material for the project-planner agent.**
> Use this file when generating stage plans for Electron desktop applications.
> Each stage below maps to one `stage-plan.md` file. Adapt stage count and task depth to the project scope.

---

## Archetype Overview

Electron apps split across two processes: a **main process** (Node.js, full OS access) and one or more **renderer processes** (Chromium, UI). The IPC bridge connecting them is the critical architectural seam. Build order must respect this split — you cannot wire the renderer to APIs that don't exist in the main process yet.

Typical tech stack: Electron + Vite + React/Svelte + TypeScript + electron-builder.

---

## Typical Stage Progression

### Stage 1: Foundation

**Goal:** Runnable Electron app with correct process separation and tooling.

Key deliverables:
- `package.json` with Electron, Vite, and TypeScript configured
- Main process entry (`src/main/index.ts`) that creates a BrowserWindow
- Preload script stub (`src/preload/index.ts`)
- Renderer entry (`src/renderer/index.tsx`) rendering a placeholder
- Dev mode with hot reload (`electron-vite` or equivalent)
- `.gitignore`, `tsconfig` for each process, ESLint

Typical tasks:
- Initialize project and install dependencies
- Configure Vite for main/preload/renderer targets
- Create BrowserWindow with secure defaults (contextIsolation, nodeIntegration: false)
- Set up TypeScript path aliases
- Verify dev server starts and window opens

Recommended agents:
- Lead: `feature-builder` (Sonnet) — project scaffold
- Support: `code-reviewer` (Haiku) — tsconfig and security defaults

---

### Stage 2: Main Process

**Goal:** All main-process business logic implemented and testable in isolation.

Key deliverables:
- App lifecycle management (ready, window-all-closed, activate)
- Window manager (create, restore, remember bounds across restarts)
- AppData path helpers for config/data storage
- Logging setup (electron-log or equivalent)
- Dev tools toggle

Typical tasks:
- Implement window state persistence (size, position)
- Set up app paths and ensure directories exist
- Configure logger with file and console transports
- Handle macOS dock behavior
- Write unit tests for path helpers and window manager

Recommended agents:
- Lead: `feature-builder` (Sonnet) — window management and app lifecycle
- Review: `code-reviewer` (Haiku) — error handling and cleanup

---

### Stage 3: IPC Bridge

**Goal:** Type-safe, secure IPC layer connecting main and renderer.

Key deliverables:
- Preload script exposing API via `contextBridge.exposeInMainWorld`
- IPC channel registry (typed constants or enum)
- Main-side `ipcMain.handle` handlers for each channel
- Renderer-side typed wrapper (`window.api.*`)
- Shared TypeScript types for all IPC payloads

Typical tasks:
- Define IPC channel names as typed constants
- Implement `contextBridge` exposure with full type signatures
- Register `ipcMain.handle` for each channel with validation
- Generate renderer-side API object from preload
- Test round-trip for one sample channel

Recommended agents:
- Lead: `feature-builder` (Sonnet) — IPC architecture
- Support: `code-reviewer` (Sonnet) — security review (no nodeIntegration leaks, input validation)

**Note:** This is the highest-risk stage. Any security mistake here (exposing raw `ipcRenderer`, skipping validation) is hard to fix later.

---

### Stage 4: Renderer / UI

**Goal:** Application UI built in the renderer, consuming the IPC API.

Key deliverables:
- Component library or design system setup (Tailwind, CSS Modules, or component lib)
- Main application shell (layout, sidebar, content area)
- Feature screens/views wired to IPC calls
- Loading, error, and empty states for all async operations
- Keyboard navigation support

Typical tasks:
- Set up styling approach and global CSS reset
- Build app shell layout
- Implement primary feature views
- Wire UI components to `window.api.*` calls
- Handle IPC errors gracefully in the UI
- Add keyboard shortcuts via Electron's `globalShortcut` or renderer-local handlers

Recommended agents:
- Lead: `ui-ux-designer` (Opus) — layout and component design
- Support: `feature-builder` (Sonnet) — IPC wiring and state management
- Review: `code-reviewer` (Haiku) — accessibility and error states

---

### Stage 5: File System Integration

**Goal:** App can read, write, and watch files on the user's machine.

Key deliverables:
- File open/save dialogs via `dialog.showOpenDialog` / `dialog.showSaveDialog`
- File read/write operations through main process IPC handlers
- File watcher (if needed) using `chokidar` or `fs.watch`
- Recent files list with persistence
- Drag-and-drop file handling in renderer

Typical tasks:
- Implement file dialog IPC handlers
- Add read/write/exists helpers with error handling
- Persist recent files to AppData
- Handle file not found, permission denied, disk full errors
- Wire drag-and-drop events to IPC

Recommended agents:
- Lead: `feature-builder` (Sonnet) — file system IPC handlers
- Review: `code-reviewer` (Haiku) — error handling and path sanitization

---

### Stage 6: Native Integrations

**Goal:** App feels native with OS-level features.

Key deliverables:
- Application menu (File, Edit, View, Help) with accelerators
- Context menus for right-click interactions
- System tray icon and menu (if applicable)
- OS notifications via `Notification` API
- Dock/taskbar badge (macOS/Windows)

Typical tasks:
- Build menu template with accelerators
- Wire menu items to IPC or renderer actions
- Implement system tray with show/hide/quit
- Add notification support with click handlers
- Implement deep linking (custom URL scheme)

Recommended agents:
- Lead: `feature-builder` (Sonnet) — menus and tray
- Review: `code-reviewer` (Haiku) — cross-platform behavior differences

---

### Stage 7: Auto-Update

**Goal:** App can deliver updates to users without manual reinstall.

Key deliverables:
- `electron-updater` configured against update server (GitHub Releases or S3)
- Update check on startup (with configurable interval)
- Progress UI: checking, available, downloading, ready-to-install
- Silent background download with user-prompted install
- Rollback strategy documented

Typical tasks:
- Install and configure `electron-updater`
- Set up update feed URL (GitHub Releases recommended for start)
- Implement update lifecycle IPC channels (check, progress, install)
- Build update notification UI in renderer
- Test with a staged release

Recommended agents:
- Lead: `feature-builder` (Sonnet) — updater integration
- Review: `code-reviewer` (Haiku) — error handling and user messaging

---

### Stage 8: Packaging

**Goal:** App builds to installable artifacts for all target platforms.

Key deliverables:
- `electron-builder` config in `package.json` or `electron-builder.yml`
- Icons for macOS (.icns), Windows (.ico), Linux (.png)
- Code signing configuration (macOS and Windows)
- ASAR packaging with correct `extraResources` entries
- CI build matrix (mac/win/linux)

Typical tasks:
- Configure `electron-builder` targets (dmg, nsis, AppImage)
- Generate icons at all required sizes
- Add entitlements file for macOS notarization
- Set up `extraResources` for bundled assets
- Test unsigned local build on each platform

Recommended agents:
- Lead: `feature-builder` (Sonnet) — build config
- Review: `code-reviewer` (Haiku) — signing and entitlements checklist

---

### Stage 9: Distribution

**Goal:** App released and downloadable by users.

Key deliverables:
- GitHub Release (or equivalent) with platform artifacts
- Auto-update feed pointing to release
- Download page or landing page updated
- Release notes / changelog
- Smoke test on clean machine

Typical tasks:
- Tag release and trigger CI build
- Upload artifacts to release
- Verify auto-updater can fetch and apply update
- Update website download links
- Test install on clean VM

Recommended agents:
- Lead: `feature-builder` (Sonnet) — release pipeline
- Review: `code-reviewer` (Haiku) — artifact verification

---

## Common Parallelization Patterns

```
Stage 1 (Foundation)
       ↓
Stage 2 (Main Process) ─────────────────────────────┐
       ↓                                             │
Stage 3 (IPC Bridge) ← must follow Stage 2          │
       ↓                                             │
Stage 4 (Renderer/UI) ──── can start UI skeleton ───┘
       ↓ (IPC wired)
Stage 5 (File System) ──┐
Stage 6 (Native)        │── parallel once Stage 4 complete
Stage 7 (Auto-Update)  ─┘
       ↓
Stage 8 (Packaging)
       ↓
Stage 9 (Distribution)
```

Within a stage, parallelize by subsystem:
- Menu implementation and tray implementation can run in parallel (Stage 6)
- macOS and Windows packaging tasks can run in parallel (Stage 8)
- Read and write IPC handlers can be built in parallel (Stage 5)

---

## Technology-Specific Verification Commands

```bash
# TypeScript — check all three process configs
npx tsc -p src/main/tsconfig.json --noEmit
npx tsc -p src/preload/tsconfig.json --noEmit
npx tsc -p src/renderer/tsconfig.json --noEmit

# Start dev mode
npm run dev

# Run unit tests (Vitest or Jest)
npm test

# Build for current platform (unpackaged, fast check)
npm run build
npx electron-builder --dir

# Full packaged build
npx electron-builder

# Check preload security: no direct node access exposed
grep -r "nodeIntegration: true" src/main/
grep -r "require(" src/preload/ | grep -v contextBridge

# Lint
npm run lint
```

---

## Common Stage Dependencies

| Stage | Hard Depends On | Notes |
|-------|----------------|-------|
| Main Process (2) | Foundation (1) | BrowserWindow must exist |
| IPC Bridge (3) | Main Process (2) | ipcMain handlers registered in main |
| Renderer/UI (4) | IPC Bridge (3) | window.api must be available |
| File System (5) | IPC Bridge (3) | File ops go through IPC |
| Native Integrations (6) | Renderer/UI (4) | Menu actions trigger renderer updates |
| Auto-Update (7) | Main Process (2) | Updater runs in main process |
| Packaging (8) | All features complete | Can't package incomplete app |
| Distribution (9) | Packaging (8) | Artifacts must exist before release |

---

## Planner Notes

- **Skip Stage 7** (Auto-Update) for internal tools where users can reinstall manually.
- **Skip tray** in Stage 6 if the app doesn't need background operation.
- **Merge Stages 8+9** for small projects — packaging and distribution can be one stage.
- Always validate the IPC security model in Stage 3 before building on top of it.
- Window state persistence (Stage 2) is easy to add early but painful to retrofit.
