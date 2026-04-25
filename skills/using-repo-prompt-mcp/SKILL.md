---
name: using-repo-prompt-mcp
description: Use when repository-wide code context, cross-file understanding, planning, debugging, review, refactoring, or curated handoff context would improve a coding task through Repo Prompt MCP.
---

# Using Repo Prompt MCP

## Core rule

Use Repo Prompt MCP as the context layer for repository-wide coding work.

MCP tool metadata explains individual tools. This skill defines routing, priority, and boundaries.

Default server prefix: `RepoPrompt`.

## Use when

Use this skill for:

- Unknown relevant files or symbols
- Multi-file planning, debugging, review, refactoring, or architecture analysis
- Large files where CodeMaps or slices can control token usage
- Tasks needing curated context for another AI coding tool
- Diffs where surrounding call sites, tests, contracts, or config matter

## Tool routing

Use fully qualified tool names.

| Need | Preferred tool |
|---|---|
| Inspect repo or module shape | `RepoPrompt:get_file_tree` |
| Find files, symbols, strings, tests, docs, or call sites | `RepoPrompt:file_search` |
| Inspect APIs, exports, classes, functions, types, and module boundaries | `RepoPrompt:get_code_structure` |
| Build task-specific context for question, plan, review, debug, or refactor | `RepoPrompt:context_builder` |
| Check current selection, prompt, token budget, and workspace state | `RepoPrompt:workspace_context` |
| Curate selected files, folders, and slices | `RepoPrompt:manage_selection` |
| Build, append, export, or switch handoff prompts/presets | `RepoPrompt:prompt` |
| Read exact file content inside Repo Prompt workspace context | `RepoPrompt:read_file` |
| Inspect status, diff, log, show, blame, or branch history | `RepoPrompt:git` |

## Default workflow

1. Start with `RepoPrompt:workspace_context` when a Repo Prompt workspace may already contain useful selection or prompt state.
2. Use `RepoPrompt:get_file_tree` for unfamiliar repos, packages, modules, or feature areas.
3. Use `RepoPrompt:file_search` to find candidate source, tests, docs, configs, and call sites.
4. Use `RepoPrompt:get_code_structure` to understand API surface and module boundaries before reading large files.
5. Use `RepoPrompt:context_builder` for multi-file answers, plans, reviews, debugging, and refactors.
6. Use `RepoPrompt:manage_selection` when the task needs a reusable context pack or handoff.
7. Use `RepoPrompt:prompt` when exporting a structured handoff prompt or switching presets.
8. Use native tools for implementation, tests, builds, commits, pushes, and PR creation.

## Selection guidance

A strong Repo Prompt selection usually contains:

- Target source files
- Nearest tests
- Types, schemas, interfaces, and API contracts
- Runtime config that affects behavior
- Docs or specs that define expected behavior
- Call sites that show real API usage

Selection rules:

- Prefer CodeMaps or slices for large files.
- Recheck token budget with `RepoPrompt:workspace_context` after selection changes.
- Use `RepoPrompt:read_file` for exact snippets after search, CodeMap inspection, or selection curation.
- Use native `Read` for quick known-path reads during implementation.

## Native tool boundary

Repo Prompt MCP owns context discovery and context orchestration.

Native tools own execution:

- Known-file quick reads
- Edits and writes
- Tests, builds, lint, typecheck
- Package scripts
- Local shell commands
- Commits, pushes, and PR/MR creation

## Write-capable Repo Prompt tools

Use these only in explicit patch/apply workflows:

- `RepoPrompt:apply_edits`
- `RepoPrompt:file_actions`

Before using them:

1. Inspect the intended change.
2. Keep the diff reviewable.
3. Apply the smallest coherent patch.
4. Verify through native test/build tools.

## Fallback

When Repo Prompt MCP is unavailable, stale, or too broad, continue with native tools while preserving the same workflow shape:

```text
discover -> inspect structure -> curate context -> plan -> implement -> verify
```

Mention the fallback in the final report when it affects confidence or coverage.

## Reference

For the compact full tool map, read `references/repo-prompt-mcp-tools.md` only when the task needs tools outside the routing table above.
