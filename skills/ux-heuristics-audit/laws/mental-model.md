# Mental Model

**What it says.** The simplified internal picture a person carries of how something works, used to predict what it will do next. When the system contradicts that picture, the prediction fails.

**Lens:** Mental models & expectation

**Unit of analysis:** the **object**. Sweep this lens across every domain object in your inventory, checking each of its states and actions.

## Look for
- UI that contradicts the obvious model: a Save that discards, an Archive that deletes, a back button that loses data.
- Terms or icons whose behavior doesn't match what users assume they mean.
- Flows that violate the cause-and-effect users expect from the domain.

## Verify it from the code
Word-versus-behavior mismatch is the provable core of this law, and it produces the highest-value findings in the whole set.

- For each action label, read its handler and compare the promise to the effect. `Archive` that issues a `DELETE`, `Save draft` that publishes, `Cancel` that submits, `Remove` that permanently destroys — each is a two-line proof (label here, handler there).
- Check reversibility against the word used. Words like archive, hide, and remove imply recoverability. Find the delete path: is it a soft delete with a restore route, or a hard delete? If there's no way back, the word is lying.
- Check the browser Back button explicitly: does leaving a step lose entered data? Trace whether state is in the URL/persisted or purely in component memory.
- Check that the same concept uses one name everywhere. Grep for the feature's synonyms across templates and API routes — "folder" in the UI and "collection" in the API leaks a second model.
- Check destructive confirmations for what they actually say happens versus what happens.

## Not a violation (check before reporting)
- **A model you invented.** State whose expectation is violated and why — from the word used, the icon, or a domain convention. "Users expect X" with no basis isn't evidence.
- **Deliberate domain terms** the product teaches and uses consistently.
- **Soft delete you didn't find.** Look for `deleted_at`, `is_deleted`, `status`, a trash route, or a restore endpoint before claiming an action is irreversible. This is the most common false Critical in the whole audit.
- **Backend behavior you assumed.** If the handler calls an API you can't read, say the check was inconclusive rather than asserting.

## User cost
Users predict behavior from their internal model. When the system **violates that model**, they act on wrong predictions — losing data, taking wrong turns, and distrusting everything else the product says.

## Example
**Before** — "Archive" permanently deletes with no recovery.
**After** — Archive moves to a recoverable archive, matching the word's meaning.

## Fix
Make behavior match the model the word, icon, or flow evokes. Where you must diverge, signal it loudly and make it reversible.

## Don't confuse with
- [Jakob's Law](jakobs-law.md) — Jakob's is the model formed from *other products' conventions*; Mental Model is the user's model of *how this system and its concepts behave*.

---
Principle catalogued by [Laws of UX](https://lawsofux.com/mental-model/) (Jon Yablonski); after Craik (1943) and Norman. Wording here is our own.
