---
name: ux-heuristics-audit
description: Use when evaluating a screen, flow, or component against UX principles and heuristics — "audit against Laws of UX", "is this usable", "heuristic review", "check cognitive load", "too many choices / Hick's / Fitts's / Jakob's law", or naming a route to review for usability (not functional bugs). Sibling to ux-audit, which finds state/CSS/race bugs; this finds principle violations.
---

# UX Heuristic Audit

Heuristic evaluation against 30 established UX principles, done by reading the code.

This file is the **method**. The `laws/` files are the **lenses** — one per principle, each with what to look for, how to verify it from the code, and what is *not* a violation. Open a lens when you're about to use it; don't work from memory of what the principle means.

**Read [`references/reading-the-code.md`](references/reading-the-code.md) before you start.** It's the systematic part, and the audit is only as good as the reading. Its rule — *no finding without reading the code that produces it* — is what the rest of this file assumes. Two techniques from it are worth knowing before you even open a lens:

- **Find the working example and diff against it.** Almost every codebase already does the thing right somewhere. "This form should validate" is an opinion; "`CheckoutForm.tsx` validates on blur and shows an inline error, `ProfileForm.tsx:88` does neither, same pattern" is a finding.
- **Follow the incoming edges, not just the outgoing ones.** Who calls this? One caller is a local fix, twelve is systemic — that difference *is* the severity rating.

If the project already has a knowledge graph from `/understand`, use it rather than rebuilding the map by hand.

## Two rules that decide whether this works

**Every finding names a location and a cost.** "This menu is overwhelming" is noise. A finding is real when you can name the principle, point at `file:line` or a specific element, and say what it costs the user. If you can't cite it, it goes in the Suspected list — not in the report.

**Finding nothing is a valid result.** The pull toward filling the report is strong and it is the main way these audits go wrong: as an interface gets better there's less to find, and a model starts manufacturing violations to fill the space. A long list is a warning sign, not coverage. Never flag a principle as violated just because an element it *could* apply to exists — a form isn't a Hick's Law violation because it has fields.

## What you are and aren't good at

- **You can't see.** Unless you were given a screenshot or ran the page, you're reading source and inferring a rendering. Say which you had. Never describe how something "looks" from code alone.
- **You can't measure.** No timings, no analytics. Report the missing mechanism, not an invented number — and never attach a directional word ("most users", "increasingly") to figures you produced yourself.
- **You can't feel, and this is where you're most confidently wrong.** "Users will find this confusing" is the same class of error as a fabricated drop-off rate, and it's measurably worse. When a lens asks for the user cost, name the structural cause you can point at — a value the user must re-enter, an unlabelled control, a raw ID on screen — not the emotion you imagine.
- **Your default story is that the user succeeds.** Models are trained on task completion, so the instinct is to narrate a smooth path: the user finishes, uses the advanced controls, never mistypes. Real users quit, ignore filters, and retry constantly. When you catch yourself describing a clean run through the UI, that's the bias, not a finding.
- **You don't get tired.** This is the real advantage. Human reviewers fade across a long evaluation; you don't. The exhaustive, boring, every-lens-every-screen sweep is where you win — so do it.

## The lenses, grouped by what you sweep them over

Each lens says at the top which **unit of analysis** it applies to. That's what makes the sweep finishable: you're not asking "does Hick's Law apply to this app?" — you're walking a list, and for each row the answer is a finding or an explicit *n/a*.

**Object lenses (11)** — walk every domain object, and for each, its states and its actions.
[Hick's Law](laws/hicks-law.md) · [Choice Overload](laws/choice-overload.md) · [Mental Model](laws/mental-model.md) · [Jakob's Law](laws/jakobs-law.md) · [Postel's Law](laws/postels-law.md) · [Tesler's Law](laws/teslers-law.md) · [Occam's Razor](laws/occams-razor.md) · [Pareto Principle](laws/pareto-principle.md) · [Von Restorff](laws/von-restorff-effect.md) · [Cognitive Bias](laws/cognitive-bias.md) · [Similarity](laws/law-of-similarity.md)

**Screen lenses (11)** — walk every rendered view.
[Fitts's Law](laws/fittss-law.md) · [Miller's Law](laws/millers-law.md) · [Cognitive Load](laws/cognitive-load.md) · [Chunking](laws/chunking.md) · [Selective Attention](laws/selective-attention.md) · [Proximity](laws/law-of-proximity.md) · [Common Region](laws/law-of-common-region.md) · [Uniform Connectedness](laws/law-of-uniform-connectedness.md) · [Prägnanz](laws/law-of-pragnanz.md) · [Aesthetic-Usability](laws/aesthetic-usability-effect.md) · [Paradox of the Active User](laws/paradox-of-the-active-user.md)

**Flow lenses (8)** — walk every multi-step sequence.
[Doherty Threshold](laws/doherty-threshold.md) · [Goal-Gradient](laws/goal-gradient-effect.md) · [Peak-End Rule](laws/peak-end-rule.md) · [Serial Position](laws/serial-position-effect.md) · [Zeigarnik](laws/zeigarnik-effect.md) · [Working Memory](laws/working-memory.md) · [Flow](laws/flow.md) · [Parkinson's Law](laws/parkinsons-law.md)

Most cells come back *n/a*. That's the expected result, not a failure — report the ones that bite, and let the empty cells prove you swept.

**Short on time?** The object sweep pays best, and inside it [Mental Model](laws/mental-model.md) (label versus handler) and [Postel's Law](laws/postels-law.md) (read the validators) yield the most provable findings, followed by [Working Memory](laws/working-memory.md) (trace the data flow), [Uniform Connectedness](laws/law-of-uniform-connectedness.md) (`for`/`id` pairing), [Doherty Threshold](laws/doherty-threshold.md) (pending state bound to the UI) and [Cognitive Bias](laws/cognitive-bias.md) (initial checkbox state). Expect little from [Prägnanz](laws/law-of-pragnanz.md), [Aesthetic-Usability](laws/aesthetic-usability-effect.md) and [Flow](laws/flow.md) without a rendered page.

## Process

The spine is **OOUX**: map the objects first, then walk the principles across the map. That ordering is what turns "review this UI" into a list you can finish and a coverage claim you can defend.

### Step 1 — Build the inventory (no findings yet)

Three lists, in this order. `references/reading-the-code.md` Phase 1 has the extraction commands.

**Objects.** The nouns the product manipulates — Order, Document, Booking, Ticket. Get them from the data layer, not the UI: schemas, migrations, model definitions. For each object, fill in three columns from the code:

| Object | States | Actions | Relationships |
|---|---|---|---|
| Order | draft, placed, paid, shipped, cancelled | place, pay, cancel, refund, archive | belongs-to Customer, has-many LineItems |

- **States** come from enum columns, `status` fields, boolean flags, `deleted_at`. Scope each extraction to one table — a grep across the whole schema returns every table's states merged into one imaginary object.
- **Actions** come from handlers, mutations, and endpoints that write the object — not from buttons you noticed.
- **Relationships** come from foreign keys and joins.

Guarded updates are the best source you'll get for the transitions: `SET status='paid' WHERE status='pending'` hands you an edge and its precondition in one line. But **collect them from every layer before you trust the machine.** Query files are the obvious place; the same table is often also written by raw SQL inside application code, and a state that looks terminal in the query files may have its only exit there. Getting this wrong doesn't leave a gap — it manufactures a confident Critical.

Then, before moving on, sweep the grid itself — this is the OOUX pass and it finds the worst bugs on its own:
- **Every (state × action) cell.** Is the action valid in that state, and does the UI actually prevent the invalid ones? "The backend rejects it" is not "the UI prevents it."
- **Every state: is there a path back?** Terminal states are the single richest source of critical findings. A "Cancelled" with no reinstate, an "Archived" with no restore.
- **Every relationship: what happens to the children?** Deleting the parent — orphans, cascade, or silent hide?

**Screens.** Every route or view, from the router. Note which objects each one renders — that link is what makes the object sweep reach the UI.

**Flows.** Every multi-step sequence: signup, checkout, onboarding, anything with a wizard, a `step` variable, or a route per stage.

### Step 2 — State your evidence base

Code only? Screenshots? A running page? Write it down — it bounds what you can legitimately claim. If you only have code, ask for a screenshot or run the app; that's cheaper than guessing.

### Step 3 — Sweep principle by principle, over its own list

For each lens: open the file, check its **unit of analysis**, then walk that list — every object, or every screen, or every flow. Run the lens's *Verify it from the code* checks, then read its *Not a violation* list before writing anything down.

One lens per pass, not one sweep over all thirty. And for each candidate, go find how the rest of the codebase handles the same situation before calling it a violation.

Record an explicit **n/a** for cells with no finding. The empty cells are the evidence that you swept, and they're what lets you say honestly what was covered.

### Step 4 — Sweep the objects *across* screens

Per-screen checks cannot catch this by construction: each screen looks fine alone. Take each object and compare its treatment everywhere it appears — the same concept named two different things, an action whose label differs between views, a control that changes meaning, a value shown on one screen and needed on another. The object inventory makes this a mechanical walk instead of a hope.

### Step 5 — Repeat independently, at least twice more

Don't let a later pass see the earlier ones. Findings that appear in every run are the ones to trust; findings that appear once are usually noise. Cheap, and the highest-leverage thing you can do.

### Step 6 — Verify, aggregate, judge

- **Verify** each finding against the actual element. If you can't cite it, move it to Suspected with the check that would settle it.
- **Aggregate.** The grid makes most duplicates collapse on their own — one cell, one finding, however many screens it showed up on. Then ask the harder question: do any of these share a single *assumption* of mine? One misreading reappears as five differently-worded findings.
- **Tradeoff test.** A violated principle isn't automatically a defect; it depends on context and the alternatives. A hamburger menu really does violate recognition-over-recall and is often still right on mobile. Ask what the alternative would cost and whether the user recovers in one click.
- **Rate severity last,** in its own pass over the consolidated list. Discovery and rating compete for attention; doing both at once is what makes everything come out "Major".

## Deliverable

Use Nielsen's 0–4 scale — every practitioner reads it fluently, and it has a rating for "not a problem", which an invented scale won't:

> **0** not a problem · **1** cosmetic · **2** minor · **3** major · **4** must fix before release

Derive it rather than picking a number: rate **frequency** (primary path or rare branch?), **impact** (can the user recover?) and **persistence** (once learned, or every session?), then combine. Average across your runs. Present it as a triage hint, not a prioritised backlog — severity is genuinely contested even between humans looking at the same list.

For each finding:

- **Severity** + **Basis** (verified in code / seen in a screenshot / inferred) + **Runs** (how many passes found it) + **Principle** + **proof** (`file:line`)
- **Expected** — what the principle says should hold here
- **Gap** — what's actually there, in *this* element
- **Fix** — the smallest change that closes it. Prefer preventing over correcting: disabling an invalid choice beats validating it after entry.
- **Cost** — what it does to the user, structurally

Lead with the **coverage grid** — objects/screens/flows down one axis, principles across the other, each cell a finding reference or *n/a*. It is the cheapest part of the report to produce and the most valuable to the reader: it's the only thing that distinguishes "I found four problems" from "I checked ninety cells and four of them bit."

Close with three sections:

- **Suspected — unverified.** What you couldn't confirm, each with the check that would settle it. Most of these won't survive; keep them anyway, because the occasional one is a real find nobody else spotted.
- **Not assessed.** Lenses your evidence couldn't support.
- **Not visible from here.** Say plainly what a static read can't reach: whether a user realises a panel scrolls, that a control is tappable, that a feature exists at all — plus silent form rejections, unexplained disabled controls, and layouts you never rendered. This report decides what to put in front of real users; it doesn't replace doing so.

Two checks before you ship. **The paste test:** if a finding could be pasted unchanged onto a different product's screen, it isn't a finding. **The contradiction check:** read your findings against each other — asserting both that something is consistent and that it isn't, in one report, is a known and embarrassing failure.

## Anti-patterns

- **Decorative principle-dropping.** "This relates to Hick's Law" with no cost stated.
- **Forcing all 30 to apply.** A report that invokes every principle is pattern-matching, not auditing.
- **Claiming absence from one grep.** Search several spellings and check the layer above before saying something is missing.
- **Judging from a grep excerpt.** The guard clause three lines up usually decides it.
- **Cheap criticals.** If two of your three criticals are wrong, the reader discards the third.
- **Confusing this with `ux-audit`.** Black-box renders, orphan rows, RTL leaks, race conditions are functional bugs → `ux-audit`. This skill is for principle violations in an otherwise-working UI. When both apply, run both and say so.

## Attribution

The 30 principles are long-standing findings from cognitive psychology and HCI — Hick (1952), Fitts (1954), Miller (1956), the Gestalt school, Tversky and Kahneman. Each lens file cites its source. The selection and grouping of these particular 30 as a working set follows **[Laws of UX](https://lawsofux.com/) by Jon Yablonski**, which is worth reading directly. All text here is our own; none is reproduced from that site, and this skill is not affiliated with it.

The method's specifics — the multi-run rule, the separate severity pass, the tradeoff test, the empty-result rule — come from published evaluations of machine-generated usability critique. Sources and figures: [`references/research-notes.md`](references/research-notes.md).
