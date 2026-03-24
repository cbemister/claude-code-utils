---
name: design-app
description: Generate multiple design concepts for an app, compare them side-by-side, and implement the chosen direction. Creates detailed design documents with color palettes, typography, spacing, component specs, and interactive HTML mockups.
argument-hint: "[count] - Optional: number of concepts to generate (default: 3, max: 7)"
---

# Design App

Generate multiple competing design concepts for an app, present them for comparison, and implement the chosen direction into the codebase.

## Instructions

**IMPORTANT: Execute immediately. If context about the app is available from CLAUDE.md or the current project, use it. Otherwise, gather requirements first.**

---

## Step 1: Gather Design Context

### 1A: Understand the App

Read `CLAUDE.md`, `README.md`, `package.json`, and any existing design files to understand:

- **What the app does** — core purpose and key screens
- **Target users** — who uses this and in what context
- **Tech stack** — framework, styling approach (Tailwind, CSS Modules, styled-components, NativeWind, etc.)
- **Existing design** — any colors, fonts, or components already in place

If the app context is unclear, use **AskUserQuestion** to ask:

> What is this app? Who is it for? Describe the core screens and the feeling you want it to evoke. Any design directions you're drawn to or want to avoid?

### 1B: Set Concept Count

Use the `$ARGS` count if provided, otherwise default to **3** concepts. Cap at 7.

### 1C: Select Design Directions

Choose contrasting design directions that suit the app. Pull from this palette of approaches — select directions that are **meaningfully different** from each other so the comparison is valuable:

| Direction | Personality | Best For |
|-----------|-------------|----------|
| Modern Minimal | Clean, focused, typographic | Developer tools, productivity, SaaS |
| Warm Craft | Tactile, analog, personal | Journals, note-taking, personal apps |
| Dev Dark | IDE-inspired, dense, precise | Developer-facing tools, dashboards |
| Bold Vibrant | Energetic, confident, colorful | Consumer apps, creative tools, social |
| Glassmorphism | Layered, translucent, depth | Premium SaaS, dashboards, iOS-style |
| Swiss Precision | Grid-governed, typographic, systematic | Data apps, corporate, editorial |
| Organic Flow | Natural, biophilic, calming | Wellness, community, eco-focused |
| Dark Premium | Rich, glowing, sophisticated | Fintech, dev tools, premium SaaS |
| Retro Synthwave | Nostalgic, neon, playful | Games, entertainment, creative |
| Brutalist | Raw, bold, unconventional | Portfolios, agencies, counter-culture |

Don't just pick the first N — select directions that create interesting tension. For example, {Modern Minimal, Warm Craft, Dev Dark} gives three very different takes on a productivity app.

---

## Step 2: Create Design Concepts Directory

Create the output directory structure:

```
docs/design-concepts/
├── concept-1-[direction-slug].md
├── concept-2-[direction-slug].md
├── concept-3-[direction-slug].md
├── mockups/
│   ├── concept-1-[direction-slug].html
│   ├── concept-2-[direction-slug].html
│   └── concept-3-[direction-slug].html
└── COMPARISON.md
```

If `docs/design-concepts/` already exists, check for existing concepts and ask whether to replace or add to them.

---

## Step 3: Generate Design Concept Documents

For **each concept**, generate a complete design document following this structure. Every concept must be fully specified — detailed enough that someone could implement it without asking questions.

### Concept Document Structure

```markdown
# Design Concept N: [Direction Name]

**Direction:** [1-2 sentence summary of the visual approach]
**Personality:** [3-4 adjectives]
**Emotion:** [What the user should feel using this app]
**Audience:** [Who this design speaks to]

---

## 1. Design Philosophy & Inspiration

### Core Principles
[4-5 numbered principles that govern every design decision]

### Inspiration Sources
[5-6 real products/designers/movements — be specific, not generic]

### What Makes This NOT AI-Generated
[6-8 specific anti-patterns: why this won't look like default Tailwind/Bootstrap.
Call out exact decisions — specific hex values instead of generic blue,
asymmetric spacing instead of uniform p-4, distinctive font pairings
instead of just Inter, etc.]

---

## 2. Complete Color Palette

### Design Rationale
[Why these specific colors — what metaphor or material they reference]

### Light Mode
[Full token list with hex values, organized by category:
- Background & Surfaces (4-6 tokens)
- Text hierarchy (4 tokens)
- Accent colors (3-4 tokens + muted variants)
- Borders & Dividers (3 tokens)
- Task/State colors (map to app states)
- Semantic colors (success, warning, error, info)]

### Dark Mode
[Complete alternate palette — not just "invert the colors" but a
thoughtfully designed dark variant]

### Contrast Verification
[Table showing key text/background combinations with WCAG AA/AAA results]

### Tailwind/CSS Configuration
[Ready-to-paste config for the project's styling approach]

---

## 3. Typography System

### Font Choices & Rationale
[2-3 fonts with reasoning for each choice.
Include Google Fonts import URL or system font stack.]

### Type Scale
[Table with 8-10 styles: display, title, heading, body, body-medium,
secondary, caption, overline, mono — each with size, weight,
line-height, letter-spacing, and usage]

### Font Loading Strategy
[How to load fonts for the project's framework — @font-face,
Google Fonts link, next/font, expo-font, etc.]

---

## 4. Spacing System

### Scale
[Token-based scale (space-1 through space-16) with pixel values
and usage guidelines for proximity grouping]

### Spacing Rules
[When to use tight vs. loose spacing based on content relationships]

---

## 5. Component Designs

Detail the visual treatment for core components. For each, specify:
- Default state appearance
- Hover/focus/active/disabled states
- Dimensions and padding
- Border radius, shadows, transitions
- Color token references (not raw hex in components)

### Components to Specify:
1. **Button** — Primary, Secondary, Ghost variants
2. **Card** — Content container with elevation
3. **Text Input** — Default, focus, error, disabled
4. **Navigation** — Tab bar or sidebar pattern
5. **List Item** — The primary repeating element
6. **Badge/Tag** — Status indicators
7. **Modal/Dialog** — Overlay pattern

### Layout Patterns
[Key screen layouts — how the navigation, content area, and
action zones are arranged. Include responsive breakpoints if web.]

---

## 6. Motion & Interaction

### Transition Tokens
[Duration and easing values for micro-interactions]

### Key Animations
[Hover effects, page transitions, loading states, state changes]

---

## 7. Implementation Notes

### File Mapping
[Which existing files need changes, which new files to create]

### Migration Path
[If existing design exists — how to incrementally adopt this concept]

### Design Tokens Export
[Complete token set in the format the project uses — CSS variables,
Tailwind config, or JS/TS theme object]
```

### Quality Standards for Each Concept

- **Every hex value must be intentional** — no generic blue (#3B82F6), green (#22C55E), or gray (#6B7280) from Tailwind defaults unless deliberately chosen
- **Color palettes must include WCAG contrast verification** for text/background combinations
- **Typography must specify actual font names** with fallback stacks, not just "sans-serif"
- **Component specs must include all interactive states** — not just the default appearance
- **Dark mode must be a thoughtful redesign**, not auto-inverted colors
- **Spacing must use a consistent scale**, not arbitrary pixel values

---

## Step 4: Generate HTML Mockups

For **each concept**, generate a single-file HTML mockup that demonstrates the design in action. The mockup must be self-contained (inline CSS, no external dependencies except Google Fonts).

### Mockup Requirements

1. **Theme toggle** — Light/dark mode switch in the top corner
2. **Representative screen** — Show the app's primary screen with real-looking content (not lorem ipsum)
3. **Component showcase** — Display all specified components in their various states
4. **Interactive states** — Hover effects, focus states, and transitions must work
5. **Responsive** — Must look reasonable on both desktop and mobile widths
6. **Color palette strip** — Visual swatch bar showing all key colors

### Mobile App Device Frame

If the target app is a **mobile app** (React Native, Flutter, Expo, etc.), wrap the mockup content inside a phone simulator frame:

- **Device bezel** — Rounded rectangle with realistic proportions (e.g., 390×844 for iPhone, 360×800 for Android)
- **Status bar** — Time, battery, signal indicators at the top
- **Home indicator** — Bottom bar for gesture-nav devices
- **Centered on page** — The phone frame sits centered on a neutral background, with the design rendered inside at native resolution
- **Device picker** — Optional toggle between iPhone and Android frame proportions
- The component showcase section can render **outside** the phone frame (below it) at full width

This gives a realistic preview of how the design will feel on a real device, rather than stretching to fill the browser window.

For **web and desktop apps**, render the mockup at full browser width as normal — no device frame needed.

### HTML Mockup Structure

```html
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>[App Name] — Concept N: [Direction]</title>
  <!-- Google Fonts -->
  <style>
    /* CSS Custom Properties for all design tokens */
    :root { /* light mode tokens */ }
    [data-theme="dark"] { /* dark mode tokens */ }

    /* Full component styles using only token references */
    /* Interactive states */
    /* Responsive breakpoints */
    /* Theme toggle styles */
  </style>
</head>
<body>
  <!-- Theme toggle button -->
  <!-- App header/navigation -->
  <!-- Primary screen mockup with realistic content -->
  <!-- Component showcase section -->
  <!-- Color palette visualization -->

  <script>
    // Theme toggle logic
    // Any interactive behavior
  </script>
</body>
</html>
```

---

## Step 5: Generate Comparison Document

Create `docs/design-concepts/COMPARISON.md` that summarizes all concepts side-by-side:

```markdown
# Design Concepts Comparison

## Overview

| Aspect | Concept 1: [Name] | Concept 2: [Name] | Concept 3: [Name] |
|--------|-------------------|-------------------|-------------------|
| **Direction** | [1-line] | [1-line] | [1-line] |
| **Personality** | [adjectives] | [adjectives] | [adjectives] |
| **Primary Color** | [name + hex swatch] | [name + hex swatch] | [name + hex swatch] |
| **Font Pairing** | [heading + body] | [heading + body] | [heading + body] |
| **Dark Mode** | [approach] | [approach] | [approach] |
| **Strengths** | [2-3 bullets] | [2-3 bullets] | [2-3 bullets] |
| **Trade-offs** | [2-3 bullets] | [2-3 bullets] | [2-3 bullets] |
| **Best If** | [when to pick] | [when to pick] | [when to pick] |

## Mockup Links

- [Concept 1: [Name]](mockups/concept-1-[slug].html)
- [Concept 2: [Name]](mockups/concept-2-[slug].html)
- [Concept 3: [Name]](mockups/concept-3-[slug].html)

## Design Philosophy Comparison

[2-3 paragraphs comparing the underlying design approaches and
what kind of user experience each creates]

## Recommendation

[Suggest which concept fits the app's stated goals best, with reasoning.
Make it clear this is a recommendation — the user chooses.]
```

---

## Step 6: Present Concepts for Review

After generating all documents and mockups, present a summary:

```
================================================================
  Design Concepts Generated
================================================================

  [N] concepts created in docs/design-concepts/

  Concept 1: [Direction Name]
    [1-line personality summary]
    Doc:    docs/design-concepts/concept-1-[slug].md
    Mockup: docs/design-concepts/mockups/concept-1-[slug].html

  Concept 2: [Direction Name]
    [1-line personality summary]
    Doc:    docs/design-concepts/concept-2-[slug].md
    Mockup: docs/design-concepts/mockups/concept-2-[slug].html

  Concept 3: [Direction Name]
    [1-line personality summary]
    Doc:    docs/design-concepts/concept-3-[slug].md
    Mockup: docs/design-concepts/mockups/concept-3-[slug].html

  Comparison: docs/design-concepts/COMPARISON.md

  Next Steps:
    1. Open the HTML mockups in a browser to see each in action
    2. Review the comparison document
    3. Tell me which concept to implement (or mix elements from multiple)
================================================================
```

Use **AskUserQuestion** to ask:

> Which concept would you like to implement? You can pick one directly (e.g., "concept 2"), mix elements ("concept 1 colors with concept 3 typography"), or ask me to refine any concept before deciding.

---

## Step 7: Implement Chosen Design

Once the user selects a concept (or a mix), implement it into the actual codebase.

### 7A: Create Design Tokens File

Based on the project's styling approach, create the token file:

- **Tailwind** → Extend `tailwind.config.js` / `tailwind.config.ts` with the color, spacing, and typography tokens
- **CSS Modules / vanilla CSS** → Create `styles/design-tokens.css` with CSS custom properties
- **styled-components / Emotion** → Create `styles/theme.ts` with a typed theme object
- **NativeWind / React Native** → Extend Tailwind config + create `theme/tokens.ts` for runtime access

### 7B: Set Up Typography

- Add font imports (Google Fonts link, `next/font`, `expo-font`, or `@font-face` declarations)
- Create typography utility classes or style objects matching the type scale

### 7C: Apply Base Styles

- Set background colors, default text colors, and font families on the root/body
- Implement dark mode toggle if the project supports it
- Apply the spacing scale to layout containers

### 7D: Update Existing Components

If components already exist, update them to use the new design tokens:

- Buttons → new colors, border-radius, shadows, hover states
- Cards → new elevation, background, borders
- Inputs → new focus rings, border colors, placeholder styles
- Navigation → new active states, backgrounds

### 7E: Create Design Reference

Create `docs/DESIGN-SYSTEM.md` documenting the implemented design:

```markdown
# Design System

**Based on:** Concept [N] — [Direction Name]
**Generated by:** /design-app on [date]

## Tokens Reference
[Link to token file]

## Color Palette
[Visual reference with hex values]

## Typography
[Type scale with examples]

## Component Patterns
[How to use the design system in new components]
```

### 7F: Verify Implementation

- Check that all colors reference tokens, not hardcoded hex values
- Verify WCAG contrast ratios pass on actual rendered components
- Confirm dark mode works if implemented
- Test responsive behavior at key breakpoints

---

## Step 8: Completion Summary

```
================================================================
  Design Implemented
================================================================

  Concept: [Direction Name]

  Files Created/Modified:
    [list of files with annotations: new/modified]

  Design System:
    Tokens:     [path to token file]
    Reference:  docs/DESIGN-SYSTEM.md
    Source:     docs/design-concepts/concept-[N]-[slug].md

  Features:
    ✓ Color palette (light + dark)
    ✓ Typography system ([font names])
    ✓ Spacing scale
    ✓ Component styles updated
    [✓ Dark mode toggle — if applicable]

  Next Steps:
    - Run the app to verify the design in-browser
    - Use /enhance-design for conversion + accessibility polish
    - Use /style to try themed variations on this base
================================================================
```
