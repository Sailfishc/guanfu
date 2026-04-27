# GuanFu v0.5 最佳实践

这份文档用于降低后续使用 GuanFu 时的脑力负担。它不是完整手册，而是操作原则和判断表。

## 1. 总原则：先建立系统状态，再让 agent 做事

GuanFu 不是“直接让 AI 写代码”的流程。它是一个把模糊输入、计划、任务、执行、审查、QA、架构和流程进化分开的工程系统。

推荐默认链路：

```text
gf-init
  -> gf-brainstorm
  -> gf-plan
  -> gf-backlog when work items matter
  -> gf-work
  -> gf-code-review
  -> gf-doc-review
  -> gf-qa when humans test behavior
  -> gf-architecture-review when structure risk appears
  -> gf-compound when a reusable lesson appears
  -> gf-evolve when the harness itself must change
```

核心判断：

```text
人负责方向、taste、架构判断、QA 体验。
Agent 负责已批准切片内的执行、验证、记录、复查。
```

## 2. 不要 GitHub-first；要 local-first backlog

`to-issues` 的精华不是 GitHub issue，而是 independently grabbable work item。

GuanFu v0.5 的默认是：

```text
docs/guanfu/backlog/WI-*.md
```

GitHub、Linear、Jira 都只是 adapter。

使用规则：

- 任何可能跨越一个 plan 的任务，都进入 backlog。
- QA bug、review repair、architecture candidate、doc fix、guardrail、evolution 都用同一套 work item schema。
- 每个 item 都要有 `mode: HITL | AFK` 和 `blocked_by`。
- `DONE` 必须有验证证据。
- 外部 issue 只写入 `backend` 和 `backend_ref`，不要删除本地 work item。

## 3. Plan 必须切 vertical slice

不要接受这种计划：

```text
S1: schema
S2: service
S3: API
S4: UI
S5: tests
```

这种是 horizontal slicing，反馈太晚。

更好的 slice 是：

```text
S1: 用户完成一个最小行为，并能在数据、接口、界面或命令、测试里验证完整路径。
```

每个 slice 至少回答：

```text
Data/state 是什么？
Interface/API/command 是什么？
UI/user-visible behavior 是什么？
Tests/verification 是什么？
```

只有一个 slice 是 `ACTIVE`。其他 slice 可以有 blockers，但不要让多个 agent 同时修改同一个 active plan，除非你已经有隔离分支和 merge 策略。

## 4. Work 可以 AFK，但 evidence 不能省

`gf-work` 的职责不是“写完就说 done”，而是：

```text
实现一个 active slice
更新 plan 和 linked work item
留下 fresh verification evidence
```

重跑 `/gf-work` 时不要相信旧状态。

必须重新看：

- active plan
- active slice
- linked work item
- completion evidence
- git status/diff
- 近期 review

规则：

```text
Action 可以幂等跳过。
Verification 不能因为旧记录而跳过。
```

## 5. QA 不修 bug；QA 保存用户体验事实

`gf-qa` 的价值是保留人类测试时的真实体验和 taste。

它应该产出：

```text
QA_BUG / QA_FOLLOWUP work item
```

而不是直接改代码。

QA item 必须有：

- What happened
- What I expected
- Steps to reproduce
- Acceptance criteria
- End-to-end path
- 是否 blocking active slice

不要在 QA issue 里主要写文件路径和行号。文件路径会变，用户体验不会。

## 6. Architecture review 不重构；只提出 candidate

`gf-architecture-review` 是预防层，不是实现层。

它要判断：

- Module 是否 shallow
- Interface 是否太复杂
- Implementation 是否被错误拆散
- Seam 是否真的需要
- Adapter 是否只是 ceremony
- Test surface 是否合理
- Locality 和 leverage 是否提升

关键测试：

```text
Deletion test:
删掉这个模块后，复杂度是消失了，还是扩散到 N 个 caller？
```

如果只是消失，它可能是 pass-through。
如果复杂度会扩散，它可能是有价值的 deep module。

Architecture review 只输出 candidates。用户或 plan 选择之后，才进入 `/gf-plan` 或 ADR。

## 7. Doc lifecycle 是防 doc rot 的核心

GuanFu 会保留很多文档，但文档越多越可能误导未来 agent。

每个 durable artifact 都应该能被分类：

```text
DRAFT
APPROVED
ACTIVE
CURRENT
COMPLETED
HISTORICAL
SUPERSEDED
ARCHIVED
STALE
RETIRED
```

未来 agent 只能把这些当作当前依据：

```text
ACTIVE / CURRENT / APPROVED
```

这些只能当证据，不是当前指令：

```text
COMPLETED / HISTORICAL / ARCHIVED
```

`SUPERSEDED` 必须有 successor。
`STALE` 必须 route 到 doc fix、plan 或 evolution。

## 8. Review 不是挑错；review 是路由器

`gf-code-review` 看到问题后要问：

```text
这是实现 bug？-> gf-work
这是缺任务？-> gf-backlog
这是架构病？-> gf-architecture-review
这是文档状态问题？-> gf-doc-review
这是重复错误？-> gf-compound
这是 skill/harness gap？-> gf-evolve
```

不要把所有问题都变成一句 review comment。

## 9. Guardrails 要 executable

危险 git 操作不能只靠 prompt 约束。

推荐项目级安装：

```bash
bash skills/gf-guardrails/scripts/install-git-guardrails.sh --project --test
```

验证：

```bash
echo '{"tool_input":{"command":"git push origin main"}}' | skills/gf-guardrails/scripts/block-dangerous-git.sh
```

期望 exit code 2，并输出 `BLOCKED`。

`gf-init --audit` 会报告 guardrails 是否安装，但不会强制安装。

## 10. Evolve 必须 RED before PATCH

改 GuanFu skill/template/router/script 之前，要先记录：

- real failure 或用户明确指出的 failure pattern
- pressure scenario
- baseline behavior
- forbidden behavior
- patch surface
- re-test result

没有 RED evidence，就不能把 evolution 标成 `APPLIED` 或 `VALIDATED`。

## 11. 快速判断表

| 输入 | 用哪个 skill | 输出 |
|---|---|---|
| 模糊想法 | `gf-brainstorm` | approved brainstorm |
| 已批准方向，要拆执行 | `gf-plan` | active plan + slices |
| 需要任务板/issue，但不想依赖 GitHub | `gf-backlog` | local work items |
| 执行一个已批准 slice | `gf-work` | code changes + fresh evidence |
| 审查实现 | `gf-code-review` | findings + routes |
| 人工测试发现问题 | `gf-qa` | behavior-first QA work items |
| 模块边界/测试边界/耦合有问题 | `gf-architecture-review` | architecture candidates |
| 文档是否会误导未来 agent | `gf-doc-review` | lifecycle + handoff review |
| 重复错误或经验需要沉淀 | `gf-compound` | reusable lesson + guardrail |
| GuanFu 流程本身要改 | `gf-evolve` | RED -> patch -> retest |
| 防危险 git 操作 | `gf-guardrails` | executable hook |

## 12. 最小日常节奏

新 feature：

```text
gf-brainstorm -> gf-plan -> gf-backlog -> gf-work -> gf-code-review -> gf-doc-review
```

人工测试：

```text
gf-qa -> gf-backlog -> gf-plan/gf-work
```

架构风险：

```text
gf-architecture-review -> gf-plan or ADR
```

流程失败：

```text
gf-compound -> gf-evolve
```

每次只问一个问题：

```text
当前问题属于 goal、plan、task state、implementation、review、QA、architecture、docs、lesson、skill evolution、safety 中哪一类？
```

分类清楚后，再调用对应 skill。
