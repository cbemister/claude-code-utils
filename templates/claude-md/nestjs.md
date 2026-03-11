# [Project Name] - Project Documentation

## Overview
[Brief description of what this NestJS application does and its primary purpose]

## Tech Stack
- **NestJS** [version, e.g., 10+] with **TypeScript** strict mode
- **TypeORM** with **PostgreSQL**
- **Swagger / OpenAPI** for API documentation
- **class-validator** and **class-transformer** for DTO validation
- **Passport.js** with JWT strategy for authentication
- **Jest** for unit and e2e testing
- **ESLint** and **Prettier** for code quality
- **[Deployment]** - Docker / Railway / AWS ECS

## Project Structure
```
src/
├── main.ts                    # Bootstrap, Swagger setup, global pipes
├── app.module.ts              # Root module
├── config/
│   ├── configuration.ts       # Typed config factory
│   └── database.config.ts     # TypeORM config
├── modules/
│   ├── auth/
│   │   ├── auth.module.ts
│   │   ├── auth.controller.ts
│   │   ├── auth.service.ts
│   │   ├── dto/
│   │   │   ├── login.dto.ts
│   │   │   └── register.dto.ts
│   │   └── strategies/
│   │       └── jwt.strategy.ts
│   └── [feature]/
│       ├── [feature].module.ts
│       ├── [feature].controller.ts
│       ├── [feature].service.ts
│       ├── [feature].repository.ts   # Optional custom repo
│       ├── dto/
│       │   ├── create-[feature].dto.ts
│       │   └── update-[feature].dto.ts
│       └── entities/
│           └── [feature].entity.ts
├── common/
│   ├── decorators/            # Custom decorators
│   │   └── current-user.decorator.ts
│   ├── filters/               # Exception filters
│   │   └── http-exception.filter.ts
│   ├── guards/                # Auth guards
│   │   └── jwt-auth.guard.ts
│   ├── interceptors/          # Response interceptors
│   │   └── transform.interceptor.ts
│   └── pipes/                 # Validation pipes
│       └── parse-id.pipe.ts
└── database/
    └── migrations/            # TypeORM migrations

test/
├── app.e2e-spec.ts
└── jest-e2e.json
```

## Bootstrap

```typescript
// src/main.ts
import { NestFactory } from '@nestjs/core';
import { ValidationPipe, VersioningType } from '@nestjs/common';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // Global validation pipe
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,           // Strip unknown properties
      forbidNonWhitelisted: true,
      transform: true,           // Auto-transform to DTO types
      transformOptions: { enableImplicitConversion: true },
    }),
  );

  // API versioning
  app.enableVersioning({ type: VersioningType.URI });

  // Swagger
  const config = new DocumentBuilder()
    .setTitle('[Project Name] API')
    .setDescription('[API description]')
    .setVersion('1.0')
    .addBearerAuth()
    .build();

  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api/docs', app, document);

  app.enableCors();
  await app.listen(process.env.PORT ?? 3000);
}

bootstrap();
```

## Modules

### Feature Module Pattern
```typescript
// src/modules/items/items.module.ts
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ItemsController } from './items.controller';
import { ItemsService } from './items.service';
import { Item } from './entities/item.entity';

@Module({
  imports: [TypeOrmModule.forFeature([Item])],
  controllers: [ItemsController],
  providers: [ItemsService],
  exports: [ItemsService],
})
export class ItemsModule {}
```

## Entities (TypeORM)

```typescript
// src/modules/items/entities/item.entity.ts
import {
  Entity, PrimaryGeneratedColumn, Column, ManyToOne,
  CreateDateColumn, UpdateDateColumn, Index,
} from 'typeorm';
import { User } from '../../auth/entities/user.entity';

export enum ItemStatus {
  DRAFT = 'draft',
  PUBLISHED = 'published',
  ARCHIVED = 'archived',
}

@Entity('items')
export class Item {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ length: 255 })
  title: string;

  @Column({ type: 'text', nullable: true })
  description: string | null;

  @Column({ type: 'enum', enum: ItemStatus, default: ItemStatus.DRAFT })
  status: ItemStatus;

  @ManyToOne(() => User, (user) => user.items, { onDelete: 'CASCADE' })
  @Index()
  owner: User;

  @Column()
  ownerId: string;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
```

## DTOs with class-validator

```typescript
// src/modules/items/dto/create-item.dto.ts
import { IsString, IsOptional, IsEnum, MinLength, MaxLength } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { ItemStatus } from '../entities/item.entity';

export class CreateItemDto {
  @ApiProperty({ description: 'Item title', minLength: 1, maxLength: 255 })
  @IsString()
  @MinLength(1)
  @MaxLength(255)
  title: string;

  @ApiPropertyOptional({ description: 'Item description' })
  @IsString()
  @IsOptional()
  description?: string;

  @ApiPropertyOptional({ enum: ItemStatus, default: ItemStatus.DRAFT })
  @IsEnum(ItemStatus)
  @IsOptional()
  status?: ItemStatus;
}

// src/modules/items/dto/update-item.dto.ts
import { PartialType } from '@nestjs/swagger';
import { CreateItemDto } from './create-item.dto';

export class UpdateItemDto extends PartialType(CreateItemDto) {}
```

## Controllers

```typescript
// src/modules/items/items.controller.ts
import {
  Controller, Get, Post, Patch, Delete, Body, Param,
  ParseUUIDPipe, UseGuards, HttpCode, HttpStatus,
} from '@nestjs/common';
import { ApiTags, ApiBearerAuth, ApiOperation } from '@nestjs/swagger';
import { JwtAuthGuard } from '../../common/guards/jwt-auth.guard';
import { CurrentUser } from '../../common/decorators/current-user.decorator';
import { ItemsService } from './items.service';
import { CreateItemDto } from './dto/create-item.dto';
import { UpdateItemDto } from './dto/update-item.dto';

@ApiTags('Items')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller({ path: 'items', version: '1' })
export class ItemsController {
  constructor(private readonly itemsService: ItemsService) {}

  @ApiOperation({ summary: 'List all items for the current user' })
  @Get()
  findAll(@CurrentUser('id') userId: string) {
    return this.itemsService.findAll(userId);
  }

  @ApiOperation({ summary: 'Get a single item' })
  @Get(':id')
  findOne(@Param('id', ParseUUIDPipe) id: string, @CurrentUser('id') userId: string) {
    return this.itemsService.findOne(id, userId);
  }

  @ApiOperation({ summary: 'Create a new item' })
  @Post()
  create(@Body() dto: CreateItemDto, @CurrentUser('id') userId: string) {
    return this.itemsService.create(dto, userId);
  }

  @ApiOperation({ summary: 'Update an item' })
  @Patch(':id')
  update(
    @Param('id', ParseUUIDPipe) id: string,
    @Body() dto: UpdateItemDto,
    @CurrentUser('id') userId: string,
  ) {
    return this.itemsService.update(id, dto, userId);
  }

  @ApiOperation({ summary: 'Delete an item' })
  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  remove(@Param('id', ParseUUIDPipe) id: string, @CurrentUser('id') userId: string) {
    return this.itemsService.remove(id, userId);
  }
}
```

## Services

```typescript
// src/modules/items/items.service.ts
import { Injectable, NotFoundException, ForbiddenException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Item } from './entities/item.entity';
import { CreateItemDto } from './dto/create-item.dto';
import { UpdateItemDto } from './dto/update-item.dto';

@Injectable()
export class ItemsService {
  constructor(
    @InjectRepository(Item)
    private readonly itemRepository: Repository<Item>,
  ) {}

  findAll(ownerId: string): Promise<Item[]> {
    return this.itemRepository.find({
      where: { ownerId },
      order: { createdAt: 'DESC' },
    });
  }

  async findOne(id: string, ownerId: string): Promise<Item> {
    const item = await this.itemRepository.findOne({ where: { id } });
    if (!item) throw new NotFoundException(`Item ${id} not found`);
    if (item.ownerId !== ownerId) throw new ForbiddenException();
    return item;
  }

  async create(dto: CreateItemDto, ownerId: string): Promise<Item> {
    const item = this.itemRepository.create({ ...dto, ownerId });
    return this.itemRepository.save(item);
  }

  async update(id: string, dto: UpdateItemDto, ownerId: string): Promise<Item> {
    const item = await this.findOne(id, ownerId);
    Object.assign(item, dto);
    return this.itemRepository.save(item);
  }

  async remove(id: string, ownerId: string): Promise<void> {
    const item = await this.findOne(id, ownerId);
    await this.itemRepository.remove(item);
  }
}
```

## Configuration

```typescript
// src/config/configuration.ts
export default () => ({
  port: parseInt(process.env.PORT ?? '3000', 10),
  database: {
    host: process.env.DB_HOST ?? 'localhost',
    port: parseInt(process.env.DB_PORT ?? '5432', 10),
    username: process.env.DB_USERNAME ?? 'postgres',
    password: process.env.DB_PASSWORD,
    name: process.env.DB_NAME ?? 'myapp',
  },
  jwt: {
    secret: process.env.JWT_SECRET,
    expiresIn: process.env.JWT_EXPIRES_IN ?? '7d',
  },
});
```

## Environment Variables
Create `.env`:
```bash
PORT=3000

DB_HOST=localhost
DB_PORT=5432
DB_USERNAME=postgres
DB_PASSWORD=yourpassword
DB_NAME=myapp

JWT_SECRET=your-jwt-secret-min-32-characters
JWT_EXPIRES_IN=7d
```

## Key Files
| Purpose | File |
|---------|------|
| Bootstrap | `src/main.ts` |
| Root module | `src/app.module.ts` |
| Config | `src/config/configuration.ts` |
| JWT guard | `src/common/guards/jwt-auth.guard.ts` |
| Current user | `src/common/decorators/current-user.decorator.ts` |

## Commands
```bash
npm run start:dev            # Start with hot reload (nodemon)
npm run start:debug          # Start with debugger
npm run start:prod           # Start compiled app

npm run build                # Compile TypeScript
npm run test                 # Run unit tests
npm run test:watch           # Unit tests in watch mode
npm run test:cov             # Tests with coverage
npm run test:e2e             # Run end-to-end tests

npm run lint                 # ESLint
npm run format               # Prettier

# TypeORM migrations
npm run migration:generate -- src/database/migrations/MigrationName
npm run migration:run
npm run migration:revert
```

## Code Style

### TypeScript
- Strict mode enabled; no implicit `any`
- All service methods return typed values (use `Promise<Entity>`, not `Promise<any>`)
- DTOs always use class-validator decorators; never accept raw `object`

### NestJS Conventions
- One module per feature; modules register their own entities
- Services handle business logic; controllers handle HTTP concerns only
- Use `@HttpCode(HttpStatus.NO_CONTENT)` for delete endpoints
- Guard routes at the controller level; fine-tune with method-level decorators

---

## Notes
[Any additional project-specific notes, microservice setup, or important information]

## Resources
- [NestJS Documentation](https://docs.nestjs.com/)
- [TypeORM Documentation](https://typeorm.io/)
- [Swagger / OpenAPI with NestJS](https://docs.nestjs.com/openapi/introduction)
- [class-validator](https://github.com/typestack/class-validator)
