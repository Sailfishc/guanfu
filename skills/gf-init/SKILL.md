---
name: gf-init
description: Use when setting up, refreshing, or auditing GuanFu in a repository, including AGENTS routing, docs/guanfu templates, backlog templates, guardrail status, code context, and harness health checks.
---

# gf-init

Version: 0.5.0

## Overview

Initialize, audit, or refresh a repository as a GuanFu project. This skill is self-contained: its script and template assets live inside this skill directory.

Core principle: templates, router text, and initialization logic travel with `gf-init`. Installing only `skills/gf-*` is enough for Claude Code and Codex.

## Standard Skill Layout

```text
gf-init/
  SKILL.md
  scripts/
    gf-init.sh
  assets/
    templates/*.md
```

Runtime depends on `skills/gf-init/scripts/gf-init.sh` and `skills/gf-init/assets/templates/`.

## Modes

```bash
scripts/gf-init.sh --new       # default, create missing harness files
scripts/gf-init.sh --refresh   # refresh router and generated templates, preserve project artifacts
scripts/gf-init.sh --audit     # read-only report of missing/stale GuanFu pieces and optional guardrail status
scripts/gf-init.sh --dry-run   # preview writes
scripts/gf-init.sh --force     # overwrite generated templates
```

## Workflow

### 1. Locate the installed skill directory

Claude Code:

```bash
bash ~/.claude/skills/gf-init/scripts/gf-init.sh --new
```

Codex / agents:

```bash
bash ~/.agents/skills/gf-init/scripts/gf-init.sh --new
```

Repository-scoped install:

```bash
bash .agents/skills/gf-init/scripts/gf-init.sh --new
```

Package-development checkout:

```bash
bash skills/gf-init/scripts/gf-init.sh --new
```

### 2. Run the right mode

- New repository: `--new`
- Existing repository after GuanFu upgrade: `--refresh`
- Diagnosis only: `--audit`
- Existing hand-written `AGENTS.md`: run `--dry-run` first
- Guardrail installation: use `/gf-guardrails`; `gf-init --audit` only reports status

### 3. Confirm required outputs

Required project outputs:

```text
AGENTS.md or agents.md
docs/guanfu/README.md
docs/guanfu/backlog/README.md
docs/guanfu/backlog/WORK_ITEM_TEMPLATE.md
docs/guanfu/context/CODE_EXPLORE_TEMPLATE.md
docs/guanfu/brainstorms/BRAINSTORM_TEMPLATE.md
docs/guanfu/plans/PLAN_TEMPLATE.md
docs/guanfu/reviews/code/CODE_REVIEW_TEMPLATE.md
docs/guanfu/reviews/docs/DOC_REVIEW_TEMPLATE.md
docs/guanfu/reviews/qa/QA_REVIEW_TEMPLATE.md
docs/guanfu/reviews/architecture/ARCHITECTURE_REVIEW_TEMPLATE.md
docs/guanfu/adr/0000-template.md
docs/guanfu/compound/COMPOUND_NOTE_TEMPLATE.md
docs/guanfu/compound/index.md
docs/guanfu/standards/review-rubric.md
docs/guanfu/standards/taste.md
docs/guanfu/evolution/EVOLUTION_TEMPLATE.md
docs/guanfu/best-practices/GUANFU_WORKFLOW_BEST_PRACTICES.md
```

Generated templates are copied from `gf-init/assets/templates/` into the corresponding `docs/guanfu/` stage directories.

### 4. Perform or refine code explore

The script installs `CODE_EXPLORE_TEMPLATE.md`. Then run a read-only code explore and save a concrete report:

```text
docs/guanfu/context/code-explore-YYYY-MM-DD-HHMM.md
```

The report includes repo purpose, stack, key directories, entry points, testing commands, current docs, risk areas, patterns to reuse, and gaps future GuanFu skills should know.

### 5. Audit optional executable guardrails

`--audit` reports whether project/global dangerous-git guardrails appear installed. Missing guardrails are reported as optional, not as init failure.

Use `/gf-guardrails` to install or repair hooks.

## Completion

Report:

```text
STATUS: DONE | DONE_WITH_CONCERNS | BLOCKED
MODE: new | refresh | audit
SKILL_ASSETS: found | missing
AGENTS: updated | already-current | missing
DOCS: created | refreshed | audited
BACKLOG: created | refreshed | audited
BEST_PRACTICES: created | refreshed | audited
GUARDRAILS: installed | missing | partial | not-checked
CODE_EXPLORE: <path or none>
NEXT: /gf-brainstorm or /gf-plan
```

## Common Mistakes

| Mistake | Fix |
|---|---|
| Copying only `SKILL.md` | Copy the whole `gf-init/` directory so `scripts/` and `assets/` travel with it. |
| Depending on package-root `templates/` | Use `gf-init/assets/templates/` as the runtime source of truth. |
| Keeping duplicate init scripts | Keep one runtime script: `skills/gf-init/scripts/gf-init.sh`. |
| Refresh overwrites project notes | Refresh generated templates and router block; preserve living artifacts. |
| Audit mutates repo | `--audit` is read-only. |
| Expecting init to install hooks | Use `/gf-guardrails`; init only audits guardrail status. |
