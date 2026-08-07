# Paradox of the Active User

**What it says.** People skip the documentation and start pressing things immediately — even when reading first would genuinely be faster. Anything that depends on being read first will be missed.

**Lens:** Mental models & expectation

**Unit of analysis:** the **screen**. Sweep this lens across every rendered view in your inventory.

## Look for
- Onboarding that assumes the docs/tour were read.
- Empty states with no inline guidance on what to do next.
- Features discoverable only via help pages, not the UI itself.
- Tooltips/manuals carrying load that the interface should carry.

## Verify it from the code
Empty states are the concrete, checkable expression of this law.

- Find every list, table, and dashboard, then find its zero-item branch. Grep for `length === 0`, `isEmpty`, `.length ? ... :`, or an `EmptyState` component. A list that renders nothing when empty — no message, no next action — is a citable finding.
- Check that the empty state contains an *action*, not just prose. "No projects yet" with no create button leaves the user stuck.
- Check first-run: is there any inline affordance, or does the product rely on a tour that can be dismissed and never seen again? Look for whether the tour's completion flag gates the only explanation of a feature.
- Check whether required knowledge lives only in `title`/tooltip attributes, which never appear on touch devices. Grep for `title=` carrying instructions rather than labels.
- Check error recovery text: does the message say what to do, or only what went wrong?

## Not a violation (check before reporting)
- **A tour existing is not the defect.** Tours are fine as a supplement. The finding is when the tour is the *only* explanation.
- **Empty states you didn't find.** They're often separate components — search by name before asserting absence.
- **Expert tools with real manuals.** Professional software legitimately expects training; scale the finding to the audience.
- **Demanding onboarding everywhere.** Adding a coach mark to every feature is its own [Cognitive Load](cognitive-load.md) problem.

## User cost
Users jump straight in and skip instructions. Anything that **depends on reading first** gets missed — they get stuck, err, or never discover the feature at all.

## Example
**Before** — a blank dashboard with a "read the guide" link.
**After** — an empty state that names what goes here, with a primary action to create the first one.

## Fix
Make the interface self-evident: inline affordances, actionable empty states, and contextual hints exactly where needed. Assume nothing was read.

## Don't confuse with
- [Jakob's Law](jakobs-law.md) — leaning on conventions *helps* the active user; this law is specifically about not relying on documentation.

---
Principle catalogued by [Laws of UX](https://lawsofux.com/paradox-of-the-active-user/) (Jon Yablonski); underlying research: Carroll & Rosson (1987). Wording here is our own.
