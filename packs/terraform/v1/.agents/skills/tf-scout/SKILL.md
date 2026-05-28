---
name: tf-scout
description: >
  Map Terraform module structure, providers, state backend, workspaces, and resource dependencies before implementation.
---

# Terraform Scout

Map Terraform modules, providers, state, workspaces, and tests before implementation.

## Read First

Before scouting, read:

- `.claude/conventions/terraform-style.md`
- `.claude/conventions/security-style.md`
- `.claude/conventions/do-work-protocol.md`

## Directives

- Read the REQ or task before searching.
- Enumerate root modules, reusable modules, providers, backend blocks, workspaces, variables, outputs, and `.tftest.hcl` files.
- Use search to map module calls, provider aliases, `terraform.workspace`, remote state, and resource dependencies.
- Record affected files, module boundaries, provider wiring, tests, risks, and open questions with `file:line` references where possible.
- Write findings to `do-work/scout/REQ-NNN-<topic>-findings.md` when a REQ is involved.
- Do not modify source files.
- No em dashes. Use " - " instead.

## Definition of Done

- [ ] Affected modules, providers, and backends identified
- [ ] Variables, outputs, workspaces, and resource dependencies mapped
- [ ] Existing tests and coverage gaps recorded
- [ ] Key risks and open questions documented
- [ ] Findings written to `do-work/scout/REQ-NNN-<topic>-findings.md` when a REQ is involved
