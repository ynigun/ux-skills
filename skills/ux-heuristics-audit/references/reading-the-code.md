# Reading the code systematically

The lenses tell you *what* to look for. This tells you how to move through a codebase so you actually find it.

None of this is UX-specific — it's borrowed from methods that already work for agents reading code: structural extraction before judgement, following the dependency graph in both directions, finding a working example and diffing against it, and tracing backward from a symptom to its source.

## The rule that makes the rest work

```
NO FINDING WITHOUT READING THE CODE THAT PRODUCES IT
```

Not the file name. Not the grep line. The code. Everything below is in service of that.

---

## Phase 1 — Extract structure mechanically, before you judge anything

The most reliable code-analysis tools available all do the same thing first: run a **deterministic extraction** to get structure, then apply judgement on top of the result. Never ask yourself to hold a codebase in your head when a command can hand you the facts.

Get these before forming a single opinion:

- **Routes / screens.** Find the router. File-based routing (`app/`, `pages/`, `routes/`) gives you the list from `find`. Otherwise grep the route-definition call (`createBrowserRouter`, `<Route`, `@app.route`, `r.Get(`). This list is the audit's scope.
- **Domain objects.** From the data layer, not the UI: schema files, migrations, model definitions, the shared types file.
- **State.** Grep for store creation (`createContext`, `writable(`, `useReducer`, `zustand`, `signal(`). State that lives inside a component dies with it — that fact alone produces findings.
- **The central stylesheet.** Read it end to end, once. Highest-yield read in the audit: a rule targeting a bare tag silently overrides scoped component styles everywhere, and no amount of component reading reveals it.

**If the project has a knowledge graph** (`.understand-anything/knowledge-graph.json`, from `/understand`), use it — it already contains the file/function/class nodes and the imports/calls/contains edges, and grepping it is far cheaper than rebuilding the map by hand. If not and the codebase is large, the `Explore` agent can do this sweep and hand you back the map without filling your context with file dumps.

Record no findings during this phase.

## Phase 2 — Query the index; read only what you need

Once you have a map, don't read the codebase — query it.

- Grep the index or the tree for candidates. Open only the files a candidate points at.
- **Grep locates; reading judges.** Judging from a grep excerpt is the most common way to be confidently wrong — the guard clause three lines above the match usually decides whether there's a bug at all.
- Read the imports before the body. Half of "this isn't handled" is handled by something imported from elsewhere.
- When a file is the subject of a finding and it's under a few hundred lines, read all of it.

## Phase 3 — Follow edges in *both* directions

Dependency edges have a direction, and the one people forget is the one that matters most.

- **Outgoing** — what does this call, import, depend on? Tells you what it does.
- **Incoming** — *what calls this?* Tells you whether a problem is reachable, how many places share it, and whether the "fix" would break three other screens.

A finding with no incoming trace is a finding you can't size. Before reporting a component defect, grep for its usages: one caller means a local fix, twelve means a systemic one — and that difference is the whole severity rating.

## Phase 4 — Find the working example and diff against it

This is the single most valuable technique here, borrowed straight from systematic debugging, and it converts a subjective judgement into a comparison.

Almost every codebase already does the thing right *somewhere*. Before declaring a violation:

1. **Find a working example in the same codebase.** Another form that does validate. Another list that does have an empty state. Another destructive action that does confirm.
2. **Read it completely** — not skimmed.
3. **List every difference,** however small. Don't assume "that can't matter."

You now have a finding of a different quality: not "this form should probably validate," but "`CheckoutForm.tsx` validates on blur and shows an inline error; `ProfileForm.tsx:88` does neither, and they're the same component pattern."

And if you *can't* find a working example anywhere — that's meaningful too. It means you're proposing a new convention, not fixing a deviation, which is a much bigger ask and should be labelled as one.

## Phase 5 — Trace backward from the symptom to the source

When something is wrong at the render layer, don't fix it at the render layer. Trace upward until the value stops being wrong:

- Where does the bad value get displayed?
- What passed it in?
- What produced it there?
- Keep going until you reach the origin.

The finding belongs at the origin. Three screens showing a mangled string are one finding about the parser, not three findings about screens.

Same technique in the other direction for absence: to show a value isn't carried across a wizard step, follow it from where it's captured to every place it's read, and name the point where the trail stops.

## Phase 6 — One hypothesis at a time

State it explicitly: *"I think X is a violation because Y."* Then check that one thing, minimally, against the code. Not five at once — you won't know which observation supported which claim, and neither will the reader.

## Techniques that repay their cost

**Read both sides of every seam.** Real defects live where two things meet, and you only see them holding both:

| Seam | Read together |
|---|---|
| Label ↔ behaviour | the button's text **and** its handler |
| Client ↔ server | the form's validation **and** the endpoint's |
| Write ↔ read | the INSERT/UPDATE **and** every SELECT that filters on it |
| Component ↔ cascade | the component's styles **and** the global rules hitting the same tags |
| State ↔ render | where the flag is set **and** whether any template reads it |

A `loading` flag that's set but never rendered is a real bug, invisible from either side alone.

**Proving absence needs more than one grep.** Search the concept, not one spelling, then check the layer above (a wrapper, middleware, a base class, a global handler):

- Validation — `validate|schema|zod|yup|joi|pattern=|required`
- Soft delete — `deleted_at|is_deleted|archived|status|trash|restore`
- Loading — `loading|isLoading|pending|busy|submitting|skeleton|spinner`
- Accessible name — `aria-label|aria-labelledby|<label|sr-only|title=`

If you still find nothing, write **"I searched X, Y, Z and found none"** — honest and still actionable.

**Answer consistency questions mechanically.** Comparing across files from memory is exactly what you're worst at. Collect first, into one list you can see at once, then compare:

```bash
grep -rho 'variant="[a-z]*"' src/ | sort | uniq -c | sort -rn
```

**Walk the unhappy paths.** The happy path is what the code was written for. Findings concentrate in the zero-item branch, the `catch`, the pending state, the 200-character string, the interrupted flow, the unauthorised view.

**Let tests and churn point.** Tests document intent — you need intent to claim a mismatch. And `git log --since="3 months ago" --name-only --pretty=format: | sort | uniq -c | sort -rn | head -20` gives you the churn list; fresh code carries more defects than stable code.

## Red flags — stop and go back a phase

If you catch yourself thinking any of these, you've skipped a phase:

| Thought | Reality |
|---|---|
| "I can tell from the file name" | You can't. Open it. |
| "The grep line is enough" | The deciding logic is usually just outside the match. |
| "This looks like a bug I've seen" | Then confirm it here, in this code. |
| "There's no validation" (after one grep) | Search other spellings and the layer above first. |
| "This is obviously confusing to users" | You can't assess that. Name the structural cause instead. |
| "I'll note it now and verify later" | You won't, and it'll ship as confirmed. |
| "I have enough findings" | Coverage isn't a feeling. Finish the sweep. |

## When one area produces three or more findings

Stop reporting and ask whether it's intentional. Three "violations" clustered in one component usually means one of three things: a deliberate pattern you haven't understood, one root cause with three symptoms, or one wrong assumption of yours reproducing itself. All three call for going back to Phase 4 and finding out how the rest of the codebase handles the same situation — not for filing three findings.

## Know when to stop and say so

If a finding depends on something you genuinely cannot see from here — rendered geometry, an external API's response shape, what a third-party component does internally — stop and write down what you'd need. An audit that names its blind spots is worth more than one that covers them with a confident guess.
