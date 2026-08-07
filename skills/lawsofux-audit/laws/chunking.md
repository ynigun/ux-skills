# Chunking

**What it says.** Grouping raw pieces into a few meaningful units so they can be held, scanned, and recalled as one thing instead of many.

**Lens:** Cognitive load, attention & memory

## Look for
- Long unbroken number strings (card, phone, account) shown without grouping.
- Content walls with no sections, headings, or paragraphs.
- Lists and forms presented as one continuous run instead of grouped units.

## Verify it from the code
- Check how machine-formatted values are rendered: grep for card numbers, IBANs, phone numbers, order references, and API keys displayed straight from state with no formatter. An unformatted 16-digit string is a concrete finding.
- Check the *input* side too, which matters more: does the field format as the user types or on blur? Does it accept a pasted grouped value? Trace the change handler.
- For long content, count structural markers — `<h2>`/`<h3>`, `<section>`, list elements — against the length of the text. A long body with no subheadings is verifiable.
- For forms, check whether fields are grouped into `<fieldset>`s or steps, and how many fall in each run.
- Check truncation and overflow: a long identifier squeezed into a narrow cell with `text-overflow: ellipsis` and no copy button or tooltip is unreadable in a different way.

## Not a violation (check before reporting)
- **Values not meant to be read by humans.** An API key shown once for copying, with a copy button, doesn't need visual chunking.
- **Already-formatted values.** Check for the formatter before claiming its absence — it may live in a util module rather than the template.
- **Locale-specific grouping.** Digit and thousands separators differ by locale; don't impose one convention. Check whether `Intl.NumberFormat` or equivalent is used.
- **Short strings.** A 4-digit code doesn't need chunking.

## User cost
Ungrouped information is **harder to scan, hold, verify, and recall.** Users checking a number against a physical card or a bank statement have to count digits.

## Example
**Before** — `4539221199887766` in one field.
**After** — `4539 2211 9988 7766`, grouped as the eye expects.

## Fix
Group information into meaningful units: format numbers on display and on input, section long forms, add headings and paragraphs. Make structure visible.

## Don't confuse with
- [Miller's Law](millers-law.md) — Miller's is the *limit*; Chunking is the *technique* that works within it.
- [Law of Proximity](law-of-proximity.md) — visual grouping by spacing; Chunking is the broader content-grouping idea, and also applies to text and numbers.

---
Principle catalogued by [Laws of UX](https://lawsofux.com/chunking/) (Jon Yablonski); underlying research: Miller (1956). Wording here is our own.
