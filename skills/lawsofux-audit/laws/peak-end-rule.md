# Peak-End Rule

**What it says.** Memory of an experience is assembled from its most intense moment and its final moment — not from an average of everything that happened.

**Lens:** Heuristics · interaction & decision cost

## Look for
- Flows that end on a raw error, a dead-end, or an anticlimax instead of confirmation.
- No moment of delight or reassurance at the most important step.
- Painful peaks (a confusing payment step, a jarring error) left unsoftened.

## Verify it from the code
The *end* of a flow is fully verifiable; the *peak* requires judgment, so lead with the end.

- Find the terminal branch of the flow: what happens after the final success? Grep for the post-submit path — a redirect, a `navigate()`, a toast, a success view. A redirect to a bare index page with no confirmation is a concrete finding.
- Check the failure ending too, and read what the user is actually shown. A `catch` that renders `err.message` puts a raw exception string at the most-remembered moment.
- Check whether the ending carries what the user needs next: reference number, receipt, what happens now, how to undo. Read the success component and list what it renders.
- For the peak, prefer the step you can *prove* is hardest — the one with the most validation rules, the most fields, or the most error branches — over a guess.

## Not a violation (check before reporting)
- **Judging tone from code.** You can verify that a confirmation exists and what it contains; you can't verify that it "feels" delightful. Report the missing element, not the missing emotion.
- **A confirmation you didn't find.** Success states are often separate components or routes. Search before asserting absence.
- **Emotional adjectives as findings.** "The ending is anticlimactic" is not actionable. "Success redirects to the dashboard with no order reference" is.
- **Deliberately quiet endings.** An autosave that ends silently is correct; not every action deserves a celebration.

## User cost
The overall memory of the product is dominated by its **worst moment and its last moment**. A great flow that ends badly is remembered as bad.

## Example
**Before** — successful purchase dumps the user on a blank page.
**After** — a clear confirmation with order summary and next step.

## Fix
Design the peak and the ending deliberately: confirm success concretely, recover gracefully from the hardest moment, and end every flow on a resolved note.

## Don't confuse with
- [Goal-Gradient Effect](goal-gradient-effect.md) — that's motivation *during* a flow; Peak-End is the *memory* of it afterward.

---
Principle catalogued by [Laws of UX](https://lawsofux.com/peak-end-rule/) (Jon Yablonski); underlying research: Kahneman et al. (1993). Wording here is our own.
