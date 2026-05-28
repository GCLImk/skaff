# Accessibility Style

Target: WCAG 2.1 AA.

## Semantic HTML
- Use landmark elements: `header`, `main`, `nav`, `footer`, `aside`, `section`, `article`.
- Use correct heading hierarchy. Do not skip levels.
- Prefer native elements. Use `<button>` not `<div role="button">`.

## ARIA
- Add ARIA only when semantics are insufficient.
- `aria-label` on icon-only buttons.
- `aria-describedby` when additional context improves understanding.
- Do not use `role="presentation"` on interactive elements.

## Keyboard navigation
- Tab order follows visual reading order.
- All interactive elements reachable and operable with keyboard.
- Modals trap focus and return it to the trigger on close.
- Menus support arrow-key navigation when applicable.
- Route changes, drawers, and custom widgets preserve logical keyboard flow.

## Focus management
- Visible focus indicator required on all interactive elements. Do not suppress `outline` without a replacement.
- Programmatic focus: move focus to new content when the user triggers a dialog, drawer, or page-level transition.
- Avoid focus loss during conditional rendering or async state changes.

## Forms
- Every input has a `<label>` element linked via `for` and `id`, or `aria-label` as a fallback.
- Error messages associated with the relevant input via `aria-describedby`.
- Required fields marked with `aria-required` or `required`.

## Color contrast
- Text on background: minimum 4.5:1 (AA).
- Large text (18pt+ or 14pt bold+): minimum 3:1.
- UI components and graphical elements: minimum 3:1.

## Images
- Informative images: meaningful `alt` text describing purpose.
- Decorative images: `alt=""`.
- Complex images (charts, diagrams): supplementary long description.

## Motion
- Respect `prefers-reduced-motion`. Disable or reduce animation for users who request it.

## Testing
- Run axe-core checks in Vitest on accessibility-critical flows.
- Verify keyboard paths with Vue Testing Library or end-to-end tooling when present.
- Prefer queries by role, label, and accessible name over test IDs.
