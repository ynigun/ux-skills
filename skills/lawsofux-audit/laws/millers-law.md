# Miller's Law

**What it says.** The number of *unstructured* items a person can hold in mind at once tops out around seven, give or take two. Structure raises the ceiling; raw count does not.

**Lens:** Cognitive load, attention & memory

## Look for
- Long ungrouped lists, menus, or forms (12 fields in one column).
- Data the user must hold across steps because the UI doesn't carry it.
- Tables and number strings shown without chunking.

## Verify it from the code
- Count fields per visual group, not per form. Grep the component for `<input`, `<select`, `<textarea` and check how many fall inside each `<fieldset>`, section heading, or card.
- Look for the grouping markup before counting anything a violation: `<fieldset>`, `<optgroup>`, `role="group"`, section headings, step boundaries in a wizard.
- For "hold across steps," trace the value: is it written to form state / a store / the URL and re-displayed on the later step, or is it only shown once? That trace is the proof.
- If the list is data-driven, check the realistic upper bound, not the fixture. Three items in the seed data can be thirty in production.

## Not a violation (check before reporting)
- **The 7±2 number is not a design rule.** It describes unstructured recall, not how many links a nav may have. Never report "8 items exceeds Miller's Law" as a standalone finding — that is the single most common misuse of this law.
- **Already chunked.** Sections, headings, or steps mean the user holds a handful of groups, not every item.
- **Nothing must be memorized.** A long list that stays on screen while the user works costs scanning (see [Cognitive Load](cognitive-load.md)), not working memory.
- **Scanning ≠ remembering.** A 30-row table the user reads and acts on in place is fine.

## User cost
Beyond ~7±2 units the user must **re-scan and re-hold** information, slowing completion and raising error rates.

## Example
**Before** — a 12-field form in one undifferentiated stack.
**After** — three labeled sections of ~4 fields each.

## Fix
Group related items into a handful of meaningful chunks; carry context forward so nothing must be memorized between steps.

## Don't confuse with
- [Chunking](chunking.md) — Chunking is the *technique*; Miller's Law is the *capacity limit* that motivates it.
- [Working Memory](working-memory.md) — the underlying cognitive system Miller's quantifies.

---
Principle catalogued by [Laws of UX](https://lawsofux.com/millers-law/) (Jon Yablonski); underlying research: Miller (1956). Wording here is our own.
