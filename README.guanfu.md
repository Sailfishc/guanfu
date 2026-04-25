# 观复 GuanFu

> 先观其意，再复其行。  
> A Zen-inspired Compound Engineering Harness for AI-native development.

观复是一套面向 AI 研发的复利工程流程与 skills 集合。它帮助人和 AI 把一个模糊想法，逐步锻造成清晰问题、可执行计划、可验证实现、可复用经验。

它服务一个简单判断：AI 的稳定性来自文档化的上下文。想法写下来，计划写下来，决策写下来，验证写下来，错误也写下来。下一轮 AI 才能站在上一轮的结果上继续工作。

## 为什么叫观复

**观**，是看清。

看清用户真正想解决的问题，看清代码现状，看清约束，看清方案背后的假设，看清实现之后留下的风险。

**复**，是回到。

回到计划，回到证据，回到 review，回到错误，回到可复用的经验。每一次回看，都会让下一次行动更稳。

观复的工作节奏可以概括为：

```text
一念 → 观照 → 成案 → 行作 → 回看 → 复利
idea → brainstorm → plan → work → review → compound
```

## 项目定位

观复是一个 repo-native harness。它把 AI 研发过程拆成几个稳定阶段，每个阶段都有对应 skill 和文档产出。

目标是让 AI 开发从“长对话里的即时发挥”，进入“有状态、有证据、有复利的工程流程”。

它适合这些场景：

- 你有一个想法，但问题边界还模糊。
- 你希望 AI 先帮你澄清问题，再开始写计划。
- 你希望计划能拆成小 slice，并能持续更新状态。
- 你希望实现过程留下验证证据，方便继续交给下一个 agent。
- 你希望 review 捕捉模式和风险，而非只改表面 bug。
- 你希望错误进入项目记忆，形成可复用的 guardrail。

## 核心原则

### 1. 文档是 AI 的工作记忆

聊天上下文会变长、会压缩、会丢失重点。项目文档提供稳定锚点。

观复要求每个阶段都产生或更新文档：brainstorm、plan、work log、review、ADR、compound note。

### 2. 80% planning and review, 20% execution

执行本身会越来越便宜。真正决定质量的是：

- 问题有没有想清楚
- plan 有没有切小
- slice 有没有验收标准
- review 有没有抓到模式
- 错误有没有沉淀成下一次的约束

### 3. 一个阶段，一个 skill，一个产物

每个 skill 只做一类事情。

`ce-brainstorm` 负责澄清想法。  
`ce-plan` 负责形成可执行计划。  
`ce-work` 负责执行一个 active slice。  
`ce-review` 负责审查实现和文档。  
`ce-compound` 负责沉淀错误和经验。

这种分工让 AI 在每一步都知道当前该做什么、该产出什么、该停在哪里。

### 4. Plan 和 Work 共用 living plan

Plan 阶段创建计划文档。Work 阶段继续更新同一个计划文档。

计划里必须显式记录：

```markdown
Status: ACTIVE | COMPLETED | PAUSED | ABANDONED
Active Slice: <slice id or none>
```

每个 slice 都要有：

- 目标
- 范围
- 涉及文件
- 验收标准
- 测试或验证命令
- 当前状态
- 完成证据

### 5. 错误要进入复利系统

观复把错误视为工程资产的入口。

当某个 bug、review finding、验证失败、工具误用、架构误判反复出现时，它需要被写成 compound note，并进入 `docs/ce/compound/index.md`。

下一次 agent 执行前，会先读取这些经验，减少重复试错。

## Skills

| Skill | 阶段 | 触发场景 | 主要产物 |
|---|---|---|---|
| `ce-brainstorm` | 观照 | idea、模糊需求、问题澄清 | `docs/ce/brainstorms/YYYY-MM-DD-<slug>.md` |
| `ce-plan` | 成案 | 已批准的 brainstorm/spec，需要实施计划 | `docs/ce/plans/YYYY-MM-DD-<slug>-plan.md`，必要时写 ADR |
| `ce-work` | 行作 | 执行 active plan slice | 更新同一个 plan 的 slice 状态与 work log |
| `ce-review` | 回看 | review 代码、文档、ADR、slice 完成度 | `docs/ce/reviews/YYYY-MM-DD-<slug>-review.md` |
| `ce-compound` | 复利 | 错误、反复困惑、review 模式、项目经验 | `docs/ce/compound/YYYY-MM-DD-<key>.md` 和 `index.md` |

## 推荐工作流

```text
/ce-brainstorm
  ↓
/ce-plan
  ↓
/ce-work
  ↓
/ce-review
  ↓
/ce-compound
```

实际使用时常见节奏：

```text
1. 用 ce-brainstorm 把 idea 澄清成问题框架
2. 用 ce-plan 把问题框架拆成多个 slice
3. 用 ce-work 一次实现一个 active slice
4. 用 ce-review 审查 diff、测试、文档和计划一致性
5. 用 ce-compound 把错误和模式沉淀成项目记忆
```

## 目录结构

初始化后，项目会形成这样的文档结构：

```text
docs/ce/
  README.md
  context/        # repo map、code explore、测试命令、项目背景
  brainstorms/   # idea 对焦文档
  plans/          # plan + work 共用的 living plan
  reviews/        # code review / doc review / slice review
  adr/            # Architecture Decision Records
  compound/       # 错误、模式、guardrail、复利笔记
  standards/      # review rubric、taste checklist、项目约束
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
bash scripts/ce-init.sh
```

或者从已安装的 skill 目录执行：

```bash
bash ~/.claude/skills/ce-init/ce-init.sh
```

初始化会创建：

```text
docs/ce/
AGENTS.md 或 agents.md 的 Compound Engineering Router 区块
```

Router 会告诉 agent：

```text
idea / 模糊需求        → ce-brainstorm
已批准设计 / 计划需求  → ce-plan
开始实现              → ce-work
审查实现 / 文档        → ce-review
沉淀错误 / 经验        → ce-compound
```

## 使用示例

### 从一个模糊 idea 开始

```text
/ce-brainstorm
我想做一个 note / whiteboard app 的 block drag 体验优化，但我还没想清楚具体怎么拆。
```

输出：

```text
docs/ce/brainstorms/2026-04-25-block-drag.md
```

### 生成 implementation plan

```text
/ce-plan
基于刚才 approved brainstorm，生成可执行 plan，并拆成小 slice。
```

输出：

```text
docs/ce/plans/2026-04-25-block-drag-plan.md
```

### 执行一个 slice

```text
/ce-work
开始执行 active slice。
```

`ce-work` 会更新同一个 plan：

```markdown
Active Slice: S1
Status: ACTIVE

## Work Log
- 2026-04-25: started S1
- Verification: npm test ...
```

### Review

```text
/ce-review
review 当前 diff 和对应 plan。
```

输出：

```text
docs/ce/reviews/2026-04-25-block-drag-review.md
```

### 复利沉淀

```text
/ce-compound
把这次 review 中发现的 selection 状态同步问题沉淀成 compound note。
```

输出：

```text
docs/ce/compound/2026-04-25-selection-state-sync.md
```

## 文档产物之间的关系

```text
brainstorm
  提供问题框架、约束、成功标准
      ↓
plan
  提供 slice、验收标准、验证命令、ADR 入口
      ↓
work log
  记录实现过程、状态变更、验证证据
      ↓
review
  检查计划一致性、代码质量、测试、文档、风险
      ↓
compound
  把错误、模式、项目判断写入长期记忆
```

## AGENTS.md 的角色

`AGENTS.md` 是项目里的 router 和 taste 文件。

它负责告诉 agent：

- 当前项目采用观复流程
- 什么时候使用哪个 skill
- 每个阶段的停止条件
- 项目的质量偏好
- review 的基本标准
- 文档产物的默认位置

一个好的 `AGENTS.md` 可以让新 agent 进入项目后快速恢复工作方式。

## ADR 的角色

ADR 用来记录架构性决定。

触发条件包括：

- 数据模型变化
- 跨模块边界调整
- 引入新依赖
- 改变持久化方式
- 改变 agent 调度方式
- 影响未来扩展路径的技术选择

ADR 要写清楚：背景、选择、备选方案、后果、回滚方式。

## Compound Note 的角色

Compound note 是观复的复利核心。

一条好的 compound note 应该回答：

```text
发生了什么？
为什么会发生？
下次怎么提前发现？
下次 agent 应该遵守什么规则？
哪些测试、脚本、review checklist 可以固化这个规则？
```

经验写进 compound note 后，后续 `ce-work` 和 `ce-review` 会把它作为项目记忆读取。

## 适合谁

观复适合这些开发者和团队：

- 高频使用 AI coding agent 的个人开发者
- 正在搭建 repo-native harness 的团队
- 希望把 plan、review、ADR、错误复盘标准化的工程团队
- 需要让多个 agent 接力完成复杂工作的项目
- 希望把 AI 协作过程沉淀为长期工程资产的人

## 设计取舍

观复偏向清晰、可追踪、可复用。

它会让开发过程多出一些文档动作，但这些动作服务于后续 agent 的稳定执行：

- brainstorm 减少问题误解
- plan 减少实现发散
- slice 减少一次性大改
- review 减少隐性风险
- compound 减少重复犯错

这套流程适合中长期项目、复杂功能、多人或多 agent 接力协作。

## 当前状态

当前版本包含核心 skills、初始化脚本、模板和压力测试场景。

```text
skills/
  ce-brainstorm/
  ce-plan/
  ce-work/
  ce-review/
  ce-compound/

templates/
  plan.md
  review.md
  adr.md
  compound-note.md
  AGENTS.compound-engineering.md

scripts/
  ce-init.sh

tests/
  pressure-scenarios.md
```

## Roadmap

后续可以继续增强：

- 把命令前缀从 `ce-*` 统一升级为 `gf-*`
- 增加 `gf-init` skill 包装初始化脚本
- 增加独立 `gf-doc-review`
- 增加 review dashboard
- 增加 plan slice 状态检查脚本
- 增加 compound note 检索脚本
- 增加跨项目经验库
- 增加 subagent pressure test 自动化

## 一句话

观复是一套让 AI 研发形成复利的工程 harness：先观照，再行动，后复盘，让每一次错误都成为下一次判断力的一部分。
