# Tesler's Law (Conservation of Complexity)

**What it says.** Every system carries a floor of complexity that can't be designed away. It can only be moved — absorbed by the product, or handed to the user.

**Lens:** Heuristics · interaction & decision cost

## Look for
- Inherent complexity pushed onto the user instead of handled by the system ("configure your account in one step" that's really four).
- Manual steps the system could do (compute totals, infer country from ZIP, default the obvious).
- A "simple" UI that's simple for the builder, complex for the user.

## Verify it from the code
The test is whether the system *already has* what it's asking for. That is checkable.

- For each user-supplied value, search whether the data exists server-side. If the app can derive it (city from postcode, currency from locale, timezone from the browser, tax from the address) and still asks, that's a citable finding.
- Look for required fields with no default where a sensible default is computable: grep for `required` in schemas and forms, then check whether a default could come from existing state.
- Look for arithmetic left to the user — a UI that shows components but not the total. Grep the template for the parts and check whether the sum is rendered anywhere.
- Check for repeated entry across a session: the same value asked twice in one flow means the first answer wasn't carried. Trace the state between steps.

## Not a violation (check before reporting)
- **Complexity that must be explicit.** Legal consent, destructive confirmations, and payment amounts should be user-affirmed, not inferred. Don't "simplify" these.
- **Inference the system can't reliably make.** Guessing wrong on the user's behalf is worse than asking. If the derivation is ambiguous, asking is the right design.
- **Power-user surfaces.** An advanced configuration screen is allowed to be complex for the audience that wants control.
- **"Just make it simpler" with no target.** Name what the system should absorb and where the data comes from, or it isn't a finding.

## User cost
Irreducible complexity doesn't vanish — **someone absorbs it.** When it's dumped on the user, every session pays the tax.

## Example
**Before** — user must hand-enter tax, shipping, and totals.
**After** — system computes them; user confirms.

## Fix
Move as much complexity as possible into the system. What can't be removed, the product should carry — not the user.

## Don't confuse with
- [Occam's Razor](occams-razor.md) — Occam's removes *unnecessary* elements; Tesler's relocates *necessary* complexity to the right side.

---
Principle catalogued by [Laws of UX](https://lawsofux.com/teslers-law/) (Jon Yablonski); attributed to Larry Tesler. Wording here is our own.
