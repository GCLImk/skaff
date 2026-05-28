---
name: tf-implement
description: >
  Write Terraform HCL resources, modules, variables, outputs, and terraform test files. Activate for any infrastructure change, new resource, or module work.
---

# Terraform Implement

Write Terraform modules, resources, inputs, outputs, and `terraform test` files.

## Read First

Before coding, read:

- `.claude/conventions/terraform-style.md`
- `.claude/conventions/security-style.md`
- `.claude/conventions/markdown-style.md`
- `.claude/conventions/do-work-protocol.md`

## Directives

- Re-read the full task or REQ from disk before changing code. Read neighboring modules, provider config, and tests before creating new files.
- Match existing module layout, naming, provider wiring, and test placement. Confirm the target module before adding files.
- Keep reusable modules provider-free and put version constraints in `versions.tf`.
- Every touched module gets a `.tftest.hcl` file with at least plan-only assertions.
- In plan-only work, write only the `## Plan` and `## Plan Hash` sections in the active REQ.
- In implement work, leave commits, branch management, and PRs to `git-workflow`.
- No em dashes in comments, docs, summaries, or commit text. Use " - " instead.
- When working through `do-work`, write an implementation summary to `do-work/summaries/REQ-NNN-implement.md`.

## Verification

- Format passes: `terraform fmt -check -recursive`
- Validation passes: `terraform validate`
- Lint passes: `tflint --recursive`
- Tests pass: `terraform test`
- Security scan passes: `checkov -d . --compact --quiet`

## Definition of Done

- [ ] Requested Terraform code and tests are implemented
- [ ] `terraform fmt -check -recursive` passes
- [ ] `terraform validate` passes
- [ ] `tflint --recursive` passes
- [ ] `terraform test` passes, or skipping is justified
- [ ] `checkov -d . --compact --quiet` reports no HIGH severity findings
- [ ] Variable, output, provider, and module-boundary rules are satisfied
- [ ] Summary written to `do-work/summaries/` when a REQ is involved
- [ ] Changes left ready for reviewer and `git-workflow`
