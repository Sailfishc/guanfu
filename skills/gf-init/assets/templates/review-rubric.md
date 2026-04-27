# GuanFu Review Rubric

## Harness Principle

Before execution: discuss deeply through brainstorm and plan. During execution: follow the approved plan automatically. After execution: review, compound, and evolve.

## Code Review

- Spec compliance: implementation matches the active plan slice.
- Correctness: edge cases, errors, retries, empty states, concurrency, data loss.
- Verification freshness: commands ran after final code changes.
- Tests: meaningful assertions, failure modes covered, focused mocks.
- Architecture: clear boundaries, low coupling, explicit state, reversible decisions.
- Security and trust: auth, permissions, injection, secrets, unsafe output, data exposure.
- Taste: smaller API, simpler names, fewer moving parts, readable future diffs.

## Document Review

- Documents provide enough context for a fresh agent to continue.
- Active and completed states are explicit.
- Slices have tests, verification commands, rollback, and exit criteria.
- ADR exists for high-reversal-cost choices.
- Open questions are real blockers with owners or resolution paths.

## Evolution Review

- Failure behavior is concrete.
- Expected behavior is observable.
- The proposed patch changes the smallest necessary surface.
- A pressure scenario exists before the skill update lands.
- Retest result is recorded.
