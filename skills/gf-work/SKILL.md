---
name: gf-work
description: Use when implementing an approved active GuanFu plan slice in an existing repository.
---


# gf-work

## Purpose

Implement exactly one active plan slice, update the living plan, and leave fresh verification evidence.

After plan approval, execution is autonomous. Do the work, record assumptions, verify, then hand off to review.

## Autonomous contract

Continue without routine prompts. When the plan is imperfect, choose the smallest safe interpretation consistent with the approved goal, record the assumption, and surface it in review.

Stop only for destructive or irreversible external action, missing credentials, legal/compliance/security ambiguity requiring human authority, or architecture conflict that invalidates the approved goal.

## Work entry check

Load plans, compound notes, ADRs, and recent reviews:

```bash
find docs/guanfu/plans -type f -name '*-plan.md' 2>/dev/null | sort | tail -30
find docs/guanfu/compound -type f -name '*.md' 2>/dev/null | sort | tail -50
find docs/guanfu/adr -type f -name '*.md' 2>/dev/null | sort | tail -30
find docs/guanfu/reviews -type f -name '*.md' 2>/dev/null | sort | tail -30
git status --short 2>/dev/null || true
```

Output:

```markdown
## Work Entry Check
Plan: <path>
Plan Status: ACTIVE | PAUSED | COMPLETED | ABANDONED | UNKNOWN
Plan Approval: APPROVED | DRAFT | UNKNOWN
Execution Mode: AUTOMATED_AFTER_PLAN | DISABLED | UNKNOWN
Active Slice: <slice id or none>
Multiple Active Plans Found: yes/no
Decision: WORK | MARK_BLOCKED | RETURN_TO_PLAN
```

Rules:

- `Plan Approval: APPROVED` and `Execution Mode: AUTOMATED_AFTER_PLAN` are required for normal work.
- Multiple active plans -> choose the one matching the user request or most recent approved plan, then record the choice.
- Missing active slice -> mark plan blocked and route to `/gf-doc-review`.

## Load relevant compound memory

Read `docs/guanfu/compound/index.md` first. Load notes whose keywords, files, areas, or owner skill match the active slice.

Append to the plan:

```markdown
## Relevant Compound Notes
- <path>: <lesson applied>
```

## Start the slice

Append:

```markdown
### <ISO timestamp> - gf-work started <slice>
Assumptions:
- <assumption or none>
Relevant compound notes:
- <path or none>
```

## Test-first implementation

For behavior changes:

1. write or update the failing test
2. run it and capture expected failure
3. implement minimal code
4. run focused test
5. run broader verification from the plan

For docs/config/process changes, create a concrete verification check.

## Scope control

Allowed work:

- files listed in the active slice
- direct dependencies needed by the slice
- tests, docs, and config required by the slice

When new work appears:

- add it as a follow-up slice for P2/P3
- create a review-focus note when it may affect correctness
- mark the current slice `BLOCKED` when it invalidates the approved goal

## Fresh verification gate

Before marking complete, run:

```markdown
## Fresh Verification Check
Last code change: <timestamp or git diff summary>
Verification command: <command>
Verification ran after final code change: yes/no
Result: PASS | FAIL | SKIPPED
Covers Exit Criteria: yes/no
Decision: MARK_COMPLETED | KEEP_ACTIVE | BLOCKED
```

A completed slice requires verification after final code change. If verification cannot run, mark `DONE_WITH_CONCERNS` and record the reason.

## Update living plan

Set slice status to `COMPLETED` or `BLOCKED`. Record:

```markdown
#### Completion Evidence
- Command: `<command>`
- Result: PASS | FAIL | SKIPPED
- Ran after final code change: yes/no
- Files changed: <files>
- Assumptions made: <list>
- Review focus: <what review must inspect>
```

Set `Active Slice` to the next TODO slice or `none`.

## Continue

After the slice is completed or blocked, continue directly to `/gf-code-review`.

## Completion

```text
STATUS: DONE | DONE_WITH_CONCERNS | BLOCKED
PLAN_UPDATED: <path>
SLICE: <id> COMPLETED | BLOCKED
VERIFICATION: <commands and results>
ASSUMPTIONS_RECORDED: yes/no
NEXT: /gf-code-review
```

