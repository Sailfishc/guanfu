# Packaging Guide

## Human-visible layout

Every downloadable package should show the skill in Finder and normal file browsers:

```text
skills/<skill-name>/SKILL.md
```

Dot directories are agent-discoverable mirrors, not the only copy.

## Codex package

```text
.agents/skills/<skill-name>/SKILL.md
.agents/skills/<skill-name>/agents/openai.yaml
```

Install:

```bash
mkdir -p <repo>/.agents/skills
cp -R skills/<skill-name> <repo>/.agents/skills/
```

## Claude Code package

```text
.claude/skills/<skill-name>/SKILL.md
```

Install:

```bash
mkdir -p <repo>/.claude/skills
cp -R skills/<skill-name> <repo>/.claude/skills/
```

## User-level install

```bash
mkdir -p ~/.agents/skills ~/.claude/skills
cp -R skills/<skill-name> ~/.agents/skills/
cp -R skills/<skill-name> ~/.claude/skills/
```

## Package checklist

- `README.md` explains install, usage, evals, and limitations
- `PATTERNS.md` records reusable learnings
- `AGENTS.md.snippet` provides Codex routing guidance
- `CLAUDE.md.snippet` provides Claude Code routing guidance
- `skills/` contains visible source copy
- `.agents/skills/` mirrors Codex copy when targeting Codex
- `.claude/skills/` mirrors Claude Code copy when targeting Claude Code
- `evals/` contains JSONL cases and runner
- `scripts/validate-package.sh` passes
- Zip preserves dot directories

## Versioning

Use semantic versioning for packages:

```text
creating-agent-skills-meta-v1.0.0.zip
```

Document known limitations. State which evals were run and which are pending.
