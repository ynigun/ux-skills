# Attribution

## UX principles

The 30 principles in `skills/ux-heuristics-audit/laws/` are long-standing findings from cognitive psychology and human-computer interaction — Hick (1952), Fitts (1954), Miller (1956), the Gestalt school, Tversky and Kahneman, and others. Each lens file cites its own source.

The selection and grouping of these particular 30 as a working set follows **[Laws of UX](https://lawsofux.com/) by Jon Yablonski**, which is an excellent reference and worth reading directly.

All text in this repository — definitions, verification steps, examples and guidance — is our own. No text is reproduced from that site. This project is not affiliated with, endorsed by, or derived from the Laws of UX content, and is released under the MIT licence in `LICENSE`.

## Research informing the LLM-auditor guidance

The method's specifics — running the sweep more than once, rating severity in a separate pass, the tradeoff test, treating an empty result as valid — come from published evaluations of machine-generated usability critique. Figures and full discussion are in `skills/ux-heuristics-audit/references/research-notes.md`.

These studies were run on the model generations available at the time of writing, mostly GPT-4-era models, GPT-4o, and Gemini 2.0 Flash. Reported precision across them ranges from 13% to 84%, which reflects how differently each built its ground truth rather than a real difference in capability. Treat every figure as a direction, not a current-capability estimate.

- Lubos, Felfernig, Garber, Le & Henrich, *Recommending Usability Improvements with Multimodal Large Language Models*, ACM FSE 2026 — [arXiv:2604.25420](https://arxiv.org/abs/2604.25420)
- Ebrahimi Pourasad & Maalej, *Does GenAI Make Usability Testing Obsolete?*, ICSE 2025 — [arXiv:2411.00634](https://arxiv.org/abs/2411.00634)
- Zhong, McDonald & Hsieh, *Synthetic Heuristic Evaluation* — [arXiv:2507.02306](https://arxiv.org/abs/2507.02306)
- Wang et al., *UXBench: Measuring the Actionability of LLM-Generated UX Critiques* — [arXiv:2606.16262](https://arxiv.org/abs/2606.16262)
- Lu et al., *Can LLM Agents Simulate Multi-Turn Human Behavior?* — [arXiv:2503.20749](https://arxiv.org/abs/2503.20749)
- Duan, Warner, Li & Hartmann, *Generating Automatic Feedback on UI Mockups with LLMs*, CHI 2024; and Duan, Chen, Li, Hartmann & Li, *UICrit*, UIST 2024
- Platt, Luchs & Nizamani, *Catching UX Flaws in Code* — [arXiv:2512.04262](https://arxiv.org/abs/2512.04262)
- Wu, Swearngin, Vajjala, Leung, Nichols & Barik, *Improving User Interface Generation Models from Designer Feedback*, CHI 2026 — [arXiv:2509.16779](https://arxiv.org/abs/2509.16779)
- Truss, *PersonaCite*, CHI EA 2026 — [arXiv:2601.22288](https://arxiv.org/abs/2601.22288)
- Guerino, Rodrigues, Capeleti, Mello, Freire & Zaina, *Can GPT-4o evaluate usability like human experts?*, INTERACT 2025
- Lewis, Sauro, Schiavone & Plabst, *Does AI Find Real UI Problems or Just Hallucinations?* and the two preceding studies in the series, MeasuringU 2026
- Nielsen, *Severity Ratings for Usability Problems* (1994); Moran & Gordon, *How to Conduct a Heuristic Evaluation* (2023); Elman, *The Core Skill of Design in the AI Era: Critique* (2026) — Nielsen Norman Group

## Method

The code-reading method in `skills/ux-heuristics-audit/references/reading-the-code.md` adapts patterns from two existing approaches: phased root-cause investigation and pattern analysis (find a working example, read it completely, list every difference) from the `superpowers` systematic-debugging skill, and deterministic structural extraction before semantic judgement, plus following dependency edges in both directions, from the `understand-anything` plugin.
