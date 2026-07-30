# Packs

Language and platform packs for the Claude Agent Scaffold. Each pack is a complete overlay of agents, conventions, templates, and optional tool-specific multi-LLM files targeting one language or stack.

Current packs include `csharp`, `appsheet`, `python`, `go`, `nextjs`, `gcli`, `react`, `vue3-vite`, `html-css`, `designer`, and `appscript`. Recent additions are `go`, `react`, `vue3-vite`, `html-css`, `designer`, and `appscript`.

## Contract

Every pack lives at `packs/<pack-name>/` and ships one or more versions as sibling directories (`v1/`, `v2/`, ...). The installer picks one pack + version and copies it on top of the shared `common/` tree into the target project.

### Required contents per version

```
packs/<pack>/v<N>/
  .claude/                 (required)
    agents/*.md
    commands/*.md
    conventions/*.md
  do-work/                 (required)
    templates/
      CLAUDE.md.template      (the target's top-level CLAUDE.md source)
      ratchet.conf.template   (tuned weights/thresholds for this stack)
      .gitleaks.toml.template (allowlist tuned to this stack)
      ci/                     (optional; omit if no CI gate ships yet)
  .cursor/rules/           (recommended - multi-LLM)
  .windsurf/rules/         (recommended - multi-LLM)
  .windsurf/workflows/     (recommended - multi-LLM)
  .gemini/skills/          (recommended - multi-LLM)
  .agents/skills/          (recommended - multi-LLM)
  .github/agents/          (recommended - multi-LLM)
  .github/instructions/    (recommended - multi-LLM)
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

A handful of files are expected to track across packs (generic markdown style, protocol-level conventions with agent names substituted). See [SHARED-NOTES.md](./SHARED-NOTES.md) for the backport checklist.

Two conventions are not pack-owned at all: `commit-style.md` and `knowledge-protocol.md` ship once from `common/.claude/conventions/` and install identically into every pack. Do not add a pack-local copy of either - a pack-local file of the same name only wins the installer's collision with `-Force`, so an unforced override would silently do nothing (see [INSTALL.md](../INSTALL.md#what-gets-installed)). `knowledge-protocol.md` uses `<pack>` and "domain advisor or specialist agent" as placeholders (documented at the top of the file) since it cannot hard-code any one pack's agent names.

## Multi-LLM compatibility

New packs should include the multi-LLM directories where the tool supports them: `.cursor/rules/`, `.windsurf/rules/`, `.windsurf/workflows/`, `.gemini/skills/`, `.agents/skills/`, `.github/agents/`, and `.github/instructions/`.

The `common/` tree handles the generic cross-tool files automatically for every install, including `GEMINI.md`, `AGENTS.md`, `.github/copilot-instructions.md`, `.cursorrules`, `.windsurfrules`, `.aider.conf.yml`, and `.continue/rules/`. Pack overlays only need to add the pack-specific rules, agents, skills, and instructions.
