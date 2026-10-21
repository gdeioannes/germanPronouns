# Study companion: design guide

The rules every level's printed study companion follows (A1.1 first, A1.2 next,
then the rest). When a decision is made while writing one book, it goes here,
and the books already written get it too.

Content: `assets/content/companion/<course>/<level>.json`.
Model: `src/lib/domain/companion.ts`. Pages: `src/lib/components/companion/`.
Guard test: `src/lib/domain/companion.test.ts`. Rules marked **(tested)** fail the test when broken.

## The book

- **A4, one topic per spread:** the left page teaches, the right page is written on. Reviews come after
  roughly every 6–7 topics. Then the "at a glance" page, the picture dictionary, and the answers.
- **Each book carries on from the one before it.** Words an earlier level's book taught count as known,
  so A1.2 doesn't teach *Tisch* again **(tested)**. Where a topic builds on an earlier rule, a short
  reminder brings it back (for example, mein + *-en* recalls *einen*).
- **Every spread fits its page.** Check before printing, in print media, never by the screen view (the
  screen view can look crowded when the print is fine).

## Teaching

- **Teach before asking.** Every German word an exercise shows must be on a learn page by then: this
  spread's, an earlier spread's, or an earlier book's **(tested)**. If a topic needs extra words, add a
  "Words for the practice page" block. If they don't fit, split the topic into two spreads.
- **A schema beats a paragraph.** Before writing a tip box, ask whether a diagram says it faster. Use a
  block from the catalogue below, and add a new kind when none fits.
- **Check every topic page for a diagram before a book is finished.** The test lists the topic pages
  without one (it prints, it doesn't fail). Each one on that list must be a deliberate choice: an
  irregular table or a page of vocabulary can be right without one.
- **Teach with the pictures you test with.** When a practice exercise asks about pictures (positions,
  weather), the learn page shows them first, labelled (`pictures`). The practice page then asks with
  a different picture, such as the topic picture, so the reader can't just copy.
- **Gender colours, always.** der is blue, die red, das green, plural grey, the same as the app. Every
  table with der, die and das columns sets `genders: true` **(tested)**. The article word stays printed,
  so the page still reads in black and white.
- **Fun, not textbook.** Example sentences get a small twist (the dog has the umbrella, the cat sits on
  the phone). The grammar stays plain.
- **No answer in the label.** A cue gives the clue (the subject *ich*, an English word), never the
  answer.

## Schema catalogue

| Block | Use it for | Example |
|---|---|---|
| `slots` | Word order: the verb in second place, *nicht* at the end, the two-part verb bracket. `hot` frames the verb (a column, or one cell). | `Wo · wohnst · du?` |
| `arrow` | Who does what to whom, with *wer?* and *wen?* (and later *wem?*) on the two ends. | `Lena —sieht→ den Hund` |
| `flow` | A real either/or choice the reader keeps getting wrong. | kein or nicht? · du or Sie? · haben or sein? |
| `merge` | One word made from two inputs. | owner *ihr* + thing *-e* = *ihre Tasche* |
| `build` | Words glued from parts: endings, contractions, compounds, numbers. | k + ein = kein · in + dem = im |
| `pictures` | Labelled pictures that teach by showing: where the cat is, what the weather does. | *auf dem Korb* under a cat on a basket |
| `timeline` | seit, vor, in, für: a dot or a bar on a line with now in the middle. | vor zwei Jahren · seit zwei Jahren |
| `clock` | Telling the time: faces with hands plus the German. `dial` adds the guide (nach right, vor left, halb at the bottom). Also good for "a day in the life" with times. | 09:30 = halb zehn |
| `flip` | Numbers read right to left. | 47 = sieben-und-vierzig |
| `tree` | Family. | |
| `tiles` | A small set to learn by heart (numbers, question words, colours). | |
| `table` | Forms side by side, the yes → no mirror. | |
| `pairs` | A short "this → that" list. | der Schlüssel → ihn |
| `box` | What no schema can say: culture, a trap, a memory trick. | |

The *focus* and **bold** marks render in tables, boxes, notes, slots, arrows, flows, merges and clocks. They
don't render in `words` items or in the hook line, so don't use them there.

## Exercises

- **Paper only:** write, match, circle, sort, colour, fill gaps, label pictures (`tags`), read or draw
  clock hands (`clocks`), and listen with a QR code. No app wording such as tap, type or swipe **(tested)**.
- A Listen exercise is written from the quiz's transcript (`passage` in the course file), so the notes
  match what the reader hears.
- **Every exercise has its answer** in the key at the back **(tested)**.
- When a spread has a picture, at least one exercise should use what the picture shows. Write the
  exercise from the finished picture, not from the prompt.
- End each practice page with an "about you" exercise when there's room, and 3–4 *I can* lines.

## Pictures

- **Default:** Gemini, drawn from a companion manifest (`assets/images/companion*_manifest.json`) in the
  shared picture-book style, transparent and trimmed:
  `node tool/gen-images.mjs --manifest <file> --no-link`.
  Ask for a small joke in each scene. Gemini can't draw German finger counting, and it can't draw text.
- **Public-domain and CC photos (Wikimedia Commons) are always an option** when a real photo beats a
  drawing: a station board, a market, a city. Credit them in the book's `credits` with author and
  licence, the way the printed book does in `assets/content/chapters/de_cert_a1/_photos.json`.
- **The picture dictionary is drawn fresh** for each book, in the same study-book style (GDI,
  2026-10-21: the app's word-card pictures are not usable on paper). One plain object per word,
  ids `cpd_<word>`, shared between books, so a word drawn once is reused later.
- Every picture a book prints must be on disk, and the credits can't be empty **(tested)**.

## Rights

- No exam brand names anywhere (Goethe, telc, ÖSD, TestDaF) **(tested)**.
- QR codes only use codes already registered in `assets/content/booklinks.json` for real quizzes
  **(tested)**.

## Making a level

1. Plan the topics from the level's quizzes, grouping quizzes that share a rule.
2. Write the content with a script file kept in `tool/companion/` (A1.2: `tool/companion/a1_2.py`),
   batch by batch. Shell heredocs break on quotes in this environment.
3. Run `npx vitest run src/lib/domain/companion.test.ts`, then check fit in print media.
4. Preview at `/course/<course>/workbook/<level>?preview`.
5. Draw the pictures, then check them and adjust the exercises to what was drawn.
6. Add the level to `READY_WORKBOOKS` in `src/lib/domain/workbook.ts`, then print:
   `node tool/gen-workbooks.mjs --url http://localhost:5173 <level>`.
