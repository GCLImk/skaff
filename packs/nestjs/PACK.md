# nestjs pack

Targets NestJS 10+ backend services written in TypeScript 5+ on Node 20 LTS or 22 LTS, using
**yarn** (activated through corepack) as the package manager and Jest as the test framework.
Ships the specialist triad (`nestjs-scout`, `nestjs-implement`, `nestjs-doc-writer`), two
read-only domain advisors (`nestjs-module-specialist`, `nestjs-persistence-specialist`), and the
shared `reviewer`, `ratchet`, and `git-workflow` agents. Orchestration lives in the main-session
`/do-work-run` slash command. This is the scaffold's first pack whose tool allowlists grant
`Bash(yarn ...)`; every other TypeScript pack hardcodes `Bash(pnpm ...)` and therefore cannot run
a yarn project's scripts at all.

## Versions

| Version | Status     | Target runtime / tool baseline                                                                        | Changelog                                       |
| ------- | ---------- | ----------------------------------------------------------------------------------------------------- | ----------------------------------------------- |
| v1      | maintained | Node 20+ / 22+, NestJS 10+, TypeScript 5+ strict, yarn (corepack, `packageManager`-pinned), Jest, ESLint + Prettier | Initial cut. First yarn-native pack in the scaffold. |

**Latest:** v1

## Notes

### Why the name is `nestjs` and not something narrower

The pack was authored to unblock a specific project (a NestJS backend inside a yarn-workspaces
monorepo, on Postgres, deployed to GCP), so the honest question was whether it is a general
NestJS pack or that project wearing a pack's clothing. It is general, and the test applied was:
does anything in the overlay name a system of record, a hosting provider, an auth provider, an
ORM, a database engine, or a company domain? Nothing does.

What the pack does encode is what the **framework** dictates and nothing more: modules and their
`exports`, constructor injection and provider scope, DTOs with `class-validator` behind a global
`ValidationPipe`, exception filters, guards, `@nestjs/config`, lifecycle and shutdown hooks, and
Jest with `Test.createTestingModule()`. A stranger's NestJS service on MySQL behind Prisma,
deployed to Fly.io, gets correct advice from every file here.

The two places a project-specific pack would have leaked, and how they were kept out:

- **Persistence.** `nestjs-persistence-specialist` is ORM-agnostic by construction: its first
  directive is to detect the ORM, query builder and driver from `package.json` and phrase every
  recommendation in that tool's terms. The rules it applies (reversibility, expand-and-contract
  sequencing, locking cost, batched backfills, transaction boundaries, N+1) hold across TypeORM,
  Prisma, Drizzle, MikroORM, Sequelize, Kysely and raw `pg`. `nestjs-style.md` section 10 opens by
  saying the ORM choice belongs to the project.
- **Workspaces.** `nestjs-scout` runs `yarn workspaces list` and names the target workspace when
  the repo has them, and does nothing when it does not. Nothing else in the pack assumes a
  monorepo.

`packs/nextjs/PACK.md` is the cautionary counter-example, and it was read first: that pack's
manifest hard-codes Google Sheets as the system of record, NextAuth with `hd=myriota.com`, a
bespoke `NOTIFY_ENDPOINT`, and Cloud Run. It is one project generalised into a pack without being
de-specialised, and only its shape is reusable. This pack deliberately does not do that.

### Toolchain choices and rationale

- **yarn, through corepack, and only yarn.** This is the point of the pack. Every `Bash(...)`
  grant in every agent, every command in every convention, every mirror file and the CI template
  all use yarn. Projects are expected to pin the version with `packageManager` in `package.json`
  and activate it with `corepack enable`; the pack does not ask for a global yarn install, and the
  CI template runs `corepack enable` before `setup-node` for the same reason.
- **npm and pnpm are NOT granted, deliberately and explicitly.** No agent's tool allowlist
  contains a `Bash(npm ...)` or `Bash(pnpm ...)` pattern, and there is no fallback. Two reasons.
  First, a lockfile is a single choice: an allowlist that permits two managers invites an agent to
  run the one the repo does not use and silently produce a second lockfile. Second, this pack
  exists because `react/v1` claims in prose that "yarn is acceptable" while granting only
  `Bash(pnpm ...)`, so the agents cannot run a yarn project at all - restating that ambiguity in
  the opposite direction would repeat the defect. A project on npm or pnpm should install `react`,
  `nextjs`, or `python`-style packs, or edit the `Bash(yarn ...)` grants in
  `.claude/agents/*.md` and the `package.json` script list in `nestjs-style.md` before first run.
  `CLAUDE.md.template` section 6 states this in the installed target so the constraint is visible
  without reading this manifest.
- **`yarn <script>` rather than `yarn exec <binary>`.** `yarn tsc --noEmit`, `yarn nest`,
  `yarn jest` resolve through `yarn run` on both yarn 1 and yarn 4, so the same grants work on
  either. `yarn dlx` replaces `npx` where a one-shot binary is needed (only `ts-prune` in the
  ratchet).
- **`yarn install --immutable`** is the CI install form so a drifted lockfile fails the build
  instead of being rewritten in place.
- **Jest, not Vitest.** NestJS ships Jest in every `@nestjs/cli` scaffold and
  `Test.createTestingModule()` is documented against it. Choosing Vitest would mean fighting the
  framework's own generators for no gain in a backend with no browser environment to simulate.
- **`class-validator` plus a global `ValidationPipe`** rather than a schema library at the
  controller edge, because the pipe is the framework's own boundary and DTO classes are what
  `whitelist` and `forbidNonWhitelisted` operate on. Schema libraries remain fine for
  configuration validation, and `nestjs-style.md` section 8 shows exactly that.
- **The ORM is not chosen.** See the naming section above.

### Ratchet dimensions and tuning rationale

Eight dimensions. `security` replaces the frontend packs' `accessibility`, on the reasoning that a
backend service owns the trust boundary and has no accessibility surface at all - a dimension with
nothing to measure is decoration, which is exactly what the protocol's N/A rule exists to avoid.

| Dimension | Weight | Signal it is mapped to |
| --------- | ------ | ---------------------- |
| `parse_check` | 1.0 (gate) | `yarn tsc --noEmit`, confirmed by `yarn build` |
| `lint` | 1.0 | `yarn lint` (`--max-warnings 0`) plus `yarn format:check` |
| `complexity` | 1.0 | Method and class length, injected-dependency count per class, nesting depth on modified files |
| `structure` | **1.5** | Module-boundary and DI hygiene against `nestjs-style.md` sections 2 to 4, including a diff grep for cross-boundary `../` imports |
| `dead_code` | 0.5 | `ts-prune` or `knip` when configured; **`null` otherwise** - see below |
| `test_coverage` | **1.5** | `yarn test --coverage`, plus `yarn test:e2e` when the request boundary changed |
| `doc_quality` | 1.0 | TSDoc on exported providers, DTO fields and injection tokens; markdown conformance |
| `security` | **1.5** | `yarn npm audit --severity high`, plus diff evidence: guard coverage on new routes, DTO validation, parameterised queries, no secrets in logs, no `process.env` outside config, `synchronize` off |

Three dimensions at 1.5 put half the composite weight on the three ways a backend actually fails:

- **`structure` 1.5** - module boundaries and DI hygiene decide whether the service stays
  changeable. A provider reached by a deep relative import, or a `Scope.REQUEST` provider bubbling
  into a singleton consumer, is not a style nit; it is the defect that makes the next ten REQs
  expensive. Nothing else in the pipeline measures it, and it cannot be measured by a tool, which
  is why it needs weight rather than a CI job.
- **`test_coverage` 1.5** - backend logic has no visual signal. An untested branch in a service is
  invisible until it is an incident. Matches the app packs' emphasis for the same reason.
- **`security` 1.5** - the service is where untrusted input and real credentials meet. An unguarded
  route, an unvalidated payload, a concatenated query or a logged token is a production incident,
  and at 1.0 six other dimensions can average it away.

Leaving any of the three at 1.0 lets the other two mask it, which is the failure mode the ratchet
exists to prevent. `dead_code` keeps the shared 0.5 because it is the noisiest dimension in every
pack.

**`dead_code` ships as N/A in `ratchet.conf.template`**, and this is a real toolchain gap rather
than a dodge. NestJS resolves providers through decorator metadata, not through a direct import,
so an un-tuned unused-export scan reports every provider, guard, pipe and filter in the project as
dead. Hand-scoring the dimension would be noise, so `na_dimensions = dead_code` is set and the
`ratchet.md` Tool Mapping says plainly not to hand-score it. Remove it from `na_dimensions` in the
same REQ that wires `ts-prune` or `knip` with a DI-aware ignore rule; the protocol's Appearance
rule records the first real value as neutral.

Thresholds: `threshold_test_coverage = 0.70`, `threshold_doc_quality = 0.85`,
`threshold_security = 0.85`, `threshold_parse_check = 1.00`. External validation fires at composite
`>= 0.85`, unchanged from the shared default.

### Agent roster and model choices

| Agent | Model | maxTurns | Why |
| ----- | ----- | -------- | --- |
| `nestjs-scout` | sonnet | 25 | Builds a reverse-dependency map across the module graph. Multi-file synthesis, not lookup |
| `nestjs-implement` | sonnet | 50 | Writes code, migrations and tests; owns the plan-hash drift check |
| `nestjs-doc-writer` | sonnet | 30 | TSDoc accuracy on failure surfaces and ADR authorship both need judgement |
| `nestjs-module-specialist` | sonnet | 20 | Cycle tracing and placement decisions are graph reasoning over many files |
| `nestjs-persistence-specialist` | sonnet | 20 | Migration-safety advice has production consequences if wrong |
| `reviewer` | sonnet | (unset) | Matches the shared reviewer across packs; also serves as the external validator |
| `ratchet` | sonnet | 30 | Runs the toolchain fresh and applies the graduated bar |
| `git-workflow` | sonnet | 30 | Secret scanning and the dangerous-ops gate |

**Divergence from the nextjs pack:** its four domain advisors run on `haiku`. Both advisors here
run on `sonnet`. A routing advisor answers a mostly local question; a module-boundary advisor has
to trace `A -> B -> C -> A` across the whole `src/` tree and report the blast radius, and a
migration advisor has to reason about deploy ordering against a populated table. Getting either
wrong is expensive, and the read-only path is cheap enough that the model choice is not the
constraint.

**Why exactly two advisors.** A pack with dead agents is worse than a lean one, so each had to earn
its place against a trigger that fires on real REQs and a gap nothing else covers.
`nestjs-module-specialist` earns it because `structure` is the pack's highest-weighted judgement
dimension and the scout only reports the graph rather than deciding placement in it.
`nestjs-persistence-specialist` earns it because migration ordering is the single most expensive
backend mistake and no other agent in the pipeline knows anything about expand-and-contract. Both
are wired conditionally in `/do-work-run` step 5, not unconditionally in the loop: an advisor is
spawned only when its trigger fires. A third advisor for auth or observability was considered and
rejected - the rules worth stating already live in `nestjs-style.md` section 9 and the `security`
dimension, and an advisor that only restates a convention is dead weight.

### Divergence from shared

- **Conventions taken from `common/`, not duplicated.** `commit-style.md` and
  `knowledge-protocol.md` ship once from `common/.claude/conventions/` per the pack contract, and
  this pack adds no local copy of either. `do-work-protocol.md` names
  `nestjs-doc-writer` as the ADR owner and both specialists as the proposed-convention owners, so
  the placeholders in the common `knowledge-protocol.md` resolve against a real roster.
- **Runtime `do-work/` directory skeletons are not duplicated.** `common/do-work/` already ships
  every `.gitkeep` (`archive/`, `archive/legacy/`, `ratchet/`, `scout/`, `summaries/`,
  `proposed-conventions/`, `user-requests/`, `working/`), so this overlay ships only
  `do-work/templates/`. Several older packs carry redundant copies; there is no behavioural
  difference either way and no need for a new pack to add more.
- **`markdown-style.md`** is the react/v1 version (the cleanest, post-fix) with the code-fence
  example retagged to ` ```ts ` and the intra-repo link pointing at `./nestjs-style.md`.
- **Two latent copy-paste defects were fixed on the way in**, not inherited. `react/v1`'s
  `do-work-protocol.md` ownership table still says "XML doc and markdown edits" and its
  `external-validation.md` axis 5 still says "do the XML docs and comments", both left over from
  the csharp pack; and its `ratchet-protocol.md` explains the focused kept-bar column with "a
  bugfix that touches one hook", which is React-specific. This pack says TSDoc, TSDoc, and "one
  service method". The same three defects are still present in `react/v1` and in whichever packs
  copied from it, and are worth a backport pass per `packs/SHARED-NOTES.md`.
- **CI template ships.** `do-work/templates/ci/` is present with a yarn + corepack workflow and a
  `dependency-audit` job feeding the `security` dimension. `react/v1` and `go/v1` ship no `ci/`.
  The workflow's baseline-composite check uses `node -p` rather than the `python3` one-liner the
  nextjs template inherited, so the only runtime the workflow needs is the one it already installs.
- **`git-workflow` mirrors carry two extra lines.** `packs/SHARED-NOTES.md` lists
  `.gemini/skills/git-workflow/SKILL.md`, `.agents/skills/git-workflow/SKILL.md` and
  `.github/agents/git-workflow.agent.md` as tracking files. This pack's copies add a
  "commit `yarn.lock` with any dependency change, and never add a second lockfile" rule and a
  "check migration files for a pasted connection string" rule. Both are backend and yarn specific
  and are not candidates for backport; everything else in those files tracks.
- **Every mirror file was written from this pack's own `.claude/agents/` sources**, not copied from
  another pack and edited. `830ebac` found that the mirror files in four packs were byte-identical
  copies of the csharp reviewer, telling agents on Python and TypeScript projects to run
  `dotnet build`. Within this pack, `.agents/skills/` is a verbatim mirror of `.gemini/skills/` by
  design (the contract treats them as the same content in two locations); `.github/agents/` is a
  separate rendering because the Copilot format carries `model:` and `tools:` frontmatter.

### Open items

- No `ts-prune` or `knip` integration at v1, so `dead_code` starts N/A. Wiring it needs a DI-aware
  ignore rule; until then the honest score is `null`.
- A TSDoc lint rule (`eslint-plugin-tsdoc` or `jsdoc/require-jsdoc`) is recommended but not
  enforced. `nestjs-doc-writer` directive 10 surfaces missing-doc counts as a finding in the
  meantime; remove that fallback once the rule is in the project's ESLint config.
- The pack does not ship a GraphQL convention. `@nestjs/graphql` projects get correct module, DI,
  validation and persistence advice, but resolver-specific guidance (dataloader batching, field
  resolvers, schema-first versus code-first) would be a v2 addition or a separate advisor.
- Microservice transports (`@nestjs/microservices`, gRPC, Kafka) are out of scope at v1. The
  transport-agnostic error-handling rule in `nestjs-style.md` section 6 is written so a later
  addition does not contradict it.

### Upgrading an installed project

There is no in-place upgrade. To apply pack changes to an existing target:

```bash
./install.sh /path/to/project --force --pack nestjs@v1
```

Review the diff in the target's git history. Re-run without `--force` to verify idempotency.
Switching a target from a different pack to this one also needs `--allow-pack-switch`
(`-AllowPackSwitch` on PowerShell); the installer lists the files the previous pack would orphan
before refusing. Mixing packs in one repo is not supported.
