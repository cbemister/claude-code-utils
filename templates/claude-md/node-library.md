# [Library Name] - Project Documentation

## Overview
[Brief description of what this library does and its primary purpose]

## Installation
```bash
npm install [library-name]
# or
yarn add [library-name]
# or
pnpm add [library-name]
```

## Tech Stack
- **Node.js** [version]
- **TypeScript** for type safety
- **[Build Tool]** - tsup / esbuild / rollup
- **[Testing]** - Vitest / Jest
- **[Linting]** - ESLint + Prettier

## Project Structure
```
src/
├── index.ts               # Main entry point
├── types/                 # TypeScript type definitions
│   └── index.ts
├── core/                  # Core functionality
│   ├── module1.ts
│   └── module2.ts
├── utils/                 # Utility functions
│   └── helpers.ts
└── __tests__/             # Tests
    ├── unit/
    └── integration/

dist/                      # Build output (not in git)
├── index.js               # CJS output
├── index.mjs              # ESM output
└── index.d.ts             # Type definitions

examples/                  # Usage examples
├── basic.ts
└── advanced.ts
```

## API Design

### Main Export
```typescript
// src/index.ts
export { function1, function2 } from './core/module1';
export { Class1, Class2 } from './core/module2';
export type { Type1, Type2 } from './types';

// Default export (if applicable)
export { default } from './core/main';
```

### Function Pattern
```typescript
/**
 * [Function description]
 *
 * @param param1 - [Description]
 * @param options - [Description]
 * @returns [Description]
 *
 * @example
 * ```typescript
 * const result = functionName('value', { option: true });
 * ```
 */
export function functionName(
  param1: string,
  options?: FunctionOptions
): ReturnType {
  // Implementation
}
```

### Class Pattern
```typescript
/**
 * [Class description]
 *
 * @example
 * ```typescript
 * const instance = new ClassName({ config: 'value' });
 * await instance.method();
 * ```
 */
export class ClassName {
  constructor(config: Config) {
    // Implementation
  }

  public async method(): Promise<Result> {
    // Implementation
  }
}
```

## Type Definitions

### Export Types
All public types should be exported from `src/types/index.ts`:

```typescript
export interface Config {
  option1: string;
  option2?: number;
}

export type Result = {
  success: boolean;
  data?: unknown;
};

export type Options<T> = {
  validate?: (item: T) => boolean;
  transform?: (item: T) => T;
};
```

### Generic Types
```typescript
export interface Response<T> {
  data: T;
  error?: Error;
}

export class Service<TConfig extends BaseConfig> {
  constructor(config: TConfig) {
    // Implementation
  }
}
```

## Error Handling

### Custom Errors
```typescript
export class LibraryError extends Error {
  constructor(
    message: string,
    public code: string,
    public details?: unknown
  ) {
    super(message);
    this.name = 'LibraryError';
  }
}

// Usage
throw new LibraryError('Invalid config', 'INVALID_CONFIG', { config });
```

### Error Codes
Document all error codes:
- `INVALID_CONFIG` - Configuration is invalid
- `NOT_FOUND` - Resource not found
- `TIMEOUT` - Operation timed out

## Testing

### Unit Tests
```typescript
import { describe, it, expect } from 'vitest';
import { functionName } from '../core/module1';

describe('functionName', () => {
  it('should handle basic case', () => {
    const result = functionName('input');
    expect(result).toBe('expected');
  });

  it('should handle edge case', () => {
    expect(() => functionName('')).toThrow(LibraryError);
  });
});
```

### Integration Tests
```typescript
describe('integration', () => {
  it('should work end-to-end', async () => {
    const service = new Service(config);
    const result = await service.process(data);
    expect(result.success).toBe(true);
  });
});
```

## Build Configuration

### tsup Config
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
});
```

### Package.json Exports
```json
{
  "main": "./dist/index.js",
  "module": "./dist/index.mjs",
  "types": "./dist/index.d.ts",
  "exports": {
    ".": {
      "require": "./dist/index.js",
      "import": "./dist/index.mjs",
      "types": "./dist/index.d.ts"
    }
  }
}
```

## Commands
```bash
npm run build        # Build for production
npm run dev          # Build in watch mode
npm run test         # Run tests
npm run test:watch   # Run tests in watch mode
npm run test:coverage # Generate coverage report
npm run lint         # Run ESLint
npm run type-check   # Run TypeScript checks
npm run prepublishOnly # Pre-publish checks
```

## Documentation

### JSDoc Comments
All public APIs should have JSDoc comments:
- Description of what it does
- `@param` for each parameter
- `@returns` for return value
- `@throws` for possible errors
- `@example` with usage example

### README.md
Keep README.md updated with:
- Installation instructions
- Quick start guide
- API reference (or link to docs)
- Examples
- Contributing guidelines

## Publishing

### Pre-publish Checklist
- [ ] All tests pass
- [ ] Build succeeds
- [ ] Version bumped in package.json
- [ ] CHANGELOG.md updated
- [ ] README.md up to date
- [ ] Types are exported correctly
- [ ] Examples work

### npm Publish
```bash
npm run build
npm run test
npm version [patch|minor|major]
npm publish
```

### Versioning
Follow semantic versioning:
- **MAJOR** - Breaking changes
- **MINOR** - New features (backward compatible)
- **PATCH** - Bug fixes

## Code Style

### TypeScript
- Use strict mode
- Prefer interfaces over types for objects
- Export all public types
- Use generics when appropriate

### Functions
- Pure functions when possible
- Single responsibility
- Descriptive names
- Validate inputs

### Async/Await
- Use async/await over promises
- Handle errors properly
- Consider timeouts for external operations

## Performance

### Best Practices
- Avoid blocking operations
- Use streams for large data
- Cache when appropriate
- Consider memory usage

### Benchmarks
```bash
npm run benchmark    # Run performance benchmarks
```

## Examples

### Basic Usage
```typescript
import { functionName } from '[library-name]';

const result = functionName('input');
console.log(result);
```

### Advanced Usage
```typescript
import { ClassName, type Config } from '[library-name]';

const config: Config = {
  option1: 'value',
  option2: 42,
};

const instance = new ClassName(config);
await instance.method();
```

## Contributing

### Development Setup
```bash
git clone [repository-url]
cd [library-name]
npm install
npm run dev
```

### Making Changes
1. Create feature branch
2. Make changes with tests
3. Run tests and lint
4. Update documentation
5. Submit pull request

## Maintenance

### Dependency Updates
```bash
npm outdated          # Check for updates
npm update            # Update dependencies
npm audit             # Check for vulnerabilities
```

### Breaking Changes
When introducing breaking changes:
1. Document in CHANGELOG.md
2. Bump major version
3. Provide migration guide
4. Consider deprecation warnings first

---

## Notes
[Any additional library-specific notes, conventions, or important information]

## Resources
- [Node.js Documentation](https://nodejs.org/docs)
- [TypeScript Documentation](https://www.typescriptlang.org/docs)
- [npm Documentation](https://docs.npmjs.com)
