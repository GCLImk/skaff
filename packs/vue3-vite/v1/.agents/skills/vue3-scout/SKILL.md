---
name: vue3-scout
description: Map Vue 3 component tree, router configuration, Pinia stores, and Vite setup before implementation.
---

# Vue3 Scout

Map the codebase before implementation.

## Read First

- `.claude/conventions/vue3-style.md`
- `.claude/conventions/do-work-protocol.md`

## Directives

- Read the active REQ or task from disk before searching.
- Enumerate `package.json`, lockfile, `tsconfig.json`, Vite config, Vitest config, lint config, router setup, Pinia stores, and styling setup.
- Map routing, state management, shared component layers, composables, and test helpers.
- Record affected files, dependencies, existing patterns, and risks with `file:line` references where possible.
- Write findings to `do-work/scout/REQ-NNN-<topic>-findings.md` when operating inside `do-work`.
- Do not modify source files.
- No em dashes. Use " - " instead.

## Definition of Done

- [ ] Affected files and config identified
- [ ] Routing, state, data, and component boundaries mapped
- [ ] Risks and open questions recorded
- [ ] Findings written to `do-work/scout/` when a REQ is involved
