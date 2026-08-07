# Reading the code systematically

This is the part that decides whether the audit works. The lenses tell you *what* to look for; this tells you how to move through a codebase so you actually find it instead of sampling a few files and guessing.

None of it is UX-specific. It's how to read unfamiliar code without fooling yourself.

## 1. Build the map before you judge anything

You cannot audit what you haven't enumerated, and an audit that starts with opinions about the first file you opened will stay there. Spend the first pass building a list, not findings.

Get these four things, in this order:

- **Routes / screens.** Find the router. File-based routing (`app/`, `pages/`, `routes/`) gives you the list for free — `find` the directory. Otherwise grep for the route-definition call (`createBrowserRouter`, `<Route`, `@app.route`, `r.Get(`). This list is the audit's scope; write it down.
- **The domain objects.** What nouns does the app manipulate? Get them from the data layer, not from the UI: schema files, migrations, model/type definitions. `find . -name "*.sql"`, the ORM models, the shared `types.ts`.
- **The state.** Where does UI state live? Grep for the store creation (`createContext`, `writable(`, `useReducer`, `zustand`, `signal(`). State that lives in a component dies with it — that fact produces findings on its own.
- **The central stylesheet.** Find it and read it end to end, once, before any visual claim. This is the highest-yield read in the whole audit: a rule targeting a bare tag silently overrides carefully scoped component styles everywhere, and you cannot infer that from the component.

Only now start looking for problems.

## 2. Grep to locate, read to judge

The most common way to be confidently wrong is to judge from a grep excerpt. A match tells you where to look; it does not tell you what the code does.

- Grep gives you candidates. Open the file and read around each hit — the guard clause three lines up is usually the thing that decides whether it's a bug.
- When a file is under a few hundred lines and it's the subject of a finding, read the whole thing. Cheaper than being wrong.
- Read the imports at the top before judging the body. Half of "this isn't handled" turns out to be handled by something imported from elsewhere.

## 3. Searching for absence is a different skill from searching for presence

Most false findings are claims that something is missing. Proving absence is genuinely harder than proving presence, and needs a different technique.

**Never conclude "there is no X" from one grep for one spelling.** Search the concept, not the word:

- Validation: `validate|schema|zod|yup|joi|rule|constraint|pattern=|required`
- Soft delete: `deleted_at|is_deleted|isDeleted|archived|status|trash|restore|soft`
- Loading state: `loading|isLoading|pending|isPending|busy|submitting|isFetching|spinner|skeleton`
- Accessible name: `aria-label|aria-labelledby|<label|sr-only|visually-hidden|title=`
- Error handling: `catch|onError|error|try|rescue|except|Result|err !=`

Then check the layer above: a wrapper component, a middleware, a base class, a decorator, a global handler. If you still find nothing, say **"I searched X, Y, Z and found none"** rather than "there is none." That sentence is honest and still actionable.

## 4. Read both sides of every boundary

Almost every real UX defect lives at a seam, and you only see it if you read both sides at once:

| Boundary | Read together |
|---|---|
| Label ↔ behaviour | the button's text **and** its handler |
| Client ↔ server | the form's validation **and** the endpoint's |
| Write ↔ read | the INSERT/UPDATE **and** every SELECT that filters on it |
| Component ↔ cascade | the component's styles **and** the global rules that hit the same tags |
| State ↔ render | where the flag is set **and** whether any template reads it |

A `loading` variable that gets set but is never rendered is a real bug and it is invisible from either side alone.

## 5. Trace one path at a time, all the way

Pick a value and follow it end to end before starting another. Interleaving traces is how you lose the thread and start guessing.

For each value the user supplies or sees: where does it enter, what normalises it, where is it stored, which queries read it, what filters those queries apply, where does it land in the DOM, and what happens to it when the record is deleted. Note where the trace *breaks* — a value stored and never read back is a finding.

## 6. Walk the unhappy paths deliberately

The happy path is what the code was written for, so it usually works. Findings concentrate elsewhere, and each of these is a concrete thing to go grep for:

- **Empty:** every list's zero-item branch (`length === 0`, `?.length ?`, `isEmpty`, an `EmptyState` component).
- **Error:** every `catch`. What does the *user* see? A rendered `err.message` puts a stack trace on screen.
- **Loading:** every `await` in a handler. What renders in between?
- **Too much:** long strings, many rows, a 200-character name. Look for truncation, `overflow`, fixed heights.
- **Interrupted:** what survives navigating away and coming back? Refresh?
- **Denied:** what does an unauthorised user see — a helpful message or a blank screen?

## 7. Inventory, then compare — never compare from memory

Consistency questions ("are these buttons styled alike?", "does this icon mean the same thing everywhere?") are the ones models get wrong most often, because comparing across files from memory is exactly what an LLM is bad at.

Do it mechanically instead. Collect first, into one list you can see at once:

```bash
grep -rho 'variant="[a-z]*"' src/ | sort | uniq -c | sort -rn
grep -rn 'className="[^"]*btn[^"]*"' src/ | sed 's/.*className="\([^"]*\)".*/\1/' | sort -u
```

Then compare the list. A resolved list of values is an arithmetic check; the same question asked from memory is a guess.

## 8. Let the tests and the history point you

- **Tests document intent.** A test asserting a behaviour tells you what was meant, which is what you need to say a mismatch exists. Untested branches are where defects concentrate.
- **`git log` finds the fresh code.** Recently changed areas carry more defects than stable ones. `git log --since="3 months ago" --name-only --pretty=format: | sort | uniq -c | sort -rn | head -20` gives you the churn list.
- **TODO/FIXME comments** are the previous developer telling you where the problems are. Grep them.

## 9. Know when to stop reading and say so

If a finding depends on something you genuinely cannot see from here — rendered geometry, an external API's response shape, what a third-party component does internally — stop. Write down what you'd need. An audit that names its blind spots is more useful than one that papers over them with a confident guess.
