# Source Traceability Gate v1

## Goal

Readers should be able to tell where important claims came from. For technical, current, podcast, interview, report, release, named-person, or named-company essays, traceability is a publication gate.

## Public source note

When sources are public or linkable, `资料来源` should include:

| Field | Requirement |
|---|---|
| Source title | Exact title when known |
| Platform/publication | Podcast, newsletter, report site, company blog, transcript source |
| Date | Publish, recording, event, or access date when known |
| Link | Include if available; never invent |
| Locator | Timestamp, section, page, or line when useful and available |

Compact example:

```text
资料来源：
- The Pragmatic Engineer, “DHH’s new way of writing code”, 2026-04-08.
- 科技慢半拍 #133，“MCP & CLI...”，小宇宙，2026-04-22.
```

## Internal source pointer

Keep this internal for every load-bearing claim:

```text
Claim:
Source title:
Source type:
Date:
Link:
Timestamp/page/section:
Confidence: high / medium / low
Public note needed: yes/no
```

## Hard failures

- Exact number with no source pointer.
- Named person role, quote, or timeline with no source pointer.
- Public source exists but `资料来源` only says “podcast” or “interview notes”.
- Link is guessed or fabricated.
- Secondary material is written as if the author personally conducted the interview.

## Fixes

| Problem | Fix |
|---|---|
| Source note says only “访谈笔记” | Add title, platform, date, link if known |
| Number cannot be traced | Remove number or qualify it |
| Timestamp source exists | Keep timestamp internally; include publicly only if useful |
| Source is private | Say “内部材料” or omit public source note; remove unverifiable precision |
| Link unavailable | Name the source and type; do not invent a URL |
