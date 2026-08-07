# Flow

**What it says.** The absorbed state where challenge and skill are matched and attention holds itself on the task. Interruptions break it, and it is expensive to re-enter.

**Lens:** Heuristics · interaction & decision cost

## Look for
- Needless interruptions: modals, confirmations, and context switches mid-task.
- Friction spikes that break concentration (a sudden re-login, an unexpected step).
- Mismatch between challenge and skill — too hard frustrates, too trivial bores.

## Verify it from the code
Interruptions are objects in the code; find them and check what gates them.

- Enumerate every interrupting surface: modals, dialogs, toasts that steal focus, `confirm()`, tours, upsell banners, cookie/consent prompts, re-auth prompts. Grep for the modal component, `showModal`, `alert(`, `confirm(`.
- For each, read its trigger condition. A modal fired on a timer or on page count while the user is mid-form is the citable finding; a modal fired by the user's own click is not an interruption.
- Check session/token expiry handling: does an expired token drop the user to login and *lose* unsaved work, or does it refresh silently and preserve state? Trace the 401 handler.
- Check that in-progress work survives interruption at all — is there a draft, autosave, or restored form state? Absence is a strong, concrete finding.
- Check focus behavior: a modal that opens without trapping focus, or that returns focus to the top of the page on close, forces the user to re-find their place.

## Not a violation (check before reporting)
- **User-initiated dialogs.** Opening a picker the user asked for is not an interruption.
- **Required confirmations.** Destructive-action guards protect the user; they belong under a different lens if anywhere.
- **Speculation about boredom or frustration.** "Too easy" and "too hard" aren't assessable from source. Report the interruption, not the emotional state.
- **Necessary re-authentication** before sensitive operations — flag only the *lost work*, not the prompt.

## User cost
Interruptions and friction **break immersion**; the user drops out of the task, loses their place, and may not return. When unsaved work is lost with it, the cost escalates from annoyance to data loss.

## Example
**Before** — a marketing modal interrupts the user mid-checkout.
**After** — no interruptions until the task completes; promos wait for a natural pause.

## Fix
Protect the user's focus: remove avoidable interruptions, preserve in-progress work across them, and restore focus where the user left it.

## Don't confuse with
- [Doherty Threshold](doherty-threshold.md) — latency breaks flow, but Flow is broader: any avoidable interruption, not just slow response.

---
Principle catalogued by [Laws of UX](https://lawsofux.com/flow/) (Jon Yablonski); underlying research: Csíkszentmihályi. Wording here is our own.
