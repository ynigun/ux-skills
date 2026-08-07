# Doherty Threshold

**What it says.** When a system answers within roughly 400ms, neither side is left waiting and the work feels continuous. Past that, the user notices the machine.

**Lens:** Heuristics · interaction & decision cost

**Unit of analysis:** the **flow**. Sweep this lens across every multi-step sequence in your inventory.

## Look for
- No loading, skeleton, or optimistic state on actions that take time.
- Blocking spinners with no progress sense.
- No acknowledgement on submit (did it work?).
- Perceptible lag on typing, hover, or navigation.

## Verify it from the code
You almost never have real timings, so audit the *feedback*, not the latency — that part is fully verifiable.

- For each async action, find the `await`/`.then` and ask what renders between call and resolution. Grep for the state flag: `isLoading`, `pending`, `submitting`, `busy`, `isFetching`. A mutation with no such flag is a citable finding.
- Check that the flag is actually *bound to the UI*, not just set. A `loading` variable that no template reads is the sharper bug.
- Check the error path too: many handlers set `loading = true` and only clear it on success, leaving a permanent spinner on failure. Look for `finally`.
- Flag operations that are *inherently* slow from their shape — an N+1 in a loop, a full-table read, an unindexed lookup, a sequential chain of awaits that could be `Promise.all`.
- Only claim a specific duration if you have a measurement (a trace, a log, a benchmark). Otherwise say "no feedback during an unbounded await."

## Not a violation (check before reporting)
- **Fabricated timings.** Never assert "this takes 2 seconds" from reading code. State the missing feedback instead.
- **Optimistic UI.** If the interface updates immediately and reconciles later, there is nothing to wait on — that's the fix already applied.
- **Feedback that isn't a spinner.** A disabled button, a skeleton, a progress bar, or an inline status all satisfy this. Grep for `disabled` bound to the pending flag before claiming silence.
- **Genuinely long jobs.** A 30-second export isn't a Doherty violation if it shows progress and stays cancellable.

## User cost
Feedback slower than ~400ms breaks the sense of direct manipulation: the user **doubts, re-clicks, or abandons**.

## Example
**Before** — Save button does nothing visible for 2s, then the page reloads.
**After** — button shows a spinner immediately, then a success toast.

## Fix
Acknowledge every action within 400ms — optimistic UI, skeletons, progress indicators. If real work is slow, show progress; perceived speed matters as much as actual speed. Also guard against double-submit by disabling the control while pending.

## Don't confuse with
- [Flow](flow.md) — Doherty is about *system response latency*; Flow is about *not interrupting* the user's concentration.

---
Principle catalogued by [Laws of UX](https://lawsofux.com/doherty-threshold/) (Jon Yablonski); underlying research: Doherty & Thadhani (1982). Wording here is our own.
