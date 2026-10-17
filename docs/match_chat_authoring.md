# Writing a "Schreib mir!" chat

How to write one match chat for `/play/schreib-mir`. The reference chat is
Oma Helga: read `assets/content/match/helga.json` and
`docs/match_chat_helga.md` first, and copy the structure exactly.

## The game in one paragraph

The learner swipes a character, matches, and chats to reach a goal shown up
front. The character writes; the learner answers by **building** sentences
from a word bank (never by picking an answer). Keywords in the sentence pick
the branch (an *intent*); the sentence also gets a 0–100 grammar score.
Interest starts at 5 (max 10) and moves by the intent's value, plus 1 for a
perfect sentence. At 0 the character deletes the match on the spot. After the
last turn: 7+ is a win (a like + saved contact), 4–6 is the partial ending,
under 4 is deleted. Every chat happens **once**: no retries.

## File

`assets/content/match/<id>.json`, `id` lowercase ascii (`bernd`,
`frau_koehler` → use `koehler`). Required fields, all checked by
`src/lib/domain/matchContent.test.ts`:

| Field | What |
|---|---|
| `id`, `name`, `age`, `emoji` | `name` as shown ("Frau Köhler"), `age` a number (a fridge can be 3) |
| `image` | `match_<id>`, the profile picture |
| `level`, `order` | the sub-level module, e.g. `"A2.1"`; `order` within the level |
| `bio`, `bioEn` | the profile line in German (easy for the level) + English |
| `goal` | the goal, in English, one sentence |
| `tagline` | for the contact card: "Bäckerin · 58 · Prenzlauer Berg" |
| `voice`, `brief` | the assigned Gemini voice; an acting brief in English (who they are, how they sound) |
| `focus` | the grammar practised, short: "Perfekt mit sein · Dativ" |
| `secretFlag` | only if there is a secret ending (default flag name `secret`) |
| `lexicon` | see below |
| `intro`, `turns`, `offTopic`, `confused`, `endings` | see below |
| `partialTitle` | German headline of the partial ending |
| `share` | `win`, `partial`, `deleted` (+ `secret`): German, funny, with `{score}` and `{url}` |
| `imageCharacter`, `imagePrompts` | see Pictures |
| `tests`, `playthroughs` | see Tests |
| `hidden`, `unlocks` | only for unlockable characters |

## Messages

`{ "who": "<id>", "type": "text", "de": "…", "emoji": "🪩", "en": "…", "audio": "mc_<id>_<slug>" }`

- `who` is always the chat id. `de` and `en` always. Emoji in `emoji`, never in `de` (`de` is read aloud).
- Every message with `de` gets a unique `audio` id `mc_<id>_…`, **except** lines containing `{name}` (the learner's name), which get no `audio`.
- `type: "photo"`: `image`, `alt` (German, it is part of the challenge), optional `overlay` (lines of text drawn over the photo, for any text the picture must show: the model cannot draw text), optional `wide: true` for 16:9.
- `type: "voice"`: a voice note, plays twice at most, transcript hidden until the end. `de` = transcript, `direction` = acting note ("shouting over traffic"), optional `bg`: `"techno"` (club loop) or `"scratch"` (record scratch first). No other `bg` values exist.

## Turns

```json
{
  "id": "t3",
  "before": [ messages the character sends, ending with the question ],
  "tiles": [ 12–20 tiles ],
  "wrong": { "tanzt": "tanze", "machen": { "to": "treffen", "note": "You 'treffen' a decision." } },
  "prepCase": { "auf": "acc" },
  "intents": [ … ],
  "next": "t5"
}
```

- **Tiles** must contain the words for *every* branch of the turn, plus wrong forms next to right ones (tanze/tanzt, dem/den, weil + the right verb). A word needed twice appears twice. Multi-word tiles are allowed ("in der Mitte"). Lowercase except nouns and names. `{name}` is the learner's name tile. The full-stop tile is always added by the app.
- **wrong**: tile → right form. A plain string on a verb is a verb ending (−20); anything else is a word (−15). Use `{to, note}` at B2–C for collocations and register ("eine Entscheidung machen" → treffen), the note in English.
- **prepCase**: the case of a two-way preposition in this turn (Wohin? → `acc`). Default is dative.
- `next` only to jump; otherwise turns run in order.

## Intents (the branches)

```json
{ "id": "friends", "when": { "any": ["freunden"], "none": ["nicht"], "all": [], "flag": "x", "noFlag": "y" },
  "value": 0, "reply": [ messages ], "flags": ["saidBlack"], "flagsIf": { "schwarz*": "saidBlack" },
  "fact": "🖤 trägt Schwarz", "photo": "match_<id>_outfit", "cause": "yellow", "next": "t7b", "noBonus": true }
```

- Checked **top to bottom, first match wins**. Put specific and negated intents first ("nicht" + verb before the plain yes).
- Keywords are lowercase tile words; `word*` matches a prefix. Every keyword must be in the bank.
- `value`: +2 great, +1 good, 0 honest but not hoped for, −1 wrong, −2 contradiction / lost negation. A perfect sentence adds +1 when value ≥ 0.
- **The near-answer rule**: for every question, list every answer a learner would naturally build from the bank and give each one an intent, even a neutral 0. The off-topic reply ("das war nicht meine Frage", −1) is a last resort. A playtester answered "Ich komme mit Freunden" and lost interest because only "fünf Freunden" was covered: never again. At least 4 intents per turn.
- `flags` remember claims, so a later turn can catch a contradiction (`"flag": "saidBlack"` on the later intent).
- `fact`: a German line with an emoji for the contact card ("🚪 findet geheime Türen").
- `cause`: a key of `endings.deleted`, for the line that ends the chat if this sinks it.
- Score below 60 → the character says the `confused` line ("Hä?"), −1, and the chat moves on.

## What the grammar checker can and cannot grade

It checks, with real rules (`gradeSentence` in `src/lib/domain/matchChat.ts`):

- the `wrong` map;
- article and adjective endings by case: after prepositions (incl. genitive ones: wegen, trotz, während …), with a pronoun subject + an `accVerbs` / `datVerbs` verb, genitive attributes after a noun;
- verb second in main clauses; verb last in clauses opened by weil, dass, obwohl, wenn, ob, damit, nachdem, bevor, falls, sobald, während, seit, bis … (add `als`, `wie`, `warum` … to `lexicon.subordinators` if a turn needs them); a sentence opening with such a clause must continue with the verb ("Weil ich krank bin, komme ich nicht");
- infinitives and participles (`lexicon.nonfinite`) at the end of the clause (Perfekt, modal verbs, werden, würde);
- imperatives listed in `lexicon.imperatives` may open a sentence;
- a full sentence with a pronoun subject but no verb.

- questions: the app offers a "?" tile, and a question may put the verb first ("Würden Sie …?") or after a question word;
- a second verb sharing the subject ("… und sah nichts"), participles and infinitives joined by "und";
- a first slot with focus particles ("Nur noch …"), a noun with a name, place adverb or prepositional phrase after it ("Herr Wolf", "der Stuhl rechts", "die Limonade mit Eis"), clock times ("um halb acht"), an adverb + prepositional phrase ("Gestern um acht");
- alle/jede/diese as articles, lowercase "ihr" + masculine/neuter noun as a possessive, indeclinable rosa/lila/super, "es gibt" + accusative, adjectives joined by "und";
- formal Sie / Ihr / Ihnen can be tiles without listing them as names.

It cannot grade, so **don't build turns that need**: relative clauses, verb-first conditionals ("Hätte ich …"), subject–verb agreement with a noun subject, the choice of haben/sein (use `wrong` where only one is right), the order of two infinitives, split separable verbs in tricky positions (offer the joined form "aufstehe" in subordinate clauses), extended participle phrases, plural forms after numbers. If the checker misgrades a correct sentence, change the bank or the example, don't fight it.

**Lexicon must list** every noun tile with its gender (`"pl"` for plurals, and each case form you use: `"Regens": "m"`), every finite verb form in any bank (right and wrong) in `verbs`, every infinitive/participle in `nonfinite`, adjectives that get inflected (base form) in `adjectives`, names in `names`, `accVerbs` and `datVerbs`. A capitalised tile that is not in `nouns` or `names` fails the tests.

## Level

Write the German for the level, and make the module's grammar the core of
the challenges (`assets/content/syllabus/de_cert_a1.json` has the structures
per module). A1: short main clauses, present tense. A2: Perfekt, Dativ,
weil/dass. B1: Konjunktiv II, Präteritum, passive. B2: Konjunktiv I,
irreale Bedingungen, Genitiv. C: register, collocations, nuance, irony; at C
the score mostly tests word choice (`wrong` with notes) and meaning.

## Shape and fun

- 7–9 turns, at most one secret branch. Mix in 1–3 media challenges: a photo to read, a voice note to understand, a photo the learner "sends" (picked by what they wrote, via `photo` on intents).
- The character is weird and funny, with a strong voice and running jokes; wrong answers are funny, never humiliating. Real German life where it fits (Pfand, Sonntagsruhe, Bürgeramt …).
- A careful learner should win; a careless one should get deleted; deletions must be funny.
- Endings: `win` (1–2 messages), `partial`, `deleted` with `default`, `confused` and one line per `cause`, `sunday` (a follow-up voice note), `secret` (only with `secretFlag`, else `[]`).
- No exam brand names, no real brands or real people, no romance or sexual content, nothing mean about groups of people.

## Pictures

`imageCharacter`: a fixed visual description of the character, reused in
every prompt as `{self}`. `imagePrompts`: `{ "id": "match_<id>…", "aspect": "3:4", "prompt": "…" }`.

- Always `match_<id>` (3:4 portrait for the profile). Then one per photo and per sent photo.
- **Puzzle pictures must be robust**: the image model gets layouts wrong. Use at most 3 objects to tell apart, by big obvious differences (colour, left/middle/right, size), describe the exact layout, and never need text in the image (use `overlay`). Count on someone checking the picture against the clue afterwards.
- No text, letters or logos in any picture (the style forbids it anyway).

## Tests (in the file)

- `tests`: at least 3 per turn, each `{ "turn", "say", "score"?, "intent"?, "delta"? }`. Cover a perfect answer, a small-mistake answer (score 70–85), each near-answer, a wrong answer, and one "Hä?" (`"intent": null`). `say` is the sentence as written, using only bank tiles (and `{name}`).
- `playthroughs`: `{ "name", "ending", "say": [["t1", "…"], …] }`: at least a win and a deletion; the partial and secret ones if they exist.
- Run `npx vitest run src/lib/domain/matchContent.test.ts -t "^<id> "` until it is green. Do not edit the engine, the tests, or other chats.

## Story, not lesson (the fun rule)

Players hated a character asking "Bett: der, die oder das?". The character
lives in their own crazy world and **never knows it is a German lesson**.

- **Never quiz the language.** No "der, die oder das?", "Sag es höflich",
  "Im Perfekt, bitte", "Wie heißt das auf Deutsch?", "Bilde einen Satz",
  "Ist das richtig?". Exceptions only where the premise *is* language (Robo-7
  learning German, Polly the parrot repeating you), and even there it stays a joke.
- **Hide the grammar in the situation.** Ask a real, absurd question whose
  natural answer needs the structure. Instead of "Bett: der, die oder das?",
  Bernd says: "Ich habe Hunger. Was steht in deinem Zimmer? Ich frage für
  meinen Bauch." The learner answers "Ein Bett und ein Stuhl" — articles practised,
  nobody asked about articles.
- **Every line earns its place**: a joke, an absurd detail, a twist, a callback.
  "Okay but basic" is not good enough. Each chat needs at least one wild
  escalation (the goat starts a band; the fridge falls in love with the
  freezer; the official's stamp has a name and opinions).
- **Crazy answers welcome.** Put one or two absurd but grammatical options in
  each bank (a giraffe, a tuba, "mein Anwalt") and give them funny replies.
  Learners love saying ridiculous things in correct German.
- Corrections stay invisible in the story: the recast quote and the score
  badge do the teaching, the character just reacts.
