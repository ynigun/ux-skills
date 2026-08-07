# Von Restorff Effect (Isolation Effect)

**What it says.** In a set of similar things, the one that breaks the pattern is what gets noticed and remembered. Distinctiveness is a finite budget — spend it on one thing.

**Lens:** Cognitive load, attention & memory

**Unit of analysis:** the **object**. Sweep this lens across every domain object in your inventory, checking each of its states and actions.

## Look for
- A primary action that looks like every other button (no emphasis).
- Everything weighted equally, so nothing draws the eye.
- Conversely: a *destructive* action made as prominent as the safe primary, inviting misclicks.

## Verify it from the code
- Identify the intended primary action from behavior — the one that submits, the one bound to `Enter`, the one the flow depends on — then check what visual treatment it gets versus its peers. Same class as everything else is the finding.
- Count how many elements on the screen use the emphasis treatment. Three "primary" buttons in one view means none of them is distinctive; that's countable.
- Check the destructive action's treatment specifically. A delete styled with the same weight as the primary is a Critical candidate — pair it with [Fitts's Law](fittss-law.md) if they're also adjacent.
- Verify emphasis isn't carried by color alone: check for a weight, size, border, or icon difference too. Color-only emphasis fails for color-blind users and in high-contrast modes.

## Not a violation (check before reporting)
- **Deliberately flat secondary rows.** A row of equal-weight filter chips has no primary; not every group needs a standout.
- **Emphasis applied by a variant prop** you didn't trace (`variant="primary"` resolving in the design system).
- **Distinctiveness you can't see.** If you only have source and the emphasis lives in a theme file, read the theme before concluding.
- **Recommending emphasis everywhere.** If you flag three separate elements on one screen as needing to stand out, you've defeated the law.

## User cost
If the key action doesn't stand out, the user **scans every control each time** and may miss it. If a destructive action stands out too much, it gets clicked by mistake.

## Example
**Before** — Save, Cancel, and Reset are identical grey buttons.
**After** — Save is a solid accent button; the rest are quiet secondaries.

## Fix
Make the single most important action visually distinct — by more than color alone — and keep secondary and destructive actions quieter.

## Don't confuse with
- [Law of Similarity](law-of-similarity.md) — Similarity groups a set; Von Restorff deliberately breaks the group for one item.
- [Selective Attention](selective-attention.md) — that's whether users look at that region at all.

---
Principle catalogued by [Laws of UX](https://lawsofux.com/von-restorff-effect/) (Jon Yablonski); underlying research: von Restorff (1933). Wording here is our own.
