# ux-skills

Three Claude Code skills for auditing user interfaces — built for an agent that reads code, not a person looking at a screen.

Most UX guidance assumes eyes on a rendering. An agent has source, and its failure modes are specific: it reports problems that aren't there, describes them without saying where, flags functionality that's already implemented, and — because models are trained on task completion — narrates a smooth path through the UI where a real user would have quit. Every skill here is shaped around preventing that while keeping enough coverage to be worth running.

## Install

```
/plugin marketplace add ynigun/ux-skills
/plugin install ux-skills@ux-skills
```

## The skills

### `ux-heuristics-audit` — find the principle violations

Heuristic evaluation across 30 established UX principles, one file per principle.

The organising idea is **OOUX**: map the domain objects first — their states, their actions, their relationships, pulled from schemas and handlers rather than from buttons you happened to notice — then sweep each principle across that map. Each principle declares its **unit of analysis** (11 apply to objects, 11 to screens, 8 to flows), so the sweep is a list you walk rather than a judgement call about where to look. Every cell ends as a finding or an explicit *n/a*, and the report opens with the resulting coverage grid.

That grid is the point. It's what separates "I found four problems" from "I checked ninety cells and four of them bit."

Each lens carries what to look for, **how to verify it from the code**, and **what is not a violation** — the already-handled cases that look like bugs and produce most false findings.

### `ux-audit` — find the bugs

End-to-end audit for functional UX defects, in three layers over every object in the feature: an object/state/action sweep that catches unreachable and irreversible states, a lifecycle trace following each attribute from write to render, and a visual contract pass covering cascade collisions, RTL leakage, dynamic-content edge cases and breakpoints.

Use it for: "why does this feel broken", state-machine traps, data that silently disappears, layout that breaks in one language.

### `auditing-responsive-layout` — measure, don't eyeball

Layout bugs that appear only at certain widths or in certain persisted UI states. Ships a headless probe that walks `widths × states` plus a resize-without-reload pass and reports computed geometry, because a screenshot hides inset scrollbars, clipped overflow and computed margins.

Use it for: horizontal scroll on mobile, a stray strip down one side, "works on my machine", a bug that only shows in device mode.

## Which one

| Symptom | Skill |
|---|---|
| Something is broken or loses data | `ux-audit` |
| Nothing is broken but it's harder to use than it should be | `ux-heuristics-audit` |
| It only breaks at some screen width | `auditing-responsive-layout` |

They compose. A full review runs all three and says so.

## How the code actually gets read

`skills/ux-heuristics-audit/references/reading-the-code.md` is shared by all three, and it's the part that makes the audits systematic rather than impressionistic. One rule governs it — *no finding without reading the code that produces it* — and the two techniques that do the most work are:

- **Find the working example and diff against it.** Almost every codebase already does the thing right somewhere. "This form should validate" is an opinion; "`CheckoutForm.tsx` validates on blur and shows an inline error, `ProfileForm.tsx:88` does neither, same pattern" is a finding.
- **Follow the incoming edges, not just the outgoing ones.** Who calls this? One caller is a local fix, twelve is systemic — and that difference is the severity rating.

## Licence

MIT — see `LICENSE`. Attribution for the principle taxonomy, the research behind the LLM-auditor guidance, and the code-reading patterns is in `NOTICE.md`.
