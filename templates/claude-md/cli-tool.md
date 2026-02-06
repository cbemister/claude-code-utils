# [CLI Tool Name] - Project Documentation

## Overview
[Brief description of what this CLI tool does and its primary purpose]

## Installation
```bash
npm install -g [tool-name]
# or
npx [tool-name]
# or
yarn global add [tool-name]
```

## Tech Stack
- **Node.js** [version]
- **TypeScript** for type safety
- **[CLI Framework]** - Commander.js / yargs / oclif
- **[Build Tool]** - tsup / esbuild / rollup
- **[Testing]** - Vitest / Jest
- **[Linting]** - ESLint + Prettier

## Project Structure
```
src/
├── index.ts               # Main entry point, CLI setup
├── commands/              # Command implementations
│   ├── init.ts
│   ├── build.ts
│   └── deploy.ts
├── lib/                   # Core logic
│   ├── config.ts          # Configuration handling
│   ├── logger.ts          # Output formatting
│   └── utils.ts
├── types/                 # TypeScript type definitions
│   └── index.ts
└── __tests__/             # Tests
    ├── unit/
    └── e2e/

bin/                       # Executable entry
└── cli.js                 # Shebang wrapper

dist/                      # Build output (not in git)
├── index.js               # CJS output
└── index.mjs              # ESM output
```

## Command Structure

### Main CLI Setup
```typescript
// src/index.ts
import { Command } from 'commander';

export const program = new Command();

program
  .name('[tool-name]')
  .description('[Tool description]')
  .version(require('../package.json').version);

program
  .command('init')
  .description('Initialize a new project')
  .option('-t, --template <type>', 'Project template')
  .action(initCommand);

program
  .command('build')
  .description('Build the project')
  .option('-w, --watch', 'Watch mode')
  .action(buildCommand);

program.parse();
```

### Command Implementation Pattern
```typescript
// src/commands/init.ts
import { logger } from '../lib/logger';
import { loadConfig } from '../lib/config';

export async function initCommand(options: InitOptions) {
  try {
    logger.info('Initializing project...');

    const config = await loadConfig();
    // Implementation

    logger.success('Project initialized!');
  } catch (error) {
    logger.error(`Failed to initialize: ${error.message}`);
    process.exit(1);
  }
}
```

## Configuration

### Configuration File Pattern
```typescript
// src/lib/config.ts
import { cosmiconfig } from 'cosmiconfig';
import { z } from 'zod';

const configSchema = z.object({
  rootDir: z.string().default('./'),
  output: z.string().default('./dist'),
  // ...
});

export type Config = z.infer<typeof configSchema>;

export async function loadConfig(): Promise<Config> {
  const explorer = cosmiconfig('[tool-name]');
  const result = await explorer.search();

  if (!result) {
    return configSchema.parse({});
  }

  return configSchema.parse(result.config);
}
```

### Configuration File Locations
Supports multiple locations (in priority order):
- `.[tool-name]rc.json`
- `.[tool-name]rc.js`
- `.[tool-name].config.js`
- `package.json` (in `[tool-name]` field)

Example `.toolrc.json`:
```json
{
  "rootDir": "./src",
  "output": "./dist",
  "watch": false
}
```

## Argument Parsing

### Option Types
```typescript
// Boolean flags
.option('-w, --watch', 'Enable watch mode')

// String options
.option('-c, --config <path>', 'Config file path')

// Number options
.option('-p, --port <number>', 'Port number', parseInt)

// Multiple values
.option('-e, --exclude <patterns...>', 'Patterns to exclude')

// Default values
.option('-o, --output <dir>', 'Output directory', './dist')

// Required options
.requiredOption('-t, --template <type>', 'Template type')
```

### Positional Arguments
```typescript
program
  .command('create <name>')
  .description('Create a new resource')
  .action((name, options) => {
    // name is positional argument
  });
```

### Variadic Arguments
```typescript
program
  .command('process <files...>')
  .description('Process multiple files')
  .action((files) => {
    // files is an array
  });
```

## Interactive Prompts

### Using Inquirer/Prompts
```typescript
import prompts from 'prompts';

export async function initCommand(options: InitOptions) {
  const answers = await prompts([
    {
      type: 'select',
      name: 'template',
      message: 'Choose a template:',
      choices: [
        { title: 'Basic', value: 'basic' },
        { title: 'Advanced', value: 'advanced' },
      ],
    },
    {
      type: 'text',
      name: 'name',
      message: 'Project name:',
      validate: (value) => value.length > 0 || 'Name is required',
    },
    {
      type: 'confirm',
      name: 'typescript',
      message: 'Use TypeScript?',
      initial: true,
    },
  ]);

  if (!answers.name) {
    logger.error('Operation cancelled');
    process.exit(1);
  }

  // Use answers...
}
```

## Output Formatting

### Logger Pattern
```typescript
// src/lib/logger.ts
import chalk from 'chalk';

export const logger = {
  info: (msg: string) => console.log(chalk.blue('ℹ'), msg),
  success: (msg: string) => console.log(chalk.green('✓'), msg),
  warn: (msg: string) => console.log(chalk.yellow('⚠'), msg),
  error: (msg: string) => console.error(chalk.red('✖'), msg),

  step: (current: number, total: number, msg: string) => {
    console.log(chalk.cyan(`[${current}/${total}]`), msg);
  },

  spinner: (msg: string) => {
    // Use ora or similar for spinners
    const ora = require('ora');
    return ora(msg).start();
  },
};
```

### Progress Indicators
```typescript
const spinner = logger.spinner('Processing...');

try {
  await doWork();
  spinner.succeed('Completed!');
} catch (error) {
  spinner.fail('Failed!');
  throw error;
}
```

### Tables
```typescript
import { table } from 'table';

const data = [
  ['Name', 'Status', 'Size'],
  ['file1.js', 'OK', '1.2 KB'],
  ['file2.js', 'OK', '800 B'],
];

console.log(table(data));
```

## Error Handling

### Error Types
```typescript
// src/lib/errors.ts
export class CLIError extends Error {
  constructor(
    message: string,
    public code: string,
    public exitCode: number = 1
  ) {
    super(message);
    this.name = 'CLIError';
  }
}

export class ConfigError extends CLIError {
  constructor(message: string) {
    super(message, 'CONFIG_ERROR', 1);
  }
}

export class ValidationError extends CLIError {
  constructor(message: string) {
    super(message, 'VALIDATION_ERROR', 1);
  }
}
```

### Global Error Handler
```typescript
// src/index.ts
import { CLIError } from './lib/errors';

process.on('unhandledRejection', (error: Error) => {
  if (error instanceof CLIError) {
    logger.error(error.message);
    process.exit(error.exitCode);
  } else {
    logger.error(`Unexpected error: ${error.message}`);
    if (process.env.DEBUG) {
      console.error(error.stack);
    }
    process.exit(1);
  }
});
```

### User-Friendly Errors
```typescript
try {
  await validateConfig(config);
} catch (error) {
  throw new ConfigError(
    `Invalid configuration:\n` +
    `  - ${error.message}\n` +
    `  Fix: Check your .toolrc.json file`
  );
}
```

## File System Operations

### Path Handling
```typescript
import path from 'path';
import { fileURLToPath } from 'url';

// Get directory of current module
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Resolve paths relative to cwd
const absolutePath = path.resolve(process.cwd(), options.config);

// Join paths safely
const outputPath = path.join(config.rootDir, 'dist', 'output.js');
```

### File Operations
```typescript
import fs from 'fs/promises';
import { existsSync } from 'fs';

// Check if file exists
if (!existsSync(configPath)) {
  throw new ConfigError('Config file not found');
}

// Read file
const content = await fs.readFile(filePath, 'utf-8');

// Write file
await fs.writeFile(outputPath, content, 'utf-8');

// Create directory
await fs.mkdir(dirPath, { recursive: true });

// Copy file
await fs.copyFile(source, dest);
```

### Template Copying
```typescript
import { glob } from 'glob';

async function copyTemplate(templateDir: string, targetDir: string) {
  const files = await glob('**/*', {
    cwd: templateDir,
    dot: true,
    nodir: true,
  });

  for (const file of files) {
    const source = path.join(templateDir, file);
    const dest = path.join(targetDir, file);

    await fs.mkdir(path.dirname(dest), { recursive: true });
    await fs.copyFile(source, dest);
  }
}
```

## Testing

### Unit Tests
```typescript
import { describe, it, expect, vi } from 'vitest';
import { initCommand } from '../commands/init';

describe('init command', () => {
  it('should create project structure', async () => {
    const mockFs = vi.spyOn(fs, 'mkdir');

    await initCommand({ template: 'basic', name: 'test' });

    expect(mockFs).toHaveBeenCalledWith(
      expect.stringContaining('test'),
      expect.any(Object)
    );
  });

  it('should throw on invalid template', async () => {
    await expect(
      initCommand({ template: 'invalid', name: 'test' })
    ).rejects.toThrow('Unknown template');
  });
});
```

### E2E Tests
```typescript
import { exec } from 'child_process';
import { promisify } from 'util';

const execAsync = promisify(exec);

describe('CLI e2e', () => {
  it('should run init command', async () => {
    const { stdout, stderr } = await execAsync(
      'node ./dist/index.js init --template basic --name test'
    );

    expect(stdout).toContain('Project initialized');
    expect(stderr).toBe('');
  });
});
```

### Mocking User Input
```typescript
import { vi } from 'vitest';

it('should handle user prompts', async () => {
  // Mock prompts
  const mockPrompts = vi.fn().mockResolvedValue({
    name: 'test-project',
    typescript: true,
  });

  vi.mock('prompts', () => ({ default: mockPrompts }));

  await initCommand({});

  expect(mockPrompts).toHaveBeenCalled();
});
```

## Build Configuration

### Package.json Setup
```json
{
  "name": "[tool-name]",
  "version": "1.0.0",
  "bin": {
    "[tool-name]": "./dist/index.js"
  },
  "files": [
    "dist",
    "bin"
  ],
  "scripts": {
    "build": "tsup src/index.ts --format cjs,esm --dts",
    "dev": "tsup src/index.ts --watch",
    "test": "vitest",
    "prepublishOnly": "npm run build && npm test"
  }
}
```

### tsup Configuration
```typescript
// tsup.config.ts
import { defineConfig } from 'tsup';

export default defineConfig({
  entry: ['src/index.ts'],
  format: ['cjs', 'esm'],
  dts: true,
  splitting: false,
  sourcemap: true,
  clean: true,
  shims: true, // Add shims for __dirname, __filename
  banner: {
    js: '#!/usr/bin/env node',
  },
});
```

## Commands
```bash
npm run dev          # Build in watch mode
npm run build        # Build for production
npm run test         # Run tests
npm run test:watch   # Run tests in watch mode
npm run lint         # Run linter

# Testing locally
npm link             # Link CLI globally
[tool-name] --help   # Test your CLI

# Publishing
npm version [patch|minor|major]
npm publish
```

## Environment Variables

### Usage in CLI
```typescript
const DEBUG = process.env.DEBUG === 'true';
const CI = process.env.CI === 'true';

if (DEBUG) {
  logger.info('Debug mode enabled');
}
```

### User Configuration
Users can set environment variables:
```bash
DEBUG=true [tool-name] build
CI=true [tool-name] deploy
```

## Distribution

### npm Publishing
```bash
# First time setup
npm login

# Publish
npm run build
npm test
npm publish

# Publish beta
npm publish --tag beta
```

### GitHub Releases
Automate with GitHub Actions:
```yaml
name: Release
on:
  push:
    tags:
      - 'v*'
jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
      - run: npm install
      - run: npm run build
      - run: npm test
      - run: npm publish
        env:
          NODE_AUTH_TOKEN: ${{ secrets.NPM_TOKEN }}
```

## Help Text Best Practices

### Command Descriptions
```typescript
program
  .command('build')
  .description('Build the project for production')  // Clear and concise
  .option('-w, --watch', 'Rebuild on file changes')
  .option('-m, --minify', 'Minify output files')
  .option('-s, --sourcemap', 'Generate source maps')
```

### Examples in Help
```typescript
program
  .command('create <name>')
  .description('Create a new component')
  .addHelpText('after', `
Examples:
  $ [tool-name] create Button
  $ [tool-name] create auth/LoginForm
  $ [tool-name] create --template advanced UserCard
  `);
```

## Code Style

### TypeScript
- Use strict mode
- Define interfaces for all command options
- Export types for public APIs

### Error Messages
- Be specific about what went wrong
- Suggest how to fix it
- Include relevant file paths

### Output
- Use colors for clarity (errors = red, success = green)
- Include emoji/symbols for visual scanning
- Show progress for long operations

---

## Notes
[Any additional CLI-specific conventions, third-party integrations, or important information]

## Resources
- [Commander.js Documentation](https://github.com/tj/commander.js)
- [Node.js CLI Best Practices](https://github.com/lirantal/nodejs-cli-apps-best-practices)
- [Project-specific resources]
