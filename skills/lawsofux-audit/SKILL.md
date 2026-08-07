---
name: lawsofux-audit
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

## The lenses

Most principles won't apply to a given screen. That's expected — report the ones that bite.

**Interaction & decision cost** — [Hick's Law](laws/hicks-law.md) · [Choice Overload](laws/choice-overload.md) · [Fitts's Law](laws/fittss-law.md) · [Jakob's Law](laws/jakobs-law.md) · [Miller's Law](laws/millers-law.md) · [Doherty Threshold](laws/doherty-threshold.md) · [Peak-End Rule](laws/peak-end-rule.md) · [Goal-Gradient](laws/goal-gradient-effect.md) · [Serial Position](laws/serial-position-effect.md) · [Aesthetic-Usability](laws/aesthetic-usability-effect.md) · [Postel's Law](laws/postels-law.md) · [Tesler's Law](laws/teslers-law.md) · [Occam's Razor](laws/occams-razor.md) · [Pareto Principle](laws/pareto-principle.md) · [Parkinson's Law](laws/parkinsons-law.md) · [Flow](laws/flow.md)

**Gestalt / visual grouping** — [Proximity](laws/law-of-proximity.md) · [Common Region](laws/law-of-common-region.md) · [Similarity](laws/law-of-similarity.md) · [Uniform Connectedness](laws/law-of-uniform-connectedness.md) · [Prägnanz](laws/law-of-pragnanz.md)

**Cognitive load, attention & memory** — [Cognitive Load](laws/cognitive-load.md) · [Working Memory](laws/working-memory.md) · [Chunking](laws/chunking.md) · [Selective Attention](laws/selective-attention.md) · [Von Restorff](laws/von-restorff-effect.md) · [Zeigarnik](laws/zeigarnik-effect.md) · [Cognitive Bias](laws/cognitive-bias.md)

**Mental models & expectation** — [Mental Model](laws/mental-model.md) · [Paradox of the Active User](laws/paradox-of-the-active-user.md) · (also [Jakob's Law](laws/jakobs-law.md))

**Short on time?** The lenses that yield provable findings from code are [Mental Model](laws/mental-model.md) (label versus handler), [Postel's Law](laws/postels-law.md) (read the validators), [Working Memory](laws/working-memory.md) (trace the data flow), [Uniform Connectedness](laws/law-of-uniform-connectedness.md) (`for`/`id` pairing), [Doherty Threshold](laws/doherty-threshold.md) (pending state bound to the UI), and [Cognitive Bias](laws/cognitive-bias.md) (initial checkbox state). Expect little from [Prägnanz](laws/law-of-pragnanz.md), [Aesthetic-Usability](laws/aesthetic-usability-effect.md) and [Flow](laws/flow.md) without a rendered page.

## Process

1. **Map the codebase.** Routes, domain objects, state, central stylesheet — Phase 1 of `references/reading-the-code.md`. Extract it mechanically; don't record a single finding during this pass.
2. **State your evidence base.** Code only? Screenshots? A running page? Write it down — it bounds what you can legitimately claim. If you only have code, ask for a screenshot or run the app; it's cheaper than guessing.
3. **Run one lens at a time.** Open the lens file, run its *Verify it from the code* checks, then read its *Not a violation* list before writing anything down. One lens per pass beats one sweep over all thirty. For each candidate, go find how the rest of the codebase handles the same situation before calling it a violation.
4. **Do a cross-screen pass.** This is the blind spot per-screen sweeps cannot reach by construction — each screen looks fine alone. Compare naming and control behaviour across every screen: the same concept called two things, a control that changes meaning between views, a value shown on one screen and needed on another.
5. **Repeat the sweep, independently, at least twice more.** Don't let a later pass see the earlier ones. Findings that show up in every run are the ones to trust; findings that appear once are usually noise. This is cheap and it's the highest-leverage thing you can do.
6. **Verify each finding against the actual element.** Open it. If you can't cite it, move it to Suspected with the check that would settle it.
7. **Aggregate.** Merge the duplicates the per-lens, per-screen and multi-run passes produced. Then ask the harder question: do any of these share a single *assumption* of mine? One misreading of what the user is doing will reappear as five differently-worded findings.
8. **Apply the tradeoff test.** A violated principle isn't automatically a defect — it depends on context and the alternatives. A hamburger menu really does violate recognition-over-recall and is often still right on mobile. Ask: what would the alternative cost, and can the user recover in one click? If the alternative is worse, it's not a finding.
9. **Rate severity last, in its own pass** over the consolidated list. Discovery and rating compete for attention; doing both at once is what makes everything come out "Major".

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
