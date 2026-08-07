# Svelte 5 traps

Open this file only when auditing a Svelte 5 codebase. Each item is a class of bug a per-component read will not surface.

- **Module-level `$state` in `.svelte.ts` stores** — server-side rendering pollution. A store declared at module scope is shared across every request the server handles, so one user's state can leak into another's page. Use `setContext`/`getContext` so each request gets its own instance.

- **`await` inside a state mutator** — without a staleness guard, a rapid A-then-B click can resolve A last, leaving the UI showing B's selection with A's data. Capture the id before the await and bail after it: `if (currentId !== startedId) return`.

- **`onMount(() => { if (reactiveValue) ... })`** — `onMount` runs once, with whatever the value was at mount. It does not re-run when the value changes. Use `$effect` when the behaviour should track the value.

- **Debounce timers** — every path that cancels the pending work must clear the timer: route change, filter switch, form reset, component destroy. If only one of them clears it, the others leak a stale callback.

- **Long-lived polls** — every caller that can start the poll must be able to stop it, and the active count must be refcounted. Otherwise the first caller owns the poll forever and later callers can never stop it.
