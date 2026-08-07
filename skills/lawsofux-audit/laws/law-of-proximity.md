# Law of Proximity

**What it says.** Things placed close together are read as belonging together. Distance is not decoration — it carries meaning whether you intend it or not.

**Lens:** Gestalt · visual grouping

## Look for
- Related fields placed far apart; unrelated fields adjacent.
- A label detached from its control by wide spacing.
- Help text floating away from the input it describes.

## Verify it from the code
Spacing is one of the few visual properties you can read directly.

- Read the actual spacing values between siblings — `gap`, `margin-block`, `space-y-*` utilities — and compare *within* a group against *between* groups. The defect is when they're equal or inverted: uniform `gap: 16px` across a form gives every field the same apparent relatedness.
- Check DOM adjacency against visual adjacency: absolute positioning, `order`, and grid placement can put related markup far apart on screen. Read the layout rules, not just the tree.
- For labels, check the pairing directly: is there a `<label for>`/`id` link, or is the label a floating `<span>`? A detached label is both a proximity and a [Uniform Connectedness](law-of-uniform-connectedness.md) finding, and the `for`/`id` version is provable.
- Check error text placement: is the message rendered inside the field's container, or appended at the form level far from the input that failed?

## Not a violation (check before reporting)
- **Grouping achieved another way.** A card, border, or background already groups the items — see [Common Region](law-of-common-region.md). Uniform spacing inside a bordered card is fine.
- **Spacing you assumed.** Don't report a gap you didn't read a value for. Tailwind-style utilities and design tokens make this checkable; guessing does not.
- **Responsive differences.** A layout that groups correctly at one breakpoint may not at another — say which breakpoint, or verify both.
- **Single-column forms with consistent rhythm** where every field is genuinely peer-level. Not everything needs subgroups.

## User cost
Spacing *is* meaning. When distance contradicts relationship, the user **mis-reads what belongs together** and re-scans to reconstruct the structure.

## Example
**Before** — First name, Card number, Last name interleaved in one stack.
**After** — name fields grouped tightly; payment fields grouped separately, with whitespace between groups.

## Fix
Use spacing to encode relationship: tighten related items, separate unrelated groups. Distance should match meaning.

## Don't confuse with
- [Law of Common Region](law-of-common-region.md) — Proximity groups by *distance*; Common Region groups by a *shared boundary*. Items can be close yet still need a boundary, or far apart yet share a region.

---
Principle catalogued by [Laws of UX](https://lawsofux.com/law-of-proximity/) (Jon Yablonski); from Gestalt psychology. Wording here is our own.
