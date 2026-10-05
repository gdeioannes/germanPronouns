# Story review system

How a story episode gets from "it passes the gate" to "it's genuinely fun".
The gate test (`src/routes/story/story-gate.test.ts`) is the hard floor —
pools, images, audio, solvability. This is the taste loop on top of it. Run
it at least **three rounds** for a new episode; log each round in the
episode doc (`docs/episodes/<ep>.md` → "Review log").

## The three instruments

1. **Scorecard** — `npm run story-review -- <episode id>` (`tool/review-story.mjs`).
   Static numbers from the JSON: estimated play time against the floor,
   share of passive beats, share of plain pick-one questions, mechanics
   mix, critical-beat count, German used before it is taught, wrong options
   without a reaction, straight translation questions, long narration,
   three-in-a-row mechanics, word-list coverage (`teaches`).
2. **Playtest bot** — `node tool/playtest-story.mjs <episode id> --base <dev url>`
   (`npm run dev` first). Plays the whole episode in Chrome with the right
   answers, screenshots every screen and dialogue turn into
   `assets/images/raw/playtest/<episode>/`, and reports page errors, stuck
   screens, unreached beats and missing files. The screenshots are what a
   reviewer looks at.
3. **Reviewer passes** — two independent reviews per round, each given the
   episode JSON, the scorecard and the screenshots, never the author's
   opinion of them:
   - **Player & game designer** — a curious adult who knows zero German,
     playing on a phone. Is every screen clear without help? Where is it
     boring, long, repetitive or confusing? Is it *playful* — is there
     something to do with the hands, a joke that lands, a payoff? Where would
     they quit?
   - **German teacher** — is every German line correct, natural and spoken
     the way people in Berlin speak? Is it introduced before it is asked?
     Is the load right for a first hour (new items per screen, repetition,
     du/Sie)? Are any answers ambiguous (two right options)?

Each reviewer returns ranked findings with a concrete fix. The author applies
what holds up, re-runs the scorecard and the bot, and logs the round.

## What "good" looks like (the checklist reviewers score against)

- **Playful, never a test.** No "What does X mean?" questions. Every
  question is a case action: tap the sign to get out, steer Maya, build her
  sentence, pick her reply in a live conversation. Plain pick-one questions
  ≤ 25 % of exercises.
- **Hands busy.** No more than two passive beats (narration, clue card) in a
  row; the same mechanic at most twice running, unless re-framed.
- **Show, then ask.** Every German word lands in the notebook (or is heard,
  with an English gloss) before it is asked for. Notebook entries are
  playable (the speaker button).
- **Every miss gets a reaction.** Wrong options carry an in-character reply;
  the game never just goes red.
- **The picture is part of the game.** Hotspots on the scene (signs, the TV
  tower, the Ampelmännchen, the bell plates), the Kiez map, the U-Bahn line.
  German on props is HTML overlay, never baked into the image.
- **Short lines.** Narration ≲ 300 characters; Maya's asides ≲ 170.
- **Pacing.** At or above the episode's floor, but a first episode should
  not feel like homework: a beginner should finish in one sitting.
- **Story pays off.** One mystery, honestly solvable from the German alone;
  clues used in the finale from memory; one continuity hook planted.
- **Bible rules.** Maya never speaks German aloud; one voice per character;
  cosy stakes; the learner is "partner".
