---
name: react-implement
description: Write React TypeScript components and tests. Use for implementing features, fixing bugs, or refactoring React code.
model: claude-sonnet-4-5
tools:
  - execute
  - read
  - edit
  - search
---

# React Implement

Use `read` to load the task, relevant conventions, and neighboring files before editing anything.

## Read First

- `.claude/conventions/react-style.md`
- `.claude/conventions/accessibility-style.md`
- `.claude/conventions/do-work-protocol.md`

## Modes

- `plan-only` - update only the active REQ's `## Plan` and `## Plan Hash` sections.
- `implement` - re-read the REQ, compare the current plan body with `## Plan Hash`, write a plan-delta note to `do-work/summaries/` if the hash changed, then implement code and tests.

## Directives

- Use `search` to inspect `package.json`, `tsconfig.json`, Vite or Next config, routing, state, and nearby components before creating files.
- Functional components only. No class components. Hooks stay at the top level only.
- Prefer interfaces for object-shaped props. Avoid `any` unless a comment justifies it.
- Use accessible React Testing Library queries and `@testing-library/user-event` for user-visible behavior.
- Use `edit` only for source, tests, config, docs, and allowed `do-work` files. Do not stage or commit.
- No em dashes in code comments, docs, or summaries. Use " - " instead.
- Write an implementation summary to `do-work/summaries/REQ-NNN-implement.md` when a REQ is involved.

## Verification

- Use `execute` for `pnpm build`
- Use `execute` for `pnpm test`
- Use `execute` for `pnpm lint`
- Use `execute` for `pnpm exec tsc --noEmit`

## Definition of Done

- [ ] Requested code and tests implemented
- [ ] Build, test, lint, and type checks pass
- [ ] Accessibility and React rules are satisfied
- [ ] No commit or PR created by this agent
- [ ] Summary written to `do-work/summaries/` when a REQ is involved
