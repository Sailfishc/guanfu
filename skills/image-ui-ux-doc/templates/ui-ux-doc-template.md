# UI/UX Document: [Screen or Flow Name]

## Source Image Summary

- Source image(s): [filename, screenshot, uploaded image, or description]
- Platform: [desktop web, mobile app, tablet, unknown]
- Confidence: [High / Medium / Low]
- Confirmed by user: [yes/no, include date or message if relevant]

## Product Context

- Intended user: [confirmed user or unknown]
- User job to be done: [what the user is trying to accomplish]
- Screen purpose: [why this screen exists]
- Entry point: [how user reaches this screen]
- Exit point: [where user goes next]

## Visible Facts

List only what is directly visible in the image.

- [Visible element]
- [Visible layout region]
- [Visible text or CTA]

## Information Architecture

Describe the hierarchy from most important to least important.

1. Primary region: [what anchors the screen]
2. Secondary region: [supporting controls or content]
3. Tertiary region: [metadata, helper text, secondary actions]

## Layout Specification

### Screen: [Name]

- Container: [viewport, page shell, modal, drawer, card, panel]
- Navigation: [sidebar, top nav, tabs, breadcrumbs, none]
- Main content: [cards, table, form, list, canvas, editor]
- Actions: [primary, secondary, destructive, disabled]
- Density: [compact, standard, spacious]
- Alignment: [left, centered, grid, split pane]

## Component Inventory

| Component | Purpose | Visible state | Notes |
| --- | --- | --- | --- |
| [Component] | [Why it exists] | [default/selected/disabled/etc.] | [Details] |

## User Flow

```text
[Entry] -> [Main action] -> [Feedback state] -> [Next screen or completion]
```

## Interaction Requirements

| Element | Trigger | Expected behavior | Feedback |
| --- | --- | --- | --- |
| [Button/link/control] | [click/tap/hover/input] | [result] | [visual/system response] |

## State Model

Include each state even if it is not visible in the source image.

- Default: [normal loaded state]
- Loading: [skeleton, spinner, disabled content]
- Empty: [zero data state and CTA]
- Error: [message, retry, fallback]
- Success: [confirmation or updated UI]
- Disabled: [why unavailable]
- Partial data: [what appears when some content is missing]
- Permission denied: [if relevant]

## Content and Microcopy

- Primary heading: [text]
- Primary CTA: [text]
- Helper copy: [text]
- Error copy: [recommended text]
- Empty-state copy: [recommended text]

## Visual System Notes

- Typography: [observed type scale or unknown]
- Color roles: [background, text, accent, status, destructive]
- Spacing: [compact/standard/spacious, observed rhythm]
- Borders/elevation: [cards, panels, shadows, dividers]
- Iconography: [observed icons and meanings]

## Accessibility Requirements

- Keyboard path: [tab order, focus handling]
- Screen reader labels: [controls that need labels]
- Contrast risks: [visible or likely]
- Hit targets: [especially mobile]
- Motion: [avoid or define reduced-motion handling]

## Responsive Behavior

- Desktop: [layout]
- Tablet: [layout]
- Mobile: [layout]
- Overflow handling: [long names, long lists, small viewport]

## Frontend Sketch

- Sketch generated: [yes/no]
- Sketch file: [path or link]
- Purpose: [what the sketch is meant to validate]

## Assumptions

- [Assumption and why it was made]

## Open Questions

- [Question that still needs product/design input]

## Risks

- [UX risk]
- [Implementation risk]
- [Ambiguity risk]

## Acceptance Criteria

- [ ] [User can complete primary task]
- [ ] [All major states are covered]
- [ ] [Keyboard and screen reader behavior is defined]
- [ ] [Responsive behavior is defined]
- [ ] [Unknowns are resolved or explicitly listed]
