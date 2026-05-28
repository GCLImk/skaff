# SvelteKit / TypeScript Conventions

All agents read this file before writing or reviewing code in this project. The stack below is the default for this pack.

## Mandatory stack

| Layer | Choice | Reason |
| ----- | ------ | ------ |
| Language | TypeScript 5+ in strict mode | Safer load, action, and component contracts |
| Framework | SvelteKit 2+ | File-based routing, loads, actions, and endpoints on one rail |
| UI | Svelte 5 with runes | Consistent modern reactivity |
| Build | Vite 5+ | Default SvelteKit build pipeline |
| Testing | Vitest + Svelte Testing Library | Fast component and route-adjacent tests |
| Styling | Scoped component CSS or optional Tailwind CSS | Keep styling choices simple and local |
| Forms | SvelteKit form actions where possible | Prefer framework-native mutation flow |

## Project layout

```text
<repo>/
  src/
    routes/                Route files and SvelteKit load/action handlers
    lib/
      components/          Reusable Svelte components
      stores/              Shared stores when local rune state is not enough
      server/              Server-only modules
      utils/               Shared helpers
    app.html               App shell template
    hooks.client.ts        Optional client hooks
    hooks.server.ts        Optional server hooks
  static/                  Public assets
  tests/                   Cross-cutting Vitest suites
  svelte.config.js|ts
  vite.config.ts
  vitest.config.ts
  tsconfig.json
  package.json
```

## Svelte components

- Reusable components use `<script lang="ts">`.
- Svelte 5 runes only. Do not use legacy `$:` reactive statements or `export let`.
- Declare props with `$props()` and destructure once near the top of the script block.
- Local mutable state uses `$state`.
- Derived values use `$derived`.
- Side effects use `$effect` and must clean up when they subscribe or bind external resources.
- Keep reusable component files in PascalCase under `src/lib/components/`.
- Route files follow SvelteKit naming exactly: `+page.svelte`, `+layout.svelte`, `+page.ts`, `+page.server.ts`, `+layout.ts`, `+layout.server.ts`, `+server.ts`.

## TypeScript

- `strict: true` is assumed.
- Avoid `any`. Prefer explicit types or `unknown` with narrowing.
- Export shared domain types from `.ts` modules, not from `.svelte` files unless the project already does that.
- Type `$props()` destructuring and exported helper functions explicitly when inference is not obvious.
- Do not hide type errors with broad casts.

## State and stores

- Local rune state first. Keep state as close to the component that owns it as possible.
- Promote to `svelte/store` only when state must be shared across components, routes, or modules.
- Stores live under `src/lib/stores/` unless an existing pattern says otherwise.
- Do not mirror the same value in both a store and component rune state without a clear synchronization reason.

## Data loading

- Prefer SvelteKit `load` functions for route data.
- Use `+page.server.ts` and `+layout.server.ts` when the work needs secrets, cookies, headers, database access, or other server-only resources.
- Use `+page.ts` and `+layout.ts` only for browser-safe work.
- Keep load return shapes small and serializable.
- Reuse server helpers from `src/lib/server/` instead of duplicating route logic.

## Form actions

- Prefer form actions in `+page.server.ts` over client `fetch` when the interaction can follow a normal submit/redirect/error flow.
- Validate action input at the server boundary.
- Use `fail()` for expected validation errors and typed action data for success paths.
- Reserve client-side fetch mutations for interactions that cannot fit form actions, and document why in the review summary.

## Server and client boundary

- Never use browser APIs such as `window`, `document`, `localStorage`, or `matchMedia` in `+page.server.ts`, `+layout.server.ts`, `+server.ts`, `hooks.server.ts`, or `src/lib/server/**`.
- Keep secrets, tokens, and private environment access in server-only modules.
- Client-only behavior belongs in `.svelte` files, `hooks.client.ts`, or browser-safe utility modules.
- When a component needs browser-only setup, guard it behind `onMount` or a browser-safe check.

## Styling

- Use one primary styling strategy per project.
- Scoped component CSS is the default.
- Tailwind CSS is optional. If the repo uses Tailwind, follow that pattern consistently.
- Do not mix Tailwind, large global CSS layers, and ad hoc utility frameworks unless the repo already does.
- Keep visual state names semantic and stable.

## Imports and naming

- Order imports: external packages, aliased paths, relative paths.
- Keep a blank line between import groups.
- Reusable component files are `PascalCase.svelte`.
- Utility modules are `camelCase.ts`.
- Store modules are `camelCase.ts`.
- Tests are `ComponentName.test.ts`, `route-name.test.ts`, or `route-name.spec.ts`.

## Testing

- Use Vitest with Svelte Testing Library for component and route-adjacent tests.
- Prefer accessible queries such as `getByRole`, `getByLabelText`, and `findByRole`.
- Test user-visible behavior, not implementation details.
- Mock network and server boundaries explicitly.
- Add coverage for load helpers, form actions, stores, and component states when the change touches them.

## Accessibility baseline

- All interactive elements are keyboard reachable.
- Buttons have meaningful text or `aria-label` when icon-only.
- Inputs have visible labels and programmatic associations.
- Dynamic status and validation feedback is announced when needed.
- See `accessibility-style.md` for the full guide.

## Verification

- `npx svelte-check --tsconfig ./tsconfig.json` passes.
- `npm run test` passes.
- `npm run build` passes.
- `npm run lint` passes.
