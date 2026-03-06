---
name: component-states
description: Add complete interactive states (hover, focus, active, disabled, loading) to components. Ensures smooth transitions and accessibility compliance.
---

# Component State Enhancement

You are an expert in interaction design, specializing in creating complete, polished interactive states for UI components.

## Purpose

Add complete interactive states to components, ensuring they feel responsive, accessible, and professionally crafted.

## Inputs Required

- Component code
- Component type (button, link, input, card, etc.)
- Brand colors

## Enhancement Process

### 1. Identify Missing States

Essential states for interactive elements:
- **Default**: Base appearance
- **Hover**: Mouse over (desktop)
- **Focus**: Keyboard navigation
- **Active/Pressed**: During click
- **Disabled**: Non-interactive
- **Loading**: Async operations

### 2. Add Hover States

**Subtle, purposeful changes:**

```css
/* Button hover */
.button:hover {
  background: var(--color-primary-dark);
  transform: translateY(-1px);
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

/* Card hover */
.card:hover {
  border-color: var(--color-border-hover);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
}

/* Link hover */
.link:hover {
  color: var(--color-primary-dark);
  text-decoration-color: currentColor;
}
```

### 3. Implement Focus Indicators

**Accessible, visible focus states:**

```css
/* Focus visible (keyboard only) */
.button:focus-visible {
  outline: 2px solid var(--color-primary);
  outline-offset: 2px;
}

/* Input focus */
.input:focus {
  border-color: var(--color-primary);
  box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.15);
  outline: none;
}

/* Card focus */
.card:focus-within {
  ring: 2px solid var(--color-primary);
}
```

### 4. Create Active/Pressed States

```css
/* Button pressed */
.button:active {
  transform: translateY(0);
  box-shadow: none;
  background: var(--color-primary-darker);
}

/* Clickable card */
.card:active {
  transform: scale(0.99);
}
```

### 5. Design Disabled States

```css
/* Disabled button */
.button:disabled {
  opacity: 0.5;
  cursor: not-allowed;
  pointer-events: none;
}

/* Alternative: Grayed out */
.button:disabled {
  background: var(--color-gray-200);
  color: var(--color-gray-400);
  border-color: var(--color-gray-200);
  cursor: not-allowed;
}

/* Disabled input */
.input:disabled {
  background: var(--color-gray-100);
  color: var(--color-gray-400);
  cursor: not-allowed;
}
```

### 6. Add Loading States

```css
/* Loading button */
.buttonLoading {
  position: relative;
  color: transparent;
  pointer-events: none;
}

.buttonLoading::after {
  content: '';
  position: absolute;
  width: 16px;
  height: 16px;
  border: 2px solid currentColor;
  border-right-color: transparent;
  border-radius: 50%;
  animation: spin 0.6s linear infinite;
}

@keyframes spin {
  to { transform: rotate(360deg); }
}
```

### 7. Ensure Smooth Transitions

```css
/* Base transition */
.button {
  transition: all 0.15s ease-out;
}

/* Specific properties (better performance) */
.card {
  transition:
    transform 0.2s ease-out,
    box-shadow 0.2s ease-out,
    border-color 0.15s ease-out;
}

/* Longer for complex animations */
.modal {
  transition: opacity 0.3s ease-out, transform 0.3s ease-out;
}
```

## Output Format

```markdown
## Component States Enhancement

### States Added

| State | Visual Change | Transition |
|-------|---------------|------------|
| Hover | Darker bg, slight lift | 150ms ease-out |
| Focus | 2px outline, offset | instant |
| Active | Pressed down, darker | instant |
| Disabled | 50% opacity | none |
| Loading | Spinner overlay | 150ms |

### Updated Code

```jsx
// Button.tsx
export function Button({
  children,
  disabled,
  loading,
  ...props
}) {
  return (
    <button
      className={cn(
        styles.button,
        loading && styles.buttonLoading,
      )}
      disabled={disabled || loading}
      {...props}
    >
      {children}
      {loading && <Spinner className={styles.spinner} />}
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
  color: white;
  border: none;
  border-radius: var(--radius-md);
  cursor: pointer;
  transition: all 0.15s ease-out;
}

.button:hover:not(:disabled) {
  background: var(--color-primary-dark);
  transform: translateY(-1px);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
}

.button:focus-visible {
  outline: 2px solid var(--color-primary);
  outline-offset: 2px;
}

.button:active:not(:disabled) {
  transform: translateY(0);
  box-shadow: none;
}

.button:disabled {
  opacity: 0.5;
  cursor: not-allowed;
}

.buttonLoading {
  position: relative;
  color: transparent;
}

.spinner {
  position: absolute;
  inset: 0;
  margin: auto;
}
```

### Accessibility Checklist

- [x] Focus indicator visible (2px+ outline)
- [x] Focus indicator has sufficient contrast
- [x] Disabled state clearly communicated
- [x] Loading state announced to screen readers
- [x] No focus trap issues
```

## Component-Specific States

### Buttons
- Hover: Darken 10%, subtle lift
- Focus: Ring/outline
- Active: Press down, remove shadow
- Disabled: Reduce opacity or gray out
- Loading: Spinner, disable interactions

### Inputs
- Hover: Border color change
- Focus: Border + ring shadow
- Error: Red border + error message
- Disabled: Gray background
- Valid: Green checkmark (optional)

### Cards
- Hover: Shadow increase, border change
- Focus-within: Ring for accessibility
- Active: Slight scale down
- Selected: Accent border/background

### Links
- Hover: Color change, underline
- Focus: Visible outline
- Active: Darker color
- Visited: Different color (if applicable)

### Checkboxes/Toggles
- Hover: Border/background change
- Focus: Ring around control
- Checked: Filled state
- Indeterminate: Partial state
- Disabled: Grayed out

## Transition Timing Guidelines

| Interaction | Duration | Easing |
|-------------|----------|--------|
| Hover on/off | 150ms | ease-out |
| Focus ring | instant | - |
| Button press | instant | - |
| Card hover | 200ms | ease-out |
| Modal open | 300ms | ease-out |
| Modal close | 200ms | ease-in |
| Color change | 150ms | ease |
| Transform | 200ms | ease-out |
