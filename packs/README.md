# Packs

Language and platform packs for the Claude Agent Scaffold. Each pack is a complete overlay of agents, conventions, and templates targeting one language or stack.

## Contract

Every pack lives at `packs/<pack-name>/` and ships one or more versions as sibling directories (`v1/`, `v2/`, ...). The installer picks one pack + version and copies it on top of the shared `common/` tree into the target project.

### Required contents per version

```
packs/<pack>/v<N>/
  .claude/
    agents/*.md
    conventions/*.md     (at minimum the pack-specific style convention
                          and any convention that names agents)
  do-work/
    templates/
      CLAUDE.md.template    (the target's top-level CLAUDE.md source)
      ratchet.conf.template (tuned weights/thresholds for this stack)
      .gitleaks.toml.template (allowlist tuned to this stack)
      ci/                   (optional; omit if no CI gate ships yet)
```

A version is standalone. No layering across versions. No symlinks. Copy what you need from another version, diverge freely, document the divergence in `PACK.md`.

### Manifest (`packs/<pack>/PACK.md`)

One `PACK.md` per pack lists versions. Format:

```markdown
# <pack> pack

<one-paragraph description of the target stack and the pack's scope>

## Versions

| Version | Status       | Target runtime / tool baseline           | Changelog                |
| ------- | ------------ | ---------------------------------------- | ------------------------ |
| v2      | maintained   | ...                                      | (latest - what's new)    |
| v1      | frozen       | ...                                      | (initial cut)            |

**Latest:** v2

## Notes

<anything version-spanning a reader needs, e.g. migration notes between versions>
```

Status values:

- `planned` - directory does not exist yet; entry is a placeholder.
- `maintained` - receives fixes and protocol updates.
- `frozen` - still shipped, no further changes expected.
- `removed` - directory deleted; tombstone row kept for history.

### Version bumping

Integer major versions only (`v1`, `v2`, ...). Bump when any of the following change in a non-backwards-compatible way:

- Agent roster (rename, split, merge, or new required agent)
- Directive ordering or mandatory inputs on an agent
- Ratchet dimension set or kept-bar schema
- do-work protocol (lock semantics, file layout, ownership table)
- Target toolchain baseline (e.g. .NET 9 -> .NET 10 with required API shifts, Node 20 -> Node 22 with syntax features used)

Do not bump for cosmetic edits, new advisory notes, or tool-version bumps that remain compatible.

### Cap on live versions

At most three versions per pack stay `maintained` or `frozen`. When a fourth version ships, the oldest goes to `removed` status one quarter later. The manifest keeps the tombstone row so historical references do not orphan.

### Pinning from the target

The installer writes `.claude/.pack` into the target recording `pack`, `version`, `installed_at`, and the Skaff commit SHA. Future tooling (upgrade helper, compatibility check) reads this. Do not edit it by hand.

### Upgrading an installed project

There is no in-place upgrade. The intended path is:

```bash
./install.sh /path/to/project --force --pack <pack>@v<new>
```

The target project's git history holds the diff. Review and commit. Abandoned migrations are the project owner's to resolve.

## Shared files

A handful of files are expected to track across packs (commit style, generic markdown style). See [SHARED-NOTES.md](./SHARED-NOTES.md) for the backport checklist.
