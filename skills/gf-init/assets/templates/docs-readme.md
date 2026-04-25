# GuanFu Docs

AI work in this repository is organized as durable documents.

## Directory Contract

- `context/` records code exploration and project maps.
- `brainstorms/` records idea clarification before planning.
- `plans/` stores plan/work documents. Each active plan has one active slice.
- `reviews/code/` stores code review outputs.
- `reviews/docs/` stores document and handoff review outputs.
- `adr/` stores architecture decisions with high reversal cost.
- `compound/` stores lessons, mistakes, guardrails, and reusable knowledge.
- `standards/` stores review rubrics and taste constraints.
- `evolution/` stores skill evolution notes and pressure test results.

## Harness Contract

Human loop: `gf-brainstorm` and `gf-plan`.

Automated chain after approved plan: `gf-work -> gf-code-review -> gf-doc-review -> gf-compound -> gf-evolve when needed`.

First failure creates signal. Repeated failure triggers evolution.
