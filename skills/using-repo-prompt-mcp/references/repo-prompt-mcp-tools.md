# Repo Prompt MCP Tools Reference

This reference expands the main `SKILL.md` with tool boundaries, common uses, and routing guidance.

Use the registered MCP server namespace. This reference assumes `RepoPrompt`.

## Discovery tools

### `RepoPrompt:get_file_tree`

Use to map repository shape.

Best for:
- Unfamiliar repositories.
- Monorepos.
- Package or module boundaries.
- Finding likely entry points before search.

Output should guide the next search or structure inspection.

### `RepoPrompt:file_search`

Use to find files, symbols, text, tests, docs, and call sites.

Search targets:
- User-facing feature names.
- Error messages.
- Stack trace symbols.
- Type, class, function, route, command, config, and table names.
- Test names and fixture names.

Run focused searches for each major concept.

### `RepoPrompt:get_code_structure`

Use for CodeMaps and API surface.

Best for:
- Large files.
- Public interfaces.
- Classes, functions, exports, types, and module boundaries.
- Dependency shape before exact reading.

Use this before full reads when implementation details are secondary.

### `RepoPrompt:context_builder`

Use when multiple files matter.

Recommended response styles:
- `question`: answer a repository question.
- `plan`: produce implementation or refactor plan.
- `review`: review changed code with surrounding context.
- `clarify`: assemble context and identify unknowns.

Context builder works best after the task is described with concrete constraints and known file names, symbols, or failure signals.

## Context orchestration tools

### `RepoPrompt:workspace_context`

Use before and after selection changes.

Inspect:
- Selection.
- Prompt.
- Token budget.
- File tree state.
- Workspace state.

This tool prevents context drift during long planning or review sessions.

### `RepoPrompt:manage_selection`

Use to curate selected files, folders, and slices.

Actions can include add, remove, set, clear, and preview depending on the MCP server implementation.

Use cases:
- Add search results.
- Add nearest tests.
- Add contracts, schemas, or types.
- Add runtime config.
- Add call sites.
- Replace stale context.
- Preview selected content before handoff.

Selection rule:

A selection should explain the task with source, tests, contracts, config, and usage examples while staying inside token budget.

### `RepoPrompt:prompt`

Use to manage handoff prompt state.

Use cases:
- Set task instructions.
- Append constraints.
- Export prompt text.
- Switch presets for plan, review, clarify, or apply workflows.

A strong handoff prompt contains:
- Task.
- Selected context summary.
- Constraints.
- Success criteria.
- Files and symbols that matter.
- Unknowns that require verification.

### `RepoPrompt:read_file`

Use for workspace-aware exact reads.

Use cases:
- Read a selected file.
- Read exact snippets after CodeMap inspection.
- Check whether a large file should be sliced.
- Verify a file found through Repo Prompt search.

Native `Read` stays useful for fast known-path checks during implementation.

### `RepoPrompt:git`

Use for git-aware context.

Use cases:
- Status.
- Diff.
- Changed files.
- Recent commits.
- Blame.
- Show commit or file revisions.

Use it to combine branch changes with repository context before review or planning.

## Built-in chat tools

### `RepoPrompt:chat_send`

Use when the workflow intentionally routes analysis through Repo Prompt's built-in chat.

Good fit:
- Compare model responses over the same selected context.
- Continue an existing Repo Prompt chat tied to the current context.
- Keep discussion inside Repo Prompt workspace state.

### `RepoPrompt:chats`

Use to inspect or continue Repo Prompt chat history when the existing chat carries important context.

### `RepoPrompt:list_models`

Use when the workflow needs to choose a Repo Prompt model or preset.

## Write-capable tools

### `RepoPrompt:apply_edits`

Use in patch/apply workflows with a reviewable diff.

Required checks:
1. Confirm the task calls for applying a patch.
2. Inspect intended changes.
3. Keep changes scoped.
4. Run native tests or build verification after apply.

### `RepoPrompt:file_actions`

Use for file creation, deletion, move, or rename through Repo Prompt when the workflow explicitly calls for Repo Prompt-managed file operations.

Required checks:
1. Name each file operation.
2. Preserve reversibility through git.
3. Verify resulting file tree.
4. Run relevant tests or build checks.

## Workspace tools

### `RepoPrompt:manage_workspaces`

Use for multi-workspace, multi-window, tab, or folder orchestration.

Good fit:
- A task spans multiple folders opened in Repo Prompt.
- The agent needs to switch active workspace context.
- The user already prepared a workspace for a specific feature area.

## Routing recipes

### Unknown feature area

1. `RepoPrompt:get_file_tree`
2. `RepoPrompt:file_search`
3. `RepoPrompt:get_code_structure`
4. `RepoPrompt:context_builder`
5. `RepoPrompt:manage_selection`
6. `RepoPrompt:prompt`

### Known symbol or error

1. `RepoPrompt:file_search`
2. `RepoPrompt:get_code_structure`
3. `RepoPrompt:read_file`
4. `RepoPrompt:manage_selection`
5. `RepoPrompt:context_builder`

### Review branch diff

1. `RepoPrompt:git`
2. `RepoPrompt:file_search`
3. `RepoPrompt:get_code_structure`
4. `RepoPrompt:manage_selection`
5. `RepoPrompt:context_builder` with review style

### Prepare handoff to another AI coding tool

1. `RepoPrompt:workspace_context`
2. `RepoPrompt:manage_selection`
3. `RepoPrompt:prompt`
4. Export or summarize the handoff

## Fallback routing

When Repo Prompt MCP output is unavailable or too broad, use native tools while preserving the workflow shape:

- `get_file_tree` fallback: native glob/tree/find.
- `file_search` fallback: native grep/rg.
- `get_code_structure` fallback: targeted reads and language tooling.
- `context_builder` fallback: manual context summary.
- `workspace_context` fallback: local notes plus file list.
- `manage_selection` fallback: explicit list of files and slices in the plan.
- `prompt` fallback: markdown handoff.
- `read_file` fallback: native Read.
- `git` fallback: native git commands.
