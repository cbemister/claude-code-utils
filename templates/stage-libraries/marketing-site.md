# Stage Library: Marketing Site (Astro / Static)

> **Reference material for the project-planner agent.**
> Use this file when generating stage plans for marketing sites, landing pages, and static sites built with Astro, Next.js (static export), or similar frameworks.
> Each stage below maps to one `stage-plan.md` file. Adapt stage count and task depth to the project scope.

---

## Archetype Overview

Marketing sites live or die by conversion, performance, and SEO. Build order follows content hierarchy: design system first, then page structure top-to-bottom (hero → features → social proof → CTA), then the cross-cutting concerns (SEO, analytics, performance). The goal is a site that loads instantly, ranks well, and converts visitors.

Typical tech stack: Astro + React/Svelte components + Tailwind CSS + MDX for content + Vercel/Netlify deploy.

---

## Typical Stage Progression

### Stage 1: Design System

**Goal:** Visual language established before writing a single page component.

Key deliverables:
- Color palette tokens (primary, secondary, neutral, semantic)
- Typography scale (font families, sizes, weights, line heights)
- Spacing scale (consistent rem/px increments)
- Base component set: Button (variants), Link, Badge, Icon wrapper
- Global CSS (reset, custom properties, body defaults)
- Design token reference doc or Storybook stub

Typical tasks:
- Define and document color palette with accessibility contrast ratios
- Set up Tailwind config with custom design tokens
- Build Button component with all variants (primary, secondary, ghost, danger)
- Create typography utility classes or components
- Document tokens for team reference

Recommended agents:
- Lead: `ui-ux-designer` (Opus) — visual design decisions
- Support: `feature-builder` (Sonnet) — Tailwind config and component implementation
- Review: `code-reviewer` (Haiku) — accessibility contrast checks

---

### Stage 2: Content Structure

**Goal:** Site architecture, routing, and content model defined.

Key deliverables:
- Page routes defined (`/`, `/pricing`, `/about`, `/blog`, etc.)
- Layout components (root layout, page layout, blog layout)
- Navigation component (header with nav links, mobile menu)
- Footer component
- Content collections defined (MDX/CMS schema for blog or docs, if applicable)
- 404 page

Typical tasks:
- Define all routes and create placeholder pages
- Build header with responsive nav and mobile hamburger menu
- Build footer with links, legal, social icons
- Set up content collections schema (if using MDX or CMS)
- Create base layout wrapping all pages

Recommended agents:
- Lead: `feature-builder` (Sonnet) — routing and layout structure
- Support: `ui-ux-designer` (Opus) — nav and footer design
- Review: `code-reviewer` (Haiku) — accessibility (keyboard nav, skip links)

---

### Stage 3: Hero / Landing Section

**Goal:** Above-the-fold experience built and polished.

Key deliverables:
- Hero section with headline, subheadline, primary CTA
- Supporting visual (illustration, screenshot, video, or 3D element)
- Responsive layout (desktop and mobile variants)
- Animated entrance (if applicable — use with restraint)
- Trust signals in hero (logos, star rating, user count)

Typical tasks:
- Build hero layout component
- Write and finalize hero headline copy
- Implement hero visual (image optimization, lazy load)
- Add primary CTA button with tracking attribute
- Ensure hero is fully responsive at all breakpoints
- Test LCP (Largest Contentful Paint) target: < 2.5s

Recommended agents:
- Lead: `ui-ux-designer` (Opus) — hero composition and visual hierarchy
- Support: `feature-builder` (Sonnet) — responsive implementation and image optimization
- Review: `conversion-optimizer` (Sonnet) — CTA placement and copy effectiveness

---

### Stage 4: Feature Sections

**Goal:** Product value communicated through structured feature blocks.

Key deliverables:
- Feature grid or list section (icon + title + description)
- Feature detail sections (alternating image + text blocks)
- "How it works" steps or timeline (if applicable)
- Comparison table (if competing with alternatives)

Typical tasks:
- Build reusable FeatureCard component
- Build alternating feature-detail section (image left / image right)
- Build steps/timeline component
- Write feature copy for each item
- Ensure all sections are responsive

Recommended agents:
- Lead: `ui-ux-designer` (Opus) — section layouts and visual rhythm
- Support: `feature-builder` (Sonnet) — component implementation
- Review: `conversion-optimizer` (Sonnet) — benefit framing and copy

---

### Stage 5: Social Proof

**Goal:** Trust signals integrated throughout the page.

Key deliverables:
- Testimonial section (quote, attribution, avatar)
- Logo bar (customer/partner logos)
- Stats section (key numbers: users, uptime, NPS, etc.)
- Case study previews (if applicable)
- Review aggregate or star rating display

Typical tasks:
- Build TestimonialCard component
- Build LogoBar with grayscale-to-color hover effect
- Build StatsBar with animated counters (if applicable)
- Source and format testimonial content
- Implement logo assets (SVG preferred)

Recommended agents:
- Lead: `ui-ux-designer` (Opus) — trust section layout
- Support: `feature-builder` (Sonnet) — component implementation
- Review: `conversion-optimizer` (Sonnet) — social proof placement strategy

---

### Stage 6: CTAs and Conversion

**Goal:** Conversion paths clear and optimized throughout the page.

Key deliverables:
- Mid-page CTA section (secondary conversion point)
- Pricing section (if applicable) with plan cards
- Sign-up / waitlist form with validation
- Final bottom CTA section
- Form submission handling (API route or third-party form service)

Typical tasks:
- Build PricingCard component with feature list and CTA
- Build email capture form with validation
- Connect form to backend (API route, Resend, Mailchimp, etc.)
- Add success/error states for form submission
- Build bottom-of-page CTA section
- A/B test variant prep (if applicable)

Recommended agents:
- Lead: `conversion-optimizer` (Sonnet) — CTA hierarchy and pricing page
- Support: `feature-builder` (Sonnet) — form handling and API integration
- Review: `ui-ux-designer` (Opus) — visual polish

---

### Stage 7: SEO and Meta

**Goal:** Every page rankable and shareable.

Key deliverables:
- `<title>` and `<meta name="description">` per page
- Open Graph tags (og:title, og:description, og:image) per page
- Twitter card tags
- Canonical URLs
- Structured data (JSON-LD for Organization, WebSite, Product, or Article)
- `robots.txt` and `sitemap.xml`
- Heading hierarchy (one H1 per page, logical H2/H3 structure)

Typical tasks:
- Create SEO component accepting per-page props
- Write meta copy for each page
- Generate og:image assets (or dynamic OG image endpoint)
- Add JSON-LD schema to appropriate pages
- Generate sitemap from page list
- Validate with Google Rich Results Test and OG debugger

Recommended agents:
- Lead: `feature-builder` (Sonnet) — SEO component and sitemap generation
- Review: `code-reviewer` (Haiku) — heading hierarchy and schema validation

---

### Stage 8: Analytics

**Goal:** Visitor behavior tracked from day one.

Key deliverables:
- Analytics provider integrated (Plausible, Fathom, PostHog, or GA4)
- Conversion events tracked (CTA clicks, form submissions, pricing page views)
- Error tracking (Sentry or equivalent)
- Cookie consent banner (if required by GDPR)
- Event taxonomy documented

Typical tasks:
- Install and configure analytics provider
- Add pageview tracking
- Add custom event tracking for CTAs and form submissions
- Set up error tracking with source maps
- Implement cookie consent if required
- Document event names and properties

Recommended agents:
- Lead: `feature-builder` (Sonnet) — analytics integration
- Review: `code-reviewer` (Haiku) — privacy compliance and consent flow

---

### Stage 9: Performance

**Goal:** Core Web Vitals green across all pages.

Key deliverables:
- LCP < 2.5s on all pages
- CLS < 0.1 on all pages
- INP < 200ms (formerly FID)
- All images with explicit width/height, lazy loading, next-gen format (WebP/AVIF)
- Fonts optimized (preload, font-display: swap, subset)
- Third-party scripts deferred or partytown'd
- Lighthouse score ≥ 90 on Performance

Typical tasks:
- Audit all images: convert to WebP/AVIF, add dimensions, lazy load below fold
- Audit font loading: self-host or preconnect, use font-display: swap
- Defer non-critical third-party scripts
- Remove unused CSS (PurgeCSS or Tailwind JIT already handles this)
- Run Lighthouse CI and fix regressions
- Verify bundle size with `astro build --verbose` or `next-bundle-analyzer`

Recommended agents:
- Lead: `feature-builder` (Sonnet) — performance fixes
- Review: `code-reviewer` (Haiku) — Lighthouse audit review

---

### Stage 10: Launch

**Goal:** Site live, monitored, and announced.

Key deliverables:
- Custom domain configured with HTTPS
- DNS records verified (A, CNAME, MX)
- Environment variables set in production
- Uptime monitoring configured
- 301 redirects from old URLs (if migration)
- Launch announcement prepared

Typical tasks:
- Configure domain and SSL in hosting platform
- Set production environment variables
- Configure uptime monitor (Better Uptime, Pingdom, etc.)
- Verify all forms submit correctly in production
- Do full manual smoke test on mobile and desktop
- Announce on social / newsletter

Recommended agents:
- Lead: `feature-builder` (Sonnet) — deployment config and smoke testing
- Review: `code-reviewer` (Haiku) — pre-launch checklist

---

## Common Parallelization Patterns

```
Stage 1 (Design System)
       ↓
Stage 2 (Content Structure) ──────────────────────────────┐
       ↓                                                   │
Stage 3 (Hero)       ──┐                                   │
Stage 4 (Features)   ──┤── parallel once Stage 2 done     │
Stage 5 (Social Proof)─┘                                   │
       ↓ (all sections complete)                           │
Stage 6 (CTAs/Conversion)                                  │
       ↓                                                   │
Stage 7 (SEO/Meta) ──┐                                     │
Stage 8 (Analytics)──┤── parallel once Stage 6 done       │
Stage 9 (Performance)┘                                     │
       ↓                                                   │
Stage 10 (Launch) ←────────────────────────────────────────┘
```

Within a stage:
- Testimonial cards and logo bar (Stage 5) can be built in parallel
- og:image generation and JSON-LD authoring (Stage 7) can run in parallel
- Image optimization and font optimization (Stage 9) can run in parallel

---

## Technology-Specific Verification Commands

```bash
# Astro
npm run dev              # dev server at localhost:4321
npm run build            # production build to dist/
npm run preview          # preview production build locally
npx astro check          # TypeScript check

# Next.js (static)
npm run dev
npm run build && npm run start
npx tsc --noEmit

# Lighthouse (install once)
npm install -g lighthouse
lighthouse http://localhost:4321 --view

# Check sitemap generated
ls dist/sitemap*.xml
curl http://localhost:4321/sitemap.xml

# Check OG tags
curl -s http://localhost:4321 | grep og:

# Image audit: find unoptimized images
find public/ -name "*.jpg" -o -name "*.png" | xargs du -sh | sort -h

# Bundle size
npm run build -- --verbose
du -sh dist/

# Core Web Vitals (via PageSpeed API)
open https://pagespeed.web.dev/

# Lint and format
npm run lint
npm run format
```

---

## Common Stage Dependencies

| Stage | Hard Depends On | Notes |
|-------|----------------|-------|
| Content Structure (2) | Design System (1) | Layout uses design tokens |
| Hero (3) | Content Structure (2) | Header/footer wrapper must exist |
| Features (4) | Content Structure (2) | Page layout shell must exist |
| Social Proof (5) | Content Structure (2) | Page layout shell must exist |
| CTAs/Conversion (6) | Features (4), Social Proof (5) | CTAs contextualized by surrounding content |
| SEO/Meta (7) | All page content complete | Meta copy reflects final content |
| Analytics (8) | CTAs defined (6) | Can't track events that don't exist yet |
| Performance (9) | All content and scripts present | Can't optimize what isn't there |
| Launch (10) | Performance (9) | Must pass Core Web Vitals before launch |

---

## Planner Notes

- **Merge Stages 3–5** for small landing pages — single-page sites don't need separate stages per section.
- **Skip Stage 8 analytics** for early pre-launch sites or when using a CMS with built-in analytics.
- **Move SEO earlier** if organic search is the primary acquisition channel — add it to Stage 2.
- Conversion rate depends heavily on copy, not just design. Loop in copywriting-guide skill during Stages 3–6.
- Performance (Stage 9) often reveals issues introduced in earlier stages. Allocate more time than expected.
