# GuanFu Evolution: gf-plan vertical slice gate

Date: 2026-04-26T00:01:00-07:00
Status: APPLIED
Target Skill: gf-plan
Source Failure: P0 review found gf-plan could still approve horizontal schema-only/service-only/API-only/UI-only slices.
Source Compound Note: none
Supersedes: none

## Real Failure

The previous slice schema required outcomes, tests, verification commands, and exit criteria, but did not force each slice to prove an end-to-end path or classify HITL/AFK/blockers. A plan could look structured while still decomposing horizontally.

## RED Gate Evidence

- Current package run or simulation: simulated current gf-plan behavior from the uploaded package excerpt.
- Runtime unavailable reason, if any: no executable agent harness was included in the uploaded context.
- Forbidden behavior: approving implementation slices without an end-to-end path.
- Decision: PATCH_ALLOWED

## Baseline Pressure Scenario

Scenario: Plan accepts horizontal implementation slices
Target skill: `gf-plan`
Failure pressure: a feature spans schema, service/API, UI/user-visible behavior, and tests.
Expected baseline failure: agent creates schema-only/service-only/API-only/UI-only slices and marks them ready.
Forbidden behavior: approving slices that cannot be demonstrated or verified alone.
Pass criteria: plan includes Vertical Slice Gate; each slice has Type, Blocked By, End-to-End Path; horizontal smells are split, merged, or blocked.

## Baseline Execution Availability

Runtime execution unavailable; used simulation against the old skill text.

## Baseline Agent Behavior

The old text could fill the existing slice schema while omitting HITL/AFK, dependency, and end-to-end path checks. Nothing marked a schema-only, service-only, or UI-only slice as suspicious.

## Failure Pattern

Structured plans can hide horizontal decomposition when the schema records verification commands but not the integration path.

## Forbidden Behavior

Approving implementation slices that do not deliver a narrow but complete path through the layers needed for independently verifiable value.

## Patch

Added a Vertical Slice Gate to `skills/gf-plan/SKILL.md`, expanded the slice schema, updated `skills/gf-init/assets/templates/plan.md`, and added a pressure scenario.

## Exact Text Changed

- Added Vertical Slice Gate table and rules.
- Added `Type: HITL | AFK`.
- Added `Blocked By`.
- Added `User Stories / Requirements Covered`.
- Added `End-to-End Path` with data/state, interface/API/command, UI/user-visible behavior, and tests/verification.
- Updated Slice Index template with Type and Blocked By columns.

## Re-test Result

Static validation confirms the gate and fields exist in runtime skill, init template, and pressure scenario bank. Fresh agent behavior is not validated yet.

## Remaining Risk

An agent may still justify infrastructure-only slices too easily. Run a real pressure session before marking this VALIDATED.

## Changelog Entry

P0: `gf-plan` now requires a Vertical Slice Gate and enriched slice metadata before plan approval.

## Rollback Plan

Revert `skills/gf-plan/SKILL.md`, `skills/gf-init/assets/templates/plan.md`, and the corresponding pressure scenario entry.
