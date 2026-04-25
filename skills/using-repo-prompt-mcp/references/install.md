# Installation Notes

This package is a single Agent Skill for using Repo Prompt MCP as the preferred repository context layer.

## Claude Code

Personal skill across projects:

```bash
mkdir -p ~/.claude/skills
cp -R using-repo-prompt-mcp ~/.claude/skills/
```

Project skill for one repository:

```bash
mkdir -p .claude/skills
cp -R using-repo-prompt-mcp .claude/skills/
```

Invoke directly:

```text
/using-repo-prompt-mcp
```

Claude Code uses `SKILL.md` and referenced files. The `agents/openai.yaml` file is included for Codex metadata.

## Codex

Personal skill across projects:

```bash
mkdir -p ~/.agents/skills
cp -R using-repo-prompt-mcp ~/.agents/skills/
```

Project skill for one repository:

```bash
mkdir -p .agents/skills
cp -R using-repo-prompt-mcp .agents/skills/
```

Invoke explicitly with the skill selector or by naming the skill in the prompt.

Codex can use `SKILL.md`, `references/`, and the optional `agents/openai.yaml` metadata file.

## MCP server namespace

The skill uses `RepoPrompt:*` tool names. Configure your MCP server name as `RepoPrompt`, or replace the prefix in `SKILL.md` and `references/repo-prompt-mcp-tools.md` with your registered server name.

## Package contents

```text
using-repo-prompt-mcp/
├── SKILL.md
├── agents/
│   └── openai.yaml
└── references/
    ├── install.md
    └── repo-prompt-mcp-tools.md
```
