---
name: building-code-context
description: Use when curating multi-file repository context before planning, debugging, reviewing, refactoring, or handing work to another agent; relevant files are unknown; or tests/config/schema/call sites affect the task. Trigger words include build context, context pack, handoff, plan, review diff, refactor, debug, 构建上下文, 打包上下文, 交接, 多文件计划, 多文件调试, 审查diff. Do not use for single known-file edits, pure test/build/lint, commits, pushes, or PRs.
---

# Building Code Context

## Core rule

Build the smallest sufficient context pack for a downstream coding task. The user-facing purpose is context construction, not introducing a specific tool.

Preferred backend: RepoPrompt MCP if available. Fallback: native Codex tools with the same workflow shape.

## Use when

Use this skill when:

- The user asks to build, curate, package, or hand off context.
- A plan/debug/review/refactor depends on files not yet known.
- A branch diff needs nearby call sites, tests, contracts, schemas, or config.
- Another agent will receive the context.
- The task spans multiple modules or a large file where slices/structure summaries matter.
- Chinese equivalents appear: “构建上下文”, “打包上下文”, “交接给另一个 agent”, “多文件调试”, “审查 diff 并看周边调用”.

Do not use this skill for:

- Single known-file edits.
- Pure shell/test/build/lint commands.
- Commits, pushes, PR/MR creation.
- Generic programming explanations.
- Cases where the user explicitly says not to use skills or context tools.

## Tool preference

Use fully qualified MCP tool names when RepoPrompt is connected.

| Need | Preferred backend tool |
|---|---|
| Existing context, prompt, selection, token state | `RepoPrompt:workspace_context` |
| Repo/module/file shape | `RepoPrompt:get_file_tree` |
| Candidate files, symbols, strings, tests, call sites | `RepoPrompt:file_search` |
| API surface and module boundaries | `RepoPrompt:get_code_structure` |
| Task-specific context discovery | `RepoPrompt:context_builder` |
| Curated selection, slices, previews | `RepoPrompt:manage_selection` |
| Handoff prompt or preset export | `RepoPrompt:prompt` |
| Diffs and history | `RepoPrompt:git` |
| Exact content after narrowing | `RepoPrompt:read_file` |

Native Codex tools own edits, tests, builds, lint, typecheck, commits, pushes, and PR creation.

## Context-building workflow

1. Classify the target mode: plan, debug, review, refactor, or handoff.
2. Restate the task in one sentence and define what “sufficient context” means.
3. Discover candidate context:
   - target source files
   - nearest tests
   - call sites and consumers
   - types, schemas, interfaces, API contracts
   - runtime config and feature flags
   - docs/specs that define expected behavior
   - git diff/history when reviewing changes
4. Inspect structure before loading large bodies. Prefer CodeMaps/structure summaries and slices for large files.
5. Curate a context pack. Include why each file matters and what downstream work it enables.
6. Check for missing context. Name gaps instead of pretending coverage is complete.
7. Output a handoff-ready context pack. Do not implement unless the user separately asks for implementation.

## Output format

Use this format unless the user asked for something else:

```text
CONTEXT PACK
- Task: <one sentence>
- Mode: plan | debug | review | refactor | handoff
- Primary files: <path -> reason>
- Supporting files: <tests/config/schema/docs/call sites -> reason>
- Relationships: <how the files connect>
- Suggested slices or CodeMaps: <large files and relevant areas>
- Missing context / risks: <unknowns>
- Handoff prompt: <compact prompt another agent can use>
- Confidence: high | medium | low, with reason
```

## Boundaries

Context tools discover and package context.

Do not use write-capable RepoPrompt tools in this skill:

- `RepoPrompt:apply_edits`
- `RepoPrompt:file_actions`

If the user later asks to implement, switch to the appropriate implementation workflow and use native editing/testing tools.

## Common mistakes

| Mistake | Correction |
|---|---|
| Building a huge context pack | Keep the pack minimal and explain why each file is included. |
| Only including source files | Include nearest tests, configs, schemas, docs, and call sites when relevant. |
| Treating diff-only review as enough | Add surrounding context for changed behavior. |
| Editing during context construction | Stop at context unless the user explicitly requests implementation. |
| Hiding uncertainty | Name missing context and confidence. |

## Reference

Read `references/context-pack-template.md` only when a richer handoff template is needed.
