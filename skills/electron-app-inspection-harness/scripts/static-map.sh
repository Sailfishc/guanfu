#!/usr/bin/env bash
set -euo pipefail
DOC_ROOT="${1:-}"; [ -n "$DOC_ROOT" ] || { echo "Usage: static-map.sh <doc-root>" >&2; exit 64; }
ROOT="$DOC_ROOT/02-static-asar/extracted"; [ -d "$ROOT" ] || { echo "EXTRACTED_ASAR_NOT_FOUND: $ROOT" >&2; exit 66; }
OUT_MD="$DOC_ROOT/02-static-asar/static-map.md"; OUT_JSON="$DOC_ROOT/02-static-asar/static-map.json"
RG="$(command -v rg || true)"
search(){ local pat="$1"; if [ -n "$RG" ]; then "$RG" -n --hidden --glob '!node_modules' "$pat" "$ROOT" 2>/dev/null | head -200; else grep -RInE "$pat" "$ROOT" 2>/dev/null | head -200; fi; }
{
  echo "# Static ASAR Map"
  echo
  echo "Generated: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo
  echo "## Entry files"
  find "$ROOT" -maxdepth 4 \( -name package.json -o -name "*.html" -o -name "*.js" -o -name "*.css" -o -name "*.map" \) 2>/dev/null | sed "s#^$ROOT/##" | head -300
  echo
  echo "## Framework hints"
  search 'react|vue|svelte|solid|prosemirror|tiptap|slate|lexical|tailwind|emotion|styled-components|vite|webpack|parcel|rollup' || true
  echo
  echo "## Electron and IPC hints"
  search 'ipcRenderer|ipcMain|contextBridge|BrowserWindow|BrowserView|webContents|globalShortcut|Menu\.buildFromTemplate|nativeImage|Tray' || true
  echo
  echo "## UI command and shortcut hints"
  search 'shortcut|hotkey|Command|command palette|palette|drag|drop|selection|hover|focus|canvas|whiteboard|editor|sidebar|menu' || true
  echo
  echo "## Style/token hints"
  search '--[a-zA-Z0-9_-]+:|var\(--|#[0-9a-fA-F]{6}|rgb\(|hsl\(|font-family|border-radius|box-shadow' || true
  echo
  echo "## Asset files"
  find "$ROOT" \( -name "*.svg" -o -name "*.png" -o -name "*.jpg" -o -name "*.webp" -o -name "*.woff" -o -name "*.woff2" -o -name "*.ttf" \) 2>/dev/null | sed "s#^$ROOT/##" | head -500
} > "$OUT_MD"
python3 - <<'PY' "$ROOT" "$OUT_JSON"
import os,json,sys,re
root,out=sys.argv[1:]
files=[]
for dirpath,_,names in os.walk(root):
    for n in names:
        p=os.path.join(dirpath,n); rel=os.path.relpath(p,root)
        if len(files)<5000: files.append(rel)
report={"schemaVersion":"4.0.0","fileCountApprox":len(files),"files":files[:5000]}
open(out,'w').write(json.dumps(report,indent=2))
PY
printf 'STATIC_MAP=%s\n' "$OUT_MD"
