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
  "microChecks": [ ... ]
}
```

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
