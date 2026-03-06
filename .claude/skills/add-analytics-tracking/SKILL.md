# Add Analytics Tracking

Add usage tracking for a new feature to appear in admin analytics.

## When to Use
Use this skill when adding a new feature that should be tracked for usage analytics in the admin dashboard.

## Overview

The analytics system tracks feature usage with:
- **Features**: Categories of functionality (e.g., QUICK_CAPTURE, VIEW_PREFERENCES)
- **Actions**: What the user did (e.g., CREATED, UPDATED, DELETED)
- **Metadata**: Additional context about the action

## Files to Modify

### 1. Analytics Constants
**File:** `hooks/useAnalytics.ts`

Add your feature to `AnalyticsFeatures`:

```typescript
export const AnalyticsFeatures = {
  // ... existing features
  YOUR_FEATURE: 'your_feature',
} as const;
```

Add any new actions to `AnalyticsActions` (if needed):

```typescript
export const AnalyticsActions = {
  // ... existing actions
  YOUR_ACTION: 'your_action',
} as const;
```

### 2. Feature Component
**File:** Your feature component

Import and use the analytics hook:

```typescript
import { useAnalytics, AnalyticsFeatures, AnalyticsActions } from '@/hooks/useAnalytics';

function YourComponent() {
  const { trackFeatureUse } = useAnalytics();

  const handleAction = () => {
    // Track the action
    trackFeatureUse(AnalyticsFeatures.YOUR_FEATURE, AnalyticsActions.CREATED, {
      // Optional metadata
      itemType: 'example',
      scope: 'project',
    });
  };
}
```

### 3. Admin Analytics Dashboard (Optional)
**File:** `src/components/admin/analytics/EngagementChart.tsx`

If you want your feature to appear as a category in the engagement chart, add it to `FEATURE_CATEGORIES`:

```typescript
const FEATURE_CATEGORIES = [
  // ... existing categories
  { key: 'your_feature', label: 'Your Feature', color: '#8B5CF6' },
];
```

## Standard Actions

Use these standard actions when applicable:

| Action | Use For |
|--------|---------|
| `CREATED` | User created a new item |
| `UPDATED` | User modified an existing item |
| `DELETED` | User removed an item |
| `OPENED` | User opened a modal/panel |
| `CLOSED` | User closed a modal/panel |
| `VIEWED` | User viewed a page/content |
| `STARTED` | User started a process (e.g., timer) |
| `COMPLETED` | User completed a process |
| `SKIPPED` | User skipped something |
| `FAVORITED` | User added to favorites |
| `UNFAVORITED` | User removed from favorites |
| `REORDERED` | User reordered items |
| `HIDDEN` | User hid an item |
| `SHOWN` | User un-hid an item |

## Tracking Call Examples

### Basic Tracking
```typescript
trackFeatureUse(AnalyticsFeatures.QUICK_CAPTURE, AnalyticsActions.CREATED);
```

### With Metadata
```typescript
trackFeatureUse(AnalyticsFeatures.VIEW_PREFERENCES, AnalyticsActions.FAVORITED, {
  viewType: 'plan',
  viewName: 'roadmap',
  scope: 'global',
});
```

### In Event Handlers
```typescript
const handleSubmit = async (data: FormData) => {
  try {
    await createItem(data);
    trackFeatureUse(AnalyticsFeatures.YOUR_FEATURE, AnalyticsActions.CREATED, {
      itemType: data.type,
    });
  } catch (error) {
    // Don't track failed actions
  }
};
```

## Best Practices

1. **Track successful actions only** - Don't track failed attempts
2. **Use consistent naming** - Feature names should be snake_case
3. **Include relevant metadata** - Add context that helps understand usage patterns
4. **Don't over-track** - Focus on meaningful user actions
5. **Track both sides** - If tracking CREATED, also track DELETED

## Testing

1. Perform the tracked action in the app
2. Go to Admin → Analytics
3. Check the Engagement Chart for your feature
4. Verify the action appears in the analytics data

## API Endpoint

Analytics events are sent to:
```
POST /api/analytics/track
```

Body:
```json
{
  "feature": "your_feature",
  "action": "created",
  "metadata": { "key": "value" }
}
```
