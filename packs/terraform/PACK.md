# terraform pack

Targets Terraform 1.7+ projects and reusable modules using Terraform and OpenTofu compatible HCL2, `terraform validate`, `tflint`, `terraform test`, and `checkov`. Ships specialist agents (`tf-scout`, `tf-implement`, `tf-doc-writer`) plus the shared reviewer, ratchet, and git-workflow agents. Orchestration lives in a main-session slash command (`/do-work-run`).

## Versions

| Version | Status     | Target tool baseline                                                            | Changelog                          |
| ------- | ---------- | -------------------------------------------------------------------------------- | ---------------------------------- |
| v1      | maintained | Terraform 1.7+, OpenTofu compatible HCL2, tflint, terraform test, checkov       | Initial cut for Terraform projects |

**Latest:** v1

## Notes

### Toolchain choices

- **Runtime:** Terraform 1.7+ HCL2 written to stay OpenTofu compatible.
- **Verification:** `terraform fmt -check -recursive`, `terraform validate`, `tflint --recursive`, `terraform test`.
- **Security:** `checkov -d . --compact --quiet` before commit. No HIGH findings accepted.
- **Layout:** root stacks and reusable modules. Reusable modules keep provider configuration in the caller, not inside the module.
- **Docs:** variables and outputs are described in HCL, and module READMEs follow terraform-docs style sections.

### Ratchet tuning rationale

- `security_weight = 2.0` - security is the critical quality gate for infrastructure as code.
- `test_coverage_weight = 1.0` - standard emphasis, but coverage means module and resource coverage via `terraform test`.
- `threshold_test_coverage = 0.50` - lower than app packs because infrastructure tests are harder to exhaustively automate.

### Divergence from shared

- `ratchet-protocol.md` expands to eight dimensions by adding `security` as a first-class dimension.
- `coverage-protocol.md` keeps the shared verification protocol and adds Terraform-specific guidance for interpreting `terraform test` coverage.

### Upgrading from a different pack

Re-run the installer with `--force --pack terraform@v1`. Review the diff in the target's git history. Mixing packs in one repo is not supported.
