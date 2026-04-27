---
name: gf-guardrails
description: Use when installing, auditing, or testing executable safety hooks for GuanFu, especially to block dangerous git commands such as push, reset --hard, clean -f, branch -D, checkout ., or restore .
---

# gf-guardrails

## Purpose

Install executable safety guardrails for agent-run shell commands.

Prompt rules are not enough for destructive operations. This skill provides a Claude Code `PreToolUse` hook that blocks dangerous git commands before they execute.

## Bundled scripts

```text
skills/gf-guardrails/scripts/block-dangerous-git.sh
skills/gf-guardrails/scripts/install-git-guardrails.sh
```

## What is blocked

- `git push` including force variants
- `git reset --hard`
- `git clean -f`, `git clean -fd`, and force variants
- `git branch -D`
- `git checkout .` and `git checkout -- .`
- `git restore .` and `git restore -- .`

## Install

Ask scope only when the user did not specify one:

```text
A) Project only: .claude/settings.json
B) Global: ~/.claude/settings.json
```

Then run one:

```bash
bash skills/gf-guardrails/scripts/install-git-guardrails.sh --project
bash skills/gf-guardrails/scripts/install-git-guardrails.sh --global
```

The installer copies the hook, makes it executable, and merges a `PreToolUse` Bash hook without overwriting existing settings.

## Audit

```bash
bash skills/gf-guardrails/scripts/install-git-guardrails.sh --audit --project
bash skills/gf-guardrails/scripts/install-git-guardrails.sh --audit --global
```

`/gf-init --audit` also reports optional guardrail installation status. Missing guardrails are not a harness setup failure, but they are a safety gap.

## Verify block behavior

```bash
echo '{"tool_input":{"command":"git push origin main"}}' | skills/gf-guardrails/scripts/block-dangerous-git.sh
```

Expected:

```text
exit code: 2
stderr contains: BLOCKED
```

## Customization

Only customize after explaining the risk. If the user wants to allow a blocked command, prefer a one-time human-run terminal command rather than weakening the hook.

## Output

```text
STATUS: INSTALLED | AUDITED | TESTED | BLOCKED | DONE_WITH_CONCERNS
SCOPE: project | global
HOOK: <path>
SETTINGS: <path>
TEST: PASS | FAIL | SKIPPED
NEXT: /gf-init --audit | none
```
