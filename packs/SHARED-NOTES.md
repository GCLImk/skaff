# Shared notes across packs

Files that are *conceptually* the same across packs. No automation enforces this - the list is a maintainer checklist when updating one pack's convention that should logically track across others.

## Files that should stay aligned

| File (within each pack)                      | Why it should track                                                  |
| -------------------------------------------- | -------------------------------------------------------------------- |
| `.claude/conventions/markdown-style.md`      | Generic markdown rules. Only language-tag examples diverge per pack. |
| `.claude/conventions/do-work-protocol.md`    | Queue, lock, and ownership semantics are protocol-level. Agent names within the ownership table legitimately diverge per pack. |
| `.claude/conventions/ratchet-protocol.md`    | Seven dimensions and the graduated kept bar are protocol-level. Tool mapping in the per-pack ratchet agent legitimately diverges. |
| `.claude/conventions/coverage-protocol.md`   | Coverage formula and band thresholds are protocol-level.             |
| `.claude/conventions/external-validation.md` | Adversarial prompt is protocol-level.                                |

**Not listed** (deliberately pack-specific, never backport):

- `<lang>-style.md` - the pack's defining convention.
- Agent files - each pack owns its agent roster.
- `commands/do-work-run.md` - each pack's slash command names its own specialists.
- Ratchet signal-source table in `ratchet.md`.
- `ratchet.conf.template` - tuned per stack.
- `.gitleaks.toml.template` - allowlist tuned per stack.
- CI workflow templates - per-toolchain.
- `CLAUDE.md.template` - lists the pack's conventions by name.

## Backport workflow

When editing a protocol-level convention in one pack:

1. Make the change.
2. Identify which other live packs should track. Use the table above.
3. Apply the equivalent change in each pack (verbatim or adapted as needed).
4. Commit each pack's change as a separate file edit in the same commit; commit message scope is `packs`.
5. If a pack is deliberately diverging on a previously shared convention, note it in that pack's `PACK.md` under a "Divergence from shared" heading.

## Shared base in `common/`

The truly pack-agnostic files live in `common/` (not under `packs/`) and are installed before any pack overlay:

- `common/.claude/conventions/commit-style.md` - Conventional Commits rules, language-agnostic.
- `common/do-work/templates/REQ-template.md` and `UR-template.md` - generic request shapes.
- `common/do-work/` runtime dir skeletons (`.gitkeep` sentinels).

If a pack ever needs to diverge on one of these, it can ship the file under its own version dir and the pack overlay will win (installer copies `common/` first, pack second). The override should be called out in `PACK.md`.
