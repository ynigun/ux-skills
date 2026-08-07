# Zeigarnik Effect

**What it says.** Unfinished business stays active in mind; finished business is released. Open loops keep pulling attention back.

**Lens:** Cognitive load, attention & memory

**Unit of analysis:** the **flow**. Sweep this lens across every multi-step sequence in your inventory.

## Look for
- No "you have N steps left" / incomplete-profile nudges where they'd help completion.
- Conversely: manufactured or fake incompleteness used to nag (dark pattern).
- Progress that gives no sense of what remains open.

## Verify it from the code
- Check whether genuine incompleteness is even computable: does the model have the fields that would let the app say "2 of 5 done"? If the data exists and nothing renders it, that's the finding.
- Distinguish real from manufactured by reading the completion logic. A "profile 60% complete" meter whose denominator includes optional marketing fields is fabricated incompleteness — and that's a dark pattern you can prove by reading the calculation.
- Check whether a completion indicator can ever reach 100%. A meter with an unreachable maximum is a nag by construction.
- For drafts and abandoned work, check persistence: is unfinished work saved and surfaced on return, or silently discarded? Trace the draft path.
- Check dismissal: can the user permanently dismiss a nudge, or does it return every session?

## Not a violation (check before reporting)
- **Absence of nudges is not automatically a defect.** Plenty of good products don't nag. Only report it where completion genuinely serves the user, and say why.
- **Optional fields shown as optional.** If the UI is honest that the remaining items are optional, there's no manufactured urgency.
- **Recommending engagement mechanics.** Don't turn an audit finding into a growth tactic; this law is at least as often used to justify manipulation as to fix real problems.
- **Streaks and badges** in a product where they're the explicit point.

## User cost
Open loops stay in mind and pull users back to finish. **Failing to surface genuine incompleteness** loses easy completions; **faking it** annoys and erodes trust once noticed.

## Example
**Before** — a half-finished profile gives no hint anything is incomplete.
**After** — a subtle "Profile 60% complete — 2 steps left," counting only fields that actually matter.

## Fix
Surface genuine open tasks honestly, persist unfinished work, and let the meter actually reach completion. Don't fabricate incompleteness.

## Don't confuse with
- [Goal-Gradient Effect](goal-gradient-effect.md) — Goal-Gradient is acceleration toward a *visible finish*; Zeigarnik is the *memory pull* of anything left open.

---
Principle catalogued by [Laws of UX](https://lawsofux.com/zeigarnik-effect/) (Jon Yablonski); underlying research: Zeigarnik (1927). Wording here is our own.
