---
name: gf-init
version: 0.2.0
description: Use when setting up or refreshing GuanFu in a repository, creating AGENTS routing, project docs, taste constraints, code context, or the initial AI engineering harness.
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
  - /gf-init
  - guanfu init
  - initialize guanfu
  - setup ai harness
  - refresh agents
---

# gf-init

## Overview

Initialize the repository as a GuanFu project and create the durable documents that future agents use as source of truth.

Core principle: a harness begins with router, taste, docs, and code facts. Future agents should depend on project documents.

## Required Outputs

Create or refresh:

```text
AGENTS.md or agents.md
docs/guanfu/README.md
docs/guanfu/context/
docs/guanfu/brainstorms/
docs/guanfu/plans/
docs/guanfu/reviews/code/
docs/guanfu/reviews/docs/
docs/guanfu/adr/
docs/guanfu/compound/
docs/guanfu/standards/
docs/guanfu/evolution/
docs/guanfu/context/code-explore-YYYY-MM-DD.md
```

## Workflow

### 1. Detect repo root

Run:

```bash
git rev-parse --show-toplevel 2>/dev/null || pwd
```

Operate from that root.

### 2. Run initializer

Prefer the script installed with this skill:

```bash
bash ~/.claude/skills/gf-init/gf-init.sh
```

Fallback:

```bash
bash ~/.agents/skills/gf-init/gf-init.sh
bash scripts/gf-init.sh
```

Use `--dry-run` when the repo already has hand-written agent instructions.

### 3. Perform code explore

Call an independent agent or inspect directly. Save it to:

```text
docs/guanfu/context/code-explore-YYYY-MM-DD.md
```

The report must include:

- repo purpose
- stack and package manager
- key directories
- entry points
- testing and verification commands
- current docs
- risk areas
- patterns to reuse
- gaps future GuanFu skills should know

### 4. Verify router

Confirm `AGENTS.md` or `agents.md` includes:

- `## GuanFu Router`
- `## GuanFu Taste`
- routes for `gf-brainstorm`, `gf-plan`, `gf-work`, `gf-code-review`, `gf-doc-review`, `gf-compound`, `gf-evolve`

## Code Explore Template

```markdown
# Code Explore: <repo>

Date: <YYYY-MM-DD>
Branch: <branch>
Explorer: <agent>

## Repo Purpose

## Stack

## Directory Map

## Important Entry Points

## Test and Verification Commands

## Existing Documentation

## Risk Areas

## Patterns to Reuse

## Gaps and Follow-ups

## Recommended Next GuanFu Skill
```

## Common Mistakes

| Mistake | Fix |
|---|---|
| Running the script and skipping code explore | Write `docs/guanfu/context/code-explore-YYYY-MM-DD.md`. |
| Writing product code during init | Keep init scoped to docs, router, templates, and code explore. |
| Putting docs under a generic root | Use `docs/guanfu/` for GuanFu memory. |
| Leaving router vague | Add exact skill names and stage triggers. |

## Completion

Report:

```text
STATUS: DONE | DONE_WITH_CONCERNS | NEEDS_CONTEXT
DOCS: docs/guanfu/
ROUTER: AGENTS.md updated | agents.md updated | already present
CODE_EXPLORE: docs/guanfu/context/code-explore-YYYY-MM-DD.md
NEXT: gf-brainstorm | gf-plan | stop
```
