# Generation prompt — “Tschechisch entdecken” (`de_cs`), a deep intro course

> Paste everything below the line into Claude Code at the repo root to generate
> the course. It is written to match this app’s authoring conventions exactly
> (the `de_es` course is the working template).

---

## Mission

Author a **new, short-but-deep introductory course** for this Flutter app:
**a native German speaker — who is a professional French teacher — learning Czech.**
Course id **`de_cs`** (🇩🇪 → 🇨🇿, `uiLang: UiLang.de`, `learnLocale: 'cs-CZ'`).

This is **not** a full A1–C2 certification. It is a **deep introductory taster**
(~3 small modules, ~18 quizzes, ~90–120 min) that is so good it makes the learner
*ache* for the rest. Quality and depth over breadth. End on a deliberate hook.

## Who the learner is — design for *this* person, not “a beginner”

She is a **linguist by trade**: a German native who teaches French. She thinks in
paradigms, knows what *aspect*, *valency*, *palatalisation*, *clitic*, *case
government* and *animacy* mean, and finds etymology delightful. **Do not write for
a tourist.** Banish generic phrasebook filler. Every Help Memory note should tell
her something a smart adult who already commands two case-light/​case-rich systems
would find *insightful* — the kind of detail that makes a language teacher smile.

Her superpower, which a monolingual German learner does **not** have, is **French**.
Czech’s two cliffs — the **seven-case system** and **verbal aspect** — each have a
bridge she already owns:
- **Cases** → her trained German case intuition (Nom/Akk/Dat/Gen) is the scaffold;
  Czech only adds Vocative, Locative, Instrumental on top of a system she feels in
  her bones.
- **Aspect** → as a French teacher she drills **imparfait vs passé composé** every
  day. That is the closest thing in Western Europe to the Czech
  **imperfective/perfective** split. Exploit this relentlessly — it is the single
  most “tailor-made” move in the whole course.

So the course’s signature is a **trilingual contrastive spine: Czech ↔ German ↔
French**, woven into nearly every quiz. Compare all three, constantly, with taste.

## The depth bar (read twice)

Reject anything superficial. Concretely, that means:
- Use real metalanguage (in German): *Aspekt, perfektiv/imperfektiv, Lokativ,
  Instrumental, Vokativ, Palatalisierung, Klitika, Belebtheit, Valenz*.
- Prefer the **non-obvious true fact** over the safe platitude. Examples of the
  register expected:
  - Czech has **no articles at all** — neither German `der/die/das/ein` nor French
    `le/la/un/du`. Definiteness lives in word order, demonstratives (`ten/ta/to`),
    and aspect. For a French teacher who drills the partitive `du café`, “just say
    `káva`” is a small revelation.
  - **Fixed stress on the first syllable** (like German’s tendency, the *opposite*
    of French’s phrase-final stress) — and it’s **independent of vowel length**, so
    `okno`, `holka`, `dobrý` never stress where a French ear expects.
  - **Phonemic vowel length** (`a/á, e/é, i/í, o/ó, u/ú/ů`) is like German
    *Staat/Stadt*, **unlike** French — and length ≠ stress, which trips everyone.
  - The háček consonants map cleanly: **`ž` = the French `j` in *jour* [ʒ]**,
    `š` = German *sch*, `č` = German *tsch*, `ň` = French/Italian *gn*. Give her the
    French anchor for `ž` explicitly — she’ll never forget it.
  - **`ř`** (Dvořák): the hardest sound in any European language — a raised
    alveolar trill with simultaneous friction. Don’t hand-wave it; describe the
    mechanism and that even Czech children acquire it last.
  - **Syllabic `l`/`r`** (`vlk`, `prst`, `krk`, the tongue-twister *Strč prst skrz
    krk*): vowel-less syllables — alien to both German and French.
  - **Pro-drop**: `Jsem učitelka` (no `já`). Like Spanish/Italian, **unlike** both
    German and French — both her languages force the subject pronoun.
  - **Second-position (Wackernagel) clitics**: `se/si/mi/ti/ho/jsem` cluster in slot
    two. Here French helps — she already orders clitics in *je **le lui** donne*.
  - **Vocative case** for direct address (`Petře!`, `Pavle!`, `paní Nováková →
    paní Nováková`): French lost it, German never had a morphological one — but
    Latin had it, which a philologically-minded teacher will enjoy.
  - **Genitive of counting** (`pět korun`, `pět piv`) and the 2–4 paucal — numbers
    govern case, which neither German nor French does.
  - **Germanisms in Czech** as friendly cognates with a story: `knedlík ←
    Knödel`, `šunka ← Schinken`, `barva ← Farbe`, `rytíř ← Ritter`, `brýle`,
    `hřbitov` — plus international/Romance words she’ll recognise (`restaurace`,
    `prezident`, `kultura`). And a few **false friends** to flag.

If a note could appear in any generic Czech app, rewrite it until it could only
appear in *this* one.

## The trilingual contrastive spine (seed — extend it)

Treat these as the backbone. Each becomes a recurring **`⚠️ Für
Deutschsprachige`** and/or **`🇫🇷 Brücke aus dem Französischen`** Help Memory tip,
plus a few **dedicated contrastive quizzes (⚑)**. Add more as content demands.

| #  | Czech feature | vs German | vs French (her bridge / contrast) |
|----|---------------|-----------|-----------------------------------|
| T1 | No articles | drops `der/die/das`, `ein` | drops `le/la/les`, `un/une`, partitive `du/de la` |
| T2 | 7 cases | extends her 4 (Nom/Akk/Dat/Gen) | French lost case except pronouns (`je/me/moi`) |
| T3 | Aspect perfective/imperfective | German has **none** | ≈ passé composé / passé simple **vs** imparfait |
| T4 | Aspect via verb pairs (`dělat/udělat`, `psát/napsat`) | no equivalent | she knows aspect as *meaning*, not stem — show the shift |
| T5 | Perfective present = **future** | `werden` future | `futur`/`futur proche` — but Czech hides it in the stem |
| T6 | Verb prefixes (`na-, vy-, při-, pře-, ode-`) | **trennbare Verben** (`an-, aus-, mit-`) — strong bridge | French uses different verbs/prepositions |
| T7 | Pro-drop | obligatory subject | obligatory subject (`il/elle`) |
| T8 | First-syllable fixed stress | German tendency (bridge) | French phrase-final stress (contrast) |
| T9 | Phonemic vowel length | `Staat/Stadt` (bridge) | no phonemic length (contrast) |
| T10 | `ž=[ʒ]`, `š`, `č`, `ň` (háček) | `sch`/`tsch` for `š`/`č` | **`ž` = `j` in *jour*** (anchor); `ň`≈`gn` |
| T11 | `ř` | — | — (unique; teach the mechanism) |
| T12 | Syllabic `l`/`r` (`vlk`, `prst`) | — | — |
| T13 | Vocative (`Petře!`) | none morphological | French lost it; Latin had it (philology hook) |
| T14 | Instrumental (`autem`, `s kamarádem`) | `mit` + Dativ | `en`/`avec` |
| T15 | Locative only after prepositions (`v Praze`) | Dativ/Akk after Wechselprä­positionen | `à`/`en Prague` |
| T16 | 2nd-position clitics (`se/si/mi/jsem`) | sentence-bracket logic | **`je le lui donne`** clitic order (bridge) |
| T17 | Reflexive `se/si` | `sich` (Akk/Dat split — bridge) | `se` (bridge) |
| T18 | Counting governs case (`pět korun`, paucal 2–4) | plain plural | plain plural |
| T19 | Three genders **+ animacy** (`pán` vs `hrad`) | three genders, no animacy | two genders |
| T20 | Diminutives everywhere (`-ek/-ka/-ička`) | `-chen/-lein` | `-et/-ette` |

## Course shape (suggested skeleton — keep it short, keep it deep)

Three small, **gated, interleaved** modules. Every module: knowledge
(`fillBlank`) + listen-&-repeat (`speakRepeat`) + at least one `reading`. **Never
two `fillBlank` back-to-back** without a `speakRepeat` or `reading` between them
(the app’s interleave rule). Suggested arc:

1. **`de_cs_m1` — Erste Klänge** (the phonology hook): the háček & length system,
   `ř`, first-syllable stress, syllabic `l/r`; greetings, `ano/ne/prosím/děkuji`,
   `Jak se máš?`; first `být` forms with pro-drop. Make the *sound system itself*
   the seduction — she will be fascinated.
2. **`de_cs_m2` — Ich, du und die anderen**: personal pronouns + pro-drop, full
   present of `být`, **the no-article revelation**, three genders + animacy, the
   **Vocative** for names, numbers 1–10 with the *genitive-of-counting* teaser, a
   first taste of *case* via the German bridge. Reading: a short self-introduction.
3. **`de_cs_m3` — Tun & Sein: erster Blick auf den Aspekt**: a gentle but **real**
   intro to perfective/imperfective through the **imparfait/passé composé** bridge;
   present of one regular verb; the **Instrumental** teaser (`autem`,
   `s kamarádem`); reflexive `se/si`. Reading: a slice-of-life passage. **Close
   with a deliberate hook** quiz/tip that previews what’s coming (the full 7-case
   table, aspect pairs at scale) so she wants the sequel.

Use a small **recurring cast** so passages feel like a story, not flashcards
(e.g. **Klára**, a German Romanistik student newly in Prague, and **Tomáš**, a
local). Passages in Czech; German translation behind the info button; reading
questions in Czech with German glosses (mirror `deCsRead`/the `de_es` readings).

## Engineering — make it actually compile, ship, and speak

Mirror the **`de_es`** course end-to-end. Study these before writing:
`lib/data/courses/de_es/` (builder + `de_es_a1_1.dart` + `de_es_content.dart`),
`lib/models/content/quiz.dart`, `lib/models/content/help_memory.dart`,
`docs/de_es/00_course_spec.md`, `docs/de_es_certification_plan.md`.

Then deliver:

1. **Builder** — `lib/data/courses/de_cs/de_cs_builder.dart`, mirroring
   `de_es_builder.dart` but Czech-framed: `CourseItem.prompt` = **German**,
   `answer` = **Czech**; teaching text in German; reading passage = Czech,
   `passageTranslation` = German. Column labels: `subjectColumnLabel: 'Deutsch'`,
   category label `'Auf Tschechisch'` (speak: `'Tschechisch'`). Provide
   `deCsFill`, `deCsVocab`, `deCsSpeak`, `deCsRead`.
   - **`speakRepeat` = 🇨🇿–🇩🇪–🇫🇷 triad.** For every `deCsSpeak` item, the **Czech**
     sentence goes in `answer` (the *only* field sent to Czech TTS), and the
     `prompt` carries the **German meaning + the real French parallel phrase +
     a one-fact micro-tip**, e.g. `CourseItem(prompt: "Ich heiße Klára ([FR] *Je
     m'appelle Klára* — reflexives se wie im Frz.!)", answer: "Jmenuji se Klára.")`.
     Real French *text* (`Je m'appelle…`, `Au revoir`, `J'ai lu`), not a paraphrase
     — the learner is a French teacher; give her the anchor she already owns. Each
     module has one dedicated triad speak quiz (`de_cs_m1_zvuky_slov`,
     `de_cs_m2_lide_vztahy`, `de_cs_m3_aspekt_mluvit`) with full item lists in
     `00_table_of_contents.md`; apply the same prompt pattern to the other speak
     quizzes too. **Never put French/German text in `answer`** or the Czech voice
     will mangle it.
   - **No emoji in app-facing strings (PDF-safe).** Flag emojis (🇩🇪/🇫🇷/🇨🇿) and
     other emoji are multi-codepoint sequences absent from the embedded PDF fonts
     (Source Serif / Inter), so they render as tofu boxes in the exported Help
     Memory PDF. Tag languages with plain text instead — **`[DE]` / `[FR]` /
     `[CS]`** — in every `helpMemory*` string, `CourseItem.prompt`, title, and
     passage. Accented Latin (á č ě ř ž ů…) and arrows (→) are fine; only
     emoji/flags break. Emoji in the markdown docs is OK (renders in viewers).
2. **Content files** — `de_cs_m1.dart`, `de_cs_m2.dart`, `de_cs_m3.dart`, each
   exporting its `List<QuizContent>` in chain order; plus
   `de_cs_content.dart` aggregating them into `final List<QuizContent> deCsContent`.
3. **Help Memory contract (enforced by tests)** — **every** quiz needs a
   `helpMemoryIntro` **and ≥1 `helpMemoryTip`**. Use tip `kind`s
   (`rule`/`tip`/`warning`/`example`/`mnemonic`) and carry the spine through two
   recurring flavours: a German-contrast tip (`kind: 'warning'`, tagged `[DE]` in
   the body) and a French-bridge tip (tagged `[FR]`). Aim for *both* on the meaty
   quizzes. Use the `[DE]`/`[FR]`/`[CS]` text tags, never flag emoji (see the
   PDF-safe rule under §1).
4. **Register the course**:
   - `lib/data/quiz_content_library.dart` → add `...deCsContent` to `allQuizContent`.
   - `tool/generate_content.dart` → add `'de_cs': [...deCsContent]`.
   - `lib/data/course_catalog.dart` → add a `_deCsNav` `NavLayout` (one **gated
     `NavGroupType.quizzes`** group per module + a `MÁS/MEHR` links group) and a
     `Course(id: 'de_cs', name: 'Tschechisch entdecken', tagline: …,
     speakFlag: '🇩🇪', learnFlag: '🇨🇿', uiLang: UiLang.de,
     learnLocale: 'cs-CZ', nav: _deCsNav)` in `defaultCourses`.
   - `assets/content/catalog.json` → add the course entry **and bump `version`**.
5. **TTS for Czech** — in `lib/services/tts/cloud_tts_provider.dart`, add a `cs`
   case to **both** `_voiceFor` switches so `speakRepeat`/`reading` audio works:
   Azure `cs-CZ-VlastaNeural` (f) / `cs-CZ-AntoninNeural` (m); Google
   `cs-CZ-Wavenet-A`/`-B` (fall back to Standard). Without this, Czech audio is
   silent/garbled.
6. **Versioning + seed** — bump `kDataVersion` in `lib/data/data_version.dart` (and
   the matching `"version"` in `assets/content/catalog.json`), then **regenerate
   the seed**: `dart run tool/generate_content.dart` and
   `dart run tool/generate_seed.dart` (so `assets/seed/quiz_content.json` carries
   the new course + version). Verify the new `"version"` is stamped.
7. **Docs** — author `docs/de_cs/00_course_spec.md` (totals, per-module counts,
   gating, interleave, reading arc) and a `docs/de_cs_intro_plan.md` carrying the
   **trilingual spine table** above, mirroring the `de_es` docs.

## Acceptance criteria

- `flutter analyze` is **clean** (this repo treats lint *infos* as failures).
- `flutter test` passes — including `test/quiz_model_test.dart` and any
  help-memory/seed-integrity tests (every quiz has intro + ≥1 tip; ids unique;
  round-trips losslessly).
- The course appears in the course switcher, its modules are gated in order, and
  `speakRepeat`/`reading` items play **Czech** audio.
- **Czech is correct and natural** — correct diacritics, correct case endings in
  every example, idiomatic phrasing. Get the grammar right; she *will* notice.
- Every module carries the trilingual spine; no quiz is generic.
- The final module ends on an explicit, enticing hook for the full course.

## Working method

Plan first (propose the 3-module quiz list with ids, types, and which spine point
each carries — like the table in `docs/de_es_certification_plan.md` §4 — before
writing content). Build incrementally, run `flutter analyze` as you go, keep edits
surgical, and **do not** invent app APIs — copy the `de_es` patterns exactly.
