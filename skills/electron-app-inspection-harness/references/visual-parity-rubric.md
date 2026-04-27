# Visual Parity Rubric

Use this rubric to grade Sumink-like visual reconstruction.

## Levels

| Level | Meaning | Evidence |
|---|---|---|
| 0 | no comparable UI | no screenshot or route |
| 1 | rough layout | static screen visible, major structure exists |
| 2 | token-aligned | typography, color, spacing tokens extracted and applied |
| 3 | state-aligned | default/hover/focus/active states captured and implemented |
| 4 | interaction-aligned | typing, selection, scroll, resize, and backlinks behavior stable |
| 5 | regression-ready | screenshot diff and interaction tests run per slice |

## Static screen thresholds

These thresholds are guidance, not absolute pass/fail gates:

| Metric | Target |
|---|---:|
| Window/shell geometry | within 8 px for major regions |
| Sidebar width | within 6 px |
| Topbar height | within 4 px |
| Main content x/y offset | within 12 px |
| Font size | within 1 px |
| Line height | within 2 px |
| Icon/text alignment | within 3 px |
| Screenshot mismatch | trending down across iterations |

## Gap table format

| Region | Reference | Current | Gap | Likely fix | Slice |
|---|---:|---:|---|---|---|
| sidebar width | | | | token/layout | slice-01 |
| title font size | | | | typography token | slice-01 |
| hover background | | | | state style | slice-02 |
| cursor stability | | | | editor logic | slice-04 |
