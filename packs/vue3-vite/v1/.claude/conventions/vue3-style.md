# Vue 3 Style

## 1. Single File Components
- Use Single File Components with `<script setup lang="ts">`.
- Composition API only. Do not use the Options API.
- One component per file. File name matches component name in PascalCase.
- Keep templates readable. Move branching and data shaping into computed values or composables when template logic starts to sprawl.

## 2. Composition API and composables
- Composables only at the top level. Never inside conditionals, loops, or nested functions.
- Custom composable names start with `use`.
- Keep composables focused. Split when a composable does more than one thing.
- Prefer `computed` for derived state and reserve `watch` or `watchEffect` for true side effects.

## 3. Props and emits
- Type props with `defineProps` and emits with `defineEmits`.
- Use interfaces or named type aliases for object-shaped props when they improve readability.
- Prop names are camelCase in script and may be used in kebab-case at call sites.
- Emit names should be verb-first and kebab-case, such as `save`, `close`, or `update:modelValue`.

## 4. Types
- TypeScript strict mode is the baseline.
- No `any` without an explicit justification comment.
- Prefer `unknown` over `any` for values of truly unknown shape.
- Use inference when the type is obvious from context.

## 5. State
- Local state first with `ref` and `reactive`.
- Pinia is the default for cross-component or cross-route state.
- Keep state as close to the consuming component as possible.
- Do not duplicate the same source of truth across local state and Pinia without a clear sync boundary.

## 6. Routing
- Use Vue Router 4 patterns already present in the project.
- Keep route definitions and guards near router configuration.
- Prefer lazy route components for page-level views when the project already code-splits routes.

## 7. Data fetching
- Prefer the project's existing composable or service layer.
- Components do not call `fetch` directly unless that is already the project pattern and the REQ explicitly requires it.
- Handle loading, empty, and error states explicitly.

## 8. Templates and DOM access
- Prefer declarative bindings and Vue refs over direct DOM queries.
- Avoid manual DOM manipulation unless a browser API truly requires it.
- Keep `v-if`, `v-for`, and slot composition straightforward. Complex UI state belongs in computed values, composables, or stores.

## 9. Styling
- Use one styling strategy per project: scoped CSS, CSS Modules, Tailwind, or the established design system. Do not mix strategies unless the repo already does.
- No inline styles unless driven by dynamic values that cannot be expressed in CSS.
- Match the repo's existing token and utility conventions.

## 10. Imports
- Order: external packages, aliased paths, relative paths.
- Blank line between each group.
- Import from Vue, Router, and Pinia entry points explicitly instead of deep internal paths.

## 11. File naming
- Components: `PascalCase.vue`
- Composables: `useMyComposable.ts`
- Stores: `useMyStore.ts` or `myStore.ts`, following the repo pattern
- Utilities: `camelCase.ts`
- Tests: `ComponentName.test.ts`, `useComposable.test.ts`, or `storeName.test.ts`

## 12. Testing
- Use Vue Testing Library. Prefer accessible queries: `getByRole`, `getByLabelText`, `getByText`.
- Avoid test IDs unless nothing semantic works.
- Test user-visible behavior, not implementation details.
- Mock router, Pinia, network, and browser APIs only at the boundary you need.

## 13. Accessibility baseline
- All interactive elements are keyboard reachable.
- Buttons have meaningful labels (or `aria-label` if icon-only).
- Images have descriptive alt text or `alt=""` if decorative.
- Inputs have visible, programmatic labels.
- See `accessibility-style.md` for the full guide.

## 14. Verification
- `npm run build` passes.
- `npm run test` passes.
- `npm run lint` passes.
- `npm run typecheck` or `npx vue-tsc --noEmit` passes.
