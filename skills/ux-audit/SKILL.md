---
name: ux-audit
description: Audit a web/app feature end-to-end for UX bugs using OOUX + Lifecycle Trace + Visual Contract. Finds state-machine traps, CSS cascade bugs, i18n/RTL issues, missing reverse-actions, and race conditions. Trigger when the user says "audit the UX", "find UX bugs", "review this feature end-to-end", "why does X feel broken", or names a route/screen to review.
---

# UX Audit

Systematic end-to-end audit methodology. Use when a user asks you to find UX bugs in a feature, screen, or route — not quick fixes, the real underlying bugs.

## Core principle

**Depth over breadth.** Grep/checklist passes miss the bugs that matter: state-machine traps, CSS cascade collisions, reverse-action gaps, race conditions. Trace the user's path through the code, don't sample it.

**Verify every "critical" claim.** Before labeling anything a bug, open the code and confirm. Pattern-matching produces false criticals that destroy the user's trust in the whole report.

## Method: three layers

Every object in the feature gets examined through all three layers. If you only do one, you miss most of the bugs.

### 1. OOUX (Object-Oriented UX)

For each domain object (e.g. Email, Draft, Thread, Rule), fill in:

| Object | CTAs | States | Relationships |
|--------|------|--------|---------------|
| Email  | archive, star, delete, convert, forward, reply, mark-read/unread | new, read, archived, converted, deleted | belongs-to Thread, has-many Attachments |

Then sweep:
- Every (state × CTA) cell — is the action valid in that state? Is it blocked in the UI?
- Every state — is there a path back? (**Terminal states are the #1 trap** — "Converted" with no unconvert, "Deleted" with no restore.)
- Every relationship — does deleting A leave orphan Bs? Does archiving the parent hide children it shouldn't?

### 2. Lifecycle Trace

Follow each *attribute* of each object from the moment it's written to every place it's read. Follow the exact code path — don't guess.

- **Creation**: where's the row inserted? What defaults are set? What validators run?
- **Every mutation**: every UPDATE/SET. What triggers it? What's the transaction boundary?
- **Every read**: every SELECT. What filter is applied? Does the filter drop rows that shouldn't be dropped?
- **Display**: where does the value land in the DOM? Is it escaped/sanitized? Does it get re-parsed client-side?
- **Terminal fates**: is the row ever hard-deleted? Soft-deleted? Archived? Can it come back?

This layer catches: partial commits, orphan rows, stale reads, silent truncation (e.g. `LEFT(body_text, 200)`), timezone drift, JSON-array-stringified-as-string bugs.

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
   - **Critical** = feature is broken or user loses work (black box body, no restore from trash, silent data loss)
   - **Major** = flow works but confuses users (wrong prefix language, no delivery badge, no loading state)
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

## Svelte 5 specific traps (when applicable)

- **Module-level `$state` in `.svelte.ts` stores** — SSR pollution: any server-side import leaks state between users. Use `setContext/getContext` instead.
- **`await` inside state mutators** — no staleness guard means rapid click A→B resolves A last, state wins for A. Gate every post-await write with `if (currentId !== startedId) return`.
- **`onMount(() => { if (reactiveValue) ... })`** — runs once with whatever value reactiveValue had at mount, not reactively. Use `$effect` to re-run when the value changes.
- **Debounce timers** — every cancellation path must clear the timer. Folder switch? Route leave? Form reset? If you only cleared it in one place, the other two leak.
- **Long-lived polls** — every caller that starts the poll must be able to stop it, and the counter must be refcounted or the first caller "owns" it forever.

## Backend specific traps (when applicable)

- **Partial-commit windows** — any flow that writes to two tables without a transaction can leave one updated and the other not. Wrap in `tx.Begin`/`tx.Commit`/`tx.Rollback`.
- **Silent error swallowing** — `if err != nil { return }` with no log. Every error path on the write side should log before returning so debugging is possible.
- **Path-param encoding** — chi/mux/etc. don't URL-decode path params. Message-IDs, thread-IDs, emails-in-URLs all need `url.PathUnescape`.
- **JSON-array-as-string** — when a header value is `map[string]string` but the provider sends arrays, you get literal `["<id1>","<id2>"]` as the value. Sanitize before parsing.
- **Soft delete filters** — once you add `is_deleted`, every SELECT needs `WHERE is_deleted = FALSE`. Miss one and deleted rows ghost back into random lists.

## Lessons from past audits

- **Terminal states are the #1 source of Critical bugs.** Every "converted", "archived", "deleted" state needs a reverse. Check first.
- **CSS cascade ≥ component styles.** Generic-tag rules in app.css clobber carefully-scoped component styles. Check app.css first for any visual bug.
- **"Already enforced by backend" doesn't mean "UI prevents it."** Check that the UI disallows invalid combinations — otherwise users hit confusing errors.
- **One root cause can produce three "critical" symptoms.** Cluster before counting.
- **Always read the central stylesheet before claiming a visual bug.** You will be embarrassed otherwise.
