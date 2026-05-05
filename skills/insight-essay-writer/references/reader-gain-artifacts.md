# Reader-Gain Artifacts

Every publishable essay must give the reader one concrete thing to carry away. Pick one artifact that fits the primary reader.

## Artifact types

| Artifact | Best for | Shape |
|---|---|---|
| Decision table | Tool choice, model choice, role judgment | Scenario → choose → why |
| Checklist | Workflow change, team habit, risk review | 5-9 checks |
| Operating model | Team or org mechanism | Components and handoffs |
| Failure-mode list | Safety, trust, AI agent work, product quality | Failure → cause → guardrail |
| Before/after workflow | Career or process shift | Old action → new action |
| Field guide | Role transition | Situation → what to watch → what to do |
| Diagnostic questions | Product, strategy, customer materials | Questions that reveal the real issue |

## Placement

Place the artifact after the core mechanism has been explained. The reader should understand why the tool exists before seeing it.

## Quality rules

A good artifact:

- Uses reader language, not author process language.
- Has 5 to 9 rows or checks for most essays.
- Changes a decision the reader makes this week.
- Avoids generic advice like “communicate more” or “align stakeholders”.
- Connects each row to the essay’s mechanism.

## Examples

### PM article

| Situation | PM's new judgment |
|---|---|
| Small UX change | Run a low-cost experiment and watch real behavior |
| Feature touches permissions or billing | Treat as infrastructure decision |
| Model limitation creates friction | Decide between prompt, harness, UI, or waiting for model improvement |
| Users cannot see what AI is doing | Add trust and observability to the product surface |
| Model upgrade changes capability | Reprice the old feature and decide whether to remove, shrink, or keep it |

### AI coding article

| Scenario | Give to AI | Human keeps |
|---|---|---|
| Early vague idea | Ask aggressive clarifying questions | Make tradeoffs and set boundaries |
| Implementation task | Build inside sandbox/worktree | Define module interface and test boundary |
| Verification | Run tests, type checks, reviewer agent | Judge whether feedback covers real risk |
| UI experience | Generate throwaway prototype | Decide taste, flow, and product quality |

## Artifact anti-patterns

- A table that merely restates the essay.
- A framework with ten abstract categories.
- A checklist without decisions.
- A matrix that introduces a second thesis.
