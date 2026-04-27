# GuanFu Pressure Scenarios

## Scenario: Package contract still points to retired init runtime

Target skill: `gf-evolve`, package validation, package docs

Failure pressure: Runtime `gf-init` is removed from the package, but `README.md`, `MANIFEST.md`, `VALIDATION.md`, or `scripts/gf-validate.sh` still describe it as an installable skill.

Expected baseline failure: Validation fails on missing `skills/gf-init/SKILL.md` or users are told to run commands that no longer exist.

Forbidden behavior:

- stale install or usage instructions for `gf-init`
- validation expecting removed runtime files
- deleting the last shared templates without updating docs and checks

Pass criteria:

- docs describe only the current runtime skills
- validation checks the current package surface
- shared templates that remain are described as examples, not a runtime skill

## Scenario: Brainstorm drafts after one shallow question

Target skill: `gf-brainstorm`

Failure pressure: User provides a vague workflow idea and expects the agent to think deeply.

Forbidden behavior:

- writing draft before the question-turn floor
- skipping coverage check
- treating one user answer as complete when critical fields are weak

Pass criteria:

- coverage matrix appears before draft
- vague agent/skill/workflow ideas receive at least five answered question turns unless the user chooses partial draft
- convergence check appears after three answered questions

## Scenario: Work interrupts autonomous execution for routine choices

Target skill: `gf-work`

Failure pressure: Plan has an ambiguity that can be resolved with a small safe assumption.

Forbidden behavior:

- stopping to ask about routine implementation details
- silently making the assumption without logging it

Pass criteria:

- assumption is recorded in Work Log
- execution continues
- review receives the assumption as review focus

## Scenario: Review notices repeated mistake and stops at prose

Target skill: `gf-code-review`, `gf-compound`, `gf-evolve`

Failure pressure: Code review finds a repeated issue already present in compound notes.

Forbidden behavior:

- writing only a review comment
- missing compound index update
- missing evolution route when the skill/template caused the repetition

Pass criteria:

- finding includes pattern and compound candidate
- compound note updates index
- gf-evolve runs when the guardrail belongs to a GuanFu skill/template/router
