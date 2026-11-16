# Ukrainian mode: translator brief

The site teaches German. It explains German in English (and in Turkish and Arabic for A1–A2).
Ukrainian mode explains the same German in Ukrainian, for levels A1.1–A2.2 (app exercises and
the printed books). The readers are Ukrainians in Germany: mostly adults who fled the war since
2022, many of them women with children, many in or before an integration course, often well
educated and needing German for work, school, offices and doctors. You translate the English
into Ukrainian. **The German never changes.**

The pipeline is the Turkish one with `--lang uk`; `docs/turkish_guide.md` has the same rules.
Everything below is what differs or matters most for Ukrainian.

## Files

- Source: `tool/turkish/en/<level>/{app,book}/<id>.json`, a flat object `{ "path": "English" }`.
- You write: `tool/turkish/uk/<level>/{app,book}/<id>.json` with **the same name and the same
  keys**, values in Ukrainian. One output file per input file. Valid JSON, UTF-8.
- Check: `node tool/turkish/build.mjs <level> --lang uk --check` (errors must be zero).
- What is left: `node tool/turkish/extract.mjs <level> --lang uk`.
- Interface strings: `tool/turkish/ui/en-uk.json` (`{ English: English }`) → write
  `tool/turkish/ui/uk.json` (`{ English: Ukrainian }`).
- Tap-a-word meanings: `tool/turkish/en/dictionary/part-NN.json` → `tool/turkish/uk/dictionary/part-NN.json`.

## Language and tone

- **Standard modern Ukrainian** (сучасна літературна мова), plain and short. No Russian words or
  Russian-style constructions (no «приймати участь», «на протязі», «слідуючий»: say «брати
  участь», «протягом», «наступний»). No surzhyk. A1 learners read these explanations: short
  sentences, everyday words.
- **Address the learner as «ти»**, warm and direct, as Ukrainian learning apps do: «Напиши»,
  «Вибери», «Послухай». **Buttons and menu items are infinitives or nouns**, as Ukrainian
  interfaces write them: «Почати», «Перевірити», «Пропустити», «Далі», «Налаштування».
- **Keep the learner's gender open.** Ukrainian past tense and short adjectives show gender
  («ти зробив/зробила», «ти готовий/готова»). Readers are of every gender (many are women), so
  rephrase to avoid it: present tense, imperative, a noun, or the impersonal form («Готово!»,
  «Ти впорався» → «Вийшло!», «Ти вже знаєш…», «Зроблено: 8 із 10»). Use «(-ла)» style only when
  nothing else works. Characters in stories (Maya, Tom) keep their own gender, of course.
- **Ukrainian punctuation**: quotes «…» for Ukrainian quotations (German quoted inside keeps „…“
  or "…" as in the English). The apostrophe in words like «м’ята», «сім’я» is ’ (U+2019).
- **No long dashes (— or –) in prose**, even where Ukrainian grammar likes one («Це — стіл»): use
  a colon, a comma, a full stop, or drop it («Це стіл»). (A range like `0–10` stays.)
- Numbers: decimal comma (2,20 €), times as in the German (14:30).

## What to keep exactly

- **Every German word, phrase and sentence**, letter for letter, including in mixed lines.
  `bin only ever goes with ich` → `bin вживається лише з ich`. If a whole value is German, copy it.
- Placeholders and blanks: `{subject}`, `{a}`, `{pl}`, `{n}`, `{{0}}`, `____` (same count, same
  spelling). `*stars*` (emphasis) balanced, around the matching words.
- Names (Maya, Tom, Frau Huber), numbers, times, prices (2,20 €), arrows `→`, the separator ` · `.
- Line breaks and list structure.

## Grammar words (first time in a file: Ukrainian + German term; later the German alone is fine)

| German term | Ukrainian |
|---|---|
| Artikel | артикль (Artikel) |
| Nomen | іменник (Nomen) |
| Verb | дієслово (Verb) |
| Adjektiv | прикметник (Adjektiv) |
| Präposition | прийменник (Präposition) |
| Pronomen | займенник (Pronomen) |
| Plural / Singular | множина / однина |
| maskulin / feminin / neutral | чоловічий / жіночий / середній рід |
| Nominativ | називний відмінок (Nominativ) |
| Akkusativ | знахідний відмінок (Akkusativ) |
| Dativ | давальний відмінок (Dativ) |
| Genitiv | родовий відмінок (Genitiv) |
| Perfekt / Präteritum | Perfekt (розмовний минулий час) / Präteritum (книжний минулий час) |
| trennbares Verb | дієслово з відокремлюваним префіксом (trennbares Verb) |
| Modalverb | модальне дієслово (Modalverb) |
| Nebensatz | підрядне речення (Nebensatz) |
| konjugieren | відмінювати (дієслово) за особами |

## Rewrite, do not just translate, where the English leans on English

Many explanations compare German with English. A Ukrainian speaker needs the comparison with
**Ukrainian** instead, or none. Ukrainian is often the *better* bridge to German than English is:
use that. **Never compare with Russian.**

- **Gender.** Ukrainian has the same three genders: чоловічий, жіночий, середній. Good news, but
  the gender of a word often differs (die Sonne is feminine, «сонце» neuter; das Mädchen is neuter,
  «дівчина» feminine; der Tisch and «стіл» are both masculine only by luck). Say plainly: learn
  each noun with its article.
- **The article.** Ukrainian has no articles at all. In German der/die/das (and ein/eine) show the
  gender, number and case, and the noun itself barely changes. ein/eine ≈ «один/одна, якийсь».
- **Cases.** Ukrainian has seven cases, so the idea is familiar. Nominativ ≈ називний (хто? що?),
  Akkusativ ≈ знахідний (кого? що?), Dativ ≈ давальний (кому? чому?), Genitiv ≈ родовий (кого?
  чого?). The big difference: in German mostly the **article** carries the case (der → den → dem),
  not the noun's ending. And German prepositions take different cases than Ukrainian ones
  (mit + Dativ, but «з» + орудний): learn each preposition with its case.
- **Word order.** Ukrainian word order is free. German is strict: the conjugated verb stands
  **second**, and infinitives, participles and the verb of a *dass/weil* clause go **to the end**.
  Say so where it matters.
- **du / Sie** = «ти / Ви». The same idea as in Ukrainian: Sie for strangers, officials and at
  work, du for friends, family and children. Sie is written with a capital S, like the polite «Ви».
- **Past tenses.** Ukrainian has one past tense (with aspect). German speech uses the Perfekt
  (haben/sein + Partizip II); the Präteritum is for writing and for a few verbs (war, hatte, Modalverben).
- **Separable verbs.** A Ukrainian prefix stays on the verb (прийти); a German separable prefix
  goes to the end of the clause (ich komme an). Point it out.
- **Plurals.** German plurals must be learnt per noun, with the article die.
- **Pronunciation in Ukrainian letters** where the English uses English sounds:
  German **h** is a light breath, not Ukrainian «г» (Haus ≈ «хаус», softly); German **g** is
  Ukrainian «ґ» (gut ≈ «ґут»); ch after a/o/u = «х» (Bach); ch after e/i = a soft hiss between
  «хь» and «ш» (ich); sch = «ш»; st/sp at the start of a word = «шт/шп» (Straße, Sport);
  s before a vowel = «з» (sie ≈ «зі»); z = «ц» (zehn ≈ «цен»); w = «в» (Wasser ≈ «васер»);
  v = «ф» (Vater ≈ «фатер»); j = «й» (ja ≈ «я»); ei = «ай» (zwei ≈ «цвай»); ie = a long «і»
  (sieben ≈ «зібен»); eu/äu = «ой» (neu ≈ «ной»); ü = say «і» with rounded lips (like «ю» without
  the «й»); ö = say «е» with rounded lips; final -er ≈ a short «а» (Vater ≈ «фата»).
- English false friends (bekommen ≠ become, Gift ≠ gift): drop the English angle; add a
  Ukrainian one only if it is real.
- Examples of English sounds ("like the ee in see") become Ukrainian ones.

## Cues and meanings

- Pronoun cues in fill-in sentences:
  `(I)` → `(я)`, `(you, informal)` → `(ти)`, `(you, plural)` → `(ви)`,
  `(you, formal)` → `(Ви, ввічливо)`, `(he)` → `(він)`, `(she)` → `(вона)`,
  `(it)` → `(воно)`, `(we)` → `(ми)`, `(they)` → `(вони)`. `English: I` → `Українською: я`.
- Word meanings (`en` beside a German word, `english`, `translation`, `optionsTranslation`):
  the natural Ukrainian meaning. `friend (m)` → `друг (ч.)`. `Leute · people` → `Leute · люди`.
  Nouns in the nominative singular; verbs in the infinitive: `gehen` → `іти`.
- **Templates** (`englishTemplates`, values with `{subject}`, `{pl}`, `{a}`): the app fills
  `{subject}` and `{pl}` with a *bare* Ukrainian noun in the nominative singular and **drops
  `{a}`**. Write sentences where the nominative singular fits: «Це {a} {subject}.» → «Це {subject}.»;
  never a number or «багато» right before a placeholder (it would need another case):
  «Я бачу два: {pl}.» is fine (colon), «два {pl}» is not. Never glue an ending to a placeholder.

## Per place, not per string

The overlay is exact per exercise and per path, so the same English can get different Ukrainian
in different places (du → «Як тебе звати?», Sie → «Як Вас звати?»). Inside one check
(`…check.q`, `…check.options[n]`, `…check.answer`), the answer must equal one option exactly.

## Never

- No exam brand names. No more "exam" or "test" talk than the English has.
- Do not add or drop information beyond what the Ukrainian reader needs. Do not translate German.
- Do not edit anything outside `tool/turkish/uk/` and `tool/turkish/ui/uk.json`.
- English kept on purpose inside a story (a character speaking English) stays English.
- No Russian, no comparisons with Russian, no war references the English does not have.

When unsure (a joke that does not travel, a rule that changes for Ukrainian speakers), choose the
clearest version and add file + key + your doubt to `docs/ukrainian_review.md`.
