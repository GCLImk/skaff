# Terraform Style

- Keep one resource per file named for the resource type.
- Variables go in `variables.tf` with `description` and `type`; sensitive vars also set `sensitive = true`.
- Outputs go in `outputs.tf` and every output needs `description`.
- Providers belong in `providers.tf`, data sources in `data.tf`, and version constraints in `versions.tf`.
- No hard-coded credentials or project IDs. Keep reusable modules provider-free.
- `terraform fmt -check -recursive`, `terraform validate`, `tflint --recursive`, `terraform test`, and `checkov -d . --compact --quiet` must stay clean.
- No em dashes in comments. Use " - " instead.
- Read `.claude/conventions/terraform-style.md` and `.claude/conventions/security-style.md` for the complete rules.
