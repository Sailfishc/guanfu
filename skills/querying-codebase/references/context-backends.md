# Context backend reference

Use this only when the main skill instructions are insufficient.

## RepoPrompt MCP backend

Preferred when connected:

- `RepoPrompt:workspace_context`: current selection, prompt, token budget, workspace state
- `RepoPrompt:get_file_tree`: repo or module tree
- `RepoPrompt:file_search`: file paths, symbols, strings, tests, docs, call sites
- `RepoPrompt:get_code_structure`: CodeMaps, exports, classes, functions, types
- `RepoPrompt:read_file`: exact file content after narrowing
- `RepoPrompt:git`: status, diff, log, show, blame, history

## Native fallback backend

Use native Codex tools or shell equivalents:

- tree/list files: `find`, `ls`, `git ls-files`
- search: `rg`, `grep`, native search tools
- structure: language-aware commands when available, otherwise read imports/exports/tests
- git: `git status`, `git diff`, `git log`, `git show`, `git blame`

Keep the same workflow shape:

```text
discover -> inspect structure -> read exact snippets -> answer with evidence
```
