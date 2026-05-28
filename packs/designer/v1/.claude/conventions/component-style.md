# Component Style

All agents read this file before designing or reviewing component APIs, Storybook stories, or usage documentation.

## Component API design

- Keep component APIs small, explicit, and composable.
- Prefer a few well-named props over large variant matrices.
- Use booleans for true state toggles such as `isDisabled` or `isSelected`.
- Use semantic prop names such as `tone`, `size`, `emphasis`, `placement`, or `density`.
- Avoid props that accept raw color, spacing, or typography values when a token-backed option exists.

## Composition patterns

- Prefer composition, slots, or child components over giant all-in-one components.
- Shared behaviors should live in primitives or helpers, not be copy-pasted into every variant.
- Compound components should expose a clear parent-child contract and document required structure.

## Storybook story structure

- Every meaningful component gets a story file near the component or under the project's stories directory.
- Include at least:
  - Default story
  - State stories for loading, disabled, error, or selected states when applicable
  - Variant stories for supported themes or visual modes
- Stories must keep args realistic and avoid placeholder combinations that the product never uses.
- Add accessibility notes when the component has keyboard, focus, or screen-reader expectations.

## Documentation expectations

- Story titles should match the component hierarchy and stay stable over time.
- Docs should explain intent, constraints, and accessibility behaviour.
- Controls in Storybook should reflect the supported API, not expose internal implementation props.
- When a prop has nuanced behavior, describe it in story docs or component comments.

## Naming and events

- Event props should read as actions: `onOpenChange`, `onSelect`, `onDismiss`.
- State props should describe state, not implementation: `isOpen`, `isPressed`, `isCurrent`.
- Avoid abbreviations unless they are already established across the project.

## Done criteria for component work

- Tokens remain the source of truth.
- Stories are added or updated with the component change.
- Accessibility notes are present when interaction patterns are non-trivial.
- The API remains easy to understand from the story and component signature.
