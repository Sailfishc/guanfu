---
name: gf-brainstorm
version: 0.2.0
description: Use when a user has an early product or engineering idea, fuzzy requirement, unclear problem statement, or wants to explore options before planning or implementation.
allowed-tools:
  - Read
  - Grep
  - Glob
  - Write
  - Edit
  - AskUserQuestion
  - WebSearch
  - Agent
triggers:
  - /gf-brainstorm
  - brainstorm
  - idea
  - help me think through
  - unclear requirement
---

# gf-brainstorm

## Overview

Turn a fuzzy idea into a clear problem frame, explicit assumptions, alternatives, and a written brainstorm artifact.

Core principle: the first human framing is usually incomplete. Expand it, challenge it, and make the user choose.

## Hard Gate

Do not write code, scaffold files, create an implementation plan, or start implementation in this skill.

The output is a brainstorm document and a handoff recommendation to `gf-plan`.

## Required Artifact

```text
docs/guanfu/brainstorms/YYYY-MM-DD-<slug>.md
```

## Workflow

### 1. Recover context

Read, if present:

```text
AGENTS.md
agents.md
docs/guanfu/README.md
docs/guanfu/context/*.md
docs/guanfu/compound/index.md
recent docs/guanfu/brainstorms/*.md
```

If `docs/guanfu/` is missing, recommend `gf-init` before continuing.

### 2. Ask one high-value question at a time

Use questions that clarify outcome:

- Who is the actor or user?
- What pain or job exists today?
- What is the current workaround?
- What would success look like?
- Which constraints are real?
- Which part is in scope for the first slice?
- What would make this idea worth discarding?

Prefer multiple choice when the user is stuck. Use open questions when the user has context.

### 3. Generate 2-3 approaches

At least two approaches are required:

| Approach | Shape |
|---|---|
| Minimal | fastest useful wedge |
| Strong | best long-term direction |
| Lateral | unusual path or framing |

For each approach, include effort, risk, what it proves, and what it leaves out.

### 4. Challenge premises

Write the premises as explicit claims:

```text
PREMISES:
1. ...
2. ...
3. ...
```

Ask the user to confirm or revise.

### 5. Write brainstorm document

Use the template in `templates/brainstorm.md` or the initialized repo template.

The document must include:

- raw idea
- reframed idea
- target actor
- pain / job
- current workaround
- constraints
- options considered
- recommendation
- premises
- success criteria
- non-goals
- open questions
- handoff to `gf-plan`

### 6. Handoff

After the user approves the brainstorm:

```text
NEXT: gf-plan
```

## Common Mistakes

| Mistake | Fix |
|---|---|
| Starting implementation from a vivid idea | Write the brainstorm artifact first. |
| Asking many questions at once | Ask one question and wait. |
| Treating "users" as a target actor | Name a specific role or person type. |
| Producing only one approach | Give at least two real choices. |
| Skipping premises | Make assumptions visible before planning. |

## Completion

Report:

```text
STATUS: DONE | DONE_WITH_CONCERNS | NEEDS_CONTEXT
ARTIFACT: docs/guanfu/brainstorms/YYYY-MM-DD-<slug>.md
NEXT: gf-plan | revise | stop
```
