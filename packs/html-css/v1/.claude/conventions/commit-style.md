# Commit Conventions

All agents read this file before committing. Format is Conventional Commits.

## Format

```text
type(scope): description

[optional body]

[optional footer]
```

## Types

- `feat` - new feature
- `fix` - bug fix
- `docs` - documentation only
- `style` - formatting, whitespace, missing semicolons (no logic change)
- `refactor` - code change that neither fixes a bug nor adds a feature
- `test` - adding or correcting tests
- `chore` - tooling, dependencies, build scripts
- `build` - build system or external dependency changes
- `ci` - CI config and scripts
- `perf` - performance improvement

## Scope

Optional. Lowercase kebab-case. Matches a project, module, or feature area.

Examples: `feat(auth)`, `fix(orders-api)`, `docs(readme)`, `chore(deps)`.

Use `*` for multi-scope changes sparingly. Prefer splitting into separate commits.

## Subject Rules

- Under 72 characters.
- Imperative mood: "add", "fix", "remove" - not "added", "fixes", "removing".
- Lowercase first letter unless it's a proper noun.
- No trailing period.
- No em dashes. Use " - " instead.

## Body

- Wrap at 72 columns.
- Explain what and why, not how.
- Separate from subject with a blank line.

## Footer

- `BREAKING CHANGE: <description>` for breaking changes. Also add `!` after type: `feat(api)!: ...`.
- `Refs: #123` or `Closes: #123` to link issues.
- `Co-authored-by: Name <email>` for co-authorship.

## Examples

```text
feat(auth): add OAuth refresh token flow
```

```text
fix(orders-api): handle null shipping address on draft orders

Draft orders previously threw NullReferenceException when the
shipping address was unset. Return a 422 with a validation
error instead.

Closes: #412
```

```text
refactor(domain)!: split Order aggregate into Order and OrderLine

BREAKING CHANGE: Order.Lines is now a navigation to OrderLine
rather than an owned collection. Callers that materialise lines
via projection must update their queries.
```
