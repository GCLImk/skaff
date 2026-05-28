# GEMINI.md

This project uses the skaff scaffold to install shared workflows, conventions, and specialist prompts into the repository. Use this file as the default behavioral contract for Gemini CLI work.

## 1. Think Before Coding

- State assumptions before implementation.
- Surface ambiguity and tradeoffs instead of guessing.
- If multiple interpretations exist, present them and ask.
- If a simpler path exists, say so.
- Stop when a blocking detail is unclear.

## 2. Simplicity First

- Write the minimum code that solves the requested problem.
- Do not add speculative features, abstractions, or configurability.
- Avoid complexity that is not required by the task.
- If the solution feels too large, reduce it.

## 3. Surgical Changes

- Touch only the files and lines needed for the request.
- Match the existing style and patterns of the repository.
- Do not refactor unrelated code.
- Clean up imports, variables, and helpers made obsolete by your own change.
- Leave unrelated dead code alone unless asked.

## 4. Goal-Driven Execution

Plan before coding and define how each step will be verified.

```text
1. [Step] -> verify: [check]
2. [Step] -> verify: [check]
3. [Step] -> verify: [check]
```

Keep working until the success criteria are actually verified.

## 5. House Rules

- No em dashes anywhere. Use " - " instead.
- Use AskUserQuestion for blocking ambiguity, or the equivalent question mechanism in the current tool.
- Write task summaries to `do-work/summaries/` when work is complete.
- Use Conventional Commits for commit messages: `type(scope): description`.

## 6. Conventions

Read convention files in `.claude/conventions/` before the work that needs them. Gemini CLI can import them directly with `@./path/to/file.md`, for example `@./.claude/conventions/commit-style.md`.

Key files:

- `<lang>-style.md`
- `markdown-style.md`
- `commit-style.md`
- `do-work-protocol.md`
- `coverage-protocol.md`
- `ratchet-protocol.md`
- `external-validation.md`

Conventions are cumulative. A task that edits source, updates markdown, and prepares a commit should load all relevant files.

## 7. Sub-Agent Skills

Specialist skills live under `.gemini/skills/`. The CLI activates them when the task matches.

Key skills:

- `<pack>-implement`
- `<pack>-scout`
- `reviewer`
- `git-workflow`

Use the matching skill before doing work that clearly fits its specialty.

## 8. do-work Workflow

The standard queue is:

1. capture - record or clarify the request
2. scout - gather context and constraints
3. plan - define steps and verification
4. implement - make the smallest correct change
5. review - inspect the result for defects and gaps
6. ratchet - improve the requirement or quality bar when warranted
7. git - summarize and prepare the final commit flow

When touching the queue itself, read `.claude/conventions/do-work-protocol.md` first.
