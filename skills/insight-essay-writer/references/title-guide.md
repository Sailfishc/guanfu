# Title Guide v7

## Goal

A title should make the reader understand the article's promise and want to continue. It should sound like a public article title, not a research note.

## Generate four title families

### 1. Problem titles

Use when the article starts from reader pain or a common failure.

```text
AI 编程最容易卡住的地方，正在从代码转向反馈
为什么你的 Agent 看起来很忙，最后还是没跑通
工程团队被 AI 加速以后，真正堵住的是哪一步
```

### 2. Mechanism titles

Use when the article has a clear hidden mechanism.

```text
Anthropic 的速度来自发布系统
AI 产品团队的速度，来自一套低摩擦发布通道
Claude Code 这类产品，会把 PM 推向回路设计
```

### 3. Decision titles

Use when readers need to choose a model, workflow, team design, or product strategy.

```text
什么任务该交给 Agent，什么必须留给工程师
当代码可以隔夜写完，团队该先补哪条反馈链
AI 产品要不要保留旧功能，先看它还在服务谁
```

### 4. Reader-gain titles

Use when the article offers a practical lens.

```text
功能越来越容易写，PM 越要会判断什么值得写
当工程开始当天反馈，产品判断该怎么跟上
模型越强，越要重新估价那些旧功能
```

## Primary source title distance

Do not translate or lightly paraphrase a strong primary source title. If the source title is `DHH's new way of writing code`, reject titles like `DHH 的新写法`.

Prefer:

```text
代码变快以后，工程师的判断半径变大了
Agent 先出手以后，工程师要重新设计工作现场
AI 写得越快，工程师越要知道什么该留下
```

## Hard anti-patterns

Avoid titles built from internal scaffolding:

```text
旧价格表 / 新价格表
成本结构分析
论点锦标赛
Source Map
Quality Gate
Roadmap
XX 的新价格表
DHH 的新写法
X 的新方式
从 A 到 B：某某访谈的启示
```

These can be internal analysis tools. Keep them out of H1 titles and usually out of H2 section headings.

## Anti-rut rules

- Avoid using the same title skeleton in consecutive drafts.
- Avoid preserving a source title skeleton, especially named actor + novelty phrase.
- If a prior draft used `当 X，Y 该 Z`, generate at least 15 candidates outside that pattern.
- If a reference essay starts with a role and a future, choose a problem, decision, or mechanism title.
- If the article has one strong sentence in the body, test it as a title.

## Title scoring

Score each candidate 1-5:

| Gate | Question |
|---|---|
| Directness | Does the reader know the point? |
| Curiosity | Does it create a reason to read? |
| Naturalness | Does it sound publishable? |
| Specificity | Does it name a role, product, domain, or decision? |
| Reader gain | Does it imply what the reader will get? |
| Originality | Does it differ from polished references and prior drafts? |

Choose the highest-scoring title. If two titles tie, pick the one with lower framework language and lower overlap with the reference.
