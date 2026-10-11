# Content review — Certification German A1–C2 (`de_cert_a1`)

Read 2026-10-11 against the shipped bundle `assets/content/courses/de_cert_a1.json`:
391 quizzes across twelve sub-levels, plus the syllabus, the shared noun and verb
collections, the vocabulary decks and the picture hunts.

Every finding below was checked against the data before it was written. Where the
earlier review (`docs/content_review_2026-09-27.md`) was right and the content has
since been fixed, that is recorded too, because most of it has been.

---

## 1. The headline

The course is in far better shape than the September review describes. Of the
roughly fifteen engine defects and eleven course-wide problems that review listed,
**all of the mechanically checkable ones are fixed**. Six of the twelve sub-levels
(A2.1, A2.2, B1.1, B1.2, B2.1, B2.2) now contain no incorrect German, no wrong
answer key and no false grammar claim at all.

What remains divides into three kinds:

1. A small number of **real content errors**, concentrated in A1.1, A1.2 and the
   generated vocabulary decks.
2. A **generated-deck bug** that produces nonsense flashcards at four levels.
3. **Structural gaps** — things the course does not do at all, the largest being
   that a learner never writes free German anywhere in twelve levels.

---

## 2. Confirmed fixed since September

- Syllabus `exam` is an array in all twelve modules; it used to be a string, which
  rendered one bullet per character.
- No Help Memory table stores rows as bare arrays.
- Every reading and listening quiz has a `passageTitle`; two used to render
  "undefined".
- No tip prints an internal contrastive-spine code to learners.
- Multi-gap sentences render one input per gap, so 442 two-gap sentences are
  answerable.
- `strictDiacritics` is set on the 21 quizzes whose target is the umlaut itself.
- Multiple-choice keys spread 106/103/102/75 across the four indices; no quiz keys
  a single index throughout, and options are shuffled at render.
- Every fill-in, dictation and repeat-after-me pool meets the ten-item minimum.
- Every multiple-choice question has an explanation, every quiz has a hook and at
  least one check question, and every drill sentence has an English translation.
- All 246 syllabus structures are covered; there are no orphan `covers` ids.
- House rules hold: no exam brand names, no level prefixes in titles, no part
  numbers, no commercial textbook names, no author notes visible to learners. The
  poetry quiz now uses Ringelnatz (d. 1934) and Morgenstern (d. 1914), both
  genuinely out of copyright.
- Passage length now scales: about 65 words at A1.1, 130 at A2, 150 to 210 at B1,
  255 to 335 at B2, 360 to 410 at C1, 400 to 470 at C2.

---

## 3. Wrong — must fix

### 3.1 The vocabulary decks are generated, and the generator has two bugs

The decks are built by `tool/build-vocabulary.mjs` from each level's quizzes. Two
faults in it put wrong cards in front of learners. The source quizzes are correct;
only the generated cards are wrong.

**A phrase containing a slash is split into two cards.** The split rule exists for
entries like "der Großvater / Opa". Applied to a phrase it produces nonsense: the
entry "mit dessen / deren Hilfe = with whose help" becomes two cards, "mit dessen"
and "deren Hilfe", each glossed "with whose help".

**Grid subjects are harvested as if they were German words.** Some grids use the
subject column as an English prompt and put the German in the category value. The
builder reads the prompt as German, so the C2.2 deck teaches "to deny outright =
deny" and "to bear responsibility = bear", and the A1.2 deck teaches "home = home
(direction)" and "at home = at home (place)".

A related case: in the A1.2 time grid the subject is a bare noun and the English
gloss carries the preposition the exercise is about, so the deck teaches "der Abend
= in the evening", "das Essen = after the meal", "der Kurs = before the course",
"8 Uhr = at eight", "eine Woche = in a week's time" and "zwei Wochen = for two
weeks". None of those glosses is what the German word means.

### 3.2 Individual wrong cards and keys

- `quest_a2_1_wortschatz` — "beim Arzt = at", a truncated gloss. It should read
  "at the doctor's". And "Cafe" is missing its accent: the German is *das Café*.
- `quest_c1_2_wortschatz` — "der weiterführender Nebensatz" has the wrong adjective
  ending; it is *der weiterführende Nebensatz*.
- `quest_c1_2_wortschatz` — the five ambiguous prefix verbs each carry only one of
  their two meanings (*umfahren*, *wiederholen*, *durchschauen*, *unterstellen*,
  *umschreiben*), although the whole point of the `praefixe` quiz is that each has
  two.
- `quest_a1_1_farben` — the tip says *rosa, lila, orange* never change at all.
  False for *orange*, which standard German inflects (ein oranges T-Shirt).
- `quest_a1_1_lesen_dasbinich` — "Ich bin Studentin und **lerne** an der
  Universität." *lernen* without an object does not mean "to study at university";
  the translation already says "study", so the German should be *studiere*.
- `quest_a1_1_lesen_dasbinich` — the exam note promises true/false statements; the
  quiz has five multiple-choice questions and no true/false.
- `quest_a1_1_wo_praepositionen` — in the "Woher?" category the value for *das
  Bett* is an em dash, an author placeholder that surfaces in the reference table.
- `quest_a1_2_pronomen_akk` — the intro says five of the nine pronouns change and
  "three stay". Five plus three is eight. Four stay: *sie* (her), *sie* (them),
  *es* and *Sie*.
- `quest_a1_2_hoeflich` — the quiz sets `strictDiacritics` and its intro says the
  umlaut is what makes these polite (*hätte* not *hatte*, *könnten* not *konnten*),
  yet six items also accept the plain indicative *Können Sie* or *Kann ich*, and
  one accepts *Können* against a cue that reads "(could)". The one feature the
  exercise exists to drill cannot be failed.
- `quest_c1_1_bildung` — s13 cues "peer review" and accepts "Peer-Review", so
  typing the hint passes. s12 does the same with "correlation" and "Korrelation".
- `quest_c1_1_suchbild_theater` — a tip runs two thoughts into one sentence and
  reads as if *Trommel* ended in -e.

### 3.3 Metadata that does not match the items

Five quizzes use a `categoryLabel` that is never declared in `categories`
(`quest_a1_1_wo_praepositionen`, `quest_a1_1_wortbildung`, `quest_a1_1_alphabet`,
`quest_a1_2_datum`, `quest_a1_2_koerper`), and the same five use subject keys
(k0–k5, w0–w8, o0–o5, p0–p7) that are not declared either.

**Investigated and left alone.** Neither costs the learner anything. The weak-spot
worksheet looks its category up by the label string, not by the declaration, and
every one of these items carries its own answer, so the worksheet works. An
undeclared subject key merely suppresses the label above the sentence, and these
sentences are self-contained. Declaring the categories with no values would add a
column of blank cells to the Help Memory table, which is worse than leaving it out.
Three quizzes attach one subject key to two items
(`quest_a2_1_indefinitpronomen`, `quest_a2_2_genitiv_s_datum`,
`quest_a2_2_schreiben_email`); the table is built from the subject list rather than
the sentences, so the effect is two items sharing a label, which is cosmetic.

> Also checked and **not** a defect: the apparently unused categories in
> `quest_a1_2_uhrzeit` ("offiziell") and `quest_a1_2_perfekt_intro` ("haben oder
> sein?") are fully populated reference columns. No item drills them, but they are
> deliberate table data.

### 3.4 One sentence wrong in 24 places

All 24 picture hunts share an intro that illustrates the harder prompt with
"Wo ist ___ Brille?". Only two of the 24 rooms contain a Brille.

### 3.5 Plurals marked as non-existent

The shared noun library uses two different notations: `-` means the plural does not
change (*Fenster*, *Lehrer*), and the em dash means the noun **has no plural**, which
is how `pluralForm` reads it. 216 of the 759 shared nouns carry the em dash. For the
uncountables among them (*Geld*, *Milch*, *Fieber*, *Geduld*, *Vernunft*) that is
right, and for the plural-only *Eltern* and *Leute* it is the closest the notation
gets.

But twenty nouns that do have an ordinary plural were marked as having none, so the
deck taught that they have none:

*Opa, Oma, Student, Schüler, Morgen, Nacht, Abend, Chefin, Urlaub, Balkon,
Verspätung, Verantwortung, Verbrauch, Entwicklung, Vielfalt, Herausforderung,
Stelle, Konjunktur, Rendite, Verordnung.*

---

## 4. Could be improved

- **Bracketed cues give the answer away.** The pattern recurs:
  `quest_b2_2_konzessiv` and `quest_b2_2_adversativ` cue the relation in English on
  every item; `quest_b1_2_konnektoren_zweiteilig` names the English pair;
  `quest_b2_1_dass_infinitiv` marks three items "can it become zu?", which answers
  the question; `quest_a1_2_wann_praepositionen` prints "(zwei Wochen)" above a gap
  whose answer is *Zwei Wochen*. Removing the cue from a third of the items in each
  would turn a lookup into a choice.
- **Vocabulary quizzes whose English cue is the answer's translation.**
  `quest_b1_1_arbeit`, `quest_c1_2_kultur` and `quest_a1_2_koerper` all test recall
  of a word the cue has just named in English. That is the deck's job. A German
  definition, or a collocation gap, would test more.
- **The correct option is the uniquely longest in 170 of 386 multiple-choice items,
  44 per cent.** Shuffling does not close that guessing route; length-matching the
  distractors would.
- **Long single-topic blocks.** C1.1 runs six consecutive exercises on nominal
  style; B2.1 runs three passive quizzes plus a passive strand; B1.1 runs four on
  the adjective table. Each block is well taught, but it is a long stretch.
- **Cross-level duplicate stems.** "Ich gebe ____." is shared by
  `quest_a2_1_dativ_akkusativ` and `quest_b2_1_mittelfeld`; "Er fährt ____." by
  `quest_a2_2_tekamolo` and the same B2.1 quiz.
- **`quest_a2_2_genitiv_s_datum` bundles two unrelated topics**, so each category's
  values are half empty and the reference table shows a blank for every item
  belonging to the other half. Two quizzes would be cleaner.
- **`quest_a2_2_kleidung` category values carry articles** ("die Hose") but every
  gap follows an article already in the sentence, so the table shows a form the
  drill rejects.
- **Teaching points introduced and never drilled**: *mögen* and *mochte* in
  `quest_a2_1_modal_praeteritum`; six of the fifteen body parts declared in
  `quest_a1_2_koerper`; the twelve Präteritum verbs of A2.2, which do not reappear
  until B1.2.
- **236 picture-hunt nouns appear in more than one room.** Natural for rooms, but
  the C-level rooms are re-drilling A1 furniture.
- **804 of about 3,370 vocabulary cards repeat a word from a lower level's deck.**
  Deliberate spaced repetition or generator noise — it needs a decision either way.
- **Decks ship largely without pictures**: 149 of 239 cards unpictured at A1.1,
  rising to 346 of 365 at C2.2.
- **C1 and C2 passages sit below exam norms.** C1 runs 360 to 410 words against a
  400 to 600 norm, C2 400 to 470 against 500 to 700, though the shape is now right.

---

## 5. Missing — should be added

### 5.1 The course never asks the learner to write

There is no `writing` quiz type anywhere in the content model. The nine quizzes
with "schreiben" in the name are fill-in-the-gap drills. A learner completes twelve
sub-levels from A1.1 to C2.2 without ever producing a free written German sentence,
though the certification target requires writing from A2 upward. This is the single
largest gap in the course.

### 5.2 Smaller gaps

- **C2.2 is the only sub-level with no dictation quiz.** Every other level has one.
- **Eight speaking exercises have no duration or pass score** and fall back to
  manifest defaults: the four at A1.1 and A1.2 and the four at C2.1 and C2.2, which
  is to say both ends of the course.
- **Five listening quizzes have no `voiceGender`**, so multi-speaker passages are
  read by one voice: the B1.1 interview and survey, the B1.2 podcast, and the C2.2
  specialist lecture and capstone.
- **115 of 246 syllabus structures are covered by exactly one quiz.** Nearly half
  the grammar inventory gets a single exposure and no recycling.
- **A1.1 syllabus items that no quiz delivers**: *möchte*, named under
  `a1.sein-haben`; *kein*, named under `a1.articles-nom`; ordinal numbers and *die
  Million*, named under `a1.numbers`; and the compass directions, named under
  `a1.countries`.
- **A1.1 deck gaps**: no language card (Deutsch, Englisch) and no nationality card
  (Deutscher, Französin) exists although a whole quiz drills them; *China* and
  *Japan* are quiz subjects with no card; *die Familie* is drilled but is in neither
  the vocab list nor the deck.
- **The A1.2 deck contains no body vocabulary at all** — not Kopf, Arm, Bein,
  Rücken, Bauch, Zahn, Auge, Fuß, Hals, Ohr, Knie, Nase, Finger, Fieber or
  Schmerzen — although `quest_a1_2_koerper` teaches them and the deck claims to hold
  every word the module's exercises use.
- **Numbers above one hundred** are used at A1.2 (650 Euro, the year 1995, phone
  numbers) but taught nowhere.

---

## 6. Per-level summary

| Level | Quizzes | Clean | Wrong | Note |
|---|---|---|---|---|
| A1.1 | 29 | 12 | 10 | The weakest module: most of the course's real errors are here |
| A1.2 | 35 | 21 | 6 | Deck bugs, the politeness quiz, metadata |
| A2.1 | 27 | 23 | 3 | Two bad cards, one duplicate subject key |
| A2.2 | 34 | 29 | 3 | Metadata only |
| B1.1 | 32 | 29 | 0 | No incorrect German |
| B1.2 | 34 | 31 | 0 | No incorrect German |
| B2.1 | 36 | 33 | 0 | Most thoroughly rebuilt level |
| B2.2 | 37 | 34 | 0 | No incorrect German |
| C1.1 | 33 | 29 | 3 | Two items accept their own hint, one run-on tip |
| C1.2 | 33 | 30 | 2 | Deck fragments and half-glossed prefix verbs |
| C2.1 | 31 | 31 | 0 | Clean on every check; September's complaints all fixed |
| C2.2 | 30 | 28 | 2 | Two reversed deck cards from the generator bug |

---

## 7. What was fixed on 2026-10-11

All of section 3 except the two items investigated and deliberately left alone.
Full test suite green (536 tests), `svelte-check` clean, exam-framing check clean.

### Six bugs in the deck generator (`tool/build-vocabulary.mjs`)

The decks are generated, so each of these was putting wrong cards in front of
learners at several levels at once. Three were found only because rebuilding the
decks exposed them.

1. **English-prompted grids were harvested as German vocabulary.** A grid whose
   subject column is an English prompt now has its subjects skipped, by a per-row
   test and by a whole-grid test for when half or more of the rows look English.
2. **A bare noun glossed with a preposition** ("der Abend = in the evening") is
   skipped, unless the German label brings its own preposition, so "zu Hause = at
   home" survives.
3. **A shared-tail gloss was split down the middle**, so "beim Arzt / zum Arzt =
   at / to the doctor's" produced "beim Arzt = at". Fixed in the authoring source
   for all five entries that had it, rather than by guessing in the generator.
4. **The stress-mark stripper ate the acute in French loans**, turning *Café* into
   *Cafe*. It now strips an acute only inside a word, where German stress marks
   sit, never on the final letter.
5. **The generator stamped the level into the deck title** ("A1.1 · Wortschatz"),
   against the house rule the content test enforces. It had not been noticed
   because nobody had rebuilt a deck since the rule landed.
6. **A rebuild discarded every card's picture.** Pictures are attached after the
   deck is built, so all twelve levels lost their "words in pictures" workbook
   page on the first rebuild. The generator now carries them across.

Twelve bad cards are gone and nothing else changed: the eight A1.2 cards, the two
C1.2 fragments and the two reversed C2.2 cards.

### Content

- "mit dessen / deren Hilfe" added to the hand-decision drop list, since it is one
  expression and the slash splitter cannot know that.
- `quest_a2_1_woher_wo_wohin`, `quest_b1_2_technik`,
  `quest_b2_2_relativ_dessen_deren`, `quest_c1_1_adverbialsaetze` and
  `quest_c1_2_kohaesion`: the five shared-tail glosses rewritten so each part
  stands alone.
- Two wrong adjective endings: *der weiterführende Nebensatz* and *das historische
  Präsens*.
- `quest_a1_1_farben`: the false claim that *orange* never inflects removed from
  the tip title, the tip text and the check explanation.
- `quest_a1_1_lesen_dasbinich`: *lerne* → *studiere* in the passage, and the exam
  note now says multiple-choice, which is what the quiz has.
- `quest_a1_1_wo_praepositionen`: the em-dash placeholder cell filled with *aus dem
  Bett*.
- `quest_a1_2_pronomen_akk`: "three stay" → "four stay" in the intro and the tip
  title, so the arithmetic works.
- `quest_a1_2_hoeflich`: seven items no longer accept the plain indicative, so the
  Konjunktiv II the quiz exists to drill can actually be required.
- `quest_c1_1_bildung`: the two cues that named the loanword the item also accepts
  now describe the meaning instead, so typing the hint no longer passes. Both
  loanwords stay accepted, because both are real academic German.
- `quest_c1_1_suchbild_theater`: the run-on tip split in two.
- **All 24 picture hunts** now illustrate the hidden-article prompt with an object
  that is actually in that room, taken from the objects the intro already names.
  Verified: 24 of 24 name a real spot. Before, all 24 promised a Brille and only
  two rooms had one.
- Twenty plurals corrected in the shared noun library, and the generated dictionary
  index rebuilt so the new forms resolve to their lemma.

## 8. Still open

Nothing from section 3 except the two metadata items above. Section 4 and section 5
are untouched: they are judgement calls and new work rather than defects. The
largest is that the course never asks the learner to write.
