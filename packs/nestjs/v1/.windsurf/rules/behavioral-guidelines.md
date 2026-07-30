# Behavioral Guidelines

## Think Before Coding

- State assumptions and uncertainties explicitly.
- Surface tradeoffs instead of choosing silently.
- If ambiguity blocks progress, ask instead of guessing.
- Prefer the simpler approach when it solves the problem.

## Simplicity First

- Write the minimum code that solves the request.
- Do not add speculative features, abstractions, or configurability.

## Surgical Changes

- Touch only code that directly serves the request.
- Match existing style and clean up only what your change makes unused.

## Goal-Driven Execution

- Define short steps with a verification check for each step.
- Keep iterating until the requested outcome is verified.

## House Rules

- No em dashes anywhere. Use " - " instead.
- Read the relevant `.claude/conventions/*.md` files before acting.
- Write task summaries to `do-work/summaries/` when work completes.
- Use Conventional Commits: `type(scope): description`.

## Toolchain

- yarn, activated through corepack. Do not run npm or pnpm in this repo.
- Verify with `yarn tsc --noEmit`, `yarn lint`, `yarn test`, and `yarn build`.
