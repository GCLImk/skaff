# Accessibility Style

Target: WCAG 2.1 AA.

## Semantic HTML
- Use landmark elements: `header`, `main`, `nav`, `footer`, `aside`, `section`, `article`.
- Use correct heading hierarchy. Do not skip levels.
- Prefer native elements. Use `<button>` not a clickable `<div>`.
- Preserve semantic children through slots or snippets instead of wrapping everything in generic containers.

## ARIA
- Add ARIA only when semantics are insufficient.
- `aria-label` on icon-only buttons.
- `aria-describedby` when additional context improves understanding.
- Do not use `role="presentation"` on interactive elements.

## Keyboard navigation
- Tab order follows visual reading order.
- All interactive elements are reachable and operable with keyboard.
- Dialogs, menus, and popovers manage focus predictably.
- Escape and close behavior is implemented where the pattern expects it.

## Focus management
- Visible focus indicator required on all interactive elements. Do not suppress `outline` without a replacement.
- When Svelte conditionally mounts page-level content, move focus to the new primary heading or first actionable element when that improves orientation.
- Return focus to the trigger after closing a dialog or popover when practical.

## Forms
- Every input has a `<label>` linked via `for` and `id`, or an `aria-label` fallback.
- Error messages are associated with the relevant input via `aria-describedby` when needed.
- Required fields are marked with `required` or `aria-required`.
- Server-side action failures expose clear, persistent feedback.

## Color contrast
- Text on background: minimum 4.5:1 (AA).
- Large text (18pt+ or 14pt bold+): minimum 3:1.
- UI components and graphical elements: minimum 3:1.

## Images
- Informative images: meaningful `alt` text describing purpose.
- Decorative images: `alt=""`.
- Complex images (charts, diagrams): supplementary long description.

## Motion
- Respect `prefers-reduced-motion`.
- Avoid autoplaying or looping motion that cannot be paused.

## Testing
- Run axe checks on accessibility-critical flows when tooling is present.
- Verify keyboard paths manually or with browser automation when a component introduces complex interaction.
- In Vitest suites, prefer semantic assertions over DOM-structure assertions.
