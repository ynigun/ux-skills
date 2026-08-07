---
name: lawsofux-audit
description: Use when evaluating a screen, flow, or component against UX principles and heuristics — "audit against Laws of UX", "is this usable", "heuristic review", "check cognitive load", "too many choices / Hick's / Fitts's / Jakob's law", or naming a route to review for usability (not functional bugs). Sibling to ux-audit, which finds state/CSS/race bugs; this finds principle violations.
---

# UX Heuristic Audit

Heuristic evaluation against 30 well-established UX principles. Use when a user wants a design judged against usability principles — not "does it work" (that's `ux-audit`), but "does it respect how human attention, memory, and expectation actually work."

Each principle lives in its own file under `laws/`. This file is the **method**; the `laws/` files are the **lenses**. Open a lens file when you suspect that principle applies — each one carries its definition, what to look for, **how to verify it from the code**, **what is not a violation**, the user cost, a before/after, and which neighbouring principles it gets confused with.

## Core principle

**Every claim cites a principle AND a concrete user cost.** Naming "Hick's Law" because a menu has items is noise. A finding is real only when you can name the principle, point at the exact element, and state what it costs the user (slower decision, misclick, lost work, abandoned flow). Decorative principle-dropping destroys trust faster than missing a finding.

**Breadth is the whole point.** A capable reviewer finds the obvious ~8 principles unaided. The value here is the long tail — Choice Overload, Serial Position, Peak-End, Zeigarnik, Selective Attention, Prägnanz, Mental Model. Sweep every lens; don't stop at the easy ones.

**Verify against the real artifact.** Open the code, the rendered DOM, or the screenshot before claiming a violation. Half of "violations" are already handled by something you didn't read (an `optgroup`, a confirm dialog, a focus style, a soft delete).

## Working as an LLM auditor — read this before you start

You are not a human evaluator with eyes on a screen. Your failure modes are specific, measured, and different from a human's. Studies of LLM-driven usability evaluation report four recurring ones, and every one of them is preventable:

| Documented failure | What it looks like here | The discipline |
|---|---|---|
| **Issues that don't exist.** Models report problems that aren't there. | A confident finding about a control you never opened | Every finding needs a file:line or a named element. No citation → demote it, don't assert it. |
| **Recommendations too general.** Engineers receiving machine-generated reports consistently ask *which* element and *where* — a report naming neither can't be acted on. | "The form has too many fields" | Name the field, the file, and the line. A finding that doesn't say *where* is not a finding. |
| **Missing existing functionality.** Flagging validation, error handling, or a guard as absent when it is implemented elsewhere. | "No error handling here" when the handler is in another file | Search for the thing before declaring it absent. Each lens file's **Not a violation** section lists the specific handled cases that look like violations. |
| **Severity labels collapse into ties.** Asked for explicit severity ratings, models return many identical ones, which defeats prioritisation. | Nine findings all marked Major | Bucket by severity, then force a **strict 1..N order**. See Deliverable. |

Three further constraints that come from what you actually are:

- **You cannot see.** Unless you were given a screenshot or ran a headless browser, you are reading source and inferring a rendering. Say which artifact you assessed. Never describe how something "looks" when you only read code.
- **You cannot measure.** No timings, no eye-tracking, no funnel analytics. Never write "users abandon at step 3" or "this takes 2 seconds." Report the missing mechanism, not an invented metric.
- **You pattern-match.** A screen that resembles one with a known problem is not a screen with that problem. Open it.

### Your real problem is recall, not precision

Everything above guards against false findings. But the measured weakness runs the other way. In a controlled study where a model was given an app's source code, a screenshot of the view, and a description of its context, it reached precision of 0.61–0.66 and **recall of 0.35–0.38** — right about most of what it reported, and missing roughly two-thirds of the issues that traditional usability testing and expert review found between them.

Coverage numbers elsewhere land higher — a screenshot-based heuristic sweep reached 73–77% of a master issue set, against 55–63% for five-evaluator human panels on the same apps. For calibration, Nielsen's long-standing baselines put a single human evaluator at 20–50% and three-to-five specialists at 74–87%. A model sits *inside* the specialist band, not above it: competitive on cost and repeatability, not on insight.

> **On all of these numbers.** They come from GPT-4 and GPT-4 Turbo (studies run March–November 2024) and from Gemini 2.0 Flash, a small fast model. No current-generation reasoning model appears in this literature, and every one of these papers says its own figures will age. Treat them as a **floor and a direction**, never as current capability. The durable direction: recall is the weaker half, because missing an issue costs no confidence while inventing one requires overconfidence.

So the guards must not collapse into timidity. A report with three impeccable findings and thirty misses is a failed audit.

- **Sweep every lens explicitly.** Don't stop when you have "enough." The long tail is where the value is.
- **Don't silently drop what you couldn't verify.** Uncertain items go in a separate **Suspected — unverified** list with what you'd need to confirm them. That preserves recall without contaminating the confirmed findings.
- **Run the lenses as separate passes** rather than judging all 30 in one sweep. This is the one process change the literature agrees on: evaluating each heuristic on its own produces more detailed and more varied findings, and a single combined pass also risks truncating mid-analysis. The cost is redundancy, which the next section handles.
- **Say what you didn't cover.** A named gap is recoverable; a silent one isn't.

### Two things that will wreck the report if you don't handle them

**You will produce duplicates; humans don't.** Per-screen and per-lens passes each treat their slice as a fresh artifact, so the same underlying defect gets reported once per screen it appears on. In a measured comparison, synthetic evaluation generated eight and nine duplicate issues per app while human evaluators produced **zero**. Before writing anything up, run an explicit **aggregation pass**: group findings by the component and root cause they share, and merge. This is the same discipline as clustering by root cause — but it must be a deliberate step, not something you hope happened.

**A large fraction of your raw output will not be real issues.** When findings from these systems were rated by reviewers, roughly a quarter to a third landed at "I don't agree that this is a usability problem at all" — and the overwhelming majority of those came from the model rather than from human evaluators. Expect to discard a lot of your own first pass. Triage before you report: anything you cannot tie to a named element and a concrete cost does not make the confirmed list.

**And do not default to praise.** Asked simply to evaluate a UI, models reliably return reassurance — "clean", "intuitive", "easy to understand" — instead of findings. If your pass over a lens produced only approval, you have not run the lens; go back and look for the specific things its **Look for** section names.

### What your evidence base can and cannot yield

Yield varies sharply with what you were given. State which case you're in, and don't promise findings the evidence can't support:

| Evidence | Strong at | Weak at |
|---|---|---|
| **Source code** | Logic, state, validation, data flow, reversibility — and **rare paths user testing never exercises**: behaviour under a slow connection, an unbounded input, an error branch nobody hits. This is code inspection's genuine advantage over watching users. | Anything visual: layout, spacing, emphasis, whether the rendering actually reads |
| **Screenshots / rendered UI** | Layout and visual grouping. Measured strongest on minimalism and visual consistency — small details like uneven whitespace and insufficient font-size differentiation, where human panels scored far lower. | Recognising platform components and domain design conventions — a system control mistaken for app UI; **violations that span screens** |
| **Both** | Everything above. The study with the best precision/recall used code *and* a screenshot together, not either alone. | Cross-screen consistency, still, unless you look for it deliberately |

**Ask for screenshots or a running page if you only have code.** It changes what you can find, and it's cheaper than guessing.

**Where to trust yourself and where to hedge.** You have one real advantage over a human evaluator: no attentional decay. Human reviewers' issue-finding measurably drops off across a long evaluation and their descriptions get terser on repeat problems; a model's stays flat. Long, repetitive sweeps are where you win — so do the boring exhaustive pass, that's the job. Conversely, when a finding depends on recognising a platform component or a domain convention, mark it for human confirmation; that is the measured weak spot.

## The lenses (one file per principle)

Walk the feature through all four groups. Most principles won't apply to a given screen — that's expected. Open the file for any you suspect.

### Heuristics — interaction & decision cost
- [Hick's Law](laws/hicks-law.md) · [Choice Overload](laws/choice-overload.md) · [Fitts's Law](laws/fittss-law.md) · [Jakob's Law](laws/jakobs-law.md) · [Miller's Law](laws/millers-law.md) · [Doherty Threshold](laws/doherty-threshold.md) · [Peak-End Rule](laws/peak-end-rule.md) · [Goal-Gradient Effect](laws/goal-gradient-effect.md) · [Serial Position Effect](laws/serial-position-effect.md) · [Aesthetic-Usability Effect](laws/aesthetic-usability-effect.md) · [Postel's Law](laws/postels-law.md) · [Tesler's Law](laws/teslers-law.md) · [Occam's Razor](laws/occams-razor.md) · [Pareto Principle](laws/pareto-principle.md) · [Parkinson's Law](laws/parkinsons-law.md) · [Flow](laws/flow.md)

### Gestalt — visual grouping
- [Law of Proximity](laws/law-of-proximity.md) · [Law of Common Region](laws/law-of-common-region.md) · [Law of Similarity](laws/law-of-similarity.md) · [Law of Uniform Connectedness](laws/law-of-uniform-connectedness.md) · [Law of Prägnanz](laws/law-of-pragnanz.md)

### Cognitive load, attention & memory
- [Cognitive Load](laws/cognitive-load.md) · [Working Memory](laws/working-memory.md) · [Chunking](laws/chunking.md) · [Selective Attention](laws/selective-attention.md) · [Von Restorff Effect](laws/von-restorff-effect.md) · [Zeigarnik Effect](laws/zeigarnik-effect.md) · [Cognitive Bias](laws/cognitive-bias.md)

### Mental models & expectation
- [Mental Model](laws/mental-model.md) · [Paradox of the Active User](laws/paradox-of-the-active-user.md) · (also [Jakob's Law](laws/jakobs-law.md))

### Start here if you're short on time
The lenses with the highest ratio of provable findings to guesswork are [Mental Model](laws/mental-model.md) (label versus handler), [Postel's Law](laws/postels-law.md) (read the validators), [Working Memory](laws/working-memory.md) (trace the data flow), [Uniform Connectedness](laws/law-of-uniform-connectedness.md) (`for`/`id` pairing), [Doherty Threshold](laws/doherty-threshold.md) (pending state bound to the UI), and [Cognitive Bias](laws/cognitive-bias.md) (initial checkbox state). The most guesswork-prone is [Prägnanz](laws/law-of-pragnanz.md) — expect it to yield nothing most of the time.

## Process

1. **Map first.** List every screen, object, control, and the flow's steps before judging anything. You can't spot a Serial Position or Goal-Gradient problem without the sequence.
2. **State your evidence base.** Code only? Screenshots? A live page? Write it down — it bounds which lenses can produce findings at all.
3. **Read the real artifact.** Central CSS + the component markup, or the rendered screenshot. Note what's actually there (groupings, confirm dialogs, focus states, soft deletes) so you don't flag handled cases.
4. **Sweep all four groups.** For each principle you suspect, open its file, run its **Verify it from the code** checks, then read its **Not a violation** list before writing anything down.
5. **Do a cross-screen pass.** This is the most robustly documented blind spot in the whole literature, agreed by every study that measured it: models found 43% and 50% of cross-screen violations where human panels found 86% and 83%. Each screen looks fine alone, so a per-screen sweep cannot surface these by construction. Check the set deliberately: the same concept named differently in two places, a control that changes meaning between views, inconsistent primary-action treatment, a value shown on one screen and required on another, a style that only collides when two components meet. Note that nearly all such misses fall under consistency — so if you take one thing from this step, compare naming and control behaviour across every screen. When you have screenshots, put them in navigation order and say so; sequence is what makes these visible.
6. **Verify each suspected violation** against the exact element. If you cannot cite it, move it to **Suspected — unverified** with the check that would settle it; don't discard it silently.
7. **Classify by severity, then rank strictly:**
   - **Critical** — blocks or loses the user (destructive action indistinguishable from a safe one; flow abandons under Choice Overload).
   - **Major** — measurably slower/harder (no progress indicator on a 5-step flow; Hick's overload on the primary path).
   - **Minor** — friction or polish (label not click-associated; suboptimal button order).
8. **Aggregate, then cluster by root cause.** First merge the duplicates your per-lens and per-screen passes inevitably produced. Then cluster what remains: three symptoms of one missing grouping = one finding with three effects, not three findings.

## Deliverable

Severity-ordered report, and **within it a strict 1..N ranking with no ties** — if two findings feel equal, decide which you would fix first and say why. Ties are the documented failure mode of LLM heuristic evaluation; forcing a total order is the fix.

For each finding:
- **Rank** + **Severity** + **Principle** (the specific one) + **proof** (`file:line` or the named element)
- **User cost** — the concrete behavior it produces (slower, misclick, abandonment, lost work)
- **Fix** — smallest change that removes the cost. Prefer *preventive* designs over corrective ones where both are available: disabling invalid choices beats validating them after entry.

Then two closing sections that are not optional:

- **Suspected — unverified.** Everything you couldn't confirm, each with the one check that would settle it. This is how the report keeps recall without inflating the confirmed list.
- **Not assessed.** Lenses your evidence base couldn't support, and what you'd need. Stating the gap is worth more than padding the report.

End with the 2–3 highest-leverage fixes called out.

### The actionability test

Benchmarks for machine-generated UX critique score a report by **repair lift** — whether an agent given only your report can actually improve the interface. Apply that test to every finding before you ship it:

> Could someone who has never seen this screen open the file you named, find the element you named, and make the change you described — without asking you a question?

If not, the finding isn't finished. Missing location, vague fix, or a cost stated as an adjective are the three usual reasons.

## Anti-patterns

- **Decorative principle-dropping.** "This menu relates to Hick's Law" with no cost stated. Every citation needs a *consequence*, not a label.
- **Forcing all 30 to apply.** Most principles don't apply to most screens. A report that invokes all of them is pattern-matching, not auditing. Report the ones that bite.
- **Unverified claims.** "No confirmation on delete" when there's a confirm modal you didn't open. Read before you claim.
- **Findings with no location.** The single most common complaint from engineers receiving machine-generated usability reports.
- **Confusing this with `ux-audit`.** A black-box render, an orphaned row, an RTL leak, a race condition → those are functional/CSS bugs → `ux-audit`. This skill is for principle violations in an otherwise-working UI. When both apply, run both and say so.
- **Cheap criticals.** If two of your three criticals are wrong, the user discards the third. A Critical means the user is blocked or loses work — verify it.

## Attribution

The 30 principles collected here are long-standing findings from cognitive psychology and human-computer interaction — Hick (1952), Fitts (1954), Miller (1956), the Gestalt school, Kahneman and Tversky, and others; each lens file cites its source.

The selection and grouping of these particular 30 as a working set follows **[Laws of UX](https://lawsofux.com/) by Jon Yablonski**, which is an excellent reference and worth reading directly. All text in this skill — definitions, checks, examples, and guidance — is written by us. No text is reproduced from that site, and this skill is not affiliated with or endorsed by it.

The LLM-auditor guidance in this file is drawn from published evaluations of machine-generated usability critique. **These studies were run on the model generations available at the time of writing; the reported failure modes have been consistent across them, but treat specific numbers as historical rather than as current performance.**

- Lubos, Felfernig, Garber, Le & Henrich, *Recommending Usability Improvements with Multimodal Large Language Models* (ACM FSE 2026) — [arXiv:2604.25420](https://arxiv.org/abs/2604.25420). Ran `gemini-2.0-flash-001` at temperature 0 over MP4 screen recordings sampled at 1 fps. Source of the specificity, context-awareness and preventive-fix findings, of the severity-tie result that motivates relative ordering, and of the per-heuristic evaluation and aggregation steps.
- Ebrahimi Pourasad & Maalej, *Does GenAI Make Usability Testing Obsolete?* (ICSE 2025) — [arXiv:2411.00634](https://arxiv.org/abs/2411.00634). Ran GPT-4 Turbo with Vision over app context **plus source code plus a screenshot** — not code alone. Source of precision 0.61–0.66 and recall 0.35–0.38, where that spread is across two expert graders scoring the same output (their agreement was only moderate, κ = 0.53), and the authors ask that recall be read as indicative since it is measured conservatively against the union of two other methods. Also the source of the rare-user-path advantage and of the one-view-at-a-time explanation for cross-screen misses.
- Zhong, McDonald & Hsieh, *Synthetic Heuristic Evaluation: A Comparison between AI- and Human-Powered Usability Evaluation* — [arXiv:2507.02306](https://arxiv.org/abs/2507.02306). Ran GPT-4 (with Gemini 1.5 Pro and Claude 3.5 Sonnet as comparisons) over 3–9 static screenshots per task, March–June 2024. Source of the 73–77% coverage against 55–63% for panels of five recruited freelance UX designers (five per app, ten in total), the cross-screen figures, the duplicate counts, the severity-0 noise proportion, the praise-by-default behaviour, the split-the-heuristics finding, and the attentional-decay comparison.
- Wang et al., *UXBench: Measuring the Actionability of LLM-Generated UX Critiques* — [arXiv:2606.16262](https://arxiv.org/abs/2606.16262). Source of the repair-lift framing behind the actionability test.
- Ahmed & Imran, *The role of large language models in UI/UX design: A systematic literature review* — [arXiv:2507.04469](https://arxiv.org/abs/2507.04469).
- Guerino, Rodrigues, Capeleti, Mello, Freire & Zaina, *Can GPT-4o evaluate usability like human experts? A comparative study on issue identification in heuristic evaluation* (INTERACT 2025, pp. 381–402). The original source, on GPT-4o, for the finding that models identify issues with severity comparable to humans while also reporting issues that do not exist.

Nielsen's evaluator-coverage baselines (a single evaluator finding 20–50% of issues, three to five specialists 74–87%) are from the Nielsen Norman Group's published guidance on heuristic evaluation.
