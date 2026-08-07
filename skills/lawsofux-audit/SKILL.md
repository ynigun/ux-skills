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

Everything above guards against false findings. But the measured weakness of code-based LLM usability evaluation is the opposite one: in a controlled study, an LLM inspecting app source reached precision of 0.61–0.66 and **recall of only 0.35–0.38** — it was right about most of what it reported, and missed roughly two-thirds of the real issues.

> **On these numbers.** They come from studies run on earlier model generations, and capability has moved since. Treat the *direction* as the durable finding, not the decimals: recall has consistently been the weaker half, because missing an issue requires no confidence while inventing one requires overconfidence. If your own model is better than this, the discipline costs you little; if it isn't, the discipline is what saves the report. Don't cite these figures as current performance.

So the guards must not collapse into timidity. A report with three impeccable findings and thirty misses is a failed audit.

- **Sweep every lens explicitly.** Don't stop when you have "enough." The long tail is where the value is.
- **Don't silently drop what you couldn't verify.** Uncertain items go in a separate **Suspected — unverified** list with what you'd need to confirm them. That preserves recall without contaminating the confirmed findings.
- **Run the lenses as separate passes** rather than judging all 30 in one sweep. Depth per lens beats one shallow pass over everything.
- **Say what you didn't cover.** A named gap is recoverable; a silent one isn't.

### What your evidence base can and cannot yield

Yield varies sharply with what you were given. State which case you're in, and don't promise findings the evidence can't support:

| Evidence | Strong at | Weak at |
|---|---|---|
| **Source code only** | Logic, state, validation, data flow, reversibility, rare paths that user testing never reaches — this is the genuine advantage of code inspection over user testing | Anything visual: layout, spacing, emphasis, whether the rendering actually reads |
| **Screenshots / rendered UI** | Layout and visual grouping — multimodal heuristic evaluation has been measured *above* individual human evaluators (73–77% of known issues versus 57–63% for experienced evaluators, on the model generation tested) | Recognising unfamiliar UI components and design conventions; **violations that span screens** |
| **Both, or a live page** | Everything above | Still cross-screen consistency unless you look for it deliberately |

**Ask for screenshots or a running page if you don't have them.** It changes what you can find, and it's cheaper than guessing.

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
5. **Do a cross-screen pass.** Violations that span screens are a documented blind spot — each screen looks fine alone. Check the set: the same concept named differently in two places, a control that changes meaning between views, inconsistent primary-action treatment, a value shown on one screen and required on another, a style that only collides when two components meet. Nothing in a per-screen sweep will surface these.
6. **Verify each suspected violation** against the exact element. If you cannot cite it, move it to **Suspected — unverified** with the check that would settle it; don't discard it silently.
7. **Classify by severity, then rank strictly:**
   - **Critical** — blocks or loses the user (destructive action indistinguishable from a safe one; flow abandons under Choice Overload).
   - **Major** — measurably slower/harder (no progress indicator on a 5-step flow; Hick's overload on the primary path).
   - **Minor** — friction or polish (label not click-associated; suboptimal button order).
8. **Cluster by root cause.** Three symptoms of one missing grouping = one finding with three effects, not three findings.

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

- Lubos, Felfernig, Garber, Le & Henrich, *Recommending Usability Improvements with Multimodal Large Language Models* (ACM FSE 2026) — [arXiv:2604.25420](https://arxiv.org/abs/2604.25420). Source of the four failure modes: non-existent issues, insufficiently specific recommendations, missed existing functionality, and tied severity ratings.
- *Does GenAI Make Usability Testing Obsolete?* — [arXiv:2411.00634](https://arxiv.org/abs/2411.00634). Source of the precision 0.61–0.66 / recall 0.35–0.38 figures for source-code-based evaluation, and of the observation that code inspection reaches rare user paths that user testing does not.
- *Synthetic Heuristic Evaluation: A Comparison between AI- and Human-Powered Usability Evaluation* — [arXiv:2507.02306](https://arxiv.org/abs/2507.02306). Source of the multimodal 73–77% versus 57–63% comparison, and of the cross-screen and design-convention blind spots.
- Wang et al., *UXBench: Measuring the Actionability of LLM-Generated UX Critiques* — [arXiv:2606.16262](https://arxiv.org/abs/2606.16262). Source of the repair-lift framing behind the actionability test.
- Ahmed & Imran, *The role of large language models in UI/UX design: A systematic literature review* — [arXiv:2507.04469](https://arxiv.org/abs/2507.04469).
