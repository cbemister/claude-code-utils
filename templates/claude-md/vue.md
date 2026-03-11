# [Nuxt App Name] - Project Documentation

## Overview
[Brief description of what this application does and its primary purpose]

## Tech Stack
- **Nuxt 3** with file-based routing
- **Vue 3** with Composition API (`<script setup>`)
- **TypeScript** for type safety
- **Pinia** for state management
- **[Styling]** - Tailwind CSS / Nuxt UI / UnoCSS
- **VueUse** for composable utilities
- **[Database]** - PostgreSQL / PlanetScale / Supabase
- **[Auth]** - Nuxt Auth Utils / Lucia / Clerk
- **[Deployment]** - Vercel / Cloudflare / Node

## Project Structure
```
pages/                          # File-based routing
├── index.vue                   # /
├── about.vue                   # /about
├── [...slug].vue               # Catch-all
├── (app)/                      # Route group (no path segment)
│   ├── dashboard.vue
│   └── settings/
│       └── index.vue
└── auth/
    ├── login.vue
    └── register.vue

components/                     # Auto-imported components
├── ui/                         # Primitive UI (Button, Input, etc.)
│   ├── Button.vue
│   └── Modal.vue
├── [Feature]/                  # Feature-specific components
│   └── PostCard.vue
└── layout/
    ├── AppHeader.vue
    └── AppFooter.vue

composables/                    # Auto-imported composables
├── useUser.ts
├── useApi.ts
└── usePosts.ts

stores/                         # Pinia stores (auto-imported)
├── user.ts
└── posts.ts

server/                         # Server-side code (Nitro)
├── api/                        # API routes
│   ├── users/
│   │   ├── index.get.ts        # GET /api/users
│   │   ├── index.post.ts       # POST /api/users
│   │   └── [id].get.ts         # GET /api/users/:id
│   └── auth/
│       ├── login.post.ts
│       └── logout.post.ts
├── middleware/                 # Server middleware
│   └── auth.ts
└── utils/                      # Server utility functions
    ├── db.ts
    └── auth.ts

layouts/                        # Named layouts
├── default.vue
└── auth.vue

middleware/                     # Route middleware (client + server)
├── auth.ts
└── guest.ts

plugins/                        # Nuxt plugins
└── toast.client.ts

public/                         # Static assets
nuxt.config.ts
```

## Key Patterns

### Page with Data Fetching
```vue
<!-- pages/(app)/dashboard.vue -->
<script setup lang="ts">
definePageMeta({
    middleware: 'auth',
    layout: 'default',
})

const { data: posts, status, error } = await useFetch('/api/posts', {
    query: { limit: 20 },
})
</script>

<template>
    <div>
        <div v-if="status === 'pending'">Loading...</div>
        <div v-else-if="error">Error: {{ error.message }}</div>
        <ul v-else>
            <li v-for="post in posts" :key="post.id">
                {{ post.title }}
            </li>
        </ul>
    </div>
</template>
```

### Composable Pattern
```typescript
// composables/usePosts.ts
export function usePosts() {
    const posts = useState<Post[]>('posts', () => [])

    async function fetchPosts(query?: { limit?: number }) {
        const data = await $fetch('/api/posts', { query })
        posts.value = data
        return data
    }

    async function createPost(payload: CreatePostInput) {
        const post = await $fetch('/api/posts', {
            method: 'POST',
            body: payload,
        })
        posts.value = [post, ...posts.value]
        return post
    }

    async function deletePost(id: string) {
        await $fetch(`/api/posts/${id}`, { method: 'DELETE' })
        posts.value = posts.value.filter(p => p.id !== id)
    }

    return {
        posts: readonly(posts),
        fetchPosts,
        createPost,
        deletePost,
    }
}
```

### Pinia Store
```typescript
// stores/user.ts
import { defineStore } from 'pinia'

interface UserState {
    user: User | null
    isLoading: boolean
}

export const useUserStore = defineStore('user', () => {
    const user = ref<User | null>(null)
    const isLoading = ref(false)

    const isAuthenticated = computed(() => user.value !== null)

    async function fetchCurrentUser() {
        isLoading.value = true
        try {
            user.value = await $fetch('/api/auth/me')
        } catch {
            user.value = null
        } finally {
            isLoading.value = false
        }
    }

    function logout() {
        user.value = null
    }

    return { user, isLoading, isAuthenticated, fetchCurrentUser, logout }
})
```

### Server API Route
```typescript
// server/api/posts/index.post.ts
import { z } from 'zod'

const createPostSchema = z.object({
    title: z.string().min(1).max(200),
    content: z.string().min(1),
})

export default defineEventHandler(async (event) => {
    const session = await requireUserSession(event)  // throws 401 if not authed

    const body = await readValidatedBody(event, createPostSchema.parse)

    const post = await db.post.create({
        data: {
            ...body,
            userId: session.user.id,
        },
    })

    setResponseStatus(event, 201)
    return post
})
```

### Route Middleware (Auth Guard)
```typescript
// middleware/auth.ts
export default defineNuxtRouteMiddleware(() => {
    const { loggedIn } = useUserSession()

    if (!loggedIn.value) {
        return navigateTo('/auth/login')
    }
})
```

### Component with VueUse
```vue
<!-- components/ui/Modal.vue -->
<script setup lang="ts">
import { onClickOutside } from '@vueuse/core'
import { useFocusTrap } from '@vueuse/integrations/useFocusTrap'

interface Props {
    open: boolean
    title: string
}

const props = defineProps<Props>()
const emit = defineEmits<{
    close: []
}>()

const container = ref<HTMLElement>()

onClickOutside(container, () => emit('close'))
const { activate, deactivate } = useFocusTrap(container)

watch(() => props.open, (open) => {
    if (open) activate()
    else deactivate()
})
</script>

<template>
    <Teleport to="body">
        <div v-if="open" class="overlay" role="dialog" aria-modal="true">
            <div ref="container" class="modal">
                <h2>{{ title }}</h2>
                <slot />
                <button @click="emit('close')">Close</button>
            </div>
        </div>
    </Teleport>
</template>
```

### Nuxt Configuration
```typescript
// nuxt.config.ts
export default defineNuxtConfig({
    devtools: { enabled: true },
    modules: [
        '@pinia/nuxt',
        '@vueuse/nuxt',
        '@nuxt/ui',       // or '@nuxtjs/tailwindcss'
        'nuxt-auth-utils',
    ],
    runtimeConfig: {
        // Private — server only
        databaseUrl: '',
        authSecret: '',
        // Public — exposed to client
        public: {
            appUrl: 'http://localhost:3000',
        },
    },
    typescript: {
        strict: true,
        typeCheck: true,
    },
})
```

## Environment Variables
Create `.env` with:
```bash
# Private (server-only)
NUXT_DATABASE_URL=postgresql://user:password@localhost:5432/dbname
NUXT_AUTH_SECRET=your-secret-min-32-characters

# Public (prefix NUXT_PUBLIC_ to expose to client)
NUXT_PUBLIC_APP_URL=http://localhost:3000
```

Access in server code:
```typescript
const config = useRuntimeConfig()
const url = config.databaseUrl          // server only
const appUrl = config.public.appUrl     // available everywhere
```

## Key Files
| Purpose | File |
|---------|------|
| Types | `types/index.ts` |
| App config | `nuxt.config.ts` |
| Server DB util | `server/utils/db.ts` |
| Auth middleware | `middleware/auth.ts` |
| Root layout | `layouts/default.vue` |

## Commands
```bash
npm run dev          # Start dev server with HMR
npm run build        # Production build
npm run start        # Start production server (after build)
npm run generate     # Generate static site
npm run preview      # Preview production build
nuxi typecheck       # TypeScript type checking
npm run lint         # Run ESLint
npm run test         # Run Vitest unit tests
```

## Code Style

### Vue 3 Conventions
- Always use `<script setup lang="ts">` — avoid Options API
- Use `defineProps<Props>()` generic form for type-safe props
- Use `defineEmits<{ eventName: [arg: Type] }>()` for typed emits
- Prefer `useFetch` (SSR-aware) over raw `$fetch` in components
- Use `useState` for server-hydrated shared state across components

### Nuxt Auto-Imports
- Components in `components/` are auto-imported — no import needed
- Composables in `composables/` are auto-imported
- Pinia stores in `stores/` are auto-imported via `@pinia/nuxt`
- VueUse functions are auto-imported via `@vueuse/nuxt`

### Naming Conventions
- Component files: `PascalCase.vue`
- Composables: `useFeatureName.ts`, exported as `useFeatureName()`
- Pinia stores: `useFeatureStore` pattern inside `stores/feature.ts`
- API routes: use HTTP method suffixes (`.get.ts`, `.post.ts`, `.delete.ts`)

---

## Notes
[Any additional project-specific conventions, third-party integrations, or important information]

## Resources
- [Nuxt 3 Documentation](https://nuxt.com/docs)
- [Vue 3 Documentation](https://vuejs.org/)
- [Pinia Documentation](https://pinia.vuejs.org/)
- [VueUse Documentation](https://vueuse.org/)
