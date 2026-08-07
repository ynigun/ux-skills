# Hick's Law

**What it says.** Every option added to a choice makes the decision slower. Time-to-decide scales with how many alternatives there are and how hard they are to tell apart.

**Lens:** Heuristics · interaction & decision cost

## Look for
- Long flat menus and `<select>`s with no grouping.
- Action bars with 4+ peer buttons.
- Dense option grids, toolbars, or filter panels shown all at once.
- Onboarding that exposes every setting up front instead of sensible defaults.

## Verify it from the code
You cannot eyeball "too many" — count.

- Count the *rendered* peers, not the source lines: an array of 30 options mapped in a loop is 30 choices; a `<select>` with 8 `<option>`s inside 3 `<optgroup>`s is 3 chunks.
- Grep the component for sibling interactive elements: `<button`, `<option`, `role="menuitem"`, `<a class="...nav`. Count what lands in one visual container.
- Trace where the list comes from. A hardcoded list of 6 is fixed; a list mapped from data can be 6 today and 60 in production — check for a cap, pagination, or search.
- Establish which path is *primary* before judging. An overloaded admin panel used monthly is not the same finding as an overloaded checkout.

## Not a violation (check before reporting)
- **Grouped options.** `<optgroup>`, section headings, or a segmented control already chunk the set — Hick's cost is largely paid. Cite [Chunking](chunking.md) only if the grouping is wrong.
- **Searchable/filterable lists.** A combobox with type-ahead collapses the choice to typing; a 200-item country picker with search is fine.
- **Progressive disclosure already present.** If the extra options live behind "Advanced" or a `<details>`, they aren't on the decision path.
- **Reference lists, not decision lists.** A table of 40 rows the user scans is not 40 competing choices.

## User cost
Each added option lengthens the scan-and-decide time on the *primary* path. The cost is **latency and hesitation**, even when the user eventually picks correctly.

## Example
**Before** — a settings page surfaces 20 toggles in one column.
**After** — 4 common toggles shown; "Advanced" discloses the rest.

## Fix
Reduce, group, or progressively disclose. Highlight the recommended choice so the decision collapses to "accept default or not."

## Don't confuse with
- [Choice Overload](choice-overload.md) — Hick's is about decision *time*; Choice Overload is paralysis/abandonment from too many *comparable* options. Cite the one whose cost you can show.

---
Principle catalogued by [Laws of UX](https://lawsofux.com/hicks-law/) (Jon Yablonski); underlying research: Hick (1952) and Hyman (1953). Wording here is our own.
