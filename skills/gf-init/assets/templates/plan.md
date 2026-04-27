# Plan: <title>

Generated: <ISO timestamp>
Plan Status: ACTIVE | PAUSED | COMPLETED | ABANDONED
Plan Approval: DRAFT | APPROVED
Active Slice: S1 | none
Execution Mode: DISABLED | AUTOMATED_AFTER_PLAN
Source Brainstorm: <brainstorm path or none>
Related Work Items: <ids or none>
Previous Artifact: <path>
Next Artifact: /gf-work
Related ADRs: <paths>
Related Compound Notes: <paths>
Supersedes: <path or none>
Lifecycle: ACTIVE | COMPLETED | SUPERSEDED | ARCHIVED

## Goal

## Constraints

## Code Explore Summary

## ADR Decision Matrix

| Decision | Reversible? | Affects data? | Affects public API? | Cross-module? | New dependency? | ADR needed? |
|---|---|---|---|---|---|---|

## Vertical Slice Gate

| Slice | Type | Blocked By | End-to-End Path | Demoable / Verifiable Alone | Horizontal Smell? | Decision |
|---|---|---|---|---|---|---|
| S1 | AFK | none | data/state -> interface/API/command -> UI/user-visible behavior -> tests/verification | yes/no | none/schema-only/service-only/API-only/UI-only/tests-only/infra-only | ACCEPT/SPLIT/MERGE/BLOCK |

Rules:

- A slice must cross every layer required for user-visible behavior or concrete verification.
- Schema-only, service-only, API-only, UI-only, or tests-only slices are suspicious unless explicitly justified as infrastructure unlocks.
- Infrastructure-only slices must unlock a later vertical slice and include a concrete verification command.
- Mark `HITL` only when human taste, architecture, security, product, compliance, or irreversible judgment remains.

## Slice Index

| Slice | Status | Type | Blocked By | Backlog Item | Risk | Outcome | Verification | Review Focus |
|---|---|---|---|---|---|---|---|---|
| S1 | ACTIVE | AFK | none | none | | | | |

## Slices

### Slice S1: <name>

Status: ACTIVE
Type: HITL | AFK
Risk: LOW | MEDIUM | HIGH
Blocked By: <slice ids, work item ids, or none>
Backlog Item: <WI-id/path or none>
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

## Autonomous Execution Contract

After this plan is approved:
- `/gf-work` executes the active slice without routine user prompts.
- `/gf-code-review` reviews the result and routes findings without routine user prompts.
- `/gf-doc-review` checks handoff quality without routine user prompts.
- `/gf-qa` records manual QA findings as backlog items when the user reports behavior problems.
- `/gf-compound` records reusable lessons when failures or patterns appear.
- `/gf-evolve` updates skills/templates/pressure scenarios when the harness gap is real.

## Implementation Log

## Anomaly Log

## Backlog Log

## Code Review Log

## Doc Review Log

## QA Log

## Architecture Review Log

## Compound / Evolution Log
