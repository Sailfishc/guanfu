# GuanFu Skills v0.5.0

GuanFu is a local-first skill harness for AI-assisted software engineering.

v0.5.0 adds the Prevention and Backlog Layer:

- `gf-backlog`: local work item contract for feature slices, QA bugs, review repairs, architecture candidates, guardrails, and evolution work.
- `gf-qa`: captures manual QA and user-observed behavior as durable work items.
- `gf-architecture-review`: screens for architecture friction, deep module opportunities, deletion-test failures, and hard-to-test seams.
- `gf-doc-review` lifecycle audit: prevents durable docs from becoming misleading memory.
- `gf-guardrails`: executable dangerous-git hook skill.
- `gf-init --audit` optional guardrail status checks.

## Core flow

```text
gf-init
  -> gf-brainstorm
  -> gf-plan
       -> gf-backlog when work items are needed
       -> gf-architecture-review when architecture risk is high
  -> gf-work
  -> gf-code-review
  -> gf-doc-review
  -> gf-qa when the user manually tests or reports behavior problems
  -> gf-compound
  -> gf-evolve
```

## Install / refresh in a repo

From a package checkout:

```bash
bash skills/gf-init/scripts/gf-init.sh --new
bash skills/gf-init/scripts/gf-init.sh --audit
```

To refresh generated templates and router text:

```bash
bash skills/gf-init/scripts/gf-init.sh --refresh
```

To install executable dangerous-git hooks, use `/gf-guardrails`.

## Validation

Run:

```bash
bash scripts/gf-validate.sh
```
