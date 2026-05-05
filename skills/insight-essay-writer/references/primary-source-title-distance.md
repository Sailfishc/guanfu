# Primary Source Title Distance Gate v1

## Goal

A source title can already contain the most tempting frame. The article title must not become a translation or light paraphrase of that title.

## Run when

- A source has a strong title.
- A source title names a person, tool, trend, or “new way”.
- The draft title preserves the source actor and novelty structure.
- The input includes a polished reference or public podcast/newsletter title.

## Reject patterns

| Source title pattern | Weak article title pattern |
|---|---|
| `DHH's new way of writing code` | `DHH 的新写法` |
| `The new way to build X` | `X 的新方式` |
| `How Agent teams organize` | `Agent 团队如何组织` |
| `MCP vs CLI` | `MCP 和 CLI 的区别` |

Reject when the candidate keeps:

1. Same named actor.
2. Same novelty phrase: `新写法`, `新方式`, `new way`, `未来`, `方法`.
3. Same comparison pair without a new reader decision.
4. Same metaphor as the source title.

## Replacement moves

| Move | Example |
|---|---|
| Name the changed bottleneck | `代码变快以后，工程师的判断半径变大了` |
| Name the reader decision | `什么任务该先交给 Agent，什么必须由工程师收口` |
| Name the mechanism | `Agent 时代，工作现场本身成了工程能力` |
| Name the failure mode | `AI 写得越快，团队越容易漏掉审查边界` |

## Internal check

```text
Primary source title:
Source title skeleton:
Candidate H1:
Candidate skeleton:
Overlap: actor / verb / metaphor / novelty phrase
Article-owned mechanism named? yes/no
Reader decision named? yes/no
Pass / reject:
```

If the title is rejected, generate 15 new candidates without the source actor unless the actor is essential to reader value.
