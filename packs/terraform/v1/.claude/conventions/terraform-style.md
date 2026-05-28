# Terraform Conventions

All agents read this file before writing or reviewing Terraform HCL.

## Runtime Baseline

- Terraform 1.7+ syntax only.
- Keep configurations OpenTofu compatible. Do not rely on Terraform-only experiments or proprietary features.
- HCL2 throughout.

## File Layout

- One resource per file, named for the resource type, for example `storage_bucket.tf`.
- Variables live in `variables.tf`.
- Outputs live in `outputs.tf`.
- Providers live in `providers.tf`.
- Data sources live in `data.tf`.
- Version constraints live in `versions.tf`.
- Use `locals.tf` for shared locals only when they meaningfully reduce duplication.

## Naming

- Resources, modules, variables, locals, and outputs use `snake_case`.
- Prefer descriptive names, for example `google_storage_bucket.audit_logs`, not `google_storage_bucket.bucket1`.
- Module directories use `kebab-case` or `snake_case`, but stay consistent within the repo.

## Variables

- Every variable must declare `description` and `type`.
- Sensitive variables must also declare `sensitive = true`.
- Do not encode credentials, tokens, or fixed project IDs directly in default values.
- Prefer validation blocks when a variable has a constrained shape.

## Outputs

- Every output must declare `description`.
- Mark sensitive outputs with `sensitive = true` when they could expose credentials or identifiers that should stay out of logs.

## Providers and Modules

- Reusable modules are single-purpose.
- Reusable modules do not define provider configuration blocks. Provider configuration stays in the caller.
- Pin Terraform and provider version constraints in `versions.tf`.
- Prefer explicit provider aliases over implicit magic when multiple accounts, regions, or projects are involved.

## Secrets and Identity

- No hard-coded credentials or project IDs. Use variables, workspace data, remote state, or data sources.
- Do not commit `.tfvars` files with secrets. Use `.tfvars.example` for placeholders.
- Prefer references to Secret Manager, Vault, or equivalent secret stores over inline secret values.

## Tests and Verification

- `terraform fmt` must produce no diff.
- `terraform validate` must pass.
- `tflint` must pass clean.
- `terraform test` must cover every touched module. At minimum, add a plan-only `.tftest.hcl` assertion file per module.
- `checkov` must report no HIGH severity findings. MEDIUM findings require an inline suppression comment with justification.

Canonical verification order:

- `terraform fmt -check -recursive`
- `terraform validate`
- `tflint --recursive`
- `terraform test`
- `checkov -d . --compact --quiet`

## Comments and Descriptions

- Keep comments short and factual.
- No em dashes in comments or descriptions. Use " - " instead.
- Prefer describing intent and invariants over narrating obvious syntax.
