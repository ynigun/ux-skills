# Why the method looks like this

Background for anyone who wants to know where the rules in `SKILL.md` came from. Not needed to run an audit.

Every figure below comes from a published evaluation of LLM-driven usability critique. **All of it was measured on GPT-4-era models, GPT-4o, or Gemini 2.0 Flash**, mostly in 2024–2025. Reported precision across these studies ranges from 13% to 84%, which reflects how differently each built its ground truth rather than a real difference in capability. Treat every number as a direction, not a current-capability estimate.

## The failure modes the rules exist to prevent

**Findings that don't exist.** Reviewers classifying model-generated findings against the truth used three categories worth borrowing: a real problem, a *false alarm* (a true observation misread as a problem), and a *hallucination* (something that never happened). Of the findings a model produced that no human found, roughly two-thirds were false alarms and a quarter hallucinations — and about one in eleven was a genuine discovery every human evaluator had missed. That one is why unverified findings get quarantined instead of deleted.

**Findings with no location.** The single most common complaint from engineers receiving machine-generated reports is not being told *which* element. Vagueness alone was enough for reviewers to classify a finding as a false alarm.

**Claiming something is absent when it isn't.** Models flagged missing validation that was implemented elsewhere. Hence: search several spellings, check the layer above, and report what you searched.

**Severity ties.** Asked for a severity label in one pass, models return many identical ones. Exact run-to-run severity agreement for the same model on the same artifact measured 56%. Hence: separate pass, derived from frequency/impact/persistence, averaged across runs, presented as a triage hint.

**One wrong premise, reported five times.** In one study five of seven false findings traced to a single misreading of what the user was doing. Hence: cluster by shared *assumption*, not just shared root cause.

**Duplicates.** Per-screen and per-lens passes each treat their slice as fresh, producing eight or nine duplicates per app where human evaluators produced zero. Hence the explicit aggregation step.

## The two findings that shaped the process most

**Recall is the weak half.** A model given source code, a screenshot and app context reached precision 0.61–0.66 but recall 0.35–0.38 — and that precision spread is across two expert graders scoring the same output, who agreed only moderately (κ = 0.53). The authors ask that recall be read as indicative. Separately, screenshot-based sweeps reached 73–77% coverage against 55–63% for five-evaluator human panels. For calibration, Nielsen's baselines put one human evaluator at 20–50% and three to five specialists at 74–87%: a model sits inside the specialist band, not above it.

**Models default to "the user succeeds."** Benchmarked against 230,965 real recorded actions, the best prompt-only models predicted the human's actual next action about 12% of the time — and the errors point one way. Models assume the task completes where real users quit, overuse filters (real users searched roughly seven times more often than they filtered), and assume no retries (real users averaged nearly three searches per session, fixing typos). Because models are trained and benchmarked on task completion, an ungrounded agent's default story is "the user succeeds, uses the sophisticated controls, never makes a mistake" — the exact story that makes a broken interface look fine.

## What measurably improves results

- **Keep the principle's text in context.** Removing the explicit heuristic definitions cut useful findings by nearly two-thirds while output volume barely changed. This is why the lenses are files you open, not names you recall.
- **Separate the passes.** Collapsing detection and phrasing into one call reduced useful findings, broke the output format every time, and silently dropped the fix instructions. Evaluating each heuristic on its own produced more varied, more detailed findings.
- **Multiple independent runs.** Model self-agreement measured 31% and 57%; in the worse case two runs of the same prompt shared no findings at all. The one genuine discovery appeared in every run; two of three hallucinations came from a single run.
- **Resolve values before asking about consistency.** Studies disagree on whether models are good at consistency findings — best in one, worst in another. The difference tracks the input: given computed sizes and colours it's arithmetic; asked to infer consistency across raw files it fails.
- **Interaction evidence.** The newest benchmark gates its agents on actually exercising controls, and counts a finding only when it links to an observed event, on the grounds that a judge inspecting only a static view produces fluent but weakly grounded criticism.

## Two things to stay honest about

**An empty result is valid.** When designers used one of these tools iteratively its accuracy fell from 52% to 39%: as the interface improved there was less to find, so the model manufactured violations to fill the space. Volume is a warning sign, not coverage.

**Claims about feelings are worse than claims about numbers.** Paired studies found AI agents consistently underestimate human cognitive load and emotional frustration, and browser agents are unsuited to judging aesthetics. The best-grounded persona system in this literature concluded that grounding improves trust but not certainty, and that "the central risk of AI personas is not inaccuracy, but implicit limitations."

## An unresolved disagreement

Two papers disagree head-on about whether auditing from source alone is sufficient. One presents code-only evaluation as the advantage — no rendering needed, works early — but never validates against any ground truth. The other, six months newer and the only one that measures whether critique leads to real improvement, argues that many failures are interactional and invisible in a static snapshot: a disabled control with no explanation, a form that silently rejects input, a layout that collapses at a size you never rendered. This skill does not resolve the disagreement; it states what a static read cannot see and tells you to run the app when you can.

## Sources

- Lubos, Felfernig, Garber, Le & Henrich, *Recommending Usability Improvements with Multimodal Large Language Models*, ACM FSE 2026 — [arXiv:2604.25420](https://arxiv.org/abs/2604.25420)
- Ebrahimi Pourasad & Maalej, *Does GenAI Make Usability Testing Obsolete?*, ICSE 2025 — [arXiv:2411.00634](https://arxiv.org/abs/2411.00634)
- Zhong, McDonald & Hsieh, *Synthetic Heuristic Evaluation* — [arXiv:2507.02306](https://arxiv.org/abs/2507.02306)
- Wang et al., *UXBench* — [arXiv:2606.16262](https://arxiv.org/abs/2606.16262)
- Lu et al., *Can LLM Agents Simulate Multi-Turn Human Behavior?* — [arXiv:2503.20749](https://arxiv.org/abs/2503.20749)
- Duan, Warner, Li & Hartmann, *Generating Automatic Feedback on UI Mockups with LLMs*, CHI 2024; and Duan, Chen, Li, Hartmann & Li, *UICrit*, UIST 2024
- Platt, Luchs & Nizamani, *Catching UX Flaws in Code* — [arXiv:2512.04262](https://arxiv.org/abs/2512.04262)
- Wu, Swearngin, Vajjala, Leung, Nichols & Barik, *Improving User Interface Generation Models from Designer Feedback*, CHI 2026 — [arXiv:2509.16779](https://arxiv.org/abs/2509.16779)
- Truss, *PersonaCite*, CHI EA 2026 — [arXiv:2601.22288](https://arxiv.org/abs/2601.22288)
- Guerino et al., *Can GPT-4o evaluate usability like human experts?*, INTERACT 2025
- Lewis, Sauro, Schiavone & Plabst, *Does AI Find Real UI Problems or Just Hallucinations?* and the two preceding studies, MeasuringU 2026
- Nielsen, *Severity Ratings for Usability Problems* (1994); Moran & Gordon, *How to Conduct a Heuristic Evaluation* (2023); Elman, *The Core Skill of Design in the AI Era: Critique* (2026) — Nielsen Norman Group
