# Persona snippets for workflow Gems

Workflows reference Gems by name (`review`, `refactor`, `docs`, ...). Each Gem in Gemini needs a system prompt that lets it drive the gcli tool surface AND constrains it to a specific role. This directory holds the **role-specific layer**; the **base layer** is `gem-instructions.md` at the repo root.

## Recipe: authoring a workflow Gem

Given an empty Gem in Gemini's Gem builder, the one-time bootstrap is:

1. **Create the Gem** — open Gemini's Gem builder, give it a name, click Save. Copy the URL from the address bar (`https://gemini.google.com/gem/<id>`).
2. **Wire it into `.gcli/settings.json`** — add a `{url, persona}` entry under `gems`:
   ```json
   "gems": {
     "review": { "url": "https://gemini.google.com/gem/<id>", "persona": "review" }
   }
   ```
3. **`/gem-sync review`** — the CLI navigates to the Gem's edit page, reads the live system prompt, shows you the diff, and (on `y`) pushes `gem-instructions.md` + `personas/review.md`. The hash is recorded in `.gcli/gem-sync-state.json`.

Total system prompt lands around 1.0-1.2k tokens (base ~832t + persona 200-300t). Well under the 2k advisory limit.

## When `gem-instructions.md` or a persona changes

Run `/gem-status` to see which Gems are out of sync. `/gem-sync <name>` updates one; `/gem-sync-all` walks every persona-bearing Gem in the config. Each push diffs first and asks for confirmation, so a Gem you've edited by hand in the UI won't be silently overwritten.

If a Gem's URL is in `gems` as a bare string (no persona key) it's not eligible for `/gem-sync` — it's tracked just for `/gem` swaps and skipped by `/gem-sync-all`.

### Manual paste fallback

`/gem-sync` is the primary path. If the bridge or the Gem builder UI changes shape and `/gem-sync` breaks, the original recipe still works:

1. Open the Gem in Gemini's Gem builder.
2. Paste the entire contents of `gem-instructions.md` into the system-prompt field.
3. Append a horizontal rule (`---`) and paste `personas/<name>.md`.
4. Click Save.

This is what `/gem-sync` automates; falling back to it costs ~30s per Gem.

## What lives in each layer

| Layer | What goes here | Why |
|---|---|---|
| `gem-instructions.md` (base) | Tool format, content_b64 rules, stop-after-tool-call, untrusted_content treatment, AVAILABLE TOOLS, succinctness budgets | Same for every Gem; without it, the Gem can't drive gcli at all |
| `personas/<name>.md` (per-Gem) | Tone, posture, hard tool restrictions ("never write_file"), output discipline ("structured JSON when asked") | Differentiates `review` from `refactor`; enforced at system-prompt level |
| Workflow step `prompt:` (per-step) | The specific task ("Critique this plan", "Implement these changes") plus task-shaped substitutions like `${{ steps.investigate.output.plan }}` | Per-task; should NOT carry tone or tool guidance — that's the persona's job |

## Authoring your own personas

Three guidelines borrowed from prompt-engineering research:

1. **Explicit word counts beat qualitative directives.** "≤100 words final summary" outperforms "be concise" by ~1.2% output tokens.
2. **Forbidden-patterns list at the end.** Naming the failure modes ("don't do X") catches common drift faster than positive directives alone.
3. **Output discipline section** with structured-output rules. Tells the model exactly how to format when called from a workflow with `output_schema`.

The three shipped personas (`review.md`, `refactor.md`, `docs.md`) follow this template — copy one and replace the role-specific bits.

## Workflow-shape guidance

The shipped workflow `examples/plan-then-implement.yaml` references three Gems:

- `review` — used by `investigate` (in plan_mode, `output_schema` requires structured plan) and `critique` (`output_schema` requires `{approved, concerns}`)
- `gemcli` — the default conversational Gem; used by `implement` with full write access via per-step `allowed_tools`
- (and any others your workflows reference)

A `refactor` Gem is the natural extension: spin up a workflow that's `review.investigate` → `review.critique` → `refactor.implement`, where the implementer has tighter tool restrictions (`edit_file`, `apply_patch`, no `write_file` for full rewrites). Same shape; different persona on the implementer.
