# [SvelteKit App Name] - Project Documentation

## Overview
[Brief description of what this application does and its primary purpose]

## Tech Stack
- **SvelteKit** with file-based routing
- **TypeScript** for type safety
- **[Styling]** - Tailwind CSS / CSS Modules / UnoCSS
- **[Database]** - PostgreSQL / SQLite / PlanetScale
- **[ORM]** - Drizzle / Prisma
- **[Forms]** - Superforms + Zod
- **[Auth]** - Lucia / Auth.js / custom
- **[Deployment]** - Vercel / Cloudflare Workers / Node

## Project Structure
```
src/
├── routes/
│   ├── +layout.svelte          # Root layout
│   ├── +layout.server.ts       # Server-side layout load
│   ├── +page.svelte            # Home page
│   ├── +page.server.ts         # Page server actions/load
│   ├── (app)/                  # Authenticated route group
│   │   ├── +layout.svelte
│   │   ├── +layout.server.ts   # Auth guard
│   │   ├── dashboard/
│   │   │   └── +page.svelte
│   │   └── settings/
│   │       └── +page.svelte
│   ├── (auth)/                 # Auth route group
│   │   ├── login/
│   │   └── register/
│   └── api/                    # API-only routes
│       └── [resource]/
│           └── +server.ts

src/lib/
├── components/                 # Reusable Svelte components
│   ├── ui/                     # Primitive UI components
│   │   ├── Button.svelte
│   │   ├── Input.svelte
│   │   └── Modal.svelte
│   └── [feature]/              # Feature-specific components
├── server/                     # Server-only code (never sent to client)
│   ├── db/                     # Database client and schema
│   │   ├── index.ts
│   │   └── schema.ts
│   ├── auth.ts                 # Auth helpers
│   └── [resource].ts           # Data access layer
├── stores/                     # Svelte writable/readable stores
│   └── user.ts
├── types/                      # Shared TypeScript types
│   └── index.ts
└── utils/                      # Shared utility functions
    └── index.ts

static/                         # Static assets (served as-is)
drizzle/                        # Drizzle migrations
svelte.config.js
vite.config.ts
```

## Key Patterns

### Page Load Function
```typescript
// src/routes/(app)/dashboard/+page.server.ts
import type { PageServerLoad } from './$types';
import { redirect } from '@sveltejs/kit';
import { db } from '$lib/server/db';
import { posts } from '$lib/server/db/schema';
import { eq } from 'drizzle-orm';

export const load: PageServerLoad = async ({ locals }) => {
    if (!locals.user) {
        redirect(302, '/login');
    }

    const userPosts = await db.query.posts.findMany({
        where: eq(posts.userId, locals.user.id),
        orderBy: (posts, { desc }) => [desc(posts.createdAt)],
    });

    return { posts: userPosts };
};
```

### Server Actions (Form Handling with Superforms)
```typescript
// src/routes/(app)/posts/new/+page.server.ts
import { superValidate, fail } from 'sveltekit-superforms';
import { zod } from 'sveltekit-superforms/adapters';
import { z } from 'zod';
import type { Actions, PageServerLoad } from './$types';
import { db } from '$lib/server/db';
import { posts } from '$lib/server/db/schema';

const createPostSchema = z.object({
    title: z.string().min(1).max(200),
    content: z.string().min(1),
    published: z.boolean().default(false),
});

export const load: PageServerLoad = async () => {
    const form = await superValidate(zod(createPostSchema));
    return { form };
};

export const actions: Actions = {
    default: async ({ request, locals }) => {
        const form = await superValidate(request, zod(createPostSchema));

        if (!form.valid) {
            return fail(400, { form });
        }

        await db.insert(posts).values({
            ...form.data,
            userId: locals.user.id,
        });

        return { form };
    },
};
```

### Page Component with Superforms
```svelte
<!-- src/routes/(app)/posts/new/+page.svelte -->
<script lang="ts">
    import { superForm } from 'sveltekit-superforms';
    import type { PageData } from './$types';

    export let data: PageData;

    const { form, errors, enhance, submitting } = superForm(data.form, {
        onUpdated({ form }) {
            if (form.valid) {
                // success handling
            }
        },
    });
</script>

<form method="POST" use:enhance>
    <div>
        <label for="title">Title</label>
        <input id="title" name="title" bind:value={$form.title} />
        {#if $errors.title}<p class="error">{$errors.title}</p>{/if}
    </div>

    <div>
        <label for="content">Content</label>
        <textarea id="content" name="content" bind:value={$form.content} />
        {#if $errors.content}<p class="error">{$errors.content}</p>{/if}
    </div>

    <button type="submit" disabled={$submitting}>
        {$submitting ? 'Saving...' : 'Create Post'}
    </button>
</form>
```

### API Route (JSON endpoint)
```typescript
// src/routes/api/posts/+server.ts
import { json, error } from '@sveltejs/kit';
import type { RequestHandler } from './$types';
import { db } from '$lib/server/db';
import { posts } from '$lib/server/db/schema';

export const GET: RequestHandler = async ({ locals, url }) => {
    if (!locals.user) {
        error(401, 'Unauthorized');
    }

    const limit = Number(url.searchParams.get('limit') ?? 20);
    const all = await db.query.posts.findMany({ limit });

    return json({ posts: all });
};

export const POST: RequestHandler = async ({ request, locals }) => {
    if (!locals.user) {
        error(401, 'Unauthorized');
    }

    const body = await request.json();
    const [post] = await db.insert(posts).values(body).returning();

    return json({ post }, { status: 201 });
};
```

### Svelte Store
```typescript
// src/lib/stores/notifications.ts
import { writable } from 'svelte/store';

export type Notification = {
    id: string;
    message: string;
    type: 'success' | 'error' | 'info';
};

function createNotifications() {
    const { subscribe, update } = writable<Notification[]>([]);

    return {
        subscribe,
        add(notification: Omit<Notification, 'id'>) {
            const id = crypto.randomUUID();
            update(n => [...n, { ...notification, id }]);
            setTimeout(() => this.remove(id), 4000);
        },
        remove(id: string) {
            update(n => n.filter(x => x.id !== id));
        },
    };
}

export const notifications = createNotifications();
```

### Drizzle Schema
```typescript
// src/lib/server/db/schema.ts
import { pgTable, text, timestamp, boolean, uuid } from 'drizzle-orm/pg-core';
import { relations } from 'drizzle-orm';

export const users = pgTable('users', {
    id: uuid('id').primaryKey().defaultRandom(),
    email: text('email').notNull().unique(),
    passwordHash: text('password_hash').notNull(),
    createdAt: timestamp('created_at').defaultNow().notNull(),
});

export const posts = pgTable('posts', {
    id: uuid('id').primaryKey().defaultRandom(),
    userId: uuid('user_id').references(() => users.id).notNull(),
    title: text('title').notNull(),
    content: text('content').notNull(),
    published: boolean('published').default(false).notNull(),
    createdAt: timestamp('created_at').defaultNow().notNull(),
});

export const usersRelations = relations(users, ({ many }) => ({
    posts: many(posts),
}));

export const postsRelations = relations(posts, ({ one }) => ({
    user: one(users, { fields: [posts.userId], references: [users.id] }),
}));
```

### Auth Guard in Layout
```typescript
// src/routes/(app)/+layout.server.ts
import { redirect } from '@sveltejs/kit';
import type { LayoutServerLoad } from './$types';

export const load: LayoutServerLoad = async ({ locals }) => {
    if (!locals.user) {
        redirect(302, '/login');
    }
    return { user: locals.user };
};
```

## Environment Variables
Create `.env` with:
```bash
# Database
DATABASE_URL=postgresql://user:password@localhost:5432/dbname

# Auth
AUTH_SECRET=your-secret-min-32-characters

# Public (exposed to client — prefix with PUBLIC_)
PUBLIC_APP_URL=http://localhost:5173
```

Access in code:
```typescript
import { DATABASE_URL, AUTH_SECRET } from '$env/static/private';
import { PUBLIC_APP_URL } from '$env/static/public';
// Or dynamic:
import { env } from '$env/dynamic/private';
```

## Key Files
| Purpose | File |
|---------|------|
| Types | `src/lib/types/index.ts` |
| Database client | `src/lib/server/db/index.ts` |
| Auth helpers | `src/lib/server/auth.ts` |
| Root layout | `src/routes/+layout.svelte` |
| Server hooks | `src/hooks.server.ts` |

## Commands
```bash
npm run dev          # Start dev server (HMR)
npm run build        # Production build
npm run preview      # Preview production build
npm run check        # svelte-check type checking
npm run check:watch  # Type check in watch mode
npm run lint         # Run ESLint + Prettier check
npm run format       # Format with Prettier
npm run test         # Run Vitest unit tests
npm run test:e2e     # Run Playwright tests (if configured)

# Drizzle ORM
npx drizzle-kit generate     # Generate migration from schema changes
npx drizzle-kit migrate      # Apply migrations
npx drizzle-kit studio       # Open Drizzle Studio (DB browser)
```

## Code Style

### Svelte Conventions
- `+page.server.ts` for server-only logic (load + actions)
- `+page.svelte` for UI — keep thin, delegate to components
- `src/lib/server/` for code that must never ship to the client
- Prefix public env vars with `PUBLIC_` — SvelteKit enforces this
- Use `$lib` alias instead of relative paths across the project

### TypeScript
- Import generated `$types` from `./$types` in every route file
- Use strict mode (enabled by default in SvelteKit)
- Colocate component types in the `.svelte` file's `<script>` block

---

## Notes
[Any additional project-specific conventions, third-party integrations, or important information]

## Resources
- [SvelteKit Documentation](https://kit.svelte.dev/docs)
- [Superforms Documentation](https://superforms.rocks/)
- [Drizzle ORM Documentation](https://orm.drizzle.team/)
- [Svelte Tutorial](https://learn.svelte.dev/)
