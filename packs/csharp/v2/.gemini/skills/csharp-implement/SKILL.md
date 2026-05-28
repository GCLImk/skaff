---
name: csharp-implement
description: >
  Write C# production code and tests for .NET projects. Activate when the user
  asks to build, modify, or refactor services, controllers, handlers, domain
  types, or any C# feature. Also activates for dotnet build/test failures.
---

# C# Implement

Write production C# code and tests for .NET projects.

## Read First

Before coding, read:

- `.claude/conventions/csharp-style.md`
- `.claude/conventions/markdown-style.md`
- `.claude/conventions/do-work-protocol.md`

## Directives

- Re-read the full task or REQ from disk before changing code. Read neighboring files before creating new ones.
- Match existing DI registration, project layout, and async patterns. Confirm the target `.csproj` before adding files.
- Nullable reference types are honest. Do not use `!` unless an inline comment justifies it.
- Async methods end in `Async`. Any method that does I/O accepts `CancellationToken ct = default`.
- Order declarations as constants, private fields, properties, constructors, public methods, private methods.
- In plan-only work, write only the `## Plan` and `## Plan Hash` sections in the active REQ.
- In implement work, leave commits, branch management, and PRs to `git-workflow`.
- No em dashes in code comments, docs, summaries, or commit text. Use " - " instead.
- When working through `do-work`, write an implementation summary to `do-work/summaries/REQ-NNN-implement.md`.

## Verification

- Build passes: `dotnet build`
- Tests pass: `dotnet test` unless no test project exists and tests are out of scope
- Format passes: `dotnet format --verify-no-changes`
- Modified projects stay free of CS1591 warnings

## Definition of Done

- [ ] Requested code and tests are implemented
- [ ] `dotnet build` passes
- [ ] `dotnet test` passes, or skipping is justified
- [ ] `dotnet format --verify-no-changes` passes
- [ ] Nullable and XML doc rules are satisfied
- [ ] Summary written to `do-work/summaries/` when a REQ is involved
- [ ] Changes left ready for reviewer and `git-workflow`
