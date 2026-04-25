---
name: gf-doc-review
version: 0.3.0
description: Use when GuanFu brainstorms, plans, ADRs, reviews, compound notes, AGENTS routing, or project docs need handoff and lineage review before another agent depends on them.
allowed-tools:
  - Read
  - Grep
  - Glob
  - Write
  - Edit
  - Bash
  - Agent
triggers:
  - /gf-doc-review
  - doc review
  - review plan
  - review ADR
  - review docs
  - handoff review
---

# gf-doc-review

## Overview

Review documents as executable handoff artifacts. A fresh agent should be able to continue from docs alone.

Core principle: documents are AI memory. Post-work document review makes the next automated step safer and reveals harness gaps.

## Harness Position

`gf-doc-review` is an automated post-code-review stage. It does not ask for approval. It checks lineage, fixes safe mechanical doc issues, records substantive gaps, then routes to compound, evolve, work, or stop.

## Required Artifact

```text
docs/guanfu/reviews/docs/YYYY-MM-DD-HHMM-<slug>-doc-review.md
```

## Workflow

### 1. Choose target docs

Default target set:

```bash
find docs/guanfu/brainstorms docs/guanfu/plans docs/guanfu/adr docs/guanfu/reviews/code docs/guanfu/compound docs/guanfu/evolution -type f -name '*.md' 2>/dev/null | sort | tail -120
[ -f AGENTS.md ] && echo AGENTS.md
[ -f agents.md ] && echo agents.md
```

Review the latest related brainstorm, active or recently completed plan, code review, ADRs, compound notes, and router instructions.

### 2. Artifact Lineage Check

Write:

```markdown
## Artifact Lineage

| Artifact | Links to previous stage | Links to next action | Status clear | Issue |
|---|---|---|---|---|
| Brainstorm | | | | |
| Plan | | | | |
| ADR | | | | |
| Code Review | | | | |
| Compound Note | | | | |
| Evolution Note | | | | |
```

A complete chain should show:

```text
brainstorm -> plan -> work log -> code review -> doc review -> compound/evolve when needed
```

### 3. Fresh Agent Handoff Test

Pretend the chat transcript is gone. Answer from documents only:

```markdown
## Fresh Agent Handoff Test

Can a new agent answer:

| Question | Answerable? | Evidence |
|---|---|---|
| What is the current goal? | yes/no/partial | <path> |
| What is active? | yes/no/partial | <path> |
| What is completed? | yes/no/partial | <path> |
| What is blocked? | yes/no/partial | <path> |
| What files matter? | yes/no/partial | <path> |
| What verification evidence exists? | yes/no/partial | <path> |
| What should happen next? | yes/no/partial | <path> |

Verdict: PASS | PARTIAL | FAIL
```

### 4. Review checks

| Check | Standard |
|---|---|
| Source of truth | Artifact states where it came from. |
| State | DRAFT, APPROVED, ACTIVE, COMPLETED, BLOCKED, or SUPERSEDED is explicit. |
| Slices | Each slice has scope, verification, rollback, and exit criteria. |
| ADR | High reversal-cost decisions are recorded. |
| Verification | Commands and freshness evidence are present. |
| Handoff | Fresh agent knows next skill and next action. |
| Compound | Repeated lessons are linked or flagged. |
| Evolution | Process gaps are routed to `gf-evolve`. |
| Router | AGENTS routes match actual skill names and docs paths. |
| Taste | Quality constraints are visible for future agents. |

### 5. Safe doc fixes

Allowed automatic edits:

- broken GuanFu path typo
- missing `Next Artifact` when it is obvious from logs
- missing status line when the surrounding document clearly implies status
- router typo for `gf-*` skill names
- template heading mismatch
- stale date format instruction

For substantive changes, write a finding and route to the relevant skill. Do not ask the user mid-chain.

### 6. Write doc review artifact

Use `templates/doc-review.md`. Include:

- artifact lineage table
- fresh agent handoff test
- safe edits applied
- findings
- required edits
- compound candidates
- evolution candidates
- final verdict

Verdicts:

```text
CLEAR
CLEAR_WITH_FOLLOWUPS
RETURN_TO_PLAN
RETURN_TO_WORK
COMPOUND_REQUIRED
EVOLVE_REQUIRED
BLOCKED
```

### 7. Update related plan

Append:

```markdown
## Doc Review Log

### <ISO timestamp> - gf-doc-review
Review: docs/guanfu/reviews/docs/<file>.md
Verdict: <verdict>
Safe edits applied: <count>
Next: /gf-compound | /gf-evolve | /gf-work | stop
```

### 8. Continue the chain

Routing rules:

| Doc review result | Next step |
|---|---|
| `CLEAR` | stop or next active slice via `/gf-work` if plan has one |
| `CLEAR_WITH_FOLLOWUPS` | `/gf-compound` when follow-up contains a reusable lesson |
| `RETURN_TO_PLAN` | `/gf-plan` only when planning docs cannot guide execution |
| `RETURN_TO_WORK` | `/gf-work` when evidence or status needs implementation-side update |
| `COMPOUND_REQUIRED` | `/gf-compound` |
| `EVOLVE_REQUIRED` | `/gf-compound` first, then `/gf-evolve` |
| `BLOCKED` | `/gf-compound` with blocker evidence |

## Common Mistakes

| Mistake | Fix |
|---|---|
| Treating docs as decoration | Review them as executable handoff context. |
| Passing vague plans | Require verification, rollback, and exit criteria. |
| Ignoring router drift | Check exact skill names, docs paths, and stage order. |
| Editing meaning silently | Record a finding and route to the owning skill. |
| Missing lineage | Add previous/next artifact links. |

## Completion

Report:

```text
STATUS: DONE | DONE_WITH_CONCERNS | BLOCKED
REVIEW: docs/guanfu/reviews/docs/YYYY-MM-DD-HHMM-<slug>-doc-review.md
VERDICT: CLEAR | CLEAR_WITH_FOLLOWUPS | RETURN_TO_PLAN | RETURN_TO_WORK | COMPOUND_REQUIRED | EVOLVE_REQUIRED | BLOCKED
HANDOFF_TEST: PASS | PARTIAL | FAIL
NEXT: /gf-work | /gf-compound | /gf-evolve | /gf-plan | stop
```
