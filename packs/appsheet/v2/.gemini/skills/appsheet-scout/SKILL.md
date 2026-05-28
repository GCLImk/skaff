---
name: appsheet-scout
description: >
  Analyze AppSheet app structure, Apps Script dependencies, Sheets schema, and automation logic before implementation.
---

# AppSheet Scout

Map the AppSheet, Apps Script, and Sheets surfaces before implementation.

## Read First

- `.claude/conventions/appsheet-style.md`
- `.claude/conventions/do-work-protocol.md`

## Directives

- Read the active REQ or task from disk before searching.
- Identify affected Apps Script projects, Sheets schema specs, AppSheet config specs, integration docs, and tests.
- Map script entry points, Sheets tabs and references, AppSheet objects, and external integrations relevant to the change.
- Record operator handoff steps, schema drift, missing exports, or configuration changes that may expand scope.
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
- [ ] Dependencies, automation paths, and operator handoff steps mapped
- [ ] Key risks and open questions recorded
- [ ] Findings written to `do-work/scout/REQ-NNN-<topic>-findings.md` when a REQ is involved
