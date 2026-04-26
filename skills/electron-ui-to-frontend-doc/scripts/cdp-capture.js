#!/usr/bin/env node
/*
Capture Electron renderer evidence through Chrome DevTools Protocol.
Requires local dependency: playwright.
Usage: node scripts/cdp-capture.js http://127.0.0.1:9222 electron-ui-doc/<app-slug>/captures
*/
const fs = require('fs');
const path = require('path');

async function main() {
  const endpoint = process.argv[2] || 'http://127.0.0.1:9222';
  const outDir = process.argv[3];
  if (!outDir) {
    console.error('Usage: cdp-capture.js <cdp-endpoint> <captures-dir>');
    process.exit(64);
  }

  let chromium;
  try {
    ({ chromium } = require('playwright'));
  } catch (err) {
    console.error('ERROR: playwright is not installed. Install locally after user approval: npm i -D playwright');
    process.exit(2);
  }

  fs.mkdirSync(path.join(outDir, 'screenshots'), { recursive: true });
  fs.mkdirSync(path.join(outDir, 'dom'), { recursive: true });
  fs.mkdirSync(path.join(outDir, 'accessibility'), { recursive: true });

  const browser = await chromium.connectOverCDP(endpoint);
  const contexts = browser.contexts();
  const pages = contexts.flatMap((context) => context.pages());
  const page = pages.find((p) => !p.url().startsWith('devtools://')) || pages[0];
  if (!page) {
    console.error('ERROR: no pages found through CDP. Check the endpoint and app window.');
    await browser.close();
    process.exit(3);
  }

  await page.bringToFront().catch(() => {});

  const meta = await page.evaluate(() => ({
    url: location.href,
    title: document.title,
    viewport: { width: window.innerWidth, height: window.innerHeight },
    devicePixelRatio: window.devicePixelRatio,
    userAgent: navigator.userAgent,
  }));

  await page.screenshot({ path: path.join(outDir, 'screenshots', 'runtime-default.png'), fullPage: true });

  const snapshot = await page.evaluate(() => {
    const cssVars = {};
    const rootStyle = getComputedStyle(document.documentElement);
    for (const name of rootStyle) {
      if (name.startsWith('--')) cssVars[name] = rootStyle.getPropertyValue(name).trim();
    }

    const nodes = Array.from(document.querySelectorAll('*')).map((el, index) => {
      const rect = el.getBoundingClientRect();
      const style = getComputedStyle(el);
      return {
        index,
        tag: el.tagName.toLowerCase(),
        id: el.id || '',
        className: typeof el.className === 'string' ? el.className : '',
        role: el.getAttribute('role') || '',
        ariaLabel: el.getAttribute('aria-label') || '',
        title: el.getAttribute('title') || '',
        text: (el.textContent || '').trim().replace(/\s+/g, ' ').slice(0, 180),
        rect: {
          x: Number(rect.x.toFixed(2)),
          y: Number(rect.y.toFixed(2)),
          width: Number(rect.width.toFixed(2)),
          height: Number(rect.height.toFixed(2)),
        },
        style: {
          display: style.display,
          position: style.position,
          overflow: style.overflow,
          fontFamily: style.fontFamily,
          fontSize: style.fontSize,
          fontWeight: style.fontWeight,
          lineHeight: style.lineHeight,
          color: style.color,
          backgroundColor: style.backgroundColor,
          padding: style.padding,
          margin: style.margin,
          border: style.border,
          borderRadius: style.borderRadius,
          boxShadow: style.boxShadow,
          opacity: style.opacity,
        },
      };
    });

    return { cssVars, nodes };
  });

  fs.writeFileSync(path.join(outDir, 'dom', 'runtime-meta.json'), JSON.stringify(meta, null, 2));
  fs.writeFileSync(path.join(outDir, 'dom', 'runtime-dom-styles.json'), JSON.stringify(snapshot, null, 2));

  try {
    const ax = await page.accessibility.snapshot({ interestingOnly: false });
    fs.writeFileSync(path.join(outDir, 'accessibility', 'runtime-ax-tree.json'), JSON.stringify(ax, null, 2));
  } catch (err) {
    fs.writeFileSync(path.join(outDir, 'accessibility', 'runtime-ax-tree-error.txt'), String(err && err.message ? err.message : err));
  }

  await browser.close();
  console.log(JSON.stringify({ ok: true, outDir, page: meta }, null, 2));
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
