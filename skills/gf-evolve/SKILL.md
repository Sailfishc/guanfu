---
name: gf-evolve
version: 0.3.0
description: Use when improving GuanFu skills from user feedback, repeated failures, compound notes, pressure scenarios, validation gaps, stale templates, router drift, or new workflow requirements.
allowed-tools:
  - Read
  - Grep
  - Glob
  - Write
  - Edit
  - Bash
  - Agent
triggers:
  - /gf-evolve
  - improve skill
  - update guanfu skill
  - evolve skills
  - pressure scenario
  - skill iteration
---

# gf-evolve

## Overview

Improve GuanFu skills, templates, router rules, tests, and validation from real evidence.

Core principle: skills are living artifacts. First failure creates signal. Repeated failure triggers evolution. Every evolution should make the next agent more capable.

## Harness Position

`gf-evolve` is the final automated learning stage. It does not ask the user to re-litigate execution. It reads evidence from compound/review/user feedback, writes a pressure scenario, records baseline failure, patches the smallest surface, retests, and updates validation notes.

## Required Artifacts

Write one evolution note:

```text
docs/guanfu/evolution/YYYY-MM-DD-HHMM-<skill>-<key>.md
```

Update relevant files:

- `skills/gf-*/SKILL.md`
- `templates/*.md`
- `templates/AGENTS.guanfu.md`
- `scripts/gf-validate.sh`
- `tests/pressure-scenarios.md`
- `CHANGELOG.md`
- `VALIDATION.md`

## Workflow

### 1. Identify trigger evidence

Read:

```bash
find docs/guanfu/compound docs/guanfu/reviews docs/guanfu/evolution docs/guanfu/plans docs/guanfu/brainstorms -type f -name '*.md' 2>/dev/null | sort | tail -160
find skills templates scripts tests -type f 2>/dev/null | sort
bash scripts/gf-validate.sh 2>/dev/null || true
```

Evidence sources:

- compound note
- code review finding
- doc review finding
- user feedback
- failed pressure scenario
- repeated agent behavior
- missing trigger
- unclear routing
- stale template
- validation gap

### 2. Classify the skill gap

| Gap | Meaning |
|---|---|
| Trigger gap | Agent fails to load the skill. |
| Gate gap | Agent starts the next stage too early. |
| Template gap | Artifact lacks a required field. |
| Judgment gap | Skill gives weak decision criteria. |
| Verification gap | Skill allows completion without evidence. |
| Automation gap | Skill pauses during automated execution. |
| Iteration gap | Skill cannot learn from repeated failure. |
| Router gap | AGENTS or README points to stale skill names or wrong stage order. |
| Validation gap | Package can drift without failing checks. |

### 3. RED: write pressure scenario first

Add or update a scenario in `tests/pressure-scenarios.md` before editing the target skill.

Required scenario shape:

```markdown
### Scenario: <name>
Target skill: <gf-skill>
Source evidence: <compound/review/user feedback path>
Prompt: "<pressure prompt>"
Pressure type: urgency | simplicity | authority | sunk cost | ambiguity | automation | repeated-failure
Baseline expected failure: <what the current skill tends to do wrong>
Forbidden behavior:
- <behavior that must disappear>
Required artifacts:
- <artifact path or section>
Pass criteria:
- <observable behavior>
Observed baseline result: pending | failed | passed unexpectedly
Retest result: pending | passed | failed
```

### 4. Baseline failure record

Run or simulate the current skill against the scenario before patching.

Preferred: dispatch a fresh agent with the current skill and scenario.

Fallback: write a reasoned baseline based on observed evidence.

Record in the evolution note:

```markdown
## Baseline Agent Behavior

Method: fresh-agent | simulated-from-evidence
Observed failure:
- <specific behavior>
Rationalization:
- <why the skill allowed it>
```

If baseline passes unexpectedly, record that and look for a smaller or more accurate patch.

### 5. PATCH: make the smallest useful change

Patch the narrowest surface that closes the gap:

| Gap | Preferred patch |
|---|---|
| Trigger gap | skill `description`, triggers, router |
| Gate gap | readiness gate or stop/continue rule |
| Template gap | template fields and init script templates |
| Judgment gap | decision matrix or scoring rubric |
| Verification gap | fresh verification rule and evidence schema |
| Automation gap | no-mid-chain-human-loop rule and routing table |
| Iteration gap | compound/evolve hook |
| Router gap | `templates/AGENTS.guanfu.md`, `gf-init.sh`, README |
| Validation gap | `scripts/gf-validate.sh` |

Keep the change concise and searchable.

### 6. RETEST

Run:

```bash
bash scripts/gf-validate.sh
```

Then re-run or simulate the pressure scenario. Update:

- evolution note
- `tests/pressure-scenarios.md`
- `VALIDATION.md`
- `CHANGELOG.md`

### 7. Evolution note template

Use this structure:

```markdown
# GuanFu Evolution: <title>

Date: <ISO timestamp>
Status: PROPOSED | RED_RECORDED | APPLIED | VALIDATED | NEEDS_MORE_WORK | SUPERSEDED
Target Skill: <gf-skill>
Source Failure: <path or quote>
Source Compound Note: <path or none>
Supersedes: <path or none>

## Real Failure

## Baseline Pressure Scenario

## Baseline Agent Behavior

## Failure Pattern

## Patch

## Exact Text Changed

## Re-test Result

## Remaining Risk

## Changelog Entry

## Rollback Plan
```

### 8. Completion rules

Set `Status: VALIDATED` only after validation passes and the retest scenario passes or has a clearly recorded manual review result.

Set `Status: NEEDS_MORE_WORK` when the patch improves the behavior while leaving a known gap.

## Common Mistakes

| Mistake | Fix |
|---|---|
| Editing skills from taste alone | Tie the change to evidence. |
| Skipping baseline failure | Record RED before patching. |
| Changing many skills at once | Patch the smallest surface that closes the gap. |
| Updating description with workflow summary | Keep descriptions focused on triggering conditions. |
| Forgetting templates | Skill changes often need matching artifact fields. |
| Forgetting validation | Update and run `scripts/gf-validate.sh`. |
| Treating first failure as shame | Treat first failure as signal and repeated failure as evolution trigger. |

## Completion

Report:

```text
STATUS: DONE | DONE_WITH_CONCERNS | BLOCKED
SKILL_UPDATED: <skill/template/router/script>
EVOLUTION_NOTE: docs/guanfu/evolution/YYYY-MM-DD-HHMM-<skill>-<key>.md
PRESSURE_SCENARIO: added | updated
BASELINE: failed | passed unexpectedly | simulated
RETEST: passed | failed | simulated
VALIDATION: <commands and results>
NEXT: stop | /gf-compound
```
