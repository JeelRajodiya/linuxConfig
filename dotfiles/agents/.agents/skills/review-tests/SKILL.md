---
name: review-tests
description: Review added or changed tests for regression value, redundancy, determinism, assertion strength, and maintenance cost. Use when asked whether tests make sense, are flaky, trivial, redundant, overbuilt, or worth their lines of code. Review only by default; do not edit unless explicitly asked.
---

# Review Tests

Review tests as production code: every test adds maintenance cost and should protect a distinct, meaningful behavior.

## Scope

When reviewing a branch or diff:

1. Identify the correct merge base.
2. Inventory every added test, materially changed test, and relevant test helper.
3. Read the applicable repository and component instructions.
4. Preserve unrelated worktree changes.

Do not expand into a whole-repository audit unless requested.

## Core Question

For each test, ask:

> What concrete regression does this test catch that another test does not?

Mentally remove or invert the relevant production behavior. The test should fail for the intended reason. If it still passes, checks only its setup, or cannot distinguish the named behavior from an incorrect implementation, flag it.

A passing test is not automatically a useful test.

## Behavioral Value

Prefer tests that protect:

- User-visible or externally observable behavior.
- Important scheduling, concurrency, resource, or lifecycle invariants.
- Previously observed regressions.
- Error handling that prevents hangs, corruption, or silent failure.
- Integration boundaries not covered by cheaper tests.

Question tests that only verify:

- Standard-library or framework behavior.
- A constructor assigning its arguments.
- Private collection choices without an observable contract.
- Incidental ordering callers cannot observe.
- Error wording beyond the meaningful diagnostic.
- Implementation details already enforced by types or compilation.

Simple behavior is not automatically trivial. Keep the cheapest test that protects a meaningful contract.

## Redundancy and Assertion Strength

Compare each test with existing coverage. Flag a test when a stronger test already exercises the same input, path, failure mode, and assertions.

Prefer the test that:

1. Proves the behavior at the appropriate boundary.
2. Catches more realistic regressions.
3. Has less setup and runtime cost.
4. Produces clearer failures.

When tests partially overlap, preserve both only if each catches a distinct plausible regression. State that distinction explicitly.

Check that assertions prove the test's name and intent. Look for:

- Assertions that pass under both correct and incorrect behavior.
- Priority, ordering, retry, or cleanup tests whose setup never makes that behavior decisive.
- Length-only assertions when identity or order is the contract.
- Multiple assertions that merely restate one fact.
- Broad “no error” assertions when a specific outcome is available.
- Snapshots where a focused assertion would express the contract better.

Prefer observable outcomes over internal intermediate state unless the internal invariant is itself the contract.

## Determinism

Treat time and scheduling as inputs that should be controlled.

Flag:

- `sleep` used for synchronization.
- `yield` used to assume another task has started.
- Short timeouts used to prove something remains blocked.
- Notifications sent before proving the waiter is registered.
- Assertions dependent on thread scheduling or completion order.
- Unseeded randomness, wall-clock time, shared ports, or global state.
- Ordered assertions over hash-based or otherwise unordered collections.
- Background tasks that can escape the test or affect later tests.

When nondeterminism is found, use this order:

1. Reconsider whether the test protects enough value to exist.
2. Check whether a stronger existing test already covers the behavior.
3. Test through a simpler synchronous seam when one already exists.
4. Reuse an existing observable signal or state transition.
5. If coordination and logic are unnecessarily coupled, recommend a small production refactor that separates them. Do not perform it without authorization.
6. Only for behavior that is inherently concurrent and worth testing, use the smallest synchronization primitive already available.

Do not automatically add barriers, channels, custom schedulers, test hooks, or coordination helpers. If making a test deterministic requires scaffolding disproportionate to the behavior, recommend deleting, merging, or redesigning the test instead.

A timeout may remain as a generous watchdog when the contract is “must not hang” and no deterministic completion signal exists. Do not use the timeout itself as synchronization.

## Maintenance Cost

Look for opportunities to reduce setup without hiding intent:

- Repeated construction of contexts, fixtures, graphs, or other expensive objects.
- Helpers rebuilding an object once per item instead of once per test case.
- Manual construction that bypasses the production entrypoint being tested.
- Spawn, clone, and join scaffolding that direct observation can replace.
- Helpers with one caller or abstractions larger than their call sites.
- Table-driven tests that obscure a few simple cases.

Do not introduce a helper merely because two blocks look similar. A helper should remove meaningful noise across several callers or establish a clearer testing boundary.

## Workflow

1. Inventory the tests and record each stated behavior.
2. Trace the production path each test exercises.
3. Search for existing tests covering the same behavior.
4. Apply the value, redundancy, assertion, determinism, and maintenance lenses.
5. Run the affected tests when practical, remembering that passing does not establish value.
6. Report only actionable findings supported by concrete evidence.

Do not modify code during a review unless the user explicitly asks for changes.

## Findings

Order findings by impact:

1. False confidence: the test does not prove its stated behavior.
2. Nondeterminism or flakiness.
3. Redundant coverage.
4. Excessive setup or maintenance cost.
5. Smaller clarity improvements.

Use this format:

`file:line — <delete|merge|strengthen|determinize|shrink>: <problem>. <replacement or retained coverage>.`

When reviewing all tests in scope, briefly summarize which remaining behaviors earn their coverage. Estimate removable lines only when grounded in a concrete replacement.

If there are no actionable findings, say:

`The tests are distinct, deterministic, and proportionate. Keep them.`

## Boundaries

- Do not recommend deleting the only smoke test for non-trivial logic.
- Do not simplify away security, data-integrity, cancellation, or hang-prevention coverage.
- Use the cheapest test layer that proves the contract; do not automatically prefer unit or end-to-end tests.
- Do not flag deliberate watchdog timeouts without identifying a deterministic replacement or acknowledging their purpose.
- Do not recommend a production refactor solely for test convenience unless it also clarifies a real responsibility or state transition.
- Keep review findings separate from unrelated production correctness issues.
