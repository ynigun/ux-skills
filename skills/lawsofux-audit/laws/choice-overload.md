# Choice Overload

**What it says.** Past a certain number of comparable options, people stop choosing altogether. The failure isn't a slow decision — it's no decision.

**Lens:** Heuristics · interaction & decision cost

## Look for
- Pricing tables with many near-identical tiers.
- "All plans / all products" grids with no recommended pick.
- Endless filter/sort permutations with no smart default.
- Configuration where every option looks equally weighted.

## Verify it from the code
The distinguishing feature is *comparability*, and that is judgeable from the data, not the count.

- Read what differentiates the options. Four plans differing on one axis (seats) are easy; four differing on six overlapping axes are the overload case. Open the data/config that defines them.
- Look for the presence or absence of an anchor: grep for `recommended`, `popular`, `default`, `featured`, `highlighted`, `isDefault` in the option data or markup. No anchor is the concrete, citable defect.
- Check whether a default is preselected in the form state (`defaultValue`, `checked`, initial store value). "Nothing is selected on load" is verifiable; "too many plans" is not.
- Distinguish a decision set from a browse set in the code path: does picking one submit a form / advance a flow? If it just navigates to detail, it's browsing.

## Not a violation (check before reporting)
- **A recommended option already exists.** If one tier is marked and preselected, the paralysis is largely resolved.
- **Options that aren't comparable.** A list of 40 distinct help articles is not 40 competing choices.
- **Filter/sort surfaces with sane defaults.** Many available filters are fine when the unfiltered default view is useful.
- **Counting instead of showing cost.** "12 options" alone is not a finding. Say what the user fails to do.

## User cost
Too many *comparable* options causes **paralysis and abandonment** — the user defers or leaves rather than choosing. Worse than Hick's latency: the decision may not happen at all.

## Example
**Before** — 12 plan tiers in one dropdown.
**After** — 3 tiers with one marked "Most popular," plus a monthly/annual toggle.

## Fix
Cut the option count, mark a recommended default, and stage rare options behind "More." Anchoring one choice removes most of the paralysis.

## Don't confuse with
- [Hick's Law](hicks-law.md) — that's decision *time*; this is decision *avoidance*.

---
Principle catalogued by [Laws of UX](https://lawsofux.com/choice-overload/) (Jon Yablonski); underlying research: Iyengar & Lepper (2000). Wording here is our own.
