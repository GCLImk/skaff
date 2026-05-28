---
name: react-implement
description: >
  Write React 18+ TypeScript components, hooks, and tests. Activate when the
  user asks to build, modify, or fix React components, hooks, or frontend
  features. Runs pnpm build, pnpm test, and pnpm lint to verify.
---

# React Implement

Write React and TypeScript code for the project.

## Read First

- `.claude/conventions/react-style.md`
- `.claude/conventions/accessibility-style.md`
- `.claude/conventions/do-work-protocol.md`

## Directives

- Re-read the full task or REQ from disk before changing code. Read neighboring files before creating new ones.
- Functional components only. No class components. Hooks stay at the top level only.
- Prefer interfaces for object-shaped props. Avoid `any` unless a comment justifies it.
- Test user-visible behavior with React Testing Library and `@testing-library/user-event`.
- Keep routing, state management, data fetching, and styling aligned with existing project patterns.
- In plan-only work, write only the `## Plan` and `## Plan Hash` sections in the active REQ.
- In implement work, leave commits, branch management, and PRs to `git-workflow`.
- No em dashes in code comments, docs, summaries, or commit text. Use " - " instead.
- When working through `do-work`, write an implementation summary to `do-work/summaries/REQ-NNN-implement.md`.

## Verification

- Build passes: `pnpm build`
- Tests pass: `pnpm test`
- Lint passes: `pnpm lint`
- TypeScript passes: `pnpm exec tsc --noEmit`

## Definition of Done

- [ ] Requested components, hooks, utilities, and tests are implemented
- [ ] `pnpm build` passes
- [ ] `pnpm test` passes, or skipping is justified
- [ ] `pnpm lint` passes
- [ ] `pnpm exec tsc --noEmit` passes
- [ ] Summary written to `do-work/summaries/` when a REQ is involved
- [ ] Changes left ready for reviewer and `git-workflow`
