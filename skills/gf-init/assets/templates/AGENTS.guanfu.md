## GuanFu Router

Use these skills before answering directly when the request matches:

- New repo, missing docs harness, missing routing, first-time setup, stale GuanFu templates -> `/gf-init`
- New idea, unclear requirement, feature concept, product thought, architecture thought, agent workflow, or skill concept -> `/gf-brainstorm`
- Approved brainstorm, implementation slices, architecture decisions, ADRs, or execution plan -> `/gf-plan`
- Approved active plan exists and user asks to implement, continue, build, fix, or work -> `/gf-work`
- Code changed, tests changed, diff changed, completed slice, or implementation evidence needs review -> `/gf-code-review`
- Brainstorm, plan, ADR, review, compound, AGENTS routing, or handoff docs need review -> `/gf-doc-review`
- Mistake, repeated failure, bad assumption, missed edge case, flaky workflow, or review pattern appears -> `/gf-compound`
- GuanFu skill, template, router, validation script, pressure scenario, or standard needs improvement -> `/gf-evolve`

Default sequence:

`gf-init -> gf-brainstorm -> gf-plan -> gf-work -> gf-code-review -> gf-doc-review -> gf-compound -> gf-evolve when needed`

## GuanFu Harness Contract

- Human loop stages: `gf-brainstorm` and `gf-plan`. Use these stages to align goal, constraints, success criteria, failure modes, and taste.
- Automated stages: `gf-work`, `gf-code-review`, `gf-doc-review`, `gf-compound`, and `gf-evolve`. After plan approval, proceed through the chain without routine mid-execution user prompts.
- Approved plans include `Execution Mode: AUTOMATED_AFTER_PLAN`.
- During automated execution, record anomalies, make the smallest safe decision consistent with the approved plan, and let review/compound/evolve calibrate afterward.
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
