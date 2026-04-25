---
name: gf-doc-review
description: Use when GuanFu brainstorms, plans, ADRs, reviews, compound notes, AGENTS routing, or project docs need quality review before another agent depends on them.
---


# gf-doc-review

## Purpose

Review the durable documents that future agents will rely on.

The test is simple: a fresh agent should understand current goal, active state, evidence, risks, and next action from files alone.

## Autonomous contract

Continue without routine prompts. Apply small safe documentation fixes inline when they clarify state, links, or headings. Record all edits.

Stop only when a missing decision invalidates the approved goal or requires human authority.

## Required artifact

```text
docs/guanfu/reviews/docs/YYYY-MM-DD-HHMM-<slug>-doc-review.md
```

## Load context

Read:

- active plan
- latest brainstorm
- related ADRs
- code review artifact
- compound index and relevant notes
- `AGENTS.md` or `agents.md`
- `docs/guanfu/standards/review-rubric.md`

## Artifact lineage check

```markdown
## Artifact Lineage
| Artifact | Links to previous stage | Links to next action | Status clear | Issue |
|---|---|---|---|---|
```

Check the chain:

```text
brainstorm -> plan -> work log -> code review -> doc review -> compound/evolution when needed
```

## Fresh agent handoff test

Pretend the chat transcript is gone. Answer from docs only:

1. What is the current goal?
2. What is active?
3. What is completed?
4. What is blocked?
5. What files matter?
6. What verification evidence exists?
7. What should happen next?

Verdict:

```text
PASS | PARTIAL | FAIL
```

## Review dimensions

- State clarity: active, completed, blocked, deferred.
- Slice clarity: entry conditions, scope, exit criteria, verification.
- Evidence quality: commands, results, freshness.
- ADR coverage: high-reversal-cost decisions documented.
- Compound coverage: lessons and repeated risks recorded.
- Evolution coverage: skill/template/router gaps routed.
- Handoff quality: next agent can continue without chat memory.

## Finding schema

```markdown
| ID | Severity | Document | Evidence | Impact | Required Route |
|---|---|---|---|---|---|
```

Severity:

```text
P0 state misleading
P1 next agent could fail
P2 clarity issue
P3 polish
```

## Continue

- `CLEAR` -> next active plan slice or final handoff.
- `CLEAR_WITH_FOLLOWUPS` -> add follow-up notes, then next slice.
- `COMPOUND_REQUIRED` -> `/gf-compound`.
- `EVOLUTION_REQUIRED` -> `/gf-compound`, then `/gf-evolve`.
- `BLOCKED` -> update the plan with blocked reason and evidence.

