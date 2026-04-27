---
name: gf-doc-review
description: Use when GuanFu brainstorms, plans, backlog items, ADRs, reviews, compound notes, AGENTS routing, or project docs need quality or lifecycle review before another agent depends on them.
---

# gf-doc-review

## Purpose

Review durable documents that future agents will rely on.

The test is simple: a fresh agent should understand current goal, active state, evidence, risks, lifecycle status, and next action from files alone.

## Autonomous contract

Continue without routine prompts. Apply small safe documentation fixes inline when they clarify state, links, lifecycle, or headings. Record all edits.

Stop only when a missing decision invalidates the approved goal or requires human authority.

## Required artifact

```text
docs/guanfu/reviews/docs/YYYY-MM-DD-HHMM-<slug>-doc-review.md
```

## Load context

Read:

- active plan
- linked backlog items
- latest brainstorm
- related ADRs
- QA, architecture, and code review artifacts
- compound index and relevant notes
- `AGENTS.md` or `agents.md`
- `docs/guanfu/standards/review-rubric.md`

## Artifact lineage check

```markdown
## Artifact Lineage
| Artifact | Links to previous stage | Links to next action | Status clear | Lifecycle clear | Issue |
|---|---|---|---|---|---|
```

Check the chain:

```text
brainstorm -> plan -> backlog/work item -> work log -> code review -> doc review -> QA/architecture/compound/evolution when needed
```

## Doc lifecycle audit

Every durable artifact must state how future agents should treat it.

Use this table:

```markdown
## Doc Lifecycle Audit
| Artifact | Current State | Future Agent Treatment | Successor | Risk | Action |
|---|---|---|---|---|---|
```

Lifecycle vocabulary:

```text
DRAFT       not approved as instruction
APPROVED    approved source input
ACTIVE      current work or current plan
CURRENT     reliable current reference
COMPLETED   finished evidence, not current instruction
HISTORICAL  audit evidence only
SUPERSEDED  replaced; must point to successor
ARCHIVED    retained, not current instruction
STALE       likely misleading; requires route
RETIRED     intentionally no longer used
```

Rules:

- Future agents may rely on `ACTIVE`, `CURRENT`, and approved source docs as current instruction.
- `COMPLETED` and `HISTORICAL` are evidence, not current instruction.
- `SUPERSEDED` must point to a successor.
- `STALE` must route to doc fix, `/gf-plan`, `/gf-compound`, or `/gf-evolve` when the stale doc reflects a repeated process gap.
- Completed plans must not present themselves as active work.
- Closed backlog items must not remain `ACTIVE` or `READY`.

## Fresh agent handoff test

Pretend the chat transcript is gone. Answer from docs only:

1. What is the current goal?
2. What is active?
3. What is completed?
4. What is blocked?
5. Which backlog items matter?
6. What files matter?
7. What verification evidence exists?
8. Which documents are current instructions vs historical evidence?
9. What should happen next?

Verdict:

```text
PASS | PARTIAL | FAIL
```

## Review dimensions

- State clarity: active, completed, blocked, deferred.
- Backlog clarity: item status, mode, blockers, acceptance criteria, verification.
- Slice clarity: entry conditions, scope, exit criteria, verification.
- Lifecycle clarity: current vs historical vs superseded.
- Evidence quality: commands, results, freshness.
- ADR coverage: high-reversal-cost decisions documented.
- QA coverage: user-observed behavior captured as work items.
- Architecture coverage: candidates recorded, selected, or explicitly rejected.
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
P2 clarity/lifecycle issue
P3 polish
```

## Continue

- `CLEAR` -> next active plan slice or final handoff.
- `CLEAR_WITH_FOLLOWUPS` -> add follow-up notes or backlog items, then next slice.
- `COMPOUND_REQUIRED` -> `/gf-compound`.
- `EVOLUTION_REQUIRED` -> `/gf-compound`, then `/gf-evolve`.
- `BLOCKED` -> update the plan/backlog with blocked reason and evidence.
