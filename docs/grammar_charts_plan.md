# German Grammar Charts: plan of action

This is the brief for anyone (person or agent) who drafts or reworks a chart. Read all of it before
touching a chart. The owner reviews every chart one by one after it has been drafted; a draft is
allowed to need design work, but it is not allowed to be thin, generic or wrong.

## 1. The book

- A4 landscape wall charts. One hard topic per chart. English explanations, German examples.
- Meant to be cut out and hung on a wall, so each chart must work alone and be readable from a step away.
- Target: **one book of 35 charts** (37 pages with cover and intro). Was 32; on 2026-11-22 five essentials were added and scales + compound nouns taken out. Originally: the 23 that exist plus 9 new
  ones. It is a curated set of what is hard to remember, not a full grammar. A longer list was
  drafted (53 charts) and cut by the owner as too much; the cut topics are kept under "Later" in
  section 7 and are **not** to be built now. Each chart prints its level (assumption, owner can change).
- The order in `tool/charts/charts.json` is the order in the book. A chart's number is its place in
  that list (the builder rewrites every printed "Chart N"), so never hard-code a number you expect to stay.
- Not on the site yet. Do not commit, push or publish anything unless the owner says so.

## 2. Reference charts

Before drafting, open these and look at the rendered pages (`static/img/charts/NN.webp` after
`npm run charts`, or render with the helper in section 8):

- `tool/charts/src/15-gender.html` (built by `tool/charts/build/build-15.mjs`): the benchmark for
  density, first read and grouping. It took about twenty review rounds; copy its lessons, not its shape.
- `01-cases`, `02-wo-wohin`, `03-verb-position`, `05-adjective-endings`, `06-tenses`,
  `07-verb-preposition`, `10-time-prepositions`, `13-relative-clauses`, `14-modal-verbs`: approved.
- `16`–`23` (plural, n-nouns, articles, kein/nicht, possessives, pronouns, question words,
  comparison) were built as one batch and **rejected** as "very empty, very generic, out of touch".
  They are examples of what not to hand in.

## 3. What every chart has

1. **Header:** logo, "Chart N", the title (the learner's question, e.g. "der, die or das?"), three
   numbered steps for using the chart, the QR box.
2. **First read** (left box, has a title): "Look here first: <the point in six words>", then one or
   two full sentences that explain **how to read the diagram below**, then one to three worked
   examples that use the same visual code as the diagram. A learner who reads only this box must
   understand what the page is for and how its colours and positions work.
3. **The one idea** (navy box): one sentence to remember, plus one memorable example.
4. **The diagram:** the main body, the reason the chart exists.
5. **Rule rows:** two rows of details and traps ("watch out").
6. **Key line:** what the colours, stripes and numbers mean.

## 4. Rules

### Amount of content (the most common failure is too little)

- At least **40 German examples** (words or short sentences) on a chart; 50–60 is normal. Chart 15
  has about 50 words, 6 rule cells and 3 worked examples.
- The page is full to its edges. No empty area larger than about a tenth of the page. If there is
  room left, add real examples, exceptions or a second view of the rule, never decoration or bigger type.
- Cover the whole topic at the chart's levels, including the exceptions a learner will meet. If a
  textbook table has eight rows, the chart does not show four.
- Body text never below 0.9cqw; example words in the diagram 1.7cqw or larger.

### Shape

- The shape comes from the content. Ask what the learner does with the rule: look something up
  (table, columns, map), decide (decision path, only if the questions really branch), see a
  sequence (time line, steps), compare (before/after, pairs), or see a scale.
- Never pick a diagram type for novelty, and never a decision path for something that is a lookup.
- Group examples under the rule they share and name the rule once (one bracket, one label, one
  percentage). Never repeat the same tag on every line.
- Order by certainty or frequency when the rule has them (always, nearly always, usually), and show
  the difference visually (solid, paler, palest).

### Design

- House style of the reference charts: Source Serif 4 for titles and big German words, Inter for the
  rest; navy `#1f3a5f`, terracotta ink `#a24c26`, highlight `#ffe14d`.
- Colours mean the same on every chart: der `#0f4a96`, die `#a81f1b`, das `#1c6a3c`; Nominativ
  outlined, Akkusativ yellow, Dativ purple `#5b3aa8`, Genitiv teal `#0b6e74`; the verb that changes
  with the person is terracotta.
- No cartoon styling: no tilted boxes, drop shadows, stickers, speech bubbles or jokes.
- Pictures only where the picture carries the meaning (a place, an action). The app's library is
  `static/img/<id>.webp` (about 1,070 drawings, listed in `assets/images/manifest.json`). Do not
  generate new images; ask the owner if a chart seems to need one.
- All sizes in `cqw`; the sheet is `container-type: inline-size; aspect-ratio: 297/210`.

### Content

- German must be correct and natural. Vocabulary no harder than the chart's level; prefer words the
  course already teaches (`assets/content/shared/dictionary/de.json` has 3,470 nouns with gender,
  the course content under `assets/content/` is sorted by level).
- Explanations in plain English, short sentences, no grammar jargon the learner has not met
  ("the verb that changes with the person", not "the finite verb").
- Every figure needs a source: a published one (name it in the build script) or a count from our own
  word list. No invented percentages. If there is no figure, show none.
- No exam brand names anywhere.
- Cross-references say "see Chart N" using the number the target has in its **file name**; the
  builder maps it to the book number.

## 5. How one chart gets made

1. **Check the level.** Find where the course first teaches the topic and where it finishes; put
   that on the chart and in `charts.json`. The levels in section 7 are estimates.
2. **Write the spec out in full** before any HTML: the first-read text, the one idea, the complete
   list of German examples, the traps. Count the examples against the 40 minimum.
3. **Build** the chart as `tool/charts/src/NN-slug.html`, with a build script in
   `tool/charts/build/` when the body is generated from data.
4. **Render and look** (section 8). Fix overflow and gaps.
5. **Review rounds** (section 6): at least two full rounds, fixing between rounds.
6. **Report** to the owner: what the chart shows, what you were unsure about, what you left out.
   Then stop; the owner reviews before the next chart is called finished.

One agent works at a time. Never several charts in parallel.

## 6. Review rounds: look at the finished page as five different people

After the chart renders cleanly, open the screenshot and answer every question honestly, in
writing, as each of these readers. Any "no" is a defect: fix it, render again, and run the round
again. Stop after a round with no defects, or after three rounds (then list what remains).

**The learner at this level, seeing the chart for the first time**
- In ten seconds, can I say what this page helps me do?
- After the first-read box, do I know how to read the diagram without guessing?
- Is there a word in the English I would not understand? A German word above my level?
- Can I find the answer for a word or sentence of my own in under fifteen seconds?
- Do I know what to do when my case is not on the chart?

**The learner three weeks later, glancing at the wall**
- Is there one thing my eye lands on first, and is it the most useful thing?
- Can I read the main diagram from a step away?
- Would I learn something new on the tenth look, or is it used up after the first?

**The German teacher**
- Is every German word, article, ending and example sentence correct?
- Is any rule stated more strongly than it holds? Are the common exceptions on the page?
- Is anything important for this level missing? Anything on the page that belongs to a later level?
- Would I be happy to hang this in my classroom, or would I have to correct it out loud?

**The designer**
- Is the page full, with no dead area and nothing cramped or cut off?
- Does it look like it belongs to the same book as the reference charts?
- Is the same thing shown the same way everywhere on the page (one colour, one meaning)?
- Is anything repeated that could be said once? Anything decorative that carries no information?

**The sceptic (last)**
- Why is this shape better than a plain table? If a table would be clearer, it should be a table.
- What would the owner call "empty", "generic" or "weird" here?

## 7. The charts

Status: **ok** approved · **drafted** built by the 2026-11-22 run, waiting for the owner's review (build scripts in tool/charts/build/build-NN.mjs) · **rework** / **new** not done.
Levels are estimates until step 1 of section 5 has been done for the chart.
The table is in book order (learning order). 2026-11-22: five charts added (imperative, nach/in/zu, reflexive, da-/wo-, werden); scales (12) and compound nouns (09) taken out of the book, files kept.

| # | Chart | Level | Status | Shape |
|---|---|---|---|---|
| 1 | der, die or das? (endings) | A1.1 → B1.1 | ok (15-gender) | columns with certainty bands |
| 2 | der, die or das? (meaning families) | A1.1 → A2.2 | drafted 2026-11-22 | families grouped under each article |
| 3 | One Tisch, two …? (plural) | A1.1 → A2.1 | drafted 2026-11-22 (16) | five routes from singular to plural |
| 4 | der, ein or nothing? | A1.1 → A2.1 | drafted 2026-11-22 (18) | situations side by side |
| 5 | Present tense, with vowel-change verbs | A1.1 → A1.2 | drafted 2026-11-22 | persons with endings + vowel families |
| 6 | Where does the verb go? | A1.1 → A2.2 | ok (03) | decision path |
| 7 | Komm! Kommt! Kommen Sie! (imperative) | A1.2 → A2.1 | drafted 2026-11-22 (33) | table: verbs × du / ihr / Sie + tone |
| 8 | wer, wen, wem? (question words) | A1.1 → A2.2 | drafted 2026-11-22 (22) | question → answer pairs |
| 9 | kein or nicht? | A1.1 → A2.1 | drafted 2026-11-22 (19) | decision path + position line |
| 10 | mein, dein, sein, ihr | A1.1 → A2.1 | drafted 2026-11-22 (20) | owner × thing grid |
| 11 | Must, may, can or want? | A1.2 → A2.1 | ok (14) | pictures |
| 12 | The four cases | A1.2 → B1.1 | ok (01) | table |
| 13 | ich, mich or mir? | A1.2 → A2.1 | drafted 2026-11-22 (21) | table by case with sentence frames |
| 14 | um, am or im? | A1.1 → A2.1 | ok (10) | rings |
| 15 | One verb, many prefixes | A1.2 → B1.1 | ok (11) | hub |
| 16 | When does it happen? (tenses) | A1.2 → B1.2 | ok (06) | time line |
| 17 | Perfekt: haben or sein? ge-…-t or ge-…-en? | A1.2 → A2.1 | drafted 2026-11-22 | two questions, then participle patterns |
| 18 | Wo? or Wohin? | A2.1 → A2.2 | ok (02) | pictures |
| 19 | Prepositions with a fixed case | A2.1 → A2.2 | drafted 2026-11-22 | groups in case colours |
| 20 | nach, in or zu? | A1.2 → A2.2 | drafted 2026-11-22 (34) | five columns, Wohin / Wo / Woher |
| 21 | Verbs with Dativ, and two objects | A2.1 → A2.2 | drafted 2026-11-22 | verb list + object-order line |
| 22 | ich freue mich (reflexive verbs) | A2.1 → A2.2 | drafted 2026-11-22 (35) | pronoun table + verbs + mich-or-mir pairs |
| 23 | und, deshalb, weil: three word orders | A2.1 → B1.1 | drafted 2026-11-22 | three sentence frames with connector lists |
| 24 | singen, sang, gesungen (irregular verbs) | A2.1 → B1.1 | drafted 2026-11-22 | vowel families |
| 25 | gut, besser, am besten | A2.1 → A2.2 | drafted 2026-11-22 (23) | steps with the irregular ones set apart |
| 26 | Nouns that add -n | A2.2 → B1.1 | drafted 2026-11-22 (17) | who belongs + where the -n appears |
| 27 | Which adjective ending? | A2.1 → B1.1 | ok (05) | decision path |
| 28 | Verb + preposition | A2.2 → B2.1 | ok (07) | map |
| 29 | darauf, worauf, auf ihn (da- and wo- words) | B1.1 → B1.2 | drafted 2026-11-22 (36) | build table + thing-or-person pairs |
| 30 | Which man? The man who … | A2.2 → B1.2 | ok (13) | pictures |
| 31 | werden: three jobs | A2.2 → B1.2 | drafted 2026-11-22 (37) | three columns, told apart by the end |
| 32 | würde, hätte, wäre (Konjunktiv II) | B1.1 → B1.2 | drafted 2026-11-22 | four uses with forms |
| 33 | zu, um … zu, ohne … zu | B1.1 | drafted 2026-11-22 | sentence frames |
| 34 | When the verbs pile up | B1.1 → B2.2 | ok (04) | reference |
| 35 | From Aktiv to Passiv | B1.1 → B2.1 | ok (08) | before and after |
| 36 | er sagt, er sei krank (indirect speech) | B2.1 → C1.1 | drafted 2026-11-22 (38) | forms table + four kinds of sentence |

**Order of work:** go down the table and take the next chart that is new or rework. One chart at
a time: build it, run the review rounds, report, then the next. Do not touch a chart marked ok.
A new chart gets the next free file number (24, 25, …) and a line in `tool/charts/charts.json`
at its place in the book order.

### Notes per chart (the 17 to build)

Each note gives the idea to start from, not the finished content. Write the full spec (section 5,
step 2) before building. "Min." is the floor for German examples.

- **Gender by meaning.** First read: "when the ending says nothing, the meaning often does".
  Families under each article: der = days, months, seasons, weather (Regen, Schnee), compass
  points, car brands, alcoholic drinks (but das Bier); die = numbers, trees and flowers (most),
  motorbikes, ships; das = colours, languages, letters, metals, young beings (Kind, Baby), hotels
  and cinemas, verbs as nouns. One family = one bracket with 4–6 words. Traps: das Mädchen (ending
  wins, see endings chart), die Person, das Bier. Min. 60.
- **Plural.** The batch version listed five endings with too few words. Show the five routes
  (-e, -er, -n/-en, -s, no ending; with or without umlaut) and, for each, **who takes it** with
  8–10 words: feminine nouns in -e → -n (nearly all), -ung/-heit/-keit → -en, foreign words → -s,
  masculine/neuter in -er/-en/-el → no ending, one-syllable neuters → ¨-er. Percentages if our word
  list supports them. Dativ plural -n in the rule rows. Min. 50.
- **der, ein or nothing?** Situations, not a two-question path: first mention (ein) → known (der);
  jobs and nationalities (Ich bin Lehrer); materials and uncountables; plural of ein = nothing;
  countries with articles (die Schweiz, die Türkei, der Iran, die USA); fixed phrases (zu Hause,
  mit dem Bus, Klavier spielen). Each with 3–4 sentences. Min. 40 sentences or phrases.
- **Present tense.** ONE chart together with the next note: regular endings on one side, the vowel-change families on the other, min. 60 forms in total. Regular endings for all persons with three model verbs; stems in -t/-d
  (arbeitest), -s/-ß/-z (du heißt), -eln (ich sammle); sein, haben, werden in full. First read
  explains "stem + ending". Min. 45 forms.
- **Vowel-change verbs.** (Part of the Present tense chart.) Families e→i (essen, geben, helfen, nehmen, sprechen, treffen), e→ie
  (lesen, sehen), a→ä (fahren, schlafen, tragen, waschen, laufen→äu). Only du and er/sie/es change:
  show that visually. Traps: nehmen (nimmst), wissen. Min. 25 verbs with both forms.
- **Question words.** Pairs of question and a real answer: wer/wen/wem/wessen in case colours;
  wo/wohin/woher; wann/wie lange/wie oft/seit wann; wie viel/wie viele; warum; welcher; was für
  ein; W-question vs yes/no question word order (see verb position chart). Min. 30 pairs.
- **kein or nicht?** kein for nouns with ein or no article; nicht for everything else. Then the
  position of nicht on a sentence line (after the verb and objects, before adjectives, places,
  prepositions, the second verb part). nicht mehr, noch nicht, nie, doch as answer. Min. 40 sentences.
- **Possessives.** Grid: owners down (ich→mein … sie/Sie→ihr/Ihr), the thing's gender and case
  across, endings in case colours; sein vs ihr with two people and their things; euer → eure.
  Min. 45 phrases.
- **Pronouns.** ich/mich/mir table for all persons in case colours, each cell with a sentence
  frame; es, man; order of two pronouns (Ich gebe es ihm); du vs Sie. Min. 45.
- **Perfekt.** Two questions: haben or sein (movement A→B, change of state, plus sein/bleiben/
  passieren)? Participle: ge-…-t, ge-…-en, separable (auf-ge-macht), no ge- (be-, ver-, er-,
  -ieren). 12 common irregular participles. Min. 50 verbs.
- **Fixed-case prepositions.** Akkusativ: durch, für, gegen, ohne, um, bis, entlang. Dativ: aus,
  bei, mit, nach, seit, von, zu, gegenüber, außer, ab. Each with two example phrases; contracted
  forms (zum, zur, beim, vom, im, am, ins); pointer to Wo/Wohin for the nine two-case ones. Min. 45.
- **Dativ verbs and two objects.** About 20 verbs that take Dativ (helfen, danken, gefallen,
  gehören, schmecken, passen, antworten, glauben, folgen, gratulieren, fehlen, wehtun…), then
  verbs with two objects (geben, schenken, zeigen, schicken, bringen, erklären…) and the order
  rule: noun Dativ before noun Akkusativ, pronouns first, Akk pronoun before Dat pronoun. Min. 45.
- **Three word orders.** Frame 1: und, aber, oder, denn, sondern (nothing changes). Frame 2:
  deshalb, trotzdem, dann, danach, sonst, außerdem (verb comes next). Frame 3: weil, dass, wenn,
  ob, obwohl, als, bevor, nachdem, damit, während (verb last). Same example idea in all three
  frames. als/wenn/wann in the rule rows. Min. 40.
- **Irregular verbs.** Families by vowel pattern (ei–ie–ie, ie–o–o, i–a–u, e–a–o, e–a–e, a–u–a,
  mixed: bringen, denken, kennen, wissen), 5–7 verbs each with all three forms; sein-Perfekt
  marked. Min. 45 verbs.
- **Comparison.** -er / am -sten; umlaut group (alt, groß, jung, kalt, lang, warm…); -est after
  d/t/s; the irregular five (gut, viel, gern, hoch, nah); als vs so … wie; before a noun it takes
  endings (see adjective endings chart). Min. 45.
- **Nouns that add -n.** Who belongs: masculine nouns in -e (Junge, Kollege, Kunde, Name),
  -ent, -ant, -ist, -at, -oge, and Herr, Mensch, Nachbar, Bauer; where the -n appears (everywhere
  except Nominativ singular); Herz, Name with -ns in Genitiv. Min. 40.
- **Konjunktiv II.** Four uses, each with forms and sentences: polite requests (Könnten Sie…,
  Ich hätte gern…), wishes (Wenn ich doch … hätte), unreal conditions (Wenn ich Zeit hätte, würde
  ich…), advice (An deiner Stelle würde ich…). Forms: würde + infinitive; hätte, wäre, könnte,
  müsste, dürfte, sollte, wüsste, käme, ginge. Min. 40.
- **zu-infinitive.** After verbs (versuchen, anfangen, vergessen…), after adjectives and nouns
  (Es ist schwer, … / Ich habe Lust, …); um … zu, ohne … zu, statt … zu; no zu after modals,
  lassen, sehen, hören, gehen, bleiben; separable verbs (anzurufen); dass or zu (same subject).
  Min. 40.

### Later (cut from this book, do not build now)

Kept so the ideas are not lost; a possible second volume. 2026-11-22: Imperative, nach/in/zu,
Reflexive verbs, da- and wo- words and werden moved INTO the book (charts 33–37); the briefs below
stay as their record. Scales (12) and compound nouns (09) moved out, to here.

- **Imperative.** du / ihr / Sie built from the present; drop -st; vowel-change verbs (Iss! Nimm!
  but Fahr!); sei, seid, seien Sie; separable verbs (Mach die Tür zu!); bitte and mal for tone.
  Min. 40.
- **nach, in or zu?** Destinations grouped: nach (cities, countries without article, Hause,
  directions), in + Akk (countries with article, buildings you enter, mountains), zu (people,
  shops, events), an (water, edges), auf (islands, Markt, Party). The matching "where" and "from"
  forms in a second line (in/bei/aus/von). Min. 45.
- **Reflexive verbs.** sich table; Akkusativ group (sich freuen, sich setzen, sich treffen, sich
  beeilen…) vs Dativ group when there is another object (Ich wasche mir die Hände); real vs
  optional reflexive (waschen); reciprocal (wir treffen uns). Min. 40.
- **dieser, jeder, welcher.** der-words take der-endings: one table in case colours; then the
  pronouns jemand/niemand/man/etwas/nichts/alle/viele/einige with sentences; man → einen/einem.
  Min. 40.
- **da- and wo- words.** Thing → da(r)- + preposition, person → preposition + pronoun; question
  wo(r)- vs preposition + wen/wem; darauf, dass … as a pointer forward. Use the verbs from the
  Verb + preposition chart. Min. 40.
- **Two-part connectors.** sowohl … als auch, nicht nur … sondern auch, entweder … oder, weder …
  noch, zwar … aber, je … desto, einerseits … andererseits; what each means on a small scale
  (both, one, neither) and where the verb stands. Min. 30 sentences.
- **Genitiv prepositions.** wegen, trotz, während, statt, innerhalb, außerhalb, aufgrund,
  mithilfe, anlässlich; the Genitiv forms needed (des …s, der); spoken German uses Dativ after
  wegen/trotz; the weil/obwohl sentence that says the same. Min. 35.
- **Middle of the sentence.** A slots line: subject, pronouns, time, reason, manner, place,
  with known information before new; nicht's place; what moves to position 1 for emphasis.
  Several sentences set on the same slots. Min. 30 sentences.
- **werden.** Three columns: werden + adjective/noun (become), werden + infinitive (future,
  guess), werden + participle (passive); the forms wird/wurde/ist geworden/ist worden; würde as a
  pointer to Konjunktiv II. Min. 36.
- **Indirect speech.** Direct → indirect pairs; Konjunktiv I forms (sei, habe, werde, könne,
  komme); when it falls back to Konjunktiv II (sie haben → hätten); pronoun and time shifts;
  questions and requests (ob, solle). Min. 35.
- **Verbal ↔ nominal.** Pairs: weil → wegen, obwohl → trotz, wenn → bei, nachdem → nach, bevor →
  vor, während → während, damit → zu/für, indem → durch; each with a full sentence both ways.
  Min. 30 pairs.
- **Participles as adjectives.** Partizip I (happening now, active) vs Partizip II (done,
  passive); with endings; turned into a relative clause and back; extended form as a pointer to
  Long noun phrases. Min. 40.
- **Passive alternatives.** One sentence in five forms: man, sich lassen, sein + zu, -bar/-lich,
  bekommen-passive; which mean "can" and which "must". Min. 30.
- **Guessing and hearsay.** Certainty scale: muss (≈ 95 %), müsste, dürfte, kann, könnte, with the
  adverb that says the same (sicher, wahrscheinlich, vielleicht); soll (others say) vs will (he
  claims); past forms (muss … gewesen sein). The percentages here are a teaching convention:
  say so in the key. Min. 35.
- **Noun-verb pairs.** Map by verb: treffen (eine Entscheidung, Maßnahmen), stellen (eine Frage,
  einen Antrag), nehmen, bringen, kommen, geben, führen, leisten; each with the simple verb that
  means the same. Min. 45.
- **Adjectives and nouns with prepositions.** Map by preposition like the Verb + preposition
  chart: stolz auf, interessiert an, zufrieden mit, abhängig von, verantwortlich für; Interesse
  an, Angst vor, Lust auf, Einfluss auf. Case colour on each. Min. 50.
- **Unreal past.** hätte/wäre + participle; with modal (hätte … machen können/sollen/müssen) and
  its word order in a side clause; als ob / als wäre; fast/beinahe. Min. 30.
- **Modal particles.** One neutral sentence, then the same sentence with doch, ja, mal, halt,
  eben, eigentlich, denn, wohl, schon, and what each adds (surprise, softening, resignation…).
  Particles cannot be translated word for word: say so in the first read. Min. 35.
- **Word building.** Prefixes un-, miss-, ur-; suffixes -heit/-keit/-ung/-schaft (make die
  nouns), -chen/-lein (das), -er/-in (people), -bar, -los, -voll, -lich, -ig, -isch; each with
  4–5 words and the base word. Pointer to the gender chart. Min. 55.
- **Long noun phrases.** One long written-style phrase unpacked in steps into relative clauses,
  and built up again; where the article and the noun sit; how to find the noun first when reading.
  Min. 24 phrases.

## 8. Tools

- Render one chart and measure overflow (from the repo root):
  `node tool/charts/shot.mjs tool/charts/.tmp tool/charts/src/NN-slug.html`
  It prints `page H/H` (the two numbers must match) and every overflowing element, and saves
  `tool/charts/.tmp/shot-NN-slug.png`. **Open the PNG and look at it**; clean numbers are not a review.
- Build the whole book: `npm run charts` (PDF in `static/books/charts/`, previews in
  `static/img/charts/`, manifest for the site). It stops if any chart is taller than its sheet.
- Edit build scripts with the Edit tool, not shell one-liners: backslashes and quotes get lost in
  the shell.
- `tool/charts/build/build-15-17.mjs` and `build-18-23.mjs` are the old batch generators. Running
  the first one overwrites the approved Chart 15. Do not run them; write a new script per chart.

## 9. Open decisions (owner)

- Decided 2026-11-22: one book; then 35 charts, then 36 with ONE C-level chart (indirect speech; GDI asked for the minimum C chart) (imperative, nach/in/zu, reflexive, da-/wo-, werden moved in from Later; scales and compound nouns out).
- Print the level on each chart (assumed: yes, next to "Chart N").
- Chart 15 follow-ups: -tum and -ant are weaker than "nearly always" in our word count (-ma was
  removed for that reason, -anz for space); its
  "next chart" pointer waits for the meaning-families chart.
- The published percentages on Chart 15 come from one secondary source and need checking before print.
