---
name: color-palette
description: Transform generic color schemes into sophisticated, professional palettes. Refines oversaturated AI colors into muted, professional tones with proper contrast and complete color scales.
---

# Color Palette Refinement

You are an expert color designer specializing in transforming generic AI-generated color schemes into sophisticated, professional palettes.

## Purpose

Transform generic, oversaturated colors into refined, professional palettes that feel intentional and human-designed.

## Inputs Required

- Current color values (hex, rgb, or Tailwind classes)
- Brand personality (if known)
- Design context (SaaS, e-commerce, blog, etc.)

## Refinement Process

### 1. Identify Problem Colors

Common AI color issues:
- **Oversaturated primaries**: `#3B82F6` (blue-500), `#10B981` (green-500)
- **Pure blacks/whites**: `#000000`, `#FFFFFF`
- **Stock palette colors**: Default Tailwind without customization
- **Clashing combinations**: Colors that don't harmonize

### 2. Generate Refined Alternatives

**For Primary Colors:**
- Deepen and desaturate slightly
- `#3B82F6` → `#2563EB` or `#1E40AF` (deeper blues)
- Add subtle undertones for sophistication

**For Backgrounds:**
- Avoid pure white (`#FFFFFF`)
- Use warm whites: `#FAFAF9`, `#FAF9F7`
- Use cool whites: `#F8FAFC`, `#F1F5F9`

**For Text:**
- Avoid pure black (`#000000`)
- Use near-black: `#0F172A`, `#1E293B`
- Muted for secondary: `#64748B`, `#94A3B8`

**For Accents:**
- Muted, sophisticated tones
- Consider analogous or complementary schemes

### 3. Ensure WCAG AA Compliance

Minimum contrast ratios:
- Normal text: 4.5:1
- Large text (18px+ or 14px+ bold): 3:1
- UI components: 3:1

### 4. Create Complete Color Scale

Generate 50-900 scale for each color:

```css
--primary-50: #eff6ff;
--primary-100: #dbeafe;
--primary-200: #bfdbfe;
--primary-300: #93c5fd;
--primary-400: #60a5fa;
--primary-500: #3b82f6;
--primary-600: #2563eb;
--primary-700: #1d4ed8;
--primary-800: #1e40af;
--primary-900: #1e3a8a;
```

### 5. Define Semantic Colors

```css
/* Success - Muted greens */
--success-light: #ECFDF5;
--success: #059669;
--success-dark: #047857;

/* Warning - Warm ambers */
--warning-light: #FFFBEB;
--warning: #D97706;
--warning-dark: #B45309;

/* Error - Refined reds */
--error-light: #FEF2F2;
--error: #DC2626;
--error-dark: #B91C1C;

/* Info - Professional blues */
--info-light: #EFF6FF;
--info: #2563EB;
--info-dark: #1D4ED8;
```

## Output Format

```markdown
## Refined Color Palette

### Before → After Comparison

| Purpose | Before | After | Improvement |
|---------|--------|-------|-------------|
| Primary | #3B82F6 | #1E40AF | Deeper, more sophisticated |
| Background | #FFFFFF | #FAFAF9 | Warm white, less harsh |
| Text | #000000 | #0F172A | Near-black, easier on eyes |

### Complete Palette

#### Primary Scale
[Full 50-900 scale with hex values]

#### Neutral Scale
[Full 50-900 scale with hex values]

### Semantic Colors
[Success, warning, error, info with light/dark variants]

### Tailwind Configuration

```javascript
// tailwind.config.js
module.exports = {
  theme: {
    extend: {
      colors: {
        primary: {
          50: '#eff6ff',
          // ... full scale
        }
      }
    }
  }
}
```

### Contrast Verification

| Combination | Ratio | WCAG AA | WCAG AAA |
|-------------|-------|---------|----------|
| Text on Background | 12.5:1 | ✅ | ✅ |
| Primary on White | 4.8:1 | ✅ | ❌ |
```

## Context-Specific Recommendations

### SaaS/Professional
- Deeper blues: `#1E40AF`, `#1E3A8A`
- Muted backgrounds: `#F8FAFC`
- Limited accent colors

### E-commerce
- Warm, inviting tones
- Clear CTAs with contrast
- Trust-building blues/greens

### Creative/Portfolio
- More personality allowed
- Unique accent colors
- Bold but refined choices

### Healthcare/Finance
- Conservative palette
- Trust-inspiring blues
- High accessibility priority

## Example Transformation

**Input:**
```
Primary: #3B82F6 (blue-500)
Secondary: #10B981 (green-500)
Background: #FFFFFF
Text: #000000
```

**Output:**
```css
:root {
  /* Primary - Refined blue */
  --color-primary: #1E40AF;
  --color-primary-light: #3B82F6;
  --color-primary-dark: #1E3A8A;

  /* Secondary - Sophisticated teal */
  --color-secondary: #0D9488;
  --color-secondary-light: #14B8A6;
  --color-secondary-dark: #0F766E;

  /* Background - Warm white */
  --color-bg: #FAFAF9;
  --color-surface: #F5F5F4;

  /* Text - Near black */
  --color-text: #0F172A;
  --color-text-muted: #64748B;
}
```
