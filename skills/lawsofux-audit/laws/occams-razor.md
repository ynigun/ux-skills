# Occam's Razor

**What it says.** Prefer the version with the fewest moving parts that still does the job. In design terms: keep removing elements until removing one more would break something.

**Lens:** Heuristics · interaction & decision cost

**Unit of analysis:** the **object**. Sweep this lens across every domain object in your inventory, checking each of its states and actions.

## Look for
- Redundant controls (two ways to do one thing — a Save button *and* a save link).
- Decorative fields, steps, or options that add no value.
- Visual clutter that doesn't serve a task.

## Verify it from the code
Redundancy is provable; "clutter" is not.

- Find two controls bound to the same handler. Grep the component for repeated handler names or identical dispatch calls — two elements calling `save()` in the same view is a concrete, citable duplicate.
- Check whether a field is ever read. Trace a form field to its submit payload and then to its consumer; a field written to the database and never used anywhere is dead weight the user is paying for.
- Check for steps that collect nothing: a wizard page whose only output is "next" can be merged.
- Count elements against tasks. If a screen has controls that serve no flow you mapped in step 1 of the process, name them individually.

## Not a violation (check before reporting)
- **Deliberate redundancy for discoverability.** A toolbar button plus a keyboard shortcut plus a context-menu item is one action with three affordances — that's good design, not clutter, as long as they behave identically.
- **Elements you can't see a use for.** Absence of understanding is not evidence of uselessness. If you can't trace what something does, say so rather than proposing removal.
- **Minimalism as an end in itself.** Removing a label, a confirmation, or an empty-state hint makes the UI simpler and the product worse.
- **Density in expert tools.** Information density is a feature where the user's job is monitoring.

## User cost
Every extra element adds a **decision and a distraction.** Redundancy creates "are these different?" hesitation for zero benefit.

## Example
**Before** — Save button, "save" text link, and a Reset that's never needed.
**After** — one Save, one Cancel.

## Fix
Analyze each element; remove anything you can take away without breaking the design. Simpler is the default; complexity must justify itself.

## Don't confuse with
- [Tesler's Law](teslers-law.md) — Occam's removes the *unnecessary*; Tesler's relocates the *irreducible*.

---
Principle catalogued by [Laws of UX](https://lawsofux.com/occams-razor/) (Jon Yablonski); attributed to William of Ockham. Wording here is our own.
