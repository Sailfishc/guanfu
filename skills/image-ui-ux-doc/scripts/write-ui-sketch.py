#!/usr/bin/env python3
"""Generate a rough, self-contained HTML UI sketch from a JSON spec.

Usage:
  python scripts/write-ui-sketch.py spec.json output.html

The script is intentionally simple: it creates a layout sketch for discussion,
not production frontend code.
"""

from __future__ import annotations

import html
import json
import sys
from pathlib import Path
from typing import Any


def esc(value: Any) -> str:
    return html.escape(str(value), quote=True)


def list_items(items: Any) -> str:
    if not isinstance(items, list):
        return ""
    return "".join(f"<span class='pill'>{esc(item)}</span>" for item in items)


def render_component(component: dict[str, Any]) -> str:
    kind = str(component.get("type", "section")).lower()
    title = component.get("title") or component.get("text") or kind.title()
    body = component.get("body", "")
    items = component.get("items", [])

    if kind == "header":
        return f"""
        <header class='topbar'><!-- Main page heading from the confirmed UI doc -->
          <div>
            <p class='eyebrow'>UI sketch</p>
            <h1>{esc(title)}</h1>
          </div>
          <button class='button'>Primary action</button>
        </header>
        """

    if kind == "sidebar":
        labels = items if isinstance(items, list) and items else ["Overview", "Items", "Settings"]
        return """
        <aside class='sidebar'><!-- Navigation region -->
          <strong>{}</strong>
          {}
        </aside>
        """.format(
            esc(title),
            "".join(f"<a href='#'>{esc(label)}</a>" for label in labels),
        )

    if kind == "toolbar":
        return f"""
        <section class='toolbar'><!-- Search, filters, and page-level actions -->
          {list_items(items)}
        </section>
        """

    if kind == "table":
        labels = items if isinstance(items, list) and items else ["Name", "Status", "Owner", "Updated"]
        heads = "".join(f"<th>{esc(label)}</th>" for label in labels)
        cells = "".join(f"<td>{esc(label)} value</td>" for label in labels)
        return f"""
        <section class='panel'><!-- Tabular content region -->
          <h2>{esc(title)}</h2>
          <table><thead><tr>{heads}</tr></thead><tbody><tr>{cells}</tr><tr>{cells}</tr></tbody></table>
        </section>
        """

    if kind == "form":
        labels = items if isinstance(items, list) and items else ["Name", "Description", "Owner"]
        fields = "".join(
            f"<label>{esc(label)}<input placeholder='{esc(label)}' /></label>" for label in labels
        )
        return f"""
        <section class='panel'><!-- Form region -->
          <h2>{esc(title)}</h2>
          <div class='form'>{fields}<button class='button'>Save</button></div>
        </section>
        """

    if kind == "list":
        labels = items if isinstance(items, list) and items else ["List item", "List item", "List item"]
        rows = "".join(f"<li><span>{esc(label)}</span><span class='muted'>metadata</span></li>" for label in labels)
        return f"""
        <section class='panel'><!-- List content region -->
          <h2>{esc(title)}</h2>
          <ul class='list'>{rows}</ul>
        </section>
        """

    return f"""
    <section class='card'><!-- Generic content block -->
      <h3>{esc(title)}</h3>
      <p>{esc(body) if body else 'Describe this UI region here.'}</p>
      <div class='pills'>{list_items(items)}</div>
    </section>
    """


def render_screen(screen: dict[str, Any]) -> str:
    name = screen.get("name", "Screen")
    purpose = screen.get("purpose", "Purpose not specified")
    layout = screen.get("layout", [])
    if not isinstance(layout, list):
        layout = []

    sidebar = ""
    main_components = []
    for component in layout:
        if not isinstance(component, dict):
            continue
        if str(component.get("type", "")).lower() == "sidebar":
            sidebar += render_component(component)
        else:
            main_components.append(render_component(component))

    if not main_components:
        main_components.append(render_component({"type": "card", "title": "Main content", "body": purpose}))

    return f"""
    <section class='screen'>
      <div class='screen-title'>
        <h2>{esc(name)}</h2>
        <p>{esc(purpose)}</p>
      </div>
      <div class='shell {"with-sidebar" if sidebar else ""}'>
        {sidebar}
        <main class='content'>{''.join(main_components)}</main>
      </div>
    </section>
    """


def render_html(spec: dict[str, Any]) -> str:
    title = spec.get("title", "UI Sketch")
    viewport = spec.get("viewport", "desktop")
    notes = spec.get("notes", [])
    screens = spec.get("screens", [])
    if not isinstance(screens, list) or not screens:
        screens = [{"name": "Main screen", "purpose": "Validate layout hierarchy", "layout": []}]
    if not isinstance(notes, list):
        notes = [str(notes)]

    note_html = "".join(f"<li>{esc(note)}</li>" for note in notes)
    screen_html = "".join(render_screen(screen if isinstance(screen, dict) else {}) for screen in screens)

    return f"""<!doctype html>
<html lang='en'>
<head>
  <meta charset='utf-8' />
  <meta name='viewport' content='width=device-width, initial-scale=1' />
  <title>{esc(title)}</title>
  <style>
    :root {{ font-family: ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif; color: #1f2937; background: #f8fafc; }}
    * {{ box-sizing: border-box; }}
    body {{ margin: 0; padding: 32px; }}
    .wrap {{ max-width: 1180px; margin: 0 auto; }}
    .meta {{ margin-bottom: 24px; padding: 16px 18px; border: 1px solid #d1d5db; border-radius: 18px; background: white; }}
    .meta h1 {{ margin: 0 0 8px; font-size: 28px; }}
    .meta p, .meta li {{ color: #4b5563; }}
    .screen {{ margin: 24px 0; }}
    .screen-title {{ margin-bottom: 12px; }}
    .screen-title h2 {{ margin: 0; }}
    .screen-title p {{ margin: 4px 0 0; color: #6b7280; }}
    .shell {{ min-height: 560px; display: block; border: 1px solid #cbd5e1; border-radius: 24px; background: #ffffff; overflow: hidden; }}
    .shell.with-sidebar {{ display: grid; grid-template-columns: 240px 1fr; }}
    .sidebar {{ padding: 20px; border-right: 1px solid #e5e7eb; background: #f9fafb; }}
    .sidebar strong {{ display: block; margin-bottom: 14px; }}
    .sidebar a {{ display: block; padding: 10px 12px; margin: 6px 0; border: 1px solid #e5e7eb; border-radius: 12px; color: #374151; text-decoration: none; background: white; }}
    .content {{ padding: 22px; display: grid; gap: 16px; align-content: start; }}
    .topbar {{ display: flex; align-items: center; justify-content: space-between; gap: 16px; padding: 18px; border: 1px solid #e5e7eb; border-radius: 18px; }}
    .eyebrow {{ margin: 0 0 4px; color: #6b7280; font-size: 12px; text-transform: uppercase; letter-spacing: .08em; }}
    h1, h2, h3 {{ line-height: 1.15; }}
    h1 {{ margin: 0; }}
    .toolbar {{ display: flex; flex-wrap: wrap; gap: 10px; padding: 14px; border: 1px dashed #cbd5e1; border-radius: 16px; background: #f8fafc; }}
    .pill {{ display: inline-flex; align-items: center; min-height: 32px; padding: 6px 10px; border: 1px solid #d1d5db; border-radius: 999px; background: white; color: #374151; }}
    .panel, .card {{ padding: 18px; border: 1px solid #e5e7eb; border-radius: 18px; background: #ffffff; }}
    .card p {{ color: #4b5563; }}
    table {{ width: 100%; border-collapse: collapse; margin-top: 12px; }}
    th, td {{ padding: 12px; border-bottom: 1px solid #e5e7eb; text-align: left; }}
    th {{ background: #f9fafb; font-weight: 600; }}
    .form {{ display: grid; gap: 12px; max-width: 520px; }}
    label {{ display: grid; gap: 6px; color: #374151; }}
    input {{ min-height: 42px; padding: 8px 10px; border: 1px solid #cbd5e1; border-radius: 12px; font: inherit; }}
    .button {{ min-height: 40px; padding: 0 14px; border: 1px solid #111827; border-radius: 12px; background: #111827; color: white; font: inherit; }}
    .list {{ list-style: none; padding: 0; margin: 12px 0 0; }}
    .list li {{ display: flex; justify-content: space-between; gap: 12px; padding: 12px; border: 1px solid #e5e7eb; border-radius: 12px; margin-bottom: 8px; }}
    .muted {{ color: #6b7280; }}
    @media (max-width: 760px) {{
      body {{ padding: 16px; }}
      .shell.with-sidebar {{ display: block; }}
      .sidebar {{ border-right: 0; border-bottom: 1px solid #e5e7eb; }}
      .topbar {{ align-items: flex-start; flex-direction: column; }}
    }}
  </style>
</head>
<body>
  <div class='wrap'>
    <section class='meta'>
      <h1>{esc(title)}</h1>
      <p>Viewport: {esc(viewport)}. Rough layout sketch for UI/UX discussion, not production frontend code.</p>
      <ul>{note_html}</ul>
    </section>
    {screen_html}
  </div>
</body>
</html>
"""


def main() -> int:
    if len(sys.argv) != 3:
        print("Usage: python scripts/write-ui-sketch.py spec.json output.html", file=sys.stderr)
        return 2

    spec_path = Path(sys.argv[1])
    output_path = Path(sys.argv[2])

    try:
        spec = json.loads(spec_path.read_text(encoding="utf-8"))
    except FileNotFoundError:
        print(f"Spec file not found: {spec_path}", file=sys.stderr)
        return 1
    except json.JSONDecodeError as exc:
        print(f"Invalid JSON in {spec_path}: {exc}", file=sys.stderr)
        return 1

    if not isinstance(spec, dict):
        print("Spec root must be a JSON object", file=sys.stderr)
        return 1

    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text(render_html(spec), encoding="utf-8")
    print(f"WROTE {output_path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
