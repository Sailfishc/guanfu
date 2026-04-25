---
name: using-repo-prompt-mcp
description: Use when working in a code repository where task success depends on repository-wide context, cross-file understanding, planning, debugging, review, refactoring, or curated AI coding context through Repo Prompt MCP.
---

# Using Repo Prompt MCP

## Purpose

Use Repo Prompt MCP as the preferred context layer for repository-wide understanding.

This skill guides the agent to use Repo Prompt for context discovery, CodeMaps, selection management, prompt handoff, workspace-aware reads, and git-aware context before planning, reviewing, debugging, or changing code.

Use the registered MCP server namespace. This package assumes `RepoPrompt`.

## Tool policy

Use fully qualified Repo Prompt MCP tool names.

Core pattern:

1. Discover repository shape.
2. Find relevant files, symbols, tests, docs, and call sites.
3. Inspect structure through CodeMaps.
4. Curate the selection and token budget.
5. Build task-specific context or handoff prompt.
6. Use native tools for implementation and verification.

## Primary context discovery tools

Use these tools first when repository context matters.

| Need | Preferred tool |
|---|---|
| Understand repository shape | `RepoPrompt:get_file_tree` |
| Find files, symbols, text, tests, docs, or call sites | `RepoPrompt:file_search` |
| Understand APIs, exports, classes, functions, types, and module boundaries | `RepoPrompt:get_code_structure` |
| Build multi-file context for planning, debugging, review, refactoring, or architecture analysis | `RepoPrompt:context_builder` |
| Check selection, prompt, file tree state, token budget, and workspace state | `RepoPrompt:workspace_context` |

### `RepoPrompt:get_file_tree`

Use at the start of work in an unfamiliar repository, package, module, or feature area.

Good triggers:
- Relevant files are unknown.
- The repo has multiple packages or apps.
- The request references a feature area, domain concept, or architecture concern.
- A directory-level map helps narrow search.

### `RepoPrompt:file_search`

Use to find relevant files, symbols, exact strings, error text, route names, config keys, domain terms, tests, docs, and call sites.

Good triggers:
- A stack trace includes function, file, or class names.
- The user names a feature and gives no path.
- A review needs surrounding usage, tests, or contracts.
- A refactor needs every call site.

### `RepoPrompt:get_code_structure`

Use to inspect CodeMaps and API surface before planning or editing.

Good triggers:
- The task involves module boundaries.
- The agent needs interfaces before full implementations.
- Large files would consume too much context.
- The plan needs classes, functions, exports, types, or call graph shape.

### `RepoPrompt:context_builder`

Use for multi-file planning, debugging, review, refactoring, architecture analysis, and repository questions.

Use response style by task when supported by the MCP server:
- `question` for answering codebase questions.
- `plan` for implementation or refactor planning.
- `review` for code review.
- `clarify` for context assembly and handoff preparation.

### `RepoPrompt:workspace_context`

Use before changing Repo Prompt context.

Check:
- Current selection.
- Current prompt.
- Token budget.
- File tree state.
- Workspace state.

Use it again after selection changes when token budget matters.

## Context orchestration tools

Use these tools when the task needs curated, reusable, or handoff-quality context.

| Need | Preferred tool |
|---|---|
| Curate selected files, folders, or slices | `RepoPrompt:manage_selection` |
| Build, append, export, or switch structured handoff prompts | `RepoPrompt:prompt` |
| Read through Repo Prompt workspace context | `RepoPrompt:read_file` |
| Inspect status, diff, log, show, blame, or history | `RepoPrompt:git` |

### `RepoPrompt:manage_selection`

Use after discovery to turn search results into a deliberate context pack.

Typical uses:
- Add files found by `RepoPrompt:file_search`.
- Add related tests, types, docs, configs, and call sites.
- Preview current selection before expanding scope.
- Replace selection when current context points at the wrong feature area.
- Use slices for large files.
- Keep selection within the token budget shown by `RepoPrompt:workspace_context`.

Selection hygiene:
1. Start with `RepoPrompt:workspace_context`.
2. Add files from search and CodeMaps deliberately.
3. Include tests and contracts alongside source files.
4. Prefer slices for large files.
5. Preview selection before handoff.
6. Keep token budget visible.
7. Use `RepoPrompt:prompt` after selection reflects the task.

A strong selection usually contains:
- Target source files.
- Nearest tests.
- Types, schemas, interfaces, or API contracts.
- Relevant docs or specs.
- Runtime config that affects behavior.
- Call sites that prove API usage.

### `RepoPrompt:prompt`

Use when the workflow needs a structured handoff prompt.

Typical uses:
- Create a planning prompt after context selection.
- Add task constraints after files are selected.
- Export reusable context for another AI coding tool.
- Switch to a Plan, Review, Clarify, or Apply-style preset when the workflow calls for it.

Prompt hygiene:
- Name the task.
- Name the selected files and why they matter.
- State constraints and success criteria.
- Include known unknowns.
- Keep implementation instructions separate from context notes.

### `RepoPrompt:read_file`

Use when the read should stay connected to the Repo Prompt workspace.

Good triggers:
- The path came from `RepoPrompt:file_search`.
- The file is part of the current Repo Prompt selection.
- The read will inform selection, slicing, or prompt construction.
- The task needs Repo Prompt workspace coherence.
- The agent needs exact snippets after CodeMap inspection.

Use native `Read` for quick known-path source checks during implementation.

### `RepoPrompt:git`

Use when repository history affects the task.

Typical uses:
- Inspect status, diff, or changed files.
- Pair a diff with surrounding context for review.
- Read recent commits before planning.
- Check blame or history for a suspicious change.
- Compare branch changes with selected source and tests.

Use native git commands for commit, push, PR creation, and verification workflows.

## Recommended workflows

### Repository question

1. Use `RepoPrompt:get_file_tree` for unfamiliar repositories.
2. Use `RepoPrompt:file_search` for relevant symbols, routes, files, and terms.
3. Use `RepoPrompt:get_code_structure` for API surface and module boundaries.
4. Use `RepoPrompt:context_builder` with response style `question` when the answer spans multiple files.
5. Use `RepoPrompt:read_file` for exact file content inside the Repo Prompt workspace.
6. Answer with concrete file and symbol references.

### Planning a feature or refactor

1. Use `RepoPrompt:workspace_context` to inspect current state.
2. Use `RepoPrompt:get_file_tree` and `RepoPrompt:file_search` to map the area.
3. Use `RepoPrompt:get_code_structure` to understand interfaces and dependencies.
4. Use `RepoPrompt:context_builder` with response style `plan`.
5. Use `RepoPrompt:manage_selection` to add related tests, types, docs, configs, and call sites.
6. Use `RepoPrompt:prompt` to create the final planning handoff.
7. Move implementation to native edit and verification tools.

### Debugging

1. Use `RepoPrompt:file_search` for error text, failing test names, stack trace symbols, and related domain terms.
2. Use `RepoPrompt:get_code_structure` for involved modules.
3. Use `RepoPrompt:context_builder` with response style `plan` or `question`.
4. Use `RepoPrompt:manage_selection` to include suspected source files, call sites, tests, and configuration.
5. Use `RepoPrompt:read_file` to inspect exact code paths before proposing the fix.
6. Write or run a focused regression test through native tools.

### Code review

1. Use `RepoPrompt:git` to inspect diff, status, log, and changed files.
2. Use `RepoPrompt:file_search` to find surrounding call sites and tests.
3. Use `RepoPrompt:get_code_structure` for changed modules and dependencies.
4. Use `RepoPrompt:manage_selection` to include changed files plus relevant context.
5. Use `RepoPrompt:context_builder` with response style `review`.
6. Report findings with file, symbol, risk, evidence, and suggested fix.

### Context handoff

1. Use `RepoPrompt:workspace_context` to inspect existing state.
2. Use `RepoPrompt:manage_selection` to curate source, tests, docs, configs, and slices.
3. Use `RepoPrompt:prompt` to produce a clear handoff.
4. Confirm token budget.
5. State what the receiving agent should do next.

## Native tool routing

Use the agent's native tools for direct execution work.

| Phase | Repo Prompt MCP | Native tools |
|---|---|---|
| Discovery | file tree, search, CodeMaps, context builder | grep/glob when MCP is unavailable |
| Context packaging | workspace context, selection, prompt | local notes or plan files |
| Exact reading | Repo Prompt read_file for workspace-tied reads | native Read for known-file reads |
| Implementation | reviewed context and plan | native Edit/Write/Bash |
| Verification | git context when useful | tests, build, lint, git commands |
| Shipping | context and review support | commit, push, PR tools |

## Write-operation boundary

Write-capable Repo Prompt tools belong to explicit patch/apply workflows.

- `RepoPrompt:apply_edits`
  Use when applying a structured, reviewable patch generated through Repo Prompt.

- `RepoPrompt:file_actions`
  Use when the workflow explicitly includes file creation, deletion, move, or rename through Repo Prompt.

Before using write-capable tools:
1. Inspect the intended change.
2. Keep the diff reviewable.
3. Preserve user-visible context.
4. Verify with tests or build commands through native tools after applying changes.

## Failure handling

When a Repo Prompt MCP tool is unavailable, stale, or overly broad:

1. Continue with native tools.
2. Use grep, glob, read, and git commands to recover missing context.
3. Preserve the same workflow shape: discover, inspect structure, curate context, plan, implement, verify.
4. Record the MCP limitation in the final report when it affected confidence or coverage.

## Additional resources

- For complete tool boundaries and examples, read [references/repo-prompt-mcp-tools.md](references/repo-prompt-mcp-tools.md).
- For installation notes across Claude Code and Codex, read [references/install.md](references/install.md).

## Completion standard

Before moving from context work to implementation or final answer, verify:

- Relevant module boundaries are understood.
- Selected context includes source, tests, and contracts where applicable.
- Token budget is known.
- Large files use slices or CodeMaps when full content adds low value.
- The final plan or answer names the concrete files and symbols it depends on.
