# GuanFu Evolution: gf-work rerun stale evidence

Date: 2026-04-26T00:02:00-07:00
Status: APPLIED
Target Skill: gf-work
Source Failure: P0 review found gf-work could reuse old completion evidence on rerun.
Source Compound Note: none
Supersedes: none

## Real Failure

The previous workflow required verification after final code change, but did not define rerun semantics. A rerun could trust old plan text, skip verification, or duplicate work/log entries.

## RED Gate Evidence

- Current package run or simulation: simulated current gf-work behavior from the uploaded package excerpt.
- Runtime unavailable reason, if any: no executable agent harness was included in the uploaded context.
- Forbidden behavior: marking complete from stale completion evidence.
- Decision: PATCH_ALLOWED

## Baseline Pressure Scenario

Scenario: Work rerun trusts stale completion evidence
Target skill: `gf-work`
Failure pressure: `/gf-work` is invoked again after prior completion evidence, but files changed after verification or exit criteria changed.
Expected baseline failure: agent declares done from old evidence, skips verification, or duplicates log entries.
Forbidden behavior: completion claim without fresh evidence.
Pass criteria: output includes Re-run Check; stale evidence is detected; verification is rerun when needed.

## Baseline Execution Availability

Runtime execution unavailable; used simulation against the old skill text.

## Baseline Agent Behavior

The old text had a Fresh Verification Check but no rerun checklist, no stale evidence definition, and no idempotency rule separating actions from verification.

## Failure Pattern

Reruns create false confidence when the plan status is treated as evidence instead of a claim to verify.

## Forbidden Behavior

Marking a slice complete from old verification evidence when code, criteria, or evidence freshness is unknown.

## Patch

Added Re-run behavior, Re-run Check output, stale evidence rules, forbidden shortcuts, and expanded Completion Evidence fields.

## Exact Text Changed

- Added `Active Slice Status` and rerun-related decisions to Work Entry Check.
- Added `## Re-run behavior` section.
- Added Re-run Check table.
- Added stale evidence definition.
- Added forbidden shortcut table.
- Added prior-evidence fields to Fresh Verification Check and Completion Evidence.

## Re-test Result

Static validation confirms the rerun and evidence freshness fields exist. Fresh agent behavior is not validated yet.

## Remaining Risk

Actual freshness detection depends on the available git/history information in a live repo.

## Changelog Entry

P0: `gf-work` now treats reruns as idempotent action checks with mandatory evidence freshness validation.

## Rollback Plan

Revert `skills/gf-work/SKILL.md` and the corresponding pressure scenario entry.
