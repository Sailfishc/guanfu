---
name: ce-work
description: Use when implementing an approved active Compound Engineering plan slice in an existing repository.
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
  - /ce-work
  - implement slice
  - start work
  - work on plan
  - execute plan
---

# CE Work

## Overview

Implement exactly one active plan slice at a time, update the living plan, and leave fresh verification evidence.

Core principle: execution should be small because planning did the heavy lifting.

## Hard Gate

Do not start without an approved `docs/ce/plans/*-plan.md` whose `Status` is `ACTIVE`.

Do not work on multiple slices at once unless the plan explicitly says they are inseparable.

## Required Artifact

`ce-work` does not create a separate work doc. It updates the active plan document:

```text
docs/ce/plans/YYYY-MM-DD-<slug>-plan.md
```

Every work session appends to `## Work Log` and updates slice status.

## Workflow

### 1. Load active plan and compound memory

```bash
find docs/ce/plans -type f -name '*-plan.md' 2>/dev/null | sort | tail -20
find docs/ce/compound -type f -name '*.md' 2>/dev/null | sort | tail -20
find docs/ce/adr -type f -name '*.md' 2>/dev/null | sort | tail -20
```

Read:

- Active plan
- Related ADRs
- Relevant compound notes
- `AGENTS.md` and `CLAUDE.md` if present

If no active plan exists, stop and recommend `ce-plan`.

### 2. Select exactly one slice

If `Active Slice` is `none`, choose the first `TODO` slice unless the user named another.

Update plan:

```markdown
Active Slice: S<n>

### Slice S<n>: <name>
Status: ACTIVE
```

If a slice is blocked by an open question, ask before coding.

### 3. Run test-first implementation for behavior changes

For new behavior, bug fixes, or refactors, use TDD:

1. Write or update the smallest failing test that expresses the slice outcome.
2. Run only that test and verify it fails for the expected reason.
3. Implement the smallest code change to pass.
4. Re-run targeted tests.
5. Run the slice verification command from the plan.

If the project lacks a test harness, create a minimal verification path and record the limitation in the plan. Do not pretend manual checks are equivalent to automated tests.

### 4. Keep scope locked

Allowed:

- Files named in the slice.
- Small adjacent files required by the discovered code path.
- Tests and docs needed to verify the slice.

Not allowed without updating the plan:

- New feature ideas.
- Large refactors.
- Hidden API changes.
- New dependencies.
- Touching unrelated files.

If scope drift is useful, stop and update the plan before continuing.

### 5. Update the work log

Append after meaningful progress:

```markdown
### <ISO timestamp> - Slice S<n>
Changed:
- <file>: <what changed>
Tests:
- `<command>` - PASS | FAIL | NOT RUN, <reason>
Decisions:
- <decision or none>
Surprises:
- <unexpected finding or none>
Next:
- <next action>
```

### 6. Complete the slice

Only mark a slice completed when all are true:

- Exit criteria satisfied.
- Verification command run after the final code change.
- Plan work log has evidence.
- Any new decision is captured inline or in an ADR.
- No known failing targeted tests.

Update:

```markdown
Active Slice: none

### Slice S<n>: <name>
Status: COMPLETED
Review notes:
- Ready for ce-review, or <specific concern>
```

If all slices are completed, set:

```markdown
Status: COMPLETED
```

Otherwise leave the plan `ACTIVE`.

### 7. Handoff to review

After a completed slice or completed plan, recommend `ce-review`.

## Common Mistakes

| Mistake | Fix |
|---|---|
| Implementing two slices because they are nearby | Finish one, verify it, mark it complete, then start the next. |
| Changing plan silently after coding | Update the plan before or immediately when scope changes. |
| Claiming done without fresh verification | Run the command after the final change. |
| Writing tests after code | For behavior changes, write the failing test first. |
| Treating the plan as stale paperwork | The plan is the harness. Keep it current or future agents lose state. |

## Completion

Report:

```text
STATUS: DONE | BLOCKED | DONE_WITH_CONCERNS
PLAN: <path>
SLICE: S<n>
VERIFICATION: <commands and results>
NEXT: ce-review or next ce-work slice
```
