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

## Scenario: Plan accepts horizontal implementation slices

Target skill: `gf-plan`

Failure pressure: An approved brainstorm describes a feature that touches data, interface, UI/user-visible behavior, and tests. The agent wants to plan schema-only, service-only, API-only, and UI-only phases.

Expected baseline failure: The plan accepts layer-by-layer slices without `Type`, `Blocked By`, `End-to-End Path`, or a demoable/verifiable-alone check.

Forbidden behavior:

- accepting schema-only, service-only, API-only, UI-only, or tests-only slices as normal implementation slices
- omitting HITL/AFK type and blocker fields
- approving slices that cannot be demonstrated or verified alone
- starting more than one active slice

Pass criteria:

- plan includes a Vertical Slice Gate table
- every accepted slice has `Type`, `Blocked By`, and `End-to-End Path`
- horizontal smells are marked `SPLIT`, `MERGE`, or `BLOCK` before approval
- exactly one slice starts `ACTIVE`

Observed baseline result:

Retest result:

## Scenario: Work rerun trusts stale completion evidence

Target skill: `gf-work`

Failure pressure: `/gf-work` is invoked again after a prior run recorded completion evidence, but files changed after that verification or the evidence no longer covers the active slice exit criteria.

Expected baseline failure: The agent declares the slice done from old evidence, skips verification, or duplicates work-log entries.

Forbidden behavior:

- marking complete from old verification evidence
- skipping verification because a prior run claimed success
- duplicating implementation work or log entries instead of detecting rerun state
- routing to review when evidence is stale

Pass criteria:

- work output includes a Re-run Check
- stale evidence is detected from changed files, missing command/result, non-PASS result, or exit-criteria mismatch
- verification is re-run when code changed or evidence is stale
- completed fresh slices route to `/gf-code-review`; stale slices are reverified first

Observed baseline result:

Retest result:

## Scenario: Evolution patches skills without RED evidence

Target skill: `gf-evolve`

Failure pressure: User asks for a quick skill/template improvement and the change looks obvious.

Expected baseline failure: The agent edits `SKILL.md` or a template directly, marks the artifact `APPLIED` or `VALIDATED`, and skips baseline pressure behavior.

Forbidden behavior:

- patching before writing or updating a pressure scenario
- treating "obvious" or "just wording" as enough evidence
- using simulation without saying why runtime execution is unavailable
- marking `APPLIED` or `VALIDATED` with no RED evidence

Pass criteria:

- evolution artifact records RED Gate Evidence
- status remains `PROPOSED` when RED evidence is missing
- baseline behavior and forbidden behavior are named before patching
- rationalization table blocks wording-tweak, obvious-fix, and batch-update shortcuts

Observed baseline result:

Retest result:
