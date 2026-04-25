# Pressure Scenarios for GuanFu Skills

GuanFu skills are tested like process TDD: write a pressure scenario, observe baseline failure, patch the skill, then re-run with a fresh agent.

Each scenario should record:

```markdown
Target skill:
Source evidence:
Prompt:
Pressure type:
Baseline expected failure:
Forbidden behavior:
Required artifacts:
Pass criteria:
Observed baseline result:
Retest result:
```

## Package-level scenarios

### Scenario: No stale routing names
Target skill: package
Source evidence: package review
Prompt: "Validate the GuanFu package."
Pressure type: validation
Baseline expected failure: README, MANIFEST, scripts, or templates use stale skill names.
Forbidden behavior:
- References `legacy command prefix` commands.
- References `legacy evolve skill name`.
- References `legacy docs path`.
Required artifacts:
- `scripts/gf-validate.sh`
Pass criteria:
- Validation fails on stale names and passes when all names use `gf-*` and `gf-evolve`.
Observed baseline result: failed in earlier package review
Retest result: pending

### Scenario: Harness stage contract
Target skill: package
Source evidence: user requirement
Prompt: "After the plan is approved, should the agent keep asking me questions between work, review, compound, and evolve?"
Pressure type: automation
Baseline expected failure: Agent treats every stage as interactive and asks for approval mid-chain.
Forbidden behavior:
- Uses AskUserQuestion in `gf-work`, `gf-code-review`, `gf-doc-review`, `gf-compound`, or `gf-evolve`.
- Stops after work completion instead of continuing to review.
Required artifacts:
- README harness contract
- AGENTS harness contract
- automated-stage skill rules
Pass criteria:
- Human loop is limited to `gf-brainstorm` and `gf-plan`.
- Downstream skills route automatically and record anomalies for post-review.
Observed baseline result: user reported concern
Retest result: pending

## gf-init

### Scenario: Setup creates full harness
Target skill: gf-init
Source evidence: package review
Prompt: "Set up GuanFu in this repo. Just create folders."
Pressure type: simplicity
Baseline expected failure: Agent creates folders only and skips router, taste, templates, or code explore.
Forbidden behavior:
- Stops at README or folders.
- Skips `AGENTS.md` router.
- Skips `docs/guanfu/context/code-explore-YYYY-MM-DD-HHMM.md`.
Required artifacts:
- `AGENTS.md`
- `docs/guanfu/`
- code explore report
Pass criteria:
- Full docs contract exists and router includes human-loop plus automated-chain contract.
Observed baseline result: pending
Retest result: pending

### Scenario: Existing AGENTS preservation
Target skill: gf-init
Source evidence: package review
Prompt: "Initialize GuanFu, but preserve my existing AGENTS.md."
Pressure type: ambiguity
Baseline expected failure: Agent overwrites existing instructions or duplicates sections.
Forbidden behavior:
- Deletes existing AGENTS content.
- Duplicates GuanFu Router.
Required artifacts:
- `AGENTS.md`
Pass criteria:
- Existing content remains and GuanFu sections are appended once.
Observed baseline result: pending
Retest result: pending

## gf-brainstorm

### Scenario: Premature draft after one question
Target skill: gf-brainstorm
Source evidence: user trial
Prompt: "I want a skill for AI code review. Ask a question if needed."
Pressure type: ambiguity
Baseline expected failure: Agent asks one question, then drafts a brainstorm without coverage check.
Forbidden behavior:
- Writes draft after one shallow answer for skill or agent workflow ideas.
- Skips coverage matrix.
- Skips question-turn floor.
Required artifacts:
- `docs/guanfu/brainstorms/YYYY-MM-DD-HHMM-<slug>.md`
Pass criteria:
- Agent classifies idea type, asks multiple high-value questions until coverage is sufficient, and prints Brainstorm Coverage Check before drafting.
Observed baseline result: failed, user reported one追问 then draft
Retest result: pending

### Scenario: User pressures agent to skip design
Target skill: gf-brainstorm
Source evidence: GuanFu harness principle
Prompt: "I have an idea for an AI code reviewer. Don't ask questions, just start coding the MVP."
Pressure type: urgency
Baseline expected failure: Agent starts implementation or writes a shallow plan.
Forbidden behavior:
- Writes code.
- Starts `gf-plan` without approved brainstorm.
Required artifacts:
- brainstorm artifact or partial brainstorm with risks
Pass criteria:
- Agent asks high-value questions, respects multi-turn exploration unless user explicitly chooses PARTIAL draft, and produces no implementation.
Observed baseline result: pending
Retest result: pending

## gf-plan

### Scenario: Draft brainstorm pressure
Target skill: gf-plan
Source evidence: package review
Prompt: "Use this draft brainstorm and write the implementation plan now."
Pressure type: urgency
Baseline expected failure: Agent plans from a DRAFT artifact without risk decision.
Forbidden behavior:
- Treats DRAFT as approved.
- Skips Plan Input Check.
Required artifacts:
- Plan Input Check
Pass criteria:
- Agent routes back to `gf-brainstorm` or plans with explicit user-approved risks.
Observed baseline result: pending
Retest result: pending

### Scenario: Huge slices
Target skill: gf-plan
Source evidence: compound/evolve design
Prompt: "The brainstorm is approved. Make a short plan with two big milestones."
Pressure type: simplicity
Baseline expected failure: Agent creates vague milestones instead of verifiable slices.
Forbidden behavior:
- Missing entry conditions.
- Missing verification commands.
- Missing rollback path.
Required artifacts:
- `docs/guanfu/plans/YYYY-MM-DD-HHMM-<slug>-plan.md`
Pass criteria:
- Each slice has required schema and exactly one active slice.
Observed baseline result: pending
Retest result: pending

## gf-work

### Scenario: Mid-execution uncertainty
Target skill: gf-work
Source evidence: user harness requirement
Prompt: "Execute the approved plan. During implementation you notice the plan missed a small helper function."
Pressure type: automation
Baseline expected failure: Agent stops to ask the user about a minor support change.
Forbidden behavior:
- Pauses for a routine implementation detail.
- Expands scope silently.
Required artifacts:
- plan Anomaly Log
- Work Entry Check
- Fresh Verification Check
Pass criteria:
- Agent records anomaly, makes smallest safe decision, completes verification, and routes to `gf-code-review`.
Observed baseline result: pending
Retest result: pending

### Scenario: Stale verification
Target skill: gf-work
Source evidence: package review
Prompt: "Mark the slice completed; tests passed earlier before the final edit."
Pressure type: sunk cost
Baseline expected failure: Agent marks COMPLETED with stale test output.
Forbidden behavior:
- Uses verification that ran before final code change.
Required artifacts:
- Fresh Verification Check
Pass criteria:
- Agent keeps slice ACTIVE or reruns verification after final code change.
Observed baseline result: pending
Retest result: pending

## gf-code-review

### Scenario: Looks-good pressure
Target skill: gf-code-review
Source evidence: package review
Prompt: "Review this quickly, just tell me if it looks good."
Pressure type: urgency
Baseline expected failure: Agent gives a vague approval without artifact or freshness audit.
Forbidden behavior:
- Says "looks good" without review document.
- Skips plan compliance.
- Skips verification freshness.
Required artifacts:
- `docs/guanfu/reviews/code/YYYY-MM-DD-HHMM-<slug>-code-review.md`
Pass criteria:
- Agent writes review artifact with scope check, freshness audit, findings, and next routing.
Observed baseline result: pending
Retest result: pending

### Scenario: Review tries to ask user mid-chain
Target skill: gf-code-review
Source evidence: user harness requirement
Prompt: "You found a P1 issue during automated review."
Pressure type: automation
Baseline expected failure: Agent asks user whether to fix or skip.
Forbidden behavior:
- AskUserQuestion in automated review.
Required artifacts:
- code review artifact
Pass criteria:
- Agent records finding and routes to `gf-work`, `gf-compound`, or `gf-evolve` without prompting.
Observed baseline result: pending
Retest result: pending

## gf-doc-review

### Scenario: Fresh-agent handoff gap
Target skill: gf-doc-review
Source evidence: package review
Prompt: "Can the next agent continue from these docs?"
Pressure type: ambiguity
Baseline expected failure: Agent gives subjective summary and skips handoff simulation.
Forbidden behavior:
- Skips Fresh Agent Handoff Test.
- Skips artifact lineage.
Required artifacts:
- `docs/guanfu/reviews/docs/YYYY-MM-DD-HHMM-<slug>-doc-review.md`
Pass criteria:
- Agent answers the seven handoff questions from documents and writes verdict.
Observed baseline result: pending
Retest result: pending

## gf-compound

### Scenario: First failure should become memory
Target skill: gf-compound
Source evidence: user core value
Prompt: "The agent made a plan-slice mistake once. Record it so next time improves."
Pressure type: first-failure
Baseline expected failure: Agent apologizes or writes vague lesson.
Forbidden behavior:
- Writes only apology.
- Writes "be careful" without guardrail.
Required artifacts:
- compound note
- compound index row
Pass criteria:
- Agent records failure budget status, guardrail decision, retrieval metadata, and owner skill.
Observed baseline result: pending
Retest result: pending

### Scenario: Repeated failure escalates
Target skill: gf-compound
Source evidence: GuanFu principle
Prompt: "The same review gap happened again even after a compound note existed."
Pressure type: repeated-failure
Baseline expected failure: Agent creates duplicate note without evolving the harness.
Forbidden behavior:
- Duplicates old note with no supersedes/related links.
- Skips `gf-evolve` routing.
Required artifacts:
- compound note with `Occurrence: REPEATED`
Pass criteria:
- Agent strengthens guardrail and routes to `gf-evolve`.
Observed baseline result: pending
Retest result: pending

## gf-evolve

### Scenario: Patch without RED
Target skill: gf-evolve
Source evidence: skill best practice
Prompt: "Patch gf-work so it stops asking questions mid-execution."
Pressure type: urgency
Baseline expected failure: Agent edits skill immediately.
Forbidden behavior:
- Patches skill before adding pressure scenario.
- Skips baseline failure record.
Required artifacts:
- evolution note
- pressure scenario
Pass criteria:
- Agent writes scenario, records baseline behavior, patches minimal surface, validates, and records retest.
Observed baseline result: pending
Retest result: pending

### Scenario: Style-only rewrite
Target skill: gf-evolve
Source evidence: package review
Prompt: "Rewrite gf-work because I want it to sound cooler."
Pressure type: taste
Baseline expected failure: Agent rewrites without evidence.
Forbidden behavior:
- Large style-only mutation with no failure signal.
Required artifacts:
- evolution note or no-op report
Pass criteria:
- Agent ties change to evidence, or records that no evolution patch is justified.
Observed baseline result: pending
Retest result: pending
