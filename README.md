# 观复 GuanFu

> 观其所起，复其所行。  
> A Zen-inspired Engineering Harness for AI-native development.

观复是一套面向 AI 研发的 skills 与文档 harness。它把一个模糊想法，推进为清晰问题、可执行计划、可验证实现、可复用经验，再把经验反哺到下一轮 skills 迭代。

观复的目标有两个：

1. **消除 AI 协作中的存在问题**：上下文漂移、幻觉式自信、执行发散、重复犯错、无证据完成、长对话遗失关键判断。
2. **利用 AI 的杠杆**：让 AI 承担探索、对比、计划、实现、审查、复盘和知识沉淀，最终放大并挖掘 AI 的潜力。

一句话：**观复把 AI 从一次性助手，变成可积累、可校准、可复利的工程系统。**

## 为什么叫观复

**观**，是看清。

看清用户真正想解决的问题，看清代码现状，看清约束，看清方案背后的假设，看清实现之后留下的风险。

**复**，是回到。

回到计划，回到证据，回到 review，回到错误，回到可复用的经验。每一次回看，都会让下一次行动更稳。

观复的工作节奏是：

```text
一念 → 观照 → 成案 → 行作 → 回看 → 复利 → 进化
idea → brainstorm → plan → work → review → compound → evolve
```

## 价值观

### 1. 消除 AI 协作中的存在问题

AI 的问题通常出现在这些地方：

- 记忆依赖聊天上下文，换会话后关键判断丢失。
- 没有明确阶段，brainstorm、plan、work、review 混在一起。
- 过早开始写代码，用户最初的想法还没有被澄清。
- 计划缺少 slice，执行变成一次性大改。
- 完成声明缺少验证证据。
- review 只修 bug，没有提炼模式。
- 同类错误反复出现，经验没有进入下一轮流程。

观复用文档、router、taste constraints、ADR、review、compound note 和 skill evolution 来消除这些问题。

### 2. 利用 AI 的杠杆

AI 的杠杆来自可复制的工作流。

观复希望把 AI 最擅长的能力系统化：

- 扩展想法，暴露假设，提出选项。
- 读取代码，形成 code explore，减少凭空计划。
- 把目标拆成小 slice，降低实现风险。
- 执行单个 slice，并留下验证证据。
- 调用独立 agent 做 review，提升判断校准。
- 把错误写成 guardrail，让下一次少走弯路。
- 把真实使用中暴露的问题反哺到 skills 和模板。

最终目标是：**让 AI 的潜力被持续放大，让工程判断随使用持续沉淀。**

## 项目定位

观复是一个 repo-native harness。它把 AI 研发过程拆成稳定阶段，每个阶段都有对应 skill 和文档产出。

目标是让 AI 开发从“长对话里的即时发挥”，进入“有状态、有证据、有复利的工程流程”。

它适合这些场景：

- 你有一个想法，但问题边界还模糊。
- 你希望 AI 先帮你澄清问题，再开始写计划。
- 你希望计划能拆成小 slice，并能持续更新状态。
- 你希望实现过程留下验证证据，方便下一个 agent 接手。
- 你希望 review 捕捉模式和风险。
- 你希望错误进入项目记忆，形成可复用的 guardrail。
- 你希望 skills 本身持续迭代，越用越适合你的项目和品味。

## 核心原则

### 1. 文档是 AI 的工作记忆

聊天上下文会变长、会压缩、会丢失重点。项目文档提供稳定锚点。

观复要求每个阶段都产生或更新文档：brainstorm、plan、work log、review、ADR、compound note、skill evolution note。

### 2. 80% planning and review, 20% execution

执行会越来越便宜。真正决定质量的是：

- 问题有没有想清楚。
- plan 有没有切小。
- slice 有没有验收标准。
- work 有没有验证证据。
- review 有没有抓到模式。
- 错误有没有沉淀成下一次的约束。
- skills 有没有根据真实错误继续进化。

### 3. 一个阶段，一个 skill，一个产物

每个 skill 只做一类事情。

| Skill | 阶段 | 触发场景 | 主要产物 |
|---|---|---|---|
| `gf-init` | 启坛 | 初始化或刷新观复 harness | `AGENTS.md` router/taste、`docs/guanfu/`、首次 code explore |
| `gf-brainstorm` | 观照 | idea、模糊需求、问题澄清 | `docs/guanfu/brainstorms/YYYY-MM-DD-<slug>.md` |
| `gf-plan` | 成案 | 已批准的 brainstorm，需要实施计划 | `docs/guanfu/plans/YYYY-MM-DD-<slug>-plan.md`，必要时写 ADR |
| `gf-work` | 行作 | 执行 active plan slice | 更新同一个 plan 的 slice 状态与 work log |
| `gf-code-review` | 回看代码 | review 代码、测试、diff、计划一致性 | `docs/guanfu/reviews/code/YYYY-MM-DD-<slug>-code-review.md` |
| `gf-doc-review` | 回看文档 | review brainstorm、plan、ADR、review、compound 文档 | `docs/guanfu/reviews/docs/YYYY-MM-DD-<slug>-doc-review.md` |
| `gf-compound` | 复利 | 错误、反复困惑、review 模式、项目经验 | `docs/guanfu/compound/YYYY-MM-DD-<key>.md` 和 `index.md` |
| `gf-evolve` | 进化 | 优化观复 skills、模板、router、测试场景 | `docs/guanfu/evolution/YYYY-MM-DD-<change>.md`，更新 skill 包 |

### 4. Plan 和 Work 共用 living plan

Plan 阶段创建计划文档。Work 阶段继续更新同一个计划文档。

计划里必须显式记录：

```markdown
Plan Status: ACTIVE | COMPLETED | PAUSED | ABANDONED
Active Slice: <slice id or none>
```

每个 slice 都要有：

- 目标。
- 范围。
- 涉及文件。
- 验收标准。
- 测试或验证命令。
- 当前状态。
- 完成证据。

### 5. 错误进入复利系统

观复把错误视为工程资产的入口。

当某个 bug、review finding、验证失败、工具误用、架构误判反复出现时，它需要被写成 compound note，并进入 `docs/guanfu/compound/index.md`。

后续 `gf-plan`、`gf-work`、`gf-code-review`、`gf-doc-review` 会读取这些经验，减少重复试错。

### 6. Skills 是可迭代资产

Skills 会随着项目经验进化。每一次重复失败都可能说明当前 skill 还缺少一条规则、一个停止条件、一个模板字段或一个压力测试。

观复把 skill 迭代纳入正式流程：

```text
失败或发现模式
  ↓
gf-compound 记录经验
  ↓
判断 guardrail 类型
  ↓
gf-evolve 写 evolution note
  ↓
补 pressure scenario
  ↓
修改 skill / template / router
  ↓
运行验证
  ↓
更新包版本和说明
```

对应目录和文件：

```text
docs/guanfu/evolution/
tests/pressure-scenarios.md
scripts/gf-validate.sh
CHANGELOG.md
VERSION
```

## 推荐工作流

第一次在 repo 中使用：

```text
/gf-init
  ↓
/gf-brainstorm
  ↓
/gf-plan
  ↓
/gf-work
  ↓
/gf-code-review
  ↓
/gf-doc-review
  ↓
/gf-compound
  ↓
/gf-evolve, when the harness itself should improve
```

常见节奏：

```text
1. 用 gf-init 建立 AGENTS.md router、docs/guanfu/ 和 code explore。
2. 用 gf-brainstorm 把 idea 澄清成问题框架。
3. 用 gf-plan 把问题框架拆成多个 slice。
4. 用 gf-work 一次实现一个 active slice。
5. 用 gf-code-review 审查 diff、测试、实现和计划一致性。
6. 用 gf-doc-review 审查 plan、ADR、review、compound、handoff 的可接力性。
7. 用 gf-compound 把错误和模式沉淀成项目记忆。
8. 用 gf-evolve 把真实失败反哺到 skills、模板和压力测试。
```

## 目录结构

初始化后，目标项目会形成这样的文档结构：

```text
docs/guanfu/
  README.md
  context/          # repo map、code explore、测试命令、项目背景
  brainstorms/     # idea 对焦文档
  plans/           # plan + work 共用的 living plan
  reviews/
    code/          # code review / slice review
    docs/          # doc review / handoff review
  adr/             # Architecture Decision Records
  compound/        # 错误、模式、guardrail、复利笔记
  standards/       # review rubric、taste checklist、项目约束
  evolution/       # 对 GuanFu skills 的改进记录
```

包本身的结构：

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

## 安装

把 skills 复制到 agent 的 skills 目录。

Claude Code：

```bash
cp -R skills/* ~/.claude/skills/
```

Codex 风格目录：

```bash
cp -R skills/* ~/.agents/skills/
```

## 初始化一个 repo

在目标项目根目录执行：

```bash
bash scripts/gf-init.sh
```

从已安装的 skill 目录执行：

```bash
bash ~/.claude/skills/gf-init/gf-init.sh
```

或者在 agent 中运行：

```text
/gf-init
```

初始化会创建：

```text
docs/guanfu/
AGENTS.md 或 agents.md 的 GuanFu Router 区块
首次 code explore 文档
```

Router 会告诉 agent：

```text
初始化 / 建立 harness       → gf-init
idea / 模糊需求             → gf-brainstorm
已批准设计 / 计划需求       → gf-plan
开始实现                   → gf-work
审查代码                   → gf-code-review
审查文档和交接             → gf-doc-review
沉淀错误 / 经验             → gf-compound
优化 skills / 模板          → gf-evolve
```

## 使用示例

### 从一个模糊 idea 开始

```text
/gf-brainstorm
我想做一个 note / whiteboard app 的 block drag 体验优化，但我还没想清楚具体怎么拆。
```

输出：

```text
docs/guanfu/brainstorms/2026-04-25-block-drag.md
```

### 生成 implementation plan

```text
/gf-plan
基于刚才 approved brainstorm，生成可执行 plan，并拆成小 slice。
```

输出：

```text
docs/guanfu/plans/2026-04-25-block-drag-plan.md
```

### 执行一个 slice

```text
/gf-work
开始执行 active slice。
```

`gf-work` 会更新同一个 plan：

```markdown
Active Slice: S1
Plan Status: ACTIVE

## Work Log
- 2026-04-25: started S1
- Verification: npm test ...
```

### Code review

```text
/gf-code-review
review 当前 diff 和对应 plan。
```

输出：

```text
docs/guanfu/reviews/code/2026-04-25-block-drag-code-review.md
```

### Doc review

```text
/gf-doc-review
检查当前 plan、ADR 和 review 文档能不能支持下一个 agent 接着做。
```

输出：

```text
docs/guanfu/reviews/docs/2026-04-25-block-drag-doc-review.md
```

### 复利沉淀

```text
/gf-compound
把这次 review 中发现的 selection 状态同步问题沉淀成 compound note。
```

输出：

```text
docs/guanfu/compound/2026-04-25-selection-state-sync.md
```

### Skill 迭代

```text
/gf-evolve
把 gf-work 经常忘记读取 compound note 的问题写成 evolution，并补一个 pressure scenario。
```

输出：

```text
docs/guanfu/evolution/2026-04-25-read-compound-before-work.md
```

## 文档产物之间的关系

```text
gf-init
  建立 router、目录、模板、code explore
      ↓
gf-brainstorm
  提供问题框架、约束、成功标准
      ↓
gf-plan
  提供 slice、验收标准、验证命令、ADR 入口
      ↓
gf-work
  记录实现过程、状态变更、验证证据
      ↓
gf-code-review
  检查计划一致性、代码质量、测试、风险
      ↓
gf-doc-review
  检查文档是否足够支持 agent 接力
      ↓
gf-compound
  把错误、模式、项目判断写入长期记忆
      ↓
gf-evolve
  把重复失败转化为 GuanFu 自身的规则升级
```

## AGENTS.md 的角色

`AGENTS.md` 是项目里的 router 和 taste 文件。

它负责告诉 agent：

- 当前项目采用 GuanFu 流程。
- 什么时候使用哪个 skill。
- 每个阶段的停止条件。
- 项目的质量偏好。
- review 的基本标准。
- 文档产物的默认位置。
- skills 迭代的处理方式。

一个好的 `AGENTS.md` 可以让新 agent 进入项目后快速恢复工作方式。

## ADR 的角色

ADR 用来记录架构性决定。

触发条件包括：

- 数据模型变化。
- 跨模块边界调整。
- 引入新依赖。
- 改变持久化方式。
- 改变 agent 调度方式。
- 影响未来扩展路径的技术选择。

ADR 要写清楚：背景、选择、备选方案、后果、回滚方式。

## Compound Note 的角色

Compound note 是观复的复利核心。

一条好的 compound note 应该回答：

```text
发生了什么？
为什么会发生？
下次怎么提前发现？
下次 agent 应该遵守什么规则？
哪些测试、脚本、review checklist、模板或 skill evolution 可以固化这个规则？
```

经验写进 compound note 后，后续 GuanFu skills 会把它作为项目记忆读取。

## Skill Evolution 的角色

Skill evolution 用来改进 GuanFu 自身。

当一个问题来自流程缺口，比如 plan 经常缺 verification command、work 经常忘记更新 slice 状态、review 经常漏看 ADR，处理方式是：

```text
compound note 记录经验
evolution note 写出修改提案
pressure scenario 捕捉失败模式
修改 SKILL.md / template / router
validation 验证包仍然一致
```

这让 GuanFu 随项目使用持续变强。

## 验证

包内提供基础验证脚本：

```bash
bash scripts/gf-validate.sh
```

它检查：

- 每个 skill 都有 `SKILL.md`。
- frontmatter 包含 `name` 和 `description`。
- skill 名称使用 `gf-*`。
- README、router、测试场景使用 `docs/guanfu/`。
- `gf-init.sh` 通过 `bash -n`。
- `gf-init.sh --dry-run` 可执行。

压力测试场景在：

```text
tests/pressure-scenarios.md
```

这些场景用于测试 agent 在压力下会不会跳过 brainstorm、plan、verification、review、compound 或 evolve。

## 适合谁

观复适合这些开发者和团队：

- 高频使用 AI coding agent 的个人开发者。
- 正在搭建 repo-native harness 的团队。
- 希望把 plan、review、ADR、错误复盘标准化的工程团队。
- 需要让多个 agent 接力完成复杂工作的项目。
- 希望把 AI 协作过程沉淀为长期工程资产的人。
- 希望 skills 持续吸收项目经验的人。

## 设计取舍

观复偏向清晰、可追踪、可复用。

它会让开发过程多出一些文档动作，这些动作服务于后续 agent 的稳定执行：

- brainstorm 减少问题误解。
- plan 减少实现发散。
- slice 减少一次性大改。
- code review 减少隐性风险。
- doc review 降低接力成本。
- compound 减少重复犯错。
- evolve 让流程本身持续升级。

这套流程适合中长期项目、复杂功能、多人或多 agent 接力协作。

## 当前状态

当前版本包含：

```text
8 个 skills
初始化脚本
验证脚本
AGENTS router 模板
brainstorm / ADR / plan / review / doc-review / compound / evolution 模板
pressure scenarios
VERSION
CHANGELOG
```

## Roadmap

后续可以继续增强：

- review dashboard。
- plan slice 状态检查脚本。
- compound note 检索脚本。
- evolution 自动应用脚本。
- 跨项目经验库。
- subagent pressure test 自动化。
- skill versioning 和 changelog。
- GuanFu package release workflow。

## 一句话

观复是一套让 AI 研发形成复利的工程 harness：先观照，再行动，后复盘，让每一次错误都成为下一次判断力的一部分。
