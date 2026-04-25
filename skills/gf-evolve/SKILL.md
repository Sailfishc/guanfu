---
name: gf-evolve
version: 0.2.0
description: Use when improving GuanFu skills from user feedback, repeated failures, compound notes, pressure scenarios, validation gaps, or new workflow requirements.
allowed-tools:
  - Read
  - Grep
  - Glob
  - Write
  - Edit
  - Bash
  - AskUserQuestion
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

Improve GuanFu skills as living artifacts. Use evidence from real failures, user feedback, review findings, and compound notes to update skills and validation scenarios.

Core principle: a skill is part of the engineering system. It should learn from failure with the same discipline as production code.

## Required Artifacts

Write one evolution note:

```text
docs/guanfu/evolution/YYYY-MM-DD-<skill>-<key>.md
```

Update relevant files:

- `skills/gf-*/SKILL.md`
- `tests/pressure-scenarios.md`
- `CHANGELOG.md`
- `VALIDATION.md`
- templates when the fix belongs in a document shape

## Workflow

### 1. Identify trigger evidence

Use at least one evidence source:

- compound note
- code review finding
- doc review finding
- user feedback
- failed pressure scenario
- repeated agent behavior
- missing trigger or unclear routing

Write the source into the evolution note.

### 2. Classify the skill gap

| Gap | Meaning |
|---|---|
| Trigger gap | Agent fails to load the skill. |
| Gate gap | Agent starts the next stage too early. |
| Template gap | Artifact lacks a required field. |
| Judgment gap | Skill gives weak decision criteria. |
| Verification gap | Skill allows completion without evidence. |
| Iteration gap | Skill cannot learn from repeated failure. |

### 3. Write a pressure scenario first

Before editing the skill, add or draft a scenario:

```markdown
### Scenario: <name>
Prompt: "<pressure prompt>"
Expected behavior: <specific behavior>
Failure mode observed: <what happened before>
```

Use combined pressure when relevant: urgency, simplicity, authority, sunk cost, ambiguity.

### 4. Make the smallest useful skill change

Edit the target skill to close the gap:

- improve `description` for trigger gaps
- add hard gate for premature transitions
- add template fields for missing artifacts
- add examples for judgment gaps
- add verification checklist for completion gaps
- add handoff rules for routing gaps

Keep the skill searchable and concise.

### 5. Validate

Run lightweight checks:

```bash
bash scripts/gf-validate.sh
```

Then run or simulate the pressure scenario with an agent when available.

### 6. Update version notes

Update:

- `CHANGELOG.md`
- `VALIDATION.md`
- evolution note

### 7. Completion report

Report:

```text
STATUS: DONE | DONE_WITH_CONCERNS | NEEDS_CONTEXT
SKILL_UPDATED: <skill>
EVOLUTION_NOTE: docs/guanfu/evolution/YYYY-MM-DD-<skill>-<key>.md
PRESSURE_SCENARIO: added | drafted | pending
VALIDATION: <commands and results>
```

## Common Mistakes

| Mistake | Fix |
|---|---|
| Editing skills from taste alone | Tie the change to evidence. |
| Changing many skills at once | Change the smallest set that closes the gap. |
| Skipping pressure scenario | Write the scenario before editing. |
| Updating description with workflow summary | Keep description focused on triggering conditions. |
| Forgetting validation | Update `VALIDATION.md` and run checks. |
