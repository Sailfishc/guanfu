# Capability Ladder

Use this ladder before downgrading. The objective is maximum useful evidence with reasonable setup cost.

## Modes

| Mode | Meaning | Best first channel |
|---|---|---|
| own-dev-app | user can run or edit source | debug bridge + Playwright Electron + MCP |
| own-packaged-app | user owns packaged app | CDP + MCP + asar |
| third-party-app | authorized inspection, no source modification | CDP + MCP + asar + OS automation |
| archive-only | `app.asar` only | static asar + bundle search |
| screenshot-only | screenshots only | visual report with low-confidence claims |

## Tool installability

| Tier | Capability | Install action | Notes |
|---|---|---|---|
| T0 | `node`, `npm`, `python3`, `curl`, `plutil`, `screencapture`, `lsof` | detect | foundational |
| T1 | `@electron/asar` | local `.tooling` install | high static-analysis value |
| T1 | `chrome-remote-interface` | local `.tooling` install | raw CDP capture |
| T1 | `puppeteer-core` | local `.tooling` install | lightweight attach to running CDP |
| T1 | `playwright` package | local `.tooling` install with browser download skipped | Electron/CDP API and test capture |
| T1 | Chrome DevTools MCP | `codex mcp add chrome-devtools -- npx chrome-devtools-mcp@latest` | high agent runtime value |
| T1 | Playwright MCP | `codex mcp add playwright -- npx @playwright/mcp@latest` | high agent UI exploration value |
| T2 | Playwright browser binaries | explicit browser install | only for prototype rendering/tests |
| T2 | Homebrew `rg`, `jq` | optional | use fallback first |
| T3 | Figma, plugins, MCP | optional adapter | never required for core inspect |
| T3 | Xcode / Accessibility Inspector | optional | OS-level detail, high install cost |
| T4 | macOS Screen Recording / Accessibility | user gated | ask only when needed |
| T4 | app accepts debug flags | app specific | diagnose, record, use alternative evidence |

## Recovery rules

1. Local npm tooling is cheaper than accepting a bad evidence route.
2. MCP setup is worth it when the agent needs runtime diagnosis or UI exploration.
3. Browser downloads are useful for generated web prototypes/tests, not required for CDP attach.
4. OS permissions are useful for menus/dialogs/focus, but need clear user approval.
5. Figma is an adapter. It is never a prerequisite for inspection.

## Downgrade thresholds

A weaker route is allowed only when one of these is true:

```text
- the user declines install, restart, or permissions
- the app refuses remote debugging or uses single-instance behavior that blocks attach
- Node/npm is unavailable and the user declines installing it
- the app is archive-only
- auth/DRM/security restrictions block runtime evidence
```

Record the exact condition in `00-meta/capability-ledger.json`.
