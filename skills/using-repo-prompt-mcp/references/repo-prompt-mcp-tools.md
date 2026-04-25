# Repo Prompt MCP Tool Map

Use this reference only when the main routing table is insufficient.

## Discovery

- `RepoPrompt:get_file_tree`: repository or module structure
- `RepoPrompt:file_search`: files, symbols, strings, tests, docs, call sites
- `RepoPrompt:get_code_structure`: CodeMaps, APIs, exports, classes, functions, types
- `RepoPrompt:context_builder`: task-specific context for question, plan, review, debug, refactor

## Context orchestration

- `RepoPrompt:workspace_context`: selection, prompt, token budget, workspace state
- `RepoPrompt:manage_selection`: add, remove, set, clear, preview files and slices
- `RepoPrompt:prompt`: set, append, export, or switch handoff prompts and presets
- `RepoPrompt:read_file`: exact reads tied to Repo Prompt workspace context
- `RepoPrompt:git`: status, diff, log, show, blame, history

## Built-in chat

Use when the workflow intentionally uses Repo Prompt chat state:

- `RepoPrompt:chat_send`
- `RepoPrompt:chats`
- `RepoPrompt:list_models`

## Write-capable tools

Use in explicit patch/apply workflows with reviewable diffs:

- `RepoPrompt:apply_edits`
- `RepoPrompt:file_actions`

## Workspace management

Use for multi-window, multi-tab, or workspace switching flows:

- `RepoPrompt:manage_workspaces`

## Routing recipes

| Situation | Route |
|---|---|
| Unknown feature area | `workspace_context` -> `get_file_tree` -> `file_search` -> `get_code_structure` -> `context_builder` |
| Known symbol or error | `file_search` -> `get_code_structure` -> `read_file` -> `context_builder` |
| Review branch diff | `git` -> `file_search` for call sites/tests -> `manage_selection` -> `context_builder` review |
| Handoff prompt | `workspace_context` -> `manage_selection` -> `prompt` |
