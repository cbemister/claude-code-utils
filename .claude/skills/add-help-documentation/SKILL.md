# Add Help Documentation

Add documentation for a new feature to the help modal (Cmd+?).

## When to Use
Use this skill when a new feature needs user-facing documentation in the help center.

## Help Modal Sections

The help modal has multiple sections. Choose the appropriate one for your documentation:

| Section | File | Use For |
|---------|------|---------|
| Quick Start | `QuickStartSection.tsx` | Core features, getting started guides |
| Workflow Guides | `WorkflowGuidesSection.tsx` | Step-by-step workflows |
| Agile Practices | `AgilePracticesSection.tsx` | Agile methodology explanations |
| Templates | `TemplatesSection.tsx` | Template documentation |

## Files Location
```
src/components/help/sections/
├── QuickStartSection.tsx
├── WorkflowGuidesSection.tsx
├── AgilePracticesSection.tsx
├── TemplatesSection.tsx
└── HelpSections.module.css
```

## Documentation Block Template

Add a new documentation block to the appropriate section file:

```tsx
<div className={styles.block}>
  <h4 className={styles.blockTitle}>Feature Name</h4>
  <p className={styles.description}>
    Brief description of what the feature does.
  </p>
  <ol className={styles.numberedList}>
    <li>Step 1 of using the feature</li>
    <li>Step 2 of using the feature</li>
    <li>Step 3 of using the feature</li>
  </ol>
</div>
```

## Available CSS Classes

### Container Classes
- `styles.section` - Main section wrapper
- `styles.block` - Individual documentation block
- `styles.sectionTitle` - Section heading (h3)
- `styles.blockTitle` - Block heading (h4)

### Text Classes
- `styles.intro` - Introduction paragraph
- `styles.description` - Muted description text

### List Classes
- `styles.list` - Unordered bullet list
- `styles.numberedList` - Ordered numbered list

### Special Classes
- `styles.shortcutGrid` - Grid for keyboard shortcuts
- `styles.shortcut` - Individual shortcut row
- `styles.kbd` - Keyboard key styling
- `styles.shortcutLabel` - Shortcut description

## Keyboard Shortcut Example

```tsx
<div className={styles.block}>
  <h4 className={styles.blockTitle}>Keyboard Shortcuts</h4>
  <div className={styles.shortcutGrid}>
    <div className={styles.shortcut}>
      <span className={styles.kbd}>Cmd+K</span>
      <span className={styles.shortcutLabel}>Quick Capture</span>
    </div>
  </div>
</div>
```

## Feature Documentation Example

```tsx
<div className={styles.block}>
  <h4 className={styles.blockTitle}>Favorite Views</h4>
  <p className={styles.description}>
    Star any view to add it to your favorites for quick access.
  </p>
  <ol className={styles.numberedList}>
    <li>Click the star icon on any page header to favorite it</li>
    <li>Choose &quot;This Project&quot; or &quot;All Projects&quot; scope</li>
    <li>Access favorites from the sidebar under your project</li>
    <li>Manage all favorites in Settings &rarr; View Preferences</li>
  </ol>
</div>
```

## Tips

- Use `&rarr;` for arrow characters (→) in navigation paths
- Use `&quot;` for quotes in JSX
- Keep descriptions concise - users scan documentation
- Use numbered lists for sequential steps
- Use bullet lists for feature overviews
- Place new blocks logically near related content
- Test the help modal to verify styling appears correctly
