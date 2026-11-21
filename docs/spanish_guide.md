# Spanish mode: translator brief

The site teaches German. It explains German in English (and in Turkish, Arabic, Ukrainian and
French for A1–A2). Spanish mode explains the same German in Spanish, for levels A1.1–A2.2 (app
exercises and the printed books). The readers are Spanish speakers learning German: people from
Spain and from every Latin American country, often adults who live or work in Germany, Austria or
Switzerland (or plan to), some school and university students. You translate the English into
Spanish. **The German never changes.**

The pipeline is the Turkish one with `--lang es`; `docs/turkish_guide.md` has the same rules.
Everything below is what differs or matters most for Spanish.

## Files

- Source: `tool/turkish/en/<level>/{app,book}/<id>.json`, a flat object `{ "path": "English" }`.
- You write: `tool/turkish/es/<level>/{app,book}/<id>.json` with **the same name and the same
  keys**, values in Spanish. One output file per input file. Valid JSON, UTF-8.
- Check: `node tool/turkish/build.mjs <level> --lang es --check` (errors must be zero).
- What is left: `node tool/turkish/extract.mjs <level> --lang es`.
- Interface strings: `tool/turkish/ui/en.json` (`{ English: file }`) → write
  `tool/turkish/ui/es.json` (`{ English: Spanish }`).
- Tap-a-word meanings: `tool/turkish/en/dictionary/part-NN.json` → `tool/turkish/es/dictionary/part-NN.json`.
- The French files (`tool/turkish/fr/…`) are a good model for structure: same keys, same
  template tricks. Translate from the **English**, not from the French.

## Language and tone

- **Neutral international Spanish**, plain and short, that reads naturally in Madrid, Mexico City,
  Bogotá and Buenos Aires alike. A1 learners read these explanations: short sentences, everyday
  words.
  - Plural "you" towards the learners is **ustedes**. No vosotros, no voseo (vos) in the
    explanations.
  - Avoid words that differ by region when a common one exists: « teléfono » rather than
    móvil/celular, « auto o coche » only if a car must be named (or rephrase), « apartamento o piso »
    likewise, « computadora/ordenador » → « el portátil » / « la pantalla » or rephrase. Never
    « coger ». « Jugo/zumo »: write « jugo (zumo) » the first time in a file if needed.
  - Where a German comparison needs a regional fact, say both briefly.
- **Address the learner as « tú »**, warm and direct: « Escribe », « Elige », « Escucha ». Never
  « usted » towards the learner. Characters in stories and dialogues keep whatever register the
  German has (Sie between strangers → usted; du between friends → tú; ihr → ustedes).
- **Buttons and menu items are infinitives or nouns**, as Spanish interfaces write them:
  « Empezar », « Comprobar », « Saltar », « Siguiente », « Ajustes », « Reintentar ».
- **Keep the learner's gender open.** Avoid « listo/a », « bienvenido », « cansado », « seguro »
  towards the learner: rephrase with a verb or a noun (« ¡Vamos! », « Te damos la bienvenida »,
  « ¡Bien hecho, es correcto! », « Ya sabes… », « Superado: 8 de 10 »). No « @ », « -x », « -e »
  endings, no « listo/a ». Characters (Maya, Tom) keep their own gender, of course.
- **Spanish punctuation**: opening ¿ and ¡ always (« ¿Cómo te llamas? »). Spanish quotations in
  « » with no inner spaces. German quoted inside keeps „…" or "…" as in the English, and German
  sentences never get ¿ or ¡.
- **No long dashes (— or –) in prose**: use a colon, a comma, a full stop or brackets. (A range
  like `0–10` stays.)
- Numbers: decimal comma as in German (2,20 €), times as in the German (14:30). Many Latin
  American countries write a decimal point: where the English explains the German comma, say so.

## What to keep exactly

- **Every German word, phrase and sentence**, letter for letter, including in mixed lines.
  `bin only ever goes with ich` → `bin solo va con ich`. If a whole value is German, copy it.
- Placeholders and blanks: `{subject}`, `{a}`, `{pl}`, `{n}`, `{{0}}`, `____` (same count, same
  spelling, except in templates, see below). `*stars*` (emphasis) balanced, around the matching words.
- Names (Maya, Tom, Frau Huber), numbers, times, prices (2,20 €), arrows `→`, the separator ` · `.
- Line breaks and list structure.

## Grammar words (first time in a file: Spanish + German term; later the German alone is fine)

| German term | Spanish |
|---|---|
| Artikel | artículo (Artikel) |
| Nomen | sustantivo (Nomen) |
| Verb | verbo (Verb) |
| Adjektiv | adjetivo (Adjektiv) |
| Präposition | preposición (Präposition) |
| Pronomen | pronombre (Pronomen) |
| Plural / Singular | plural / singular |
| maskulin / feminin / neutral | masculino / femenino / neutro |
| Nominativ | nominativo (Nominativ), el caso del sujeto |
| Akkusativ | acusativo (Akkusativ), el caso del objeto directo |
| Dativ | dativo (Dativ), el caso del objeto indirecto |
| Genitiv | genitivo (Genitiv) |
| Perfekt / Präteritum | Perfekt (≈ pretérito perfecto: he comido) / Präteritum (el pasado escrito) |
| trennbares Verb | verbo separable (trennbares Verb) |
| Modalverb | verbo modal (Modalverb) |
| Nebensatz | oración subordinada (Nebensatz) |
| konjugieren | conjugar |

## Rewrite, do not just translate, where the English leans on English

Many explanations compare German with English. A Spanish speaker needs the comparison with
**Spanish** instead, or none. Spanish is often a *better* bridge to German than English is
(genders, conjugation, usted): use it.

- **Gender.** Spanish has two genders, German three: masculino, femenino and **neutro**. And the
  gender of a word rarely matches: der Tisch / la mesa, die Sonne / el sol, der Mond / la luna,
  das Mädchen / la chica, das Haus / la casa. Say plainly: never guess from Spanish, learn each
  noun with its article.
- **The article.** Like Spanish, German has definite and indefinite articles: der/die/das ≈
  el/la, die (plural) ≈ los/las, ein/eine ≈ un/una. Differences: the German article changes with
  the case (der → den → dem), which Spanish articles never do; German has no plural of ein
  (unos/unas = no article: Ich habe Bücher). The negative is kein/keine (« no… ningún »:
  Ich habe kein Auto = no tengo auto).
- **Cases.** Spanish nouns have no cases, but Spanish **pronouns** do: él / lo / le, ellos / los /
  les. That is the key: Nominativ ≈ the subject (él), Akkusativ ≈ the direct object (lo, la),
  Dativ ≈ the indirect object (le, « a alguien »). In German the article (and the pronoun) shows
  it: Der Mann sieht den Hund. Ich gebe dem Kind… German has no « a personal »: Ich sehe den Mann
  (veo **a**l hombre). German prepositions decide their case: learn each one with it (mit + Dativ).
- **The subject is never dropped.** Spanish leaves the subject out (« hablo alemán »); German
  always needs it: **Ich** spreche Deutsch. Even weather and impersonal sentences need **es**:
  « llueve » = **Es** regnet, « hay » = **es gibt**. Say so wherever it matters.
- **Word order.** Spanish word order is free; German puts the conjugated verb **second** (and the
  subject moves behind it when something else comes first: Heute **gehe ich**…), and infinitives,
  participles and the verb of a *dass/weil* clause go **to the end**. Questions with no question
  word start with the verb (Kommst du?), not just a rising voice as in Spanish.
- **du / ihr / Sie** = « tú / ustedes entre amigos (en España: vosotros) / usted, ustedes ». Same
  idea as Spanish: Sie for strangers, officials and at work. And like usted, **Sie is conjugated
  like the third person plural** (sie/Sie kommen ≈ ellos/ustedes vienen). Sie is written with a
  capital S. Where Spanish speakers in Latin America say ustedes to friends, German still says ihr.
- **ser / estar.** German has one verb, sein, for both: Ich bin müde (estoy cansado) and Ich bin
  Lehrer (soy profesor). Also no article with jobs, as in Spanish: Ich bin Lehrer.
- **Past tenses.** The German Perfekt is built like the pretérito perfecto (he comido), but with
  haben **or sein**: sein goes with movement and change verbs (Ich bin gekommen). And it is the
  everyday spoken past, also where Spanish uses the indefinido: « ayer comí pizza » = Gestern
  **habe** ich Pizza **gegessen**. The Präteritum is the written past, used in speech only for war,
  hatte and the Modalverben.
- **Separable verbs.** A Spanish verb keeps its prefix (devolver); a German separable prefix goes
  to the end of the clause (ich komme an). Point it out.
- **Plurals.** German plurals must be learnt per noun, with the article die. The Spanish -s/-es
  rarely helps.
- **Capital letters.** Every German noun starts with a capital letter (der Tisch, die Liebe),
  also days, months and languages (Montag, Deutsch), which Spanish writes small.
- **Pronunciation in Spanish terms** where the English uses English sounds:
  Spanish vowels are a good base (German a, e, i, o, u are pure like Spanish ones), but German
  also has **long and short vowels**, and the difference changes words (Staat / Stadt).
  **h** at the start is breathed, like a soft Spanish jota (Haus: never mute as in Spanish
  « hola »); **j** = « y » (ja ≈ « ya »); **w** = a v with the upper teeth on the lower lip
  (Wasser), different from b, which Spanish does not distinguish; **v** = « f » (Vater ≈
  « fáter »); **z** = « ts » (zehn ≈ « tsén »); **s** before a vowel = a buzzing s, like a bee
  (sie ≈ « zi »); **sch** = the « sh » you use to ask for silence: « ¡shh! » (Schule); **st/sp**
  at the start = « sht/shp » (Straße, Sport), and **no « e » before**: Spanien, not « Espanien »;
  **ch** after a/o/u = **the Spanish jota** (Bach ≈ « baj »); **ch** after e/i = a soft hiss with
  the tongue flat, softer than the jota (ich); **ü** = say « i » with rounded lips (über);
  **ö** = say « e » with rounded lips (schön); **ei** = « ai » (zwei ≈ « tsvai »); **ie** = a long
  « i » (sieben); **eu/äu** = « oi » (neu ≈ « noi »); **au** = « au »; **-er** at the end ≈ a short
  « a » (Vater ≈ « fata »); the **r** is in the throat, not rolled (a rolled r is still understood);
  **b, d, g at the end sound p, t, k** (Tag ≈ « tak »). Stress is mostly on the first syllable.
- **Time trap.** halb acht = 7:30, half way *to* eight. A Spanish speaker hears « las ocho y
  media » (8:30) and comes an hour late: say so wherever the English explains halb.
- **Numbers.** einundzwanzig is « uno-y-veinte », the units first: point it out.
- English false friends (bekommen ≠ become, Gift ≠ gift): drop the English angle. Spanish ones are
  worth adding where real: der Mantel = abrigo (a mantel is die Tischdecke), die Rente = la
  jubilación (not la renta), also = o sea, así que (not « también »: that is auch), die Karte =
  tarjeta, mapa, entrada (not carta: that is der Brief), fast = casi, das Gift = veneno, eventuell =
  quizás, die Bank also banco (para sentarse), sensibel = sensible (same!).
- Examples of English sounds ("like the ee in see") become Spanish ones.

## Cues and meanings

- Pronoun cues in fill-in sentences:
  `(I)` → `(yo)`, `(you, informal)` → `(tú)`, `(you, plural)` → `(ustedes/vosotros)`,
  `(you, formal)` → `(usted)`, `(he)` → `(él)`, `(she)` → `(ella)`,
  `(it)` → `(neutro: ello)`, `(we)` → `(nosotros)`, `(they)` → `(ellos/ellas)`.
  `English: I` → `En español: yo`.
- Word meanings (`en` beside a German word, `english`, `translation`, `optionsTranslation`):
  the natural Spanish meaning. `friend (m)` → `amigo (m.)`. `Leute · people` → `Leute · la gente`.
  Nouns in the singular with no article unless the English has one; verbs in the infinitive:
  `gehen` → `ir`.

## Templates (`englishTemplates` and subjects of the same exercise)

The app fills a template with each subject's meaning. In Spanish (same system as French):

- A **noun subject** (`subjects[n].english` in an exercise whose templates use `{a}`, `{pl}` or
  a `{…/…}` pair) is written **with its indefinite article**, which tells the app its Spanish
  gender: `una mesa`, `un hombre`, `una lámpara nueva`. If its plural is not just the first word +
  -s/-es (or -z → -ces), add it after a bar: `una lámpara nueva|lámparas nuevas`.
- In the template:
  - `{a}` → un / una
  - `{subject}` → the noun **without** its article (`lámpara nueva`)
  - `{pl}` → the plural (`mesas`)
  - `{masculine/feminine}` → any pair picked by the noun's gender: `{el/la}`, `{El/La}`,
    `{este/esta}`, `{nuevo/nueva}`, `{lo/la}`. « a el » and « de el » become « al » and « del » by
    themselves. Avoid `{el/la}` before a feminine noun with stressed a (el agua): rephrase.
  - Examples: "That is {a} {subject}." → `Es {a} {subject}.`;
    "The {subject} is here." → `{El/La} {subject} está aquí.`;
    "That is my {subject}." → `Es mi {subject}.`; "I see two {pl}." → `Veo dos {pl}.`
- A **subject that is not a noun** (a pronoun « yo », a country, a number) has no article and is
  used as is. When the German subject is a person (ich, du, er…) and the English template
  conjugates a verb after it ("{subject} could not come"), Spanish would need a different verb form
  for each person: write the template so one form fits everyone, after a colon:
  `{subject}: ayer no fue posible venir.` For pronoun subjects use `yo`, `tú`, `él/ella`,
  `nosotros`, `ustedes/vosotros`, `ellos/ellas / usted`.

## Per place, not per string

The overlay is exact per exercise and per path, so the same English can get different Spanish in
different places (du → « ¿Cómo te llamas? », Sie → « ¿Cómo se llama usted? »). Inside one check
(`…check.q`, `…check.options[n]`, `…check.answer`), the answer must equal one option exactly.

## Never

- No exam brand names. No more "exam" or "test" talk than the English has.
- Do not add or drop information beyond what the Spanish reader needs. Do not translate German.
- Do not edit anything outside `tool/turkish/es/` and `tool/turkish/ui/es.json`
  (and `docs/spanish_review.md` for doubts).
- English kept on purpose inside a story (a character speaking English) stays English.

When unsure (a joke that does not travel, a rule that changes for Spanish speakers, a regional
word), choose the clearest version and add file + key + your doubt to `docs/spanish_review.md`.

## B1–C2: the English button in Spanish

From B1 the site explains German **in German**; a button under each explanation opens the
English. In Spanish mode that button opens Spanish instead. You translate only that layer (and the
word meanings), never the German explanations above it.

- Source: `tool/turkish/en/<level>/app/<quiz id>.json` for `b1_1 … c2_2` (only button-layer
  paths). You write `tool/turkish/es/<level>/app/<quiz id>.json`, same name, same keys.
- Model file (French, same structure): `tool/turkish/fr/b1_1/app/quest_b1_1_adj_komparativ.json`.
- What the fields are:
  - `help.introEn`, `help.hookEn`, `help.tips[i].en.title/.text/.trap`, `help.rememberEn[i]`,
    `help.examEn`, `help.recallEn.*`: the explanation itself. Same content as the German above it.
  - `…check.whyEn`, `sentences[i].whyEn`, `help.mistakes[i].whyEn`: why an answer is right or wrong.
  - `…examples[i].en`, `help.context.en`: the translation of a German example or text. Translate
    **from the German** (`node tool/turkish/de-context.mjs <quiz id>` prints it), naturally.
  - `help.vocab[i].en`, `cards[i].en`, `spots[i].en`, `visual.*.en`: a word's meaning, short, like a
    dictionary gloss (`caliente`, `barato, conveniente`). de-context.mjs shows the German word.
- B1–C2 readers are advanced: full, precise Spanish is fine, but keep it clear and short.
- Where the English compares German with English, compare with Spanish when that helps more
  (the subjuntivo vs Konjunktiv I/II, the indefinido vs Präteritum, « se » vs the German Passiv,
  por/para vs für/durch).
- Everything in "What to keep exactly" and the punctuation rules above applies.
- Check: `node tool/turkish/build.mjs <level> --lang es --check` (0 errors), then without `--check`.
