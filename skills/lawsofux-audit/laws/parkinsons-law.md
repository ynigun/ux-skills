# Parkinson's Law

**What it says.** Work stretches to fill whatever time is allowed for it. If the interface permits a task to be slow, it will be.

**Lens:** Heuristics · interaction & decision cost

## Look for
- No smart defaults or autofill that would let users finish faster.
- Flows with no time-saving shortcuts; every task takes as long as the UI allows.
- Missing autocomplete, saved info, or one-tap paths on repeat tasks.

## Verify it from the code
- Check the form for the standard acceleration hooks and report the missing ones by name: `autocomplete` attributes on inputs, `inputmode`, `enterkeyhint`, `type="email"`/`type="tel"` (which summon the right keyboard), and browser autofill-friendly field names.
- Missing or wrong `autocomplete` is the single most common concrete finding here — `autocomplete="off"` on an address or payment field actively blocks the browser from helping.
- Check whether previously-entered data is reused: does the app store and offer the last address, the last project, the most recent selection? Trace whether the value is persisted and then whether it's ever read back as a default.
- Check for keyboard paths on repeated actions: an `Enter`-to-submit handler, a shortcut registry. Their absence is verifiable.
- Look for artificial delays that pad the task: `setTimeout` before showing results, forced multi-step confirmations on trivial actions, mandatory animations that block input.

## Not a violation (check before reporting)
- **Deliberate friction.** Confirmations on destructive or irreversible actions are supposed to slow the user down. Never file those here.
- **`autocomplete="off"` where it's intentional.** One-time codes and some security fields legitimately opt out.
- **Speed claims without a mechanism.** "This flow is slow" is not a finding; "no `autocomplete` on any of the eight address fields" is.
- **Rate limits and cooldowns** that exist for abuse prevention.

## User cost
Tasks expand to fill the time the UI permits. Without acceleration, users spend **more effort than the task requires** — most painfully on tasks they repeat.

## Example
**Before** — checkout re-asks for address every time.
**After** — saved address and autofill complete the task in seconds.

## Fix
Reduce the time a task *can* take: autofill, smart defaults, saved data, and keyboard shortcuts. Make the fast path the default path.

## Don't confuse with
- [Doherty Threshold](doherty-threshold.md) — that's *system* response speed; Parkinson's is the *task completion* time the design permits.

---
Principle catalogued by [Laws of UX](https://lawsofux.com/parkinsons-law/) (Jon Yablonski); after C. Northcote Parkinson (1955). Wording here is our own.
