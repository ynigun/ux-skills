# Law of Common Region

**What it says.** Anything enclosed by a shared boundary reads as one group — a border, a card, a panel, a tinted background. Enclosure is a stronger grouping signal than spacing alone.

**Lens:** Gestalt · visual grouping

**Unit of analysis:** the **screen**. Sweep this lens across every rendered view in your inventory.

## Look for
- No card, border, or background separating distinct groups.
- Sections that bleed together with nothing enclosing them.
- A `<fieldset>`-worthy group rendered as a flat list of rows.

## Verify it from the code
- Look for the enclosure primitives before claiming they're absent: `border`, `background`, `box-shadow`, `outline`, a `<fieldset>`, a card component, or a utility class like `rounded-lg border`. Grep the component and its wrapper — the boundary is often applied one level up.
- Check the semantic counterpart too: `<fieldset>` with `<legend>`, `role="group"`, `aria-labelledby`. A visual group with no semantic group is a real finding for screen-reader users even when it looks fine.
- Where groups exist, check they're *distinguishable*: two adjacent cards with the same background as the page and no border are visually one region.
- For a flat list of settings rows, check whether headings exist in the markup at all — a `<h3>` between groups is a weaker but real boundary.

## Not a violation (check before reporting)
- **Spacing that already does the job.** Generous whitespace between groups can group adequately; requiring a border everywhere produces a boxy, over-segmented UI. Cite this law when spacing alone has proven ambiguous, not reflexively.
- **Deliberately borderless design systems.** Many modern systems group with typography and space by design. Judge whether the grouping *reads*, not whether a border exists.
- **Nested cards.** A card inside a card inside a card is over-application of this law — don't recommend adding one.
- **A boundary applied by a parent component** you didn't open.

## User cost
Without a boundary, distinct groups read as **one undifferentiated mass**, even when spacing is okay. The user can't tell where one section ends and the next begins.

## Example
**Before** — payment and profile fields in one flat list.
**After** — each group wrapped in its own bordered card, with a `<fieldset>`/`<legend>` pairing for assistive tech.

## Fix
Enclose related elements in a shared region (card, panel, fieldset, background), and mirror it semantically.

## Don't confuse with
- [Law of Proximity](law-of-proximity.md) — Proximity uses *distance*; Common Region uses an explicit *container*. Use Common Region when groups stay ambiguous despite reasonable spacing.

---
Principle catalogued by [Laws of UX](https://lawsofux.com/law-of-common-region/) (Jon Yablonski); from Gestalt psychology. Wording here is our own.
