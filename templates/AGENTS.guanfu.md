# GuanFu Router

Use these skills before answering directly when the request matches:

- New repo, missing docs harness, missing routing, or first-time setup -> `/gf-init`
- New idea, unclear requirement, feature concept, product thought, or "help me think" -> `/gf-brainstorm`
- Approved brainstorm, implementation plan, architecture, slices, milestones -> `/gf-plan`
- Active plan exists and user asks to implement, continue, build, fix, or work -> `/gf-work`
- Code changed, tests changed, diff changed, or implementation evidence needs review -> `/gf-code-review`
- Brainstorm, plan, ADR, review, compound, AGENTS routing, or handoff docs need review -> `/gf-doc-review`
- A mistake, repeated failure, bad assumption, missed edge case, flaky workflow, or review pattern appears -> `/gf-compound`
- A GuanFu skill, template, router, pressure scenario, validation script, or standard needs improvement -> `/gf-evolve`

Default sequence:

```text
gf-init -> gf-brainstorm -> gf-plan -> gf-work -> gf-code-review -> gf-doc-review -> gf-compound -> gf-evolve when needed
```

## GuanFu Harness Contract

- Human loop stages: `gf-brainstorm` and `gf-plan`. Use these stages to align goal, constraints, success criteria, failure modes, and taste.
- Automated stages: `gf-work`, `gf-code-review`, `gf-doc-review`, `gf-compound`, and `gf-evolve`. After plan approval, proceed through the chain without mid-execution user prompts.
- Approved plans should include `Execution Mode: AUTOMATED_AFTER_PLAN`.
- During automated execution, record anomalies, make the smallest safe decision, and let review/compound/evolve calibrate afterward.
- First failure is a signal. Repeated failure is a harness gap. Record both.

## GuanFu Taste

- Values: reduce AI collaboration failure modes and amplify AI leverage.
- Documents are project memory. Put durable context in `docs/guanfu/`.
- Brainstorm before plan. Plan before work. Review after work. Compound after mistakes. Evolve after repeated or process-level failure.
- Use small verifiable slices. Keep exactly one active slice in a plan.
- Plan and Work share one living plan document.
- A slice completes after fresh verification evidence is recorded after the final code change.
- Architecture decisions that are hard to reverse need an ADR in `docs/guanfu/adr/`.
- Review captures patterns, user impact, and future guardrails.
- Mistakes become guardrails: tests, scripts, checklist changes, AGENTS updates, ADRs, template edits, or skill evolution.
- Skills are living artifacts. Real failures should update skills, templates, pressure scenarios, or router rules through `gf-evolve`.

## GuanFu Document Contract

```text
docs/guanfu/
  context/
  brainstorms/
  plans/
  reviews/code/
  reviews/docs/
  adr/
  compound/
  standards/
  evolution/
```
