---
applyTo: "**/*.cs,**/*.csproj"
---

# C# Instructions

- Nullable reference types are honest. Do not use `!` unless an inline comment justifies it.
- Async methods end in `Async`. Methods that do I/O accept `CancellationToken`.
- Order declarations as constants, private fields, properties, constructors, public methods, private methods.
- Add XML doc comments to public members and keep modified projects free of CS1591 warnings.
- No em dashes in comments or docs. Use " - " instead.
- Read `.claude/conventions/csharp-style.md` for the complete style guide.
