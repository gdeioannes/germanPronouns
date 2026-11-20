# French mode: translator brief

The site teaches German. It explains German in English (and in Turkish, Arabic and Ukrainian
for A1–A2). French mode explains the same German in French, for levels A1.1–A2.2 (app
exercises and the printed books). The readers are French speakers learning German: people
from France, Belgium, Switzerland, Luxembourg, francophone Africa, Canada, often adults who live
or work in Germany or Austria (or plan to), some school and university students. You translate
the English into French. **The German never changes.**

The pipeline is the Turkish one with `--lang fr`; `docs/turkish_guide.md` has the same rules.
Everything below is what differs or matters most for French.

## Files

- Source: `tool/turkish/en/<level>/{app,book}/<id>.json`, a flat object `{ "path": "English" }`.
- You write: `tool/turkish/fr/<level>/{app,book}/<id>.json` with **the same name and the same
  keys**, values in French. One output file per input file. Valid JSON, UTF-8.
- Check: `node tool/turkish/build.mjs <level> --lang fr --check` (errors must be zero).
- What is left: `node tool/turkish/extract.mjs <level> --lang fr`.
- Interface strings: `tool/turkish/ui/en.json` (`{ English: English }`) → write
  `tool/turkish/ui/fr.json` (`{ English: French }`).
- Tap-a-word meanings: `tool/turkish/en/dictionary/part-NN.json` → `tool/turkish/fr/dictionary/part-NN.json`.

## Language and tone

- **Standard French of France** (français standard), plain and short. A1 learners read these
  explanations: short sentences, everyday words. Numbers as in France: soixante-dix,
  quatre-vingts, quatre-vingt-dix. (Belgian/Swiss septante, nonante may appear once as a note in
  the numbers lessons, nowhere else.)
- **Address the learner as « vous »**, warm and direct: « Écrivez », « Choisissez »,
  « Écoutez ». Never « tu » towards the learner. Characters in stories and dialogues keep whatever
  register the German has (du between friends → the French translation uses tu).
- **Buttons and menu items are infinitives or nouns**, as French interfaces write them:
  « Commencer », « Vérifier », « Passer », « Suivant », « Paramètres », « Réessayer ».
- **Keep the learner's gender open.** Avoid « prêt(e) », « vous êtes fatigué » etc. towards the
  learner: rephrase with a verb or a noun (« C'est parti ! », « Bravo, c'est juste »,
  « Vous savez déjà… », « Réussi : 8 sur 10 »). No écriture inclusive with dots (« prêt·e »).
  Characters (Maya, Tom) keep their own gender, of course.
- **French typography**: a narrow no-break space (U+202F) before `; : ! ?` and inside « »
  around French quotations: « Bonjour ». German quoted inside keeps „…“ or "…" as in the English,
  and German text never gets those spaces. Apostrophe: the straight ' is fine (be consistent).
- **No long dashes (— or –) in prose**: use a colon, a comma, a full stop or brackets. (A range
  like `0–10` stays.)
- Numbers: decimal comma (2,20 €), times as in the German (14:30). French already writes both
  that way: say so where the English explains it.

## What to keep exactly

- **Every German word, phrase and sentence**, letter for letter, including in mixed lines.
  `bin only ever goes with ich` → `bin ne s'emploie qu'avec ich`. If a whole value is German, copy it.
- Placeholders and blanks: `{subject}`, `{a}`, `{pl}`, `{n}`, `{{0}}`, `____` (same count, same
  spelling, except in templates, see below). `*stars*` (emphasis) balanced, around the matching words.
- Names (Maya, Tom, Frau Huber), numbers, times, prices (2,20 €), arrows `→`, the separator ` · `.
- Line breaks and list structure.

## Grammar words (first time in a file: French + German term; later the German alone is fine)

| German term | French |
|---|---|
| Artikel | article (Artikel) |
| Nomen | nom (Nomen) |
| Verb | verbe (Verb) |
| Adjektiv | adjectif (Adjektiv) |
| Präposition | préposition (Präposition) |
| Pronomen | pronom (Pronomen) |
| Plural / Singular | pluriel / singulier |
| maskulin / feminin / neutral | masculin / féminin / neutre |
| Nominativ | nominatif (Nominativ), le cas du sujet |
| Akkusativ | accusatif (Akkusativ), le cas du COD |
| Dativ | datif (Dativ), le cas du COI |
| Genitiv | génitif (Genitiv) |
| Perfekt / Präteritum | Perfekt (≈ passé composé) / Präteritum (passé de l'écrit) |
| trennbares Verb | verbe à particule séparable (trennbares Verb) |
| Modalverb | verbe de modalité (Modalverb) |
| Nebensatz | subordonnée (Nebensatz) |
| konjugieren | conjuguer |

## Rewrite, do not just translate, where the English leans on English

Many explanations compare German with English. A French speaker needs the comparison with
**French** instead, or none. French is often a *better* bridge to German than English is: use it.

- **Gender.** French has two genders, German three: masculin, féminin and **neutre**. And the
  gender of a word rarely matches: der Tisch / la table, die Sonne / le soleil, der Mond / la
  lune, das Mädchen / la fille, das Auto / la voiture. Say plainly: never guess from French, learn
  each noun with its article.
- **The article.** Like French, German has definite and indefinite articles: der/die/das ≈
  le/la, die (plural) ≈ les, ein/eine ≈ un/une. Differences: German has **no partitive** (du, de la):
  « je bois de l'eau » = Ich trinke Wasser, no article. The negative is kein/keine (« pas de »).
  And the German article changes with the case (der → den → dem), which French articles never do.
- **Cases.** French nouns have no cases, but French **pronouns** do: il / le / lui, ils / les /
  leur. That is the key: Nominativ ≈ the subject (il), Akkusativ ≈ the direct object, COD (le),
  Dativ ≈ the indirect object, COI (lui, « à qqn »). In German the article (and the pronoun)
  shows it: Der Mann sieht den Hund. Ich gebe dem Kind… German prepositions decide their case:
  learn each one with it (mit + Dativ).
- **Word order.** French is subject–verb–object. German puts the conjugated verb **second**
  (and the subject moves behind it when something else comes first: Heute **gehe ich**…), and
  infinitives, participles and the verb of a *dass/weil* clause go **to the end**. Say so where
  it matters.
- **du / ihr / Sie** = « tu / vous (pluriel) / vous (poli) ». Same idea as French: Sie for
  strangers, officials and at work. Sie is written with a capital S and conjugated like « ils »
  (sie/Sie kommen).
- **Past tenses.** Good news: the German Perfekt works like the passé composé, with haben (avoir)
  or sein (être), and sein goes with movement and change verbs, much like être (Ich bin gekommen
  ≈ je suis venu). It is the spoken past. The Präteritum is the written past, used in speech only
  for war, hatte and the Modalverben (≈ imparfait for those).
- **Separable verbs.** A French verb keeps its prefix (revenir); a German separable prefix goes to
  the end of the clause (ich komme an). Point it out.
- **Plurals.** German plurals must be learnt per noun, with the article die. The French -s rarely helps.
- **Pronunciation in French terms** where the English uses English sounds:
  every German letter is pronounced, **final e too** (Name ≈ « naa-me », never mute); **h** is
  breathed (Haus: a real h, absent in French); **u** = « ou » (gut ≈ « gout »); **ü** = French « u »
  (über); **ö** = French « eu » (schön); **ei** = « aï » (zwei ≈ « tsvaï »); **ie** = a long « i »
  (sieben); **eu/äu** = « oï » (neu ≈ « noï »); **au** = « aou »; **w** = « v » (Wasser);
  **v** = « f » (Vater ≈ « fater »); **z** = « ts » (zehn ≈ « tsén »); **s** before a vowel = « z »
  (sie ≈ « zi »); **sch** = « ch » (Schule); **st/sp** at the start = « cht/chp » (Straße, Sport);
  **ch** after a/o/u = a scraped sound in the throat, like the Spanish jota (Bach); **ch** after
  e/i = a soft hiss close to the start of « chut » with the tongue flat (ich); **j** = « y »
  (ja ≈ « ya »); **-er** at the end ≈ a short « a » (Vater ≈ « fata »). Stress is mostly on the
  first syllable, not the last as in French.
- **Time trap.** halb acht = 7:30, half way *to* eight. A French speaker hears « huit heures et
  demie » (8:30) and comes an hour late: say so wherever the English explains halb.
- **Numbers.** einundzwanzig is « un-et-vingt », the units first: point it out.
- English false friends (bekommen ≠ become, Gift ≠ gift): drop the English angle. French ones
  are worth adding where real: also = donc (not « aussi »: that is auch), die Bank also bench,
  der Chef = the boss (not a chef), fast = presque.
- Examples of English sounds ("like the ee in see") become French ones.

## Cues and meanings

- Pronoun cues in fill-in sentences:
  `(I)` → `(je)`, `(you, informal)` → `(tu)`, `(you, plural)` → `(vous, pluriel)`,
  `(you, formal)` → `(vous, poli)`, `(he)` → `(il)`, `(she)` → `(elle)`,
  `(it)` → `(il/elle, neutre)`, `(we)` → `(nous)`, `(they)` → `(ils/elles)`.
  `English: I` → `En français : je`.
- Word meanings (`en` beside a German word, `english`, `translation`, `optionsTranslation`):
  the natural French meaning. `friend (m)` → `ami (m.)`. `Leute · people` → `Leute · les gens`.
  Nouns in the singular with no article unless the English has one; verbs in the infinitive:
  `gehen` → `aller`.

## Templates (`englishTemplates` and subjects of the same exercise)

The app fills a template with each subject's meaning. In French:

- A **noun subject** (`subjects[n].english` in an exercise whose templates use `{a}`, `{pl}` or
  a `{…/…}` pair) is written **with its indefinite article**, which tells the app its French
  gender: `une table`, `un homme`, `une nouvelle lampe`. If its plural is not just the noun + -s
  (or -x, -aux), add it after a bar: `un œil|yeux`, `une nouvelle table|nouvelles tables`.
- In the template:
  - `{a}` → un / une
  - `{subject}` → the noun **without** its article (`nouvelle lampe`)
  - `{pl}` → the plural (`tables`)
  - `{masculine/feminine}` → any pair picked by the noun's gender: `{le/la}`, `{Le/La}`,
    `{mon/ma}`, `{ce/cette}`, `{du/de la}`, `{nouveau/nouvelle}`. le/la become l' and ma/ta/sa
    become mon/ton/son before a vowel by themselves.
  - Examples: "That is {a} {subject}." → `C'est {a} {subject}.`;
    "The {subject} is here." → `{Le/La} {subject} est ici.`;
    "That is my {subject}." → `C'est {mon/ma} {subject}.`; "I see two {pl}." → `Je vois deux {pl}.`
- A **subject that is not a noun** (a pronoun « je », a country, a number) has no article and
  is used as is. When the German subject is a person (ich, du, er…) and the English template
  conjugates a verb after it ("{subject} could not come"), French would need a different verb form
  for each person: write the template so one form fits everyone, after a colon:
  `{subject} : impossible de venir hier.` For pronoun subjects use `je`, `tu`, `il/elle/on`,
  `nous`, `vous`, `ils/elles / vous (poli)`.

## Per place, not per string

The overlay is exact per exercise and per path, so the same English can get different French in
different places (du → « Comment tu t'appelles ? », Sie → « Comment vous appelez-vous ? »). Inside
one check (`…check.q`, `…check.options[n]`, `…check.answer`), the answer must equal one option exactly.

## Never

- No exam brand names. No more "exam" or "test" talk than the English has.
- Do not add or drop information beyond what the French reader needs. Do not translate German.
- Do not edit anything outside `tool/turkish/fr/` and `tool/turkish/ui/fr.json`.
- English kept on purpose inside a story (a character speaking English) stays English.

When unsure (a joke that does not travel, a rule that changes for French speakers), choose the
clearest version and add file + key + your doubt to `docs/french_review.md`.

## B1–C2: the English button in French

From B1 the site explains German **in German**; a button under each explanation opens the
English. In French mode that button opens French instead. You translate only that layer (and the
word meanings), never the German explanations above it.

- Source: `tool/turkish/en/<level>/app/<quiz id>.json` for `b1_1 … c2_2` (only button-layer
  paths). You write `tool/turkish/fr/<level>/app/<quiz id>.json`, same name, same keys.
- Model file: `tool/turkish/fr/b1_1/app/quest_b1_1_adj_komparativ.json`.
- What the fields are:
  - `help.introEn`, `help.hookEn`, `help.tips[i].en.title/.text/.trap`, `help.rememberEn[i]`,
    `help.examEn`, `help.recallEn.*`: the explanation itself. Same content as the German above it.
  - `…check.whyEn`, `sentences[i].whyEn`, `help.mistakes[i].whyEn`: why an answer is right or wrong.
  - `…examples[i].en`, `help.context.en`: the translation of a German example or text. Translate
    **from the German** (`node tool/turkish/de-context.mjs <quiz id>` prints it), naturally.
  - `help.vocab[i].en`, `cards[i].en`, `spots[i].en`, `visual.*.en`: a word's meaning, short, like a
    dictionary gloss (`chaud`, `bon marché, avantageux`). de-context.mjs shows the German word.
- B1–C2 readers are advanced: full, precise French is fine, but keep it clear and short.
- Where the English compares German with English, compare with French when that helps more
  (« plus grand » vs größer, the subjonctif vs Konjunktiv I/II, the passé simple vs Präteritum).
- Everything in "What to keep exactly" and the typography rules above applies.
- Check: `node tool/turkish/build.mjs <level> --lang fr --check` (0 errors), then without `--check`.
