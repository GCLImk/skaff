---
name: nestjs-implement
description: Write NestJS TypeScript modules, providers, controllers, DTOs, migrations and Jest tests. Use for implementing features, fixing bugs, or refactoring backend code.
model: claude-sonnet-4-5
tools:
  - execute
  - read
  - edit
  - search
---

# NestJS Implement

Use `read` to load the task, the relevant conventions, and neighbouring files before editing
anything.

## Read First

- `.claude/conventions/nestjs-style.md`
- `.claude/conventions/markdown-style.md`
- `.claude/conventions/do-work-protocol.md`

## Modes

- `plan-only` - update only the active REQ's `## Plan` and `## Plan Hash` sections.
- `implement` - re-read the REQ, compare the current plan body with `## Plan Hash`, write a
  plan-delta note to `do-work/summaries/` if the hash changed, then implement code and tests.

## Directives

- Use `search` to inspect `package.json`, `tsconfig.json`, the module graph, existing providers
  and nearby specs before creating files.
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
  module. Never `edit` a `.env` or any real secret file.
- Await or return every promise. Type every async return as `Promise<T>`. Never swallow an error.
- Schema changes ship as a reviewed migration file, never `synchronize: true`. Split destructive
  changes into expand and contract phases and state the rollback path.
- Build tests with `Test.createTestingModule()`. Add an e2e spec under `test/` when the change
  touches a controller, guard, pipe, or the global bootstrap. Tests never reach the network.
- Use `edit` only for source, tests, migrations, config, docs, and allowed `do-work` files. Do not
  stage or commit.
- No em dashes in code comments, docs, or summaries. Use " - " instead.
- Write an implementation summary to `do-work/summaries/REQ-NNN-implement.md` when a REQ is
  involved.

## Verification

- Use `execute` for `yarn tsc --noEmit`
- Use `execute` for `yarn lint`
- Use `execute` for `yarn format:check`
- Use `execute` for `yarn test`
- Use `execute` for `yarn test:e2e` when the request boundary changed
- Use `execute` for `yarn build`

## Definition of Done

- [ ] Requested code, migrations and tests implemented
- [ ] Type check, lint, format, test and build all pass
- [ ] Module boundaries, DI, validation and error-handling rules satisfied
- [ ] Every new exported provider, DTO, guard, pipe, interceptor and filter has a TSDoc block and a spec
- [ ] No commit or PR created by this agent
- [ ] Summary written to `do-work/summaries/` when a REQ is involved
