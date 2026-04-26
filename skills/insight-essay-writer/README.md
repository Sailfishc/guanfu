# Insight Essay Writer v4

This skill turns one or more source materials, transcripts, events, customer notes, or reference essays into a publishable high-insight Chinese longform article.

v4 focuses on five upgrades:

1. Deep insight stays first.
2. Strong reference essays trigger an originality gate.
3. Reader gain requires a concrete artifact: decision table, checklist, operating model, or failure-mode list.
4. Public articles stay clean, with research scaffolding kept internal.
5. Titles are natural, specific, curiosity-creating, and free of internal framework labels.

## Install in Claude Code

```bash
mkdir -p ~/.claude/skills
cp -R insight-essay-writer ~/.claude/skills/
```

## Install in Codex

```bash
mkdir -p ~/.agents/skills
cp -R insight-essay-writer ~/.agents/skills/
```

Repo-scoped install:

```bash
mkdir -p .agents/skills
cp -R insight-essay-writer .agents/skills/
```

## Install in Claude.ai

Upload the zipped `insight-essay-writer` folder as a custom Skill.

## Example prompt

```text
Use insight-essay-writer. Read the attached materials and write a publishable Chinese essay. Keep all research notes internal. If one attachment is a polished reference essay, use it only as a comparison target and write from a fresh angle.
```
