# Next.js / TypeScript Conventions

All agents read this file before writing or reviewing code in this project. The stack below is mandatory; substitutions are not permitted without an explicit user-approved exception captured in a REQ.

## Mandatory stack

| Layer        | Choice                                                         | Reason                                                |
| ------------ | -------------------------------------------------------------- | ----------------------------------------------------- |
| Language     | TypeScript (strict mode)                                       | Type safety on Sheets API payloads                    |
| Framework    | Next.js 14 App Router                                          | API routes + React in one container                   |
| UI           | React + Tailwind CSS                                           | No component library - keep it lean                   |
| Auth         | NextAuth.js with Google OAuth provider, `hd=myriota.com`       | Domain-restrict to the Workspace tenant               |
| Data         | Google Sheets API v4 (server-side only)                        | Sheets stay as the source of truth                    |
| Hosting      | Google Cloud Run (single container)                            | GCP boundary, scales to zero                          |
| Container    | Docker, `node:20-alpine` base                                  | Minimal image                                         |
| Bridge calls | HTTP POST to `NOTIFY_ENDPOINT` (server-side only)              | Endpoint is never exposed to the client               |

If a request requires deviating from this table, stop and `AskUserQuestion`.

## Project layout

```
<repo>/
  app/                          App Router root
    (public)/                   Routes that do not require auth
    (app)/                      Authenticated routes (group)
    api/
      auth/[...nextauth]/route.ts    NextAuth route handler
      <feature>/route.ts             Server-only API routes
    layout.tsx
    page.tsx
  components/                   React components, server-first
    ui/                         Tailwind primitives (no component library)
  lib/
    sheets/                     Google Sheets API client wrappers (server-only)
    auth.ts                     NextAuth config (authOptions)
    bridge.ts                   NOTIFY_ENDPOINT POST helper (server-only)
    env.ts                      Validated env access
  types/                        Shared TS types (Sheets row shapes, domain models)
  middleware.ts                 Optional - route protection
  Dockerfile                    Multi-stage, node:20-alpine
  .dockerignore
  next.config.mjs
  tsconfig.json
  tailwind.config.ts
  postcss.config.mjs
  package.json
  pnpm-lock.yaml | package-lock.json
  tests/                        Unit + integration tests
```

Server-only modules live under `lib/sheets/` and `lib/bridge.ts`. Use the `import "server-only"` guard at the top of each so accidental client imports fail at build time.

## Packaging tool

- **pnpm** (preferred). Acceptable alternatives: `npm`, `yarn` - one only, never mixed.
- Lockfile is committed. Do not delete or regenerate without an explicit REQ.
- Node version pinned via `.nvmrc` and `engines.node` in `package.json` to `>=20 <21`.

## TypeScript

- `strict: true` in `tsconfig.json`. `noUncheckedIndexedAccess: true`. `noImplicitOverride: true`.
- Target: `ES2022`. Module: `bundler` (Next 14 default).
- No `any`. If a third-party type is missing, write a local declaration in `types/` or a colocated `*.d.ts`.
- No `as` casts except for narrowing branded types or parsing well-known JSON. A cast that hides an error is a bug.
- Prefer `type` over `interface` for object shapes unless declaration merging is required.
- Use `unknown` at boundaries; narrow with type guards (`zod` parse where structured).

## Naming

- Files: `kebab-case.ts` / `kebab-case.tsx`. React components: `PascalCase` exported symbol from a `kebab-case.tsx` file.
- Variables, functions: `camelCase`. Types, components, enums: `PascalCase`. Constants: `SCREAMING_SNAKE_CASE` for top-level immutable config; otherwise `camelCase`.
- React Server Components are the default. Client components are explicitly marked with `"use client"` at the top of the file.
- API route handlers: file is `route.ts`, exports named after HTTP verbs (`GET`, `POST`, ...).

## React + Next.js

- App Router only. No `pages/` directory.
- Server components fetch data directly. Do not add client-side data fetching unless the data is user-interactive and changes after first paint. State which case it is in code review.
- `useEffect` for data fetching is a code smell. Prefer server components or server actions.
- Server actions (`"use server"`) are acceptable for mutations. Always validate input with `zod`.
- No `getServerSideProps`, no `getStaticProps` (those are pages-router primitives).
- Loading and error UI uses `loading.tsx` and `error.tsx` colocated with the route.

## Tailwind CSS

- No component library (no shadcn, no Material, no Radix unless added via REQ). Build primitives in `components/ui/`.
- Class strings live inline. Group with `clsx` or a `cn` helper when conditional.
- No `@apply` outside `globals.css` for true primitives (e.g. resetting form elements). Component-level `@apply` is forbidden - it defeats the utility model.
- Theme extensions go in `tailwind.config.ts` `theme.extend`. Never edit `theme` directly.

## NextAuth

- Single provider: Google. Configure in `lib/auth.ts` and re-export `authOptions`.
- Domain restriction: pass `authorization: { params: { hd: "myriota.com" } }` AND validate `profile.hd === "myriota.com"` in the `signIn` callback. Both layers - the client hint is bypassable.
- Sessions are JWT-based unless the REQ explicitly calls for a database session.
- Secret rotation: `NEXTAUTH_SECRET` is required and validated by `lib/env.ts` at startup. The app must not boot without it.
- Never log access tokens or id tokens.

## Google Sheets API v4

- Server-only. Any module that imports `googleapis` must start with `import "server-only"`.
- Authentication: a Google service account whose JSON is loaded from an env var (base64-encoded preferred for Cloud Run secret manager). No file reads in production paths.
- Sheet IDs come from env vars validated in `lib/env.ts`. Never hard-code a sheet ID in source.
- Read paths: prefer `values.batchGet` over a loop of `values.get`. Quotas are real.
- Write paths: always use `valueInputOption: "USER_ENTERED"` unless the REQ specifies otherwise. Capture `updatedRange` in the response and return it for verification.
- Type every range read or written. Define row shapes in `types/sheets/`. Cell-by-cell `string | undefined` access is forbidden in domain code; parse at the boundary.
- Rate limit handling: catch `429` and `5xx`, retry with exponential backoff up to three attempts. Surface failure to the caller with the sheet, range, and attempt count.

## Bridge calls (NOTIFY_ENDPOINT)

- The endpoint URL is server-only. Never re-export from a client module. Never embed in a server-rendered HTML response.
- All bridge calls go through `lib/bridge.ts`. Direct `fetch` to `NOTIFY_ENDPOINT` from any other file is a violation.
- Validate the response shape with `zod` before returning to callers.
- Timeouts: 10s default. Surface AbortController support to the caller.

## Environment variables

- Single source of truth: `lib/env.ts` parses `process.env` with `zod` once at module load. Re-export typed values.
- Required server vars: `NEXTAUTH_SECRET`, `NEXTAUTH_URL`, `GOOGLE_CLIENT_ID`, `GOOGLE_CLIENT_SECRET`, `GOOGLE_SERVICE_ACCOUNT_JSON_B64`, `SHEET_ID_*` (per sheet), `NOTIFY_ENDPOINT`.
- Public vars must be prefixed `NEXT_PUBLIC_` and are limited to non-secrets. The auth client ID is server-only despite being technically public; do not prefix it.
- `.env.local` is not committed. `.env.example` is.

## Error handling

- Throw typed errors at boundaries: `class SheetsApiError extends Error`, `class BridgeError extends Error`. No bare `throw new Error("...")` in domain code.
- API route handlers return `Response` with a structured JSON body: `{ error: { code, message } }`. Never leak stack traces.
- Server components that fail render fall through to `error.tsx`. Do not swallow errors with try/catch in server components unless you re-throw a typed error.
- No empty catch blocks.

## TSDoc

- Every exported symbol in `lib/`, `types/`, and any `route.ts` requires a TSDoc block: `/** ... */` with at least a one-sentence summary. Add `@param`, `@returns`, `@throws` where applicable.
- React component props: document the `Props` type. The component itself only needs a TSDoc summary if its behaviour is non-obvious.
- No placeholder text ("TODO", "Gets the value").

## Linting and formatting

- ESLint with `next/core-web-vitals` and `@typescript-eslint/strict-type-checked`.
- Prettier with the project root config. Tab width 2, single quotes; semicolons follow Next.js defaults (`semi: true`).
- Lint and format gates run in CI: `pnpm lint` and `pnpm format:check`.
- No disabled rules without an inline reason and an issue link.

## Testing

- Framework: **Vitest** for unit and integration. **Playwright** for end-to-end. Pick one per concern; never mix Jest in.
- Test files: `*.test.ts` / `*.test.tsx`. Live next to the code under test or under `tests/` for cross-cutting suites.
- Coverage: `vitest --coverage` (V8 provider). Target on changed files at v1: `>=70%` lines, `>=60%` branches. Tighten over time.
- Sheets API and the bridge call MUST be mocked at the network layer (`msw` for HTTP). Do not stub the wrapper module - test through it.
- Auth-protected routes: write integration tests with a forged session token. Do not call live Google OAuth from tests.

## Build and verification

- Type check: `pnpm tsc --noEmit`
- Lint: `pnpm lint`
- Format check: `pnpm format:check`
- Test: `pnpm test --run`
- Build: `pnpm build`

All five must pass on a feature branch before review. The ratchet runs them fresh.

## Docker / Cloud Run

- Multi-stage Dockerfile: `deps`, `builder`, `runner`. The runner stage uses `node:20-alpine` and runs as a non-root user.
- `next.config.mjs` sets `output: "standalone"` so the runner stage can copy `.next/standalone` and `.next/static`.
- The runner exposes port `8080` (Cloud Run default). Read `PORT` from env.
- Health check: a `GET /api/health` route returns `200` with a small JSON body. No DB or Sheets calls inside health.
- Cloud Run service account: distinct from the Sheets service account. Grant it Secret Manager access only.

## Secrets handling

- Never commit a service account JSON, OAuth client secret, `NEXTAUTH_SECRET`, or `NOTIFY_ENDPOINT`.
- Local development: load via `.env.local`. Production: Cloud Run secrets mounted as env vars.
- The `.gitleaks.toml` at repo root catches the common shapes; do not bypass.

## Starter `tsconfig.json` snippet

```jsonc
{
  "compilerOptions": {
    "target": "ES2022",
    "lib": ["dom", "dom.iterable", "esnext"],
    "allowJs": false,
    "skipLibCheck": true,
    "strict": true,
    "noUncheckedIndexedAccess": true,
    "noImplicitOverride": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "plugins": [{ "name": "next" }],
    "paths": { "@/*": ["./*"] }
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx", ".next/types/**/*.ts"],
  "exclude": ["node_modules"]
}
```
