# Jakob's Law

**What it says.** People arrive with habits formed on every other product they already use, and expect yours to behave the same way. Familiarity is borrowed from elsewhere, not built here.

**Lens:** Heuristics / Mental models · expectation

**Unit of analysis:** the **object**. Sweep this lens across every domain object in your inventory, checking each of its states and actions.

## Look for
- Reinvented navigation, controls, or gestures with no convention behind them.
- Non-standard icon meanings (a heart that archives, a trash that exports).
- Placeholder/junk nav labels ("Stuff", "Things").
- A checkout/settings/search flow that ignores how the category's leaders do it.

## Verify it from the code
This law is about convention, which an agent reasons about rather than measures. Guard against asserting a "convention" that is really just your own preference.

- Name the convention and where it comes from before citing it — "cart icon opens the cart in every major storefront" is checkable; "users expect a sidebar here" is an opinion.
- Read the icon's handler, not the icon. Grep the component for the `onClick`/`on:click` bound to the icon and confirm what it actually does before claiming a mismatch.
- Check the whole set for internal consistency too: if the same icon means two different things on two screens, that's the stronger, verifiable finding.
- Prefer conventions with a written source (a platform HIG, an ARIA authoring pattern) over "everyone knows."

## Not a violation (check before reporting)
- **Deliberate, signposted deviation.** A novel interaction that ships with an inline hint or a first-run coach mark has paid for itself; downgrade or drop.
- **Domain conventions you don't know.** Professional tools (DAWs, CAD, trading terminals, IDEs) have their own long-standing conventions that look wrong to a generalist. Don't impose consumer-web norms on them.
- **Your training data is stale.** Conventions shift. If your only evidence is "products used to do X," say so or drop the finding.
- **Tooltips/labels present.** An unusual icon with a visible text label is far less costly — Minor, not Major.

## User cost
Users act on patterns learned elsewhere. Breaking convention forces **relearning**, producing errors and distrust at the exact moment they expected familiarity.

## Example
**Before** — cart icon opens settings; settings gear opens the cart.
**After** — icons match universal conventions; current page marked active.

## Fix
Match established conventions for the pattern unless you have strong evidence a deviation helps. Reserve novelty for where it adds real value.

## Don't confuse with
- [Mental Model](mental-model.md) — Jakob's is about *cross-product* conventions; Mental Model is the user's internal model of *this* system.

---
Principle catalogued by [Laws of UX](https://lawsofux.com/jakobs-law/) (Jon Yablonski); attributed to Jakob Nielsen. Wording here is our own.
