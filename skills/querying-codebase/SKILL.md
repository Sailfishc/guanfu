---
name: querying-codebase
description: Use when answering repository questions, locating implementations, finding related files, tracing callers/callees, locating tests/config/schema, or explaining how a feature works. Trigger words include where, find, trace, call sites, tests, config, schema, 这个在哪, 查找, 追踪, 相关文件, 测试在哪. Do not use for known-file edits, pure test/build/lint, commits, pushes, PRs, or generic programming questions.
---

# Querying Codebase

## Core rule

Answer repository questions by discovering the smallest reliable context first. The user-facing purpose is querying the codebase, not using a particular tool.

Preferred backend: RepoPrompt MCP if available. Fallback: native Codex tools with the same workflow shape.

## Use when

Use this skill for:

- “Where is X implemented?”
- “Find related files/tests/config/schema.”
- “Trace this flow/call chain.”
- “Explain how this feature works in this repo.”
- “Which files matter for this behavior?”
- Chinese equivalents: “这个在哪实现”, “查找相关文件”, “追踪调用链”, “测试在哪”, “配置在哪”.

Do not use this skill for:

- Single known-file edits.
- Pure shell/test/build/lint commands.
- Commits, pushes, PR/MR creation.
- Generic programming explanations that do not require repo context.
- Requests where the user explicitly says not to use skills or context tools.

## Tool preference

Use fully qualified MCP tool names when RepoPrompt is connected.

| Need | Preferred backend tool |
|---|---|
| Existing context, selection, prompt, token state | `RepoPrompt:workspace_context` |
| Repository or module shape | `RepoPrompt:get_file_tree` |
| Files, symbols, strings, docs, tests, call sites | `RepoPrompt:file_search` |
| APIs, exports, classes, functions, types, boundaries | `RepoPrompt:get_code_structure` |
| Exact content after search/structure inspection | `RepoPrompt:read_file` |
| Git status, diff, log, show, blame | `RepoPrompt:git` |

If these tools are unavailable, use native file search/read commands and mention fallback only if it affects confidence.

## Query workflow

1. Identify the query type: implementation location, flow trace, related files, tests/config/schema, or architecture explanation.
2. Start broad only when necessary: workspace context → tree → search. Do not read large files blindly.
3. Search twice:
   - direct names from the prompt
   - behavior terms and user-visible strings that would appear in code/tests/docs
4. Inspect structure before bodies for large modules. Prefer code structure summaries before reading full files.
5. Read exact snippets only after candidates are narrowed.
6. Cross-check nearest tests, configs, schemas, and call sites when they affect the answer.
7. Return a concise answer with evidence and confidence. Do not edit files.

## Output format

Use this format unless the user asked for something else:

```text
QUERY RESULT
- Answer: <1-3 sentence answer>
- Primary files: <paths and why each matters>
- Supporting files: <tests/config/schema/docs/call sites>
- Flow: <short trace when relevant>
- Confidence: high | medium | low, with reason
- Next step: <optional concrete next action>
```

## Common mistakes

| Mistake | Correction |
|---|---|
| Reading only the first matching file | Search call sites, tests, config, and docs before answering. |
| Treating file name match as proof | Verify by reading exact code or structure. |
| Explaining without paths | Always name concrete file paths and symbols when possible. |
| Using write-capable tools | This skill answers and locates. It does not edit. |
| Hiding fallback | If RepoPrompt was unavailable and that lowers coverage, say so. |

## Reference

Read `references/context-backends.md` only when the main tool table is not enough.
