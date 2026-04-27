#!/usr/bin/env bash
set -euo pipefail
DOC_ROOT="${1:-}"; [ -n "$DOC_ROOT" ] || { echo "Usage: bootstrap-inspection-tooling.sh <doc-root> [--profile minimal|runtime|visual|parity|full] [--install-browsers]" >&2; exit 64; }
shift || true
PROFILE="runtime"; INSTALL_BROWSERS=0
while [ $# -gt 0 ]; do
  case "$1" in
    --profile) PROFILE="${2:-}"; shift 2 ;;
    --install-browsers) INSTALL_BROWSERS=1; shift ;;
    -h|--help) echo "Usage: bootstrap-inspection-tooling.sh <doc-root> [--profile minimal|runtime|visual|parity|full] [--install-browsers]"; exit 0 ;;
    *) echo "UNKNOWN_ARG: $1" >&2; exit 64 ;;
  esac
done
case "$PROFILE" in minimal|runtime|visual|parity|full) ;; *) echo "INVALID_PROFILE: $PROFILE" >&2; exit 64 ;; esac
command -v node >/dev/null 2>&1 || { echo "NEEDS_NODE" >&2; exit 69; }
command -v npm >/dev/null 2>&1 || { echo "NEEDS_NPM" >&2; exit 69; }
TOOLING="$DOC_ROOT/.tooling"; mkdir -p "$TOOLING"
cd "$TOOLING"
[ -f package.json ] || cat > package.json <<'JSON'
{"name":"electron-app-inspection-tooling","private":true,"version":"0.0.0"}
JSON
case "$PROFILE" in
  minimal) PACKAGES=("@electron/asar") ;;
  runtime) PACKAGES=("@electron/asar" "chrome-remote-interface" "puppeteer-core" "playwright") ;;
  visual|parity|full) PACKAGES=("@electron/asar" "chrome-remote-interface" "puppeteer-core" "playwright" "pixelmatch" "pngjs") ;;
esac
PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1 npm install --no-audit --no-fund "${PACKAGES[@]}"
if [ "$INSTALL_BROWSERS" = "1" ]; then npx playwright install chromium; fi
cat > tooling-status.json <<JSON
{
  "schemaVersion": "4.0.0",
  "createdAt": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "profile": "$PROFILE",
  "installBrowsers": $INSTALL_BROWSERS,
  "packages": [$(printf '"%s",' "${PACKAGES[@]}" | sed 's/,$//')],
  "toolingDir": "$TOOLING"
}
JSON
cat > tooling-report.md <<MD
# Tooling Report

Installed profile: $PROFILE

Packages:

$(printf -- '- %s\n' "${PACKAGES[@]}")

Browser binaries installed: $INSTALL_BROWSERS
MD
python3 - <<'PY' "$DOC_ROOT/00-meta/capability-ledger.json" "$PROFILE" "$TOOLING"
import json,sys,time,os
path,profile,tooling=sys.argv[1:]
try: data=json.load(open(path))
except Exception: data={"schemaVersion":"4.0.0","capabilities":[],"downgradeJustification":[]}
data.setdefault("capabilities",[]).append({"name":"local-npm-tooling","status":"installed","value":"high","cost":"low-medium","evidence":".tooling/tooling-status.json","notes":f"profile={profile}","createdAt":time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime())})
open(path,'w').write(json.dumps(data,indent=2))
PY
printf 'TOOLING_DIR=%s\nPROFILE=%s\n' "$TOOLING" "$PROFILE"
