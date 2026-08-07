# Pareto Principle

**What it says.** A small share of causes produces most of the effect — the familiar 80/20 framing. A few features carry most of the use.

**Lens:** Heuristics · interaction & decision cost

## Look for
- The primary path given equal visual weight to rare actions.
- Effort spread evenly across features instead of concentrated on the few that drive most use.
- Common tasks buried behind the same number of clicks as edge cases.

## Verify it from the code
The trap here is that you do not have usage data. Use structural evidence instead.

- Derive "primary" from the code, not from intuition: the default route, the landing view after login, the action bound to the submit/primary button, the path with the most tests or the most error handling.
- Count interaction steps per task by tracing the routes and handlers. "Export to CSV and Save are both two clicks from the same menu" is verifiable and neutral about which matters more.
- Look for equal styling across unequal actions: the same button class applied to the everyday action and the rare one.
- If the project has analytics, telemetry event names, or a feature-flag config, read it — that's the closest thing to real usage evidence available from the repo.

## Not a violation (check before reporting)
- **Inventing percentages.** Never write "80% of users do X" unless you read it somewhere real. Say "the primary path, judged by the default route" and state your basis.
- **Guessing which feature matters.** If the code gives you no signal about priority, this law yields no finding on that screen. Skip it.
- **Deliberate parity.** Some products intentionally treat features equally; a platform or a toolkit may have no single primary path.
- **Confusing rare with unimportant.** An account-deletion flow is rare and must still be reachable and correct.

## User cost
When the vital few aren't prioritized, **most users pay friction on their most common task** so that rare cases can look equal.

## Example
**Before** — "Export to obscure format" sits beside "Save" with identical prominence.
**After** — Save is primary; rare exports live under a "More" menu.

## Fix
Identify the small set of features driving most use and optimize those relentlessly. Give the common path the most prominence and the least friction.

## Don't confuse with
- [Hick's Law](hicks-law.md) — Hick's is about *how many options* a screen shows; Pareto is about *where to invest effort and prominence* across them.

---
Principle catalogued by [Laws of UX](https://lawsofux.com/pareto-principle/) (Jon Yablonski); after Vilfredo Pareto. Wording here is our own.
