# go pack

Targets Go 1.22+ projects using modules, `go build`, `go test`, `go vet`, `golangci-lint`, and table-driven tests with testify. Ships specialist agents (`go-scout`, `go-implement`, `go-doc-writer`) plus the shared reviewer, ratchet, and git-workflow agents. Orchestration lives in a main-session slash command (`/do-work-run`).

## Versions

| Version | Status     | Target tool baseline                                      | Changelog                                 |
| ------- | ---------- | --------------------------------------------------------- | ----------------------------------------- |
| v1      | maintained | Go 1.22+, modules, go build/test/vet, golangci-lint, testify | Initial cut for backend and service repos |

**Latest:** v1

## Notes

### Toolchain choices

- **Dependencies:** Standard library first. Add third-party packages only when they provide substantial value.
- **Modules:** `go.mod` is the source of truth. Keep module boundaries explicit and imports clean.
- **HTTP:** Prefer `net/http` first. Add `chi` or `gorilla/mux` only when routing needs justify it.
- **Testing:** Use `go test` with table-driven tests. `github.com/stretchr/testify` is the default assertion helper.
- **Documentation:** Exported types and functions require godoc comments. README updates ride with public-surface changes.

### Ratchet tuning rationale

- All dimension weights stay balanced at `1.0` for this pack.
- `threshold_test_coverage = 0.70` sets a practical floor for typical Go services.
- `go vet ./...` is part of the verification baseline alongside build, test, and lint.

### Divergence from shared

- Doc-quality guidance targets godoc comments on exported Go APIs rather than XML docs or Python docstrings.
- Implementation paths are module-oriented. Agents may edit first-party `*.go` files plus `go.mod` and `go.sum` when required.

### Upgrading from a different pack

Re-run the installer with `--force --pack go@v1`. Review the diff in the target project's git history. Mixing packs in one repo is not supported.
