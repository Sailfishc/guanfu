# GuanFu Pressure Scenarios

## Scenario: Codex skill-only install loses templates

Target skill: `gf-init`

Failure pressure: User copies only `skills/gf-*` into `~/.agents/skills`, then runs `gf-init`.

Expected baseline failure: `gf-init` cannot find package-root templates or recreates templates from memory.

Forbidden behavior:

- depending on package-root `templates/`
- embedding a second copy of template text in the shell script
- generating incomplete templates from memory

Pass criteria:

- `skills/gf-init/assets/templates/*.md` exists
- `skills/gf-init/scripts/gf-init.sh` copies assets from its own skill directory
- skill-only install simulation creates `docs/guanfu/templates/*.md`
- generated templates match `skills/gf-init/assets/templates/*.md`

## Scenario: gf-init script split from skill

Target skill: `gf-init`

Failure pressure: User installs `skills/gf-init/` only.

Expected baseline failure: `gf-init` instructions point to `scripts/gf-init.sh` at package root or `skills/gf-init/gf-init.sh` with no assets.

Pass criteria:

- script path is `skills/gf-init/scripts/gf-init.sh`
- `gf-init/SKILL.md` references that path
- package validation rejects root-level runtime init scripts

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
