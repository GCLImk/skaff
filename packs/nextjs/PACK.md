# nextjs pack

Targets Next.js 14 App Router applications written in TypeScript, deployed as a single Docker container to Google Cloud Run, authenticated via NextAuth + Google OAuth (`hd`-restricted to a single Workspace tenant), and backed by Google Sheets API v4 as the system of record. Includes a server-only HTTP bridge to a downstream `NOTIFY_ENDPOINT`. Ships the standard specialist triad (`nextjs-scout`, `nextjs-implement`, `nextjs-doc-writer`) plus four read-only domain advisors (`nextjs-routing-specialist`, `sheets-specialist`, `auth-specialist`, `cloudrun-specialist`) and the shared `reviewer`, `ratchet`, and `git-workflow` agents. Domain advisors write recommendation briefs to `do-work/scout/`; only `nextjs-implement` writes production code. Orchestration lives in the main-session `/do-work-run` slash command.

## Mandatory stack

This pack is opinionated. The agents enforce the stack below; deviations require an AskUserQuestion confirmation captured in the originating REQ.

| Layer        | Choice                                                         |
| ------------ | -------------------------------------------------------------- |
| Language     | TypeScript (strict)                                            |
| Framework    | Next.js 14 (App Router)                                        |
| UI           | React + Tailwind CSS, no component library                     |
| Auth         | NextAuth.js + Google OAuth, `hd=myriota.com`                   |
| Data         | Google Sheets API v4 (server-side only)                        |
| Hosting      | Google Cloud Run (single container, scale to zero)             |
| Container    | Docker, `node:20-alpine` base                                  |
| Bridge       | Server-side HTTP POST to `NOTIFY_ENDPOINT`                     |

## Versions

| Version | Status     | Target tool baseline                                                                  | Changelog                                   |
| ------- | ---------- | ------------------------------------------------------------------------------------- | ------------------------------------------- |
| v1      | maintained | Node 20+, pnpm 9 (npm/yarn allowed), TypeScript 5+, Next.js 14, Vitest, Playwright    | Initial cut. Stack and conventions locked.  |

**Latest:** v1

## Notes

### Toolchain choices and rationale

- **pnpm** preferred for workspace ergonomics and lockfile determinism. `npm` and `yarn` are accepted but never mixed in a single repo - the lockfile decides.
- **Vitest** over Jest. Better TypeScript ergonomics, faster watch loop, native ESM. Playwright covers end-to-end. Jest is excluded from this pack to avoid two test runners diverging.
- **Tailwind only**, no shadcn / Radix / Material at v1. The mandate is "keep it lean"; bringing in a component library defeats the point. Add via REQ if a future feature needs it.
- **`googleapis` client library** for Sheets v4. The official `@googleapis/sheets` package is also acceptable. Custom HTTP clients are not - the auth and retry handling on the official client carry their weight.
- **Cloud Run + Docker** is hard-coded. Supporting Vercel or another host would multiply the conventions; if a project needs a different host, fork the pack or ship a v2.

### Ratchet tuning rationale

`ratchet.conf.template` raises `structure_weight` to 1.5 because the server / client boundary is the defining safety property of this stack. A leaked `NOTIFY_ENDPOINT` or a client-side `googleapis` import is a security incident, not a style nit, and must not be diluted by other dimensions. `dead_code` starts as N/A until `ts-prune` is wired in - TypeScript tree-shaking plus Next.js dynamic imports produce too many false positives without a dedicated tool. `test_coverage_weight` is 1.0 (down from the csharp default of 1.5) while the vitest + msw layer is being established; raise once the suite stabilises.

### Divergence from shared

None declared. Protocol-level conventions (do-work, ratchet, coverage, external-validation, markdown) track the csharp pack verbatim aside from agent-name substitutions.

### Open items

- A `ts-prune` (or equivalent) integration is not wired into the pack at v1. The ratchet records `dead_code` as N/A until it is.
- A TSDoc lint rule (`eslint-plugin-tsdoc` or `jsdoc/require-jsdoc`) is recommended but not enforced in `nextjs-style.md`. Add to the project's eslint config when ready, then remove the "surface as a finding" fallback from `nextjs-doc-writer.md` directive 10.

### Upgrading an installed project

There is no in-place upgrade. To apply pack changes to an existing target:

```bash
./install.sh /path/to/project --force --pack nextjs@v1
```

Review the diff in the target's git history. Re-run without `--force` to verify idempotency.
