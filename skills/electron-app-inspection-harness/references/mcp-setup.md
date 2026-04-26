# MCP Setup

Use MCP when the agent can benefit from live tool access. MCP is especially valuable for runtime UI diagnosis because it lets the agent inspect the app rather than only read static artifacts.

## Codex MCP

Check current MCP servers:

```bash
codex mcp list
```

Add Chrome DevTools MCP:

```bash
codex mcp add chrome-devtools -- npx chrome-devtools-mcp@latest
```

Add Playwright MCP:

```bash
codex mcp add playwright -- npx @playwright/mcp@latest
```

If an Electron app exposes CDP at `127.0.0.1:9222`, configure Chrome DevTools MCP to connect to it:

```toml
[mcp_servers.chrome-devtools]
command = "npx"
args = ["-y", "chrome-devtools-mcp@latest", "--browser-url=http://127.0.0.1:9222"]
```

Project-scoped config goes in `.codex/config.toml` for trusted projects. User-scoped config goes in `~/.codex/config.toml`.

## Current-session limitation

Some agent clients load MCP config at session start. When a server is configured during the current task and tools do not appear immediately, use local CDP scripts for this run and note that MCP will be available after restarting the agent.

## MCP artifacts

Write MCP outputs to:

```text
03-mcp/chrome-devtools-summary.md
03-mcp/playwright-summary.md
03-mcp/mcp-config.md
```

Minimum Chrome DevTools summary:

```text
connected target
document title and URL
console errors/warnings
network failures
DOM/CSS findings
screenshots captured
performance trace summary when requested
```

Minimum Playwright summary:

```text
accessibility snapshot
roles and names for target controls
flows executed
screenshots captured
state matrix observed
candidate selectors/test actions
```
