---
name: mobile-design
description: Apply mobile-first design patterns and touch interactions. Implements navigation, responsive layouts, touch targets, gestures, and platform-aware patterns for iOS and Android.
argument-hint: "[patterns | touch] — Optional: run just navigation/layout patterns or touch interactions. Default: both."
---

# Mobile Design

Apply mobile-first patterns and touch interactions. Run both areas or target one specifically.

## Usage

```
/mobile-design           — apply both patterns and touch interactions
/mobile-design patterns  — navigation, layout, responsive strategies only
/mobile-design touch     — touch targets, gestures, haptics only
```

## Instructions

Parse the argument and run the specified area(s). If no argument, run both in order.

---

## Area: patterns

Apply mobile navigation, layout patterns, and responsive strategies.

**Goals:**
- Implement appropriate mobile navigation pattern for the app type
- Ensure content is reachable within thumb zones
- Apply responsive grid that works from 320px up

**Navigation patterns (choose based on app type):**
- **Bottom nav bar** — for apps with 3-5 top-level destinations (most apps)
- **Hamburger/drawer** — for content-heavy apps with many nav items
- **Tab bar** — iOS-native feel, persistent tabs
- **Top nav with back** — for linear flows (checkout, onboarding)

**Layout rules:**
- Single column on mobile — avoid multi-column below 640px
- Full-width cards with 16px horizontal padding
- Sticky headers max 56px height — leave content room
- Bottom safe area padding for iOS home indicator (env(safe-area-inset-bottom))

**Responsive strategy:**
- Mobile-first CSS: start with mobile styles, add complexity at breakpoints
- Breakpoints: 640px (sm), 768px (md), 1024px (lg), 1280px (xl)
- Images: use srcset and sizes for responsive images
- Text: larger base size on mobile (16px minimum — never smaller)

**Thumb zones:**
- Primary actions in bottom 60% of screen
- Destructive actions require confirmation and placed out of natural thumb path
- Navigation anchored to bottom (not top) on mobile

---

## Area: touch

Implement touch-friendly interactions for mobile interfaces.

**Goals:**
- All interactive targets meet minimum touch target size
- Swipe gestures feel natural and have visual feedback
- Platform-appropriate interaction patterns

**Touch targets:**
- Minimum 44×44pt (iOS) / 48×48dp (Android) for all tappable elements
- Add padding to small visual elements to meet size requirements without changing appearance
- Spacing between adjacent targets: minimum 8px gap

**Gestures to implement where appropriate:**
- **Swipe to dismiss** — modals, notifications, cards
- **Pull to refresh** — list/feed views
- **Long press** — contextual menus, drag handles
- **Swipe actions** — list items (delete, archive, etc.)

**Feedback patterns:**
- Visual press state (scale 0.97 + opacity 0.8) on tap — 150ms, ease-out
- Haptic feedback on key actions (iOS: UIImpactFeedbackGenerator, Android: VibrationEffect)
- Loading skeletons instead of spinners for content loads
- Smooth transitions (300ms) for navigation and modal presentation

**iOS/Android specifics:**
- iOS: respect safe areas, use native scroll momentum, blur effects for sheets
- Android: ripple effects on touch, elevation shadows, bottom sheet patterns
- Both: respect prefers-reduced-motion for all animations
