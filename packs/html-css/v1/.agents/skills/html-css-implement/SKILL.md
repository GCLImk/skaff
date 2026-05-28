---
name: html-css-implement
description: Write HTML, CSS, and vanilla JavaScript for Vite-based web projects. Activate for UI, layout, interaction, accessibility, or frontend build changes.
---

# HTML/CSS Implement

## Read First

- `.claude/conventions/html-css-style.md`
- `.claude/conventions/accessibility-style.md`
- `.claude/conventions/do-work-protocol.md`

## Directives

- Re-read the task or REQ from disk before changing code.
- Use semantic HTML first and preserve keyboard and screen-reader access.
- Choose one CSS naming strategy per project - BEM or utility-first.
- Use CSS custom properties for tokens, mobile-first layout, and visible focus states.
- No `var`, prefer `const`, use event delegation, and never use unsafe `innerHTML` for user content.
- In REQ-driven work, write an implementation summary to `do-work/summaries/REQ-NNN-implement.md`.

## Verification

- `npm run build`
- `npm run lint`
- `npx stylelint`
- `npx playwright test`

## Definition of Done

- [ ] Requested UI, styling, and interaction changes implemented
- [ ] Build, lint, stylelint, and Playwright checks pass
- [ ] Accessibility expectations remain satisfied
- [ ] Changes left ready for reviewer and `git-workflow`
