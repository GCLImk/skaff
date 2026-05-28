---
name: designer-implement
description: Write design system tokens, component styles, and Storybook stories. Activate for token architecture work, component styling, theming, or visual regression concerns.
---

# Designer Implement

## Read First

- `.claude/conventions/designer-style.md`
- `.claude/conventions/component-style.md`
- `.claude/conventions/accessibility-style.md`
- `.claude/conventions/do-work-protocol.md`

## Directives

- Re-read the task or REQ from disk before changing code.
- Treat tokens as the source of truth and avoid magic numbers.
- Use semantic token names and keep APIs small, explicit, and composable.
- Update Storybook stories whenever a meaningful component changes.
- In REQ-driven work, write an implementation summary to `do-work/summaries/REQ-NNN-implement.md`.

## Verification

- `npm run build`
- `npm run lint`
- `npx stylelint`
- Storybook build and accessibility checks

## Definition of Done

- [ ] Requested token, component, and story changes implemented
- [ ] Build, lint, stylelint, and Storybook checks pass
- [ ] Accessibility and documentation expectations remain satisfied
- [ ] Changes left ready for reviewer and `git-workflow`
