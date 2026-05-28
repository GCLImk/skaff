# Designer Style

All agents read this file before writing or reviewing design-system code, token definitions, component styles, or Storybook documentation.

## 1. Design-first principle

- Design tokens are the source of truth.
- UI decisions should flow from tokens and component contracts, not one-off visual tweaks.
- If a request conflicts with the token system, fix the token architecture first or escalate.

## 2. Token architecture

- Separate tokens by concern: color, spacing, typography, radii, shadows, motion, and z-index.
- Prefer semantic token names such as `--color-primary`, `--surface-muted`, or `$space-stack-md`.
- Raw palette values may exist internally, but semantic aliases are the public API.
- Support theming through token indirection rather than duplicated component styles.

## 3. Naming stability

- Token names are stable interfaces. Avoid churn unless the underlying semantic meaning changed.
- Do not expose numeric-only names as the public API.
- Component, story, and theme names must describe intent rather than implementation detail.

## 4. Component styling

- Components consume tokens only. No magic numbers in production styling.
- Prefer composition over variant explosion.
- Keep selectors intentional, shallow, and easy to override within the system.
- Interactive states such as hover, focus, pressed, selected, and disabled must be styled deliberately.

## 5. Storybook is part of the product

- Every meaningful component needs Storybook stories.
- Each component should have stories for default usage, meaningful states, and supported variants.
- Stories document usage, constraints, and accessibility notes.
- A component change is incomplete when the matching stories are stale.

## 6. Accessibility is non-negotiable

- Visible focus states are required on every interactive element.
- WCAG AA is the minimum target.
- Text contrast must meet 4.5:1, and large text or UI affordances must meet 3:1.
- Motion and color choices must stay accessible across supported themes.

## 7. Theming

- Themes are token-driven. Do not fork component styles per theme when token substitution can express the same result.
- Light, dark, and brand themes should share component structure and behavior.
- Theme overrides should stay as shallow as possible.

## 8. CSS and SCSS hygiene

- Keep nesting controlled and readable.
- Avoid deep selector chains and unbounded specificity growth.
- Use layer boundaries, partials, and module structure intentionally.
- Remove dead tokens and dead variants when the change that created them also retires them.

## 9. Figma-to-code workflow

- Treat Figma as design input, not as code output.
- Translate intent into tokens, spacing rules, and component APIs manually.
- Do not mirror frame names or raw hex values blindly into the codebase.

## 10. Testing and validation

- Storybook build must pass for changes that affect components or tokens.
- Chromatic or the project's visual-regression tool is part of the validation path when configured.
- axe-core checks should run for interactive components where the repo supports them.

## 11. Documentation

- README content must explain token workflow, theming model, Storybook usage, and build/test commands.
- Component docs and stories should explain when to use a component, not just what props it accepts.
- Accessibility expectations belong in the story or docs where maintainers will actually see them.
