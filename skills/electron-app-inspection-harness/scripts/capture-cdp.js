#!/usr/bin/env node
const fs = require('fs');
const path = require('path');

function arg(name, def='') {
  const i = process.argv.indexOf(name);
  return i >= 0 ? process.argv[i + 1] : def;
}
const docRoot = arg('--doc-root');
const port = Number(arg('--port', '9222'));
const label = arg('--label', 'default');
if (!docRoot) {
  console.error('Usage: capture-cdp.js --doc-root <doc-root> [--port 9222] [--label default]');
  process.exit(64);
}

const toolingRequire = (pkg) => {
  const local = path.join(docRoot, '.tooling', 'node_modules', pkg);
  try { return require(local); } catch {}
  return require(pkg);
};

async function main() {
  const CDP = toolingRequire('chrome-remote-interface');
  const out = {
    screenshots: path.join(docRoot, '01-runtime', 'screenshots'),
    dom: path.join(docRoot, '01-runtime', 'dom'),
    ax: path.join(docRoot, '01-runtime', 'accessibility'),
    cn: path.join(docRoot, '01-runtime', 'console-network')
  };
  Object.values(out).forEach(d => fs.mkdirSync(d, { recursive: true }));

  const targets = await CDP.List({ port });
  fs.writeFileSync(path.join(docRoot, '01-runtime', 'pages.json'), JSON.stringify(targets, null, 2));
  const pageTarget = targets.find(t => t.type === 'page' || t.type === 'webview') || targets[0];
  if (!pageTarget) throw new Error(`No CDP targets on port ${port}`);
  const client = await CDP({ port, target: pageTarget });
  const { Runtime, Page, DOM, Accessibility, Log, Network } = client;
  const logs = [];
  try {
    await Promise.all([Runtime.enable(), Page.enable(), DOM.enable(), Log.enable(), Network.enable()].filter(Boolean));
    Log.entryAdded(({ entry }) => logs.push(entry));

    const meta = await Runtime.evaluate({ expression: `({title: document.title, url: location.href, readyState: document.readyState, userAgent: navigator.userAgent, viewport: {w: innerWidth, h: innerHeight, dpr: devicePixelRatio}})`, returnByValue: true });
    fs.writeFileSync(path.join(out.dom, `${label}-meta.json`), JSON.stringify(meta.result.value, null, 2));

    const domStyles = await Runtime.evaluate({ expression: `(() => {
      const nodes = Array.from(document.querySelectorAll('*')).slice(0, 2000);
      return nodes.map((el, index) => {
        const r = el.getBoundingClientRect();
        const s = getComputedStyle(el);
        const text = (el.textContent || '').trim().replace(/\s+/g, ' ').slice(0, 140);
        return {
          index,
          tag: el.tagName.toLowerCase(),
          id: el.id || '',
          className: String(el.className || ''),
          role: el.getAttribute('role') || '',
          ariaLabel: el.getAttribute('aria-label') || '',
          text,
          rect: {x: r.x, y: r.y, w: r.width, h: r.height},
          style: {
            display: s.display, position: s.position, zIndex: s.zIndex,
            fontFamily: s.fontFamily, fontSize: s.fontSize, fontWeight: s.fontWeight,
            lineHeight: s.lineHeight, letterSpacing: s.letterSpacing,
            color: s.color, backgroundColor: s.backgroundColor,
            padding: s.padding, margin: s.margin, border: s.border,
            borderRadius: s.borderRadius, boxShadow: s.boxShadow,
            overflow: s.overflow, opacity: s.opacity
          }
        };
      });
    })()`, returnByValue: true });
    fs.writeFileSync(path.join(out.dom, `${label}-dom-styles.json`), JSON.stringify(domStyles.result.value, null, 2));

    try {
      const screenshot = await Page.captureScreenshot({ format: 'png', captureBeyondViewport: true });
      fs.writeFileSync(path.join(out.screenshots, `${label}.png`), Buffer.from(screenshot.data, 'base64'));
    } catch (e) {
      fs.writeFileSync(path.join(out.screenshots, `${label}-screenshot-error.txt`), String(e.stack || e));
    }

    try {
      const ax = await Accessibility.getFullAXTree({});
      fs.writeFileSync(path.join(out.ax, `${label}-ax-tree.json`), JSON.stringify(ax, null, 2));
    } catch (e) {
      fs.writeFileSync(path.join(out.ax, `${label}-ax-error.txt`), String(e.stack || e));
    }

    fs.writeFileSync(path.join(out.cn, `${label}-log-entries.json`), JSON.stringify(logs, null, 2));
    fs.writeFileSync(path.join(docRoot, '01-runtime', `${label}-capture-summary.md`), `# CDP Capture Summary\n\nTarget: ${pageTarget.title || pageTarget.url}\nPort: ${port}\nLabel: ${label}\n\nArtifacts:\n- 01-runtime/screenshots/${label}.png\n- 01-runtime/dom/${label}-meta.json\n- 01-runtime/dom/${label}-dom-styles.json\n- 01-runtime/accessibility/${label}-ax-tree.json\n`);
  } finally {
    await client.close();
  }
}
main().catch(e => { console.error(e.stack || e); process.exit(1); });
