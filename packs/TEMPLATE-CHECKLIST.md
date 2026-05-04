# Template checklist for new packs

This checklist is the canonical procedure for building a new language/stack pack. There is **no `_template/` directory** by design. The duplication and drift cost of a separate template would outweigh the benefit; instead, **`packs/csharp/v2`** is the canonical structural reference, and this checklist names the swaps you must make on top of it.

## Step 0 - confirm scope

Before starting, answer these in writing (place in your draft `PACK.md`):

- **Target runtime:** version baseline (e.g. Python 3.12+, Node 20+, Go 1.22+).
- **Packaging tool:** one canonical choice. Document acceptable alternatives.
- **Lint + format tool:** one tool covering both if possible (e.g. ruff for python).
- **Test framework:** one choice. Coverage tool may be the same package or separate.
- **Type checker:** if the language has one, name it. Optional vs required.
- **Doc style:** docstring/comment convention (e.g. Google docstrings, JSDoc).
- **Layout:** src vs flat, repo conventions.

If any of the above has no defensible default, do not start. Resolve via AskUserQuestion or a design note first.

## Step 1 - bootstrap directory

```bash
cp -r packs/csharp/v2 packs/<lang>/v1
cd packs/<lang>/v1
```

## Step 2 - rename agent and convention files

```bash
cd .claude/agents
mv csharp-scout.md       <lang>-scout.md
mv csharp-implement.md   <lang>-implement.md
mv csharp-doc-writer.md  <lang>-doc-writer.md

cd ../conventions
mv csharp-style.md <lang>-style.md
```

`reviewer.md`, `ratchet.md`, `git-workflow.md` keep their names (shared across packs).

## Step 3 - mechanical sweep of references

In every `.md` file under `.claude/`, `do-work/templates/`, replace every occurrence of:

- `csharp-scout` -> `<lang>-scout`
- `csharp-implement` -> `<lang>-implement`
- `csharp-doc-writer` -> `<lang>-doc-writer`
- `csharp-style` -> `<lang>-style`

Use sed or an editor sweep. Do not touch the disambiguation note in `do-work-protocol.md` line 5 (which mentions the orchestrator-as-main-session rename - that is shared protocol).

## Step 4 - rewrite `<lang>-style.md`

Full rewrite. The structure to mirror is in `packs/csharp/v2/.claude/conventions/csharp-style.md`. Required sections:

1. Project layout
2. Packaging tool
3. Naming conventions
4. Type system / nullability rules (if applicable)
5. Comment / docstring style
6. Async semantics (if applicable)
7. Error handling
8. Imports / module hygiene
9. Lint and format tooling
10. Type checking (if applicable)
11. Test framework and conventions
12. Coverage tooling
13. Build / verification commands
14. Secrets handling

Optional final section: a starter config snippet (e.g. `pyproject.toml`, `tsconfig.json`).

Write from scratch in the language's idiom; do not mechanically translate C# rules.

## Step 5 - retool the four agent files

Per agent, swap the language-specific tool grants and directives. Rules:

### `<lang>-scout.md`

- Frontmatter `tools:` Bash grants: replace dotnet/.sln/.csproj enumeration commands with the equivalent for the target stack.
- Directives 2-5: rewrite to enumerate the stack's project file (e.g. pyproject.toml, package.json, go.mod), dependency lockfile, internal module structure, and import graph.
- Output Format: rename "Solutions and Projects" to a stack-appropriate label.

### `<lang>-implement.md`

- Frontmatter `tools:` Bash grants: replace dotnet build/test/format with the stack's lint, format, test, and syntax-check commands.
- **Do NOT add `Bash(git add*)` or `Bash(git commit*)`.** Those belong exclusively to git-workflow. Keep `git status`, `git log`, `git diff` for read-only awareness.
- Directives: rewrite the per-language discipline section (DI, async, declarations order, etc.) to match `<lang>-style.md`.
- Definition of Done: replace `dotnet build/test/format/CS1591` checkboxes with the stack's lint/test/coverage/docstring-coverage gates.
- Keep verbatim:
  - The "Do not stage or commit" boundary directive.
  - The plan-only mode / implement mode split with hash-based plan-drift detection.
  - The "Changed files left in working tree for git-workflow" DoD checkbox.

### `<lang>-doc-writer.md`

- Frontmatter `tools:` grants: replace dotnet build/format with the stack's syntax check and lint.
- **Do NOT add `Bash(git add*)` or `Bash(git commit*)`.**
- Directives: rewrite XML doc / `<summary>` / `<param>` rules to the stack's docstring style.
- DoD: replace CS1591 with the stack's docstring-coverage gate (e.g. interrogate for python, missing-jsdoc lint rule for typescript).
- Keep verbatim: the "Do not stage or commit" boundary directive.

### `ratchet.md`

- Frontmatter `tools:` Bash grants: replace dotnet build/test/format with the stack's syntax-check, lint, format, test, and coverage commands.
- Directive 5: replace "run `dotnet build` and `dotnet test` fresh" with the stack equivalents.
- **Tool Mapping table** (the seven-dimension table near the bottom): full rewrite. Each row's "Signal source" column must name the actual command and tool that produces the signal in the target stack. Use `null` for any dimension genuinely not measurable; document the gap in `ratchet.conf.template` `na_dimensions`.

### `reviewer.md`

- Frontmatter `tools:` grants: replace dotnet build/test with the stack's lint and test invocations.
- Inputs section: same.
- Directive 2-3: replace "CS1591 warning count" with the stack's docstring gate.

### `git-workflow.md`

- Description only: change "C# projects" to "<Stack> projects". The git operations themselves are language-agnostic; do not touch the rest.

## Step 6 - retool the four templates

Under `do-work/templates/`:

### `CLAUDE.md.template`

- Conventions Index table: change the `csharp-style.md` row to `<lang>-style.md` with a stack-appropriate "read before" description.
- Verify no lingering "C#" / "dotnet" / "XML doc" / "CS1591" mentions.

### `ratchet.conf.template`

- Add a comment block at the top documenting the stack's tuning rationale (mirror the appsheet/v1 or python/v1 style).
- Adjust weights and thresholds for the stack's typical signal-to-noise ratio.
- Populate `na_dimensions` if the stack legitimately cannot measure one (e.g. no test_coverage tooling on day one).

### `.gitleaks.toml.template`

- Title: `gitleaks config for <lang> pack`.
- Allowlist paths: stack-typical test, fixture, virtualenv, cache directories.
- Inline regex examples: stack-typical safe-token patterns.

### `ci/ratchet-gate.yml.template`

- GitHub Actions workflow.
- Replace `actions/setup-dotnet@v4` and `dotnet ...` steps with the stack's setup action and commands.
- Add a `permissions:` block (`contents: read`, `pull-requests: write`, `checks: write`).
- Pin all action versions to specific majors. Do not use `@main`.
- Keep the baseline-composite-floor comparison logic structurally identical.

### `ci/README.md`

- Replace dotnet references with stack equivalents.
- Branch protection settings section is language-agnostic; keep verbatim aside from the renamed required-check job name.

## Step 7 - manifest

Write `packs/<lang>/PACK.md`. Required sections (mirror the csharp/v2 PACK.md):

- **Description** - one paragraph. What this pack targets.
- **Versions table** - row per version with status, target tool baseline, one-line changelog.
- **Notes** - toolchain choices (rationale for any non-obvious picks), ratchet tuning rationale, divergence from shared (if any), upgrade path.

## Step 8 - update top-level pack tables

Three files at repo root:

- `INSTALL.md` - "Packs" table.
- `README.md` - intro paragraph and Roadmap section.
- (No top-level changes needed elsewhere.)

## Step 9 - test the install

```bash
rm -rf /tmp/<lang>-test
./install.sh /tmp/<lang>-test --pack <lang>
```

Expected:

- File count similar to the reference pack (csharp/v2 ships 28 files).
- Pack identity sentinel: `cat /tmp/<lang>-test/.claude/.pack` shows `pack: <lang>`, `version: v1`.
- Re-run is idempotent (no copies on second invocation without `--force`).

## Step 10 - cross-pack consistency check

Run these greps against your new pack version. Each should return zero or only the explicitly-allowed string:

```bash
cd packs/<lang>/v1
grep -rn "csharp\|dotnet\|CS1591\|\.csproj\|NuGet" . | grep -v PACK.md
```

Should return zero matches (PACK.md may legitimately reference csharp as a peer pack).

```bash
grep -rn "Bash(git add\|Bash(git commit" .claude/agents/<lang>-implement.md .claude/agents/<lang>-doc-writer.md
```

Should return zero matches (boundary preserved).

```bash
grep -rn "Do not stage or commit" .claude/agents/<lang>-implement.md .claude/agents/<lang>-doc-writer.md
```

Should return one match per file (the boundary directive).

```bash
grep -n "orchestrator" .claude/conventions/*.md | grep -v "Note on"
```

Should return zero matches outside the disambiguation note in `do-work-protocol.md`.

## Step 11 - protocol drift check

If you noticed a protocol-level change worth backporting to other packs (e.g. a sharper directive, a new ratchet honesty mechanism), file an issue or apply across all maintained packs in one commit. See [SHARED-NOTES.md](./SHARED-NOTES.md) for the backport contract.

## What this checklist deliberately omits

- A scripted scaffold-new-pack tool. Once we have 5+ packs, that may be worth building. At 3 packs the cost outweighs the benefit.
- A linter that enforces the cross-pack consistency greps in CI. Same threshold reasoning.
- Auto-generated docs. Each PACK.md is hand-written; the tradeoff is currently on the side of intent over uniformity.
