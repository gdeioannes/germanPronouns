# Certificación Español (`de_es`) — Detailed Course Specification

Native **German speakers → learning Spanish** (🇩🇪→🇪🇸, `uiLang: de`). Mirrors the
`de_cert_a1` certification model (one streak-unlocked Quest chain, three
interleaved exercise types) and adds a **contrastive German→Spanish spine**
(see `../de_es_certification_plan.md`, table C1–C20).

This folder is the authoring spec:
- **`00_course_spec.md`** (this file) — totals, per-Quest counts, gating, streak,
  reading & audio models, progression rules.
- **`01_a_levels.md`** — full content for Quests A1.1, A1.2, A2.1, A2.2.
- **`02_b_levels.md`** — full content for Quests B1.1, B1.2, B2.

## 1. Totals at a glance

| Metric | Count |
|--------|-------|
| **Quests (modules)** | **7** (A1.1, A1.2, A2.1, A2.2, B1.1, B1.2, B2) |
| **Quizzes total** | **105** |
| — Knowledge (`fillBlank`) | 62 |
| — Audio / listen-&-repeat (`speakRepeat`) | 22 |
| — Reading (`reading`) | 21 |
| **Reading passages** | 21 (each with 4–6 comprehension questions) |
| **Audio exercises** | 22 (each 6–8 spoken phrases) + TTS on all 21 reading passages |
| **Drill items (knowledge)** | ≈ 660 German→Spanish items |
| **Spoken phrases (audio)** | ≈ 158 |
| **Reading questions** | ≈ 104 |
| **Dedicated contrastive quizzes (⚑)** | 22 |

## 2. Per-Quest breakdown

| Quest | Title | CEFR | Quizzes | Knowl. | Audio | Read. | Items¹ | Streak² | Time³ |
|-------|-------|------|:------:|:------:|:-----:|:-----:|:------:|:-------:|:-----:|
| **A1.1** | Primeros pasos | A1 | 14 | 8 | 4 | 2 | ~115 | 6 | 58 min |
| **A1.2** | Mi vida diaria | A1 | 15 | 9 | 3 | 3 | ~125 | 6 | 63 min |
| **A2.1** | Experiencias | A2 | 15 | 9 | 3 | 3 | ~125 | 7 | 68 min |
| **A2.2** | Describir y comparar | A2 | 15 | 9 | 3 | 3 | ~125 | 7 | 68 min |
| **B1.1** | Opiniones y deseos | B1 | 15 | 9 | 3 | 3 | ~125 | 8 | 78 min |
| **B1.2** | Relatos y conjeturas | B1 | 15 | 9 | 3 | 3 | ~125 | 8 | 78 min |
| **B2** | Argumentar y matizar | B2 | 16 | 9 | 3 | 4 | ~140 | 8 | 90 min |
| **Total** | | | **105** | **62** | **22** | **21** | **~920** | | ~9 h |

¹ Items = knowledge drill items + spoken phrases + reading questions (per Quest).
² Streak goal = consecutive correct answers that mark a knowledge quiz "done"
  (Quest unlock goal; configurable). It rises with level.
³ Rough first-completion time for the whole Quest.

## 3. Quiz anatomy (the three types)

**Knowledge — `fillBlank`** *(62 quizzes)*
- The German phrase/word is the prompt; the learner types the Spanish answer
  ("Sag es auf Spanisch"). Multiple accepted spellings; first-letter hint; eye
  icon reveals a German hint.
- **Done** at the Quest streak goal (consecutive correct).
- 8–14 items each. Vocab quizzes list a full finite set; grammar quizzes cover a
  full paradigm + applied sentences.

**Audio — `speakRepeat`** *(22 quizzes)*
- The app reads the Spanish phrase aloud (Spanish neural TTS); the German meaning
  is shown underneath; the learner repeats it. Optional STT for self-check.
- **Done** by *play-through* — heard to the end; **never needs a microphone**, so
  the certificate is completable on a mic-less device.
- 6–8 phrases each (model dialogues for self-intro, ordering, opinion, argument).

**Reading — `reading`** *(21 quizzes)*
- A Spanish passage (target language) with the German translation behind an info
  button; per-question German glosses behind info, so the learner reads Spanish
  first. Multiple-choice questions.
- **Done** by *score* ≥ ⅔ correct.
- Questions per level: **A1 = 4, A2 = 5, B1 = 5, B2 = 6.** Passages also get TTS
  playback (the "Hören" touchpoint).

## 4. Gating & progression model

1. **Linear chain.** All 91 quizzes form one ordered chain; finishing a quiz
   unlocks the next (`firstLockedQuestIndex`).
2. **Type interleave.** No two `fillBlank` back-to-back without an audio or
   reading between them.
3. **Sub-level lock.** A whole Quest unlocks only once **every** quiz in all
   previous Quests is done (`isQuestLevelUnlocked`, `NavGroup.level`). So A2.1
   stays locked until all of A1.1 + A1.2 is complete.
4. **One new "big rock" per Quest** (see progression spine below); everything
   prior is recycled inside later items.
5. **Certificate-ready** when all 91 are done. No separate weighted exam (same
   readiness model as `de_cert_a1`).

### Progression spine (what's *new* vs *recycled* per Quest)

| Quest | New "big rock" | Recycles |
|-------|----------------|----------|
| A1.1 | present of `ser`, `-ar` verbs, gender, numbers | — |
| A1.2 | `ser` vs `estar` (intro), `gustar`, full present, `ir a` | A1.1 vocab, `ser`, articles |
| A2.1 | past: `pretérito indefinido` + `perfecto`, OD pronouns, personal `a` | present, `ser`/`estar`, gender |
| A2.2 | `imperfecto` vs `indefinido` (aspect), comparison, OI pronouns, `por`/`para` (intro) | both pasts, adjectives, `gustar` |
| B1.1 | present subjunctive (triggers), future, imperative | all pasts, pronouns |
| B1.2 | conditional, pluscuamperfecto, reported speech, more subjunctive | subjunctive, narration |
| B2 | imperfect subjunctive, unreal conditionals, `verbos de cambio`, `ser`/`estar` advanced, passive | everything |

**Why this order (for German speakers):** the two cliffs are *aspect*
(`indefinido` vs `imperfecto`, no German equivalent) and the *trigger-based
subjunctive* (German `Konjunktiv` works differently). They are deliberately
**separated** — aspect mastered across A2 before mood begins at B1 — so a learner
never fights both at once. `ser`/`estar`, `por`/`para`, and the subjunctive each
**spiral** (intro → consolidate → advanced) rather than landing once.

## 5. Reading passage arc (level-locked, but adult & interesting)

A recurring cast keeps it engaging; topics rise in abstraction with level. The
A-levels follow **Anna** (a German med student in Madrid) and exchange student
**Lukas** — protagonists the audience identifies with.

| Quest | Passages |
|-------|----------|
| A1.1 | *¡Hola! Me llamo Anna* · *Mi compañera de piso* |
| A1.2 | *Un día con la familia García* · *En el mercado* · *La casa de Anna* |
| A2.1 | *Un fin de semana en Valencia* · *El viaje de Lukas a Madrid* · *Una fiesta sorpresa* |
| A2.2 | *Mi infancia en un pueblo* · *Un correo a un amigo alemán* · *Antes y ahora* |
| B1.1 | *El futuro del trabajo* · *Una carta de recomendación* · *Estudiar en el extranjero* |
| B1.2 | *Una anécdota de viaje* · *Carta al director* · *Un perro héroe* |
| B2 | *¿Energía nuclear, sí o no?* · *El teletrabajo, ¿ventaja o trampa?* · *Reseña de una novela* · *Artículo de opinión* |

## 6. Implementation prerequisites

Carried over from `../de_es_certification_plan.md` §8 — most important:
`UiLang.de` must be added; the Quest chain in `lib/data/quest_data.dart` must
become **course-scoped** (it's currently single/global, German-only) or the
course uses level-gated `quizzes` groups; a Spanish neural TTS voice must be in
the chain; bump `kDataVersion`.
