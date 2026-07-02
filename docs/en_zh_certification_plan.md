# Certification Chinese A1 → C2 (`en_zh`) — Content Plan

A new **certification course for English speakers learning Mandarin Chinese**
(`speak 🇬🇧 → learn 🇨🇳`, `uiLang: en`). It is the mirror image of the `zh_en`
course and follows the same model: a single ordered, pass-to-unlock chain split
into twelve CEFR sub-levels (A1.1 → C2.2), balanced across the four exam skills
and exercising **all five** quiz kinds (`fillBlank`, `speakRepeat`, `reading`,
`listening`, `dictation`) plus the **inline big-text cloze**. Its backbone is a
**contrastive spine tuned to the English↔Mandarin typological gap** — as wide as
`zh_en`'s, but with the traps reversed: where the Chinese learner of English
fights articles and verb endings, the English learner of Chinese fights **tones,
characters, measure words and the aspect particles**.

This is a companion authoring doc — same role as
[`zh_en_certification_plan.md`](zh_en_certification_plan.md),
[`de_es_certification_plan.md`](de_es_certification_plan.md) and
[`a1_competency_matrix.md`](a1_competency_matrix.md): the competency/contrastive
mapping lives here, **not** as serialized `QuizContent` fields, so the content
schema and the seed/version pipeline stay unchanged. Keep it in sync when
quizzes are added, removed, or reordered.

> **No new UI language needed.** `uiLang` is English (`UiLang.en`), which the
> app has had from day one, and the TTS chain already carries Mandarin neural
> voices (Azure `zh-CN-Xiaoxiao/Yunxi`, Google `cmn-CN-Wavenet`) — added for the
> `zh_en` course's Chinese info-button lines. The engineering lift is ~zero;
> this course is almost pure content (see §13).

---

## 1. Ladder & scope

Twelve modules, smooth full progression (no skipped sub-levels), anchored to the
**HSK — the official Chinese proficiency certification**, in both of its living
forms:

- **HSK 2009 (six levels)** — the exam candidates still overwhelmingly sit.
  Vocabulary: HSK 1 = 150 words, 2 = 300, 3 = 600, 4 = 1 200, 5 = 2 500,
  6 = 5 000+.
- **Chinese Proficiency Grading Standards 2021** (《国际中文教育中文水平等级标准》,
  GF 0025-2021) — "**three bands, nine levels**" (三等九级), the new syllabus the
  HSK is migrating to. Cumulative inventories per level ≈ 300/600/900/1200/1500/
  1800/3000 characters and 500/1272/2245/3245/4316/5456/11092 words; ≈ 572
  grammar points across levels 1–9. Band 1 (levels 1–3) ≈ beginner/A, Band 2
  (4–6) ≈ intermediate/B, Band 3 (7–9) ≈ advanced/C.
- **TOCFL** (Taiwan) — the one Chinese exam *explicitly* CEFR-aligned (Band A =
  A1–A2, Band B = B1–B2, Band C = C1–C2); used as the CEFR sanity check.
- **EBCL** (European Benchmarking Chinese Language) — CEFR can-do descriptors
  for Chinese at A1–B1; drives the A-level can-dos.

The CEFR↔HSK mapping below follows the **conservative European reading**
(Fachverband Chinesisch / ALTE critiques): old-HSK levels sit roughly one CEFR
band *below* the publisher's claim. That matches the 2021 Standards' own band
structure and gives the twelve modules a sane vocabulary ramp.

| Module | Title (English · 中文) | CEFR | HSK 2009 · Standards 2021 | "Big rock" (one new hard structure) |
|--------|------------------------|------|---------------------------|--------------------------------------|
| **A1.1** | First Sounds & Tones · *声调入门* | A1 | HSK 1 (a) · L1 | **The four tones** + pinyin, 是, 吗-questions, pronouns |
| **A1.2** | People & Things · *人与物* | A1 | HSK 1 (b) · L1 | **很 + adjective (no 是!)**, 的 possession, measure word 个, 有 |
| **A2.1** | Time & Daily Life · *时间与日常* | A2 | HSK 2 (a) · L1–2 | **Time/place BEFORE the verb** (S-T-P-V-O), 在, serial 去+V, 会/能/可以 |
| **A2.2** | Done & Experienced · *完成与经历* | A2 | HSK 2 (b) · L2 | **了 (completion & change)**, 过, 不 vs 没, measure-word system, 比 |
| **B1.1** | Results & Directions · *结果与方向* | B1 | HSK 3 (a) · L2–3 | **Complements** (resultative & directional), 的/得/地, duration after verb |
| **B1.2** | Describing & Defining · *描述与定义* | B1 | HSK 3 (b) · L3 | **的 relative clauses (modifier BEFORE noun)**, 是…的, potential complements |
| **B2.1** | Handling & Being Handled · *处置与被动* | B2 | HSK 4 (a) · L3–4 | **把 & 被**, causative 让/叫, full comparison system |
| **B2.2** | Attitude & Flow · *语气与连贯* | B2 | HSK 4 (b) · L4 | **就/才 & the adverb system** (都/也/还/再/又), 着, particles 吧/呢/啊 |
| **C1.1** | Precision & Nuance · *精确与辨析* | C1 | HSK 5 · L5 | **Near-synonym discrimination**, formal prepositions, 成语 intro |
| **C1.2** | The Written Register · *书面语* | C1 | HSK 5–6 · L6 | **书面语 grammar** (将/于/之/而/则), formal passive 由/受/遭, hedging |
| **C2.1** | Idiom & Color · *成语与色彩* | C2 | HSK 6 · L7–9 | **Idiomatic mastery**: 成语/俗语/歇后语, connotation, marked syntax |
| **C2.2** | Mastery · *精通* | C2 | HSK 7–9 · L7–9 | Near-native discourse: 文言 flavor, irony, journalistic & literary analysis (capstone) |

**Official anchors** (what each level *must* cover):
- **HSK 2009 syllabus** (word lists + grammar outline per level) — the exam
  blueprint; module vocab stays inside its level's list.
- **Standards 2021** (characters/words/grammar per level, four skills + the new
  fifth skill **translation** at Band 3) — sequencing of grammar points.
- **CEFR** global + skill descriptors and **EBCL** A1–B1 Chinese descriptors —
  the can-do goals.
- **TOCFL** band descriptors — CEFR cross-check for B2–C2 text difficulty.
- **HSKK** (口语) speaking exam formats (初级 listen-and-repeat! / 中级 / 高级)
  — the `speakRepeat` quizzes literally mirror HSKK 初级's repeat-after-me task.

---

## 2. Progression principles

1. **One new "big rock" per module** (table above); everything before it is
   recycled. The aspect system is built once and spiralled (了 → 过 → 着 →
   complements → 把/被 → register), never dumped.
2. **Spiral, don't dump.** The three lifelong English-learner cliffs — **tones**,
   **characters**, and **the 了-system** — each appear *intro → consolidation →
   advanced* across many modules, not once.
3. **Sound before script, script before speed.** Every A/B module opens or
   anchors on a `speakRepeat` **tone/pinyin focus** (tones, tone pairs, sandhi,
   j/q/x vs zh/ch/sh, -n/-ng) before the grammar leans on those sounds.
   Characters ramp gently: radicals as "meaning hints" from A1.1, compound
   transparency (电脑 = electric-brain) from A2, no rote stroke drilling.
4. **Pinyin scaffold with a planned exit.** Fill-blank answers accept **pinyin
   as well as hanzi** (tone-marked or bare) via the `accepted` list; reading and
   listening passages carry **pinyin + English behind the info button** through
   B1, **English only from B2.1** — the scaffold is removed on schedule.
5. **The IME is the writing skill.** `dictation` = hear the Chinese, **type it
   with a pinyin IME** — exactly how the computer-based HSK writing paper works.
   Typing pinyin and *choosing the right character* trains recall + recognition
   in one move.
6. **Interleave skills.** Never two `fillBlank` back-to-back without a
   `speakRepeat`, `reading`, `listening`, or `dictation` breaking them up; every
   module touches all four exam skills.
7. **Gate the next sub-level.** Each level group is `NavGroup.gated`, so the
   whole A1.1 → C2.2 sequence is one continuous pass-to-unlock chain.

---

## 3. Skill balance — the five quiz kinds, tuned for English learners

The HSK tests **listening, reading, writing** (+ **speaking** via HSKK, +
**translation** at Band 3). The mix is **deliberately weighted toward speaking
and listening** because an English learner's failures cluster in *perception and
production of tone*, and toward dictation-as-IME-writing because that is the
literal HSK writing task.

| Exam skill | Kind (`QuizContent.kind`) | Gate | Per module | Why it matters for an English learner |
|------------|---------------------------|------|-----------|----------------------------------------|
| **Grammar & vocab** (语法/词汇) | `fillBlank` | streak | **7–9** | Measure words, 了/过/着, 把/被, word order — the systematic gaps. Answers accept hanzi *or* pinyin. |
| **Speaking** (HSKK) | `speakRepeat` (TTS → repeat, never needs a mic) | play-through | **2–4** | Carries the **tone spine**: four tones, tone pairs, sandhi, j/q/x, -n/-ng, prosody. Mirrors HSKK 初级's repeat task. |
| **Reading** (阅读) | `reading` (+ inline big-text cloze) | score ≥ 65% | **2** | Character recognition in context, modifier-before-noun parsing, no word spaces. |
| **Listening** (听力) | `listening` (hidden TTS passage + MC) | score ≥ 65% | **1–2** | Tone perception at speech rate — the receptive cliff. |
| **Writing** (书写) | `dictation` (listen & type via IME) | score ≥ 65% | **1** | **Forces sound → character mapping** — the modern, computer-based HSK writing skill. |

**Per-module target ≈ 15–16 quizzes**, interleaved so no skill clusters. The
**inline big-text cloze** (`inlineBlanks` reusing `reading`) is the vehicle for
**particle choice inside a passage** — select 了/过/着 or 的/得/地 across a
paragraph — at B1+ (three big-text quizzes: B1.1, B2.2, C1.2). The per-sentence
**Speak icon** sits on every Chinese line so learners always hear before they
repeat.

---

## 4. The contrastive spine (English → Mandarin)

The course backbone. Each row is a recurring "⚠️ trap for English speakers" tip
woven into the relevant quiz's `helpMemoryTips`, plus dedicated contrastive
quizzes (marked **⚑ Z#** in §8). These are the points where Mandarin diverges
from English — i.e. where the learner actually trips. Deliberately the mirror
image of `zh_en`'s spine: same gap, crossed from the other side.

### Sound & script (drives `speakRepeat`, `listening`, `dictation`)
| # | Mandarin feature | Why an English speaker trips | First taught |
|---|------------------|------------------------------|--------------|
| **Z1** | **The four tones + neutral tone** (mā má mǎ mà) | English pitch = attitude, never word identity → tones feel optional; they are not | A1.1 → THE spiral |
| **Z2** | **Tone sandhi**: 3rd+3rd → 2nd+3rd (你好), 不 bù→bú before tone 4, 一 yī→yí/yì | Invisible in pinyin as written → learner reads the citation tone | A1.1 → spiral |
| **Z3** | **Pinyin ≠ English letters**: q/x/j, zh/ch/sh/r, c = /tsʰ/, z = /ts/, ü, the buzzing -i of zhi/chi/shi/ri/zi/ci/si | The Latin letters *look* readable → English values leak in (\"c\" as /k/, \"q\" as /kw/) | A1.1 |
| **Z4** | **Aspiration, not voicing**: b/d/g are *unaspirated voiceless*, p/t/k aspirated | English b/d/g are voiced → wrong contrast, but intelligible; the reverse (hearing it) is harder | A1.1 |
| **Z5** | **-n vs -ng finals**, the two \"u\"s (u/ü) | fán/fáng, lù/lǜ merge for English ears | A2.1 |
| **Z6** | **Syllable-timed rhythm; intonation rides ON tones** (a question still keeps each syllable's tone) | English stress-timing + rising question intonation flattens or bends tones | B2.1 → spiral |
| **Z7** | **Characters**: morpheme-syllable writing; **radicals hint meaning, phonetic components hint sound** (~80% of characters are 形声字) | No alphabet to lean on → memorize smart (components), not brute-force | A1.1 → spiral |
| **Z8** | **No word spaces** — reading means chunking characters into words | Learner parses character-by-character and stalls | B1 readings onward |

### Grammar & usage (drives `fillBlank`, `reading`, big-text cloze)
| # | Mandarin feature | Why an English speaker trips | First taught |
|---|------------------|------------------------------|--------------|
| **Z9** | **No conjugation, agreement, plural, case, gender** — verbs and nouns never change | A *bridge* — but learners over-mark: they hunt for a past tense and misuse 了 for it | A1.1 (named as advantage) |
| **Z10** | **Adjectives are verbs**: 她**很**高, never ~~她是高~~ | English copula habit → \"是 + adj\" error; unmarked 高 implies comparison | A1.2 (the cliff) |
| **Z11** | **Measure words** are obligatory: 一**个**人, 三**本**书, 两**条**路 | English counts bare nouns → MW dropped or 个 overused | A1.2 intro → A2.2 system |
| **Z12** | **Questions don't move anything**: 吗 / A-not-A; question word stays in place (你买**什么**?) | English inversion + wh-fronting → \"什么你买?\" ✗ | A1.1 → A1.2 |
| **Z13** | **Time & place BEFORE the verb** (我**明天在家**吃饭); duration/frequency AFTER (学了**三年**) | English puts adverbials at the end → \"我吃饭在家\" ✗ | A2.1 (the cliff), B1.1 |
| **Z14** | **了 is aspect, not past tense**: completion 了 vs new-situation 了; NOT with habits (每天), NOT with 想/是/在 | The single biggest error source: 了 sprayed on every past sentence | A2.2 → THE spiral (B2.2, C2.1) |
| **Z15** | **过** = experience (\"have ever\"), distinct from 了 | Maps to *two* English perfects → confusion both ways | A2.2 |
| **Z16** | **在/正在** progressive; **着** durative state (门开**着**) | -ing maps to two different markers | A2.1 (在) → B2.2 (着) |
| **Z17** | **不 vs 没**: 没 negates completion & 有; 不 negates habit/future/adjectives/willingness | One English \"not\" splits in two | A2.2 |
| **Z18** | **有 for existence** (桌子上**有**一本书); location sentences: 在 vs 有 vs 是 | \"There is\" ↔ 有 mapping crosses word order | A1.2 → A2.1 |
| **Z19** | **All modifiers BEFORE the noun**, incl. relative clauses: 我买**的**书 (\"the book that I bought\") | English hangs clauses after the noun → parsing + production flip | A1.2 (的) → B1.2 (clauses) |
| **Z20** | **的 / 得 / 地** — one sound, three jobs | Homophones, distinct grammar → the classic written trap | B1.1 |
| **Z21** | **Complements**: resultative (找**到**, 听**懂**), directional (拿**出来**), potential (听**得/不**懂), degree (说**得**很好) | English has no slot for them → learner stops at the bare verb (找 ≠ find) | B1.1 → B1.2 → B2.1 |
| **Z22** | **把** (disposal): grab the object, then act — 把门关上 | No English analogue; word order feels inverted | B2.1 |
| **Z23** | **被** passive is narrow/adversative; Chinese prefers the **notional passive** (问题解决了) | English passive habit → 被 overuse; formal 由/受/遭 at C | B2.1 → C1.2 |
| **Z24** | **比 comparisons**: A 比 B + adj (一点儿/得多) — **never 很** with 比 | \"更/很\" collide with English \"more/very\" | A2.2 → B2.1 |
| **Z25** | **Paired connectives — keep BOTH**: 因为…所以, 虽然…但是, 如果…就, 不但…而且 | English drops the second half → learner drops 所以/但是 | B1.1 → spiral |
| **Z26** | **会 / 能 / 可以** — English \"can\" splits three ways (learned skill / capability-circumstance / permission) | One-to-three mapping | A2.1 |
| **Z27** | **The little adverbs**: 就 vs 才, 再 vs 又, 都/也/还 — fixed pre-verb slots, attitude-laden | Tiny words, huge meaning shifts, no English echo | B2.2 (the cliff) |
| **Z28** | **Topic-prominence & pro-drop**; **是…的** focus for time/place/manner of past events | English demands subjects & clefts differently | B1.2 → C1 |
| **Z29** | **Coverbs**: 在/给/跟/对/离/从…到 are verbs sitting *before* the main verb | English prepositions come after; 离 (\"distance from\") has no direct match | A2.1 → C1.1 (对于/关于/由于) |
| **Z30** | **Register & idiom**: 书面语 vs 口语 (将=把, 于, 之, 而, 则), 成语/俗语/歇后语, formal passive 由/受 | A second, half-classical grammar to acquire at C | C1.1 → C2 |

---

## 5. Bridges to exploit (positive transfer)

English learners of Chinese also have real *advantages* — name them explicitly
so the course feels achievable, not just a list of traps.

| Bridge | How to use it |
|--------|---------------|
| **Shared SVO word order** | Basic sentences map 1:1 (我爱你) — start fast, spend the saved effort on tones & measure words. |
| **Almost zero morphology** | No conjugation, no gender, no case, no plural, no agreement — say it once, it never changes. Framed at A1.1 as \"the grammar you never have to learn\". |
| **Ultra-regular numbers** | 11 = ten-one (十一), 22 = two-ten-two (二十二), 200 = 两百 — arithmetic, not memorization. |
| **The regular calendar** | Monday = weekday-one (星期一), February = two-month (二月) — whole English memory lists collapse into two patterns. |
| **Compound transparency** | 电脑 electric-brain = computer, 飞机 flying-machine = airplane — vocabulary compounds like Lego from ~1500 morphemes. |
| **English partitives → measure words** | \"a **pair of** trousers, a **sheet of** paper, a **cup of** tea\" — English already has the classifier instinct; Chinese just makes it obligatory (Z11). |
| **Pinyin uses familiar letters** | Only the value differences need teaching (Z3); reading pinyin is day-one accessible. |
| **Loanwords & cognates** | 咖啡 kāfēi, 巧克力 qiǎokèlì, 沙发 shāfā — free vocabulary with tone practice built in. |

---

## 6. Memory-aid toolkit (the \"how to remember\" methods)

Hard structures get a **named mnemonic** in `helpMemoryTips` (kinds: `rule`,
`mnemonic`, `example`, `warning`), authored in English, reused across modules so
they compound.

| Hard thing | Method | The hook |
|------------|--------|----------|
| **The four tones** | **Tone gestures** | 1st = *sing it flat* (doctor's \"aaah\"), 2nd = *\"huh?\"* rise, 3rd = *skeptical dip* (\"we-ell…\"), 4th = *\"No!\"* command drop. |
| **Tone sandhi** | \"**Two dips can't dance**\" | 3rd+3rd → 2nd+3rd: nǐ hǎo is really ní hǎo. 不 and 一 flip before a 4th tone. |
| **Measure words** | \"**Every noun brings its suitcase**\" | Number/这/那 + **MW** + noun, always. Lost? 个 is the beige suitcase that fits everything — then upgrade: 本 bound, 张 flat, 条 long-bendy, 只 animals, 杯 cups, 位 people (polite). |
| **很 + adjective** | \"**很 is the glue, not 'very'**\" | Plain 她很高 = \"she's tall\" — 很 is nearly empty; NO 是 before adjectives. 是 only links nouns. |
| **了** | \"**A ✓-stamp, not a tense**\" | Stamp the action as *done* (verb 了) or the situation as *new* (sentence 了). Never stamp habits (每天), states (是/在/想), or hopes. |
| **不 vs 没** | \"**没 for done-and-have, 不 for everything else**\" | 没 negates completed events & 有; 不 negates habits, futures, adjectives, willingness. |
| **Word order** | \"**Set the scene, then act**\" | Subject + **WHEN** + **WHERE** + verb + object: 我明天在家吃饭. Duration lands *after* the verb: 学了三年. |
| **的 / 得 / 地** | \"**noun-的, how-it-went-得, how-you-do-it-地**\" | 的 before nouns; 得 after verbs grading the result; 地 turns adjectives into -ly before verbs. |
| **Complements** | \"**Verbs need a landing**\" | 找 is to look — 找**到** is to find. Action verb + result/direction tells you how it ended: 听懂, 吃完, 拿出来. |
| **把** | \"**Grab it, then do it**\" | 把 + object + verb + landing: 把门关上 — grab the door, shut it. Needs a result-landing; bare 把门关 ✗. |
| **比** | \"**A 比 B tall — and never 很**\" | 他比我高(一点儿/得多). Degree words replace, never join, 很. |
| **会/能/可以** | \"**Skill 会, power 能, permission 可以**\" | Learned it? 会. Physically/circumstantially able? 能. Allowed? 可以. |
| **就 vs 才** | \"**就 = sooner than you think, 才 = later than you'd like**\" | 八点就来了 (early!) vs 八点才来 (finally!). |
| **Characters** | \"**Meaning left, sound right**\" | ~80% are 形声字: 妈 = 女 (meaning) + 马 mǎ (sound). Learn components, not strokes. |
| **Dictation/IME** | \"**Type pinyin, pick the character**\" | The modern HSK writing skill *is* the IME: hearing → pinyin → recognizing the right hanzi. |
| **Spaced repetition** | Built into the chain | Streak gate + recycled vocab in later readings/listenings re-expose hard items; dictation re-tests the sound→character mapping. |

Every module's Help Memory **must** carry: one `helpMemoryIntro`, at least one
`rule`/`mnemonic` tip for its big rock, and a `warning` for the relevant **Z#**
contrastive trap. (Enforced by `test/en_zh_course_test.dart`.)

---

## 7. Legend for the module syllabi (§8)

**Type** = `QuizContent.kind` · **Gate** = streak (knowledge) / play-through
(speaking, never needs a mic) / score (reading, listening & dictation, ≥ 65%).
**⚑ Z#** = dedicated contrastive quiz. Ids follow `en_zh_<level>_<slug>`.
Pinyin is accepted alongside hanzi in fill-blanks (tone-marked or bare);
passages carry pinyin + English behind the info button through B1.

---

## 8. Module syllabi

### A1.1 — First Sounds & Tones · *声调入门* (HSK 1a)
**Can-do (EBCL A1):** greet, introduce yourself, ask someone's name, count
0–99, use basic courtesy formulas. **Grammar (HSK 1):** 是 ±, subject pronouns,
吗-questions, 呢 echo-questions, 叫/姓, 不 negation of verbs, numbers.
**Vocab:** greetings, courtesy, numbers, countries, names. **Big rocks:** Z1,
Z2, Z3, Z4, Z7, Z9 (bridge), Z12.

| # | Exercise | id | Type | Gate | Z# |
|---|----------|----|------|------|----|
| 1 | The four tones | `en_zh_a1_1_tones` | speakRepeat | play-through | **⚑ Z1** |
| 2 | Pinyin: the tricky letters | `en_zh_a1_1_pinyin` | speakRepeat | play-through | **⚑ Z3 ⚑ Z4** |
| 3 | Greetings & courtesy | `en_zh_a1_1_greetings` | fillBlank | streak | |
| 4 | Pronouns 我/你/他/她 | `en_zh_a1_1_pronouns` | fillBlank | streak | Z9 |
| 5 | 是 — linking nouns (only!) | `en_zh_a1_1_shi` | fillBlank | streak | **⚑ Z10-preview** |
| 6 | Numbers 0–99 (the Lego system) | `en_zh_a1_1_numbers` | fillBlank | streak | bridge |
| 7 | Speaking: introduce yourself | `en_zh_a1_1_speak_intro` | speakRepeat | play-through | |
| 8 | Questions: 吗 and 呢 | `en_zh_a1_1_ma` | fillBlank | streak | **⚑ Z12** |
| 9 | Listening: 你好! | `en_zh_a1_1_listen_hello` | listening | score | Z1 |
| 10 | Names & countries: 叫/姓/…人 | `en_zh_a1_1_names` | fillBlank | streak | |
| 11 | Reading: 我叫汤姆 | `en_zh_a1_1_read_tom` | reading | score | |
| 12 | Tone pairs & 你好-sandhi | `en_zh_a1_1_tone_pairs` | speakRepeat | play-through | **⚑ Z2** |
| 13 | Characters: your first radicals | `en_zh_a1_1_hanzi` | fillBlank | streak | **⚑ Z7** |
| 14 | Dictation: first sentences (IME) | `en_zh_a1_1_dict_hello` | dictation | score | Z7 |
| 15 | Question words 什么 / 谁 | `en_zh_a1_1_what_who` | fillBlank | streak | **⚑ Z12** |

### A1.2 — People & Things · *人与物* (HSK 1b)
**Can-do:** describe people simply, talk about family and possessions, ask
what/which/whose, count things. **Grammar:** 很 + adj, 的 possession, measure
word 个, 有/没有, 这/那/哪, 几 vs 多少. **Vocab:** family, common objects,
colours, basic adjectives. **Big rocks:** Z10, Z11 (intro), Z18, Z19 (的).

| # | Exercise | id | Type | Gate | Z# |
|---|----------|----|------|------|----|
| 1 | Adjectives take 很, never 是 | `en_zh_a1_2_hen` | fillBlank | streak | **⚑ Z10** |
| 2 | Family words | `en_zh_a1_2_family` | fillBlank | streak | |
| 3 | Possession with 的 | `en_zh_a1_2_de` | fillBlank | streak | **⚑ Z19** |
| 4 | Speaking: my family | `en_zh_a1_2_speak_family` | speakRepeat | play-through | Z1 |
| 5 | 有 + the measure word 个 | `en_zh_a1_2_you_ge` | fillBlank | streak | **⚑ Z11 ⚑ Z18** |
| 6 | 这 / 那 / 哪 | `en_zh_a1_2_this_that` | fillBlank | streak | |
| 7 | Listening: 我的家 | `en_zh_a1_2_listen_family` | listening | score | |
| 8 | Everyday things & 什么 | `en_zh_a1_2_things` | fillBlank | streak | |
| 9 | How many? 几 vs 多少 | `en_zh_a1_2_ji_duoshao` | fillBlank | streak | Z11 |
| 10 | Reading: 这是我的家 | `en_zh_a1_2_read_home` | reading | score | Z19 |
| 11 | Tones in real words (sandhi live) | `en_zh_a1_2_speak_sandhi` | speakRepeat | play-through | **⚑ Z2** |
| 12 | Negation with 不 | `en_zh_a1_2_bu` | fillBlank | streak | Z17-preview |
| 13 | Colours & describing | `en_zh_a1_2_colours` | fillBlank | streak | Z10 |
| 14 | Dictation: my family (IME) | `en_zh_a1_2_dict_family` | dictation | score | |
| 15 | Reading: 我的朋友小美 | `en_zh_a1_2_read_friend` | reading | score | |

### A2.1 — Time & Daily Life · *时间与日常* (HSK 2a)
**Can-do:** talk about routines and schedules, tell the time and date, say
where things happen, express wants and abilities. **Grammar:** S-T-P-V-O word
order, dates/weekdays, 点/分/半, 在 + place, 去 + V purpose, 想/要, 会/能/可以,
frequency adverbs. **Vocab:** daily routine, places, transport. **Big rocks:**
Z13, Z16 (在), Z26, Z29, Z5.

| # | Exercise | id | Type | Gate | Z# |
|---|----------|----|------|------|----|
| 1 | The regular calendar: 星期/月/号 | `en_zh_a2_1_calendar` | fillBlank | streak | bridge |
| 2 | Telling the time: 点/分/半 | `en_zh_a2_1_time` | fillBlank | streak | |
| 3 | Time goes BEFORE the verb | `en_zh_a2_1_word_order` | fillBlank | streak | **⚑ Z13** |
| 4 | Speaking: my day | `en_zh_a2_1_speak_day` | speakRepeat | play-through | |
| 5 | 在 + place (scene before action) | `en_zh_a2_1_zai` | fillBlank | streak | **⚑ Z13 ⚑ Z29** |
| 6 | Listening: 你几点起床? | `en_zh_a2_1_listen_morning` | listening | score | |
| 7 | Going to do: 去 + verb | `en_zh_a2_1_qu_verb` | fillBlank | streak | **⚑ Z29** |
| 8 | Wanting: 想 / 要 | `en_zh_a2_1_xiang_yao` | fillBlank | streak | |
| 9 | Can: 会 / 能 / 可以 | `en_zh_a2_1_hui_neng` | fillBlank | streak | **⚑ Z26** |
| 10 | Reading: 汤姆的一天 | `en_zh_a2_1_read_day` | reading | score | Z13 |
| 11 | Sounds: -n/-ng, j/q/x, ü | `en_zh_a2_1_speak_finals` | speakRepeat | play-through | **⚑ Z5 ⚑ Z3** |
| 12 | Daily verbs | `en_zh_a2_1_daily_verbs` | fillBlank | streak | |
| 13 | 每天 / 常常 / 有时候 | `en_zh_a2_1_frequency` | fillBlank | streak | Z13 |
| 14 | Dictation: my routine (IME) | `en_zh_a2_1_dict_routine` | dictation | score | |
| 15 | Reading: 在咖啡馆 | `en_zh_a2_1_read_cafe` | reading | score | |
| 16 | Listening: 周末做什么? | `en_zh_a2_1_listen_weekend` | listening | score | |

### A2.2 — Done & Experienced · *完成与经历* (HSK 2b)
**Can-do:** say what happened, what you've experienced, shop and pay, compare
simply. **Grammar:** verb-了 & sentence-了, 过, 没(有) vs 不, the measure-word
system, 多少钱/块/毛, 比, 一点儿 vs 有点儿. **Vocab:** food & drink, shopping,
money. **Big rocks:** Z14, Z15, Z17, Z11 (system), Z24 (intro).

| # | Exercise | id | Type | Gate | Z# |
|---|----------|----|------|------|----|
| 1 | 了 №1 — the action is done | `en_zh_a2_2_le_done` | fillBlank | streak | **⚑ Z14** |
| 2 | 了 №2 — the situation is new | `en_zh_a2_2_le_change` | fillBlank | streak | **⚑ Z14** |
| 3 | Didn't: 没(有) — and when NOT 了 | `en_zh_a2_2_mei` | fillBlank | streak | **⚑ Z17** |
| 4 | Speaking: what I did yesterday | `en_zh_a2_2_speak_yesterday` | speakRepeat | play-through | Z14 |
| 5 | Ever done: 过 | `en_zh_a2_2_guo` | fillBlank | streak | **⚑ Z15** |
| 6 | Listening: 你吃饭了吗? | `en_zh_a2_2_listen_eaten` | listening | score | Z14 |
| 7 | The measure-word system | `en_zh_a2_2_measure_words` | fillBlank | streak | **⚑ Z11** |
| 8 | Shopping: 多少钱 / 块 / 毛 | `en_zh_a2_2_shopping` | fillBlank | streak | |
| 9 | Reading: 买东西 | `en_zh_a2_2_read_shopping` | reading | score | Z11 |
| 10 | Comparing with 比 | `en_zh_a2_2_bi` | fillBlank | streak | **⚑ Z24** |
| 11 | 一点儿 vs 有点儿 | `en_zh_a2_2_yidianr` | fillBlank | streak | |
| 12 | Sounds: 不 & 一 change tone | `en_zh_a2_2_speak_bu_yi` | speakRepeat | play-through | **⚑ Z2** |
| 13 | Food & drink | `en_zh_a2_2_food` | fillBlank | streak | |
| 14 | Dictation: yesterday (IME) | `en_zh_a2_2_dict_yesterday` | dictation | score | **⚑ Z14** |
| 15 | Reading: 汤姆的周末 | `en_zh_a2_2_read_weekend` | reading | score | |

### B1.1 — Results & Directions · *结果与方向* (HSK 3a)
**Can-do:** say how actions turned out, give directions of movement, say how
long/how often, connect causes and contrasts, talk about health. **Grammar:**
resultative complements (完/到/见/懂/好/错), directional 来/去 (+上/下/进/出/回/
起), duration & frequency after the verb, 的/得/地, 因为…所以 / 虽然…但是.
**Vocab:** health & body, study, movement. **Big rocks:** Z21, Z20, Z13 (ext),
Z25.

| # | Exercise | id | Type | Gate | Z# |
|---|----------|----|------|------|----|
| 1 | Verbs need a landing: 完/到/懂 | `en_zh_b1_1_result_1` | fillBlank | streak | **⚑ Z21** |
| 2 | More landings: 见/好/错 + 没V完 | `en_zh_b1_1_result_2` | fillBlank | streak | Z21 |
| 3 | Speaking: verb + landing drills | `en_zh_b1_1_speak_results` | speakRepeat | play-through | Z21 |
| 4 | Direction: V + 来/去 (进来, 出去) | `en_zh_b1_1_direction` | fillBlank | streak | **⚑ Z21** |
| 5 | Listening: 去医院 | `en_zh_b1_1_listen_hospital` | listening | score | |
| 6 | Duration after the verb | `en_zh_b1_1_duration` | fillBlank | streak | **⚑ Z13** |
| 7 | 的 / 得 / 地 — one sound, three jobs | `en_zh_b1_1_de_de_de` | fillBlank | streak | **⚑ Z20** |
| 8 | 得 — grading the result | `en_zh_b1_1_degree` | fillBlank | streak | Z20 Z21 |
| 9 | Reading: 学中文的路 | `en_zh_b1_1_read_learning` | reading | score | Z8 |
| 10 | Keep BOTH: 因为…所以 / 虽然…但是 | `en_zh_b1_1_pairs` | fillBlank | streak | **⚑ Z25** |
| 11 | Health & body | `en_zh_b1_1_health` | fillBlank | streak | |
| 12 | Speaking: longer sentences, steady tones | `en_zh_b1_1_speak_rhythm` | speakRepeat | play-through | Z6 |
| 13 | Big text: 的/得/地 in a letter | `en_zh_b1_1_bigtext_de` | reading (inline) | score | **⚑ Z20** |
| 14 | Listening: 王老师的建议 | `en_zh_b1_1_listen_advice` | listening | score | |
| 15 | Dictation: 我学了… (IME) | `en_zh_b1_1_dict_study` | dictation | score | Z13 |
| 16 | Reading: 汤姆病了 | `en_zh_b1_1_read_sick` | reading | score | |

### B1.2 — Describing & Defining · *描述与定义* (HSK 3b)
**Can-do:** describe and define people/things with clauses, highlight when/
where/how something happened, state real conditions, describe weather/change.
**Grammar:** 的 relative clauses, 是…的, 如果…就, 又…又 / 越来越 / 越…越,
potential complements V得/不C, separable verbs (见面/帮忙/唱歌). **Vocab:**
people & personality, weather & seasons. **Big rocks:** Z19, Z28, Z21
(potential), Z25.

| # | Exercise | id | Type | Gate | Z# |
|---|----------|----|------|------|----|
| 1 | The clause moves LEFT: V-的 + noun | `en_zh_b1_2_relative_1` | fillBlank | streak | **⚑ Z19** |
| 2 | Longer 的-clauses | `en_zh_b1_2_relative_2` | fillBlank | streak | Z19 |
| 3 | Speaking: describing people | `en_zh_b1_2_speak_people` | speakRepeat | play-through | |
| 4 | 是…的 — spotlighting the details | `en_zh_b1_2_shi_de` | fillBlank | streak | **⚑ Z28** |
| 5 | Listening: 他是什么时候来的? | `en_zh_b1_2_listen_shide` | listening | score | Z28 |
| 6 | If…then: 如果…就 | `en_zh_b1_2_ruguo` | fillBlank | streak | **⚑ Z25** |
| 7 | 又…又 / 越来越 / 越…越 | `en_zh_b1_2_you_yue` | fillBlank | streak | |
| 8 | Can manage it? V得/不C | `en_zh_b1_2_potential` | fillBlank | streak | **⚑ Z21** |
| 9 | Reading: 我认识的人 | `en_zh_b1_2_read_people` | reading | score | Z19 |
| 10 | Separable verbs: 见面, 帮忙 | `en_zh_b1_2_separable` | fillBlank | streak | ⚑ |
| 11 | Weather & seasons | `en_zh_b1_2_weather` | fillBlank | streak | |
| 12 | Speaking: chunking — read like words, not characters | `en_zh_b1_2_speak_chunks` | speakRepeat | play-through | **⚑ Z8** |
| 13 | Listening: 天气预报 | `en_zh_b1_2_listen_weather` | listening | score | |
| 14 | Dictation: descriptions (IME) | `en_zh_b1_2_dict_describe` | dictation | score | |
| 15 | Reading: 北京的四季 | `en_zh_b1_2_read_seasons` | reading | score | |

### B2.1 — Handling & Being Handled · *处置与被动* (HSK 4a)
**Can-do:** give instructions about objects, report mishaps, get things done
through others, compare in full detail. **Grammar:** 把 + complement, 被 &
notional passive, 让/叫 causatives, 比…更 / 最 / 跟…一样 / 没有…那么, abstract
directional complements (想起来, 坚持下去). **Vocab:** moving house, work,
services. **Big rocks:** Z22, Z23, Z24 (full), Z21 (abstract), Z6.
From here passages drop the pinyin scaffold (English translation only).

| # | Exercise | id | Type | Gate | Z# |
|---|----------|----|------|------|----|
| 1 | 把 — grab it, then act | `en_zh_b2_1_ba_1` | fillBlank | streak | **⚑ Z22** |
| 2 | 把 + where it lands (在/到/给) | `en_zh_b2_1_ba_2` | fillBlank | streak | Z22 |
| 3 | Speaking: instructions with 把 | `en_zh_b2_1_speak_ba` | speakRepeat | play-through | Z22 |
| 4 | 被 — when things happen TO you | `en_zh_b2_1_bei` | fillBlank | streak | **⚑ Z23** |
| 5 | The notional passive (问题解决了) | `en_zh_b2_1_notional` | fillBlank | streak | **⚑ Z23** |
| 6 | Listening: 谁把蛋糕吃了? | `en_zh_b2_1_listen_cake` | listening | score | Z22 |
| 7 | Making & letting: 让 / 叫 | `en_zh_b2_1_rang` | fillBlank | streak | |
| 8 | Comparison, the full kit | `en_zh_b2_1_compare` | fillBlank | streak | **⚑ Z24** |
| 9 | Reading: 搬家 | `en_zh_b2_1_read_moving` | reading | score | Z22 |
| 10 | Abstract directions: 起来 / 下去 | `en_zh_b2_1_abstract_dir` | fillBlank | streak | Z21 |
| 11 | Speaking: question intonation OVER tones | `en_zh_b2_1_speak_intonation` | speakRepeat | play-through | **⚑ Z6** |
| 12 | Work & office | `en_zh_b2_1_work` | fillBlank | streak | |
| 13 | Listening: 面试 | `en_zh_b2_1_listen_interview` | listening | score | |
| 14 | Dictation: 把-sentences (IME) | `en_zh_b2_1_dict_ba` | dictation | score | Z22 |
| 15 | Reading: 中国的快递 | `en_zh_b2_1_read_delivery` | reading | score | |

### B2.2 — Attitude & Flow · *语气与连贯* (HSK 4b)
**Can-do:** color statements with attitude, sequence and connect ideas
fluently, describe ongoing states, argue simple positions. **Grammar:** 着,
就 vs 才, 再 vs 又, 都/也/还 slots, sentence-final 吧/呢/啊, 不但…而且 /
只要…就 / 只有…才 / 即使…也 / 无论…都. **Vocab:** feelings, habits, opinions.
**Big rocks:** Z27, Z16 (着), Z25 (advanced), Z14 (review in cloze).

| # | Exercise | id | Type | Gate | Z# |
|---|----------|----|------|------|----|
| 1 | 着 — states that stay on | `en_zh_b2_2_zhe` | fillBlank | streak | **⚑ Z16** |
| 2 | 就 vs 才 — sooner vs later | `en_zh_b2_2_jiu_cai` | fillBlank | streak | **⚑ Z27** |
| 3 | 再 vs 又 — future vs past \"again\" | `en_zh_b2_2_zai_you` | fillBlank | streak | **⚑ Z27** |
| 4 | Speaking: attitude particles 吧/呢/啊 | `en_zh_b2_2_speak_particles` | speakRepeat | play-through | |
| 5 | The 都/也/还 slots | `en_zh_b2_2_dou_ye_hai` | fillBlank | streak | Z27 |
| 6 | Listening: 等人 | `en_zh_b2_2_listen_waiting` | listening | score | Z27 |
| 7 | Strong pairs: 不但…而且 / 只要…就 / 只有…才 | `en_zh_b2_2_pairs` | fillBlank | streak | **⚑ Z25** |
| 8 | Big text: 了/过/着 — the aspect story | `en_zh_b2_2_bigtext_aspect` | reading (inline) | score | **⚑ Z14 ⚑ Z15 ⚑ Z16** |
| 9 | Reading: 一次约会 | `en_zh_b2_2_read_date` | reading | score | |
| 10 | Concession: 即使…也 / 无论…都 | `en_zh_b2_2_concession` | fillBlank | streak | Z25 |
| 11 | Speaking: connected speech at pace | `en_zh_b2_2_speak_flow` | speakRepeat | play-through | Z6 |
| 12 | Feelings & opinions | `en_zh_b2_2_feelings` | fillBlank | streak | |
| 13 | Listening: 播客 — 好习惯 | `en_zh_b2_2_listen_podcast` | listening | score | |
| 14 | Dictation: attitude lines (IME) | `en_zh_b2_2_dict_attitude` | dictation | score | |
| 15 | Reading: 手机与生活 | `en_zh_b2_2_read_phones` | reading | score | |

### C1.1 — Precision & Nuance · *精确与辨析* (HSK 5)
**Can-do:** discuss abstract topics precisely, choose between near-synonyms,
structure formal statements, use first idioms naturally. **Grammar:**
near-synonym discrimination, 使/令/让, 对/对于/关于/由于/通过, 既然/否则/…的话,
word-building 化/性/主义, verb-object collocations 取得/产生/造成. **Vocab:**
society, education, environment (abstract). **Big rocks:** near-synonyms, Z29
(formal coverbs), Z30 (成语 intro), Z7 (word-building bridge).

| # | Exercise | id | Type | Gate | Z# |
|---|----------|----|------|------|----|
| 1 | Near-synonyms I: 帮助/帮忙, 突然/忽然 | `en_zh_c1_1_synonyms_1` | fillBlank | streak | ⚑ |
| 2 | Formal causatives: 使 / 令 / 让 | `en_zh_c1_1_shi_ling` | fillBlank | streak | |
| 3 | Speaking: presenting an opinion | `en_zh_c1_1_speak_opinion` | speakRepeat | play-through | |
| 4 | 对 / 对于 / 关于 / 由于 | `en_zh_c1_1_prepositions` | fillBlank | streak | **⚑ Z29** |
| 5 | Listening: 讲座 — 城市化 | `en_zh_c1_1_listen_lecture` | listening | score | |
| 6 | First 成语: 马马虎虎, 入乡随俗… | `en_zh_c1_1_chengyu` | fillBlank | streak | **⚑ Z30** |
| 7 | Long attributives (的-chains) | `en_zh_c1_1_attributives` | fillBlank | streak | Z19 |
| 8 | Reading: 科技与生活 | `en_zh_c1_1_read_tech` | reading | score | |
| 9 | 既然 / 否则 / …的话 | `en_zh_c1_1_jiran` | fillBlank | streak | Z25 |
| 10 | Word-building: 化 / 性 / 主义 | `en_zh_c1_1_word_building` | fillBlank | streak | **⚑ Z7** |
| 11 | Speaking: formal register delivery | `en_zh_c1_1_speak_formal` | speakRepeat | play-through | Z30 |
| 12 | Collocations: 取得/产生/造成 | `en_zh_c1_1_collocations` | fillBlank | streak | ⚑ |
| 13 | Listening: 访谈 — 环境 | `en_zh_c1_1_listen_environment` | listening | score | |
| 14 | Dictation: opinion lines (IME) | `en_zh_c1_1_dict_opinion` | dictation | score | |
| 15 | Reading: 一篇议论文 | `en_zh_c1_1_read_essay` | reading | score | Z30 |

### C1.2 — The Written Register · *书面语* (HSK 5–6)
**Can-do:** read news and formal prose comfortably, shift between spoken and
written register, hedge and soften claims, follow formal argument. **Grammar:**
书面语 function words (将/于/之/而/则/即/并), formal passive 由/受/遭, rhetorical
难道/岂不, discourse markers 然而/因此/此外/总之, hedging 恐怕/未必/不见得,
register pairs (跟→与, 给→为, 用→以). **Vocab:** news, formal correspondence,
business. **Big rocks:** Z30, Z23 (formal passive), Z25 (formal).

| # | Exercise | id | Type | Gate | Z# |
|---|----------|----|------|------|----|
| 1 | 将 — the written 把 (and 于) | `en_zh_c1_2_jiang_yu` | fillBlank | streak | **⚑ Z30** |
| 2 | 之 / 而 / 则 | `en_zh_c1_2_zhi_er_ze` | fillBlank | streak | Z30 |
| 3 | Speaking: reading a news lead | `en_zh_c1_2_speak_news` | speakRepeat | play-through | Z30 |
| 4 | Formal passive: 由 / 受 / 遭 | `en_zh_c1_2_formal_passive` | fillBlank | streak | **⚑ Z23** |
| 5 | Listening: 新闻播报 | `en_zh_c1_2_listen_news` | listening | score | |
| 6 | Flow markers: 然而/因此/此外/总之 | `en_zh_c1_2_discourse` | fillBlank | streak | **⚑ Z25** |
| 7 | Rhetorical questions: 难道 / 岂不 | `en_zh_c1_2_rhetorical` | fillBlank | streak | |
| 8 | Reading: 一篇社论 | `en_zh_c1_2_read_editorial` | reading | score | Z30 |
| 9 | Hedging: 恐怕 / 未必 / 不见得 | `en_zh_c1_2_hedging` | fillBlank | streak | ⚑ |
| 10 | Register pairs: 跟→与, 给→为 | `en_zh_c1_2_register_pairs` | fillBlank | streak | **⚑ Z30** |
| 11 | Speaking: formal vs casual delivery | `en_zh_c1_2_speak_register` | speakRepeat | play-through | |
| 12 | Big text: a report in 书面语 | `en_zh_c1_2_bigtext_formal` | reading (inline) | score | **⚑ Z30** |
| 13 | Listening: 商务会谈 | `en_zh_c1_2_listen_business` | listening | score | |
| 14 | Dictation: formal lines (IME) | `en_zh_c1_2_dict_formal` | dictation | score | Z30 |
| 15 | Reading: 两封信，两种语体 | `en_zh_c1_2_read_letters` | reading | score | |

### C2.1 — Idiom & Color · *成语与色彩* (HSK 6 / Band 3)
**Can-do:** use idioms and sayings appropriately, read between the lines,
control connotation, understand humor. **Grammar/lexis:** 成语 in narrative and
argument, 惯用语/俗语/歇后语, connotation pairs (果断/武断, 成果/后果), marked
structures 连…都 / 再…也 / 非…不可, fine 了/着/过 nuance, precision pairs
(发挥/发扬, 度过/渡过). **Big rocks:** Z30 (mastery), Z27, Z14–16 (nuance).

| # | Exercise | id | Type | Gate | Z# |
|---|----------|----|------|------|----|
| 1 | 成语 I — in stories | `en_zh_c2_1_chengyu_1` | fillBlank | streak | **⚑ Z30** |
| 2 | 成语 II — in argument | `en_zh_c2_1_chengyu_2` | fillBlank | streak | Z30 |
| 3 | Speaking: storytelling with idioms | `en_zh_c2_1_speak_story` | speakRepeat | play-through | |
| 4 | Street Chinese: 惯用语 & 俗语 | `en_zh_c2_1_guanyongyu` | fillBlank | streak | ⚑ |
| 5 | Listening: 幽默 — 相声片段 | `en_zh_c2_1_listen_humor` | listening | score | |
| 6 | Connotation: 果断 or 武断? | `en_zh_c2_1_connotation` | fillBlank | streak | ⚑ |
| 7 | Marked syntax: 连…都, 再…也, 非…不可 | `en_zh_c2_1_marked` | fillBlank | streak | **⚑ Z27** |
| 8 | Reading: 一篇讽刺文章 | `en_zh_c2_1_read_satire` | reading | score | Z30 |
| 9 | 歇后语 & cultural references | `en_zh_c2_1_xiehouyu` | fillBlank | streak | Z30 |
| 10 | Speaking: prosody & attitude | `en_zh_c2_1_speak_prosody` | speakRepeat | play-through | Z6 |
| 11 | Aspect at C2: 了/着/过 nuance | `en_zh_c2_1_aspect_nuance` | fillBlank | streak | **⚑ Z14** |
| 12 | Listening: 文学朗读 | `en_zh_c2_1_listen_literary` | listening | score | |
| 13 | Dictation: nuanced lines (IME) | `en_zh_c2_1_dict_nuance` | dictation | score | |
| 14 | Reading: 一篇书评 | `en_zh_c2_1_read_review` | reading | score | |
| 15 | Precision pairs: 发挥/发扬, 度过/渡过 | `en_zh_c2_1_precision` | fillBlank | streak | ⚑ |

### C2.2 — Mastery · *精通* (HSK 7–9, capstone)
**Can-do:** understand and produce virtually everything; analyse style; argue
with sophistication; handle irony, allusion and classical flavor. **Grammar/
lexis:** 文言 elements in modern prose (所谓/而已/皆/乃/即便), 与其…不如 / 宁可,
discourse-level cohesion, translationese repair, tone & irony control. **Big
rocks:** Z30 (ceiling), Z9-inverse (write *Chinese* Chinese, not translated
English).

| # | Exercise | id | Type | Gate | Z# |
|---|----------|----|------|------|----|
| 1 | Classical flavor: 所谓 / 而已 / 皆 / 乃 | `en_zh_c2_2_wenyan` | fillBlank | streak | **⚑ Z30** |
| 2 | Discourse cohesion at C2 | `en_zh_c2_2_cohesion` | fillBlank | streak | Z30 |
| 3 | Speaking: deliver a short speech | `en_zh_c2_2_speak_speech` | speakRepeat | play-through | |
| 4 | Weighing choices: 与其…不如 / 宁可 | `en_zh_c2_2_weighing` | fillBlank | streak | |
| 5 | Listening: 时事辩论 | `en_zh_c2_2_listen_debate` | listening | score | |
| 6 | Allusion: 塞翁失马 & friends | `en_zh_c2_2_allusion` | fillBlank | streak | Z30 |
| 7 | Reading: 一篇新闻分析 | `en_zh_c2_2_read_analysis` | reading | score | |
| 8 | Say it in Chinese, not translated English | `en_zh_c2_2_natural` | fillBlank | streak | ⚑ |
| 9 | Tone & irony control | `en_zh_c2_2_irony` | fillBlank | streak | Z30 |
| 10 | Speaking: spontaneous rebuttal | `en_zh_c2_2_speak_rebuttal` | speakRepeat | play-through | |
| 11 | Listening: 文化讲座 | `en_zh_c2_2_listen_culture` | listening | score | |
| 12 | Dictation: 一段社论 (IME) | `en_zh_c2_2_dict_editorial` | dictation | score | Z30 |
| 13 | Reading: 分析一篇短篇小说 | `en_zh_c2_2_read_story` | reading | score | |
| 14 | Reading: capstone — 一篇长篇特稿 | `en_zh_c2_2_read_capstone` | reading | score | |
| 15 | Speaking: capstone — your view | `en_zh_c2_2_speak_capstone` | speakRepeat | play-through | |

---

## 9. Skill coverage (HSK / HSKK mapping)

| Exam skill | Where covered |
|------------|---------------|
| **听力 Listening** | The 1–2 `listening` quizzes per module (~18 hidden-audio passages) — tone perception at speech rate, the receptive cliff for a non-tonal L1. |
| **阅读 Reading** | The 2 `reading` quizzes per module (~26 passages incl. 3 inline big-text clozes) — character recognition in context, chunking without spaces; pinyin+English info-button scaffold through B1, English-only from B2.1. |
| **书写 Writing** | The 1 `dictation` quiz per module (12) — hear & type via pinyin IME, exactly the computer-based HSK writing mechanic. |
| **口语 Speaking (HSKK)** | The 2–4 `speakRepeat` quizzes per module (~29) — model phrases *plus* the dedicated tone/pinyin-focus quizzes (four tones, tone pairs, sandhi, 不/一, j/q/x, -n/-ng, prosody); HSKK 初级 is literally listen-and-repeat. |
| **语法/词汇** | All `fillBlank` knowledge quizzes (~97), HSK-word-list-sequenced; answers accept hanzi or pinyin. |

## 10. Reading & listening catalogue (level-aligned, interesting)

All passages/audio in Chinese; pinyin + English behind the info button through
B1, English-only from B2.1. A-levels use a recurring cast (**汤姆 Tom**, a
British student in Beijing; his friend **小美**; **王老师**).

- **A1.1** — 我叫汤姆 · 你好! (listen)
- **A1.2** — 这是我的家 · 我的朋友小美 · 我的家 (listen)
- **A2.1** — 汤姆的一天 · 在咖啡馆 · 你几点起床?, 周末做什么? (listen)
- **A2.2** — 买东西 · 汤姆的周末 · 你吃饭了吗? (listen)
- **B1.1** — 学中文的路 · 汤姆病了 · big text: 的/得/地 letter · 去医院, 王老师的建议 (listen)
- **B1.2** — 我认识的人 · 北京的四季 · 他是什么时候来的?, 天气预报 (listen)
- **B2.1** — 搬家 · 中国的快递 · 谁把蛋糕吃了?, 面试 (listen)
- **B2.2** — 一次约会 · 手机与生活 · big text: aspect story · 等人, 播客—好习惯 (listen)
- **C1.1** — 科技与生活 · 一篇议论文 · 讲座—城市化, 访谈—环境 (listen)
- **C1.2** — 一篇社论 · 两封信，两种语体 · big text: 书面语 report · 新闻播报, 商务会谈 (listen)
- **C2.1** — 一篇讽刺文章 · 一篇书评 · 幽默—相声片段, 文学朗读 (listen)
- **C2.2** — 一篇新闻分析 · 分析一篇短篇小说 · 一篇长篇特稿 (capstone) · 时事辩论, 文化讲座 (listen)

## 11. Totals & effort

- **12 modules → ≈ 182 quizzes**: ≈ **97** `fillBlank`, **29** `speakRepeat`,
  **26** `reading` (incl. 3 inline big-text clozes), **18** `listening`,
  **12** `dictation`. Every module carries ≥ 2 readings, ≥ 2 speaking, ≥ 1
  listening, ≥ 1 dictation.
- **≈ 1,600+ content items** (drill items + spoken phrases + reading/listening
  questions + dictation sentences + inline blanks).
- **30 contrastive points** (Z1–Z30); ~45 quizzes carry a dedicated **⚑ Z#**
  focus, the rest carry contrastive tips in Help Memory.
- Rough first-completion time: A-levels ~55 min/module, B-levels ~75 min,
  C-levels ~90 min; the full ladder ≈ 14 hours of first-pass study.

## 12. What makes this course distinct (design summary)

1. **The tone spine.** ~10 of the 29 `speakRepeat` quizzes are *dedicated* tone
   work (four tones, tone pairs, sandhi, 不/一 changes, intonation-over-tones)
   — front-loaded because tone gates everything downstream, and modeled on the
   HSKK 初级 repeat-after-me task.
2. **Pinyin scaffold with a planned exit.** Fill answers accept pinyin alongside
   hanzi (auto-expanded: tone-marked entries also accept bare letters), and
   passages carry pinyin behind the info button — through B1, then it's gone.
3. **The IME as the writing exam.** Dictation = hear Chinese, type it with a
   pinyin IME — the exact mechanic of the computer-based HSK writing paper and
   the way Chinese is actually written today.
4. **Radicals as strategy, not rote.** Characters enter through components
   ("meaning left, sound right") and compound transparency (电脑 = electric
   brain), never stroke drilling.
5. **The aspect system spiralled to C2.** 了/过/着 get intro (A2.2) →
   consolidation (B2.2 big-text cloze) → nuance (C2.1) — because "了 = past
   tense" is the error that never dies.
6. **The 书面语 module.** C1.2 treats written Chinese as the half-new grammar it
   really is (将/于/之/而/则, 由/受/遭) — the gap every HSK 5–6 candidate hits.
7. **Bridges, not just traps.** No-morphology, Lego numbers, the regular
   calendar, compound transparency and partitives→measure-words are named as
   *advantages* to keep motivation high.

---

## 13. Implementation appendix (engineering notes)

Reuse the `zh_en` playbook (§13 of
[`zh_en_certification_plan.md`](zh_en_certification_plan.md)); this course
needs **no new engineering seams**:

1. **UI language** — `UiLang.en` (built-in). No l10n work.
2. **TTS** — `learnLocale: 'zh-CN'`; the chain already carries Mandarin neural
   voices (Azure `zh-CN-XiaoxiaoNeural`/`YunxiNeural`, Google
   `cmn-CN-Wavenet-A/B`) plus the on-device fallback.
3. **Builder** — `lib/data/courses/en_zh/en_zh_builder.dart` mirrors
   `zh_en_builder.dart` oriented 🇬🇧→🇨🇳: `fillBlank` prompt = English cue,
   answer = Chinese (with `**…**` isolating the blanked word); a pinyin
   expansion helper auto-adds bare-letter variants of tone-marked `accepted`
   entries (nǚ → nv/nu). `enZhBigText` mirrors `enDeBigText` for the three
   inline particle clozes.
4. **Content files** — `en_zh_a1_1.dart … en_zh_c2_2.dart` (12 files), exported
   as `enZhA1_1` …, wired through `en_zh_content.dart`.
5. **Course registration** — `Course(id: 'en_zh', name: 'Certification Chinese
   · HSK', tagline: 'From nǐ hǎo to HSK mastery — tones, characters and all',
   uiLang: UiLang.en, speakFlag: '🇬🇧', learnFlag: '🇨🇳', learnLocale:
   'zh-CN')` + a gated 12-group `NavLayout` in `course_catalog.dart`; add the
   course to `quiz_content_library.dart` and `tool/generate_content.dart`.
6. **Versioning** — bump `kDataVersion`; regenerate bundles
   (`dart run tool/generate_content.dart`) **and** the seed
   (`dart run tool/generate_seed.dart`); refresh the `content_snapshot` +
   `storage_keys` goldens (`UPDATE_GOLDEN=1`); bump the course count in
   `test/asset_provider_test.dart`.
7. **Quality gate** — `test/en_zh_course_test.dart` mirrors
   `zh_en_course_test.dart`: registration seams, unique ids, Help Memory
   everywhere, answerable reading/listening data, spoken/dictation lines carry
   meanings, plus en_zh-specific checks (Chinese answers in fills, pinyin
   acceptance on marked blanks, big-text blanks resolve).

## Sources

- [Chinese Testing International · HSK exam structure](https://www.chinesetest.cn/) — levels, sections, the computer-based writing paper.
- [《国际中文教育中文水平等级标准》GF 0025-2021 (Chinese Proficiency Grading Standards, MoE/State Language Commission 2021)](http://www.moe.gov.cn/jyb_sjzl/ziliao/A19/202103/t20210329_523304.html) — three bands, nine levels; character/word/grammar inventories.
- [HSK 2009 vocabulary & grammar syllabus (levels 1–6)](https://www.chinesetest.cn/godownload.do) — the word lists modules stay inside.
- [HSKK (汉语水平口语考试) formats](https://www.chinesetest.cn/) — 初级 listen-and-repeat mirrors `speakRepeat`.
- [TOCFL ↔ CEFR alignment (SC-TOP)](https://tocfl.edu.tw/) — the CEFR-aligned cross-check.
- [EBCL — European Benchmarking Chinese Language](http://ebcl.eu.com/) — CEFR A1–B1 can-do descriptors for Chinese.
- [Fachverband Chinesisch · statement on HSK–CEFR alignment](https://www.fachverband-chinesisch.de/) — the conservative mapping this ladder follows.
- [Council of Europe · CEFR global & skill descriptors (A1–C2)](https://www.coe.int/en/web/common-european-framework-reference-languages/level-descriptions)