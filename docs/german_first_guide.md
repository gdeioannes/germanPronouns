# German first: how to rewrite the explanations (B1.1 to C2.2)

The explanations of the app (`help`) and the book chapters become German, written
for a learner at that level. In the app the English stays behind a button; the
tool keeps it, so you never handle it. The books have no English explanations.

This is **rewriting for a learner, not translating**. Say the same thing, with the
same facts and the same humour, the way a good German teacher would say it to this
learner. Reorder and split freely. Short and clear beats complete.

## How difficult, by level

| Level | Sentences | Language |
|---|---|---|
| B1.1, B1.2 | Short, about 8 to 12 words. One idea per sentence. | Present and Perfekt. Simple *weil*, *dass*, *wenn* are fine. No Konjunktiv, Passiv or long noun phrases in the explanation, unless that is the lesson's topic. Everyday words. |
| B2.1, B2.2 | Clear, up to about 16 words. | Normal written German, plain and friendly. All grammar up to B1 may be used. |
| C1.1, C1.2 | Natural. | Educated German. Do not simplify artificially. |
| C2.1, C2.2 | Natural. | The register of a good German grammar or style guide, still warm and readable. |

Address the learner as *du*.

## Grammar words

Use these freely from B1 (taught in the A2.2 lesson *Grammatikwörter*):
Nomen, Verb, Adjektiv, Artikel, Pronomen, Präposition, Endung, Satz, Hauptsatz,
Nebensatz, Subjekt, Objekt, Nominativ, Akkusativ, Dativ, Genitiv, Singular, Plural,
maskulin, feminin, neutral, Infinitiv, Präsens, Perfekt, Präteritum, Partizip,
Komparativ, Superlativ, Relativsatz, trennbar, reflexiv.

A helper verb is always a *Hilfsverb* (haben, sein, werden), a modal verb a *Modalverb* (können, müssen …). Never invent a friendlier name for a real grammar term. A conjunction is a *Konjunktion*; explain it the first time as a *Verbindungswort*.

Any other term (Konjunktiv II, Passiv, Nominalisierung, Apposition …) has to be
explained the first time a quiz or chapter uses it, in a few plain words or with a
German example. Prefer question words to labels at B1: *wer? wen? wem? wessen?*

## Word meanings

| Level | A word's meaning |
|---|---|
| B1 | An English word in brackets is fine for a key new word: *das Gehalt (salary)*. Prefer a German example if it does the job. |
| B2 | English only for a word's meaning and false friends: *die Rente (pension), nicht „rent“*. |
| C1, C2 | German synonym or short German definition: *die Rente (das Geld im Alter)*. English only where a false friend is the whole point. |

False-friend warnings about English are welcome at every level; say them in German.

## What must not change

- **Every German example, form and word quoted in the prose stays exactly as it is.** Same endings, same spelling, same `*marking*`. Never "correct" or vary them. If one really is wrong, keep it and list it in your final report.
- **Facts stay facts.** Do not add dates, numbers or claims. Do not drop a warning.
- **The joke stays.** If the English is funny, the German must be funny too. Never turn characters or situations into a lesson.
- A check's hint never gives its answer: nothing like *ich → mich*.
- No exam names, no "Teil 3", no level names, no talk of exams, except inside the `exam` field, which keeps its own general wording.
- **App prose:** keep the meaning of the English cues. Do not add new tables or lists.
- **Book prose describes paper:** write, circle, cover, tick. Never tap, swipe, medal, or anything from the app.

## Style

- No long dashes (— or –). Use a colon, a comma or a new sentence.
- German quotation marks: „so“. Plain text otherwise; keep `*` marks balanced.
- Capital letters and commas as a careful German writer would use them. Your German must be correct: a learner will copy it.
- Same terms throughout: Regel, Tipp, Fehler, Beispiel, Übung.

## Book instructions: use exactly these

| English | German |
|---|---|
| Circle the right word. | Kreise das richtige Wort ein. |
| Circle what the text says. | Kreise ein, was im Text steht. |
| Circle what the poster/page says. | Kreise ein, was auf dem Plakat / auf der Seite steht. |
| Write the verb. | Schreib das Verb. |
| Each sentence has one mistake. Write it correctly. | Jeder Satz hat einen Fehler. Schreib ihn richtig. |
| Listen to the dictation and write the missing words. | Hör das Diktat und schreib die fehlenden Wörter. |
| Find the mistake (title) | Finde den Fehler |
| Heard it? (title) | Gehört? |
| Words for the practice page (title) | Wörter für die Übungen |
| About you. | Über dich. |

## What you do

You get a level and a kind (`app` or `book`).

1. Take each file in `tool/german-first/en/<level>/<kind>/`. Skip it if `tool/german-first/de/<level>/<kind>/` already has one with the same name.
2. Write the German to `tool/german-first/de/<level>/<kind>/<same name>.json`, a flat JSON object with the **same keys**:

   ```json
   { "intro": "…", "tips[0].title": "…", "tips[0].text": "…" }
   ```

   - **App:** every `hook`, `intro`, `recall`, `remember`, `title`, `text`, `trap`, `check.why`, `mistakes…why` and `exam` key must be there. For `visual`, `table` and `check.q/options/answer` keys, leave out what is already German. The list cannot catch every short English string, so open the quiz in `assets/content/authoring/de_cert_a1/<level>.json` if a `table`, a `visual` or a check looks half English; any path that exists in its `help` is accepted. A table column that only gives a word's meaning stays English; a column that explains a use or names a form becomes German. If you change a check's options, its answer must be spelled the same as one of them.
   - **Book:** leave out a key that is fine as it is. Keep these in English: a word's meaning (`"… to give up smoking"` in an `.en` key, or a table column that only gives meanings), and a practice item whose English sentence is the question. Book German must be **no longer than the English**, because the pages are full: shorten when it runs over.
     The list in `en/` cannot catch every short English string. So read the chapter's `grammar[]` and `practise[]` in `assets/content/book2/de_cert_a1/<level>.json` too, and also add any path it finds English in, using the same path syntax: options and their `answer`, `tag`, `head[..].text`, table cells, short `.en` notes that explain rather than give a meaning (`a wish` becomes `ein Wunsch`), and cues in `after` such as `(promise)` (`(Versprechen)`). The check accepts any path that exists in the chapter.
3. After every few files, run `node tool/german-first/apply.mjs <level> --check` and fix each `ERROR`. Look at each `look:` line and fix it if the text really is English. Never run it without `--check`.

Do not edit any other file. Do not spawn sub-agents. Work through the files one by one until none are left, and do not stop to ask.

Examples of the finished thing: quiz `quest_b1_1_adj_bestimmt` in `assets/content/authoring/de_cert_a1/b1_1.json`, chapter `garten` in `assets/content/book2/de_cert_a1/b1_1.json`.
