---
name: creating-agent-skills
description: Use when creating, editing, packaging, validating, or evaluating agent skills for Codex, Claude Code, Claude.ai, API, or open agent skills. Trigger on requests for skill design, SKILL.md, frontmatter, descriptions, eval cases, skill packages, meta-skills, or skill routing. Route normal coding tasks and ordinary use of existing skills to the relevant task skill.
---

# Creating Agent Skills

## Core principle

Skill authoring is eval-driven process documentation: identify a repeatable agent behavior, write pressure cases first, observe baseline failure, create the smallest useful skill, then validate trigger behavior and task behavior.

A good skill teaches an agent how to handle a reusable workflow. The user-facing goal names the skill. Tools and MCP servers are backends.

## When to use

Use this skill for:

- New skills or meta-skills
- Editing `SKILL.md`, frontmatter, descriptions, references, scripts, or templates
- Skill trigger debugging, low activation, over-activation, and routing rules
- Skill eval design, baseline/candidate comparisons, scoring, and reports
- Packaging skills for Codex, Claude Code, Claude.ai, API, or a repository
- Turning a repeated workflow, team convention, or MCP recipe into a reusable skill

Route these tasks elsewhere:

- Running an existing skill exactly as-is → invoke that skill
- One-off project rules → write `AGENTS.md` or `CLAUDE.md`
- Pure deterministic checks → write scripts, hooks, or CI checks
- Ordinary feature implementation, tests, builds, commits, or PRs → use the project workflow

## Decision gate

Before writing a skill, classify the request.

| Situation | Artifact |
|---|---|
| Repeatable judgment-heavy workflow | Skill |
| Stable repo/team rule | `AGENTS.md` or `CLAUDE.md` |
| Deterministic validation or transformation | Script, hook, or CI job |
| Service/tool access | MCP/tool integration plus a skill recipe |
| One-time answer | Normal response |
| Multi-skill distribution | Plugin/package |

If the request is a skill, continue.

## Required workflow

### 1. Write the skill brief

Produce this before file creation:

```text
SKILL BRIEF
- Purpose:
- Target surfaces: Codex | Claude Code | Claude.ai | API | generic
- User phrases that should trigger it:
- Requests that should route elsewhere:
- Required dependencies: none | scripts | MCP | external tools
- Risk level: low | medium | high
- Output contract:
```

### 2. Create eval cases first

Create at least these cases:

| Case type | Minimum | Purpose |
|---|---:|---|
| Positive trigger | 3 | The skill activates for real user language |
| Negative trigger | 3 | Related tasks route elsewhere |
| Pressure | 2 | The agent follows gates under speed, sunk-cost, or authority pressure |
| Explicit invocation | 1 | `$skill-name` or slash/manual invocation works |
| Packaging | 1 | Visible and hidden install paths are present |

For edits to an existing skill, use the current behavior as the baseline. For new skills, run baseline if the target agent is available. If the target agent cannot run locally, mark the baseline as `pending` and still create executable eval fixtures.

### 3. Name by purpose

Use a lowercase, hyphenated, action-oriented name. Prefer gerunds for workflows.

Good examples:

- `creating-agent-skills`
- `querying-codebase`
- `building-code-context`
- `reviewing-api-contracts`

Tool-first names such as `using-repo-prompt-mcp` work only when the user's actual goal is operating that tool.

### 4. Write the description as routing metadata

The description controls discovery. Put trigger conditions first, then scope boundaries. Keep workflow details in the body.

Good pattern:

```yaml
description: Use when creating, editing, validating, packaging, or evaluating agent skills. Trigger on SKILL.md, frontmatter, description tuning, eval cases, skill packages, or skill routing. Route normal coding tasks to the relevant implementation workflow.
```

Weak patterns:

- Description summarizes every step in the workflow
- Description starts with a tool name while the user asks for an outcome
- Description uses soft language such as `would improve`
- Description omits related tasks that should route elsewhere

### 5. Keep `SKILL.md` lean

Use progressive disclosure.

- `SKILL.md`: routing, core workflow, hard gates, output contract
- `references/`: long guidance, rubrics, examples, platform notes
- `scripts/`: deterministic scaffolding, validation, packaging, eval runners
- `assets/templates/`: reusable templates

Keep references one level deep from `SKILL.md`. Each reference file should have a clear title and purpose.

### 6. Add scripts when correctness is checkable

Use scripts for work that benefits from deterministic checks:

- Frontmatter validation
- Name and path validation
- Description linting
- Reference/file existence checks
- Package layout checks
- JSONL eval case validation
- Report generation

Scripts must have local-only defaults. Any network access, package install, destructive file operation, or credential use must be explicit in the README and the script help text.

### 7. Package for the target surfaces

For Codex packages, include both:

```text
skills/<skill-name>/              # visible copy for humans
.agents/skills/<skill-name>/      # Codex-discoverable copy
```

For Claude Code packages, include:

```text
skills/<skill-name>/              # visible copy for humans
.claude/skills/<skill-name>/      # Claude Code-discoverable copy
```

For Claude.ai upload packages, include a zip containing the skill folder itself, or include clear upload instructions.

### 8. Validate and report

Run static validation every time. Run dynamic evals when the target agent CLI is available.

Report with this contract:

```text
SKILL BUILD REPORT
- Skill:
- Target surfaces:
- Files created:
- Eval cases:
- Static validation:
- Dynamic eval:
- Known limitations:
- Install command:
```

## Reference routing

Read these when needed:

- `references/skill-patterns.md` for patterns, anti-patterns, and examples
- `references/platform-rules.md` for Codex, Claude Code, Claude.ai, and API placement
- `references/eval-method.md` for eval case design and scoring
- `references/packaging.md` for visible/hidden package structure
- `references/security.md` for script and dependency review
- `references/quality-rubric.md` for release gates

Use templates from `assets/templates/` when creating files.

## Hard gates

- Start with eval cases for new skills and meaningful edits.
- Treat tool names as backend names. The skill name expresses the user goal.
- Keep workflow steps out of the description.
- Include positive and route-away cases in evals.
- Include a visible `skills/` copy in downloadable packages.
- State unrun evals as pending with the exact command to run.
- Preserve user-provided constraints in the skill brief.

## Common failure modes

| Failure mode | Fix |
|---|---|
| Hidden-only package | Add visible `skills/` and mirror into agent-specific folders |
| Tool-first name | Rename around the user purpose |
| Low implicit activation | Rewrite description with concrete trigger phrases and boundaries |
| Over-activation | Add route-away cases in description, body, and evals |
| Bloated body | Move examples and platform notes into one-level references |
| Untestable skill | Define observable outputs, tool calls, files, or report sections |
| Missing baseline | Run baseline or mark it pending with a reproducible command |
| Script risk | Make script local-only by default and document permissions |

## Minimal output templates

### Skill brief

Use `assets/templates/skill-brief.md`.

### New skill scaffold

Use `assets/templates/SKILL.md.template`.

### Eval cases

Use `assets/templates/cases.jsonl.template`.
