# External Validation

Adversarial review prompt snippet. Used by the `ratchet` agent when dispatching `reviewer` as an independent second pass at composite >= 0.85. The purpose is to surface defects the implementing agent might miss because it is biased toward its own output.

## When This Fires

Only the `ratchet` agent dispatches external validation, and only when:

- Baseline composite (pre-change) >= `external_validation_after_composite` (default 0.85, configurable in `ratchet.conf`).
- OR the scope_hint is `focused` at composite >= 0.85 (the focused track still requires external validation).

A normal review pass (`reviewer` invoked by the main session at step 8) uses the reviewer's default brief. This file only applies to the **second, ratchet-triggered pass**.

## Brief Contents - What to Include

- The full unified diff (`git diff HEAD`) of the change under review.
- The REQ file contents, with `## Verification` and `## Plan Verification` sections.
- The dimension definitions from `.claude/conventions/ratchet-protocol.md` (so the external reviewer knows what quality means on this project).
- This external-validation prompt snippet, prepended to the dispatch brief.

## Brief Contents - What to Exclude

- The new scoreset from the current run. The external reviewer must not know the numbers.
- The implementing agent's self-assessment, commit messages, or any text from the implementer's summary.
- The first reviewer pass's verdict. The external reviewer is independent of the first reviewer.
- The ratchet's own dimension calculations.

## The Prompt Snippet

Prepend this verbatim to the dispatch brief:

```text
You are the external validator. Your job is adversarial review of a change
that a first reviewer already approved and an automated ratchet is about to
accept. Your job is to disagree when disagreement is warranted.

Approach this review with the following priors:

- The first reviewer was not wrong on purpose, but may have missed subtle
  issues. Your job is to catch what they missed.
- The implementing agent has a bias toward its own output. You do not.
- A change that "looks clean" is not automatically sound. Look for what is
  absent - missing tests, missing error handling, missing edge cases - not
  only what is present.
- Prefer specific, actionable critique over general impressions.
- If you find nothing, say so. A clean bill is a valid output. Do not
  manufacture concerns.

Do not consider:

- Coverage metrics or scores. You do not have them. Your verdict is based on
  reading the diff and the REQ.
- Whether the first reviewer was "right" to approve. Your verdict is
  independent.

Evaluate on these axes:

1. Correctness - does the change do what the REQ asked? Are there cases it
   handles incorrectly?
2. Regression risk - could this change break existing behaviour outside the
   changed files? Think about what consumers of changed symbols expect.
3. Test sufficiency - are the tests actually exercising the change, or are
   they cosmetic? Would the tests fail if the implementation were subtly
   wrong?
4. Hidden coupling - does the change reach into modules it should not, or
   create new coupling that complicates future changes?
5. Documentation accuracy - do the XML docs and comments accurately describe
   the new behaviour, or are they stale?

Return one of:

- Verdict: Pass - no blocking concerns. Include one or two sentences naming
  what you looked at most carefully and found clean.
- Verdict: Fail - blocking concerns exist. List each concern with file,
  symbol, specific issue, and the adversarial test case that would reveal
  the issue if the implementation is wrong.
```

## Why This Works

Two reasons this prompt differs from the default reviewer:

1. **Opposing priors.** The default reviewer is neutral. This prompt primes for doubt. Correlated-failure research (see arXiv 2603.25773) shows same-distribution reviewers share failure modes unless the priors differ.
2. **Narrow focus.** The default reviewer considers the whole REQ. This prompt asks for adversarial critique on five specific axes, which disincentivises hand-waving verdicts.

An external validator that always finds problems is broken. An external validator that never finds problems is broken. A working external validator finds problems on roughly 10-30% of changes at composite >= 0.85 when those changes are landed by the same agent family. If your external validator's rejection rate is outside this band after 30+ runs, review the prompt.

## What Not To Do

- Do not chain an external validation onto an external validation. The second reviewer is final. If it fails, the change loops back to `nextjs-implement`, not to a third reviewer.
- Do not let the external reviewer see the scores. That defeats the purpose.
- Do not treat `Verdict: Pass` as permission to skip the graduated kept bar. The bar still applies; external validation is an additional gate, not a replacement.
