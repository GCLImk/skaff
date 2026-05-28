# React Style

## 1. Components
- Functional components only. No class components.
- One component per file. File name matches component name in PascalCase.
- Co-locate component, styles, and test: `MyComponent.tsx`, `MyComponent.module.css`, `MyComponent.test.tsx`.

## 2. Hooks
- Hooks only at the top level. Never inside conditionals, loops, or nested functions.
- Custom hook names start with `use`.
- Keep hooks focused. Split when a hook does more than one thing.

## 3. Props
- Use interfaces for object-shaped props: `interface MyComponentProps { ... }`.
- Export prop interfaces only when consumed by other components.
- Destructure props at the function signature.

## 4. Types
- No `any` without an explicit justification comment.
- Prefer `unknown` over `any` for values of truly unknown shape.
- Use type inference when the type is obvious from context.

## 5. State
- Local state first (`useState`).
- Context for cross-tree UI state shared by nearby components.
- Zustand or equivalent only when app complexity clearly warrants it.
- Keep state as low in the tree as possible.

## 6. Data fetching
- Prefer TanStack Query when the project already uses it.
- Isolate fetch logic in custom hooks. Components do not call `fetch` directly.
- Handle loading and error states explicitly.

## 7. Memoisation
- Do not add `useMemo` or `useCallback` preemptively.
- Add only when there is a measurable render-count problem or a dependency array requires it.

## 8. Styling
- Use one strategy per project: CSS Modules or Tailwind. Do not mix.
- No inline styles unless driven by dynamic values that cannot be expressed in CSS.
- CSS Modules: file named `Component.module.css`, imported as `styles`.

## 9. Imports
- Order: external packages, aliased paths, relative paths.
- Blank line between each group.
- No default-and-named mixed imports when avoidable.

## 10. File naming
- Components: `PascalCase.tsx`
- Hooks: `useMyHook.ts`
- Utilities: `camelCase.ts`
- Tests: `ComponentName.test.tsx` or `useHook.test.ts`

## 11. Testing
- Use React Testing Library. Prefer accessible queries: `getByRole`, `getByLabelText`, `getByText`.
- Avoid `getByTestId` unless nothing semantic works.
- Test user-visible behavior, not implementation details.
- Use `@testing-library/user-event` over `fireEvent` for realistic interaction.

## 12. Accessibility baseline
- All interactive elements are keyboard reachable.
- Buttons have meaningful labels (or `aria-label` if icon-only).
- Images have descriptive alt text or `alt=""` if decorative.
- Inputs have visible, programmatic labels.
- See `accessibility-style.md` for the full guide.

## 13. Verification
- `pnpm build` passes.
- `pnpm test` passes.
- `pnpm lint` passes.
- `pnpm exec tsc --noEmit` passes.
