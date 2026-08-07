# Postel's Law

**What it says.** Accept input generously; emit output strictly. Absorb reasonable variation on the way in rather than pushing it back at whoever is typing.

**Lens:** Heuristics · interaction & decision cost

## Look for
- Rigid input formats (phone, date, card) that reject spaces, dashes, or casing.
- Validation that punishes harmless variation instead of normalizing it.
- Forms that demand the machine's preferred format rather than the human's.
- Output that overwhelms (dumps every field) instead of showing what matters.

## Verify it from the code
This is the most mechanically checkable law in the set — read the validators.

- Grep for the validation layer: regex literals, `pattern=` attributes, `maxLength`, schema definitions (zod/yup/joi/pydantic), server-side validators. Read each one and ask what *reasonable* input it rejects.
- Common real defects, all citable: a phone regex that rejects spaces, dashes, or `+`; an email regex stricter than the spec (rejects `+` tags or new TLDs); a name field that rejects apostrophes, hyphens, or non-Latin characters; a postcode pattern hardcoded to one country.
- Check for normalization *before* validation: `.trim()`, `.toLowerCase()`, stripping separators. Its absence is the finding — untrimmed input rejecting a pasted value with a trailing space is a classic.
- Check both layers. Client-side leniency with a strict server (or the reverse) produces errors that appear only on submit.
- Check the paste path specifically: fields that split into segments (card, OTP) often break on paste. Look for a `paste` handler.

## Not a violation (check before reporting)
- **Deliberately strict security fields.** Password rules, 2FA codes, and API tokens should be strict. Don't apply this law there.
- **Strictness with normalization already applied.** If the code strips formatting first, a tight regex afterwards is correct.
- **Regexes you didn't actually evaluate.** Don't call a pattern too strict without tracing what it accepts — verify with a concrete rejected example you can name.
- **Server-side canonical formats.** Storing E.164 phone numbers is right; the question is only whether the *input* accepted variation.

## User cost
Strict input handling produces **needless errors and friction** for input that's perfectly understandable. Users retype, get blocked, and distrust the form.

## Example
**Before** — "1 (555) 123-4567" is rejected; only `5551234567` is accepted.
**After** — the field strips formatting and accepts any reasonable variant.

## Fix
Accept input liberally and normalize it before validating; emit clear, conservative output. Anticipate variation rather than forbidding it.

## Don't confuse with
- [Tesler's Law](teslers-law.md) — Postel's absorbs *input variation*; Tesler's is about who absorbs *inherent task complexity*.

---
Principle catalogued by [Laws of UX](https://lawsofux.com/postels-law/) (Jon Yablonski); originally Jon Postel's robustness principle (RFC 761). Wording here is our own.
