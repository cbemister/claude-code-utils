---
name: enhance-design
description: Comprehensive design enhancement that chains all design skills in phases - analyze, mobile optimize, conversion optimize, and polish. Transforms any interface into a professional, high-converting, mobile-friendly experience.
hooks:
  SubagentStart:
    - matcher: ".*"
      hooks:
        - type: command
          command: |
            case "$AGENT_TYPE" in
              "conversion-audit") echo "📊 Auditing conversion opportunities..." ;;
              "mobile-patterns") echo "📱 Applying mobile navigation patterns..." ;;
              "touch-interactions") echo "👆 Implementing touch interactions..." ;;
              "mobile-accessibility") echo "♿ Adding accessibility support..." ;;
              "copywriting-guide") echo "✍️  Optimizing copy and messaging..." ;;
              "cta-optimizer") echo "🎯 Enhancing CTAs..." ;;
              "social-proof") echo "⭐ Adding social proof elements..." ;;
              "color-palette") echo "🎨 Refining color palette..." ;;
              "typography-system") echo "📝 Establishing typography system..." ;;
              "spacing-system") echo "📏 Creating spacing rhythm..." ;;
              "component-states") echo "🔄 Adding interactive states..." ;;
              "micro-interactions") echo "✨ Implementing micro-interactions..." ;;
              "component-polish") echo "💎 Final polish pass..." ;;
              *) echo "🔧 Running $AGENT_TYPE..." ;;
            esac
  SubagentStop:
    - hooks:
        - type: command
          command: "echo '   ✓ Complete'"
  Stop:
    - hooks:
        - type: agent
          prompt: |
            Verify that /enhance-design completed all required phases.

            Check the conversation transcript for evidence that these phases ran:

            Phase 1 - ANALYZE:
            - [ ] /conversion-audit was invoked

            Phase 2 - MOBILE OPTIMIZE (should run in parallel):
            - [ ] /mobile-patterns was invoked
            - [ ] /touch-interactions was invoked
            - [ ] /mobile-accessibility was invoked

            Phase 3 - CONVERSION OPTIMIZE (should run in parallel):
            - [ ] /copywriting-guide was invoked
            - [ ] /cta-optimizer was invoked
            - [ ] /social-proof was invoked

            Phase 4 - VISUAL POLISH (should run in batches):
            - [ ] /color-palette was invoked
            - [ ] /typography-system was invoked
            - [ ] /spacing-system was invoked
            - [ ] /component-states was invoked
            - [ ] /micro-interactions was invoked
            - [ ] /component-polish was invoked

            Context: $ARGUMENTS

            Return {"ok": true} if ALL phases completed successfully.
            Return {"ok": false, "reason": "Missing: [list skills that didn't run]"} if any skills were skipped.
          timeout: 120
---

# Enhance Design Skill

Comprehensive design enhancement workflow that orchestrates all design skills to transform interfaces into professional, high-converting, mobile-friendly experiences.

## When to Use

Use `/enhance-design` when you need to:
- Do a complete design overhaul of an existing interface
- Prepare an app or page for production launch
- Transform generic/AI-generated UI into professional design
- Optimize for both mobile experience AND conversion
- Apply full design system improvements systematically

**For targeted improvements, use individual skills instead:**
- `/ui-transform` - Quick visual polish
- `/mobile-patterns` - Mobile-specific work only
- `/conversion-audit` - Conversion analysis only

## Skill Chain Overview

```
/enhance-design
    │
    ├─▶ Phase 1: ANALYZE
    │   └─▶ /conversion-audit (identify issues)
    │
    ├─▶ Phase 2: MOBILE OPTIMIZE
    │   ├─▶ /mobile-patterns (navigation, layout)
    │   ├─▶ /touch-interactions (gestures, targets)
    │   └─▶ /mobile-accessibility (screen readers)
    │
    ├─▶ Phase 3: CONVERSION OPTIMIZE
    │   ├─▶ /copywriting-guide (headlines, copy)
    │   ├─▶ /cta-optimizer (buttons, placement)
    │   └─▶ /social-proof (testimonials, trust)
    │
    └─▶ Phase 4: VISUAL POLISH
        ├─▶ /color-palette (professional colors)
        ├─▶ /typography-system (type hierarchy)
        ├─▶ /spacing-system (visual rhythm)
        ├─▶ /component-states (hover, focus, etc.)
        ├─▶ /micro-interactions (animations)
        └─▶ /component-polish (final details)
```

## Instructions

### Phase 1: Analyze & Audit

**Goal**: Understand current state and identify all improvement opportunities

**Run `/conversion-audit` to assess:**
- Page structure and information hierarchy
- Copy effectiveness and messaging
- Trust signals and social proof
- Friction points and obstacles
- Mobile conversion readiness

**Output**: Prioritized list of improvements with estimated impact

```markdown
## Design Audit Results

### Critical Issues (Fix First)
1. [Issue] - [Impact] - [Recommended fix]
2. [Issue] - [Impact] - [Recommended fix]

### High Priority
3. [Issue] - [Impact] - [Recommended fix]

### Medium Priority
...

### Strengths (Don't Change)
- [What's working well]
```

**User checkpoint**: Review audit results before proceeding

---

### Phase 2: Mobile Optimization (PARALLEL EXECUTION)

**Goal**: Ensure excellent mobile experience with thumb-friendly, accessible interactions

**⚡ PERFORMANCE TIP**: These three skills are independent and should run in parallel for faster completion.

**Execute simultaneously:**
- `/mobile-patterns` - Implement appropriate navigation pattern (bottom nav, drawer, tabs), create responsive grid and breakpoint system, adapt components for mobile (tables → lists, modals → sheets), handle safe areas (notches, home indicators)

- `/touch-interactions` - Ensure all touch targets ≥ 48x48px, add swipe gestures where appropriate, implement touch feedback (scale, ripple), add pull-to-refresh if applicable

- `/mobile-accessibility` - Add screen reader labels (VoiceOver/TalkBack), implement proper focus management, add live regions for dynamic content, verify reduced motion support

**Wait for all three to complete before proceeding to Phase 3.**

**Output**: Mobile-optimized interface with:
- [ ] Bottom-heavy layout (thumb zone friendly)
- [ ] All touch targets ≥ 48px
- [ ] Platform-appropriate patterns
- [ ] Safe area handling
- [ ] Screen reader support

---

### Phase 3: Conversion Optimization (PARALLEL EXECUTION)

**Goal**: Optimize copy, CTAs, and trust signals for maximum conversion

**⚡ PERFORMANCE TIP**: These three skills modify independent content areas and should run in parallel.

**Execute simultaneously:**
- `/copywriting-guide` - Rewrite headlines using PAS/AIDA/BAB frameworks, transform features into benefits, optimize microcopy (buttons, forms, errors), apply power words strategically

- `/cta-optimizer` - Optimize CTA copy (action verb + value + friction reducer), improve CTA visual design (contrast, size, spacing), strategic CTA placement (above fold, after value, before footer), establish clear primary/secondary/tertiary hierarchy

- `/social-proof` - Add/improve testimonials (photos, names, results), implement logo trust bar, add stats and usage numbers, place trust signals near CTAs and forms

**Wait for all three to complete before proceeding to Phase 4.**

**Output**: Conversion-optimized interface with:
- [ ] Benefit-driven headlines
- [ ] Prominent, action-oriented CTAs
- [ ] Strategic social proof placement
- [ ] Trust signals near decision points
- [ ] No dark patterns

---

### Phase 4: Visual Polish (BATCHED PARALLEL EXECUTION)

**Goal**: Elevate visual quality to professional, human-designed standards

**⚡ PERFORMANCE TIP**: Run these in three parallel batches - later batches depend on earlier ones.

**Batch 1 (parallel) - Design Systems:**
Execute simultaneously (independent systems):
- `/color-palette` - Replace generic AI colors with sophisticated palette, create proper color scales (50-900), ensure contrast ratios meet WCAG, define semantic color usage

- `/typography-system` - Establish type scale with clear hierarchy, choose appropriate font pairing, define weight usage and line heights, implement responsive sizing

- `/spacing-system` - Create intentional spacing rhythm, apply spacing based on content relationships, break mechanical uniformity, define consistent spacing scale

**Wait for Batch 1 to complete.**

**Batch 2 (parallel) - Component Enhancements:**
Execute simultaneously (depend on design systems but independent of each other):
- `/component-states` - Add complete interactive states (hover, focus, active, disabled, loading), ensure smooth transitions, implement keyboard focus indicators, add error and success states

- `/micro-interactions` - Add subtle hover effects, implement entrance animations, create meaningful loading states, polish transitions between states

**Wait for Batch 2 to complete.**

**Batch 3 (sequential) - Final Pass:**
- `/component-polish` - Final detail pass, perfect alignment and spacing, add subtle shadows and depth, ensure pixel-perfect implementation

**Output**: Polished, professional interface with:
- [ ] Sophisticated color palette
- [ ] Clear typography hierarchy
- [ ] Intentional spacing rhythm
- [ ] Complete interactive states
- [ ] Delightful micro-interactions
- [ ] Production-ready quality

---

## Execution Options

When invoking `/enhance-design`, choose execution mode:

### Option A: Full Enhancement (Default)
Run all 4 phases sequentially. Best for complete design overhaul.
- Time: 30-60 minutes
- Output: Fully transformed interface

### Option B: Quick Enhancement
Run Phase 1 (Analyze) + Phase 4 (Polish) only. Best for visual improvements without mobile/conversion changes.
- Time: 15-20 minutes
- Output: Visually improved interface

### Option C: Mobile Focus
Run Phase 1 (Analyze) + Phase 2 (Mobile) only. Best for mobile-specific improvements.
- Time: 15-20 minutes
- Output: Mobile-optimized interface

### Option D: Conversion Focus
Run Phase 1 (Analyze) + Phase 3 (Conversion) only. Best for landing pages and revenue pages.
- Time: 15-20 minutes
- Output: Conversion-optimized interface

---

## Output Format

```markdown
# Design Enhancement Report

## Summary
- **Mode**: Full Enhancement
- **Components Enhanced**: [number]
- **Issues Fixed**: [number]
- **Estimated Conversion Lift**: +[X-Y]%

---

## Phase 1: Audit Results
[Summary of conversion audit findings]

### Issues Addressed
1. [Issue] → [Solution applied]
2. [Issue] → [Solution applied]

---

## Phase 2: Mobile Optimization
[Summary of mobile improvements]

### Changes Made
- Navigation: Implemented bottom tab bar
- Touch targets: Fixed 12 undersized elements
- Accessibility: Added 8 screen reader labels

---

## Phase 3: Conversion Optimization
[Summary of conversion improvements]

### Copy Changes
- Headline: [Before] → [After]
- CTAs: Updated 5 buttons with value-driven copy

### Social Proof Added
- Logo bar after hero (4 brands)
- Testimonial section (3 cards)
- Stats counter (3 metrics)

---

## Phase 4: Visual Polish
[Summary of visual improvements]

### Design System Updates
- Colors: Replaced #2563eb with custom palette
- Typography: Established 6-level hierarchy
- Spacing: Applied 8px grid rhythm
- States: Added complete interactive states

---

## Files Modified
- `[filepath]` - [Changes made]
- `[filepath]` - [Changes made]

---

## Before/After Comparison
[Key visual differences highlighted]

---

## Verification Checklist
- [x] All touch targets ≥ 48px
- [x] Color contrast ≥ 4.5:1
- [x] Screen reader tested
- [x] CTA copy is action-oriented
- [x] Social proof placed strategically
- [x] No dark patterns present
- [x] Component states complete
- [x] Micro-interactions added
```

---

## Chained Skills Reference

| Phase | Skill | Purpose |
|-------|-------|---------|
| 1 | `/conversion-audit` | Identify all design issues |
| 2a | `/mobile-patterns` | Mobile navigation and layout |
| 2b | `/touch-interactions` | Touch targets and gestures |
| 2c | `/mobile-accessibility` | Screen reader support |
| 3a | `/copywriting-guide` | Headlines and copy |
| 3b | `/cta-optimizer` | CTA design and placement |
| 3c | `/social-proof` | Testimonials and trust |
| 4a | `/color-palette` | Professional colors |
| 4b | `/typography-system` | Type hierarchy |
| 4c | `/spacing-system` | Visual rhythm |
| 4d | `/component-states` | Interactive states |
| 4e | `/micro-interactions` | Animations |
| 4f | `/component-polish` | Final details |

---

## Integration with Agents

This skill works well when invoked by:
- **ui-ux-designer** - For complete design transformations
- **mobile-designer** - When mobile-first approach is needed
- **conversion-optimizer** - When revenue optimization is primary goal

---

## Notes

- Each phase can be run independently if needed
- User approval checkpoints after Phase 1 (audit) recommended
- For very large projects, consider running one phase per session
- Individual skills can be re-run if specific improvements needed
- All changes follow ethical design principles (no dark patterns)
- Accessibility is baked into every phase, not an afterthought
