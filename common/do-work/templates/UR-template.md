# UR input.md Template

Copy this to `do-work/user-requests/UR-NNN/input.md` when manually seeding a User Request. The do action normally creates this automatically; use this template only when seeding by hand.

The **Full Verbatim Input** section is the source of truth for every downstream verify action. Never summarise it. Paste the user's exact words.

---

## Simple shape

```markdown
---
id: UR-NNN
title: Short descriptive title
created_at: 2026-04-24T10:00:00Z
requests: [REQ-NNN]
word_count: <int>
---

# Short descriptive title

## Full Verbatim Input

[The exact, unedited input from the user]

---
*Captured: 2026-04-24T10:00:00Z*
```

---

## Complex shape (multi-REQ UR)

```markdown
---
id: UR-NNN
title: Descriptive title for the batch
created_at: 2026-04-24T10:00:00Z
requests: [REQ-NNN, REQ-NNN, REQ-NNN]
word_count: <int>
---

# Descriptive title for the batch

## Summary
[2-3 sentence overview of what this user request covers]

## Extracted Requests

| ID      | Title                      | Summary                                       |
| ------- | -------------------------- | --------------------------------------------- |
| REQ-NNN | [title]                    | [one line]                                    |
| REQ-NNN | [title]                    | [one line]                                    |

## Batch Constraints
[Cross-cutting concerns that apply to all REQs in this batch. Omit this section for single-REQ URs.]

- Shared design principles or sequencing
- Performance or quality budgets
- User tone signals: "keep it simple", scope cues, latitude given

## Full Verbatim Input

[THE COMPLETE, UNEDITED INPUT FROM THE USER]

[Paste the entire input exactly as received. Do not summarise, edit, or clean up. This is the source of truth for verify-request.]

---
*Captured: 2026-04-24T10:00:00Z*
```

---

## Frontmatter fields

| Field          | Required | Description                                                |
| -------------- | -------- | ---------------------------------------------------------- |
| `id`           | Yes      | `UR-NNN` - monotonic, never reused                         |
| `title`        | Yes      | Descriptive title for the request or batch                 |
| `created_at`   | Yes      | ISO 8601 timestamp                                         |
| `requests`     | Yes      | Array of REQ IDs extracted from this UR                    |
| `word_count`   | Yes      | Word count of the verbatim input, for reference            |

## Assets

Any screenshots or attachments supplied with the input go in `do-work/user-requests/UR-NNN/assets/`, named `REQ-NNN-<descriptor>.<ext>`.

## Lifecycle reminder

While any child REQ is pending or in-progress, the UR stays in `do-work/user-requests/`. Cleanup moves it to `do-work/archive/UR-NNN/` once every child REQ reaches `done`. Do not move UR folders manually.
