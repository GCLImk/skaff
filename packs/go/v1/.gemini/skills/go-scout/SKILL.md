---
name: go-scout
description: >
  Map Go package structure, interfaces, dependencies, and go.mod before implementation.
---

# Go Scout

Map the Go codebase before implementation.

## Read First

- `.claude/conventions/go-style.md`
- `.claude/conventions/do-work-protocol.md`

## Directives

- Read the active REQ or task from disk before searching.
- Identify affected modules, packages, entry points, handlers, interfaces, tests, and configuration files.
- Map `go.mod` dependencies, first-party package boundaries, interface consumers, and current test coverage for the affected area.
- Record module path, Go version, router choice, generated-code boundaries, and risks that may expand scope.
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

- [ ] Affected files and packages identified
- [ ] Dependencies, interfaces, and test coverage mapped
- [ ] Key risks and open questions recorded
- [ ] Findings written to `do-work/scout/REQ-NNN-<topic>-findings.md` when a REQ is involved
