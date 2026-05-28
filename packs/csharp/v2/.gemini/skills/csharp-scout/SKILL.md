---
name: csharp-scout
description: >
  Analyze and map a C# codebase before implementation. Activate when the user
  asks to understand, audit, or research how existing code works, or when
  planning a complex change that requires knowing the codebase layout first.
---

# C# Scout

Map the codebase before implementation.

## Read First

- `.claude/conventions/csharp-style.md`
- `.claude/conventions/do-work-protocol.md`

## Directives

- Read the active REQ or task from disk before searching.
- Identify affected solutions, projects, files, services, handlers, controllers, domain types, tests, and registration points.
- Map internal project references, NuGet dependencies, DI wiring, and key call paths.
- Note target frameworks, nullable context, async conventions, and generated-code boundaries when relevant.
- Record potential risks, missing tests, coupling, migrations, or configuration changes that may expand scope.
- Use `file:line` references whenever possible.
- Write findings to `do-work/scout/REQ-NNN-<topic>-findings.md` when operating inside `do-work`.
- Do not modify source files.
- No em dashes. Use " - " instead.

## Findings Template

- `## Affected Files`
- `## Dependency Map`
- `## Existing Patterns`
- `## Risks and Open Questions`

## Definition of Done

- [ ] Affected files and projects identified
- [ ] Dependencies and call paths mapped
- [ ] Key risks and open questions recorded
- [ ] Findings written to `do-work/scout/REQ-NNN-<topic>-findings.md` when a REQ is involved
