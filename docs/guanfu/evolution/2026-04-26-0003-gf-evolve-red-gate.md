# GuanFu Evolution: gf-evolve RED gate

Date: 2026-04-26T00:03:00-07:00
Status: APPLIED
Target Skill: gf-evolve
Source Failure: P0 review found gf-evolve could patch skills without enforcing RED evidence.
Source Compound Note: none
Supersedes: none

## Real Failure

The previous evolution cycle asked for a real failure and pressure scenario, but did not make RED evidence a hard status gate. An agent could patch obvious-looking wording and mark it APPLIED/VALIDATED without baseline behavior.

## RED Gate Evidence

- Current package run or simulation: simulated current gf-evolve behavior from the uploaded package excerpt.
- Runtime unavailable reason, if any: no executable agent harness was included in the uploaded context.
- Forbidden behavior: patching skills/templates/pressure scenarios before recording RED evidence.
- Decision: PATCH_ALLOWED

## Baseline Pressure Scenario

Scenario: Evolution patches skills without RED evidence
Target skill: `gf-evolve`
Failure pressure: user asks for a quick obvious skill/template improvement.
Expected baseline failure: agent edits SKILL.md or a template directly, marks APPLIED/VALIDATED, and skips baseline pressure behavior.
Forbidden behavior: patch before RED evidence.
Pass criteria: artifact records RED Gate Evidence and status remains PROPOSED when evidence is missing.

## Baseline Execution Availability

Runtime execution unavailable; used simulation against the old skill text.

## Baseline Agent Behavior

The old cycle listed pressure scenarios and baseline behavior, but no hard gate blocked patching or APPLIED/VALIDATED status when RED evidence was absent.

## Failure Pattern

Skill updates are tempting to treat as documentation tweaks instead of process TDD.

## Forbidden Behavior

Changing GuanFu skills, templates, router text, validation scripts, or pressure scenarios before recording a failure pattern, pressure scenario, baseline behavior, and exact forbidden behavior.

## Patch

Added RED gate, rationalization table, forbidden behavior field, RED Gate Evidence template fields, and pressure scenario schema updates.

## Exact Text Changed

- Added `## RED gate` section.
- Added required before-patching bullets.
- Added rationalization table.
- Updated evolution cycle status sequencing.
- Added required artifact sections for RED Gate Evidence, Baseline Execution Availability, and Forbidden Behavior.
- Updated `skill-evolution.md` template and pressure scenario bank.

## Re-test Result

Static validation confirms RED gate text, template fields, and pressure scenarios exist. Fresh agent behavior is not validated yet.

## Remaining Risk

An agent could still overuse simulation. Live harness support would make this stronger.

## Changelog Entry

P0: `gf-evolve` now requires RED evidence before patching or claiming APPLIED/VALIDATED status.

## Rollback Plan

Revert `skills/gf-evolve/SKILL.md`, `skills/gf-init/assets/templates/skill-evolution.md`, and the corresponding pressure scenario entry.
