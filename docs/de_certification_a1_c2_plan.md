# Certification German A1 → C2 (`de_cert`) — Content Plan

The full build-out of the **German certification course for English speakers**
(`speak 🇬🇧 → learn 🇩🇪`, `uiLang: en`). It extends today's `de_cert_a1` Quest
chain (A1.1 + A1.2 only) into the complete Goethe-Institut ladder **A1 → C2**,
adds a brand-new **listening (Hörverstehen)** exercise type, and balances every
module across the four Goethe skills.

This is a companion authoring doc — same role as
[`a1_competency_matrix.md`](a1_competency_matrix.md) and
[`de_es_certification_plan.md`](de_es_certification_plan.md): the
competency/contrastive mapping lives here, **not** as serialized `QuizContent`
fields, so the content schema and the seed/version pipeline stay unchanged. Keep
it in sync when quizzes are added, removed, or reordered.

> **What already exists** (do not re-author): A1.1 (13 quizzes) and A1.2 (12)
> ship today in [`quest_a1_1_content.dart`](../lib/data/quest/quest_a1_1_content.dart)
> / [`quest_a1_2_content.dart`](../lib/data/quest/quest_a1_2_content.dart), wired
> through [`quest_data.dart`](../lib/data/quest_data.dart). This plan **keeps**
> their ids/progress, rebuilds A1 to the four-skill standard (improved tips +
> mnemonics + E-spine, **2 new Hören each** and **1 new Sprechen** in A1.2 — see
> §8), and appends ten new modules (A2.1 … C2.2).

---

## 1. Ladder & scope

Twelve modules, smooth full progression (no skipped sub-levels), mapped to the
six Goethe-Institut exams. **C2.2 is the reading/listening ceiling** — every
passage and audio caps at the level of its module, rising to GDS (C2) difficulty.

| Module | Title (German · English) | CEFR | Goethe exam | "Big rock" (one new hard structure) |
|--------|--------------------------|------|-------------|--------------------------------------|
| **A1.1** | *Erste Schritte* · First steps | A1 | Start Deutsch 1 | Present tense, `sein/haben`, nominative articles |
| **A1.2** | *Im Alltag* · Everyday life | A1 | Start Deutsch 1 | **Accusative**, modal verbs, separable verbs |
| **A2.1** | *Erlebnisse* · Experiences | A2 | Goethe A2 | **Perfekt** (`haben`/`sein`), **dative** articles |
| **A2.2** | *Beschreiben & Planen* · Describe & plan | A2 | Goethe A2 | **Wechselpräpositionen** (Akk vs Dat), subordinate clauses (`weil/dass`) |
| **B1.1** | *Meinungen & Wünsche* · Opinions & wishes | B1 | Zertifikat B1 | **Konjunktiv II** (würde/hätte/wäre), **adjective endings** |
| **B1.2** | *Erzählen & Begründen* · Narrate & justify | B1 | Zertifikat B1 | **Präteritum** (narrative), **Passiv** (werden), relative clauses |
| **B2.1** | *Argumentieren* · Argue | B2 | Goethe B2 | **Konjunktiv I** (reported speech), passive (all tenses + modal) |
| **B2.2** | *Differenzieren* · Differentiate | B2 | Goethe B2 | **Konjunktiv II Vergangenheit** (irreal past), participial attributes, Genitiv prepositions |
| **C1.1** | *Abstrahieren* · Abstract | C1 | Goethe C1 | **Nominalstil ↔ Verbalstil**, Passiversatzformen (`sein+zu`, `sich lassen`, `-bar`) |
| **C1.2** | *Nuancieren* · Nuance | C1 | Goethe C1 | Subjective modals (inference), advanced connectors, Wortbildung |
| **C2.1** | *Stilsicherheit* · Stylistic command | C2 | GDS (C2) | Register & rhetoric, idiomatic mastery, Funktionsverbgefüge |
| **C2.2** | *Meisterschaft* · Mastery | C2 | GDS (C2) | Near-native discourse, literary/journalistic analysis, capstone |

**Official anchors** (what each level *must* cover):
- **CEFR** global + skill descriptors (Council of Europe) — the can-do goals.
- **Goethe-Institut exam syllabi / Wortlisten** (Start Deutsch 1, A2, Zertifikat
  B1, Goethe B2, C1, C2/GDS) — themes, the four Module (Lesen, Hören, Schreiben,
  Sprechen), and the official A1/A2/B1 vocabulary lists.
- **Profile deutsch / DaF grammar inventories** — the grammar progression that
  drives the "big rock" column.

> **Course id:** keep the stable id `de_cert_a1` (ids are permanent; **never**
> change storage-key prefixes) but retitle the display to *"German Certification
> (A1–C2)"*. The Quest chain is global and single-consumer today, so extending it
> is appending entries (see §14).

---

## 2. Progression principles

1. **One new "big rock" per module.** Each module introduces a single hard
   structure (the table above) and recycles everything before it. No module
   stacks two alien systems at once — e.g. the **dative** (A2.1) is solid before
   **two-way prepositions** (A2.2), which are solid before **adjective endings**
   (B1.1).
2. **Spiral, don't dump.** Cases (Akk → Dat → Gen), the Konjunktiv (II present →
   I reported → II past), and the passive each appear *intro → consolidation →
   advanced* across several modules, never once.
3. **Cases before endings.** The four cases are mastered (A1.2–A2.1) before
   adjective endings (B1.1), because endings are a *function* of case+gender+
   article and collapse without that base.
4. **Interleave skills.** Never two `fillBlank` back-to-back without a
   `speakRepeat`, `reading`, or `listening` breaking them up (same rule as
   `de_cert_a1`). Every module touches all four skills.
5. **Receptive skills are level-locked but interesting.** Reading + listening use
   only grammar already taught, but topics are adult and engaging (a flat-share
   in Berlin, a job interview, a climate debate, a book review). German text/
   audio first; English behind an info button.
6. **Gate the next sub-level.** A module unlocks as a block only when **every**
   quiz in all preceding sub-levels is done (`isQuestLevelUnlocked` — already
   supports arbitrary sub-levels, iterating them in chain order).

---

## 3. Skill balance — the four-Module model

Goethe exams test four Module: **Lesen, Hören, Schreiben, Sprechen**. This course
now covers **all four** actively — each maps to an exercise type and a gate:

| Goethe skill | Exercise type (`QuizContent.kind`) | Gate | Per module (A2+) |
|--------------|-----------------------------------|------|------------------|
| **Lesen** (reading) | `reading` | score ≥ 65% | **2** |
| **Hören** (listening) | `listening` **← NEW** (hidden TTS passage + MC) | score ≥ 65% | **1–2** |
| **Sprechen** (speaking) | `speakRepeat` (TTS → repeat, never needs a mic) | play-through | **2** |
| **Schreiben** (writing) | `dictation` **← NEW** (listen & type the sentence) | score ≥ 65% | **1** |
| **Grammatik & Wortschatz** | `fillBlank` (knowledge) | streak | **7–8** |

Two new exercise types ship with this build — **Hören** (`listening`, §4) and
**Diktat** (`dictation`, §4.5) — so the course exercises **all five** kinds and
the full four-Module set. **Per-module target ≈ 14–16 quizzes**, roughly
`8 fillBlank + 2 reading + 2 listening + 2 speaking + 1 dictation`, interleaved
so no skill clusters (≤ 2 knowledge quizzes in a row). The exact split per module
is in §8. A1.1/A1.2 are **rebuilt to this balance** in place (ids kept): each
reaches **2 Hören + ≥1 Lesen + 2 Sprechen + 1 Diktat** alongside its knowledge
quizzes, and now carries all five types.

---

## 4. NEW exercise type — Hörverstehen (`QuizKind.listening`)

A listening-comprehension quiz: a short German passage (~50 words) is **read
aloud by TTS and never shown on screen**, followed by the same multiple-choice
UI as reading. It is the audio twin of `reading` and reuses its data fields, so
it costs one enum value and one page — not a new schema.

### 4.1 Behaviour
- **Stage 1 — Listen.** A play panel (no text) auto-plays the passage on entry,
  with a pulsing speaker indicator, a **▶ Play again / replay** button, the
  `VoiceStatusChip` (premium-cloud → offline voice), and an **info button** that
  opens the passage **in German *and* English** (the script is the help, not the
  question). A "Start questions" button advances.
- **Stage 2 — Answer.** Identical multiple-choice UI to `ReadingQuizPage`
  (shuffled options, per-question info = translation, submit, score, retry), with
  a small **persistent replay button** so the learner can re-listen while
  answering. Replaying the audio is always allowed (no penalty).
- **Gate:** score ≥ 65% → `markQuestQuizCompleted` (unlocks next chain quiz) +
  a new `markListeningQuizCompleted` for the home/drawer ribbon (mirrors reading).

### 4.2 Data (reuse the reading fields — zero new serialized fields)
| Field | Use in listening |
|-------|------------------|
| `readingPassage` | the **hidden** German script TTS reads aloud; shown only behind the info button |
| `readingPassageTranslation` | English script, shown beside the German in the info dialog |
| `readingQuestions` | the multiple-choice questions (same `ReadingQuestion`) |
| `readingTitle` / `readingCategory` | on-screen title (e.g. *"Nachricht auf dem Anrufbeantworter"*) + topic chip |
| `kind` | **`listening`** (new enum value; `toJson`/`fromJson` already serialize `kind` by name) |

### 4.3 Icon & accent
A dedicated **ear** icon, distinct from speaking's `record_voice_over` and
reading's `menu_book`:

```dart
// lib/data/nav_layout_data.dart
IconData quizKindIcon(QuizKind kind) => switch (kind) {
  QuizKind.speakRepeat => Icons.record_voice_over_rounded,
  QuizKind.reading     => Icons.menu_book_rounded,
  QuizKind.listening   => Icons.hearing_rounded,   // ← NEW (ear)
  QuizKind.fillBlank   => Icons.quiz_rounded,
};
Color quizKindColor(QuizKind kind) => switch (kind) {
  ...
  QuizKind.listening => kSectionAccentColors[3],   // 4th accent
};
```
Drawer/home kind label: **"Listen & answer"** (`record_voice_over` stays
"Listen & repeat"). Candidate icons if `hearing` reads too clinical:
`Icons.headphones_rounded`, `Icons.graphic_eq_rounded`, `Icons.spatial_audio_off_rounded`.

### 4.4 Why reuse `reading` instead of a fresh schema
The listening quiz differs from reading in exactly three UI behaviours (hide the
passage, play it, allow replay) and one icon/gate label — not in its data shape.
Reusing `readingPassage`/`readingQuestions` keeps the back-office editor, the
seed pipeline, JSON round-trip tests, and the help-memory wiring unchanged.
Engineering touchpoints are itemised in §14.

---

## 4.5 NEW exercise type — Diktat (`QuizKind.dictation`)

The writing (**Schreiben**) twin of the listening quiz, and the fifth exercise
type. TTS reads a German sentence aloud (never shown until answered) and the
learner **types** what they hear. It completes the four-Module set.

- **Behaviour.** Per sentence: auto-play + replay (pulsing speaker, no text), a
  text field, **Check** → reveals the correct sentence + its translation so the
  learner can compare spelling, then **Next**. Scored across the set.
- **Forgiving check.** The typed answer is normalised with `normalizeForSpeech`
  (case, punctuation and umlaut spelling folded: *ä/ae*, *ß/ss*) plus a ≥ 0.9
  `similarity` tolerance, so a learner without a German keyboard — or with one
  small typo — still passes. (No mic needed; pure listen-&-write.)
- **Data.** Reuses the `speakRepeat` shape: each `QuizContent.subjects` entry is
  a sentence to dictate (`display`) with its translation (`english`). Builder:
  `dictationQuestQuiz(...)`.
- **Gate.** Score ≥ 65% → `markDictationQuizCompleted` + `markQuestQuizCompleted`.
- **Icon/accent.** `Icons.spellcheck_rounded`, `kSectionAccentColors[1]`; drawer/
  home label **"Listen & write"**.
- **Engineering.** Same touchpoints as §14A (enum value, page
  `DictationQuizPage`, loader dispatch, the exhaustive `switch (kind)` sites, a
  `completedDictationQuizzes` set in NounSettings/UserSettings/SettingsKeys,
  builder, tests). **Shipped and green** in this build.

## 5. The contrastive spine (English → German)

This course's backbone. Each row is a recurring "⚠️ For English speakers" tip
woven into the relevant quiz's `helpMemoryTips`, plus dedicated contrastive
quizzes (marked **⚑** in §8). These are the points where German diverges from
English — i.e. where the learner actually trips.

| # | German feature | Why an English speaker trips | First taught |
|---|----------------|------------------------------|--------------|
| E1 | **Every noun is capitalised** (das Haus, ein Buch) | English caps only proper nouns | A1.1 |
| E2 | **3 genders** der/die/das, not predictable from meaning | English has no grammatical gender | A1.1 → spiral |
| E3 | **4 cases** reshape articles/adjectives | English leans on word order | A1.2 (Akk) → A2.1 (Dat) → B1.1 (Gen) |
| E4 | **Verb-second (V2)**: finite verb is element #2 (*Morgen __gehe__ ich…*) | English keeps rigid SVO | A1.1 |
| E5 | **Separable verbs**: prefix flies to the end (*Ich stehe um 7 __auf__*) | No English equivalent | A1.2 |
| E6 | **Modal verbs push the main verb to the end** (*Ich muss heute __arbeiten__*) | English keeps the verb adjacent | A1.2 |
| E7 | **kein vs nicht** negation split | English just uses *not/no* | A1.2 |
| E8 | **Perfekt: `haben` vs `sein`** (motion/change → sein) | English has only *have* | A2.1 |
| E9 | **du vs Sie** (T–V formality) | English lost *thou* | A1.1 |
| E10 | **Wechselpräpositionen**: Akk for motion (wohin?), Dat for place (wo?) | English prepositions don't case-switch | A2.2 |
| E11 | **Subordinate clauses send the verb to the very end** (*…, weil ich müde __bin__*) | English keeps verb early | A2.2 → B1 |
| E12 | **TeKaMoLo** adverb order (Time–Cause–Manner–Place) | English uses Place–Manner–Time | A2.2 → B1 |
| E13 | **Adjective endings** vary by gender+case+article type | English adjectives never inflect | B1.1 (the cliff) |
| E14 | **Konjunktiv II** for politeness/hypothesis (würde/hätte/wäre/könnte) | Maps loosely to *would/could* but forms differ | B1.1 |
| E15 | **Genitiv** & genitive prepositions (trotz/während/wegen/aufgrund) | English uses *of*/'s | B1.1 → B2.2 |
| E16 | **werden-Passiv** + modal passive (*kann gemacht werden*) | English *be*-passive is simpler | B1.2 → B2.1 |
| E17 | **n-Deklination** (weak masc.: den __Jungen__, dem __Studenten__) | No English equivalent | B1.2 |
| E18 | **Konjunktiv I** for reported speech (*Er sagte, er __sei__ krank*) | English backshifts tense instead | B2.1 |
| E19 | **Extended participial attributes** (*das von mir __gelesene__ Buch*) | English uses relative clauses | B2.2 → C1 |
| E20 | **False friends** (*also*=so; *bekommen*=receive; *Gift*=poison; *aktuell*=current; *Chef*=boss; *Rente*=pension; *eventuell*=possibly) | Look identical, mean different | sprinkled A1–C2 |

---

## 6. Memory-aid toolkit (the "how to remember" methods)

Hard structures get a **named mnemonic** in `helpMemoryTips` (kinds: `rule`,
`mnemonic`, `example`, `warning`). Reuse these across modules so they compound.

| Hard thing | Method | The hook |
|------------|--------|----------|
| **Gender** | Colour-coding + ending rules | der = blue, die = red, das = green (the app's `helpMemoryColorByGender`). **die**: ‑ung, ‑heit, ‑keit, ‑schaft, ‑tion, ‑ei, ‑ie, ‑ik. **das**: ‑chen, ‑lein, ‑ment, ‑um, ‑ma. **der**: ‑er (agent), ‑ling, ‑ismus, days/months/seasons, male people. |
| **Accusative prepositions** | Chant **"durch–für–gegen–ohne–um"** (+bis, entlang) | Five-beat rhythm; "DfgoU" — *always* accusative, no exceptions. |
| **Dative prepositions** | The classic class **song**: "aus–außer–bei–mit–nach–seit–von–zu–gegenüber" | Sung to a melody; *always* dative. |
| **Wechselpräpositionen** | The **box picture**: a cat *auf der* Box (Wo? Dat) vs jumping *auf die* Box (Wohin? Akk) | "Movement → Akkusativ (the arrow A→); resting → Dativ." 9 of them: an, auf, hinter, in, neben, über, unter, vor, zwischen. |
| **Perfekt haben/sein** | "**Movers & changers take `sein`**" | Motion (gehen, fahren, kommen) + change of state (werden, sterben, aufwachen) + sein/bleiben/passieren → `sein`; everything else → `haben`. |
| **Case question words** | **wer / wen / wem / wessen** | Map 1:1 to Nom / Akk / Dat / Gen — ask the question, get the case. |
| **Adjective endings** | The **"one strong signal"** rule | If the article already shows the case (der/die/das/dem/den…), the adjective just takes ‑e or ‑en; if there's no/weak article, the *adjective itself* carries the case ending. |
| **Word order** | **TeKaMoLo** | **Te**mporal → **Ka**usal → **Mo**dal → **Lo**kal: *Ich fahre morgen wegen der Arbeit mit dem Zug nach Köln.* |
| **Konjunktiv II** | Default **"würde + Infinitiv"** | When unsure of the form, *würde* + infinitive is always safe; learn hätte/wäre/könnte/möchte by heart as the common exceptions. |
| **Subordinate verb-final** | "**The conjunction kicks the verb to the back**" | weil/dass/wenn/obwohl → finite verb last. Pair with a physical "kick" gesture. |
| **Spaced repetition** | Built into the chain | The streak gate + recycled vocab in later readings re-expose hard items naturally; difficult nouns reappear in `listening` scripts. |

Every module's Help Memory **must** carry: one `helpMemoryIntro`, at least one
`rule`/`mnemonic` tip for its big rock, and a `warning` for the relevant **E#**
contrastive trap. (Enforced by the existing help-memory tests.)

---

## 7. Legend for the module syllabi (§8)

**Type** = `QuizContent.kind` · **Gate** = streak (knowledge) / play-through
(speaking, never needs a mic) / score (reading **and** listening, ≥ 65%). **⚑** =
dedicated contrastive quiz. Ids follow the existing convention
`quest_<level>_<slug>`. **(existing)** marks shipped A1 quizzes.

---

## 8. Module syllabi

> **A1 is rebuilt to the new standard.** The 25 shipped quizzes keep their **ids
> and storage-key prefixes** (saved streaks/scores survive — see §14B) but are
> *improved in place*: every one gains the four-skill balance, an **E-spine
> contrastive `warning`**, and a **named mnemonic** from §6, with duplicate
> table/tip/card info stripped (Rule B). **New** quizzes (4 Hören + 1 Sprechen)
> get fresh ids. Detailed authoring spec — intros, tips, sample items, and the
> full Hören scripts — follows each module's map.

### A1.1 — *Erste Schritte* · First steps  *(17 quizzes — redesigned)*
**Can-do:** greet, introduce yourself, spell, give origin/job, count 0–100, name
everyday things and family, ask basic W-questions. **Grammar:** present (regular
+ **stem-changing**), `sein/haben`, nominative articles, personal pronouns,
W-questions, V2 word order. **Big rocks:** E1 (capitalisation), E2 (gender),
E4 (V2), E9 (du/Sie). **Balance:** 11 fillBlank (incl. **3 verb-conjugation**) ·
2 Sprechen · 1 Lesen · 2 Hören · 1 Diktat. **(new)** = added.

| # | Exercise | id | Type | Gate | E# |
|---|----------|----|------|------|----|
| 1 | Zahlen 0–10 | `quest_a1_1_zahlen` | fillBlank | streak | |
| 2 | Personalpronomen | `quest_a1_1_pronomen` | fillBlank | streak | E9 |
| 3 | Sprechen: Vorstellung | `quest_a1_1_sprechen_vorstellung` | speakRepeat | play-through | E9 |
| 4 | Artikel im Nominativ | `quest_a1_1_artikel` | fillBlank | streak | **⚑ E2** |
| 5 | Zahlen 11–20 | `quest_a1_1_zahlen2` | fillBlank | streak | |
| 6 | **Hören: Begrüßung & Vorstellung** | `quest_a1_1_hoeren_vorstellung` | listening | score | **(new)** |
| 7 | sein & haben *(conjugation)* | `quest_a1_1_sein_haben` | fillBlank | streak | |
| 8 | W-Fragen | `quest_a1_1_wfragen` | fillBlank | streak | E4 |
| 9 | Lesen: *Das bin ich* | `quest_a1_1_lesen_dasbinich` | reading | score | E1 |
| 10 | Regelmäßige Verben (Präsens) *(conjugation)* | `quest_a1_1_praesens` | fillBlank | streak | **⚑ E4** |
| 11 | **Unregelmäßige Verben (Vokalwechsel)** *(conjugation)* | `quest_a1_1_vokalwechsel` | fillBlank | streak | **(new)** |
| 12 | **Diktat: Steckbrief** | `quest_a1_1_diktat_steckbrief` | dictation | score | **(new)** |
| 13 | **Hören: Im Geschäft — Zahlen & Preise** | `quest_a1_1_hoeren_zahlen` | listening | score | **(new)** |
| 14 | Zahlen 20–100 | `quest_a1_1_zahlen3` | fillBlank | streak | |
| 15 | Farben | `quest_a1_1_farben` | fillBlank | streak | |
| 16 | Sprechen: Zahlen & Preise | `quest_a1_1_sprechen_zahlen` | speakRepeat | play-through | |
| 17 | Familie & Menschen | `quest_a1_1_familie` | fillBlank | streak | E1 |

#### A1.1 — detailed spec

**1 · Zahlen 0–10** — fillBlank · streak · *keep, polish*
- *Intro:* every larger number is built from 0–10 — say and spell each by heart.
- *Tip (warning):* watch **zwei, drei, sechs, sieben**; counting uses **eins**,
  but before a noun it's **ein** (*ein Apfel*).
- *Samples:* `3 → drei` · `5 → fünf` · `8 → acht`.

**2 · Personalpronomen** — fillBlank · streak · *improve: add E9*
- *Intro:* who is doing the action — the nominative pronouns.
- *Tip (warning · E9):* German splits "you" into **du** (informal) and **Sie**
  (formal, *always capitalised*). *sie* = she/they (lowercase); **Sie** = you-formal.
- *Samples:* `I → ich` · `you (informal) → du` · `we → wir` · `they → sie`.

**3 · Sprechen: Vorstellung** — speakRepeat · play-through · *improve phrases*
- *Phrases (short→long):* "Hallo!" · "Ich heiße Emma." · "Ich komme aus England."
  · "Ich wohne jetzt in Berlin." · "Ich bin zweiunddreißig Jahre alt." · "Freut
  mich, dich kennenzulernen!"
- *Tip (mnemonic · E9):* greet a stranger with **Sie** ("Wie heißen *Sie*?"), a
  friend with **du** ("Wie heißt *du*?").

**4 · Artikel im Nominativ** — fillBlank · streak · **⚑ E2** · *improve: gender system*
- *Intro:* every German noun has a gender — **der / die / das** — and you must
  learn it *with* the noun. `helpMemoryColorByGender` tints them (der=blue,
  die=red, das=green).
- *Tip (rule · gender endings):* **die** → ‑ung, ‑heit, ‑keit, ‑schaft, ‑tion;
  **das** → ‑chen, ‑lein; **der** → ‑er (agent), days/months.
- *Tip (warning · E2):* gender is **not logical** — *das Mädchen* (a girl!) is
  neuter because of ‑chen. Memorise der/die/das as part of the word.
- *Samples:* `Hund → der` · `Katze → die` · `Haus → das` · `Mädchen → das`.

**5 · Zahlen 11–20** — fillBlank · streak · *keep*
- *Tip (rule):* teens = unit + **zehn** (vierzehn). *Tip (warning):* **16
  sechzehn** drops the ‑s, **17 siebzehn** drops the ‑en; **elf/zwölf** irregular.
- *Samples:* `13 → dreizehn` · `16 → sechzehn` · `20 → zwanzig`.

**6 · Hören: Begrüßung & Vorstellung** — listening · score · **(new)**
- *Topic chip:* "Alltag · Vorstellung". *Title:* "Lena stellt sich vor".
- **Script (German, hidden — ~50 words):** *"Hallo! Ich heiße Lena Schmidt. Ich
  komme aus Österreich, aus Wien. Jetzt wohne ich in Berlin. Ich bin dreißig
  Jahre alt und ich bin Lehrerin. Ich spreche Deutsch, Englisch und ein bisschen
  Spanisch. Meine Hobbys sind Musik und Sport. Ich spiele gern Gitarre. Und wie
  heißt du?"*
- **Script (English, info button):** *"Hello! My name is Lena Schmidt. I come
  from Austria, from Vienna. Now I live in Berlin. I am thirty years old and I am
  a teacher. I speak German, English and a little Spanish. My hobbies are music
  and sport. I like playing the guitar. And what's your name?"*
- **Questions:**
  1. *Woher kommt Lena?* — aus Deutschland · **aus Österreich** ✓ · aus der Schweiz
  2. *Was ist Lena von Beruf?* — Ärztin · Studentin · **Lehrerin** ✓
  3. *Wie alt ist Lena?* — 13 · **30** ✓ · 33
  4. *Welches Hobby hat Lena?* — Kochen · **Musik** ✓ · Tanzen
- *Tip (mnemonic):* listen for the **W-word answers** — *woher* (origin), *was*
  (job), *wie alt* (age). *New nouns → DB:* Lehrerin (f), Gitarre (f), Musik (f).

**7 · W-Fragen** — fillBlank · streak · E4 · *improve: V2*
- *Intro:* open questions start with a **W-word**, then the verb.
- *Tip (rule · E4):* the finite verb is still in **position 2** — *W-Wort + Verb +
  Subjekt*: "**Woher kommst du?**", "**Wann beginnt** der Film?"
- *Samples:* `___ heißt du? → Wie` · `___ kommst du? → Woher` · `___ wohnst du? → Wo`.

**8 · sein & haben** — fillBlank · streak · *improve*
- *Tip (rule):* both irregular, learn by heart — **sein** = identity/state
  (*Ich bin müde*), **haben** = possession (*Ich habe Zeit*).
- *Samples:* `Ich ___ Student. → bin` · `Du ___ ein Auto. → hast` · `Wir ___ müde. → sind`.

**9 · Lesen: *Das bin ich*** — reading · score · *keep, add E1 tip*
- *Tip (warning · E1):* notice **every noun is capitalised** in the passage
  (*Name, Stadt, Beruf*) — unlike English. Keep the passage in German; English
  behind the info button.

**10 · Farben** — fillBlank · streak · *improve*
- *Tip (rule):* used **predicatively** ("Das Auto ist **rot**") colours take **no
  ending**; endings come later (attributive, B1.1).
- *Samples:* `red → rot` · `blue → blau` · `green → grün` · `white → weiß`.

**11 · Zahlen 20–100** — fillBlank · streak · *keep*
- *Tip (rule):* from 21 up, **units before tens**, joined by *und*, one word:
  **ein·und·zwanzig** (one-and-twenty). *Watch:* dreißig (‑ßig).
- *Samples:* `21 → einundzwanzig` · `47 → siebenundvierzig` · `100 → hundert`.

**12 · Hören: Im Geschäft — Zahlen & Preise** — listening · score · **(new)**
- *Topic chip:* "Einkaufen · Markt". *Title:* "Auf dem Markt".
- **Script (German, hidden — ~50 words):** *"Guten Tag und herzlich willkommen
  auf dem Markt! Heute sind die Äpfel billig: ein Kilo kostet nur zwei Euro. Die
  Bananen kosten drei Euro. Ein Brot kostet einen Euro fünfzig. Möchten Sie auch
  Eier? Zehn Eier kosten zwei Euro zwanzig. Vielen Dank und einen schönen Tag!"*
- **Script (English, info button):** *"Good day and welcome to the market! Today
  the apples are cheap: one kilo costs only two euros. The bananas cost three
  euros. A loaf of bread costs one euro fifty. Would you like eggs too? Ten eggs
  cost two euros twenty. Thank you and have a nice day!"*
- **Questions:**
  1. *Wie viel kostet ein Kilo Äpfel?* — **2 Euro** ✓ · 3 Euro · 1,50 Euro
  2. *Was kostet drei Euro?* — die Äpfel · **die Bananen** ✓ · das Brot
  3. *Wie viele Eier kosten 2,20 Euro?* — fünf · **zehn** ✓ · zwanzig
- *Tip (mnemonic):* prices come right after the product name — hold the **product
  + number** pair in your head. *New nouns → DB:* Markt (m), Apfel (m), Banane (f),
  Brot (n), Ei (n).

**13 · Regelmäßige Verben (Präsens)** — fillBlank · streak · **⚑ E4** · *improve*
- *Intro:* the present-tense endings ‑e/‑st/‑t/‑en/‑t/‑en on the stem.
- *Tip (rule · E4):* the finite verb sits in **position 2**, even after a
  time word: "**Heute spiele ich** Fußball" (not *Heute ich spiele*).
- *Samples:* `ich (spielen) → spiele` · `du (machen) → machst` · `er (wohnen) → wohnt`.

**14 · Familie & Menschen** — fillBlank · streak · E1 · *improve*
- *Tip (rule):* the female form usually adds **‑in** (Lehrer → Lehrer**in**).
  *Tip (warning · E1):* people-nouns are still capitalised (*der Vater, die Mutter*).
- *Samples:* `father → der Vater` · `mother → die Mutter` · `child → das Kind`.
- *New nouns → DB:* Vater (m), Mutter (f), Bruder (m), Schwester (f), Kind (n),
  Sohn (m), Tochter (f), Eltern (pl) — all `family`, mark Junge/etc. `declensionSafe:false`.

**15 · Sprechen: Zahlen & Preise** — speakRepeat · play-through · *improve*
- *Phrases:* "Was kostet das?" · "Das kostet drei Euro fünfzig." · "Zusammen,
  bitte." · "Meine Nummer ist null-eins-sieben-…" · "Das ist zu teuer!"
- *Tip (mnemonic):* read prices as **Euro + Cent** ("3,50" → "drei Euro fünfzig").

---

### A1.2 — *Im Alltag* · Everyday life  *(16 quizzes — redesigned)*
**Can-do:** talk about objects you own/use, daily routine, time & dates, order
food, basic shopping, say what you can/must/want. **Grammar:** accusative case,
possessives, modal verbs, separable verbs, kein/nicht, clock time, accusative
prepositions. **Big rocks:** E3 (accusative), E5 (separable), E6 (modal→verb-end),
E7 (kein/nicht). **Balance:** 9 fillBlank · 2 Sprechen · 2 Lesen · 2 Hören ·
1 Diktat.

| # | Exercise | id | Type | Gate | E# |
|---|----------|----|------|------|----|
| 1 | Akkusativ (Artikel) | `quest_a1_2_akkusativ` | fillBlank | streak | **⚑ E3** |
| 2 | Possessivartikel | `quest_a1_2_possessiv` | fillBlank | streak | |
| 3 | **Hören: Im Café bestellen** | `quest_a1_2_hoeren_cafe` | listening | score | **(new)** |
| 4 | Personalpronomen (Akkusativ) | `quest_a1_2_pronomen_akk` | fillBlank | streak | E3 |
| 5 | Negation (kein / nicht) | `quest_a1_2_negation` | fillBlank | streak | **⚑ E7** |
| 6 | Lesen: *Im Café* | `quest_a1_2_lesen_cafe` | reading | score | |
| 7 | Modalverben | `quest_a1_2_modalverben` | fillBlank | streak | **⚑ E6** |
| 8 | Sprechen: Alltag & Uhrzeit | `quest_a1_2_sprechen_alltag` | speakRepeat | play-through | E5 |
| 9 | Uhrzeit | `quest_a1_2_uhrzeit` | fillBlank | streak | E20 |
| 10 | Wochentage & Monate | `quest_a1_2_datum` | fillBlank | streak | E1 |
| 11 | **Diktat: Mein Tag** | `quest_a1_2_diktat_meintag` | dictation | score | **(new)** |
| 12 | **Hören: Termine & Uhrzeit** | `quest_a1_2_hoeren_termine` | listening | score | **(new)** |
| 13 | Akkusativpräpositionen | `quest_a1_2_praepositionen` | fillBlank | streak | |
| 14 | Trennbare Verben | `quest_a1_2_trennbare` | fillBlank | streak | **⚑ E5** |
| 15 | **Sprechen: Einkaufen & Bestellen** | `quest_a1_2_sprechen_einkaufen` | speakRepeat | play-through | **(new)** |
| 16 | Lesen: *Eine kleine Reise* | `quest_a1_2_lesen_reise` | reading | score | |

#### A1.2 — detailed spec

**1 · Akkusativ (Artikel)** — fillBlank · streak · **⚑ E3** · *improve*
- *Intro:* the **object** of an action takes the accusative — the first case
  where the article changes.
- *Tip (rule · E3):* **only masculine changes**: *der → den*, *ein → einen*.
  *die / das / eine* stay the same. Mnemonic: "**Akk = den** (the extra ‑n)."
- *Samples:* `Ich sehe ___ Hund (der). → den` · `Ich habe ___ Apfel (ein). → einen`
  · `Ich kaufe ___ Katze (die). → die`.

**2 · Possessivartikel** — fillBlank · streak · *improve*
- *Tip (rule):* possessives take **ein-endings** (mein, meine, meinen…). *sein* =
  his, *ihr* = her/their, **Ihr** = your-formal.
- *Samples:* `my father → mein Vater` · `my mother → meine Mutter` · `your (inf.)
  dog → dein Hund`.

**3 · Hören: Im Café bestellen** — listening · score · **(new)**
- *Topic chip:* "Essen & Trinken · Café". *Title:* "Eine Bestellung im Café".
- **Script (German, hidden — ~50 words):** *"Guten Tag, was möchten Sie
  bestellen? — Ich nehme einen Kaffee und ein Stück Apfelkuchen, bitte. —
  Möchten Sie den Kaffee mit Milch? — Ja, gern, mit Milch und Zucker. — Und etwas
  zu trinken? — Nein, danke. Was kostet das? — Das macht vier Euro achtzig. —
  Hier sind fünf Euro. — Danke schön!"*
- **Script (English, info button):** *"Good day, what would you like to order? —
  I'll have a coffee and a piece of apple cake, please. — Would you like the
  coffee with milk? — Yes, gladly, with milk and sugar. — And something to drink?
  — No, thanks. What does it cost? — That's four euros eighty. — Here are five
  euros. — Thank you!"*
- **Questions:**
  1. *Was bestellt der Gast zu essen?* — Schokokuchen · **Apfelkuchen** ✓ · ein Brot
  2. *Wie trinkt der Gast den Kaffee?* — schwarz · **mit Milch und Zucker** ✓ · mit Zitrone
  3. *Was kostet die Bestellung?* — 4,18 € · **4,80 €** ✓ · 5,00 €
- *Tip (mnemonic):* the order verbs — *möchten · nehmen · bestellen · kosten* —
  are your signposts. *New nouns → DB:* Kaffee (m), Apfelkuchen (m), Milch (f),
  Zucker (m), Wasser (n), Stück (n).

**4 · Personalpronomen (Akkusativ)** — fillBlank · streak · E3 · *improve*
- *Tip (rule):* only **er → ihn** is surprising; the rest shadow the article
  pattern (mich/dich/uns/euch). *sie/es/Sie* don't change.
- *Samples:* `me → mich` · `you (inf.) → dich` · `him → ihn` · `us → uns`.

**5 · Negation (kein / nicht)** — fillBlank · streak · **⚑ E7** · *improve*
- *Tip (rule · E7):* **kein** negates a noun that would take *ein*/no article
  (*Ich habe **kein** Auto*); **nicht** negates everything else — verbs,
  adjectives, definite nouns (*Das ist **nicht** gut*).
- *Samples:* `Ich habe ___ Zeit. → keine` · `Das ist ___ gut. → nicht` · `Ich
  habe ___ Auto. → kein`.

**6 · Lesen: *Im Café*** — reading · score · *keep, polish* — pairs with quiz 3's
  Hören (same scene, now read): möchten / nehmen / bestellen / bezahlen.

**7 · Modalverben** — fillBlank · streak · **⚑ E6** · *improve*
- *Intro:* können, müssen, wollen, dürfen, sollen, möchten — they reshape the sentence.
- *Tip (rule · E6):* the modal is conjugated in **position 2**; the **main verb
  goes to the very end as an infinitive**: "Ich **muss** heute **arbeiten**."
- *Samples:* `Ich ___ Deutsch sprechen (can). → kann` · `Du ___ jetzt schlafen
  (must). → musst` · `Wir ___ ins Kino gehen (want). → wollen`.

**8 · Sprechen: Alltag & Uhrzeit** — speakRepeat · play-through · E5 · *improve*
- *Phrases:* "Ich stehe um sieben Uhr auf." · "Um halb neun frühstücke ich." ·
  "Am Nachmittag kaufe ich ein." · "Abends sehe ich fern."
- *Tip (mnemonic · E5):* hear the **separable prefix snap to the end** (*auf*,
  *ein*, *fern*).

**9 · Uhrzeit** — fillBlank · streak · E20 · *improve*
- *Tip (warning · false-friend trap):* **halb acht = 7:30**, *not* 8:30 — German
  counts **toward** the next hour. *Tip (rule):* "Viertel nach / vor".
- *Samples:* `7:30 → halb acht` · `8:15 → Viertel nach acht` · `8:45 → Viertel vor neun`.

**10 · Wochentage & Monate** — fillBlank · streak · E1 · *improve*
- *Tip (rule):* days & months are **masculine** (*der Montag, der Mai*) and
  capitalised (E1); use **am** Montag, **im** Januar.
- *Samples:* `Monday → Montag` · `Saturday → Samstag` · `January → Januar`.

**11 · Hören: Termine & Uhrzeit** — listening · score · **(new)**
- *Topic chip:* "Verabredung · Anrufbeantworter". *Title:* "Eine Nachricht von Anna".
- **Script (German, hidden — ~50 words):** *"Hallo Tom, hier ist Anna. Wir treffen
  uns morgen, am Samstag. Der Film im Kino beginnt um halb acht. Komm bitte schon
  um sieben Uhr, dann essen wir vorher eine Pizza. Wir treffen uns direkt vor dem
  Kino. Mein Handy ist an — ruf mich bitte an! Bis morgen, tschüss!"*
- **Script (English, info button):** *"Hi Tom, this is Anna. We're meeting
  tomorrow, on Saturday. The film at the cinema starts at half past seven. Please
  come at seven o'clock, then we'll eat a pizza beforehand. We'll meet right in
  front of the cinema. My phone is on — please call me! See you tomorrow, bye!"*
- **Questions:**
  1. *Wann beginnt der Film?* — um 7 Uhr · **um halb acht (19:30)** ✓ · um 8 Uhr
  2. *Wo treffen sich Anna und Tom?* — im Kino · **vor dem Kino** ✓ · bei Anna
  3. *An welchem Tag treffen sie sich?* — Freitag · **Samstag** ✓ · Sonntag
- *Tip (mnemonic):* this reuses the **halb acht** trap from quiz 9 — the film is
  at **19:30**, the meeting at **19:00**. *New nouns → DB:* Film (m), Kino (n),
  Pizza (f), Handy (n).

**12 · Akkusativpräpositionen** — fillBlank · streak · *improve*
- *Tip (mnemonic):* the chant **"durch · für · gegen · ohne · um"** — these five
  **always** take the accusative, no exceptions.
- *Samples:* `Ich gehe ___ den Park (through). → durch` · `Das ist ___ dich (for).
  → für` · `Wir fahren ___ die Stadt (around). → um`.

**13 · Trennbare Verben** — fillBlank · streak · **⚑ E5** · *improve*
- *Intro:* verbs like *aufstehen, einkaufen, anrufen, fernsehen* split in use.
- *Tip (rule · E5):* in a main clause the **prefix flies to the end**: "Ich
  **stehe** um sieben **auf**." The stress is on the prefix (**AUF**stehen).
- *Samples:* `Ich ___ um 7 ___ (aufstehen). → stehe … auf` · `Sie ___ Brot ___
  (einkaufen). → kauft … ein`.

**14 · Sprechen: Einkaufen & Bestellen** — speakRepeat · play-through · **(new)**
- *Phrases (short→long):* "Ich hätte gern…" · "Ein Kilo Äpfel, bitte." · "Was
  kostet ein Brot?" · "Ich nehme die Bananen." · "Haben Sie auch Eier?" ·
  "Zusammen oder getrennt?"
- *Tip (mnemonic):* **"Ich hätte gern …"** is the polite all-purpose opener for
  any shop or café — bank it.

**15 · Lesen: *Eine kleine Reise*** — reading · score · *keep, polish* — travel,
  transport, weather; *mit dem* + dative (a forward glance to A2.1), times & prices.

### A2.1 — *Erlebnisse* · Experiences
**Can-do:** narrate the past, talk about a trip/weekend, give & follow
directions, describe weather. **Grammar:** **Perfekt** (haben/sein), Präteritum
of `war/hatte`, **dative articles**, dative prepositions, dative pronouns,
comparison (intro). **Big rocks:** E8, E3(Dat).

| # | Exercise | id | Type | Gate | Contrastive |
|---|----------|----|------|------|-------------|
| 1 | Perfekt mit *haben* | `quest_a2_1_perfekt_haben` | fillBlank | streak | E8 |
| 2 | Perfekt mit *sein* | `quest_a2_1_perfekt_sein` | fillBlank | streak | **⚑ E8** |
| 3 | Sprechen: Mein Wochenende | `quest_a2_1_sprechen_wochenende` | speakRepeat | play-through | |
| 4 | Dativ: bestimmte Artikel | `quest_a2_1_dativ_artikel` | fillBlank | streak | **⚑ E3** |
| 5 | Dativpräpositionen (aus/bei/mit…) | `quest_a2_1_dativ_praep` | fillBlank | streak | E3 |
| 6 | **Hören: Eine Reise erzählen** | `quest_a2_1_hoeren_reise` | listening | score | |
| 7 | Personalpronomen im Dativ | `quest_a2_1_pronomen_dativ` | fillBlank | streak | E3 |
| 8 | war & hatte (Präteritum) | `quest_a2_1_war_hatte` | fillBlank | streak | |
| 9 | Lesen: *Ein Wochenende in Hamburg* | `quest_a2_1_lesen_hamburg` | reading | score | |
| 10 | Wegbeschreibung & Verkehr | `quest_a2_1_wegbeschreibung` | fillBlank | streak | |
| 11 | Sprechen: Nach dem Weg fragen | `quest_a2_1_sprechen_weg` | speakRepeat | play-through | |
| 12 | Das Wetter & Jahreszeiten | `quest_a2_1_wetter` | fillBlank | streak | E20 |
| 13 | Komparativ (größer als…) | `quest_a2_1_komparativ` | fillBlank | streak | |
| 14 | **Hören: Wetterbericht** | `quest_a2_1_hoeren_wetter` | listening | score | |
| 15 | Lesen: *Emmas erste Woche in Deutschland* | `quest_a2_1_lesen_emma` | reading | score | |

### A2.2 — *Beschreiben & Planen* · Describe & plan
**Can-do:** describe people/rooms, say where things are, give reasons, talk about
health & clothes, make plans. **Grammar:** **Wechselpräpositionen**, reflexive
verbs, **`weil`/`dass`** (verb-final), Imperativ, superlative, `werden` (future
intro). **Big rocks:** E10, E11, E12.

| # | Exercise | id | Type | Gate | Contrastive |
|---|----------|----|------|------|-------------|
| 1 | Wechselpräpositionen: Wo? (Dativ) | `quest_a2_2_wechsel_wo` | fillBlank | streak | **⚑ E10** |
| 2 | Wechselpräpositionen: Wohin? (Akk) | `quest_a2_2_wechsel_wohin` | fillBlank | streak | **⚑ E10** |
| 3 | Sprechen: Mein Zimmer beschreiben | `quest_a2_2_sprechen_zimmer` | speakRepeat | play-through | E10 |
| 4 | Reflexive Verben (sich freuen…) | `quest_a2_2_reflexiv` | fillBlank | streak | |
| 5 | Nebensatz mit *weil* | `quest_a2_2_weil` | fillBlank | streak | **⚑ E11** |
| 6 | **Hören: Eine Verabredung** (making a plan) | `quest_a2_2_hoeren_verabredung` | listening | score | |
| 7 | Nebensatz mit *dass* | `quest_a2_2_dass` | fillBlank | streak | E11 |
| 8 | Körper & Gesundheit | `quest_a2_2_gesundheit` | fillBlank | streak | |
| 9 | Lesen: *Beim Arzt* | `quest_a2_2_lesen_arzt` | reading | score | |
| 10 | Imperativ (Mach! Machen Sie!) | `quest_a2_2_imperativ` | fillBlank | streak | E9 |
| 11 | Kleidung & Einkaufen | `quest_a2_2_kleidung` | fillBlank | streak | E20 |
| 12 | Sprechen: Personen beschreiben | `quest_a2_2_sprechen_person` | speakRepeat | play-through | |
| 13 | Superlativ (am größten / der größte) | `quest_a2_2_superlativ` | fillBlank | streak | |
| 14 | Wortstellung: TeKaMoLo | `quest_a2_2_tekamolo` | fillBlank | streak | **⚑ E12** |
| 15 | Lesen: *Eine E-Mail an einen Freund* | `quest_a2_2_lesen_email` | reading | score | |

### B1.1 — *Meinungen & Wünsche* · Opinions & wishes
**Can-do:** give opinions, make polite requests, hypothesise, talk about work/
study & future. **Grammar:** **Konjunktiv II** (würde/hätte/wäre/könnte),
**adjective endings** (the cliff), Genitiv (intro), relative clauses (Nom/Akk),
Futur I, `wenn`/`obwohl`. **Big rocks:** E13, E14, E15.

| # | Exercise | id | Type | Gate | Contrastive |
|---|----------|----|------|------|-------------|
| 1 | Die Welt der Arbeit | `quest_b1_1_arbeit` | fillBlank | streak | E20 |
| 2 | Adjektivendungen: bestimmter Artikel | `quest_b1_1_adj_bestimmt` | fillBlank | streak | **⚑ E13** |
| 3 | Adjektivendungen: unbestimmter Artikel | `quest_b1_1_adj_unbestimmt` | fillBlank | streak | **⚑ E13** |
| 4 | Sprechen: Höfliche Bitten | `quest_b1_1_sprechen_bitten` | speakRepeat | play-through | E14 |
| 5 | Konjunktiv II: würde + Infinitiv | `quest_b1_1_konj2_wuerde` | fillBlank | streak | **⚑ E14** |
| 6 | Konjunktiv II: hätte / wäre / könnte | `quest_b1_1_konj2_haette` | fillBlank | streak | E14 |
| 7 | **Hören: Ein Vorstellungsgespräch** (job interview) | `quest_b1_1_hoeren_interview` | listening | score | |
| 8 | Futur I (werden + Infinitiv) | `quest_b1_1_futur` | fillBlank | streak | |
| 9 | Lesen: *Die Zukunft der Arbeit* | `quest_b1_1_lesen_arbeit` | reading | score | |
| 10 | Relativsätze (Nom/Akk) | `quest_b1_1_relativ` | fillBlank | streak | |
| 11 | Genitiv (intro) + Possessivgenitiv | `quest_b1_1_genitiv` | fillBlank | streak | **⚑ E15** |
| 12 | Sprechen: Meinung äußern | `quest_b1_1_sprechen_meinung` | speakRepeat | play-through | |
| 13 | Nebensätze: wenn / als / obwohl | `quest_b1_1_konjunktionen` | fillBlank | streak | E11 |
| 14 | **Hören: Eine Radio-Umfrage** | `quest_b1_1_hoeren_umfrage` | listening | score | |
| 15 | Lesen: *Im Ausland studieren* | `quest_b1_1_lesen_studium` | reading | score | |

### B1.2 — *Erzählen & Begründen* · Narrate & justify
**Can-do:** tell a story in the past, explain processes, describe what is done,
report briefly. **Grammar:** **Präteritum** (narrative regular+irregular),
**werden-Passiv** (Präsens/Präteritum), relative clauses (Dat/Gen),
**n-Deklination**, infinitive clauses (`um…zu`, `ohne…zu`), two-part connectors.
**Big rocks:** E16, E17.

| # | Exercise | id | Type | Gate | Contrastive |
|---|----------|----|------|------|-------------|
| 1 | Technik & Medien | `quest_b1_2_technik` | fillBlank | streak | E20 |
| 2 | Präteritum: regelmäßig | `quest_b1_2_praet_reg` | fillBlank | streak | |
| 3 | Präteritum: unregelmäßig | `quest_b1_2_praet_unreg` | fillBlank | streak | |
| 4 | Sprechen: Eine Geschichte erzählen | `quest_b1_2_sprechen_geschichte` | speakRepeat | play-through | |
| 5 | Passiv Präsens (werden + Partizip) | `quest_b1_2_passiv` | fillBlank | streak | **⚑ E16** |
| 6 | Passiv Präteritum (wurde gemacht) | `quest_b1_2_passiv_praet` | fillBlank | streak | E16 |
| 7 | **Hören: Eine Nachricht / Durchsage** (announcement) | `quest_b1_2_hoeren_durchsage` | listening | score | |
| 8 | n-Deklination (den Jungen, dem Studenten) | `quest_b1_2_n_deklination` | fillBlank | streak | **⚑ E17** |
| 9 | Lesen: *Ein technisches Missgeschick* | `quest_b1_2_lesen_technik` | reading | score | |
| 10 | Infinitivsätze: um…zu / ohne…zu | `quest_b1_2_infinitiv` | fillBlank | streak | |
| 11 | Relativsätze (Dativ/Genitiv) | `quest_b1_2_relativ_dat` | fillBlank | streak | E15 |
| 12 | Sprechen: Etwas begründen | `quest_b1_2_sprechen_begruenden` | speakRepeat | play-through | |
| 13 | Konnektoren: entweder…oder / nicht nur…sondern auch | `quest_b1_2_konnektoren` | fillBlank | streak | |
| 14 | **Hören: Ein Podcast-Ausschnitt** | `quest_b1_2_hoeren_podcast` | listening | score | |
| 15 | Lesen: *Eine wahre Anekdote* | `quest_b1_2_lesen_anekdote` | reading | score | |

### B2.1 — *Argumentieren* · Argue
**Can-do:** argue & debate, report what others said, understand argumentative
texts, use a formal register. **Grammar:** **Konjunktiv I** (indirekte Rede),
passive (Perfekt + **modal passive** `kann gemacht werden`), Partizip I/II as
adjectives, Verben mit Präposition + **da-/wo-compounds**, connectors
(trotzdem/dennoch/folglich). **Big rocks:** E18, E16(advanced).

| # | Exercise | id | Type | Gate | Contrastive |
|---|----------|----|------|------|-------------|
| 1 | Gesellschaft & Politik | `quest_b2_1_gesellschaft` | fillBlank | streak | |
| 2 | Konjunktiv I: indirekte Rede | `quest_b2_1_konj1` | fillBlank | streak | **⚑ E18** |
| 3 | Indirekte Rede: Fragen & Bitten | `quest_b2_1_indirekt_fragen` | fillBlank | streak | E18 |
| 4 | Sprechen: Eine Meinung verteidigen | `quest_b2_1_sprechen_verteidigen` | speakRepeat | play-through | |
| 5 | Modalpassiv (kann gemacht werden) | `quest_b2_1_modalpassiv` | fillBlank | streak | **⚑ E16** |
| 6 | **Hören: Eine Diskussion / Debatte** | `quest_b2_1_hoeren_debatte` | listening | score | |
| 7 | Verben mit Präposition + da-/wo-Kompositum | `quest_b2_1_verben_praep` | fillBlank | streak | |
| 8 | Partizip I & II als Adjektiv | `quest_b2_1_partizip_adj` | fillBlank | streak | E19 |
| 9 | Lesen: *Pro & Contra: Homeoffice* | `quest_b2_1_lesen_homeoffice` | reading | score | |
| 10 | Konnektoren: trotzdem/dennoch/folglich | `quest_b2_1_konnektoren` | fillBlank | streak | |
| 11 | Sprechen: Ein Argument präsentieren | `quest_b2_1_sprechen_argument` | speakRepeat | play-through | |
| 12 | Passiv Perfekt (ist gemacht worden) | `quest_b2_1_passiv_perfekt` | fillBlank | streak | E16 |
| 13 | **Hören: Ein Nachrichtenbeitrag** (news report) | `quest_b2_1_hoeren_nachrichten` | listening | score | |
| 14 | Lesen: *Leserbrief an die Redaktion* | `quest_b2_1_lesen_leserbrief` | reading | score | |

### B2.2 — *Differenzieren* · Differentiate
**Can-do:** express unreal past, concede & qualify, nuance with particles, handle
formal genitive register. **Grammar:** **Konjunktiv II Vergangenheit** (hätte/
wäre gemacht, irreale Bedingungen/Wünsche), **Genitivpräpositionen** (trotz/
während/wegen/aufgrund), **erweiterte Partizipialattribute**, Funktionsverbgefüge
(intro), **Modalpartikeln** (doch/ja/mal/eben). **Big rocks:** E19, E15(adv).

| # | Exercise | id | Type | Gate | Contrastive |
|---|----------|----|------|------|-------------|
| 1 | Wissenschaft & Umwelt | `quest_b2_2_umwelt` | fillBlank | streak | |
| 2 | Konjunktiv II Vergangenheit (hätte gemacht) | `quest_b2_2_konj2_verg` | fillBlank | streak | **⚑ E14** |
| 3 | Irreale Bedingungssätze (wenn…hätte, …wäre) | `quest_b2_2_irreal` | fillBlank | streak | E14 |
| 4 | Sprechen: Hypothesen & Bedauern | `quest_b2_2_sprechen_hypothese` | speakRepeat | play-through | |
| 5 | Genitivpräpositionen (trotz/während/wegen) | `quest_b2_2_genitiv_praep` | fillBlank | streak | **⚑ E15** |
| 6 | **Hören: Ein Vortrag / eine Präsentation** | `quest_b2_2_hoeren_vortrag` | listening | score | |
| 7 | Erweitertes Partizipialattribut | `quest_b2_2_partizip_attribut` | fillBlank | streak | **⚑ E19** |
| 8 | Modalpartikeln (doch/ja/mal/eben) | `quest_b2_2_modalpartikeln` | fillBlank | streak | E20 |
| 9 | Lesen: *Klimawandel — was tun?* | `quest_b2_2_lesen_klima` | reading | score | |
| 10 | Funktionsverbgefüge (in Betracht ziehen…) | `quest_b2_2_fvg` | fillBlank | streak | |
| 11 | Sprechen: Einräumen & widersprechen | `quest_b2_2_sprechen_einraeumen` | speakRepeat | play-through | |
| 12 | Konzessivsätze (obwohl/wenngleich) | `quest_b2_2_konzessiv` | fillBlank | streak | |
| 13 | **Hören: Ein Interview mit einer Fachperson** | `quest_b2_2_hoeren_fachinterview` | listening | score | |
| 14 | Lesen: *Eine Buchrezension* | `quest_b2_2_lesen_rezension` | reading | score | |

### C1.1 — *Abstrahieren* · Abstract
**Can-do:** read/hear abstract argumentative texts, switch between nominal and
verbal style, use passive alternatives, write in a formal/academic register.
**Grammar:** **Nominalisierung ↔ Verbalisierung**, **Passiversatzformen**
(`sein+zu`, `sich lassen`, `‑bar`/`‑lich`), advanced connectors (insofern/
sofern/zumal), participial clauses, Verbalstil vs Nominalstil. **Big rocks:** E19.

| # | Exercise | id | Type | Gate | Contrastive |
|---|----------|----|------|------|-------------|
| 1 | Bildung & Wissenschaft (Wortschatz) | `quest_c1_1_bildung` | fillBlank | streak | |
| 2 | Nominalisierung (verbaler → nominaler Stil) | `quest_c1_1_nominalisierung` | fillBlank | streak | **⚑** |
| 3 | Verbalisierung (nominaler → verbaler Stil) | `quest_c1_1_verbalisierung` | fillBlank | streak | |
| 4 | Sprechen: Ein Thema strukturiert darstellen | `quest_c1_1_sprechen_darstellen` | speakRepeat | play-through | |
| 5 | Passiversatz: sein + zu / sich lassen | `quest_c1_1_passiversatz` | fillBlank | streak | **⚑ E16** |
| 6 | Passiversatz: Adjektive auf ‑bar / ‑lich | `quest_c1_1_bar_lich` | fillBlank | streak | |
| 7 | **Hören: Ein Universitätsvortrag** | `quest_c1_1_hoeren_vorlesung` | listening | score | |
| 8 | Konnektoren: insofern/sofern/zumal | `quest_c1_1_konnektoren` | fillBlank | streak | |
| 9 | Lesen: *Ein populärwissenschaftlicher Artikel* | `quest_c1_1_lesen_wissenschaft` | reading | score | |
| 10 | Partizipialsätze (verkürzte Nebensätze) | `quest_c1_1_partizipialsatz` | fillBlank | streak | E19 |
| 11 | Sprechen: Eine Grafik beschreiben | `quest_c1_1_sprechen_grafik` | speakRepeat | play-through | |
| 12 | Nomen-Verb-Verbindungen (formaler Stil) | `quest_c1_1_nomen_verb` | fillBlank | streak | |
| 13 | **Hören: Eine Diskussionsrunde** (panel) | `quest_c1_1_hoeren_podiumsdiskussion` | listening | score | |
| 14 | Lesen: *Ein Essay-Auszug* | `quest_c1_1_lesen_essay` | reading | score | |

### C1.2 — *Nuancieren* · Nuance
**Can-do:** grasp implication & tone, infer with modals, derive words, follow
fast idiomatic speech. **Grammar:** **subjektiver Gebrauch der Modalverben**
(*Er muss krank sein* = inference; *Sie soll reich sein* = hearsay), **Wortbildung**
(productive prefixes/suffixes), idioms & Redewendungen, advanced Funktionsverb-
gefüge, text cohesion, Modalpartikeln (advanced). **Big rocks:** E20.

| # | Exercise | id | Type | Gate | Contrastive |
|---|----------|----|------|------|-------------|
| 1 | Kultur & Medien (gehobener Wortschatz) | `quest_c1_2_kultur` | fillBlank | streak | |
| 2 | Subjektive Modalverben: Vermutung (muss/dürfte/könnte) | `quest_c1_2_modal_vermutung` | fillBlank | streak | **⚑** |
| 3 | Subjektive Modalverben: Hörensagen (soll/will) | `quest_c1_2_modal_hoerensagen` | fillBlank | streak | E18 |
| 4 | Sprechen: Andeuten & abschwächen | `quest_c1_2_sprechen_abschwaechen` | speakRepeat | play-through | |
| 5 | Wortbildung: Vorsilben (ver-/zer-/ent-/be-) | `quest_c1_2_wortbildung_vor` | fillBlank | streak | |
| 6 | Wortbildung: Nachsilben (-heit/-ung/-bar…) | `quest_c1_2_wortbildung_nach` | fillBlank | streak | E2 |
| 7 | **Hören: Eine Reportage** | `quest_c1_2_hoeren_reportage` | listening | score | |
| 8 | Redewendungen & feste Wendungen | `quest_c1_2_redewendungen` | fillBlank | streak | **⚑ E20** |
| 9 | Lesen: *Eine Kolumne / ein Kommentar* | `quest_c1_2_lesen_kolumne` | reading | score | |
| 10 | Textkohäsion: Verweismittel & Konnektoren | `quest_c1_2_kohaesion` | fillBlank | streak | |
| 11 | Sprechen: Ironie & Betonung | `quest_c1_2_sprechen_ironie` | speakRepeat | play-through | |
| 12 | Funktionsverbgefüge (fortgeschritten) | `quest_c1_2_fvg_adv` | fillBlank | streak | |
| 13 | **Hören: Ein Hörspiel-Ausschnitt** (radio drama) | `quest_c1_2_hoeren_hoerspiel` | listening | score | |
| 14 | Lesen: *Ein literarischer Text (Auszug)* | `quest_c1_2_lesen_literatur` | reading | score | |

### C2.1 — *Stilsicherheit* · Stylistic command
**Can-do:** command register & rhetoric, use idioms precisely, read demanding
literary/journalistic prose. **Grammar/usage:** register switching (formell ↔
umgangssprachlich), rhetorical structures, fixed collocations, advanced
connotation, **Konjunktiv I (literarisch)**, complex nominal/participial chains.
Ceiling = **GDS (C2)**.

| # | Exercise | id | Type | Gate | Contrastive |
|---|----------|----|------|------|-------------|
| 1 | Wirtschaft & Recht (Fachwortschatz) | `quest_c2_1_wirtschaft` | fillBlank | streak | |
| 2 | Register: formell ↔ umgangssprachlich | `quest_c2_1_register` | fillBlank | streak | **⚑** |
| 3 | Kollokationen (starke Wortpartner) | `quest_c2_1_kollokationen` | fillBlank | streak | E20 |
| 4 | Sprechen: Eine Rede halten | `quest_c2_1_sprechen_rede` | speakRepeat | play-through | |
| 5 | Stilmittel & Rhetorik | `quest_c2_1_stilmittel` | fillBlank | streak | |
| 6 | **Hören: Ein Feature / eine Dokumentation** | `quest_c2_1_hoeren_feature` | listening | score | |
| 7 | Konjunktiv I in literarischen/journalistischen Texten | `quest_c2_1_konj1_lit` | fillBlank | streak | E18 |
| 8 | Konnotation & Wortwahl | `quest_c2_1_konnotation` | fillBlank | streak | |
| 9 | Lesen: *Ein anspruchsvoller Zeitungsartikel* | `quest_c2_1_lesen_artikel` | reading | score | |
| 10 | Idiomatik: Sprichwörter | `quest_c2_1_sprichwoerter` | fillBlank | streak | **⚑ E20** |
| 11 | Sprechen: Spontan reagieren & moderieren | `quest_c2_1_sprechen_moderieren` | speakRepeat | play-through | |
| 12 | **Hören: Eine Satire / ein Kabarett-Ausschnitt** | `quest_c2_1_hoeren_satire` | listening | score | |
| 13 | Lesen: *Eine literarische Kurzgeschichte* | `quest_c2_1_lesen_kurzgeschichte` | reading | score | |

### C2.2 — *Meisterschaft* · Mastery  *(capstone — full C2 ceiling)*
**Can-do:** near-native comprehension & production; analyse abstract, implicit,
literary and journalistic discourse; appreciate wordplay, irony, and connotation.
This module is the **reading/listening ceiling**: passages and audio are GDS-level
in density, abstraction, and speed.

| # | Exercise | id | Type | Gate | Contrastive |
|---|----------|----|------|------|-------------|
| 1 | Philosophie & Gesellschaft (abstrakter Wortschatz) | `quest_c2_2_philosophie` | fillBlank | streak | |
| 2 | Feinheiten: Wortstellung & Fokus | `quest_c2_2_fokus` | fillBlank | streak | E12 |
| 3 | Anspielungen & implizite Bedeutung | `quest_c2_2_anspielung` | fillBlank | streak | **⚑** |
| 4 | Sprechen: Ein Streitgespräch führen | `quest_c2_2_sprechen_streitgespraech` | speakRepeat | play-through | |
| 5 | Stilistische Variation & Paraphrase | `quest_c2_2_paraphrase` | fillBlank | streak | |
| 6 | **Hören: Ein wissenschaftlicher Vortrag (Originaltempo)** | `quest_c2_2_hoeren_fachvortrag` | listening | score | |
| 7 | Wortspiel & Mehrdeutigkeit | `quest_c2_2_wortspiel` | fillBlank | streak | |
| 8 | Lesen: *Ein Essay (anspruchsvoll, abstrakt)* | `quest_c2_2_lesen_essay` | reading | score | |
| 9 | Fach- & Wissenschaftssprache | `quest_c2_2_wissenschaftssprache` | fillBlank | streak | |
| 10 | **Hören: Eine literarische Lesung** (author reading) | `quest_c2_2_hoeren_lesung` | listening | score | |
| 11 | Sprechen: Eine Analyse vortragen | `quest_c2_2_sprechen_analyse` | speakRepeat | play-through | |
| 12 | **Hören: Capstone — Podiumsdiskussion (mehrere Sprecher)** | `quest_c2_2_hoeren_capstone` | listening | score | |
| 13 | Lesen: *Capstone — literarischer Text mit Interpretation* | `quest_c2_2_lesen_capstone` | reading | score | |

---

## 9. Reading catalogue (Lesen — level-aligned, interesting)

German text first, English behind the info button. A recurring cast keeps the
A/B levels warm: **Anna & Tom** (a Berlin couple), the **Müller** family, and
exchange student **Emma** (an English speaker learning German — the audience's
mirror). Topics rise in abstraction with level; C-levels are journalistic/
literary.

- **A1.1** — *Das bin ich* (exists)
- **A1.2** — *Im Café* · *Eine kleine Reise* (exist)
- **A2.1** — *Ein Wochenende in Hamburg* · *Emmas erste Woche in Deutschland*
- **A2.2** — *Beim Arzt* · *Eine E-Mail an einen Freund*
- **B1.1** — *Die Zukunft der Arbeit* · *Im Ausland studieren*
- **B1.2** — *Ein technisches Missgeschick* · *Eine wahre Anekdote*
- **B2.1** — *Pro & Contra: Homeoffice* · *Leserbrief an die Redaktion*
- **B2.2** — *Klimawandel — was tun?* · *Eine Buchrezension*
- **C1.1** — *Populärwissenschaftlicher Artikel* · *Essay-Auszug*
- **C1.2** — *Eine Kolumne / ein Kommentar* · *Literarischer Text (Auszug)*
- **C2.1** — *Anspruchsvoller Zeitungsartikel* · *Literarische Kurzgeschichte*
- **C2.2** — *Essay (abstrakt)* · *Capstone: literarischer Text + Interpretation*

## 10. Listening catalogue (Hören — NEW, hidden audio scripts)

Each is a ~50-word German script TTS reads aloud (never shown; German+English
behind the info button). Genres mirror the Goethe Hören Module and escalate:
slow monologue → dialogue → announcement → interview/debate → lecture →
multi-speaker discussion.

- **A1.1** — *Begrüßung & Vorstellung* (slow self-intro) · *Im Geschäft — Zahlen & Preise* (market, prices)
- **A1.2** — *Im Café bestellen* (ordering dialogue) · *Termine & Uhrzeit* (answerphone message)
- **A2.1** — *Eine Reise erzählen* · *Wetterbericht*
- **A2.2** — *Eine Verabredung* (making a plan)
- **B1.1** — *Ein Vorstellungsgespräch* · *Eine Radio-Umfrage*
- **B1.2** — *Eine Durchsage* (station/airport announcement) · *Podcast-Ausschnitt*
- **B2.1** — *Eine Debatte* · *Ein Nachrichtenbeitrag*
- **B2.2** — *Ein Vortrag* · *Interview mit einer Fachperson*
- **C1.1** — *Universitätsvortrag* · *Podiumsdiskussion*
- **C1.2** — *Eine Reportage* · *Hörspiel-Ausschnitt*
- **C2.1** — *Ein Feature / Dokumentation* · *Satire / Kabarett*
- **C2.2** — *Fachvortrag (Originaltempo)* · *Literarische Lesung* · *Capstone: Podiumsdiskussion*

## 11. Speaking catalogue (Sprechen — listen & repeat, never needs a mic)

Two per module, short → long (word → phrase → sentence). Functions track the
Goethe Sprechen Module: self-presentation → asking/answering → requests →
opinions → argument → presentation → moderation → analysis. (See the `id`s in §8.)

---

## 12. Vocabulary & noun-list growth (authoring rules)

**Rule A — every new German noun used in any sentence, reading, or listening
script is added to [`germanNouns`](../lib/data/noun_database.dart).** Supply
`gender`, `english`, `categories` (from `nounCategoryDisplayNames`),
`difficulty`, and `declensionSafe` (false for weak/n-declension masculines like
*Junge, Student, Kollege* — these also feed the n-Deklination quiz in B1.2).
The `noun` string must be **unique** across the list (article/noun lookups build
name→noun maps). New categories the B/C levels will need: `politics`, `economy`,
`science`, `environment`, `law`, `arts`, `philosophy` — add them to
`nounCategoryDisplayNames` first.

**Rule B — never show the same fact twice** (the `no-duplicate-info-on-quiz-card`
principle, now a cert-wide rule):
- The contextual quiz prompt shows **English only**; the German is the
  interactive line. Strip trailing "(…)" cues that merely repeat the Case/subject
  (`stripSentenceCue`).
- The **Help Memory table** carries the reference/declension data; the
  `helpMemoryTips` carry rules/mnemonics. Don't restate a tip's content inside
  the table or vice-versa.
- The **PDF** (`help_memory_pdf.dart` / `QuizPdfTheme`) is generated from the
  same Help Memory source — so fixing duplication once fixes it everywhere. Keep
  intro → tips → table as three *non-overlapping* layers.

**Rule C — Help Memory completeness** (enforced by tests): every quiz (including
each new `listening`) ships a `helpMemoryIntro` + ≥1 `helpMemoryTip`; the big-rock
quiz of each module carries its **E#** contrastive `warning` and a named mnemonic
from §6.

---

## 13. Totals & effort

| Bucket | Count |
|--------|-------|
| Modules | **12** (A1.1 … C2.2) |
| Exercise types | **5** — `fillBlank`, `speakRepeat`, `reading`, `listening` **(new)**, `dictation` **(new)** |
| **Shipped & verified** (A1.1 = 17, A1.2 = 16) | **33** |
| ↳ of which new in this build | 4 Hören + 2 Diktat + 1 Vokalwechsel + 1 Sprechen = **8** |
| New `listening` (Hören, A2–C2) | ~20 |
| New `dictation` (Diktat, A2–C2) | ~10 (1/module) |
| New `reading` (A2–C2) | ~20 |
| New `speakRepeat` (A2–C2) | ~20 |
| New `fillBlank` (A2–C2, incl. verb-conjugation drills) | ~85 |
| **Grand total** | **≈ 190 quizzes** |

≈ **1,300–1,500 content items** (drill items + spoken phrases + reading questions
+ listening scripts/questions). Rough first-completion: A-levels ~50 min/module,
B-levels ~75 min, C-levels ~90 min. Certificate-ready when every chain quiz is
done (no separate weighted exam — same readiness model as `de_cert_a1`).

---

## 14. Engineering appendix (prerequisites before authoring lands)

Content-first, but these seams move first. The **listening quiz** is the only new
runtime feature; everything else is content + a chain extension.

**A. The new `listening` exercise type**
1. **Enum** — add `listening` to `QuizKind` in
   [quiz_content.dart](../lib/models/quiz_content.dart). `toJson`/`fromJson`
   already serialize `kind` by name; the reading fields are reused, so **no new
   serialized fields**.
2. **Page** — `lib/pages/listening_quiz_page.dart`, modelled on
   [reading_quiz_page.dart](../lib/pages/reading_quiz_page.dart) but: Stage-1
   play panel (no passage text) reusing the `TtsService` + `VoiceStatusChip` +
   pulsing indicator from [speak_repeat_quiz_page.dart](../lib/pages/speak_repeat_quiz_page.dart);
   auto-play on entry; **replay** button persistent into Stage 2; info button
   shows German **and** English script. Stage-2 questions are
   `ReadingQuizPage._buildQuestions` verbatim (extract to a shared widget or copy).
3. **Dispatch** — add `case QuizKind.listening:` in
   [quest_quiz_loader.dart](../lib/widgets/quest_quiz_loader.dart) →
   `ListeningQuizPage`.
4. **Icon/accent** — `quizKindIcon`/`quizKindColor` in
   [nav_layout_data.dart](../lib/data/nav_layout_data.dart) (ear icon, 4th accent;
   see §4.3).
5. **Exhaustive switches** — the compiler will flag every `switch (kind)` that
   isn't exhaustive: `app_drawer.dart` (`_buildQuestTile` kind/label switch ~L511
   and the default-icon switch ~L968) and `course_home_page.dart` (`_UiKind`).
   Add the `listening` case ("Listen & answer") to each — this is how we know we
   covered all surfaces.
6. **Completion/ribbon** — `NounSettings.markListeningQuizCompleted` + its
   completion set, mirroring `markReadingQuizCompleted`, so finished listening
   quizzes show the ribbon on the home/drawer.
7. **Builder** — `listeningQuestQuiz(...)` in
   [quest_builders.dart](../lib/data/quest/quest_builders.dart), a clone of
   `readingQuestQuiz` with `kind: QuizKind.listening`.
8. **Tests** — extend [reading_test.dart](../test/reading_test.dart): JSON
   round-trip for `listening`; every listening quiz has a passage + translation +
   ≥3 questions + intro + ≥1 tip; passage word-count ~40–60.
9. **TTS** — a ~50-word passage is one long utterance. The cloud neural voices
   handle it; for the on-device fallback, **chunk by sentence** so device TTS
   doesn't truncate. Confirm the chain in `lib/services/tts/`.

**B. Extending the Quest chain A2 → C2**
10. **Content files** — `quest_a2_1_content.dart … quest_c2_2_content.dart`
    (one per module), each exporting `questA2_1Content`, etc.
11. **Wire-up** — append them to `_compiledQuestEntries` in
    [quest_data.dart](../lib/data/quest_data.dart) with their `levelLabel`.
    `isQuestLevelUnlocked` / `firstLockedQuestIndex` already handle arbitrary
    sub-levels in chain order — no gating change needed.
12. **NavLayout** — extend the cert course's `questChain` group(s) and per-level
    `NavGroup.level` headers in the nav data so the drawer shows A2.1 … C2.2.
13. **Course title** — retitle `de_cert_a1`'s display to *"German Certification
    (A1–C2)"* in [course_catalog.dart](../lib/data/course_catalog.dart); **keep
    the id and all storage-key prefixes unchanged**.

**C. Ship it**
14. **Versioning** — bump `kDataVersion` in
    [data_version.dart](../lib/data/data_version.dart) (and the seed `"version"`);
    the atomic self-healing reseed ships the new modules + listening quizzes to
    existing installs.
15. **Docs** — as the volume grows, split fully-authored content into a
    `docs/de_cert/` folder (mirroring `docs/de_es/`), keeping this file the
    high-level map and `a1_competency_matrix.md` the A1 detail.

---

## Sources

- Goethe-Institut — exam overviews & syllabi (Start Deutsch 1, A2, Zertifikat B1,
  Goethe-Zertifikat B2 / C1 / C2 GDS) and the official A1/A2/B1 Wortlisten.
- Council of Europe — CEFR global + skill descriptors (A1–C2).
- Profile deutsch / DaF grammar inventories — grammar progression per level.
- Companion docs in this repo: [`a1_competency_matrix.md`](a1_competency_matrix.md)
  (A1 detail) and [`de_es_certification_plan.md`](de_es_certification_plan.md)
  (the contrastive-spine model this plan mirrors).
