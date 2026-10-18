# The printed course: plan for print-on-demand books, module by module

Written 2026-10-18. The goal: turn the twelve level workbooks into books that
can be sold through Amazon's print-on-demand (KDP), printed in A4, with
everything a good German course book has, all the app's pictures and diagrams,
every exercise type, and QR codes that link each page back to the app for the
audio and the parts paper cannot do.

Part 1 is the plan. Part 2 (§9) is the inventory: every exercise of every module
with the treatment it gets in the book and the work it needs.

---

## 1. What exists today

`npm run workbooks` prints one PDF per sub-level from the route
`/course/de_cert_a1/workbook/<level>` through Chrome, A4, 13 mm margins,
52–98 pages each, about 65 MB committed in `static/workbooks/`. A workbook has:

- a cover page with the level, the module name, a scene picture and the table of units;
- one unit per **grammar** and **reading** exercise: hook, intro, rule cards with examples, words, context, "check yourself" questions, cheat sheet, then 8 practice items, with the answers upside down at the foot;
- a "words in pictures" page of 16 cards from the level's deck.

What it does **not** have, measured against the bundle:

| Gap | Count | Why it matters |
|---|---|---|
| Listening, dictation, repeat-after-me, speaking, writing, vocabulary deck and picture-hunt exercises are skipped | 177 of 403 exercises (44 %) | Nearly half the course is missing; every skill except reading. |
| The 570 lesson diagrams (built 2026-10-18) are not drawn in print | 403 lessons | The diagrams are the clearest part of the lesson. |
| Audio is unreachable from paper | 11,638 recorded clips | Listening and dictation cannot work without it. |
| No link to the app at all | — | A reader cannot get from a page to the exercise, the audio or the deck. |
| Not a KDP-ready file | — | Wrong margins for binding, 512 px pictures (about 200 dpi at print size), no separate cover file, no ISBN or copyright page. |
| Medal ladder, Ja oder Nein, match chats, the story episodes are absent | ~300 ladder drills, 100 rounds, 51 chats, 3 episodes | Optional, but they are the course's character. |

---

## 2. The product

**Six books, one per level** (A1, A2, B1, B2, C1, C2), each holding its two
sub-levels as Part 1 and Part 2. Reasons over twelve thin books: a sub-level is
only 50–100 pages, which is a pamphlet at KDP's minimum spine; a level matches
how learners buy ("the B1 book"); six listings are easier to keep in print than
twelve. Expected size after the additions below: **180–260 pages per book**.

Format: **A4 (8.27 × 11.69 in), paperback, premium colour, white paper**.
Colour is not optional: the gender colours and the glowing cells in the case
grids carry meaning. The §5 decision records the cost.

Each book links to the app through QR codes, so the paper is the study
material and the phone is the player: audio, the speaking tutor, the deck, the
picture hunts.

---

## 3. The anatomy of a book

### Front matter (6–8 pages)
1. Half-title, then the title page.
2. Copyright page: ISBN (free from KDP), the disclaimer the app already carries (no exam-brand names), picture and voice credits ("illustrations and audio generated for this course"), edition and content version from `course.version`.
3. "How this book works": the unit anatomy with a labelled sample page (reuse the annotated-screenshot idea from the app's help), the QR-code legend, the medal boxes.
4. The two parts' can-do lists and themes from the syllabus (`syllabus/de_cert_a1.json` has them per module).
5. Contents: every unit with its page, and a **progress tracker** (one row per unit with tick boxes for Learn / Practise / Medal).

### A unit, by exercise type
The unit order follows the app's deck order inside the sub-level. Every unit opens with a running head (part · unit number · type), a QR to the exercise in the app, and the unit's own scene picture where it has one.

| Type | Count | Pages in the book | What the page holds |
|---|---|---|---|
| Grammar (fillBlank) | 226 | 2–3 | Hook, intro, rule cards **with their diagrams**, words with pictures, context, check yourself, cheat sheet and recap table, 8–10 practice items, answer strip. Exists today minus the diagrams. |
| Reading | 31 | 2 | Pre-reading words, the passage with its picture, the questions, a QR to hear the passage read. Exists today minus the words and the QR. |
| Text work (inline cloze) | 12 | 1–2 | The passage with numbered gaps, the options. Exists. |
| Listening | 27 | 1 | **New.** A "before you listen" box (the moves diagram), a large QR to the recording, the questions with tick boxes, two ruled lines for notes. The transcript goes to the answer key, not the unit, so the page cannot be read instead of heard. |
| Dictation | 11 | 1 | **New.** One QR per sentence (or one QR to a numbered player page), 15 ruled lines. Sentences in the key. |
| Repeat after me (speakRepeat) | 24 | 1 | **New.** The phrases with translations, a QR to the whole set, stress marked in bold, the lesson's sound tips. |
| Conversation with your AI (speaking) | 24 | 1 | **New.** The scenario, the phrases to have ready (the new word lists), a QR that opens the app page where the prompt is copied, a self-check list ("full sentences", "asked back", "used the Perfekt"). |
| Writing | 12 | 2 | **New.** The task, the model text with its moves labelled, a ruled page (28 lines), the checklist, and a QR to the correction flow in the app. |
| Vocabulary deck | 12 | 4–6 | **New.** The sub-level's words grouped by theme, every noun with article and plural, a picture where the card has one (486 cards do), and a QR to the deck. Replaces the single "words in pictures" page. |
| Picture hunt (Suchbild) | 24 | 2 | **New.** The room as a full-width picture (1024 px scenes exist), 32 numbered boxes to write the word and article, the answer list in the key. |

### Part-level extras
- **Medal ladder page** per sub-level: the ladder's drills already exist as content (`assets/content/ladder`); print a "Challenge" page of 20 harder items per part, with three medal boxes to tick (the app's bronze/silver/gold), and a QR to the ladder.
- **A story** per level where one exists (A1 has three episodes): the episode as a short illustrated reader at the end of Part 1 or 2, with the story pictures (180 exist).
- **Ja oder Nein?** round as a two-page spread of eight questions for A1–B1 books: a light page between heavy units.
- **A match chat** (Schreib mir!) printed as a dialogue reading with the character's picture, one per part, with a QR to play it.

### Back matter (12–20 pages)
1. **Answer key** for everything that is not already upside down in its unit: listening transcripts and answers, dictation sentences, picture-hunt lists, text-work gaps.
2. **Grammar appendix**: the recap tables of the part, collected (the 30 paradigm tables plus the derived grids), as a quick reference.
3. **Word index A–Z** for the book: every word taught, with article, plural and the unit number.
4. **Audio index**: every QR in the book in one list, with the track number and what it plays, for readers who prefer to type a short link.
5. "What's next": the next book and a QR to the app's placement test.

---

## 4. The QR system

One short, stable URL scheme, so a code printed in 2026 still works:

| Code type | Target | Notes |
|---|---|---|
| Exercise | `/go/<quizId>` → redirects to the quiz page | One per unit. |
| Audio set | `/play/<quizId>` (new route) | A player page that lists the exercise's clips in order with big play buttons; works offline-first from the recorded MP3s. Serves listening, dictation, repeat-after-me and the reading passages. |
| Single clip | `/play/<quizId>#<n>` | Only for dictation, where the reader needs sentence 7 again. |
| Deck | `/go/<deckId>` | Vocabulary pages. |
| Prompt | `/go/<quizId>?copy=1` | Speaking and writing: lands on the page with the copy button in view. |
| Book | `/book/<level>` | Front matter: the book's own page with errata, the audio index and a link to the free PDF. |

Generation: the `qrcode` npm package renders SVG inline in the page, so the
codes print as vectors. Size at least 18 mm, quiet zone 2 modules, ink-navy
on paper. The short redirect route is a static `+server` map in SvelteKit
written from the bundle at build time, so changing a quiz URL later never
breaks a printed book.

Fallback for readers without a camera: every QR carries its short URL in 7 pt
text beneath it.

---

## 5. Print specification (KDP)

To verify against KDP's current help pages before upload; these are the
figures I know and the rules of thumb.

- **Trim** A4, no bleed (none of the pages runs art to the edge; the cover does, and the cover is a separate file).
- **Margins**: outside/top/bottom ≥ 0.25 in (use 15 mm); **inside (gutter) depends on page count**: 0.375 in up to 150 pages, 0.5 in to 300, 0.625 in to 500. Use 20 mm for a 180–300 page book. This means mirrored margins (`@page :left` / `:right`), which Chrome supports.
- **Pictures at 300 dpi**: a 60 mm wide picture needs 709 px; the app's 512 px WebPs give ~215 dpi. The 1024 px originals are in `assets/images/raw/` (566 of 558 current pictures have one; the few missing can be regenerated with `--force`). The book build must read the raw originals, not `static/img/`.
- **Fonts embedded**: Chrome embeds the web fonts (Source Serif 4, Inter) as subsets; KDP accepts this. Check with the KDP previewer, which flags missing fonts.
- **PDF/X not required**, but flatten transparency: the glowing cells use translucent fills; render them as opaque mixes in the print stylesheet.
- **Page count** 24–828 for colour; even number not required (KDP adds a blank).
- **Cover**: a separate PDF, full wrap (back + spine + front) with 0.125 in bleed; spine width = pages × 0.0025 in (white paper). Generate it from the level's scene art with the course palette through `tool/og-images.mjs`'s resvg path, which already draws brand SVG to PNG; wrap as PDF with the same Chrome print path.
- **ISBN**: KDP's free ISBN per book, or your own if you want to sell outside Amazon.
- **Interior colour cost** (A4, premium colour, about 220 pages): roughly 1.00 + 220 × 0.07 ≈ **16 € print cost**, so a 29–34 € list price for a reasonable royalty. Black-and-white would be ~4.50 € but loses the gender colours; if you want a cheap edition, a second stylesheet that encodes gender with patterns (solid / dashed / dotted borders) makes the same book printable in B&W. Confirm current rates on KDP's pricing page.

---

## 6. The work, in order

| # | Workstream | What is done | Effort |
|---|---|---|---|
| W1 | **Diagrams in print** | Render `LessonVisual` inside `WorkbookUnit`; a print stylesheet that keeps diagrams on one page, opaque colours, no scroll frames (wide brackets wrap). Check all 13 kinds at A4 width. | 1 session |
| W2 | **New unit types** | `workbook.ts` gains units for listening, dictation, speakRepeat, speaking, writing, vocabulary and suchbild; a Svelte block each; answer-key entries. The content is all in the bundle already. | 3 sessions |
| W3 | **QR and link routes** | `/go/<id>` redirect map, `/play/<id>` player page (clip list from the audio manifest), `/book/<level>` page; `qrcode` SVG in the page; the audio index. | 1–2 sessions |
| W4 | **Six-book assembly** | A `/course/.../book/<level>` route that concatenates two sub-levels with front and back matter, mirrored margins, running heads, the contents and tracker pages, the index (built from the deck and the unit words), the grammar appendix. | 2 sessions |
| W5 | **Print quality** | 300 dpi picture path from `assets/images/raw/` (and a one-off regeneration of the ones with no raw file), opaque colour mixes, widow/orphan control, page-break rules per block, font subset check in the KDP previewer. | 1–2 sessions |
| W6 | **Covers** | A cover generator (front, spine, back with blurb and the barcode area) per book from the level's hero scene; six covers. | 1 session |
| W7 | **Extras** | Medal-ladder challenge pages, story reader for A1, Ja oder Nein spreads, one match chat per part. | 1–2 sessions |
| W8 | **Tooling** | `npm run books` → six interior PDFs + six cover PDFs + a manifest with page counts and spine widths; the free PDF download on the worksheet page becomes the same file. Content-change check against `course.version`. | 1 session |
| W9 | **Proofing** | Render every page with PyMuPDF to PNG, look at every one of the ~1,300 pages across the six books, fix overflow and bad breaks; one ordered proof copy per book from KDP before publishing (about 20 € each, 1–2 weeks' delivery). | 2 sessions + proof wait |

Total: **13–16 sessions**, three to four weeks at the usual pace, plus the proof
copies. The only money is the six proof copies and, if any 300 dpi originals
are missing, a few cents of image generation.

What to do first for the biggest gain: W1 and W2 make the free PDFs complete
(every exercise, every diagram) in about four sessions, before any KDP work.

---

## 7. Decisions to take

1. **Six books or twelve.** The plan assumes six; twelve needs no change in the pipeline, only a different grouping.
2. **Colour or black-and-white.** The plan assumes premium colour. If B&W, W5 adds a pattern-coded stylesheet.
3. **Medals in the book.** Included as tick boxes on the tracker and the challenge pages, not as a scoring system; the app keeps the real medals. Easy to drop.
4. **Transcripts in the key or in the unit.** The plan puts them in the key, so listening stays listening.
5. **Title and author name** on the cover, and whether the app's name appears (the IP review's rule: no exam brands anywhere).

---

## 8. Open risks

- **KDP figures** (margins, cost per page, max pages) move; verify on the day of upload.
- **Chrome print engine**: it has produced blank-page waste and intermittent `printToPDF` failures before; W8 keeps the retry loop, and widow/orphan rules must be tested per block.
- **File size**: six colour books at 300 dpi may reach 40–60 MB each; KDP's limit is 650 MB, fine, but the committed free PDFs should stay at the current 512 px resolution to keep the repo small. Two render profiles: `web` and `print`.
- **Picture hunts** depend on the 24 room scenes printing crisply; they are 1024 px, which is 300 dpi at 87 mm, so the page has to show them at that size or regenerate them larger.

---

## 9. Inventory: every exercise, module by module

Columns: **Own picture** = the exercise has its own scene (shared level cards
are not printed); **Audio clips** = recorded MP3s available to link;
**Diagrams** = lesson diagrams on its rule cards; **Work** = what the book
needs for this exercise.

### A1.1 — Erste Schritte (First steps)

30 exercises, 19 already in the PDF today, 11 to add. Can-do: Introduce yourself and others; say your name, where you live, what you do; Ask and answer simple questions about a person; Name everyday things with the right article, in the singular and the plural; Count, say ages and prices, give a phone number; Say where something or someone is.

| # | Exercise | Type | Book treatment | Own picture | Audio clips | Diagrams | Work |
|---|---|---|---|---|---|---|---|
| 1 | Zahlen 0–10 | fillBlank | Lesson unit | shared | 0 items | 2 | exists · add diagrams, audio QR |
| 2 | Personalpronomen | fillBlank | Lesson unit | shared | 19 items | 2 | exists · add diagrams, audio QR |
| 3 | Sprechen: Vorstellung | speakRepeat | Speaking card | shared | 12 phrases | 1 | NEW: phrase list with QR audio + pronunciation tips |
| 4 | Artikel im Nominativ | fillBlank | Lesson unit | yes | 0 items | 3 | exists · add diagrams, audio QR |
| 5 | Plural der Nomen | fillBlank | Lesson unit | shared | 0 items | 2 | exists · add diagrams, audio QR |
| 6 | Zahlen 11–20 | fillBlank | Lesson unit | shared | 0 items | 2 | exists · add diagrams, audio QR |
| 7 | Hören: Vorstellung | listening | Listening unit | yes | 1 passage | 1 | NEW: task page + QR audio; transcript in the key |
| 8 | sein & haben | fillBlank | Lesson unit | shared | 21 items | 2 | exists · add diagrams, audio QR |
| 9 | W-Fragen | fillBlank | Lesson unit | shared | 18 items | 2 | exists · add diagrams, audio QR |
| 10 | Lesen: Das bin ich | reading | Reading unit | yes | 1 passage | 1 | exists · add diagrams |
| 11 | Kurzcheck: Zahlen & Vorstellung | speaking | Conversation card | yes | — | 1 | NEW: printed prompt + QR to copy it + self-check boxes |
| 12 | Regelmäßige Verben (Präsens) | fillBlank | Lesson unit | shared | 23 items | 2 | exists · add diagrams, audio QR |
| 13 | Unregelmäßige Verben (Vokalwechsel) | fillBlank | Lesson unit | yes | 22 items | 2 | exists · add diagrams, audio QR |
| 14 | Großer Text: Das bin ich | text work | Text-work unit | yes | — | 1 | exists · add diagrams |
| 15 | Diktat: Steckbrief | dictation | Dictation unit | shared | 15 sentences | 1 | NEW: QR per sentence + ruled lines; key |
| 16 | Hören: Zahlen & Preise | listening | Listening unit | yes | 1 passage | 1 | NEW: task page + QR audio; transcript in the key |
| 17 | Zahlen 20–100 | fillBlank | Lesson unit | shared | 0 items | 2 | exists · add diagrams, audio QR |
| 18 | Farben | fillBlank | Lesson unit | shared | 18 items | 3 | exists · add diagrams, audio QR |
| 19 | Sprechen: Zahlen & Preise | speakRepeat | Speaking card | shared | 15 phrases | 1 | NEW: phrase list with QR audio + pronunciation tips |
| 20 | Familie & Menschen | fillBlank | Lesson unit | shared | 19 items | 2 | exists · add diagrams, audio QR |
| 21 | Länder, Sprachen & Nationalitäten | fillBlank | Lesson unit | shared | 0 items | 2 | exists · add diagrams, audio QR |
| 22 | Wo? — Ortsangaben | fillBlank | Lesson unit | shared | 31 items | 2 | exists · add diagrams, audio QR |
| 23 | Wortbildung: -in & Komposita | fillBlank | Lesson unit | shared | 29 items | 2 | exists · add diagrams, audio QR |
| 24 | Gespräch: Das bin ich | speaking | Conversation card | yes | — | 1 | NEW: printed prompt + QR to copy it + self-check boxes |
| 25 | Schreiben: Das bin ich | writing | Writing page | yes | — | 1 | NEW: task + model text + ruled page + checklist |
| 26 | Das Alphabet & Buchstabieren | fillBlank | Lesson unit | shared | 18 items | 1 | exists · add diagrams, audio QR |
| 27 | Zahlen ab 100: Preise, Jahre, Mengen | fillBlank | Lesson unit | shared | 19 items | 2 | exists · add diagrams, audio QR |
| 28 | Wortschatz | vocabulary | Picture dictionary | shared | — | 2 | NEW: deck by theme, 4–6 pages, with pictures |
| 29 | Suchbild: Das Wohnzimmer | suchbild | Picture hunt | yes | — | 1 | NEW: full-page room + numbered label list |
| 30 | Suchbild: Das Klassenzimmer | suchbild | Picture hunt | yes | — | 1 | NEW: full-page room + numbered label list |

### A1.2 — Im Alltag (Everyday life)

36 exercises, 24 already in the PDF today, 12 to add. Can-do: Talk about your day and tell the time; Order, shop and pay; ask for things politely; Say what you can, must, want and may do; Talk about what happened yesterday, in simple sentences; Give and follow simple instructions; Say what hurts and how you feel.

| # | Exercise | Type | Book treatment | Own picture | Audio clips | Diagrams | Work |
|---|---|---|---|---|---|---|---|
| 1 | Akkusativ (Artikel) | fillBlank | Lesson unit | yes | 0 items | 2 | exists · add diagrams, audio QR |
| 2 | Possessivartikel | fillBlank | Lesson unit | shared | 0 items | 3 | exists · add diagrams, audio QR |
| 3 | Hören: Im Café | listening | Listening unit | yes | 1 passage | 1 | NEW: task page + QR audio; transcript in the key |
| 4 | Personalpronomen (Akkusativ) | fillBlank | Lesson unit | shared | 19 items | 2 | exists · add diagrams, audio QR |
| 5 | Negation (kein/nicht) | fillBlank | Lesson unit | shared | 19 items | 2 | exists · add diagrams, audio QR |
| 6 | Lesen: Das neue Café | reading | Reading unit | yes | 1 passage | 1 | exists · add diagrams |
| 7 | Modalverben | fillBlank | Lesson unit | yes | 18 items | 3 | exists · add diagrams, audio QR |
| 8 | Sprechen: Alltag & Uhrzeit | speakRepeat | Speaking card | shared | 12 phrases | 1 | NEW: phrase list with QR audio + pronunciation tips |
| 9 | Uhrzeit | fillBlank | Lesson unit | shared | 16 items | 3 | exists · add diagrams, audio QR |
| 10 | Kurzcheck: Akkusativ & Possessiv | speaking | Conversation card | yes | — | 1 | NEW: printed prompt + QR to copy it + self-check boxes |
| 11 | Wochentage & Monate | fillBlank | Lesson unit | shared | 29 items | 2 | exists · add diagrams, audio QR |
| 12 | Wann? — Zeitangaben | fillBlank | Lesson unit | shared | 20 items | 2 | exists · add diagrams, audio QR |
| 13 | Diktat: Mein Tag | dictation | Dictation unit | shared | 14 sentences | 1 | NEW: QR per sentence + ruled lines; key |
| 14 | Hören: Termine & Uhrzeit | listening | Listening unit | yes | 1 passage | 1 | NEW: task page + QR audio; transcript in the key |
| 15 | Hören: Durchsage am Bahnhof | listening | Listening unit | yes | 1 passage | 1 | NEW: task page + QR audio; transcript in the key |
| 16 | Akkusativpräpositionen | fillBlank | Lesson unit | shared | 19 items | 1 | exists · add diagrams, audio QR |
| 17 | Großer Text: Mein Tag | text work | Text-work unit | yes | — | 2 | exists · add diagrams |
| 18 | Trennbare Verben | fillBlank | Lesson unit | shared | 19 items | 2 | exists · add diagrams, audio QR |
| 19 | Perfekt: erste Schritte | fillBlank | Lesson unit | shared | 15 items | 3 | exists · add diagrams, audio QR |
| 20 | war & hatte | fillBlank | Lesson unit | shared | 19 items | 2 | exists · add diagrams, audio QR |
| 21 | Imperativ | fillBlank | Lesson unit | shared | 22 items | 1 | exists · add diagrams, audio QR |
| 22 | Höflich bitten & bestellen | fillBlank | Lesson unit | shared | 15 items | 1 | exists · add diagrams, audio QR |
| 23 | mir, dir, Ihnen — Dativ-Pronomen | fillBlank | Lesson unit | shared | 15 items | 2 | exists · add diagrams, audio QR |
| 24 | Satzbau: Position 2 & Konnektoren | fillBlank | Lesson unit | shared | 19 items | 3 | exists · add diagrams, audio QR |
| 25 | Sprechen: Einkaufen & Bestellen | speakRepeat | Speaking card | shared | 12 phrases | 1 | NEW: phrase list with QR audio + pronunciation tips |
| 26 | Einkaufen: Mengen & Preise | fillBlank | Lesson unit | shared | 18 items | 2 | exists · add diagrams, audio QR |
| 27 | Körper & Befinden | fillBlank | Lesson unit | shared | 21 items | 3 | exists · add diagrams, audio QR |
| 28 | Lesen: Eine kleine Reise | reading | Reading unit | yes | 1 passage | 1 | exists · add diagrams |
| 29 | Lesen: Anzeigen & Schilder | reading | Reading unit | yes | 1 passage | 1 | exists · add diagrams |
| 30 | Gespräch: Mein Alltag | speaking | Conversation card | yes | — | 1 | NEW: printed prompt + QR to copy it + self-check boxes |
| 31 | Schreiben: Eine kurze Nachricht | writing | Writing page | yes | — | 1 | NEW: task + model text + ruled page + checklist |
| 32 | Wohin? — nach, zu, in | fillBlank | Lesson unit | shared | 20 items | 2 | exists · add diagrams, audio QR |
| 33 | unser, euer, Ihr | fillBlank | Lesson unit | shared | 16 items | 2 | exists · add diagrams, audio QR |
| 34 | Wortschatz | vocabulary | Picture dictionary | shared | — | 1 | NEW: deck by theme, 4–6 pages, with pictures |
| 35 | Suchbild: Die Küche | suchbild | Picture hunt | yes | — | 1 | NEW: full-page room + numbered label list |
| 36 | Suchbild: Der Supermarkt | suchbild | Picture hunt | yes | — | 1 | NEW: full-page room + numbered label list |

### A2.1 — Erlebnisse (Experiences)

28 exercises, 17 already in the PDF today, 11 to add. Can-do: Talk about the past: your weekend, a trip, what you did yesterday; Say who you gave, showed or told something to; Ask for and follow directions in a town; Talk about the weather and the seasons; Compare two things.

| # | Exercise | Type | Book treatment | Own picture | Audio clips | Diagrams | Work |
|---|---|---|---|---|---|---|---|
| 1 | Perfekt mit haben | fillBlank | Lesson unit | yes | 18 items | 4 | exists · add diagrams, audio QR |
| 2 | Perfekt mit sein | fillBlank | Lesson unit | shared | 18 items | 2 | exists · add diagrams, audio QR |
| 3 | Sprechen: Mein Wochenende | speakRepeat | Speaking card | shared | 12 phrases | 1 | NEW: phrase list with QR audio + pronunciation tips |
| 4 | Dativ: bestimmte Artikel | fillBlank | Lesson unit | shared | 18 items | 3 | exists · add diagrams, audio QR |
| 5 | Hören: Eine Reise | listening | Listening unit | yes | 1 passage | 1 | NEW: task page + QR audio; transcript in the key |
| 6 | Dativpräpositionen | fillBlank | Lesson unit | shared | 16 items | 3 | exists · add diagrams, audio QR |
| 7 | Zeitangaben: seit, vor, nach, in, für, über | fillBlank | Lesson unit | shared | 18 items | 2 | exists · add diagrams, audio QR |
| 8 | Woher? Wo? Wohin? | fillBlank | Lesson unit | shared | 24 items | 3 | exists · add diagrams, audio QR |
| 9 | Personalpronomen im Dativ | fillBlank | Lesson unit | shared | 18 items | 2 | exists · add diagrams, audio QR |
| 10 | Wem? Was? — Verben mit Dativ und Akkusativ | fillBlank | Lesson unit | yes | 18 items | 2 | exists · add diagrams, audio QR |
| 11 | Lesen: Ein Wochenende in Hamburg | reading | Reading unit | yes | 1 passage | 1 | exists · add diagrams |
| 12 | Kurzcheck: Perfekt | speaking | Conversation card | yes | — | 1 | NEW: printed prompt + QR to copy it + self-check boxes |
| 13 | war & hatte (Präteritum) | fillBlank | Lesson unit | shared | 18 items | 2 | exists · add diagrams, audio QR |
| 14 | Modalverben im Präteritum | fillBlank | Lesson unit | shared | 0 items | 2 | exists · add diagrams, audio QR |
| 15 | Großer Text: Ein Wochenende bei Oma | text work | Text-work unit | yes | — | 1 | exists · add diagrams |
| 16 | Das Wetter & Jahreszeiten | fillBlank | Lesson unit | shared | 18 items | 2 | exists · add diagrams, audio QR |
| 17 | Diktat: Im Perfekt | dictation | Dictation unit | shared | 15 sentences | 1 | NEW: QR per sentence + ruled lines; key |
| 18 | Sprechen: Nach dem Weg fragen | speakRepeat | Speaking card | shared | 12 phrases | 2 | NEW: phrase list with QR audio + pronunciation tips |
| 19 | Komparativ | fillBlank | Lesson unit | shared | 16 items | 3 | exists · add diagrams, audio QR |
| 20 | welcher? dieser! — und mein im Dativ | fillBlank | Lesson unit | shared | 17 items | 2 | exists · add diagrams, audio QR |
| 21 | Hören: Wetterbericht | listening | Listening unit | yes | 1 passage | 1 | NEW: task page + QR audio; transcript in the key |
| 22 | Lesen: Emmas erste Woche | reading | Reading unit | yes | 1 passage | 1 | exists · add diagrams |
| 23 | Gespräch: Erlebnisse | speaking | Conversation card | yes | — | 1 | NEW: printed prompt + QR to copy it + self-check boxes |
| 24 | Schreiben: Eine E-Mail an einen Freund | writing | Writing page | yes | — | 1 | NEW: task + model text + ruled page + checklist |
| 25 | Indefinitpronomen: man, jemand, niemand, etwas, nichts, alle | fillBlank | Lesson unit | shared | 19 items | 1 | exists · add diagrams, audio QR |
| 26 | Wortschatz | vocabulary | Picture dictionary | shared | — | 1 | NEW: deck by theme, 4–6 pages, with pictures |
| 27 | Suchbild: Das Badezimmer | suchbild | Picture hunt | yes | — | 1 | NEW: full-page room + numbered label list |
| 28 | Suchbild: Der Bahnhof | suchbild | Picture hunt | yes | — | 1 | NEW: full-page room + numbered label list |

### A2.2 — Beschreiben & Planen (Describe & plan)

35 exercises, 25 already in the PDF today, 10 to add. Can-do: Describe a room and say where things are and where you put them; Give reasons and say what you think (weil, dass, deshalb); Ask indirectly and politely (Können Sie mir sagen, ob …?); Make suggestions and give advice (könnte, sollte); Describe people, clothes and health; talk to a doctor; Narrate simply in the written past (Präteritum) and understand a simple passive.

| # | Exercise | Type | Book treatment | Own picture | Audio clips | Diagrams | Work |
|---|---|---|---|---|---|---|---|
| 1 | Wechselpräpositionen: Wo? | fillBlank | Lesson unit | shared | 20 items | 2 | exists · add diagrams, audio QR |
| 2 | Wechselpräpositionen: Wohin? | fillBlank | Lesson unit | yes | 19 items | 3 | exists · add diagrams, audio QR |
| 3 | Großer Text: Mein Zimmer | text work | Text-work unit | yes | — | 1 | exists · add diagrams |
| 4 | Sprechen: Mein Zimmer | speakRepeat | Speaking card | shared | 12 phrases | 1 | NEW: phrase list with QR audio + pronunciation tips |
| 5 | Reflexive Verben | fillBlank | Lesson unit | shared | 21 items | 2 | exists · add diagrams, audio QR |
| 6 | Nebensatz mit weil | fillBlank | Lesson unit | shared | 19 items | 3 | exists · add diagrams, audio QR |
| 7 | Hören: Eine Verabredung | listening | Listening unit | yes | 1 passage | 1 | NEW: task page + QR audio; transcript in the key |
| 8 | Nebensatz mit dass | fillBlank | Lesson unit | shared | 21 items | 2 | exists · add diagrams, audio QR |
| 9 | wenn & deshalb | fillBlank | Lesson unit | shared | 19 items | 2 | exists · add diagrams, audio QR |
| 10 | Indirekte Fragen: ob & W-Wort | fillBlank | Lesson unit | shared | 19 items | 2 | exists · add diagrams, audio QR |
| 11 | Verben mit Präposition: worauf? darauf! | fillBlank | Lesson unit | shared | 18 items | 3 | exists · add diagrams, audio QR |
| 12 | Kurzcheck: Wo oder wohin? | speaking | Conversation card | yes | — | 1 | NEW: printed prompt + QR to copy it + self-check boxes |
| 13 | Körper & Gesundheit | fillBlank | Lesson unit | shared | 19 items | 2 | exists · add diagrams, audio QR |
| 14 | Kleidung & Einkaufen | fillBlank | Lesson unit | shared | 19 items | 3 | exists · add diagrams, audio QR |
| 15 | Lesen: Beim Arzt | reading | Reading unit | yes | 1 passage | 2 | exists · add diagrams |
| 16 | Imperativ | fillBlank | Lesson unit | shared | 20 items | 2 | exists · add diagrams, audio QR |
| 17 | Diktat: Beschreiben | dictation | Dictation unit | shared | 15 sentences | 1 | NEW: QR per sentence + ruled lines; key |
| 18 | Sprechen: Personen beschreiben | speakRepeat | Speaking card | shared | 12 phrases | 1 | NEW: phrase list with QR audio + pronunciation tips |
| 19 | Adjektive vor dem Nomen: erste Begegnung | fillBlank | Lesson unit | shared | 0 items | 2 | exists · add diagrams, audio QR |
| 20 | Vorschläge & Ratschläge: könnte, sollte | fillBlank | Lesson unit | shared | 0 items | 2 | exists · add diagrams, audio QR |
| 21 | Relativsätze: der, die, das (Nom/Akk) | fillBlank | Lesson unit | yes | 20 items | 2 | exists · add diagrams, audio QR |
| 22 | Präteritum: erste Schritte | fillBlank | Lesson unit | shared | 18 items | 2 | exists · add diagrams, audio QR |
| 23 | Passiv Präsens: Das wird gemacht | fillBlank | Lesson unit | shared | 19 items | 2 | exists · add diagrams, audio QR |
| 24 | Wortbildung: -er, -ung, un-, -los, -bar | fillBlank | Lesson unit | shared | 19 items | 3 | exists · add diagrams, audio QR |
| 25 | Superlativ | fillBlank | Lesson unit | shared | 19 items | 2 | exists · add diagrams, audio QR |
| 26 | Wortstellung: Wann? Wie? Wo? | fillBlank | Lesson unit | shared | 19 items | 2 | exists · add diagrams, audio QR |
| 27 | Lesen: Eine E-Mail | reading | Reading unit | yes | 1 passage | 1 | exists · add diagrams |
| 28 | Lesen: Formular & Anmeldung | reading | Reading unit | yes | 1 passage | 1 | exists · add diagrams |
| 29 | Gespräch: Beschreiben & Planen | speaking | Conversation card | yes | — | 1 | NEW: printed prompt + QR to copy it + self-check boxes |
| 30 | Annas Auto & der 3. Oktober: Genitiv-s und Datum | fillBlank | Lesson unit | shared | 16 items | 2 | exists · add diagrams, audio QR |
| 31 | Schreiben: E-Mail-Bausteine | fillBlank | Lesson unit | shared | 16 items | 2 | exists · add diagrams, audio QR |
| 32 | Schreiben: Einladung & Plan | writing | Writing page | yes | — | 1 | NEW: task + model text + ruled page + checklist |
| 33 | Wortschatz | vocabulary | Picture dictionary | shared | — | 1 | NEW: deck by theme, 4–6 pages, with pictures |
| 34 | Suchbild: Das Kinderzimmer | suchbild | Picture hunt | yes | — | 1 | NEW: full-page room + numbered label list |
| 35 | Suchbild: Das Café | suchbild | Picture hunt | yes | — | 1 | NEW: full-page room + numbered label list |

### B1.1 — Meinungen & Wünsche (Opinions & wishes)

33 exercises, 22 already in the PDF today, 11 to add. Can-do: Describe people, things and places with fully declined adjectives (der/ein/no article; comparative and superlative); Express wishes, polite requests and unreal conditions (würde, hätte, wäre, könnte); Make predictions and promises (Futur I) and talk about the world of work; Link ideas with relative clauses (incl. with prepositions), the genitive and wenn/als/obwohl/falls/da/trotzdem; Use infinitive clauses with zu and the es-expressions of everyday German; Write a formal and an informal e-mail with the standard Redemittel; state and justify an opinion.

| # | Exercise | Type | Book treatment | Own picture | Audio clips | Diagrams | Work |
|---|---|---|---|---|---|---|---|
| 1 | Die Welt der Arbeit | fillBlank | Lesson unit | shared | 18 items | 2 | exists · add diagrams, audio QR |
| 2 | Adjektivendungen: bestimmter Artikel | fillBlank | Lesson unit | yes | 19 items | 1 | exists · add diagrams, audio QR |
| 3 | Sprechen: Höfliche Bitten | speakRepeat | Speaking card | shared | 12 phrases | 1 | NEW: phrase list with QR audio + pronunciation tips |
| 4 | Adjektivendungen: unbestimmter Artikel | fillBlank | Lesson unit | shared | 18 items | 1 | exists · add diagrams, audio QR |
| 5 | Großer Text: Meine neue Wohnung | text work | Text-work unit | yes | — | 1 | exists · add diagrams |
| 6 | Adjektivendungen ohne Artikel | fillBlank | Lesson unit | shared | 18 items | 1 | exists · add diagrams, audio QR |
| 7 | Komparativ & Superlativ vor dem Nomen | fillBlank | Lesson unit | shared | 16 items | 1 | exists · add diagrams, audio QR |
| 8 | Adjektive und Partizipien als Nomen | fillBlank | Lesson unit | shared | 18 items | 1 | exists · add diagrams, audio QR |
| 9 | Konjunktiv II: würde + Infinitiv | fillBlank | Lesson unit | yes | 18 items | 2 | exists · add diagrams, audio QR |
| 10 | Hören: Vorstellungsgespräch | listening | Listening unit | yes | 1 passage | 1 | NEW: task page + QR audio; transcript in the key |
| 11 | Konjunktiv II: hätte / wäre / könnte | fillBlank | Lesson unit | shared | 18 items | 2 | exists · add diagrams, audio QR |
| 12 | Lesen: Die Zukunft der Arbeit | reading | Reading unit | yes | 1 passage | 1 | exists · add diagrams |
| 13 | Kurzcheck: Konjunktiv II | speaking | Conversation card | yes | — | 1 | NEW: printed prompt + QR to copy it + self-check boxes |
| 14 | Futur I | fillBlank | Lesson unit | shared | 18 items | 2 | exists · add diagrams, audio QR |
| 15 | Relativsätze (Nom./Akk.) | fillBlank | Lesson unit | shared | 19 items | 2 | exists · add diagrams, audio QR |
| 16 | Relativsätze mit Dativ & Präposition | fillBlank | Lesson unit | shared | 18 items | 2 | exists · add diagrams, audio QR |
| 17 | Diktat: Wünsche & Bitten | dictation | Dictation unit | shared | 15 sentences | 1 | NEW: QR per sentence + ruled lines; key |
| 18 | Genitiv | fillBlank | Lesson unit | shared | 16 items | 2 | exists · add diagrams, audio QR |
| 19 | Sprechen: Meinung äußern | speakRepeat | Speaking card | shared | 12 phrases | 1 | NEW: phrase list with QR audio + pronunciation tips |
| 20 | Nebensätze: wenn / als / obwohl | fillBlank | Lesson unit | shared | 15 items | 2 | exists · add diagrams, audio QR |
| 21 | Infinitiv mit zu | fillBlank | Lesson unit | shared | 20 items | 2 | exists · add diagrams, audio QR |
| 22 | es-Ausdrücke: es gibt, es geht, es lohnt sich | fillBlank | Lesson unit | shared | 15 items | 1 | exists · add diagrams, audio QR |
| 23 | Hören: Radio-Umfrage | listening | Listening unit | yes | 1 passage | 1 | NEW: task page + QR audio; transcript in the key |
| 24 | Lesen: Im Ausland studieren | reading | Reading unit | yes | 1 passage | 1 | exists · add diagrams |
| 25 | Schreiben: Die E-Mail — formell & informell | fillBlank | Lesson unit | shared | 18 items | 2 | exists · add diagrams, audio QR |
| 26 | Schreiben: Eine formelle E-Mail | writing | Writing page | yes | — | 1 | NEW: task + model text + ruled page + checklist |
| 27 | Gespräch: Meinungen & Wünsche | speaking | Conversation card | yes | — | 1 | NEW: printed prompt + QR to copy it + self-check boxes |
| 28 | Verben mit Präpositionen: worauf? – darauf! | fillBlank | Lesson unit | shared | 16 items | 2 | exists · add diagrams, audio QR |
| 29 | Indirekte Fragen: Können Sie mir sagen, ob …? | fillBlank | Lesson unit | shared | 17 items | 1 | exists · add diagrams, audio QR |
| 30 | falls, da, trotzdem | fillBlank | Lesson unit | shared | 17 items | 1 | exists · add diagrams, audio QR |
| 31 | Wortschatz | vocabulary | Picture dictionary | shared | — | 1 | NEW: deck by theme, 4–6 pages, with pictures |
| 32 | Suchbild: Das Büro | suchbild | Picture hunt | yes | — | 1 | NEW: full-page room + numbered label list |
| 33 | Suchbild: Die Arztpraxis | suchbild | Picture hunt | yes | — | 1 | NEW: full-page room + numbered label list |

### B1.2 — Erzählen & Begründen (Narrate & justify)

35 exercises, 24 already in the PDF today, 11 to add. Can-do: Narrate in the written past (Präteritum, incl. mixed verbs) and order events with the Plusquamperfekt and temporal clauses; Understand and form the passive in the present and past, and with a modal verb; Express purpose, means and result (um … zu, damit, indem, sodass) and link with two-part connectors; Express unreal wishes about the past (Hätte ich doch …!); Use genitive prepositions (trotz, wegen, während) and participles as adjectives; Understand the modal particles of spoken German and build words from suffixes; Talk about technology, media, health and the environment.

| # | Exercise | Type | Book treatment | Own picture | Audio clips | Diagrams | Work |
|---|---|---|---|---|---|---|---|
| 1 | Technik & Medien | fillBlank | Lesson unit | shared | 17 items | 2 | exists · add diagrams, audio QR |
| 2 | Präteritum: regelmäßig | fillBlank | Lesson unit | shared | 18 items | 2 | exists · add diagrams, audio QR |
| 3 | Präteritum: unregelmäßig | fillBlank | Lesson unit | shared | 17 items | 2 | exists · add diagrams, audio QR |
| 4 | Präteritum: Mischverben | fillBlank | Lesson unit | shared | 18 items | 1 | exists · add diagrams, audio QR |
| 5 | Plusquamperfekt: hatte / war + Partizip II | fillBlank | Lesson unit | yes | 17 items | 2 | exists · add diagrams, audio QR |
| 6 | Temporalsätze: nachdem, bevor, während, seit, bis | fillBlank | Lesson unit | shared | 19 items | 2 | exists · add diagrams, audio QR |
| 7 | Großer Text: Der kleine Ritter | text work | Text-work unit | yes | — | 1 | exists · add diagrams |
| 8 | Sprechen: Eine Geschichte erzählen | speakRepeat | Speaking card | shared | 12 phrases | 1 | NEW: phrase list with QR audio + pronunciation tips |
| 9 | Passiv (Präsens) | fillBlank | Lesson unit | yes | 17 items | 2 | exists · add diagrams, audio QR |
| 10 | Hören: Eine Durchsage | listening | Listening unit | yes | 1 passage | 1 | NEW: task page + QR audio; transcript in the key |
| 11 | Passiv (Präteritum) | fillBlank | Lesson unit | shared | 18 items | 2 | exists · add diagrams, audio QR |
| 12 | Passiv mit Modalverb & Passiv Perfekt | fillBlank | Lesson unit | shared | 18 items | 2 | exists · add diagrams, audio QR |
| 13 | Kurzcheck: Präteritum | speaking | Conversation card | yes | — | 1 | NEW: printed prompt + QR to copy it + self-check boxes |
| 14 | n-Deklination | fillBlank | Lesson unit | shared | 17 items | 1 | exists · add diagrams, audio QR |
| 15 | Lesen: Ein Missgeschick | reading | Reading unit | yes | 1 passage | 1 | exists · add diagrams |
| 16 | Infinitivsätze: um … zu, ohne … zu, statt … zu | fillBlank | Lesson unit | shared | 18 items | 2 | exists · add diagrams, audio QR |
| 17 | damit oder um … zu? | fillBlank | Lesson unit | shared | 17 items | 1 | exists · add diagrams, audio QR |
| 18 | indem & sodass: Wie? Mit welcher Folge? | fillBlank | Lesson unit | shared | 18 items | 1 | exists · add diagrams, audio QR |
| 19 | Diktat: Eine kleine Geschichte | dictation | Dictation unit | shared | 12 sentences | 1 | NEW: QR per sentence + ruled lines; key |
| 20 | Relativsätze (Dativ/Genitiv) | fillBlank | Lesson unit | shared | 19 items | 1 | exists · add diagrams, audio QR |
| 21 | Zweiteilige Konnektoren | fillBlank | Lesson unit | shared | 17 items | 2 | exists · add diagrams, audio QR |
| 22 | Irreale Wünsche: Hätte ich doch …! | fillBlank | Lesson unit | shared | 18 items | 2 | exists · add diagrams, audio QR |
| 23 | trotz, wegen, während + Genitiv | fillBlank | Lesson unit | shared | 18 items | 1 | exists · add diagrams, audio QR |
| 24 | Partizip I & II als Adjektiv | fillBlank | Lesson unit | shared | 18 items | 2 | exists · add diagrams, audio QR |
| 25 | Sprechen: Etwas begründen | speakRepeat | Speaking card | shared | 12 phrases | 1 | NEW: phrase list with QR audio + pronunciation tips |
| 26 | Modalpartikeln: denn, doch, eigentlich, ja, mal | fillBlank | Lesson unit | shared | 17 items | 1 | exists · add diagrams, audio QR |
| 27 | Hören: Podcast | listening | Listening unit | yes | 1 passage | 1 | NEW: task page + QR audio; transcript in the key |
| 28 | Wortbildung: -heit, -keit, -ung, -schaft, -ler, -ant | fillBlank | Lesson unit | shared | 18 items | 1 | exists · add diagrams, audio QR |
| 29 | Lesen: Eine wahre Anekdote | reading | Reading unit | yes | 1 passage | 1 | exists · add diagrams |
| 30 | Gespräch: Erzählen & Begründen | speaking | Conversation card | yes | — | 1 | NEW: printed prompt + QR to copy it + self-check boxes |
| 31 | Schreiben: Etwas ist schiefgegangen | writing | Writing page | yes | — | 1 | NEW: task + model text + ruled page + checklist |
| 32 | Zustandspassiv: Die Tür ist geschlossen | fillBlank | Lesson unit | shared | 18 items | 2 | exists · add diagrams, audio QR |
| 33 | Wortschatz | vocabulary | Picture dictionary | shared | — | 1 | NEW: deck by theme, 4–6 pages, with pictures |
| 34 | Suchbild: Die Garage | suchbild | Picture hunt | yes | — | 1 | NEW: full-page room + numbered label list |
| 35 | Suchbild: Der Park | suchbild | Picture hunt | yes | — | 1 | NEW: full-page room + numbered label list |

### B2.1 — Argumentieren (Argue)

37 exercises, 26 already in the PDF today, 11 to add. Can-do: Report what others said in the Konjunktiv I (present, past, questions and requests), with Konjunktiv II as a substitute; Use the full passive system: with modals, in the Perfekt, the state passive, and subjectless passives; Use verbs, adjectives and nouns with their fixed prepositions, including da-/wo- forms; Place elements in the middle field correctly (time – cause – manner – place; object order); Express causes and time relations both verbally and nominally (weil ↔ wegen; bevor ↔ vor); Handle lassen, double infinitives, dass ↔ zu-infinitive, and predict gender from suffixes; Write a structured Stellungnahme / Leserbrief and argue in a discussion.

| # | Exercise | Type | Book treatment | Own picture | Audio clips | Diagrams | Work |
|---|---|---|---|---|---|---|---|
| 1 | Gesellschaft & Politik | fillBlank | Lesson unit | shared | 15 items | 1 | exists · add diagrams, audio QR |
| 2 | Konjunktiv I: indirekte Rede | fillBlank | Lesson unit | yes | 15 items | 2 | exists · add diagrams, audio QR |
| 3 | Großer Text: Die Pressekonferenz | text work | Text-work unit | yes | — | 1 | exists · add diagrams |
| 4 | Sprechen: Meinung verteidigen | speakRepeat | Speaking card | shared | 12 phrases | 1 | NEW: phrase list with QR audio + pronunciation tips |
| 5 | Indirekte Fragen | fillBlank | Lesson unit | shared | 15 items | 1 | exists · add diagrams, audio QR |
| 6 | Indirekte Rede: Vergangenheit, Fragen, Bitten | fillBlank | Lesson unit | shared | 15 items | 1 | exists · add diagrams, audio QR |
| 7 | Modalpassiv | fillBlank | Lesson unit | shared | 15 items | 2 | exists · add diagrams, audio QR |
| 8 | Hören: Eine Debatte | listening | Listening unit | yes | 1 passage | 1 | NEW: task page + QR audio; transcript in the key |
| 9 | Verben mit Präposition | fillBlank | Lesson unit | shared | 15 items | 2 | exists · add diagrams, audio QR |
| 10 | Adjektive mit Präposition | fillBlank | Lesson unit | shared | 15 items | 2 | exists · add diagrams, audio QR |
| 11 | Nomen mit Präposition | fillBlank | Lesson unit | shared | 15 items | 1 | exists · add diagrams, audio QR |
| 12 | Kurzcheck: Konjunktiv I | speaking | Conversation card | yes | — | 1 | NEW: printed prompt + QR to copy it + self-check boxes |
| 13 | Partizip als Adjektiv: Relativsatz ↔ Attribut | fillBlank | Lesson unit | yes | 15 items | 1 | exists · add diagrams, audio QR |
| 14 | Lesen: Pro & Contra Homeoffice | reading | Reading unit | yes | 1 passage | 1 | exists · add diagrams |
| 15 | Konnektoren | fillBlank | Lesson unit | shared | 15 items | 2 | exists · add diagrams, audio QR |
| 16 | Mittelfeld: TeKaMoLo & Objektstellung | fillBlank | Lesson unit | shared | 18 items | 2 | exists · add diagrams, audio QR |
| 17 | Kausal: verbal ↔ nominal | fillBlank | Lesson unit | shared | 15 items | 2 | exists · add diagrams, audio QR |
| 18 | Temporal: verbal ↔ nominal | fillBlank | Lesson unit | shared | 15 items | 1 | exists · add diagrams, audio QR |
| 19 | dass-Satz ↔ Infinitiv mit zu | fillBlank | Lesson unit | shared | 15 items | 1 | exists · add diagrams, audio QR |
| 20 | lassen & Doppelinfinitiv | fillBlank | Lesson unit | shared | 16 items | 2 | exists · add diagrams, audio QR |
| 21 | Nachsilben & Genus | fillBlank | Lesson unit | shared | 17 items | 3 | exists · add diagrams, audio QR |
| 22 | Diktat: Argumentieren | dictation | Dictation unit | shared | 12 sentences | 1 | NEW: QR per sentence + ruled lines; key |
| 23 | Passiv Perfekt | fillBlank | Lesson unit | shared | 15 items | 2 | exists · add diagrams, audio QR |
| 24 | Zustandspassiv: ist geöffnet vs wird geöffnet | fillBlank | Lesson unit | shared | 15 items | 1 | exists · add diagrams, audio QR |
| 25 | Subjektlose Passivsätze: Es wird getanzt | fillBlank | Lesson unit | shared | 15 items | 1 | exists · add diagrams, audio QR |
| 26 | Hören: Nachrichten | listening | Listening unit | yes | 1 passage | 1 | NEW: task page + QR audio; transcript in the key |
| 27 | Sprechen: Ein Argument präsentieren | speakRepeat | Speaking card | shared | 12 phrases | 1 | NEW: phrase list with QR audio + pronunciation tips |
| 28 | Lesen: Leserbrief | reading | Reading unit | yes | 1 passage | 1 | exists · add diagrams |
| 29 | Schreiben: Stellungnahme & Leserbrief | fillBlank | Lesson unit | shared | 15 items | 1 | exists · add diagrams, audio QR |
| 30 | Gespräch: Argumentieren | speaking | Conversation card | yes | — | 1 | NEW: printed prompt + QR to copy it + self-check boxes |
| 31 | Schreiben: Stellungnahme | writing | Writing page | yes | — | 1 | NEW: task + model text + ruled page + checklist |
| 32 | um … zu, ohne … zu, statt … zu oder dass? | fillBlank | Lesson unit | shared | 15 items | 1 | exists · add diagrams, audio QR |
| 33 | nicht / nur brauchen + zu | fillBlank | Lesson unit | shared | 15 items | 1 | exists · add diagrams, audio QR |
| 34 | je … desto / umso | fillBlank | Lesson unit | shared | 15 items | 1 | exists · add diagrams, audio QR |
| 35 | Wortschatz | vocabulary | Picture dictionary | shared | — | 1 | NEW: deck by theme, 4–6 pages, with pictures |
| 36 | Suchbild: Die Hotelrezeption | suchbild | Picture hunt | yes | — | 1 | NEW: full-page room + numbered label list |
| 37 | Suchbild: Die Baustelle | suchbild | Picture hunt | yes | — | 1 | NEW: full-page room + numbered label list |

### B2.2 — Differenzieren (Differentiate)

38 exercises, 27 already in the PDF today, 11 to add. Can-do: Talk about the unreal past: conditions, regrets, comparisons with als ob, and guesses with Futur II; Use genitive prepositions, extended participial attributes and Funktionsverbgefüge in formal text; Express conditions, concessions, consequences, means and contrasts both verbally and nominally; Recognise subjective sollen (hearsay), passive substitutes and the modal particles of speech; Use generalising relative clauses (wer … der), was/wo relatives and indefinite pronouns; Keep a text cohesive with reference words and nominalise verbs the six ways; Build adjectives with suffixes and negation prefixes; solve a Sprachbausteine cloze.

| # | Exercise | Type | Book treatment | Own picture | Audio clips | Diagrams | Work |
|---|---|---|---|---|---|---|---|
| 1 | Wissenschaft & Umwelt | fillBlank | Lesson unit | shared | 18 items | 1 | exists · add diagrams, audio QR |
| 2 | Konjunktiv II der Vergangenheit | fillBlank | Lesson unit | yes | 18 items | 2 | exists · add diagrams, audio QR |
| 3 | Irreale Bedingungssätze | fillBlank | Lesson unit | shared | 18 items | 2 | exists · add diagrams, audio QR |
| 4 | Irreale Vergleiche: als ob | fillBlank | Lesson unit | shared | 17 items | 1 | exists · add diagrams, audio QR |
| 5 | Großer Text: Verpasste Chancen | text work | Text-work unit | yes | — | 1 | exists · add diagrams |
| 6 | Sprechen: Hypothesen & Bedauern | speakRepeat | Speaking card | shared | 12 phrases | 1 | NEW: phrase list with QR audio + pronunciation tips |
| 7 | Futur II: Vermutungen über Vergangenes | fillBlank | Lesson unit | shared | 18 items | 2 | exists · add diagrams, audio QR |
| 8 | Genitivpräpositionen | fillBlank | Lesson unit | shared | 18 items | 1 | exists · add diagrams, audio QR |
| 9 | Hören: Ein Vortrag | listening | Listening unit | yes | 1 passage | 1 | NEW: task page + QR audio; transcript in the key |
| 10 | Erweitertes Partizipialattribut | fillBlank | Lesson unit | yes | 15 items | 2 | exists · add diagrams, audio QR |
| 11 | Kurzcheck: Irreale Vergangenheit | speaking | Conversation card | yes | — | 1 | NEW: printed prompt + QR to copy it + self-check boxes |
| 12 | Modalpartikeln | fillBlank | Lesson unit | shared | 17 items | 1 | exists · add diagrams, audio QR |
| 13 | Lesen: Klimawandel | reading | Reading unit | yes | 1 passage | 1 | exists · add diagrams |
| 14 | Funktionsverbgefüge | fillBlank | Lesson unit | shared | 18 items | 1 | exists · add diagrams, audio QR |
| 15 | Verweiswörter & Textkohäsion | fillBlank | Lesson unit | shared | 17 items | 1 | exists · add diagrams, audio QR |
| 16 | Nominalisierung: die sechs Typen | fillBlank | Lesson unit | shared | 17 items | 1 | exists · add diagrams, audio QR |
| 17 | Adjektivbildung: -lich, -ig, -isch, -bar, -los, -reich | fillBlank | Lesson unit | shared | 15 items | 2 | exists · add diagrams, audio QR |
| 18 | Diktat: Hypothesen | dictation | Dictation unit | shared | 12 sentences | 1 | NEW: QR per sentence + ruled lines; key |
| 19 | Konzessivsätze | fillBlank | Lesson unit | shared | 18 items | 2 | exists · add diagrams, audio QR |
| 20 | Konditional: verbal ↔ nominal | fillBlank | Lesson unit | shared | 17 items | 1 | exists · add diagrams, audio QR |
| 21 | Konsekutiv & modal: verbal ↔ nominal | fillBlank | Lesson unit | shared | 17 items | 1 | exists · add diagrams, audio QR |
| 22 | Adversativ: während, dagegen, im Gegensatz zu | fillBlank | Lesson unit | shared | 17 items | 2 | exists · add diagrams, audio QR |
| 23 | Hören: Fachinterview | listening | Listening unit | yes | 1 passage | 1 | NEW: task page + QR audio; transcript in the key |
| 24 | Subjektives sollen: Er soll reich sein | fillBlank | Lesson unit | shared | 15 items | 1 | exists · add diagrams, audio QR |
| 25 | Passiversatz: -bar, sich lassen, sein + zu | fillBlank | Lesson unit | shared | 15 items | 1 | exists · add diagrams, audio QR |
| 26 | Relativsätze mit wer, was, wo | fillBlank | Lesson unit | shared | 18 items | 1 | exists · add diagrams, audio QR |
| 27 | Indefinitpronomen | fillBlank | Lesson unit | shared | 17 items | 1 | exists · add diagrams, audio QR |
| 28 | Sprechen: Einräumen & widersprechen | speakRepeat | Speaking card | shared | 12 phrases | 1 | NEW: phrase list with QR audio + pronunciation tips |
| 29 | Lesen: Eine Buchrezension | reading | Reading unit | yes | 1 passage | 1 | exists · add diagrams |
| 30 | Lesen: Sprachbausteine | reading | Reading unit | yes | 1 passage | 1 | exists · add diagrams |
| 31 | Gespräch: Differenzieren | speaking | Conversation card | yes | — | 1 | NEW: printed prompt + QR to copy it + self-check boxes |
| 32 | Schreiben: Beschwerde mit Zugeständnis | writing | Writing page | yes | — | 1 | NEW: task + model text + ruled page + checklist |
| 33 | Relativsätze: dessen, deren und Präposition + Relativpronomen | fillBlank | Lesson unit | shared | 17 items | 2 | exists · add diagrams, audio QR |
| 34 | Futur I: Vermutungen über Gegenwart und Zukunft | fillBlank | Lesson unit | shared | 17 items | 1 | exists · add diagrams, audio QR |
| 35 | Konjunktiv II der Gegenwart: hätte, wäre, käme, würde | fillBlank | Lesson unit | shared | 18 items | 1 | exists · add diagrams, audio QR |
| 36 | Wortschatz | vocabulary | Picture dictionary | shared | — | 1 | NEW: deck by theme, 4–6 pages, with pictures |
| 37 | Suchbild: Die Öko-Wohnung | suchbild | Picture hunt | yes | — | 1 | NEW: full-page room + numbered label list |
| 38 | Suchbild: Das Labor | suchbild | Picture hunt | yes | — | 1 | NEW: full-page room + numbered label list |

### C1.1 — Abstrahieren (Abstract)

34 exercises, 22 already in the PDF today, 12 to add. Can-do: Move freely between verbal and nominal style; use passive substitutes in specialist text; Deploy the full system of adverbial clauses and their main-clause, subordinate and infinitive variants; Choose tenses deliberately in narrative and report (Präteritum, Perfekt, Plusquamperfekt, Futur); Use the written-language connectors, conjunctional adverbs and genitive prepositions of academic German; Build and unpack complex noun phrases: participial clauses, attribute chains, apposition; Understand lectures and academic texts in detail; place sentences in a text; solve a lexical-structural cloze; Present structured content and describe a graph.

| # | Exercise | Type | Book treatment | Own picture | Audio clips | Diagrams | Work |
|---|---|---|---|---|---|---|---|
| 1 | Bildung & Wissenschaft | fillBlank | Lesson unit | shared | 17 items | 2 | exists · add diagrams, audio QR |
| 2 | Nominalisierung | fillBlank | Lesson unit | yes | 17 items | 1 | exists · add diagrams, audio QR |
| 3 | Sprechen: Strukturiert darstellen | speakRepeat | Speaking card | shared | 12 phrases | 1 | NEW: phrase list with QR audio + pronunciation tips |
| 4 | Verbalisierung | fillBlank | Lesson unit | shared | 15 items | 2 | exists · add diagrams, audio QR |
| 5 | Tempuswahl in Erzählung und Bericht | fillBlank | Lesson unit | shared | 17 items | 1 | exists · add diagrams, audio QR |
| 6 | Passiversatz | fillBlank | Lesson unit | shared | 17 items | 2 | exists · add diagrams, audio QR |
| 7 | Großer Text: Hinweise zum neuen System | text work | Text-work unit | yes | — | 1 | exists · add diagrams |
| 8 | Hören: Vorlesung | listening | Listening unit | yes | 1 passage | 1 | NEW: task page + QR audio; transcript in the key |
| 9 | Adjektive auf -bar / -lich | fillBlank | Lesson unit | shared | 17 items | 1 | exists · add diagrams, audio QR |
| 10 | Kurzcheck: Nominalisierung | speaking | Conversation card | yes | — | 1 | NEW: printed prompt + QR to copy it + self-check boxes |
| 11 | Konnektoren (insofern/sofern/zumal/geschweige denn) | fillBlank | Lesson unit | shared | 17 items | 2 | exists · add diagrams, audio QR |
| 12 | Konjunktionaladverbien der Schriftsprache | fillBlank | Lesson unit | shared | 17 items | 1 | exists · add diagrams, audio QR |
| 13 | Adverbialsätze I: temporal, kausal, final, konditional | fillBlank | Lesson unit | shared | 17 items | 1 | exists · add diagrams, audio QR |
| 14 | Adverbialsätze II: konzessiv, konsekutiv, modal, adversativ, komparativ | fillBlank | Lesson unit | shared | 17 items | 1 | exists · add diagrams, audio QR |
| 15 | Genitivpräpositionen der Schriftsprache | fillBlank | Lesson unit | shared | 17 items | 1 | exists · add diagrams, audio QR |
| 16 | Adjektive mit Kasus & Nomen mit Präposition | fillBlank | Lesson unit | shared | 17 items | 1 | exists · add diagrams, audio QR |
| 17 | Lesen: Wissenschaft | reading | Reading unit | yes | 1 passage | 1 | exists · add diagrams |
| 18 | Lesen: Sätze einordnen | reading | Reading unit | yes | 1 passage | 1 | exists · add diagrams |
| 19 | Partizipialsätze | fillBlank | Lesson unit | yes | 17 items | 1 | exists · add diagrams, audio QR |
| 20 | Attribute: Genitiv, Präposition, Apposition, Ketten | fillBlank | Lesson unit | shared | 17 items | 1 | exists · add diagrams, audio QR |
| 21 | Diktat: Wissenschaftssprache | dictation | Dictation unit | shared | 12 sentences | 1 | NEW: QR per sentence + ruled lines; key |
| 22 | Sprechen: Eine Grafik beschreiben | speakRepeat | Speaking card | shared | 12 phrases | 2 | NEW: phrase list with QR audio + pronunciation tips |
| 23 | Hören: Diskussionsrunde | listening | Listening unit | yes | 1 passage | 1 | NEW: task page + QR audio; transcript in the key |
| 24 | Hören: Vortrag mit Detailfragen | listening | Listening unit | yes | 1 passage | 1 | NEW: task page + QR audio; transcript in the key |
| 25 | Lesen: Ein Essay | reading | Reading unit | yes | 1 passage | 1 | exists · add diagrams |
| 26 | Lesen: Sprachbausteine-Cloze | reading | Reading unit | yes | 1 passage | 1 | exists · add diagrams |
| 27 | Gespräch: Abstrahieren | speaking | Conversation card | yes | — | 1 | NEW: printed prompt + QR to copy it + self-check boxes |
| 28 | Schreiben: Zusammenfassung | writing | Writing page | yes | — | 1 | NEW: task + model text + ruled page + checklist |
| 29 | Erweiterte Partizipialattribute | fillBlank | Lesson unit | shared | 17 items | 2 | exists · add diagrams, audio QR |
| 30 | Zweiteilige Konnektoren | fillBlank | Lesson unit | shared | 17 items | 1 | exists · add diagrams, audio QR |
| 31 | Funktionsverbgefüge der Fachsprache | fillBlank | Lesson unit | shared | 17 items | 1 | exists · add diagrams, audio QR |
| 32 | Wortschatz | vocabulary | Picture dictionary | shared | — | 1 | NEW: deck by theme, 4–6 pages, with pictures |
| 33 | Suchbild: Das Krankenzimmer | suchbild | Picture hunt | yes | — | 1 | NEW: full-page room + numbered label list |
| 34 | Suchbild: Hinter der Bühne | suchbild | Picture hunt | yes | — | 1 | NEW: full-page room + numbered label list |

### C1.2 — Nuancieren (Nuance)

34 exercises, 22 already in the PDF today, 12 to add. Can-do: Use the full system of subjective modal verbs (supposition and hearsay) in present and past; Build and decode words with prefixes and suffixes, including separable/inseparable verb prefixes; Use idioms, advanced cohesion devices and formal Funktionsverbgefüge appropriately; Criticise and recommend retrospectively with the Konjunktiv II; use advanced relative clauses; Handle nouns with irregular number and gender-neutral references; shift register from informal to formal; Transform sentences: relative clause ↔ participial attribute, active ↔ passive ↔ substitute; Structure a talk, describe a graph, take a position; read literature and expert opinions; hear an interview for stimmt / stimmt nicht / nicht gesagt.

| # | Exercise | Type | Book treatment | Own picture | Audio clips | Diagrams | Work |
|---|---|---|---|---|---|---|---|
| 1 | Kultur & Medien | fillBlank | Lesson unit | shared | 15 items | 1 | exists · add diagrams, audio QR |
| 2 | Subjektive Modalverben: Vermutung | fillBlank | Lesson unit | shared | 15 items | 2 | exists · add diagrams, audio QR |
| 3 | Sprechen: Andeuten & abschwächen | speakRepeat | Speaking card | shared | 12 phrases | 1 | NEW: phrase list with QR audio + pronunciation tips |
| 4 | Konjunktiv II: Kritik & nachträgliche Empfehlung | fillBlank | Lesson unit | shared | 15 items | 2 | exists · add diagrams, audio QR |
| 5 | Relativsätze advanced | fillBlank | Lesson unit | shared | 15 items | 1 | exists · add diagrams, audio QR |
| 6 | Numerus-Besonderheiten & genderneutrale Bezeichnungen | fillBlank | Lesson unit | shared | 15 items | 2 | exists · add diagrams, audio QR |
| 7 | Subjektive Modalverben: Hörensagen | fillBlank | Lesson unit | yes | 15 items | 1 | exists · add diagrams, audio QR |
| 8 | Großer Text: Der geheimnisvolle Nachbar | text work | Text-work unit | yes | — | 2 | exists · add diagrams |
| 9 | Wortbildung: Vorsilben | fillBlank | Lesson unit | shared | 15 items | 2 | exists · add diagrams, audio QR |
| 10 | Hören: Reportage | listening | Listening unit | yes | 1 passage | 1 | NEW: task page + QR audio; transcript in the key |
| 11 | Hören: Interview — stimmt / stimmt nicht / nicht gesagt | listening | Listening unit | yes | 1 passage | 1 | NEW: task page + QR audio; transcript in the key |
| 12 | Wortbildung: Nachsilben | fillBlank | Lesson unit | shared | 15 items | 1 | exists · add diagrams, audio QR |
| 13 | Präfixe: trennbar oder untrennbar? | fillBlank | Lesson unit | shared | 15 items | 2 | exists · add diagrams, audio QR |
| 14 | Kurzcheck: Subjektive Modalverben | speaking | Conversation card | yes | — | 1 | NEW: printed prompt + QR to copy it + self-check boxes |
| 15 | Redewendungen | fillBlank | Lesson unit | yes | 15 items | 3 | exists · add diagrams, audio QR |
| 16 | Lesen: Eine Kolumne | reading | Reading unit | yes | 1 passage | 1 | exists · add diagrams |
| 17 | Lesen: Expertenmeinungen zuordnen | reading | Reading unit | yes | 1 passage | 1 | exists · add diagrams |
| 18 | Textkohäsion | fillBlank | Lesson unit | shared | 15 items | 1 | exists · add diagrams, audio QR |
| 19 | Redemittel: Vortrag, Grafik, Stellungnahme | fillBlank | Lesson unit | shared | 15 items | 2 | exists · add diagrams, audio QR |
| 20 | Umformulierung: Relativsatz ↔ Partizip, Aktiv ↔ Passiv | fillBlank | Lesson unit | shared | 15 items | 2 | exists · add diagrams, audio QR |
| 21 | Register: informell → formell | fillBlank | Lesson unit | shared | 15 items | 1 | exists · add diagrams, audio QR |
| 22 | Schreiben: Forumsbeitrag & formelle Beschwerde | fillBlank | Lesson unit | shared | 15 items | 1 | exists · add diagrams, audio QR |
| 23 | Diktat: Nuancen | dictation | Dictation unit | shared | 12 sentences | 1 | NEW: QR per sentence + ruled lines; key |
| 24 | Sprechen: Ironie & Betonung | speakRepeat | Speaking card | shared | 12 phrases | 1 | NEW: phrase list with QR audio + pronunciation tips |
| 25 | Hören: Hörspiel | listening | Listening unit | yes | 1 passage | 1 | NEW: task page + QR audio; transcript in the key |
| 26 | Lesen: Literarischer Text | reading | Reading unit | yes | 1 passage | 1 | exists · add diagrams |
| 27 | Gespräch: Nuancieren | speaking | Conversation card | yes | — | 1 | NEW: printed prompt + QR to copy it + self-check boxes |
| 28 | Konjunktiv I: indirekte Rede | fillBlank | Lesson unit | shared | 15 items | 2 | exists · add diagrams, audio QR |
| 29 | Modalpartikeln | fillBlank | Lesson unit | shared | 15 items | 2 | exists · add diagrams, audio QR |
| 30 | Schreiben: Bericht im Nominalstil | fillBlank | Lesson unit | shared | 15 items | 1 | exists · add diagrams, audio QR |
| 31 | Schreiben: Ein Forumsbeitrag | writing | Writing page | yes | — | 1 | NEW: task + model text + ruled page + checklist |
| 32 | Wortschatz | vocabulary | Picture dictionary | shared | — | 1 | NEW: deck by theme, 4–6 pages, with pictures |
| 33 | Suchbild: Die Redaktion | suchbild | Picture hunt | yes | — | 1 | NEW: full-page room + numbered label list |
| 34 | Suchbild: Der Flughafen | suchbild | Picture hunt | yes | — | 1 | NEW: full-page room + numbered label list |

### C2.1 — Stilsicherheit (Stylistic command)

30 exercises, 19 already in the PDF today, 11 to add. Can-do: Move between formal and colloquial register with precision; choose words by connotation and collocation; Recognise and use rhetorical devices, proverbs and journalistic Konjunktiv I; Command verb valency: cases, prepositional objects, double objects; Build and decode compounds and derived adjectives; use advanced comparison (relative superlatives, proportionality); Reformulate: nominal ↔ verbal, direct ↔ indirect, connector ↔ preposition; Grade and tone statements with Abtönungs- and Graduierungsmittel; Speak: hold a speech, moderate a discussion; read press and short fiction; hear features and satire.

| # | Exercise | Type | Book treatment | Own picture | Audio clips | Diagrams | Work |
|---|---|---|---|---|---|---|---|
| 1 | Wirtschaft & Recht | fillBlank | Lesson unit | shared | 19 items | 2 | exists · add diagrams, audio QR |
| 2 | Register: formell ↔ umgangssprachlich | fillBlank | Lesson unit | shared | 19 items | 2 | exists · add diagrams, audio QR |
| 3 | Sprechen: Eine Rede halten | speakRepeat | Speaking card | shared | 12 phrases | 1 | NEW: phrase list with QR audio + pronunciation tips |
| 4 | Kollokationen | fillBlank | Lesson unit | shared | 20 items | 1 | exists · add diagrams, audio QR |
| 5 | Valenz: Verben und ihre Ergänzungen | fillBlank | Lesson unit | shared | 19 items | 2 | exists · add diagrams, audio QR |
| 6 | Komposita bilden & verstehen | fillBlank | Lesson unit | shared | 19 items | 2 | exists · add diagrams, audio QR |
| 7 | Komparation advanced: einer der größten, bei weitem, je … umso | fillBlank | Lesson unit | shared | 18 items | 1 | exists · add diagrams, audio QR |
| 8 | Adjektivbildung: -haft, -mäßig, -artig, -fähig, -würdig, -gerecht | fillBlank | Lesson unit | shared | 20 items | 1 | exists · add diagrams, audio QR |
| 9 | Großer Text: Aus der Vorstandssitzung | text work | Text-work unit | yes | — | 1 | exists · add diagrams |
| 10 | Stilmittel & Rhetorik | fillBlank | Lesson unit | yes | 19 items | 1 | exists · add diagrams, audio QR |
| 11 | Hören: Feature | listening | Listening unit | yes | 1 passage | 1 | NEW: task page + QR audio; transcript in the key |
| 12 | Konjunktiv I (Journalismus) | fillBlank | Lesson unit | shared | 17 items | 1 | exists · add diagrams, audio QR |
| 13 | Umformulierung 2: direkt ↔ indirekt, Konnektor ↔ Präposition, Aktiv ↔ Passiv | fillBlank | Lesson unit | shared | 19 items | 1 | exists · add diagrams, audio QR |
| 14 | Kurzcheck: Register | speaking | Conversation card | yes | — | 1 | NEW: printed prompt + QR to copy it + self-check boxes |
| 15 | Konnotation & Wortwahl | fillBlank | Lesson unit | yes | 20 items | 1 | exists · add diagrams, audio QR |
| 16 | Abtönung & Graduierung: durchaus, keineswegs, geradezu | fillBlank | Lesson unit | shared | 17 items | 1 | exists · add diagrams, audio QR |
| 17 | Lesen: Zeitungsartikel | reading | Reading unit | yes | 1 passage | 1 | exists · add diagrams |
| 18 | Sprichwörter | fillBlank | Lesson unit | shared | 18 items | 2 | exists · add diagrams, audio QR |
| 19 | Diktat: Register & Stil | dictation | Dictation unit | shared | 12 sentences | 1 | NEW: QR per sentence + ruled lines; key |
| 20 | Sprechen: Moderieren | speakRepeat | Speaking card | shared | 12 phrases | 1 | NEW: phrase list with QR audio + pronunciation tips |
| 21 | Hören: Satire | listening | Listening unit | yes | 1 passage | 1 | NEW: task page + QR audio; transcript in the key |
| 22 | Lesen: Kurzgeschichte | reading | Reading unit | yes | 1 passage | 1 | exists · add diagrams |
| 23 | Gespräch: Stilsicherheit | speaking | Conversation card | yes | — | 1 | NEW: printed prompt + QR to copy it + self-check boxes |
| 24 | Schreiben: Zweimal dasselbe | writing | Writing page | yes | — | 1 | NEW: task + model text + ruled page + checklist |
| 25 | Konjunktiv II: Nuancen | fillBlank | Lesson unit | shared | 19 items | 2 | exists · add diagrams, audio QR |
| 26 | Konnektoren: indes, wiewohl, zumal, gleichwohl, mithin | fillBlank | Lesson unit | shared | 18 items | 1 | exists · add diagrams, audio QR |
| 27 | Präfixe: Bedeutung von ver-, zer-, er-, ent-, be-, über- | fillBlank | Lesson unit | shared | 20 items | 2 | exists · add diagrams, audio QR |
| 28 | Wortschatz | vocabulary | Picture dictionary | shared | — | 1 | NEW: deck by theme, 4–6 pages, with pictures |
| 29 | Suchbild: Die Tischlerei | suchbild | Picture hunt | yes | — | 1 | NEW: full-page room + numbered label list |
| 30 | Suchbild: Der Bauernhof | suchbild | Picture hunt | yes | — | 1 | NEW: full-page room + numbered label list |

### C2.2 — Meisterschaft (Mastery)

33 exercises, 22 already in the PDF today, 11 to add. Can-do: Control word order for focus and information structure; read and produce allusion, implicature and wordplay; Paraphrase with lexical and syntactic variation; write in academic register; Use the written-language prepositions and the full nominal style; read and translate official German; Handle appositions, the complete modal-verb system, and the full passive/substitute spectrum; Transform adverbial clauses across main-clause, subordinate and infinitive variants; Write a literary appraisal (review, interpretation) with the fixed Redemittel; read poetry; Speak: conduct a dispute, present an analysis; hear specialist lectures and readings.

| # | Exercise | Type | Book treatment | Own picture | Audio clips | Diagrams | Work |
|---|---|---|---|---|---|---|---|
| 1 | Philosophie & Gesellschaft | fillBlank | Lesson unit | shared | 19 items | 2 | exists · add diagrams, audio QR |
| 2 | Wortstellung & Fokus | fillBlank | Lesson unit | shared | 19 items | 2 | exists · add diagrams, audio QR |
| 3 | Sprechen: Streitgespräch | speakRepeat | Speaking card | shared | 12 phrases | 1 | NEW: phrase list with QR audio + pronunciation tips |
| 4 | Anspielungen & Implikatur | fillBlank | Lesson unit | yes | 18 items | 2 | exists · add diagrams, audio QR |
| 5 | Paraphrase & Variation | fillBlank | Lesson unit | shared | 19 items | 1 | exists · add diagrams, audio QR |
| 6 | Hören: Fachvortrag | listening | Listening unit | yes | 1 passage | 1 | NEW: task page + QR audio; transcript in the key |
| 7 | Wortspiel & Mehrdeutigkeit | fillBlank | Lesson unit | shared | 18 items | 1 | exists · add diagrams, audio QR |
| 8 | Kurzcheck: Andeutung & Ironie | speaking | Conversation card | yes | — | 1 | NEW: printed prompt + QR to copy it + self-check boxes |
| 9 | Lesen: Essay | reading | Reading unit | yes | 1 passage | 1 | exists · add diagrams |
| 10 | Wissenschaftssprache | fillBlank | Lesson unit | shared | 18 items | 2 | exists · add diagrams, audio QR |
| 11 | Präpositionen der Schriftsprache | fillBlank | Lesson unit | shared | 20 items | 1 | exists · add diagrams, audio QR |
| 12 | Nominalstil: verdichten und auflösen | fillBlank | Lesson unit | shared | 20 items | 2 | exists · add diagrams, audio QR |
| 13 | Behördensprache: Amtsdeutsch übersetzen | fillBlank | Lesson unit | yes | 19 items | 2 | exists · add diagrams, audio QR |
| 14 | Lesen: Ein amtliches Schreiben | reading | Reading unit | yes | 1 passage | 1 | exists · add diagrams |
| 15 | Appositionen: Kasus, Komma, Titel | fillBlank | Lesson unit | shared | 20 items | 1 | exists · add diagrams, audio QR |
| 16 | Modalverben — das ganze System | fillBlank | Lesson unit | shared | 21 items | 2 | exists · add diagrams, audio QR |
| 17 | Vorgangs-, Zustandspassiv, Passiversatz — Meisterschaft | fillBlank | Lesson unit | shared | 20 items | 1 | exists · add diagrams, audio QR |
| 18 | Adverbialsätze: Hauptsatz / Nebensatz / Infinitiv umformen | fillBlank | Lesson unit | shared | 21 items | 1 | exists · add diagrams, audio QR |
| 19 | Großer Text: Zum Wert des Lesens | text work | Text-work unit | yes | — | 1 | exists · add diagrams |
| 20 | Hören: Literarische Lesung | listening | Listening unit | yes | 1 passage | 1 | NEW: task page + QR audio; transcript in the key |
| 21 | Sprechen: Eine Analyse vortragen | speakRepeat | Speaking card | shared | 12 phrases | 1 | NEW: phrase list with QR audio + pronunciation tips |
| 22 | Rezension & Interpretation: Redemittel | fillBlank | Lesson unit | shared | 20 items | 1 | exists · add diagrams, audio QR |
| 23 | Hören: Podiumsdiskussion (Capstone) | listening | Listening unit | yes | 1 passage | 1 | NEW: task page + QR audio; transcript in the key |
| 24 | Lesen: Literatur & Deutung (Capstone) | reading | Reading unit | yes | 1 passage | 1 | exists · add diagrams |
| 25 | Lesen: Lyrik (Ringelnatz, Morgenstern) | reading | Reading unit | yes | 1 passage | 1 | exists · add diagrams |
| 26 | Gespräch: Meisterschaft | speaking | Conversation card | yes | — | 1 | NEW: printed prompt + QR to copy it + self-check boxes |
| 27 | Schreiben: Erörterung | writing | Writing page | yes | — | 1 | NEW: task + model text + ruled page + checklist |
| 28 | Redewendungen | fillBlank | Lesson unit | shared | 16 items | 2 | exists · add diagrams, audio QR |
| 29 | Fremdwörter und Latinismen | fillBlank | Lesson unit | shared | 18 items | 1 | exists · add diagrams, audio QR |
| 30 | Deutsch in Österreich und der Schweiz | fillBlank | Lesson unit | shared | 21 items | 1 | exists · add diagrams, audio QR |
| 31 | Wortschatz | vocabulary | Picture dictionary | shared | — | 1 | NEW: deck by theme, 4–6 pages, with pictures |
| 32 | Suchbild: Der Antiquitätenladen | suchbild | Picture hunt | yes | — | 1 | NEW: full-page room + numbered label list |
| 33 | Suchbild: Der Hafen | suchbild | Picture hunt | yes | — | 1 | NEW: full-page room + numbered label list |
