# HTML, CSS, and JavaScript Style

All agents read this file before writing or reviewing HTML, CSS, or vanilla JavaScript for this stack.

## Mandatory stack

| Layer        | Choice                                  | Reason                                   |
| ------------ | --------------------------------------- | ---------------------------------------- |
| Build tool   | Vite                                    | Fast static and SPA workflows            |
| Markup       | HTML5                                   | Semantic-first authoring                 |
| Styling      | CSS3 with custom properties             | Tokens stay visible and portable         |
| Scripting    | Vanilla JavaScript (ES2022+)            | No framework dependency by default       |
| Lint         | ESLint + Stylelint                      | JS and CSS quality gates                 |
| Format       | Prettier                                | Consistent formatting                    |
| E2E          | Playwright                              | Browser-real verification                |
| Accessibility| axe-core + pa11y where configured       | Accessibility is the defining quality gate |

If a request requires deviating from this stack, stop and use AskUserQuestion.

## Project layout

A typical Vite project for this pack uses:

```text
<repo>/
  index.html
  src/
    main.js
    styles/
    components/
  public/
  tests/
  package.json
  vite.config.js | vite.config.mjs | vite.config.ts
```

Other layouts are acceptable when they are consistent and the Vite entry path is clear.

## Semantic HTML

- Use native landmarks: `header`, `main`, `nav`, `aside`, `footer`, `section`, `article`.
- Preserve heading hierarchy from page title down.
- Prefer native controls before custom widgets.
- Keep DOM structure meaningful even when CSS changes the visual order.
- Use lists for repeated items, forms for user input, and buttons for actions.

## CSS architecture

- Choose one naming strategy per project: **BEM** or **utility-first**. Do not mix them casually.
- Define design tokens with CSS custom properties for color, spacing, typography, radii, motion, and shadows.
- Keep selectors low-specificity. Prefer class selectors over IDs and deep descendant chains.
- Use mobile-first breakpoints.
- No inline styles except when a platform API requires one small dynamic value and there is no maintainable alternative.
- No `!important` except for narrowly-scoped utility overrides that are documented in the code.

## Responsive behavior

- Build from the smallest viewport upward.
- Favor fluid layouts, `minmax()`, flexbox, and grid over device-specific hacks.
- Avoid fixed heights on content containers unless the content is intentionally clipped.
- Test touch targets and spacing at mobile widths before polishing desktop layout.

## JavaScript

- Use ES modules and modern syntax. No `var`.
- Prefer `const`; use `let` only when reassignment is real.
- Use event delegation for repeated interactive elements.
- Never inject user-provided content with `innerHTML`.
- Prefer `textContent`, `createElement`, and template cloning for safe DOM updates.
- Keep behavior progressively enhanced. Content and core navigation should remain usable before JavaScript runs.
- Use `data-*` hooks for behavior binding instead of relying on visible text.

## Accessibility and interaction

- Accessibility-style.md is binding for every interactive change.
- Icon buttons need accessible names.
- Images need meaningful alt text or `alt=""` when decorative.
- Inputs need labels, helper text, and error wiring.
- Focus must remain visible across themes and breakpoints.

## Linting and formatting

- ESLint governs JavaScript quality.
- Stylelint governs CSS quality.
- Prettier handles formatting for HTML, CSS, JS, JSON, and Markdown.
- Do not disable lint rules without a file-local explanation.

## Testing

- Use Playwright for end-to-end coverage of critical user flows.
- Include accessibility assertions with axe-core where the repo supports it.
- Use pa11y for page-level accessibility checks when configured.
- Verify keyboard paths, focus order, and reduced-motion behavior on affected screens.

## Documentation

- The README must explain setup, scripts, build command, lint command, and test command.
- Document any non-obvious accessibility contract, such as roving tabindex or dialog focus behavior.
- Use JSDoc on exported helpers or modules when the behavior is not obvious from the function name alone.

## Build and verification commands

- `npm run build`
- `npm run lint`
- `npx stylelint "src/**/*.css"` or the repo equivalent
- `npx playwright test`
- `npx prettier --check .`

## Secrets handling

- Never commit API keys, auth tokens, or production endpoints.
- Document placeholders in `.env.example` only.
- The repo root `.gitleaks.toml` remains the secret scanning guardrail.
