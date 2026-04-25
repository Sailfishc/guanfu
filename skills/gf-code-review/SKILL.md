---
name: gf-code-review
version: 0.2.0
description: Use when code, tests, diffs, completed plan slices, or implementation evidence need review before merge, handoff, or the next implementation slice.
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
  - /gf-code-review
  - code review
  - review diff
  - review slice
  - pre-merge review
---

# gf-code-review

## Overview

Review implementation against the active plan, code quality, tests, verification evidence, and architectural decisions. Capture patterns, not just bugs.

Core principle: a good review improves future judgment. The review artifact should teach the next agent what to watch for.

## Required Artifact

```text
docs/guanfu/reviews/code/YYYY-MM-DD-<slug>-code-review.md
```

Also update the related plan's code review log.

## Workflow

### 1. Load source of truth

Read:

- active or recently completed plan
- related brainstorm
- related ADRs
- recent compound notes
- current diff and changed files
- tests and verification output

### 2. Run review-focused code explore

Dispatch an independent agent for review-focused code explore. Ask it to report:

- changed behavior
- risky files
- plan compliance
- test coverage gaps
- ADR conflicts
- compound candidates

### 3. Review dimensions

| Dimension | Questions |
|---|---|
| Plan compliance | Does implementation match the active slice? |
| Correctness | What edge cases, errors, concurrency, data loss, or state bugs exist? |
| Tests | Did verification cover new behavior and failure modes? |
| Architecture | Did boundaries stay clean? Is an ADR needed? |
| Security/trust | Auth, permissions, secrets, unsafe output, injection, prompt exposure. |
| Taste | Is the solution smaller, clearer, and easier to change? |
| Compound | Did this reveal a reusable lesson or repeated mistake? |

### 4. Classify findings

Use:

- `P0 BLOCKER`: unsafe to continue
- `P1 FIX_NOW`: should be fixed before next slice
- `P2 FOLLOW_UP`: can be planned
- `P3 NOTE`: informational

Each finding needs:

- location
- evidence
- pattern
- user impact
- recommended fix
- compound candidate yes/no

### 5. Write review document

Use `templates/review.md`.

### 6. Update plan

Append to plan:

```markdown
## Code Review Log

### <ISO timestamp> - gf-code-review
Review: docs/guanfu/reviews/code/<file>.md
Verdict: CLEAR | CLEAR_WITH_FOLLOWUPS | BLOCKED
```

### 7. Handoff

If repeated mistake or reusable lesson exists, recommend `gf-compound`.

If docs are weak, recommend `gf-doc-review`.

## Common Mistakes

| Mistake | Fix |
|---|---|
| Saying "looks good" | Write a review artifact with evidence. |
| Reviewing only code style | Check plan compliance, tests, ADRs, and risks. |
| Fixing during review | Record findings first. Fix via `gf-work` or approved follow-up. |
| Missing patterns | Mark compound candidates explicitly. |
| Using stale tests | Verify commands are fresh enough for the changed code. |

## Completion

Report:

```text
STATUS: DONE | DONE_WITH_CONCERNS | BLOCKED
REVIEW: docs/guanfu/reviews/code/YYYY-MM-DD-<slug>-code-review.md
VERDICT: CLEAR | CLEAR_WITH_FOLLOWUPS | BLOCKED
NEXT: gf-doc-review | gf-compound | gf-work
```
