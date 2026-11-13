---
name: restaurant-picker
description: Ranks and tiers candidate restaurants by the user's own taste, by comparing each one with places the user has already rated, and explains why in the user's own terms. Use when the user asks where to eat, which of several restaurants is better, whether a place suits them, or reports how a meal went.
---

# Restaurant Picker

Helps one person choose where to eat, judged by their taste rather than by the crowd.

## What this skill does and does not do

- **Does:** ranks a few candidate restaurants and sorts each into one of four tiers: *likely to love*, *worth a try*, *likely to disappoint*, *not enough evidence*. For each it names the place the user has eaten at that it most resembles, the dishes to order, and the warning signs to know about.
- **Does not:** predict an exact score. In testing, scores predicted from online reviews were no more accurate than guessing the user's average, while pairwise ranking was right about 70% of the time once reviews were read in depth. If the user asks for a number, give a rough range and say it is rough.
- **Language:** reply in the language the user writes in.

Everything about the user lives in their **taste profile** (see `examples/example-profile.md` for the format). This file contains only the method and never hard-codes any person's data.

## 0. Load the taste profile

Look for the profile in this order:
1. A file named `taste-profile.md` in this skill's folder.
2. A path the user has given.
3. A profile the user pastes into the conversation.

If none exists, offer to build one (section 8) before ranking. Without a profile, you can still rank by general quality, but say clearly that the ranking is not personalised.

## 1. Clarify the request

Needed: location, party size, occasion, budget. Ask at most one question, about whichever is most important and missing; assume the rest and state the assumptions at the top of the reply.

If the profile's pending-feedback list has places the user has since visited, ask once how they went (once per place; never chase).

## 2. Find candidates

- Use places the user names directly.
- When recommending, start from the user's want-to-try list as described in the profile. Drop non-food places and places already rated. Fill gaps with search. Mark which candidates came from the want-to-try list.
- If a name can't be found, try spelling variants and homophones, and check the profile's known aliases. If still unsure, ask.

## 3. Gather evidence (for each candidate)

1. Confirm the exact location; watch for same-name restaurants and branches.
2. Primary source: Google Maps reviews. If a browser tool is available, open the restaurant's public page and read the default, *Newest* and *Lowest rating* sorts, 20 to 40 reviews in total. Read only; never post, save, share, or open the user's saved lists or account pages; skip reviews written by the user; close any tab you opened. Without a browser, use web search and say the evidence is thinner.
3. Identify the 2 to 3 most-mentioned signature dishes and collect how reviewers describe their **flavour**. Users usually order the signatures.
4. Negative-review check: scan mid and low reviews for anything on the profile's red-flag list.
5. Other sources (Yelp, Reddit, local forums, guides, press) supplement this; they do not replace it. Use the review platforms that matter locally (for example Tabelog in Japan, Naver in Korea, Dianping in mainland China).
6. Never invent sources or claims. Mark unknowns as unknown.

Rules for reading evidence:
- Use reviewers' descriptions of flavour, not their star ratings or verdicts. Critics care about different things than this user does.
- Missing flavour detail is **not** negative evidence. If reviews only say "delicious" or "huge portions", start from how strongly and consistently the place is praised within its category and area, and lower your confidence.
- Ratings near 4.9 built on generic five-star reviews (or reviews naming staff) may be inflated; weight reviews with specifics.
- Volume of coverage reflects fame, not quality. Handle fame only in step 5.
- For small places with little coverage, look for craft signals: a chef trained at a respected restaurant, hand-picked ingredients, few seats, limited seasonal items, dishes seasoned individually, house-made creative items. More signals make "likely to love" more plausible.

## 4. Compare (the core step)

Do not score dimensions. For each candidate:

1. From the profile's **benchmarks**, pick the user's favourite and least favourite place in the same category (or the closest style if the category is missing).
2. Using the signature-dish flavour evidence, decide which one the candidate is closer to, and write one sentence explaining why in terms of the profile's green and red flags. Example: "Reviewers say every dish has its own distinct flavour, which is closer to [favourite] than to [least favourite]."
3. Assign a tier:
   - **Likely to love:** clearly close to the user's favourite in that category, with no red flags.
   - **Worth a try:** in between, or strong points alongside minor flaws.
   - **Likely to disappoint:** several reviewers explicitly describe a red flag in the signature dishes.
   - **Not enough evidence:** too little to judge; say what is missing.
4. Rules while judging:
   - Judge the meal the user would actually order. Unavoidable parts of a set (rice, sides) count; weak dishes that can be skipped on an à-la-carte menu don't, but list them as dishes to avoid.
   - Simple, classic or homestyle food is not "boring" when it is exceptional for its category; it can be "likely to love".
   - A low price does not mean a low tier. Don't let a reviewer's comparison to a chain set the tier.
   - The user's preferences are relative within a category: a tea shop and a fine-dining restaurant can both be favourites.

## 5. Rank

- Order by tier; within a tier, compare pairs: which candidate's evidence is closer to the user's favourite in its category.
- **Buzz:** if the profile says the user values famous places for shared conversation, a famous, much-discussed place they have not visited may move ahead of lesser-known places within *worth a try*. It never jumps ahead of *likely to love*, and fame never lifts a *likely to disappoint* place. Places already visited get no buzz bonus.

## 6. Output

1. One sentence on the conditions and assumptions used.
2. A table: rank, name, tier, most similar place the user has eaten at, dishes to order, warning signs, buzz, amount of evidence (high, medium, low).
3. Two or three sentences each on the top two, citing specific flavour evidence.
4. One clear recommendation. If the top two are close, say so and say when each is the better choice.

## 7. Feedback loop

- **Decided to go:** record the place, its tier and its comparison place in the profile's pending-feedback list.
- **After the meal:** record what the user says and remove it from the pending list. If their experience is a tier or more away from the prediction, ask one question to find out why (wrong comparison place, misread evidence, or something missing from the profile) and record their answer.
- When the same kind of miss happens three times, propose a change to the profile's principles or benchmarks; the user decides.
- If the profile file can't be written to, show the updated lines so the user can paste them in.
- Ask about pending places only when the user is next choosing a restaurant.

## 8. Building a taste profile (setup)

1. Ask the user for their ratings in any form: an export from a rating app, screenshots, a pasted list, or simply 10 to 20 places they remember with a score or a "loved / fine / disliked".
2. Pick the 5 highest and 5 lowest, and ask "what made this one great?" or "what went wrong?". Keep the user's own words.
3. Turn the answers into one sentence of principle plus green flags and red flags, each tied to a real example.
4. Group rated places by category as benchmarks, best to worst.
5. Ask where their want-to-try list lives, and whether famous places get priority for them.
6. Write the profile in the format of `examples/example-profile.md` and show it to the user to confirm.

## 9. Self-test

When the user asks, or after the profile changes significantly:

1. Choose 10 to 15 places the user has rated that are not used as examples in the principles, spread across high, middle and low ratings.
2. If you can start a separate agent, give it this method and the profile with those places removed, and forbid it from reading memory, past conversations, or rating apps. If you can't, say that a test run in the same conversation is not truly blind.
3. Have it run steps 3 to 5 on those places.
4. Compare with the user's actual ratings:
   - **Pairwise ranking accuracy** (coin flip = 50%).
   - **Tier hit rate**, mapping the user's ratings to tiers using the thresholds in their profile.
5. Report the results and the two or three biggest misses with likely causes.
