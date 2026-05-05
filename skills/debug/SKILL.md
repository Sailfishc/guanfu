---
name: debug
preamble-tier: 3
version: 1.0.0
description: |
  Use when the user explicitly invokes /debug, asks for deep bug diagnosis, or has a reproducible failure that normal implementation, QA, or review workflows did not resolve. Do not use for routine feature work, shipping, QA sweeps, or general code review.
allowed-tools:
  - Bash
  - Read
  - Grep
  - Glob
  - Write
  - Edit
  - Agent
  - AskUserQuestion
  - WebSearch
triggers:
  - /debug
  - deep debug
  - diagnose this bug
  - root cause
  - why is this broken
---

# Debug: Deep Bug Diagnosis

This is a special-scenario skill. It is not part of the normal product development flow.

Use it when the user needs root-cause diagnosis, not when they merely need implementation, QA, review, or shipping.

## Boundary

Do not invoke this skill during normal `/brainstorm`, `/plan`, `/implement`, `/qa`, `/review`, or `/ship` unless the user explicitly asks for `/debug` or a prior workflow is blocked by a bug that needs deeper diagnosis.

This skill produces evidence first. Fixes are optional and gated.

## Core rules

1. Reproduce before reasoning. No root cause claim without a failing command, log, trace, screenshot, or data sample.
2. Separate symptom from cause. The visible error is usually the last domino, not the first.
3. Keep a hypothesis ledger. Every theory must have evidence, a falsification test, and a current status.
4. Minimize the repro. Shrink the bug until one command, one request, one fixture, or one input demonstrates it.
5. Do not patch symptoms. A passing test without a causal explanation is not done.
6. If implementing a fix, use `test-driven-development`: write a regression test, watch it fail, then patch.

## Workflow

Copy this checklist and update it as you work:

```text
Debug Progress:
- [ ] 0. Scope and safety snapshot
- [ ] 1. Reproduce the bug
- [ ] 2. Classify the failure
- [ ] 3. Build and test hypotheses
- [ ] 4. Prove root cause
- [ ] 5. Propose fix options
- [ ] 6. Optional fix with regression test
- [ ] 7. Final diagnostic report
```

### 0. Scope and safety snapshot

Run or inspect:

```bash
git status --short
git branch --show-current
git log --oneline -10
```

Capture:

- User-visible failure
- Expected behavior
- Actual behavior
- Exact command, route, page, input, or workflow that fails
- Recent changes likely related to the failure
- Any destructive operation needed to reproduce it

If reproducing the bug requires destructive data changes, production credentials, or access the user did not grant, stop and ask.

### 1. Reproduce the bug

Find the smallest reliable reproduction.

Good reproductions:

- `npm test path/to/failing.test.ts`
- `curl -i http://localhost:3000/api/foo -d @fixture.json`
- `bin/test-lane test/models/order_test.rb:42`
- Browser steps with exact page, action, and observed result

If the failure is flaky, run the repro multiple times and record the rate:

```bash
for i in {1..10}; do <command> || echo "failed on run $i"; done
```

Do not move to root cause until the failure is observed or the inability to reproduce is itself documented.

### 2. Classify the failure

Classify the likely failure family before reading broadly:

| Family | Evidence to look for |
|---|---|
| Logic bug | Wrong branch, missing case, inverted condition, bad invariant |
| Data bug | Unexpected null, bad fixture, migration drift, stale cache |
| Contract bug | Caller and callee disagree on shape, type, status, encoding |
| State bug | Race condition, stale state, ordering issue, lifecycle mismatch |
| Environment bug | Version mismatch, missing env var, path, permissions, network |
| Test bug | Mock lies, bad setup, async not awaited, assertion tests wrong thing |
| Integration bug | API change, dependency behavior, service unavailable, auth boundary |

State the classification as a hypothesis, not a conclusion.

### 3. Build and test hypotheses

Maintain this ledger in your notes and final report:

```markdown
| # | Hypothesis | Evidence for | Test to falsify | Result | Status |
|---|---|---|---|---|---|
| H1 | ... | ... | ... | ... | open/ruled out/proven |
```

Use narrowing tactics:

- Read the call path from failing edge inward.
- Compare last known good behavior with current behavior.
- Inspect recent diffs touching the failing path.
- Add temporary logging only when it will distinguish between two hypotheses.
- Prefer one precise probe over broad scanning.
- For external libraries or APIs, use official docs or source before guessing.

Remove temporary logging before any final fix.

### 4. Prove root cause

A root cause is proven only when all three are true:

1. You can explain the causal chain from trigger to failure.
2. You can show the smallest code path, data shape, or state transition that causes it.
3. You can explain why the main alternative hypotheses are wrong.

Use this format:

```markdown
ROOT CAUSE:
<one sentence>

CAUSAL CHAIN:
1. <trigger>
2. <code/data/state transition>
3. <why it produces the observed failure>

EVIDENCE:
- <file:line or command output>
- <file:line or command output>

RULED OUT:
- <hypothesis> because <evidence>
```

### 5. Propose fix options

Before editing code, present 2 or 3 fix options when more than one reasonable fix exists:

```markdown
FIX OPTIONS:
A) Minimal patch
   Scope: <files>
   Risk: Low/Medium/High
   Pros: ...
   Cons: ...

B) Correct boundary fix
   Scope: <files>
   Risk: Low/Medium/High
   Pros: ...
   Cons: ...

RECOMMENDATION: Choose <A/B> because <reason tied to user impact>.
```

If there is only one safe fix, say so and explain why.

### 6. Optional fix with regression test

Only implement when the user asked for a fix or approved the recommendation.

Required sequence:

1. Write a regression test that fails for the reproduced bug.
2. Run the test and verify it fails for the expected reason.
3. Apply the smallest fix that addresses the proven cause.
4. Run the regression test and the nearest relevant suite.
5. Remove temporary probes and debug logs.
6. Run final verification.

Never claim the bug is fixed without fresh verification after the code changed.

### 7. Final diagnostic report

End with one of these statuses:

- `DONE` if root cause is proven and fix is verified.
- `DONE_DIAGNOSED` if root cause is proven and fix is not implemented.
- `DONE_WITH_CONCERNS` if the diagnosis is strong but some risk remains.
- `BLOCKED` if reproduction or required access is unavailable.

Report template:

```markdown
STATUS: DONE | DONE_DIAGNOSED | DONE_WITH_CONCERNS | BLOCKED

BUG:
<user-visible failure>

REPRODUCTION:
<exact command or steps>

ROOT CAUSE:
<one sentence>

EVIDENCE:
- <specific evidence>
- <specific evidence>

FIX:
<implemented fix or recommended fix>

VERIFICATION:
- <command>: <result>

USER IMPACT:
<what users experienced and why this fix matters>

REMAINING RISKS:
<any uncertainty or follow-up>
```

## Stop conditions

Stop and ask when:

- The bug cannot be reproduced and the next step would be speculative.
- The fix changes public behavior beyond the reported bug.
- The fix touches auth, billing, data deletion, migrations, or security-sensitive paths.
- The diagnosis depends on production-only data or credentials.
- Three distinct attempts failed to narrow the cause.

## Common mistakes

| Mistake | Better move |
|---|---|
| Fixing the first suspicious line | Reproduce, then prove why that line causes the failure |
| Reading the whole repo | Trace the failing path first |
| Adding logs everywhere | Add one probe that separates two hypotheses |
| Calling a test bug a product bug | Validate the test setup and mock realism |
| Shipping without regression test | Add the failing test first, then fix |
