# Episode 2 — "The Secret Room" (de_cert_a1, end of A1.1)

The A1.1 finale. Maya has finished the level with the learner and now has
enough German to open doors herself — this episode puts **all of A1.1** to
work: the first half (numbers 0–20, pronouns, articles, plural, sein &
haben, W-Fragen, regular verbs, introductions) is re-tested in passing, the
second half (20–100 and over 100, colours, family, countries & languages,
Wo-prepositions, compounds and -in, the alphabet and spelling, vowel-change
verbs) carries the new evidence.

General rules live in `docs/story_bible.md`; JSON schema in
`docs/story_module_schema.md`; the review loop in `docs/story_review.md`.
Script target: `assets/content/stories/ep2_secret_room.json`.

Status (2026-10-08, evening): **complete and gate-green** — JSON, route,
registry, 19 pictures (+ the shared `ep1_maya_mic` redrawn so Maya sits
behind the desk), 64 clips, notebook words, sfx; `npx vitest run
src/routes/story` passes 44/44; the playtest bot plays 55/55 beats with no
page errors and no missing files. Open item: 19 clips are plain Chirp
reads, not acted takes (see "Audio takes" below).

## Where we left off (Episode 1)

Jonas was found at Pension Sonnenschein, Zimmer N, paint roller in hand,
Lena laughing beside him. The only answer Maya got: *"Bald, Maya. Bald."*
Open questions carried in: what is behind that door, who is Lena really,
and why does Jonas trust her and not Maya.

## Premise

Three weeks later. Jonas's room in the WG is still empty, but a parcel
arrives for him — paint, three cans, delivered to the wrong address with a
return label from the Pension. Maya decides "soon" has waited long enough.
With the learner she works three leads around the Pension: the parcel's
paperwork, a phone call where she finally gets Lena's surname spelled out,
the Pension's grandmother, a caretaker's note about a hidden key, and
Jonas's torn crate labels. The finale is a night visit to Zimmer N — and a
grandmother who catches her in the corridor.

**The honest solution (from the German evidence alone):**

1. Lena's surname is the Pension's family name → Lena is the owner's
   **granddaughter** (Enkelin); the Pension is her family's.
2. Jonas is Lena's **Freund** — her boyfriend, not "a friend" (the
   Freund/Freundin trap from `quest_a1_1_familie`). He moved out of the
   WG to move in with her. That's the "why" of Episode 1.
3. The room is being turned into a tiny **recording studio** (the compound
   labels: Mikrofon, Kopfhörer, Schreibtisch, Stehlampe, Wandfarbe).
4. The Pension opened **1926** — this year it turns **100**. The studio is
   for a hundred-years podcast of the grandmother's Berlin stories, and
   they want Maya to host it — *in German*. "Bald" meant: when your German
   is ready. That is why nobody told her: Maya broadcasts secrets to forty
   thousand strangers for a living.

Cozy stakes, nobody is a villain, and the reveal re-frames the whole
season: the learner's German *was* the surprise.

**Cliffhanger (one question):** the grandmother hands Maya a photograph of
the Pension in 1926. One face is circled in pencil. *"Wer ist das?"* →
Episode 3 (A1.2).

## Episode cast

Recurring: Maya, Jonas (now seen in person), Lena (now warm), Böhm.

### OMA HARTMANN (the Pension's owner — Lena's grandmother)

> Frau Hartmann, a small, upright woman around eighty, white hair pinned
> up, light skin, half-moon reading glasses on a chain, a sage cardigan
> over a cream blouse, a brooch, sensible shoes. Sharp eyes, dry humour;
> the only person in the series Maya is a little afraid of.

New block `{oma}`, reference sheet `oma_ref_neutral`, voice to be cast by
audition (older de-DE voice; add 3 candidates to `tool/gen-voice-refs.mjs`
with her signature line *"Und Sie sind…?"*, run `npm run voices`, pick by
ear). Her surname is pooled with Lena's (`familyName`) — in prompts she is
always "the grandmother"; the name only ever appears as overlay/text.

### THE COURIER (one scene)

> A delivery rider in a yellow rain jacket and helmet, parcel scanner in
> hand, in a hurry.

Voice: any spare de-DE audition voice not yet used (fast, bored).

### THE RECEPTIONIST (phone only)

Reuse the Episode 1 receptionist voice.

## Locations

- **The WG kitchen** (intro, micro-texts) — existing block.
- **The Pension lobby** (phone lead, finale entrance) — existing block.
- **The Pension's breakfast room** (new): a sunlit room with white
  tablecloths, a dresser with cups, framed black-and-white photos of the
  house along one wall, a tall clock. Dusk-window light.
- **The Pension kitchen** (new): an old Berlin guesthouse kitchen — tiled
  walls in cream and sage, a big gas stove, a wooden table with the
  ingredients laid out (onion, eggs, two rolls, minced meat, mustard jar,
  parsley, salt), a cast-iron pan, copper pots on hooks. Dusk-window
  light, steam. Props drawn blank for label overlay.
- **The back courtyard / Hinterhof** (new): a typical Berlin inner
  courtyard — brick walls, bike racks, a flower pot by the back door, a
  doormat, a fuse box, a row of bins. Door-shaft light by day, torch noir
  for the finale.
- **Zimmer N, revealed** (new): a small room half-painted light blue, a
  desk with a microphone on an arm, headphones, a standing lamp, a crate,
  and a hand-painted banner (blank — overlay) for "100 Jahre". Lamp cone.

## Pools (anti-memorization)

| Pool | Variants | Used in |
|---|---|---|
| `roomNumber` | 12 · 7 · 15 | parcel label, finale door (new draw — Maya "copied it from the Episode 1 notebook") |
| `familyName` | Hartmann · Neumann · Vogel | spelled on the phone, guestbook, Oma's name |
| `postcode` | 10437 · 10405 · 10435 (real Prenzlauer Berg codes) | parcel label, recall |
| `paintColour` | hellblau · grün · gelb | parcel, crate labels, the room's walls in the finale |
| `paintPrice` | 34,90 · 42,50 · 27,80 | invoice listening |
| `omaCountry` | Polen · Österreich · die Türkei | Oma's origin (she came to Berlin as a child; languages follow) |
| `keyPlace` | unter der Matte · im Blumentopf · auf dem Fensterbrett | Böhm's note, courtyard hotspot |

The founding year **1926** is fixed (it is the point), as is "100 Jahre".

## Structure and challenges (7-chapter skeleton)

Play floor **10 min** (level finale, more than the 8-min minimum),
credibility 3, **31 interactions, 9 critical** (trimmed 30 % from the
first draft on 2026-10-08 — ep0/ep1 have 25/20 quiz beats; this one may be
a bit longer, not twice as long). Every quiz is a case action. Player
note: the kitchen's voiced requests need a hotspot beat that runs several
rounds on one picture (or chained hotspot beats sharing image + spots) —
check `HotspotBeat.svelte` before authoring.

### Intro — "Bald is over" (kitchen, 2 panels + recruit) — 1

- Panel 1: three weeks of nothing. Jonas's door still shut. Maya's case
  board has one word on it: BALD.
- Panel 2: the doorbell. A courier, a heavy parcel for *Jonas Weber*,
  *"Unterschreiben Sie hier, bitte"*. Maya signs. The parcel is from the
  Pension — and it's addressed back to Zimmer N.
- `banter` recruit: *"Partner. Three weeks. Are we doing this?"* — every
  option gets a reaction; "no" gets *"Wrong. We are."*

### Ch.1 — "The Parcel" (evidence, linear) — 4 — **numbers over 100, colours, prices, articles**

Material: the delivery label and the invoice taped to the cans.

1. `hotspot` — the label: tap the *Postleitzahl* (passing remark: every
   Berlin postcode starts with 1; the Pension's begins 104 — Prenzlauer
   Berg). Overlay `{pool:postcode}`.
2. `orderedPick` keypad, critical — "Type the postcode into the tracking
   site", overlay hidden: dial `{pool:postcode}` from memory.
3. `inlineCloze` on the invoice (≥6 blanks, tiles): *3 × Wandfarbe**n**,
   {paintColour} · 1 × der Pinsel · 2 × die Folie … Gesamt: {paintPrice}
   €* — restore articles, plural -n, colour after a count.
4. `listening` — the courier's voice note, *"Das macht {paintPrice}
   Euro."* → pick the amount from three near-misses (34,90 / 43,90 /
   34,19).
5. `clue` — notebook: die Postleitzahl, die Wandfarbe, hellblau, der
   Pinsel, das Paket, kostet/macht.

### Ch.2 — "Buchstabieren Sie, bitte" (evidence, linear) — 4 — **alphabet & spelling, Sie-forms, W-Fragen**

Maya phones the Pension to "return the parcel", really to get a surname.

1. `dialogue` — *"Pension Sonnenschein, guten Tag?"* → Maya `build`:
   *Guten Tag, hier ist Maya Ellison.* (tiles; decoys *bin / du / heißt*).
2. *"Ellison — wie schreibt man das?"* → `orderedPick` tiles of
   **letters** in German letter names (audio per tile): E-L-L-I-S-O-N,
   Maya's tip: *"Doppel-L"*.
3. Maya asks for Lena → *"Welche Lena — Lena {familyName}?"* spelled
   fast, once → assemble `{pool:familyName}` from a letter bank
   (critical; one replay as the "bad line" gag). The receptionist adds
   *"Ach, die Enkelin von der Chefin!"* — Maya writes both words down
   (`clue` card: Enkelin, Chefin, the -in rule — asked in Lead A).
4. `choose` the right way to end the call (*"Vielen Dank, auf
   Wiederhören!"* vs *Tschüss, du!* vs *Hallo?*).

Reveal: Lena shares the owner's surname. Micro-text after: spell the
surname back, letters shuffled (`recall`).

### HUB — "Three leads at the Pension" (any order, each grants a clue)

Teach-before-ask: each lead is self-contained, the words it needs land in
a `clue` beat inside that lead. One micro-text per lead.

#### Lead A (heard) — "In Omas Küche" — 8 — **family, countries & languages, kitchen nouns + articles, quantities, plural, -in, vowel-change verbs**

Maya books a breakfast at the Pension as a guest. The grandmother sits
down uninvited, interrogates her, then decides a guest who asks this many
questions can work: *"Sie können helfen."* They make **Buletten mit
Kartoffelsalat** — Oma cooks, Maya fetches, the learner does the German.

Breakfast room:

1. `dialogue` — Oma: *"Und Sie sind…?"* → Maya `build` a full polite
   intro in the *right order*: *Ich heiße Maya. Ich komme aus den USA. Ich
   wohne in Berlin.* (critical)
2. `hotspot` — Oma nods at the photo wall; tap the plaque *seit 1926*
   (plants the year for the finale).
3. Oma about herself (voiced, 4 short lines; Maya gives the English hook
   before each): *"Ich komme aus {omaCountry}. Ich spreche Deutsch und
   {language}. Ich habe eine Tochter und eine Enkelin. Die Enkelin heißt
   Lena."* → `orderedPick` **case board**: pin Oma → Tochter → Enkelin =
   Lena, decoys *Sohn, Schwester, Tante*.
4. Berlinerisch: Maya mentions Böhm's *ick / ooch / dit*; Oma: *"Der
   Mann ist Berliner. Ich bin Berlinerin."* → `select`: which word is the
   woman? (-in rule; Berlin fact: the dialect, English first).

The kitchen (new scene, ingredients laid out, props blank, labels overlaid):

5. `clue` — Oma lays out the ingredients with their articles: die Zwiebel,
   das Ei / die Eier, die Schrippe, das Hackfleisch, der Senf, die
   Petersilie, die Pfanne. Berlin facts: **die Schrippe**, **die Bulette**.
6. `hotspot` × 4 rounds, labels gone — Oma's voiced requests: *"Geben Sie
   mir die Zwiebel."* … *das Ei* … *die Schrippe* … *die Pfanne*. Tap the
   right thing; round 4 critical. Wrong: *"Nein. DIE Zwiebel."*, the item
   wobbles. Trains article + noun by ear and the polite request.
7. `orderedPick` tiles — Oma dictates the recipe in one breath, steps and
   amounts: *"Erst fünfhundert Gramm Hackfleisch, dann zwei Eier, dann
   eine Zwiebel, dann zwei Schrippen — in die Pfanne."* Build the four
   step lines in order (number words, Gramm, plurals, erst/dann; decoys
   *Ei, Schrippe, fünfzig*). The "Mengen" half of `quest_a1_1_zahlen_gross`.
8. The trap, while the Buletten fry: *"Lena hat einen Freund. Er malt."*
   → `select` critical: *ein Freund* = boyfriend (Familie, "Freund or
   Freundin"). Maya: *"He MALT. Paint roller. Oh. OH."*
9. `banter` — Oma tastes: *"Zu viel Salz?"* then *"Sprechen Sie Deutsch?"*
   — every answer gets her dry reply; *"Ein bisschen."* earns *"Das sehen
   wir."* Handing over cold Buletten for the road: *"Lena fährt heute nach
   Potsdam, Jonas nimmt den Schlüssel. Er spricht mit Herrn Böhm."*

Micro-text: who has the key? (nimmt → Jonas; vowel change by meaning).
Clue A: **Lena is the granddaughter; Jonas is her boyfriend; Jonas has
the key.**

#### Lead B (written) — "Der Schlüssel" — 3 — **Wo-prepositions, numbers 20–100**

Herr Böhm (he does odd jobs for the Pension too — *"Ick mach hier ooch
die Heizung"*) has left Jonas a note in the Hinterhof. Berlin fact: **der
Hinterhof**.

1. `clue` — unter, auf, im / in der, vor, neben, die Matte, der
   Blumentopf, das Fensterbrett, die Tür, grün.
2. `inlineCloze` on Böhm's note (≥6 blanks, tiles): *Jonas — der
   Schlüssel ist {keyPlace}. Die Tür ist grün. Die Nummer ist
   {roomNumber}. Der Code für das Tor ist …* — restore the prepositions
   and contractions.
3. `hotspot`, critical — tap where the key is in the courtyard (hidden
   zone; the three `{keyPlace}` variants are three spots in one picture).
4. `orderedPick` keypad, critical — Böhm reads the gate code in words:
   *"dreiundvierzig – achtundsiebzig"* → dial 4378 (the flipped
   unit-and-ten order is the whole test).

Micro-text: the gate code (`recall`). Clue B: **where the key is, the
green door, the code.**

#### Lead C (re-order) — "Die Kisten" — 3 — **compounds, regular verbs, word order**

Jonas's delivery crates in the Pension's hallway, labels torn in half.

1. `clue` — the compound rule ("the last word rules"), das Mikrofon, der
   Kopfhörer, der Schreibtisch, die Stehlampe, die Wandfarbe, das Regal.
2. `orderedPick` tiles — **reassemble torn compounds** (≥6): *Mikro+fon,
   Kopf+hörer, Schreib+tisch, Steh+lampe, Wand+farbe, Bücher+regal*,
   wrong halves as decoys; each pair shows the last word's article.
3. `select`, critical — what is this room going to be: *ein Studio / eine
   Küche / ein Bad* — the deduction, not a translation.
4. `orderedPick` tiles — Jonas and Lena's scrambled packing chat: sort six
   messages by verb endings and time words (*Ich kaufe die Farbe. Dann
   male ich. Du bringst das Mikrofon? …*).

Micro-text: the paint colour (`recall`). Clue C: **it's a studio.**

### Ch.6 — Finale "Zimmer {roomNumber}, nachts" — 8 — unlocked by A+B+C

Torch noir for the courtyard, lamp cone for the room. Everything from
memory first, then live talk.

1. `hotspot` — the key, in the dark (the pooled spot, not re-shown; glows
   after two misses).
2. `hotspot` — the green door among four, by torchlight (colours).
3. `recall`, critical — which door upstairs: the pooled room number.
4. **Caught.** Light on. Oma in a dressing gown: *"Und Sie sind… ach,
   Maya. Was machen Sie hier?"* → `dialogue`, all learner turns critical:
   - `build`: *Ich suche Jonas und Lena.*
   - Oma: *"Warum?"* → `choose` an honest answer with haben (*Ich habe
     eine Frage. / Ich bin die Polizei. / Ich bin müde.*).
   - Oma: *"Wie alt ist das Haus?"* → tiles: *hundert Jahre* /
     *seit neunzehnhundertsechsundzwanzig* (numbers over 100, years).
   - Oma: *"Und wer bin ich?"* → `select`: *Sie sind Lenas Oma. / Du bist
     Lena. / Sie sind die Chefin von Jonas.*
   - Oma, finally smiling, opens the door herself.
5. `narrative` — the reveal: the room half {paintColour}, microphone,
   headphones, the banner overlay *100 Jahre Pension Sonnenschein*, and a
   card in Jonas's handwriting → `inlineCloze` (tiles, the last blanks):
   *Für Maya. Das ist dein Studio. Die Oma hat 100 Jahre Berlin im Kopf.
   Du fragst, sie erzählt — auf Deutsch. Bald? JETZT.*
6. `narrative` — Jonas and Lena arrive from the Späti with cake and cold
   Buletten (Berlin fact: **der Späti**). Jonas moved in with his
   girlfriend; the studio is for the Pension's centenary podcast; nobody
   told Maya because she's a *podcaster*. Lena: *"Jetzt sprichst du
   Deutsch, Maya."* Maya: *"Ein bisschen."* Oma: *"Das sehen wir."*
7. Podcast outro (voiced), then the cliffhanger: the 1926 photo, one face
   circled. *"Wer ist das?"*

### Cut from the first draft (keep for a Director's Cut / future episodes)

Postcode redial from memory · Enkelin/Chefin select on the phone · two
kitchen rounds (Senf, Petersilie) · separate steps-ordering beat · the
green-door tap in Lead B · crate counting (*sieben Kisten*) · the map walk
and gate-code redial in the finale · two micro-texts.

## Berlin culture (English first, then the German word)

Pinned podcast facts (the bible's 3–4):

1. **Die Schrippe** — Berlin's word for a bread roll; the rest of Germany
   says Brötchen (kitchen).
2. **Die Bulette** — the Berlin meatball, from French *boulette*, brought
   by Huguenot refugees in the 1700s; eaten cold at the Späti counter
   (kitchen).
3. **Der Hinterhof** — Berlin tenements were built around chains of inner
   courtyards; the Hackesche Höfe link eight of them (courtyard lead).
4. **Der Späti** — the late-night corner shop with its own Berlin word
   (finale, Jonas and Lena's cake — and cold Buletten).

Texture, not pinned: **Berlinerisch** (Böhm's *ick / ooch / dit / wat*,
Oma's *Berliner / Berlinerin*), Berlin postcodes all starting with 1
(passing remark on the label), the family-run Altbau Pension, Oma
insisting on *Sie* from a stranger, Kaffee und Kuchen when Jonas and Lena
arrive, and the 1926 photograph pointing at Weimar-era Berlin for
Episode 3.

## What it tests (coverage map)

| A1.1 quest | Where it works |
|---|---|
| Zahlen 0–10 / 11–20 | room number, crate count, letters' count |
| Zahlen 20–100 | gate code (flipped order) |
| Zahlen ab 100 | postcode, invoice total, *seit 1926*, *hundert Jahre* |
| Hören/Sprechen: Zahlen & Preise | courier's total |
| Farben | invoice, the green door, the half-painted room |
| Artikel / Plural / Wortschatz | invoice cloze, compounds' articles, *sieben Kisten* |
| Personalpronomen, du/Sie | every line to Oma and the receptionist |
| sein & haben | Oma's family lines, finale answers |
| W-Fragen | *Warum? Wer? Wie alt? Wo ist…?* |
| Regelmäßige Verben | the scrambled packing chat |
| Vokalwechsel | *fährt / nimmt / spricht* → who has the key |
| Vorstellung / Das bin ich / Gespräch | breakfast intro in the right order |
| Familie & Menschen | Oma → Tochter → Enkelin; Freund = boyfriend |
| Zahlen ab 100 (Mengen) + Plural | *fünfhundert Gramm Hackfleisch, zwei Eier, zwei Schrippen* |
| Wortschatz (articles by ear) | the six "Geben Sie mir…" kitchen rounds |
| Länder, Sprachen | Oma's origin and languages |
| Wo? Ortsangaben | Böhm's note, the key hotspot |
| Wortbildung | *Enkelin / Chefin*, the torn compounds |
| Alphabet & Buchstabieren | Ellison and {familyName} on the phone |
| Diktat / Steckbrief | invoice and note restoration (cloze, no typing) |

Typing: none required (tiles, keypads, taps, letter tiles) — the Diktat
quests are covered by tile cloze so the episode stays phone-friendly.

## Continuity hooks

- Pays off: the terracotta coat (ep0→ep1), *Bald* (ep1), Böhm as the
  neighbourhood fixer (ep0, ep1), the Episode 1 room number.
- Plants: the 1926 photograph (ep3), the Pension studio as Maya's new base
  (future episodes can start there), Oma as recurring cast.

## Registry

`STORY_EPISODES` entry: level `A1.1`, `after: 'quest_a1_1_wortschatz'`
(the last quiz of the level; the episode is the level's finale), href
`/story/ep2-secret-room`, cover `story/ep2_courtyard_night`.

## Image list (budget estimate ≈ 16 scenes + 1 ref sheet ≈ €0.70)

ep2_kitchen_parcel · ep2_label (prop, blank) · ep2_invoice (prop, blank) ·
ep2_lobby_phone · ep2_breakfast_oma · ep2_kitchen_table (prop scene,
blank labels) · ep2_kitchen_frying · ep2_courtyard_day ·
ep2_courtyard_note (prop) · ep2_hallway_crates · ep2_crate_labels (prop) ·
ep2_courtyard_night (cover, torch noir) · ep2_green_doors ·
ep2_corridor_oma · ep2_studio_reveal · ep2_card (prop) · ep2_cake_trio ·
ep2_photo_1926 (prop, circled face) · oma_ref_neutral.

## Engine and tool changes made for this episode

- `HotspotBeat.svelte`: a hotspot may carry `audio` (+ `speaker`,
  `transcript`): the clip plays as the beat opens and a chip replays it —
  Oma's kitchen orders ("Geben Sie mir die Zwiebel") are answered by tapping.
- Gate test: a hotspot `answer` may be a pool (`{pool:keySpot}`); every
  variant must be a spot id.
- `tool/review-story.mjs`: an episode may declare `assumes` (words the
  level's exercises already taught) — a finale leans on the whole level, and
  the teach-before-ask check now seeds from it.
- `tool/gen-story-audio.mjs`: voices `oma` (Gacrux, shared with the number
  task's grandmother) and `kurier` (Rasalgethi), directions for both,
  `ep2_podcast_intro/outro` → Maya. `tool/gen-voice-refs.mjs`: Oma auditions
  (Gacrux chosen, Despina, Vindemiatrix) and the courier.
- `tool/gen-story-sfx.mjs`: `sizzle` (the pan) and `keys` (key found).
- Dev bible: Episode 2 nav card; cast entries for Oma and the courier.

## Review log

**Round 2 (2026-10-08, with pictures and audio).** User feedback: the
first part had too much easy interaction and too little German, and Maya
should narrate more and use the German she has learned. Applied: the
courier is a three-turn exchange (build "Nein, ich bin Maya. Jonas wohnt
hier.", answer "Ist er da?" with "nicht da", sign); the label is rebuilt
in German address order instead of tapped; a Lieferschein is read and
answered in German ("Wer ist der Absender?" by tapping the sender line,
"Was ist im Paket?" among German options); the invoice cloze gained
kosten/kostet; the recruit banter is gone; three new Maya panels (i2, i5,
p7) where she narrates with learned German. Scorecard: 25.6 min, 55 beats,
31 exercises, 6 critical, 44 % passive, 13 % plain pick-one, one warning
left (two quiet beats at the start of the courtyard lead). Playtest with
real assets: 55/55, no errors; screenshots confirmed the label overlays;
the plaque label was widened so "seit 1926" fits on a phone. Known
length: ~60 % over ep1 — chapters save, so it plays in two sittings; trim
the kitchen or the crates if it has to be one.

**Round 1 (2026-10-08, script only — no pictures, no playtest yet).**
Scorecard after the first tightening pass (seven narration panels folded
into neighbours, a banter added in the finale, `assumes` declared):
23.3 min estimated (ep1: 15.4, ep0: 17.0), 51 beats, 29 exercises, 7
critical, 43 % passive (ep1: 55 %), 10 % plain pick-one (ep1: 40 %),
46 notebook words, mechanics narrative×16 dialogue×5 banter×3 clue×6
hotspot×8 orderedPick×6 inlineCloze×3 listening×1 select×2 recall×1.
Remaining flags: three passive beats in a row at `ch4/s2` and `ch6/f13`
(the ending), third hotspot in a row in the kitchen (intended: four orders).
Two reviewer agents (player/game designer, DaF teacher) read the JSON.
Applied: the gate code now pays off (a from-memory keypad opens the
finale, Maya puts the key BACK in Lead B); the room number is no longer in
the chapter title or the hub button; the receptionist's bubble only
spells the surname, so the critical pick is a real letters→name catch; the
invoice adds up (pooled unit price, `die Dose`), the price voicemail is
the paint shop, not the courier; the 1926 plaque is a hotspot in the
breakfast room before the midnight maths; the family-tree sort and the
second kitchen round were cut, the recipe matches the orders (ein Ei, eine
alte Schrippe) with the plurals as decoys; the Freund trap is planted on
the kitchen card; Böhm's note lost the dative blank and the ambiguous
`auf/unter/vor`; the chat strips carry times and end "Ich sage nichts";
the compound snap uses real compounds (Stehlampe, Kopfhörer,
Schreibtisch); Oma's timeline is "Berlinerin seit 1961" from Poland /
Turkey / Italy with English pools for the gloss and an ASCII pool for the
audio key; "Das sehen wir" → "Das werden wir sehen"; Böhm gets a little
Berlinerisch in the frame of his code; the ending hook is a hotspot (tap
the circled face). Not applied: wrong-answer replies on `select` beats (the
player has none — a possible engine addition), cutting the price listening
(it is the only Hören: Zahlen & Preise beat), the f6 `zehn` decoy (kept:
the aside gives the maths). After the pass: 23.2 min estimated, 51 beats,
30 exercises, 9 critical (incl. dialogue turns), 41 % passive, 10 % plain
pick-one, 48 notebook words. Playtest bot (pictures and clips missing):
51/51 beats played, no page errors, no stuck screens, 97 screenshots in
`assets/images/raw/playtest/ep2_secret_room/`.

## Audio takes

Acted takes (Gemini-TTS, directed) exist for 45 clips. The Cloud route
(`npm run story-audio`) needs the "Agent Platform API" enabled on the
Google project, and the Gemini-API route hit its daily quota at clip 46.
These 19 are Chirp 3 HD reads (correct, clear, un-acted) and can be
re-recorded as acted takes with
`npm run story-audio -- ep2_secret_room --gemini-api --force` once the quota
resets (delete only these files first to keep the 45 acted ones):
`ep2_oma_wiealt`, `ep2_oma_werbinich`, `ep2_oma_kommen`, `ep2_oma_freund`,
`ep2_narr_f7_0..2`, `ep2_narr_f9`, `ep2_narr_f10`, `ep2_podcast_outro_0..2`,
`ep2_narr_i2`, `ep2_narr_i5`, `ep2_narr_p7_0..2`, `ep2_kurier_wer`,
`ep2_kurier_da`, `ep2_kurier_unterschreiben`. Nobody has listened to the
spelled-letter clips (`ep2_rez_lena_*`, `ep2_rez_danke`) or the gate-code
clips yet — do that on /dev/story-bible before shipping.

## Shipping checklist (in order)

1. Restore `GOOGLE_TTS_KEY` in `.env` (the Gemini key is back).
2. DONE 2026-10-08 — `npm run images -- --story oma_ref_neutral kurier_ref_neutral ep2_kitchen_parcel ep2_label ep2_invoice ep2_breakfast_oma ep2_photo_wall ep2_kitchen_table ep2_kitchen_frying ep2_courtyard_note ep2_courtyard_day ep2_hallway_crates ep2_courtyard_night ep2_green_doors ep2_corridor_oma ep2_studio_reveal ep2_card ep2_cake_trio ep2_photo_1926`
   (19 pictures ≈ €0.75). Hotspot boxes are set from the PNGs (label rows +
   postcode box; kitchen table: onion, eggs, rolls, parsley, mustard, pan —
   that is the picture's order; courtyard day/night: pot, mat, sill; four
   doors; plaque; circled face). Re-check them in the playtest screenshots.
3. `npm run voices -- oma kurier` (listen on /dev/story-bible, recast by
   ear if Gacrux reads wrong for her), then
   `npm run story-audio -- ep2_secret_room` and `npm run audio` (notebook
   words). Check the spelled-letters clips (`ep2_rez_lena_*`,
   `ep2_rez_danke`) say letter names, and the gate-code clips flip the
   digits correctly.
4. `npx vitest run src/routes/story` → green; `npm run dev` +
   `node tool/playtest-story.mjs ep2_secret_room`; two reviewer passes with
   screenshots (rounds 2 and 3); log here.
