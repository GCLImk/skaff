# Terraform Security Conventions

All agents read this file before writing or reviewing infrastructure changes.

## Secrets

- No secrets in state when there is a practical alternative. Prefer Secret Manager, Vault, or similar references over literal secret values.
- Never hard-code credentials, private keys, or access tokens.
- Do not commit `.tfvars`, `.auto.tfvars`, or state files containing secrets.

## Encryption

- Encryption at rest is required for all storage resources.
- Use provider-native encryption controls and customer-managed keys when the platform or REQ requires them.

## Networking

- No public IPs unless explicitly justified with an inline comment.
- Prefer private networking, private endpoints, and firewall rules scoped to known sources.
- Security groups, firewall rules, and ingress policies default to least exposure.

## IAM

- Follow the principle of least privilege.
- Do not grant `roles/owner` or equivalent full-admin bindings.
- Prefer narrowly scoped roles on the smallest resource that satisfies the requirement.

## Verification

- Run `checkov -d . --compact` before committing.
- HIGH severity findings block the change.
- MEDIUM severity findings require an inline suppression comment with a concrete justification.
- Re-check new backends, remote state data sources, IAM bindings, and public ingress rules during review.
