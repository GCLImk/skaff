---
name: gcli-scout
description: >
  Analyze gcli Python structure, Chrome extension layout, and Gemini persona/skill dependencies before implementation.
---

# gcli Scout

Map the gcli codebase before implementation.

## Read First

- `.claude/conventions/gcli-style.md`
- `.claude/conventions/do-work-protocol.md`

## Directives

- Read the active REQ or task from disk before searching.
- Identify affected CLI modules, extension files, host config, ADK code, personas, skills, tests, and workflow files.
- Map the dispatch table, manifest entrypoints, host bridge shape, and first-party imports relevant to the change.
- Record safety issues, missing manifest wiring, persona or skill dependencies, and configuration changes that may expand scope.
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

- [ ] Affected files and surfaces identified
- [ ] Dispatch, extension, host, and dependency paths mapped
- [ ] Key risks and open questions recorded
- [ ] Findings written to `do-work/scout/REQ-NNN-<topic>-findings.md` when a REQ is involved
