# [Game Name] - Project Documentation

## Overview
[Brief description of the game, genre, and gameplay]

## Tech Stack
- **[Game Engine]** - Phaser.js / PixiJS / Three.js / Custom Canvas
- **TypeScript** for type safety
- **[Build Tool]** - Vite / Webpack / Parcel
- **[Physics]** - Matter.js / Arcade Physics / Box2D (if used)
- **[State Management]** - Custom / Redux / Zustand (if used)
- **[Asset Loading]** - Built-in loader / Custom
- **[Testing]** - Vitest / Jest (if used)

## Project Structure
```
src/
├── index.ts               # Game initialization
├── config/
│   ├── game.config.ts     # Phaser/engine configuration
│   └── constants.ts       # Game constants
├── scenes/                # Game scenes
│   ├── Boot.ts            # Preloader/boot scene
│   ├── MainMenu.ts        # Main menu
│   ├── GamePlay.ts        # Main gameplay
│   ├── GameOver.ts        # Game over screen
│   └── Pause.ts           # Pause menu
├── entities/              # Game entities/sprites
│   ├── Player.ts
│   ├── Enemy.ts
│   └── Projectile.ts
├── systems/               # Game systems
│   ├── InputSystem.ts
│   ├── CollisionSystem.ts
│   └── ScoreSystem.ts
├── managers/              # Game managers
│   ├── AssetManager.ts
│   ├── AudioManager.ts
│   └── StateManager.ts
├── utils/
│   ├── math.ts
│   └── helpers.ts
└── types/
    └── index.ts

public/
├── assets/
│   ├── images/
│   │   ├── sprites/
│   │   ├── backgrounds/
│   │   └── ui/
│   ├── audio/
│   │   ├── music/
│   │   └── sfx/
│   └── fonts/
└── index.html
```

## Game Configuration

### Phaser Configuration
```typescript
// src/config/game.config.ts
import Phaser from 'phaser';
import { Boot, MainMenu, GamePlay, GameOver } from '../scenes';

export const gameConfig: Phaser.Types.Core.GameConfig = {
  type: Phaser.AUTO,
  width: 800,
  height: 600,
  parent: 'game-container',
  backgroundColor: '#000000',
  physics: {
    default: 'arcade',
    arcade: {
      gravity: { y: 300 },
      debug: process.env.NODE_ENV === 'development',
    },
  },
  scene: [Boot, MainMenu, GamePlay, GameOver],
  scale: {
    mode: Phaser.Scale.FIT,
    autoCenter: Phaser.Scale.CENTER_BOTH,
  },
  audio: {
    disableWebAudio: false,
  },
};
```

### Game Constants
```typescript
// src/config/constants.ts
export const GAME_WIDTH = 800;
export const GAME_HEIGHT = 600;
export const PLAYER_SPEED = 200;
export const ENEMY_SPAWN_RATE = 2000;
export const MAX_LIVES = 3;

export const ASSETS = {
  PLAYER: 'player',
  ENEMY: 'enemy',
  BACKGROUND: 'background',
  MUSIC: 'background-music',
  SFX_SHOOT: 'shoot',
} as const;
```

## Scene Management

### Scene Lifecycle
```typescript
// src/scenes/GamePlay.ts
import Phaser from 'phaser';
import { Player } from '../entities/Player';
import { ASSETS } from '../config/constants';

export class GamePlay extends Phaser.Scene {
  private player!: Player;
  private enemies!: Phaser.GameObjects.Group;
  private score: number = 0;
  private scoreText!: Phaser.GameObjects.Text;

  constructor() {
    super({ key: 'GamePlay' });
  }

  // Load assets
  preload() {
    this.load.image(ASSETS.PLAYER, 'assets/images/player.png');
    this.load.image(ASSETS.ENEMY, 'assets/images/enemy.png');
    this.load.audio(ASSETS.MUSIC, 'assets/audio/music.mp3');
  }

  // Initialize scene
  create() {
    // Create background
    this.add.image(400, 300, ASSETS.BACKGROUND);

    // Create player
    this.player = new Player(this, 400, 500);
    this.add.existing(this.player);

    // Create enemy group
    this.enemies = this.add.group({
      classType: Enemy,
      runChildUpdate: true,
    });

    // Setup UI
    this.scoreText = this.add.text(16, 16, 'Score: 0', {
      fontSize: '32px',
      color: '#fff',
    });

    // Setup input
    this.setupInput();

    // Setup collisions
    this.setupCollisions();

    // Start background music
    this.sound.play(ASSETS.MUSIC, { loop: true, volume: 0.5 });
  }

  // Update game loop (called every frame)
  update(time: number, delta: number) {
    this.player.update(time, delta);
    this.spawnEnemies(time);
  }

  private setupInput() {
    this.input.keyboard?.on('keydown-SPACE', () => {
      this.player.shoot();
    });
  }

  private setupCollisions() {
    this.physics.add.overlap(
      this.player.bullets,
      this.enemies,
      this.handleBulletEnemyCollision,
      undefined,
      this
    );
  }

  private handleBulletEnemyCollision(
    bullet: Phaser.GameObjects.GameObject,
    enemy: Phaser.GameObjects.GameObject
  ) {
    bullet.destroy();
    enemy.destroy();
    this.addScore(10);
  }

  private spawnEnemies(time: number) {
    // Enemy spawning logic
  }

  private addScore(points: number) {
    this.score += points;
    this.scoreText.setText(`Score: ${this.score}`);
  }
}
```

### Scene Transitions
```typescript
// Transition from MainMenu to GamePlay
this.scene.start('GamePlay', { difficulty: 'normal' });

// Pause current scene and show Pause menu
this.scene.pause();
this.scene.launch('Pause');

// Resume from pause
this.scene.resume('GamePlay');
this.scene.stop('Pause');

// Game over transition
this.scene.start('GameOver', {
  score: this.score,
  level: this.currentLevel,
});
```

## Entity Pattern

### Base Entity Class
```typescript
// src/entities/Player.ts
import Phaser from 'phaser';

export class Player extends Phaser.GameObjects.Sprite {
  public bullets!: Phaser.GameObjects.Group;
  private cursors!: Phaser.Types.Input.Keyboard.CursorKeys;
  private health: number = 3;
  private speed: number = 200;

  constructor(scene: Phaser.Scene, x: number, y: number) {
    super(scene, x, y, 'player');

    // Enable physics
    scene.physics.world.enable(this);

    // Setup bullets group
    this.bullets = scene.add.group({
      classType: Bullet,
      maxSize: 10,
      runChildUpdate: true,
    });

    // Setup input
    this.cursors = scene.input.keyboard!.createCursorKeys();
  }

  update(time: number, delta: number) {
    const body = this.body as Phaser.Physics.Arcade.Body;

    // Handle movement
    if (this.cursors.left.isDown) {
      body.setVelocityX(-this.speed);
    } else if (this.cursors.right.isDown) {
      body.setVelocityX(this.speed);
    } else {
      body.setVelocityX(0);
    }

    // Keep player on screen
    this.x = Phaser.Math.Clamp(this.x, 0, this.scene.scale.width);
  }

  shoot() {
    const bullet = this.bullets.get(this.x, this.y - 20);
    if (bullet) {
      bullet.fire();
      this.scene.sound.play('shoot');
    }
  }

  takeDamage(amount: number) {
    this.health -= amount;

    if (this.health <= 0) {
      this.die();
    } else {
      this.flash();
    }
  }

  private flash() {
    this.scene.tweens.add({
      targets: this,
      alpha: 0,
      duration: 100,
      yoyo: true,
      repeat: 3,
    });
  }

  private die() {
    this.scene.cameras.main.shake(500);
    this.destroy();
    this.scene.scene.start('GameOver');
  }
}
```

## Input Handling

### Keyboard Input
```typescript
// Setup in scene create()
this.cursors = this.input.keyboard!.createCursorKeys();

// Custom keys
this.keys = {
  jump: this.input.keyboard!.addKey(Phaser.Input.Keyboard.KeyCodes.SPACE),
  shoot: this.input.keyboard!.addKey(Phaser.Input.Keyboard.KeyCodes.CTRL),
};

// In update()
if (this.cursors.up.isDown) {
  this.player.jump();
}

if (Phaser.Input.Keyboard.JustDown(this.keys.shoot)) {
  this.player.shoot();
}
```

### Mouse/Touch Input
```typescript
// Click/tap handling
this.input.on('pointerdown', (pointer: Phaser.Input.Pointer) => {
  this.handleClick(pointer.x, pointer.y);
});

// Drag handling
this.input.on('pointermove', (pointer: Phaser.Input.Pointer) => {
  if (pointer.isDown) {
    this.player.x = pointer.x;
    this.player.y = pointer.y;
  }
});
```

## Collision Detection

### Arcade Physics Collisions
```typescript
// src/scenes/GamePlay.ts
private setupCollisions() {
  // Collision between two sprites
  this.physics.add.collider(
    this.player,
    this.platforms
  );

  // Overlap (no physics response)
  this.physics.add.overlap(
    this.player,
    this.coins,
    this.collectCoin,
    undefined,
    this
  );

  // Group vs Group
  this.physics.add.overlap(
    this.player.bullets,
    this.enemies,
    this.bulletHitEnemy,
    undefined,
    this
  );

  // With custom collision callback
  this.physics.add.collider(
    this.player,
    this.enemies,
    this.playerHitEnemy,
    (player, enemy) => {
      // Return true to process collision, false to skip
      return !player.isInvincible;
    },
    this
  );
}

private collectCoin(
  player: Phaser.GameObjects.GameObject,
  coin: Phaser.GameObjects.GameObject
) {
  coin.destroy();
  this.score += 10;
}
```

## Animation System

### Creating Animations
```typescript
// src/scenes/Boot.ts (or in entity constructor)
this.anims.create({
  key: 'player-walk',
  frames: this.anims.generateFrameNumbers('player', {
    start: 0,
    end: 7,
  }),
  frameRate: 10,
  repeat: -1, // Loop forever
});

this.anims.create({
  key: 'player-jump',
  frames: this.anims.generateFrameNumbers('player', {
    frames: [8, 9, 10],
  }),
  frameRate: 10,
  repeat: 0,
});

// Playing animations
this.player.play('player-walk');

// Stop animation
this.player.stop();

// Animation events
this.player.on('animationcomplete-player-jump', () => {
  this.player.play('player-idle');
});
```

## Audio Management

### Audio Manager Pattern
```typescript
// src/managers/AudioManager.ts
export class AudioManager {
  private scene: Phaser.Scene;
  private music: Phaser.Sound.BaseSound | null = null;
  private sfxVolume: number = 1.0;
  private musicVolume: number = 0.5;

  constructor(scene: Phaser.Scene) {
    this.scene = scene;
  }

  playMusic(key: string, loop: boolean = true) {
    if (this.music) {
      this.music.stop();
    }

    this.music = this.scene.sound.add(key, {
      loop,
      volume: this.musicVolume,
    });
    this.music.play();
  }

  playSfx(key: string, volume?: number) {
    this.scene.sound.play(key, {
      volume: volume ?? this.sfxVolume,
    });
  }

  setMusicVolume(volume: number) {
    this.musicVolume = Phaser.Math.Clamp(volume, 0, 1);
    if (this.music) {
      this.music.setVolume(this.musicVolume);
    }
  }

  setSfxVolume(volume: number) {
    this.sfxVolume = Phaser.Math.Clamp(volume, 0, 1);
  }
}
```

## State Management

### Game State Pattern
```typescript
// src/managers/StateManager.ts
interface GameState {
  score: number;
  lives: number;
  level: number;
  highScore: number;
  settings: {
    musicVolume: number;
    sfxVolume: number;
  };
}

export class StateManager {
  private state: GameState;

  constructor() {
    this.state = this.loadState();
  }

  private loadState(): GameState {
    const saved = localStorage.getItem('gameState');
    if (saved) {
      return JSON.parse(saved);
    }

    return {
      score: 0,
      lives: 3,
      level: 1,
      highScore: 0,
      settings: {
        musicVolume: 0.5,
        sfxVolume: 1.0,
      },
    };
  }

  saveState() {
    localStorage.setItem('gameState', JSON.stringify(this.state));
  }

  getState(): GameState {
    return { ...this.state };
  }

  updateState(updates: Partial<GameState>) {
    this.state = { ...this.state, ...updates };
    this.saveState();
  }

  resetGameProgress() {
    this.state.score = 0;
    this.state.lives = 3;
    this.state.level = 1;
    this.saveState();
  }
}
```

## Asset Loading

### Preload Pattern
```typescript
// src/scenes/Boot.ts
export class Boot extends Phaser.Scene {
  constructor() {
    super({ key: 'Boot' });
  }

  preload() {
    // Show loading bar
    this.createLoadingBar();

    // Load images
    this.load.image('player', 'assets/images/player.png');
    this.load.image('background', 'assets/images/bg.png');

    // Load spritesheets
    this.load.spritesheet('explosion', 'assets/images/explosion.png', {
      frameWidth: 64,
      frameHeight: 64,
    });

    // Load audio
    this.load.audio('music', 'assets/audio/music.mp3');
    this.load.audio('shoot', 'assets/audio/shoot.wav');

    // Load JSON
    this.load.json('level-1', 'assets/levels/level1.json');

    // Progress events
    this.load.on('progress', (value: number) => {
      this.updateLoadingBar(value);
    });

    this.load.on('complete', () => {
      this.scene.start('MainMenu');
    });
  }

  private createLoadingBar() {
    const width = this.cameras.main.width;
    const height = this.cameras.main.height;

    const progressBar = this.add.graphics();
    const progressBox = this.add.graphics();
    progressBox.fillStyle(0x222222, 0.8);
    progressBox.fillRect(width / 4, height / 2 - 30, width / 2, 50);

    this.load.on('progress', (value: number) => {
      progressBar.clear();
      progressBar.fillStyle(0xffffff, 1);
      progressBar.fillRect(
        width / 4 + 10,
        height / 2 - 20,
        (width / 2 - 20) * value,
        30
      );
    });
  }
}
```

## Performance Optimization

### Object Pooling
```typescript
// Create a pool of reusable objects
this.bulletPool = this.add.group({
  classType: Bullet,
  maxSize: 20,
  runChildUpdate: true,
});

// Get object from pool
const bullet = this.bulletPool.get(x, y);
if (bullet) {
  bullet.setActive(true);
  bullet.setVisible(true);
  bullet.fire();
}

// Return to pool when done
bullet.setActive(false);
bullet.setVisible(false);
```

### Texture Atlases
```typescript
// Combine multiple images into a single texture atlas
// Load in Boot scene
this.load.atlas(
  'sprites',
  'assets/atlases/sprites.png',
  'assets/atlases/sprites.json'
);

// Use atlas frames
this.add.image(x, y, 'sprites', 'player-idle-1');
```

### Destroy Unused Objects
```typescript
// Clean up off-screen objects
this.enemies.children.each((enemy: Phaser.GameObjects.GameObject) => {
  if (enemy.y > this.cameras.main.height + 50) {
    enemy.destroy();
  }
});
```

## Commands
```bash
npm run dev          # Development server with hot reload
npm run build        # Production build
npm run preview      # Preview production build
npm run test         # Run tests (if applicable)
```

## Key Files
| Purpose | File |
|---------|------|
| Game entry | `src/index.ts` |
| Game config | `src/config/game.config.ts` |
| Constants | `src/config/constants.ts` |
| Main gameplay | `src/scenes/GamePlay.ts` |
| Player entity | `src/entities/Player.ts` |
| Audio manager | `src/managers/AudioManager.ts` |

## Code Style

### Scenes
- Keep scenes focused on orchestration
- Delegate entity logic to entity classes
- Use scene data to pass information between scenes

### Entities
- Extend Phaser.GameObjects.Sprite for visual entities
- Implement update() method for per-frame logic
- Keep entity behavior self-contained

### Systems
- Use managers for cross-cutting concerns (audio, state)
- Keep systems stateless where possible
- Use events for communication between systems

---

## Notes
[Any additional game-specific mechanics, special features, or important information]

## Resources
- [Phaser 3 Documentation](https://photonstorm.github.io/phaser3-docs/)
- [Phaser 3 Examples](https://phaser.io/examples)
- [Game development patterns]
