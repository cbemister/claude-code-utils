---
name: component-polish
description: Polish components to production quality — interactive states, micro-interactions, and final refinement. Run all three passes or target one area.
argument-hint: "[states | interactions] — Optional: run just interactive states or micro-interactions. Default: full polish pass (all three)."
---

# Component Polish

Polish components to production quality. Run a full pass or target a specific area.

## Usage

```
/component-polish              — full pass (states + interactions + polish)
/component-polish states       — interactive states only (hover, focus, active, disabled, loading)
/component-polish interactions — micro-interactions only (animations, transitions, entrance effects)
```

## Instructions

Parse the argument and run the specified area. If no argument, run all three in order.

---

## Area: states

Add complete interactive states to components: hover, focus, active, disabled, loading.

**Goals:**
- Every interactive element has all essential states defined
- States are visually distinct and accessible (focus visible to keyboard users)
- Transitions between states are smooth (150ms ease-out for micro, 200ms for larger elements)

**Hover states** — subtle, purposeful changes:
```css
.button:hover { background: var(--color-primary-dark); transform: translateY(-1px); box-shadow: 0 2px 4px rgba(0,0,0,.1); }
.card:hover { border-color: var(--color-border-hover); box-shadow: 0 4px 12px rgba(0,0,0,.08); }
.link:hover { color: var(--color-primary-dark); text-decoration-color: currentColor; }
```

**Focus states** — keyboard-accessible, always visible:
```css
.button:focus-visible { outline: 2px solid var(--color-primary); outline-offset: 2px; }
.input:focus { border-color: var(--color-primary); box-shadow: 0 0 0 3px rgba(37,99,235,.15); outline: none; }
```

**Active/pressed states:**
```css
.button:active { transform: translateY(0); box-shadow: none; background: var(--color-primary-darker); }
.card:active { transform: scale(0.99); }
```

**Disabled states:**
```css
.button:disabled { opacity: 0.5; cursor: not-allowed; pointer-events: none; }
.input:disabled { background: var(--color-gray-100); color: var(--color-gray-400); cursor: not-allowed; }
```

**Loading states:**
```css
.buttonLoading { position: relative; color: transparent; pointer-events: none; }
.buttonLoading::after {
  content: ''; position: absolute; width: 16px; height: 16px;
  border: 2px solid currentColor; border-right-color: transparent;
  border-radius: 50%; animation: spin 0.6s linear infinite;
  top: 50%; left: 50%; transform: translate(-50%, -50%);
}
@keyframes spin { to { transform: translate(-50%, -50%) rotate(360deg); } }
```

**Component-specific state guide:**

| Component | Hover | Focus | Active | Disabled | Loading |
|-----------|-------|-------|--------|----------|---------|
| Button | Darken + lift | Ring outline | Press down | Dim + no-pointer | Spinner, text hidden |
| Input | Border color | Border + glow ring | — | Gray bg | — |
| Card | Shadow + border | focus-within ring | Scale 0.99 | Dim | Skeleton |
| Link | Color + underline | Outline | Darker | Dim | — |
| Toggle | Preview state | Ring | Scale 0.95 | Dim | Spinner |

**Base transition:**
```css
.button { transition: all 0.15s ease-out; }
.card { transition: transform 0.2s ease-out, box-shadow 0.2s ease-out, border-color 0.15s ease-out; }
```

---

## Area: interactions

Add micro-interactions — animations and transitions that make interfaces feel responsive and alive.

**Goals:**
- Hover/press feedback on all interactive elements
- Entrance animations for content that appears dynamically
- Loading states that feel smooth (no jarring spinners)
- All animations respect `prefers-reduced-motion`
- Only animate `transform` and `opacity` for 60fps performance

**Hover effects:**
```css
/* Lift */
.card { transition: transform 0.2s ease-out, box-shadow 0.2s ease-out; }
.card:hover { transform: translateY(-4px); box-shadow: 0 12px 24px rgba(0,0,0,.15); }

/* Underline slide */
.link::after { content: ''; position: absolute; bottom: 0; left: 0; width: 0; height: 2px; background: currentColor; transition: width 0.2s ease-out; }
.link:hover::after { width: 100%; }
```

**Press feedback:**
```css
.button:active { transform: scale(0.98); transition: transform 0.1s ease; }
```

**Entrance animations:**
```css
@keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }
@keyframes slideUp { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }

.fadeIn { animation: fadeIn 0.3s ease-out; }
.slideUp { animation: slideUp 0.4s ease-out; }

/* Stagger for lists */
.staggerItem { opacity: 0; animation: slideUp 0.4s ease-out forwards; }
.staggerItem:nth-child(1) { animation-delay: 0ms; }
.staggerItem:nth-child(2) { animation-delay: 50ms; }
.staggerItem:nth-child(3) { animation-delay: 100ms; }
```

**Loading animations:**
```css
/* Skeleton pulse */
.skeleton { background: var(--color-gray-200); animation: pulse 1.5s ease-in-out infinite; }
@keyframes pulse { 0%, 100% { opacity: 1; } 50% { opacity: 0.5; } }
```

**Common patterns:**
```css
/* Tooltip */
.tooltip { opacity: 0; transform: translateY(4px); transition: all 0.15s ease-out; pointer-events: none; }
.trigger:hover .tooltip { opacity: 1; transform: translateY(0); }

/* Modal */
.modal { opacity: 0; transform: scale(0.95); transition: all 0.3s ease-out; }
.modalOpen { opacity: 1; transform: scale(1); }
```

**Timing guide:**

| Interaction | Duration | Easing |
|-------------|----------|--------|
| Hover on/off | 150ms | ease-out |
| Button press | 100ms | ease |
| Card hover | 200ms | ease-out |
| Modal open | 300ms | ease-out |
| Modal close | 200ms | ease-in |
| Entrance | 300-400ms | ease-out |

**Always include reduced-motion override:**
```css
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    transition-duration: 0.01ms !important;
  }
}
```

---

## Full Polish Pass (default)

When no argument is provided, run all three areas in order, then apply final refinements:

1. **States** — Apply the `states` area above
2. **Interactions** — Apply the `interactions` area above
3. **Design system consistency** — Verify all colors, spacing, typography from tokens
4. **Subtle details** — Layered shadows, inner glows, gradient accents where appropriate
5. **Spacing and alignment** — Optical alignment for icons, consistent rhythm
6. **Accessibility final check** — aria-busy on loaders, aria-invalid on errors, all focus states visible

**Design system consistency check:**
```tsx
// ❌ Inconsistent
<div className="p-3 rounded-md bg-gray-100">
<div className="p-4 rounded-lg bg-slate-50">

// ✅ Consistent
<div className="p-4 rounded-lg bg-surface">
```

**Refined shadows:**
```css
.card { box-shadow: 0 1px 2px rgba(0,0,0,.04), 0 4px 8px rgba(0,0,0,.04); }
.cardElevated { box-shadow: 0 2px 4px rgba(0,0,0,.04), 0 8px 16px rgba(0,0,0,.08); }
```

**Polish checklist:**
- [ ] All design tokens used (no hardcoded values)
- [ ] All interactive states present (hover, focus, active, disabled, loading)
- [ ] Entrance animations on dynamic content
- [ ] Skeleton loading states instead of spinners for content loads
- [ ] Error states styled with accessible messaging
- [ ] Touch targets ≥ 44px on mobile
- [ ] Focus indicators visible and styled
- [ ] `prefers-reduced-motion` respected
- [ ] No layout shift on state change
- [ ] Responsive at all breakpoints
