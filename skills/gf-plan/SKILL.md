---
name: gf-plan
description: Use when an approved brainstorm, design, or product decision exists and the user wants implementation slices, architecture decisions, ADRs, or an active engineering plan before coding.
---


# gf-plan

## Purpose

Turn an approved brainstorm into a living implementation plan with slices, ADR decisions, verification commands, rollback paths, and an autonomous execution contract.

This is a human-loop stage. Ask for decisions that affect goal, scope, architecture, slice order, verification, risk, or taste. After plan approval, execution becomes autonomous.

## Boundary

Planning only. Product code changes belong to `/gf-work`.

Required artifact:

```text
docs/guanfu/plans/YYYY-MM-DD-HHMM-<slug>-plan.md
```

## Input readiness

Read:

- latest approved `docs/guanfu/brainstorms/*.md`
- related `docs/guanfu/context/*.md`
- `docs/guanfu/compound/index.md` and relevant notes
- `docs/guanfu/evolution/*.md` when skill behavior matters
- `AGENTS.md` or `agents.md`
- existing ADRs and related plans

Use Bash when useful:

```bash
find docs/guanfu -maxdepth 3 -type f -name '*.md' 2>/dev/null | sort | tail -120
git branch --show-current 2>/dev/null || true
git status --short 2>/dev/null || true
```

Before writing the plan, output:

```markdown
## Plan Input Check
Source: <brainstorm path or source>
Source Status: APPROVED | DRAFT | PARTIAL | UNKNOWN
Readiness: COMPLETE | PARTIAL | UNKNOWN
Open Questions Blocking Plan: yes/no
Plan-Changing Assumptions:
- <assumption or none>
Decision: PLAN | RETURN_TO_BRAINSTORM | PLAN_WITH_RISKS
```

Rules:

- `APPROVED + COMPLETE` -> `PLAN`.
- `PARTIAL` -> `PLAN_WITH_RISKS`, with risks in the plan.
- `DRAFT` or `UNKNOWN` -> ask whether to return to `/gf-brainstorm` or continue with explicit risk.

## Code explore

When the plan touches existing code, dispatch an independent read-only code explore agent.

Prompt:

```text
Explore the codebase for this GuanFu plan.
Read only. Return likely files, current patterns, integration points, test commands, risks, dependencies, ADR candidates, relevant compound notes, and prior review patterns.
```

## Discuss plan-changing gaps

Ask one focused question at a time when a missing decision changes slice order, architecture, verification, risk, or taste. Use AskUserQuestion for explicit plan-changing choices and final approval.

Typical plan questions:

- Which slice should create value or learning first?
- Which behavior must remain stable?
- Which verification command proves each slice?
- Which decision has high reversal cost?
- Which failure is acceptable in the first run and should be captured for review?

## ADR matrix

For meaningful decisions, include:

```markdown
| Decision | Reversible? | Affects data? | Affects public API? | Cross-module? | New dependency? | ADR needed? |
|---|---|---|---|---|---|---|
```

Create an ADR when reversal cost is high, data/API changes exist, a new dependency is added, or an agent routing/harness decision changes future behavior.

## Vertical Slice Gate

Before writing slice details, reject horizontal plans. Each accepted slice must be a tracer bullet: a narrow path that crosses every layer needed for behavior-visible or verification-visible value.

Write this gate table into the plan before `## Slices`:

```markdown
## Vertical Slice Gate

| Slice | Type | Blocked By | End-to-End Path | Demoable / Verifiable Alone | Horizontal Smell? | Decision |
|---|---|---|---|---|---|---|
| S1 | AFK | none | data/state -> interface/API/command -> UI/user-visible behavior -> tests/verification | yes/no | none/schema-only/service-only/API-only/UI-only/tests-only/infra-only | ACCEPT/SPLIT/MERGE/BLOCK |
```

Rules:

- A good slice crosses every layer required for user-visible behavior or concrete verification.
- Schema-only, service-only, API-only, UI-only, or tests-only slices are suspicious. Split or merge them unless they are explicit infrastructure unlocks.
- Infrastructure-only slices are allowed only when they unblock a later vertical slice and include a concrete verification command.
- Every accepted slice must be demoable or verifiable on its own.
- Prefer many thin `AFK` slices over a few broad slices. Mark `HITL` only when human taste, architecture, security, product, compliance, or irreversible judgment remains.
- Record dependencies in `Blocked By`. A plan may describe a dependency graph, but exactly one slice starts `ACTIVE`.
- If `Horizontal Smell?` is not `none`, set `Decision` to `SPLIT`, `MERGE`, or `BLOCK` before approval.

## Slice schema

Each slice must use:

```markdown
### Slice S<n>: <name>

Status: TODO | ACTIVE | COMPLETED | BLOCKED | DEFERRED
Type: HITL | AFK
Risk: LOW | MEDIUM | HIGH
Blocked By: <slice ids or none>
User Stories / Requirements Covered:
- <source requirement or none>

#### Outcome
#### End-to-End Path
- Data / state:
- Interface / API / command:
- UI / user-visible behavior:
- Tests / verification:

#### Entry Conditions
#### Scope
#### Out of Scope
#### Files / APIs Expected To Change
#### Test-First Plan
#### Verification Commands
#### Rollback / Revert Path
#### Review Focus
#### Compound Triggers
#### Exit Criteria
#### Completion Evidence
```

Exactly one slice starts as `ACTIVE`. Others start as `TODO`. Every slice must pass the Vertical Slice Gate before approval. Each non-active slice keeps its `Blocked By` value so future parallelization remains possible, but GuanFu still executes one active slice at a time.

## Autonomous execution contract

Write this section into the plan:

```markdown
## Autonomous Execution Contract

After this plan is approved:
- `/gf-work` executes the active slice without routine user prompts.
- `/gf-code-review` reviews the result and routes findings without routine user prompts.
- `/gf-doc-review` checks handoff quality without routine user prompts.
- `/gf-compound` records reusable lessons when failures or patterns appear.
- `/gf-evolve` updates skills/templates/pressure scenarios when the harness gap is real.

Allowed autonomous decisions:
- infer small implementation details consistent with the approved plan
- add focused tests that prove slice behavior
- record assumptions in the work log
- create follow-up slices for P2 findings
- route P0/P1 findings back to `/gf-work`
- write compound notes and evolution notes from observed failures

Stop only for destructive or irreversible external action, missing credentials or access, legal/compliance/security ambiguity requiring human authority, or architecture conflict that invalidates the approved goal.
```

## Write living plan

Use `docs/guanfu/plans/PLAN_TEMPLATE.md` when available. Header must include:

```markdown
Plan Status: ACTIVE
Plan Approval: DRAFT
Active Slice: S1
Execution Mode: DISABLED
Source Brainstorm: <path>
```

## Approval gate

Ask the user:

```text
A) Approve plan and start autonomous execution at /gf-work S1
B) Revise slices or decisions
C) Return to /gf-brainstorm
```

When approved, set:

```markdown
Plan Approval: APPROVED
Execution Mode: AUTOMATED_AFTER_PLAN
```

Then continue to `/gf-work`.
