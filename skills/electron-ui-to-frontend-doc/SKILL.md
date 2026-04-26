---
name: electron-ui-to-frontend-doc
version: 2.1.0
description: Use when documenting a specified macOS Electron app, app.asar archive, screenshots, DOM/CSS, or UI component as a Codex-ready frontend implementation handoff with app-scoped folders, component specs, design tokens, evidence, and verification.
---

# Electron UI to Frontend Doc

## Purpose

Create an app-scoped frontend documentation pack that Codex can implement from directly.

Canonical outputs:

```text
electron-ui-doc/<app-slug>/handoff/frontend-implementation.md
electron-ui-doc/<app-slug>/handoff/codex-implementation-prompt.md
electron-ui-doc/<app-slug>/manifest.json
```

Figma, HTML prototypes, and code starters are optional adapters. The documentation pack is the source of truth.

## Hard gates

### Gate 1: explicit app identity

The user must specify the target app before inspection, extraction, capture, or document writing.

Accepted app identity inputs:

```text
- /Applications/Example.app
- Example
- app_name=Example plus app_asar=/path/to/app.asar
```

If the prompt only includes a screenshot, a generic `app.asar`, or wording like “this Electron app”, stop and ask one question:

```text
Which Electron app should I inspect?
A) .app path, for example /Applications/Example.app
B) exact installed app name, for example Example
C) archive-only mode: app name + app.asar path
```

If an `app.asar` path is supplied without app name, inspect metadata only as a candidate and ask the user to confirm the app name for folder naming.

### Gate 2: app-scoped output folder

Every output path includes the app slug.

Default:

```text
electron-ui-doc/<app-slug>/
```

User-supplied output root still receives an app slug:

```text
<output-root>/<app-slug>/
```

Examples:

```text
electron-ui-doc/sumink/
electron-ui-doc/heptabase/
electron-ui-doc/my-electron-app/
```

### Gate 3: Codex-ready contract

The pack must contain a pasteable Codex prompt and machine-readable metadata.

Required Codex files:

```text
manifest.json
handoff/codex-implementation-prompt.md
handoff/task-contract.json
handoff/acceptance-checklist.md
```

The Codex prompt points to the app-scoped files and tells Codex the implementation order, evidence rules, acceptance criteria, and verification path.

### Gate 4: evidence provenance

Every implementation claim needs provenance:

```text
source | runtime DOM | computed CSS | accessibility tree | screenshot | inference
```

Screenshot-derived values are approximate. Unobserved interaction states are `not observed`.

## Guardrails

Use this for apps the user is authorized to inspect, migrate, document, or redesign. Respect licensing, DRM, authentication, encryption, sandboxing, and access controls. Keep proprietary assets separate and record license/provenance.

If the user asks for production code, rebuild from documented behavior and component specifications. Keep generated code semantic. Avoid reproducing minified DOM or copying proprietary assets into a shipped rebuild.

## Required deliverable

Minimum output:

```text
electron-ui-doc/<app-slug>/
  .app-context.json
  manifest.json
  README.md
  00-environment-report.md
  01-route-decision.md
  02-app-map.md
  03-screen-inventory.md
  04-user-flows.md
  05-design-tokens.json
  06-assets-inventory.md
  components/
    <component-name>.md
    <component-name>.spec.json
  captures/
    screenshots/
    dom/
    accessibility/
  handoff/
    frontend-implementation.md
    codex-implementation-prompt.md
    task-contract.json
    acceptance-checklist.md
    verification-report.md
```

Optional adapters:

```text
  figma/figma-model.json
  figma/import-notes.md
  prototype/index.html
  code-starter/tokens.css
  code-starter/components/
  code-starter/stories/
  code-starter/tests/
```

## Workflow checklist

```text
Electron UI Doc Progress:
- [ ] Resolve exact app identity
- [ ] Create app-scoped output root
- [ ] Confirm authorization when needed
- [ ] Detect local environment and available routes
- [ ] Select route and record confidence
- [ ] Extract/static-map app.asar when available
- [ ] Attempt runtime capture through CDP when approved and available
- [ ] Capture screenshots/accessibility fallback when runtime capture is unavailable
- [ ] Build screen inventory and user flows
- [ ] Pick high-value component(s) for deep documentation
- [ ] Extract tokens with provenance
- [ ] Write component specs and JSON specs
- [ ] Write frontend handoff, Codex prompt, task contract, acceptance checklist
- [ ] Generate optional Figma/prototype/code adapters when supported
- [ ] Validate output pack structure
- [ ] Self-review unsupported claims and missing blockers
```

## Step 1: resolve app identity and output root

Run from the skill directory.

`.app` path:

```bash
bash scripts/check-electron-ui-env.sh \
  --app "/Applications/Example.app" \
  --out-root electron-ui-doc
```

Installed app name:

```bash
bash scripts/check-electron-ui-env.sh \
  --app "Example" \
  --out-root electron-ui-doc
```

Archive-only:

```bash
bash scripts/check-electron-ui-env.sh \
  --app-name "Example" \
  --asar "./evidence/app.asar" \
  --out-root electron-ui-doc
```

Use printed variables as canonical:

```text
APP_NAME=<display name>
APP_SLUG=<slug>
APP_PATH=<path or empty>
APP_ASAR=<path or empty>
OUTPUT_DIR=<output-root>/<app-slug>
CONTEXT=<output-root>/<app-slug>/.app-context.json
```

If the script prints `NEEDS_APP_IDENTITY`, `NEEDS_APP_NAME_FOR_ASAR`, `APP_NOT_FOUND`, or `AMBIGUOUS_APP`, ask the user for the required app identity and stop.

## Step 2: confirm scope and target

Required values after app identity:

```text
scope: whole app, one screen, or one component
target output: docs, Codex handoff, Figma adapter, prototype, code starter, or all possible outputs
target stack: required only for code starter
```

Defaults:

```text
scope: whole app inventory + one high-value component deep dive
target output: frontend documentation pack + Codex handoff
target stack: infer from source and mark as inferred
```

Ask one question only when the missing value changes execution materially.

## Step 3: choose route

Use the best route the machine supports. Figma is optional.

| Route | Conditions | Confidence | Primary output |
|---|---|---:|---|
| A. Source + runtime | `app.asar` or source maps available, and CDP connects | High | component docs, tokens, Codex handoff, optional code starter |
| B. Runtime DOM | CDP connects, source unavailable or minified | Medium-high | DOM-derived docs, tokens, Codex handoff, prototype |
| C. Static source only | explicit app archive extractable, app cannot be inspected live | Medium | app map, inferred component specs, asset inventory, Codex handoff with gaps |
| D. Screenshot + accessibility | explicit app identity, screenshots, and accessibility data available | Medium-low | visual/UX docs with explicit unknowns |
| E. Screenshot only | explicit app identity plus images only | Low | visual inventory, approximate layout, capture tasks |

Write `$OUTPUT_DIR/01-route-decision.md`:

```text
Selected route: A/B/C/D/E
Resolved app: <app name>
Doc root: <OUTPUT_DIR>
Why: available evidence
Unavailable capabilities: missing inputs/tools
Confidence: high/medium/low
Fallback plan: next best route
```

## Step 4: static app map

If `APP_ASAR` exists:

```bash
bash scripts/extract-asar.sh "$OUTPUT_DIR" "$APP_ASAR"
```

Then inspect under `$OUTPUT_DIR/evidence/extracted`:

```bash
find "$OUTPUT_DIR/evidence/extracted" -maxdepth 4 \( -name "package.json" -o -name "*.map" -o -name "*.css" -o -name "*.svg" -o -name "*.woff*" -o -name "*.ttf" \)
rg -n "react|vue|svelte|solid|tailwind|emotion|styled-components|vite|webpack|rollup|electron" "$OUTPUT_DIR/evidence/extracted" || true
rg -n "Button|Card|Sidebar|Modal|Menu|Search|Canvas|Grid|Dialog|Toast|Popover|Editor" "$OUTPUT_DIR/evidence/extracted" || true
```

Write `$OUTPUT_DIR/02-app-map.md` with app name/version/bundle id, entry points, renderer bundles, framework evidence, source map status, styling system, assets, candidate screens/components, and unknowns.

## Step 5: runtime capture through CDP

When launch/debug is allowed:

```bash
open -a "$APP_NAME" --args --remote-debugging-port=9222
curl -s http://127.0.0.1:9222/json/list | jq .
```

If CDP and local Playwright are available:

```bash
node scripts/cdp-capture.js http://127.0.0.1:9222 "$OUTPUT_DIR/captures"
```

If Playwright is missing, ask before local installation:

```text
Playwright is missing. Install it locally in this workspace for automated DOM/CSS capture? Command: npm i -D playwright
```

Capture screenshot, DOM snapshot, computed styles, accessibility snapshot, CSS variables, viewport size, and device pixel ratio.

## Step 6: fallback capture

If runtime capture is unavailable:

```bash
mkdir -p "$OUTPUT_DIR/captures/screenshots"
screencapture -i "$OUTPUT_DIR/captures/screenshots/manual-selection.png"
```

Record Accessibility Inspector findings in:

```text
$OUTPUT_DIR/captures/accessibility/manual-accessibility-notes.md
```

Inline chat images are fallback evidence. Mark them `not reproducible from filesystem`.

## Step 7: screens, flows, components

Write `$OUTPUT_DIR/03-screen-inventory.md` with screen purpose, entry trigger, regions, observed states, missing states, evidence, and confidence.

Write `$OUTPUT_DIR/04-user-flows.md` with start state, action sequence, UI feedback, data/state change, success/error/empty state, keyboard path, evidence, and confidence.

Pick one high-value component by default. Produce both:

```text
$OUTPUT_DIR/components/<component-name>.md
$OUTPUT_DIR/components/<component-name>.spec.json
```

Each component spec covers purpose, anatomy, props/data, visual layout, states, interactions, accessibility, tokens, assets, edge cases, Codex implementation contract, acceptance criteria, evidence, and confidence.

Minimum state matrix:

```text
default, hover, active, focus, selected, disabled, loading, error, empty, long text, missing asset
```

## Step 8: tokens and assets

Write `$OUTPUT_DIR/05-design-tokens.json` using `templates/design-tokens.schema.json` as shape. Every token value includes `value`, `usage`, `provenance`, and optional `evidencePath`.

Write `$OUTPUT_DIR/06-assets-inventory.md` with asset path, type, observed usage, license/provenance notes, and rebuild recommendation.

## Step 9: Codex-ready handoff

Write:

```text
$OUTPUT_DIR/handoff/frontend-implementation.md
$OUTPUT_DIR/handoff/codex-implementation-prompt.md
$OUTPUT_DIR/handoff/task-contract.json
$OUTPUT_DIR/handoff/acceptance-checklist.md
```

You can create the Codex files from templates with:

```bash
bash scripts/create-codex-handoff.sh "$OUTPUT_DIR"
```

`codex-implementation-prompt.md` must be directly pasteable into Codex and include exact doc root, app name, target stack, implementation order, required inputs, required outputs, acceptance criteria, visual verification, and unknown handling.

`task-contract.json` is machine-readable task data. Each work item includes:

```json
{
  "id": "component.note-editor",
  "title": "Implement NoteEditor",
  "priority": 1,
  "inputs": ["components/note-editor.md", "components/note-editor.spec.json", "05-design-tokens.json"],
  "outputs": ["src/components/note-editor/NoteEditor.tsx"],
  "acceptance": ["state stories exist", "keyboard path documented"]
}
```

## Step 10: optional adapters

Generate adapters after the documentation pack exists.

| Adapter | Condition | Output |
|---|---|---|
| HTML prototype | enough layout/token evidence exists | `prototype/index.html` |
| Figma | Figma/MCP/plugin available | `figma/figma-model.json`, `figma/import-notes.md` |
| code starter | component specs and tokens are adequate | `code-starter/` with stories/tests |

Call generated code `code-starter` until verification passes.

## Step 11: validation and final report

Run:

```bash
bash scripts/validate-doc-pack.sh "$OUTPUT_DIR"
```

Write `$OUTPUT_DIR/handoff/verification-report.md` with required files, route evidence, component state coverage, token provenance coverage, Codex readiness, visual checks, gaps, and next actions.

Validation requirements:

```text
- manifest.json exists and includes app.name and app.slug
- output path includes app slug
- Codex implementation prompt exists
- task contract JSON exists
- at least one component spec exists
- unknowns are explicit
- no fabricated app identity appears
```

## Common mistakes

| Mistake | Fix |
|---|---|
| Starting when the target app is missing | Stop at Gate 1 and ask for app path, app name, or app.asar plus app display name |
| Writing to generic `electron-ui-doc/` | Always write to `electron-ui-doc/<app-folder-name>/` |
| Inferring app identity from `app.asar` and proceeding silently | Treat metadata as candidate and ask for confirmation |
| Creating human-only prose | Add `manifest.json`, `handoff/codex-implementation-prompt.md`, and `handoff/task-contract.json` |
| Treating Figma as the center | Start with route detection and frontend doc pack |
| Treating screenshots as exact truth | Use DOM/CSS/source first; screenshots validate pixels |
| Claiming exact tokens from image sampling | Mark screenshot-derived values approximate |
| Skipping states | Build a state matrix and mark missing states |
| Copying minified DOM into code | Rebuild semantic components from documented anatomy |
| Ignoring scale/DPI | Record viewport, window size, and device pixel ratio |
| Hiding uncertainty | Label confidence per screen/component/token |
| Installing global tooling | Ask before installing; prefer local or manual fallback |

## Final response format

```text
STATUS: DONE | DONE_WITH_CONCERNS | NEEDS_CONTEXT | BLOCKED
APP: <confirmed app name>
DOC_ROOT: <path>
ROUTE: <A/B/C/D/E>
CANONICAL_HANDOFF: <path>/handoff/frontend-implementation.md
CODEX_PROMPT: <path>/handoff/codex-implementation-prompt.md
TASK_CONTRACT: <path>/handoff/task-contract.json
VALIDATION: pass/fail and key gaps
```
