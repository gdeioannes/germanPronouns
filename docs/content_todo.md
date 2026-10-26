# Content to-do — Certification German A1–C2

Opened 2026-10-11 from `docs/content_review_2026-10-11.md`, after the defects in
that review's section 3 were fixed. Everything here was checked against the
shipped bundle on 2026-10-11. Nothing in this list is a wrong answer key or
incorrect German; those are already fixed.

Ordered by payoff for the effort, not by size.

---

## A. Silently broken, small, do first

### A1. Lift the speaking fields out of `session`

Eight speaking exercises author their duration and length in a `session` object,
and their feedback limits in a `report` object. Neither key exists in the
`SpeakingExercise` contract (`src/lib/content/types.ts`), so nothing reads them
and the exercise falls back to the manifest defaults.

`quest_c2_1_sprechen_kurzcheck` holds `{"durationMinutes":3,"minExchanges":6}`
inside `session` and `{"maxWords":150,"maxCorrections":3}` inside `report`. The
exercises that work, such as `quest_a2_1_sprechen_kurzcheck`, set
`durationMinutes`, `minExchanges` and `passScore` at the top level.

Affected, the two ends of the course:

| Level | Quiz |
|---|---|
| A1.1 | `quest_a1_1_sprechen_kurzcheck`, `quest_a1_1_sprechen_dialog` |
| A1.2 | `quest_a1_2_sprechen_kurzcheck`, `quest_a1_2_sprechen_dialog` |
| C2.1 | `quest_c2_1_sprechen_kurzcheck`, `quest_c2_1_sprechen_dialog` |
| C2.2 | `quest_c2_2_sprechen_kurzcheck`, `quest_c2_2_sprechen_dialog` |

To do: move `durationMinutes` and `minExchanges` to the top level, set a
`passScore` for each, and decide whether `report` and `priorityErrors` should
become real contract fields or be dropped. The `dialog` exercises have no
`passScore` anywhere, so that value has to be chosen, not recovered.

### A2. Set `voiceGender` on five listening passages — DONE 2026-10-25 (as `speakers`)

`voiceGender` was never read by anything. The four labelled dialogues now carry a
`speakers` map (label → male/female) and `npm run audio` records each line in a
voice of that gender; `quest_c2_2_hoeren_fachvortrag` is a one-speaker lecture
and was listed here by mistake. Re-recorded 2026-10-25.

Multi-speaker passages are currently read by one voice:
`quest_b1_1_hoeren_interview`, `quest_b1_1_hoeren_umfrage`,
`quest_b1_2_hoeren_podcast`, `quest_c2_2_hoeren_fachvortrag`,
`quest_c2_2_hoeren_capstone`. Re-record after setting it.

### A3. Give C2.2 a dictation — DONE 2026-10-25

`quest_c2_2_diktat_wissenschaft`, after the Wissenschaftssprache quiz, recorded.

Every sub-level has exactly one dictation except C2.2, which has none. The level
already has the hardest listening material to draw on.

---

## B. Writing — decided and built, 2026-10-11

### B1. The writing exercise exists

Decided: a real `writing` quiz type, character-bound and scaled by level, scored
like speaking, with the corrections joining the one personal-focus loop.

How it works. The learner writes the text in the app, inside a character bound.
The app renders a correction request that **carries that text**, which the learner
pastes into their own AI; it corrects what they actually wrote rather than setting
a fresh task. The reply is the same delimited report speaking already uses, so the
`SCORE=` line is parsed by the existing code and the `FIX:` lines are banked in
the existing fix log. The last step keeps those fixes on screen under "Work on
these next time", and later speaking and writing prompts replay one or two of them
as PERSONAL FOCUS, filtered to the level or below.

Character bounds, from `charBoundsFor`, overridable per quiz with `charMin` and
`charMax`:

| Band | Characters |
|---|---|
| A1 | 120–300 |
| A2 | 200–500 |
| B1 | 400–900 |
| B2 | 600–1300 |
| C1 | 900–1800 |
| C2 | 1200–2500 |

What was built:

- `WritingExercise` and `WritingQuiz` in the content contract, and `writing` in
  `QuizType`.
- `src/lib/domain/writing.ts`: the bounds, the length count that ignores padding,
  and the view of a writing exercise as a speaking one so a single prompt renderer
  builds both.
- `src/lib/components/quiz/WritingQuiz.svelte`: four steps, a live character
  counter, a draft that survives a reload, and the remembered-fixes panel.
- The prompt template gained a MY TEXT block and correction rules, and the
  sections that assume a spoken session (the trigger phrase, "how to speak to me",
  the last-question warning, pronunciation slips, weaving a focus point into the
  conversation) are now scoped to the spoken families. Verified: all 24 speaking
  prompts are byte-identical apart from two deliberate rewordings.
- Every seam a new quiz type touches: the router, the completion set
  (`writing_completed_quizzes`, which syncs on its suffix), the icon map, the deck
  and recommendation labels, the SEO labels, the dictionary sweep, the worksheet,
  and the image linker, where a writing task borrows its level's reading scene.
- 21 unit tests in `src/lib/domain/writing.test.ts`.

### B2. Every level has one — done

Twelve writing tasks, one per sub-level, each sitting after the exercise whose
grammar it puts to work:

| Level | Task | Covers |
|---|---|---|
| A1.1 | Das bin ich — a short self-introduction | `a1.sein-haben` |
| A1.2 | Eine kurze Nachricht — cancel and suggest another day | `a1.sentence-connectors` |
| A2.1 | Eine E-Mail an einen Freund — last weekend, in the Perfekt | `a2.past-narration` |
| A2.2 | Einladung & Plan — invite, with könnten and weil | `a2.email-redemittel` |
| B1.1 | Eine formelle E-Mail — a complaint | `b1.email-redemittel` |
| B1.2 | Etwas ist schiefgegangen — a story with a Plusquamperfekt | `b1.narration-skills` |
| B2.1 | Stellungnahme — a position, two arguments, one objection | `b2.stellungnahme-redemittel` |
| B2.2 | Beschwerde mit Zugeständnis — concede, then press | `b2.concessive` |
| C1.1 | Zusammenfassung — compress a report, stay invisible | `c1.nominalisation-advanced` |
| C1.2 | Ein Forumsbeitrag — hedge what you cannot prove | `c1.modal-supposition` |
| C2.1 | Zweimal dasselbe — the same news in two registers | `c2.register` |
| C2.2 | Erörterung — steelman the objection, then answer it | `c2.academic-language` |

A1 was included after all. 120 to 300 characters is a real text at that level:
six true sentences about yourself, or a message cancelling an evening.

Four of the twelve cover a syllabus tag that previously had only one quiz, so
they also chip at the single-exposure problem in C1 below.

## C. Authoring work

### C1. Recycle the grammar — the biggest retention risk (list made 2026-10-25)

The 112 single-exposure structures are listed in `docs/grammar_recycling_list.md`.

115 of the 246 syllabus structures are covered by exactly one quiz. Nearly half
the grammar inventory is taught once and never met again. 131 get two or more.

To do: list the 115, decide which deserve a second exposure, and add items to
existing quizzes at later levels rather than new quizzes where possible.

### C2. A1.1 does not deliver four things its own syllabus names — DONE 2026-10-25

möchte is a third column of sein & haben; kein/keine a third column of the
article grid; five ordinals sit in Zahlen ab 100; the compass is a fourth
column of Länder (Deutschland's cell is null, which the pool skips).

| Syllabus item | Names | State |
|---|---|---|
| `a1.sein-haben` | *möchte* | absent from the level |
| `a1.articles-nom` | *kein* | appears once, incidentally, in `quest_a1_1_wfragen`; never taught or drilled |
| `a1.numbers` | Ordinalzahlen, die Million | ordinals absent from all four number quizzes |
| `a1.countries` | Himmelsrichtungen | absent from the level |

A1.1 is also the module that held most of the course's real errors, so it is
worth one deliberate pass rather than four small ones.

### C3. Fill the two deck holes — DONE 2026-10-25

Both were missing `help.vocab` lists (the Körper and Länder grids prompt in
English, so the builder rightly ignores their subjects). Vocab added, decks
rebuilt: A1.1 302 cards, A1.2 239.

- **The A1.2 deck has no body vocabulary at all.** None of Kopf, Arm, Bein,
  Rücken, Bauch, Zahn, Auge, Fuß, Hals, Ohr, Knie, Nase, Finger or Fieber is in
  it, although `quest_a1_2_koerper` teaches them and the deck claims to hold
  every word the module uses.
- **The A1.1 deck has no language and no nationality card** (Deutsch, Englisch,
  Deutscher, Französin), although a whole quiz drills them. *China*, *Japan* and
  *die Familie* are also drilled without a card.

Both are deck-builder coverage, so check whether the words are missing from the
source quizzes' `vocab` lists first.

### C4. Picture the decks — B and C done 2026-10-26

Decided 2026-10-25: picture by level, not by quiz — the A sets as the pattern,
the same count for B, new sets for C; a word drawn once serves every deck that
holds it. 410 object pictures were added for B1–C2 (the office, surgery, workshop,
park, hotel lobby, building site, home, lab, hospital ward, theatre, airport,
carpentry, farm, antique shop and harbour), checked on contact sheets, twelve
redrawn for Gemini's faults (faces on objects, stray codes, English text).

| Level | Pictured | Cards |
|---|---|---|
| A1.1 | 114 | 302 |
| A1.2 | 85 | 239 |
| A2.1 | 54 | 248 |
| A2.2 | 82 | 321 |
| B1.1 | 108 | 286 |
| B1.2 | 98 | 321 |
| B2.1 | 91 | 383 |
| B2.2 | 84 | 304 |
| C1.1 | 88 | 274 |
| C1.2 | 94 | 263 |
| C2.1 | 86 | 299 |
| C2.2 | 90 | 364 |

Still open: the abstract vocabulary of B2–C2 (Mehrheit, Erkenntnis, Register …)
has no picture by design; the A levels' remaining unpictured nouns are the next
cheap pass.

---|---|---|
| A1.1 | 90 | 239 |
| A1.2 | 60 | 206 |
| A2.1 | 34 | 228 |
| A2.2 | 56 | 304 |
| B1.1 | 48 | 266 |
| B1.2 | 41 | 304 |
| B2.1 | 31 | 369 |
| B2.2 | 19 | 289 |
| C1.1 | 21 | 257 |
| C1.2 | 34 | 250 |
| C2.1 | 23 | 283 |
| C2.2 | 19 | 363 |

Lower levels first: a picture is worth most to a beginner.

---

## D. Judgement calls — decide, then act

### D1. Bracketed English cues that give the answer away

The cue turns a choice into a lookup. Recurring offenders:
`quest_b2_2_konzessiv` and `quest_b2_2_adversativ` (every item cues the relation),
`quest_b1_2_konnektoren_zweiteilig` (names the English pair),
`quest_b2_1_dass_infinitiv` (three items cue "can it become zu?", which answers
the question), `quest_a1_2_wann_praepositionen` (prints "(zwei Wochen)" above a
gap whose answer is *Zwei Wochen*).

Removing the cue from a third of the items in each is enough; removing all of
them would make some items unanswerable.

### D2. Length-matched distractors

The correct option is the uniquely longest in 170 of 386 multiple-choice items,
44 per cent. Shuffling does not close that guessing route. A pass that pads the
distractors would.

### D3. Decide what the repeated deck cards are for

804 of about 3,370 cards repeat a word from a lower level's deck. That is either
deliberate spaced repetition or deck-builder noise. If it is deliberate, say so
somewhere; if it is not, filter it.

### D4. Vocabulary quizzes whose English cue is the answer's translation

`quest_b1_1_arbeit`, `quest_c1_2_kultur` and `quest_a1_2_koerper` test recall of a
word the cue has just named in English, which is the deck's job. A German
definition, or a collocation gap such as *eine Stelle ____*, would test more.

### D5. Smaller items, each a single decision

- `quest_a2_2_genitiv_s_datum` bundles two unrelated topics, so each category's
  values are half empty and the reference table shows a blank for every item
  belonging to the other half. Two quizzes would be cleaner.
- `quest_a2_2_kleidung` category values carry articles ("die Hose") but every gap
  follows an article already in the sentence, so the table shows a form the drill
  rejects.
- Teaching points introduced and never drilled: *mögen* and *mochte* in
  `quest_a2_1_modal_praeteritum`; six of the fifteen body parts declared in
  `quest_a1_2_koerper`; the twelve Präteritum verbs of A2.2, which do not reappear
  until B1.2.
- Cross-level duplicate stems: "Ich gebe ____." in `quest_a2_1_dativ_akkusativ`
  and `quest_b2_1_mittelfeld`; "Er fährt ____." in `quest_a2_2_tekamolo` and the
  same B2.1 quiz.
- Long single-topic blocks: six consecutive nominal-style exercises at C1.1, three
  passive quizzes plus a passive strand at B2.1, four adjective-table quizzes at
  B1.1.
- C1 and C2 passages sit below exam norms: C1 runs 360 to 410 words against a 400
  to 600 norm, C2 400 to 470 against 500 to 700.
- 236 picture-hunt nouns appear in more than one room, so the C-level rooms are
  re-drilling A1 furniture.

---

## Deliberately not doing

Five quizzes use a `categoryLabel` that is never declared, and three attach one
subject key to two items. Both were investigated and cost the learner nothing: the
weak-spot worksheet looks its category up by the label string, and an undeclared
subject key only suppresses a label on sentences that are self-contained.
Declaring the categories with no values would add a column of blank cells to the
Help Memory table. See section 3.3 of the review.
