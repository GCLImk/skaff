# do-work Protocol

Shared reference for every agent that reads, writes, or moves files under `do-work/`. Models the `bladnman/do-work` skill. Agents must defer to the skill's own action docs for anything not covered here.

## Directory Layout

```text
do-work/
├── REQ-NNN-pending.md              queue - pending requests
├── user-requests/
│   └── UR-NNN/
│       ├── input.md                verbatim user input - source of truth
│       └── assets/                 screenshots and attachments
│           └── REQ-NNN-name.png
├── working/                        in-flight - managed by the work action only
│   └── REQ-NNN-in-progress.md
├── scout/                          appsheet-scout findings briefs
│   └── REQ-NNN-<topic>-findings.md
├── ratchet/                        quality baselines - append-only
│   └── baselines.jsonl
├── summaries/                      loop, audit, and implementation summaries
└── archive/                        completed work - immutable
    ├── UR-NNN/                     self-contained completed unit
    │   ├── input.md
    │   └── REQ-NNN-done.md
    ├── abandoned/                  REQs split or abandoned via escalation
    │   └── REQ-NNN-abandoned.md
    └── legacy/                     REQs created before the UR system
        └── REQ-NNN-done.md
```

## Identifiers

- `UR-NNN` - User Request folder. One created per `do work <prompt>` invocation. Preserves the raw prompt verbatim.
- `REQ-NNN` - Request file. One or more per UR. Monotonic across the whole queue, never per-UR.
- `NNN` - zero-padded three-digit integer. Increment across the project. Never reuse.
- UR and REQ numbering are independent sequences. Check `do-work/`, `do-work/working/`, `do-work/archive/` (including `archive/UR-*/`) for the highest existing REQ. Check `do-work/user-requests/` and `do-work/archive/UR-*/` for the highest existing UR.

## REQ States

| State         | Filename suffix       | Location            | Who moves it     |
| ------------- | --------------------- | ------------------- | ---------------- |
| Pending       | `-pending.md`         | `do-work/`          | do action        |
| In progress   | `-in-progress.md`     | `do-work/working/`  | orchestrator     |
| Done          | `-done.md`            | `do-work/archive/`  | orchestrator     |

State transitions are `mv` operations. Only the orchestrator changes state once processing begins.

## Write Permissions by Action

| Location                     | do action | work / orchestrator | Any other agent           |
| ---------------------------- | --------- | ------------------- | ------------------------- |
| `do-work/` (root, REQ files) | Yes       | Read only           | Read only                 |
| `do-work/.lock`              | No        | Yes (acquire/release) | Read only               |
| `do-work/user-requests/`     | Yes       | Read only (moves)   | Read only                 |
| `do-work/working/`           | No        | Yes                 | Per agent path rules      |
| `do-work/archive/`           | No        | Yes                 | Read only                 |
| `do-work/scout/`             | No        | No                  | appsheet-scout only         |
| `do-work/ratchet/`           | No        | Read only           | ratchet only (append-only)|
| `do-work/summaries/`         | No        | Yes                 | Any agent may append      |

## Immutability Rule

Files in `do-work/working/` and `do-work/archive/` are **immutable** to every agent except the orchestrator that owns the transition. No appends, no edits, no "one more thing" patches.

To modify an in-flight or archived REQ: create a new addendum REQ in the queue that references the original via `addendum_to: REQ-NNN` frontmatter.

## Queue Lock

Only one orchestrator may run the queue at a time. Concurrent `do work run` invocations against the same repo corrupt state - two orchestrators both claim the same REQ, both append scoresets to `baselines.jsonl`, and one produces git output against a stale base.

### Lock file

Lock is a file at `do-work/.lock` containing a single JSON object:

```json
{"pid": 12345, "started_at": "2026-04-24T10:30:00Z", "host": "marc-laptop"}
```

JSON is chosen so agents parse the file deterministically. A malformed lock file is treated as stale.

### Acquire semantics

On `do work run`:

1. If `do-work/.lock` does not exist: create it with current PID, start time, and host.
2. If `do-work/.lock` exists and `started_at` is less than **2 hours** old: refuse to start. Print:
   ```text
   Queue locked by PID <pid> on <host> since <started_at>.
   If that process has died, clear the lock with: do work unlock
   ```
3. If `do-work/.lock` exists and `started_at` is 2 hours or older: treat as stale, overwrite with current values, proceed with a warning logged to `do-work/summaries/stale-lock-cleared-<date>.md`.

### Release semantics

Orchestrator removes `do-work/.lock` on clean exit (queue drained, escalation paused, or explicit abort). If the process dies uncleanly, the 2-hour staleness threshold eventually releases the lock.

### Manual escape hatch

Remove the lock file manually when a prior process died and the 2-hour staleness threshold has not yet passed:

```bash
rm do-work/.lock
```

If the do-work skill adds an `unlock` command in future, prefer it because it can print the stale lock contents for audit before removal.

### Scope

The lock lives at `do-work/.lock` (not `/tmp`), which means git worktrees that share a `do-work/` directory also share the lock. This is correct: the queue is a shared resource, not per-worktree. Two worktrees both trying to drain the same queue would otherwise both claim the same REQ.

## REQ Frontmatter

Required on every REQ file the do action creates:

| Field          | Required | Description                                        |
| -------------- | -------- | -------------------------------------------------- |
| `id`           | Yes      | `REQ-NNN`                                          |
| `title`        | Yes      | Short title                                        |
| `status`       | Yes      | `pending` when created                             |
| `created_at`   | Yes      | ISO 8601 timestamp                                 |
| `user_request` | Yes      | `UR-NNN` - the originating UR folder               |

Optional on complex REQs:

| Field          | Description                                                       |
| -------------- | ----------------------------------------------------------------- |
| `related`      | Array of sibling REQ IDs                                          |
| `batch`        | Shared batch name across related REQs                             |
| `addendum_to`  | REQ ID this request amends (used when original is in working/archive) |
| `complexity`   | `simple` \| `medium` \| `complex`. If present, the orchestrator uses this value directly and skips its own triage pass. Absent means the orchestrator triages from the REQ body. |

The orchestrator appends `claimed_at`, `route`, and `completed_at` during processing. Do not pre-populate these.

## UR `input.md` Frontmatter

| Field          | Required | Description                                        |
| -------------- | -------- | -------------------------------------------------- |
| `id`           | Yes      | `UR-NNN`                                           |
| `title`        | Yes      | Descriptive title for the request or batch         |
| `created_at`   | Yes      | ISO 8601 timestamp                                 |
| `requests`     | Yes      | Array of REQ IDs extracted from this UR            |
| `word_count`   | Yes      | Word count of the verbatim input                   |

## UR Lifecycle

1. `do work <prompt>` creates `user-requests/UR-NNN/input.md` with the full verbatim prompt and one or more `REQ-NNN-pending.md` files in the queue root. Every REQ links back via `user_request: UR-NNN`.
2. REQs process individually through the queue. The UR folder stays in `do-work/user-requests/` while any child REQ is pending or in-progress.
3. When every child REQ of a UR reaches `done`, cleanup moves the UR folder to `archive/UR-NNN/` and relocates the done REQ files inside it.
4. Legacy REQs without a `user_request` field archive to `archive/legacy/` directly.

## Invocation Modes

| Command              | Routes to       | Behaviour                                                                 |
| -------------------- | --------------- | ------------------------------------------------------------------------- |
| `do work <prompt>`   | do action       | Capture. Create UR and one or more pending REQs. No processing.           |
| `do work run`        | work action     | Start orchestrator loop. Drain the queue.                                 |
| `do work go`         | work action     | Alias of `run`.                                                           |
| `do work start`      | work action     | Alias of `run`.                                                           |
| `do work verify`     | verify-request  | Evaluate capture quality against UR inputs. Auto-fix REQs.                |
| `do work check`      | verify-request  | Alias of `verify`.                                                        |
| `do work evaluate`   | verify-request  | Alias of `verify`.                                                        |
| `do work cleanup`    | cleanup         | Consolidate archive, close completed UR folders, fix misplaced files.     |
| `do work tidy`       | cleanup         | Alias of `cleanup`.                                                       |
| `do work consolidate`| cleanup         | Alias of `cleanup`.                                                       |

Additional verify actions run automatically, not via invocation:

- **verify-request** runs automatically after the do action creates REQ files.
- **verify-plan** runs automatically after the work action's planning phase on every route.
- **cleanup** runs automatically at the end of every work loop.

All three are skippable only when the user explicitly says "skip verification" in the originating request.

## Plan Location

The plan lives inline in the REQ file under a `## Plan` section. There is no separate `plan.md` file. `verify-plan` runs after the plan is written and appends `## Plan Verification` immediately after `## Plan`. Reviewer and builder agents read the plan from the REQ file.

## Verification Sections

Two verify actions append coverage metadata to REQ files. See `.claude/conventions/coverage-protocol.md` for the shared protocol.

| Section heading        | Written by      | When                                          | Location in REQ          |
| ---------------------- | --------------- | --------------------------------------------- | ------------------------ |
| `## Verification`      | verify-request  | Automatically after the do action             | End of REQ file          |
| `## Plan Verification` | verify-plan     | Automatically after the planning phase        | Immediately after `## Plan` |

If an agent reads a REQ file that lacks `## Verification`, the do action's Step 5.5 was skipped. Flag it rather than proceeding. Same rule for `## Plan Verification` once a plan is present.

Verify actions auto-fix the target non-interactively. Agents reading a REQ may assume these sections are trustworthy extractions.

## Cleanup Behaviour

Cleanup runs automatically at the end of every work loop and can be invoked manually via `do work cleanup`. It does the following:

1. Moves UR folders out of `do-work/user-requests/` into `do-work/archive/UR-NNN/` when every child REQ is `done`.
2. Relocates loose `REQ-*-done.md` files at `do-work/archive/` root into their UR folder.
3. Moves legacy REQs (no `user_request` field) into `do-work/archive/legacy/`.
4. Fixes misplaced folders - e.g. `archive/user-requests/UR-NNN` moves to `archive/UR-NNN`.

Agents never perform these operations themselves. The orchestrator triggers cleanup as the final loop step; all other agents leave the archive untouched.

## Skill Action Boundaries

The do-work skill owns certain edits. Agents must not duplicate or overwrite these edits. Keeping the boundary clear prevents race conditions between skill-owned and agent-owned writes.

| Responsibility                                         | Owner                  |
| ------------------------------------------------------ | ---------------------- |
| Creating UR folders and `input.md` files               | do action              |
| Creating initial `REQ-*-pending.md` files              | do action              |
| Appending `## Verification` to REQ files               | verify-request action  |
| Writing the `## Plan` section into the REQ file        | appsheet-implement (plan-only mode) |
| Writing the `## Plan Hash` section into the REQ file   | appsheet-implement agent |
| Appending `## Plan Verification` to REQ files          | verify-plan action     |
| Moving REQs through `pending -> in-progress -> done`   | orchestrator agent     |
| Writing `## Override` section on escalation overrides  | orchestrator agent     |
| Writing `## Loop Counters` section to track cycles     | orchestrator agent     |
| Moving UR folders to `archive/UR-NNN/`                 | cleanup action         |
| Writing code under `apps-script/` and specs under `docs/sheets/` or `docs/appsheet/` | appsheet-implement agent |
| JSDoc and markdown edits                               | appsheet-doc-writer agent|
| Scout findings under `do-work/scout/`                  | appsheet-scout agent     |
| Git operations, commits, PRs                           | git-workflow agent     |
| Verdict and review summary                             | reviewer agent         |
| Appending `## Ratchet` section to REQ files            | ratchet agent          |
| Appending scoresets to `do-work/ratchet/baselines.jsonl` | ratchet agent        |

**Rules:**

- Agents must not edit `## Verification` or `## Plan Verification` sections. These are skill-owned.
- Agents must not edit the `## Plan Hash` section. It is owned by appsheet-implement and is the drift-detection anchor.
- Agents must not edit the `## Ratchet` section. It is owned by the ratchet agent.
- `do-work/ratchet/baselines.jsonl` is append-only. No agent rewrites it.
- Agents must not rewrite the UR `input.md`. It is the source of truth.
- Agents must not move REQ files between states except the orchestrator.
- Agents must not move UR folders between directories except via cleanup.

## Dispatch Brief Budget

Sub-agents run in isolated context windows. That separation is the point. But dispatch briefs that include too much verbatim content defeat the purpose - the isolated context fills up with orchestrator-injected material before the sub-agent does any work. Long briefs also starve the sub-agent of headroom for its own reasoning and tool output.

### The budget

**2000 tokens** of verbatim content per dispatch brief, measured as approximate word count (1 token ~= 0.75 words, so roughly 1500 words).

### Over-budget behaviour

When the material a sub-agent needs exceeds 2000 tokens:

- Include **file paths** instead of file contents.
- Include a **two-sentence summary** of what the sub-agent will find at each path.
- The sub-agent re-reads the file from disk inside its own context window.

Always include file paths even when content fits under the budget, so the sub-agent can re-read on demand rather than operating on stale brief content.

### Why this matters

A Complex REQ with long UR input, dense scout findings, a detailed plan, and three rejected implementation attempts can exceed 8000 tokens of relevant material. Pasting all of it into every dispatch brief burns the sub-agent's context before it starts work. Passing paths and letting the sub-agent read lazily is the whole reason subagents exist.

### What counts against the budget

- REQ file body (excluding machine-generated sections like `## Loop Counters`)
- Scout findings brief body
- Reviewer blocking issues list
- Ratchet Blocking Dimensions list
- Plan Delta note body (from verify-plan drift check)

### What does not count

- File paths themselves (tokens are cheap; references are free to include)
- The sub-agent's own system prompt (the agent definition file)
- Tool-call output the sub-agent generates during its run

## Addendum Workflow

A new request amending an existing one is a fresh REQ file, not an edit:

1. Assign the next REQ number.
2. Set `addendum_to: REQ-NNN` in frontmatter (the original's ID).
3. Link the same UR as the original if it came from the same invocation, or a new UR if captured separately.
4. The orchestrator treats it as a standard queue item. The builder reconciles original and addendum at planning time.

## Backward Compatibility

- REQs without `user_request` are legacy. Archive to `archive/legacy/`.
- REQs with `context_ref` pointing to `assets/CONTEXT-*.md` are legacy. Archive the CONTEXT file alongside the REQ.
- Assets in `do-work/assets/` (pre-UR system) stay in place. New assets go into `user-requests/UR-NNN/assets/`.
