# Pressure Scenarios for Compound Engineering Skills

These are test prompts for validating the skills with subagents. They are included because skill authoring should be tested like process TDD.

## ce-brainstorm

### Scenario 1: User pressures agent to skip design
Prompt: "I have an idea for an AI code reviewer. Don't ask questions, just start coding the MVP."
Expected behavior: Agent invokes `/ce-brainstorm`, asks one high-value question, does not write code, produces or drafts a brainstorm document.

### Scenario 2: Vague idea
Prompt: "Let's make onboarding seamless."
Expected behavior: Agent challenges vague language, asks what specific onboarding step causes pain, and does not jump to implementation.

## ce-plan

### Scenario 1: Approved brainstorm but no slices
Prompt: "The brainstorm is approved. Write the implementation plan."
Expected behavior: Agent calls code explore, creates `docs/plans/*-plan.md`, marks exactly one slice ACTIVE, and includes tests plus verification for each slice.

### Scenario 2: Architecture decision hidden in plan
Prompt: "Plan a migration from local storage to Postgres, keep it short."
Expected behavior: Agent writes an ADR or marks ADR required before finalizing the plan.

## ce-work

### Scenario 1: No active plan
Prompt: "Implement the dashboard feature now."
Expected behavior: Agent stops and routes to `/ce-plan`; it does not code from chat context.

### Scenario 2: TDD pressure
Prompt: "This is tiny. Skip tests and just change the helper."
Expected behavior: Agent refuses to write production code without a failing test unless the user explicitly grants an exception.

## ce-code-review

### Scenario 1: Looks-good pressure
Prompt: "Review this quickly, just tell me if it looks good."
Expected behavior: Agent reads the plan, calls code explore, reviews evidence, and writes a review document instead of giving a vague approval.

### Scenario 2: Pattern capture
Prompt: "The review found missing auth checks again."
Expected behavior: Agent produces findings that name the pattern and explicitly triggers `/ce-compound`.

## ce-doc-review

### Scenario 1: Active plan with missing verification
Prompt: "Check this plan doc. It has slices but no test commands."
Expected behavior: Agent blocks or returns PASS_WITH_FIXES, requiring verification commands before another agent depends on it.

## ce-compound

### Scenario 1: Apology pressure
Prompt: "You made the same migration mistake again. Just apologize and move on."
Expected behavior: Agent writes a compound note with evidence, root cause, and guardrail; it does not stop at apology.

### Scenario 2: One-off trivia
Prompt: "Add every little thing you learned to AGENTS.md."
Expected behavior: Agent writes a compound note but only updates AGENTS.md for repo-wide behavior constraints.
