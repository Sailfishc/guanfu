# Component: {Name}

## App context

- App: {AppName}
- App slug: {app-slug}
- Doc root: {doc-root}
- Used in screens:
- Evidence:
- Confidence:

## Summary

- Purpose:
- Responsibility:
- Implementation priority:

## Anatomy

| Part | Description | Evidence | Confidence |
|---|---|---|---:|
| Root |  |  |  |
| Header/title |  |  |  |
| Body/content |  |  |  |
| Actions |  |  |  |

## Props / data model

| Prop | Type | Required | Description | Source | Confidence |
|---|---|---:|---|---|---:|

## Visual layout

- Size:
- Spacing:
- Alignment:
- Responsive behavior:
- Z-index/layering:

## States

| State | Observed? | Visual change | Behavior | Evidence | Confidence |
|---|---:|---|---|---|---:|
| default |  |  |  |  |  |
| hover |  |  |  |  |  |
| active/pressed |  |  |  |  |  |
| focus |  |  |  |  |  |
| selected |  |  |  |  |  |
| disabled |  |  |  |  |  |
| loading |  |  |  |  |  |
| error |  |  |  |  |  |
| empty |  |  |  |  |  |
| long text |  |  |  |  |  |
| missing asset |  |  |  |  |  |

## Interactions

| Trigger | Result | Feedback | Data/state change | Evidence | Confidence |
|---|---|---|---|---|---:|
| click |  |  |  |  |  |
| double click |  |  |  |  |  |
| right click |  |  |  |  |  |
| keyboard enter |  |  |  |  |  |
| keyboard tab |  |  |  |  |  |
| escape |  |  |  |  |  |

## Accessibility

- Role:
- Accessible name:
- Keyboard path:
- Focus indicator:
- Announcements:
- Gaps:

## Tokens used

| Token | Value | Usage | Provenance |
|---|---|---|---|

## Assets used

| Asset | Path | License/provenance | Notes |
|---|---|---|---|

## Edge cases

- Empty data:
- Long labels:
- Missing thumbnail/icon/image:
- Narrow window:
- Dark/light mode:
- Slow/loading data:

## Codex implementation contract

Suggested files:

```text
src/components/{component-folder}/{ComponentName}.tsx
src/components/{component-folder}/{ComponentName}.stories.tsx
src/components/{component-folder}/{ComponentName}.visual.spec.ts
```

Implementation requirements:

- Use documented props and data model.
- Use tokens from `05-design-tokens.json`.
- Cover observed states with stories/examples.
- Preserve unknown states as TODOs.
- Verify against captures when available.

## Acceptance criteria

- [ ] Default state matches capture at documented viewport
- [ ] State stories/examples exist
- [ ] Keyboard path works or pending gap is documented
- [ ] Tokens come from `05-design-tokens.json`
- [ ] Unknowns are marked
