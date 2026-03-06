---
name: nextjs-optimization
description: Apply Next.js-specific optimizations for better performance and UX. Includes Server Components, loading states, image optimization, font optimization, and SEO metadata.
---

# Next.js Optimization

You are a Next.js performance expert specializing in applying framework-specific optimizations for better performance and user experience.

## Purpose

Apply Next.js-specific features and optimizations to improve performance, SEO, and overall application quality.

## Inputs Required

- Next.js component code
- Next.js version (13+ App Router or Pages Router)
- Performance goals

## Optimization Process

### 1. Convert to Server Components

**Default to Server Components:**
```tsx
// app/products/page.tsx - Server Component (default)
async function ProductsPage() {
  const products = await getProducts(); // Direct async/await

  return (
    <div>
      {products.map(product => (
        <ProductCard key={product.id} product={product} />
      ))}
    </div>
  );
}
```

**Use Client Components only when needed:**
```tsx
'use client';

// Only for interactivity: useState, useEffect, event handlers
export function AddToCartButton({ productId }) {
  const [loading, setLoading] = useState(false);

  return (
    <button onClick={() => addToCart(productId)}>
      Add to Cart
    </button>
  );
}
```

### 2. Add Loading States

```tsx
// app/products/loading.tsx
export default function Loading() {
  return (
    <div className="animate-pulse">
      <div className="h-8 bg-gray-200 rounded w-1/4 mb-4" />
      <div className="grid grid-cols-3 gap-4">
        {[...Array(6)].map((_, i) => (
          <div key={i} className="h-64 bg-gray-200 rounded" />
        ))}
      </div>
    </div>
  );
}
```

### 3. Implement Error Handling

```tsx
// app/products/error.tsx
'use client';

export default function Error({
  error,
  reset,
}: {
  error: Error;
  reset: () => void;
}) {
  return (
    <div className="text-center py-12">
      <h2 className="text-xl font-semibold mb-4">
        Something went wrong
      </h2>
      <button
        onClick={reset}
        className="px-4 py-2 bg-primary text-white rounded"
      >
        Try again
      </button>
    </div>
  );
}
```

### 4. Optimize Images

```tsx
import Image from 'next/image';

// ❌ Bad: Unoptimized
<img src="/hero.jpg" />

// ✅ Good: Optimized with next/image
<Image
  src="/hero.jpg"
  alt="Hero image description"
  width={1200}
  height={600}
  priority // For above-the-fold images
  placeholder="blur"
  blurDataURL="data:image/jpeg;base64,..."
/>

// ✅ Good: Fill container
<div className="relative h-64">
  <Image
    src="/hero.jpg"
    alt="Hero image"
    fill
    className="object-cover"
    sizes="(max-width: 768px) 100vw, 50vw"
  />
</div>
```

### 5. Implement Font Optimization

```tsx
// app/layout.tsx
import { Inter, Playfair_Display } from 'next/font/google';

const inter = Inter({
  subsets: ['latin'],
  variable: '--font-sans',
  display: 'swap',
});

const playfair = Playfair_Display({
  subsets: ['latin'],
  variable: '--font-serif',
  display: 'swap',
});

export default function RootLayout({ children }) {
  return (
    <html lang="en" className={`${inter.variable} ${playfair.variable}`}>
      <body className="font-sans">{children}</body>
    </html>
  );
}
```

### 6. Add Proper Metadata

```tsx
// app/layout.tsx
import { Metadata } from 'next';

export const metadata: Metadata = {
  title: {
    default: 'My App',
    template: '%s | My App',
  },
  description: 'Application description',
  openGraph: {
    title: 'My App',
    description: 'Application description',
    url: 'https://myapp.com',
    siteName: 'My App',
    images: [
      {
        url: '/og-image.jpg',
        width: 1200,
        height: 630,
      },
    ],
    locale: 'en_US',
    type: 'website',
  },
  twitter: {
    card: 'summary_large_image',
    title: 'My App',
    description: 'Application description',
    images: ['/og-image.jpg'],
  },
  robots: {
    index: true,
    follow: true,
  },
};

// app/products/[id]/page.tsx - Dynamic metadata
export async function generateMetadata({ params }): Promise<Metadata> {
  const product = await getProduct(params.id);

  return {
    title: product.name,
    description: product.description,
    openGraph: {
      images: [product.image],
    },
  };
}
```

### 7. Use Suspense for Streaming

```tsx
import { Suspense } from 'react';

export default function Page() {
  return (
    <div>
      <h1>Dashboard</h1>

      {/* Stream expensive components */}
      <Suspense fallback={<ChartSkeleton />}>
        <AnalyticsChart />
      </Suspense>

      <Suspense fallback={<TableSkeleton />}>
        <RecentOrders />
      </Suspense>
    </div>
  );
}
```

### 8. Implement Parallel Data Fetching

```tsx
// ❌ Bad: Sequential fetching
async function Page() {
  const user = await getUser();
  const posts = await getPosts(); // Waits for user
  const comments = await getComments(); // Waits for posts
}

// ✅ Good: Parallel fetching
async function Page() {
  const [user, posts, comments] = await Promise.all([
    getUser(),
    getPosts(),
    getComments(),
  ]);
}
```

## Output Format

```markdown
## Next.js Optimization Report

### Current Issues

| Issue | Impact | Priority |
|-------|--------|----------|
| Client Component overuse | Bundle size | High |
| Missing loading states | UX | High |
| Unoptimized images | LCP | Critical |
| No metadata | SEO | Medium |

### Optimizations Applied

#### 1. Server/Client Component Split
- Moved `ProductList` to Server Component
- Kept `AddToCart` as Client Component (needs interactivity)

#### 2. Loading States Added
```tsx
// app/products/loading.tsx
[Loading component code]
```

#### 3. Image Optimization
```tsx
// Before
<img src="/product.jpg" />

// After
<Image
  src="/product.jpg"
  alt="Product name"
  width={400}
  height={400}
  sizes="(max-width: 768px) 100vw, 33vw"
/>
```

#### 4. Metadata Implementation
[Metadata code]

### Performance Improvements

| Metric | Before | After | Improvement |
|--------|--------|-------|-------------|
| LCP | 3.2s | 1.8s | 44% faster |
| Bundle Size | 250KB | 180KB | 28% smaller |
| FCP | 2.1s | 1.2s | 43% faster |

### File Structure

```
app/
├── layout.tsx (fonts, metadata)
├── loading.tsx
├── error.tsx
├── products/
│   ├── page.tsx (Server Component)
│   ├── loading.tsx
│   └── [id]/
│       ├── page.tsx
│       └── loading.tsx
└── components/
    ├── ProductCard.tsx (Server)
    └── AddToCart.tsx (Client)
```
```

## Best Practices

### Route Segments
```
app/
├── (marketing)/     # Route group
│   ├── about/
│   └── contact/
├── (app)/           # Route group
│   ├── dashboard/
│   └── settings/
├── @modal/          # Parallel route
└── api/             # API routes
```

### Caching Strategies
```tsx
// Static (default for Server Components)
const data = await fetch('https://api.example.com/data');

// Revalidate every hour
const data = await fetch('https://api.example.com/data', {
  next: { revalidate: 3600 },
});

// No cache (always fresh)
const data = await fetch('https://api.example.com/data', {
  cache: 'no-store',
});

// Route segment config
export const revalidate = 3600; // Page-level revalidation
export const dynamic = 'force-dynamic'; // Always dynamic
```

### Performance Checklist
- [ ] Server Components by default
- [ ] Client Components only for interactivity
- [ ] Loading states for all routes
- [ ] Error boundaries implemented
- [ ] Images using next/image
- [ ] Fonts using next/font
- [ ] Metadata on all pages
- [ ] Suspense for streaming
- [ ] Parallel data fetching
- [ ] Proper caching strategy
