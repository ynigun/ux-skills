# Working Memory

**What it says.** The small, short-lived store holding the pieces of information a person is actively using. It is easily overwritten — by a page change, an interruption, or a new screen.

**Lens:** Cognitive load, attention & memory

## Look for
- Information shown on one step but needed on a later one, with no carry-forward.
- Confirmation codes, totals, or selections the user must memorize between screens.
- Wizards that hide prior answers the next step depends on.

## Verify it from the code
This law produces some of the most provable findings available, because "carried forward or not" is a data-flow question.

- Pick each value the user must supply or use on a later step and trace it: is it written to form state, a store, the URL, or storage — and is it *read back and rendered* where it's needed? A value written but never re-displayed is the finding.
- Check what survives navigation. Does going back a step preserve earlier answers, or does the component remount with empty state? Look for state held above the step components versus inside them.
- Check what survives a refresh for long flows: is there persistence (`localStorage`, a server-side draft, URL params) or is everything in memory?
- Two-device and copy-paste cases are concrete: a verification code delivered by email while the form sits on another screen, with no paste-friendly single field.
- Check that summary/review steps render the previously entered values rather than just "Step 1 ✓".

## Not a violation (check before reporting)
- **Values that are re-derivable on screen.** If the data is visible in a sidebar or header throughout, nothing must be memorized.
- **Deliberate re-entry for confirmation.** Asking a user to retype an email or confirm a destructive name is a safeguard, not a memory tax.
- **Assuming state is lost.** Framework state, context providers, and route loaders often preserve values invisibly. Trace it before claiming loss.
- **Server-side sessions** you didn't check.

## User cost
Working memory is small and fragile. Forcing users to **hold data across steps** causes forgetting, back-and-forth navigation, and errors — and any interruption wipes it entirely.

## Example
**Before** — step 3 asks the user to re-enter a code shown only on step 1.
**After** — the code is carried forward and displayed where it's needed.

## Fix
Don't make users remember — show. Persist and surface anything needed later; keep prior choices visible or pre-filled, and make going back non-destructive.

## Don't confuse with
- [Miller's Law](millers-law.md) — Miller's quantifies the limit; Working Memory is the system itself.
- [Chunking](chunking.md) — the technique for fitting more into it.

---
Principle catalogued by [Laws of UX](https://lawsofux.com/working-memory/) (Jon Yablonski); underlying research: Baddeley & Hitch (1974). Wording here is our own.
