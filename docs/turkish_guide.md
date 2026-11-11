# Turkish mode: translator brief

The site teaches German. Today it explains German in English. Turkish mode explains
the same German in Turkish, for levels A1.1–A2.2 (app exercises and the printed books).
You translate the English into Turkish. **The German never changes.**

## Files

- Source: `tool/turkish/en/<level>/{app,book}/<id>.json`, a flat object `{ "path": "English" }`.
- You write: `tool/turkish/tr/<level>/{app,book}/<id>.json` with **the same name and the same keys**,
  values in Turkish. One output file per input file. Valid JSON, UTF-8, real Turkish letters
  (ç ğ ı İ ö ş ü), never ASCII stand-ins.
- Check your work: `node tool/turkish/build.mjs <level> --check` (errors must be zero; read the flags).
- Work is resumable: `node tool/turkish/extract.mjs <level>` lists the files that have no Turkish yet.

## What to keep exactly

- **Every German word, phrase and sentence**, letter for letter, including in mixed lines.
  `bin only ever goes with ich` → `bin yalnızca ich ile kullanılır`. If a whole value is German
  (the extractor sometimes picks one up), copy it unchanged.
- Placeholders and blanks: `{subject}`, `{a}`, `{pl}`, `{{0}}`, `____` (same count, same spelling).
- `*stars*` (emphasis markers): keep them balanced, around the matching words.
- Names (Maya, Tom, Frau Huber), numbers, times, prices, arrows `→`, the separator ` · `.
- Line breaks and list structure.

## How to write

- Address the learner as **sen**, warm and plain, like a good teacher. Short sentences.
  A1 learners read these explanations, so keep the Turkish everyday, not academic.
- **No long dashes (— or –) in prose.** Use a comma, a colon or a full stop. (A range like
  `0–10` stays.)
- Grammar terms: use the common Turkish school term and keep the German term beside it the first
  time in a file: *Akkusativ (-i hâli)*, *Dativ (-e hâli)*, *Artikel (tanımlık)*, *Nominativ (yalın hâl)*,
  *Plural (çoğul)*, *Verb (fiil)*, *Nomen (isim)*, *Adjektiv (sıfat)*, *Präposition (edat)*.
  Later in the same file the German term alone is fine.
- The **same English string must get the same Turkish** within a file (answers and their options
  are matched by text). In a check (`…check.q`, `…check.options[n]`, `…check.answer`), the answer
  must still be exactly one of the options.
- Word meanings (`en` beside a German word, `english`, `translation`, `optionsTranslation`):
  give the natural Turkish meaning. `friend (m)` → `arkadaş (erkek)`. `Leute · people` → `Leute · insanlar`.
- Hints and pronoun cues in fill-in sentences:
  `(I)` → `(ben)`, `(you, informal)` → `(sen)`, `(you, plural)` → `(siz, çoğul)`,
  `(you, formal)` → `(siz, resmî)`, `(he)` → `(o, erkek)`, `(she)` → `(o, kadın)`,
  `(it)` → `(o, nesne)`, `(we)` → `(biz)`, `(they)` → `(onlar)`.
  `English: I` → `Türkçe: ben`.

## Rewrite, do not just translate, where the English leans on English

Many explanations compare German with English. A Turkish speaker needs the comparison with
**Turkish** instead. Rewrite those lines so they are true and useful for a Turkish speaker.
Never keep a claim like "just like English" unless it really helps a Turkish reader.

- **Pronunciation through Turkish spelling** (much easier than English):
  ü and ö sound as in Turkish; ä ≈ e; ei = *ay* (zwei ≈ *tsvay*); ie = long *i* (sieben ≈ *ziiben*);
  eu/äu = *oy* (neu ≈ *noy*); z = *ts* (zehn ≈ *tseen*); s before a vowel = *z* (sie ≈ *zi*);
  sch = *ş*; sp/st at the start = *şp/şt*; w = *v*; v = *f*; j = *y*; ch after a/o/u = a rough *h*
  from the throat (Bach); ch after e/i = a soft *h* like the start of Turkish *hiç*, said with a smile;
  final -er ≈ a short *a* (Vater ≈ *fata*); h after a vowel lengthens it (gehen ≈ *geeen*).
- **Articles and gender**: Turkish has neither. Say so plainly: every German noun brings its
  article (der/die/das), and it has to be learnt with the noun. Turkish *bir* ≈ ein/eine.
- **Cases** map well onto Turkish suffixes. Use that:
  Akkusativ ≈ the definite object *-i* (den Mann sehen ≈ adamı görmek);
  Dativ ≈ the *-e* of the receiver (dem Kind geben ≈ çocuğa vermek);
  wo? + Dativ ≈ *-de* (in der Stadt ≈ şehirde); wohin? + Akkusativ ≈ *-e* (in die Stadt ≈ şehre);
  aus/von ≈ *-den*. Mention it only where it really helps.
- **Word order**: German puts the conjugated verb second; Turkish puts the verb last. But German
  sends infinitives, participles and the verb in a *dass/weil* clause to the end, which feels
  Turkish. Say so where it helps.
- **du / Sie** ≈ *sen / siz*. Turkish has the same polite split, so this is easy: lean on it.
- Pronoun *o* in Turkish covers er, sie and es: German must choose by the noun's gender.
- Separable verbs, modal verbs, Perfekt with haben/sein: explain on their own terms.
- English false friends (bekommen ≠ become, also ≠ also, Gift ≠ gift): drop the English angle,
  or replace it with a Turkish one only if you are sure it is a real trap.
- Examples of English sounds ("like the *ee* in see") must become Turkish ones.

## Never

- No exam brand names. No "exam", "test" talk beyond what the English already says.
- Do not add or drop information beyond what the Turkish reader needs. Do not translate German.
- Do not edit anything outside `tool/turkish/tr/`.

When unsure about a line (a joke that does not travel, a rule that changes for Turkish), choose
the clearest version and add the file name + key + your doubt to `docs/turkish_review.md`.

## Conventions settled in A1.1 (follow them)

- **Per place, not per string:** the overlay is exact per exercise and per path, so the same
  English can get different Turkish in different places (du → "Adın ne?", Sie → "Adınız ne?",
  "old" → "yaşlı" or "eski"). Inside one check, the answer must still equal one option exactly.
- **Templates** (`englishTemplates`, values with `{subject}`, `{pl}`, `{a}`): the app fills
  `{subject}`/`{pl}` with a *bare* Turkish noun and `{a}` with "bir". Build sentences that work
  with a bare noun (no case suffix glued to `{subject}`): "Geldiğim ülke: {subject}.",
  "İki {pl} görüyorum.", "Bu {a} {subject}."
- **Respelling in Turkish letters:** zwei 'tsvay', drei 'dray', vier 'fiir', sieben 'zii-ben',
  zehn 'tseen', ich 'ih', zwanzig 'TSVAN-tsih'. Letter names: be, tse, fau, ve, yot, tset.
- **Numbers:** German and Turkish share the thousands dot and decimal comma (1.200 / 2,20 €);
  never present that as a German oddity. 21–99 are said units-first (bir-ve-yirmi).
- **Compounds:** head-last like Turkish (çocuk odası); linking -s-/-n- ≈ the -sı in
  "doğum günü pastası".
- **Present tense:** one German Präsens covers both "-yor" and "-ir".
- "euro" (not "avro"); "babaanne/anneanne" when the family side is known.
- English kept on purpose inside a story (a character speaking English) stays English.
- German-only values (options, answers, German captions): copy unchanged.
- Interface strings (`tool/turkish/ui/`): short, plain, "sen"; buttons as verbs ("Başla",
  "Kontrol et", "Atla"); keep `{placeholders}`; keys that are German stay German.
- Tap-a-word glosses (`tool/turkish/en/dictionary/`): the Turkish meaning in a few words, same
  hints the English has ("(+ Dativ)", "(dişil / çoğul)"); for verbs the infinitive ("gitmek").
