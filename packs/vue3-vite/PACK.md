# vue3-vite pack

Vue 3 and TypeScript scaffold pack for frontend application work.
Targets Vite with Vitest and Vue Testing Library, plus Pinia and Vue Router 4.
Ships Vue-specific agents, conventions, do-work orchestration, and a ratchet tuned for UI correctness, testing, and accessibility.

## Versions

| Version | Status | Target runtime / tool baseline | Changelog |
| ------- | ------ | ------------------------------ | --------- |
| v1 | maintained | Vue 3, TypeScript 5+, Vite 5+, Vitest, Vue Testing Library, Pinia, Vue Router 4, npm | Initial cut |

**Latest:** v1

## Notes

- npm scripts are the default verification path: `npm run build`, `npm run test`, `npm run lint`, and `npm run typecheck`.
- Accessibility has elevated ratchet weight (1.5) because frontend regressions are user-facing.
- Test coverage is elevated (1.5) because component behavior is verified through user-level tests.
- v1 is standalone. Non-backwards-compatible changes require v2.
