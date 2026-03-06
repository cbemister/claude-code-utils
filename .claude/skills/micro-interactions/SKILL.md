---
name: micro-interactions
description: Add subtle animations and transitions that make interfaces feel responsive and alive. Designs hover effects, press states, entrance animations, and loading states with 60fps performance.
---

# Micro-Interaction Design

You are an animation expert specializing in creating subtle, performant micro-interactions that make interfaces feel responsive and delightful.

## Purpose

Add subtle animations and transitions that make interfaces feel responsive, alive, and professionally crafted without being distracting.

## Inputs Required

- Component code
- Interaction points (buttons, links, cards, etc.)
- Animation style preference (subtle, playful, minimal)

## Design Process

### 1. Identify Interaction Opportunities

**User Actions:**
- Button clicks
- Link hovers
- Card interactions
- Form submissions
- Toggle switches
- Menu opens/closes

**System Feedback:**
- Loading states
- Success confirmations
- Error notifications
- Progress updates
- Content loading

### 2. Design Hover Effects

**Scale Effect (Subtle):**
```css
.card {
  transition: transform 0.2s ease-out;
}

.card:hover {
  transform: scale(1.02);
}
```

**Lift Effect:**
```css
.card {
  transition: transform 0.2s ease-out, box-shadow 0.2s ease-out;
}

.card:hover {
  transform: translateY(-4px);
  box-shadow: 0 12px 24px rgba(0, 0, 0, 0.15);
}
```

**Color Shift:**
```css
.button {
  transition: background-color 0.15s ease;
}

.button:hover {
  background-color: var(--color-primary-dark);
}
```

**Underline Animation:**
```css
.link {
  position: relative;
}

.link::after {
  content: '';
  position: absolute;
  bottom: 0;
  left: 0;
  width: 0;
  height: 2px;
  background: currentColor;
  transition: width 0.2s ease-out;
}

.link:hover::after {
  width: 100%;
}
```

### 3. Add Press/Active States

```css
.button:active {
  transform: scale(0.98);
  transition: transform 0.1s ease;
}

.card:active {
  transform: scale(0.99);
}
```

### 4. Create Entrance Animations

**Fade In:**
```css
@keyframes fadeIn {
  from {
    opacity: 0;
  }
  to {
    opacity: 1;
  }
}

.fadeIn {
  animation: fadeIn 0.3s ease-out;
}
```

**Slide Up:**
```css
@keyframes slideUp {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.slideUp {
  animation: slideUp 0.4s ease-out;
}
```

**Stagger Effect:**
```css
.staggerItem {
  opacity: 0;
  animation: slideUp 0.4s ease-out forwards;
}

.staggerItem:nth-child(1) { animation-delay: 0ms; }
.staggerItem:nth-child(2) { animation-delay: 50ms; }
.staggerItem:nth-child(3) { animation-delay: 100ms; }
.staggerItem:nth-child(4) { animation-delay: 150ms; }
```

### 5. Implement Loading Animations

**Spinner:**
```css
@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}

.spinner {
  width: 20px;
  height: 20px;
  border: 2px solid currentColor;
  border-right-color: transparent;
  border-radius: 50%;
  animation: spin 0.6s linear infinite;
}
```

**Pulse:**
```css
@keyframes pulse {
  0%, 100% {
    opacity: 1;
  }
  50% {
    opacity: 0.5;
  }
}

.skeleton {
  background: var(--color-gray-200);
  animation: pulse 1.5s ease-in-out infinite;
}
```

**Progress Bar:**
```css
@keyframes progress {
  from {
    width: 0;
  }
  to {
    width: 100%;
  }
}

.progressBar {
  animation: progress 2s ease-out;
}
```

### 6. Add Smooth Transitions

**Recommended Durations:**
- Micro (hover, active): 100-150ms
- Standard (menus, tooltips): 200-250ms
- Complex (modals, page transitions): 300-400ms

**Easing Functions:**
```css
/* Ease out - starts fast, ends slow (most common) */
transition: all 0.2s ease-out;

/* Ease in-out - smooth start and end */
transition: all 0.3s ease-in-out;

/* Custom cubic-bezier for spring effect */
transition: all 0.4s cubic-bezier(0.34, 1.56, 0.64, 1);
```

### 7. Ensure 60fps Performance

**Only animate these properties:**
- `transform` (translate, scale, rotate)
- `opacity`

**Avoid animating:**
- `width`, `height`
- `margin`, `padding`
- `top`, `left`, `right`, `bottom`
- `border-radius`
- `box-shadow` (use opacity tricks instead)

**Performance tricks:**
```css
/* Use transform instead of top/left */
.tooltip {
  transform: translateY(-10px);
  /* Not: top: -10px; */
}

/* Promote to GPU layer for complex animations */
.animatedElement {
  will-change: transform;
  /* Remove will-change after animation completes */
}
```

## Output Format

```markdown
## Micro-Interaction Enhancement

### Interactions Added

| Element | Interaction | Animation | Duration |
|---------|-------------|-----------|----------|
| Button | Hover | Scale + shadow | 150ms |
| Card | Hover | Lift + shadow | 200ms |
| Link | Hover | Underline slide | 200ms |
| Modal | Open | Fade + scale | 300ms |

### Updated Component

```tsx
// Button.tsx
export function Button({ children, ...props }) {
  return (
    <button className={styles.button} {...props}>
      {children}
    </button>
  );
}
```

```css
/* Button.module.css */
.button {
  /* Base styles */
  padding: 0.5rem 1rem;
  background: var(--color-primary);
  border-radius: var(--radius-md);

  /* Animation setup */
  transition:
    transform 0.15s ease-out,
    background-color 0.15s ease,
    box-shadow 0.15s ease-out;
}

.button:hover {
  background: var(--color-primary-dark);
  transform: translateY(-1px);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
}

.button:active {
  transform: translateY(0) scale(0.98);
  box-shadow: none;
}
```

### Animation Specifications

| Property | Value | Note |
|----------|-------|------|
| Hover duration | 150ms | Quick feedback |
| Active duration | 100ms | Immediate response |
| Easing | ease-out | Natural deceleration |
| Transform origin | center | Default |

### Performance Notes

- All animations use transform/opacity only
- No layout thrashing
- Tested at 60fps on mid-range devices
```

## Style Guidelines

### Subtle (Professional)
- Small movements (1-4px)
- Quick durations (100-200ms)
- Opacity changes (0.8-1)
- Minimal color shifts

### Modern (Default)
- Medium movements (4-8px)
- Standard durations (200-300ms)
- Shadow additions
- Scale transforms (1.02-1.05)

### Playful (Creative)
- Larger movements (8-16px)
- Longer durations (300-400ms)
- Bounce/spring easings
- Rotation/skew transforms

## Motion Preferences

Always respect user preferences:
```css
@media (prefers-reduced-motion: reduce) {
  *,
  *::before,
  *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
  }
}
```

## Common Patterns

### Tooltip Appearance
```css
.tooltip {
  opacity: 0;
  transform: translateY(4px);
  transition: all 0.15s ease-out;
  pointer-events: none;
}

.trigger:hover .tooltip {
  opacity: 1;
  transform: translateY(0);
  pointer-events: auto;
}
```

### Menu Slide
```css
.menu {
  transform: translateX(-100%);
  transition: transform 0.3s ease-out;
}

.menuOpen {
  transform: translateX(0);
}
```

### Modal Animation
```css
.overlay {
  opacity: 0;
  transition: opacity 0.3s ease-out;
}

.modal {
  opacity: 0;
  transform: scale(0.95);
  transition: all 0.3s ease-out;
}

.overlayOpen {
  opacity: 1;
}

.modalOpen {
  opacity: 1;
  transform: scale(1);
}
```
