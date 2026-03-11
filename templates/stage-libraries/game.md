# Stage Library: Browser / Canvas Game (Phaser)

> **Reference material for the project-planner agent.**
> Use this file when generating stage plans for browser-based or canvas games built with Phaser 3, or similar frameworks (PixiJS, Konva, vanilla Canvas).
> Each stage below maps to one `stage-plan.md` file. Adapt stage count and task depth to the project scope.

---

## Archetype Overview

Browser games are built around a **game loop**: update world state, render to canvas, repeat at 60fps. Phaser 3 organizes code into Scenes — each scene is its own update/render context. Build order follows: engine first, then assets, then the game world (player, entities, physics), then systems layered on top (audio, UI/HUD), then content (levels), then polish.

Typical tech stack: Phaser 3 + TypeScript + Vite + Web Audio API + Tiled (level editor) + itch.io or GitHub Pages deploy.

---

## Typical Stage Progression

### Stage 1: Engine Setup

**Goal:** Phaser game boots, renders a canvas, and accepts TypeScript code.

Key deliverables:
- `package.json` with Phaser, Vite, TypeScript
- `Game` config with correct renderer (WebGL with Canvas fallback), physics config, and scene list
- Boot scene (`BootScene`) that preloads minimal assets and advances to PreloadScene
- Preload scene (`PreloadScene`) with progress bar
- Main menu scene stub (`MenuScene`)
- Dev server running with HMR

Typical tasks:
- Initialize project and install Phaser + Vite
- Configure TypeScript with `"moduleResolution": "bundler"` and Phaser type shims
- Create Game config (renderer, width/height, scale mode, physics)
- Build BootScene → PreloadScene → MenuScene transition chain
- Implement preload progress bar

Recommended agents:
- Lead: `feature-builder` (Sonnet) — project scaffold and game config
- Review: `code-reviewer` (Haiku) — renderer config and TypeScript setup

---

### Stage 2: Asset Pipeline

**Goal:** All game assets organized, loaded, and accessible by key.

Key deliverables:
- `assets/` directory structure (sprites, tilemaps, audio, fonts, ui)
- Asset manifest or loader helper (centralized key constants)
- Texture atlases generated (TexturePacker or free-tex-packer)
- Tileset images and Tiled `.json` map files
- Placeholder assets for anything not yet designed
- Preload scene loads all assets with progress feedback

Typical tasks:
- Define asset directory structure and naming conventions
- Create or source placeholder sprite assets
- Generate texture atlas from sprite sheets
- Export tilemap as JSON from Tiled
- Register all assets in PreloadScene with typed key constants
- Verify all assets load without 404s

Recommended agents:
- Lead: `feature-builder` (Sonnet) — asset loading and key constants
- Support: `ui-ux-designer` (Opus) — sprite and UI asset design (if creating originals)
- Review: `code-reviewer` (Haiku) — preload error handling

---

### Stage 3: Scene Management

**Goal:** Scene transitions, data passing, and scene lifecycle managed correctly.

Key deliverables:
- Scene registry with all scene keys as typed constants
- `SceneManager` helper or scene data typing
- Scene transition animations (fade, slide, or instant)
- Pause/resume behavior (overlay scenes for pause menu)
- Scene restart on game over or retry

Typical tasks:
- Define all scene keys as a typed enum or const object
- Implement fade transition helper
- Build GameScene stub that receives level data from MenuScene
- Build PauseScene as overlay (launched over GameScene, not replacing it)
- Build GameOverScene with retry and menu options
- Test full scene flow: Menu → Game → Pause → Resume → Game Over → Retry

Recommended agents:
- Lead: `feature-builder` (Sonnet) — scene architecture
- Review: `code-reviewer` (Haiku) — memory leaks on scene destroy

---

### Stage 4: Player and Entities

**Goal:** Player character controllable with correct animation states.

Key deliverables:
- `Player` class (extends `Phaser.Physics.Arcade.Sprite` or `GameObject`)
- Player state machine: idle, run, jump, fall, attack, hurt, dead
- Animation definitions wired to atlas frames
- Player spawned from tilemap object layer or config
- Enemy/NPC base class (if applicable) with patrol or chase AI stub
- Entity factory or group management

Typical tasks:
- Create Player class with physics body configuration
- Define animation frames for each player state
- Implement state transitions (grounded check, velocity check)
- Add enemy base class with simple AI (patrol between two points)
- Spawn entities from Tiled object layer
- Test player movement visually

Recommended agents:
- Lead: `feature-builder` (Sonnet) — entity classes and animation
- Review: `code-reviewer` (Haiku) — state machine correctness

---

### Stage 5: Input Handling

**Goal:** All control schemes implemented and rebindable.

Key deliverables:
- Keyboard input (WASD + arrows + space + common keys)
- Gamepad support via Phaser's Gamepad plugin
- Mobile touch controls (virtual joystick + buttons, if targeting mobile)
- `InputManager` class abstracting device type
- Input config persisted to localStorage (key bindings)

Typical tasks:
- Create `InputManager` that maps logical actions to physical keys/buttons
- Implement keyboard cursor keys + WASD for movement
- Add gamepad support with axis deadzone handling
- Build on-screen virtual controls for mobile (if applicable)
- Persist and restore key bindings from localStorage
- Test all input methods

Recommended agents:
- Lead: `feature-builder` (Sonnet) — InputManager and binding system
- Review: `code-reviewer` (Haiku) — edge cases (gamepad disconnect, multi-key)

---

### Stage 6: Physics and Collision

**Goal:** All collision and overlap detection working correctly.

Key deliverables:
- Tilemap collider layers registered with arcade physics
- Player ↔ world collision (solid tiles, slopes if applicable)
- Player ↔ enemy overlap (damage, knockback)
- Player ↔ collectible overlap (coins, power-ups)
- Projectile ↔ enemy collision (if applicable)
- Physics debug mode toggle

Typical tasks:
- Set up tilemap collision layers (mark collision tiles in Tiled)
- Add `this.physics.add.collider(player, groundLayer)`
- Implement damage system (hit points, invincibility frames, knockback)
- Implement collectible pickup with score/state update
- Add physics debug toggle (keyboard shortcut in dev)
- Tune physics constants (gravity, jump velocity, friction)

Recommended agents:
- Lead: `feature-builder` (Sonnet) — collision setup and damage system
- Review: `code-reviewer` (Haiku) — physics edge cases (tunneling, stuck-in-wall)

---

### Stage 7: UI and HUD

**Goal:** In-game UI and heads-up display built and reactive.

Key deliverables:
- HUD scene running parallel to GameScene (separate scene, not world-space)
- Health/lives display
- Score display
- Timer (if applicable)
- Minimap (if applicable)
- Main menu screen (title, play, settings, credits)
- Pause menu (resume, restart, settings, quit)
- Settings screen (volume, key bindings)

Typical tasks:
- Create `UIScene` launched in parallel with GameScene
- Implement health bar or heart display
- Implement score counter with update events from GameScene
- Build main menu layout with button components
- Build pause menu with blur overlay
- Build settings panel wired to audio and input managers

Recommended agents:
- Lead: `ui-ux-designer` (Opus) — menu layout and HUD design
- Support: `feature-builder` (Sonnet) — Phaser UI implementation and event wiring
- Review: `code-reviewer` (Haiku) — scene communication correctness

---

### Stage 8: Audio

**Goal:** All sound effects and music playing at appropriate moments.

Key deliverables:
- `AudioManager` class wrapping Phaser's SoundManager
- Background music with loop and fade in/out
- Sound effects for all player actions (jump, attack, hurt, collect, death)
- UI sound effects (button hover, click, menu open)
- Master volume, music volume, SFX volume controls
- Audio resumed after first user interaction (browser autoplay policy)

Typical tasks:
- Create AudioManager singleton
- Load all audio in PreloadScene
- Implement music track management (play, stop, crossfade)
- Wire SFX calls to game events
- Connect volume sliders from Settings to AudioManager
- Handle browser autoplay policy (resume AudioContext on first click)

Recommended agents:
- Lead: `feature-builder` (Sonnet) — AudioManager and event wiring
- Review: `code-reviewer` (Haiku) — autoplay policy and memory (destroy sounds on scene end)

---

### Stage 9: Level Design

**Goal:** Playable levels built, balanced, and loaded from data.

Key deliverables:
- Level manifest (ordered list of level files)
- All levels authored in Tiled and exported as JSON
- Level progression (complete level → load next)
- Level select screen (if applicable)
- Checkpoint system (if applicable)
- Boss encounter (if applicable)

Typical tasks:
- Define level manifest with metadata (name, tilemap file, music track)
- Author Level 1 fully (geometry, enemies, collectibles, exit)
- Author remaining levels
- Implement level completion detection (reach exit trigger)
- Implement level load from manifest
- Playtest each level for balance

Recommended agents:
- Lead: `feature-builder` (Sonnet) — level loading system
- Support: `ui-ux-designer` (Opus) — level design (visual composition)
- Review: `code-reviewer` (Haiku) — level data validation

---

### Stage 10: Polish and Juice

**Goal:** Game feels satisfying to play — feedback, effects, and responsiveness.

Key deliverables:
- Screen shake on impact/explosion
- Particle effects (dust on landing, sparks on hit, collectible pop)
- Camera effects (zoom, letterbox, follow with lerp)
- Hit-stop (brief freeze-frame on impact)
- Screen flash on damage
- Tween animations for UI (score pop, damage number float-up)
- Controller rumble (if gamepad supported)

Typical tasks:
- Add camera follow with lerp and bounds
- Implement screen shake utility
- Add particle emitters for key events
- Implement hit-stop (brief `this.physics.pause()` on hit)
- Add damage number float-up text
- Add idle animations and ambient environment details
- Final playtest pass for feel

Recommended agents:
- Lead: `ui-ux-designer` (Opus) — visual feedback and feel
- Support: `feature-builder` (Sonnet) — Phaser effects implementation
- Review: `code-reviewer` (Haiku) — performance impact of particle systems

---

### Stage 11: Build and Deploy

**Goal:** Game bundled, optimized, and live on target platforms.

Key deliverables:
- Production Vite build with asset hashing
- GZIP/Brotli compression of assets (handled by host)
- Deploy to itch.io, GitHub Pages, or custom domain
- `iframe` embed config for itch.io (canvas size, fullscreen)
- Save data persistence verified in production (localStorage scoped correctly)
- Mobile viewport meta tag and touch handling verified

Typical tasks:
- Configure Vite build for production (base path for GitHub Pages if needed)
- Audit bundle size — split large atlas files if > 2MB
- Upload to itch.io and configure page
- Test fullscreen toggle
- Test save data persistence across sessions
- Verify mobile playability (if targeting mobile)

Recommended agents:
- Lead: `feature-builder` (Sonnet) — build config and deploy
- Review: `code-reviewer` (Haiku) — bundle size and mobile audit

---

## Common Parallelization Patterns

```
Stage 1 (Engine Setup)
       ↓
Stage 2 (Asset Pipeline) ────────────────────────────────────┐
       ↓                                                      │
Stage 3 (Scene Management) ────────────────────────────────┐  │
       ↓                                                    │  │
Stage 4 (Player/Entities) ──┐                              │  │
Stage 5 (Input Handling)  ──┤── parallel, share physics    │  │
Stage 6 (Physics/Collision)─┘   setup from Stage 3         │  │
       ↓ (core gameplay works)                              │  │
Stage 7 (UI/HUD)  ──┐                                      │  │
Stage 8 (Audio)   ──┤── parallel once gameplay is playable │  │
Stage 9 (Levels)  ──┘                                      │  │
       ↓                                                    │  │
Stage 10 (Polish/Juice) ←──────────────────────────────────┘  │
       ↓                                                       │
Stage 11 (Build/Deploy) ←──────────────────────────────────────┘
```

Within a stage:
- Player animations and enemy AI (Stage 4) can be developed in parallel
- Music tracks and SFX (Stage 8) can be built in parallel
- Individual levels (Stage 9) can be authored in parallel once the level loader works

---

## Technology-Specific Verification Commands

```bash
# Start dev server
npm run dev          # Vite dev at localhost:5173

# TypeScript check
npx tsc --noEmit

# Production build
npm run build        # outputs to dist/
npm run preview      # preview dist/ locally

# Check bundle size
du -sh dist/assets/

# Run unit tests (Vitest, if applicable)
npm test

# Check for large assets
find public/assets -name "*.png" -o -name "*.jpg" | xargs du -sh | sort -rh | head -20

# Verify atlas JSON references valid frames
node -e "const a = require('./public/assets/atlas.json'); console.log(Object.keys(a.frames).length, 'frames')"

# Check for audio autoplay policy compliance
# (manual: open browser console, look for AudioContext warnings)

# Lint
npm run lint

# Deploy to GitHub Pages (if configured)
npm run deploy
```

---

## Common Stage Dependencies

| Stage | Hard Depends On | Notes |
|-------|----------------|-------|
| Asset Pipeline (2) | Engine Setup (1) | PreloadScene must exist to load assets |
| Scene Management (3) | Engine Setup (1) | Scenes registered in Game config |
| Player/Entities (4) | Asset Pipeline (2) | Sprites need loaded textures |
| Input Handling (5) | Engine Setup (1) | Can start early, no asset dependency |
| Physics/Collision (6) | Player/Entities (4) | Player physics body must exist |
| UI/HUD (7) | Scene Management (3) | UIScene runs parallel to GameScene |
| Audio (8) | Asset Pipeline (2) | Audio files loaded in PreloadScene |
| Level Design (9) | Physics/Collision (6) | Collision must work before level is playable |
| Polish/Juice (10) | All gameplay systems complete | Polish fills gaps in complete game |
| Build/Deploy (11) | Polish/Juice (10) | Deploy finished game |

---

## Planner Notes

- **Input (Stage 5) can start as early as Stage 1** — keyboard handling has no asset dependencies. Move it earlier if input is complex.
- **Skip mobile touch controls** (Stage 5) for desktop-only games.
- **Merge Stages 10+11** (Polish + Deploy) for game jams — ship fast, polish post-jam.
- **Scene communication** is a common bug source: UIScene and GameScene must use Phaser's event emitter or scene registry to share state, never direct property access.
- **Audio is frequently broken on mobile** due to browser autoplay policies. Always test on a real mobile device before declaring Stage 8 complete.
- **Physics tuning** (Stage 6) is iterative — budget extra time. Game feel comes from physics constants.
- Use the `micro-interactions` and `component-polish` skills during Stage 10 for juice pass guidance.
