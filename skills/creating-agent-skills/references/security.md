# Security Review for Skills

Skills are executable instruction packages. Review them like code.

## Script safety checklist

- Scripts default to local filesystem work only
- Network access requires an explicit flag and README mention
- Destructive writes require `--force` or a clearly named output directory
- Install commands avoid global packages
- Secrets are never read, printed, copied, or sent
- Tool calls and MCP dependencies are named explicitly
- Generated archives exclude `.env`, credentials, caches, and node_modules

## Instruction safety checklist

- The skill explains its intended scope
- The description cannot be abused to trigger on unrelated tasks
- References are one level deep and easy to audit
- Scripts have `--help` text
- No hidden telemetry, upload, or remote execution
- High-impact tasks use explicit invocation or approval gates

## Third-party skills

When adapting another skill:

1. Read every file in the skill folder.
2. Search for network calls, credential paths, shell expansions, and destructive operations.
3. Run static validation.
4. Run route-away evals for over-activation.
5. Package from a clean source folder.
