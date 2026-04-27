#!/usr/bin/env bash
set -euo pipefail
python3 - "$@" <<'PY'
import argparse, json, os, plistlib, re, shutil, subprocess, sys, time
from pathlib import Path

p=argparse.ArgumentParser(description='Initialize an Electron app inspection output root.')
p.add_argument('--app')
p.add_argument('--app-name')
p.add_argument('--asar')
p.add_argument('--out-root', default='analysis')
p.add_argument('--mode', default='third-party-app', choices=['own-dev-app','own-packaged-app','third-party-app','archive-only','screenshot-only'])
p.add_argument('--scope', default='whole app inventory + one component deep dive')
args=p.parse_args()
if not args.app and not args.app_name:
    print('NEEDS_APP_IDENTITY', file=sys.stderr); sys.exit(64)

def resolve_app(x):
    if not x: return ''
    candidates=[]
    q=Path(x).expanduser()
    if q.is_dir() and str(q).endswith('.app'): return str(q)
    for base in [Path('/Applications'), Path.home()/'Applications']:
        cand=base/f'{x}.app'
        if cand.is_dir(): return str(cand)
        if base.is_dir():
            for app in base.glob('*.app'):
                if app.stem.lower()==x.lower(): candidates.append(str(app))
    if len(candidates)==1: return candidates[0]
    if len(candidates)>1:
        print('AMBIGUOUS_APP: '+x, file=sys.stderr)
        print('\n'.join(candidates), file=sys.stderr)
        sys.exit(65)
    print('APP_NOT_FOUND: '+x, file=sys.stderr); sys.exit(66)

def slugify(s):
    s=re.sub(r'[^a-z0-9]+','-',s.lower()).strip('-')
    return s or 'electron-app'

def cmd(name):
    return shutil.which(name) or 'missing'

app_path=resolve_app(args.app) if args.app else ''
name=args.app_name or ''
bundle_id=''; version=''; asar=args.asar or ''
if app_path:
    info=Path(app_path)/'Contents/Info.plist'
    if info.is_file():
        try:
            data=plistlib.loads(info.read_bytes())
            name=name or data.get('CFBundleDisplayName') or data.get('CFBundleName') or Path(app_path).stem
            bundle_id=data.get('CFBundleIdentifier','')
            version=data.get('CFBundleShortVersionString','')
        except Exception:
            name=name or Path(app_path).stem
    else:
        name=name or Path(app_path).stem
    if not asar:
        a=Path(app_path)/'Contents/Resources/app.asar'
        if a.is_file(): asar=str(a)
name=name or (Path(app_path).stem if app_path else 'Electron App')
slug=slugify(name)
doc=Path(args.out_root)/slug
for sub in ['00-meta','01-runtime/screenshots','01-runtime/dom','01-runtime/accessibility','01-runtime/console-network','01-runtime/performance','02-static-asar','03-mcp','04-os-automation/screenshots','05-ui-ux-report','06-codex-tasks','07-parity/references','07-parity/state-captures','07-parity/measurements','07-parity/diffs','.tooling']:
    (doc/sub).mkdir(parents=True, exist_ok=True)
now=time.strftime('%Y-%m-%dT%H:%M:%SZ', time.gmtime())
app_context={
  'schemaVersion':'4.0.0','createdAt':now,'mode':args.mode,'scope':args.scope,
  'app': {'name':name,'slug':slug,'path':app_path,'asar':asar,'bundleId':bundle_id,'version':version},
  'output': {'root':str(doc)}
}
(doc/'00-meta/app-context.json').write_text(json.dumps(app_context, indent=2), encoding='utf-8')
(doc/'00-meta/capability-ledger.json').write_text(json.dumps({'schemaVersion':'4.0.0','createdAt':now,'capabilities':[],'downgradeJustification':[]}, indent=2), encoding='utf-8')
manifest={
  'schemaVersion':'4.0.0','appContext':'00-meta/app-context.json','capabilityLedger':'00-meta/capability-ledger.json','routeDecision':'00-meta/route-decision.md','runtime':'01-runtime/','staticAsar':'02-static-asar/','mcp':'03-mcp/','osAutomation':'04-os-automation/','uiUxReport':'05-ui-ux-report/','codexTasks':'06-codex-tasks/','parity':'07-parity/',
  'readOrder':['00-meta/manifest.json','00-meta/app-context.json','00-meta/capability-ledger.json','05-ui-ux-report/inspection-report.md','05-ui-ux-report/design-tokens.json','05-ui-ux-report/component-inventory.md','05-ui-ux-report/interaction-matrix.md','06-codex-tasks/task-contract.json','07-parity/parity-matrix.md','07-parity/implementation-slices.json']
}
(doc/'00-meta/manifest.json').write_text(json.dumps(manifest, indent=2), encoding='utf-8')
(doc/'00-meta/environment-report.md').write_text(f'''# Environment Report\n\nGenerated: {now}\n\n| Item | Value |\n|---|---|\n| App name | {name} |\n| App slug | {slug} |\n| Mode | {args.mode} |\n| App path | {app_path or 'not provided'} |\n| app.asar | {asar or 'not found'} |\n| Output root | {doc} |\n| node | {cmd('node')} |\n| npm | {cmd('npm')} |\n| codex | {cmd('codex')} |\n| python3 | {cmd('python3')} |\n| screencapture | {cmd('screencapture')} |\n| lsof | {cmd('lsof')} |\n''', encoding='utf-8')
(doc/'00-meta/route-decision.md').write_text('''# Route Decision\n\nInitialized only. Select route after capability recovery.\n\nPreferred order:\n\n1. debug bridge if own-dev-app\n2. MCP runtime inspection\n3. raw CDP/Puppeteer capture\n4. Playwright Electron\n5. asar static analysis\n6. OS automation\n7. screenshot fallback\n''', encoding='utf-8')
(doc/'05-ui-ux-report/verification-report.md').write_text('# Verification Report\n\nPending inspection.\n', encoding='utf-8')
(doc/'07-parity/parity-matrix.md').write_text('# Parity Matrix\n\nPending state captures.\n', encoding='utf-8')
(doc/'07-parity/implementation-slices.json').write_text(json.dumps({'schemaVersion':'4.1.0','profile':'generic-electron-ui','slices':[]}, indent=2), encoding='utf-8')
(doc/'06-codex-tasks/inspection-kanban.md').write_text('''# Inspection Kanban\n\n## Ready\n\n- [ ] Attach or launch CDP and capture default runtime evidence.\n- [ ] Extract app.asar and create static map.\n- [ ] Use MCP runtime exploration when available.\n- [ ] Build UI/UX report and component inventory.\n- [ ] Build Codex implementation task contract.\n\n## Done\n''', encoding='utf-8')
print(f'APP_NAME={name}')
print(f'APP_SLUG={slug}')
print(f'APP_PATH={app_path}')
print(f'APP_ASAR={asar}')
print(f'DOC_ROOT={doc}')
print(f'CONTEXT={doc}/00-meta/app-context.json')
PY
