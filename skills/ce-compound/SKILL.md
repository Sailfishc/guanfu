---
name: ce-compound
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
  - /ce-compound
  - capture learning
  - avoid this next time
  - mistake log
  - lesson learned
  - compound note
---

# CE Compound

## Overview

Turn mistakes and hard-won lessons into reusable project memory.

Core principle: the same bug twice is a process failure. A compound note should prevent the next agent from paying the same tuition.

## Required Artifacts

Create one note:

```text
docs/ce/compound/YYYY-MM-DD-<key>.md
```

Update the index:

```text
docs/ce/compound/index.md
```

Optionally update:

- Related plan `## Work Log` or `## Review Log`
- Related ADR
- `AGENTS.md` taste or routing rules when the lesson is general and recurring
- Tests or guardrails when the lesson can be automated

## Workflow

### 1. Identify the lesson type

Classify the event:

| Type | Use when |
|---|---|
| `bug` | A defect reached implementation, review, or production |
| `review-pattern` | Review found a recurring quality issue |
| `process` | The workflow failed, skipped a gate, or caused confusion |
| `architecture` | A structural decision or coupling lesson emerged |
| `tooling` | A command, environment, or setup detail caused wasted time |
| `taste` | A product or code-quality judgment should guide future work |

### 2. Gather evidence

Read the source material:

- Review document
- Plan work log
- Failing command output
- Relevant files
- Related ADRs
- Git diff or commit

Do not write a vague lesson. Quote concrete evidence, but keep it brief.

### 3. Extract the reusable rule

A compound note must answer five questions:

1. What happened?
2. Why did it happen?
3. What signal should have caught it earlier?
4. What rule prevents it next time?
5. How can a future agent verify the rule was followed?

If you cannot answer all five, the note is not ready. Ask or investigate.

### 4. Prefer automation over memory

Before writing only prose, ask:

- Can this become a test?
- Can this become a lint rule?
- Can this become a checklist item in `AGENTS.md`?
- Can this become a template field in plan/review docs?
- Can this become an ADR?

If yes, recommend the guardrail. Prose is the fallback, not the highest leverage action.

### 5. Write the compound note

Template:

```markdown
# Compound Note: <key>

Date: <YYYY-MM-DD>
Type: bug | review-pattern | process | architecture | tooling | taste
Status: ACTIVE | SUPERSEDED
Severity: LOW | MEDIUM | HIGH
Related Plan: <path or none>
Related Review: <path or none>
Related ADR: <path or none>
Files:
- <file>

## What Happened
<concrete event>

## Root Cause
<why it happened, not just where>

## Missed Signal
<what should have revealed it earlier>

## Prevention Rule
<one operational rule future agents must follow>

## Verification
Commands or checks:
- `<command>`
Expected result:
- <result>

## Automation Candidate
Test:
Lint/check:
Template update:
AGENTS.md update:

## Example
Bad:
<small example>
Good:
<small example>

## Search Keywords
<terms future agents might search>
```

### 6. Update the compound index

Append:

```markdown
| Date | Key | Type | Severity | Rule | Applies To |
|---|---|---|---|---|---|
| YYYY-MM-DD | [key](YYYY-MM-DD-key.md) | type | severity | one-line prevention rule | files or area |
```

If `index.md` does not exist, create it with:

```markdown
# Compound Engineering Notes

Reusable project lessons. Read before planning, working, or reviewing related areas.

| Date | Key | Type | Severity | Rule | Applies To |
|---|---|---|---|---|---|
```

### 7. Update router or taste constraints when appropriate

Only update `AGENTS.md` when the rule is broadly useful and not one-off.

Good `AGENTS.md` update:

```markdown
- Before changing billing calculations, read `docs/ce/compound/2026-04-25-billing-rounding.md` and run `npm test billing`.
```

Bad update:

```markdown
- Be careful.
```

### 8. Handoff

If the note requires code, tests, or docs changes, create or update a plan slice rather than doing hidden work.

## Common Mistakes

| Mistake | Fix |
|---|---|
| Writing "remember to be careful" | Write a concrete prevention rule and verification command. |
| Capturing symptoms only | Name root cause and missed signal. |
| Creating notes nobody will find | Add search keywords and update the index. |
| Using prose when a test would prevent recurrence | Recommend automation first. |
| Updating AGENTS.md for one-off trivia | Only add broad, recurring rules. |

## Completion

Report:

```text
STATUS: DONE | NEEDS_CONTEXT | DONE_WITH_CONCERNS
NOTE: docs/ce/compound/YYYY-MM-DD-<key>.md
INDEX: updated | not updated, <reason>
GUARDRAIL: created | recommended | not applicable
```
