# AppSheet / Apps Script / Sheets Conventions

All agents read this file before writing or reviewing project artefacts. The ISWG-OS spans three surfaces - Apps Script, Google Sheets schemas, AppSheet config - each with different source-of-truth and handover models.

## Surface summary

| Surface              | Source of truth (in-repo)                                  | How changes reach production                                        |
| -------------------- | ---------------------------------------------------------- | ------------------------------------------------------------------- |
| Apps Script          | `apps-script/<project>/*.gs|*.js|*.ts`                     | Human operator runs `clasp push` at release time                    |
| Google Sheets schema | `docs/sheets/<sheet>.md` spec                              | Human operator applies schema changes in the Sheet UI from the spec |
| AppSheet config      | `docs/appsheet/<area>.md` spec (+ optional export JSON)    | Human operator applies changes in the AppSheet editor from the spec |

The spec doc is always the handover artefact. If an operator cannot apply the change from reading the spec, the spec is incomplete.

## Apps Script (GAS) style

### Project layout

```
apps-script/
  <project-name>/
    appsscript.json        # manifest (authored; committed)
    .claspignore           # what clasp push excludes
    src/
      triggers.gs          # all installable and simple triggers, one file
      clients/
        jira.gs            # thin client per integration
        gmail.gs
        chat.gs
      services/
        decision-log.gs    # one file per domain concept
      lib/
        time.gs            # shared utilities
    tests/
      decision-log.test.gs # GasT or bespoke harness, optional
```

`.clasp.json` is not committed (contains script IDs that differ per env). Use `.clasp.example.json` for the template.

### Naming

- Functions: `camelCase`. Entry-point triggers stay named as GAS expects (`onOpen`, `onEdit`, `onFormSubmit`, etc.).
- Constants: `SCREAMING_SNAKE_CASE` at module top.
- Private module helpers: prefix underscore (`_parseHeader_`) - AppSheet/V8 treats underscore-prefixed as internal.
- Files: `kebab-case.gs`.

### JSDoc

- Every exported function gets JSDoc with `@param`, `@return`, and `@throws` where applicable.
- Trigger entry points: add `@trigger <simple|installable|time-driven> <event>`.
- AppSheet-invoked endpoints (called from a bot's Call-a-script step): add `@invokedBy AppSheet bot "<bot name>"`.
- No placeholder text. If you cannot describe the purpose, you do not yet understand the function.

Example:

```javascript
/**
 * Ratifies a decision by moving its status from Draft to Ratified, timestamping,
 * and writing the approver to the decision log.
 *
 * @param {string} decisionId - row key in Decisions sheet
 * @param {string} approverEmail - Workspace email of the ratifier
 * @return {Object} updated row as { id, status, ratifiedAt, ratifiedBy }
 * @throws {Error} when the decision does not exist or is not in Draft status
 * @invokedBy AppSheet bot "Ratify decision"
 */
function ratifyDecision(decisionId, approverEmail) { ... }
```

### Structure within a file

1. File header comment (purpose, 1-3 lines)
2. Constants
3. Exported functions
4. Private helpers (underscore-prefixed)

### Error handling

- Throw `Error` with a human-readable message that includes the offending input (decision ID, sheet name, etc.) when safe. Never log raw PII.
- External calls: wrap `UrlFetchApp.fetch` with `muteHttpExceptions: true` and branch on `getResponseCode()`. Never let an unhandled non-2xx propagate to an AppSheet bot step - bots do not surface errors well.
- On failure in a trigger or bot-invoked function: write a row to the `AuditLog` sheet with `timestamp`, `function`, `input`, `error`. Triggers must not silently swallow.

### Secrets

- `PropertiesService.getScriptProperties()` only. Never hard-code tokens, webhook URLs, or JIRA credentials.
- Document every key in `docs/integrations/<system>.md` under a `Secrets` heading: key name, who provisions it, rotation cadence.

### Async / batching

- GAS is synchronous. Use `UrlFetchApp.fetchAll(requests)` for parallel HTTP. Guard against 6-minute execution limit on custom triggers by batching and checkpointing to a `State` sheet row.

### Lint and format

- ESLint with `eslint-config-googleappsscript` or equivalent. Config committed as `eslint.config.js` at project root.
- Prettier with default settings; config committed.
- Tabs vs spaces: 2-space indent.

## Sheets schema style

Each Google Sheet has one markdown spec under `docs/sheets/<sheet-name>.md`.

### Structure

```markdown
# Sheet: <Name>

**Purpose:** <one paragraph>
**Owner:** <role or person>
**AppSheet binding:** <yes/no; if yes, list tables>

## Tabs

### Tab: Decisions

| Name         | Type      | Ref           | Required | Formula                    | Notes                  |
| ------------ | --------- | ------------- | -------- | -------------------------- | ---------------------- |
| DecisionId   | Text      |               | yes      |                            | primary key, UUID      |
| Title        | Text      |               | yes      |                            |                        |
| Status       | Enum      |               | yes      |                            | Draft|Ratified|Rejected |
| RaisedBy     | Ref       | Members.Email | yes      |                            |                        |
| RatifiedAt   | DateTime  |               |          |                            | set on Ratify action   |
| LinkedJira   | Text      |               |          |                            | JIRA issue key         |

## Relationships

- `Actions.DecisionId -> Decisions.DecisionId`

## Migration notes

On changes to this spec, the operator applies:
1. <step>
2. <step>
```

### Rules

- Column names: `PascalCase`, singular.
- Every column has an explicit Type from AppSheet's type set (Text, LongText, Number, Decimal, Date, DateTime, Time, Enum, EnumList, Ref, Email, Phone, URL, Thumbnail, Image, File).
- Enum values are enumerated in Notes; no ambiguous free text.
- Ref columns point at `<SheetName>.<ColumnName>`.
- Every schema change includes a reversible migration note for the operator.

## AppSheet config style

Each functional area has one markdown spec under `docs/appsheet/<area>.md`. Areas: `tables.md`, `views.md`, `actions.md`, `bots.md`, `slices.md`, `security.md`.

### Structure (example: actions.md)

```markdown
# Actions

## Action: Ratify decision

**Applies to:** Decisions table
**Type:** Data: set the values of some columns in this row
**Only if this condition is true:** `AND([Status] = "Draft", IN(USEREMAIL(), Members[Email]))`
**Set these columns:**
- `[Status]` -> `"Ratified"`
- `[RatifiedAt]` -> `NOW()`
- `[RatifiedBy]` -> `USEREMAIL()`
**Appearance:** Prominently, button label "Ratify"
**Needs confirmation:** yes
**Confirmation message:** `"Ratify decision '" & [Title] & "'? This is auditable."`

### Operator checklist

1. Open AppSheet editor -> Behavior -> Actions -> + New Action
2. Name: `Ratify decision`
3. For a record of this table: `Decisions`
4. Do this: `Data: set the values of some columns in this row`
5. Paste each Set column expression verbatim
6. Paste the Only-if condition verbatim
7. Save

### Test walkthrough

1. Sign in as a Members-sheet user
2. Open a Decision in Draft status
3. Tap Ratify
4. Confirm the dialog
5. Verify Status = Ratified, RatifiedAt = now, RatifiedBy = current user
6. Verify AuditLog row appended
```

### Rules

- Expressions are pasted verbatim. AppSheet expression syntax is case-sensitive in column refs (`[Status]`, not `[status]`).
- Every config unit has an operator checklist and a test walkthrough. No exceptions.
- If an export JSON is committed under `docs/appsheet/_exports/`, reference the relevant `id` fields so future drift detection can diff spec vs export.

## Markdown / docs

- One `#` per file. `##` for sections. No heading skips.
- Fenced code blocks always carry a language tag.
- Tables for anything comparative.
- Admonitions as `> **Note:**` / `> **Warning:**` blockquotes.

## Commit style

Follows `.claude/conventions/commit-style.md`. Preferred scopes: `gas`, `sheets`, `appsheet`, `integrations`, `docs`, `tooling`.

## What to lint, what to check

| What                | Tool                         | Gate                                 |
| ------------------- | ---------------------------- | ------------------------------------ |
| GAS syntax          | `node --check <file>`        | Must pass on every modified file     |
| GAS lint            | `npx eslint <file>`          | Zero errors, warnings permitted      |
| GAS format          | `npx prettier --check <file>`| Must pass                            |
| Markdown            | (no enforced linter for v1)  | Reviewer checks heading hierarchy    |
| AppSheet expression | Manual reviewer pass         | Verbatim in spec; no substitution    |

`clasp push` is not an agent action. It is a human operator action at release time.
