# Skill Patterns and Anti-Patterns

## Patterns

| Pattern | Use it when | Implementation cue |
|---|---|---|
| Purpose-first name | User describes an outcome | `querying-codebase`, `creating-agent-skills` |
| Description as routing metadata | Implicit activation matters | Trigger phrases first, boundaries second |
| Eval-first authoring | New skill or material edit | Positive, route-away, pressure, explicit, package cases |
| Progressive disclosure | Skill has more than one page of detail | Move platform notes, rubrics, examples to references |
| Script-backed validation | Correctness is checkable | Validate frontmatter, paths, JSONL, package layout |
| Visible + discoverable package | Downloadable package for humans and agents | `skills/` plus `.agents/skills/` or `.claude/skills/` |
| Backend-neutral workflow | Tool or MCP usage supports a broader goal | Tool appears in references/dependencies, not necessarily the name |
| AGENTS/CLAUDE routing snippet | Outer routing is unstable | Add short routing rules beside the skill |

## Anti-patterns

| Anti-pattern | Failure | Correction |
|---|---|---|
| Tool-first naming | User language misses the skill | Name the task purpose |
| Description contains the full workflow | Agent shortcuts from metadata | Keep the workflow in `SKILL.md` body |
| Soft trigger wording | Low activation | Use concrete trigger phrases |
| Missing route-away cases | Over-activation | Add cases to description, body, and evals |
| Hidden-only package | Users think skills are missing | Include visible `skills/` |
| No eval component | Quality depends on vibes | Include JSONL cases and runner |
| Monolithic `SKILL.md` | High token cost and missed details | Split to one-level references |
| Scripts with broad privileges | Supply-chain risk | Local-only defaults, explicit help, clear README |
| One-off story | Low reuse | Extract reusable method, constraints, and examples |

## Description examples

Good:

```yaml
description: Use when reviewing API contract changes, schema compatibility, generated clients, endpoint behavior, or versioning risk. Trigger on OpenAPI, REST contract, breaking change, client generation, or compatibility review. Route ordinary code review to the code-review workflow.
```

Weak:

```yaml
description: This skill checks OpenAPI files, searches the repo, runs a schema diff, writes a report, and creates follow-up tasks.
```

The weak version is a process summary. The good version is routing metadata.

## Name examples

| User goal | Good name | Weak name |
|---|---|---|
| Find code context | `querying-codebase` | `using-repoprompt` |
| Build handoff context | `building-code-context` | `mcp-context-builder` |
| Create skills | `creating-agent-skills` | `skill-utils` |
| Review API contracts | `reviewing-api-contracts` | `openapi-checker` |
| Migrate database safely | `migrating-databases` | `flyway-helper` |
