## GuanFu Router

Use these skills before answering directly when the request matches:

- New repo, missing docs harness, missing routing, first-time setup, stale GuanFu templates, or harness audit -> `/gf-init`
- New idea, unclear requirement, feature concept, product thought, architecture thought, agent workflow, or skill concept -> `/gf-brainstorm`
- Approved brainstorm, QA finding, architecture candidate, implementation slices, ADRs, or execution plan -> `/gf-plan`
- Local work items, backlog, issues, blockers, HITL/AFK classification, QA bugs, review repairs, architecture candidates, or external issue adapter links -> `/gf-backlog`
- Approved active plan exists and user asks to implement, continue, build, fix, or work -> `/gf-work`
- User is manually testing, reporting broken behavior, comparing expected vs actual behavior, or doing QA -> `/gf-qa`
- Code changed, tests changed, diff changed, completed slice, or implementation evidence needs review -> `/gf-code-review`
- Architecture risk, shallow module, unclear seam, hard-to-test path, repeated boundary finding, or deep module opportunity -> `/gf-architecture-review`
- Brainstorm, plan, backlog, ADR, review, compound, AGENTS routing, or handoff docs need review or lifecycle audit -> `/gf-doc-review`
- Mistake, repeated failure, bad assumption, missed edge case, flaky workflow, or review pattern appears -> `/gf-compound`
- GuanFu skill, template, router, validation script, pressure scenario, or standard needs improvement -> `/gf-evolve`
- Dangerous git command safety hooks, executable guardrails, or hook audit/install/repair -> `/gf-guardrails`

Default sequence:

`gf-init -> gf-brainstorm -> gf-plan -> gf-backlog when work items are needed -> gf-work -> gf-code-review -> gf-doc-review -> gf-compound -> gf-evolve when needed`

QA and architecture are referral loops:

- Manual QA findings go to `/gf-qa`, then `/gf-backlog` or `/gf-plan`.
- Architecture risk goes to `/gf-architecture-review`, then `/gf-brainstorm`, `/gf-plan`, `/gf-backlog`, or ADR.

## GuanFu Harness Contract

- Human loop stages: `gf-brainstorm`, `gf-plan`, and selected architecture decisions. Use these stages to align goal, constraints, success criteria, failure modes, and taste.
- Automated stages: `gf-work`, `gf-code-review`, `gf-doc-review`, `gf-compound`, and `gf-evolve`. After plan approval, proceed through the chain without routine mid-execution user prompts.
- Work item layer: `gf-backlog` is local-first and backend-agnostic. External issues are adapters, not the source of truth.
- Approved plans include `Execution Mode: AUTOMATED_AFTER_PLAN`.
- During automated execution, record anomalies, make the smallest safe decision consistent with the approved plan, and let review/compound/evolve calibrate afterward.
- First failure is a signal. Repeated failure is a harness gap. Record both.

## GuanFu Taste

- Values: reduce AI collaboration failure modes and amplify AI leverage.
- Documents are project memory, but every durable document needs lifecycle state.
- Brainstorm before plan. Plan before work. Review after work. QA preserves human taste. Compound after mistakes. Evolve after repeated or process-level failure.
- Use small verifiable vertical slices. Keep exactly one active slice in a plan.
- Plan and Work share one living plan document. Backlog holds work item state that may outlive a plan.
- A slice completes after fresh verification evidence is recorded after the final code change.
- Architecture decisions that are hard to reverse need an ADR in `docs/guanfu/adr/`.
- Architecture review proposes candidates; it does not refactor.
- QA captures user-observed behavior; it does not directly fix code.
- Review captures patterns, user impact, and future guardrails.
- Mistakes become guardrails: tests, scripts, checklist changes, AGENTS updates, ADRs, template edits, or skill evolution.
- Skills are living artifacts. Real failures should update skills, templates, pressure scenarios, or router rules through `gf-evolve`.
