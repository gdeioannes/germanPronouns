# Certification English A1 → C2 (`zh_en`) — Content Plan

A new **certification course for native Mandarin-Chinese speakers learning
English** (`speak 🇨🇳 → learn 🇬🇧`, `uiLang: zh`). It mirrors the `de_cert` model:
a single ordered, streak-unlocked **Quest chain** split into twelve CEFR
sub-levels (A1.1 → C2.2), balanced across the four exam skills and exercising
**all five** quiz kinds (`fillBlank`, `speakRepeat`, `reading`, `listening`,
`dictation`). What makes this course distinct is a **contrastive spine tuned to
the Mandarin↔English typological gap** — the widest gap of any course in the app,
and therefore the richest teaching opportunity.

This is a companion authoring doc — same role as
[`a1_competency_matrix.md`](a1_competency_matrix.md),
[`de_es_certification_plan.md`](de_es_certification_plan.md) and
[`de_certification_a1_c2_plan.md`](de_certification_a1_c2_plan.md): the
competency/contrastive mapping lives here, **not** as serialized `QuizContent`
fields, so the content schema and the seed/version pipeline stay unchanged. Keep
it in sync when quizzes are added, removed, or reordered.

> **First Chinese-UI course.** `zh_en` is the first course whose `uiLang` is
> Chinese, so it needs `UiLang.zh` + a Simplified-Chinese UI-string set. This is
> the one real engineering lift; the rest is content and reuses the `de_es`/
> `de_cert` seams (see §13).

---

## 1. Ladder & scope

Twelve modules, smooth full progression (no skipped sub-levels), mapped to the
Cambridge English ladder and to **China's Standards of English (CSE, MoE 2018)**
so the course speaks to what Chinese learners are actually assessed on. **C2.2 is
the reading/listening ceiling** — every passage and audio caps at the level of
its module, rising to C2 (Proficiency) difficulty.

| Module | Title (English · 中文) | CEFR | Cambridge exam · CSE | "Big rock" (one new hard structure) |
|--------|------------------------|------|----------------------|--------------------------------------|
| **A1.1** | First Contact · *初次接触* | A1 | (Pre-A1/A1) · CSE 1–2 | The verb **be** (am/is/are), subject pronouns, `a/an`, SVO, alphabet & phonics |
| **A1.2** | Everyday Life · *日常生活* | A1 | (A1) · CSE 2 | **Present simple** (+3rd-person `-s`), **do/does** questions & negation, plurals |
| **A2.1** | Past & Experiences · *过去与经历* | A2 | A2 Key · CSE 3 | **Past simple** (`-ed` + irregular), `was/were`, `did/didn't` |
| **A2.2** | Plans, Descriptions & Quantities · *计划与数量* | A2 | A2 Key · CSE 3 | **Future** (`will` / `be going to`), present continuous, comparatives, count/uncount |
| **B1.1** | Experiences & Connections · *经历与联系* | B1 | B1 Preliminary · CSE 4 | **Present perfect** (vs past simple; `for/since/ever/yet`), articles deep-dive |
| **B1.2** | Narratives & Conditions · *叙述与条件* | B1 | B1 Preliminary · CSE 4–5 | **Past continuous** vs simple, 0/1st conditionals, **relative clauses**, gerund/infinitive |
| **B2.1** | Opinions & Hypotheses · *观点与假设* | B2 | B2 First · CSE 5 | **2nd & 3rd conditionals + wish**, present perfect continuous, **passive voice** |
| **B2.2** | Reporting & Nuance · *转述与细节* | B2 | B2 First · CSE 6 | **Reported speech** (backshift), modals of deduction, phrasal verbs |
| **C1.1** | Abstraction & Precision · *抽象与精确* | C1 | C1 Advanced · CSE 6–7 | Advanced **verb complementation**, mixed conditionals, cohesion & nominalization |
| **C1.2** | Register & Rhetoric · *语体与修辞* | C1 | C1 Advanced · CSE 7 | **Inversion / cleft / fronting**, participle clauses, hedging & stance |
| **C2.1** | Stylistic Command · *风格驾驭* | C2 | C2 Proficiency · CSE 8 | Idiomatic mastery, subtle modality & aspect, ellipsis/substitution, marked syntax |
| **C2.2** | Mastery · *精通* | C2 | C2 Proficiency · CSE 8–9 | Near-native discourse: rhetoric, connotation/irony, literary & journalistic analysis (capstone) |

**Official anchors** (what each level *must* cover):
- **CEFR** global + skill descriptors (Council of Europe) — the can-do goals.
- **English Grammar Profile (EGP)** + **English Vocabulary Profile (EVP)**
  (English Profile — University of Cambridge / Cambridge University Press /
  British Council, from the Cambridge Learner Corpus). This is the authoritative
  *English-specific* grammar & vocabulary inventory per CEFR level — the direct
  equivalent of the PCIC (Spanish) or *Profile deutsch* (German). It drives the
  grammar/vocab columns below.
- **Cambridge English Main Suite exam blueprints** (A2 Key, B1 Preliminary, B2
  First, C1 Advanced, C2 Proficiency) — themes and the four skills (Reading, Use
  of English, Listening, Speaking, Writing) shape exercise types and topics.
- **China's Standards of English Language Ability (CSE)** + national exams
  (**Gaokao** English, **CET-4/6**, **TEM-8**, **PETS**) — anchors difficulty and
  register to the Chinese assessment context (CSE 2≈A1, 3≈A2, 4–5≈B1, 6≈B2,
  7≈B2/C1, 8≈C1/C2, 9≈C2).
- **IELTS / TOEFL** topic banks — source the B2–C2 reading/listening themes
  (the two exams most Chinese learners actually sit).

---

## 2. Progression principles

1. **One new "big rock" per module.** Each module introduces a single hard
   structure (the table above) and recycles everything before it. Tense is
   built once and spiralled (present → past → future → perfect → perfect
   continuous → conditionals → reported), never dumped.
2. **Spiral, don't dump.** The three lifelong Chinese-learner cliffs — **articles
   (`a/an/the/Ø`)**, **tense/aspect endings**, and **countability** — each appear
   *intro → consolidation → advanced* across many modules, not once.
3. **Sound before fluency.** Because pronunciation is the #1 barrier for Chinese
   speakers, every A/B module opens or anchors on a **`speakRepeat` sound focus**
   (final consonants, `th`, `/v/`, vowel pairs, word stress, intonation) before
   the grammar leans on those sounds.
4. **Interleave skills.** Never two `fillBlank` back-to-back without a
   `speakRepeat`, `reading`, `listening`, or `dictation` breaking them up. Every
   module touches all four exam skills.
5. **Receptive skills are level-locked but interesting.** Reading + listening use
   only grammar already taught, but topics are adult and engaging (a flat-share
   abroad, a start-up pitch, an AI-ethics debate, a satirical column). English
   text/audio first; Chinese translation behind an info button.
6. **Gate the next sub-level.** A module unlocks as a block only when **every**
   quiz in all preceding sub-levels is done (`isQuestLevelUnlocked` — already
   supports arbitrary sub-levels, iterating them in chain order).

---

## 3. Skill balance — the five quiz kinds, tuned for Chinese learners

The Cambridge exams test **Reading, Listening, Speaking, Writing** (+ Use of
English). Each maps to an exercise kind and a gate. The mix is **deliberately
weighted toward speaking, listening and dictation** — heavier than `de_es` —
because a Chinese learner's failures cluster in *perception & production of the
exact morphemes and sounds English marks and Chinese doesn't*.

| Exam skill | Kind (`QuizContent.kind`) | Gate | Per module | Why it matters for a Chinese learner |
|------------|---------------------------|------|-----------|--------------------------------------|
| **Grammar & vocab** (Use of English) | `fillBlank` | streak | **8–9** | Articles, tense endings, countability — the systematic gaps. |
| **Speaking** | `speakRepeat` (TTS → repeat, never needs a mic) | play-through | **2–3** | Carries the **phonology spine**: final consonants, `th`, `/v/`, stress, intonation. |
| **Reading** | `reading` (passage + MC) | score ≥ 65% | **2** | Word order, relative clauses, cohesion in context. |
| **Listening** | `listening` (hidden TTS passage + MC) | score ≥ 65% | **1–2** | Connected speech & English intonation vs tonal habits. |
| **Writing** | `dictation` (listen & type) | score ≥ 65% | **1–2** | **Forces the learner to hear *and write* the `-s`, `-ed`, and articles they habitually drop** — the single most diagnostic drill for this L1. |

**Per-module target ≈ 15–16 quizzes**, roughly `8–9 fillBlank + 2–3 speakRepeat +
2 reading + 1–2 listening + 1–2 dictation`, interleaved so no skill clusters
(≤ 2 knowledge quizzes in a row). The app's **inline big-text cloze**
(`inlineBlanks` reusing `reading`) is the natural vehicle for **article/tense
cloze inside a passage** (fill `a/the/Ø` across a paragraph) at B1+. The
per-sentence **Speak icon** (reusable `SpeakIconButton`, target-language default)
sits on every English line so learners always hear before they repeat.

---

## 4. The contrastive spine (Mandarin → English)

This course's backbone. Each row is a recurring "⚠️ 中文母语者注意" tip woven into
the relevant quiz's `helpMemoryTips`, plus dedicated contrastive quizzes (marked
**⚑ Z#** in §8). These are the points where English diverges from Mandarin — i.e.
where the learner actually trips. It is a *bigger* spine than `de_es` (20) or
`de_cert` (20) because Mandarin and English are typologically far apart.

### Phonology (drives `speakRepeat`, `listening`, `dictation`)
| # | English feature | Why a Mandarin speaker trips | First taught |
|---|-----------------|------------------------------|--------------|
| **Z1** | Latin alphabet, phonics & spelling | Pinyin gives the letters but not the sounds (`c`, `i`, `e`, `ang`… differ) | A1.1 |
| **Z2** | `th` /θ/ /ð/ (think, this) | No Mandarin equivalent → /s z/ or /f d/ | A1.1 → spiral |
| **Z3** | /v/ vs /w/ (very, wine) | No /v/ in Mandarin → /w/ | A1.1 |
| **Z4** | **Final consonants & clusters** (and, desk, asked, world) | Mandarin syllables end only in a vowel, /n/ or /ŋ/ → learner adds a vowel ("an-duh") or drops it | A1.1 → spiral |
| **Z5** | /l/–/n/, /l/–/r/, dark final /l/ (milk, feel) | Merged or absent finally | A1.2 |
| **Z6** | Vowel contrasts & length: /iː/–/ɪ/ (sheep/ship), /æ/–/e/–/ʌ/ (bad/bed/bud) | Mandarin has fewer vowel contrasts | A1.2 → spiral |
| **Z7** | **Voiced vs voiceless finals** (bag/back, is/ice, prize/price) | Mandarin uses aspiration, not final voicing → merges the pair (this is the `-ed`/plural cliff) | A2.1 |
| **Z8** | **Word stress & schwa reduction** (PHOtograph → phoTOGraphy; "the" = /ðə/) | English is stress-timed; Mandarin syllable-timed → equal weight, no schwa | A1.2 → spiral to C |
| **Z9** | **Sentence stress, rhythm & intonation** (pitch = attitude/question, not tone) | Tonal habits fight English intonation | A2.2 → spiral |
| **Z10** | **Connected speech**: linking, weak forms, elision ("wanna", "cuppa") | Syllable-timing blocks reductions | B1.2 → spiral |

### Grammar & morphosyntax (drives `fillBlank`, `dictation`, `reading`)
| # | English feature | Why a Mandarin speaker trips | First taught |
|---|-----------------|------------------------------|--------------|
| **Z11** | **Articles `a/an/the/Ø`** (definiteness, first vs later mention, generic) | Mandarin has **no articles** — the single biggest error source | A1.1 → THE spiral (B1.1, C1.1) |
| **Z12** | **`be` as copula** before adjectives (She *is* happy) | Mandarin adjectives are verbs (她很漂亮, no copula) → learner drops "be" | A1.1 |
| **Z13** | **Subject–verb agreement & 3rd-person `-s`** (He likes) | No agreement in Mandarin → "He like" | A1.2 → spiral |
| **Z14** | **Do-support** for questions & negation (Do you…? He doesn't…) | Mandarin negates directly (我不喜欢) and questions with 吗/A-not-A — **no inversion, no auxiliary** | A1.2 (the cliff) |
| **Z15** | **Plural `-s` & countable/uncountable** (much/many, "an information" ✗) | Mandarin nouns don't inflect for number; classifiers carry it | A1.2 → A2.2 → B1 |
| **Z16** | **Measure words → English partitives / `a`** (a slice of, a pair of, a cup of) | Bridge: the Chinese classifier (三**本**书) becomes the partitive/`a` | A2.2 |
| **Z17** | **Tense morphology & the timeline** (`-ed`, `will`, `-ing`) | Mandarin uses time words + aspect particles 了/过/在/着, **no verb inflection** | A2.1 (the system), every module after |
| **Z18** | **Aspect map**: 了/过 → present perfect vs past simple; 在 → present continuous; 着 → stative | Leverage existing aspect intuition instead of fighting it | B1.1 |
| **Z19** | **Dummy/expletive subjects `it` & `there`** (It's raining; There is…) | Mandarin drops subjects / uses 有 → "Is raining", "Have a book on the table" | A1.2 → A2.1 |
| **Z20** | **he / she / it** (spoken *tā* is genderless) | Classic he↔she slip **in speech** — heavy `speakRepeat` cure | A1.1 → spiral |
| **Z21** | **Time & place adverbials at the END** (I went to school *yesterday*) | Mandarin puts them pre-verb (我明天去) → "I yesterday went…" | A2.1 |
| **Z22** | **Topic-prominent → subject-prominent** ("This restaurant the food is good" → "The food here is good") | Mandarin is topic-prominent → bridges later to clefts/"As for…" | B1.2 → C1 |
| **Z23** | **Relative clauses AFTER the noun** (the book *that I bought*) | Mandarin modifiers precede (我买**的**书) → "I bought book is expensive" | B1.2 |
| **Z24** | **Prepositions `in/on/at`** (+ verb + preposition) | English prep system vs Mandarin coverbs (在/给/跟/对) | A1.2 → spiral to C |
| **Z25** | **Paired-connective drop**: "Although…, ~~but~~…" / "Because…, ~~so~~…" | Mandarin uses 虽然…但是, 因为…所以 → keeps both | B1.1 |
| **Z26** | **Gerund vs infinitive & complementation** (enjoy *doing* / want *to do* / make sb *do*) | Mandarin stacks bare verbs → "enjoy to swim" ✗ | B1.2 → B2 |
| **Z27** | **Passive voice** (be + V3; agentless) | Mandarin 被 is narrower/adversative → under/overuse & form errors | B2.1 |
| **Z28** | **Unreal conditionals & backshift** (if I *were*… I *would have*…), wish | Mandarin conditionals don't change tense/mood → "If I will have time" ✗ | B2.1 |
| **Z29** | **Reported speech backshift** & sequence of tenses | No morphological backshift in Mandarin | B2.2 |
| **Z30** | **Phrasal verbs** (separable, idiomatic: put off, run into) | Largely absent in Mandarin | B1.2 → C2 |
| **Z31** | **Cohesion, nominalization, hedging & rhetoric** (thesis-first, hedged English vs Chinese discourse patterns) | Different essay/argument structure & directness norms | C1.1 → C2 |
| **Z32** | **Collocation, idiom & register** (false friends, "Chinglish": "open the light" → *turn on*) | Word-for-word transfer breaks collocation | C1 → C2, sprinkled earlier |

---

## 5. Bridges to exploit (positive transfer)

Chinese learners have real *advantages* over, say, German learners of English —
name them explicitly so the course feels achievable, not just a list of traps.

| Bridge | How to use it |
|--------|---------------|
| **Shared SVO word order** | Basic sentences map 1:1 — start fast, spend the saved effort on articles/tense. |
| **Pinyin → the Latin alphabet** | Learners already read Roman letters; teach only where letter→sound *differs* (Z1). |
| **Analytic morphology** | Both languages are analytic; English has *far fewer* inflections than German/Spanish — frame tense endings as "small and countable", not a conjugation jungle. |
| **Existing aspect intuition (了/过/在/着)** | Don't invent aspect — *relabel* it. 了/过 → perfect; 在 → continuous. This is the course's cleverest lever (Z18). |
| **Classifiers → partitives** | 三**本**书 already teaches "counter words"; English `a piece of / a pair of` is the same instinct (Z16). |
| **Almost no grammatical gender** | Only he/she/it — a rounding error next to der/die/das. |
| **Topic-comment → clefts** | The Chinese topic slot bridges to English "As for… / It was X that…" at C1 (Z22). |

---

## 6. Memory-aid toolkit (the "how to remember" methods)

Hard structures get a **named mnemonic** in `helpMemoryTips` (kinds: `rule`,
`mnemonic`, `example`, `warning`), authored in Chinese, reused across modules so
they compound.

| Hard thing | Method | The hook |
|------------|--------|----------|
| **Articles** | The **`a`–`the`–`Ø` decision tree** | `the` = 你我都知道是哪个 (we both know which); `a/an` = 新的、众多之一 (new, one of many); `Ø` = 泛指/不可数 (general/uncountable). |
| **Countability** | The **finger test** | 能用手指数 1,2,3 吗? → `a/one/many/-s`. 不能? → `some/much/a piece of`. |
| **3rd-person `-s`** | "**He/She/It → 加 S**" | Only these three subjects trigger the `-s`; a one-letter habit. |
| **Tense** | The **timeline** + aspect bridge | PAST ◄─ NOW ─► FUTURE, with 了=✓已完成, 在=▶进行中, 过=经历过 pinned to perfect/continuous. |
| **Do-support** | "**没有助动词? 借个 DO**" | If the sentence has no helper verb, *borrow* `do/does/did` to ask or to say no. |
| **Word order** | "**S-V-O，然后 WHERE，最后 WHEN**" | Adverbials go to the tail: "…at school **yesterday**", never "I yesterday…". |
| **he / she** | Pair-drill + heavy `speakRepeat` | *tā* is one word in speech; force the contrast aloud until automatic. |
| **Relative clauses** | "**英语把描述挂在名词后面**" | English hooks the description *after* the noun; Chinese hangs it before (的). |
| **Connective pairs** | "**一句一座桥**" | English keeps only ONE — drop the second 但是/所以. |
| **Prepositions in/on/at** | The **zoom rule** | `at` = a point, `on` = a surface/line/day, `in` = an enclosed space/month/year. |
| **Passive** | "**翻转**: object → 前面, be + V3, 需要才加 by" | Flip the object to the front; add the agent only if it matters. |
| **Conditionals** | The **if-table (0/1/2/3)** | "退一步时态 = 非真实" — step the tense one back = unreal/hypothetical. |
| **Pronunciation** | "**落地音**" drills, `th` = 舌尖出牙, schwa = 懒音 /ə/, "one strong beat" | Land the final consonant; one stressed beat per word; reduce the rest. |
| **Spaced repetition** | Built into the chain | Streak gate + recycled vocab in later readings/`listening` re-expose hard items; dictation re-tests dropped morphemes. |

Every module's Help Memory **must** carry: one `helpMemoryIntro`, at least one
`rule`/`mnemonic` tip for its big rock, and a `warning` for the relevant **Z#**
contrastive trap. (Enforced by the existing help-memory tests.)

---

## 7. Legend for the module syllabi (§8)

**Type** = `QuizContent.kind` · **Gate** = streak (knowledge) / play-through
(speaking, never needs a mic) / score (reading, listening & dictation, ≥ 65%).
**⚑ Z#** = dedicated contrastive quiz. Ids follow `zh_en_<level>_<slug>`.

---

## 8. Module syllabi

### A1.1 — First Contact · *初次接触*
**Can-do (CEFR):** greet, introduce yourself, spell your name, give
nationality/job, count 0–20, name everyday things and family, ask basic
W-questions. **EGP grammar:** `be` (am/is/are, ±), subject pronouns, `a/an`,
`this/that`, possessive adjectives `my/your`, W-questions (`what/where/who`),
regular plural (intro). **EVP vocab:** greetings, numbers 0–20, countries &
nationalities, jobs, family, colours, classroom objects. **Big rocks:** Z1, Z2,
Z3, Z11, Z12, Z20.

| # | Exercise | id | Type | Gate | Z# |
|---|----------|----|------|------|----|
| 1 | The alphabet & sounds | `zh_en_a1_1_alphabet` | speakRepeat | play-through | **⚑ Z1** |
| 2 | Numbers 0–20 | `zh_en_a1_1_numbers` | fillBlank | streak | |
| 3 | Subject pronouns (I/you/he/she/it) | `zh_en_a1_1_pronouns` | fillBlank | streak | **⚑ Z20** |
| 4 | The verb *be*: am/is/are | `zh_en_a1_1_be` | fillBlank | streak | **⚑ Z12** |
| 5 | Speaking: Introduce yourself | `zh_en_a1_1_speak_intro` | speakRepeat | play-through | Z20 |
| 6 | `a` / `an` | `zh_en_a1_1_a_an` | fillBlank | streak | **⚑ Z11** |
| 7 | Countries & nationalities | `zh_en_a1_1_nationalities` | fillBlank | streak | |
| 8 | Listening: Nice to meet you | `zh_en_a1_1_listen_meet` | listening | score | |
| 9 | this / that / these / those | `zh_en_a1_1_this_that` | fillBlank | streak | Z15 |
| 10 | Jobs & "What do you do?" | `zh_en_a1_1_jobs` | fillBlank | streak | Z11 |
| 11 | Reading: *This is my family* | `zh_en_a1_1_read_family` | reading | score | Z12 |
| 12 | Colours & classroom objects | `zh_en_a1_1_colours` | fillBlank | streak | |
| 13 | Speaking: `th` & `/v/` sound focus | `zh_en_a1_1_speak_th_v` | speakRepeat | play-through | **⚑ Z2 ⚑ Z3** |
| 14 | Dictation: My name & number | `zh_en_a1_1_dict_name` | dictation | score | **⚑ Z4** |
| 15 | W-questions: what / where / who | `zh_en_a1_1_wh` | fillBlank | streak | |

### A1.2 — Everyday Life · *日常生活*
**Can-do:** talk about routines, likes/dislikes, family, food; tell the time;
say prices; say what you can do. **EGP grammar:** present simple (all persons),
3rd-person `-s`, `do/does` ± & ?, adverbs of frequency, plural nouns (reg/irreg),
`have`/`have got`, object pronouns, possessive `'s`, prepositions of time
(`at/on/in`), `can` (ability), `there is/are`. **EVP vocab:** daily routine, food
& drink, days/months, time, hobbies, house. **Big rocks:** Z13, Z14, Z15, Z19,
Z24.

| # | Exercise | id | Type | Gate | Z# |
|---|----------|----|------|------|----|
| 1 | Present simple (I/you/we/they) | `zh_en_a1_2_present` | fillBlank | streak | |
| 2 | Third-person `-s` (he/she/it) | `zh_en_a1_2_third_s` | fillBlank | streak | **⚑ Z13** |
| 3 | Listening: A typical day | `zh_en_a1_2_listen_day` | listening | score | |
| 4 | `do` / `does` — questions | `zh_en_a1_2_do_questions` | fillBlank | streak | **⚑ Z14** |
| 5 | `don't` / `doesn't` — negation | `zh_en_a1_2_negation` | fillBlank | streak | **⚑ Z14** |
| 6 | Speaking: My daily routine | `zh_en_a1_2_speak_routine` | speakRepeat | play-through | Z8 |
| 7 | Adverbs of frequency | `zh_en_a1_2_frequency` | fillBlank | streak | Z21 |
| 8 | Plural nouns: `-s` / `-es` / irregular | `zh_en_a1_2_plurals` | fillBlank | streak | **⚑ Z15** |
| 9 | `there is` / `there are` + `it` (weather) | `zh_en_a1_2_there_it` | fillBlank | streak | **⚑ Z19** |
| 10 | Reading: *A day in Lin's life* | `zh_en_a1_2_read_lin` | reading | score | |
| 11 | Prepositions of time: at / on / in | `zh_en_a1_2_prep_time` | fillBlank | streak | **⚑ Z24** |
| 12 | `can` / `can't` (ability) | `zh_en_a1_2_can` | fillBlank | streak | |
| 13 | Speaking: Final consonants & `-s` endings | `zh_en_a1_2_speak_endings` | speakRepeat | play-through | **⚑ Z4 ⚑ Z5** |
| 14 | Telling the time & prices | `zh_en_a1_2_time_prices` | fillBlank | streak | |
| 15 | Dictation: My routine | `zh_en_a1_2_dict_routine` | dictation | score | **⚑ Z13 ⚑ Z15** |
| 16 | Reading: *At the café* | `zh_en_a1_2_read_cafe` | reading | score | |

### A2.1 — Past & Experiences · *过去与经历*
**Can-do:** narrate past events, a trip/weekend; ask about the past; sequence
events. **EGP grammar:** past simple (regular `-ed` + irregular), `was/were`,
`did/didn't` ± & ?, past time expressions (`ago`, `last…`), `and/but/because`,
sequence adverbs. **EVP vocab:** travel, transport, town, weather, free time,
life events. **Big rocks:** Z17, Z21, Z7.

| # | Exercise | id | Type | Gate | Z# |
|---|----------|----|------|------|----|
| 1 | Past simple: regular `-ed` | `zh_en_a2_1_past_reg` | fillBlank | streak | **⚑ Z17** |
| 2 | Pronunciation: `-ed` /t/, /d/, /ɪd/ | `zh_en_a2_1_speak_ed` | speakRepeat | play-through | **⚑ Z7** |
| 3 | Past simple: irregular verbs | `zh_en_a2_1_past_irreg` | fillBlank | streak | Z17 |
| 4 | `was` / `were` | `zh_en_a2_1_was_were` | fillBlank | streak | |
| 5 | `did` / `didn't` — questions & negation | `zh_en_a2_1_did` | fillBlank | streak | **⚑ Z14** |
| 6 | Listening: My weekend | `zh_en_a2_1_listen_weekend` | listening | score | |
| 7 | Past time expressions & word order | `zh_en_a2_1_time_order` | fillBlank | streak | **⚑ Z21** |
| 8 | Speaking: Tell me about your trip | `zh_en_a2_1_speak_trip` | speakRepeat | play-through | |
| 9 | Reading: *A weekend in Shanghai* | `zh_en_a2_1_read_shanghai` | reading | score | |
| 10 | Transport & getting around | `zh_en_a2_1_transport` | fillBlank | streak | Z24 |
| 11 | The weather & seasons | `zh_en_a2_1_weather` | fillBlank | streak | Z19 |
| 12 | `because` / `so` / `but` | `zh_en_a2_1_connectors` | fillBlank | streak | Z25 |
| 13 | Listening: A short trip | `zh_en_a2_1_listen_trip` | listening | score | |
| 14 | Dictation: Last weekend | `zh_en_a2_1_dict_weekend` | dictation | score | **⚑ Z17** |
| 15 | Reading: *Lin's first week abroad* | `zh_en_a2_1_read_abroad` | reading | score | |

### A2.2 — Plans, Descriptions & Quantities · *计划与数量*
**Can-do:** talk about plans, make comparisons, describe people/places, quantify,
shop. **EGP grammar:** `be going to`, `will` (predictions/decisions), present
continuous (now & future), comparatives & superlatives, `much/many/some/any/a lot
of`, count vs uncount nouns, partitives, adjective order, `too/enough` (intro).
**EVP vocab:** shopping, clothes, city vs country, food quantities, describing
people. **Big rocks:** Z15, Z16, Z11, Z9, Z6.

| # | Exercise | id | Type | Gate | Z# |
|---|----------|----|------|------|----|
| 1 | Present continuous (now) | `zh_en_a2_2_continuous` | fillBlank | streak | Z17 |
| 2 | `be going to` (plans) | `zh_en_a2_2_going_to` | fillBlank | streak | |
| 3 | `will` (predictions & decisions) | `zh_en_a2_2_will` | fillBlank | streak | |
| 4 | Speaking: My weekend plans | `zh_en_a2_2_speak_plans` | speakRepeat | play-through | **⚑ Z9** |
| 5 | Comparatives: `-er` / `more … than` | `zh_en_a2_2_comparatives` | fillBlank | streak | |
| 6 | Superlatives: `the -est` / `the most` | `zh_en_a2_2_superlatives` | fillBlank | streak | Z11 |
| 7 | Listening: Making plans | `zh_en_a2_2_listen_plans` | listening | score | Z9 |
| 8 | Countable vs uncountable | `zh_en_a2_2_count_uncount` | fillBlank | streak | **⚑ Z15** |
| 9 | much / many / a lot of / some / any | `zh_en_a2_2_quantifiers` | fillBlank | streak | **⚑ Z15** |
| 10 | Partitives: a piece / a pair / a cup of | `zh_en_a2_2_partitives` | fillBlank | streak | **⚑ Z16** |
| 11 | Reading: *Shopping in the market* | `zh_en_a2_2_read_market` | reading | score | |
| 12 | `a` / `an` / `the` / `Ø` — review | `zh_en_a2_2_articles` | fillBlank | streak | **⚑ Z11** |
| 13 | Speaking: Vowel pairs (sheep/ship) | `zh_en_a2_2_speak_vowels` | speakRepeat | play-through | **⚑ Z6** |
| 14 | Describing people & places | `zh_en_a2_2_describing` | fillBlank | streak | |
| 15 | Dictation: A shopping list & plans | `zh_en_a2_2_dict_shopping` | dictation | score | **⚑ Z11 ⚑ Z15** |
| 16 | Reading: *City life vs country life* | `zh_en_a2_2_read_city` | reading | score | |

### B1.1 — Experiences & Connections · *经历与联系*
**Can-do:** talk about life experiences and recent events, describe changes,
connect past to present. **EGP grammar:** present perfect simple, present perfect
vs past simple, `for/since`, `ever/never/already/yet/just`, `been` vs `gone`,
`used to`, `so/such/too/enough`, connective pairs. **EVP vocab:** work & study,
health, technology, life changes, media. **Big rocks:** Z18, Z17, Z11, Z25, Z8.

| # | Exercise | id | Type | Gate | Z# |
|---|----------|----|------|------|----|
| 1 | Present perfect: form (have/has + V3) | `zh_en_b1_1_pp_form` | fillBlank | streak | Z17 |
| 2 | Present perfect vs past simple | `zh_en_b1_1_pp_vs_past` | fillBlank | streak | **⚑ Z18** |
| 3 | `for` / `since` | `zh_en_b1_1_for_since` | fillBlank | streak | |
| 4 | ever / never / already / yet / just | `zh_en_b1_1_adverbs` | fillBlank | streak | Z18 |
| 5 | Speaking: Have you ever…? | `zh_en_b1_1_speak_ever` | speakRepeat | play-through | Z18 |
| 6 | Listening: How life has changed | `zh_en_b1_1_listen_change` | listening | score | |
| 7 | `been` vs `gone` | `zh_en_b1_1_been_gone` | fillBlank | streak | |
| 8 | `used to` (past habits) | `zh_en_b1_1_used_to` | fillBlank | streak | Z17 |
| 9 | Reading: *The future of work* | `zh_en_b1_1_read_work` | reading | score | |
| 10 | Articles deep-dive: generic & abstract | `zh_en_b1_1_articles_deep` | fillBlank | streak | **⚑ Z11** |
| 11 | Connective pairs: although/but, because/so | `zh_en_b1_1_pairs` | fillBlank | streak | **⚑ Z25** |
| 12 | Speaking: Word stress & schwa | `zh_en_b1_1_speak_stress` | speakRepeat | play-through | **⚑ Z8** |
| 13 | so / such / too / enough | `zh_en_b1_1_so_such` | fillBlank | streak | |
| 14 | Listening: A podcast on technology | `zh_en_b1_1_listen_podcast` | listening | score | Z10 |
| 15 | Dictation: What I've done this year | `zh_en_b1_1_dict_year` | dictation | score | **⚑ Z18** |
| 16 | Reading: *Studying abroad* | `zh_en_b1_1_read_study` | reading | score | |

### B1.2 — Narratives & Conditions · *叙述与条件*
**Can-do:** tell stories, describe circumstances, talk about real conditions,
define and connect ideas. **EGP grammar:** past continuous, past simple vs
continuous (`when/while`), zero & first conditional, defining relative clauses
(`who/which/that/where/whose`), verb + `-ing` vs verb + `to`, `could/should`
(advice), phrasal verbs (intro). **EVP vocab:** stories, environment,
relationships, feelings. **Big rocks:** Z23, Z26, Z30, Z22, Z17.

| # | Exercise | id | Type | Gate | Z# |
|---|----------|----|------|------|----|
| 1 | Past continuous (was/were + `-ing`) | `zh_en_b1_2_past_cont` | fillBlank | streak | Z17 |
| 2 | Past simple vs continuous (when/while) | `zh_en_b1_2_past_vs_cont` | fillBlank | streak | |
| 3 | Speaking: Tell a story | `zh_en_b1_2_speak_story` | speakRepeat | play-through | |
| 4 | Zero conditional (facts) | `zh_en_b1_2_cond0` | fillBlank | streak | |
| 5 | First conditional (real future) | `zh_en_b1_2_cond1` | fillBlank | streak | Z28 |
| 6 | Listening: An announcement | `zh_en_b1_2_listen_announce` | listening | score | Z10 |
| 7 | Relative clauses: who / which / that | `zh_en_b1_2_relative` | fillBlank | streak | **⚑ Z23** |
| 8 | Relative clauses: where / whose | `zh_en_b1_2_relative2` | fillBlank | streak | Z23 |
| 9 | Reading: *A true anecdote* | `zh_en_b1_2_read_anecdote` | reading | score | Z22 |
| 10 | Verb + gerund (enjoy/finish doing) | `zh_en_b1_2_gerund` | fillBlank | streak | **⚑ Z26** |
| 11 | Verb + infinitive (want/decide to do) | `zh_en_b1_2_infinitive` | fillBlank | streak | **⚑ Z26** |
| 12 | Phrasal verbs (get up, turn on, look for) | `zh_en_b1_2_phrasal` | fillBlank | streak | **⚑ Z30** |
| 13 | Speaking: Sentence stress & linking | `zh_en_b1_2_speak_linking` | speakRepeat | play-through | **⚑ Z10** |
| 14 | Listening: A short story | `zh_en_b1_2_listen_story` | listening | score | |
| 15 | Dictation: A childhood memory | `zh_en_b1_2_dict_childhood` | dictation | score | |
| 16 | Reading: *Protecting our city* | `zh_en_b1_2_read_city` | reading | score | |

### B2.1 — Opinions & Hypotheses · *观点与假设*
**Can-do:** argue, hypothesise, express regret/wishes, describe processes. **EGP
grammar:** second & third conditional, `wish`/`if only`, present perfect
continuous, passive (present/past/present-perfect + modal), modals of possibility
(`might/could/may`), reported speech (intro), argument connectors. **EVP vocab:**
society, work, science, opinions, processes. **Big rocks:** Z28, Z27, Z18, Z31.

| # | Exercise | id | Type | Gate | Z# |
|---|----------|----|------|------|----|
| 1 | Second conditional (if I were…) | `zh_en_b2_1_cond2` | fillBlank | streak | **⚑ Z28** |
| 2 | Third conditional (if I had…, would have…) | `zh_en_b2_1_cond3` | fillBlank | streak | **⚑ Z28** |
| 3 | `wish` / `if only` | `zh_en_b2_1_wish` | fillBlank | streak | Z28 |
| 4 | Speaking: What would you do if…? | `zh_en_b2_1_speak_if` | speakRepeat | play-through | Z28 |
| 5 | Present perfect continuous | `zh_en_b2_1_ppc` | fillBlank | streak | Z18 |
| 6 | Passive: present & past | `zh_en_b2_1_passive` | fillBlank | streak | **⚑ Z27** |
| 7 | Passive: perfect & modal passive | `zh_en_b2_1_passive2` | fillBlank | streak | Z27 |
| 8 | Listening: A radio debate | `zh_en_b2_1_listen_debate` | listening | score | |
| 9 | Reading: *Should we trust AI?* | `zh_en_b2_1_read_ai` | reading | score | |
| 10 | Modals of possibility (might/could/may) | `zh_en_b2_1_modals` | fillBlank | streak | |
| 11 | Speaking: Defend an opinion | `zh_en_b2_1_speak_opinion` | speakRepeat | play-through | Z9 |
| 12 | Reported speech (intro: say/tell + backshift) | `zh_en_b2_1_reported_intro` | fillBlank | streak | Z29 |
| 13 | Listening: A science podcast | `zh_en_b2_1_listen_science` | listening | score | Z10 |
| 14 | Dictation: An opinion paragraph | `zh_en_b2_1_dict_opinion` | dictation | score | Z27 |
| 15 | Argument connectors (however/therefore) | `zh_en_b2_1_arg_connectors` | fillBlank | streak | **⚑ Z25** |
| 16 | Reading: *The benefits of remote work* | `zh_en_b2_1_read_remote` | reading | score | |

### B2.2 — Reporting & Nuance · *转述与细节*
**Can-do:** report/summarise, speculate about the past, add non-essential info,
use nuanced modality. **EGP grammar:** reported speech (statements/questions/
commands), reporting verbs (suggest/admit/deny + patterns), modals of deduction
(present & past), non-defining relative clauses, phrasal verbs (separable),
causative `have/get sth done`, comparative intensifiers. **EVP vocab:** news &
media, crime, culture, workplace. **Big rocks:** Z29, Z30, Z22, Z27.

| # | Exercise | id | Type | Gate | Z# |
|---|----------|----|------|------|----|
| 1 | Reported statements (backshift) | `zh_en_b2_2_reported` | fillBlank | streak | **⚑ Z29** |
| 2 | Reported questions & commands | `zh_en_b2_2_reported_q` | fillBlank | streak | Z29 |
| 3 | Reporting verbs (suggest/admit/refuse) | `zh_en_b2_2_reporting_verbs` | fillBlank | streak | Z26 |
| 4 | Speaking: Report what someone said | `zh_en_b2_2_speak_report` | speakRepeat | play-through | |
| 5 | Modals of deduction (present): must/can't be | `zh_en_b2_2_deduction` | fillBlank | streak | |
| 6 | Modals of deduction (past): must/might have | `zh_en_b2_2_deduction_past` | fillBlank | streak | |
| 7 | Listening: A news report | `zh_en_b2_2_listen_news` | listening | score | |
| 8 | Non-defining relative clauses (, which …) | `zh_en_b2_2_nondefining` | fillBlank | streak | Z23 |
| 9 | Reading: *A cultural misunderstanding* | `zh_en_b2_2_read_culture` | reading | score | Z22 Z32 |
| 10 | Phrasal verbs: separable & idiomatic | `zh_en_b2_2_phrasal` | fillBlank | streak | **⚑ Z30** |
| 11 | Causative: have / get something done | `zh_en_b2_2_causative` | fillBlank | streak | |
| 12 | Speaking: Connected speech & weak forms | `zh_en_b2_2_speak_weak` | speakRepeat | play-through | **⚑ Z10** |
| 13 | Listening: A workplace briefing | `zh_en_b2_2_listen_work` | listening | score | |
| 14 | Dictation: A news summary | `zh_en_b2_2_dict_news` | dictation | score | Z29 |
| 15 | Comparative intensifiers (much/far/slightly) | `zh_en_b2_2_intensifiers` | fillBlank | streak | |
| 16 | Reading: *The story behind the headline* | `zh_en_b2_2_read_headline` | reading | score | |

### C1.1 — Abstraction & Precision · *抽象与精确*
**Can-do:** discuss abstract topics precisely, structure an argument, express
complex relationships. **EGP grammar:** mixed conditionals, advanced verb
complementation (`tend to`, `manage to`, `avoid doing`, `be used to doing`),
participle clauses, nominalization, cohesive reference & substitution, cleft
sentences, `the … the …`, articles with abstract/generic nouns. **EVP vocab:**
academia, economy, ethics, environment (abstract), high-frequency collocations.
**Big rocks:** Z31, Z11, Z26, Z22, Z32.

| # | Exercise | id | Type | Gate | Z# |
|---|----------|----|------|------|----|
| 1 | Mixed conditionals | `zh_en_c1_1_mixed_cond` | fillBlank | streak | Z28 |
| 2 | Advanced verb complementation | `zh_en_c1_1_complementation` | fillBlank | streak | **⚑ Z26** |
| 3 | Participle clauses (Having finished…) | `zh_en_c1_1_participle` | fillBlank | streak | Z23 |
| 4 | Speaking: Present an abstract argument | `zh_en_c1_1_speak_argue` | speakRepeat | play-through | Z31 |
| 5 | Nominalization (verb → noun style) | `zh_en_c1_1_nominalization` | fillBlank | streak | **⚑ Z31** |
| 6 | Cohesion: reference & substitution | `zh_en_c1_1_cohesion` | fillBlank | streak | **⚑ Z31** |
| 7 | Listening: A university lecture | `zh_en_c1_1_listen_lecture` | listening | score | |
| 8 | Articles with abstract & generic nouns | `zh_en_c1_1_articles_abstract` | fillBlank | streak | **⚑ Z11** |
| 9 | Reading: *The ethics of technology* | `zh_en_c1_1_read_ethics` | reading | score | Z31 |
| 10 | Cleft sentences (It was… / What I mean…) | `zh_en_c1_1_cleft` | fillBlank | streak | **⚑ Z22** |
| 11 | `the … the …` (proportion) | `zh_en_c1_1_the_the` | fillBlank | streak | |
| 12 | Speaking: Intonation for emphasis & contrast | `zh_en_c1_1_speak_emphasis` | speakRepeat | play-through | **⚑ Z9** |
| 13 | Collocations: make/do/take/have + noun | `zh_en_c1_1_collocations` | fillBlank | streak | **⚑ Z32** |
| 14 | Listening: A panel discussion | `zh_en_c1_1_listen_panel` | listening | score | Z10 |
| 15 | Dictation: An academic paragraph | `zh_en_c1_1_dict_academic` | dictation | score | Z31 |
| 16 | Reading: *An argumentative essay* | `zh_en_c1_1_read_essay` | reading | score | |

### C1.2 — Register & Rhetoric · *语体与修辞*
**Can-do:** shift register, argue persuasively, hedge/soften, signal stance.
**EGP grammar:** inversion (negative adverbials; conditional inversion `Had I
known`), fronting for emphasis, hedging (`tend to`, `it would appear`),
impersonal passive reporting (`It is said that…`, `is thought to…`), discourse
markers, concession (`whereas/albeit/despite`), advanced phrasal/prepositional
verbs. **EVP vocab:** formal/academic, business, politics, register pairs. **Big
rocks:** Z31, Z32, Z27, Z22, Z10.

| # | Exercise | id | Type | Gate | Z# |
|---|----------|----|------|------|----|
| 1 | Inversion after negative adverbials | `zh_en_c1_2_inversion` | fillBlank | streak | **⚑ Z22** |
| 2 | Conditional inversion (Had I known…) | `zh_en_c1_2_cond_inversion` | fillBlank | streak | Z28 |
| 3 | Fronting for emphasis | `zh_en_c1_2_fronting` | fillBlank | streak | Z22 |
| 4 | Speaking: Formal vs informal register | `zh_en_c1_2_speak_register` | speakRepeat | play-through | Z32 |
| 5 | Hedging & softening | `zh_en_c1_2_hedging` | fillBlank | streak | **⚑ Z31** |
| 6 | Impersonal passive reporting | `zh_en_c1_2_impersonal` | fillBlank | streak | Z27 |
| 7 | Listening: A political interview | `zh_en_c1_2_listen_interview` | listening | score | |
| 8 | Discourse markers (nonetheless/moreover) | `zh_en_c1_2_discourse` | fillBlank | streak | Z31 |
| 9 | Reading: *An opinion column* | `zh_en_c1_2_read_column` | reading | score | Z32 |
| 10 | Concession: whereas / albeit / despite | `zh_en_c1_2_concession` | fillBlank | streak | **⚑ Z25** |
| 11 | Advanced collocations & idioms | `zh_en_c1_2_idioms` | fillBlank | streak | **⚑ Z32** |
| 12 | Speaking: Persuasive intonation & stress | `zh_en_c1_2_speak_persuade` | speakRepeat | play-through | Z9 |
| 13 | Phrasal/prepositional verbs (advanced) | `zh_en_c1_2_phrasal_adv` | fillBlank | streak | Z30 |
| 14 | Listening: A business negotiation | `zh_en_c1_2_listen_negotiation` | listening | score | Z10 |
| 15 | Dictation: A formal email | `zh_en_c1_2_dict_email` | dictation | score | Z32 |
| 16 | Reading: *Two reviews, two registers* | `zh_en_c1_2_read_reviews` | reading | score | |

### C2.1 — Stylistic Command · *风格驾驭*
**Can-do:** use language flexibly and idiomatically, convey fine shades of
meaning, grasp implicit/ironic meaning. **EGP grammar (C2):** subtle modality &
probability, fine perfect/continuous aspect, ellipsis & substitution, emphatic &
marked structures, extended idiom/metaphor, precise connotation, register-
shifting. **EVP vocab:** idioms, phrasal-verb networks, connotation sets, low-
frequency & literary lexis. **Big rocks:** Z32, Z31, Z10, Z18.

| # | Exercise | id | Type | Gate | Z# |
|---|----------|----|------|------|----|
| 1 | Subtle modality & probability | `zh_en_c2_1_modality` | fillBlank | streak | Z18 |
| 2 | Perfect & continuous aspect nuances | `zh_en_c2_1_aspect` | fillBlank | streak | Z18 |
| 3 | Ellipsis & substitution (…and so do I) | `zh_en_c2_1_ellipsis` | fillBlank | streak | Z31 |
| 4 | Speaking: Idiomatic fluency & rhythm | `zh_en_c2_1_speak_fluency` | speakRepeat | play-through | **⚑ Z10** |
| 5 | Idioms & fixed expressions | `zh_en_c2_1_idioms` | fillBlank | streak | **⚑ Z32** |
| 6 | Connotation & word choice | `zh_en_c2_1_connotation` | fillBlank | streak | **⚑ Z32** |
| 7 | Listening: Irony & humour (a comedy clip) | `zh_en_c2_1_listen_irony` | listening | score | Z31 |
| 8 | Emphatic & marked structures | `zh_en_c2_1_marked` | fillBlank | streak | Z22 |
| 9 | Reading: *A satirical article* | `zh_en_c2_1_read_satire` | reading | score | Z31 Z32 |
| 10 | Phrasal-verb networks (put up with / off / down) | `zh_en_c2_1_pv_networks` | fillBlank | streak | Z30 |
| 11 | Register-shifting: rewrite formal↔informal | `zh_en_c2_1_register_shift` | fillBlank | streak | **⚑ Z32** |
| 12 | Speaking: Prosody, connotation & attitude | `zh_en_c2_1_speak_prosody` | speakRepeat | play-through | Z9 |
| 13 | Collocation precision (strong/heavy/deep) | `zh_en_c2_1_collocation_precision` | fillBlank | streak | Z32 |
| 14 | Listening: A literary reading | `zh_en_c2_1_listen_literary` | listening | score | |
| 15 | Dictation: A nuanced argument | `zh_en_c2_1_dict_nuance` | dictation | score | Z32 |
| 16 | Reading: *A book review with irony* | `zh_en_c2_1_read_review` | reading | score | |

### C2.2 — Mastery · *精通* (capstone)
**Can-do:** understand and produce virtually everything; analyse style; argue
with sophistication; handle irony, connotation and cultural reference. **EGP
grammar (C2 ceiling):** full command of all structures; stylistically marked
usage; literary devices; discourse-level cohesion; near-native pragmatics. **EVP
vocab:** full range incl. rare, literary, technical, cultural-reference lexis.
**Big rocks:** Z31, Z32, Z28, Z27 (mastery + residual-Chinglish elimination).

| # | Exercise | id | Type | Gate | Z# |
|---|----------|----|------|------|----|
| 1 | Advanced discourse cohesion | `zh_en_c2_2_cohesion` | fillBlank | streak | Z31 |
| 2 | Rhetorical devices (parallelism, litotes) | `zh_en_c2_2_rhetoric` | fillBlank | streak | Z31 |
| 3 | Nuanced conditionals & counterfactuals | `zh_en_c2_2_counterfactual` | fillBlank | streak | Z28 |
| 4 | Speaking: Deliver a persuasive speech | `zh_en_c2_2_speak_speech` | speakRepeat | play-through | Z9 |
| 5 | Idiom, metaphor & cultural reference | `zh_en_c2_2_metaphor` | fillBlank | streak | Z32 |
| 6 | Register & tone control (irony/formality) | `zh_en_c2_2_tone` | fillBlank | streak | Z32 |
| 7 | Listening: A current-affairs debate | `zh_en_c2_2_listen_debate` | listening | score | |
| 8 | Reading: *A journalistic analysis* | `zh_en_c2_2_read_analysis` | reading | score | Z31 |
| 9 | Complex passive & impersonal structures | `zh_en_c2_2_complex_passive` | fillBlank | streak | Z27 |
| 10 | Precision & concision (Chinglish repair) | `zh_en_c2_2_concision` | fillBlank | streak | **⚑ Z32** |
| 11 | Speaking: Spontaneous argument & rebuttal | `zh_en_c2_2_speak_rebuttal` | speakRepeat | play-through | Z10 |
| 12 | Listening: A literary / critical talk | `zh_en_c2_2_listen_critical` | listening | score | |
| 13 | Dictation: A dense editorial | `zh_en_c2_2_dict_editorial` | dictation | score | Z31 |
| 14 | Reading: *Analysing a short story* | `zh_en_c2_2_read_story` | reading | score | Z31 Z32 |
| 15 | Reading: Capstone — *A long-form feature* | `zh_en_c2_2_read_capstone` | reading | score | |
| 16 | Speaking: Capstone — *Your view on a complex issue* | `zh_en_c2_2_speak_capstone` | speakRepeat | play-through | Z9 |

---

## 9. Skill coverage (Cambridge / CSE mapping)

| Exam skill | Where covered |
|------------|---------------|
| **Reading** | The 2 `reading` quizzes per module (~24 passages), level-locked grammar, adult topics; English text first, Chinese behind an info button. |
| **Listening** | The 1–2 `listening` quizzes per module (~20 hidden-audio passages) — connected speech & intonation, the receptive gap for tonal L1s. |
| **Speaking** | The 2–3 `speakRepeat` quizzes per module (~30) — model phrases *plus* the dedicated phonology-focus quizzes (final consonants, `th`, `/v/`, vowel pairs, stress, intonation, linking). |
| **Writing** | The 1–2 `dictation` quizzes per module (~14) — listen & type; the diagnostic drill for the `-s`, `-ed`, and articles Chinese learners drop. Reading passages also double as writing models. |
| **Use of English / Grammar & vocab** | All `fillBlank` knowledge quizzes (~105), EGP/EVP-sequenced. |

## 10. Reading & listening catalogue (level-aligned, interesting)

All passages/audio in English, Chinese translation behind an info button. Topics
rise in abstraction with level; A-levels use a recurring cast (**Lin**, a Chinese
exchange student the audience relates to; her flatmates; her family back home).

- **A1.1** — *This is my family* · *Nice to meet you* (listen)
- **A1.2** — *A day in Lin's life* · *At the café* · *A typical day* (listen)
- **A2.1** — *A weekend in Shanghai* · *Lin's first week abroad* · *My weekend*, *A short trip* (listen)
- **A2.2** — *Shopping in the market* · *City life vs country life* · *Making plans* (listen)
- **B1.1** — *The future of work* · *Studying abroad* · *How life has changed*, *A tech podcast* (listen)
- **B1.2** — *A true anecdote* · *Protecting our city* · *An announcement*, *A short story* (listen)
- **B2.1** — *Should we trust AI?* · *The benefits of remote work* · *A radio debate*, *A science podcast* (listen)
- **B2.2** — *A cultural misunderstanding* · *The story behind the headline* · *A news report*, *A workplace briefing* (listen)
- **C1.1** — *The ethics of technology* · *An argumentative essay* · *A university lecture*, *A panel discussion* (listen)
- **C1.2** — *An opinion column* · *Two reviews, two registers* · *A political interview*, *A business negotiation* (listen)
- **C2.1** — *A satirical article* · *A book review with irony* · *Irony & humour*, *A literary reading* (listen)
- **C2.2** — *A journalistic analysis* · *Analysing a short story* · *A long-form feature* (capstone) · *A current-affairs debate*, *A critical talk* (listen)

## 11. Totals & effort

- **12 modules → ≈ 187 quizzes**: ≈ **105** `fillBlank`, **30** `speakRepeat`
  (audio), **24** `reading`, **14** `dictation`, **14** `listening`. Every module
  carries ≥ 2 readings, ≥ 2 speaking, ≥ 1 listening, ≥ 1 dictation.
- **≈ 1,800+ content items** (drill items + spoken phrases + reading/listening
  questions + dictation sentences).
- **32 contrastive points** (Z1–Z32); ~45 quizzes carry a dedicated **⚑ Z#**
  focus, the rest carry contrastive tips in Help Memory.
- Rough first-completion time: A-levels ~55 min/module, B-levels ~75 min, C-levels
  ~90 min. The full A1.1→C2.2 ladder ≈ 14–15 hours of first-pass study.

## 12. What makes this course distinct (design summary)

1. **The aspect bridge (Z18).** Instead of teaching perfect/continuous from zero,
   it *relabels* the learner's native 了/过/在 intuition — the single most
   powerful lever a Chinese-L1 English course has, and one that generic courses
   miss entirely.
2. **Phonology as a first-class skill.** ~30 `speakRepeat` quizzes, several
   *dedicated* to the exact sounds Mandarin lacks (final consonants, `th`, `/v/`,
   vowel length, stress, intonation, linking) — front-loaded because they gate
   everything downstream.
3. **Dictation as diagnosis.** `dictation` is used specifically to force
   perception + production of the `-s`, `-ed`, and articles Chinese learners
   systematically drop — the highest-signal drill for this L1.
4. **Articles & countability spiralled to C1.** The two lifelong error sources get
   ≥ 4 dedicated passes each rather than one A1 mention.
5. **Bridges, not just traps.** Shared SVO, pinyin, analytic morphology, and
   classifiers→partitives are named as *advantages* to keep motivation high.

---

## 13. Implementation appendix (engineering prerequisites)

Content-first plan, but these seams must move before authoring lands. Reuse the
`de_es` playbook (docs §8 of [`de_es_certification_plan.md`](de_es_certification_plan.md));
the one genuinely new piece is the Chinese UI.

1. **`UiLang.zh` — the real lift.** Add `zh` to the enum in
   [course.dart](../lib/models/course.dart) (currently `en, es, de`) and supply a
   **Simplified-Chinese UI-string set**: all `AppStrings` chrome, the
   `_VoiceStrings` in [voice_status_chip.dart](../lib/widgets/voice_status_chip.dart),
   and [intro_strings.dart](../lib/l10n/intro_strings.dart). This is the first
   Chinese-UI course, so budget for it up front.
2. **Quest chain, course-scoped.** `de_es` already established a **12/N-group
   `NavGroupType.questChain`** per course in
   [course_catalog.dart](../lib/data/course_catalog.dart); add a 12-group chain
   for `zh_en` (A1.1 … C2.2). No global-chain surgery needed — follow the `de_es`
   registration, not the legacy single-global `de_cert` path.
3. **Builder** — add `lib/data/courses/zh_en/zh_en_builder.dart` mirroring
   [de_es_builder.dart](../lib/data/courses/de_es/de_es_builder.dart) but oriented
   🇨🇳→🇬🇧: `fillBlank` subject = Chinese prompt, answer = English; teaching text
   authored in **Chinese**; `readingCourseQuiz`/`listeningCourseQuiz` passage =
   English, `passageTranslation` = Chinese; `speakRepeat`/`dictation` `display` =
   English line, `english`(translation) = Chinese.
4. **Content files** — `zh_en_a1_1.dart … zh_en_c2_2.dart` (12 files), exported as
   `questZhEnA1_1Content`, etc., wired through `zh_en_content.dart`.
5. **Course registration** — add `Course(id: 'zh_en', name: '英语认证 A1–C2',
   tagline: '从零基础到精通，一步步考取英语证书', uiLang: UiLang.zh, speakFlag: '🇨🇳',
   learnFlag: '🇬🇧', learnLocale: 'en-GB')` + its 12-group `NavLayout` to
   [course_catalog.dart](../lib/data/course_catalog.dart) and the entry to
   [catalog.json](../assets/content/catalog.json). (`en-US` is equally fine —
   pick per the target TTS voice; note IELTS/Cambridge lean 🇬🇧, TOEFL 🇺🇸.)
6. **TTS** — the target language is now **English**, so a **British/American
   English neural voice** must be first in the chain
   ([lib/services/tts/](../lib/services/tts/)) for `speakRepeat`/`listening`/
   `dictation`. A Mandarin (`zh-CN`) voice is *optional* — only needed if the
   Chinese translations behind info buttons should also be spoken; `SpeakIcon`
   defaults to `learnLocale` (English), so English is the hard requirement.
7. **Versioning** — bump `kDataVersion` in
   [data_version.dart](../lib/data/data_version.dart) and the `"version"` in
   `catalog.json` / `app.json` / the course bundle; the atomic reseed ships the
   new course to existing installs. Regenerate bundles
   (`dart run tool/generate_content.dart`) **and** the seed
   (`dart run tool/generate_seed.dart`), then refresh the `content_snapshot`
   golden (`UPDATE_GOLDEN=1`).
8. **Help Memory** — every quiz needs `helpMemoryIntro` + `helpMemoryTips`
   (enforced by tests); use the tips to carry the Z1–Z32 contrastive notes and the
   §6 mnemonics, authored in Chinese.
9. **Quality gate** — add `test/zh_en_course_test.dart` mirroring
   `test/en_de_course_test.dart` / the `de_es` tests: unique ids, per-module
   counts, every quiz has intro+tips, the 12-level gating chain is contiguous, and
   `learnLocale`/`uiLang` are correct.

## Sources

- [Council of Europe · CEFR global & skill descriptors (A1–C2)](https://www.coe.int/en/web/common-european-framework-reference-languages/level-descriptions)
- [English Profile · English Grammar Profile](https://englishprofile.org/?menu=english-grammar-profile) — data-driven grammar inventory per CEFR level (Cambridge Learner Corpus).
- [English Profile · English Vocabulary Profile](https://englishprofile.org/?menu=english-vocabulary-profile) — words/phrases/meanings per CEFR level.
- [English Profile · Reference Level Descriptions (home)](https://englishprofile.org/)
- [Cambridge English · International language standards (CEFR & exam ladder)](https://www.cambridgeenglish.org/exams-and-tests/cefr/) — A2 Key, B1 Preliminary, B2 First, C1 Advanced, C2 Proficiency.
- [Cambridge English Qualifications (overview)](https://www.cambridgeenglish.org/exams-and-tests/qualifications/)
- [China's Standards of English Language Ability (CSE) ↔ CEFR alignment (Springer, 2022)](https://link.springer.com/article/10.1007/s40299-021-00617-2) — MoE 2018 nine-level framework; CSE 2≈A1 … 9≈C2.
