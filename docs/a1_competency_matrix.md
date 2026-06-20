# Certification German A1 — Competency Matrix

Authoritative mapping of every exercise in the **`de_cert_a1`** course (the Quest
chain across sub-levels A1.1 and A1.2) to its Goethe-Institut A1 (*Start Deutsch 1*)
competency. Goethe A1 is the scope ceiling — nothing here exceeds A1.

This is a companion authoring doc (decided in planning): the competency data lives
here rather than as serialized `QuizContent` fields, so the content schema and the
seed/version pipeline stay unchanged. Keep this file in sync when quizzes are
added, removed, or reordered.

## Legend

- **Skill** — Knowledge (grammar/vocabulary recall), Speaking (listen & repeat),
  Reading (comprehension).
- **Type** — `fillBlank`, `speakRepeat`, `reading` (the `QuizContent.kind`).
- **Gate** — how the quiz unlocks the next chain entry: *streak* (reach the Quest
  streak goal), *play-through* (speaking — completed once heard to the end; never
  needs a microphone), *score* (reading — pass ≥ ⅔ of the questions).
- **Wt** — relative certification weight (1 = standard knowledge quiz; speaking and
  reading skill exercises ≈ 2).
- **Time** — rough minutes for a first completion.

## A1.1 — "Erste Schritte"

| # | Exercise | id | Goethe objective | Vocab group | Grammar topic | Skill | Type | Gate | Diff | Time | Wt |
|---|----------|----|------------------|-------------|---------------|-------|------|------|------|------|----|
| 1 | Zahlen 0–10 | `quest_a1_1_zahlen` | Numbers for prices/age/phone | Numbers | Cardinal numbers | Knowledge | fillBlank | streak | beginner | 4 | 1 |
| 2 | Personalpronomen | `quest_a1_1_pronomen` | Talk about people | Pronouns | Nominative personal pronouns | Knowledge | fillBlank | streak | beginner | 4 | 1 |
| 3 | **Sprechen: Vorstellung** | `quest_a1_1_sprechen_vorstellung` | Introduce yourself; greet | Greetings, personal info | Statements & W-questions (spoken) | Speaking | speakRepeat | play-through | beginner | 6 | 2 |
| 4 | Artikel im Nominativ | `quest_a1_1_artikel` | Name things with article | Everyday objects | der/die/das, ein/eine (nom.) | Knowledge | fillBlank | streak | beginner | 5 | 1 |
| 5 | Zahlen 11–20 | `quest_a1_1_zahlen2` | Numbers | Numbers | Cardinal numbers (teens) | Knowledge | fillBlank | streak | beginner | 4 | 1 |
| 6 | **W-Fragen** | `quest_a1_1_wfragen` | Ask for information | Question words | W-questions, verb-second | Knowledge | fillBlank | streak | beginner | 5 | 1 |
| 7 | sein & haben | `quest_a1_1_sein_haben` | Describe/possess | — | Present tense (irregular) | Knowledge | fillBlank | streak | beginner | 5 | 1 |
| 8 | Farben | `quest_a1_1_farben` | Describe things | Colours | Predicative adjectives | Knowledge | fillBlank | streak | beginner | 4 | 1 |
| 9 | **Lesen: Das bin ich** | `quest_a1_1_lesen_dasbinich` | Understand a short self-intro text | Personal info, daily life | Present tense; W-questions | Reading | reading | score | beginner | 6 | 2 |
| 10 | Zahlen 20–100 | `quest_a1_1_zahlen3` | Prices, age | Numbers | Compound numbers | Knowledge | fillBlank | streak | beginner | 5 | 1 |
| 11 | Regelmäßige Verben | `quest_a1_1_praesens` | Talk about activities | Common verbs | Present tense (regular) | Knowledge | fillBlank | streak | beginner | 6 | 1 |
| 12 | Familie & Menschen | `quest_a1_1_familie` | Talk about family | Family & people | Nouns with article; -in forms | Knowledge | fillBlank | streak | beginner | 5 | 1 |
| 13 | **Sprechen: Zahlen & Preise** | `quest_a1_1_sprechen_zahlen` | Say numbers/prices aloud | Numbers, prices | Pronunciation (z/ei) | Speaking | speakRepeat | play-through | beginner | 5 | 2 |

## A1.2 — "Im Alltag"

| # | Exercise | id | Goethe objective | Vocab group | Grammar topic | Skill | Type | Gate | Diff | Time | Wt |
|---|----------|----|------------------|-------------|---------------|-------|------|------|------|------|----|
| 1 | Akkusativ (Artikel) | `quest_a1_2_akkusativ` | Talk about objects of actions | Everyday objects | Accusative articles | Knowledge | fillBlank | streak | beginner | 5 | 1 |
| 2 | Possessivartikel | `quest_a1_2_possessiv` | Talk about belongings | Family, objects | Possessives (nom./akk.) | Knowledge | fillBlank | streak | beginner | 6 | 1 |
| 3 | **Personalpronomen (Akkusativ)** | `quest_a1_2_pronomen_akk` | Refer to people/things as objects | Pronouns | Accusative personal pronouns | Knowledge | fillBlank | streak | beginner | 5 | 1 |
| 4 | Negation (kein/nicht) | `quest_a1_2_negation` | Say what is not / none | — | kein vs nicht | Knowledge | fillBlank | streak | beginner | 6 | 1 |
| 5 | **Lesen: Im Café** | `quest_a1_2_lesen_cafe` | Understand an ordering scene | Food & drink, prices | möchten/nehmen/bestellen/bezahlen | Reading | reading | score | beginner | 6 | 2 |
| 6 | Modalverben | `quest_a1_2_modalverben` | Express ability/wish/need | — | Modal verbs | Knowledge | fillBlank | streak | beginner | 6 | 1 |
| 7 | Uhrzeit | `quest_a1_2_uhrzeit` | Tell the time | Time | Colloquial clock time | Knowledge | fillBlank | streak | beginner | 6 | 1 |
| 8 | **Sprechen: Alltag & Uhrzeit** | `quest_a1_2_sprechen_alltag` | Describe routine; say the time | Daily routine, time | Separable verbs (spoken) | Speaking | speakRepeat | play-through | beginner | 6 | 2 |
| 9 | Wochentage & Monate | `quest_a1_2_datum` | Dates and appointments | Time/calendar | Days/months; am/im | Knowledge | fillBlank | streak | beginner | 5 | 1 |
| 10 | Akkusativpräpositionen | `quest_a1_2_praepositionen` | Express purpose/direction | — | durch/für/gegen/ohne/um + akk. | Knowledge | fillBlank | streak | beginner | 6 | 1 |
| 11 | **Lesen: Eine kleine Reise** | `quest_a1_2_lesen_reise` | Understand a travel text | Travel, transport, weather | mit dem + dative; times/prices | Reading | reading | score | beginner | 7 | 2 |
| 12 | Trennbare Verben | `quest_a1_2_trennbare` | Describe daily actions | Daily-routine verbs | Separable verbs | Knowledge | fillBlank | streak | beginner | 6 | 1 |

## Goethe A1 skill coverage

| Goethe skill area | Where it is covered |
|-------------------|---------------------|
| **Sprechen** (introduce yourself, ask/answer, requests) | A1.1 Sprechen: Vorstellung & Zahlen; A1.2 Sprechen: Alltag & Uhrzeit; reinforced by W-Fragen, pronouns |
| **Lesen** (short texts: personal, café/menu, travel) | A1.1 Lesen: Das bin ich; A1.2 Lesen: Im Café & Eine kleine Reise |
| **Hören** (partial) | TTS playback in the three speaking exercises (listen → repeat) |
| **Grammar & vocabulary** | All `fillBlank` knowledge quizzes across A1.1/A1.2 |
| **Schreiben** | Out of scope for this iteration (not required by the brief) |

## Notes

- **Readiness model:** streak-completion. The course is "certificate-ready" when
  every chain quiz is *done* — knowledge via the Quest streak goal, speaking via
  play-through, reading via a passing score. There is no separate weighted exam;
  the `Wt` column is for authoring balance only.
- **Microphone independence:** speaking never blocks progression (play-through
  gate), so the certificate is fully completable on a device without a microphone.
- **Anti-repetition:** types are interleaved (no two same-type quizzes
  back-to-back); each reading passage and speaking phrase set is unique; numbers,
  grammar, and topics rotate across the chain.
