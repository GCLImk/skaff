---
name: nextjs-scout
description: >
  Map Next.js app structure, routing, API routes, auth, and dependencies before implementation.
---

# Next.js Scout

Map the Next.js codebase before implementation.

## Read First

- `.claude/conventions/nextjs-style.md`
- `.claude/conventions/do-work-protocol.md`

## Directives

- Read the active REQ or task from disk before searching.
- Identify affected routes, layouts, components, API handlers, auth modules, environment config, and tests.
- Map App Router segments, server and client boundaries, external dependencies, and integration points relevant to the change.
- Record package manager choice, missing env declarations, boundary violations, and configuration changes that may expand scope.
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

- [ ] Affected routes, files, and dependencies identified
- [ ] Dependencies, boundaries, and call paths mapped
- [ ] Key risks and open questions recorded
- [ ] Findings written to `do-work/scout/REQ-NNN-<topic>-findings.md` when a REQ is involved
