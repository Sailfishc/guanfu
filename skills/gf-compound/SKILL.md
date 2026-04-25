---
name: gf-compound
version: 0.3.0
description: Use when a mistake, bug, failed verification, review finding, repeated confusion, taste gap, or project-specific lesson should become reusable engineering knowledge.
allowed-tools:
  - Read
  - Grep
  - Glob
  - Write
  - Edit
  - Bash
  - Agent
triggers:
  - /gf-compound
  - capture learning
  - avoid this next time
  - mistake log
  - lesson learned
  - compound note
---

# gf-compound

## Overview

Turn mistakes, review findings, taste gaps, and hard-won lessons into reusable project memory and guardrails.

Core principle: first failure is a signal. Repeated failure is a harness gap. Compound notes turn signals into future leverage.

## Harness Position

`gf-compound` is an automated post-review stage. It does not ask the user to decide mid-chain. It records what happened, selects the strongest guardrail, updates the compound index, and routes skill/process gaps to `gf-evolve`.

## Required Artifacts

Create one note:

```text
docs/guanfu/compound/YYYY-MM-DD-HHMM-<key>.md
```

Update:

```text
docs/guanfu/compound/index.md
```

If the lesson concerns GuanFu behavior, route to `gf-evolve` after writing the note.

## Workflow

### 1. Gather evidence

Read relevant sources:

```bash
find docs/guanfu/plans docs/guanfu/reviews docs/guanfu/adr docs/guanfu/evolution -type f -name '*.md' 2>/dev/null | sort | tail -120
find docs/guanfu/compound -type f -name '*.md' 2>/dev/null | sort | tail -120
git status --short 2>/dev/null || true
git log --oneline -20 2>/dev/null || true
```

Use evidence from review findings, plan work log, failing command output, git diff, ADRs, user feedback, and repeated agent behavior.

### 2. Classify the lesson

| Type | Use when |
|---|---|
| bug | Defect reached implementation, review, or production. |
| review-pattern | Review found a recurring quality issue. |
| process | Workflow skipped a gate or caused confusion. |
| architecture | Structural decision created leverage or risk. |
| tooling | Command, environment, or setup caused wasted time. |
| docs | Artifact could not support fresh-agent handoff. |
| taste | Product or code-quality judgment should guide future work. |
| skill | GuanFu skill behavior needs improvement. |

### 3. Determine failure budget status

Write:

```markdown
## Failure Budget Status

Occurrence: FIRST_SEEN | REPEATED | UNKNOWN
First seen evidence: <path or none>
Similar prior notes:
- <path or none>
Decision: RECORD_LESSON | STRENGTHEN_GUARDRAIL | ROUTE_TO_EVOLVE
```

Rules:

- `FIRST_SEEN`: record lesson and choose a guardrail.
- `REPEATED`: strengthen guardrail and route to `gf-evolve` when the existing harness failed to prevent recurrence.
- `UNKNOWN`: search index and proceed conservatively.

### 4. Extract reusable rule

A note must answer:

1. What happened?
2. Why did it happen?
3. What signal should have caught it earlier?
4. What rule prevents it next time?
5. How can a future agent verify the rule was followed?
6. Which skill or stage should load this lesson?

### 5. Guardrail Decision

This section is mandatory:

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
- [ ] No guardrail, reason: <explicit reason>

Owner skill:
- gf-brainstorm | gf-plan | gf-work | gf-code-review | gf-doc-review | gf-compound | gf-evolve | project-only

Applied now: yes/no
Follow-up: <path or next skill>
Verification: <how future agents know this guardrail worked>
```

Prefer executable guardrails. A test, script, checklist, or template field beats a reminder.

### 6. Retrieval metadata

Add metadata so future stages can find the note:

```markdown
## Retrieval Metadata

Applies To:
- Skill: <gf-skill or project-only>
- Stage: brainstorm | plan | work | code-review | doc-review | compound | evolve
- Files / Areas: <paths or modules>
- Keywords: <search terms>
- Trigger: <when future agents should load this>

Supersedes: <path or none>
Related Notes:
- <path>
```

### 7. Write compound note

Use `templates/compound-note.md`. Include evidence, failure budget status, guardrail decision, retrieval metadata, and future usage.

### 8. Update index

Append to `docs/guanfu/compound/index.md`:

```markdown
| Date | Type | Lesson | Guardrail | Owner Skill | Trigger | Source |
|---|---|---|---|---|---|---|
```

If the index uses an older schema, extend it safely and keep existing rows.

### 9. Continue to evolve when needed

Route to `gf-evolve` when:

- the note type is `skill`
- a repeated failure survived an existing guardrail
- a skill asked too few questions, drafted too early, skipped verification, paused during execution, or missed a required artifact
- a template or router gap caused the failure

## Common Mistakes

| Mistake | Fix |
|---|---|
| Writing "be careful" | Write a concrete prevention rule and verification method. |
| Capturing symptoms only | Name root cause and missed signal. |
| Creating notes nobody can find | Add retrieval metadata and index row. |
| Using prose when a test can prevent recurrence | Prefer executable guardrails. |
| Stopping at first-failure blame | Treat first failure as signal and improve the harness. |
| Missing repeated-failure escalation | Route repeated failures to `gf-evolve`. |

## Completion

Report:

```text
STATUS: DONE | DONE_WITH_CONCERNS | BLOCKED
NOTE: docs/guanfu/compound/YYYY-MM-DD-HHMM-<key>.md
INDEX: updated | not updated, <reason>
OCCURRENCE: FIRST_SEEN | REPEATED | UNKNOWN
GUARDRAIL: test | script | checklist | ADR | AGENTS | template | skill-patch | none
OWNER_SKILL: <gf-skill or project-only>
NEXT: /gf-evolve | /gf-work | stop
```
