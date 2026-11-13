# Restaurant Picker

**An AI skill that picks restaurants by *your* taste, not the crowd's.**

Star ratings tell you what the average diner thinks. Restaurant Picker compares each candidate with places *you* have already loved or disliked, reads what reviewers say about the flavour of the signature dishes, and tells you which ones you're likely to love, in your own terms.

It works as a skill for Claude (Claude Code, and the Claude app) and the method is plain Markdown, so it can be adapted to other AI agents.

## What you get

Ask something like *"Dinner for four near Downtown on Saturday: Little Basil Kitchen, Noodle Lab or Harbor Oyster Room?"* and you get:

| Rank | Restaurant | Tier | Closest to a place you've rated | Order | Watch out for | Evidence |
|---|---|---|---|---|---|---|
| 1 | Harbor Oyster Room | Likely to love | Copper Lantern (your favourite) | grilled oysters, chowder | weekend wait | high |
| 2 | Noodle Lab | Worth a try | Ramen Haru | dry noodles | broth called salty by several reviewers | medium |
| 3 | Little Basil Kitchen | Likely to disappoint | Golden Wok Express | — | many reviewers say the sauces are sweet | high |

…followed by a short explanation of the top picks and one clear recommendation. (Example uses the fictional profile in `skills/restaurant-picker/examples/`.)

## How it works

1. **Taste profile.** A short Markdown file in your own words: one principle, green flags and red flags (each tied to a real meal), and your rated restaurants grouped by category. The skill can interview you to build it.
2. **Evidence.** For each candidate it reads 20 to 40 recent reviews (Google Maps when a browser tool is available, plus local review sites), finds the signature dishes, and collects how people describe their flavour.
3. **Comparison, not scoring.** It asks: is this place closer to your favourite in this category, or to the one you disliked? Then it sorts candidates into four tiers: *likely to love*, *worth a try*, *likely to disappoint*, *not enough evidence*.
4. **Feedback loop.** Tell it how a meal went and it records the result; repeated misses lead to suggested profile updates, which you approve.
5. **Self-test.** It can blind-test itself on places you've already rated and report how often it ranks pairs correctly.

## Why it ranks instead of predicting scores

During development we blind-tested several approaches against one person's real ratings:

| Approach | Pairwise ranking accuracy |
|---|---|
| Coin flip | 50% |
| Weighted 10-dimension score from web-search snippets | 47% to 59% |
| Comparison with the user's own places, reading 50+ Google Maps reviews per restaurant | 68% to 72% |

Predicted *scores* were never more accurate than simply guessing the person's average rating. Rankings were. So the skill ranks, explains, and stays honest about uncertainty. These numbers come from one person and 15 restaurants per test; run the self-test on your own profile to see how it does for you.

## Install

### Claude Code

```
/plugin marketplace add Randolphyu/restaurant-picker
/plugin install restaurant-picker@restaurant-picker
```

### Claude app (web, desktop, mobile)

1. Build the zip: `./scripts/build-zip.sh` (or download `restaurant-picker.zip` from the latest Release).
2. Upload it as a custom skill in Claude's skills settings.

### Other agents

Copy `skills/restaurant-picker/SKILL.md` into your agent's instructions. It is plain Markdown; browser and sub-agent steps degrade gracefully when those tools aren't available.

## Set up your taste profile

Say *"build my taste profile"*. The skill will ask for your ratings (an export from a rating app, screenshots, or just 10 to 20 places you remember), then ask why you loved or disliked your top and bottom five, and write the profile for you to confirm.

Or write it yourself: copy `skills/restaurant-picker/examples/example-profile.md` to `skills/restaurant-picker/taste-profile.md` and edit it.

## Privacy

- Your profile is a local file. `taste-profile.md` is in `.gitignore` so it isn't committed by accident.
- When reading Google Maps through a browser, the skill only opens public restaurant pages, never posts or saves anything, and doesn't open your saved lists or account pages unless your profile says your want-to-try list lives there.

## Limitations

- About 7 in 10 pairwise calls right is a realistic ceiling: online reviews can't see how you order, who you went with, or how hungry you were.
- Small or brand-new places with few reviews often land in *not enough evidence*.
- Results depend on review availability and language in your area.

## Roadmap

- Importers for common rating-app exports and Google Takeout saved lists
- Per-region review-source presets
- Larger multi-user evaluation of ranking accuracy

## License

MIT
