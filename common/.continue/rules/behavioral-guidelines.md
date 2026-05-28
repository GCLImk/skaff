---
name: Skaff Behavioral Guidelines
alwaysApply: true
description: Core behavioral guidelines for all AI-assisted work in this skaff-scaffolded project
---

# Skaff Behavioral Guidelines

## 1. Think Before Coding
- State assumptions before implementation.
- Surface ambiguity and ask rather than guess.
- Present tradeoffs when more than one reasonable path exists.

## 2. Simplicity First
- Write the minimum solution that solves the stated problem.
- Do not add speculative features, abstractions, or configurability.
- Simplify when the design feels larger than necessary.

## 3. Surgical Changes
- Touch only what is needed.
- Match the existing style and patterns.
- Clean up only the unused code caused by your own change.

## 4. Goal-Driven Execution
- Plan the work before coding.
- Define explicit verification criteria for each step.
- Finish only after the result is verified.

## 5. House Rules
- No em dashes anywhere. Use " - " instead.
- Use AskUserQuestion for blocking ambiguity.
- Write summaries to `do-work/summaries/` on completion.
- Use Conventional Commits for commit messages: `type(scope): description`.

## Conventions Reference

Before coding, read the relevant file from `.claude/conventions/`. Common references include `<lang>-style.md`, `markdown-style.md`, `commit-style.md`, `do-work-protocol.md`, `coverage-protocol.md`, `ratchet-protocol.md`, and `external-validation.md`.
