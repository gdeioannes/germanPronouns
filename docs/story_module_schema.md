# Story module — schema spec (Step 0)

A story episode is a gamified narrative module (Maya mysteries) layered on
top of the existing quiz system. This spec defines the JSON before any code;
the TypeScript types, loader and gate test are written after this is approved.

Episodes live at `assets/content/stories/<id>.json` (authoring), get bundled
by the content generator like other content, and render in a dedicated story
player page.

## Top level

```jsonc
{
  "id": "ep1_empty_room",
  "course": "de_cert_a1",
  "level": "a1_1",                 // half-level the vocab is drawn from
  "half": 1,                        // 1 = first half of the level's topics
  "title": "The Empty Room",
  "tagline": "Maya's flatmate vanished overnight. Help her find him.",
  "minutesFloor": 8,                // authoring target, checked by gate test
  "credibility": 3,                 // lives; lost on flagged wrong answers
  "cast": ["maya", "jonas", "lena", "boehm"],  // recurring cast from story_bible.md + episode cast from docs/episodes/
  "pools": { ... },                 // randomization pools, see below
  "chapters": [ ... ],
  "hub": { ... },
  "microChecks": [ ... ],
  // optional, read by the shared player (src/lib/components/story/):
  "cover": "story/ep1_room_wide",   // title-screen scene
  "ending": { "image": "…", "title": "…", "text": "…", "line": "…" },
  "microFrom": "Maya 💬",           // who the between-chapter checks are from
  "teaches": ["Hallo", "…"]         // the word list, checked by npm run story-review
}
```

The hub may also carry its screen texts: `title`, `lockedHint`,
`finaleLabel`, `allCluesLine`. Narration clips are
`<prefix>_narr_<beatId>.mp3` where the prefix is the id up to the first
underscore (`ep0`, `ep1`). Every episode runs in the one shared player —
a route is just `<StoryPlayer episode={…} />`.

## Chapters

Linear by default; the `hub` makes a group of them free-order.

```jsonc
{
  "id": "ch3_phone_call",
  "title": "The Phone Call",
  "clue": "A",                      // completing it grants this clue (optional)
  "beats": [ ... ]                  // played in order
}
```

### Beats

Every beat has an `id` and a `type`; narrative and quizzes interleave freely.

**`narrative`** — Maya talking (English), with scene image and optional audio:

```jsonc
{ "id": "b1", "type": "narrative",
  "image": "story/ep1_room_wide",   // static/img/ key
  "audio": "story/ep1_b1",          // optional ambient/voice clip
  "text": "Okay. His room is EMPTY. Beds don't just... leave. {user}, I need you." }
```

`{user}` marks direct address; `{pool:flatmateCity}` etc. splice randomized
values (see pools) into narrative and quiz text alike.

**`quiz`** — embeds one quiz using existing kinds (reading, listening,
dictation, inline cloze/bigText, select) by inline definition, same shapes
the quiz system already uses:

```jsonc
{ "id": "b2", "type": "quiz", "kind": "listening",
  "image": "story/ep1_voicemail",
  "critical": true,                 // wrong answer costs 1 credibility
  "quiz": { /* existing quiz content shape */ } }
```

**`orderedPick`** — the NEW kind: choose options in the correct sequence.

```jsonc
{ "id": "b3", "type": "quiz", "kind": "orderedPick",
  "layout": "keypad",               // keypad | tiles | bubbles
  "critical": true,
  "prompt": "Dial the number you heard.",
  "audio": "story/ep1_number_{pool:phoneNumber}",
  "sequence": "{pool:phoneNumber}", // the correct order (digits or item ids)
  "options": [ ... ],               // tiles/bubbles: items incl. decoys
  "retry": "replayAudio" }          // on fail: replay and retry (busy tone)
```

Layouts: `keypad` = 0–9 dial pad (sequence is digits), `tiles` = word/sentence
tiles to order (word order, chat sorting), `bubbles` = dialogue replies
assembled in order.

**`clue`** — a found vocabulary scrap (Jonas's sticky notes, a decoded
grumble): German/English pairs that go into Maya's in-game notebook. This is
how the story teaches — diegetic dictionary entries, never a lesson:

```jsonc
{ "id": "b5", "type": "clue", "title": "Jonas labels everything",
  "intro": "Under the bed: sticky notes...",
  "entries": [ { "de": "ich bin", "en": "I am" } ] }
```

**`recall`** (quiz kind) — a memory question: the answer was seen or heard
earlier and may NOT be re-shown (no transcript, no replay). Decoy options
are the OTHER pool variants via `{pool:name:other1}` / `:other2`, so the
drawn variant is always among its plausible siblings. Used for the room
number at the finale door and for Maya's between-chapter micro-texts.

Chapters may carry `studyLinks`: quest ids the learner can optionally open
to train that chapter's grammar ("want to drill this?") — the story itself
never quizzes grammar in the abstract; every question is a case action
(tape the note, pin the fact, dial, remember).

**`banter`** (quiz kind) — a light conversational ask ("Hilfst du mir?"):
every option carries a `reply` — Maya's in-character reaction. Wrong answers
get a retort and another try; non-critical, there to keep early narrative
stretches interactive.

**`dialogue`** (quiz kind, added for Episode 0) — a live conversation as
chat bubbles (`DialogueBeat.svelte`). Character lines are voiced and play as
they appear (`rate` slows/speeds playback; `blur: true` = too fast to read,
the gag before "Ich verstehe nicht"); the learner's turns are Maya's —
`choose` (options with `reply`) or `build` (tiles). `aside` lines are Maya's
English whispers. Maya's German is text only.

```jsonc
{ "id": "b6", "type": "quiz", "kind": "dialogue", "image": "story/ep0_baeckerei",
  "lines": [
    { "who": "baeckerin", "name": "Frau Demir, the baker", "de": "Wie heißen Sie?",
      "en": "What's your name?", "audio": "story/ep0_baecker_name" },
    { "who": "maya", "build": { "sequence": ["Ich", "heiße", "Maya."],
                                "options": ["Ich", "heiße", "Maya.", "Sie", "komme"] } },
    { "who": "aside", "text": "NOW. The note." },
    { "who": "maya", "critical": true, "choose": [
      { "text": "Entschuldigung… Jonas?", "correct": true },
      { "text": "Tschüss… Jonas?", "correct": false, "reply": "“Bye, Jonas? …”" } ] } ],
  "reveal": "Jonas WEBER." }
```

`who` picks the voice in `tool/gen-story-audio.mjs`; `audio` keys may be
pooled like any other.

**`hotspot`** (quiz kind) — tap the right thing in the scene
(`HotspotBeat.svelte`). `spots` are boxes in percent of the picture; a spot
with `label` gets the German overlaid on the blank-drawn prop (`style`:
`sign` | `plate` | `chalk`), one without is a hidden zone that glows after
two misses. `crop` zooms into part of the picture (spots keep full-picture
coordinates); `entries` drop words into the notebook on success; `sound`
names an sfx.

```jsonc
{ "id": "f5", "type": "quiz", "kind": "hotspot", "critical": true,
  "image": "story/ep0_bells", "crop": { "x": 22, "y": 8, "w": 46, "h": 84 },
  "prompt": "Four bells. One is Jonas. Ring it!",
  "spots": [ { "id": "weber", "x": 32.7, "y": 46.3, "w": 13.4, "h": 9.3, "label": "Weber", "style": "plate" } ],
  "answer": "weber", "sound": "doorbell", "missLine": "…", "reveal": "…" }
```

**`map`** (quiz kind) — the code-drawn Kiez map (`KiezMap.svelte`, layout
data in `kiez.ts`; no image). `mode: "find"`: tap `target` (a place id,
poolable); `labels: false` hides place names (German word → picture),
`streetLabels` toggles street names. `mode: "walk"`: steer Maya from the
square with links / rechts / geradeaus; `walks` holds one
`{ turns, path }` per variant of `walkPool` (path = junction ids, one more
than turns).

**`stops`** (quiz kind) — a U-Bahn ride (`StopsBeat.svelte`): the variants of
`pool` are the stops, in a shuffled order with the drawn one never first;
each plays `audio` (pooled per variant, spoken from `transcript` by
`speaker`); the learner stays on or gets off. Names stay hidden until passed.

**`choice`** — pure narrative branching (red herrings, hub flavor):

```jsonc
{ "id": "b4", "type": "choice",
  "text": "Where should I look first?",
  "options": [
    { "label": "The kitchen", "goto": "ch_kitchen_herring" },
    { "label": "Back to the room", "goto": null } ] }
```

## Hub

```jsonc
{ "afterChapter": "ch2_voicemail",
  "leads": ["ch3_phone_call", "ch4_steckbrief", "ch5_chat"],
  "requiredClues": ["A", "B", "C"],
  "unlocks": "ch6_confrontation" }
```

Leads are playable in any order; the unlock chapter opens when all required
clues are held.

## Pools (anti-memorization)

Named pools of variants; one variant per pool is picked at episode start
(and re-picked on restart). Every audio/text/answer that references a pool
must exist for **every** variant.

```jsonc
"pools": {
  "phoneNumber": ["0 3 0 5 5 1 2 8", "0 3 0 7 6 3 1 9", "0 3 0 2 9 8 4 6"],
  "roomNumber":  ["Zimmer zwölf", "Zimmer sieben", "Zimmer fünfzehn"],
  "lenaCity":    ["Hamburg", "Leipzig", "Dresden"]
}
```

Pre-rendered audio variants are keyed `story/<clip>_<poolIndex>`.

## Micro-checks

One-question "texts from Maya" shown between chapters (spaced review):

```jsonc
"microChecks": [
  { "after": "ch2_voicemail", "kind": "select",
    "text": "quick — *das* Zimmer or *der* Zimmer? need it for my notes",
    "quiz": { ... } } ]
```

## Fail & restart rules

- `critical: true` wrong answers cost 1 credibility; at 0, the **current
  chapter** restarts (solved chapters stay solved), credibility refills,
  pool values used by that chapter re-randomize.
- Non-critical quizzes behave like normal quizzes (retry freely).
- Audio beats and quiz audio must play through once before answering unlocks.

## Progress & storage

- Per-episode progress under a new storage key `story_<id>` (chapter states,
  clues, credibility, picked pool indices). Existing storage key prefixes
  untouched.
- Episode completion can clear the corresponding quest gates? **Decision
  deferred** — for v1 the episode is standalone; completing it awards its
  own medal/badge only.

## Gate test (enforced in CI)

1. Every evidence chapter has ≥ 3 quiz beats; bigText beats ≥ 6 blanks;
   tile sorts ≥ 6 items; estimated play time ≥ `minutesFloor`.
2. Every pool has ≥ 3 variants; every pool reference resolves; every
   audio variant key exists in the audio manifest.
3. Every `image`/`audio` key exists; every `goto` target exists; hub clues
   are all grantable; the unlock chapter is reachable.
4. All German content passes the exam-framing check and uses only
   level-appropriate vocabulary (checked against the half-level word list).
5. Cast ids exist in `docs/story_bible.md`.
```
