# Law of Similarity

**What it says.** Elements that look alike are read as the same kind of thing, even when they sit far apart. Shared appearance implies shared behavior.

**Lens:** Gestalt · visual grouping

## Look for
- Links styled like buttons (or vice versa) — falsely grouped as the same kind of thing.
- Unlike things sharing one style; like things styled differently.
- Inconsistent treatment of the same element type across a screen.

## Verify it from the code
This is one of the most reliably checkable laws, because it's about consistency across a set.

- Build an inventory: for each interactive element type, collect the classes or styled-components applied. Two different class sets producing the same visual role, or one class set spanning two different roles, is the finding.
- Check element type against appearance: grep for `<a>` carrying button classes and `<button>` carrying link classes. That mismatch is both a Similarity finding and a semantics/accessibility one — cite it once, note both effects.
- Compare a component's usage across files. The same `<Button variant="primary">` used for the main action in one view and a tertiary action in another is inconsistency you can point to with two file references.
- For status colors, check the mapping is consistent: the same color used for "error" in one component and "warning" in another.

## Not a violation (check before reporting)
- **Intentional variants.** A design system with primary/secondary/ghost buttons is *using* similarity correctly, not violating it. Only flag when the variant doesn't match the role.
- **Different things that happen to share a base class.** Check the full computed appearance, not one shared utility.
- **A single deviation with a stated purpose** — see [Von Restorff](von-restorff-effect.md), where breaking similarity is the point.
- **Cross-theme differences.** Light and dark variants of the same component are not an inconsistency.

## User cost
Shared appearance implies shared function. Mismatches make users **expect the wrong behavior** — clicking a "button" that navigates away, or missing an action that doesn't look actionable.

## Example
**Before** — a text link styled to look like the primary button sits beside it.
**After** — buttons look like buttons; links look like links, consistently.

## Fix
Make elements that share function share appearance, and vice versa. Keep one consistent visual language per element type, and keep the semantic tag matching the role.

## Don't confuse with
- [Von Restorff Effect](von-restorff-effect.md) — Similarity makes a set read as one; Von Restorff makes one item *escape* the set deliberately.

---
Principle catalogued by [Laws of UX](https://lawsofux.com/law-of-similarity/) (Jon Yablonski); from Gestalt psychology. Wording here is our own.
