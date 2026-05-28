# designer pack

Targets design-system and component-library repositories where tokens are the source of truth, Storybook is a required deliverable, CSS or SCSS define the presentation layer, and accessibility plus documentation are first-class quality gates. This pack is tuned for design systems rather than general application code.

## Versions

| Version | Status     | Target runtime / tool baseline                                               | Changelog |
| ------- | ---------- | ---------------------------------------------------------------------------- | --------- |
| v1      | maintained | Node 20+, Storybook, Stylelint, ESLint, Chromatic, CSS or SCSS tokens        | Initial cut. Design-system pack with Storybook and accessibility emphasis. |

**Latest:** v1

## Notes

### Toolchain choices

- **Runtime:** Node 20+ with Storybook as the documentation surface.
- **Styling:** CSS or SCSS with token-driven architecture.
- **Validation:** ESLint, Stylelint, Storybook build, Chromatic where configured, and accessibility checks.
- **Deliverables:** stories are part of done, not optional.

### Ratchet tuning rationale

- `accessibility_weight = 2.0` because component-library accessibility defects spread quickly across products.
- `doc_quality_weight = 2.0` because Storybook stories and component docs are operator-facing deliverables, not afterthoughts.
- `dead_code_weight = 0.5` because unused-token detection can be noisy until a project adds dedicated tooling.

### Divergence from shared

None declared. Protocol-level conventions track the shared pack model with agent-name substitutions and design-system-specific quality dimensions.

### Upgrading an installed project

There is no in-place upgrade. To apply pack changes to an existing target:

```bash
./install.sh /path/to/project --force --pack designer@v1
```

Review the diff in the target's git history. Re-run without `--force` to verify idempotency.
