# Serial Position Effect

**What it says.** In a sequence, the first and last items are the ones that stick. Everything in the middle is remembered and noticed least.

**Lens:** Heuristics · interaction & decision cost

## Look for
- Most-important nav items or actions buried in the middle of a list.
- Button order that puts the safe/expected default last or in the middle.
- Key info placed where it's least remembered (mid-list).

## Verify it from the code
- Read the source order of the items, then check whether CSS reorders them: `flex-direction: row-reverse`, `order:`, `grid-area`, or RTL direction all change what "first" means visually. Source order alone is not enough.
- Establish which item is primary from the code — the one styled as primary, the one that submits the form, the one with the default focus — then report its index in the rendered sequence.
- For navigation, check whether the order is static markup or sorted at runtime. A list sorted by recency has no fixed middle to blame.
- In RTL layouts, confirm which end is the visual start before calling something "first."

## Not a violation (check before reporting)
- **Platform-mandated button order.** OS and framework conventions fix the order of Cancel/OK; deviating would break [Jakob's Law](jakobs-law.md). Don't demand a reorder that fights the platform.
- **Alphabetical or semantically-required order.** A country list, a timeline, or a ranked table has an order the content dictates.
- **Ordering opinions with no cost.** "Settings should come before Help" is a preference unless you can state what it costs. Skip it.
- **Short sets.** With three items there is barely a middle. Reserve this for lists long enough for position to matter.

## User cost
Items in the middle are **least remembered and least noticed**; placing primary actions there reduces recall and discoverability.

## Example
**Before** — the main CTA is the 3rd of 5 equal nav items.
**After** — primary destinations placed first and last; utility items in the middle.

## Fix
Position the most important actions at the start or end of a sequence. Order menus and button rows so weight matches placement.

## Don't confuse with
- [Von Restorff Effect](von-restorff-effect.md) — that's standing out by *contrast*; Serial Position is standing out by *position*.

---
Principle catalogued by [Laws of UX](https://lawsofux.com/serial-position-effect/) (Jon Yablonski); underlying research: Ebbinghaus, later Murdock (1962). Wording here is our own.
