# react pack

React 18+ and TypeScript 5+ scaffold pack for frontend application work. Targets Vite by default with Vitest and React Testing Library. Ships React-specific agents, conventions, do-work orchestration, and a ratchet tuned for UI correctness, testing, and accessibility.

## Versions

| Version | Status | Target runtime / tool baseline | Changelog |
| ------- | ------ | ------------------------------ | --------- |
| v1 | maintained | React 18+, TypeScript 5+, Vite, Vitest, RTL, pnpm | Initial cut |

**Latest:** v1

## Notes

- pnpm is preferred; npm and yarn are acceptable.
- Next.js is supported as an optional variant - same agent discipline, adapt build/test commands.
- Accessibility has elevated ratchet weight (1.5) because frontend regressions are user-facing.
- Test coverage is elevated (1.5) because component behavior is verified through user-level tests.
- v1 is standalone. Non-backwards-compatible changes require v2.
