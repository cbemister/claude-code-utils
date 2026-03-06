# Add Onboarding Tour Step

Add a new step to the guided onboarding tour for introducing features to new users.

## When to Use
Use this skill when adding a new feature that should be introduced during the onboarding tour.

## Files to Modify

### 1. Types Definition
**File:** `src/types/index.ts`

Add the step ID to the `OnboardingStepId` union type (before 'complete'):

```typescript
export type OnboardingStepId =
  | 'welcome'
  // ... existing steps
  | 'your-step-id'  // Add your new step here
  | 'complete';
```

### 2. Tour Steps Definition
**File:** `src/components/onboarding/tourSteps.ts`

Add your step object to the `TOUR_STEPS` array. Insert it at the appropriate position (before 'templates' and 'complete'):

```typescript
{
  id: 'your-step-id',
  title: 'Feature Title',
  description: 'Description of what this feature does and how to use it.',
  targetSelector: '[data-tour="your-element-id"]',
  targetRoute: '/route',  // Optional: route to navigate to
  position: 'bottom',     // 'top' | 'bottom' | 'left' | 'right' | 'center'
  action: 'tooltip',      // 'tooltip' | 'modal' | 'highlight'
  allowInteraction: true, // Optional: allow clicking through spotlight
  mobilePosition: 'top',  // Optional: different position on mobile
},
```

### 3. Target Element
**File:** Your feature component

Add the `data-tour` attribute to the element that should be highlighted:

```tsx
<button data-tour="your-element-id">
  Feature Button
</button>
```

## Step Properties

| Property | Required | Description |
|----------|----------|-------------|
| `id` | Yes | Unique step ID (must match OnboardingStepId type) |
| `title` | Yes | Title shown in tooltip/modal |
| `description` | Yes | Description text |
| `targetSelector` | No | CSS selector for spotlight target |
| `targetRoute` | No | Route to navigate to for this step |
| `position` | No | Tooltip position: 'top', 'bottom', 'left', 'right', 'center' |
| `action` | No | Display type: 'tooltip', 'modal', 'highlight' |
| `allowInteraction` | No | Allow clicking through spotlight (default: false) |
| `mobilePosition` | No | Override position on mobile |

## Testing

1. Reset onboarding progress:
   ```bash
   # Via API
   POST /api/onboarding/reset
   ```

2. Refresh the page to restart the tour

3. Navigate through the tour to verify:
   - Step appears at correct position in sequence
   - Target element is correctly highlighted
   - Tooltip/modal displays properly
   - Navigation between steps works

## Tips

- Use `action: 'modal'` for steps without a specific target element
- Use `action: 'tooltip'` when highlighting a specific UI element
- Consider mobile experience - use `mobilePosition` for elements near edges
- Keep descriptions concise (1-2 sentences)
- Test on both desktop and mobile viewports
