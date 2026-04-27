# Editor Interaction Contract

Use this for note/editor parity, including Sumink-like title blocks, paragraph blocks, ordered lists, code blocks, selection, cursor, and IME behavior.

## Required scenarios

| Scenario | Actions | Expected evidence |
|---|---|---|
| title focus | click title | focused element, cursor position, focus style |
| paragraph typing | click paragraph, type text | text insertion, stable cursor, no layout jump |
| ordered list typing | click list item, type, Enter | numbering and indentation stable |
| code block typing | click code block, type code | monospace style, selection/cursor stable |
| Backspace at block start | key Backspace | block merge behavior documented |
| Enter at block end | key Enter | new block behavior documented |
| selection drag | mouse drag across text | selection style and anchor documented |
| IME composition | type Chinese/Japanese/Korean input manually or via local test | composition remains stable |
| paste plain text | paste multi-line text | block splitting or plain insertion documented |
| paste code | paste fenced code or code text | code block handling documented |
| undo/redo | Cmd-Z / Cmd-Shift-Z | text, block type, cursor restoration documented |

## Capture notes

- IME behavior often needs manual notes or a local Playwright test with OS input.
- Use computed CSS for cursor-adjacent block typography and spacing.
- Record unknown editor semantics as TODOs rather than guessing.

## Implementation acceptance

- Typing preserves cursor position.
- Composition input preserves active editor state.
- Enter and Backspace behaviors are deterministic.
- Undo/redo is scoped to editor operations.
- Visual block states use centralized tokens.
