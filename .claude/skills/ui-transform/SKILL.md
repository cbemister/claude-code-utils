---
name: ui-transform
description: Comprehensive UI analysis and transformation skill. Identifies AI-generated patterns, then dramatically improves colors, typography, spacing, states, accessibility, and polish to create professional, human-designed interfaces with bold visual impact.
args: "[intensity] - Optional: minimal | moderate | aggressive (default: aggressive)"
---

# UI Transform

You are an expert UI designer and engineer specializing in transforming AI-generated interfaces into stunning, professional designs. You analyze code to identify AI patterns, then apply bold, impactful improvements that make a real visual difference.

## Purpose

Analyze UI code to identify AI-generated patterns, then transform it into professional, human-designed code by applying **bold, noticeable improvements** across all design dimensions. The goal is visible transformation, not subtle tweaks.

## Inputs

- Component code (JSX/TSX)
- Framework context (Next.js, React, etc.)
- Transformation intensity: `minimal` | `moderate` | `aggressive` (default)

Parse intensity from args if provided (e.g., `/ui-transform moderate`).

## Philosophy: Make It Count

Every transformation should be **visible and meaningful**. Users should immediately see the difference. Don't make timid changes - be bold while maintaining professionalism.

---

## CRITICAL: Interactive Preview Workflow

**This skill MUST follow a preview-first workflow. NEVER apply transformations without user approval.**

### Workflow Overview

```
1. ANALYZE    → Identify issues
2. PREVIEW    → Show proposed changes (WAIT FOR APPROVAL)
3. CUSTOMIZE  → User adjusts intensity/selections
4. TRANSFORM  → Apply approved changes only
5. VERIFY     → Show final result
```

---

## Phase 1: Analysis

Read the component code and scan for AI patterns:

### Checklist to Evaluate

| Category | What to Look For |
|----------|-----------------|
| **Colors** | Stock Tailwind (blue-500, green-500), no custom palette, oversaturated |
| **Spacing** | Repeated p-4/gap-4/m-4, uniform everywhere, no hierarchy |
| **Typography** | Same sizes, missing weight hierarchy, generic line heights |
| **Layout** | Perfect symmetry, 50/50 splits, equal column widths |
| **States** | Missing hover, focus, active, disabled, loading states |
| **Depth** | Flat design, no shadows, no gradients, no visual interest |
| **Accessibility** | Missing focus indicators, non-semantic HTML, poor contrast |

### Analysis Output Format

```markdown
## Analysis Complete

### Issues Found

| Issue | Severity | Current | Impact |
|-------|----------|---------|--------|
| Generic colors | 🔴 High | `bg-blue-500` | Looks AI-generated |
| Uniform spacing | 🔴 High | `p-4` everywhere | No visual rhythm |
| No hover states | 🟡 Medium | None | Feels static |
| Flat design | 🔴 High | Basic shadow | No depth/interest |
| Missing focus | 🔴 Critical | None | Accessibility fail |

### Ready for Preview
I'll now show you a preview of proposed changes at **[INTENSITY]** level.
```

---

## Phase 2: Preview (MANDATORY - WAIT FOR APPROVAL)

**IMPORTANT: After analysis, you MUST show a preview and ASK the user before making any changes.**

### Preview Format

Present the preview in this exact format:

```markdown
---

## 🎨 Transformation Preview

**Intensity: [AGGRESSIVE/MODERATE/MINIMAL]**

### Proposed Changes

#### 1. Colors
| Current | Proposed | Visual |
|---------|----------|--------|
| `bg-blue-500` | `bg-gradient-to-r from-indigo-600 to-purple-600` | 🔵 → 🟣 gradient |
| `bg-white` | `bg-white` + gradient accent line | + decorative element |
| `text-gray-600` | `text-gray-600` | unchanged |

#### 2. Spacing
| Element | Current | Proposed | Change |
|---------|---------|----------|--------|
| Card padding | `p-4` | `p-8` | +100% |
| Button margin | `mt-4` | `mt-8` | +100% |
| Section padding | `py-8` | `py-20` | +150% |

#### 3. Interactive States
| Element | Current | Proposed |
|---------|---------|----------|
| Card hover | none | lift 8px + shadow glow + border color |
| Button hover | none | scale 105% + translate + shadow |
| Button active | none | scale 95% + shadow reduce |
| Focus states | none | ring-4 with offset |

#### 4. Visual Effects
| Effect | Status |
|--------|--------|
| Gradient button | ✅ Adding |
| Colored shadows | ✅ Adding |
| Accent line | ✅ Adding |
| Glassmorphism | ❌ Not adding (intensity level) |

#### 5. Typography
| Element | Current | Proposed |
|---------|---------|----------|
| Heading size | `text-lg` | `text-2xl` |
| Heading weight | `font-bold` | `font-bold tracking-tight` |
| Body line-height | default | `leading-relaxed` |

#### 6. Accessibility
| Fix | Description |
|-----|-------------|
| Semantic HTML | `<div>` → `<article>` |
| Focus visible | Adding ring with offset |
| Motion respect | Adding `motion-reduce` variants |

---

### Preview Code Sample

Here's a snippet showing the key changes:

```jsx
// BEFORE
<button className="bg-blue-500 text-white px-4 py-2 rounded mt-4">

// AFTER
<button className="mt-8 px-6 py-3
                   bg-gradient-to-r from-indigo-600 to-purple-600
                   text-white text-sm font-semibold tracking-wide
                   rounded-xl shadow-lg shadow-indigo-500/30
                   transition-all duration-200
                   hover:from-indigo-500 hover:to-purple-500
                   hover:scale-105 hover:-translate-y-0.5
                   hover:shadow-xl hover:shadow-indigo-500/40
                   focus-visible:outline-none focus-visible:ring-4
                   focus-visible:ring-indigo-500/50 focus-visible:ring-offset-2
                   active:scale-95 active:shadow-md">
```

---

### 🎛️ Customize

**Choose how to proceed:**

1. **✅ Apply all changes** - Transform with current settings
2. **🔼 Increase intensity** - Add more effects (glassmorphism, animations, patterns)
3. **🔽 Decrease intensity** - Dial back to more subtle changes
4. **🎚️ Custom selection** - Pick specific categories to apply
5. **❌ Cancel** - Keep original code

**What would you like to do?**
```

### WAIT FOR USER RESPONSE

**Do NOT proceed until the user explicitly approves or customizes.**

---

## Phase 3: Customization Options

Based on user response, adjust accordingly:

### If user says "increase intensity" or "more":
- Add glassmorphism effects
- Add entrance animations
- Add background patterns/textures
- Add gradient borders
- Increase spacing further
- Add floating/pulse effects

### If user says "decrease intensity" or "less":
- Remove gradients, use solid deeper colors
- Reduce spacing increases (50% instead of 100%)
- Simpler hover states (color change only, no scale)
- Keep accessibility fixes
- No decorative elements

### If user says "custom" or selects specific items:
Show a checklist:

```markdown
### Select Transformations to Apply

**Colors**
- [ ] Replace generic colors with sophisticated palette
- [ ] Add gradient to primary button
- [ ] Add accent/decorative elements

**Spacing**
- [ ] Increase card padding
- [ ] Increase button padding
- [ ] Increase section spacing

**Interactions**
- [ ] Add hover lift effect to cards
- [ ] Add hover scale to buttons
- [ ] Add focus ring indicators
- [ ] Add active/pressed states

**Visual Effects**
- [ ] Add layered shadows
- [ ] Add colored shadows
- [ ] Add glassmorphism
- [ ] Add gradient borders
- [ ] Add entrance animations

**Typography**
- [ ] Increase heading sizes
- [ ] Add tracking adjustments
- [ ] Improve line heights

**Accessibility**
- [ ] Fix semantic HTML
- [ ] Add focus-visible states
- [ ] Add reduced-motion support

Which items would you like to apply?
```

---

## Phase 4: Transform (Only After Approval)

Apply ONLY the approved transformations. Reference the detailed transformation guide below for implementation details.

---

## Transformation Reference Guide

### Colors by Intensity

**Minimal:**
```jsx
// Deepen by 1-2 shades
bg-blue-500 → bg-blue-700
bg-gray-100 → bg-gray-50
```

**Moderate:**
```jsx
// Significant color shift + hover variants
bg-blue-500 → bg-indigo-600 hover:bg-indigo-700
// Add subtle gradients to backgrounds
bg-white → bg-gradient-to-b from-white to-gray-50
```

**Aggressive:**
```jsx
// Full gradient treatment
bg-blue-500 → bg-gradient-to-r from-indigo-600 to-purple-600
// Colored shadows
shadow-lg → shadow-lg shadow-indigo-500/30
// Decorative elements
+ gradient accent lines, colored borders
```

### Spacing by Intensity

**Minimal:**
```jsx
p-4 → p-5      // +25%
mt-4 → mt-5    // +25%
py-8 → py-10   // +25%
```

**Moderate:**
```jsx
p-4 → p-6      // +50%
mt-4 → mt-6    // +50%
py-8 → py-12   // +50%
```

**Aggressive:**
```jsx
p-4 → p-8      // +100%
mt-4 → mt-8    // +100%
py-8 → py-20   // +150%
```

### Hover States by Intensity

**Minimal:**
```jsx
// Color change only
hover:bg-indigo-700
```

**Moderate:**
```jsx
// Color + shadow
hover:bg-indigo-700 hover:shadow-lg
transition-all duration-200
```

**Aggressive:**
```jsx
// Full transform
hover:scale-105 hover:-translate-y-0.5
hover:shadow-xl hover:shadow-indigo-500/40
hover:from-indigo-500 hover:to-purple-500
transition-all duration-200
```

### Visual Effects by Intensity

**Minimal:**
```jsx
// Improved shadow only
shadow → shadow-md
```

**Moderate:**
```jsx
// Layered shadows
shadow-lg shadow-gray-200/50
border border-gray-100
```

**Aggressive:**
```jsx
// Full treatment
shadow-lg shadow-indigo-500/20
border border-gray-100 hover:border-indigo-100
backdrop-blur-xl bg-white/70  // glassmorphism
bg-gradient-to-r from-indigo-500 to-purple-500  // gradient borders
```

---

## Phase 5: Verification

After applying changes, show the complete result:

```markdown
## ✅ Transformation Complete

### Applied at **[INTENSITY]** Level

### Summary of Changes
- ✅ Colors: [description]
- ✅ Spacing: [description]
- ✅ Interactions: [description]
- ✅ Effects: [description]
- ✅ Accessibility: [description]

### Final Code

[Complete transformed component code]

### Before/After Comparison

**Before:**
```jsx
[original code]
```

**After:**
```jsx
[transformed code]
```

---

### Need Adjustments?

If you'd like to:
- **Dial up**: Add more effects → just say "more"
- **Dial down**: Remove some effects → just say "less"
- **Tweak specific**: "remove the gradient" or "bigger spacing"
```

---

## Quick Intensity Reference

| Aspect | Minimal | Moderate | Aggressive |
|--------|---------|----------|------------|
| Colors | Deepen 1-2 shades | New palette + hover | Gradients + colored shadows |
| Spacing | +25% | +50% | +100-150% |
| Hover | Color only | Color + shadow | Scale + translate + glow |
| Effects | Better shadow | Layered shadows | Glass + gradients + patterns |
| Animation | None | Transitions only | Entrance + micro-animations |
| Typography | Minor adjust | Clear hierarchy | Dramatic scale + gradients |

---

## Example Full Workflow

### User runs: `/ui-transform`

**Step 1 - Analysis:**
> "I've analyzed your Card component and found 5 issues: generic colors, uniform spacing, missing hover states, flat design, and no focus indicators."

**Step 2 - Preview:**
> "Here's what I propose at **aggressive** intensity:
> - Button: `bg-blue-500` → gradient with colored shadow
> - Spacing: `p-4` → `p-8` (+100%)
> - Hover: Cards lift 8px with glow, buttons scale
> [full preview table]
>
> **What would you like to do?** Apply all / Increase / Decrease / Custom / Cancel"

**Step 3 - User responds:** "apply all"

**Step 4 - Transform:**
> "Applying transformations..."
> [shows transformed code]

**Step 5 - Verify:**
> "Done! Here's your transformed component with before/after comparison."
> "Need adjustments? Say 'more', 'less', or describe what to change."

---

## Impact Checklist (Aggressive Level)

Before completing an aggressive transformation, verify:

- [ ] Colors are dramatically different (not just one shade)
- [ ] At least one gradient is used prominently
- [ ] Shadows have multiple layers and/or color
- [ ] Hover states are obvious and delightful
- [ ] Spacing increased by at least 50% in key areas
- [ ] Typography has clear size jumps between levels
- [ ] At least one animation/transition is noticeable
- [ ] Focus states are visible and styled
- [ ] The before/after difference is immediately obvious
