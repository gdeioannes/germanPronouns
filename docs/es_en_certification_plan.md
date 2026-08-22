# es_en — Certificación de Inglés A1–C2 (Spanish → English)

Course for native Spanish speakers learning English. `speak 🇪🇸 → learn 🇬🇧`,
`uiLang: UiLang.es`, `learnLocale: 'en-GB'`. All teaching text (titles, intros,
tips, prompts) is **Spanish**; every answer/passage is **English**.

**Anchoring:** CEFR only (A1–C2 descriptors and public can-do statements). No
exam brand names anywhere (see `docs/ip_copyright_review.md`). Spanish content
is pan-Hispanic neutral; English content is en-GB voiced but flags US/UK
differences where they matter (spelling, vocabulary, dates).

## Contrastive spine S1–S30 (Spanish ↔ English)

The course's signature: every module attacks the specific traps a Spanish
speaker falls into, tagged ⚑S<n> in Help Memory tips.

**Sound (S1–S10):** S1 vowel length & schwa (ship/sheep, unstressed vowels
reduce); S2 no e- before s+consonant (school ≠ "eschool"); S3 /h/ is aspirated,
Spanish j is not /h/ in hello; S4 b/v are distinct; S5 th (/θ/ /ð/) vs s/d;
S6 final consonants & clusters (-st, -ed, -s never drop); S7 -ed has three
sounds (/t/ /d/ /ɪd/); S8 word stress is lexical & unmarked (PHOto vs phoTOgrapher);
S9 /dʒ/ vs /j/ (job vs yob) and sh/ch; S10 intonation & weak forms (can/can't).

**Grammar (S11–S24):** S11 subject pronouns are mandatory (no pro-drop);
S12 adjectives before the noun, never agree (two red cars); S13 3rd-person -s;
S14 do-support for questions & negation (no "¿Vienes?" inversion of main verbs);
S15 present simple vs continuous (Spanish presente covers both); S16 articles:
no "the" for generalisations (Life is short ≠ *The life*), a/an before jobs;
S17 possessive 's + no "of the" chains; S18 countable/uncountable (advice,
furniture, news); S19 present perfect vs past simple (≠ pretérito perfecto
compuesto usage); S20 since/for/ago; S21 phrasal verbs are core vocabulary,
not slang; S22 make vs do, say vs tell; S23 conditionals & unreal past
(if I were); S24 reported speech backshift.

**Lexicon & register (S25–S30):** S25 false friends (actually, embarrassed,
library, assist, sensible, career, exit…); S26 word order of questions is fixed
(ASI: aux-subject-inversion); S27 gerund vs infinitive after verbs (enjoy
doing / want to do); S28 get-constructions & passives; S29 US/UK variation
(spelling -our/-or, -ise/-ize, lift/elevator, dates); S30 register — formal
written English (linking, hedging, nominalisation) for C-levels.

## Modules (12, each gated, chain order)

Each module ships ~23 quizzes: 8 fill · 3 vocab · 3 speak · 2 reading ·
2 listening · 2 dictation · 2 speaking (mid checkpoint + closing) · 1 big text.
Dictation targets what Spanish ears miss (final -s/-ed, weak forms); speakRepeat
carries the phonology (S1–S10); fills carry the grammar spine; the big text is
an inline cloze passage; the two speaking exercises run in the learner's own AI
(see `docs/speaking_quiz_feature.md`), the checkpoint at the list midpoint.

- **A1.1 · Primer contacto** — be, a/an, pronouns obligatorios (S11), alphabet & vowels (S1–S2), this/that, wh-questions, jobs, numbers.
- **A1.2 · La vida diaria** — present simple + 3rd -s (S13), do-support (S14), frequency adverbs, have got, can, time & routines, plurals, possessives (S17).
- **A2.1 · El pasado** — past simple regular/irregular, -ed sounds (S7), there was/were, ago (S20), holidays & biography.
- **A2.2 · Planes y comparaciones** — going to / will, present continuous (S15), comparatives/superlatives, countable/uncountable + some/any (S18), town & directions.
- **B1.1 · Opiniones y experiencias** — present perfect vs past (S19), since/for, phrasal verbs I (S21), gerund/infinitive (S27), opinions & agreeing.
- **B1.2 · Historias y condiciones** — past continuous, conditionals 0/1/2 (S23), used to, relative clauses, storytelling connectors.
- **B2.1 · Argumentos e hipótesis** — conditional 3 & mixed, modals of deduction, passives (S28), linking words, false friends I (S25).
- **B2.2 · Matices y reformulación** — reported speech (S24), question tags, wish/if only, phrasal verbs II, make/do/say/tell (S22), US/UK (S29).
- **C1.1 · Abstracción y precisión** — nominalisation, inversion for emphasis, advanced connectors, hedging, collocations, uncountable abstractions.
- **C1.2 · Registro y retórica** — formal vs informal register (S30), cleft sentences, participle clauses, discourse markers, academic verbs.
- **C2.1 · Estilo e idiomatismo** — idioms, metaphor, ellipsis & substitution, subtle modality, irony & understatement.
- **C2.2 · Maestría** — full-range synthesis: style editing, register switching, rhetorical structure, near-native traps, the last false friends.

Recurring cast: Lucía (from Guadalajara, works in London), Mateo (Buenos Aires,
studies in Manchester), Mrs. Park (their teacher).

## Ship checklist

Files `lib/data/courses/es_en/…` (builder + 12 modules + content list). Then:
catalog nav (`_esEnCertNav`, gated groups), `allQuizContent`,
`tool/generate_content.dart` `_contentByCourse`, generators, goldens
(content_fidelity, storage_keys), asset_provider count, `kDataVersion`,
gate test `test/es_en_course_test.dart`, Spanish speaking template
`assets/content/speaking/template.es.json` + manifest entry.
