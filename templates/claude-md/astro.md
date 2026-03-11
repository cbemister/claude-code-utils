# [Astro Site Name] - Project Documentation

## Overview
[Brief description of what this site does and its primary purpose — e.g., marketing site, blog, docs, hybrid app]

## Tech Stack
- **Astro 4+** with Islands architecture
- **TypeScript** for type safety
- **Tailwind CSS** for styling
- **MDX** for content with embedded components
- **Content Collections** for structured, type-safe content
- **[UI Framework]** - React / Vue / Svelte (for interactive islands)
- **[Deployment]** - Vercel / Netlify / Cloudflare Pages / Node

## Project Structure
```
src/
├── pages/                      # File-based routing
│   ├── index.astro             # /
│   ├── about.astro             # /about
│   ├── blog/
│   │   ├── index.astro         # /blog — listing page
│   │   └── [slug].astro        # /blog/:slug — dynamic route
│   └── [...slug].astro         # Catch-all (e.g., docs)
│
├── layouts/                    # Reusable page shells
│   ├── BaseLayout.astro        # <html>, <head>, global styles
│   ├── BlogLayout.astro        # Blog post wrapper
│   └── DocsLayout.astro        # Docs page with sidebar
│
├── components/                 # UI components
│   ├── ui/                     # Primitive components
│   │   ├── Button.astro
│   │   └── Card.astro
│   ├── blog/                   # Blog-specific components
│   │   ├── PostCard.astro
│   │   └── TagList.astro
│   └── interactive/            # Islands (React/Vue/Svelte)
│       ├── SearchBox.tsx       # client:load
│       └── Newsletter.tsx      # client:visible
│
├── content/                    # Content Collections
│   ├── config.ts               # Collection schemas (Zod)
│   ├── blog/                   # Blog posts (MDX/MD)
│   │   ├── first-post.mdx
│   │   └── second-post.md
│   └── docs/                   # Documentation (MDX/MD)
│       └── getting-started.mdx
│
├── styles/                     # Global styles
│   └── global.css
│
└── utils/                      # Shared utility functions
    └── index.ts

public/                         # Static assets (served as-is)
├── fonts/
└── og-image.png

astro.config.mjs
tailwind.config.mjs
tsconfig.json
```

## Key Patterns

### Content Collections Schema
```typescript
// src/content/config.ts
import { defineCollection, z } from 'astro:content';

const blog = defineCollection({
    type: 'content',  // MDX/MD files
    schema: z.object({
        title: z.string(),
        description: z.string(),
        pubDate: z.coerce.date(),
        updatedDate: z.coerce.date().optional(),
        author: z.string().default('Anonymous'),
        tags: z.array(z.string()).default([]),
        image: z.object({
            url: z.string(),
            alt: z.string(),
        }).optional(),
        draft: z.boolean().default(false),
    }),
});

const docs = defineCollection({
    type: 'content',
    schema: z.object({
        title: z.string(),
        description: z.string(),
        order: z.number(),
        section: z.string(),
    }),
});

export const collections = { blog, docs };
```

### Dynamic Route with Content Collections
```astro
---
// src/pages/blog/[slug].astro
import { getCollection, render } from 'astro:content';
import BlogLayout from '../../layouts/BlogLayout.astro';

export async function getStaticPaths() {
    const posts = await getCollection('blog', ({ data }) => !data.draft);
    return posts.map(post => ({
        params: { slug: post.slug },
        props: { post },
    }));
}

const { post } = Astro.props;
const { Content, headings } = await render(post);
---

<BlogLayout frontmatter={post.data} headings={headings}>
    <Content />
</BlogLayout>
```

### Blog Listing Page
```astro
---
// src/pages/blog/index.astro
import { getCollection } from 'astro:content';
import BaseLayout from '../../layouts/BaseLayout.astro';
import PostCard from '../../components/blog/PostCard.astro';

const posts = (await getCollection('blog', ({ data }) => !data.draft))
    .sort((a, b) => b.data.pubDate.getTime() - a.data.pubDate.getTime());
---

<BaseLayout title="Blog" description="All posts">
    <main>
        <h1>Blog</h1>
        <ul>
            {posts.map(post => (
                <li>
                    <PostCard
                        slug={post.slug}
                        title={post.data.title}
                        description={post.data.description}
                        pubDate={post.data.pubDate}
                        tags={post.data.tags}
                    />
                </li>
            ))}
        </ul>
    </main>
</BaseLayout>
```

### Island Architecture (Partial Hydration)
```astro
---
// src/pages/index.astro
// Static Astro components — zero JS shipped
import HeroSection from '../components/HeroSection.astro';
// Interactive island — ships JS only for this component
import SearchBox from '../components/interactive/SearchBox';
import Newsletter from '../components/interactive/Newsletter';
---

<HeroSection />

<!-- Hydrate immediately — above the fold interactive -->
<SearchBox client:load />

<!-- Hydrate when scrolled into view — below the fold -->
<Newsletter client:visible />

<!-- Hydrate only on user interaction -->
<CommentSection client:idle />

<!-- Only render on client, skip SSR entirely -->
<LiveChat client:only="react" />
```

### Base Layout
```astro
---
// src/layouts/BaseLayout.astro
interface Props {
    title: string;
    description: string;
    image?: string;
}

const {
    title,
    description,
    image = '/og-image.png',
} = Astro.props;

const canonicalURL = new URL(Astro.url.pathname, Astro.site);
---

<html lang="en">
<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link rel="canonical" href={canonicalURL} />
    <meta name="description" content={description} />

    <!-- Open Graph -->
    <meta property="og:title" content={title} />
    <meta property="og:description" content={description} />
    <meta property="og:image" content={new URL(image, Astro.url)} />
    <meta property="og:type" content="website" />

    <title>{title}</title>
</head>
<body>
    <slot />
</body>
</html>
```

### View Transitions
```astro
---
// src/layouts/BaseLayout.astro
import { ViewTransitions } from 'astro:transitions';
---

<html>
<head>
    <!-- ... -->
    <ViewTransitions />
</head>
<body>
    <slot />
</body>
</html>
```

Animate specific elements:
```astro
<!-- Shared element transition between pages -->
<img
    src={post.data.image.url}
    alt={post.data.image.alt}
    transition:name={`hero-${post.slug}`}
/>
```

### Astro Configuration
```javascript
// astro.config.mjs
import { defineConfig } from 'astro/config';
import tailwind from '@astrojs/tailwind';
import mdx from '@astrojs/mdx';
import react from '@astrojs/react';
import sitemap from '@astrojs/sitemap';

export default defineConfig({
    site: 'https://your-site.com',
    integrations: [
        tailwind(),
        mdx(),
        react(),       // only if using React islands
        sitemap(),
    ],
    markdown: {
        shikiConfig: {
            theme: 'github-dark',
            wrap: true,
        },
    },
    output: 'static',  // or 'server' / 'hybrid'
    // adapter: vercel() / cloudflare() — for SSR
});
```

### Server Endpoints (SSR or API)
```typescript
// src/pages/api/subscribe.ts
import type { APIRoute } from 'astro';

export const POST: APIRoute = async ({ request }) => {
    const body = await request.json();

    if (!body.email) {
        return new Response(JSON.stringify({ error: 'Email required' }), {
            status: 400,
            headers: { 'Content-Type': 'application/json' },
        });
    }

    // Process subscription...

    return new Response(JSON.stringify({ success: true }), {
        status: 200,
        headers: { 'Content-Type': 'application/json' },
    });
};
```

## Environment Variables
Create `.env` with:
```bash
# Public — must prefix with PUBLIC_ to use in client-side code
PUBLIC_SITE_URL=https://your-site.com

# Private — server-side only (SSR or endpoints)
CMS_API_KEY=your-api-key
EMAIL_SERVICE_KEY=your-key
```

Access in code:
```typescript
// Client-side (in components or .astro frontmatter)
const siteUrl = import.meta.env.PUBLIC_SITE_URL;

// Server-side only (endpoints, SSR pages)
const apiKey = import.meta.env.CMS_API_KEY;
```

## Key Files
| Purpose | File |
|---------|------|
| Content schemas | `src/content/config.ts` |
| Global styles | `src/styles/global.css` |
| Base layout | `src/layouts/BaseLayout.astro` |
| Tailwind config | `tailwind.config.mjs` |
| Astro config | `astro.config.mjs` |

## Commands
```bash
npm run dev          # Start dev server with HMR
npm run build        # Production build to dist/
npm run preview      # Preview production build locally
astro check          # TypeScript + template type checking
npm run lint         # Run ESLint
```

## Code Style

### Astro Conventions
- Keep component logic in the `---` frontmatter fence; keep the template declarative
- Static-first: only reach for `client:*` directives when interactivity is genuinely needed
- Prefer `.astro` components for static UI — use React/Vue/Svelte only for islands
- All content that benefits from Zod validation belongs in a Content Collection

### Island Directive Reference
| Directive | When to use |
|-----------|-------------|
| `client:load` | Immediately visible, interactive above the fold |
| `client:idle` | Interactive but not urgent — loads during browser idle |
| `client:visible` | Below the fold — loads when scrolled into view |
| `client:only="react"` | Client-render only (no SSR) |

### Performance Guidelines
- Avoid `client:load` for components below the fold
- Use `<Image />` from `astro:assets` instead of plain `<img>` for optimization
- Prefer `getStaticPaths` + `getCollection` for blog/docs over runtime fetching
- Enable `sitemap()` integration and set `site` in `astro.config.mjs`

---

## Notes
[Any additional project-specific conventions, CMS integrations, or important information]

## Resources
- [Astro Documentation](https://docs.astro.build/)
- [Content Collections Guide](https://docs.astro.build/en/guides/content-collections/)
- [View Transitions Guide](https://docs.astro.build/en/guides/view-transitions/)
- [Astro Integrations](https://astro.build/integrations/)
