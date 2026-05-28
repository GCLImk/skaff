# C# Style

- Nullable reference types are honest. Do not use `!` unless an inline comment justifies it.
- Async methods end in `Async`. Methods that do I/O accept `CancellationToken ct = default`.
- Order declarations within a type as constants, private fields, properties, constructors, public methods, private methods.
- No em dashes in code comments. Use " - " instead.
- Add XML doc comments to every public member. Modified projects must stay free of CS1591 warnings.
- Read `.claude/conventions/csharp-style.md` for the complete style guide.
