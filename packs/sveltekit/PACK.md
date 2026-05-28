# sveltekit pack

SvelteKit 2+ scaffold pack for application work with Svelte 5 runes, TypeScript 5+, Vite 5+, Vitest, Svelte Testing Library, and optional Tailwind CSS. Ships SvelteKit-specific scout, implement, doc-writer, and accessibility agents plus the shared reviewer, ratchet, and git-workflow agents.

## Versions

| Version | Status | Target runtime / tool baseline | Changelog |
| ------- | ------ | ------------------------------ | --------- |
| v1 | maintained | SvelteKit 2+, Svelte 5, TypeScript 5+, Vite 5+, Vitest, Svelte Testing Library, optional Tailwind CSS | Initial cut |

**Latest:** v1

## Notes

- Svelte 5 runes only. No legacy `$:` reactive statements in v1 guidance.
- Form actions are preferred over client fetch for mutations that fit SvelteKit's request lifecycle.
- Accessibility has elevated ratchet weight (1.5) because UI regressions are user-facing.
- Test coverage has elevated ratchet weight (1.5) with `threshold_test_coverage = 0.65` because SvelteKit routes and form actions are harder to cover thoroughly.
- v1 is standalone. Non-backwards-compatible changes require v2.
