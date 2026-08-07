# Aesthetic-Usability Effect

**What it says.** A design that looks good is judged to work better than it does. Polish buys trust — and hides flaws, including from the people reviewing it.

**Lens:** Heuristics · interaction & decision cost

**Unit of analysis:** the **screen**. Sweep this lens across every rendered view in your inventory.

## Look for
- Raw, unstyled, or visually inconsistent UI that erodes trust before use.
- Conversely: a polished surface that *masks* a real usability problem you should still flag.

## Verify it from the code
For an agent, this law's main job is not to produce findings — it's to stop you trusting a pretty surface.

- Treat it as a **review discipline**: when a component looks well-designed, deliberately re-check its states (empty, error, loading, long content) rather than passing it. Polish correlates with a well-built happy path and neglected edges.
- Where you do report inconsistency, make it concrete: count the distinct font sizes, colors, border radii, or spacing values used for the same class of element. "Six button styles across four components" is verifiable; "looks unpolished" is not.
- Prefer design-token evidence: if the project has tokens or a theme file, grep for hardcoded hex colors and pixel values that bypass them. Those are citable.

## Not a violation (check before reporting)
- **Taste as a finding.** "The design feels dated" is not a finding an audit can defend. Drop it unless you can name a cost.
- **Screenshots you were never given.** If you have only code, don't render an aesthetic verdict at all. Say what you couldn't assess.
- **Intentional minimalism.** Sparse is not unfinished.
- **Using this law to soften real findings.** Never write "but it looks nice" as mitigation for a broken flow.

## User cost
Polish raises perceived usability and trust — and **hides minor usability issues**. Lack of polish makes a usable product *feel* broken; excess polish can lull reviewers into missing real flaws.

## Example
**Before** — a functional form with mismatched fonts and cramped spacing feels untrustworthy at the payment step.
**After** — consistent type, spacing, and color make the same form feel credible.

## Fix
Invest in visual quality to earn trust — but don't let it substitute for fixing real friction. When auditing, separate "feels nice" from "works well," and verify usability under the polish.

## Don't confuse with
- This is a *perception* effect, not a license to skip the other laws — it's the reason a pretty UI can pass review with real flaws intact.

---
Principle catalogued by [Laws of UX](https://lawsofux.com/aesthetic-usability-effect/) (Jon Yablonski); underlying research: Kurosu & Kashimura (1995). Wording here is our own.
