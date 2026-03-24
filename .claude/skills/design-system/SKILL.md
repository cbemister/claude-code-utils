---
name: design-system
description: Apply foundational design system improvements — color palette, typography, spacing, and layout. Run all at once or target a specific area. Use before component-polish for a complete design overhaul.
argument-hint: "[colors | typography | spacing | layout] — Optional: run just one area. Default: all four."
---

# Design System

Apply foundational design improvements across color, typography, spacing, and layout. Each area can be run independently via argument, or run all four in sequence.

## Usage

```
/design-system             — run all four areas in sequence
/design-system colors      — refine color palette only
/design-system typography  — improve typography only
/design-system spacing     — fix spacing rhythm only
/design-system layout      — improve layout composition only
```

## Instructions

Parse the argument and run the specified area(s). If no argument, run all four in order.

---

## Area: colors

Transform generic color schemes into sophisticated, professional palettes. Refines oversaturated AI-generated colors into muted, professional tones with proper contrast and complete color scales.

**Goals:**
- Eliminate oversaturated, garish colors typical of AI-generated UIs
- Establish a cohesive palette: primary, secondary, accent, neutral, semantic (success/warning/error)
- Ensure WCAG AA contrast ratios (4.5:1 for text, 3:1 for UI components)
- Create full color scales (50–900) for consistent shading

**Process:**
1. Audit existing colors — identify saturation issues, missing scales, contrast failures
2. Design new palette — muted primary (HSL with S: 15-35%), complementary secondary, functional accent
3. Generate full scales for each hue using consistent HSL lightness steps
4. Apply throughout: update CSS variables/design tokens, verify contrast at each step
5. Check semantic colors: success (green), warning (amber), error (red), info (blue) — all muted, not neon

---

## Area: typography

Create a cohesive typography system with proper hierarchy and readability. Designs font pairings, type scales, weight hierarchies, and responsive sizing.

**Goals:**
- Establish clear hierarchy: display → heading → body → caption → label
- Choose appropriate font pairings (heading + body, or single family with weight variation)
- Define a modular type scale (Major Third 1.250 or Perfect Fourth 1.333)
- Set proper line heights, letter spacing, and measure (45-75 chars per line)

**Process:**
1. Audit current type usage — identify inconsistent sizes, poor hierarchy, readability issues
2. Choose font strategy — system fonts (performance) or web fonts (personality)
3. Define scale: base 16px, 5-6 steps up (lg, xl, 2xl, 3xl, 4xl), 2-3 steps down (sm, xs)
4. Assign weights: display 700-800, heading 600-700, body 400, caption 400, label 500
5. Set line heights: display 1.1, heading 1.2-1.3, body 1.5-1.6, caption 1.4
6. Apply responsive scaling: use clamp() for fluid typography on key headings

---

## Area: spacing

Transform uniform spacing into intentional, hierarchical spacing that creates visual rhythm. Apply spacing based on content relationships and hierarchy.

**Goals:**
- Replace arbitrary pixel values with a consistent spacing scale
- Use spacing to communicate hierarchy: related elements closer, distinct sections farther
- Establish rhythm: consistent vertical spacing creates a readable flow

**Process:**
1. Audit current spacing — identify arbitrary values, inconsistent gaps, poor grouping
2. Define scale: 4px base unit — 4, 8, 12, 16, 24, 32, 48, 64, 96, 128
3. Apply hierarchy rules:
   - Within component: 4-8px between related elements
   - Between component parts: 12-16px
   - Between components: 24-32px
   - Between sections: 48-96px
4. Fix padding: components need internal breathing room (12-24px typical)
5. Check that grouping is visible: content that belongs together has tighter spacing than content that doesn't

---

## Area: layout

Break perfect symmetry and create more engaging, professional layouts. Apply 60/40 or 70/30 splits, vary content block sizes, and create focal points while maintaining visual balance.

**Goals:**
- Move away from perfectly equal-width columns that look template-like
- Create visual hierarchy through size variation
- Establish a clear focal point on each major section
- Use negative space intentionally

**Process:**
1. Audit current layout — identify overly symmetrical patterns, equal-weight columns, buried focal points
2. Identify primary content areas — what is most important on each page/section?
3. Apply asymmetry strategically:
   - Hero sections: 60/40 or 70/30 text/image split
   - Feature grids: vary card sizes — one large featured card + smaller supporting cards
   - Testimonials: alternate alignment rather than uniform rows
4. Create visual anchors: use size, color, or whitespace to draw eyes to key CTAs
5. Ensure mobile collapses gracefully — asymmetric layouts should stack cleanly at mobile widths
