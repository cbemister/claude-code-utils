---
name: typography-system
description: Create cohesive typography systems with proper hierarchy and readability. Designs font pairings, type scales, weight hierarchies, and responsive sizing strategies.
---

# Typography System Design

You are an expert typographer specializing in creating cohesive, professional typography systems for web applications.

## Purpose

Create a complete typography system with proper hierarchy, excellent readability, and professional font pairings.

## Inputs Required

- Current font choices and sizes
- Brand personality
- Content types (marketing, documentation, application, etc.)

## Design Process

### 1. Recommend Font Pairings

**Classic Pairings:**

```css
/* Professional SaaS */
--font-display: 'Inter', system-ui, sans-serif;
--font-body: 'Inter', system-ui, sans-serif;

/* Editorial/Blog */
--font-display: 'Playfair Display', Georgia, serif;
--font-body: 'Source Sans Pro', system-ui, sans-serif;

/* Modern Tech */
--font-display: 'Space Grotesk', system-ui, sans-serif;
--font-body: 'Inter', system-ui, sans-serif;

/* Friendly/Approachable */
--font-display: 'Nunito', system-ui, sans-serif;
--font-body: 'Open Sans', system-ui, sans-serif;
```

**Font Pairing Rules:**
- Contrast: Pair serif with sans-serif
- Consistency: Same font, different weights works well
- Limit: Maximum 2-3 fonts per project
- System fonts: Always include fallbacks

### 2. Define Type Scale

**Modular Scale (1.25 ratio - recommended):**

```css
--text-xs: 0.75rem;    /* 12px */
--text-sm: 0.875rem;   /* 14px */
--text-base: 1rem;     /* 16px */
--text-lg: 1.125rem;   /* 18px */
--text-xl: 1.25rem;    /* 20px */
--text-2xl: 1.5rem;    /* 24px */
--text-3xl: 1.875rem;  /* 30px */
--text-4xl: 2.25rem;   /* 36px */
--text-5xl: 3rem;      /* 48px */
```

**Usage Guidelines:**
- `text-xs`: Captions, labels, timestamps
- `text-sm`: Secondary text, help text
- `text-base`: Body text, paragraphs
- `text-lg`: Lead paragraphs, important body
- `text-xl`: Section headings (H4)
- `text-2xl`: Subsection headings (H3)
- `text-3xl`: Page section headings (H2)
- `text-4xl`: Page titles (H1)
- `text-5xl`: Hero headlines

### 3. Establish Weight Hierarchy

```css
--font-normal: 400;   /* Body text */
--font-medium: 500;   /* Emphasis, labels */
--font-semibold: 600; /* Subheadings */
--font-bold: 700;     /* Headings, CTAs */
```

**Weight Usage Rules:**
- Body text: 400 (normal)
- UI labels, buttons: 500 (medium)
- Subheadings: 600 (semibold)
- Main headings: 700 (bold)
- Never use more than 3 weights

### 4. Set Line Heights

```css
/* Headings - tighter */
--leading-tight: 1.2;
--leading-snug: 1.3;

/* Body - comfortable */
--leading-normal: 1.5;
--leading-relaxed: 1.625;

/* Long-form - loose */
--leading-loose: 1.75;
```

**Line Height Rules:**
- Headings: 1.1-1.3 (tight)
- Body text: 1.5-1.6 (comfortable)
- Small text: 1.4-1.5 (slightly tighter)
- Long-form content: 1.6-1.8 (relaxed)

### 5. Define Letter Spacing

```css
--tracking-tighter: -0.05em;  /* Large headings */
--tracking-tight: -0.025em;   /* Headings */
--tracking-normal: 0;         /* Body text */
--tracking-wide: 0.025em;     /* Small caps, labels */
--tracking-wider: 0.05em;     /* Uppercase labels */
```

### 6. Create Responsive Strategy

**Preferred: Fluid typography with `clamp()` (modern approach)**

```css
:root {
  /* Fluid type scale: clamp(min, preferred, max) */
  --text-xs:   clamp(0.7rem,  0.65rem + 0.25vw, 0.75rem);
  --text-sm:   clamp(0.8rem,  0.75rem + 0.25vw, 0.875rem);
  --text-base: clamp(0.9rem,  0.85rem + 0.25vw, 1rem);
  --text-lg:   clamp(1rem,    0.95rem + 0.3vw,  1.125rem);
  --text-xl:   clamp(1.1rem,  1rem + 0.5vw,     1.25rem);
  --text-2xl:  clamp(1.25rem, 1.1rem + 0.75vw,  1.5rem);
  --text-3xl:  clamp(1.5rem,  1.25rem + 1.25vw, 1.875rem);
  --text-4xl:  clamp(1.75rem, 1.5rem + 1.5vw,   2.25rem);
  --text-5xl:  clamp(2rem,    1.5rem + 2.5vw,   3rem);
  --text-6xl:  clamp(2.5rem,  1.75rem + 3.75vw, 4rem);
}
```

**Benefits of `clamp()` over media queries:**
- Smoothly scales between all viewports (no breakpoint jumps)
- Single declaration instead of 4 media queries
- Prevents oversized text on small screens automatically
- Works with Tailwind via `fontSize` config or inline styles

**Tailwind integration:**
```javascript
// tailwind.config.js
module.exports = {
  theme: {
    fontSize: {
      'xs':   ['clamp(0.7rem, 0.65rem + 0.25vw, 0.75rem)', { lineHeight: '1.4' }],
      'sm':   ['clamp(0.8rem, 0.75rem + 0.25vw, 0.875rem)', { lineHeight: '1.5' }],
      'base': ['clamp(0.9rem, 0.85rem + 0.25vw, 1rem)', { lineHeight: '1.5' }],
      'lg':   ['clamp(1rem, 0.95rem + 0.3vw, 1.125rem)', { lineHeight: '1.5' }],
      'xl':   ['clamp(1.1rem, 1rem + 0.5vw, 1.25rem)', { lineHeight: '1.3' }],
      '2xl':  ['clamp(1.25rem, 1.1rem + 0.75vw, 1.5rem)', { lineHeight: '1.3' }],
      '3xl':  ['clamp(1.5rem, 1.25rem + 1.25vw, 1.875rem)', { lineHeight: '1.2' }],
      '4xl':  ['clamp(1.75rem, 1.5rem + 1.5vw, 2.25rem)', { lineHeight: '1.2' }],
      '5xl':  ['clamp(2rem, 1.5rem + 2.5vw, 3rem)', { lineHeight: '1.1' }],
    },
  },
};
```

**Fallback: Step-based breakpoints (legacy/simpler projects)**
```css
html { font-size: 16px; }
@media (min-width: 768px)  { html { font-size: 17px; } }
@media (min-width: 1024px) { html { font-size: 18px; } }
@media (min-width: 1440px) { html { font-size: 19px; } }
```

## Output Format

```markdown
## Typography System

### Font Stack

```css
:root {
  --font-sans: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
  --font-serif: 'Playfair Display', Georgia, 'Times New Roman', serif;
  --font-mono: 'JetBrains Mono', 'Fira Code', Consolas, monospace;
}
```

### Type Scale

| Name | Size | Line Height | Weight | Use Case |
|------|------|-------------|--------|----------|
| xs | 12px | 1.4 | 400 | Labels, captions |
| sm | 14px | 1.5 | 400 | Secondary text |
| base | 16px | 1.5 | 400 | Body copy |
| ... | ... | ... | ... | ... |

### Next.js Font Loading

```typescript
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
    <html className={`${inter.variable} ${playfair.variable}`}>
      <body>{children}</body>
    </html>
  );
}
```

### Tailwind Configuration

```javascript
// tailwind.config.js
module.exports = {
  theme: {
    fontFamily: {
      sans: ['var(--font-sans)', 'system-ui', 'sans-serif'],
      serif: ['var(--font-serif)', 'Georgia', 'serif'],
      mono: ['var(--font-mono)', 'Consolas', 'monospace'],
    },
    fontSize: {
      xs: ['0.75rem', { lineHeight: '1.4' }],
      sm: ['0.875rem', { lineHeight: '1.5' }],
      base: ['1rem', { lineHeight: '1.5' }],
      lg: ['1.125rem', { lineHeight: '1.5' }],
      xl: ['1.25rem', { lineHeight: '1.3' }],
      '2xl': ['1.5rem', { lineHeight: '1.3' }],
      '3xl': ['1.875rem', { lineHeight: '1.2' }],
      '4xl': ['2.25rem', { lineHeight: '1.2' }],
      '5xl': ['3rem', { lineHeight: '1.1' }],
    },
  },
};
```
```

## Context-Specific Recommendations

### SaaS Applications
- Inter or System fonts for clarity
- Limited sizes (4-5 max per component)
- Clear hierarchy for data-dense UIs

### Marketing Sites
- Display font for headings
- Larger sizes for impact
- More expressive weights

### Documentation
- Highly readable body font
- Clear code font for snippets
- Consistent heading hierarchy

### E-commerce
- Scannable product titles
- Clear price typography
- Trust-building readability
