---
name: gf-work
version: 0.3.0
description: Use when implementing an approved active GuanFu plan slice in an existing repository after the user has approved the plan.
allowed-tools:
  - Read
  - Grep
  - Glob
  - Write
  - Edit
  - Bash
  - Agent
triggers:
  - /gf-work
  - implement slice
  - start work
  - work on plan
  - execute plan
---

# gf-work

## Overview

Implement exactly one active plan slice, update the living plan, and leave fresh verification evidence.

Core principle: after plan approval, execution is automatic. Do the planned work, record anomalies, verify, then continue directly to review.

## Harness Position

`gf-work` is part of the automated execution chain:

```text
gf-work -> gf-code-review -> gf-doc-review -> gf-compound -> gf-evolve when needed
```

Do not ask the user mid-execution. When reality differs from the plan, record it in the plan's `Anomaly Log`, make the smallest safe decision, and let review/compound/evolve calibrate the process afterward.

## Hard Gate

Start from an approved `docs/guanfu/plans/*-plan.md` whose `Plan Status` is `ACTIVE` and `Execution Mode` is `AUTOMATED_AFTER_PLAN` or equivalent.

Work on one active slice. Scope expansion becomes a new TODO slice or a review finding.

## Required Artifact

`gf-work` updates the active plan document:

```text
docs/guanfu/plans/YYYY-MM-DD-HHMM-<slug>-plan.md
```

It may create code, tests, and local docs required by the active slice.

## Workflow

### 1. Load active context

Run:

```bash
find docs/guanfu/plans -type f -name '*-plan.md' 2>/dev/null | sort | tail -30
find docs/guanfu/compound -type f -name '*.md' 2>/dev/null | sort | tail -80
find docs/guanfu/adr -type f -name '*.md' 2>/dev/null | sort | tail -40
git status --short 2>/dev/null || true
git log --oneline -20 2>/dev/null || true
```

Read the active plan, related brainstorm, ADRs, and relevant compound notes.

### 2. Work Entry Check

Print before editing:

```markdown
## Work Entry Check

Plan: <path>
Plan Status: ACTIVE | PAUSED | COMPLETED | ABANDONED | UNKNOWN
Execution Mode: AUTOMATED_AFTER_PLAN | UNKNOWN
Active Slice: <slice id or none>
Multiple Active Plans Found: yes/no
Decision: WORK | RETURN_TO_PLAN | BLOCKED
Reason: <one sentence>
```

Rules:

- `WORK` only when one active plan and one active slice are clear.
- `RETURN_TO_PLAN` when slice scope, exit criteria, or verification is too vague for safe implementation.
- `BLOCKED` when repo state or tooling prevents work. Write a blocked entry and continue to `gf-code-review` or `gf-compound` only if there is useful evidence.

### 3. Retrieve relevant compound notes

Use the active slice's files, APIs, keywords, risk areas, and review focus to match `docs/guanfu/compound/index.md` and specific notes. Record:

```markdown
## Compound Notes Considered
- <path>: <rule applied>
```

### 4. Start the slice

Update the plan before code changes:

```markdown
## Implementation Log

### <ISO timestamp> - gf-work start
Slice: S<n>
Intent: <one sentence>
Compound notes considered:
- <path>
```

### 5. Follow test-first execution

For behavior changes:

1. write or update the focused test
2. run it and capture expected RED result
3. implement minimal code
4. run focused verification
5. run slice verification commands
6. run broader verification if the plan requires it

If no automated test is suitable, record the reason and use the plan's observable verification.

### 6. Keep scope bounded

Allowed work:

- files listed in the active slice
- direct dependencies required for the slice
- tests and docs required for the slice
- minimal plan updates that document actual execution

Unexpected work handling:

```markdown
## Anomaly Log

### <ISO timestamp>
Observed: <what differed from the plan>
Decision: <smallest safe action taken>
Future handling: review | compound | evolve | new slice
```

Use this rule:

| Situation | Action |
|---|---|
| Minor implementation detail differs | Record anomaly and continue. |
| Additional small support change is required | Do it, record reason, review later. |
| New feature or broad refactor appears | Add TODO slice, keep current slice focused. |
| Verification fails | Fix within current slice when cause is in scope. Record evidence. |
| Unsafe or destructive uncertainty appears | Stop code changes, mark slice BLOCKED, route evidence to review/compound. |

### 7. Fresh Verification Check

Before marking completed, print and write into the plan:

```markdown
## Fresh Verification Check

Last code change: <git diff summary or timestamp>
Verification command: `<command>`
Verification ran after final code change: yes/no
Result: PASS | FAIL | SKIPPED
Covers Exit Criteria: yes/no
Decision: MARK_COMPLETED | KEEP_ACTIVE | BLOCKED
```

A slice reaches `COMPLETED` only when verification ran after the final code change and covers the exit criteria.

### 8. Update living plan

On completion:

```markdown
### Slice S<n>: <name>
Status: COMPLETED

#### Completion Evidence
- Command: `<command>`
- Result: PASS
- Ran after final code change: yes
- Output summary: <concise excerpt>
- Files changed: <paths>
- Anomalies: <none or links>
```

Then set `Active Slice` to the next TODO slice or `none`.

### 9. Continue to review

Immediately continue to:

```text
NEXT: /gf-code-review
```

Do not wait for approval between work and review.

## Common Mistakes

| Mistake | Fix |
|---|---|
| Coding from chat context | Read and update the active plan. |
| Working multiple slices | Finish one active slice and record evidence. |
| Stopping to ask about minor deviations | Record anomaly and continue. |
| Claiming completion from confidence | Record fresh verification output. |
| Reusing stale test output | Run verification after final code change. |
| Losing a process failure | Add compound/evolve trigger in the plan. |

## Completion

Report:

```text
STATUS: DONE | DONE_WITH_CONCERNS | BLOCKED
PLAN_UPDATED: docs/guanfu/plans/YYYY-MM-DD-HHMM-<slug>-plan.md
SLICE: S<n> COMPLETED | BLOCKED | ACTIVE
VERIFICATION: <commands and results>
ANOMALIES: <count and summary>
NEXT: /gf-code-review
```
