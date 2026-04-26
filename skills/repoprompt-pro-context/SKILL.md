---
name: repoprompt-pro-context
version: 2.0.0
description: Use when the user wants Repo Prompt to prepare curated repository context for GPT-5.5 Pro, ChatGPT Pro, or another high-reasoning model for complex codebase questions, debugging, architecture, planning, testing strategy, or review.
---

# RepoPrompt Pro Context

## Core Principle

Context Builder is the scout, not the whole workflow.

Repo Prompt should first discover and shape repository context. Then the agent must inspect, prune, repair, and package that context so GPT-5.5 Pro can reason in the smart zone. The goal is not maximum context. The goal is the smallest sufficient packet with the right files, slices, CodeMaps, diffs, tests, constraints, and uncertainty notes.

## Hard Gate

Do not implement code, run destructive commands, call `apply_edits`, or apply GPT output in this skill.

Allowed output: a Repo Prompt orchestration report, a curated selection report, and a paste-ready GPT-5.5 Pro context prompt. If the user wants implementation, hand off after this skill completes.

## When to Use

Use for multi-file repository questions, debugging, planning, architecture analysis, test strategy, code review, regression analysis, or preparing a context packet for a high-reasoning model.

Do not use for single-file edits, obvious local questions, pure product brainstorming without repository context, or direct implementation requests.

## Task Modes

Classify first. If modes overlap, choose the dominant mode and mention secondary goals.

| Mode | Use when | Repo Prompt focus | Final reasoning output |
|---|---|---|---|
| `question` | Explain how something works | Entry points, call graph, interfaces, docs | Grounded explanation |
| `debug` | Bug, error, regression | Repro path, failing tests, logs, recent diffs | Root-cause hypotheses and verification |
| `plan` | Feature, refactor, migration | Architecture, seams, examples, tests | Alternatives and recommended plan |
| `review` | Diff or PR critique | Git diff plus surrounding modules | Findings, risks, missing tests |
| `architecture` | System design tradeoffs | Interfaces, dependencies, ADRs, cross-cutting flows | Boundary and migration memo |
| `test-strategy` | How to test | Public interfaces, risky branches, existing tests | Test matrix |

## Repo Prompt Tool Roles

Use the Repo Prompt MCP tool names when available. Tool names can vary by integration, so use the closest equivalent.

| Tool | Use |
|---|---|
| `workspace_context` | Inspect prompt, selection, token count, current state |
| `get_file_tree` | Understand repository shape and selected markers |
| `git` | Read-only status, diff, log, blame, changed files |
| `file_search` | Find symbols, paths, strings, errors, config, tests |
| `get_code_structure` | Get CodeMaps and structure summaries |
| `read_file` | Read exact file content for reasoning core |
| `context_builder` | Discover context and write Handoff/Final Prompt |
| `manage_selection` | Add, remove, set, slice, codemap-only, preview selection |
| `prompt` | Set or export the final workspace prompt |
| `ask_oracle` | Optional Repo Prompt internal reasoning over current Selection |

Important: `context_builder` mutates the current Selection and workspace Prompt. Always inspect state before and after calling it.

## Response Type Choice

Use `context_builder` deliberately.

| response_type | Use when | Why |
|---|---|---|
| `clarify` | Preparing external GPT-5.5 Pro context or manually auditing context | Builds Selection + Handoff Prompt without auto-solving |
| `question` | User wants Repo Prompt to answer a codebase question directly | Builds context then enters Oracle-style answer path |
| `plan` | User wants a Repo Prompt internal plan before implementation | Builds context then enters Oracle-style planning path |
| `review` | User wants a Repo Prompt internal review | Builds context then enters Oracle-style review path |

Default for this skill: `clarify`. Use `plan`, `question`, or `review` only when the user explicitly wants Repo Prompt to produce the reasoning result too. For GPT-5.5 Pro handoff, prefer `clarify` followed by manual refinement and export.

## Workflow

### 1. Normalize the user task

Restate the raw user request as a Pro-grade task:

- exact question to answer,
- desired output shape,
- success criteria,
- constraints,
- implementation allowed or forbidden,
- assumptions.

Ask one clarifying question only if the missing answer changes context selection. Otherwise proceed and record assumptions.

### 2. Preflight the Repo Prompt workspace

Run or request the equivalent of:

```text
workspace_context(include:["prompt","selection","tokens"])
```

If selection is stale, broad, or unrelated, clear or replace it. Old context is worse than no context.

For review, regression, or branch tasks, collect read-only git state before discovery:

```text
git(status)
git(diff) or git(diff, artifacts:true)
git(log)
```

For large repos, inspect structure first:

```text
get_file_tree
```

### 3. Run Context Builder as discovery

Use the built-in prompt below, adapted to the task:

```xml
<task>Find the minimal sufficient repository context for this task.</task>
<mode>{question|debug|plan|review|architecture|test-strategy}</mode>
<user_question>{precise task}</user_question>
<context>
Prioritize entry points, direct dependencies, callers/callees, public interfaces, schemas, routes, tests, recent diffs, docs/ADRs, and examples of the same pattern.
Avoid generated files, vendored code, stale PRDs, unrelated docs, broad directories, and full files when a slice or CodeMap is enough.
</context>
<discovery_agent-guidelines>
Return selected files/slices, representation choice, why each item matters, missing context, ambiguities, and token estimate.
Do not implement. Do not call apply_edits. Do not treat stale docs as current unless history is requested.
</discovery_agent-guidelines>
```

Recommended call:

```text
context_builder(response_type:"clarify", instructions:<above>)
```

### 4. Postflight the Context Builder result

Immediately inspect:

```text
workspace_context(include:["prompt","selection","tokens"])
```

Verify these facts:

- What files were added or removed?
- Did the workspace Prompt change?
- Did token count exceed the packet budget?
- Did the Final Prompt include `<ambiguities>` or uncertainty?
- Did Context Builder select full files where slices or CodeMaps would be enough?
- Did it miss tests, config, callers, callees, or recent diffs?

Treat the Final Prompt as a discovery-agent summary, not ground truth. If it names an ambiguity, resolve it with search, file reads, or mark it as a known gap.

### 5. Refine with other tools

Context Builder output is a draft. Improve it before exporting.

Use `file_search` when a symbol, error, route, feature flag, or test is missing.
Use `get_code_structure` when neighboring modules only need signatures and relationships.
Use `read_file` when exact logic or line-level behavior matters.
Use `git` when the task is about a diff, regression, branch, or review.
Use `manage_selection` to convert:

- full large files → slices,
- neighboring implementation → CodeMap,
- stale docs → removed or marked historical,
- missing core files → full,
- missing tests/config → full or slice.

Use `prompt(set)` only after the selection is clean. Use `prompt(export)` when ready to hand off.

### 6. Keep the final packet in the smart zone

Repo Prompt may use larger internal budgets. The exported GPT-5.5 Pro packet should not.

Default target: 40k-80k tokens.
Hard cap: 100k tokens unless the user asked for a broad audit.

If the packet wants to exceed the cap, split by:

- one user workflow,
- one failing behavior,
- one module seam,
- one architecture decision,
- one review theme,
- one test surface.

### 7. Optional Oracle pass

Use `ask_oracle` only after Selection is verified.

Good uses:

```text
context_builder(response_type:"clarify")
→ inspect Selection + Prompt
→ manage_selection refinements
→ ask_oracle(mode:"plan" | "review" | "chat")
```

Bad use:

```text
ask_oracle(question about files not selected)
```

Oracle does not explore the repo. It reasons over current Selection and Prompt.

### 8. Build the GPT-5.5 Pro packet

The exported packet must include:

- task statement,
- success criteria,
- repository map,
- selected context with representation labels,
- Context Builder Handoff Prompt or summary,
- exact file contents/slices/CodeMaps/diffs,
- known gaps and assumptions,
- analysis instructions.

Do not ask GPT-5.5 Pro to browse the repo. Give it the context.

## Context Sufficiency Check

Before final output, answer these:

- Can GPT-5.5 Pro answer the exact user task from this packet alone?
- Are entry points included?
- Are core implementation files full or useful slices?
- Are interfaces, types, schemas, contracts, routes, or CLI definitions included?
- Are one-hop callers/callees included when behavior crosses boundaries?
- Are tests and test style included?
- Is config included when it changes behavior?
- Is git diff/log/status included for review, regression, or branch tasks?
- Are stale docs removed or marked historical?
- Is every selected item justified?
- Is the exported token count under 100k?

If no, either fix the Selection or list the missing context as a known gap.

## Output Format

Return four sections.

### 1. Repo Prompt Orchestration Report

```markdown
## Repo Prompt Orchestration Report

Task mode: <mode>
Context Builder response_type: <clarify|question|plan|review>
Preflight selection: <empty|N files|stale and cleared>
Post-builder selection: <N files, N tokens>
Final packet estimate: <N tokens>
Context confidence: <High|Medium|Low>

### Tool sequence
1. workspace_context — <result>
2. context_builder — <result>
3. <file_search/read_file/git/manage_selection/etc> — <why used>

### Key Context Builder side effects
- Selection changed: <yes/no, summary>
- Workspace Prompt changed: <yes/no>
- Ambiguities found: <none/list>
```

### 2. Curated Selection Report

```markdown
## Curated Selection Report

| Item | Representation | Why included | Source |
|---|---|---|---|
| path/to/file.ts | full | Core implementation | Context Builder + verified |
| path/to/large.ts:120-210 | slice | Error branch | Manual refinement |
| path/to/types.ts | CodeMap | Public interface | Manual refinement |

### Removed or downgraded
- <path> — <reason>

### Known gaps
- <missing file/log/test/diff, or “None found”>

### Assumptions
- <assumption>
```

### 3. GPT-5.5 Pro Context Prompt

```markdown
# GPT-5.5 Pro Context Prompt

You are GPT-5.5 Pro acting as a senior staff engineer and codebase analyst.

Use only the provided repository context. Separate grounded facts from inferences. Cite file paths, diff sections, or context sections for claims. If context is insufficient, say exactly what file, log, diff, or test is needed.

Do not invent repository behavior. Do not ask for hidden chain-of-thought. Provide concise rationale, evidence, uncertainty, and the final recommendation.

## Task

<precise task>

## Desired output

<explanation | root-cause analysis | decision memo | review findings | implementation plan | test strategy>

## Success criteria

- <criterion 1>
- <criterion 2>
- <criterion 3>

## Repository map

<brief file tree or module map>

## Context Builder handoff summary

<Final/Handoff Prompt summary, including relationships and ambiguities>

## Selected repository context

<Repo Prompt export: files, slices, CodeMaps, diffs, docs>

## Constraints

- <user constraints>
- <technical constraints>
- <do not implement / do not modify files, if applicable>

## Known gaps and uncertainty

<missing context and assumptions>

## Analysis instructions

1. Summarize relevant system behavior in 5-10 bullets.
2. Identify the files, interfaces, data flow, and tests that matter.
3. Answer the task directly.
4. For debugging/review, rank failure modes and verification steps.
5. For planning/architecture, compare at least two approaches and recommend one.
6. For implementation planning, propose vertical slices that can be tested end-to-end.
7. End with the smallest next action that reduces uncertainty.
```

### 4. Next Context Move

If enough:

```markdown
Next context move: Paste the GPT-5.5 Pro Context Prompt into ChatGPT Pro.
```

If not enough:

```markdown
Next context move: Add <specific missing context> before sending to GPT-5.5 Pro.
```

## Mode-Specific Additions

### Question

Include entry points, call flow, public interfaces, and docs. Ask for explanation, not a fix.

### Debug

Include error text, repro steps, failing tests, logs, recent diffs, and the smallest end-to-end path that triggers the bug. Ask for ranked hypotheses before fixes.

### Plan

Include current architecture, examples of similar features, constraints, tests, and module seams. Ask for alternatives, tradeoffs, and vertical slices.

### Review

Start with `git(diff, artifacts:true)` when available. Include the diff plus enough surrounding code to detect cross-module risk. Ask for severity, evidence, and missing tests.

### Architecture

Include CodeMaps for neighboring modules, docs/ADRs, dependency paths, tests, and examples. Ask about interfaces, locality, leverage, migration risk, and testability.

### Test Strategy

Include public interfaces, existing test style, risky branches, data models, and failure modes. Ask for tests that verify behavior rather than implementation details.

## Built-In Presets

For ready-to-copy Repo Prompt prompts, read `presets/repoprompt-presets.md`.

Use those presets when the user asks for a specific mode or when the Context Builder request needs to be stricter than the default template.

## Common Mistakes

| Mistake | Fix |
|---|---|
| Calling `context_builder` once and stopping | Inspect, prune, repair, then export or ask Oracle |
| Ignoring Selection side effects | Run `workspace_context` before and after |
| Treating Final Prompt as fact | Verify `<ambiguities>` or mark gaps |
| Letting Context Builder overfill the packet | Convert full files to slices/CodeMaps and split tasks |
| Asking Oracle about unselected files | Add files first or run Context Builder |
| Reviewing diff without git context | Add `git(diff, artifacts:true)` before review |
| Selecting the whole repo | Split by workflow, seam, bug, or review theme |
| Including old PRDs as current truth | Remove or mark historical |
| Asking GPT-5.5 Pro to browse the repo | Export the curated context into the prompt |
| Applying edits during context prep | Stop. This skill only prepares context |

## Fallback When Repo Prompt MCP Is Unavailable

Ask the user to run Repo Prompt manually:

```text
In Repo Prompt, run Context Builder with response_type: clarify.

Task: <precise task>

Find the minimal sufficient repository context. Return selected files, slices, CodeMaps, relevant tests, recent diffs if applicable, why each item is included, missing context, ambiguities, and token estimate. Avoid stale docs, generated files, broad directories, and unrelated code.
```

Then ask the user to paste or export the resulting Repo Prompt context. Build the GPT-5.5 Pro Context Prompt from that packet.

## Final Rule

This skill is complete only when the user has a high-signal, low-noise, paste-ready GPT-5.5 Pro context prompt, a clear orchestration report, and a precise list of missing context if the packet is not sufficient.
