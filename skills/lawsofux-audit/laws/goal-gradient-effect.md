# Goal-Gradient Effect

**What it says.** Effort and motivation rise as a visible finish line gets closer. The pull is strongest at the end — and absent entirely if the end can't be seen.

**Lens:** Heuristics · interaction & decision cost

**Unit of analysis:** the **flow**. Sweep this lens across every multi-step sequence in your inventory.

## Look for
- Multi-step flows with no progress indicator or step count.
- No sense of "almost done" near completion.
- Loyalty/onboarding progress that starts from absolute zero with no early momentum.

## Verify it from the code
- Establish that a multi-step flow actually exists: find the step state (`step`, `currentStep`, a route per step, a wizard/stepper component) and count the steps from the code, not from a guess.
- Then check whether that step count is ever *rendered*. A `currentStep` variable used only for branching, never displayed, is the citable finding: the flow has steps, the user can't see them.
- Check whether total steps are knowable. A flow whose length depends on branching may legitimately show "Step 3" without "of 5" — say so rather than demanding a number that can't exist.
- For progress meters, read how the percentage is computed. A meter that jumps 0 → 100 with nothing between provides no gradient.

## Not a violation (check before reporting)
- **Short flows.** A two-step confirm doesn't need a stepper. Don't manufacture findings on flows under ~3 steps.
- **Progress shown by other means.** Breadcrumbs, a visible step list in a sidebar, or a persistent checklist all satisfy this — grep before claiming none exists.
- **Single-page forms.** A long form on one screen has a visible end (the scrollbar and the submit button). This law is about *sequences*, not length.
- **Inventing drop-off numbers.** You do not have funnel analytics. Say "no visible progress on a 5-step flow," not "users quit at step 3."

## User cost
Without visible proximity to the goal, motivation stays flat and **drop-off rises** — especially in the middle of long flows.

## Example
**Before** — a 5-step signup with no stepper.
**After** — a progress bar showing "Step 3 of 5"; a pre-filled first step gives early momentum.

## Fix
Show progress, and make the remaining distance feel short. Granting visible early progress (a partly-filled bar) increases follow-through.

## Don't confuse with
- [Zeigarnik Effect](zeigarnik-effect.md) — that's the *memory pull* of an unfinished task; Goal-Gradient is the *acceleration* toward a visible finish line.

---
Principle catalogued by [Laws of UX](https://lawsofux.com/goal-gradient-effect/) (Jon Yablonski); underlying research: Hull (1932), Kivetz et al. (2006). Wording here is our own.
