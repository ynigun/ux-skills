# Cognitive Load

**What it says.** The total mental effort a person must spend to make sense of an interface and act in it. Effort spent decoding the UI is effort not spent on the task.

**Lens:** Cognitive load, attention & memory

## Look for
- Jargon, unexplained abbreviations, raw IDs shown to users.
- Dense screens with no hierarchy; everything competing at once.
- Math or lookups the UI could do for the user.
- Information that must be held in the head across steps (extraneous load).

## Verify it from the code
"Too much" is not a finding. Name the specific thing the user must decode.

- Hunt for raw machine values reaching the UI: UUIDs, enum constants (`STATUS_PENDING_REVIEW`), epoch timestamps, byte counts, error codes, database column names used as labels. Grep the templates for values rendered without a formatter or a translation lookup. Each one is concrete and citable.
- Check for unexplained abbreviations in labels and headers, and check whether a tooltip or helper text exists nearby.
- Look for computation left to the user — values displayed as components with no total, or units the user must convert.
- Check hierarchy structurally: does the view use heading levels and sections, or is it a flat run of equal-weight elements? Count `<h*>` usage and section boundaries.
- Check the empty and error states, which are where load usually spikes: an error that renders a stack trace or a raw API message is a clear finding.

## Not a violation (check before reporting)
- **Domain vocabulary for a domain audience.** Medical, legal, financial, and developer tools use precise terms their users know. Don't flag correct terminology as jargon.
- **Density in monitoring interfaces.** A dashboard whose job is comparison is supposed to be dense.
- **"Feels overwhelming"** with no specific element named. If you can't point at what to change, there's no finding.
- **IDs deliberately shown** — support reference numbers and order IDs are meant to be visible and copyable.

## User cost
Every unit of unnecessary mental effort **slows comprehension and raises errors and abandonment.** The budget spent decoding the UI isn't spent on the task.

## Example
**Before** — a checkout shows a pre-tax subtotal and makes the user add tax and shipping mentally.
**After** — the UI computes and shows the final total.

## Fix
Cut extraneous load: plain language, clear hierarchy, do the computation, carry context forward, and format machine values for humans.

## Don't confuse with
- [Working Memory](working-memory.md) / [Miller's Law](millers-law.md) — those are the *capacity limit*; Cognitive Load is the *total demand* placed against it.

---
Principle catalogued by [Laws of UX](https://lawsofux.com/cognitive-load/) (Jon Yablonski); underlying research: Sweller (1988). Wording here is our own.
