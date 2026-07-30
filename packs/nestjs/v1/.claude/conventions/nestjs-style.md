# NestJS Style

All agents read this file before writing or reviewing NestJS or TypeScript code in this
project.

## 1. Toolchain Baseline

- Node 20 LTS or newer. Node 22 LTS is the preferred target for new services.
- NestJS 10 or newer. TypeScript 5 or newer, `strict: true`.
- **yarn is the package manager.** Enable it through corepack rather than a global install:

  ```bash
  corepack enable
  corepack prepare yarn@stable --activate
  ```

  The `packageManager` field in `package.json` pins the exact version. Do not add a
  second lockfile. A repo with both `yarn.lock` and `package-lock.json` is a bug - delete
  the one that does not match `packageManager` and say so in the REQ.
- Canonical scripts every project is expected to expose in `package.json`:

  | Script | Command it wraps |
  | ------ | ---------------- |
  | `build` | `nest build` |
  | `start:dev` | `nest start --watch` |
  | `lint` | `eslint . --max-warnings 0` |
  | `format:check` | `prettier --check .` |
  | `test` | `jest` |
  | `test:cov` | `jest --coverage` |
  | `test:e2e` | `jest --config ./test/jest-e2e.json` |

  If a script is missing, add it in the same REQ rather than inventing an ad-hoc command
  line. Agents verify through `yarn <script>`, never through a bare binary path.

## 2. Project Layout

- `src/main.ts` is the only bootstrap entry point. It creates the app, wires global pipes,
  filters and interceptors, and starts the listener. No business logic.
- `src/app.module.ts` is the composition root. It imports feature modules and
  infrastructure modules. It declares no controllers or providers of its own beyond a
  health check.
- One directory per feature module under `src/<feature>/`:

  ```text
  src/orders/
    orders.module.ts
    orders.controller.ts
    orders.service.ts
    dto/create-order.dto.ts
    dto/update-order.dto.ts
    entities/order.entity.ts
    orders.service.spec.ts
  ```

- Cross-cutting code that is not a feature lives under `src/common/` (guards, filters,
  interceptors, decorators, pipes) and `src/config/` (configuration schema and loaders).
- End-to-end tests live under `test/`, not under `src/`.
- File naming is kebab-case with a role suffix: `orders.controller.ts`,
  `create-order.dto.ts`, `order-created.event.ts`. Class names are PascalCase and match
  the file: `OrdersController`, `CreateOrderDto`.

## 3. Module Boundaries

- A feature module owns its providers. Anything another module needs must appear in that
  module's `exports` array. Nothing is reachable by accident.
- **Never import a provider by relative path across a feature boundary.** Import the
  owning module and inject the exported provider. A deep relative import such as
  `../orders/orders.service` from inside `src/billing/` is a structural defect, not a
  shortcut.
- Circular module imports are forbidden. `forwardRef()` is a last resort, not a pattern:
  if two modules need each other, the shared piece belongs in a third module or in
  `src/common/`.
- `@Global()` is reserved for genuine infrastructure that every module needs (config,
  logging, database connection). A global feature module is a design failure.
- Shared contracts (interfaces, enums, DTO base types) that two features both depend on go
  in a module both can import, never in whichever feature happened to define them first.

## 4. Dependency Injection

- Constructor injection only. No property injection, no service locator, no direct
  instantiation of a provider with `new`.
- Depend on the narrowest type that satisfies the need. When a provider is swapped in tests
  or per environment, inject an interface behind an injection token:

  ```ts
  export const PAYMENT_GATEWAY = Symbol('PAYMENT_GATEWAY');

  @Module({
    providers: [{ provide: PAYMENT_GATEWAY, useClass: StripeGateway }],
    exports: [PAYMENT_GATEWAY],
  })
  export class PaymentModule {}
  ```

  Use `Symbol` or a `const` string token, never a bare string literal repeated at each
  injection site.
- Default to the singleton scope. `Scope.REQUEST` and `Scope.TRANSIENT` bubble up the
  injection chain and quietly make every consumer request-scoped, so use them only when
  per-request state genuinely cannot be passed as an argument. State the reason in a
  comment on the provider.
- A class with more than five injected dependencies is a signal that it holds more than one
  responsibility. Split it, or state in the REQ why it should not be split.
- Controllers do not contain business logic. A controller validates, delegates to exactly
  one service method, and shapes the response. Services do not know about HTTP.
- Never inject the request object into a service to read headers or the session. Extract
  what is needed in the controller or a decorator and pass it as a parameter.

## 5. DTOs and Validation

- Every request body, query string and route parameter that carries structure has a DTO
  class. Interfaces cannot be validated at runtime, so DTOs are classes.
- Register `ValidationPipe` globally in `main.ts` with these options, and do not relax
  them per route:

  ```ts
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
    }),
  );
  ```

  `whitelist` strips unknown properties, `forbidNonWhitelisted` rejects them outright, and
  `transform` produces real DTO instances rather than plain objects.
- Validate with `class-validator` decorators on the DTO. Every field carries at least one
  decorator - an undecorated field is silently stripped by `whitelist` and produces a
  confusing empty value at runtime.
- Response shapes are explicit. Never return a persistence entity straight from a
  controller. Map to a response DTO or apply `ClassSerializerInterceptor` with `@Exclude()`
  on sensitive fields. Password hashes, tokens and internal ids must not be serialisable by
  default.
- Reuse through composition, not inheritance chains: `PartialType`, `PickType` and
  `OmitType` from `@nestjs/mapped-types` (or `@nestjs/swagger` when OpenAPI is in use).
- Configuration is validated the same way at startup. See section 8.

## 6. Error Handling

- Throw NestJS HTTP exceptions from the layer that knows the HTTP meaning:
  `BadRequestException`, `NotFoundException`, `ConflictException`,
  `UnauthorizedException`, `ForbiddenException`.
- Services that must stay transport-agnostic throw domain errors and let a mapping layer or
  an exception filter translate them. Do not import `@nestjs/common` HTTP exceptions into a
  pure domain module that also serves a queue consumer or a CLI.
- Register exactly one global exception filter so every unhandled error produces the same
  response envelope, logs with a correlation id, and never leaks a stack trace or an
  internal message to the client.
- Never swallow an error. A `catch` block either handles the failure meaningfully, enriches
  and rethrows, or logs at error level and rethrows. An empty `catch` is a blocking review
  issue.
- Never put a raw entity, a raw driver error, or a raw config value in a client-facing
  message. Log the detail, return a safe message plus the correlation id.
- Validation failures return 400 with the field-level detail `ValidationPipe` produces.
  Do not rewrite them into a generic message.

## 7. Async Patterns

- Every promise is awaited or explicitly returned. A floating promise is a lost error.
  Enable `@typescript-eslint/no-floating-promises` and treat its findings as blocking.
- Async methods return `Promise<T>` with `T` stated. Never `Promise<any>`.
- Use `Promise.all` for independent work and a sequential loop for dependent work. Do not
  fire `Promise.all` over an unbounded array - batch it, or the service will exhaust the
  connection pool.
- Long-running work does not belong in a request handler. Push it to a queue
  (`@nestjs/bull`, `@nestjs/schedule` for cron) and return an accepted response.
- Implement `OnModuleDestroy` / `OnApplicationShutdown` for anything holding a socket,
  a pool, a timer or a subscription, and call `app.enableShutdownHooks()`. A service that
  cannot drain cleanly loses in-flight requests on every deploy.
- No `process.exit()` outside a fatal bootstrap failure in `main.ts`.

## 8. Configuration

- All configuration comes from the environment through `@nestjs/config`. No `process.env`
  access outside the config module - a `process.env.FOO` in a service is untestable and
  untyped.
- Validate the whole environment at startup with a schema and fail fast:

  ```ts
  ConfigModule.forRoot({
    isGlobal: true,
    validate: (raw) => envSchema.parse(raw),
  });
  ```

  A missing or malformed variable must crash the process at boot, never surface as
  `undefined` on the first request that needs it.
- Read config through `ConfigService.get<T>()` with an explicit type parameter, or through
  a typed namespaced config factory. No non-null assertions on config lookups.
- Secrets are never committed, never defaulted to a working value, and never logged.
  `.env` stays gitignored; commit a `.env.example` listing every variable name with an
  empty or obviously fake value.
- Feature flags and environment branches live in configuration, not in `if
  (process.env.NODE_ENV === 'production')` scattered through services.

## 9. Security at the Boundary

- Every route is either explicitly public or protected by a guard. Prefer a global
  authentication guard plus an explicit `@Public()` decorator, so a new route is protected
  by default rather than exposed by omission.
- Authorisation is checked on the resource, not only on the role. A user with the right
  role and the wrong tenant must still be refused.
- Never build a query by string concatenation. Use the ORM's parameter binding or a
  parameterised statement, always.
- Rate-limit public and authentication routes (`@nestjs/throttler`). Set `helmet` and an
  explicit CORS allowlist in `main.ts`. `origin: true` is not an allowlist.
- Log the correlation id, the route and the outcome. Never log request bodies, tokens,
  cookies, authorisation headers or personal data.
- Treat a new dependency as a decision: check it is maintained, check the transitive
  additions, and run `yarn npm audit --severity high` before adding it.

## 10. Persistence

- The ORM or query builder choice belongs to the project, not to this pack. Whatever it is,
  the rules below hold.
- Repository or data-access code lives behind a provider the feature module owns. Services
  do not build queries inline against a connection.
- Migrations are files in the repository, generated and reviewed, never applied by
  `synchronize: true`. `synchronize` against any shared or production database is a blocking
  review issue.
- Every migration is reversible or documents plainly why it cannot be. Destructive steps
  (drop column, narrow a type, add a `NOT NULL` without a default) are split into an
  expand phase and a contract phase across two deploys.
- Transaction boundaries are explicit and live in the service, not spread across
  repositories. One unit of work, one transaction.
- Eager relations are opt-in per query, never a default on the entity. Assert on query
  counts in a test when a loop touches a relation, so an N+1 shows up as a failing test
  rather than a latency graph.

## 11. Testing

- Jest is the test framework. Unit and integration specs sit beside the code as
  `*.spec.ts`; end-to-end specs live in `test/` as `*.e2e-spec.ts`.
- Build unit tests with `Test.createTestingModule()` and override only the collaborators
  the test needs. Do not instantiate a controller or service with `new` and hand-rolled
  fakes - that bypasses the DI wiring the test exists to protect.
- Test observable behaviour through the public method. Do not assert on private state or on
  the number of times an internal helper ran.
- End-to-end specs drive the real HTTP surface with `supertest` against a `TestingModule`
  app, with the same global pipes and filters as production. A validation rule that only
  exists in `main.ts` is untested otherwise.
- External systems are faked at the boundary the module owns: override the injection token,
  do not monkey-patch a module's internals. Tests never reach the network.
- Every new provider, guard, pipe, interceptor and filter arrives with a spec. Every bug
  fix arrives with the test that would have caught it.
- Coverage is measured with `yarn test --coverage`. The ratchet floor is 0.70 unless the
  project overrides `threshold_test_coverage` in `ratchet.conf`. Do not lower a threshold
  to make a change pass.

## 12. TSDoc and Comments

- Every exported class, method, function, DTO field, injection token and enum member that
  is part of another module's contract carries a TSDoc block. Internal private helpers do
  not need one.
- Use TSDoc tags, not prose substitutes: a summary sentence, then `@param`, `@returns`,
  `@throws` for each exception a caller is expected to handle, and `@remarks` for context
  that is not obvious from the signature.

  ```ts
  /**
   * Places an order and reserves stock for every line item.
   *
   * @param dto - Validated order payload.
   * @param actorId - Id of the authenticated user placing the order.
   * @returns The persisted order with its generated id.
   * @throws ConflictException When any line item is out of stock.
   * @remarks Runs inside a single transaction. Partial reservation is not possible.
   */
  async placeOrder(dto: CreateOrderDto, actorId: string): Promise<OrderResponseDto> {
  ```

- Document the injection token, not the implementation class, when consumers depend on the
  token.
- Comments explain why, never what. A comment restating the code is deleted.
- `@deprecated` names the replacement and the REQ that will remove it.
- No em dashes in comments, docs or output. Use " - " instead.

## 13. Lint, Format and Type Checking

- ESLint with `@typescript-eslint` is authoritative. `yarn lint` must exit clean with zero
  warnings; the `lint` script carries `--max-warnings 0` so a warning cannot accumulate.
- Prettier owns formatting. Never hand-format around it. `yarn format:check` gates CI.
- `strict: true` in `tsconfig.json`. No `any` without a comment on the same line stating
  why. Prefer `unknown` plus narrowing.
- `@ts-ignore` is forbidden. `@ts-expect-error` is permitted only with a comment naming the
  upstream issue that will remove it.
- No non-null assertion (`!`) on anything that crosses a boundary - a request payload, a
  config lookup, or a database result. Narrow it, or throw.
- Do not disable a rule inline to land a change. Fix the code, or raise the rule change as
  its own REQ.

## 14. Verification Commands

Run in this order. All four must pass before handoff:

```bash
yarn tsc --noEmit
yarn lint
yarn test
yarn build
```

`yarn format:check` runs alongside `yarn lint`. `yarn test --coverage` produces the
coverage signal the ratchet reads. `yarn test:e2e` runs when the change touches a
controller, a guard, a pipe or the global bootstrap. `yarn install --immutable` is the
install form in CI so a drifted lockfile fails the build instead of being rewritten.

Use `yarn nest generate <schematic> <name>` for new modules, controllers, services,
guards, pipes and filters so the generated wiring matches the framework's own layout, then
edit the result to match this file.

## 15. Starter `tsconfig.json` Fragment

```json
{
  "compilerOptions": {
    "module": "commonjs",
    "target": "ES2022",
    "lib": ["ES2022"],
    "outDir": "./dist",
    "baseUrl": "./",
    "declaration": true,
    "sourceMap": true,
    "incremental": true,
    "strict": true,
    "strictNullChecks": true,
    "noImplicitAny": true,
    "noUncheckedIndexedAccess": true,
    "noImplicitOverride": true,
    "exactOptionalPropertyTypes": true,
    "emitDecoratorMetadata": true,
    "experimentalDecorators": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true
  },
  "exclude": ["node_modules", "dist"]
}
```

`emitDecoratorMetadata` and `experimentalDecorators` are not optional - NestJS DI and
`class-validator` both read the emitted metadata.
