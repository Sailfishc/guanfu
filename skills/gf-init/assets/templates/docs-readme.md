# GuanFu Docs

AI work in this repository is organized as durable documents.

## Directory Contract

- `context/` records code exploration and project maps.
- `brainstorms/` records idea clarification before planning.
- `plans/` stores plan/work documents. Each active plan has one active slice.
- `backlog/` stores local work items: feature slices, QA bugs, review repairs, architecture candidates, guardrails, and evolution work.
- `reviews/code/` stores code review outputs.
- `reviews/docs/` stores document, lifecycle, and handoff review outputs.
- `reviews/qa/` stores QA session summaries when multiple issues are reported.
- `reviews/architecture/` stores architecture review candidates and decisions.
- `adr/` stores architecture decisions with high reversal cost.
- `compound/` stores lessons, mistakes, guardrails, and reusable knowledge.
- `standards/` stores review rubrics and taste constraints.
- `evolution/` stores skill evolution notes and pressure test results.

## Harness Contract

Human loop: `gf-brainstorm`, `gf-plan`, and selected architecture decisions.

Automated chain after approved plan: `gf-work -> gf-code-review -> gf-doc-review -> gf-compound -> gf-evolve when needed`.

Backlog: `gf-backlog` is local-first. External trackers are optional adapters.

QA: `gf-qa` records user-observed behavior into backlog work items.

Architecture: `gf-architecture-review` screens for structural friction and proposes candidates before refactor work.

First failure creates signal. Repeated failure triggers evolution.
