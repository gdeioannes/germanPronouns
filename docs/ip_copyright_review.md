# IP / Copyright Content Review

*Reviewed 2026-07-07. Scope: all shipped content (`assets/content/`, `assets/seed/`,
`assets/icons/`), authored course data in `lib/data/`, visual assets, fonts,
web files, and third-party dependencies. This is an engineering review, not
legal advice.*

## Summary

No copied copyrighted text, artwork, audio, or code was found. All reading /
listening passages appear originally authored, all room/furniture art is drawn
programmatically in code, fonts and packages are permissively licensed, and no
secrets are committed. The findings below are **trademark hygiene** items
(exam brands in course names) and a few **verify / best-practice** items — none
is an identified violation.

---

## 1. Course text content — CLEAR

Checked every course bundle for long passages, lyrics, poems, quotes, and
tell-tale attribution markers.

- **Passages are originally authored.** Recurring invented characters
  (Tāngmǔ/Tom, Xiǎoměi, "Mio the monster"), original editorials, flash
  fiction, debates and book reviews. Longest string in any bundle is
  1,665 chars — magazine-blurb length, consistent with in-house authoring,
  not textbook extraction.
- **No song lyrics.** Every "Lied/canción" hit is the vocabulary word *song*.
- **Only two literary quotes, both safe:**
  - Dickens, *"It was the best of times…"* (1859) — public domain
    (`zh_en.json`, "The perfect opening line").
  - The six-word story *"For sale: baby shoes, never worn"* — apocryphally
    attributed to Hemingway, of unknown authorship, and too short for
    copyright protection (`zh_en.json`, "The power of the unsaid").
- **German Sprichwörter** (de_cert_a1) — traditional folk proverbs, public
  domain.
- **Real-book mention:** de_es contains an original review of *La sombra del
  viento* (Carlos Ruiz Zafón). Naming a book and summarising its plot in your
  own words is not infringement; the review text is original.
- **Real people** (García Márquez, Cervantes, Merkel/Macron in the Czech
  »-ová« grammar note) — factual, nominative mentions in example sentences.
  Fine.
- Fictional book title "China at the Midnight Diner" alludes to *Midnight
  Diner* (深夜食堂). Titles are not copyrightable; negligible risk.

## 2. Trademarks — ACTION RECOMMENDED

### 2.1 "HSK" in a course *name* (medium priority)

`catalog.json` / `course_catalog.dart`: course name **"Certification Chinese ·
HSK"**, tagline "From nǐ hǎo to HSK mastery", level "HSK 1–4", goal
`certification`. HSK (汉语水平考试) is a registered trademark of the Chinese
testing authority (CLEC / Chinese Testing International). Referring to HSK
levels descriptively in help text is nominative fair use; putting the mark in
the **product/course title of a paid "certification" course** is the pattern
that can be read as implying affiliation or endorsement.

**Recommendation:** rename to e.g. "Certification Chinese (HSK-aligned)" and
add a non-affiliation disclaimer (see 2.3). Same reasoning applies to app-store
listing text when publishing.

### 2.2 "DELE" references (low priority)

de_es help cards reference "die mündliche DELE-B2-Prüfung" (DELE is an
Instituto Cervantes trademark). These are descriptive, inside help text — much
lower risk than 2.1 — but covered by the same disclaimer.

### 2.3 Add a non-affiliation disclaimer (cheap, covers everything)

One sentence in the app's about/settings and store listings:

> *Not affiliated with, endorsed by, or connected to the Goethe-Institut,
> Instituto Cervantes (DELE), Chinese Testing International (HSK), or the
> Council of Europe. CEFR levels (A1–C2) indicate content alignment only; this
> app does not award official certificates.*

The last clause also addresses a consumer-accuracy point: the course
"Certification German A1–C2 — your step-by-step path to the C2 certificate"
*prepares for* certificates but the app doesn't issue recognized ones.

### 2.4 Minor brand mentions (cosmetic)

- Tip titles use **"Lego"** as a metaphor ("Compounds are Lego", "Numbers
  0–99: the Lego system", "Abstract Lego") — LEGO actively polices generic use
  of its mark. Cheap fix: "building blocks".
  (`lib/data/courses/en_zh/en_zh_a1_1.dart`, `en_zh_a1_2.dart`, `en_zh_c1_1.dart`)
- Czech furniture name for `puzzlecube` is **"rubikova kostka"**
  (`lib/data/furniture_names.dart:342`); en/de already use the generic
  "puzzle cube" / "Zauberwürfel". Cheap fix: "hlavolamová kostka".
- WeChat mentions in Chinese-course passages — nominative, fine.

## 3. Word lists / syllabi provenance — VERIFY

`docs/de_certification_a1_c2_plan.md` cites "Goethe-Institut exam syllabi /
Wortlisten" as design sources (themes, skill areas), and the en_zh course is
"HSK-anchored". Individual words and frequency facts are not copyrightable,
but **wholesale reproduction of an official curated wordlist** (its exact
selection + arrangement) could implicate the EU sui generis database right.

What the repo shows is consistent with independent curation: vocabulary is
grouped into the app's own themed categories, meanings are authored per UI
language, and the hanzi course uses its own "friendly themed" grouping of the
1,000 most common characters (frequency ranking is a fact, and multiple public
sources exist). **Action:** just confirm no Goethe/HSK wordlist file was
copy-pasted verbatim as a starting artifact; keep using own selection and
grouping.

## 4. Visual assets, fonts, audio — CLEAR

- **Logo** (`assets/icons/QuizLogo-01/02.svg`): original vector wordmark
  ("QUIZ" in a speech bubble), Illustrator export. No traced third-party art.
- **All room/furniture/shop art is drawn in code** (`flat_furniture.dart`
  primitives) — no imported images to have provenance issues. Item names are
  generic (garden gnome, lava lamp, pottery wheel…).
- **Fonts:** Inter, Source Serif 4, Noto Sans SC via `google_fonts` — all SIL
  OFL; the package handles license inclusion. Fine to bundle.
- **Audio:** all speech is generated at runtime (Azure/Google neural TTS →
  on-device fallback). No copied recordings. Note the cloud TTS terms of
  service govern generated-audio usage (both providers permit app playback).
- Flag emoji (🇬🇧🇩🇪…) render via system fonts — fine.

## 5. Code & dependencies — CLEAR, one best-practice gap

- No copied third-party code blocks, no embedded stroke-order databases
  (a common licensing trap for hanzi apps — the draw quiz uses a free-drawing
  canvas, not Arphic-derived stroke data).
- All pub dependencies are permissively licensed (BSD/MIT/Apache/OFL).
  Flutter bundles the aggregated `NOTICES` file into every build, which
  satisfies redistribution obligations.
- **Gap:** there is no in-app way to view those notices. Add an
  "Open-source licenses" entry calling `showLicensePage(...)` — standard
  practice, ~5 lines.
- `tts_secrets.json` is gitignored and has **never been committed** (checked
  full history). The Cloudflare worker keeps cloud TTS keys server-side. Good.
- The Google Ads tag ID and Aptabase app key in the client are public-by-design
  identifiers, not secrets.

## 6. Non-IP observations (informational)

- The cookieless Google Ads setup (Consent Mode all-denied +
  `url_passthrough`) is Google's documented banner-less configuration; note
  that the strictest EU ePrivacy readings treat even URL-based ad-click
  attribution as requiring consent. Current setup is a reasonable, documented
  position — just be aware it isn't universally settled.
- `pubspec.yaml` description is still "A new Flutter project." — worth
  updating before store submission (metadata quality, not legal).

---

## Priority checklist

| # | Item | Effort | Status |
|---|------|--------|--------|
| 1 | Rename "Certification Chinese · HSK" → "HSK-aligned" phrasing | tiny | ✅ done |
| 2 | Add non-affiliation / no-official-certificate disclaimer (app + store listings) | small | ✅ in-app (stores pending) |
| 3 | Confirm Goethe/HSK wordlists were curated, not copied verbatim | review | ⏳ owner to confirm |
| 4 | Add in-app "Open-source licenses" page (`showLicensePage`) | tiny | ✅ done |
| 5 | Reword "Lego" tips; rename Czech "rubikova kostka" | tiny | ✅ done |

## Implemented safeguards (2026-07-07, content version 1.19.0)

- **Course renamed** to "Certification Chinese (HSK-aligned)", tagline
  "From nǐ hǎo to HSK-level mastery" (`lib/data/course_catalog.dart`,
  regenerated into `assets/content/` and the seed).
- **Non-affiliation disclaimer** added in all four UI languages
  (en/es/de/zh): full version in Settings → "About & Legal"
  (`AppStrings.trademarkDisclaimer`), short version as a footer on the
  course finder (`course_selector_page.dart`), where the
  "Certification…" course names are displayed.
- **Open-source licenses** viewer added: Settings → About & Legal →
  "Open-source licenses" (`showLicensePage`), exposing Flutter's bundled
  NOTICES (covers OFL fonts and all BSD/MIT/Apache packages).
- **"Lego" tip titles** reworded to "building blocks" (en_zh course);
  **Czech "rubikova kostka"** renamed to the generic "hlavolamová kostka".
- **Web landing page synced** (`web/index.html`): course renamed in the
  JSON-LD catalog and the static SEO content, and the non-affiliation
  disclaimer added to the public landing text.
- `kDataVersion` bumped to **1.19.0** so existing installs reseed; content
  snapshot golden refreshed; full test suite (3,563 tests) and analyzer green.

**Still to do outside the repo:** add the same disclaimer sentence to the
Google Play / App Store listing descriptions, and confirm wordlist
provenance (item 3).
