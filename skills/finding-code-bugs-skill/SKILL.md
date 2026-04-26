---
name: finding-code-bugs
description: Use when investigating code bugs, broken behavior, crashes, failing tests, regressions, flaky behavior, suspicious diffs, or requests to find likely defects in a codebase.
---

# Finding Code Bugs

## Core Principle

Bug investigation is evidence construction, not guessing.

A professional bug hunt makes the behavior concrete, reproduces it or explains why it cannot yet be reproduced, isolates the root cause with code evidence, applies the smallest safe fix, then verifies with fresh evidence.

Finding bugs is a high-complexity engineering task. Treat the workflow below as a guardrail, not a script. The goal is not to look busy. The goal is to prove what is broken.

## Hard Rules

1. **No fix before a clear problem statement and a reproduction strategy.**
   - A full repro is best.
   - A credible unreproduced hypothesis is acceptable only if clearly labeled.

2. **No root-cause claim without evidence.**
   - Evidence means a failing test, stack trace, log, traced execution path, narrowed diff, or specific file/function behavior.

3. **No “done” without fresh verification.**
   - Re-run the original repro after the fix.
   - Run the smallest relevant automated suite.
   - For intermittent bugs, one pass is not enough.

4. **Do not broaden the fix unless the evidence demands it.**
   - Bug fixes should be small and targeted.
   - Refactors are allowed only when they reduce the bug surface being fixed.

5. **Regression coverage is the default.**
   - If production code changes, add or update a test that fails before the fix and passes after it.
   - If a test is impossible, document why and provide manual verification steps.

## Problem Statement vs Reproduction First

Use this decision gate before touching code.

| Situation | Start with | Why |
|---|---|---|
| User gives vague symptoms: “something is broken”, “it sometimes fails”, “find the bug” | Problem statement first | Otherwise you may solve the wrong problem. |
| User gives exact expected/actual behavior plus steps, logs, or failing test | Reproduction first | The fastest way to understand the bug is to watch it fail. |
| High-impact bug: data loss, auth, billing, security, migrations | Problem statement first, then repro | You need scope and blast radius before changing code. |
| Intermittent/flaky behavior | Problem statement first | You need frequency, environment, timing, and randomness controls. |
| Suspicious code/diff with no user-visible symptom | Bug-hunt audit first | Treat findings as candidates until reproduced or proven. |
| Existing failing automated test | Reproduction first | The failing test already defines the bug boundary. |

**Default tradeoff:** use a hybrid. Write a short Problem Card, then immediately attempt a reproducer. Do not spend a long time polishing the description if code or tests can answer the missing details.

## Problem Card

Before investigation, write this in your notes or response:

```markdown
## Problem Card
Problem: [one sentence]
Expected: [what should happen]
Actual: [what happens instead]
Repro target: [automated test | command | manual flow | log-triggered event]
Scope: [affected user, module, route, feature, environment]
Impact: [crash, wrong data, data loss, performance, UX, unknown]
Known facts: [logs, stack traces, recent changes, user report]
Unknowns blocking repro: [only include real blockers]
```

If unknowns block reproduction and cannot be answered from the repo, ask the user at most three focused questions. If the answer can be found by reading code, tests, logs, or recent diffs, inspect those instead of asking.

## Workflow

### 1. Triage the report

- Restate the bug using the Problem Card.
- Identify the boundary where the bug is visible: UI screen, API endpoint, CLI command, test, worker, data pipeline, or integration.
- Decide whether this is:
  - a concrete bug report,
  - a failing test,
  - an intermittent bug,
  - a broad bug hunt,
  - or a code-review-for-bugs request.

### 2. Gather evidence without flooding context

Start at the symptom boundary and walk inward.

Good first reads:
- Exact error message or stack trace.
- The failing test file.
- The route, command, handler, component, service, or job that exposes the behavior.
- Recent diffs or commits touching that area.
- Nearby tests that define expected behavior.
- Relevant docs or contracts.

Search strategy:
- Search exact strings first: error text, route path, label, event name, test name.
- Read one caller and one callee hop before expanding.
- Prefer the smallest execution path that explains the symptom.
- Avoid scanning the whole repository unless the bug is truly cross-cutting.

### 3. Reproduce the bug

Prefer reproducibility in this order:

1. Existing failing automated test.
2. New minimal failing test around the behavior.
3. Minimal script or command that fails.
4. Manual steps with exact inputs, environment, and observed output.
5. Log-triggered reproduction when the bug only appears in production-like systems.

For a new regression test:
- Test behavior, not implementation details.
- Make the test name describe the bug.
- Run it and confirm it fails for the expected reason.
- If it passes immediately, the test is not reproducing the bug.

For unreproduced bugs:
- Report what you tried.
- State what evidence is missing.
- Add targeted probes or logging if useful.
- Do not silently patch a guessed cause.

### 4. Build and falsify hypotheses

List the top hypotheses, then disprove them quickly.

```markdown
Hypothesis 1: [possible cause]
Evidence for: [fact]
Fast falsification: [test/read/log/check]
```

Use these isolation tools when appropriate:
- Narrow by input: empty, null, boundary value, duplicate, out-of-order, expired, missing permission.
- Narrow by time: last known good, recent commits, `git bisect` if regression history is available.
- Narrow by path: compare working path vs broken path.
- Add temporary logging or assertions, then remove them before finalizing unless they are intentionally permanent diagnostics.
- For concurrency or timing bugs, run repeated/stress tests and control randomness, clocks, seeds, and async scheduling where possible.

### 5. Isolate root cause

A root cause statement must name the mechanism.

Good:
```markdown
Root cause: `OrderSummary` assumes `discountCents` is always present, but the API omits it for legacy orders. The render path then computes `subtotal - undefined`, producing `NaN`.
Evidence: failing test `renders legacy order without discount`; API fixture lacks `discountCents`; stack trace enters `OrderSummary.formatTotal`.
```

Bad:
```markdown
Root cause: frontend bug.
```

### 6. Fix the bug

- Make the smallest change that repairs the root cause.
- Preserve public interfaces unless the interface is the bug.
- Prefer fixing the invariant near the source, not papering over symptoms at every caller.
- Do not bundle unrelated cleanup.
- If the codebase is hard to test because the relevant module is shallow or tangled, extract only the seam needed to test the behavior.

For production outages:
- If the user explicitly needs mitigation, apply the safest reversible mitigation first.
- Label it as mitigation, not root-cause completion.
- Follow with a root-cause fix and regression coverage.

### 7. Verify freshly

Minimum verification:
- Original reproducer now passes.
- Regression test fails before the fix and passes after the fix, when feasible.
- Nearby relevant tests pass.
- Build/typecheck/lint pass when relevant to the changed area.
- No new warnings, noisy logs, or skipped tests introduced.

For intermittent bugs:
- Run the reproducer multiple times.
- Record the run count, seed, and environment when possible.
- Do not claim certainty if the test only reduces probability.

### 8. Report the result

Use this template:

```markdown
STATUS: DONE | DONE_WITH_CONCERNS | BLOCKED | NEEDS_CONTEXT

PROBLEM
[Clear expected vs actual behavior]

REPRODUCTION
[Command/test/manual steps and observed failure]

ROOT CAUSE
[Mechanism with code evidence]

FIX
[Small description of changed behavior]

VERIFICATION
[Commands/tests/manual checks with results]

REGRESSION COVERAGE
[Test added/updated, or why not possible]

RISKS / FOLLOW-UPS
[Any remaining uncertainty, edge cases, or recommended next issue]
```

## Broad Bug-Hunt Mode

Use when the user asks “find bugs in this code” without a specific symptom.

1. Define the audit scope: current diff, module, feature, failing area, or whole repo.
2. Run low-cost feedback loops if available: tests, typecheck, lint, build.
3. Inspect high-risk areas first:

| Risk area | What to look for |
|---|---|
| Input boundaries | null, empty, missing fields, malformed data, duplicate IDs |
| State transitions | impossible states, stale state, forgotten reset, double submit |
| Async/concurrency | race condition, cancellation, out-of-order response, unawaited promise |
| Persistence | migration mismatch, partial write, transaction boundary, stale cache |
| Auth/permissions | user can access another user’s data, missing ownership check |
| Time/date | timezone, daylight saving, expiry, clock skew, inclusive/exclusive ranges |
| Error handling | swallowed errors, retry loops, misleading success state |
| Collections | off-by-one, first/last item, empty list, pagination cursor |
| Resource lifecycle | file handles, subscriptions, timers, event listeners, memory leak |
| External contracts | API schema drift, backward compatibility, missing feature flag |

4. For every candidate, output:

```markdown
Candidate bug: [one sentence]
Evidence: [file/function/path/test/log]
Repro idea: [how to prove it]
Severity: Critical | High | Medium | Low
Confidence: High | Medium | Low
Recommended next step: [test, inspect, fix, or ask user]
```

Do not call a candidate a confirmed bug until it has evidence strong enough to reproduce or prove the broken invariant.

## Intermittent / Flaky Bug Protocol

Intermittent bugs need probability management.

- Capture environment: OS, runtime, browser, seed, clock, database, network, feature flags.
- Run the suspected reproducer repeatedly before the fix to estimate failure frequency.
- Add observability around ordering, timing, retries, and state transitions.
- Prefer deterministic control: fake timers, seeded randomness, mocked clock, controlled scheduler, local test server.
- After the fix, run enough repetitions to make the result meaningful.
- Report remaining uncertainty honestly.

## Code Review for Bugs

Use this when reviewing a diff for defects rather than fixing immediately.

Review in this order:
1. Changed behavior vs stated requirement.
2. New or changed inputs.
3. Error paths and edge cases.
4. Cross-file contracts.
5. Tests: do they fail on the old behavior and cover the new behavior?
6. User impact.

Finding format:

```markdown
[SEVERITY] [file:line] Problem
Why it matters: [user-visible impact]
Evidence: [specific code path or missing case]
Repro/test: [how to expose it]
Fix direction: [smallest safe fix]
```

Severity guide:
- **Critical:** data loss, security, privacy, billing, migration breakage, production crash.
- **High:** common user path broken, regression, impossible recovery, major correctness issue.
- **Medium:** edge case broken, misleading state, missing validation, likely support issue.
- **Low:** minor correctness or maintainability issue with limited impact.

## Common Mistakes

| Mistake | Correction |
|---|---|
| “The code looks suspicious, so it is the bug.” | Suspicion is a hypothesis. Prove it with a repro or invariant violation. |
| “The fix is obvious.” | Obvious fixes still need a failing test or concrete reproduction. |
| “Tests pass, so it is fixed.” | Only relevant tests count. A suite can pass while the bug remains uncovered. |
| “I cannot reproduce it, so there is no bug.” | Report attempted repros and missing evidence. Intermittent bugs often require instrumentation. |
| “I changed several layers to be safe.” | Broad fixes create new bugs. Change the layer where the invariant belongs. |
| “One manual check passed.” | Acceptable for simple UI bugs, not for flaky, data, auth, billing, or migration bugs. |
| “I added logging, done.” | Logging is observability, not a fix, unless the bug was missing diagnostics by definition. |

## Stop Conditions

Stop and ask for context when:
- Reproduction requires credentials, private data, or an environment you cannot access.
- The expected behavior is a product decision, not inferable from code or tests.
- Multiple incompatible fixes are plausible and would change user-facing behavior.
- The investigation touches destructive operations: migrations, deletes, payments, production data.

Do not stop just because the bug is complex. Narrow it, document evidence, and keep going until one of the stop conditions is real.
