# C# Conventions

All agents read this file before writing or reviewing C# code.

## Naming

- Types, methods, properties, public fields: PascalCase
- Private fields: `_camelCase`
- Interfaces: `I`-prefix (`IMyService`)
- Constants: PascalCase (not ALL_CAPS)
- Async methods: suffix `Async`, accept `CancellationToken` where they do I/O

## Nullability

- Nullable reference types are enabled and honest.
- No `!` null-forgiving operator unless justified in an inline comment.
- Prefer `is null` / `is not null` over `== null`.

## Structure

Declarations ordered within a type: constants, private fields, properties, constructors, public methods, private methods.

## Async

- All async methods end in `Async`.
- Accept `CancellationToken ct = default` on any method that does I/O.
- Never use `.Result` or `.Wait()` on a Task. Await instead.

## Dependency Injection

- Register via extension methods in `ServiceCollectionExtensions.cs`.
- Constructor injection only. No service locator pattern.
- Interfaces live in the same namespace as their primary implementation unless shared across projects.

## Error Handling

- Use typed exceptions for domain errors. Do not throw `Exception` directly.
- Catch only what you can handle. Let the rest propagate.
- No empty catch blocks.

## XML Docs

- Every `public` and `protected` member requires `<summary>`.
- Add `<param>`, `<returns>`, and `<exception>` where applicable.
- Use `<inheritdoc cref="..."/>` for overrides and interface implementations.
- No placeholder text ("TODO", "Gets the value").

## Build

- Build command: `dotnet build`
- Test command: `dotnet test`
- Format check: `dotnet format --verify-no-changes`
- Zero CS1591 warnings on any modified project before committing.
