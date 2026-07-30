---
name: nestjs-scout
description: >
  Map a NestJS backend before implementation. Activate when planning a change
  that requires understanding the module graph, provider and injection-token
  usage, controller routes, DTO and validation surface, persistence layer, or
  test setup.
---

# NestJS Scout

Map the codebase before implementation, with an emphasis on what depends on what. Read-only.

## Read First

- `.claude/conventions/nestjs-style.md`
- `.claude/conventions/do-work-protocol.md`

## Directives

- Read the active REQ or task from disk before searching.
- Enumerate `package.json` (including `packageManager` and every script the work will need),
  `yarn.lock`, `tsconfig.json`, `nest-cli.json`, ESLint config, Prettier config, and Jest config.
  Report which of `build`, `lint`, `format:check`, `test`, `test:cov` and `test:e2e` exist.
- Report a missing `yarn.lock`, or a competing `package-lock.json` or `pnpm-lock.yaml`, as a
  blocking finding - the verification commands in this project are yarn only.
- Map every `@Module()`: its `imports`, `exports`, `providers` and `controllers`. Name the
  composition root, any `@Global()` module, every import cycle, and every deep relative import
  that crosses a feature boundary.
- Map the injection surface: providers by class, `useClass`, `useFactory`, `useValue` and
  `useExisting`; every injection token and its consumers; every non-singleton provider scope.
- For every symbol the task will change, list its reverse dependencies. The usage map is the
  point of this skill.
- Map the request boundary (routes, DTOs and their validators, global pipes, guards,
  interceptors, filters, unguarded routes), the persistence layer (ORM, entities, migrations
  directory, whether `synchronize` is set), configuration loading, and the test surface.
- Record affected files, existing patterns and risks with `file:line` references.
- Write findings to `do-work/scout/REQ-NNN-<topic>-findings.md` when operating inside `do-work`.
- Do not modify source files, tests, or config.
- No em dashes. Use " - " instead.

## Definition of Done

- [ ] Manifest, scripts, lockfile state and config identified
- [ ] Module graph mapped, cycles and boundary violations named
- [ ] Reverse dependencies listed for every symbol the task will change
- [ ] Request boundary, persistence and test surface mapped
- [ ] Risks and open questions recorded
- [ ] Findings written to `do-work/scout/` when a REQ is involved
