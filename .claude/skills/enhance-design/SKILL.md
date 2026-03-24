---
name: enhance-design
description: Comprehensive design enhancement that chains all design skills in phases - analyze, mobile optimize, conversion optimize, and polish. Transforms any interface into a professional, high-converting, mobile-friendly experience.
argument-hint: "[quick | mobile | conversion] — Optional: run subset of phases. Default: all 4 phases."
---

# Enhance Design Skill

## Instructions

**IMPORTANT: Execute immediately. Do NOT explore the codebase first or propose a plan. Start Phase 1 right now.**

Default mode is **Full Enhancement** (all 4 phases). If the user passed an argument, select the matching mode:
- `quick` → Phase 1 + Phase 4 only
- `mobile` → Phase 1 + Phase 2 only
- `conversion` → Phase 1 + Phase 3 only
- No argument or `all` → Full Enhancement (Phase 1 → 2 → 3 → 4)

---

### Phase 1: Analyze & Audit

1. **Quick project scan** (30 seconds max): Use Glob to find page files and Read the main layout to understand project structure. Do NOT launch an Explore agent - just do a quick Glob + Read.

2. **Invoke `/conversion-audit`** immediately using the Skill tool. This skill will assess:
   - Page structure and information hierarchy
   - Copy effectiveness and messaging
   - Trust signals and social proof
   - Friction points and obstacles
   - Mobile conversion readiness

3. **Present audit results** to the user as a prioritized list:

```markdown
## Design Audit Results

### Critical Issues (Fix First)
1. [Issue] - [Impact] - [Recommended fix]

### High Priority
2. [Issue] - [Impact] - [Recommended fix]

### Medium Priority
...

### Strengths (Don't Change)
- [What's working well]
```

4. **Ask the user** to confirm before proceeding to the next phase.

---

### Phase 2: Mobile Optimization

**Invoke using the Skill tool:**
- `/mobile-design` - Navigation patterns, responsive grid, touch targets ≥ 48×48px, swipe gestures, VoiceOver/TalkBack support, reduced motion

**Wait for completion.**

**VERIFY**: Run `git diff --stat` to check if files were modified. If NO files changed, implement the changes yourself directly using Edit/Write tools based on the skill's guidance.

Verify these outputs before proceeding to Phase 3:
- [ ] Bottom-heavy layout (thumb zone friendly)
- [ ] All touch targets ≥ 48px
- [ ] Platform-appropriate patterns
- [ ] Safe area handling
- [ ] Screen reader support

---

### Phase 3: Conversion Optimization

**Invoke all three in parallel** using the Skill tool in a single message:
- `/conversion-audit copy` - Rewrite headlines using PAS/AIDA/BAB, transform features into benefits, optimize microcopy
- `/conversion-audit cta` - CTA copy, visual design, placement strategy
- `/conversion-audit social-proof` - Testimonials, logo trust bar, stats, trust signals near CTAs

**Wait for all three to complete.**

**VERIFY**: Run `git diff --stat` to check if files were modified. If NO files changed, implement the changes yourself directly.

Verify these outputs before proceeding to Phase 4:
- [ ] Benefit-driven headlines
- [ ] Prominent, action-oriented CTAs
- [ ] Strategic social proof placement
- [ ] Trust signals near decision points
- [ ] No dark patterns

---

### Phase 4: Visual Polish (2 Batches)

**Batch 1 - Invoke using the Skill tool:**
- `/design-system` - Full design system pass: colors (muted palette, WCAG contrast), typography (type scale, font pairing, hierarchy), spacing (4px base scale, visual rhythm), layout (asymmetric splits, focal points)

**Wait for Batch 1 to complete.**

**VERIFY**: Run `git diff --stat`. If no files changed, implement the design system changes yourself directly.

**Batch 2 - Invoke all in parallel** using the Skill tool in a single message:
- `/component-polish states` - Complete interactive states (hover, focus, active, disabled, loading), smooth transitions, focus indicators
- `/component-polish interactions` - Hover effects, entrance animations, loading states, reduced-motion override

**Wait for Batch 2 to complete.**

**VERIFY**: Run `git diff --stat`. If no files changed, implement states and interactions yourself.

**Final - Invoke sequentially:**
- `/component-polish` - Full polish pass: design system consistency, subtle details, spacing perfection

**VERIFY**: Run `git diff --stat`. If no files changed, implement the polish yourself directly.

Verify these outputs:
- [ ] Sophisticated color palette
- [ ] Clear typography hierarchy
- [ ] Intentional spacing rhythm
- [ ] Complete interactive states
- [ ] Delightful micro-interactions
- [ ] Production-ready quality

---

### Final Report

After all phases complete, present a summary:

```markdown
# Design Enhancement Report

## Summary
- **Mode**: [Full/Quick/Mobile/Conversion]
- **Components Enhanced**: [number]
- **Issues Fixed**: [number]

## Phase 1: Audit Results
[Summary of findings]

## Phase 2: Mobile Optimization
[Summary: navigation changes, touch target fixes, accessibility additions]

## Phase 3: Conversion Optimization
[Summary: copy changes, CTA updates, social proof added]

## Phase 4: Visual Polish
[Summary: color palette, typography, spacing, states, interactions]

## Files Modified
- `[filepath]` - [Changes made]

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

## Skill Chain Reference

| Phase | Skill | Purpose |
|-------|-------|---------|
| 1 | `/conversion-audit` | Full audit — structure, copy, trust, friction, mobile |
| 2 | `/mobile-design` | Navigation, layout, touch targets, screen reader support |
| 3a | `/conversion-audit copy` | Headlines and copy optimization |
| 3b | `/conversion-audit cta` | CTA design and placement |
| 3c | `/conversion-audit social-proof` | Testimonials and trust signals |
| 4a | `/design-system` | Colors, typography, spacing, layout |
| 4b | `/component-polish states` | Interactive states |
| 4c | `/component-polish interactions` | Animations and transitions |
| 4d | `/component-polish` | Final detail pass |

## Notes

- Each phase can be run independently if needed
- User approval checkpoint after Phase 1 (audit) is recommended
- For very large projects, consider running one phase per session
- Individual skills can be re-run if specific improvements needed
- All changes follow ethical design principles (no dark patterns)
- Accessibility is baked into every phase, not an afterthought