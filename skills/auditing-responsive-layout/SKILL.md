---
name: auditing-responsive-layout
description: Use when a web UI has layout problems that show only at some screen sizes or in some UI states — horizontal scrolling/overflow, a stray strip or empty gap, content clipped at an edge, an inset/floating scrollbar, RTL spacing leaks, a control detached from what it acts on, or a "looks fine on a fresh load but the user still sees it" bug you can't reproduce.
---

# Auditing Responsive Layout

## Core principle

**Measure, don't eyeball — and test the *matrix*, not one fresh load.** Responsive layout bugs hide in combinations: `viewport width × persisted UI state × load-vs-resize path`. A single fresh load at one width is the #1 way to miss them and wrongly conclude "looks fine → must be a cache issue." Reproduce with computed geometry from a headless browser, then read the CSS to find the root cause.

## When to use

Symptoms: horizontal scrollbar on mobile, a leftover **strip** or empty **gap** on one side, content **clipped/cut off** at an edge, a scrollbar floating **inset** from the edge, a component that looks **sparse/stretched** on desktop or **cramped** on mobile, RTL text/spacing leaking the wrong way, "works on my machine", "I hard-refreshed and still see it", a bug only in **DevTools device mode**.

## The trap (read this first)

You check the page at 375px on a fresh load, it looks fine, and you blame cache. **Wrong.** The bug is gated on state you didn't set. Before concluding "no bug":

| Rationalization | Reality |
|---|---|
| "Looks fine at 375px → cache" | You tested the default state. Set every persisted toggle (`localStorage`) and retest. |
| "I hard-refreshed" | Refresh clears cache, not the `localStorage` flag (collapsed sidebar, theme) that triggers it. |
| "`@media` hides it on mobile" | A media query adds **zero** specificity. A more-specific non-media selector (`.x.collapsed`) silently wins over `@media { .x }`. |
| "The element isn't on screen" | A wide element inside `overflow:hidden` doesn't scroll — it **clips**, shifting an RTL page. Measure, don't look. |

## Method

1. **Run the probe** (`probe.js`) — edit its CONFIG (url, widths, every layout-gating `localStorage` key) and run with `dev-browser --headless --timeout 120 run probe.js`. It walks `widths × states` plus a resize-without-reload pass and prints a `⚠` per candidate bug (overflow, over-wide-no-scroller, narrow-floating-box, inset scrollbar). **Always include both `{}` and each toggle in `states`.**
2. **Verify each `⚠` in the CSS** before reporting it — open the implicated element, confirm the rule and specificity. Pattern-matching produces false bugs.
3. **Static sweeps** (cheap, catch what geometry can't):
   - RTL physical-property leaks: `grep -nE "padding-left|padding-right|margin-left|margin-right|(^|[^-])left:|(^|[^-])right:|text-align:\s*(left|right)|border-(left|right)"` then exclude `inline-start|inline-end|inset-inline`. Each hit is a candidate RTL bug; replacements: `padding-inline-start`, `margin-inline-end`, `text-align:start`, `inset-inline-start`, `border-inline-*`.
   - Specificity conflicts: for any rule inside `@media`, check no **more-specific** selector elsewhere sets the same property (e.g. `.app.collapsed .content{margin:56px}` beating `@media{.content{margin:0}}`). Fix by matching the specific selector inside the media query, or `!important` as last resort.

## Root-cause reference (verified in the wild)

| Symptom | Root cause | Fix |
|---|---|---|
| Leftover **strip** on one side, only when a toggle is on | `.shell.collapsed .content{margin-inline-start:56px}` (0,3,0) outranks `@media{.content{margin-inline-start:0}}` (0,1,0) | match the specific selector inside the media query |
| Content **shifts/clips** on mobile, RTL | wide table/element in `overflow:hidden` parent → clips instead of scrolling; or no mobile card fallback | give it `overflow-x:auto`, or swap the table for a card list `<768px` |
| Narrow content **floating** with side gaps + **inset scrollbar** | `margin:0 auto` with no `width` inside a `display:flex` column → shrinks to content | add `width:100%` (keep `max-width` + `margin:0 auto`) |
| Bug only in **DevTools device mode** / after resize | JS sets a layout class from `innerWidth`/`localStorage` on load, doesn't update on resize; or a missing/incorrect `<meta viewport>` | drive it from CSS media queries; verify the viewport meta |

## Also think UX, not just bugs

Geometry finds breakage; these heuristics find bad-but-not-broken layout — flag them too:
- **Stretched-sparse**: a component spans far past its natural width with a dead middle band and controls flung to the edges → cap width or use a denser row; keep cards for mobile.
- **Detached control**: a toggle/button far from the thing it acts on → group it.
- **Unlabeled magnitude (copy smell)**: a bare number whose unit/meaning the user must guess (`3 ימים` — days of what?) → label it.
- **Missing "next/expected" state**: a scheduler/status screen that shows only past state, never the next event → add it.
- **Unit formatting**: large minutes that should roll to hours, bytes to KB, etc.
- **Tap targets**: interactive elements `<44px` on mobile.

## Red flags — you're about to miss the bug

- "Looks fine on a fresh load" — you didn't set the persisted state.
- "I'll just eyeball the screenshot" — screenshots hide computed margins, inset scrollbars, and clipped overflow. Measure.
- "The media query handles it" — check specificity; `@media` adds none.
- Reporting a `⚠` without opening the CSS — verify first.

## Files
- `probe.js` — the headless measurement harness (edit CONFIG, run, read `⚠`).
- `test-fixture.html` — a page seeded with the four root-cause bugs above, for trying the probe.
