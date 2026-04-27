# GuanFu Evolution: gf-guardrails executable safety

Date: 2026-04-27T00:00:00-07:00
Status: APPLIED
Target Skill: gf-guardrails
Source Failure: v0.5 architecture review identified a prevention/backlog gap.
Source Compound Note: none
Supersedes: none

## Real Failure

Destructive git safety was previously prompt-level and could be bypassed by an agent under pressure.

## RED Gate Evidence

- Current package run or simulation: simulated from the uploaded GuanFu package and reviewed against v0.5 pressure scenarios.
- Runtime unavailable reason, if any: no live agent harness was available in this environment; static and script validation were run after patching.
- Forbidden behavior: dangerous git command executes because no hook blocks it.
- Decision: PATCH_ALLOWED

## Baseline Pressure Scenario

See `skills/gf-evolve/references/pressure-scenarios.md`.

## Baseline Execution Availability

Runtime execution unavailable; used scenario simulation against the old package text.

## Baseline Agent Behavior

The old package could route around this gap using plan/review prose, but lacked a durable skill/template/guardrail contract.

## Failure Pattern

A single stage can look locally correct while the whole GuanFu system loses state, prevention, or executable safety.

## Forbidden Behavior

dangerous git command executes because no hook blocks it.

## Patch

Added gf-guardrails, dangerous-git block hook, installer/auditor, gf-init audit integration, and pressure scenario.

## Exact Text Changed

See the v0.5 package files in `skills/gf-*`, `skills/gf-init/assets/templates/`, router text, and pressure scenarios.

## Re-test Result

Static validation and shell-script checks pass in the generated package. Fresh agent behavior is not validated yet.

## Remaining Risk

These skills need live project pressure testing before claiming `VALIDATED`.

## Changelog Entry

v0.5: Added gf-guardrails, dangerous-git block hook, installer/auditor, gf-init audit integration, and pressure scenario.

## Rollback Plan

Revert the target skill, related templates/router changes, and the matching pressure scenario.
