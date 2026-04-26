# Agent Workflow

This skill should make the agent better at inspection, not bury it in raw data.

## Smart-zone discipline

Keep the orchestrator focused on decisions and summaries.

```text
orchestrator context: manifests, small summaries, component specs
raw files: bundles, traces, screenshots, full DOM dumps, logs
subagents/separate runs: heavy grep, static bundle mapping, long trace analysis
```

## Grill before heavy work

Ask only the questions that change the route:

```text
- Which app exactly?
- Is this your app, and may I add temporary debug instrumentation?
- Do you allow local npm tooling install under the analysis folder?
- May I quit/relaunch the app with a debug port?
- Which screen/component/flow matters most?
```

## Inspection task board

Create independent tasks under `06-codex-tasks/inspection-kanban.md`.

Good tasks:

```text
- Attach CDP and capture default screen DOM/CSS/screenshot.
- Extract asar and map IPC/menu/shortcut/style token strings.
- Use Playwright MCP to execute Search flow and capture accessibility snapshots.
- Analyze CanvasCard hover/focus/selected states and update component contract.
```

Poor tasks:

```text
- Analyze everything.
- Build all docs.
- Read all bundles.
- Recreate the app.
```

## Vertical-slice handoff

When generating implementation tasks for Codex, split by visible user value:

```text
slice 1: design tokens + one component default state + screenshot comparison
slice 2: same component interactions + accessibility + state stories
slice 3: layout shell + one navigable flow + visual QA
```

## Reviewer pass

Before final handoff, run a separate review pass:

```text
- Does every claim have provenance?
- Are unknowns explicit?
- Did we attempt recoverable high-value tools?
- Are implementation tasks vertical slices?
- Can Codex start from the task contract without reading raw bundles?
```
