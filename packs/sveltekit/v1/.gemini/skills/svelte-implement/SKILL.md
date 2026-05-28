---
name: svelte-implement
description: Write SvelteKit routes, Svelte 5 components with runes, load functions, form actions, and Vitest tests. Activate for any SvelteKit feature, routing, or component work.
---

# Svelte Implement

Write SvelteKit and TypeScript code for the project.

## Read First

- `.claude/conventions/svelte-style.md`
- `.claude/conventions/accessibility-style.md`
- `.claude/conventions/do-work-protocol.md`

## Directives

- Re-read the full task or REQ from disk before changing code. Read neighboring files before creating new ones.
- Use Svelte 5 runes only. No legacy `$:` or `export let`.
- Prefer `$props()`, `$state`, `$derived`, and `$effect`.
- Prefer load functions and form actions over client fetch when the feature fits SvelteKit's lifecycle.
- Test user-visible behavior with Vitest and Svelte Testing Library.
- In plan-only work, write only the `## Plan` and `## Plan Hash` sections in the active REQ.
- In implement work, leave commits, branch management, and PRs to `git-workflow`.
- No em dashes in code comments, docs, summaries, or commit text. Use " - " instead.
- When working through `do-work`, write an implementation summary to `do-work/summaries/REQ-NNN-implement.md`.

## Verification

- Svelte and TypeScript pass: `npx svelte-check --tsconfig ./tsconfig.json`
- Tests pass: `npm run test`
- Build passes: `npm run build`
- Lint passes: `npm run lint`

## Definition of Done

- [ ] Requested routes, components, load functions, actions, stores, utilities, and tests are implemented
- [ ] `npx svelte-check --tsconfig ./tsconfig.json` passes
- [ ] `npm run test` passes, or skipping is justified
- [ ] `npm run build` passes
- [ ] `npm run lint` passes
- [ ] Summary written to `do-work/summaries/` when a REQ is involved
- [ ] Changes left ready for reviewer and `git-workflow`
