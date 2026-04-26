# Frontend Implementation Handoff: {AppName}

## Scope

- App: {AppName}
- App slug: {app-slug}
- Doc root: {doc-root}
- Target screen/component: {scope}
- Selected route: {A/B/C/D/E}
- Confidence: {high/medium/low}
- Date: {date}

## Codex entry point

Primary Codex prompt:

```text
handoff/codex-implementation-prompt.md
```

Machine-readable task contract:

```text
handoff/task-contract.json
```

## Evidence summary

| Evidence type | Available? | Path | Notes | Confidence |
|---|---:|---|---|---:|
| app identity |  | `.app-context.json` |  |  |
| app.asar/source |  | `evidence/extracted/` |  |  |
| source maps |  |  |  |  |
| runtime DOM |  | `captures/dom/` |  |  |
| computed CSS |  | `captures/dom/runtime-dom-styles.json` |  |  |
| screenshots |  | `captures/screenshots/` |  |  |
| accessibility tree |  | `captures/accessibility/` |  |  |

## What to build

Describe the frontend surface in product terms.

## Build order

| Priority | Component/task | Inputs | Output target | Reason |
|---:|---|---|---|---|
| 1 | Tokens | `05-design-tokens.json` | token CSS/theme module | shared styling base |
| 2 |  |  |  |  |

## Screen map

| Screen | Purpose | Components | States | Evidence | Confidence |
|---|---|---|---|---|---:|

## Component map

| Component | Responsibility | Inputs | Outputs/events | Spec | JSON spec |
|---|---|---|---|---|---|

## Data model

| Entity | Fields | Used by components | Evidence | Confidence |
|---|---|---|---|---:|

## Design tokens

Reference `05-design-tokens.json`.

Summarize token groups:

- colors:
- typography:
- spacing:
- radii:
- shadows:
- motion:

## Assets

Reference `06-assets-inventory.md`.

## Layout system

- Grid/flex model:
- Breakpoints/window sizes:
- Density rules:
- Scroll behavior:
- Layering:

## Interaction model

| Action | UI feedback | State/data change | Accessibility requirement | Evidence | Confidence |
|---|---|---|---|---|---:|

## Accessibility requirements

- Keyboard navigation:
- Focus management:
- Roles/names:
- Reduced motion:
- Contrast concerns:
- Screen reader gaps:

## Edge cases

| Case | Expected UI behavior | Evidence/confidence | Implementation note |
|---|---|---|---|

## Implementation recommendation

- Suggested stack:
- Component boundaries:
- Styling approach:
- State management:
- Testing approach:

## Test plan

- [ ] Component state stories/examples
- [ ] Visual comparison against captures
- [ ] Keyboard navigation
- [ ] Empty/loading/error states
- [ ] Long text and missing asset cases
- [ ] Accessibility smoke test

## Confirmed facts vs inferences

### Confirmed

- 

### Inferred

- 

### Unknown / follow-up capture tasks

- 
