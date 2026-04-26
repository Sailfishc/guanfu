---
name: electron-app-inspection-harness
version: 4.0.0
description: Use when inspecting a specified Electron app, app.asar archive, running renderer, UI flow, or component with AI agents; especially when MCP, CDP, Playwright, Puppeteer, asar static analysis, OS automation, debug bridge instrumentation, UI/UX findings, or Codex-ready implementation tasks are involved.
---

# Electron App Inspection Harness

## Purpose

Build a multi-channel inspection harness for a specified Electron app, then produce evidence-backed UI/UX findings and Codex-ready frontend implementation tasks.

Primary output:

```text
analysis/<app-slug>/
  00-meta/
  01-runtime/
  02-static-asar/
  03-mcp/
  04-os-automation/
  05-ui-ux-report/
  06-codex-tasks/
```

This skill is agent-first. Use Codex/Claude/MCP capabilities to inspect the app. Use bundled scripts for deterministic capture, validation, and repeatability.

## Core principle

Recover high-value observation channels before choosing a weaker path.

If CDP, Playwright, Puppeteer, asar extraction, or MCP is missing, treat that as a fixable capability gap. Install low-cost tooling locally under `analysis/<app-slug>/.tooling/` or configure MCP after user approval. Downgrade only after recovery is attempted, declined, or blocked by app/OS/security constraints.

## Hard gates

### Gate 1: exact app identity

Do not inspect until the user specifies one of:

```text
- /Applications/Example.app
- exact installed app name, for example Example
- archive-only mode: app_name=Example plus app_asar=/path/to/app.asar
```

If the user provides only a screenshot, a generic `app.asar`, or says “this Electron app”, ask one question and stop:

```text
Which Electron app should I inspect?
A) .app path, for example /Applications/Example.app
B) exact installed app name, for example Example
C) archive-only mode: app name + app.asar path
```

### Gate 2: app-scoped output

Every artifact goes under:

```text
analysis/<app-slug>/
```

A user-supplied output root still gets the app slug:

```text
<output-root>/<app-slug>/
```

### Gate 3: authorization and mode

Classify the inspection mode before running tools:

```text
own-dev-app        source exists, user allows temporary debug instrumentation
own-packaged-app   user owns app or has source but wants packaged inspection
third-party-app    user is authorized to inspect but cannot modify source
archive-only       app.asar only, no runtime access
screenshot-only    visual evidence only after better routes are blocked
```

For `own-dev-app`, ask whether temporary debug bridge instrumentation is allowed before editing source. For `third-party-app`, do not modify app code. For all modes, respect auth, DRM, encryption, sandboxing, licensing, and app terms.

### Gate 4: no silent downgrade

Before using screenshot-only or static-only routes, record capability recovery attempts in:

```text
00-meta/capability-ledger.json
00-meta/route-decision.md
05-ui-ux-report/verification-report.md
```

A downgrade is valid only when the ledger shows attempted, declined, or blocked recovery.

### Gate 5: keep the agent in the smart zone

Raw bundles, traces, screenshots, and full DOM dumps stay in files. The orchestrator reads summaries, manifests, and small evidence slices. Use subagents or separate Codex runs for heavy search and return concise findings.

## Capability ladder

Use the best available channel for the app mode. Earlier channels have priority.

| Priority | Channel | Best for | Recovery action |
|---:|---|---|---|
| 1 | App debug bridge | internal editor/whiteboard state, render counts, app-specific state | own app only, ask before adding temporary instrumentation |
| 2 | Chrome DevTools MCP | agent runtime diagnosis, console, network, performance, DOM/CSS | configure MCP or use existing tools |
| 3 | Playwright MCP | agent-controlled UI exploration, accessibility snapshots, flows | configure MCP or use existing tools |
| 4 | Raw CDP / Puppeteer | batch JSON capture, DOM/CSS/AX/screenshots/network | install local `chrome-remote-interface` + `puppeteer-core` |
| 5 | Playwright Electron | repeatable Electron launch, interaction tests, traces | install local `playwright`, use dev command when available |
| 6 | Electron debug port | renderer attach and main-process inspector | launch with `--remote-debugging-port`, optionally `--inspect` |
| 7 | asar static analysis | components, IPC, shortcuts, styles, tokens, routes | install local `@electron/asar` and extract |
| 8 | OS automation | menus, dialogs, windows, focus, global shortcuts | ask for permissions; use AppleScript/JXA/screencapture |
| 9 | screenshots | visual approximation and manual QA | final fallback plus provenance labels |

Read `references/capability-ladder.md` for details.

## Workflow

```text
Inspection Progress:
- [ ] Resolve app identity and mode
- [ ] Initialize app-scoped output root
- [ ] Build capability ledger
- [ ] Ask only for material permissions or destructive/restart actions
- [ ] Configure or detect MCP servers when useful
- [ ] Install local low-cost capture packages when useful
- [ ] Launch or attach CDP before runtime downgrade
- [ ] Run MCP/agent runtime exploration when tools are available
- [ ] Run raw CDP/Puppeteer capture for structured artifacts
- [ ] Extract and map app.asar when available
- [ ] Use OS automation for DOM-external interactions when needed
- [ ] Produce UI/UX findings with provenance
- [ ] Produce Codex task contract and implementation prompt
- [ ] Validate the pack
```

## Step 1: initialize

Run from this skill directory.

Packaged app path:

```bash
bash scripts/init-inspection.sh \
  --app "/Applications/Example.app" \
  --out-root analysis \
  --mode third-party-app
```

Installed app name:

```bash
bash scripts/init-inspection.sh --app "Example" --out-root analysis
```

Archive-only:

```bash
bash scripts/init-inspection.sh \
  --app-name "Example" \
  --asar ./app.asar \
  --out-root analysis \
  --mode archive-only
```

Use the printed `DOC_ROOT`, `APP_NAME`, `APP_SLUG`, `APP_PATH`, and `APP_ASAR` as canonical values.

## Step 2: choose the agent route

If running inside Codex, prefer these agent abilities:

```bash
codex mcp list 2>/dev/null || true
```

If Chrome DevTools MCP or Playwright MCP would materially improve the task, configure them:

```bash
bash scripts/configure-codex-mcp.sh --doc-root "$DOC_ROOT" --add chrome-devtools
bash scripts/configure-codex-mcp.sh --doc-root "$DOC_ROOT" --add playwright
```

If the current session cannot see newly configured MCP tools, continue with local CDP/Puppeteer scripts and record that MCP is configured for the next run.

## Step 3: install low-cost local tooling

Install local tooling under the doc root. Do not mutate the user project or global packages.

```bash
bash scripts/bootstrap-inspection-tooling.sh "$DOC_ROOT" --profile runtime
```

Profiles:

```text
minimal: @electron/asar
runtime: @electron/asar, chrome-remote-interface, puppeteer-core, playwright package without browser downloads
visual:  runtime + pixelmatch + pngjs
full:    visual + optional browser install when explicitly requested
```

## Step 4: runtime attach

Scan existing CDP endpoints:

```bash
bash scripts/scan-cdp.sh "$DOC_ROOT" --ports 9222-9232,9322,9422,9522
```

Launch with CDP when allowed:

```bash
bash scripts/launch-electron-cdp.sh "$DOC_ROOT" \
  --app-path "$APP_PATH" \
  --port 9222 \
  --strategy open-new-instance
```

Capture via CDP:

```bash
node scripts/capture-cdp.js \
  --doc-root "$DOC_ROOT" \
  --port 9222 \
  --label default
```

## Step 5: MCP exploration

If MCP tools are available in the agent UI, use them before writing findings.

Chrome DevTools MCP tasks:

```text
- list/select page attached to Electron renderer
- collect console errors and warnings
- inspect DOM/CSS for target component
- capture screenshot
- run performance trace for jank/latency path
- inspect network requests if the app uses remote APIs
```

Playwright MCP tasks:

```text
- get accessibility snapshot
- click through the target flow
- capture hover/focus/active/selected states
- record selectors or semantic roles
- generate a replayable Playwright test draft
```

Write MCP outputs to:

```text
03-mcp/chrome-devtools-summary.md
03-mcp/playwright-summary.md
```

## Step 6: static map

Extract and map `app.asar` when available:

```bash
bash scripts/extract-asar.sh "$DOC_ROOT" "$APP_ASAR"
bash scripts/static-map.sh "$DOC_ROOT"
```

The static map must include:

```text
main/preload/renderer entry points
framework and bundler hints
IPC channels
BrowserWindow creation
menus and shortcuts
routes and command palette strings
CSS variables, tokens, Tailwind/styled-system hints
assets and fonts
storage hints: IndexedDB, SQLite, localStorage, files
source maps and sourceMappingURL references
```

## Step 7: OS automation only for gaps

Use OS automation when the target behavior lives outside the renderer:

```text
native menus
system dialogs
window focus and resizing
macOS titlebar/traffic lights
global shortcuts
tray/menu bar items
```

Ask for macOS Screen Recording or Accessibility permissions when needed. Record denied permissions in `00-meta/capability-ledger.json`.

## Step 8: write the inspection report and Codex handoff

Create a starter handoff from artifacts when useful:

```bash
node scripts/synthesize-handoff.js "$DOC_ROOT"
```

Then refine the generated files with real findings. Minimum final files:

```text
05-ui-ux-report/inspection-report.md
05-ui-ux-report/design-tokens.json
05-ui-ux-report/component-inventory.md
05-ui-ux-report/interaction-matrix.md
05-ui-ux-report/verification-report.md
06-codex-tasks/codex-implementation-prompt.md
06-codex-tasks/task-contract.json
06-codex-tasks/acceptance-checklist.md
```

For frontend rebuilds, the Codex task contract must be vertical-slice based:

```text
slice 1: tokens + one visible component + visual check
slice 2: interaction state + accessibility + visual check
slice 3: layout shell + flow check
```

Avoid horizontal tasks such as “build all CSS”, “build all components”, “then test”.

## Step 9: validate

```bash
node scripts/synthesize-handoff.js "$DOC_ROOT"
bash scripts/validate-pack.sh "$DOC_ROOT"
```

The validation report must be linked in `05-ui-ux-report/verification-report.md`.

## Output standards

Every claim includes provenance:

```text
runtime-cdp | chrome-devtools-mcp | playwright-mcp | playwright-electron | static-asar | os-automation | screenshot | inference
```

Unobserved states stay explicit:

```text
not observed: hover, focus, active, drag, empty, error, loading
```

If the pack is used for code generation, tell Codex to read this order:

```text
00-meta/manifest.json
00-meta/capability-ledger.json
05-ui-ux-report/inspection-report.md
05-ui-ux-report/design-tokens.json
05-ui-ux-report/component-inventory.md
05-ui-ux-report/interaction-matrix.md
06-codex-tasks/task-contract.json
06-codex-tasks/acceptance-checklist.md
```

## Common failure modes

| Failure | Correct response |
|---|---|
| User forgot app name/path | Ask for exact app identity. Write nothing. |
| CDP unavailable | Scan ports, launch with debug port, ask before quit/relaunch, then capture. |
| Playwright missing | Install local package under `.tooling`, skip browsers unless needed. |
| MCP not configured | Configure MCP if Codex/Claude supports it; use local scripts for current run if restart is needed. |
| asar extraction fails | Record command, stderr, unpacked assets, and static limits. |
| Only screenshot exists | Mark route as low confidence and create follow-up capture tasks. |
| Huge bundle overwhelms context | Use static-map summaries and targeted grep slices. |
| Own app lacks internal state | Offer temporary debug bridge patch behind user approval. |

## References

- `references/capability-ladder.md`
- `references/mcp-setup.md`
- `references/agent-workflow.md`
- `references/output-contract.md`
- `templates/debug-bridge.ts`
