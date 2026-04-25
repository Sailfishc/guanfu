---
name: gf-code-review
description: Use when code, tests, diffs, completed plan slices, or implementation evidence need review before merge, handoff, or the next implementation slice.
---


# gf-code-review

## Purpose

Review implementation against the active plan, code quality, tests, verification evidence, architecture, and GuanFu taste.

Review catches the pattern, not just the bug. Findings route automatically to work, doc review, compound, or evolve.

## Autonomous contract

Continue without routine prompts.

Routes:

- P0/P1 inside approved scope -> create or update a repair slice and continue to `/gf-work`.
- P2/P3 -> add follow-up or review notes and continue.
- repeated mistake -> continue to `/gf-compound`.
- skill/template/router gap -> continue to `/gf-compound`, then `/gf-evolve`.

Stop only for security-sensitive or destructive ambiguity requiring human authority.

## Required artifact

```text
docs/guanfu/reviews/code/YYYY-MM-DD-HHMM-<slug>-code-review.md
```

Also update the related plan's review log.

## Review scope check

Determine scope and base:

```bash
git branch --show-current 2>/dev/null || true
git merge-base HEAD origin/main 2>/dev/null || git merge-base HEAD main 2>/dev/null || true
git status --short 2>/dev/null || true
git diff --stat 2>/dev/null || true
git diff --cached --stat 2>/dev/null || true
git log --oneline -20 2>/dev/null || true
```

Output:

```markdown
## Review Scope Check
Mode: SLICE | PRE_MERGE | HOTFIX | REGRESSION | SECURITY
Base: <branch or commit or working tree>
Head: <commit or working tree>
Changed files:
- <file>
Plan: <path or none>
Slice: <slice or none>
Decision: REVIEW | NEED_PLAN | NEED_WORK_LOG | BLOCKED
```

## Freshness audit

Read the active plan's completion evidence and compare it to final code changes.

```markdown
## Verification Freshness
| Evidence | Command | Claimed Result | Fresh After Last Code Change | Covers Exit Criteria | Verdict |
|---|---|---|---|---|---|
```

Weak evidence becomes a finding. Stale evidence routes to `/gf-work`.

## Review passes

1. Plan compliance: scope, slice, assumptions, exit criteria.
2. Correctness: edge cases, errors, retries, concurrency, data loss.
3. Tests: behavior coverage, regression coverage, failure mode coverage.
4. Architecture: boundaries, reversibility, dependencies, ADR fit.
5. Security/trust: auth, permissions, injection, secrets, unsafe AI output, data exposure.
6. Taste: smaller API, readable names, less ceremony, simple future diffs.
7. Compound signals: repeated issue, missed assumption, review pattern, skill gap.

Use an independent review subagent for non-trivial diffs.

## Finding schema

```markdown
### Finding R<n>: <title>
Severity: P0 | P1 | P2 | P3
Location:
Evidence:
Pattern:
Why this happened:
User impact:
Recommended route: gf-work | gf-plan | gf-compound | gf-evolve | follow-up
Compound candidate: yes/no
```

## Verdict

```text
CLEAR | CLEAR_WITH_FOLLOWUPS | RETURN_TO_WORK | RETURN_TO_PLAN | COMPOUND_REQUIRED | EVOLUTION_REQUIRED | BLOCKED
```

## Continue

- `CLEAR` or `CLEAR_WITH_FOLLOWUPS` -> `/gf-doc-review`.
- `RETURN_TO_WORK` -> update plan and continue to `/gf-work`.
- `COMPOUND_REQUIRED` -> `/gf-compound`.
- `EVOLUTION_REQUIRED` -> `/gf-compound`, then `/gf-evolve`.

