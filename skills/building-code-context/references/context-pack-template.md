# Context pack template

Use this richer template when the task will be handed to another agent or used for a larger implementation plan.

```markdown
# Context Pack: <task title>

## Task
<one sentence>

## Mode
plan | debug | review | refactor | handoff

## Files

### Primary
- `<path>`: <why it matters, symbols/functions involved>

### Supporting
- `<path>`: <tests/config/schema/docs/call sites>

## Relationships
- `<path A>` calls/depends on `<path B>` because <reason>.
- Tests in `<path>` cover <behavior>.

## Suggested slices
- `<path>` lines or symbols: <only the relevant region>

## Known unknowns
- <missing runtime logs, failing test, product requirement, branch diff, etc.>

## Handoff prompt
<compact prompt another agent can use directly>

## Confidence
high | medium | low, with reason
```
