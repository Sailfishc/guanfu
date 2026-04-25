---
name: gf-init
version: 0.3.0
description: Use when setting up, refreshing, or auditing GuanFu in a repository, creating AGENTS routing, project docs, taste constraints, code context, or the initial AI engineering harness.
allowed-tools:
  - Read
  - Grep
  - Glob
  - Write
  - Edit
  - Bash
  - Agent
triggers:
  - /gf-init
  - guanfu init
  - initialize guanfu
  - setup ai harness
  - refresh agents
  - audit guanfu
---

# gf-init

## Overview

Initialize or refresh the repository as a GuanFu project and create the durable documents future agents use as source of truth.

Core principle: a harness begins with router, taste, docs, code facts, and a clear execution contract.

## Harness Position

`gf-init` sets up the system. It is automatic. It creates or refreshes the contract that later stages follow:

```text
Human loop: gf-brainstorm -> gf-plan
Automated chain: gf-work -> gf-code-review -> gf-doc-review -> gf-compound -> gf-evolve when needed
```

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
docs/guanfu/context/code-explore-YYYY-MM-DD-HHMM.md
```

## Modes

| Mode | Use |
|---|---|
| `--new` | first-time setup |
| `--refresh` | update router/templates/docs contract while preserving existing files |
| `--audit` | report missing or stale GuanFu pieces |
| `--dry-run` | show intended actions |
| `--force` | overwrite generated templates |

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
bash ~/.claude/skills/gf-init/gf-init.sh --new
```

Fallbacks:

```bash
bash ~/.agents/skills/gf-init/gf-init.sh --new
bash scripts/gf-init.sh --new
```

For existing GuanFu repos:

```bash
bash ~/.claude/skills/gf-init/gf-init.sh --refresh
bash ~/.claude/skills/gf-init/gf-init.sh --audit
```

### 3. Perform code explore

Call an independent read-only agent or inspect directly. Save it to:

```text
docs/guanfu/context/code-explore-YYYY-MM-DD-HHMM.md
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
- recommended next GuanFu skill

### 4. Verify router

Confirm `AGENTS.md` or `agents.md` includes:

- `## GuanFu Router`
- `## GuanFu Harness Contract`
- `## GuanFu Taste`
- routes for `gf-brainstorm`, `gf-plan`, `gf-work`, `gf-code-review`, `gf-doc-review`, `gf-compound`, `gf-evolve`
- `Execution Mode: AUTOMATED_AFTER_PLAN` in the harness contract

### 5. Audit generated docs

Run:

```bash
bash scripts/gf-init.sh --audit
```

When the script is unavailable in the target repo, inspect the same checks manually.

## Code Explore Template

```markdown
# Code Explore: <repo>

Date: <ISO timestamp>
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

## Harness Fit

- Human-loop stages likely needed:
- Automated execution risks:
- Compound/evolve candidates:

## Recommended Next GuanFu Skill
```

## Common Mistakes

| Mistake | Fix |
|---|---|
| Running the script and skipping code explore | Write `docs/guanfu/context/code-explore-YYYY-MM-DD-HHMM.md`. |
| Writing product code during init | Keep init scoped to docs, router, templates, and code explore. |
| Leaving router vague | Add exact skill names, human-loop stages, and automated chain. |
| Treating old repos as static | Use `--refresh` and `--audit` as GuanFu evolves. |
| Missing harness contract | Ensure `AUTOMATED_AFTER_PLAN` appears in router/taste docs. |

## Completion

Report:

```text
STATUS: DONE | DONE_WITH_CONCERNS | BLOCKED
DOCS: docs/guanfu/
ROUTER: AGENTS.md updated | agents.md updated | already present
CODE_EXPLORE: docs/guanfu/context/code-explore-YYYY-MM-DD-HHMM.md
MODE: new | refresh | audit
NEXT: /gf-brainstorm | /gf-plan | stop
```
