# using-repo-prompt-mcp

A compact Agent Skill that routes repository-wide context work through Repo Prompt MCP.

## Install

Claude Code:

```bash
cp -R using-repo-prompt-mcp ~/.claude/skills/
```

Codex:

```bash
cp -R using-repo-prompt-mcp ~/.agents/skills/
```

Repo-scoped use:

```bash
cp -R using-repo-prompt-mcp .claude/skills/   # Claude Code
cp -R using-repo-prompt-mcp .agents/skills/   # Codex
```

## Platform notes

Claude Code uses `SKILL.md` and optional reference files.

Codex also reads `agents/openai.yaml` for UI metadata, invocation policy, and MCP dependency declaration.

Default MCP server prefix: `RepoPrompt`.
