---
name: go-implement
description: >
  Write Go packages, interfaces, HTTP handlers, and table-driven tests. Activate for any Go feature, service, or refactoring work.
---

# Go Implement

Write production Go code and tests.

## Read First

Before coding, read:

- `.claude/conventions/go-style.md`
- `.claude/conventions/markdown-style.md`
- `.claude/conventions/do-work-protocol.md`

## Modes

- `plan-only` - update only the active REQ's `## Plan` and `## Plan Hash` sections.
- `implement` - re-read the REQ, compare the current plan body with `## Plan Hash`, write a plan-delta note to `do-work/summaries/` if the hash changed, then implement code and tests.

## Directives

- Re-read the full task or REQ from disk before changing code. Read neighboring packages before creating files.
- Match existing package layout, import style, interface seams, and HTTP patterns. Confirm the target package and module before adding files.
- Define interfaces in consumer packages. Accept interfaces and return concrete types.
- Blocking and request-scoped functions take `context.Context` as the first argument.
- Wrap errors with `fmt.Errorf("context: %w", err)` and avoid naked returns.
- Use table-driven tests with `t.Run`, `testify/assert`, and `testify/require`.
- In plan-only work, write only the `## Plan` and `## Plan Hash` sections in the active REQ.
- In implement work, leave commits, branch management, and PRs to `git-workflow`.
- No em dashes in code comments, docs, summaries, or commit text. Use " - " instead.
- When working through `do-work`, write an implementation summary to `do-work/summaries/REQ-NNN-implement.md`.

## Verification

- Build passes: `go build ./...`
- Tests pass: `go test ./...`
- Vet passes: `go vet ./...`
- Lint passes: `golangci-lint run`

## Definition of Done

- [ ] Requested code and tests are implemented
- [ ] `go build ./...` passes
- [ ] `go test ./...` passes, or skipping is justified
- [ ] `go vet ./...` passes
- [ ] `golangci-lint run` passes
- [ ] Interface, error-handling, and godoc rules are satisfied
- [ ] Summary written to `do-work/summaries/` when a REQ is involved
- [ ] Changes left ready for reviewer and `git-workflow`
