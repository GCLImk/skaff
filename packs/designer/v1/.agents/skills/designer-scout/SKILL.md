---
name: designer-scout
description: Analyze design system for token drift, component API inconsistencies, and missing Storybook coverage. Activate before design system changes.
---

# Designer Scout

## Read First

- `.claude/conventions/designer-style.md`
- `.claude/conventions/component-style.md`
- `.claude/conventions/accessibility-style.md`
- `.claude/conventions/do-work-protocol.md`

## Directives

- Read the task before searching.
- Map token sources, component inventory, story coverage, theming, and accessibility tooling.
- Record affected files, existing patterns, and risks with `file:line` references where possible.
- Write findings to `do-work/scout/REQ-NNN-<topic>-findings.md` when a REQ is involved.
- Do not modify source files.

## Verification

- Findings capture tokens, components, stories, and tooling gaps

## Definition of Done

- [ ] Affected files and token sources identified
- [ ] Component and story coverage mapped
- [ ] Risks and open questions recorded
- [ ] Findings written to `do-work/scout/` when a REQ is involved
