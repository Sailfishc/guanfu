---
name: gf-work
description: Use when implementing an approved active GuanFu plan slice or linked backlog work item in an existing repository.
---

# gf-work

## Purpose

Implement exactly one active plan slice, update the living plan and linked work item, and leave fresh verification evidence.

After plan approval, execution is autonomous. Do the work, record assumptions, verify, update state, then hand off to review.

## Autonomous contract

Continue without routine prompts. When the plan is imperfect, choose the smallest safe interpretation consistent with the approved goal, record the assumption, and surface it in review.

Stop only for destructive or irreversible external action, missing credentials, legal/compliance/security ambiguity requiring human authority, or architecture conflict that invalidates the approved goal.

## Work entry check

Load plans, linked backlog items, compound notes, ADRs, and recent reviews:

```bash
find docs/guanfu/plans -type f -name '*-plan.md' 2>/dev/null | sort | tail -30
find docs/guanfu/backlog -type f -name 'WI-*.md' 2>/dev/null | sort | tail -80
find docs/guanfu/compound -type f -name '*.md' 2>/dev/null | sort | tail -50
find docs/guanfu/adr -type f -name '*.md' 2>/dev/null | sort | tail -30
find docs/guanfu/reviews -type f -name '*.md' 2>/dev/null | sort | tail -40
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
Active Slice Status: TODO | ACTIVE | COMPLETED | BLOCKED | DEFERRED | UNKNOWN
Linked Work Item: <id/path or none>
Linked Work Item Status: TODO | READY | ACTIVE | BLOCKED | DONE | SUPERSEDED | ARCHIVED | UNKNOWN
Multiple Active Plans Found: yes/no
Decision: WORK | REVERIFY | ROUTE_TO_REVIEW | MARK_BLOCKED | RETURN_TO_PLAN
```

Rules:

- `Plan Approval: APPROVED` and `Execution Mode: AUTOMATED_AFTER_PLAN` are required for normal work.
- Multiple active plans -> choose the one matching the user request or most recent approved plan, then record the choice.
- Missing active slice -> mark plan blocked and route to `/gf-doc-review`.
- Completed active slice with fresh evidence -> `ROUTE_TO_REVIEW`.
- Completed active slice with stale or unknown evidence -> `REVERIFY`.
- Linked work item status must stay aligned with active slice state unless explicitly historical or superseded.

## Re-run behavior

Re-running `/gf-work` means running the work entry check again. Actions are idempotent; verification is not. Never mark a slice complete from stale evidence.

Output this check before changing files:

```markdown
## Re-run Check
Invocation: initial | rerun
Existing Slice Status: TODO | ACTIVE | COMPLETED | BLOCKED | DEFERRED | UNKNOWN
Linked Work Item Status: TODO | READY | ACTIVE | BLOCKED | DONE | SUPERSEDED | ARCHIVED | UNKNOWN
Prior Completion Evidence Present: yes/no
Code Changed Since Prior Evidence: yes/no/unknown
Completion Evidence Fresh: yes/no/unknown
Decision: WORK | REVERIFY | ROUTE_TO_REVIEW | MARK_BLOCKED | RETURN_TO_PLAN
```

Rules:

- Re-read the active plan, active slice status, linked work item, completion evidence, implementation log, anomaly log, recent reviews, and current git status on every invocation.
- If the active slice is already `COMPLETED`, route to `/gf-code-review` unless completion evidence is stale.
- Evidence is stale when files changed after recorded verification, verification command/result is missing, result is not `PASS`, or evidence no longer covers the current exit criteria.
- If evidence is stale, keep or restore the slice as `ACTIVE`, keep the linked work item `ACTIVE`, append a rerun log entry, and re-run verification before any completion claim.
- If a failing test already exists, re-run it and confirm it still fails before implementation.
- If implementation already exists, verify it against the current exit criteria instead of duplicating work.
- Do not duplicate work log entries. Append a rerun note with reason and timestamp.
- Re-run verification whenever code changed or evidence is stale, even when a prior run claimed success.

Forbidden shortcuts:

| Shortcut | Required response |
|---|---|
| "Already done last run" | Re-check evidence freshness and current git diff. |
| "No code changed in this turn" | Confirm no relevant files changed since recorded verification. |
| "The plan says completed" | Treat plan status as a claim until evidence is fresh. |
| "The backlog item says DONE" | Treat item status as a claim until evidence is fresh. |
| "Verification was expensive" | Run the narrowest command that still proves the exit criteria, or mark concerns. |

## Load relevant compound memory

Read `docs/guanfu/compound/index.md` first. Load notes whose keywords, files, areas, or owner skill match the active slice or linked work item.

Append to the plan:

```markdown
## Relevant Compound Notes
- <path>: <lesson applied>
```

## Start the slice

Append:

```markdown
### <ISO timestamp> - gf-work started <slice>
Linked Work Item: <id/path or none>
Assumptions:
- <assumption or none>
Relevant compound notes:
- <path or none>
```

If a linked work item exists, set it to `ACTIVE` unless it is already `ACTIVE` with a matching plan/slice.

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
- files listed in the linked work item
- direct dependencies needed by the slice
- tests, docs, and config required by the slice

When new work appears:

- add it as a follow-up work item for P2/P3
- create a review-focus note when it may affect correctness
- mark the current slice `BLOCKED` when it invalidates the approved goal
- route architecture friction to `/gf-architecture-review`

## Fresh verification gate

Before marking complete, run:

```markdown
## Fresh Verification Check
Last code change: <timestamp or git diff summary>
Evidence source: new run | rerun | prior run revalidated
Prior completion evidence: <path/section or none>
Verification command: <command>
Verification ran in this gf-work invocation: yes/no
Verification ran after final code change: yes/no
Code changed since prior evidence: yes/no/unknown
Result: PASS | FAIL | SKIPPED
Covers Exit Criteria: yes/no
Decision: MARK_COMPLETED | UPDATE_EVIDENCE | KEEP_ACTIVE | BLOCKED
```

A completed slice requires verification after the final relevant change. Prior completion evidence is acceptable only when the Re-run Check says it is fresh. If verification cannot run, mark `DONE_WITH_CONCERNS` and record the reason.

No completion claim may rely only on old text in the plan, an earlier assistant summary, backlog status, or confidence.

## Update living plan and backlog

Set slice status to `COMPLETED` or `BLOCKED`. Record:

```markdown
#### Completion Evidence
- Command: `<command>`
- Result: PASS | FAIL | SKIPPED
- Ran in this gf-work invocation: yes/no
- Ran after final code change: yes/no
- Prior evidence reused: yes/no, with freshness reason
- Files changed: <files>
- Linked work item updated: <id/path or none>
- Assumptions made: <list>
- Review focus: <what review must inspect>
```

If a linked work item exists:

- `COMPLETED` slice -> set work item `DONE` only with fresh evidence.
- `BLOCKED` slice -> set work item `BLOCKED` and name blockers.
- follow-up found -> create/update `QA_FOLLOWUP`, `REVIEW_REPAIR`, or `ARCHITECTURE_CANDIDATE` through `/gf-backlog`.

Set `Active Slice` to the next TODO slice or `none`.

## Continue

After the slice is completed or blocked, continue directly to `/gf-code-review`.

## Completion

```text
STATUS: DONE | DONE_WITH_CONCERNS | BLOCKED
PLAN_UPDATED: <path>
WORK_ITEM_UPDATED: <id/path or none>
SLICE: <id> COMPLETED | BLOCKED
VERIFICATION: <commands and results>
ASSUMPTIONS_RECORDED: yes/no
NEXT: /gf-code-review
```
