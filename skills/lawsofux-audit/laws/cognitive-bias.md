# Cognitive Bias

**What it says.** A predictable, systematic deviation in how people judge and decide. Not random error — error with a pattern, which means it can be designed for or exploited.

**Lens:** Cognitive load, attention & memory

## Look for
- Misleading defaults or pre-checked options (default bias used against the user).
- Anchoring (a struck-through "was" price to inflate perceived value).
- Framing that nudges toward the business's interest at the user's expense (dark patterns).
- Designs that ignore predictable biases they could guard against.

## Verify it from the code
Dark patterns are unusually provable, because the manipulation lives in the initial state and the copy.

- Read the initial state of every checkbox and toggle: `checked`, `defaultChecked`, `defaultValue`, initial store values. A pre-checked paid add-on or a pre-checked marketing consent is a concrete, quotable finding.
- Check the symmetry of the exit path: compare the code for subscribing versus unsubscribing, or accepting versus declining. If accept is one click and decline is four, that asymmetry is countable.
- Read the button copy pairs verbatim. Confirmshaming ("No thanks, I like paying more") is right there in the string.
- Check whether an anchor price is real: is the "was" value a stored historical price or a hardcoded constant? The latter is a fabricated anchor.
- Check consent defaults against the applicable regime — pre-ticked consent is not merely a UX finding in jurisdictions where opt-in must be affirmative. Note it as a compliance flag, not a legal conclusion.

## Not a violation (check before reporting)
- **Helpful defaults.** A default that reflects what most users want, and is easy to change, is good design. The test is whose interest it serves.
- **Naming a bias without a mechanism.** "This exploits anchoring" without pointing at the anchor is decoration.
- **Persuasion that's honest.** Showing a genuine discount or real scarcity isn't a dark pattern; fabricating either is.
- **Overreaching into legal advice.** Flag the pattern and the risk; don't declare something unlawful.

## User cost
Biases are exploitable. Dark-pattern framing produces **regretted decisions and lost trust** when users notice; ignoring biases lets users mislead themselves.

## Example
**Before** — a pre-checked "add insurance for $9" buried at checkout.
**After** — the add-on is opt-in and clearly priced; the default reflects the user's likely intent.

## Fix
Design *with* known biases to help users decide well — honest defaults, fair framing, real anchors, symmetric exits. Never weaponize a bias against the user.

## Don't confuse with
- This is the umbrella category; specific effects here overlap with [Von Restorff](von-restorff-effect.md), [Serial Position](serial-position-effect.md), and [Peak-End](peak-end-rule.md). Cite the specific law when one fits.

---
Principle catalogued by [Laws of UX](https://lawsofux.com/cognitive-bias/) (Jon Yablonski); underlying research: Tversky & Kahneman. Wording here is our own.
