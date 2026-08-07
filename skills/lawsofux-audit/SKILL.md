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
| **Severity labels collapse into ties.** Asked for a severity rating in one pass, models return many identical ones, which defeats prioritisation. | Nine findings all marked Major | Rate severity in a *separate* pass, from three derived factors, averaged across runs. See Deliverable. |
| **One wrong premise, reported five times.** A single misreading of what the user is doing reproduces itself as several separately-worded findings, inflating its own apparent weight. | Five "problems" that are all the same misunderstanding | Cluster by shared *assumption*, not just shared root cause. |

Three further constraints that come from what you actually are:

- **You cannot see.** Unless you were given a screenshot or ran a headless browser, you are reading source and inferring a rendering. Say which artifact you assessed. Never describe how something "looks" when you only read code.
- **You cannot measure.** No timings, no eye-tracking, no funnel analytics. Never write "users abandon at step 3" or "this takes 2 seconds." Report the missing mechanism, not an invented metric.
- **You cannot feel, and this is where you are most confidently wrong.** "Users will find this confusing," "this is frustrating," "this adds cognitive load" are the same class of error as a fabricated drop-off rate, and the measurements are worse: paired studies find that AI agents *consistently underestimate* human cognitive load and emotional frustration, and browser agents are explicitly unsuited to judging aesthetics or how natural a layout feels. The bias has a direction — an ungrounded agent systematically reports that the interface is fine. So when a lens here asks for the **user cost**, name the structural cause you can point at (a value the user must re-enter, an unlabelled control, a raw identifier on screen), never the feeling you imagine it produces.
- **When the evidence isn't there, abstain — don't fill the gap.** The best-grounded persona system in this literature makes abstention its core mechanism: constrain claims to what the retrieved evidence supports, and where it doesn't exist, say so rather than generating plausible speculation. Its author's conclusion is the sharpest statement of why this matters: *"The central risk of AI personas is not inaccuracy, but implicit limitations."* A fabricated cost isn't dangerous because it's wrong — it's dangerous because it is persuasive, unverifiable, and dressed as evidence.

### The one number worth memorising

Benchmarked against 230,965 real recorded actions from real shopping sessions, the best prompt-only models predicted the human's actual next action **about 12% of the time**. Not "sounded plausible" — exact next action, which is the only version that matters. Whatever you are inclined to say about what a user will do next, that is the base rate.

Worse, the errors are not random, and they all point the same way. Models are trained and benchmarked on *task completion*, so a model simulating a user is structurally biased toward the user succeeding. Measured against real behaviour, models:

- **assume the task gets finished** — they keep going and buy, where real users closed the tab;
- **overuse filters and advanced controls** — real users reached for search roughly seven times more often than filters;
- **assume no retry and no error** — real users averaged nearly three searches per session, fixing typos and revising keywords, while models kept the first query.

Read those three together and the conclusion is uncomfortable: **an ungrounded agent's default story is "the user succeeds, uses the sophisticated controls, and never makes a mistake" — which is precisely the story that makes a broken interface look fine.** Every one of those assumptions is a way to miss a real defect. When you catch yourself narrating a smooth path through the UI, that is the bias talking, not a finding.

One corollary: **never attach a directional word to numbers you produced yourself.** A peer-reviewed paper in this very literature described simulated spending as "increasing with income" over a sequence that decreased twice. If you generate any aggregate, print the values and let them speak.
- **You pattern-match.** A screen that resembles one with a known problem is not a screen with that problem. Open it.

### Your real problem is recall, not precision

Everything above guards against false findings. But the measured weakness runs the other way. In a controlled study where a model was given an app's source code, a screenshot of the view, and a description of its context, it reached precision of 0.61–0.66 and **recall of 0.35–0.38** — right about most of what it reported, and missing roughly two-thirds of the issues that traditional usability testing and expert review found between them.

Coverage numbers elsewhere land higher — a screenshot-based heuristic sweep reached 73–77% of a master issue set, against 55–63% for five-evaluator human panels on the same apps. For calibration, Nielsen's long-standing baselines put a single human evaluator at 20–50% and three-to-five specialists at 74–87%. A model sits *inside* the specialist band, not above it: competitive on cost and repeatability, not on insight.

> **On all of these numbers.** They come from GPT-4 and GPT-4 Turbo (studies run March–November 2024) and from Gemini 2.0 Flash, a small fast model. No current-generation reasoning model appears in this literature, and every one of these papers says its own figures will age. Treat them as a **floor and a direction**, never as current capability. The durable direction: recall is the weaker half, because missing an issue costs no confidence while inventing one requires overconfidence.

So the guards must not collapse into timidity. A report with three impeccable findings and thirty misses is a failed audit.

- **Sweep every lens explicitly.** Don't stop when you have "enough." The long tail is where the value is.
- **Don't silently drop what you couldn't verify.** Uncertain items go in a separate **Suspected — unverified** list with what you'd need to confirm them. That preserves recall without contaminating the confirmed findings.
- **Run the lenses as separate passes,** and separate the *kinds* of work too. This is the best-evidenced structural finding in the literature, from two directions. Evaluating each heuristic on its own produces more detailed and more varied findings than judging everything at once. And merging distinct tasks into a single pass measurably degrades the result: when detection and phrasing were collapsed into one call, useful findings dropped, the output format broke *every* time, and the model silently omitted the fix instructions. Keep detection, localisation, and write-up as separate steps. The cost is redundancy, which the next section handles.
- **Keep the principle's actual text in front of you.** Removing the explicit heuristic definitions from the prompt cut useful findings by nearly two-thirds while the *volume* of output barely changed — the same amount of text at a third of the value, and with tunnel vision on whichever issue type came to mind first. This is exactly why the lenses here are files you open rather than names you recall: read the lens, then look.
- **Say what you didn't cover.** A named gap is recoverable; a silent one isn't.

### Finding nothing is a valid result

Say it before anything else, because the opposite instinct is strong and measurable. When designers used one of these tools iteratively, its accuracy *fell* with each round — from 52% to 39% — for a mechanical reason: as the interface got better there was less left to find, so the model manufactured violations to fill the space. The same pathology shows up as sheer volume. In one comparison a weaker model reported 228 violations to a stronger model's 63 and had *fewer* useful ones, because it applied each guideline to every element of the matching type.

So: **a long findings list is a warning sign, not evidence of thoroughness.** And the specific rule that follows — *never report a principle as violated merely because an element it could apply to exists.* A form is not a Hick's Law violation because it has fields. If a lens genuinely produced nothing, write that it produced nothing.

### Three things that will wreck the report if you don't handle them

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

Model reliability varies enormously by principle, and it has been measured. Where studies scored per-heuristic agreement and accuracy, the pattern is consistent: models are dependable on **error prevention**, **missing feedback on system status**, **match between the system and the real world**, and **recognition over recall** — and unreliable on **aesthetics**, **help and documentation**, **flexibility and shortcuts**, and anything resting on a judgement of visual style. Missing feedback in particular produced the largest measurable improvement for every model in a repair benchmark; flow problems the smallest.

Mapped onto the lenses here, the highest ratio of provable findings to guesswork is [Mental Model](laws/mental-model.md) (label versus handler), [Postel's Law](laws/postels-law.md) (read the validators), [Working Memory](laws/working-memory.md) (trace the data flow), [Uniform Connectedness](laws/law-of-uniform-connectedness.md) (`for`/`id` pairing), [Doherty Threshold](laws/doherty-threshold.md) (pending state bound to the UI), and [Cognitive Bias](laws/cognitive-bias.md) (initial checkbox state). Expect little from [Prägnanz](laws/law-of-pragnanz.md), [Aesthetic-Usability](laws/aesthetic-usability-effect.md), [Flow](laws/flow.md) and [Parkinson's Law](laws/parkinsons-law.md) — most of the time they should yield nothing, and that is the correct outcome.

**One important qualifier on consistency.** Studies disagree sharply about whether models are good at [Similarity](laws/law-of-similarity.md) and consistency findings — best in one, worst in another. The likely reconciliation is the input: where the model was handed *resolved* values (computed sizes, colours, spacing), consistency became an arithmetic check it passed easily; where it had to infer consistency across raw source files, it failed. The practical move is to extract the facts first — collect the actual token values, class sets, or computed styles into one place — and only then ask whether they are consistent.

## Process

1. **Map first.** List every screen, object, control, and the flow's steps before judging anything. You can't spot a Serial Position or Goal-Gradient problem without the sequence.
2. **State your evidence base.** Code only? Screenshots? A live page? Write it down — it bounds which lenses can produce findings at all.
3. **Read the real artifact.** Central CSS + the component markup, or the rendered screenshot. Note what's actually there (groupings, confirm dialogs, focus states, soft deletes) so you don't flag handled cases.
4. **Sweep all four groups.** For each principle you suspect, open its file, run its **Verify it from the code** checks, then read its **Not a violation** list before writing anything down.
5. **Do a cross-screen pass.** This is the most robustly documented blind spot in the whole literature, agreed by every study that measured it: models found 43% and 50% of cross-screen violations where human panels found 86% and 83%. Each screen looks fine alone, so a per-screen sweep cannot surface these by construction. Check the set deliberately: the same concept named differently in two places, a control that changes meaning between views, inconsistent primary-action treatment, a value shown on one screen and required on another, a style that only collides when two components meet. Note that nearly all such misses fall under consistency — so if you take one thing from this step, compare naming and control behaviour across every screen. When you have screenshots, put them in navigation order and say so; sequence is what makes these visible.
6. **Repeat the sweep independently, at least three times.** This is the highest-leverage step available to you and it costs almost nothing. Model self-agreement between runs of the same audit has been measured at 31% and 57% — in the worse case, two runs of the same prompt shared *no* findings at all. In the same study, the one genuine discovery that all four human researchers missed appeared in **every** run, while two of the three outright hallucinations came from a **single** run. Run frequency is therefore a usable confidence signal, and it's the cheap analogue of the three-to-five independent evaluators that human heuristic evaluation has always required. Do not let a later pass see the earlier ones. Record for each finding how many runs produced it.
7. **Aggregate, then cluster by root cause.** Merge the duplicates your per-lens, per-screen and multi-run passes inevitably produced. Then cluster what remains: three symptoms of one missing grouping = one finding with three effects, not three findings. Watch for the specific pathology here — a single wrong premise reproduces itself in costume. In one study, five of seven false findings traced back to *one* misreading of what the user was trying to do. Before ranking, ask of every group: do these share not just a root cause in the code, but a single assumption of mine?
8. **Give each surviving finding a verdict**, using the three-way taxonomy from studies that checked machine-generated findings against the truth. These are not degrees of confidence; they have different remedies:
   - **Confirmed** — you opened it, it's there, and it costs the user something.
   - **False alarm** — a true observation misread as a problem. The element exists and you described it correctly; the *judgement* is wrong. Fixed by context, not by grounding.
   - **Hallucination** — an element, state or behaviour that does not exist. Fixed by grounding, not by argument.
   In the study that classified them, of the findings the model produced that no human found, roughly two-thirds were false alarms and a quarter were hallucinations. Assume the same of your own output and go looking.
9. **Apply the tradeoff test before promoting anything to Confirmed.** A violated principle is not automatically a defect — established heuristic-evaluation practice is explicit that whether it needs fixing depends on context and on the alternatives available. A hamburger menu really does violate recognition-over-recall, and on mobile it's often still right. For every finding ask: *what would the alternative cost, and is there a low-friction recovery path?* If the answer is "the alternative is worse" or "the user recovers in one click," it's a false alarm, not a finding.
10. **Rate severity in a separate pass, over the consolidated list.** Never during discovery — the two compete for attention, which is exactly why single-pass severity labels come out identical. See Deliverable for the scale.

## Deliverable

### Severity: use the established scale, and derive it

Use Nielsen's 0–4 severity scale rather than inventing one. Every UX practitioner reads it fluently, and it has a property an ad-hoc scale lacks: a built-in channel for dissent.

> **0** — not a usability problem at all
> **1** — cosmetic: fix only if spare time allows
> **2** — minor: low priority
> **3** — major: important to fix, high priority
> **4** — catastrophe: must be fixed before release

Don't assign the number directly. Rate the three factors the scale is built from, each a narrow question you can answer from evidence, then derive:

- **Frequency** — is this on the primary path or a rare branch?
- **Impact** — if it happens, can the user recover, and how easily?
- **Persistence** — a one-time stumble once learned, or a tax on every session?

Then average across your independent runs. A mean of several 0–4 ratings is continuous, so ties mostly dissolve on their own — which is the point.

**Present the result as a triage hint, never as a number to trust.** Run-to-run severity agreement for the same model on the same artifact has been measured at only 56% exact, and developers and end users disagreed sharply about severity on the same issue list — sometimes because the model was wrong, sometimes because severity is genuinely contested. Averaging across runs is what makes the ordering usable at all; it does not make any single score authoritative. Never hand this list to someone as a ready-made prioritised backlog. **Do not force a strict 1..N order with no ties.** Earlier drafts of this skill did, on the theory that ties were the enemy; that was backwards. Ties came from single-rater, single-label severity, which established practice already rejects as unreliable. Forced pairwise ranking is separately the *worst*-performing feedback format measured in this literature — expert agreement at chance level, and models trained on it got worse, not better. Mandating an order you have no basis for is hallucinated precision, and this skill exists to suppress exactly that. Rank the top few if it helps the reader; leave the tail scored and unordered.

### Report structure

A polished report is more dangerous than a messy one — opacity presented in a confident format creates a false sense of precision, and that is a documented risk, not a stylistic worry. So state each finding's *evidence basis*, not just its severity, and never let formatting imply certainty the evidence doesn't carry.

For each finding:
- **Severity** (0–4, with the three factors shown) + **Verdict** (Confirmed / False alarm / Hallucination) + **Basis** (verified in code / observed in a screenshot / inferred) + **Runs** (how many independent passes produced it) + **Principle** + **proof** (`file:line` or the named element)
- Then four parts, in this order — the structure that two independent studies found made machine critique usable, and whose absence made experts reject it for containing "too many assumptions":
  1. **The expected standard.** What the principle says should hold here.
  2. **The specific gap in *this* artifact.** Not the category — this element, this line.
  3. **The fix.** Smallest change that closes the gap. Prefer *preventive* designs over corrective ones: disabling invalid choices beats validating them after entry.
  4. **Why.** The concrete user cost, named structurally rather than emotionally.

Then three closing sections that are not optional:

- **Suspected — unverified.** Everything you couldn't confirm, each with the one check that would settle it. Label it honestly: when this was measured, roughly **one in eleven** model-only findings turned out to be a genuine discovery the humans had missed. That one is worth keeping — in the study it was a real interaction failure every professional evaluator overlooked. But a reader must know the base rate before spending time here.
- **Not assessed.** Lenses your evidence base couldn't support, and what you'd need.
- **Cannot be seen from this artifact.** Say it plainly: a static read cannot find discoverability, affordance, or mental-model failures — whether a user realises a panel scrolls, that a control is tappable, or that a feature exists at all. Nor can it see the interactional failures the newest benchmark in this area singles out: a disabled control with no explanation, a form that silently rejects input, a destructive action that hides its consequence, a layout that collapses at a size you never rendered. That benchmark's blunt warning is that a judge inspecting only the first rendered view produces fluent but weakly grounded criticism — so name what you couldn't reach rather than letting a confident report imply you reached it. Heuristic evaluation complements user research; it does not replace it. The honest use of this report is to decide what to put in front of users next.

**If you can actually run the thing, run it.** The same benchmark gates its agents on interaction coverage: a report isn't accepted until the salient controls have genuinely been exercised, and a finding counts only when it links to an observed event. Adopt the spirit of that — click the disabled control, submit the empty form, resize the window, trigger the error branch. Every interaction you actually perform converts a guess into evidence, and this is the single biggest upgrade available to a code-reading auditor.

End with the 2–3 highest-leverage fixes called out.

### Two cheap checks before you ship

**The paste test.** If a finding could be pasted unchanged onto a different screen of a different product, it isn't a finding. "Users might not understand these icons" passes nothing; "the icon at `Toolbar.tsx:34` has no label and no `aria-label`, and its handler archives rather than deletes" is a finding. Vagueness alone was enough to classify findings as false alarms when this was studied.

**The contradiction check.** Read your own findings against each other and ask whether any two assert opposite things about the same element. Models have been observed praising a screen's consistency and condemning its inconsistency inside a single report. This costs one pass and catches an embarrassing class of error.

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

- Truss, *PersonaCite: VoC-Grounded Interviewable Agentic Synthetic AI Personas* (CHI EA 2026) — [arXiv:2601.22288](https://arxiv.org/abs/2601.22288). Source of the abstention mechanism and of the observation that the central risk is implicit limitations rather than inaccuracy.
- Huang, *Evaluating the Trustworthiness of AI Personas in Paired Usability Testing* (CSAI 2025). Paired ten students with matched AI agents; found agents consistently underestimated cognitive load and emotional frustration. Small sample — the direction is what carries, not the percentages.
- Holter, Koh, Dogan & Chan, *UXCascade: Scalable Usability Testing with Simulated User Agents* — [arXiv:2601.15777](https://arxiv.org/abs/2601.15777). Ran GPT-5 in August 2025; source of the finding that agents show significantly lower behavioural variability than humans and are unsuited to aesthetic judgement.
- Kaiser et al., *Simulating Human Opinions with Large Language Models* (UMAP 2025). Source of the substantially-reduced-variance and positivity-bias findings in simulated responses.

- Lewis, Sauro, Schiavone & Plabst, *Does AI Find Real UI Problems or Just Hallucinations?* and the two studies preceding it in the same series, MeasuringU (2026). Source of the Confirmed / false alarm / hallucination taxonomy and its definitions, the one-in-eleven base rate for model-only findings, the 31% and 57% self-agreement figures, the finding that a genuine discovery appeared in every run while hallucinations clustered in single runs, and the five-false-alarms-from-one-misreading result.
- Wu, Swearngin, Vajjala, Leung, Nichols & Barik, *Improving User Interface Generation Models from Designer Feedback* (CHI 2026) — [arXiv:2509.16779](https://arxiv.org/abs/2509.16779). Source of the finding that forced ranking produced expert agreement at chance level and degraded models trained on it, while spatially grounded feedback performed best.
- Nielsen, *Severity Ratings for Usability Problems* (1994) and Moran & Gordon, *How to Conduct a Heuristic Evaluation* (2023), Nielsen Norman Group. Source of the 0–4 scale and its frequency/impact/persistence factors, the requirement to rate severity in a separate pass and to average independent ratings, the three-to-five evaluator recommendation and evaluator independence, the violation-is-not-automatically-a-problem rule, and the coverage baselines above.
- Rosala & Moran, *Synthetic Users* and Sponheim & Brown, *AI UX-Design Tools Are Not Ready for Primetime*, Nielsen Norman Group. Source of the idealisation and flat-prioritisation failure modes and of the prohibition on generating user research data.
- Elman, *The Core Skill of Design in the AI Era: Critique*, Nielsen Norman Group (2026). Source of the objective-but-not-arbitrary criterion rule and of decomposing a wide judgement into narrow component judges.
- Lu, Huang, Han, Yao, Bei, Gesi, Xie, Sang, Wang, He & Wang, *Can LLM Agents Simulate Multi-Turn Human Behavior? Evidence from Real Online Customer Behavior Data* — [arXiv:2503.20749](https://arxiv.org/abs/2503.20749). Source of the ~12% next-action accuracy figure across 230,965 real actions, and of the three named directional biases: assumed task completion, filter overuse, and absence of retry. Also the source of the distinction between accuracy-oriented and cognition-oriented reasoning.
- Lu, Yao et al., *UXAgent* — [arXiv:2502.12561](https://arxiv.org/abs/2502.12561) and [arXiv:2504.09407](https://arxiv.org/abs/2504.09407). Source of the practitioner finding that simulated output is valued as supplementary and as a prompt to revise one's own study design, while sixteen UX researchers disagreed that it can replace human participants.

- Duan, Warner, Li & Hartmann, *Generating Automatic Feedback on UI Mockups with Large Language Models* (CHI 2024), and Duan, Chen, Li, Hartmann & Li, *UICrit* (UIST 2024). Source of the split-the-calls result and the heuristics-in-the-prompt ablation, of the degradation-on-improved-UIs finding, of volume as a hallucination signal, and of the four-part finding template.
- Platt, Luchs & Nizamani, *Catching UX Flaws in Code* — [arXiv:2512.04262](https://arxiv.org/abs/2512.04262). Ran GPT-4o over zipped front-end source. Source of the severity-agreement figure and of the file-and-line citation schema. Note that it measures only self-consistency and establishes no ground truth.
- Court et al., *Heuristic usability assessment of medical software* (J Appl Clin Med Phys, 2026). Ran GPT-5.0 — the newest model with a published evaluation here. Roughly a third of its suggestions were judged actionable, all minor, and seven reached a real change log.

**A note on the state of this evidence.** These sources disagree with each other in places, sometimes sharply — most relevantly about whether auditing from source alone is sufficient at all. Where a research group's own benchmark undercuts its own systems papers, this skill follows the measurement. Reported precision across these studies ranges from 13% to 84%, which reflects how differently each one built its ground truth rather than any real difference in capability, so no single accuracy number is quoted here as authoritative. Several relevant papers sit behind publisher blocks and could not be read; where a claim rests on an abstract alone it is not stated as a number.
