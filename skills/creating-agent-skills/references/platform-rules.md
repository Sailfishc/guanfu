# Platform Rules

## Shared open skill shape

A portable skill is a folder with:

```text
skill-name/
  SKILL.md
  references/     # optional
  scripts/        # optional
  assets/         # optional
  agents/         # optional, Codex-specific metadata can live here
```

`SKILL.md` starts with YAML frontmatter containing at least:

```yaml
---
name: skill-name
description: Use when ...
---
```

Name rules:

- lowercase letters, numbers, hyphens
- maximum 64 characters
- avoid reserved platform words
- match the directory name

Description rules:

- non-empty
- maximum 1024 characters
- third-person routing language
- trigger phrases and boundaries before implementation detail

## Codex

Use these locations:

```text
<repo>/.agents/skills/<skill-name>/SKILL.md
~/.agents/skills/<skill-name>/SKILL.md
/etc/codex/skills/<skill-name>/SKILL.md
```

Codex supports explicit invocation with `$skill-name` and implicit invocation through the description. `agents/openai.yaml` can set UI metadata and invocation policy.

Suggested `agents/openai.yaml`:

```yaml
interface:
  display_name: "Readable Name"
  short_description: "One-line purpose."
  default_prompt: "Use this skill for ..."
policy:
  allow_implicit_invocation: true
```

## Claude Code

Use these locations:

```text
<repo>/.claude/skills/<skill-name>/SKILL.md
~/.claude/skills/<skill-name>/SKILL.md
```

Claude Code uses `SKILL.md` and bundled files. Codex-specific `agents/openai.yaml` can remain in the folder because Claude can ignore it.

## Claude.ai and API

Use a zip containing the skill directory. Keep bundled assets local and portable. For API and team use, document dependency and runtime assumptions.

## Cross-platform packaging rule

Downloadable packages should include:

```text
skills/<skill-name>/                 # visible source of truth
.agents/skills/<skill-name>/         # Codex mirror, when requested
.claude/skills/<skill-name>/         # Claude Code mirror, when requested
scripts/install-*.sh                 # installer helpers
README.md                            # install and eval commands
```

Keep mirrored copies byte-identical. Run the validation script after mirroring.
