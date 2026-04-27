# Output Contract

## Directory layout

```text
analysis/<app-slug>/
  00-meta/
    app-context.json
    manifest.json
    capability-ledger.json
    route-decision.md
    environment-report.md
  01-runtime/
    cdp-scan.json
    pages.json
    screenshots/
    dom/
    accessibility/
    console-network/
    performance/
  02-static-asar/
    extracted/
    static-map.md
    static-map.json
    ipc-map.md
    assets-inventory.md
  03-mcp/
    mcp-config.md
    chrome-devtools-summary.md
    playwright-summary.md
  04-os-automation/
    os-automation-notes.md
    screenshots/
  05-ui-ux-report/
    inspection-report.md
    design-tokens.json
    component-inventory.md
    interaction-matrix.md
    verification-report.md
  06-codex-tasks/
    codex-implementation-prompt.md
    task-contract.json
    acceptance-checklist.md
    inspection-kanban.md
  07-parity/
    references/
    state-captures/
    measurements/
    diffs/
    parity-matrix.md
    implementation-slices.json
    codex-parity-prompt.md
```

## `capability-ledger.json`

```json
{
  "schemaVersion": "4.0.0",
  "app": { "name": "Example", "slug": "example", "path": "/Applications/Example.app" },
  "capabilities": [
    {
      "name": "chrome-devtools-mcp",
      "status": "available|installed|configured|blocked|declined|not-needed",
      "value": "high",
      "cost": "low|medium|high|user-gated",
      "evidence": "03-mcp/mcp-config.md",
      "notes": "..."
    }
  ],
  "downgradeJustification": []
}
```

## `task-contract.json`

```json
{
  "schemaVersion": "4.0.0",
  "goal": "Implement the documented UI from evidence-backed specs.",
  "readOrder": [
    "00-meta/manifest.json",
    "05-ui-ux-report/inspection-report.md",
    "05-ui-ux-report/design-tokens.json",
    "05-ui-ux-report/component-inventory.md",
    "05-ui-ux-report/interaction-matrix.md"
  ],
  "slices": [
    {
      "id": "slice-01",
      "title": "Render CanvasCard default state with tokens",
      "inputs": ["design-tokens.json", "component-inventory.md"],
      "deliverables": ["component", "story", "visual check"],
      "acceptance": ["default screenshot comparable", "keyboard focus visible"],
      "provenanceRequired": true
    }
  ],
  "unknowns": [
    { "state": "dragging", "reason": "not observed", "followUp": "capture with Playwright MCP" }
  ]
}
```


## `07-parity/implementation-slices.json`

```json
{
  "schemaVersion": "4.1.0",
  "profile": "sumink-note-editor",
  "slices": [
    {
      "id": "slice-01-note-detail-static-shell",
      "goal": "Render the note detail static shell from evidence.",
      "atoms": ["window shell", "sidebar", "topbar", "content column", "typography", "backlinks"],
      "inputs": ["design-tokens.json", "parity-matrix.md", "screenshots"],
      "acceptance": ["visible route exists", "tokens are centralized", "screenshot gap table is updated"]
    }
  ]
}
```

## Parity evidence confidence

| Evidence | Confidence | Use |
|---|---|---|
| computed CSS + DOM rect | high | typography, spacing, state geometry |
| accessibility tree | high | roles, names, keyboard affordances |
| screenshot diff | medium-high | visual similarity and regressions |
| screenshot-only measurement | medium | approximate visual reconstruction |
| inference | low | TODO or follow-up capture |
