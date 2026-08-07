# Law of Uniform Connectedness

**What it says.** Items joined by something visible — a line, a shared container, a continuous background — read as more related than items that are merely near each other. Connection outranks both proximity and similarity.

**Lens:** Gestalt · visual grouping

**Unit of analysis:** the **screen**. Sweep this lens across every rendered view in your inventory.

## Look for
- A label not visually connected to its input (no shared row/line/container, no `for`/`id`).
- Stepper or breadcrumb whose steps aren't joined by a connecting line.
- Toolbar groups with no connector (divider, segment, shared background).

## Verify it from the code
The label/input case is fully mechanical — start there, because it's the one you can prove.

- Grep every form control for its label pairing: `<label for="x">` with a matching `id="x"`, a wrapping `<label>`, or `aria-labelledby`. A control with none of these is a certain finding — it fails visually *and* for assistive tech, and clicking the label won't focus the field.
- Watch for `for` values that don't match any `id` (typos, or ids generated at runtime that the label hardcodes). Cross-check the actual strings rather than assuming they line up.
- For steppers and breadcrumbs, look for the connector in the markup or CSS: a `::before` line, a border, a shared track element. Absence is verifiable.
- For toolbars, check whether groups have a divider or shared background, or whether all buttons are one undifferentiated run.

## Not a violation (check before reporting)
- **A wrapping `<label>`.** `<label>Email <input></label>` needs no `for` — the association already exists. Missing this is a common false positive.
- **`aria-label` on the control.** It provides the accessible name; the visual connection may still be worth noting, but it isn't unlabeled.
- **Placeholder-as-label.** This *is* a real problem (the label vanishes on input), but report it as its own finding rather than calling the field unlabeled.
- **Connectors drawn by a parent or a design-system component** you didn't open.

## User cost
Connection is the strongest grouping cue. Without it, related controls read as **unrelated**, and an unpaired label also costs a click target and screen-reader clarity.

## Example
**Before** — labels float far from their inputs with no `for`/`id`.
**After** — each label sits in a connected row, paired with `for`/`id`, so the label is part of the field's hit area.

## Fix
Visually *and* semantically connect related elements: shared lines, containers, connectors, and `for`/`id` pairing.

## Don't confuse with
- [Law of Proximity](law-of-proximity.md) — a detached label is *both* a proximity gap and a connectedness gap; cite Connectedness when the fix is a connector or pairing, Proximity when the fix is spacing.

---
Principle catalogued by [Laws of UX](https://lawsofux.com/law-of-uniform-connectedness/) (Jon Yablonski); from Gestalt psychology. Wording here is our own.
