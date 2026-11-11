# Arabic mode: translator brief

The site teaches German. Today it explains German in English (and in Turkish for A1–A2). Arabic
mode explains the same German in Arabic, for levels A1.1–A2.2 (app exercises and the printed
books). The readers are Arabic speakers in Germany: refugees, asylum seekers and skilled migrants
from Syria, Iraq and other Arab countries, many in or before an integration course. They need
German for daily life, work and residency. You translate the English into Arabic.
**The German never changes.**

The pipeline is the Turkish one with `--lang ar`; `docs/turkish_guide.md` has the same rules.
Everything below is what differs or matters most for Arabic.

## Files

- Source: `tool/turkish/en/<level>/{app,book}/<id>.json`, a flat object `{ "path": "English" }`.
- You write: `tool/turkish/ar/<level>/{app,book}/<id>.json` with **the same name and the same
  keys**, values in Arabic. One output file per input file. Valid JSON, UTF-8.
- Check: `node tool/turkish/build.mjs <level> --lang ar --check` (errors must be zero).
- What is left: `node tool/turkish/extract.mjs <level> --lang ar`.
- Interface strings: `tool/turkish/ui/en.json` (`{ English: file }`) → write
  `tool/turkish/ui/ar.json` (`{ English: Arabic }`).
- Tap-a-word meanings: `tool/turkish/en/dictionary/part-NN.json` → `tool/turkish/ar/dictionary/part-NN.json`.

## Language and tone

- **Modern Standard Arabic, plain and short** (فصحى مبسطة), the Arabic of a good school book,
  readable by a Syrian, an Iraqi, a Moroccan and an Egyptian alike. No dialect, no rare words.
  A1 learners read these explanations: short sentences, everyday words.
- **Address the learner in the masculine singular** (اكتبْ، اختَرْ، أنتَ) as Arabic textbooks and
  apps do. Where a neutral form is just as easy (a noun: «الكتابة», «اختيار الكلمة»), prefer it.
  Buttons are short imperatives or nouns: «ابدأ»، «تحقّق»، «تخطَّ»، «التالي».
- **No diacritics** (tashkeel) except where a word would be ambiguous or for a short vowel
  you are explaining.
- **Arabic punctuation in Arabic text**: the comma «،», the question mark «؟», the semicolon «؛».
  German keeps its own punctuation.
- **Digits: Western 0–9** (the German numbers, prices and times use them, and so does the
  learner's phone keyboard in Germany). Never ٠١٢٣.
- **No long dashes (— or –) in prose.** Use «،» or «:» or a full stop. (A range like `0–10` stays.)
- Quotes: use «…» for Arabic quotations; German quoted inside keeps „…“ or "…" as in the English.

## What to keep exactly

- **Every German word, phrase and sentence**, letter for letter, including in mixed lines.
  `bin only ever goes with ich` → `bin تأتي فقط مع ich`. If a whole value is German, copy it.
- Placeholders and blanks: `{subject}`, `{a}`, `{pl}`, `{n}`, `{{0}}`, `____` (same count, same
  spelling). `*stars*` (emphasis) balanced, around the matching words.
- Names (Maya, Tom, Frau Huber), numbers, times, prices (2,20 €), arrows `→`, the separator ` · `.
- Line breaks and list structure.
- German inside an Arabic sentence reads fine: the page lays it out left to right by itself. Do not
  add Latin quotes around German just for that.

## Grammar words (first time in a file: Arabic + German term; later the German alone is fine)

| German term | Arabic |
|---|---|
| Artikel | أداة التعريف (Artikel) |
| Nomen | الاسم (Nomen) |
| Verb | الفعل (Verb) |
| Adjektiv | الصفة (Adjektiv) |
| Präposition | حرف الجر (Präposition) |
| Pronomen | الضمير (Pronomen) |
| Plural / Singular | الجمع / المفرد |
| maskulin / feminin / neutral | مذكر / مؤنث / محايد |
| Nominativ | حالة الرفع (Nominativ) |
| Akkusativ | حالة النصب (Akkusativ) |
| Dativ | حالة الجر بعد بعض الأفعال والحروف (Dativ) |
| Genitiv | حالة الإضافة (Genitiv) |
| Perfekt / Präteritum | الماضي التام (Perfekt) / الماضي البسيط (Präteritum) |
| trennbares Verb | الفعل المنفصل (trennbares Verb) |
| Modalverb | الفعل المساعد الدال على الإمكان أو الرغبة (Modalverb) |
| Nebensatz | الجملة الفرعية (Nebensatz) |

## Rewrite, do not just translate, where the English leans on English

Many explanations compare German with English. An Arabic speaker needs the comparison with
**Arabic** instead, or none. Never keep "just like English" unless it truly helps.

- **Gender.** Arabic has two genders, German three: masculine, feminine and **neutral**, which
  Arabic does not have. And the gender often differs from Arabic (die Sonne is feminine like
  الشمس, but der Mond masculine like القمر is luck, not a rule; das Mädchen is neutral). Say
  plainly: learn each noun with its article.
- **The article.** Arabic «ال» never changes. German der/die/das changes with gender, number and
  case. ein/eine ≈ the indefinite noun with tanween (كتابٌ = ein Buch); Arabic has no word for it.
- **Cases map well onto i'rab. Use it:** Nominativ ≈ المرفوع (the subject: der Mann kommt ≈
  جاءَ الرجلُ); Akkusativ ≈ المنصوب (the direct object: ich sehe den Mann ≈ رأيتُ الرجلَ);
  Dativ ≈ often what follows a preposition, like the مجرور after حروف الجر (mit dem Bus ≈ بالحافلةِ),
  and the person something is given to; Genitiv ≈ الإضافة (das Auto des Mannes ≈ سيارةُ الرجلِ).
  The big difference: in German the **article** carries the case (der → den → dem), not the
  noun's ending. Mention it only where it helps.
- **Word order.** Arabic often starts with the verb. German puts the conjugated verb **second**,
  and sends infinitives, participles and the verb of a *dass/weil* clause **to the end**. Say so
  where it matters.
- **du / Sie.** Arabic has no polite pronoun in the grammar. Sie is the polite form for strangers,
  officials and at work, like saying «حضرتك»; du is for friends, family and children.
- **Conjugation.** Arabic conjugates by person too, so a German verb changing its ending is a
  familiar idea. Lean on it.
- **Plurals.** German plurals, like Arabic broken plurals (جمع التكسير), must be learnt per noun.
- **Pronunciation in Arabic letters** where the English uses English sounds:
  ch after a/o/u = «خ» (Bach); sch = «ش»; s before a vowel = «ز» (sie ≈ زي); z = «تس» (zehn ≈
  تسين); w = the sound v, write «ڤ» (Wasser ≈ ڤاسر); v = «ف» (Vater ≈ فاتر); j = «ي» (ja ≈ يا);
  ei = «اي» (zwei ≈ تسڤاي); ie = a long «ي» (sieben ≈ زيبن); eu/äu = «وي» (neu ≈ نوي);
  p is a real p (not «ب»): write «پ» and say so the first time; ü and ö have no Arabic letter:
  ü = say «ي» with rounded lips, ö = say «ي/إ» with rounded lips; final -er ≈ a short «ا».
  ch after e/i = a soft hiss between «ش» and «خ» (ich).
- English false friends (bekommen ≠ become, Gift ≠ gift): drop the English angle.
- Examples of English sounds ("like the ee in see") become Arabic ones.

## Cues and meanings

- Pronoun cues in fill-in sentences:
  `(I)` → `(أنا)`, `(you, informal)` → `(أنتَ)`, `(you, plural)` → `(أنتم)`,
  `(you, formal)` → `(حضرتك، رسمي)`, `(he)` → `(هو)`, `(she)` → `(هي)`,
  `(it)` → `(هو/هي، للمحايد)`, `(we)` → `(نحن)`, `(they)` → `(هم)`. `English: I` → `بالعربية: أنا`.
- Word meanings (`en` beside a German word, `english`, `translation`, `optionsTranslation`):
  the natural Arabic meaning. `friend (m)` → `صديق (مذكر)`. `Leute · people` → `Leute · ناس`.
  Verbs as the masdar or the present: `gehen` → `يذهب / الذهاب` (pick one style per file; the
  dictionary uses the present, «يذهب»).
- **Templates** (`englishTemplates`, values with `{subject}`, `{pl}`, `{a}`): the app fills
  `{subject}` and `{pl}` with a *bare* Arabic noun (no «ال», singular) and **drops `{a}`**.
  Write sentences that work with that: «هذا {a} {subject}.» → «هذا {subject}.»;
  «أرى اثنين: {pl}.»; «هنا كثير من {pl}.» is wrong (needs a plural) → «هنا {pl}، وكثير منه.» or
  similar. Never glue «ال» or a suffix to a placeholder.

## Per place, not per string

The overlay is exact per exercise and per path, so the same English can get different Arabic in
different places (du → «ما اسمك؟», Sie → «ما اسم حضرتك؟»). Inside one check
(`…check.q`, `…check.options[n]`, `…check.answer`), the answer must equal one option exactly.

## Never

- No exam brand names. No more "exam" or "test" talk than the English has.
- Do not add or drop information beyond what the Arabic reader needs. Do not translate German.
- Do not edit anything outside `tool/turkish/ar/` and `tool/turkish/ui/ar.json`.
- English kept on purpose inside a story (a character speaking English) stays English.

When unsure (a joke that does not travel, a rule that changes for Arabic speakers), choose the
clearest version and add file + key + your doubt to `docs/arabic_review.md`.
