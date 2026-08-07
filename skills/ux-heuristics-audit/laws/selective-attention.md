# Selective Attention

**What it says.** Attention locks onto whatever seems relevant to the current goal and filters the rest out of awareness entirely — not skimmed, not seen.

**Lens:** Cognitive load, attention & memory

**Unit of analysis:** the **screen**. Sweep this lens across every rendered view in your inventory.

## Look for
- Important notices styled like ads/banners (users banner-blind them).
- Critical CTAs placed in regions users learn to ignore (sidebars, far corners).
- Key messages competing with louder decorative elements.

## Verify it from the code
The verifiable version of this law is "does the important message look like the ignorable ones."

- Compare the styling of a critical message against the promotional ones in the same codebase. If the security warning and the marketing banner share a component or a class, that's a concrete finding with two file references.
- Check placement structurally: is the message rendered in a top banner slot, a sidebar, or inline in the user's task path? Read where the component mounts in the layout.
- Check whether the message is dismissible and whether dismissal persists. A critical alert that a user can permanently hide, stored in `localStorage`, will be invisible on the visit that matters.
- Check timing: a message rendered before the content it refers to has loaded, or one that auto-dismisses on a timer, may never be read. Look for `setTimeout`-based dismissal on important notices.

## Not a violation (check before reporting)
- **Claiming to know where users look.** You have no eye-tracking. Anchor the finding in the styling/placement similarity you can show, not in an assertion about gaze.
- **Blocking alerts.** A modal or an inline blocker cannot be missed; this law doesn't apply.
- **Ad-like styling on actual ads.** That's correct.
- **"Users will ignore this"** as a bare prediction. Say what it shares with the things that get ignored.

## User cost
Users tune out anything that looks goal-irrelevant — including **important content shaped like noise.** A warning that looks like a promo gets no reader at all.

## Example
**Before** — a security alert rendered with the same banner component as marketing promos.
**After** — the alert sits inline in the user's focal path, styled distinctly, and isn't permanently dismissible.

## Fix
Place critical information in the user's focal path, style it unlike ad/banner patterns, and don't let it be dismissed away permanently.

## Don't confuse with
- [Von Restorff Effect](von-restorff-effect.md) — that's making one item *stand out within* what's being viewed; Selective Attention is about which regions get looked at at all.

---
Principle catalogued by [Laws of UX](https://lawsofux.com/selective-attention/) (Jon Yablonski); related research: Simons & Chabris (1999). Wording here is our own.
