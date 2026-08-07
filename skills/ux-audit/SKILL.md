---
name: ux-audit
description: Audit a web/app feature end-to-end for UX bugs using OOUX + Lifecycle Trace + Visual Contract. Finds state-machine traps, CSS cascade bugs, i18n/RTL issues, missing reverse-actions, and race conditions. Trigger when the user says "audit the UX", "find UX bugs", "review this feature end-to-end", "why does X feel broken", or names a route/screen to review.
---

# UX Audit

Systematic end-to-end audit methodology. Use when a user asks you to find UX bugs in a feature, screen, or route — not quick fixes, the real underlying bugs.

## Core principle

**Depth over breadth.** Grep/checklist passes miss the bugs that matter: state-machine traps, CSS cascade collisions, reverse-action gaps, race conditions. Trace the user's path through the code, don't sample it.

**Verify every "critical" claim.** Before labeling anything a bug, open the code and confirm. Pattern-matching produces false criticals that destroy the user's trust in the whole report.

## Working as an LLM auditor

- **Cite or demote.** Every finding carries a `file:line`. One that names no location cannot be acted on, and that is the most common complaint from engineers receiving machine-generated reports.
- **Search before declaring anything absent.** "No validation here" when the validator lives one file away is the characteristic false positive. Search several spellings and check the layer above. This matters most for soft deletes: look for `deleted_at`, a status field, a trash route or a restore endpoint before calling an action irreversible — that is the most common false Critical in this whole audit.
- **Don't drop what you couldn't verify — demote it.** Unconfirmed items go to a **Suspected — unverified** list with the check that would settle each. Deleting them protects precision at the cost of recall you can't afford.
- **Never invent measurements or feelings.** No timings, no abandonment rates, and no "users will find this confusing." Report the missing mechanism, not a number or an emotion you don't have.
- **Finding nothing is a valid result.** As a codebase improves there is less to find, and the instinct is to manufacture findings to fill the report. A long list is a warning sign, not coverage.
- **Say what you didn't cover.** Close with a **Not assessed** list. A named gap is recoverable; a silent one isn't.

Background and sources: [`research-notes.md`](../ux-heuristics-audit/references/research-notes.md).

## Method: three layers

Every object in the feature gets examined through all three layers. If you only do one, you miss most of the bugs.

### 1. OOUX (Object-Oriented UX)

For each domain object in the feature — whatever the product's nouns are — fill in:

| Object | CTAs | States | Relationships |
|--------|------|--------|---------------|
| Order  | place, pay, ship, cancel, refund, archive | draft, placed, paid, shipped, cancelled, refunded | belongs-to Customer, has-many LineItems |

Then sweep:
- Every (state × CTA) cell — is the action valid in that state? Is it blocked in the UI?
- Every state — is there a path back? (**Terminal states are the #1 trap** — a "Cancelled" with no reinstate, a "Deleted" with no restore.)
- Every relationship — does deleting A leave orphan Bs? Does archiving the parent hide children it shouldn't?

### 2. Lifecycle Trace

Follow each *attribute* of each object from the moment it's written to every place it's read. Follow the exact code path — don't guess.

- **Creation**: where's the row inserted? What defaults are set? What validators run?
- **Every mutation**: every UPDATE/SET. What triggers it? What's the transaction boundary?
- **Every read**: every SELECT. What filter is applied? Does the filter drop rows that shouldn't be dropped?
- **Display**: where does the value land in the DOM? Is it escaped/sanitized? Does it get re-parsed client-side?
- **Terminal fates**: is the row ever hard-deleted? Soft-deleted? Archived? Can it come back?

This layer catches: partial commits, orphan rows, stale reads, silent truncation (a `LEFT(col, n)` in a list query that the detail view doesn't apply), timezone drift, JSON-array-stringified-as-string bugs.

### 3. Visual Contract

CSS + rendering + i18n. Read the **central stylesheet** (app.css, global.css, whatever the project uses) before claiming visual bugs — most visual "bugs" are cascade collisions, not per-component.

Sweep:
- **Cascade collisions**: `.prose pre { background:#1a1a2e }` wins over per-component styles silently. Grep the central styles for anything that targets generic tags (`pre`, `blockquote`, `code`).
- **RTL/LTR**: physical properties (`padding-left`, `border-right`, `text-align:left`) leak through to the "wrong" side in RTL. Hunt for these — every one is a bug in Hebrew/Arabic projects. Replacements: `padding-inline-start`, `border-inline-start`, `text-align:start`, Tailwind `ps-`/`pe-`/`start-`/`end-`.
- **Dynamic content matrix**: empty state, one row, many rows, very long string (200+ chars), RTL + LTR mixed, emoji, zero-width chars, URL as content, broken image, failed load.
- **Breakpoints**: mobile (375), tablet (768), desktop (1280+). Walk each breakpoint: does the sidebar eat 60% of the viewport? Can the compose drawer still be closed? Do z-index layers stack correctly (admin nav vs. modal vs. backdrop)?
- **Focus & a11y**: does every modal have `role="dialog"`, `aria-modal="true"`, focus trap, Escape to close, focus restore on close? Does every image have alt? Every icon-only button an aria-label?

## Process

1. **Map the feature first.** List every route, every object, every state, every CTA. Don't start finding bugs until you can draw the state machine.
2. **Read the central CSS file end-to-end** if it's a UI audit. Note every rule that targets generic tags.
3. **Trace the primary user flows end-to-end** in the code — login → create → edit → delete → archive → unarchive → read. Note every await, every state transition, every UI-to-backend round trip.
4. **Enumerate reverse actions.** For every destructive/terminal action, is there an inverse? If not, that's a Critical.
5. **Check races.** For every `await` inside a state mutator: if the user triggers another call before this resolves, what wins? Rapid-click A then B, throttle to Slow 3G.
6. **Classify by severity**:
   - **Critical** = feature is broken or the user loses work (content renders unreadable, no restore from trash, silent data loss)
   - **Major** = flow works but confuses users (no loading state, no confirmation of a completed action, wrong language on generated text)
   - **Minor** = cosmetic or tiny edge (placeholder off by one, icon slightly misaligned)
   Verify every Critical by opening the exact line of code before labeling.

## Anti-patterns to avoid

- **Delegated understanding.** Don't spawn a subagent with "find bugs in X" and trust its report as-is. Spawn subagents for parallel code scans; synthesize the findings yourself.
- **Pattern-matching.** "This looks like the bug I saw last time" → open the code, prove it. Half the time it's already been fixed.
- **Cheap "critical" labels.** A critical claim carries weight. If three of your five criticals turn out wrong, the user stops trusting the other two. Verify.
- **Parallelism ≠ depth.** Running five subagents in parallel covers breadth but none of them trace a user flow end-to-end. Do at least one deep trace yourself before parallelizing.
- **Skipping CSS.** Pure Svelte/React file reads miss cascade bugs. Always crack open the central stylesheet.

## Deliverable

A report, ordered by severity, with for each finding:
- **Severity** (Critical/Major/Minor) + **proof** (file:line link)
- **Repro** (exact user flow that hits it)
- **Root cause** (what's actually wrong, not the symptom)
- **Fix** (one-line description of the smallest change that fixes it)

Cluster findings that share a root cause. If three symptoms are all the same `.prose pre` cascade bug, that's one Critical with three visible effects — not three Criticals.

## What experience says to check first

- **Terminal states are the #1 source of Critical bugs.** Every state a record can enter and not leave — cancelled, archived, deleted, converted — needs a reverse, or an explicit reason why it has none.
- **The cascade outranks component styles.** A rule in the central stylesheet targeting a generic tag silently clobbers carefully scoped component styles. Read the central stylesheet before claiming any visual bug.
- **"The backend enforces it" is not "the UI prevents it."** A rule enforced only server-side reaches the user as an error they could not have anticipated. Check that invalid combinations are unreachable in the UI.
- **One root cause commonly produces three "Critical" symptoms.** Cluster before counting, or the report overstates its own severity.

## Stack-specific references

Open only the one that matches the project:

- [Svelte 5 traps](references/svelte-5.md)
- [Server-side traps](references/backend-web.md)

## Reading the code systematically

The sibling skill's [`reading-the-code.md`](../ux-heuristics-audit/references/reading-the-code.md) applies here in full: extract structure mechanically before judging, query the index instead of reading the codebase, follow dependency edges in both directions, find a working example and diff against it, and trace backward from symptom to source. The rule it opens with governs this audit too — **no finding without reading the code that produces it.**

