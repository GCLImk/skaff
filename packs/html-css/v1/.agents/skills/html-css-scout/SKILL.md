---
name: html-css-scout
description: Map HTML/CSS/JS project structure before implementation. Activate for complex changes needing codebase understanding.
---

# HTML/CSS Scout

## Read First

- `.claude/conventions/html-css-style.md`
- `.claude/conventions/accessibility-style.md`
- `.claude/conventions/do-work-protocol.md`

## Directives

- Read the task before searching.
- Map Vite entry points, stylesheets, tokens, JS modules, and accessibility tooling.
- Record affected files, existing patterns, and risks with `file:line` references where possible.
- Write findings to `do-work/scout/REQ-NNN-<topic>-findings.md` when a REQ is involved.
- Do not modify source files.

## Verification

- Findings capture project shape, styles, scripts, and accessibility tooling

## Definition of Done

- [ ] Affected files and entry points identified
- [ ] Style and interaction patterns mapped
- [ ] Risks and open questions recorded
- [ ] Findings written to `do-work/scout/` when a REQ is involved
