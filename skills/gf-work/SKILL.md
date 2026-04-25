---
name: gf-work
version: 0.2.0
description: Use when implementing an approved active GuanFu plan slice in an existing repository.
allowed-tools:
  - Read
  - Grep
  - Glob
  - Write
  - Edit
  - Bash
  - AskUserQuestion
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

Implement exactly one active plan slice at a time, update the living plan, and leave fresh verification evidence.

Core principle: execution should be small because planning did the heavy lifting.

## Hard Gate

Start from an approved `docs/guanfu/plans/*-plan.md` whose `Plan Status` is `ACTIVE`.

Work on one active slice at a time. Scope expansion goes back into the plan before implementation.

## Required Artifact

`gf-work` updates the active plan document:

```text
docs/guanfu/plans/YYYY-MM-DD-<slug>-plan.md
```

It creates code and test changes as required by the active slice.

## Workflow

### 1. Load current plan

Read:

```bash
find docs/guanfu/plans -type f -name '*-plan.md' 2>/dev/null | sort | tail -20
find docs/guanfu/compound -type f -name '*.md' 2>/dev/null | sort | tail -20
find docs/guanfu/adr -type f -name '*.md' 2>/dev/null | sort | tail -20
```

Confirm:

- `Plan Status: ACTIVE`
- exactly one `Active Slice`
- the active slice has verification commands
- relevant compound notes have been considered

### 2. Check slice readiness

If the active slice lacks clear scope, tests, or exit criteria, stop and route to `gf-plan` or `gf-doc-review`.

### 3. Follow test-first implementation

For behavior changes:

1. write or update the failing test
2. run it and capture expected failure
3. implement minimal code
4. run the focused test
5. run broader verification from the plan

Record commands and outcomes in `## Work Log`.

### 4. Keep scope bounded

Allowed work:

- files listed in the active slice
- direct dependencies needed for the slice
- tests and docs required for the slice

If a new task appears, add it as a new slice or ask the user.

### 5. Update living plan

When work begins:

```markdown
## Work Log

- <timestamp>: Started S1. Intent: ...
```

When work completes:

```markdown
### Slice S1: <name>
Status: COMPLETED

#### Completion evidence
- Test: `<command>` -> PASS
- Files changed: ...
- Notes: ...
```

Update `Active Slice` to the next slice or `none`.

### 6. Handoff to review

After completion, recommend:

```text
NEXT: gf-code-review
```

## Common Mistakes

| Mistake | Fix |
|---|---|
| Coding from chat context | Read the plan and update it. |
| Working multiple slices | Finish one slice and mark evidence. |
| Skipping the failing test | Write and run the failing test first for behavior changes. |
| Claiming completion from confidence | Record fresh verification output. |
| Expanding scope silently | Update the plan first. |

## Completion

Report:

```text
STATUS: DONE | DONE_WITH_CONCERNS | NEEDS_CONTEXT | BLOCKED
PLAN_UPDATED: docs/guanfu/plans/YYYY-MM-DD-<slug>-plan.md
SLICE: S1 COMPLETED | BLOCKED
VERIFICATION: <commands and results>
NEXT: gf-code-review | next gf-work slice
```
