# [Project Name] - Project Documentation

## Overview
[Brief description of what this application does and its primary purpose]

## Tech Stack
- **Next.js 14+** with App Router (Turbopack enabled)
- **TypeScript** for type safety
- **[Styling Solution]** - CSS Modules / Tailwind CSS / styled-components
- **[Database]** - PostgreSQL / MongoDB / etc.
- **[ORM]** - Drizzle / Prisma / etc.
- **[Data Fetching]** - SWR / React Query / etc.
- **[Validation]** - Zod / Yup / etc.
- **[Auth]** - NextAuth / Clerk / custom
- **[Deployment]** - Vercel / Netlify / AWS

## Project Structure
```
app/
├── (public)/              # Public routes
│   ├── page.tsx           # Landing page
│   └── about/
├── (protected)/           # Auth-required routes
│   ├── dashboard/
│   └── settings/
├── api/                   # API routes
│   ├── auth/
│   ├── users/
│   └── [resource]/
└── layout.tsx             # Root layout

src/
├── components/
│   ├── common/            # Reusable UI components
│   ├── layout/            # Header, Footer, Navigation
│   └── [feature]/         # Feature-specific components
├── context/               # React Context providers
├── hooks/                 # Custom React hooks
├── types/                 # TypeScript type definitions
├── utils/                 # Utility functions
└── lib/                   # Library configurations

[Database Directory - e.g., drizzle/]
├── schema/                # Database schemas
├── migrations/            # Migration files
└── index.ts               # Database client
```

## API Patterns

### Client-Side API Calls
Use the API wrapper from `hooks/useApi.ts`:
```typescript
import { api } from '@/hooks/useApi';

// GET request
const { data } = await api.get<ResponseType>('/api/endpoint');

// POST request
const result = await api.post<ResponseType>('/api/endpoint', {
  field: value
});

// PATCH request
await api.patch(`/api/endpoint/${id}`, { status: 'updated' });

// DELETE request
await api.delete(`/api/endpoint/${id}`);
```

### Server-Side API Routes
Location: `app/api/[resource]/route.ts`

Pattern for protected routes:
```typescript
import { z } from 'zod';
import { withAuth, jsonResponse, errorResponse } from '@/lib/api-utils';

const createSchema = z.object({
  title: z.string().min(1).max(500),
  description: z.string().optional(),
});

export const POST = withAuth(async (request, { user }) => {
  const body = await request.json();
  const validation = createSchema.safeParse(body);

  if (!validation.success) {
    return errorResponse(validation.error.errors[0].message, 400);
  }

  // Implementation
  const result = await createItem(validation.data);

  return jsonResponse({ item: result }, 201);
});
```

## Component Patterns

### Common Components
```typescript
// Button
<Button
  variant="primary"
  size="md"
  onClick={handleClick}
>
  Save
</Button>

// Input
<Input
  id="title"
  label="Title"
  value={value}
  onChange={(e) => setValue(e.target.value)}
  error={errors.title}
/>

// Modal
<Modal
  isOpen={isOpen}
  onClose={onClose}
  title="Modal Title"
>
  {/* content */}
</Modal>
```

## Styling Conventions
[Describe your styling approach - adjust based on your choice]

### CSS Modules
- **Pattern:** `ComponentName.module.css` next to component
- **CSS Variables** in `src/styles/global.css`:
  - Spacing: `--space-1` to `--space-8`
  - Typography: `--text-xs` to `--text-2xl`
  - Colors: `--color-bg`, `--color-primary`, `--color-text`
- **Theme switching** via `data-theme` attribute

### Tailwind CSS
- **Config:** `tailwind.config.js` with custom theme
- **Plugins:** [List any Tailwind plugins used]
- **Custom utilities:** [Document any custom utilities]

## Routes

### Public Routes
- `/` - Landing page
- `/about` - About page
- `/pricing` - Pricing page
- `/login` - Authentication
- `/register` - Sign up

### Protected Routes
- `/dashboard` - Main dashboard
- `/settings` - User settings
- `/profile` - User profile

### Admin Routes (if applicable)
- `/admin` - Admin dashboard
- `/admin/users` - User management
- `/admin/settings` - System settings

## Key Files
| Purpose | File |
|---------|------|
| Types | `src/types/index.ts` |
| API client | `hooks/useApi.ts` |
| Auth utilities | `lib/auth.ts` |
| API helpers | `lib/api-utils.ts` |
| Database client | `[db-dir]/index.ts` |
| Header/Nav | `src/components/layout/Header.tsx` |

## Environment Variables
Create `.env.local` with:
```bash
# Database
DATABASE_URL=

# Auth
NEXTAUTH_SECRET=
NEXTAUTH_URL=

# [Other services]
# ...
```

## Commands
```bash
npm run dev          # Start dev server (Turbopack)
npm run build        # Production build
npm run start        # Start production server
npm run lint         # Run ESLint
npm run type-check   # Run TypeScript checks
```

## Database
[Adjust based on your ORM choice]

### Drizzle ORM
```typescript
import { db, eq } from '@/drizzle';
import { users } from '@/drizzle/schema';

// SELECT
const user = await db.query.users.findFirst({
  where: eq(users.id, userId),
});

// INSERT
const [created] = await db.insert(users)
  .values({ name, email })
  .returning();

// UPDATE
const [updated] = await db.update(users)
  .set({ name: newName })
  .where(eq(users.id, id))
  .returning();

// DELETE
await db.delete(users).where(eq(users.id, id));
```

## Authentication
[Describe your auth approach]

Example with NextAuth:
```typescript
// Protecting routes
import { getServerSession } from 'next-auth';
import { authOptions } from '@/lib/auth';

const session = await getServerSession(authOptions);
if (!session) {
  redirect('/login');
}
```

## Adding New Features

1. **Add Types** to `src/types/index.ts`
2. **Create API Routes** in `app/api/[resource]/route.ts`
3. **Create Components** in `src/components/[feature]/`
4. **Add Page** in `app/(protected)/[feature]/page.tsx`
5. **Update Navigation** in `src/components/layout/Header.tsx`

## Code Style

### TypeScript
- Use strict mode
- Prefer interfaces over types for objects
- Export types from `src/types/index.ts`

### Components
- Functional components with TypeScript
- Props interfaces for all components
- Default exports for pages, named exports for components

### API Routes
- Always validate input with Zod
- Use `withAuth` for protected routes
- Return consistent response format
- Handle errors gracefully

## Testing
[Add testing approach if applicable]

```bash
npm run test        # Run tests
npm run test:watch  # Watch mode
npm run test:coverage # Coverage report
```

## Deployment
[Deployment-specific instructions]

**Vercel:**
1. Connect GitHub repository
2. Configure environment variables
3. Deploy automatically on push to main

---

## Notes
[Any additional project-specific notes, conventions, or important information]

## Resources
- [Next.js Documentation](https://nextjs.org/docs)
- [TypeScript Documentation](https://www.typescriptlang.org/docs)
- [Project-specific resources]
