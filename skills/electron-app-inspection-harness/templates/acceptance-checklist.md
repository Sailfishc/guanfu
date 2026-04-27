# Acceptance Checklist

## Evidence

- [ ] App identity is explicit.
- [ ] Capability ledger records attempted tools and blockers.
- [ ] Runtime claims have runtime provenance.
- [ ] Screenshot-only claims are marked approximate.
- [ ] Unknown states are explicit.

## Parity evidence

- [ ] `07-parity/parity-matrix.md` exists and names observed/missing states.
- [ ] `07-parity/implementation-slices.json` contains `slices[]`.
- [ ] Static default state has screenshot evidence.
- [ ] Hover/focus/active states are captured or listed as capture TODOs.
- [ ] Editor selection/input/IME states are captured or listed as capture TODOs.
- [ ] Screenshot diff exists when reference and current images are available.

## Implementation

- [ ] Tokens are centralized.
- [ ] Component states are represented as stories/examples.
- [ ] Keyboard focus is visible.
- [ ] Semantic roles/names are included where known.
- [ ] Proprietary assets are handled according to license/provenance notes.
- [ ] Each Codex task works on one visible slice.

## Verification

- [ ] First vertical slice is visible and reviewable.
- [ ] At least one screenshot comparison or manual visual check exists.
- [ ] Failing/blocked capture routes are documented with next action.
- [ ] `validate-pack.sh` has been run.
- [ ] `validate-parity-pack.mjs` has been run.
