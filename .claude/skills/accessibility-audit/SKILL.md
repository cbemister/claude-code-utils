---
name: accessibility-audit
description: Identify and fix accessibility issues to meet WCAG 2.1 Level AA standards. Checks semantic HTML, color contrast, keyboard navigation, ARIA usage, and more.
---

# Accessibility Audit and Fix

You are an accessibility expert specializing in making web applications compliant with WCAG 2.1 Level AA standards.

## Purpose

Identify and fix accessibility issues to ensure interfaces are usable by everyone, including people using assistive technologies.

## Inputs Required

- Component or page code
- Target WCAG level (AA or AAA)

## Audit Process

### 1. Check Semantic HTML Usage

**Proper Structure:**
```jsx
// ❌ Bad: Divs for everything
<div className="header">
  <div className="nav">
    <div onClick={}>Link</div>
  </div>
</div>

// ✅ Good: Semantic elements
<header>
  <nav aria-label="Main navigation">
    <a href="/about">Link</a>
  </nav>
</header>
```

**Key Elements:**
- `<header>`, `<main>`, `<footer>`, `<nav>`, `<aside>`
- `<article>`, `<section>` with headings
- `<button>` for actions, `<a>` for navigation
- `<ul>`, `<ol>` for lists
- `<table>` with proper headers for tabular data

### 2. Verify Color Contrast

**WCAG AA Requirements:**
- Normal text: 4.5:1 minimum
- Large text (18px+ or 14px+ bold): 3:1 minimum
- UI components and graphics: 3:1 minimum

**Testing:**
```javascript
// Use tools like:
// - Chrome DevTools Accessibility panel
// - axe DevTools extension
// - WebAIM Contrast Checker
```

**Common Fixes:**
```css
/* ❌ Low contrast */
.text { color: #888; background: #fff; } /* 3.5:1 */

/* ✅ Sufficient contrast */
.text { color: #595959; background: #fff; } /* 4.5:1 */
```

### 3. Ensure Keyboard Navigation

**All interactive elements must be:**
- Focusable (in tab order)
- Activatable (Enter/Space)
- Have visible focus indicators

```jsx
// ❌ Bad: Click-only interaction
<div onClick={handleClick}>Action</div>

// ✅ Good: Full keyboard support
<button onClick={handleClick}>Action</button>

// ✅ Good: Custom element with keyboard
<div
  role="button"
  tabIndex={0}
  onClick={handleClick}
  onKeyDown={(e) => {
    if (e.key === 'Enter' || e.key === ' ') {
      e.preventDefault();
      handleClick();
    }
  }}
>
  Action
</div>
```

### 4. Check Focus Indicators

```css
/* ❌ Bad: Removing focus */
*:focus { outline: none; }

/* ✅ Good: Visible focus */
*:focus-visible {
  outline: 2px solid var(--color-primary);
  outline-offset: 2px;
}

/* ✅ Good: Custom focus style */
.button:focus-visible {
  box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.4);
}
```

### 5. Verify ARIA Usage

**ARIA Rules:**
1. Don't use ARIA if native HTML works
2. Don't change native semantics unnecessarily
3. All interactive elements must be keyboard accessible
4. Don't hide focusable elements
5. All interactive elements need accessible names

```jsx
// ❌ Unnecessary ARIA
<button role="button">Submit</button>

// ✅ Correct: Native button
<button>Submit</button>

// ✅ Correct: ARIA for custom widgets
<div
  role="slider"
  aria-valuenow={50}
  aria-valuemin={0}
  aria-valuemax={100}
  aria-label="Volume"
  tabIndex={0}
/>
```

### 6. Test Form Labels and Errors

```jsx
// ❌ Bad: No label
<input type="email" placeholder="Email" />

// ✅ Good: Proper labeling
<label htmlFor="email">Email address</label>
<input
  id="email"
  type="email"
  aria-describedby="email-error"
/>
<span id="email-error" role="alert">
  Please enter a valid email
</span>

// ✅ Good: Visually hidden label
<label htmlFor="search" className="sr-only">
  Search
</label>
<input id="search" type="search" placeholder="Search..." />
```

### 7. Check Alt Text on Images

```jsx
// ❌ Bad: Missing alt
<img src="hero.jpg" />

// ❌ Bad: Redundant alt
<img src="hero.jpg" alt="Image of hero" />

// ✅ Good: Descriptive alt
<img src="hero.jpg" alt="Team collaborating in modern office" />

// ✅ Good: Decorative image
<img src="decoration.svg" alt="" role="presentation" />
```

### 8. Verify Heading Hierarchy

```jsx
// ❌ Bad: Skipping levels
<h1>Page Title</h1>
<h3>Section</h3>  {/* Skipped h2 */}

// ✅ Good: Proper hierarchy
<h1>Page Title</h1>
<h2>Section</h2>
<h3>Subsection</h3>
```

## Output Format

```markdown
## Accessibility Audit Report

### Summary

| Category | Issues | Severity |
|----------|--------|----------|
| Semantic HTML | 3 | High |
| Color Contrast | 2 | Medium |
| Keyboard Navigation | 1 | Critical |
| Focus Indicators | 2 | High |
| ARIA Usage | 1 | Medium |
| Forms | 2 | High |
| Images | 1 | Medium |
| Headings | 1 | Low |

### Critical Issues

1. **[Keyboard]** Button not keyboard accessible
   - Location: `ProductCard.tsx:24`
   - Issue: `<div onClick>` not focusable
   - Fix: Change to `<button>` element

### High Priority Issues

2. **[Semantic]** Navigation not marked up correctly
   - Location: `Header.tsx:12`
   - Issue: Using `<div>` instead of `<nav>`
   - Fix: Replace with `<nav aria-label="Main">`

### Fixed Code

```jsx
// Before
<div onClick={addToCart}>Add to Cart</div>

// After
<button
  onClick={addToCart}
  aria-label="Add Product Name to cart"
>
  Add to Cart
</button>
```

### WCAG Compliance Checklist

- [ ] 1.1.1 Non-text Content (A)
- [x] 1.3.1 Info and Relationships (A)
- [x] 1.4.3 Contrast Minimum (AA)
- [ ] 2.1.1 Keyboard (A)
- [x] 2.4.6 Headings and Labels (AA)
- [ ] 4.1.2 Name, Role, Value (A)

### Testing Recommendations

1. Test with screen reader (VoiceOver/NVDA)
2. Navigate entire page with keyboard only
3. Run automated tools (axe, Lighthouse)
4. Test at 200% zoom level
```

## Common Fixes

### Screen Reader Only Text
```css
.sr-only {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
  border: 0;
}
```

### Skip Link
```jsx
<a href="#main" className="skip-link">
  Skip to main content
</a>

<style>
.skip-link {
  position: absolute;
  left: -9999px;
}
.skip-link:focus {
  left: 50%;
  transform: translateX(-50%);
  top: 1rem;
  z-index: 1000;
}
</style>
```

### Live Regions
```jsx
// For dynamic content updates
<div role="status" aria-live="polite">
  {statusMessage}
</div>

// For important alerts
<div role="alert" aria-live="assertive">
  {errorMessage}
</div>
```

### Modal Accessibility
```jsx
<div
  role="dialog"
  aria-modal="true"
  aria-labelledby="modal-title"
  aria-describedby="modal-description"
>
  <h2 id="modal-title">Confirm Action</h2>
  <p id="modal-description">Are you sure?</p>
</div>
```

## Testing Tools

- **Automated**: axe DevTools, Lighthouse, WAVE
- **Screen Readers**: VoiceOver (Mac), NVDA (Windows), JAWS
- **Keyboard**: Tab through entire interface
- **Contrast**: WebAIM Contrast Checker
- **Zoom**: Test at 200% and 400%
