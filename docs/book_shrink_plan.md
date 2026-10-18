# Deutsch A1 at 180 pages, US Letter: the shrink plan

Written 2026-10-18. The A1 book prints at 300 pages A4 (`static/books/manifest.json`,
version 2.0.0). The target is **180 pages at US Letter (8.5 × 11 in)**. This
plan lists where the pages come from, in the order the work should be done,
with the expected saving of each step so the build can be checked against it
after every step.

Rule of the book: **a new page only for the title pages, the part openers, the
chapter openers (the ones with a photograph) and the back-matter sections.**
Everything else flows.

**Done 2026-10-18: 161 pages at Letter** (first pass landed at 154, then the
body type, the inline cheat-sheet tables, the 3-column index and the chapter
photos were given room back). The unit component takes a `compact` prop that
the book route sets; the web workbook is untouched. `python tool/book-fill.py`
measures a build.

## Why Letter

KDP's Expanded Distribution chart lists the trim sizes eligible per ink and
paper. 8.5 × 11 in is "Yes" for premium colour on white paper and for Expanded
Distribution; A4 (8.27 × 11.69 in) is not in the chart at all, and 8.25 × 11 in
is "No" in every column. So the book must be Letter to be sold through the
wider channels.

Letter vs A4: 215.9 × 279.4 mm against 210 × 297 mm. The page is 6 mm wider
and 18 mm shorter, about 4 % less area. With the same margins the text block
goes from 180 × 263 mm to 186 × 245 mm, so every page holds ~3 % less; the
plan below needs 180 pages after that loss, which means it must reach ~174
A4-equivalent pages.

## Where the 300 pages go today

| Block | Pages | Notes |
|---|---|---|
| Front matter | 9 | half-title, title, copyright, about, how-to, "did it on paper", contents 3 pp |
| Part openers | 2 | one full page each |
| Chapter openers | ~11 | full page: photo, text, unit list |
| Grammar / reading / text-work units | ~200 | 3–4 pages each, every one starts a new page |
| Pages holding only an upside-down answer strip | 9 | the strip spilled by one line (e.g. pp. 43, 82) |
| White space before the next unit | ~34 | measured with PyMuPDF, orphan pages included |
| Vocabulary units (picture dictionary) | 24 | 12 pages each; picture cards stretch whole rows |
| Picture hunts | 8 | room page + a word-card page that is 40 % empty |
| Challenge pages | 2 | |
| Back matter | 13 | key 5, tables 1, index 5, credits 1, audio 1 |

Measured with: render the PDF, take the lowest text or image box on each page
between 5 % and 95 % of the page height, and sum `1 - fill` on the page before
each `UNIT` heading. Keep that as `tool/book-fill.mjs` (or the Python one-off)
and run it after each step below.

## The steps, in order

Savings are estimates from the proof pages; the running total is what the
build should show after each step, already at Letter.

### 0. Letter page (+9 → 309)

Files: [+page.svelte](../src/routes/course/[courseId]/book/[bookId]/+page.svelte)
line 15, [tool/gen-books.mjs](../tool/gen-books.mjs), the cover route.

- `@page { size: 8.5in 11in; margin: 14mm 13mm 16mm 13mm }`, mirrored
  `:left` / `:right` with the 20 mm gutter as now (gutter 0.5 in applies up to
  300 pages, 0.375 in up to 150; 180 pages keeps 0.5 in = 12.7 mm minimum, so
  the 20 mm can drop to 16 mm, which wins back part of the lost area).
- `tool/gen-books.mjs`: the Chrome print call must pass
  `paperWidth: 8.5, paperHeight: 11` instead of A4, and the proof renderer
  nothing (it reads the PDF size).
- Cover: `widthMm = 2 × 215.9 + spine + 2 × 3.175` bleed, `heightMm = 279.4 + 6.35`;
  spine = pages × 0.002252 in (KDP, white paper). The cover page has to recompute from the manifest.
- `.sheet.advert` fixed height 263 mm → 245 mm; `.half-title`, `.title-page`,
  `.copyright`, `.part-opener` `min-height` 250 mm → 232 mm.
- The picture-hunt rooms need ≥ 87 mm width for 300 dpi; the 186 mm measure
  has room.

### 1. Units flow; no orphan strips (−35 → 274)

File: `+page.svelte` `@media print`.

- Remove `break-before: page` from `.unit-sheet`. Keep it on `.title-page`,
  `.part-opener`, `.chapter`, `.how`, and the back-matter sections.
- Keep the unit head glued to its first rule: `.head` already has
  `break-after: avoid`; add `break-inside: avoid` to the first `.rule`.
- Orphan answer strips: wrap the last practice list and `footer.answers` in one
  block with `break-inside: avoid`, or put `break-before: avoid` on
  `.answers`. If Chrome still splits, drop the strip's `margin-top` from 4 mm
  to 2 mm; an upside-down strip at the top of the next page is acceptable.
- Between two units a 6 mm gap and the 2.2 mm accent rule of `.head` is enough
  of a separator.

### 2. Typography of the unit (−48 → 226)

File: [WorkbookUnit.svelte](../src/lib/components/workbook/WorkbookUnit.svelte).
Put these under `@media print` (or a `print` prop) so the on-screen workbook
keeps its sizes; the same component renders `/course/.../workbook/<level>`.

| What | Now | Print | Why |
|---|---|---|---|
| `.unit` gap / line-height / size | 4.2 mm / 1.45 / 10 pt | 3 mm / 1.32 / 9.5 pt | base rhythm |
| `.hook` | 19 pt, full width | 14 pt | the hook runs three lines today |
| `.head` | title, hook, QR, intro stacked | two columns: hook + title left, QR + intro right (`1fr 62mm`) | head drops from ~70 mm to ~40 mm |
| `.examples li` | one box per example, `.de` 11.5 pt over `.en` 8.5 pt | German and English on one line (`.en` inline, muted, after a middle dot); padding 1.2 mm 2.5 mm; `.de` 10.5 pt | each example halves |
| `.examples` | one column | 2 columns when the rule has 2+ examples and every `de` is under ~60 chars (decide in the component) | A1 examples are short |
| `.trap` | 9 pt box | 8.5 pt, 1.2 mm padding | |
| `h4` (rule title) | 12.5 pt | 11 pt | |
| `.rule > * + *` | 1.6 mm | 1.1 mm | |
| `.intro` | 9.5 pt / 1.55 | 9 pt / 1.4 | |
| `.words` cards | 4 columns, bordered cards | 6 columns, 1.2 mm padding, `.w-de` 10 pt; **≤ 8 words and no pictures: one wrapped line** `der Tisch · table · -e` | Words block ~45 mm → ~15 mm |
| `.checks` | 2 columns, 3.5 mm 6 mm gap | 2.5 mm 5 mm gap; `.q[lang=de]` 10 pt | |
| `.cheat` | bullets + table | keep; `td` padding 0.6 mm 1.5 mm, 8.2 pt; **if the table is in the grammar appendix, print only the bullets** | tables print twice today |
| Practise `.cloze` | 2 columns, 11 pt | 2.5 mm 5 mm gap, `.sentence` 10 pt / 1.45 | |

Check for overflow with the proof PNGs: long compounds in 6-column word
cards, and two-column examples with a `mark` near the edge.

### 3. Diagrams (−5 → 221)

Lesson diagrams stay, capped: `.visual { max-height: 70mm }`; when a rule has
two small visuals (flow, table, pills) put them side by side. Wide bracket
diagrams keep one column.

### 4. Picture dictionary (−14 → 207)

Unit kind `vocabulary`, markup around line 414 of `WorkbookUnit.svelte`.

- Today a picture card is ~35 mm tall and stretches the whole grid row
  (p. 128: four text cards stand 35 mm tall for one picture).
- Print **text cards only, 6 columns, 2 lines each**, grouped by unit as now,
  and put the pictures in a separate "In pictures" grid at the end of the unit:
  8 per row, 22 mm wide, caption under each, only for words with a picture.
- Group headings 9.5 pt, 2.5 mm above, 1 mm below.
- Expected: 12 pages → 5 per part.

### 5. Picture hunts (−4 → 203)

Unit kind `suchbild`, markup around line 404.

- Room picture: keep at full measure (≥ 87 mm for 300 dpi).
- The word page (p. 138) is the same stretched grid: print the spot list
  **under the picture** as 6 text columns without pictures, `.ruled` answer
  line 5 mm.
- Expected: 2 pages → 1 per hunt.

### 6. Back matter (−4 → 199)

- Word index: 3 columns 9 pt → 4 columns 7.8 pt, line-height 1.3. 5 pages → 3.
- Key: 2 columns at 8.5 pt, `break-inside: avoid` per entry. 5 → 4.
- Credits and audio index on one page if the audio list fits 2 columns at 7.5 pt.

### 7. Front matter (−3 → 196)

- "About this project" and "Did it on paper?" as two columns on the back of
  the how-to page, which is half empty.
- Contents + tracker 3 pages → 2: 8.5 pt, 1 mm row padding, no chapter thumbnails.

### 8. Chapter openers (−6 → 190)

They keep their new page, but not a full one: on p. 121 the photo is 100 mm
tall and the page ends at 72 %. Photo `height: 65mm; object-fit: cover`, and
the chapter's first unit **starts on the same page** under "In this chapter".
`.chapter` keeps `break-before: page`; the unit after it gets none. If the
opener must stay a page of its own for looks, skip this and go to 9 pt body
text in step 2 instead.

### 9. Head and part-head trims (−5 → 185)

- `.head` top padding 4 mm → 2.5 mm, accent rule 2.2 mm → 1.6 mm.
- `h3.part` ("1 Learn" …): 13 pt → 11 pt, circle 5.4 mm → 4.6 mm, gap above
  4.2 mm → 2.5 mm. Four per unit × 66 units is a page of air per ten units.
- Listening and dictation `.ruled` pitch 8 mm → 7 mm; writing page 16 lines → 14.

### 10. The last five (−5 → 180)

Take them from the gutter: 20 mm → 16 mm inside margin (KDP minimum for
151–300 pages is 12.7 mm) widens the measure to 190 mm, which the 2-column
blocks turn into fewer lines. If the build lands at 182–185 after step 9,
this alone closes it; if it lands under 180, put the gutter back.

## Order of work and checks

1. Step 0 first and alone: one build, confirm the page size, cover dimensions
   and that nothing overflows the shorter page (the advert page, the openers).
2. Steps 1, 2, 9 together: CSS in two files, ~90 pages. Build, run the fill
   script, open the proof PNGs for a grammar unit with a diagram (1.2), a
   reading unit (1.10), a listening unit (1.7).
3. Steps 4, 5: the two unit kinds with their own markup. Build, check the
   dictionary and hunt pages.
4. Steps 3, 6, 7: small, independent.
5. Steps 8 and 10 last, after looking at the result; both are taste calls.

Do not rebuild per change: one `npm run books` for A1 after each group above,
then the fill script. Five to six builds in all.

## What this does to KDP

- Trim 8.5 × 11 in, premium colour, white paper, no bleed inside; cover with
  0.125 in bleed.
- Gutter band 151–300 pages: inside margin ≥ 0.5 in. Outside margins ≥ 0.25 in.
- Spine: pages × 0.002252 in (KDP, white paper); the cover reads the manifest.
- Print cost at premium colour: about 1.00 + 180 × 0.07 ≈ 13.60 € (was ≈ 22 €
  at 300). Confirm on KDP's pricing page on the day of upload.

## Things not to do

- Do not drop the diagrams, the hook lines or the English glosses on the
  practice items; they are the course's character.
- Do not go below 9 pt for anything read in German, or below 7.5 pt for the
  English glosses; the answer strip at 7.6 pt is at the floor.
- Do not print units in two full-page columns: rule cards, tables and
  diagrams are built for a ~185 mm measure and would overflow.
- Do not shrink the picture-hunt rooms below 87 mm wide (300 dpi).
