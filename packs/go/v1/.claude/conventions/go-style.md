# Go Conventions

All agents read this file before writing or reviewing Go code.

## Toolchain Baseline

- Go 1.22 or newer.
- Modules only. `go.mod` is required. Commit `go.sum` when dependencies change.
- Standard library first. Add external dependencies only when they provide substantial value.
- Prefer `net/http` for HTTP services. Use `chi` or `gorilla/mux` only when the routing needs justify them.

## Package Layout

- Package names are lowercase single words.
- No underscores in package names.
- Keep packages cohesive and small. Split by responsibility, not by technical layer alone.
- Avoid import cycles. If a cycle appears, move the interface to the consumer package or extract a focused shared package.

## Interfaces

- Interfaces are defined by the consumer package, not the implementer.
- Accept interfaces, return concrete types.
- Do not introduce an interface for a single implementation unless a consumer needs the seam.

## Context Propagation

- Any blocking or request-scoped function accepts `context.Context` as its first argument.
- Do not store context on structs.
- Pass context through to database, network, filesystem, and outbound HTTP calls.

## Error Handling

- Always check errors.
- Wrap errors with `fmt.Errorf("context: %w", err)` when adding context.
- Return early on error paths.
- No naked returns. Named returns are allowed only when they improve documentation.

## State and Construction

- No global mutable state.
- Inject dependencies through constructors.
- `init()` is forbidden except in `main` packages where there is a clear startup reason.

## Naming and Declarations

- Exported types and functions require godoc comments that begin with the symbol name.
- Prefer small structs with explicit constructors over package-level singletons.
- Keep files readable: types near their methods, helpers near the code that uses them.

## Tests

- Use `go test`.
- Prefer table-driven tests with `t.Run`.
- Use `github.com/stretchr/testify/assert` and `github.com/stretchr/testify/require` for expressive assertions.
- Keep tests close to the package they exercise. Use `testdata/` for fixtures.
- Favor deterministic tests. No network access unless the task explicitly requires it.

## Coverage

- Measure coverage with `go test -cover ./...`.
- The default ratchet floor is 0.70 unless the project overrides it in `ratchet.conf`.
- Do not lower coverage thresholds without a stated reason.

## Lint and Verification

Canonical local and CI commands:

- `go build ./...`
- `go test ./...`
- `go vet ./...`
- `golangci-lint run`

`golangci-lint` must pass clean.

## Secrets

- Never hard-code secrets, tokens, or keys.
- Read configuration from environment variables or explicit config files that stay out of git.
- `.env` files stay gitignored. Provide `.env.example` when environment variables matter.

## House Rule

- No em dashes in comments or docs. Use " - " instead.
