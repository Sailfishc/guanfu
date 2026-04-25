---
name: gf-compound
description: Use when a mistake, bug, failed verification, review finding, repeated confusion, taste mismatch, or project-specific lesson should become reusable engineering knowledge.
---


# gf-compound

## Purpose

Turn failures, review findings, taste mismatches, and process surprises into reusable project memory.

A compound note should change future behavior. It must name the guardrail or explain why a guardrail is unnecessary.

## Autonomous contract

Continue without routine prompts. Capture the lesson, update the index, and route to `/gf-evolve` when the failure is repeated or caused by a skill/template/router gap.

## Required artifacts

```text
docs/guanfu/compound/YYYY-MM-DD-HHMM-<key>.md
docs/guanfu/compound/index.md
```

## Inputs

Read the source evidence:

- failed command or test output
- code review finding
- doc review finding
- plan anomaly
- user taste correction
- repeated confusion
- prior compound notes with similar keywords

## Failure budget status

Classify:

```text
FIRST_SEEN | REPEATED | UNKNOWN
```

Decision:

```text
RECORD_LESSON | STRENGTHEN_GUARDRAIL | ROUTE_TO_EVOLVE
```

Guideline:

- first seen: record lesson and lightweight prevention rule
- repeated: add or strengthen a guardrail
- skill/template/router gap: route to `/gf-evolve`

## Root cause

Write:

```markdown
## What Happened
## Evidence
## Root Cause
## Missed Signal
## Reusable Rule
```

Focus on the pattern, not only the incident.

## Guardrail decision

Every note must include:

```markdown
## Guardrail Decision

Chosen guardrail:
- [ ] Test
- [ ] Script
- [ ] Review checklist
- [ ] AGENTS rule
- [ ] ADR
- [ ] Template update
- [ ] Skill patch
- [ ] Pressure scenario
- [ ] No guardrail, reason: <explicit reason>

Owner skill:
- gf-brainstorm | gf-plan | gf-work | gf-code-review | gf-doc-review | gf-compound | gf-evolve | project-only

Applied now:
- yes/no

Follow-up:
- <path or next skill>
```

## Retrieval metadata

Include:

```markdown
## Retrieval Metadata
Applies To:
- Skill:
- Stage:
- Files / Areas:
- Keywords:
- Trigger:
Supersedes:
Related Notes:
```

Update `docs/guanfu/compound/index.md` with the lesson, guardrail, owner skill, trigger, and source.

## Continue

- project-only lesson -> return to the active flow.
- repeated issue -> continue to `/gf-evolve` if a skill/template/router/pressure scenario should change.
- review finding remains unfixed -> route to `/gf-work` with a repair slice.

