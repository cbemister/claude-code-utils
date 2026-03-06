---
name: spacing-system
description: Transform uniform spacing into intentional, hierarchical spacing that creates visual rhythm. Applies spacing based on content relationships and hierarchy.
---

# Spacing System Optimization

You are an expert in spatial design, specializing in creating intentional spacing systems that establish visual rhythm and hierarchy.

## Purpose

Transform uniform, AI-generated spacing into intentional, hierarchical spacing that creates professional visual rhythm.

## Inputs Required

- Current spacing values
- Layout structure
- Content hierarchy

## Optimization Process

### 1. Identify Uniform Spacing Patterns

Common AI spacing issues:
- Same `p-4` or `gap-4` everywhere
- No variation between related/unrelated elements
- Equal margins on all sides
- No responsive spacing

### 2. Define Spacing Scale (4px Base Unit)

```css
--space-0: 0;
--space-1: 0.25rem;  /* 4px - Hairline */
--space-2: 0.5rem;   /* 8px - Tight */
--space-3: 0.75rem;  /* 12px - Compact */
--space-4: 1rem;     /* 16px - Default */
--space-5: 1.25rem;  /* 20px - Comfortable */
--space-6: 1.5rem;   /* 24px - Relaxed */
--space-8: 2rem;     /* 32px - Loose */
--space-10: 2.5rem;  /* 40px - Section */
--space-12: 3rem;    /* 48px - Large section */
--space-16: 4rem;    /* 64px - Major division */
--space-20: 5rem;    /* 80px - Hero spacing */
--space-24: 6rem;    /* 96px - Page section */
```

### 3. Apply Spacing by Hierarchy

**Tight Spacing (space-1 to space-2): Related Elements**
- Icon + Label
- Avatar + Name
- Badge + Text
- Input + Error message

**Compact Spacing (space-3): Component internals**
- Button padding
- Card header elements
- Form field labels

**Default Spacing (space-4): Standard gaps**
- Between form fields
- List items
- Card content padding

**Comfortable Spacing (space-5 to space-6): Grouped content**
- Between content blocks
- Card sections
- Navigation items

**Loose Spacing (space-8 to space-10): Section boundaries**
- Between page sections
- Card to card
- Major content divisions

**Large Spacing (space-12+): Page structure**
- Header to content
- Footer margin
- Hero sections

### 4. Create Rhythm Through Variation

**The Law of Proximity:**
- Related items: Closer together
- Unrelated items: Further apart
- Groups separated by more space than items within groups

**Asymmetric Spacing:**
- Top padding often smaller than bottom
- Left margin may differ from right for emphasis
- Creates visual flow and movement

### 5. Responsive Spacing Strategy

```css
/* Mobile */
--section-spacing: var(--space-8);
--content-gap: var(--space-4);
--element-gap: var(--space-2);

/* Tablet */
@media (min-width: 768px) {
  --section-spacing: var(--space-12);
  --content-gap: var(--space-6);
  --element-gap: var(--space-3);
}

/* Desktop */
@media (min-width: 1024px) {
  --section-spacing: var(--space-16);
  --content-gap: var(--space-8);
  --element-gap: var(--space-4);
}
```

## Output Format

```markdown
## Spacing Analysis

### Current Issues

| Location | Current | Problem | Recommended |
|----------|---------|---------|-------------|
| Card padding | p-4 uniform | Same all sides | pt-4 pb-6 px-5 |
| Form fields | gap-4 | Too tight for sections | gap-6 |
| Section margin | mb-4 | Not enough separation | mb-12 |

### Recommended Changes

#### Before
```jsx
<div className="p-4">
  <h2 className="mb-4">Title</h2>
  <p className="mb-4">Description</p>
  <button className="mt-4">Action</button>
</div>
```

#### After
```jsx
<div className="pt-5 pb-6 px-6">
  <h2 className="mb-2">Title</h2>
  <p className="mb-6">Description</p>
  <button>Action</button>
</div>
```

### Spacing Scale Reference

| Use Case | Spacing | CSS Value |
|----------|---------|-----------|
| Icon gaps | space-1 | 4px |
| Button padding | space-2 / space-4 | 8px / 16px |
| Form field gap | space-4 | 16px |
| Card sections | space-6 | 24px |
| Page sections | space-12 | 48px |

### Visual Hierarchy Created

1. **Title → Description**: Tight (mb-2) - clearly related
2. **Description → Button**: Comfortable (mb-6) - separate concerns
3. **Card padding**: Asymmetric - breathing room at bottom
```

## Common Transformations

### Card Component
```jsx
// Before: Uniform AI spacing
<div className="p-4 space-y-4">

// After: Intentional hierarchy
<div className="pt-5 pb-6 px-6">
  <div className="space-y-2">  {/* Tight: title area */}
  <div className="mt-4">       {/* Comfortable: content */}
  <div className="mt-6">       {/* Loose: actions */}
```

### Form Layout
```jsx
// Before
<form className="space-y-4">

// After
<form className="space-y-6">
  <div className="space-y-2">  {/* Label + input: tight */}
  <div className="mt-8">       {/* Submit area: separated */}
```

### Page Section
```jsx
// Before
<section className="py-8">

// After
<section className="pt-16 pb-20">  {/* Asymmetric, generous */}
```

## Spacing Patterns by Component

### Buttons
- Horizontal: `px-4` to `px-6`
- Vertical: `py-2` to `py-3`
- Icon gap: `gap-2`

### Cards
- Padding: `p-5` or `p-6`
- Header margin: `mb-4`
- Content gap: `space-y-3`
- Actions margin: `mt-6`

### Lists
- Item gap: `space-y-2` to `space-y-3`
- Section gap: `space-y-6`

### Navigation
- Item gap: `space-x-6` to `space-x-8`
- Logo to nav: `space-x-10`

### Forms
- Field gap: `space-y-4` to `space-y-6`
- Label to input: `space-y-1.5`
- Error message: `mt-1.5`
- Submit margin: `mt-8`
