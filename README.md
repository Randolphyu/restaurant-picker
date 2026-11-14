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

1. **Taste profile.** A short Markdown file in your own words: one principle, green flags and red flags (each tied to a real meal), your hard constraints (allergies, foods you don't eat, budget, travel time), and your rated restaurants grouped by category. A starter profile needs only five places; the skill can interview you to build it.
2. **Screening.** Places that are closed, over budget, too far, or incompatible with your dietary restrictions are removed first. Star ratings are deliberately *not* used to screen.
3. **Evidence.** For up to five shortlisted places it reads 20 to 40 recent reviews (Google Maps when a browser tool is available, plus local review sites), finds the signature dishes, and collects how people describe their flavour.
4. **Comparison, not scoring.** It asks: is this place closer to your favourite in this category, or to the one you disliked? Then it sorts candidates into four tiers: *likely to love*, *worth a try*, *likely to disappoint*, *not enough evidence*.
5. **Feedback loop.** Tell it how a meal went and it records the result; repeated misses lead to suggested profile updates, which you approve.
6. **Self-test.** It can blind-test itself on places you've already rated and report how often it ranks pairs correctly.

## Why it ranks instead of predicting scores

During development we blind-tested several approaches against one person's real ratings:

| Approach | Pairwise ranking accuracy |
|---|---|
| Coin flip | 50% |
| Weighted 10-dimension score from web-search snippets | 47% to 59% |
| Comparison with the user's own places, reading 50+ Google Maps reviews per restaurant | 68% to 72% |

Predicted *scores* were never more accurate than simply guessing the person's average rating. Rankings were. So the skill ranks, explains, and stays honest about uncertainty. These numbers come from one person and 15 restaurants per test; run the self-test on your own profile to see how it does for you.

## Install

### Claude app (web, desktop and mobile)

You don't need any coding tools for this.

1. Open the [latest release](https://github.com/Randolphyu/restaurant-picker/releases/latest) and download **`restaurant-picker.zip`** from *Assets*. (Don't use GitHub's green *Code > Download ZIP* button: that downloads the whole repository, which Claude can't install as a skill.)
2. In Claude on the web or the desktop app, go to **Customize > Skills**, click **+**, then **Create skill > Upload a skill**, and choose the zip.
3. Make sure the skill is switched on. It follows your account, so it also works in the mobile app.
4. Start a chat and say *"build my taste profile"*, or just ask where to eat.

To update, download the newer zip from the latest release and upload it again.

**If you already have a skill named `restaurant-picker`,** uploading this one may clash with it. Build a renamed copy instead with `./scripts/build-zip.sh --name restaurant-picker-test`, upload that, and switch your own skill off while you try it.

**On mobile:** reading Google Maps reviews needs a browser tool, so on a phone the skill falls back to web search and says the evidence is thinner. In the Claude app the skill keeps your profile updates in memory (it asks first), so feedback works from any device.

### Claude Code

1. Add the marketplace and install the plugin:
   ```
   /plugin marketplace add Randolphyu/restaurant-picker
   /plugin install restaurant-picker@restaurant-picker
   ```
2. Ask where to eat, or call it directly with `/restaurant-picker:restaurant-picker build my taste profile`.
3. Keep your profile at `taste-profile.md` in the skill folder, or tell the skill where it lives.

To update: `/plugin marketplace update restaurant-picker`. To remove: `/plugin uninstall restaurant-picker@restaurant-picker`. Plugin skills are namespaced, so installing this never overwrites a personal skill with the same name.

### Other agents

Copy `skills/restaurant-picker/SKILL.md` into your agent's instructions, or install it with `npx skills add Randolphyu/restaurant-picker`. It is plain Markdown; browser and sub-agent steps degrade gracefully when those tools aren't available.

### Building the zip yourself

`./scripts/build-zip.sh` writes `dist/restaurant-picker.zip`. Options: `--with-profile` includes your own `taste-profile.md` (never share that zip), and `--name NAME` renames the skill.

## Set up your taste profile

Say *"build my taste profile"*. You can start with a **starter profile** in about two minutes: three places you loved, two that disappointed, one line on why for each, plus your allergies, foods you don't eat and budget. Results are less precise until you've rated around 15 places, and the skill fills the profile in as you report back on meals.

For a fuller start: in the Claude app, if you've turned on searching past chats, the skill first looks through your past food conversations and drafts a list of places with the verdicts *you* gave (not ones Claude suggested) for you to confirm. Then it fills the gaps by asking for more ratings (an export from a rating app, screenshots, or places you remember) and why you loved or disliked your top and bottom five, and writes the profile for you to confirm.

Or write it yourself: copy `skills/restaurant-picker/examples/starter-profile.md` (or the fuller `example-profile.md`) to `skills/restaurant-picker/taste-profile.md` and edit it.

## Privacy

- Past conversations are only searched where that feature exists and is turned on, and nothing found there is saved until you confirm it. Local chat logs on your computer are never read without your permission.
- Allergies and other dietary details are only saved to app memory after you agree.
- Your profile is a local file. `taste-profile.md` is in `.gitignore` so it isn't committed by accident.
- When reading Google Maps through a browser, the skill only opens public restaurant pages, never posts or saves anything, and doesn't open your saved lists or account pages unless your profile says your want-to-try list lives there.

## Limitations

- About 7 in 10 pairwise calls right is a realistic ceiling: online reviews can't see how you order, who you went with, or how hungry you were.
- **Allergies:** the skill filters out places that clearly can't accommodate your restrictions, but reviews and menus can't prove a place is safe. Always confirm with the restaurant.
- To keep things fast, it deep-reads at most five candidates per request and lists the rest as screened but not researched.
- Small or brand-new places with few reviews often land in *not enough evidence*.
- Results depend on review availability and language in your area.

## Roadmap

- Importers for common rating-app exports and Google Takeout saved lists
- Per-region review-source presets
- Larger multi-user evaluation of ranking accuracy

## License

MIT
