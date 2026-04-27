# Plan: <title>

Generated: <ISO timestamp>
Plan Status: ACTIVE | PAUSED | COMPLETED | ABANDONED
Plan Approval: DRAFT | APPROVED
Active Slice: S1 | none
Execution Mode: DISABLED | AUTOMATED_AFTER_PLAN
Source: <brainstorm path>
Previous Artifact: <path>
Next Artifact: /gf-work
Related ADRs: <paths>
Related Compound Notes: <paths>
Supersedes: <path or none>

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

| Slice | Status | Type | Blocked By | Risk | Outcome | Verification | Review Focus |
|---|---|---|---|---|---|---|---|
| S1 | ACTIVE | AFK | none | | | | |

## Slices

### Slice S1: <name>

Status: ACTIVE
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

## Implementation Log

## Anomaly Log

## Code Review Log

## Doc Review Log

## Compound / Evolution Log
