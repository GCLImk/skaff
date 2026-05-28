# Coverage Protocol

Shared enumeration-and-mapping protocol used by every verify action in the do-work skill. Currently used by `verify-request` (input -> REQs) and `verify-plan` (REQ -> plan).

> **Note:** This protocol is skill-owned. Agents do not execute it. Agents read this file so they understand the verification output they will encounter in REQ files.

> **Go pack note:** Verification and ratchet coverage for this pack use `go test -cover ./...`. The default coverage threshold in `ratchet.conf.template` is `0.70`.

## The Six Steps

1. **Enumerate** - Parse the source document into a numbered list of discrete, verifiable items. Each item is one requirement, constraint, behaviour, or detail that can be independently checked.
2. **Map** - For each source item, search the target document(s) for coverage. Classify each as Full, Partial, or Missing.
3. **Calculate** - Apply the coverage formula (below). Round to the nearest integer. This is the pre-fix score.
4. **Fix** - For missing and partial items, edit the target document to include them. Do not invent requirements. Add only what the source explicitly contains.
5. **Recalculate** - After fixes, recalculate coverage. Should be at or near 100%.
6. **Store** - Append a verification section to the target document with the coverage map, metrics, and list of fixes applied.

## Coverage Formula

```text
Coverage % = (full + 0.5 * partial) / total * 100
```

## Classification

| Status  | Definition                                                         |
| ------- | ------------------------------------------------------------------ |
| Full    | The item appears in the target with sufficient detail.             |
| Partial | The item is mentioned but missing detail, specificity, or context. |
| Missing | The item does not appear in the target at all.                     |

## Enumeration Guidelines

- One item per line, numbered sequentially.
- Each item must be independently checkable against the target.
- Do not merge related items. If the user said two things, that is two items.
- Do not split single concepts into sub-items. If "OAuth with Google and GitHub" is one thought, it is one item.
- Quote source words where possible for traceability.
- Include passing mentions. If the user said it, it counts.
- Include constraints and non-functional requirements. These are the items most often missed.
- Include scope cues ("keep it simple", "just ideas"). The target should reflect these.

## Scoring Bands (pre-fix)

| Score     | Meaning                                                |
| --------- | ------------------------------------------------------ |
| 90-100%   | Excellent capture. Minimal fixes needed.               |
| 75-89%    | Good capture. Some details dropped, auto-fixed.        |
| 50-74%    | Significant gaps. Important requirements were missing. |
| Below 50% | Major gaps. Target needed substantial additions.       |

## Auto-Fix Rules

- **Fix directly.** Do not ask the user for permission. The coverage map documents exactly what changed.
- **Stay within source scope.** Only add what the source explicitly contains.
- **Keep additions proportional.** Do not turn a 5-step plan into a 20-step plan for a minor constraint.
- **Match existing detail level.** If the target is concise, fixes are concise.
- **Do not restructure the target.** Keep its existing organisation. Fill gaps in place.

## Verification Section Schema

Every verify action appends a verification section to the target. The heading differs by action:

| Action         | Section heading        | Appended to                |
| -------------- | ---------------------- | -------------------------- |
| verify-request | `## Verification`      | REQ file                   |
| verify-plan    | `## Plan Verification` | REQ file (after `## Plan`) |

### Required fields

```markdown
## Verification

**Source**: <source document reference>
**Pre-fix coverage**: <N>% (<full> full, <partial> partial, <missing> missing)
**Post-fix coverage**: <N>% (<covered>/<total> items)

### Coverage Map

| # | Item | Target Section | Status |
|---|------|---------------|--------|
| 1 | ...  | ...           | Full |
| 2 | ...  | ...           | Partial -> Fixed |
| 3 | ...  | --            | Missing -> Fixed |

### Fixes Applied

- <concrete edit description>
- <concrete edit description>

*Verified by <action-name> action*
```

## Missing Verification Section

If an agent reads a REQ file that lacks a `## Verification` section, the do action's Step 5.5 was skipped. Flag this rather than proceeding. The same applies to `## Plan Verification` after a plan is present.

## What NOT To Do

- Do not add requirements that are not in the source.
- Do not restructure the target. Fix gaps in place.
- Do not replace the target. Edit it.
- Do not skip verification because the target "looks complete".
- Do not turn a focused target into an over-engineered one.
- Do not ask "want me to apply these fixes?". The protocol is non-interactive.
