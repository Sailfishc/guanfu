# 观复 GuanFu

> 观其所起，复其所行。
> A Zen-inspired, evolvable engineering harness for AI-native development.

观复是一套面向 AI 研发的 skills 与文档 harness。它把模糊想法推进为清晰问题、可执行计划、可验证实现、事后 review、复利经验，再把真实失败反哺到下一轮 skills 迭代。

核心宗旨：**可迭代，可进化，第一次失败可容忍，重复失败必须进入系统记忆。**

## v0.4.1 的结构修正

v0.4.1 按 Agent Skills 标准重构 `gf-init`：

```text
skills/gf-init/
  SKILL.md
  scripts/gf-init.sh
  assets/templates/*.md
```

这解决两个问题：

1. Codex / agents 安装时只复制 `skills/gf-*`，模板也会跟着 `gf-init` 一起复制。
2. `gf-init` 的脚本和模板与 skill 内聚，避免 `bin/`、包根 `scripts/`、包根 `templates/` 之间漂移。

包根目录只保留包级验证脚本：

```text
scripts/gf-validate.sh
```

## 价值观

### 1. 消除 AI 协作中的存在问题

AI 协作的典型问题包括：上下文漂移、浅层追问、过早执行、计划发散、无证据完成、review 只看表面、同类错误反复出现。观复用阶段、文档、router、taste constraints、ADR、review、compound note 和 skill evolution 来减少这些失败。

### 2. 利用 AI 的杠杆

AI 的杠杆来自可复制流程。观复让 AI 承担探索、对比、计划、实现、审查、复盘、知识沉淀和流程进化。最终目标是：**放大并挖掘 AI 的潜力，让工程判断随使用持续沉淀。**

## Harness 运行契约

```text
事前多讨论：gf-brainstorm 和 gf-plan 是 human loop。
事中坚决执行：gf-work 之后自动串行推进，中间记录异常并继续。
事后再对齐：gf-code-review、gf-doc-review、gf-compound、gf-evolve 吸收结果和 taste。
```

## 安装

Claude Code：

```bash
mkdir -p ~/.claude/skills
cp -R skills/gf-* ~/.claude/skills/
```

Codex / agents：

```bash
mkdir -p ~/.agents/skills
cp -R skills/gf-* ~/.agents/skills/
```

Repo-scoped Codex 安装：

```bash
mkdir -p .agents/skills
cp -R skills/gf-* .agents/skills/
```

安装后无需单独复制模板。模板在：

```text
skills/gf-init/assets/templates/
```

## 初始化仓库

Claude Code：

```bash
bash ~/.claude/skills/gf-init/scripts/gf-init.sh --new
```

Codex / agents：

```bash
bash ~/.agents/skills/gf-init/scripts/gf-init.sh --new
```

Repo-scoped 安装：

```bash
bash .agents/skills/gf-init/scripts/gf-init.sh --new
```

升级旧 repo：

```bash
bash ~/.agents/skills/gf-init/scripts/gf-init.sh --refresh
```

只检查：

```bash
bash ~/.agents/skills/gf-init/scripts/gf-init.sh --audit
```

## 推荐工作流

```text
/gf-init
/gf-brainstorm    # human loop
/gf-plan          # human loop, approve autonomous execution
/gf-work          # automated
/gf-code-review   # automated
/gf-doc-review    # automated
/gf-compound      # automated learning
/gf-evolve        # automated harness improvement when needed
```

## 包结构

```text
skills/
  gf-init/
    SKILL.md
    scripts/gf-init.sh
    assets/templates/
  gf-brainstorm/SKILL.md
  gf-plan/SKILL.md
  gf-work/SKILL.md
  gf-code-review/SKILL.md
  gf-doc-review/SKILL.md
  gf-compound/SKILL.md
  gf-evolve/SKILL.md
scripts/
  gf-validate.sh
tests/
  pressure-scenarios.md
```

## 验证包

```bash
bash scripts/gf-validate.sh
```

验证会检查：

- skills 都有标准 `name` 和 `description` frontmatter。
- `gf-init` 的 runtime script 在 `skills/gf-init/scripts/`。
- 模板在 `skills/gf-init/assets/templates/`。
- 包根没有 runtime `templates/`、`bin/gf-init.sh`、`scripts/gf-init.sh`。
- 模拟 Codex 安装时只复制 `skills/gf-*`，`gf-init` 仍能初始化模板。

## 目录结构，初始化后

```text
docs/guanfu/
  README.md
  context/
  brainstorms/
  plans/
  reviews/code/
  reviews/docs/
  adr/
  compound/
  standards/
  evolution/
```

## 可进化机制

`gf-evolve` 使用 RED → PATCH → RETEST：

```text
真实失败
  ↓
pressure scenario
  ↓
baseline failure
  ↓
skill / skill-local script / skill-local template patch
  ↓
fresh retest
  ↓
CHANGELOG / VALIDATION 更新
```

第一次失败产生信号，第二次同类失败触发进化。
