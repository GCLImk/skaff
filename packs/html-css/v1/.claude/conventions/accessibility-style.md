# Accessibility Style

All agents read this file before writing or reviewing interfaces, components, interactions, or documentation that affects user experience.

## 1. Semantic structure first

- Start with native HTML elements and landmark regions before reaching for ARIA.
- Keep heading order logical. Do not skip levels for visual styling.
- Use buttons for actions and links for navigation. Do not fake semantics with generic containers.
- Tables are for tabular data only. Use lists or sections for layout and grouped content.

## 2. ARIA is a fallback, not a starting point

- Add ARIA only when native semantics are insufficient.
- Every ARIA role, state, and property must stay in sync with the actual UI state.
- Do not add redundant roles to native elements.
- Avoid `aria-hidden="true"` on focusable elements or their ancestors.

## 3. Keyboard interaction is mandatory

- Every interactive control must be reachable and operable by keyboard alone.
- Preserve the natural tab order. Avoid positive `tabindex` values.
- Custom widgets must support the expected keys for their pattern:
  - Buttons: `Enter` and `Space`
  - Dialogs: focus moves inside on open, `Escape` closes when appropriate, focus returns to the trigger on close
  - Menus and listboxes: arrow keys move between options
- Hover-only disclosure is not sufficient. The same content must be reachable via focus or activation.

## 4. Focus must stay visible

- Every interactive element needs a visible focus indicator with clear contrast against adjacent colors.
- Do not remove the browser outline unless a replacement is stronger and consistent.
- When content is conditionally shown, focus must move predictably and never disappear into the page.

## 5. Forms need labels, help, and error wiring

- Every input, select, textarea, checkbox, radio, and custom field requires a visible label. `aria-label` is a last resort.
- Required fields are identified in text, not by color alone.
- Validation errors must connect to the field with `aria-describedby` and set `aria-invalid` when appropriate.
- Placeholder text is not a label.

## 6. Color, contrast, and non-color cues

- Body text must meet at least 4.5:1 contrast.
- Large text and UI components must meet at least 3:1 contrast.
- Meaning is never conveyed by color alone. Add text, icons, or patterns.
- Focus rings, disabled states, and error states must remain perceivable in high-contrast modes.

## 7. Images, media, and motion

- Informative images require meaningful `alt` text.
- Decorative images use `alt=""` and no duplicated nearby description.
- Audio and video content should include captions or transcripts when the project scope includes media.
- Respect `prefers-reduced-motion`. Essential motion should be subtle and optional.

## 8. Testing expectations

- Run `axe-core` checks in Playwright or Storybook where the project supports them.
- Run `pa11y` or an equivalent page-level accessibility pass when configured.
- Manually test primary keyboard paths without a mouse.
- Verify accessible name, role, and state for custom controls.
- Check dialogs, drawers, menus, and toasts with screen-reader-friendly markup.

## 9. Blocking failures

The following issues block completion:

- Icon-only controls without an accessible name
- Inputs without labels
- Focus indicators that disappear or fail contrast
- Custom controls that cannot be operated with keyboard
- Dialogs that do not trap and restore focus correctly
- Errors or helper text not connected to their fields
- ARIA added where native elements would have solved the problem
