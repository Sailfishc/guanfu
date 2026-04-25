# using-repo-prompt-mcp

A cross-platform Agent Skill for using Repo Prompt MCP as the preferred repository context layer.

## What it does

This skill routes repository-wide context work through Repo Prompt MCP:

- repository structure
- file and symbol search
- CodeMaps
- context builder
- workspace context
- selection management
- prompt handoff
- workspace-aware reads
- git-aware context

Implementation, tests, build commands, commits, and PR work stay with the agent's native tools.

## Install

For Claude Code:

```bash
cp -R using-repo-prompt-mcp ~/.claude/skills/
```

For Codex:

```bash
cp -R using-repo-prompt-mcp ~/.agents/skills/
```

For repo-scoped use, copy to `.claude/skills/` for Claude Code or `.agents/skills/` for Codex.

## Codex metadata

`agents/openai.yaml` is included for Codex. It declares UI metadata, implicit invocation policy, and the Repo Prompt MCP dependency.

Claude Code uses `SKILL.md` and referenced files.

## MCP server name

The default server prefix is `RepoPrompt`. Update the prefix in the markdown files when your MCP server is registered under another name.
