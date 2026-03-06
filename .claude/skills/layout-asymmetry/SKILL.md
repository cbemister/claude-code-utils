---
name: layout-asymmetry
description: Break perfect symmetry and create more engaging, professional layouts. Applies 60/40 or 70/30 splits, varies content block sizes, and creates focal points while maintaining visual balance.
---

# Layout Asymmetry Introduction

You are an expert layout designer specializing in breaking AI-generated symmetry to create engaging, professional compositions.

## Purpose

Transform perfectly symmetric, AI-generated layouts into visually interesting compositions with intentional asymmetry and focal points.

## Inputs Required

- Current layout code
- Content priorities
- Design goals

## Transformation Process

### 1. Analyze Current Symmetry

Common AI symmetry patterns:
- 50/50 column splits everywhere
- Equal-sized grid items
- Centered everything
- Identical card sizes
- Mirror-image layouts

### 2. Identify Opportunities for Asymmetry

**Questions to ask:**
- What's the most important content?
- What should draw the eye first?
- What's the visual hierarchy?
- How can we create flow/movement?

### 3. Apply Asymmetric Splits

**Instead of 50/50:**
```css
/* 60/40 Split */
.layout {
  display: grid;
  grid-template-columns: 1.5fr 1fr;
  gap: var(--space-8);
}

/* 70/30 Split */
.layout {
  display: grid;
  grid-template-columns: 2fr 1fr;
  gap: var(--space-8);
}

/* Golden Ratio (~62/38) */
.layout {
  display: grid;
  grid-template-columns: 1.618fr 1fr;
  gap: var(--space-8);
}
```

### 4. Vary Content Block Sizes

```css
/* Masonry-style variation */
.grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: var(--space-4);
}

.gridItemFeatured {
  grid-column: span 2;
  grid-row: span 2;
}

.gridItemTall {
  grid-row: span 2;
}

.gridItemWide {
  grid-column: span 2;
}
```

### 5. Create Focal Points

**Size creates hierarchy:**
- Largest element = most important
- Supporting content smaller
- Progressive size reduction

**Position creates flow:**
- Important items top-left (Western reading)
- CTAs in natural eye-flow paths
- Whitespace guides attention

### 6. Maintain Visual Balance

**Balance ≠ Symmetry:**
- A large element can balance multiple small ones
- Color weight affects balance (dark = heavy)
- Whitespace has visual weight
- Position affects perceived weight (top-right feels heavier)

## Output Format

```markdown
## Layout Transformation

### Analysis

**Current Issues:**
- 50/50 split doesn't emphasize primary content
- All cards same size despite different importance
- No clear visual hierarchy

### Recommended Changes

#### Before
```jsx
<div className="grid grid-cols-2 gap-4">
  <Card>Primary Content</Card>
  <Card>Secondary Content</Card>
</div>
```

#### After
```jsx
<div className="grid grid-cols-[2fr_1fr] gap-6">
  <Card className="row-span-2">
    Primary Content (larger, emphasized)
  </Card>
  <Card>Secondary A</Card>
  <Card>Secondary B</Card>
</div>
```

### Visual Hierarchy Created

1. **Primary focus**: Large left panel (70% width)
2. **Secondary content**: Stacked right cards (30% width)
3. **Natural flow**: Eye moves left-to-right, top-to-bottom

### Balance Analysis

- Large panel balanced by two stacked cards
- Whitespace in right column adds breathing room
- Color weight distributed evenly
```

## Common Transformations

### Hero Section
```jsx
// Before: Centered, symmetric
<section className="text-center py-20">
  <h1>Title</h1>
  <p>Description</p>
  <button>CTA</button>
</section>

// After: Asymmetric, with visual interest
<section className="grid grid-cols-[1.5fr_1fr] py-24 gap-12">
  <div className="space-y-6">
    <h1>Title</h1>
    <p>Description</p>
    <button>CTA</button>
  </div>
  <div className="relative">
    <Image className="translate-y-8" />
  </div>
</section>
```

### Card Grid
```jsx
// Before: Equal cards
<div className="grid grid-cols-3 gap-4">
  <Card /><Card /><Card />
  <Card /><Card /><Card />
</div>

// After: Featured + supporting
<div className="grid grid-cols-3 gap-4">
  <Card className="col-span-2 row-span-2" featured />
  <Card />
  <Card />
  <Card />
  <Card className="col-span-2" />
</div>
```

### Sidebar Layout
```jsx
// Before: Equal columns
<div className="grid grid-cols-2">
  <main>Content</main>
  <aside>Sidebar</aside>
</div>

// After: Content-focused
<div className="grid grid-cols-[1fr_300px] gap-8">
  <main>Content (flexible)</main>
  <aside>Sidebar (fixed)</aside>
</div>
```

### Feature Section
```jsx
// Before: Icon | Text | Icon | Text (symmetric)
<div className="grid grid-cols-4 gap-4">
  <Icon /><Text /><Icon /><Text />
</div>

// After: Offset, varied
<div className="grid grid-cols-3 gap-8">
  <div className="pt-12">Feature 1</div>
  <div>Feature 2 (emphasized)</div>
  <div className="pt-8">Feature 3</div>
</div>
```

## Asymmetry Techniques

### Offset Elements
```css
.offsetUp { transform: translateY(-2rem); }
.offsetDown { transform: translateY(2rem); }
.offsetLeft { margin-left: -2rem; }
```

### Varied Padding
```css
.asymmetricPadding {
  padding: 3rem 2rem 4rem 3rem; /* Different all sides */
}
```

### Overlapping Elements
```css
.overlap {
  position: relative;
  z-index: 1;
  margin-top: -3rem; /* Overlaps previous section */
}
```

### Breaking the Grid
```css
.breakGrid {
  width: calc(100% + 4rem);
  margin-left: -2rem;
}
```

## Balance Principles

1. **Large + Multiple Small**: One big element balanced by several small ones
2. **Dark + Light**: Heavy dark element balanced by larger light area
3. **Dense + Sparse**: Content-heavy area balanced by whitespace
4. **Top + Bottom**: Visual weight distributed vertically
5. **Left + Right**: Horizontal balance (doesn't mean equal)

## When to Keep Symmetry

- Data tables (clarity over aesthetics)
- Form layouts (consistent scanning)
- Navigation menus (predictable patterns)
- When comparing equivalent items
- Accessibility requirements
