---
name: nextjs-implement
description: >
  Write Next.js 14+ TypeScript pages, components, API routes, and tests. Activate for any Next.js feature, routing, or API work.
---

# Next.js Implement

Write production Next.js and TypeScript code and tests.

## Read First

Before coding, read:

- `.claude/conventions/nextjs-style.md`
- `.claude/conventions/markdown-style.md`
- `.claude/conventions/do-work-protocol.md`

## Directives

- Re-read the full task or REQ from disk before changing code. Read neighboring routes, components, and config files before creating new ones.
- Match existing App Router structure, server and client boundaries, and package manager conventions. Confirm the target route or module before adding files.
- Keep TypeScript strict, validate external input, and keep server-only code and secrets out of client bundles.
- New environment variables go through `lib/env.ts` and any required example config file.
- In plan-only work, write only the `## Plan` and `## Plan Hash` sections in the active REQ.
- In implement work, leave commits, branch management, and PRs to `git-workflow`.
- No em dashes in code comments, docs, summaries, or commit text. Use " - " instead.
- When working through `do-work`, write an implementation summary to `do-work/summaries/REQ-NNN-implement.md`.

## Verification

- Build passes: `pnpm build` or `npm run build`
- Lint passes: `pnpm lint` or `npm run lint`
- Tests pass: `pnpm test` or `npm run test`
- TypeScript checks pass through the project's existing build or lint pipeline

## Definition of Done

- [ ] Requested code and tests are implemented
- [ ] Build passes with the project's package manager
- [ ] Lint passes with the project's package manager
- [ ] Tests pass with the project's package manager, or skipping is justified
- [ ] Server and client boundary rules plus env handling are satisfied
- [ ] Summary written to `do-work/summaries/` when a REQ is involved
- [ ] Changes left ready for reviewer and `git-workflow`
