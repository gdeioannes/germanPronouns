# Episode 0 — "Lost in Berlin" (de_cert_a1, A1.1, the prologue)

The first thing a learner who knows **no German at all** can play. Maya
lands in Berlin to move into a shared flat she has never seen, with a dead
phone and a rain-soaked note; the learner gets her from the airport to the
right doorbell. It is the pilot of her podcast, so it also recruits the
learner as her assistant — Episode 1 ("The Empty Room") assumes that has
happened.

General rules (art style, Maya, language mixing, voices) live in
`docs/story_bible.md`; the JSON schema in `docs/story_module_schema.md`;
the script itself is `assets/content/stories/ep0_lost_in_berlin.json`
(rendered readable at `/dev/story-bible/episode?ep=ep0_lost_in_berlin`).

## Premise

Morning, Berlin airport. Maya Ellison — American true-crime podcaster, zero
German — arrives to move into a WG room she found online. Her phone dies at
the gate. All she has is a note from her future flatmate Jonas, soaked in
the rain on the way out: the street name is smudged to one letter, the
signature has no surname. The mystery is cosy and small: **where is the
flat, and whose bell is it?** Three leads around the square where she gets
off (a city map, a passer-by, a bakery) each give one clue; the finale is
the walk to the door from memory and the doorbell.

Continuity: Jonas is **never seen or heard** — only his note, his surname
on the bell and a welcome note in the kitchen (Episode 1 introduces him). A
woman in a terracotta coat leaves the building as Maya arrives and says
"Guten Abend" — Lena, revealed in Episode 1 (paid off in its `f3` line).
Herr Böhm, the caretaker, lets her in — his first appearance.

## Prologue exceptions to the formula

Agreed 2026-10-05; recorded in the bible's formula section:

- **Play floor 7 min** instead of 8 (true beginners — less German to fill
  time honestly; real play with mistakes is 10–12 min).
- **Numbers only as digits** (the house number) — number words belong to
  `quest_a1_1_zahlen`, the course's first exercise.
- **Tap only, no typing** — the learner cannot spell anything yet.
- The vocabulary is **survival German**, not the A1.1 grammar topics: no
  pronoun/article/verb drills, every word arrives in the story first.

## What it teaches (42 items)

Every tested item is first met in the story (a sign, the note, a voice) and
lands in Maya's notebook as a clue card before it is asked.

| Group | Items |
|---|---|
| Greetings | Hallo · Guten Morgen · Guten Tag · Guten Abend · Tschüss · Auf Wiedersehen · Bis bald · Willkommen |
| Polite words | ja · nein · danke · bitte · Entschuldigung |
| Introducing yourself | Ich bin … · Ich heiße … · Wie heißen Sie? · Ich komme aus … |
| Small talk | Wie geht's? · Gut, danke. |
| Survival | Ich verstehe nicht. · Sprechen Sie Englisch? |
| Finding the way | Wo ist …? · links · rechts · geradeaus · dann · Nächster Halt |
| Places | der Ausgang · der Bahnhof · die Straße · der Platz · der Park · die Brücke · die Bäckerei · das Haus · die Wohnung · die Nummer |
| Bakery | der Berliner · der Pfannkuchen · der Kaffee |
| Berlin words | der Fernsehturm · das Ampelmännchen · der Pfannkuchen |

Seen but not tested: U-Bahn, der Hausmeister, Sie sind hier.

## Berlin facts (English first, then the German word)

Maya's "podcast facts", each tied to something she passes and tapped in
the scene:

1. **Der Fernsehturm** — 368 m, the tallest structure in Germany, visible
   from almost everywhere (train window).
2. **Die Brücke** — Berlin has more bridges than Venice (the map).
3. **Das Ampelmännchen** — the little hat-wearing traffic-light man from
   East Berlin, kept after reunification by popular demand (the crossing).
4. **Der Pfannkuchen** — in Berlin a jam doughnut is a *Pfannkuchen*; the
   rest of Germany calls it a *Berliner* (the bakery).

## Interactions (no "what does X mean?" questions)

| Interaction | Where | What the learner does |
|---|---|---|
| `hotspot` (tap in the scene) | airport signs, TV tower, Ampelmännchen, bakery counter, bell board | finds the German word in the picture |
| `map` find | the Kiez map (code-drawn SVG) | taps the place Maya names, German → picture |
| `map` walk | finale | steers Maya with *links / rechts / geradeaus* from memory |
| `dialogue` | airport, passer-by, bakery, Lena, intercom | live conversation: voiced lines, picks or builds Maya's reply |
| `stops` | the U-Bahn | listens to "Nächster Halt: …" and gets off at the right stop |
| `inlineCloze` | the soaked note | restores the smudged words |
| `orderedPick` tiles | sentences | builds Maya's German word by word |
| `banter` / `recall` | everywhere | in-character replies, memory checks |

## Structure

```
ch0 Willkommen (airport, morning)  survival card → "Hilfst du mir?" Ja! · dialogue "Guten Morgen!" · tap the sign to the TRAINS
ch1 Der Zettel                     the soaked note: restore it (cloze, styled as the note)
ch2 Die U-Bahn                     TV-tower fact → tap it (decoy roofs) · stops game with near-miss names
HUB at {station}:
  ch3 Der Stadtplan  → A street    find die Brücke, der Park · read the smudge against same-initial streets
  ch4 Die Passantin  → B way       (needs A) ask by name · fast → Wie bitte? → fast → Ich verstehe nicht… → slow · green Ampelmännchen
  ch5 Die Bäckerei   → C bell      Guten Tag / Bitte schön / "Einen Berliner" → "hier heißt das Pfannkuchen" · names, Wie geht's · "Jonas Weber" · tap what he DRINKS
ch6 Die Klingel (dusk)             walk from memory (no street names) · Nummer · ring Weber · Lena · intercom build · Böhm
end                                kitchen note → tap the coffee · two mugs, one warm · sign-off
```

Pools (one index for all 3-variant pools): street (Linden-/Garten-/
Bergstraße) with its smudge and same-initial decoy (Lessing/Goethe/
Brunnen), station (Rosenplatz/Marktplatz/Königsplatz), house number
(7/9/12), way (links→geradeaus / rechts→geradeaus / geradeaus→links). The
Kiez map (`kiez.ts`) is laid out so each way really leads to its street.

## Episode cast

### DIE PASSANTIN (passer-by — ch4)

> A woman in her fifties walking a small dachshund, drawn with natural adult
> proportions and a realistic head-to-body ratio, never chibi. Short grey
> bob, red-framed glasses, a sage-green rain jacket, navy trousers, a
> mustard tote bag. Light skin, brisk and kind expression, always in a hurry.

Block `{passantin}`. Voice: Chirp 3 HD Zephyr (de-DE) — bright, quick.

### DIE BÄCKERIN (baker — ch5)

> A baker in her forties, drawn with natural adult proportions and a
> realistic head-to-body ratio, never chibi. Round friendly face, dark curly
> hair tied up under a cream headscarf, rolled sleeves, a terracotta apron
> dusted with flour. Medium-brown skin, warm and chatty expression.

Block `{baeckerin}`. Voice: Chirp 3 HD Sulafat (de-DE) — warm.

### Minor voices

Airport stranger (ch0): Achird (de-DE, friendly). U-Bahn announcement:
Schedar (de-DE, even). Lena (ch6 cameo): Aoede, as cast. Böhm (ch6): Charon,
as cast. Maya: Achernar (en-US), as cast.

Voices were cast by Chirp 3 HD voice description, without a listening
round; audition clips are in `tool/gen-voice-refs.mjs` (`npm run voices`) —
recast there if one sounds wrong.

## Locations

- **Airport arrivals** — glass hall, blank hanging signs (German overlaid).
- **U-Bahn carriage** — window with the TV tower passing.
- **The square** (the hub) — station entrance, a map board, a crossing with
  an Ampelmännchen light, a corner bakery with a striped awning.
- **The bakery** (manifest block `{baeckerei}`) — wooden counter, glass
  display with pretzels and doughnuts, a chalkboard, a coffee machine.
- **The Altbau front door** — dark-green double door, brass bell panel.
- **The WG kitchen** (from Episode 1's plan) — the welcome note.

## Continuity hooks

- Planted: the woman in the terracotta coat (→ Lena, Ep 1 `f3`).
- Planted: Böhm has the spare key and "no time" (→ his Ep 1 role).
- Planted: Jonas is never home ("Bis bald") — Ep 1 opens with him gone for
  real, and Maya never quite met him.

## Review log

The episode is iterated with `npm run story-review -- ep0_lost_in_berlin`
plus the reviewer passes in `docs/story_review.md`; findings and what
changed are logged below per round.

### Round 1 (2026-10-05) — designer + German teacher

Scorecard before: 18.8 min, 46 beats, 46 % passive, 45 notebook words.
After: 17.1 min, 41 beats, 41 % passive, plain pick-one 4 %.

- **Bugs:** hub title showed a raw `{pool:station}` (hub texts now resolved);
  the doorbell image spoiled Lena two beats early; the scorecard missed
  teach-before-ask in banter and in any-order hub leads (both fixed in the
  tool).
- **Show-then-ask:** the guidebook card now comes before "Hilfst du mir? →
  Ja!"; Entschuldigung moved to that card (it's used in every lead);
  Nummer/Haus taught before the house-number question.
- **The hub logic:** the passer-by lead now requires the street (clue A)
  so she can be asked by name; the map clue became a reading puzzle —
  same-initial decoy streets (Lessing/Linden, Goethe/Garten,
  Brunnen/Berg) and a smudge that keeps the word's end.
- **The finale is memory again:** no street names on the walk map (only the
  destination appears on arrival), Maya's pin shows which way she faces, and
  the TV tower is the compass ("facing the Fernsehturm").
- **Natural German:** the baker opens "Guten Tag! — Bitte schön?" (no
  "Wie geht's?" to a stranger at the counter; it moved to after the names);
  the note is signed "Bis bald! Jonas"; "Englisch? Nein, leider nicht. Aber
  ich spreche langsam."; Böhm answers "Ach so, für Weber" because Maya now
  says the name; build distractors that were also correct removed.
- **Playful, not a test:** the signs hotspot is a decision (we want TRAINS,
  not the exit), the TV tower has decoy roofs, the Ampelmännchen is red-vs-
  green, Jonas's breakfast becomes "tap what he DRINKS", the kitchen note is
  read and acted on (tap the coffee), per-spot miss lines.
- **New passer-by flow:** fast → "Wie bitte?" → fast again → "Ich verstehe
  nicht. Sprechen Sie Englisch?" → slow.
- **Cliffhanger with evidence:** Lena glances at the WEBER bell; in the
  kitchen there are two mugs and one is still warm.
- **Trimmed:** merged the opening panels, cut the case-board pick-ones and
  the duplicate podcast pitch, two drill micro-checks; four U-Bahn
  near-miss stops (Rosenthaler Platz …) make the listening game tenser.
- **UI:** hub tiles carry an English line and, once solved, the clue itself
  ("✓ Street: Lindenstraße"); a credibility hint on critical questions;
  Maya's toast moved off the answers; the note puzzle looks like a note.

### Round 2 (2026-10-05) — designer 6.5/10, teacher "ship after fixes"

Scorecard after: 16.8 min, 38 beats, 34 % passive, 0 % plain pick-one.

- **The way is heard, not handed over:** her slow line is blurred (listen
  only), Maya traces it with arrow tiles (critical); the hub tile says
  "memorised", the micro-check that repeated it is gone.
- **No more echo replies:** Maya greets first and the picture decides —
  the bakery clock says 14:30, Lena appears at dusk; the airport signs are
  decoded from pictograms (no pre-card) and file their words on the tap;
  the bell name is decoded ("Jonas WHO? — Weber / Brezel / Morgen").
- **The house number is a door:** three doors with enamel plates
  (`ep0_doors`), number recalled from the note.
- **The case is deduced:** "who had coffee here?" before the sign-off;
  Frau Demir's coffee for Jonas pays off as the third coffee on the table.
- **German fixes:** "zu Weber … Kommen Sie rein", "Aber ich spreche jetzt
  ganz langsam", "Also: die … — …", Bitte schön? / Bitte schön! both on the
  card, no untaught distractors (the scorecard now checks distractors too),
  Berliners and red lights told honestly, "in most of Germany ‘Berliner’".
- **Trimmed:** directions merged onto the passer-by card, the doorstep card
  and the outro panel cut (the ending carries it); words filed from dialogue
  lines as they're heard instead of a card mid-conversation.
- **UI:** no "Clue secured!" stamp over the screen (Maya's toast says it),
  toast is a small bottom-corner bubble and rarer; stop names wrap; bigger
  map labels; zoom crops on the traffic light and the kitchen table.

### Round 3 (2026-10-05) — designer 8/10, teacher "ship after fixes"

Scorecard after: 16.5 min (generous slow-beginner model), 38 beats, 34 %
passive, 0 % plain pick-one, 47 notebook words; gate 26/26; bot plays 38/38.

- Fast lines are a squiggle until the conversation ends (a CSS blur could
  still be read) — the way is truly listen-only.
- The house number is part of clue A ("Address: Lindenstraße 7"), so the
  door puzzle is set up; the map board "shows where, not which way" — why
  Maya still asks a local.
- "Sie sind hier — tap where WE are" replaces the park find (uses *hier*,
  sets up the walk's start); der Park dropped from the list.
- Direction words filed just in time on the passer-by's "Aber ich sag's noch
  mal — ganz langsam" line; Guten Abend filed on the doorstep; Hausmeister
  named in the bell prompt; no untaught distractors left.
- A sound-alike stop for every station (Königstraße); kitchen coffee count
  and the f10b reply fixed. End screen: the main button starts learning
  (the first A1.1 exercise, Zahlen 0–10) — Episode 1 is earned mid-A1.1, not
  linked from here (user decision 2026-10-05).
- **Deliberate exception:** the airport signs (a6) are tappable before
  Ausgang/Bahnhof are taught — the pictograms make it a picture-decoding
  puzzle and the words file on the tap. Don't "fix" it with a pre-card.

Open (not done, worth a later pass): the Ampelmännchen in the picture has
no hat (the fact moved to the reveal); the end-screen "Case closed!" stamp
briefly covers the hook text (shared FX); the header title truncates on
phones (shared with Episode 1).
