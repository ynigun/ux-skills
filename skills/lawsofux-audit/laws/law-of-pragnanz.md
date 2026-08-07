# Law of Prägnanz

**What it says.** The eye resolves whatever it sees into the simplest structure that fits. Ambiguous visuals get forced into *some* reading — not necessarily the one you intended.

**Lens:** Gestalt · visual grouping

**Unit of analysis:** the **screen**. Sweep this lens across every rendered view in your inventory.

## Look for
- Visually noisy, ambiguous layouts that force interpretation work.
- Complex iconography or illustration where a simple shape would read instantly.
- Layouts that don't resolve to an obvious structure at a glance.

## Verify it from the code
This is the least code-verifiable law in the set. Be correspondingly conservative — most of the time it should produce no finding at all.

- Where you do use it, anchor it in structure you can count: nesting depth of layout containers, number of distinct regions competing on one screen, or a grid whose columns change meaning between rows.
- Ambiguous alignment is checkable: elements in the same visual column with different `padding`/`margin` origins don't line up, which is what makes a layout feel unresolved.
- If you have a screenshot, use it — this law is genuinely a visual judgment, and reading it from source is close to guessing. Say which artifact you assessed.
- Prefer citing a more specific law when one fits. Almost every real "this looks confusing" resolves to [Proximity](law-of-proximity.md), [Common Region](law-of-common-region.md), [Similarity](law-of-similarity.md), or [Cognitive Load](cognitive-load.md).

## Not a violation (check before reporting)
- **"Looks cluttered" with nothing behind it.** Without a countable structural claim, this is taste. Drop it.
- **Icon-style opinions.** Whether an illustration is too detailed is not auditable from code.
- **Deliberate visual richness** in marketing or editorial surfaces, where the goal isn't instant parsing.
- **Using this law as a catch-all** when a more specific Gestalt law names the actual defect — that's a sign you haven't identified the real problem.

## User cost
The eye resolves complexity to the simplest reading it can. Ambiguous visuals make that resolution **slow and effortful**, or push the user to the *wrong* simplest reading.

## Example
**Before** — an ornate, busy diagram of a 3-step process.
**After** — three clean numbered blocks the eye parses immediately.

## Fix
Reduce visual complexity so the intended structure *is* the simplest interpretation. Favor clean, regular, recognizable forms.

## Don't confuse with
- [Cognitive Load](cognitive-load.md) — Prägnanz is specifically about *visual form* resolving to simplicity; Cognitive Load is the broader mental effort across content, interaction, and memory.

---
Principle catalogued by [Laws of UX](https://lawsofux.com/law-of-pr%C3%A4gnanz/) (Jon Yablonski); from Gestalt psychology. Wording here is our own.
