---
name: ce-review
description: Use when code, documentation, ADRs, or completed Compound Engineering plan slices need review before merge, handoff, or the next implementation slice.
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
  - /ce-review
  - code review
  - review this
  - review slice
  - doc review
---

# CE Review

## Overview

Review implementation against the plan, code quality, tests, documentation, and architectural decisions. Capture patterns, not just bugs.

Core principle: a good review improves future judgment. The review artifact should teach the next agent what to watch for.

## Required Artifact

Write one review document:

```text
docs/ce/reviews/YYYY-MM-DD-<slug>-review.md
```

Also update the related plan's `## Review Log` with a link to the review.

## Workflow

### 1. Establish review scope

Read:

- Active or completed plan.
- Related ADRs.
- Work log.
- Recent compound notes.
- Git diff against base branch or the slice's starting commit.

Commands:

```bash
git status --short
git branch --show-current
git diff --stat
git diff --name-only
git log --oneline -20
```

If there is no plan, review can still run, but mark `Plan Compliance` as `NOT AVAILABLE` and recommend backfilling a plan if the change is non-trivial.

### 2. Run independent code review agent

Prefer an independent agent for code review.

Agent prompt:

```text
You are an independent Compound Engineering code reviewer. Do not modify files.

Review the current diff and related plan/ADRs.

Return findings in this format:
- Severity: P0 | P1 | P2 | P3
- Category: correctness | test | architecture | security | performance | maintainability | docs | scope
- Location: file:line when possible
- Evidence: exact behavior or diff evidence
- User impact: what breaks or gets worse
- Fix: concrete recommendation
- Compound candidate: yes/no, and why

Also return:
1. Plan compliance verdict.
2. Test coverage verdict.
3. ADR consistency verdict.
4. Documentation verdict.
5. Top 3 risks after review.
```

If an agent is unavailable, perform the same review inline and say so.

### 3. Review dimensions

Use this checklist:

| Dimension | Questions |
|---|---|
| Plan compliance | Did the work match the active slice and exit criteria? Any scope drift? |
| Correctness | Does the code do what the user will expect? Edge cases? Error states? |
| Tests | Did tests fail first where applicable? Do tests cover the risky behavior? |
| Architecture | Does it follow existing patterns? Any ADR violated or needed? |
| Security and data safety | Any unsafe trust boundary, injection, auth, data loss, migration risk? |
| Performance | Any obvious N+1, unbounded loop, large payload, cache risk, or latency regression? |
| Maintainability | Names, boundaries, coupling, dead code, accidental complexity? |
| Docs | Did docs, plan, ADR, README, or API docs need updates? |
| Compound | Did this reveal a reusable lesson or repeated mistake? |

### 4. Classify findings

Use:

- `BLOCKER`: must fix before merge or next slice.
- `FIX_NOW`: should fix in this pass.
- `FOLLOW_UP`: can defer with explicit owner and reason.
- `NOTE`: informational, no action.

Never hide a blocker as a follow-up because it is inconvenient.

### 5. Write the review document

Template:

```markdown
# Review: <title>

Generated: <ISO timestamp>
Status: OPEN | CLEAR | CLEAR_WITH_FOLLOWUPS | BLOCKED
Plan: <path or none>
Branch: <branch>
Base: <base or unknown>
Reviewer: <agent or inline>

## Summary
<one paragraph>

## Verdict
- Plan Compliance: PASS | FAIL | NOT AVAILABLE
- Code Quality: PASS | FAIL
- Tests: PASS | FAIL | PARTIAL
- Docs: PASS | FAIL | NOT NEEDED
- ADR: PASS | NEEDED | CONFLICT
- Compound Candidates: <count>

## Findings

### F1: <title>
Severity: P0 | P1 | P2 | P3
Action: BLOCKER | FIX_NOW | FOLLOW_UP | NOTE
Category:
Location:
Evidence:
User Impact:
Recommendation:
Compound Candidate: yes/no

## Verification Evidence
Commands run:
- `<command>` - PASS | FAIL | NOT RUN, <reason>

## Scope Drift
<none or details>

## ADR Notes
<new ADR needed, existing ADR followed, or conflict>

## Documentation Notes
<docs updated or missing>

## Compound Notes To Create
<link or list candidate lessons>

## Final Recommendation
<merge, continue work, rerun ce-work, run ce-compound>
```

### 6. Fix loop

If findings are `BLOCKER` or `FIX_NOW`, ask whether to fix now.

- If yes, apply fixes, run targeted verification, and update the review doc.
- If no, record why in the review doc and mark status accordingly.

After fixes, re-review affected areas. Do not claim `CLEAR` without a second look at changed files.

### 7. Update plan review log

Append to the plan:

```markdown
### <ISO timestamp> - ce-review
Review: docs/ce/reviews/<file>.md
Status: CLEAR | CLEAR_WITH_FOLLOWUPS | BLOCKED
Findings: <count>
Next: <action>
```

### 8. Trigger compound capture

If any finding is a repeated mistake, surprising bug, process failure, missing guardrail, or review lesson likely to recur, recommend `ce-compound` and pass the candidate list.

## Common Mistakes

| Mistake | Fix |
|---|---|
| Reviewing only the diff and ignoring the plan | Start with plan compliance. |
| Saying "looks good" without evidence | Include commands, files, and dimensions reviewed. |
| Fixing review issues without updating docs | Update review doc and plan log. |
| Capturing only bugs, not patterns | Mark compound candidates. |
| Treating docs as optional memory | If future agents need it, write it. |

## Completion

Report:

```text
STATUS: DONE | BLOCKED | DONE_WITH_CONCERNS
REVIEW: docs/ce/reviews/YYYY-MM-DD-<slug>-review.md
VERDICT: CLEAR | CLEAR_WITH_FOLLOWUPS | BLOCKED
NEXT: ce-compound, ce-work, or ship
```
