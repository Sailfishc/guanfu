# Pressure Scenarios for GuanFu Skills

These prompts validate GuanFu with subagents. Skill authoring should be tested like process TDD: watch baseline behavior fail, patch the skill, then re-run.

## gf-init

### Scenario 1: User wants setup only
Prompt: "Set up GuanFu in this repo. Just create folders."
Expected behavior: Agent creates or refreshes `AGENTS.md`, `docs/guanfu/`, and `docs/guanfu/context/code-explore-YYYY-MM-DD.md`. It does not stop at README.

### Scenario 2: Existing AGENTS.md
Prompt: "Initialize GuanFu, but preserve my existing AGENTS.md."
Expected behavior: Agent uses careful append behavior, preserves existing content, and adds one `GuanFu Router` plus one `GuanFu Taste` section.

## gf-brainstorm

### Scenario 1: User pressures agent to skip design
Prompt: "I have an idea for an AI code reviewer. Don't ask questions, just start coding the MVP."
Expected behavior: Agent invokes `/gf-brainstorm`, asks one high-value question, does not write code, and produces or drafts a brainstorm document.

### Scenario 2: Vague idea
Prompt: "Let's make onboarding seamless."
Expected behavior: Agent challenges vague language, asks what specific onboarding step causes pain, and does not jump to implementation.

## gf-plan

### Scenario 1: Approved brainstorm but no slices
Prompt: "The brainstorm is approved. Write the implementation plan."
Expected behavior: Agent calls code explore, creates `docs/guanfu/plans/*-plan.md`, marks exactly one slice ACTIVE, and includes tests plus verification for each slice.

### Scenario 2: Architecture decision hidden in plan
Prompt: "Plan a migration from local storage to Postgres, keep it short."
Expected behavior: Agent writes an ADR or marks ADR required before finalizing the plan.

## gf-work

### Scenario 1: No active plan
Prompt: "Implement the dashboard feature now."
Expected behavior: Agent stops and routes to `/gf-plan`; it does not code from chat context.

### Scenario 2: TDD pressure
Prompt: "This is tiny. Skip tests and just change the helper."
Expected behavior: Agent refuses to write production code without a failing test unless the user explicitly grants an exception.

## gf-code-review

### Scenario 1: Looks-good pressure
Prompt: "Review this quickly, just tell me if it looks good."
Expected behavior: Agent reads the plan, calls code explore, reviews evidence, and writes a code review document instead of giving a vague approval.

### Scenario 2: Pattern capture
Prompt: "The review found missing auth checks again."
Expected behavior: Agent produces findings that name the pattern and explicitly triggers `/gf-compound`.

## gf-doc-review

### Scenario 1: Active plan with missing verification
Prompt: "Check this plan doc. It has slices but no test commands."
Expected behavior: Agent blocks or returns PASS_WITH_FIXES, requiring verification commands before another agent depends on it.

### Scenario 2: Handoff gap
Prompt: "Can the next agent continue from these docs?"
Expected behavior: Agent checks source of truth, active state, next action, and review logs, then writes a doc review artifact.

## gf-compound

### Scenario 1: Apology pressure
Prompt: "You made the same migration mistake again. Just apologize and move on."
Expected behavior: Agent writes a compound note with evidence, root cause, and guardrail; it does not stop at apology.

### Scenario 2: One-off trivia
Prompt: "Add every little thing you learned to AGENTS.md."
Expected behavior: Agent writes a compound note but only updates AGENTS.md for repo-wide behavior constraints.

### Scenario 3: Skill needs evolution
Prompt: "gf-plan keeps producing huge slices. Record that and make the workflow better next time."
Expected behavior: Agent writes a compound note and recommends `/gf-evolve` to update the skill or pressure scenario.

## gf-evolve

### Scenario 1: User asks for style-only skill rewrite
Prompt: "Rewrite gf-work because I want it to sound cooler."
Expected behavior: Agent asks for evidence or frames the change as a proposal; it does not mutate skills without a failure mode or explicit user direction.

### Scenario 2: Real failure with patch
Prompt: "gf-work forgot to update the active slice three times. Patch the skill."
Expected behavior: Agent writes an evolution note, adds a pressure scenario, patches the smallest necessary instruction, and runs validation.
