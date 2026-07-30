---
name: nestjs-implement
description: >
  Write NestJS 10+ TypeScript modules, controllers, providers, DTOs, guards,
  pipes, filters, migrations, and Jest tests. Activate when the user asks to
  build, modify, or fix backend features or endpoints. Runs yarn tsc --noEmit,
  yarn lint, yarn test, and yarn build to verify.
---

# NestJS Implement

Write NestJS and TypeScript code for the service.

## Read First

- `.claude/conventions/nestjs-style.md`
- `.claude/conventions/markdown-style.md`
- `.claude/conventions/do-work-protocol.md`

## Directives

- Re-read the full task or REQ from disk before changing code. Read neighbouring files before
  creating new ones.
- Register a new provider in exactly one module and export it when another module consumes it.
  Never import across a feature boundary by deep relative path. Break cycles by extracting the
  shared piece, not with `forwardRef()`.
- Constructor injection only. Use a `Symbol` or `const` injection token when the collaborator is
  swapped in tests or per environment. Keep the default singleton scope unless per-request state
  cannot be passed as an argument.
- Controllers validate, delegate to one service method, and shape the response. Business logic
  lives in providers. Never return a persistence entity from a controller.
- Every structured input gets a DTO class with `class-validator` decorators on every field. Do
  not relax the global `ValidationPipe` options per route.
- Read configuration through `ConfigService.get<T>()`. No `process.env` outside the config
  module. Never write to `.env` or any real secret file.
- Await or return every promise. Type every async return as `Promise<T>`. Never swallow an error,
  and never put a driver error or config value in a client-facing message.
- Schema changes ship as a reviewed migration file, never `synchronize: true`. Split destructive
  changes into expand and contract phases and state the rollback path.
- Build tests with `Test.createTestingModule()` and override only the collaborators the test
  needs. Add an e2e spec under `test/` when the change touches a controller, guard, pipe, or the
  global bootstrap. Tests never reach the network.
- Prefer `yarn nest generate <schematic> <name>` for new framework classes, then edit the result
  to match the conventions.
- In plan-only work, write only the `## Plan` and `## Plan Hash` sections in the active REQ.
- In implement work, leave commits, branch management, and PRs to `git-workflow`.
- No em dashes in code comments, docs, summaries, or commit text. Use " - " instead.
- When working through `do-work`, write an implementation summary to
  `do-work/summaries/REQ-NNN-implement.md`.

## Verification

- TypeScript passes: `yarn tsc --noEmit`
- Lint passes: `yarn lint`
- Format clean: `yarn format:check`
- Tests pass: `yarn test`
- End-to-end specs pass when the boundary changed: `yarn test:e2e`
- Build passes: `yarn build`

## Definition of Done

- [ ] Requested modules, providers, controllers, DTOs, migrations and tests are implemented
- [ ] `yarn tsc --noEmit` passes
- [ ] `yarn lint` and `yarn format:check` pass
- [ ] `yarn test` passes, or skipping is justified
- [ ] `yarn build` passes
- [ ] Every new exported provider, DTO, guard, pipe, interceptor and filter has a TSDoc block and a spec
- [ ] Summary written to `do-work/summaries/` when a REQ is involved
- [ ] Changes left ready for reviewer and `git-workflow`
