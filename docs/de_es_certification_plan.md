# Certificación Español (`de_es`) — Content Plan

A new **certification course for native German speakers learning Spanish**
(`speak 🇩🇪 → learn 🇪🇸`, `uiLang: de`). It mirrors the `de_cert_a1` model: a
single ordered, streak-unlocked **Quest chain** split into CEFR sub-levels, with
three interleaved exercise types — `fillBlank` (knowledge), `speakRepeat`
(listen & repeat), `reading` (comprehension). What makes this course distinct is
a **contrastive spine**: every level explicitly teaches the points where Spanish
diverges from German, because that is where German speakers actually struggle.

This is a companion authoring doc (like `a1_competency_matrix.md`): the
competency/contrastive mapping lives here, not as serialized `QuizContent`
fields, so the content schema and the seed/version pipeline stay unchanged. Keep
this in sync when quizzes are added, removed, or reordered.

> **Fully authored content** (every quiz's items, reading passages, audio
> phrases, tips) lives in [`de_es/`](de_es/): the spec/counts in
> [`00_course_spec.md`](de_es/00_course_spec.md), the A-levels in
> [`01_a_levels.md`](de_es/01_a_levels.md), the B-levels in
> [`02_b_levels.md`](de_es/02_b_levels.md). This file is the high-level map.

## 1. Ladder & scope

Seven modules, smooth full progression (no skipped sub-levels), A1 → B2:

| Module | Title (Spanish · German) | CEFR | DELE alignment | Focus leap |
|--------|--------------------------|------|----------------|------------|
| **A1.1** | Primeros pasos · *Erste Schritte* | A1 | DELE A1 (part) | Identity, sounds, present of `ser` |
| **A1.2** | Mi vida diaria · *Mein Alltag* | A1 | DELE A1 (part) | `ser`/`estar` intro, `gustar`, full present |
| **A2.1** | Experiencias · *Erlebnisse* | A2 | DELE A2 (part) | Past begins (`indefinido`/`perfecto`) |
| **A2.2** | Describir y comparar · *Beschreiben* | A2 | DELE A2 (part) | `imperfecto` vs `indefinido`, comparison |
| **B1.1** | Opiniones y deseos · *Meinungen* | B1 | DELE B1 (part) | Present subjunctive, future |
| **B1.2** | Relatos y conjeturas · *Erzählen* | B1 | DELE B1 (part) | Conditional, reported speech, more subjunctive |
| **B2** | Argumentar y matizar · *Argumentieren* | B2 | DELE B2 | Imperfect subjunctive, unreal conditionals, nuance |

**Official anchors** (what each level *must* cover):
- **CEFR / MCER** descriptors (Council of Europe) for can-do objectives.
- **Plan Curricular del Instituto Cervantes (PCIC)** — *Niveles de referencia
  para el español* — the grammar/function/notion inventories per level. This is
  the authoritative Spanish-specific syllabus and drives the grammar columns
  below.
- **DELE exam blueprints** (Instituto Cervantes) — themes and the four skills
  (comprensión de lectura, comprensión auditiva, expresión escrita, expresión
  oral) shape exercise types and reading topics.

## 2. Progression principles

1. **One new "big rock" per module.** Each module introduces a single hard
   structure (the *Focus leap* column) and recycles everything prior. No module
   stacks two alien systems at once.
2. **Spiral, don't dump.** `ser`/`estar`, `por`/`para`, and the subjunctive each
   appear as *intro → consolidation → advanced* across multiple modules rather
   than once.
3. **Aspect before mood.** Past-tense aspect (`indefinido` vs `imperfecto`, A2)
   is mastered before the subjunctive (B1), since both are the two cliffs for
   German speakers and shouldn't collide.
4. **Interleave types.** Never two `fillBlank` back-to-back without a
   `speakRepeat` or `reading` breaking them up (same rule as `de_cert_a1`).
5. **Reading is level-locked but interesting.** Passages use only grammar
   already taught, but the *topics* are adult and engaging (a German exchange
   student in Madrid, a debate on nuclear energy, a novel review). Spanish text
   first; German translation behind an info button.
6. **Gate the next sub-level.** A module's quizzes unlock as a block only when
   every quiz in all preceding sub-levels is done (`isQuestLevelUnlocked`).

## 3. The contrastive spine (German → Spanish)

The course's signature. Each row is a recurring "⚠️ Für Deutschsprachige" tip
woven into the relevant quizzes' Help Memory (`helpMemoryTips`), plus dedicated
contrastive quizzes (marked **⚑** in the tables).

| # | Spanish feature | Why a German speaker trips | First taught |
|---|-----------------|----------------------------|--------------|
| C1 | `¿…?` `¡…!` inverted opening marks | Don't exist in German | A1.1 |
| C2 | 2 genders, often guessable (`-o`/`-a`) vs der/die/das | Fewer genders but new assignments; *no* neuter | A1.1 |
| C3 | Lowercase nationalities, languages, days, months | German capitalises every noun | A1.1 |
| C4 | 5 pure vowels; `j`/`g`=[x] (≈ *ach-Laut*, a bridge!); `rr`; `c`/`z`=[θ]; no vowel length | German vowel length/umlaut habits, hard `r` | A1.1 |
| C5 | Pro-drop (subject pronoun usually omitted) | German subject is obligatory | A1.1 |
| C6 | `tener … años` for age | German uses *sein* ("ich bin 30") | A1.2 |
| C7 | **`ser` vs `estar`** (both = *sein*) | The #1 hurdle; German has one verb | A1.2 → A2.2 → B2 |
| C8 | **`gustar`** (indirect: "me gusta el café") | German *mögen* is direct subject-verb-object | A1.2 |
| C9 | Personal **`a`** ("veo **a** María") | No German equivalent | A2.1 |
| C10 | Object-pronoun proclisis ("**lo** veo") + doubling | Different placement/doubling vs German | A2.1 → A2.2 |
| C11 | **`indefinido` vs `imperfecto`** (aspect) | German speech uses *Perfekt*, no aspect split | A2.2 |
| C12 | **`por` vs `para`** | German prepositions don't split this way | A2.2 → B1.2 |
| C13 | `-ísimo` absolute superlative | No direct German form | A2.2 |
| C14 | **Trigger-based subjunctive** ("quiero que **vengas**") | German *Konjunktiv* exists but isn't triggered this way | B1.1 → B1.2 |
| C15 | Negative imperative uses subjunctive ("no **hables**") | German just negates the imperative | B1.1 |
| C16 | Conditional for politeness (`querría`, `podría`) | Maps to *Konjunktiv II* (würde/könnte) — a bridge, but forms differ | B1.2 |
| C17 | **Unreal conditionals** ("si **tuviera**, …**ría**") | Strong bridge to *wenn ich … hätte, würde ich* — exploit it | B2 |
| C18 | **Verbos de cambio** (`ponerse`/`volverse`/`hacerse`/`quedarse`) | German has one *werden*; Spanish splits by nuance | B2 |
| C19 | `se`-passive / impersonal preferred over `ser`+participio | German leans on *werden*-Passiv | B2 |
| C20 | False friends (*falsche Freunde*) | `el mantel`≠Mantel, `la firma`≠Firma, `el vaso`≠Vase, `gimnasio`≠Gymnasium | sprinkled A1–B2 |

---

## 4. Module syllabi

Legend (same as `a1_competency_matrix.md`): **Type** = `QuizContent.kind`;
**Gate** = *streak* (knowledge), *play-through* (speaking, never needs a mic),
*score* (reading, ≥ ⅔). **⚑** = dedicated contrastive quiz.

> **Note:** the tables below show each Quest's original core. Each Quest was then
> given **+1 reading and +1 audio**; the fully renumbered lists (105 quizzes
> total) live in [`de_es/`](de_es/). Counts in §7 are current.

### A1.1 — Primeros pasos · *Erste Schritte*
**Can-do (CEFR):** greet, introduce oneself, spell, give nationality/origin and
job, count 0–20, ask basic personal questions.
**PCIC grammar:** present of `ser`, `llamarse`, regular `-ar`; subject pronouns;
noun gender `-o`/`-a`; definite/indefinite articles; `qué/quién/cómo/dónde`;
`¿?` `¡!`.
**Vocab:** saludos y cortesía, alfabeto, números 0–20, países/nacionalidades,
profesiones.

| # | Exercise | id | Type | Gate | Contrastive |
|---|----------|----|------|------|-------------|
| 1 | Saludos y cortesía | `de_es_a1_1_saludos` | fillBlank | streak | C1 |
| 2 | El alfabeto y los sonidos | `de_es_a1_1_alfabeto` | speakRepeat | play-through | **⚑ C4** |
| 3 | Pronombres personales | `de_es_a1_1_pronombres` | fillBlank | streak | C5 |
| 4 | El verbo *ser* | `de_es_a1_1_ser` | fillBlank | streak | |
| 5 | Sprechen: ¿Cómo te llamas? | `de_es_a1_1_sprechen_vorstellung` | speakRepeat | play-through | |
| 6 | Números 0–20 | `de_es_a1_1_numeros` | fillBlank | streak | |
| 7 | Países y nacionalidades | `de_es_a1_1_nacionalidades` | fillBlank | streak | **⚑ C3** |
| 8 | Género: el/la, un/una | `de_es_a1_1_genero` | fillBlank | streak | **⚑ C2** |
| 9 | Lesen: *¡Hola! Me llamo Anna* | `de_es_a1_1_lesen_presentacion` | reading | score | |
| 10 | Profesiones | `de_es_a1_1_profesiones` | fillBlank | streak | |
| 11 | Verbos regulares en *-ar* | `de_es_a1_1_verbos_ar` | fillBlank | streak | |
| 12 | Sprechen: Números y deletrear | `de_es_a1_1_sprechen_numeros` | speakRepeat | play-through | C4 |

### A1.2 — Mi vida diaria · *Mein Alltag*
**Can-do:** talk about family, daily routine, likes/dislikes, order food, tell
the time, basic shopping.
**PCIC grammar:** `-er`/`-ir` present; irregulars `estar/tener/ir/hacer`;
**`ser` vs `estar` (intro)**; **`gustar`**; possessives `mi/tu/su`; plural;
numbers 20–100; `ir a` + infinitive.
**Vocab:** familia, comida y bebida, la casa, rutina, días, la hora.

| # | Exercise | id | Type | Gate | Contrastive |
|---|----------|----|------|------|-------------|
| 1 | La familia | `de_es_a1_2_familia` | fillBlank | streak | C20 (false friend *Familiennamen*) |
| 2 | Verbos en *-er* / *-ir* | `de_es_a1_2_verbos_er_ir` | fillBlank | streak | |
| 3 | *ser* vs *estar* (intro) | `de_es_a1_2_ser_estar` | fillBlank | streak | **⚑ C7** |
| 4 | Sprechen: Mi familia | `de_es_a1_2_sprechen_familia` | speakRepeat | play-through | |
| 5 | *tener* y la edad | `de_es_a1_2_tener` | fillBlank | streak | **⚑ C6** |
| 6 | Me gusta / *gustar* | `de_es_a1_2_gustar` | fillBlank | streak | **⚑ C8** |
| 7 | Lesen: *Un día con la familia García* | `de_es_a1_2_lesen_familia` | reading | score | |
| 8 | La comida y la bebida | `de_es_a1_2_comida` | fillBlank | streak | |
| 9 | La hora y los días | `de_es_a1_2_hora` | fillBlank | streak | C3 |
| 10 | Sprechen: En el restaurante | `de_es_a1_2_sprechen_restaurante` | speakRepeat | play-through | |
| 11 | Posesivos (mi/tu/su) | `de_es_a1_2_posesivos` | fillBlank | streak | |
| 12 | *ir a* + infinitivo (futuro próximo) | `de_es_a1_2_ir_a` | fillBlank | streak | |
| 13 | Lesen: *En el mercado* | `de_es_a1_2_lesen_mercado` | reading | score | |

### A2.1 — Experiencias · *Erlebnisse*
**Can-do:** narrate past events, talk about a weekend/trip, ask for and give
directions, describe a town, talk about the weather.
**PCIC grammar:** **`pretérito indefinido`** (regular + `ser/ir/estar/tener/
hacer`); **`pretérito perfecto`** (`he hablado`); `perfecto` vs `indefinido`
(`ya/todavía` vs `ayer`); `hay` vs `estar`; direct-object pronouns `lo/la/los/
las`; **personal `a`**.
**Vocab:** la ciudad, transporte, viajes, tiempo libre, el tiempo (clima).

| # | Exercise | id | Type | Gate | Contrastive |
|---|----------|----|------|------|-------------|
| 1 | La ciudad y los lugares | `de_es_a2_1_ciudad` | fillBlank | streak | |
| 2 | Pretérito perfecto (he + participio) | `de_es_a2_1_perfecto` | fillBlank | streak | |
| 3 | Sprechen: ¿Qué has hecho hoy? | `de_es_a2_1_sprechen_hoy` | speakRepeat | play-through | |
| 4 | Indefinido: verbos regulares | `de_es_a2_1_indefinido_reg` | fillBlank | streak | |
| 5 | Indefinido: irregulares | `de_es_a2_1_indefinido_irreg` | fillBlank | streak | |
| 6 | Lesen: *Un fin de semana en Valencia* | `de_es_a2_1_lesen_valencia` | reading | score | |
| 7 | Pronombres de OD (lo/la) | `de_es_a2_1_od` | fillBlank | streak | **⚑ C10** |
| 8 | La *a* personal | `de_es_a2_1_a_personal` | fillBlank | streak | **⚑ C9** |
| 9 | Transporte y direcciones | `de_es_a2_1_direcciones` | fillBlank | streak | |
| 10 | Sprechen: Pedir y dar direcciones | `de_es_a2_1_sprechen_direcciones` | speakRepeat | play-through | |
| 11 | El tiempo (clima) | `de_es_a2_1_clima` | fillBlank | streak | C7 (*hace frío* vs *estar*) |
| 12 | Lesen: *El viaje de Lukas a Madrid* | `de_es_a2_1_lesen_lukas` | reading | score | |
| 13 | perfecto vs indefinido | `de_es_a2_1_perf_vs_indef` | fillBlank | streak | C11 (intro) |

### A2.2 — Describir y comparar · *Beschreiben*
**Can-do:** describe people/places in the past, talk about childhood, compare,
talk about clothes/health, say what is happening now.
**PCIC grammar:** **`pretérito imperfecto`**; **`imperfecto` vs `indefinido`**
(aspect); comparatives (`más/menos…que`, `tan…como`, `mejor/peor`) + superlative
(`-ísimo`, `el más`); indirect-object pronouns `le/les` + doubling; `estar` +
gerundio; **`por` vs `para` (intro)**.
**Vocab:** el cuerpo y la salud, la ropa, descripción física y de carácter, la
naturaleza.

| # | Exercise | id | Type | Gate | Contrastive |
|---|----------|----|------|------|-------------|
| 1 | El cuerpo y la salud | `de_es_a2_2_cuerpo` | fillBlank | streak | |
| 2 | Pretérito imperfecto | `de_es_a2_2_imperfecto` | fillBlank | streak | |
| 3 | imperfecto vs indefinido | `de_es_a2_2_imp_vs_indef` | fillBlank | streak | **⚑ C11** |
| 4 | Sprechen: Cuando era niño… | `de_es_a2_2_sprechen_infancia` | speakRepeat | play-through | |
| 5 | Comparativos y superlativos | `de_es_a2_2_comparativos` | fillBlank | streak | **⚑ C13** |
| 6 | Lesen: *Mi infancia en un pueblo* | `de_es_a2_2_lesen_infancia` | reading | score | |
| 7 | Pronombres de OI (le/les) | `de_es_a2_2_oi` | fillBlank | streak | C10 |
| 8 | estar + gerundio | `de_es_a2_2_gerundio` | fillBlank | streak | |
| 9 | La ropa y las compras | `de_es_a2_2_ropa` | fillBlank | streak | C20 |
| 10 | Sprechen: Describir a una persona | `de_es_a2_2_sprechen_describir` | speakRepeat | play-through | C7 |
| 11 | por vs para (intro) | `de_es_a2_2_por_para` | fillBlank | streak | **⚑ C12** |
| 12 | Lesen: *Un correo a un amigo alemán* | `de_es_a2_2_lesen_correo` | reading | score | |
| 13 | Descripción de carácter | `de_es_a2_2_caracter` | fillBlank | streak | C7 (*ser* simpático / *estar* cansado) |

### B1.1 — Opiniones y deseos · *Meinungen*
**Can-do:** express opinions, wishes, give advice, talk about the future, real
hypotheses, express feelings.
**PCIC grammar:** **`presente de subjuntivo`** (forms + uses: `querer que`, `es
importante que`, `ojalá`, `recomendar que`); **`futuro imperfecto`**; imperative
(affirmative + **negative with subjunctive**); real conditionals (`si` +
presente, futuro); double object pronouns (`se lo`).
**Vocab:** trabajo y estudios, medios de comunicación, sentimientos, planes.

| # | Exercise | id | Type | Gate | Contrastive |
|---|----------|----|------|------|-------------|
| 1 | El mundo del trabajo | `de_es_b1_1_trabajo` | fillBlank | streak | C20 (*el gimnasio* etc.) |
| 2 | Futuro imperfecto | `de_es_b1_1_futuro` | fillBlank | streak | |
| 3 | Sprechen: Mis planes de futuro | `de_es_b1_1_sprechen_planes` | speakRepeat | play-through | |
| 4 | Presente de subjuntivo: formas | `de_es_b1_1_subj_formas` | fillBlank | streak | C14 |
| 5 | Subjuntivo: deseos (querer que, ojalá) | `de_es_b1_1_subj_deseos` | fillBlank | streak | **⚑ C14** |
| 6 | Lesen: *El futuro del trabajo* | `de_es_b1_1_lesen_trabajo` | reading | score | |
| 7 | Dar consejos (recomendar que…) | `de_es_b1_1_consejos` | fillBlank | streak | C14 |
| 8 | Imperativo afirmativo y negativo | `de_es_b1_1_imperativo` | fillBlank | streak | **⚑ C15** |
| 9 | Sprechen: Dar y pedir opinión | `de_es_b1_1_sprechen_opinion` | speakRepeat | play-through | |
| 10 | Pronombres dobles (se lo, me lo) | `de_es_b1_1_dobles` | fillBlank | streak | C10 |
| 11 | Condicionales reales (si + presente) | `de_es_b1_1_condic_real` | fillBlank | streak | |
| 12 | Lesen: *Una carta de recomendación* | `de_es_b1_1_lesen_carta` | reading | score | |
| 13 | Expresar sentimientos (me alegro de que…) | `de_es_b1_1_sentimientos` | fillBlank | streak | C14 |

### B1.2 — Relatos y conjeturas · *Erzählen*
**Can-do:** narrate complex past stories, hypothesise, be polite/tentative,
report what others said, tell anecdotes.
**PCIC grammar:** **`condicional simple`** (politeness, advice, hypothesis);
**`pluscuamperfecto`** (`había hablado`); subjunctive after doubt/emotion/value
(`no creo que`, `es posible que`); **estilo indirecto** (reported speech, present
→ past); relative clauses with subjunctive (`busco a alguien que…`); **`por` vs
`para` (consolidation)**; discourse connectors.
**Vocab:** la tecnología, el medio ambiente, las relaciones, la cultura.

| # | Exercise | id | Type | Gate | Contrastive |
|---|----------|----|------|------|-------------|
| 1 | La tecnología | `de_es_b1_2_tecnologia` | fillBlank | streak | |
| 2 | Condicional simple | `de_es_b1_2_condicional` | fillBlank | streak | **⚑ C16** |
| 3 | Sprechen: Pedir con cortesía | `de_es_b1_2_sprechen_cortesia` | speakRepeat | play-through | C16 |
| 4 | Pluscuamperfecto | `de_es_b1_2_pluscuamperfecto` | fillBlank | streak | (bridge: *Plusquamperfekt*) |
| 5 | Subjuntivo: duda y opinión (no creo que) | `de_es_b1_2_subj_duda` | fillBlank | streak | **⚑ C14** |
| 6 | Lesen: *Una anécdota de viaje* | `de_es_b1_2_lesen_anecdota` | reading | score | |
| 7 | Estilo indirecto | `de_es_b1_2_estilo_indirecto` | fillBlank | streak | |
| 8 | Subjuntivo en oraciones de relativo | `de_es_b1_2_subj_relativo` | fillBlank | streak | C14 |
| 9 | El medio ambiente | `de_es_b1_2_medioambiente` | fillBlank | streak | |
| 10 | Sprechen: Contar una anécdota | `de_es_b1_2_sprechen_anecdota` | speakRepeat | play-through | C11 |
| 11 | por vs para (consolidación) | `de_es_b1_2_por_para` | fillBlank | streak | **⚑ C12** |
| 12 | Lesen: *Carta al director* | `de_es_b1_2_lesen_opinion` | reading | score | |
| 13 | Conectores del discurso | `de_es_b1_2_conectores` | fillBlank | streak | |

### B2 — Argumentar y matizar · *Argumentieren*
**Can-do:** argue and debate, hypothesise about unreal situations, express
concession and nuance, understand abstract/argumentative texts, use a formal
register.
**PCIC grammar:** **`imperfecto de subjuntivo`** (`-ra`/`-se`); **unreal
conditionals** (`si tuviera, …ría`); `aunque` + subjunctive (concession);
**`ser`/`estar` advanced** (meaning shifts: `listo`, `aburrido`); **verbos de
cambio** (`ponerse/volverse/hacerse/quedarse`); `se`-passive & impersonal;
subjunctive in future temporal clauses (`cuando llegue`); idioms; advanced
connectors.
**Vocab:** política y sociedad, ciencia, arte y literatura, economía, modismos.

| # | Exercise | id | Type | Gate | Contrastive |
|---|----------|----|------|------|-------------|
| 1 | Política y sociedad | `de_es_b2_sociedad` | fillBlank | streak | |
| 2 | Imperfecto de subjuntivo (formas) | `de_es_b2_subj_imperf` | fillBlank | streak | |
| 3 | Condicionales irreales (si tuviera…) | `de_es_b2_condic_irreal` | fillBlank | streak | **⚑ C17** |
| 4 | Sprechen: Defender una opinión | `de_es_b2_sprechen_argumento` | speakRepeat | play-through | |
| 5 | Verbos de cambio (ponerse/volverse…) | `de_es_b2_verbos_cambio` | fillBlank | streak | **⚑ C18** |
| 6 | Lesen: *¿Energía nuclear, sí o no?* | `de_es_b2_lesen_debate` | reading | score | |
| 7 | ser/estar avanzado (cambios de significado) | `de_es_b2_ser_estar_adv` | fillBlank | streak | **⚑ C7** |
| 8 | Concesivas: aunque + subjuntivo | `de_es_b2_concesivas` | fillBlank | streak | C14 |
| 9 | La voz pasiva y el *se* impersonal | `de_es_b2_pasiva` | fillBlank | streak | **⚑ C19** |
| 10 | Sprechen: Presentar un argumento | `de_es_b2_sprechen_presentar` | speakRepeat | play-through | |
| 11 | Subjuntivo en temporales (cuando llegue) | `de_es_b2_subj_temporal` | fillBlank | streak | C14 |
| 12 | Lesen: *Reseña de una novela* | `de_es_b2_lesen_resena` | reading | score | |
| 13 | Expresiones idiomáticas y conectores | `de_es_b2_modismos` | fillBlank | streak | C20 |
| 14 | Lesen: *Artículo de opinión* (capstone) | `de_es_b2_lesen_articulo` | reading | score | |

---

## 5. Skill coverage (DELE mapping)

| DELE skill | Where covered |
|------------|---------------|
| **Comprensión de lectura** | The 2–3 `reading` quizzes per module (15 passages total), level-locked grammar, adult topics. |
| **Expresión e interacción orales** | The 2 `speakRepeat` quizzes per module (model phrases for self-intro, ordering, opinions, argument). |
| **Comprensión auditiva** (partial) | TTS playback inside every `speakRepeat` (listen → repeat); Spanish neural voice required. |
| **Gramática y vocabulario** | All `fillBlank` knowledge quizzes. |
| **Expresión escrita** | Out of scope for this iteration (same call as `de_cert_a1`); reading passages double as writing models. |

## 6. Reading catalogue (level-aligned, interesting)

All passages in Spanish, German translation behind an info button. Topics rise
in abstraction with level; A-level uses a recurring cast (Anna, the García
family, exchange student **Lukas** — a German learner the audience relates to).

- A1.1 — *¡Hola! Me llamo Anna* · *Mi compañera de piso*
- A1.2 — *Un día con la familia García* · *En el mercado* · *La casa de Anna*
- A2.1 — *Un fin de semana en Valencia* · *El viaje de Lukas a Madrid* · *Una fiesta sorpresa*
- A2.2 — *Mi infancia en un pueblo* · *Un correo a un amigo alemán* · *Antes y ahora*
- B1.1 — *El futuro del trabajo* · *Una carta de recomendación* · *Estudiar en el extranjero*
- B1.2 — *Una anécdota de viaje* · *Carta al director* · *Un perro héroe*
- B2 — *¿Energía nuclear, sí o no?* · *El teletrabajo, ¿ventaja o trampa?* · *Reseña de una novela* · *Artículo de opinión*

## 7. Totals & effort

- **7 modules → 105 quizzes**: **62** `fillBlank`, **22** `speakRepeat` (audio),
  **21** `reading`. ≈ 920 content items (≈660 drill items + ≈158 spoken phrases +
  ≈104 reading questions). Every Quest carries ≥2 readings and ≥3 audios.
- **20 contrastive points** (C1–C20), ~22 quizzes carry a dedicated **⚑**
  contrastive focus; the rest carry contrastive tips in Help Memory.
- Rough first-completion time: A-levels ~50 min each module, B-levels ~70 min.

## 8. Implementation appendix (engineering prerequisites)

Content-first plan, but these seams must move before authoring lands:

1. **`UiLang.de`** — add to the enum in [course.dart](../lib/models/course.dart)
   (currently only `en`, `es`) and supply the German UI strings.
2. **Quest chain is currently single/global.** [quest_data.dart](../lib/data/quest_data.dart)
   hard-wires `_compiledQuestEntries` to the German `questA1_*Content`, and
   `de_cert_a1` is the only `questChain` consumer. To run a *second*
   certification chain (`de_es`) it must become **course-scoped** — e.g. a map
   of `courseId → List<QuestEntry>` (and `applyQuestOrderFromLayout`,
   `isQuestLevelUnlocked`, completion sets keyed per course). Alternative
   (lower-risk MVP): build `de_es` from level-gated `NavGroupType.quizzes`
   groups using `NavGroup.level`, reusing the existing per-sub-level gating
   without touching the global Quest chain.
3. **Builders** — add `lib/data/courses/de_es/de_es_builder.dart` mirroring
   [es_de_builder.dart](../lib/data/courses/es_de/es_de_builder.dart) but
   flipped: subject = German phrase, answer = Spanish; teaching text authored in
   German; `readingCourseQuiz` passage = Spanish, `passageTranslation` = German.
4. **Content files** — `de_es_a1_1.dart … de_es_b2.dart` (one per module),
   exported as `questDeEsA1_1Content`, etc.
5. **Course registration** — add the `Course(id: 'de_es', …, uiLang: UiLang.de,
   learnFlag: '🇪🇸', speakFlag: '🇩🇪')` and its 7-group `NavLayout` to
   [course_catalog.dart](../lib/data/course_catalog.dart).
6. **TTS** — ensure a Spanish neural voice is in the chain
   (`lib/services/tts/`) for `speakRepeat`/`reading` playback.
7. **Versioning** — bump `kDataVersion` in
   [data_version.dart](../lib/data/data_version.dart) and the seed `"version"`;
   the atomic reseed ships the new course to existing installs.
8. **Help Memory** — every quiz needs `helpMemoryIntro` + `helpMemoryTips`
   (enforced by tests); use the tips to carry the C1–C20 contrastive notes.

## Sources

- [CVC · Plan Curricular del Instituto Cervantes — Gramática, inventario A1–A2](https://cvc.cervantes.es/ensenanza/biblioteca_ele/plan_curricular/niveles/02_gramatica_inventario_a1-a2.htm)
- [CVC · Plan Curricular del Instituto Cervantes — Gramática, inventario B1–B2](https://cvc.cervantes.es/ensenanza/biblioteca_ele/plan_curricular/niveles/02_gramatica_inventario_b1-b2.htm)
- [CVC · Plan Curricular del Instituto Cervantes — Índice general](https://cvc.cervantes.es/ensenanza/biblioteca_ele/plan_curricular/indice.htm)
- [Instituto Cervantes · Exámenes DELE — niveles y formato](https://examenes.cervantes.es/es/dele/examenes/a2)
- [Instituto Cervantes · Guía del examen DELE B1 (PDF)](https://examenes.cervantes.es/sites/default/files/guia_examen_dele_b1.pdf)
- Council of Europe · CEFR / MCER global descriptors (A1–B2).
