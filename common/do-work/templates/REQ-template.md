# REQ Template

Copy this to `do-work/REQ-NNN-<slug>-pending.md` when creating a new request. The do action normally produces REQ files automatically; use this template only when manually seeding the queue.

Use the **Simple** shape for short, single-feature captures. Use the **Complex** shape for detailed, multi-feature, or nuanced requests.

Both shapes end with a `## Verification` section appended by the verify-request action. When planning begins, the orchestrator adds `## Plan` and verify-plan appends `## Plan Verification`.

---

## Simple shape

```markdown
---
id: REQ-NNN
title: Brief descriptive title
status: pending
created_at: 2026-04-24T10:00:00Z
user_request: UR-NNN
---

# [Brief Title]

## What
[1-3 sentences describing what is being requested]

## Why
[User's stated reasoning - ONLY if they gave one. Omit section if not provided]

## Context
[Any additional context, constraints, or details the user mentioned]

## Assets
[Descriptions of screenshots or references. Files live in do-work/user-requests/UR-NNN/assets/]

---
*Source: [original verbatim request]*
```

---

## Complex shape

```markdown
---
id: REQ-NNN
title: Descriptive title
status: pending
created_at: 2026-04-24T10:00:00Z
user_request: UR-NNN
related: [REQ-NNN, REQ-NNN]   # optional
batch: <batch-name>           # optional
complexity: medium            # optional - pre-populates orchestrator triage
---

# [Title]

## What
[Concise statement of the feature or change]

## Detailed Requirements
[Extract ALL requirements from the original input that apply to THIS REQ. Do not summarise. Preserve the user's exact requirements, including specifics and values.]

- Requirement one
- Requirement two
- Requirement three

## Constraints
[Limitations, restrictions, or conditions mentioned by the user]

- Constraint one
- Constraint two

## Dependencies
[What this REQ needs and what needs it]

- Depends on: REQ-NNN - reason
- Blocks: REQ-NNN - reason

## Builder Guidance
[Capture tone and intent signals that affect HOW to build, not WHAT to build]

- Certainty level: Exploratory / Firm / Mixed
- Scope cues: [any "keep it simple", "don't over-build", "just ideas" signals]
- Latitude: [any explicit latitude given to the builder]

## Open Questions
[Ambiguities for the builder to clarify or decide]

- Question one
- Question two

## Full Context
See [user-requests/UR-NNN/input.md](./user-requests/UR-NNN/input.md) for complete verbatim input.

---
*Source: See UR-NNN/input.md for full verbatim input*
```

---

## Optional frontmatter fields

| Field          | When to include                                                         |
| -------------- | ----------------------------------------------------------------------- |
| `related`      | Sibling REQs from the same UR or logically linked elsewhere             |
| `batch`        | Shared batch label across a group of REQs                               |
| `addendum_to`  | When this REQ amends an original REQ already in `working/` or `archive/` |
| `complexity`   | `simple` \| `medium` \| `complex`. Pre-populates the orchestrator's triage |

The orchestrator appends runtime fields (`claimed_at`, `route`, `completed_at`) during processing. Do not pre-populate these.

## Sections added later

Do not write these sections manually. They are appended by agents or skill actions during processing:

- `## Verification` - by verify-request after the do action creates the REQ.
- `## Plan` - by csharp-implement in plan-only mode.
- `## Plan Hash` - by csharp-implement, SHA-256 of the plan body for drift detection.
- `## Plan Verification` - by verify-plan after `## Plan` is written.
- `## Loop Counters` - by the orchestrator on first rework cycle.
- `## Ratchet` - by the ratchet agent after scoring.
- `## Override` - by the orchestrator only when the user overrides ratchet via escalation.

See `.claude/conventions/coverage-protocol.md`, `ratchet-protocol.md`, and `do-work-protocol.md` for schemas.
