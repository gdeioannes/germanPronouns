# Rights audit: books and site

Goal: every picture, text and sound in the twelve books and on the site may be used
commercially (KDP paperbacks, a paid app later), every credit the licences ask for is
given, and nothing is copied from a source we have no right to use.

This file is the evidence register. It does not replace a lawyer: before the books are
sold, a lawyer for German copyright and media law should review the open points below.
Last full pass: 2026-11-18.

## The zero-doubt rule

When anything is unclear, the thing is replaced, not argued for.

- Photos: only CC0, public domain, CC BY and CC BY-SA (any version). Nothing with NC
  (non-commercial), ND (no changes), GFDL-only or "fair use".
- People: a photo with an identifiable private person as its subject is replaced, unless
  the person is incidental in a crowd or at a public event (KUG §23). Commons' own
  "personality rights" warning means replace.
- Artworks, posters, designed documents: replaced unless they are public domain, an
  official work (§5 UrhG), or a permanent work on a public street (freedom of panorama,
  §59 UrhG, which covers commercial use: BGH I ZR 247/15, 2017).
- Authors who add conditions or pressure beyond the licence: replaced.
- An author Commons cannot name, on a licence that requires naming the author: replaced,
  unless the uploader names themselves in the description (then credited to them).
- Texts: literature only from authors dead for more than 70 years; anything else only as
  a short quote with its source, or as a paraphrase.
- Brands and exam providers: mentioned in running text only; never on a cover, in a
  title, or as a picture's main subject.

## How it is checked

| Check | Where | Status |
|---|---|---|
| Every shipped picture traced to its source | `tool/rights-audit.mjs`, `src/lib/domain/rights.test.ts` | done: 0 unknown |
| Photo licences on the allow list | same | done: 669 credits, all allowed |
| Licences match what Wikimedia Commons publishes | `tool/commons-verify.mjs` → `assets/rights/commons.json` | done: 669 of 669 match, re-read 2026-11-18 |
| Credits as the licences ask (author as they want, licence + link, file, "modified") | `src/lib/domain/credits.ts`, `credits.test.ts` | done; books reprinted |
| Rejected photos no longer used | `rights.test.ts` | done: 43 replaced, test green |
| Every photo looked at (people, documents, artworks, brands, symbols) | manual, contact sheets of all photos | done 2026-11-18 |
| Print resolution of every picture | `tool/print-dpi.mjs` → `docs/rights/print-dpi-*.json`; `tool/upscale-print.mjs` | done (see below) |
| Texts not copied | manual sampling, web search of sample sentences | done: no match |
| Word data origin | `tool/build-dictionary.mjs` | done: own data |
| Literature and quotes | manual search of every author name in the content | done |
| Imprint in the printed books | `Book2.svelte` (last page), `src/lib/operator.ts` | in place; **address still missing** |

## Pictures: where they come from

- **Wikimedia Commons photos**: 669 credits. Licences: CC BY-SA 4.0 (297), CC BY-SA 3.0
  (143), CC BY-SA 2.0/2.5 (13), CC BY 2.0–4.0 (86), CC0 (54), public domain (76).
  All re-read from Commons on 2026-11-18; all match. 93 authors ask for a specific
  credit text; we print exactly that text. None carries a Commons restriction any more.
- **AI pictures**: about 1,800 files made with Google's Gemini image model from the
  prompts in `assets/images/*manifest.json`. Google's terms allow commercial use of the
  output. AI output cannot be copyrighted, so others may copy these pictures; KDP
  requires AI-generated images to be declared.
- **Our own**: logo, icons, share cards drawn in code, app screenshots, covers composed
  from credited photos, and seven documents typeset for the books
  (`tool/make-documents.mjs`), listed in `assets/rights/own.json`.

## Decisions on photos (`assets/rights/review.json`)

Every one of the photos was looked at on contact sheets. 43 were replaced (the new
photo keeps the id, and its caption was rewritten where it no longer fitted):

- Commons marks personality rights (7): b2b11_verein_fahne, b2b21_interview_mikro,
  b2c12_stammtisch_b, b2c21_bauernhof_b, b2c21_talkshow_b, quest_a2_2_lesen_tracht,
  quest_b1_1_lesen_verein.
- The author adds pressure beyond the licence (3, C.Suthorn): b2a12_bahn_hbf,
  b2a22_maerchen_statue, b2a22_maerchen_spiel.
- No author on a licence that requires one (1): b2b21_gericht_karlsruhe.
- Identifiable people as the main subject (17): b2b11_silvester_feger, b2b12_technik_mann,
  b2b21_interview_kamera, b2b21_interview_opener, b2b21_homeoffice_tisch,
  b2b21_homeoffice_opener, b2b22_tausch_opener, b2c12_literatur_a, b2c12_literatur_opener,
  b2c12_kabarett_b, b2c21_talkshow_opener, b2c22_schlagloch_b, b2c22_streit_a,
  b2c22_streit_b, b2c22_wien_opener, quest_b1_1_hoeren_elternzeit, quest_b1_1_hoeren_urlaub;
  and b2b12_hochzeit_opener (a private wedding, a child facing the camera; also the
  home page photo, now regenerated).
- Third-party works as the main subject (posters, front pages, artworks, a book cover, a
  brand, museum panels) (8): b2b21_buergerinitiative_sign, b2b21_nachrichten_stand,
  b2b22_buchmesse_stand, quest_b1_2_hoeren_mp3, quest_c1_1_lesen_duden,
  b2c11_karlsruhe_schild, b2a12_tag_bsr, and the documents below.
- Documents (7), now typeset by us with made-up people and firms
  (`tool/make-documents.mjs`; the exercises were kept or rewritten to match):
  b2a12_woche_plan (a printed product design), b2a22_verabredung_kino (a 1993 magazine
  page), b2b11_bewerbung_anzeige (an advert with a drawn portrait), b2b12_abschied_cv (a
  real person's CV), b2b21_interview_plakat (a campaign poster), b2b22_forschung_zettel (a
  private flyer with contact data), b2c22_anspielung_doc (a 1945 leaflet whose author's
  death date is unknown; the C2.2 chapter now reads a coded job reference instead).

Kept after checking (14), each with its reason in `review.json`: the East Side Gallery and
Wall graffiti photos (freedom of panorama), b2b12_technik_fluid (Wellcome Collection, as
it asks), b2c21_talkshow_doc (a 1924 anonymous magazine, public domain; the scan credited
to Maximilian Schönherr, who names himself), the 1958 naturalisation certificate and the
1949 form (official documents), Einstein 1921 and a 1965 broadcasting archive photo (public
domain), crowds at public events, and b2c22_knoellchen_doc (an official envelope; Commons
had only weakly blurred the recipient, so our copy prints the sample name "Max Mustermann"
and a made-up file number in their place).

## Credits: what was wrong and what changed

- The book's credits page printed title, scraped author name and licence, without the
  licence link, the file and the note that our copy is modified (CC requires both), and
  some author fields held Commons signatures. Now every line comes from Commons' own
  data: `Author, CC BY-SA 4.0 (creativecommons.org/licenses/by-sa/4.0), via Wikimedia
  Commons, commons.wikimedia.org/?curid=…, modified`.
- The site had photos without credit; it also only credited "author, licence" on deck
  cards and the home page. Every photo now shows a short credit, and /credits lists every
  photo's full credit (linked from the footer and from each short credit).
- The books and /credits say the word pictures are made with AI (Google Gemini) and the
  texts with AI help (Anthropic Claude).

## Texts

- The reading and listening texts, dialogues and exercises are written for this project.
  Sample sentences from six levels were searched on the web on 2026-11-18: no source
  contains them.
- Literature: only names, summaries and paraphrases of authors still protected (Arendt,
  Böll, Bachmann, Dürrenmatt, Borchert). Quoted text comes only from authors dead for
  more than 70 years (Kafka, Grimm, Luther, Heine, Ringelnatz, Morgenstern, Tucholsky).
  Proverbs are traditional.
- Exam providers: their public syllabus documents were used as a reference for which
  topics and grammar belong to which level. No word list, model exam or task was copied;
  the vocabulary is grouped by our own themes and chapters.

## Word data

The tap-a-word dictionary and the noun and verb collections are this project's own data
(`tool/build-dictionary.mjs`): 759 nouns and 166 verbs with meanings written per course,
plus a hand-written core of function words, grown from what the content actually uses. No
dictionary database (dict.cc, Wiktionary, Duden, PONS) was imported.

## Print resolution (KDP interior)

Measured with `tool/print-dpi.mjs all --print`. The chapter-opening panoramas print over
two pages (453 mm wide), where even Commons' full-size originals give 78–200 dpi.
`tool/upscale-print.mjs --below 200` enlarged every picture under 200 dpi with
Real-ESRGAN (local, BSD licence) to the size 300 dpi needs, at most 4×. The originals
are kept in `static/img/photo/orig/` (gitignored). Upscaling adds no rights question: it
is a modification, which the CC licences allow and the credit already says ("modified").
Result (re-measured 2026-11-18): before, 172 placements printed under 200 dpi; after, none.
83 pictures were enlarged, 28 of them with Real-ESRGAN (under 150 dpi), the rest with
Lanczos; the Real-ESRGAN ones were checked at print size for distorted faces (none).

## The printed book for KDP

- Interior: A4 (8.27 × 11.69 in) with KDP's 0.125 in bleed (`tool/kdp-bleed.mjs`); cover
  with the same bleed and a spine for the page count (`tool/gen-book2.mjs --cover`).
- The last page carries an imprint: copyright, publisher with address, how the texts and
  pictures were made, that documents and people in them are made up, and that the
  project is not connected with any exam provider.
- `tool/kdp-package.mjs` builds `kdp/`: one folder per book with interior.pdf, cover.pdf
  and listing.txt (every KDP field, including the AI disclosure).

## Open points for the lawyer and for GDI

- **Publisher address**: the imprint on the site and in the books still has no postal
  address (`src/lib/operator.ts`). German law requires it on a commercial site (§5 DDG)
  and in printed books (Landespressegesetze). KDP files are built only as drafts until it
  is filled in.
- Confirm the AI declarations for KDP (texts written with Anthropic's Claude; word
  pictures with Google's Gemini).
- Confirm that CC BY-SA photos in a sold book are fine with the credit form above (the
  book itself is not under CC BY-SA; only the photos keep their licence).
- Confirm that the typeset documents that echo real ones (a cinema listing with real
  Freiburg cinema names and film titles, a Bochum vote in 2008 with a made-up school)
  are unproblematic.
