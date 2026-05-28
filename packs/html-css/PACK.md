# html-css pack

Targets HTML5, CSS3, and vanilla JavaScript web applications built with Vite, formatted with Prettier, linted with ESLint and Stylelint, and validated through Playwright end-to-end tests. Accessibility is the defining quality gate for this pack and carries a 2.0 ratchet weight.

## Versions

| Version | Status     | Target runtime / tool baseline                                    | Changelog |
| ------- | ---------- | ----------------------------------------------------------------- | --------- |
| v1      | maintained | Node 20+, Vite, ESLint, Stylelint, Prettier, Playwright, axe-core | Initial cut. Accessibility-weighted frontend pack. |

**Latest:** v1

## Notes

### Toolchain choices

- **Runtime:** Node 20+ and Vite are the baseline.
- **Linting:** ESLint for JavaScript, Stylelint for CSS, Prettier for formatting.
- **Testing:** Playwright is the default browser-real verification path. axe-core and pa11y are expected when the target repo wires them in.
- **Layout:** standard Vite structure with `index.html`, `src/`, `public/`, and `tests/`.

### Ratchet tuning rationale

- `accessibility_weight = 2.0` because accessible interaction quality is the defining property of this pack.
- `dead_code_weight = 0.5` because unused-selector and orphaned-asset detection can be noisy on frontend repos.
- `threshold_accessibility = 0.85` keeps the pack aligned with WCAG AA expectations without pretending every repo starts perfect.

### Divergence from shared

None declared. Protocol-level conventions track the shared pack model with agent-name substitutions and stack-specific quality dimensions.

### Upgrading an installed project

There is no in-place upgrade. To apply pack changes to an existing target:

```bash
./install.sh /path/to/project --force --pack html-css@v1
```

Review the diff in the target's git history. Re-run without `--force` to verify idempotency.
