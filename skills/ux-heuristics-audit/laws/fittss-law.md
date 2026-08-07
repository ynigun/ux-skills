# Fitts's Law

**What it says.** How long it takes to hit a target depends on how far away it is and how big it is. Small and far is slow and error-prone; large and close is fast.

**Lens:** Heuristics · interaction & decision cost

**Unit of analysis:** the **screen**. Sweep this lens across every rendered view in your inventory.

## Look for
- Small touch/click targets (below ~44px on touch).
- Primary actions placed far from where the eye or hand already is.
- A destructive control packed tight against a common one (misclick risk).
- Tiny icon-only buttons, dense action rows, narrow hit areas.

## Verify it from the code
This is the one law you can often check numerically without rendering.

- Read the *computed* target size, not the icon size: padding and line-height usually make the hit area bigger than the glyph. A 16px icon with `padding: 12px` is a 40px target.
- Grep the stylesheet for explicit small sizing on interactive elements: `width:\s*(1[0-9]|2[0-9])px`, `height:\s*(1[0-9]|2[0-9])px`, `padding:\s*[0-4]px` on `button`/`a`/`[role="button"]`.
- Check whether the label is inside the hit area. A `<label for>` paired with its input roughly doubles the target; a detached `<span>` does not.
- For spacing between a destructive and a safe action, read the gap: `gap`, `margin`, or gridratio between the two buttons in the same row.
- If a headless browser is available, measure `getBoundingClientRect()` — that settles it. See the sibling `auditing-responsive-layout` skill's probe for the harness.

## Not a violation (check before reporting)
- **Padding you didn't account for.** The most common false positive. Compute the full box before calling a target small.
- **Guarded destructive actions.** If Delete opens a confirm dialog or requires typing a name, proximity is far less costly — note it as Minor at most.
- **Pointer-only surfaces.** A dense desktop toolbar behind a `@media (pointer: fine)` query isn't subject to the 44px touch guideline.
- **Full-row click targets.** A list row where the whole row is clickable is a large target even though the visible label is small.

## User cost
Small or distant targets are **slower and error-prone** to hit. Next to a destructive action, that's a misclick that loses work.

## Example
**Before** — 11px "Delete account" wedged between Save and Cancel.
**After** — large primary Save; Delete moved to a separate, spaced "Danger zone."

## Fix
Enlarge interactive targets, increase spacing, and isolate destructive actions. Put frequent actions near the user's likely cursor/thumb position.

## Don't confuse with
- [Von Restorff Effect](von-restorff-effect.md) — that's whether the action stands out *visually*; Fitts's is whether it's *easy to hit*.

---
Principle catalogued by [Laws of UX](https://lawsofux.com/fittss-law/) (Jon Yablonski); underlying research: Fitts (1954). Wording here is our own.
