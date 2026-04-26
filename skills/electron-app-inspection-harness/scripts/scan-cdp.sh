#!/usr/bin/env bash
set -euo pipefail
DOC_ROOT="${1:-}"; [ -n "$DOC_ROOT" ] || { echo "Usage: scan-cdp.sh <doc-root> [--ports 9222-9232,9322]" >&2; exit 64; }
shift || true
PORTS="9222-9232,9322,9422,9522"
while [ $# -gt 0 ]; do case "$1" in --ports) PORTS="${2:-}"; shift 2 ;; *) echo "UNKNOWN_ARG: $1" >&2; exit 64 ;; esac; done
mkdir -p "$DOC_ROOT/01-runtime"
OUT="$DOC_ROOT/01-runtime/cdp-scan.json"
python3 - <<'PY' "$PORTS" "$OUT"
import json, sys, urllib.request, time
ports_arg,out=sys.argv[1:]
ports=[]
for chunk in ports_arg.split(','):
    if not chunk.strip(): continue
    if '-' in chunk:
        a,b=chunk.split('-',1); ports.extend(range(int(a),int(b)+1))
    else: ports.append(int(chunk))
res=[]
for p in ports:
    item={"port":p,"endpoint":f"http://127.0.0.1:{p}","ok":False,"version":None,"pages":None,"error":None}
    try:
        with urllib.request.urlopen(item['endpoint']+'/json/version', timeout=.75) as r: item['version']=json.loads(r.read().decode())
        with urllib.request.urlopen(item['endpoint']+'/json/list', timeout=.75) as r: item['pages']=json.loads(r.read().decode())
        item['ok']=True
    except Exception as e: item['error']=type(e).__name__+': '+str(e)[:200]
    res.append(item)
report={"schemaVersion":"4.0.0","createdAt":time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime()),"results":res,"working":[x for x in res if x['ok']]}
open(out,'w').write(json.dumps(report,indent=2))
print(json.dumps(report,indent=2))
PY
