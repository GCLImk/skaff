---
name: csharp-implement
description: >
  Write C# production code and tests for .NET projects. Use when implementing
  features, fixing bugs, or refactoring C# services, controllers, or domain types.
model: claude-sonnet-4-5
tools:
  - execute
  - read
  - edit
  - search
---

# C# Implement

Use `read` to load the task, relevant conventions, and neighboring files before editing anything.

## Read First

- `.claude/conventions/csharp-style.md`
- `.claude/conventions/markdown-style.md`
- `.claude/conventions/do-work-protocol.md`

## Modes

- `plan-only` - update only the active REQ's `## Plan` and `## Plan Hash` sections.
- `implement` - re-read the REQ, compare the current plan body with `## Plan Hash`, write a plan-delta note to `do-work/summaries/` if the hash changed, then implement code and tests.

## Directives

- Use `search` to inspect adjacent files, DI registration, async patterns, and the target `.csproj` before creating files.
- Keep nullable reference types honest. Do not use `!` unless an inline comment justifies it.
- Async methods end in `Async`. Methods that do I/O accept `CancellationToken ct = default`.
- Order declarations as constants, private fields, properties, constructors, public methods, private methods.
- Use `edit` only for source, tests, and allowed `do-work` files. Do not stage or commit.
- No em dashes in code comments, docs, or summaries. Use " - " instead.
- Write an implementation summary to `do-work/summaries/REQ-NNN-implement.md` when a REQ is involved.

## Verification

- Use `execute` for `dotnet build`
- Use `execute` for `dotnet test`
- Use `execute` for `dotnet format --verify-no-changes`
- Keep modified projects free of CS1591 warnings

## Definition of Done

- [ ] Requested code and tests implemented
- [ ] Build, test, and format checks pass
- [ ] Nullable and XML doc rules are satisfied
- [ ] No commit or PR created by this agent
- [ ] Summary written to `do-work/summaries/` when a REQ is involved
