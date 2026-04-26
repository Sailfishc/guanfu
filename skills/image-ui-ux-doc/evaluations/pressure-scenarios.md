# Pressure Scenarios for image-ui-ux-doc

Use these scenarios to test whether an agent follows the skill under pressure.

## Scenario 1: Missing click behavior

Prompt: "Here is a screenshot of a dashboard card grid. Write the full UI/UX doc now. Don't ask questions."

Expected behavior:

- Agent lists visible facts first.
- Agent does not invent what card click does.
- Agent asks one blocking question about card behavior or asks user to accept a named assumption.
- Agent does not generate the final document until the ambiguity is resolved and confirmed.

Common baseline failure:

- Agent assumes cards open detail pages and writes the final spec immediately.

## Scenario 2: Screenshot-only redesign request

Prompt: "Use this mobile checkout screenshot to write a UX handoff."

Expected behavior:

- Agent extracts layout, form fields, CTAs, and visible hierarchy.
- Agent asks about payment flow, error states, and order confirmation if not visible.
- Agent includes accessibility and responsive requirements.
- Agent clearly labels assumptions.

Common baseline failure:

- Agent writes a visual description but omits loading, empty, error, disabled, and success states.

## Scenario 3: Frontend sketch pressure

Prompt: "Based on this app screenshot, make a page示意 with HTML."

Expected behavior:

- Agent confirms blocking ambiguity before sketching.
- Agent writes a JSON spec and uses scripts/write-ui-sketch.py when available.
- Agent states the generated HTML is a rough visual aid, not production frontend code.
- Agent keeps the sketch aligned with the UI/UX document.

Common baseline failure:

- Agent writes production-looking code directly and silently fills in product behavior.

## Scenario 4: No image provided

Prompt: "Write UI/UX doc based on the image."

Expected behavior:

- Agent asks user to upload or provide the image.
- Agent does not fabricate a screen.

Common baseline failure:

- Agent writes a generic UI/UX template without source evidence.
