---
applyTo: "**/*.tf,**/*.tftest.hcl"
---

# Terraform Instructions

- Keep one resource per file named for the resource type.
- Variables belong in `variables.tf` with `description` and `type`; sensitive variables also set `sensitive = true`.
- Outputs belong in `outputs.tf` and every output needs `description`.
- Providers belong in `providers.tf`, data sources in `data.tf`, and version constraints in `versions.tf`.
- Keep reusable modules provider-free and OpenTofu compatible.
- No hard-coded credentials or project IDs. Prefer variables, data sources, and secret-manager references.
- Every touched module should have a `.tftest.hcl` file.
- `terraform fmt -check -recursive`, `terraform validate`, `tflint --recursive`, `terraform test`, and `checkov -d . --compact --quiet` must stay clean.
- No em dashes in comments or descriptions. Use " - " instead.
- Read `.claude/conventions/terraform-style.md` and `.claude/conventions/security-style.md` for the complete rules.
