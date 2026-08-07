# Publish ux-skills to GitHub — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Turn `/root/ux-skills` into a public, installable Claude Code plugin marketplace containing three UX audit skills, with no internal project details and no third-party licensing exposure.

**Architecture:** A single repo that is simultaneously the marketplace and the plugin: `.claude-plugin/marketplace.json` at the root declares one plugin whose `source` is `./`, and `.claude-plugin/plugin.json` describes it. The three skills live under `skills/`. A `scripts/validate.sh` harness encodes every publication constraint (no copied text, no broken links, no internal identifiers, valid manifests) and runs both locally and in CI — it is the test suite for a repo whose product is prose.

**Tech Stack:** Markdown skills, Bash + `jq` for validation, GitHub Actions for CI, `gh` CLI for repo creation.

---

## Assumptions (confirm before Task 9)

These were asked by email and are not yet answered. Tasks 1–8 are safe under any answer; **Task 9 pushes to GitHub and must not run until these are confirmed.**

| Decision | Assumed | Where it bites |
|---|---|---|
| Repo name | `ux-skills` | Task 7, Task 9 |
| Visibility | **Public** | Task 9 (`--public`) |
| Rename `lawsofux-audit` → `ux-heuristics-audit` | **Yes** | Task 1 (skip the task if no) |

Already settled: licence is MIT for our own text (all 30 definitions were rewritten in original wording, so CC BY-NC-ND no longer applies); `ux-audit` gets cleaned of internal detail rather than held back.

## Current state

Two commits already landed on `main` in `/root/ux-skills`:
- `22a80d1` — 30 lens files rewritten, links fixed, per-lens verification and false-positive sections added
- `f37d232` — recall/evidence-base/actionability guidance from the UX-LLM research

Everything below is the remaining work.

## File Structure

| Path | Responsibility |
|---|---|
| `scripts/validate.sh` | **New.** All publication constraints as executable checks. The test suite. |
| `.github/workflows/validate.yml` | **New.** Runs `validate.sh` on push and PR. |
| `skills/ux-audit/SKILL.md` | **Modify.** Strip internal domain model, column names and war stories; add LLM-auditor section; link out to the two new reference files. |
| `skills/ux-audit/references/svelte-5.md` | **New.** Svelte 5 traps, moved out of SKILL.md so non-Svelte users never load them. |
| `skills/ux-audit/references/backend-web.md` | **New.** Server-side traps, moved out and de-Go-ified. |
| `skills/auditing-responsive-layout/SKILL.md` | **Modify.** One paragraph on running the probe without the `dev-browser` CLI. |
| `skills/ux-heuristics-audit/` | **Rename** of `skills/lawsofux-audit/` (Task 1). |
| `README.md` | **New.** What it is, install, what each skill does. |
| `LICENSE` | **New.** MIT. |
| `NOTICE.md` | **New.** Attribution for the principle taxonomy and research sources. |
| `.claude-plugin/plugin.json` | **New.** Plugin descriptor. |
| `.claude-plugin/marketplace.json` | **New.** Marketplace descriptor pointing at `./`. |

---

## Task 1: Rename the heuristics skill

**Skip this task entirely if the rename decision is "no".**

**Files:**
- Rename: `skills/lawsofux-audit/` → `skills/ux-heuristics-audit/`
- Modify: `skills/ux-heuristics-audit/SKILL.md` (frontmatter `name:`)
- Modify: `skills/ux-audit/SKILL.md` (cross-reference in `description:` and in Anti-patterns)

- [ ] **Step 1: Rename the directory with git so history follows**

```bash
cd /root/ux-skills
git mv skills/lawsofux-audit skills/ux-heuristics-audit
```

- [ ] **Step 2: Update the skill's own name in frontmatter**

Edit `skills/ux-heuristics-audit/SKILL.md` line 2. Replace:

```yaml
name: lawsofux-audit
```

with:

```yaml
name: ux-heuristics-audit
```

- [ ] **Step 3: Update every cross-reference to the old name**

```bash
cd /root/ux-skills
grep -rn "lawsofux-audit" skills/ docs/ || echo "no references left"
```

Two are expected, both in `skills/ux-audit/SKILL.md` — the `description:` frontmatter and the "Confusing this with" anti-pattern line. Replace `lawsofux-audit` with `ux-heuristics-audit` in both. Do **not** touch `lawsofux.com` URLs — those are the attribution links and must stay.

- [ ] **Step 4: Verify no stale references and the URLs survived**

```bash
cd /root/ux-skills
grep -rn "lawsofux-audit" skills/ ; echo "---"; grep -rc "lawsofux.com" skills/ux-heuristics-audit/laws/*.md | grep -c ":1$"
```

Expected: no output from the first grep; `30` from the second (each lens file keeps exactly one attribution URL).

- [ ] **Step 5: Commit**

```bash
cd /root/ux-skills
git add -A
git commit -m "Rename lawsofux-audit to ux-heuristics-audit

The skill is named after the principles it applies, not after the
third-party site that catalogues them."
```

---

## Task 2: Build the validation harness

This is the test suite. Write it first; it must **fail** on the current tree because `ux-audit` still contains internal identifiers. Tasks 3–8 make it pass.

**Files:**
- Create: `scripts/validate.sh`

- [ ] **Step 1: Write the failing validation script**

Create `scripts/validate.sh`:

```bash
#!/usr/bin/env bash
# Publication constraints for the ux-skills repo. Run before every push.
# Exits non-zero and prints every failure; does not stop at the first one.
set -uo pipefail
cd "$(dirname "$0")/.."

fail=0
err() { echo "FAIL: $*"; fail=1; }
ok()  { echo "  ok: $*"; }

echo "== 1. No third-party text reproduced verbatim =="
# Every lens definition must be our own wording. The old format was a
# markdown block quote ending in an attribution link on the same line.
if grep -rn '^> .*lawsofux\.com' skills/ >/dev/null 2>&1; then
  grep -rn '^> .*lawsofux\.com' skills/
  err "block-quoted definitions found — these were copied from lawsofux.com"
else
  ok "no copied definitions"
fi

echo "== 2. Attribution present in every lens file =="
lensdir=$(ls -d skills/*heuristics-audit/laws skills/lawsofux-audit/laws 2>/dev/null | head -1)
if [ -z "$lensdir" ]; then
  err "cannot locate the laws/ directory"
else
  missing=0
  for f in "$lensdir"/*.md; do
    grep -q "Wording here is our own" "$f" || { echo "  $f"; missing=1; }
  done
  [ "$missing" -eq 1 ] && err "lens files missing the attribution footer" || ok "all lens files attributed"
fi

echo "== 3. No lawsofux.com URLs use the non-existent /laws/ path =="
if grep -rn 'lawsofux\.com/laws/' skills/ >/dev/null 2>&1; then
  grep -rn 'lawsofux\.com/laws/' skills/
  err "these URLs 404 — the site has no /laws/ segment"
else
  ok "attribution URLs use the correct path"
fi

echo "== 4. No internal project identifiers =="
# Terms that would disclose our own stack, infrastructure, or audit history.
pattern='fs-k8s|freeswitch|comax|uman\.pw|agentmail|mail-bot|babysitter|ynigun|148ylr|a5c|/root/|127\.0\.0\.1:[0-9]|body_text|is_deleted|unconvert'
if grep -rniE "$pattern" skills/ README.md NOTICE.md 2>/dev/null | grep -v '^Binary'; then
  err "internal identifiers found (see above)"
else
  ok "no internal identifiers"
fi

echo "== 5. No stray hook logs or hidden state committed =="
if git ls-files | grep -E '(^|/)\.a5c/|\.log$' >/dev/null 2>&1; then
  git ls-files | grep -E '(^|/)\.a5c/|\.log$'
  err "hook logs are tracked by git"
else
  ok "no hook logs tracked"
fi

echo "== 6. Every relative markdown link resolves =="
broken=0
while IFS= read -r f; do
  d=$(dirname "$f")
  grep -o '](\([^)#]*\.md\))' "$f" 2>/dev/null | sed 's/](\(.*\))/\1/' | while read -r t; do
    case "$t" in http*) continue;; esac
    [ -f "$d/$t" ] || echo "  $f -> $t"
  done
done < <(find . -name '*.md' -not -path './.git/*') > /tmp/ux-broken-links.txt
if [ -s /tmp/ux-broken-links.txt ]; then cat /tmp/ux-broken-links.txt; broken=1; fi
[ "$broken" -eq 1 ] && err "broken relative links" || ok "all relative links resolve"

echo "== 7. Every skill has valid frontmatter =="
for s in skills/*/SKILL.md; do
  head -1 "$s" | grep -q '^---$' || err "$s: missing frontmatter opening"
  grep -q '^name: ' "$s" || err "$s: missing name:"
  grep -q '^description: ' "$s" || err "$s: missing description:"
  dir=$(basename "$(dirname "$s")")
  nm=$(grep '^name: ' "$s" | head -1 | sed 's/^name: *//')
  [ "$dir" = "$nm" ] || err "$s: name '$nm' does not match directory '$dir'"
done
ok "frontmatter checked"

echo "== 8. Manifests are valid JSON and internally consistent =="
for j in .claude-plugin/plugin.json .claude-plugin/marketplace.json; do
  if [ ! -f "$j" ]; then err "$j missing"; continue; fi
  jq empty "$j" 2>/dev/null || err "$j is not valid JSON"
done
if [ -f .claude-plugin/marketplace.json ]; then
  jq -r '.plugins[].skills[]?' .claude-plugin/marketplace.json 2>/dev/null | while read -r p; do
    [ -d "${p#./}" ] || echo "  declared skill path missing: $p"
  done > /tmp/ux-missing-skills.txt
  if [ -s /tmp/ux-missing-skills.txt ]; then cat /tmp/ux-missing-skills.txt; err "marketplace declares skills that do not exist"; else ok "declared skill paths exist"; fi
fi

echo
if [ "$fail" -eq 0 ]; then echo "ALL CHECKS PASSED"; else echo "VALIDATION FAILED"; fi
exit "$fail"
```

- [ ] **Step 2: Make it executable and run it to verify it fails**

```bash
cd /root/ux-skills
chmod +x scripts/validate.sh
./scripts/validate.sh
```

Expected: exits non-zero, printing `VALIDATION FAILED`. At minimum check 4 fails (`ux-audit/SKILL.md` still contains `body_text`, `is_deleted`, `unconvert`) and check 8 fails (no manifests yet). This failure is the point — it proves the harness detects the problems Tasks 3–8 fix.

- [ ] **Step 3: Commit the harness**

```bash
cd /root/ux-skills
git add scripts/validate.sh
git commit -m "Add publication validation harness

Encodes every constraint that must hold before this repo is public:
no reproduced third-party text, correct attribution, no internal
identifiers, no stray hook logs, resolving links, valid manifests."
```

---

## Task 3: Move the Svelte traps into a reference file

**Files:**
- Create: `skills/ux-audit/references/svelte-5.md`
- Modify: `skills/ux-audit/SKILL.md` (delete the `## Svelte 5 specific traps` section)

- [ ] **Step 1: Create the reference file**

Create `skills/ux-audit/references/svelte-5.md`:

```markdown
# Svelte 5 traps

Open this file only when auditing a Svelte 5 codebase. Each item is a
class of bug that a per-component read will not surface.

- **Module-level `$state` in `.svelte.ts` stores** — server-side rendering
  pollution. A store declared at module scope is shared across every request
  the server handles, so one user's state leaks into another's page. Use
  `setContext`/`getContext` so each request gets its own instance.

- **`await` inside state mutators** — without a staleness guard, a rapid
  A-then-B click can resolve A last, leaving the UI showing B's selection
  with A's data. Capture the id before the await and bail after it:
  `if (currentId !== startedId) return`.

- **`onMount(() => { if (reactiveValue) ... })`** — `onMount` runs once, with
  whatever the value was at mount. It does not re-run when the value changes.
  Use `$effect` when the behaviour should track the value.

- **Debounce timers** — every path that cancels the pending work must clear
  the timer. Route change, filter switch, form reset, component destroy. If
  only one of them clears it, the others leak a stale callback.

- **Long-lived polls** — every caller that can start the poll must be able to
  stop it, and the active count must be refcounted. Otherwise the first
  caller owns the poll forever and later callers can never stop it.
```

- [ ] **Step 2: Delete the section from SKILL.md**

In `skills/ux-audit/SKILL.md`, delete the entire `## Svelte 5 specific traps (when applicable)` heading and its five bullets.

- [ ] **Step 3: Verify the section is gone and the file is smaller**

```bash
cd /root/ux-skills
grep -c "Svelte 5 specific traps" skills/ux-audit/SKILL.md
```

Expected: `0`.

- [ ] **Step 4: Commit**

```bash
cd /root/ux-skills
git add skills/ux-audit/
git commit -m "Move Svelte 5 traps to a reference file

Loaded only when the project is Svelte, instead of sitting in the
main method file for every reader."
```

---

## Task 4: Move and de-scope the backend traps

The originals name a specific Go router and describe one real integration bug. Both are generalised here.

**Files:**
- Create: `skills/ux-audit/references/backend-web.md`
- Modify: `skills/ux-audit/SKILL.md` (delete the `## Backend specific traps` section)

- [ ] **Step 1: Create the reference file**

Create `skills/ux-audit/references/backend-web.md`:

```markdown
# Server-side traps

Open this file when the audit reaches the server. These are the write-side
defects that surface to users as impossible states, ghost rows, or data that
silently disappears.

- **Partial-commit windows** — any flow that writes to two tables without a
  transaction can leave the first written and the second not. The user sees a
  half-created object. Wrap multi-table writes in a transaction with an
  explicit rollback on every error path.

- **Silent error swallowing** — an error path that returns without logging
  makes the resulting user-visible bug undiagnosable. Every write-side error
  should log before it returns.

- **Path parameter encoding** — many HTTP routers hand you the raw path
  segment without URL-decoding it. Any identifier that can contain `/`, `%`,
  `+` or an email address will arrive mangled. Decode explicitly, and test
  with an identifier containing a reserved character.

- **Structured values arriving as strings** — when an upstream sends a JSON
  array where the schema expects a scalar, a permissive parser can hand you
  the literal text `["a","b"]` as the value. It then flows into the UI and
  renders as itself. Validate the shape at the boundary, not at the point of
  display.

- **Incomplete soft-delete filters** — the moment a table gains a
  soft-delete column, every existing query needs the corresponding filter.
  Miss one and deleted rows reappear in whichever list that query feeds.
  Enumerate the reads when the column is added; don't fix them as they're
  reported.

- **Timezone drift on stored timestamps** — a value written in one zone and
  read in another shifts by hours. Check that storage is timezone-aware and
  that formatting happens at the edge, not in the query.
```

- [ ] **Step 2: Delete the section from SKILL.md**

In `skills/ux-audit/SKILL.md`, delete the entire `## Backend specific traps (when applicable)` heading and its five bullets.

- [ ] **Step 3: Verify the internal identifiers are gone**

```bash
cd /root/ux-skills
grep -nE 'body_text|is_deleted|chi/mux' skills/ux-audit/SKILL.md skills/ux-audit/references/*.md
```

Expected: no output. (`body_text` is still present elsewhere in SKILL.md at this point — Task 5 removes it. If it appears here, that's the Task 5 occurrence and is expected only in `SKILL.md`.)

- [ ] **Step 4: Commit**

```bash
cd /root/ux-skills
git add skills/ux-audit/
git commit -m "Move server-side traps to a reference file, generalised

Same defects, without naming one specific router or one specific
upstream integration."
```

---

## Task 5: Strip the internal domain model and audit history from ux-audit

This is the task that removes the disclosure: our object model, our column names, and findings from our own production audits.

**Files:**
- Modify: `skills/ux-audit/SKILL.md`

- [ ] **Step 1: Replace the OOUX example table**

Find this block:

```markdown
For each domain object (e.g. Email, Draft, Thread, Rule), fill in:

| Object | CTAs | States | Relationships |
|--------|------|--------|---------------|
| Email  | archive, star, delete, convert, forward, reply, mark-read/unread | new, read, archived, converted, deleted | belongs-to Thread, has-many Attachments |
```

Replace it with:

```markdown
For each domain object in the feature (whatever the product's nouns are —
Order, Document, Booking, Ticket), fill in:

| Object | CTAs | States | Relationships |
|--------|------|--------|---------------|
| Order  | place, pay, ship, cancel, refund, archive | draft, placed, paid, shipped, cancelled, refunded | belongs-to Customer, has-many LineItems |
```

- [ ] **Step 2: Remove the product-specific terminal-state example**

Find:

```markdown
- Every state — is there a path back? (**Terminal states are the #1 trap** — "Converted" with no unconvert, "Deleted" with no restore.)
```

Replace with:

```markdown
- Every state — is there a path back? (**Terminal states are the #1 trap** — a "Cancelled" with no reinstate, a "Deleted" with no restore.)
```

- [ ] **Step 3: Remove the column name from the lifecycle section**

Find:

```markdown
This layer catches: partial commits, orphan rows, stale reads, silent truncation (e.g. `LEFT(body_text, 200)`), timezone drift, JSON-array-stringified-as-string bugs.
```

Replace with:

```markdown
This layer catches: partial commits, orphan rows, stale reads, silent truncation (a `LEFT(col, n)` in a list query that the detail view doesn't apply), timezone drift, and structured values that arrive as strings.
```

- [ ] **Step 4: Rewrite the severity examples so they aren't our findings**

Find:

```markdown
   - **Critical** = feature is broken or user loses work (black box body, no restore from trash, silent data loss)
   - **Major** = flow works but confuses users (wrong prefix language, no delivery badge, no loading state)
```

Replace with:

```markdown
   - **Critical** = feature is broken or the user loses work (content renders unreadable, no restore from trash, silent data loss)
   - **Major** = flow works but confuses users (no loading state, no confirmation of a completed action, wrong language on generated text)
```

- [ ] **Step 5: Rewrite "Lessons from past audits" as principles**

Replace the whole `## Lessons from past audits` section (heading and five bullets) with:

```markdown
## What experience says to check first

- **Terminal states are the #1 source of Critical bugs.** Every state a
  record can enter and not leave — cancelled, archived, deleted, converted —
  needs a reverse or an explicit justification for why it has none.
- **The cascade outranks component styles.** A rule in the central stylesheet
  that targets a generic tag silently clobbers carefully scoped component
  styles. Read the central stylesheet before claiming any visual bug.
- **"The backend enforces it" is not "the UI prevents it."** A rule enforced
  only server-side surfaces to the user as an error they could not have
  anticipated. Check that invalid combinations are unreachable in the UI.
- **One root cause commonly produces three "Critical" symptoms.** Cluster
  before counting, or the report overstates its own severity.
```

- [ ] **Step 6: Add the reference links to the method section**

Directly above the `## Deliverable` heading, add:

```markdown
## Stack-specific references

Open only the one that matches the project:

- [Svelte 5 traps](references/svelte-5.md)
- [Server-side traps](references/backend-web.md)
```

- [ ] **Step 7: Run the internal-identifier check**

```bash
cd /root/ux-skills
grep -rniE 'body_text|is_deleted|unconvert|delivery badge|prefix language|black box' skills/ux-audit/
```

Expected: no output.

- [ ] **Step 8: Commit**

```bash
cd /root/ux-skills
git add skills/ux-audit/
git commit -m "Remove internal domain model and audit history from ux-audit

Generic example objects, no real column names, and past findings
restated as principles rather than as our incident history."
```

---

## Task 6: Give ux-audit the same LLM-auditor discipline

`ux-heuristics-audit` gained this in commit `f37d232`; `ux-audit` should not contradict it.

**Files:**
- Modify: `skills/ux-audit/SKILL.md`

- [ ] **Step 1: Insert the section directly after `## Core principle`**

```markdown
## Working as an LLM auditor

Your failure modes here are measured, not hypothetical. Code-based LLM
usability evaluation has been scored at precision 0.61–0.66 and recall
0.35–0.38: mostly right about what it reports, and missing roughly
two-thirds of the real issues. Both halves of that need managing.

- **Cite or drop.** Every finding carries a `file:line`. A finding that names
  no location cannot be acted on and is the most common complaint from
  engineers receiving machine-generated reports.
- **Search before declaring something absent.** "No validation here" when the
  validator lives one file away is the characteristic false positive. This is
  especially true for soft deletes: look for a `deleted_at` column, a status
  field, a trash route or a restore endpoint before calling anything
  irreversible.
- **Don't drop what you couldn't verify — demote it.** Unconfirmed items go in
  a **Suspected — unverified** list with the check that would settle each one.
  Deleting them protects precision at the cost of the recall you can least
  afford.
- **Never invent measurements.** No timings, no abandonment rates. Report the
  missing mechanism, not a number you don't have.
- **Say what you didn't cover.** Close with a **Not assessed** list. A named
  gap is recoverable; a silent one is not.

Sources for the figures above are listed in the repository's `NOTICE.md`.
```

- [ ] **Step 2: Add the two closing sections to the Deliverable section**

At the end of `## Deliverable`, after the clustering paragraph, add:

```markdown
Close the report with two sections that are not optional: **Suspected —
unverified** (with the check that would settle each item) and **Not
assessed** (what your evidence base could not reach).

Before shipping any finding, apply the actionability test: could someone who
has never seen this code open the file you named, find the thing you named,
and make the change you described without asking you a question? If not, the
finding isn't finished.
```

- [ ] **Step 3: Verify both skills now agree**

```bash
cd /root/ux-skills
grep -l "Suspected — unverified" skills/*/SKILL.md
```

Expected: both `skills/ux-audit/SKILL.md` and the heuristics skill's `SKILL.md`.

- [ ] **Step 4: Commit**

```bash
cd /root/ux-skills
git add skills/ux-audit/SKILL.md
git commit -m "Apply the same LLM-auditor discipline to ux-audit

Cite-or-demote, search-before-absent, no invented measurements, and the
two closing sections, so the two audit skills do not contradict."
```

---

## Task 7: Write the repo documentation and manifests

**Files:**
- Create: `README.md`, `LICENSE`, `NOTICE.md`
- Create: `.claude-plugin/plugin.json`, `.claude-plugin/marketplace.json`
- Modify: `skills/auditing-responsive-layout/SKILL.md`

- [ ] **Step 1: Add the probe portability note**

In `skills/auditing-responsive-layout/SKILL.md`, in the `## Files` section, replace the `probe.js` line with:

```markdown
- `probe.js` — the headless measurement harness (edit CONFIG, run, read `⚠`).
  It is written for a `dev-browser`-style CLI that exposes a `browser` global.
  With plain Playwright, replace the two lines that obtain `page` with
  `const browser = await chromium.launch(); const page = await browser.newPage();`
  — the `page.evaluate` body is unchanged and is where all the measurement lives.
- `test-fixture.html` — a page seeded with the four root-cause bugs above, for
  trying the probe. It is deliberately RTL so the direction-sensitive checks
  have something to bite on.
```

- [ ] **Step 2: Write the MIT licence**

Create `LICENSE`:

```
MIT License

Copyright (c) 2026 ynigun

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```

- [ ] **Step 3: Write the attribution notice**

Create `NOTICE.md`:

```markdown
# Attribution

## UX principles

The 30 principles in `skills/ux-heuristics-audit/laws/` are long-standing
findings from cognitive psychology and human-computer interaction — Hick
(1952), Fitts (1954), Miller (1956), the Gestalt school, Tversky and
Kahneman, and others. Each lens file cites its own source.

The selection and grouping of these particular 30 as a working set follows
**[Laws of UX](https://lawsofux.com/) by Jon Yablonski**, which is an
excellent reference and worth reading directly.

All text in this repository — definitions, verification steps, examples and
guidance — is our own. No text is reproduced from that site. This project is
not affiliated with, endorsed by, or derived from the Laws of UX content.

## Research informing the LLM-auditor guidance

- Lubos, Felfernig, Garber, Le & Henrich, *Recommending Usability
  Improvements with Multimodal Large Language Models*, ACM FSE 2026 —
  [arXiv:2604.25420](https://arxiv.org/abs/2604.25420)
- *Does GenAI Make Usability Testing Obsolete?* —
  [arXiv:2411.00634](https://arxiv.org/abs/2411.00634)
- *Synthetic Heuristic Evaluation: A Comparison between AI- and
  Human-Powered Usability Evaluation* —
  [arXiv:2507.02306](https://arxiv.org/abs/2507.02306)
- Wang et al., *UXBench: Measuring the Actionability of LLM-Generated UX
  Critiques* — [arXiv:2606.16262](https://arxiv.org/abs/2606.16262)
- Ahmed & Imran, *The role of large language models in UI/UX design: A
  systematic literature review* —
  [arXiv:2507.04469](https://arxiv.org/abs/2507.04469)
```

- [ ] **Step 4: Write the README**

Create `README.md`:

```markdown
# ux-skills

Three Claude Code skills for auditing user interfaces — built for an agent
that reads code rather than a human who looks at a screen.

Most UX guidance assumes eyes on a rendering. An agent has source, and its
failure modes are specific and measured: it invents issues that don't exist,
reports them without saying where, flags functionality that is already
implemented, and produces severity labels that all come out the same. Every
skill here is shaped around preventing those four things while keeping recall
high enough to be worth running.

## Install

```
/plugin marketplace add ynigun/ux-skills
/plugin install ux-skills@ux-skills
```

## The skills

### `ux-audit` — find the bugs
End-to-end audit for functional UX defects. Three layers over every object in
the feature: an object/state/action sweep that catches unreachable and
irreversible states, a lifecycle trace that follows each attribute from write
to render, and a visual contract pass covering cascade collisions, RTL
leakage, dynamic-content edge cases and breakpoints.

Use it for: "why does this feel broken", state-machine traps, data that
silently disappears, layout that breaks in one language.

### `ux-heuristics-audit` — find the principle violations
Heuristic evaluation against 30 established UX principles, one file per
principle. Each carries what to look for, **how to verify it from the code**,
and **what is not a violation** — the handled cases that look like bugs and
generate most false positives.

Use it for: a working interface that is harder to use than it should be.

### `auditing-responsive-layout` — measure, don't eyeball
Layout bugs that appear only at certain widths or in certain persisted UI
states. Ships a headless probe that walks `widths × states` plus a
resize-without-reload pass and reports computed geometry, because a screenshot
hides inset scrollbars, clipped overflow and computed margins.

Use it for: horizontal scroll on mobile, a stray strip on one side, "works on
my machine", a bug that only appears in device mode.

## Which one

| Symptom | Skill |
|---|---|
| Something is broken or loses data | `ux-audit` |
| Nothing is broken but it's hard to use | `ux-heuristics-audit` |
| It only breaks at some screen width | `auditing-responsive-layout` |

They compose. A full review runs all three and says so.

## Licence

MIT — see `LICENSE`. Attribution for the principle taxonomy and the research
behind the LLM-auditor guidance is in `NOTICE.md`.
```

- [ ] **Step 5: Write the plugin manifest**

Create `.claude-plugin/plugin.json`:

```json
{
  "name": "ux-skills",
  "version": "1.0.0",
  "description": "Three UX audit skills built for agents that read code: functional bug hunting, heuristic evaluation against 30 principles, and headless responsive-layout measurement.",
  "author": {
    "name": "ynigun",
    "url": "https://github.com/ynigun"
  },
  "license": "MIT",
  "homepage": "https://github.com/ynigun/ux-skills",
  "repository": "https://github.com/ynigun/ux-skills.git",
  "keywords": [
    "ux",
    "usability",
    "audit",
    "heuristic-evaluation",
    "accessibility",
    "rtl",
    "responsive"
  ]
}
```

- [ ] **Step 6: Write the marketplace manifest**

Create `.claude-plugin/marketplace.json`:

```json
{
  "name": "ux-skills",
  "owner": {
    "name": "ynigun"
  },
  "metadata": {
    "description": "UX audit skills for Claude Code.",
    "version": "1.0.0"
  },
  "plugins": [
    {
      "name": "ux-skills",
      "description": "Three UX audit skills built for agents that read code: functional bug hunting, heuristic evaluation against 30 principles, and headless responsive-layout measurement.",
      "source": "./",
      "strict": false,
      "skills": [
        "./skills/ux-audit",
        "./skills/ux-heuristics-audit",
        "./skills/auditing-responsive-layout"
      ]
    }
  ]
}
```

If Task 1 was skipped, the second entry must read `./skills/lawsofux-audit`.

- [ ] **Step 7: Run the full validation — it must now pass**

```bash
cd /root/ux-skills
./scripts/validate.sh
```

Expected: `ALL CHECKS PASSED`, exit 0. If check 4 still fails, an internal identifier survived Task 5 — fix it before continuing. If check 8 fails, `jq` is missing (`apt-get install -y jq`) or a declared skill path doesn't match the rename decision.

- [ ] **Step 8: Commit**

```bash
cd /root/ux-skills
git add -A
git commit -m "Add README, MIT licence, attribution notice and plugin manifests"
```

---

## Task 8: Wire validation into CI

**Files:**
- Create: `.github/workflows/validate.yml`

- [ ] **Step 1: Write the workflow**

Create `.github/workflows/validate.yml`:

```yaml
name: validate

on:
  push:
    branches: [main]
  pull_request:

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Install jq
        run: sudo apt-get update && sudo apt-get install -y jq
      - name: Run publication checks
        run: ./scripts/validate.sh
```

- [ ] **Step 2: Verify the script is executable in git's eyes**

```bash
cd /root/ux-skills
git ls-files -s scripts/validate.sh
```

Expected: mode `100755`. If it shows `100644`, run `git update-index --chmod=+x scripts/validate.sh` — CI will fail to execute it otherwise.

- [ ] **Step 3: Commit**

```bash
cd /root/ux-skills
git add .github/workflows/validate.yml
git commit -m "Run publication checks in CI on push and PR"
```

---

## Task 9: Create the GitHub repo and push

**Do not start this task until the three decisions at the top are confirmed.** This is the only irreversible step: it publishes everything to the internet under the account authenticated in `gh`.

**Files:** none — this task only creates the remote and pushes.

- [ ] **Step 1: Confirm the decisions and the authenticated account**

```bash
gh auth status
```

Expected: logged in as `ynigun`. If a different account is active, stop — pushing would publish under the wrong identity.

- [ ] **Step 2: Re-run validation immediately before publishing**

```bash
cd /root/ux-skills
./scripts/validate.sh
```

Expected: `ALL CHECKS PASSED`. This re-run is not redundant: the `.a5c/logs/` hook directory regenerates itself in whatever directory is being worked in, and check 5 is the guard against committing one.

- [ ] **Step 3: Confirm nothing untracked or ignored is about to ship**

```bash
cd /root/ux-skills
git status --short
git ls-files | sort
```

Expected: clean working tree; the file list contains only `README.md`, `LICENSE`, `NOTICE.md`, `.gitignore`, `.claude-plugin/*.json`, `.github/workflows/validate.yml`, `scripts/validate.sh`, `docs/superpowers/plans/*.md` and the three `skills/` trees. No `.log`, no `.a5c`.

- [ ] **Step 4: Create the remote and push**

```bash
cd /root/ux-skills
gh repo create ux-skills --public --source=. --remote=origin --push \
  --description "UX audit skills for Claude Code: functional bugs, 30-principle heuristic evaluation, and headless responsive-layout measurement."
```

Expected: prints the new repository URL and pushes `main`.

- [ ] **Step 5: Verify the marketplace resolves from the remote**

```bash
cd /tmp && rm -rf ux-skills-verify
git clone --depth 1 https://github.com/ynigun/ux-skills.git ux-skills-verify
cd ux-skills-verify && jq -r '.plugins[].skills[]' .claude-plugin/marketplace.json | while read -r p; do
  test -f "${p#./}/SKILL.md" && echo "ok $p" || echo "MISSING $p"
done
```

Expected: three `ok` lines. A `MISSING` line means the manifest and the pushed tree disagree — fix and push before telling anyone the install command.

- [ ] **Step 6: Verify CI passed**

```bash
cd /root/ux-skills
gh run list --limit 1
```

Expected: the `validate` workflow with status `completed` and conclusion `success`. If it failed, read `gh run view --log-failed` and fix before announcing.

- [ ] **Step 7: Confirm the install path works end to end**

In a Claude Code session:

```
/plugin marketplace add ynigun/ux-skills
/plugin install ux-skills@ux-skills
```

Expected: the marketplace is added and the three skills appear in the skills list.

---

## Self-review notes

- **Spec coverage:** every open item from the audit email is assigned — licence (already done in prior commits, documented in Task 7 `NOTICE.md`), broken links (prior commit, guarded by check 3), stray hook log (Task 2 check 5, re-verified in Task 9 Step 2), `ux-audit` internal disclosure (Tasks 3–5, guarded by check 4), the `pareto-principle.md` self-link (fixed in the prior rewrite, guarded by check 6), the `dev-browser` dependency note (Task 7 Step 1), README/LICENSE/manifests (Task 7), rename (Task 1).
- **Ordering constraint:** Task 2 must precede Tasks 3–8 so the harness fails first and each subsequent task moves a specific check from failing to passing.
- **Rename coupling:** Task 1 changes a path that Task 7's `marketplace.json` and Task 2's check 2 both reference. Both handle either outcome — check 2 globs for both directory names, and Task 7 Step 6 states the alternative path explicitly.
