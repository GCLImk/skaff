---
name: react-scout
description: >
  Map a React codebase before implementation. Activate when planning complex
  changes that require understanding existing component structure, routing,
  state management, or test setup.
---

# React Scout

Map the codebase before implementation.

## Read First

- `.claude/conventions/react-style.md`
- `.claude/conventions/do-work-protocol.md`

## Directives

- Read the active REQ or task from disk before searching.
- Enumerate `package.json`, lockfile, `tsconfig.json`, Vite or Next config, test config, lint config, and styling setup.
- Map routing, state management, data-fetching hooks, shared component layers, and test helpers.
- Record affected files, dependencies, existing patterns, and risks with `file:line` references where possible.
- Write findings to `do-work/scout/REQ-NNN-<topic>-findings.md` when operating inside `do-work`.
- Do not modify source files.
- No em dashes. Use " - " instead.

## Definition of Done

- [ ] Affected files and config identified
- [ ] Routing, state, data, and component boundaries mapped
- [ ] Risks and open questions recorded
- [ ] Findings written to `do-work/scout/` when a REQ is involved
