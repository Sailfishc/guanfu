# Parity Matrix

| Atom / Flow | Observation status | Evidence | Gaps to close | Slice | Confidence |
|---|---|---|---|---|---|
| note detail shell | not observed | pending | shell/sidebar/topbar/content/backlinks | slice-01-note-detail-static-shell | n/a |
| sidebar states | not observed | pending | default/hover/active/pressed | slice-02-sidebar-states | n/a |
| editor block visuals | not observed | pending | title/paragraph/list/code | slice-03-editor-block-visuals | n/a |
| editor input stability | not observed | pending | typing/selection/IME/paste/undo | slice-04-editor-input-stability | n/a |
| scroll resize backlinks | not observed | pending | scroll/resize/backlinks hover | slice-05-scroll-resize-backlinks | n/a |

## Update rules

- Use `observed` only when a state has a capture artifact.
- Use `partially observed` when default exists but hover/focus/active is missing.
- Use `not observed` when no capture exists.
- Record `computed CSS`, `DOM rect`, `accessibility tree`, `screenshot diff`, or `inference` as confidence evidence.
