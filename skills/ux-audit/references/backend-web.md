# Server-side traps

Open this file when the audit reaches the server. These are the write-side defects that surface to users as impossible states, ghost rows, or data that silently disappears.

- **Partial-commit windows** — any flow that writes to two tables without a transaction can leave the first written and the second not. The user sees a half-created object. Wrap multi-table writes in a transaction with an explicit rollback on every error path.

- **Silent error swallowing** — an error path that returns without logging makes the resulting user-visible bug undiagnosable. Every write-side error should log before it returns.

- **Path parameter encoding** — many HTTP routers hand you the raw path segment without URL-decoding it. Any identifier that can contain `/`, `%`, `+`, or an email address will arrive mangled. Decode explicitly, and test with an identifier containing a reserved character.

- **Structured values arriving as strings** — when an upstream sends a JSON array where the schema expects a scalar, a permissive parser can hand you the literal text `["a","b"]` as the value. It then flows through to the UI and renders as itself. Validate the shape at the boundary, not at the point of display.

- **Incomplete soft-delete filters** — the moment a table gains a soft-delete column, every existing query needs the corresponding filter. Miss one and deleted rows reappear in whichever list that query feeds. Enumerate the reads when the column is added; don't fix them as they're reported.

- **Timezone drift on stored timestamps** — a value written in one zone and read in another shifts by hours. Check that storage is timezone-aware and that formatting happens at the edge, not in the query.
