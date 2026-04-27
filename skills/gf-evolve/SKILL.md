---
name: gf-evolve
description: Use when improving GuanFu skills from user feedback, repeated failures, compound notes, pressure scenarios, validation gaps, packaging drift, template drift, or new workflow requirements.
---


# gf-evolve

## Purpose

Improve GuanFu itself from observed failures.

Skills are living artifacts. A real failure becomes a pressure scenario, then a minimal skill/template/script patch, then a retest result.

## Autonomous contract

Continue without routine prompts when the change is local to GuanFu package files. Stop only for destructive operations, external publishing, or a change that alters the user's stated harness doctrine.

## Packaging rule

Runtime resources must live inside the owning skill directory. When package structure changes, update `README.md`, `MANIFEST.md`, `VALIDATION.md`, `tests/pressure-scenarios.md`, `references/pressure-scenarios.md`, and `scripts/gf-validate.sh` together.

Shared examples that are not installable runtime skills must be described as such in docs and validation.

## RED gate

Before changing any GuanFu skill, template, router text, validation script, or pressure scenario, produce RED evidence. If no RED evidence exists, the evolution artifact must remain `Status: PROPOSED`. Do not mark it `APPLIED` or `VALIDATED`.

Required before patching:

- Record the real failure or explicit user-requested failure pattern.
- Write or update a pressure scenario.
- Run or simulate the current package against that scenario. If runtime execution is unavailable, say why.
- Capture baseline agent behavior.
- Name the exact forbidden behavior.
- Only then patch the smallest relevant surface.

Rationalization table:

| Rationalization | Required response |
|---|---|
| "This is just a wording tweak" | Still needs a source failure or pressure scenario. |
| "The fix is obvious" | Record baseline behavior before patching. |
| "Simulation is enough" | Use simulation only when tool/runtime execution is unavailable, and say why. |
| "We can update multiple skills at once" | Split by failure pattern unless one scenario covers all changed surfaces. |
| "The user asked directly" | Treat the request as source failure only after naming the failure pattern and forbidden behavior. |

## Evolution cycle

1. Confirm the real failure or user-requested failure pattern.
2. Write or update a pressure scenario.
3. Run or simulate baseline with the current skill.
4. Record baseline agent behavior and forbidden behavior.
5. Set status to `RED_RECORDED` when RED evidence exists.
6. Patch the smallest relevant surface: skill, template, script, router, validation, or pressure scenario.
7. Re-run or simulate with a fresh agent context.
8. Record result.
9. Update `CHANGELOG.md`, `VALIDATION.md`, and package validation when applicable.

## Required artifact

```text
docs/guanfu/evolution/YYYY-MM-DD-HHMM-<skill-or-topic>.md
```

Use `docs/guanfu/skill-evolution.md` when available.

Required sections:

```markdown
## Real Failure
## RED Gate Evidence
## Baseline Pressure Scenario
## Baseline Execution Availability
## Baseline Agent Behavior
## Failure Pattern
## Forbidden Behavior
## Patch
## Exact Text Changed
## Re-test Result
## Remaining Risk
## Changelog Entry
## Rollback Plan
```

## Pressure scenarios

Use `references/pressure-scenarios.md` as the package-level scenario bank. Add scenarios with:

```text
Scenario:
Target skill:
Failure pressure:
Expected baseline failure:
Forbidden behavior:
Pass criteria:
Observed baseline result:
Retest result:
```

## Validation

Run package validation after changes:

```bash
bash scripts/gf-validate.sh
```

For package-surface changes, re-read the package docs and validation files after the patch and confirm they match the current tree.

## Status lifecycle

```text
PROPOSED -> RED_RECORDED -> APPLIED -> VALIDATED
```

Use `NEEDS_MORE_WORK` when the retest still fails. Use `SUPERSEDED` when a newer evolution note replaces the patch.

## Continue

After validation, return to the active flow: next slice, review, or package release.
