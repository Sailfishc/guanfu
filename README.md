# 观复 GuanFu

> 观其所起，复其所行。  
> A Zen-inspired, evolvable engineering harness for AI-native development.

观复是一套面向 AI 研发的 skills 与文档 harness。它把一个模糊想法推进为清晰问题、可执行计划、可验证实现、事后 review、复利经验，再把真实失败反哺到下一轮 skills 迭代。

观复的核心宗旨：**可迭代，可进化，第一次失败可容忍，重复失败必须进入系统记忆。**

## 价值观

### 1. 消除 AI 协作中的存在问题

AI 协作的典型问题包括：上下文漂移、浅层追问、过早执行、计划发散、无证据完成、review 只看表面、同类错误反复出现。观复用阶段、文档、router、taste constraints、ADR、review、compound note 和 skill evolution 来减少这些失败。

### 2. 利用 AI 的杠杆

AI 的杠杆来自可复制流程。观复让 AI 承担探索、对比、计划、实现、审查、复盘、知识沉淀和流程进化。最终目标是：**放大并挖掘 AI 的潜力，让工程判断随使用持续沉淀。**

## Harness 运行契约

观复践行一个明确的 harness 原则：

```text
事前多讨论：gf-brainstorm 和 gf-plan 是 human loop。
事中坚决执行：gf-work 之后自动串行推进，中间记录异常并继续。
事后再对齐：gf-code-review、gf-doc-review、gf-compound、gf-evolve 吸收结果和 taste。
```

### Human loop 阶段

`gf-brainstorm` 和 `gf-plan` 负责对齐目标、约束、品味和方案。它们可以多轮 AskUserQuestion。

- `gf-brainstorm`：澄清 idea，追问到覆盖度足够，产出 APPROVED brainstorm。
- `gf-plan`：把 APPROVED brainstorm 转成 living plan，拆 slice，写 ADR，取得用户批准。

### Automated execution 阶段

计划批准后，默认进入自动执行链：

```text
gf-work -> gf-code-review -> gf-doc-review -> gf-compound -> gf-evolve when needed
```

从 `gf-work` 开始，agent 遇到问题时优先记录证据、继续到 review、把偏差写入 compound，再用 evolve 修正流程。中途人工打断会削弱 harness 的复利效果。

### Failure budget

观复允许第一次失败，因为真实失败提供最好的流程信号。

| 事件 | 系统反应 |
|---|---|
| 第一次失败 | 记录 evidence，进入 review 和 compound。 |
| 同类失败再次出现 | 视为 harness gap，进入 gf-evolve。 |
| 失败来自模糊目标 | 回到 brainstorm 或 plan 的人机对齐阶段。 |
| 失败来自执行偏差 | 通过 review、compound、skill patch 改进下一轮。 |

## 阶段与 skills

| Skill | 阶段 | 人工参与 | 主要产物 |
|---|---|---|---|
| `gf-init` | 启坛 | 自动 | `AGENTS.md` router/taste、`docs/guanfu/`、code explore |
| `gf-brainstorm` | 观照 | Human loop | `docs/guanfu/brainstorms/YYYY-MM-DD-HHMM-<slug>.md` |
| `gf-plan` | 成案 | Human loop | `docs/guanfu/plans/YYYY-MM-DD-HHMM-<slug>-plan.md`，必要时写 ADR |
| `gf-work` | 行作 | 自动 | 更新同一个 plan 的 slice 状态、work log、verification evidence |
| `gf-code-review` | 回看代码 | 自动 | `docs/guanfu/reviews/code/YYYY-MM-DD-HHMM-<slug>-code-review.md` |
| `gf-doc-review` | 回看文档 | 自动 | `docs/guanfu/reviews/docs/YYYY-MM-DD-HHMM-<slug>-doc-review.md` |
| `gf-compound` | 复利 | 自动 | `docs/guanfu/compound/YYYY-MM-DD-HHMM-<key>.md` 和 `index.md` |
| `gf-evolve` | 进化 | 自动 | `docs/guanfu/evolution/YYYY-MM-DD-HHMM-<skill>-<key>.md`，更新 skill/template/test |

## 目录结构

初始化后目标项目会形成：

```text
docs/guanfu/
  README.md
  context/
  brainstorms/
  plans/
  reviews/
    code/
    docs/
  adr/
  compound/
  standards/
  evolution/
```

## 安装

Claude Code：

```bash
cp -R skills/gf-* ~/.claude/skills/
```

Codex / agents：

```bash
cp -R skills/gf-* ~/.agents/skills/
```

初始化仓库：

```bash
bash ~/.claude/skills/gf-init/gf-init.sh
# 或
bash scripts/gf-init.sh
```

验证包：

```bash
bash scripts/gf-validate.sh
```

## 推荐工作流

```text
/gf-init
/gf-brainstorm
/gf-plan
/gf-work
/gf-code-review
/gf-doc-review
/gf-compound
/gf-evolve, when the harness itself should improve
```

### 执行链规则

计划批准后，执行链自动推进：

1. `gf-work` 实现 active slice，记录验证证据。
2. `gf-code-review` 审代码、测试、diff、计划一致性和 freshness。
3. `gf-doc-review` 审文档链和 fresh-agent handoff。
4. `gf-compound` 把错误、偏差、taste 和模式变成 guardrail。
5. `gf-evolve` 在 compound 指向 skill/template/router gap 时更新 harness。

## 文档血缘

每个 artifact 都要能回答：

```text
Source -> Current status -> Evidence -> Next action -> Related lessons
```

推荐字段：

```markdown
Source:
Previous Artifact:
Next Artifact:
Related Plan:
Related Review:
Related Compound Notes:
Supersedes:
Status:
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
skill/template/router patch
  ↓
fresh retest
  ↓
CHANGELOG / VALIDATION 更新
```

这让 GuanFu 随真实使用而变强。第一次失败产生信号，第二次同类失败触发进化。

## 包内容

```text
skills/
  gf-init/
  gf-brainstorm/
  gf-plan/
  gf-work/
  gf-code-review/
  gf-doc-review/
  gf-compound/
  gf-evolve/
scripts/
  gf-init.sh
  gf-validate.sh
templates/
  AGENTS.guanfu.md
  brainstorm.md
  plan.md
  review.md
  doc-review.md
  adr.md
  compound-note.md
  skill-evolution.md
tests/
  pressure-scenarios.md
```
