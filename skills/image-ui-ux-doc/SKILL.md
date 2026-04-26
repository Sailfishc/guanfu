---
name: image-ui-ux-doc
description: Use when screenshots, app images, wireframes, Figma exports, product UI photos, or visual references are provided for UI/UX documentation, screen specs, redesign notes, or frontend sketch planning.
---

# Image UI/UX Documentation

## Overview

Turn product images into UI/UX documentation without pretending the image proves more than it does.

Images establish visible facts. Product intent, hidden interactions, data rules, user roles, edge states, and platform constraints require confirmation before the final document is generated.

## When to Use

Use this skill when the user provides or references:

- A screenshot, product image, wireframe, app mockup, Figma export, landing page, dashboard, mobile screen, or UI photo
- A request to write a UI/UX document, PRD-style screen spec, redesign brief, design handoff, UX audit, or frontend implementation brief from an image
- A request for a quick frontend page sketch, static HTML mockup, page示意, or visual companion based on a screenshot

Do not use this skill for pure backend specs, brand strategy without UI images, or image generation requests.

## Core Rule

Visible is evidence. Invisible is a question.

Never invent hidden behavior from a screenshot. If a decision would change the UX document, ask the user and confirm the resolved answer before final generation.

## Ambiguity Gate

Classify unknowns before writing the final document.

| Level | Examples | Action |
| --- | --- | --- |
| Critical | Target user, primary goal, screen purpose, flow order, CTA behavior, navigation meaning, product domain, platform, data source, destructive action | Stop. Ask one question at a time. |
| High | Missing labels, modal or drawer behavior, empty/error/loading states, permission states, responsive behavior, accessibility requirement | Stop unless the user explicitly accepts a documented assumption. |
| Low | Exact pixel spacing, exact font, exact color if not readable, minor icon meaning | State as assumption. No blocking question needed. |

### Confirmation loop

If Critical or High ambiguity exists:

1. Ask one question only.
2. Wait for the answer.
3. Update the resolved requirements.
4. Continue asking one question at a time until no blocking ambiguity remains.
5. Restate the final interpretation in 3 to 7 bullets.
6. Ask for final confirmation.
7. Generate the final UI/UX document only after confirmation.

If the user says "just do it," do not skip Critical ambiguity. For High ambiguity, proceed only if the user accepts a named assumption such as: "Assume this is a desktop SaaS dashboard and proceed."

## Workflow

Copy this checklist and complete it in order:

```text
Image UI/UX Doc Progress:
- [ ] Confirm image availability and task scope
- [ ] Extract visible facts
- [ ] Separate facts from assumptions
- [ ] Run ambiguity gate
- [ ] Resolve blocking ambiguity with the user
- [ ] Draft UI/UX document
- [ ] Optionally create frontend sketch
- [ ] Self-review against the source image and user answers
- [ ] Deliver final doc with assumptions and open questions
```

### Step 1: Confirm image availability and task scope

If no image is present, ask the user to upload or link the image.

If multiple images are present, identify each screen and ask which image is the source of truth when they conflict.

### Step 2: Extract visible facts

List only what can be seen:

- Screen type and likely platform, for example desktop web, mobile app, web app, admin console
- Layout regions, hierarchy, navigation, panels, cards, lists, tables, forms, controls
- Visible text, labels, button copy, empty states, badges, status markers
- Visual style, spacing, density, typography cues, color roles, elevation, borders
- Interaction clues, for example selected tab, disabled button, drag handle, checkbox, input, pagination

Do not identify real people in images. Describe visible roles or actions only.

### Step 3: Separate facts from assumptions

Use this format before asking questions:

```markdown
## Visible facts
- [What is directly visible]

## Likely but unconfirmed
- [Inference that may be true, with confidence]

## Blocking unknowns
- [Unknown that changes the UI/UX doc]
```

### Step 4: Resolve ambiguity

Ask the smallest question that removes the most ambiguity. Prefer multiple-choice questions when the options are clear.

Good:

```text
This screenshot shows a card list, but I cannot tell what happens when a card is clicked.
Which behavior is correct?
A) Opens a detail page
B) Opens an inline drawer
C) Selects the card for batch actions
D) Something else
```

Bad:

```text
Tell me everything about the product.
```

### Step 5: Draft the UI/UX document

Use `templates/ui-ux-doc-template.md` as the default structure. Remove sections that do not apply. Keep all assumptions explicit.

The document must include:

- Source image summary
- Intended user and job to be done, from user confirmation or marked unknown
- Information architecture
- Screen-by-screen layout spec
- User flow and interactions
- State model, including loading, empty, error, success, disabled, partial data
- Accessibility and responsive notes
- Content and microcopy notes
- Visual system observations
- Open questions and risks

### Step 6: Optional frontend sketch

Use a frontend sketch only when it helps the user evaluate layout, flow, or hierarchy. The sketch is a visual aid, not production implementation.

Use `scripts/write-ui-sketch.py` to generate a self-contained HTML sketch from a JSON spec.

```bash
python scripts/write-ui-sketch.py /tmp/ui-sketch-spec.json /tmp/ui-sketch.html
```

Minimal spec:

```json
{
  "title": "Project Dashboard",
  "viewport": "desktop",
  "notes": ["Rough page示意 based on confirmed screenshot interpretation"],
  "screens": [
    {
      "name": "Dashboard",
      "purpose": "Help users review projects and open a workspace",
      "layout": [
        {"type": "header", "text": "Projects"},
        {"type": "toolbar", "items": ["Search", "New project"]},
        {"type": "card", "title": "Project card", "body": "Name, preview, metadata, primary action"}
      ]
    }
  ]
}
```

The script escapes all text and uses no external dependencies. If a rendered screenshot is required, open the generated HTML in a browser or local preview tool available in the environment.

### Step 7: Self-review

Before final delivery, verify:

- Every major visible UI element from the image is represented or intentionally omitted
- Assumptions are labeled, not hidden inside requirements
- Blocking unknowns are resolved by user answers or remain in Open Questions
- Interaction states are covered beyond the happy path
- Accessibility and responsive behavior are addressed
- The optional HTML sketch matches the written document

## Output Contract

Return the final answer in this order:

1. UI/UX document
2. Assumptions made
3. Open questions, if any remain
4. Frontend sketch path or link, if generated

Never bury uncertainty. If the image cannot support a claim, write "not visible in the image" or ask the user.

## Common Mistakes

| Mistake | Fix |
| --- | --- |
| Treating a screenshot as a complete product spec | Use the ambiguity gate. |
| Inferring click behavior from layout alone | Ask what the control does. |
| Writing only visual description, no UX states | Add loading, empty, error, success, disabled, and partial states. |
| Creating production frontend code from a screenshot | Generate only a rough static sketch unless the user separately asks for implementation. |
| Asking a huge batch of questions | Ask one question at a time and confirm final interpretation. |
| Hiding uncertainty | Put assumptions and unknowns in named sections. |
