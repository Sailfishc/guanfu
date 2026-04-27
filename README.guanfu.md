# GuanFu Skills v0.5

GuanFu is a local-first AI engineering workflow for turning ideas into planned, verified, reviewed, and self-improving work.

## v0.5 release theme

```text
Prevention + Backlog Layer
```

v0.5 adds a backend-agnostic work-item layer, manual QA capture, architecture prevention review, document lifecycle audit, executable git guardrails, and refreshed validation/docs.

## Default flow

```text
gf-init -> gf-brainstorm -> gf-plan -> gf-backlog when work items matter -> gf-work -> gf-code-review -> gf-doc-review -> gf-compound -> gf-evolve when needed
```

Referral loops:

```text
gf-qa -> gf-backlog -> gf-plan/gf-work
gf-architecture-review -> gf-plan/ADR/gf-backlog
gf-guardrails -> gf-init --audit
```

## Install / refresh in a repo

Unzip this package at the repository root, then run:

```bash
bash skills/gf-init/scripts/gf-init.sh --refresh
bash skills/gf-init/scripts/gf-init.sh --audit
```

For a new repo:

```bash
bash skills/gf-init/scripts/gf-init.sh --new
```

Optional executable git safety:

```bash
bash skills/gf-guardrails/scripts/install-git-guardrails.sh --project --test
```

## Core directories

```text
skills/gf-*/                                      runtime skills
docs/guanfu/backlog/WI-*.md                      local work items
docs/guanfu/reviews/qa/                          QA summaries
docs/guanfu/reviews/architecture/                architecture candidates
docs/guanfu/best-practices/GUANFU_WORKFLOW_BEST_PRACTICES.md  GuanFu operating guide
```

## Local-first work items

GuanFu does not require GitHub. External trackers are adapters. The source of truth is:

```text
docs/guanfu/backlog/WI-*.md
```

## Validation

Run:

```bash
bash scripts/gf-validate.sh
```
