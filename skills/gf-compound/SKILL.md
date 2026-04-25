---
name: gf-compound
version: 0.2.0
description: Use when a mistake, bug, failed verification, review finding, repeated confusion, or project-specific lesson should become reusable engineering knowledge.
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
  - /gf-compound
  - capture learning
  - avoid this next time
  - mistake log
  - lesson learned
  - compound note
---

# gf-compound

## Overview

Turn mistakes and hard-won lessons into reusable project memory.

Core principle: the same bug twice is a process failure. A compound note should prevent the next agent from paying the same tuition.

## Required Artifacts

Create one note:

```text
docs/guanfu/compound/YYYY-MM-DD-<key>.md
```

Update:

```text
docs/guanfu/compound/index.md
```

If the lesson is about GuanFu skill behavior, recommend `gf-evolve`.

## Workflow

### 1. Gather evidence

Read relevant sources:

- review findings
- plan work log
- failing command output
- git diff or changed files
- ADRs
- user feedback
- repeated agent behavior

### 2. Classify the lesson

| Type | Use when |
|---|---|
| bug | Defect reached implementation, review, or production. |
| review-pattern | Review found a recurring quality issue. |
| process | Workflow skipped a gate or caused confusion. |
| architecture | Structural decision created leverage or risk. |
| tooling | Command, environment, or setup caused wasted time. |
| taste | Product or code-quality judgment should guide future work. |
| skill | GuanFu skill behavior needs improvement. |

### 3. Extract reusable rule

A note must answer:

1. What happened?
2. Why did it happen?
3. What signal should have caught it earlier?
4. What rule prevents it next time?
5. How can a future agent verify the rule was followed?

### 4. Prefer executable guardrails

Guardrails include:

- test
- lint/check script
- AGENTS rule
- ADR
- template field
- review rubric
- skill evolution via `gf-evolve`

### 5. Write compound note

Use `templates/compound-note.md`.

### 6. Update index

Append a row to `docs/guanfu/compound/index.md`:

```markdown
| Date | Type | Lesson | Guardrail | Source |
|---|---|---|---|---|
```

### 7. Handoff

If the guardrail requires skill or template modification, recommend `gf-evolve`.

## Common Mistakes

| Mistake | Fix |
|---|---|
| Writing "be careful" | Write a concrete prevention rule and verification command. |
| Capturing symptoms only | Name root cause and missed signal. |
| Creating notes nobody can find | Add index row and search keywords. |
| Using prose when a test can prevent recurrence | Recommend automation first. |
| Updating AGENTS for one-off trivia | Add broad rules only. |

## Completion

Report:

```text
STATUS: DONE | DONE_WITH_CONCERNS | NEEDS_CONTEXT
NOTE: docs/guanfu/compound/YYYY-MM-DD-<key>.md
INDEX: updated | not updated, <reason>
GUARDRAIL: test | checklist | ADR | AGENTS | evolution | none
NEXT: gf-evolve | stop
```
