# insight-essay-writer v7 editor-gates

Use this skill to turn one or more source materials into a publishable high-insight Chinese longform essay.

v7 keeps the v6 publish-polish spine and adds four editor gates exposed by recent article reviews:

- source traceability, so technical/current articles keep sources findable
- primary source title distance, so article titles do not become translated source titles
- series anti-rut, so consecutive Agent/AI essays do not repeat the same mechanism
- artifact extraction, so the reader-facing tool is copyable into a real meeting doc

## Install

Claude Code:

```bash
mkdir -p ~/.claude/skills
unzip insight-essay-writer-v7-editor-gates.zip -d ~/.claude/skills
```

Codex:

```bash
mkdir -p ~/.agents/skills
unzip insight-essay-writer-v7-editor-gates.zip -d ~/.agents/skills
```

## Example prompt

```text
Use insight-essay-writer. Read the attached materials and write a publishable Chinese essay. Keep all research notes internal. Make the title and section headings natural, include one usable reader-facing decision tool, and include a compact 资料来源 section with source title, platform/date, and link when available.
```

## Series-aware prompt

```text
Use insight-essay-writer. Here are the last 5 published essays and the new source material. Write the next article. Avoid repeating title skeletons, main mechanisms, artifact type, and ending decision unless the source forces it.
```

## Best-of-N review

```text
Use insight-essay-writer in Best-of-N mode. Compare these drafts from the same source material. Pick the champion, salvage the best modules from the other drafts, and identify skill improvements.
```
