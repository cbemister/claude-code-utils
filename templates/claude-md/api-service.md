# [API Service Name] - Project Documentation

## Overview
[Brief description of what this API service does and its primary purpose]

## Tech Stack
- **Node.js** [version]
- **[Framework]** - Express / Fastify / NestJS / Hono
- **TypeScript** for type safety
- **[Database]** - PostgreSQL / MongoDB / MySQL
- **[ORM/Query Builder]** - Drizzle / Prisma / TypeORM / Mongoose
- **[Validation]** - Zod / Joi / class-validator
- **[Auth]** - JWT / Passport / custom
- **[Testing]** - Vitest / Jest / Supertest
- **[Documentation]** - Swagger / OpenAPI

## Project Structure
```
src/
├── index.ts               # Application entry point
├── app.ts                 # Express/Fastify app setup
├── server.ts              # HTTP server startup
├── routes/                # Route definitions
│   ├── index.ts           # Route aggregation
│   ├── auth.ts
│   ├── users.ts
│   └── [resource].ts
├── controllers/           # Request handlers
│   ├── auth.controller.ts
│   ├── users.controller.ts
│   └── [resource].controller.ts
├── services/              # Business logic
│   ├── auth.service.ts
│   ├── users.service.ts
│   └── [resource].service.ts
├── middleware/            # Custom middleware
│   ├── auth.ts            # Authentication
│   ├── validate.ts        # Request validation
│   ├── error-handler.ts   # Error handling
│   └── logger.ts          # Request logging
├── models/                # Database models/schemas
│   ├── user.model.ts
│   └── [resource].model.ts
├── types/                 # TypeScript types
│   ├── index.ts
│   ├── request.ts
│   └── response.ts
├── utils/                 # Utility functions
│   ├── db.ts              # Database connection
│   ├── logger.ts          # Logging utility
│   └── helpers.ts
├── config/                # Configuration
│   ├── index.ts
│   ├── database.ts
│   └── auth.ts
└── __tests__/             # Tests
    ├── integration/
    └── unit/
```

## API Routes

### Route Organization
Routes are organized by resource:

| Method | Endpoint | Description | Auth |
|--------|----------|-------------|------|
| POST | `/api/auth/register` | Create new user | Public |
| POST | `/api/auth/login` | Login user | Public |
| POST | `/api/auth/refresh` | Refresh token | Public |
| GET | `/api/users` | List users | Admin |
| GET | `/api/users/:id` | Get user by ID | Authenticated |
| PUT | `/api/users/:id` | Update user | Owner/Admin |
| DELETE | `/api/users/:id` | Delete user | Admin |

### Base URL
- Development: `http://localhost:3000`
- Production: `https://api.example.com`

All API routes are prefixed with `/api/v1`

## Route Definition Pattern

### Express Example
```typescript
// src/routes/users.ts
import { Router } from 'express';
import { authenticate, authorize } from '../middleware/auth';
import { validate } from '../middleware/validate';
import * as userController from '../controllers/users.controller';
import { createUserSchema, updateUserSchema } from '../schemas/user.schema';

const router = Router();

router.get(
  '/',
  authenticate,
  authorize(['admin']),
  userController.listUsers
);

router.get(
  '/:id',
  authenticate,
  userController.getUserById
);

router.post(
  '/',
  authenticate,
  authorize(['admin']),
  validate(createUserSchema),
  userController.createUser
);

router.put(
  '/:id',
  authenticate,
  validate(updateUserSchema),
  userController.updateUser
);

export default router;
```

### Fastify Example
```typescript
// src/routes/users.ts
import { FastifyInstance } from 'fastify';
import * as userController from '../controllers/users.controller';
import { createUserSchema, updateUserSchema } from '../schemas/user.schema';

export async function userRoutes(app: FastifyInstance) {
  app.get(
    '/',
    {
      preHandler: [app.authenticate, app.authorize(['admin'])],
    },
    userController.listUsers
  );

  app.post(
    '/',
    {
      preHandler: [app.authenticate, app.authorize(['admin'])],
      schema: { body: createUserSchema },
    },
    userController.createUser
  );
}
```

## Controller Pattern

### Request Handler Structure
```typescript
// src/controllers/users.controller.ts
import { Request, Response, NextFunction } from 'express';
import * as userService from '../services/users.service';
import { CreateUserInput, UpdateUserInput } from '../types';

export async function listUsers(
  req: Request,
  res: Response,
  next: NextFunction
) {
  try {
    const { page = 1, limit = 20 } = req.query;
    const users = await userService.listUsers({
      page: Number(page),
      limit: Number(limit),
    });

    res.json({
      data: users,
      pagination: {
        page: Number(page),
        limit: Number(limit),
        total: users.length,
      },
    });
  } catch (error) {
    next(error);
  }
}

export async function getUserById(
  req: Request,
  res: Response,
  next: NextFunction
) {
  try {
    const { id } = req.params;
    const user = await userService.getUserById(id);

    if (!user) {
      return res.status(404).json({
        error: {
          code: 'USER_NOT_FOUND',
          message: 'User not found',
        },
      });
    }

    res.json({ data: user });
  } catch (error) {
    next(error);
  }
}

export async function createUser(
  req: Request<{}, {}, CreateUserInput>,
  res: Response,
  next: NextFunction
) {
  try {
    const user = await userService.createUser(req.body);
    res.status(201).json({ data: user });
  } catch (error) {
    next(error);
  }
}
```

## Service Layer Pattern

### Business Logic Separation
```typescript
// src/services/users.service.ts
import { db } from '../utils/db';
import { users } from '../models/user.model';
import { CreateUserInput, UpdateUserInput } from '../types';
import { hashPassword } from '../utils/crypto';
import { eq } from 'drizzle-orm';

export async function listUsers(options: PaginationOptions) {
  const { page, limit } = options;
  const offset = (page - 1) * limit;

  return db.query.users.findMany({
    limit,
    offset,
    columns: {
      password: false, // Exclude sensitive fields
    },
  });
}

export async function getUserById(id: string) {
  return db.query.users.findFirst({
    where: eq(users.id, id),
    columns: {
      password: false,
    },
  });
}

export async function createUser(input: CreateUserInput) {
  const hashedPassword = await hashPassword(input.password);

  const [user] = await db
    .insert(users)
    .values({
      ...input,
      password: hashedPassword,
    })
    .returning({
      id: users.id,
      email: users.email,
      name: users.name,
      createdAt: users.createdAt,
    });

  return user;
}

export async function updateUser(id: string, input: UpdateUserInput) {
  const [user] = await db
    .update(users)
    .set({
      ...input,
      updatedAt: new Date(),
    })
    .where(eq(users.id, id))
    .returning();

  return user;
}

export async function deleteUser(id: string) {
  await db.delete(users).where(eq(users.id, id));
}
```

## Middleware

### Authentication Middleware
```typescript
// src/middleware/auth.ts
import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';
import { config } from '../config';

export interface AuthRequest extends Request {
  user?: {
    id: string;
    email: string;
    role: string;
  };
}

export async function authenticate(
  req: AuthRequest,
  res: Response,
  next: NextFunction
) {
  try {
    const token = req.headers.authorization?.replace('Bearer ', '');

    if (!token) {
      return res.status(401).json({
        error: {
          code: 'UNAUTHORIZED',
          message: 'No token provided',
        },
      });
    }

    const decoded = jwt.verify(token, config.jwtSecret) as {
      id: string;
      email: string;
      role: string;
    };

    req.user = decoded;
    next();
  } catch (error) {
    res.status(401).json({
      error: {
        code: 'INVALID_TOKEN',
        message: 'Invalid or expired token',
      },
    });
  }
}

export function authorize(roles: string[]) {
  return (req: AuthRequest, res: Response, next: NextFunction) => {
    if (!req.user) {
      return res.status(401).json({
        error: {
          code: 'UNAUTHORIZED',
          message: 'User not authenticated',
        },
      });
    }

    if (!roles.includes(req.user.role)) {
      return res.status(403).json({
        error: {
          code: 'FORBIDDEN',
          message: 'Insufficient permissions',
        },
      });
    }

    next();
  };
}
```

### Validation Middleware
```typescript
// src/middleware/validate.ts
import { Request, Response, NextFunction } from 'express';
import { ZodSchema, ZodError } from 'zod';

export function validate(schema: ZodSchema) {
  return (req: Request, res: Response, next: NextFunction) => {
    try {
      req.body = schema.parse(req.body);
      next();
    } catch (error) {
      if (error instanceof ZodError) {
        res.status(400).json({
          error: {
            code: 'VALIDATION_ERROR',
            message: 'Invalid request data',
            details: error.errors.map((e) => ({
              field: e.path.join('.'),
              message: e.message,
            })),
          },
        });
      } else {
        next(error);
      }
    }
  };
}
```

### Error Handler Middleware
```typescript
// src/middleware/error-handler.ts
import { Request, Response, NextFunction } from 'express';
import { logger } from '../utils/logger';

export class AppError extends Error {
  constructor(
    public statusCode: number,
    public code: string,
    message: string
  ) {
    super(message);
    this.name = 'AppError';
  }
}

export function errorHandler(
  error: Error | AppError,
  req: Request,
  res: Response,
  next: NextFunction
) {
  logger.error(error);

  if (error instanceof AppError) {
    return res.status(error.statusCode).json({
      error: {
        code: error.code,
        message: error.message,
      },
    });
  }

  // Unhandled errors
  res.status(500).json({
    error: {
      code: 'INTERNAL_SERVER_ERROR',
      message: process.env.NODE_ENV === 'production'
        ? 'An unexpected error occurred'
        : error.message,
    },
  });
}
```

## Request Validation Schemas

### Zod Schemas
```typescript
// src/schemas/user.schema.ts
import { z } from 'zod';

export const createUserSchema = z.object({
  email: z.string().email(),
  password: z.string().min(8).max(100),
  name: z.string().min(1).max(255),
  role: z.enum(['user', 'admin']).default('user'),
});

export const updateUserSchema = z.object({
  email: z.string().email().optional(),
  name: z.string().min(1).max(255).optional(),
  role: z.enum(['user', 'admin']).optional(),
});

export const loginSchema = z.object({
  email: z.string().email(),
  password: z.string(),
});

export type CreateUserInput = z.infer<typeof createUserSchema>;
export type UpdateUserInput = z.infer<typeof updateUserSchema>;
export type LoginInput = z.infer<typeof loginSchema>;
```

## Response Format

### Success Response
```json
{
  "data": {
    "id": "123",
    "email": "user@example.com",
    "name": "John Doe"
  }
}
```

### Success with Pagination
```json
{
  "data": [...],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 100,
    "totalPages": 5
  }
}
```

### Error Response
```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid request data",
    "details": [
      {
        "field": "email",
        "message": "Invalid email format"
      }
    ]
  }
}
```

## Database

### Connection Setup
```typescript
// src/utils/db.ts
import { drizzle } from 'drizzle-orm/node-postgres';
import { Pool } from 'pg';
import * as schema from '../models';
import { config } from '../config';

const pool = new Pool({
  connectionString: config.databaseUrl,
});

export const db = drizzle(pool, { schema });

export async function connectDatabase() {
  try {
    await pool.connect();
    console.log('✓ Database connected');
  } catch (error) {
    console.error('✖ Database connection failed:', error);
    process.exit(1);
  }
}
```

### Model Definition
```typescript
// src/models/user.model.ts
import { pgTable, uuid, varchar, timestamp, text } from 'drizzle-orm/pg-core';

export const users = pgTable('users', {
  id: uuid('id').defaultRandom().primaryKey(),
  email: varchar('email', { length: 255 }).notNull().unique(),
  password: text('password').notNull(),
  name: varchar('name', { length: 255 }).notNull(),
  role: varchar('role', { length: 50 }).notNull().default('user'),
  createdAt: timestamp('created_at').defaultNow().notNull(),
  updatedAt: timestamp('updated_at').defaultNow().notNull(),
});

export type User = typeof users.$inferSelect;
export type NewUser = typeof users.$inferInsert;
```

## Authentication

### JWT Token Generation
```typescript
// src/services/auth.service.ts
import jwt from 'jsonwebtoken';
import { config } from '../config';
import { comparePassword, hashPassword } from '../utils/crypto';
import * as userService from './users.service';

export async function login(email: string, password: string) {
  const user = await userService.getUserByEmail(email);

  if (!user) {
    throw new AppError(401, 'INVALID_CREDENTIALS', 'Invalid credentials');
  }

  const isValid = await comparePassword(password, user.password);

  if (!isValid) {
    throw new AppError(401, 'INVALID_CREDENTIALS', 'Invalid credentials');
  }

  const token = jwt.sign(
    {
      id: user.id,
      email: user.email,
      role: user.role,
    },
    config.jwtSecret,
    { expiresIn: config.jwtExpiration }
  );

  const refreshToken = jwt.sign(
    { id: user.id },
    config.jwtRefreshSecret,
    { expiresIn: '7d' }
  );

  return { token, refreshToken };
}
```

## Logging

### Logger Setup
```typescript
// src/utils/logger.ts
import winston from 'winston';

export const logger = winston.createLogger({
  level: process.env.LOG_LEVEL || 'info',
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.json()
  ),
  transports: [
    new winston.transports.Console({
      format: winston.format.combine(
        winston.format.colorize(),
        winston.format.simple()
      ),
    }),
    new winston.transports.File({
      filename: 'logs/error.log',
      level: 'error',
    }),
    new winston.transports.File({
      filename: 'logs/combined.log',
    }),
  ],
});
```

### Request Logging
```typescript
// src/middleware/logger.ts
import { Request, Response, NextFunction } from 'express';
import { logger } from '../utils/logger';

export function requestLogger(
  req: Request,
  res: Response,
  next: NextFunction
) {
  const start = Date.now();

  res.on('finish', () => {
    const duration = Date.now() - start;
    logger.info({
      method: req.method,
      url: req.url,
      status: res.statusCode,
      duration: `${duration}ms`,
      userAgent: req.headers['user-agent'],
    });
  });

  next();
}
```

## Testing

### Integration Tests
```typescript
// src/__tests__/integration/users.test.ts
import request from 'supertest';
import { app } from '../../app';
import { db } from '../../utils/db';
import { users } from '../../models/user.model';

describe('Users API', () => {
  beforeEach(async () => {
    await db.delete(users);
  });

  describe('POST /api/users', () => {
    it('should create a new user', async () => {
      const response = await request(app)
        .post('/api/users')
        .send({
          email: 'test@example.com',
          password: 'password123',
          name: 'Test User',
        })
        .expect(201);

      expect(response.body.data).toMatchObject({
        email: 'test@example.com',
        name: 'Test User',
      });
      expect(response.body.data.password).toBeUndefined();
    });

    it('should validate email format', async () => {
      const response = await request(app)
        .post('/api/users')
        .send({
          email: 'invalid-email',
          password: 'password123',
          name: 'Test User',
        })
        .expect(400);

      expect(response.body.error.code).toBe('VALIDATION_ERROR');
    });
  });
});
```

### Unit Tests
```typescript
// src/__tests__/unit/auth.service.test.ts
import { describe, it, expect, vi } from 'vitest';
import * as authService from '../../services/auth.service';
import * as userService from '../../services/users.service';

vi.mock('../../services/users.service');

describe('auth.service', () => {
  describe('login', () => {
    it('should return token on valid credentials', async () => {
      vi.mocked(userService.getUserByEmail).mockResolvedValue({
        id: '1',
        email: 'test@example.com',
        password: 'hashed_password',
        role: 'user',
      });

      const result = await authService.login(
        'test@example.com',
        'password123'
      );

      expect(result).toHaveProperty('token');
      expect(result).toHaveProperty('refreshToken');
    });

    it('should throw on invalid credentials', async () => {
      vi.mocked(userService.getUserByEmail).mockResolvedValue(null);

      await expect(
        authService.login('test@example.com', 'wrong')
      ).rejects.toThrow('INVALID_CREDENTIALS');
    });
  });
});
```

## Environment Variables

Create `.env` file:
```bash
# Server
NODE_ENV=development
PORT=3000
API_VERSION=v1

# Database
DATABASE_URL=postgresql://user:pass@localhost:5432/dbname

# JWT
JWT_SECRET=your-secret-key-here
JWT_EXPIRATION=1d
JWT_REFRESH_SECRET=your-refresh-secret-here

# CORS
CORS_ORIGIN=http://localhost:3000

# Logging
LOG_LEVEL=info

# Rate Limiting
RATE_LIMIT_WINDOW_MS=900000
RATE_LIMIT_MAX_REQUESTS=100
```

## Commands
```bash
npm run dev          # Development server with auto-reload
npm run build        # Build for production
npm run start        # Start production server
npm run test         # Run tests
npm run test:watch   # Run tests in watch mode
npm run test:coverage # Generate coverage report
npm run lint         # Run ESLint
npm run format       # Format with Prettier
npm run db:generate  # Generate Drizzle migrations
npm run db:push      # Push schema changes
npm run db:studio    # Open Drizzle Studio
```

## Key Files
| Purpose | File |
|---------|------|
| App setup | `src/app.ts` |
| Server entry | `src/index.ts` |
| Database client | `src/utils/db.ts` |
| Route aggregation | `src/routes/index.ts` |
| Error handling | `src/middleware/error-handler.ts` |
| Auth middleware | `src/middleware/auth.ts` |
| Validation schemas | `src/schemas/` |

## Code Style

### Controllers
- Keep controllers thin, delegate to services
- Always use try/catch with next(error)
- Return consistent response format

### Services
- All business logic goes here
- Return data, don't handle HTTP responses
- Throw AppError for expected errors

### Middleware
- Single responsibility per middleware
- Use next() to pass control
- Handle errors appropriately

---

## Notes
[Any additional API-specific conventions, third-party integrations, or important information]

## Resources
- [Express Documentation](https://expressjs.com/)
- [Fastify Documentation](https://www.fastify.io/)
- [Drizzle ORM Documentation](https://orm.drizzle.team/)
- [Zod Documentation](https://zod.dev/)
