---
name: gf-code-review
version: 0.3.0
description: Use when code, tests, diffs, completed plan slices, implementation evidence, or automated execution results need review before the next slice, merge, or handoff.
allowed-tools:
  - Read
  - Grep
  - Glob
  - Write
  - Edit
  - Bash
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

Review implementation against the active plan, diff, tests, verification freshness, architecture, security, and taste. Capture patterns for compound engineering.

Core principle: review runs after execution without pausing for approval. Findings become work follow-ups, compound notes, or skill evolution signals.

## Harness Position

`gf-code-review` is an automated post-work stage:

```text
gf-work -> gf-code-review -> gf-doc-review -> gf-compound -> gf-evolve when needed
```

Do not ask the user during review. Write evidence, classify findings, update the plan, and route the next step.

## Required Artifact

```text
docs/guanfu/reviews/code/YYYY-MM-DD-HHMM-<slug>-code-review.md
```

Update the related plan's `Code Review Log`.

## Workflow

### 1. Detect review scope

Run:

```bash
BASE=$(git merge-base HEAD origin/main 2>/dev/null || git merge-base HEAD main 2>/dev/null || git rev-parse HEAD~1 2>/dev/null || true)
echo "BASE=${BASE:-unknown}"
git status --short 2>/dev/null || true
git diff --stat ${BASE:-HEAD~1}...HEAD 2>/dev/null || git diff --stat 2>/dev/null || true
git diff --name-only ${BASE:-HEAD~1}...HEAD 2>/dev/null || git diff --name-only 2>/dev/null || true
find docs/guanfu/plans docs/guanfu/compound docs/guanfu/adr -type f -name '*.md' 2>/dev/null | sort | tail -120
```

If the base cannot be determined, review the working tree and record `Diff Range: WORKTREE`.

### 2. Review Scope Check

Print and include in the review:

```markdown
## Review Scope Check

Mode: SLICE | PRE_MERGE | HOTFIX | REGRESSION | SECURITY | WORKTREE
Base: <branch or commit or WORKTREE>
Head: <commit or working tree>
Plan: <path or none>
Slice: <slice id or none>
Changed files:
- <file>
Decision: REVIEW | NEED_PLAN | NEED_WORK_LOG | BLOCKED
Reason: <one sentence>
```

Proceed with `REVIEW` whenever there is a diff or work log evidence. If plan/work evidence is weak, record that as a finding and continue.

### 3. Fresh verification audit

Read the active plan's completion evidence and compare it to changed files.

Write:

```markdown
## Verification Freshness

| Evidence | Command | Claimed Result | Fresh After Last Code Change | Covers Exit Criteria | Verdict |
|---|---|---|---|---|---|
```

Classify stale, missing, or weak verification as a finding.

### 4. Independent review pass

Dispatch a read-only review agent.

Prompt:

```text
You are a GuanFu code review agent. Read the active plan, related brainstorm, ADRs, compound notes, and current diff. Review plan compliance, correctness, tests, verification freshness, architecture, security/trust, taste, and compound candidates. Return findings with severity, evidence, pattern, user impact, recommended fix, and whether this should become a compound note.
```

Use the subagent as an input. Apply your own judgment before writing the final review.

### 5. Review dimensions

| Dimension | Questions |
|---|---|
| Plan compliance | Does implementation match the active slice and scope? |
| Correctness | What edge cases, errors, concurrency, data loss, or state bugs exist? |
| Tests | Did verification cover new behavior and failure modes? |
| Verification freshness | Did commands run after final code changes? |
| Architecture | Did boundaries stay clear? Is an ADR needed? |
| Security/trust | Auth, permissions, secrets, unsafe output, injection, prompt exposure. |
| Taste | Is the solution smaller, clearer, easier to change, and consistent with project taste? |
| Compound | Did this reveal a reusable lesson or repeated mistake? |
| Evolution | Did a GuanFu skill allow a preventable failure? |

### 6. Classify findings

Use:

- `P0 BLOCKER`: unsafe to continue, data/security/correctness issue, or no credible verification.
- `P1 FIX_NOW`: should be fixed before the next implementation slice.
- `P2 FOLLOW_UP`: can become a planned follow-up slice.
- `P3 NOTE`: useful observation.

Every P0/P1/P2 finding must include:

```markdown
### Finding <ID>: <title>
Severity: P0 BLOCKER | P1 FIX_NOW | P2 FOLLOW_UP | P3 NOTE
Location: <file:line or artifact>
Evidence: <specific diff, test, doc, or command>
Pattern: <generalizable pattern>
Why this happened: <likely cause>
User impact: <real consequence>
Recommended fix: <concrete next action>
Compound candidate: yes/no
Evolution candidate: yes/no
```

### 7. Write review document

Use `templates/review.md`. Include:

- review scope check
- verification freshness table
- subagent summary
- findings
- scope drift
- ADR notes
- compound candidates
- evolution candidates
- final verdict

Verdicts:

```text
CLEAR
CLEAR_WITH_FOLLOWUPS
RETURN_TO_WORK
RETURN_TO_PLAN
COMPOUND_REQUIRED
EVOLVE_REQUIRED
BLOCKED
```

### 8. Update plan

Append:

```markdown
## Code Review Log

### <ISO timestamp> - gf-code-review
Review: docs/guanfu/reviews/code/<file>.md
Verdict: <verdict>
Findings: <count>
Compound candidates: <count>
Evolution candidates: <count>
Next: /gf-doc-review | /gf-work | /gf-compound | /gf-evolve
```

### 9. Continue the chain

Routing rules:

| Review result | Next step |
|---|---|
| `CLEAR` or `CLEAR_WITH_FOLLOWUPS` | `/gf-doc-review` |
| `RETURN_TO_WORK` | `/gf-work` with review findings as active work evidence |
| `RETURN_TO_PLAN` | `/gf-plan` only when scope or architecture changed materially |
| `COMPOUND_REQUIRED` | `/gf-compound` after doc review or immediately when lesson is primary output |
| `EVOLVE_REQUIRED` | `/gf-compound` first, then `/gf-evolve` |
| `BLOCKED` | `/gf-compound` with blocker evidence |

Do not ask the user between review and next routing. The next stage records the decision.

## Common Mistakes

| Mistake | Fix |
|---|---|
| Saying "looks good" | Write a review artifact with evidence. |
| Reviewing only style | Check plan compliance, tests, freshness, ADRs, and risks. |
| Fixing during review | Record findings; fixes happen in `gf-work`. |
| Ignoring stale tests | Audit verification freshness explicitly. |
| Missing patterns | Mark compound candidates and evolution candidates. |
| Pausing for taste alignment mid-chain | Record taste finding and send it to compound/evolve. |

## Completion

Report:

```text
STATUS: DONE | DONE_WITH_CONCERNS | BLOCKED
REVIEW: docs/guanfu/reviews/code/YYYY-MM-DD-HHMM-<slug>-code-review.md
VERDICT: CLEAR | CLEAR_WITH_FOLLOWUPS | RETURN_TO_WORK | RETURN_TO_PLAN | COMPOUND_REQUIRED | EVOLVE_REQUIRED | BLOCKED
FINDINGS: <count>
NEXT: /gf-doc-review | /gf-work | /gf-plan | /gf-compound | /gf-evolve
```
