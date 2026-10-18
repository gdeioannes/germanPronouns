# Learning-phase review — every Learn lesson, A1.1 to C2.2

Read 2026-10-18 against `assets/content/authoring/de_cert_a1/*.json` (the lesson
source) and the shipped bundle `assets/content/courses/de_cert_a1.json`. 403
quizzes, 403 lessons, 1,468 rule cards each with a check. This document is the
evaluation of the **Learn** phase only (hook → rules → checks → words → context →
mistakes → cheat sheet). The Practise phase is out of scope.

Columns in the per-level tables:

- **Exercise** — title, type, id.
- **What the lesson has** — the real content, compressed (rule titles, tables, words, context).
- **What would make it teach better** — concrete additions. Visual ideas use the
  codes from §2 so the same component can serve many lessons.

## Status — 2026-10-18 (plan executed)

| Step | Done |
|---|---|
| 1 · Diagram seam | `tip.visual` (13 kinds) drawn by `components/lesson/LessonVisual.svelte`. Data lives in `assets/content/visuals/de_cert_a1/<level>.json`, stamped by `node tool/apply-visuals.mjs de_cert_a1`, then `apply-authoring`. A gate test validates every diagram. Dev gallery: `/dev/lesson-visuals` (`?all=<id part>` for course data). |
| Coverage | 568 diagrams; all 403 lessons have at least one. The opening screen shows the quiz's own scene picture. |
| 2 · Skill lessons | Correction to G2: reading, listening, dictation and repeat-after-me lessons already got passage nouns at runtime. The real gap was the 24 open speaking lessons; each now has an 8-word list. Text structure is shown with `moves` diagrams, not annotated passages, so no answers are given away. |
| 3 · Paradigm tables | Covered by people grids, case grids and family tables on the rule cards rather than recap tables. |
| 4 · Decks and Suchbild | The two app-mechanics tips in 11 vocabulary decks replaced with topic tips. C2.2 deck: 16 English label cards removed through OVERRIDES drops. Suchbild tips kept; each got a room-specific diagram. |
| 5 · Recall | `help.recall` {known, today} on 53 lessons that extend an earlier topic, shown on the opening screen. |
| 6 · Pictures | 34 Gemini pictures (`assets/images/lesson_manifest.json`, `lesson_*` in static/img) in 10 lessons; colour swatches for Farben. |

Follow-up, same day: all twelve flashcard decks rebuilt; 686 audio clips recorded, so every level is fully recorded; 30 recap paradigm tables; 19 repeated Suchbild titles now name their room; 15 more pictures (body, shoe, jumper) and existing family and clothes pictures used in their lessons; an independent German review of 799 new items found 34 errors, all fixed, including some in older tables and rule titles. Workbook PDFs not regenerated (separate task).

---

## 1. What every lesson is today, and the course-wide gaps

**The good.** Every lesson has a hook, 2–6 rule cards each with a check question,
a "how to remember it" list, and a cheat sheet. Grammar drills (fillBlank) also
carry 8–22 words with audio, a short German context passage and 3–4 "which is
right?" mistakes. The writing is strong, the hooks are real hooks, the checks are
real questions. 100 lessons carry an authored reference table.

**The gaps, in order of impact.**

| # | Gap | How many | Fix |
|---|-----|----------|-----|
| G1 | **No picture or diagram anywhere in any lesson.** The Learn phase is text plus audio. The deck-card picture (every quiz has one) never appears inside the lesson. | 403 | Add a `visual` slot on a rule card and on the hook (§2). Show `quiz.image` on the hook step for the 110 quizzes with their own scene. |
| G2 | **Skill lessons are thin.** Listening, reading, speaking, writing, dictation, vocabulary and Suchbild lessons have no words step, no context, no mistakes: hook → 3 rules → recap. | ~165 | Give each a "words you will hear/read" step (10 items from the passage), and an **annotated excerpt** of its own text or transcript showing where the answers hide (V11). |
| G3 | **Most reference tables are the answer list.** For fillBlank the table is derived from the drill: 1 column × 15 rows for 150+ grammar lessons (e.g. Perfekt mit haben lists 15 participles, not the pattern). | ~150 | Author a paradigm table where one exists (persons × forms, cases × genders) and keep the derived list as "the forms in this drill". |
| G4 | **Vocabulary-deck lessons repeat app mechanics.** All 12 share "Three modes, three kinds of memory" and "A noun without its article is marked wrong". | 12 | Replace with 3 topic tips about the words themselves (gender patterns, false friends, word families in that deck). |
| G5 | **Suchbild lessons are near clones.** 24 lessons, 22 open with "A compound takes the gender of its last part". | 24 | One shared "how gender hides in endings" card, then two tips specific to that room's objects; show the room picture with 3 labelled objects in the lesson. |
| G6 | **Repeated topics do not reference each other.** Imperativ (A1.2, A2.2), indirect questions (A2.2, B1.1, B2.1), Passiv (A2.2 → B1.2 → B2.1 → C2.2), Konjunktiv II (A2.2 → B1.1 → B2.2 → C1.2 → C2.1). | ~40 | Open the later lesson with a one-line "you already know X from …; new today is only Y" and highlight only the new cells in the shared table (V2). |
| G7 | **Kurzcheck speaking lessons have two rules and nothing else.** | 12 | Add a V14 script card (the turns the tutor will take) and 6 phrases to have ready. |
| G8 | **"Mnemonic" cards are often rules.** 329 cards are tagged mnemonic; many are plain rules with a catchy title. | ~150 | Keep the tag for real memory hooks (chants, images, stories) and give them a visual; retag the rest. |

---

## 2. Proposed visual toolkit (reusable components)

Each code below is one SVG/Svelte component fed by small data in the lesson JSON
(`tip.visual: { kind, ... }`). Built once, used by dozens of lessons. Picture-book
illustrations (V15) go through the existing `npm run images` pipeline.

| Code | Visual | Used for |
|------|--------|----------|
| **V1 Satzklammer** | Four boxes: Position 1 · Verb 2 · Mittelfeld · End. Moving parts slide and light up (prefix, participle, infinitive, verb-last after weil/dass). | word order, separable verbs, modals, Perfekt, subordinate clauses, Futur, Passiv, TeKaMoLo |
| **V2 Case grid** | m/f/n/pl × Nom/Akk/Dat/Gen in gender colours; only the cells that change versus what the learner already knows glow. | articles, pronouns, possessives, adjective endings, relative pronouns, n-Deklination |
| **V3 Timeline** | past ← now → future with markers and spans (seit, vor, in, bis, schon). | tenses, Plusquamperfekt, Futur II, temporal prepositions, als/wenn |
| **V4 Position scene** | Flat picture-book room; a dot = Wo (Dativ), an arrow = Wohin (Akkusativ). | Wechselpräpositionen, wo/wohin/woher, legen/stellen/setzen |
| **V5 Decision tree** | Two or three yes/no questions ending in the form. | haben/sein in Perfekt, kein/nicht, als/wenn, um…zu/damit, dass/zu-Infinitiv, soll/will |
| **V6 Sound card** | The letter, "say it like", a mouth hint, play button. | z, ei/ie, ü/ö/ä, ch, -ig, word stress |
| **V7 Number builder** | Tiles that snap: ein + und + zwanzig; drei + hundert. | numbers 0–10, 11–20, 20–100, 100+ , dates/ordinals |
| **V8 Clock face** | Analog clock with the shaded wedge for halb/Viertel/nach/vor and the 24h digits. | Uhrzeit, Termine, Durchsage |
| **V9 Map** | Europe/DACH; arrows for nach/in/zu/aus; flags for Länder with article. | Länder & Sprachen, wohin, DACH variants, weather regions |
| **V10 Register ladder** | Thermometer from umgangssprachlich → neutral → formell with the words on rungs. | Modalpartikeln, Konnektoren register, Register lessons, Fremdwörter, Paraphrase |
| **V11 Text map** | The lesson's own text/transcript as labelled blocks ("greeting · what she wants · when · sign-off") with the answer spots marked. | every reading, listening, dictation, e-mail/Redemittel lesson |
| **V12 Word blocks** | Prefix / stem / suffix as Lego in gender colours. | Wortbildung, compounds, suffix → gender, prefixes |
| **V13 People grid** | ich / du / er·sie·es / wir / ihr / sie / Sie as seven icons; forms written on each. Same layout in every paradigm lesson. | all verb paradigms, pronouns, possessives, Imperativ, Konjunktiv |
| **V14 Script card** | Dialogue turns as speech bubbles with the learner's turn blank. | shop, café, doctor, directions, interview, Kurzcheck/Gespräch speaking |
| **V15 Picture scene** | A picture-book illustration (existing pipeline) for the context passage or the hook. | family, body, clothes, weather, rooms, every reading/listening scene |
| **V16 Transformation pairs** | Clause on the left, phrase on the right, matching parts colour-linked by arrows. | verbal ↔ nominal, relative clause ↔ participle, active ↔ passive, direct ↔ indirect |
| **V17 Certainty scale** | Bar from 0 to 100 % with the modal/adverb at its point. | subjective modals, Futur as guess, hedging, Abtönung |
| **V18 Family tree** | Oma/Opa → Eltern → Kinder with articles. | Familie, possessives |
| **V19 Wheel** | Seasons/months/compass as a circle. | Datum, Wetter & Jahreszeiten, Wochentage |
| **V20 Moves diagram** | The argumentative "shape" (Einleitung · Pro · Contra · Meinung · Schluss) as stacked blocks with Redemittel in each. | Stellungnahme, Leserbrief, Rezension, Vortrag, Erörterung, Forumsbeitrag |

Priority build order by reach: **V1, V2, V13, V11, V3, V5** cover more than 300
lessons between them. V15 reuses the image pipeline and costs ~0.04 € per scene.

---

## 3. A1.1 — 30 lessons

| Exercise | What the lesson has | What would make it teach better |
|---|---|---|
| **Zahlen 0–10** · fillBlank/numberTasks · `quest_a1_1_zahlen` | 3 rules (the eleven, eins vs ein, z = ts / ei / ie), 13 words, phone-number context, 2 mistakes, derived list of 11. | V7 number tiles 0–10 with audio per tile; V6 sound card for z/ei/ie with mouth hint; a finger-counting picture (German thumb-first) since Order the round depends on it. |
| **Personalpronomen** · fillBlank · `quest_a1_1_pronomen` | 4 rules (nine forms, sie/sie/Sie, du or Sie, es), 10 words, context, 2 mistakes. | V13 people grid as the anchor (reused by every later paradigm); V5 mini tree "du or Sie?" (child? friend? first name?) ; picture pair for the three sie meanings. |
| **Sprechen: Vorstellung** · speakRepeat · `quest_a1_1_sprechen_vorstellung` | 3 rules (rhythm, four sounds English lacks, greetings by time/formality); no words/context/mistakes. | V6 sound cards for ü, ö, ch, r; a greeting clock (Morgen/Tag/Abend wedges, V8 variant); V14 script card of the self-intro. Fix the WOher stress example (Duden: woHER). |
| **Artikel im Nominativ** · fillBlank · `quest_a1_1_artikel` | 4 rules (der/die/das pairs, ein/eine, no article for jobs, gender endings), context, 3 mistakes, 21-row derived table with gender colours. | V12 suffix blocks (-e → die, -chen → das, -er → der) in gender colours; three-colour legend card establishing blue/red/green for the whole course; a picture row of 6 nouns with coloured frames. |
| **Plural der Nomen** · fillBlank · `quest_a1_1_plural` | 4 rules (five endings, unchanged, -s, dictionary notation), context, 3 mistakes, 18 rows. | A five-column "plural families" table with 3 examples each (authored, not derived); V12 blocks showing Umlaut + ending; a card explaining the "¨-e / -en / –" notation with one example each. |
| **Zahlen 11–20** · fillBlank · `quest_a1_1_zahlen2` | 3 rules (unit + zehn, three exceptions, 13–19 chant), 11 words, context, 2 mistakes. | V7 tiles: drei + zehn → dreizehn; highlight the shortened sech-, sieb-; audio chant as one playable step. |
| **Hören: Vorstellung** · listening · `quest_a1_1_hoeren_vorstellung` | 3 rules (listen for W-answers, question order, time words); nothing else. | G2: words step (10 words from the transcript); V11 transcript map with the 4 answer spots; "listen once for the shape" playable preview of the first 10 s. |
| **sein & haben** · fillBlank · `quest_a1_1_sein_haben` | 3 rules (sein no pattern, haben loses b, haben where English says be), 10 words, context, 3 mistakes, 2-col × 6 table. | V13 people grid for both verbs side by side; a "haben not sein" picture card (Hunger, Durst, Angst, Zeit) with icons. |
| **W-Fragen** · fillBlank · `quest_a1_1_wfragen` | 4 rules (W-word verb subject, wo/wohin/woher, wie, yes/no + doch), 12 words, context, 3 mistakes. | V1 Satzklammer with the W-word in slot 1; V4 three-arrow picture for wo (dot) / wohin (arrow in) / woher (arrow out); a doch mini-dialogue card. |
| **Lesen: Das bin ich** · reading · `quest_a1_1_lesen_dasbinich` | 3 rules (question first, guess from neighbours, intro order). | G2: V11 text map of the profile (name · age · home · job · hobbies) over the real text; words step; show the scene picture. |
| **Kurzcheck: Zahlen & Vorstellung** · speaking · `quest_a1_1_sprechen_kurzcheck` | 2 rules (full sentences, let it move on). | G7: V14 script card with the tutor's likely questions and 6 ready answers; V7 reminder tiles for ages/phone numbers. |
| **Regelmäßige Verben** · fillBlank · `quest_a1_1_praesens` | 4 rules (stem + ending, extra e, one tense three meanings, -st/-t), 12 words, context, 3 mistakes, 6-col × 10 table. | V13 grid with endings coloured; V12 stem + ending blocks (arbeit + e + t); the derived 6×10 table already works — fold it to one example verb first. |
| **Vokalwechsel** · fillBlank · `quest_a1_1_vokalwechsel` | 4 rules (only du and er, a→ä e→i e→ie, nehmen/essen shrink, endings regular), 10 words, context, 3 mistakes, 6×8 table. | V13 grid with only du/er cells glowing (G6 pattern); three colour groups a→ä / e→i / e→ie as a sorted table. |
| **Großer Text: Das bin ich** · reading(inline) · `quest_a1_1_bigtext_dasbinich` | 3 rules (ich -e / sie -t / wir, masculine Nom no ending, capitals). | V11 map of the passage with gap types colour-coded (verb / article / capital); words step; link back to the three A1.1 lessons it rehearses. |
| **Diktat: Steckbrief** · dictation · `quest_a1_1_diktat_steckbrief` | 3 rules (listen whole, capital nouns, ei/ie/ß). | V6 sound cards ei/ie/ß with spelling; one worked dictation: audio → what you hear → what you write, side by side. |
| **Hören: Zahlen & Preise** · listening · `quest_a1_1_hoeren_zahlen` | 3 rules (product then price, euros then cents, billig/kostet). | V7 price builder (vier Euro fünfzig); V15 market stall picture with price tags; words step (products). |
| **Zahlen 20–100** · fillBlank · `quest_a1_1_zahlen3` | 4 rules (unit + und + ten, the tens, ein not eins, say then flip), 11 words, context, 3 mistakes, 19 rows. | V7 tiles with the flip animated (21 → ein·und·zwanzig); a tens column card with the irregular zwanzig/dreißig/sechzig/siebzig marked. |
| **Farben** · fillBlank · `quest_a1_1_farben` | 4 rules (no ending after sein, before noun later, rosa/lila, hell-/dunkel-), 14 words, context, 3 mistakes. | Colour swatches with the word printed on each (the most obvious missing picture in the course); hell-/dunkel- gradient strip. |
| **Sprechen: Zahlen & Preise** · speakRepeat · `quest_a1_1_sprechen_zahlen` | 3 rules (z/ei/-ig, prices, stress first part). | V6 cards; stress marked on example numbers (DREIzehn vs dreiUNDzwanzig); words step with prices. |
| **Familie & Menschen** · fillBlank · `quest_a1_1_familie` | 4 rules (core family, -in, das Mädchen/Kind, Freund/Freundin), 17 words, context, 3 mistakes. | V18 family tree with articles in gender colours (the picture pipeline already has Vater/Mutter etc.); the Freund(in) ambiguity as a two-panel cartoon. |
| **Länder, Sprachen & Nationalitäten** · fillBlank · `quest_a1_1_laender` | 4 rules (aus + country, countries with article, languages -isch, nationalities -in), context, 3 mistakes, 4-col × 15 table. | V9 Europe map with the article countries marked (die Schweiz, die Türkei, die USA); the 4×15 table is good, add flags. |
| **Wo? — Ortsangaben** · fillBlank · `quest_a1_1_wo_praepositionen` | 5 rules (im/in der, am/bei/beim, aus/vom, auf/vor/unter, contractions), context, 3 mistakes, 2×17 table. | V4 town scene with 8 labelled spots (im Büro, am Bahnhof, beim Arzt); contraction cards (in + dem = im) as V12 blocks. |
| **Wortbildung: -in & Komposita** · fillBlank · `quest_a1_1_wortbildung` | 4 rules (-in/-innen, last word rules, joints, read from the back), context, 3 mistakes, 2×12 table. | V12 compound blocks with the last block coloured by gender (Apfel + Kuchen → der); animation "read from the back". |
| **Gespräch: Das bin ich** · speaking · `quest_a1_1_sprechen_dialog` | 3 rules (answer what was asked, use the level, ask back). | V14 script card of a 5-minute chat; words step with 10 reusable phrases; show the reading scene it borrows as the hook picture. |
| **Schreiben: Das bin ich** · writing · `quest_a1_1_schreiben_steckbrief` | 3 rules (verb second, four verbs, capitals), 7 words, 4 mistakes. | A model text with V11 labels (6 sentences, each labelled by what it says); V1 bracket on one sentence. |
| **Alphabet & Buchstabieren** · fillBlank · `quest_a1_1_alphabet` | 4 rules (E/I, surprising names, spelling helpers, front-desk script), 9 words, context, 3 mistakes, 11 rows. | Full alphabet grid with audio per letter and the "differs from English" ones highlighted; V14 script for spelling your name at a desk. |
| **Zahlen ab 100** · fillBlank · `quest_a1_1_zahlen_gross` | 4 rules (hundreds, thousands and the full stop, years, read from left flip last two), 10 words, context, 3 mistakes, 16 rows. | V7 big builder (zwei·tausend·drei·hundert·vier·und·zwanzig) with the German 1.000 / 4,50 punctuation card; year reading pre/post 2000 on a V3 timeline. |
| **Wortschatz** · vocabulary · `quest_a1_1_wortschatz` | 3 generic rules (article first, plural with noun, names no article). | G4: topic tips about this deck's words (which endings dominate, 3 false friends), with 6 card pictures shown in the lesson. |
| **Suchbild: Das Wohnzimmer** · suchbild · `quest_a1_1_suchbild_wohnzimmer` | 3 rules (-e → die, die Brille is one, -o/-a → das), 32 words. | G5: show the room picture with 3 objects labelled in gender colours; a 32-word checklist grouped by article. |
| **Suchbild: Das Klassenzimmer** · suchbild · `quest_a1_1_suchbild_klassenzimmer` | 3 rules (compound last part, -er machines, -chen), 32 words. | Same as above with its own picture; "two compounds, same head" example (Schulbuch / Wörterbuch → das). |

---

## 4. A1.2 — 36 lessons

| Exercise | What the lesson has | What would make it teach better |
|---|---|---|
| **Akkusativ (Artikel)** · fillBlank · `quest_a1_2_akkusativ` | 4 rules (only masculine moves, wen oder was, verbs that take it, -n on blue words), context, 3 mistakes, 2×15 table. | V2 case grid with ONLY den/einen glowing (the whole lesson in one picture); subject→verb→object arrow diagram on one sentence. |
| **Possessivartikel** · fillBlank · `quest_a1_2_possessiv` | 4 rules (pick owner, add ein-ending, sein vs ihr, euer), context, 3 mistakes, 5×9 table. | Two-step picture: owner icon → possessive stem → noun colour → ending (V13 + V2 combined); sein/ihr cartoon (his dog / her dog). |
| **Hören: Im Café** · listening · `quest_a1_2_hoeren_cafe` | 3 rules (signpost verbs, two voices, offered ≠ ordered). | G2: V11 transcript map with waiter/guest lanes; words step (menu items); café scene picture already exists, show it. |
| **Personalpronomen (Akkusativ)** · fillBlank · `quest_a1_2_pronomen_akk` | 4 rules (five change four stay, 'it', sie/Sie, chant), 12 words, context, 3 mistakes. | V13 grid Nom vs Akk with changed cells glowing; "it" decision card by noun gender. |
| **Negation (kein/nicht)** · fillBlank · `quest_a1_2_negation` | 4 rules (kein for ein-nouns, nicht elsewhere, where nicht goes, kein endings), context, 3 mistakes. | V5 tree: noun? → ein/bare? → kein else nicht; V1 bracket showing nicht's three landing spots. |
| **Lesen: Das neue Café** · reading · `quest_a1_2_lesen_cafe` | 3 rules (geöffnet/geschlossen, scan, invitation at the end). | V11 e-mail map (greeting · news · hours · prices · invitation · sign-off); words step; opening-hours sign picture. |
| **Modalverben** · fillBlank · `quest_a1_2_modalverben` | 4 rules (ich = er no ending, bracket, vowel change, möchten vs wollen), 11 words, context, 3 mistakes, 6×6 table. | V1 bracket with modal at 2 and infinitive at end (first appearance; make it memorable); V13 grid with the singular vowel-change cells glowing; a politeness ladder möchte → will (V10). |
| **Sprechen: Alltag & Uhrzeit** · speakRepeat · `quest_a1_2_sprechen_alltag` | 3 rules (land on the prefix, ü, halb). | V6 ü card; V8 clock; stress marks on the separable verbs. |
| **Uhrzeit** · fillBlank · `quest_a1_2_uhrzeit` | 4 rules (halb forward, nach/vor, official clock, asking), 11 words, context, 3 mistakes, 2×16 table. | V8 analog clock with wedges: halb acht shaded to 7:30, Viertel nach/vor; 12h vs 24h side by side. The single most picture-shaped lesson in A1. |
| **Kurzcheck: Akkusativ & Possessiv** · speaking · `quest_a1_2_sprechen_kurzcheck` | 2 rules. | G7 script card; 6 object nouns with pictures and their einen/meinen forms. |
| **Wochentage & Monate** · fillBlank · `quest_a1_2_datum` | 4 rules (all masculine, am/im, der erste…, -s habits), 13 words, context, 4 mistakes, 19 rows. | V19 month wheel with seasons; a week strip; ordinals table 1.–31. with the -te/-ste split marked. |
| **Wann? — Zeitangaben** · fillBlank · `quest_a1_2_wann_praepositionen` | 4 rules (um/am/im, spans, vor/nach/in, no preposition for years), context, 3 mistakes, 16 rows. | V3 timeline with the prepositions placed (um = point, von…bis = span, ab = open start, in = future distance). |
| **Diktat: Mein Tag** · dictation · `quest_a1_2_diktat_meintag` | 3 rules (prefix last, halb acht two words, einen -en). | Worked dictation example; V1 bracket showing the prefix landing; V8 clock for the times in the clips. |
| **Hören: Termine & Uhrzeit** · listening · `quest_a1_2_hoeren_termine` | 3 rules (halb acht, preposition decides place, instructions end). | V11 voicemail map (who · what changed · new time · place · instruction); V8 clock; words step. |
| **Hören: Durchsage am Bahnhof** · listening · `quest_a1_2_hoeren_bahnhof` | 3 rules (formula, nicht = correction, 24h). | V11 announcement formula as a fill-in template; platform sign picture with Gleis/Abfahrt/Verspätung labelled. |
| **Akkusativpräpositionen** · fillBlank · `quest_a1_2_praepositionen` | 4 rules (chant, what changes, contractions, um = at), 12 words, context, 3 mistakes, 2×15 table. | Five picture icons for durch/für/gegen/ohne/um (arrow through, gift, wall, crossed-out, circle); chant as audio. |
| **Großer Text: Mein Tag** · reading(inline) · `quest_a1_2_bigtext_meintag` | 4 rules (masculine moves, prefix at end type stem, modal → infinitive, kein). | V11 passage map with gap types colour-coded; a one-day V3 timeline of the text's events with clock icons. |
| **Trennbare Verben** · fillBlank · `quest_a1_2_trennbare` | 4 rules (verb 2 prefix end, prefixes that separate, with modal rejoined, stress), 12 words, context, 3 mistakes. | V1 bracket animation: aufstehen splits, then rejoins behind muss; prefix list with stress dots; day-routine picture strip. |
| **Perfekt: erste Schritte** · fillBlank · `quest_a1_2_perfekt_intro` | 4 rules (haben + participle end, ge-t/ge-en, three take sein, bracket), context, 3 mistakes, 2×15 table. | V1 bracket with habe … gegessen; V12 blocks ge + stem + t/en; V5 two-question tree for haben/sein (introduced here, reused in A2.1). |
| **war & hatte** · fillBlank · `quest_a1_2_war_hatte` | 4 rules (war, hatte, not ich bin gewesen, skeleton), 11 words, context, 3 mistakes, 2×6 table. | V13 grid for both; V3 timeline "yesterday" anchor. |
| **Imperativ** · fillBlank · `quest_a1_2_imperativ` | 4 rules (du stem, ihr form, Sie infinitive + Sie, sein/haben), context, 3 mistakes, 3×13 table. | Three-person cartoon (friend / group / stranger) with the same command; V13 reduced to du/ihr/Sie. A2.2 Imperativ should then say "new today: e→i and softeners" (G6). |
| **Höflich bitten & bestellen** · fillBlank · `quest_a1_2_hoeflich` | 4 rules (hätte gern, Könnten Sie, würde gern, Ich will is not polite), context, 3 mistakes. | V14 café script card; V10 politeness ladder (Ich will → Ich möchte → Ich hätte gern → Könnten Sie). |
| **mir, dir, Ihnen** · fillBlank · `quest_a1_2_dativ_pronomen_intro` | 4 rules (dative pronouns, verbs that want them, gefallen turns round, mir/dir vs mich/dich), context, 3 mistakes, 12 rows. | V13 grid Akk vs Dat; the gefallen flip as a subject/object swap diagram (Der Film gefällt mir ↔ I like the film). |
| **Satzbau: Position 2 & Konnektoren** · fillBlank · `quest_a1_2_satzbau` | 4 rules (verb second, position 0 words, dann position 1, denn vs weil), context, 3 mistakes, 2×15 table. | V1 bracket with position 0 added (und/aber/denn sit outside); dann pushing the subject behind the verb as an animation. |
| **Sprechen: Einkaufen & Bestellen** · speakRepeat · `quest_a1_2_sprechen_einkaufen` | 3 rules (hätte gern, shopkeeper's questions, ö/ä). | V14 shop script; V6 ö/ä cards; words step with 10 shop items (pictures exist). |
| **Einkaufen: Mengen & Preise** · fillBlank · `quest_a1_2_einkaufen_mengen` | 4 rules (measure + thing, weights, prices, shop script), context, 3 mistakes. | V15 market picture with labelled quantities (ein Kilo, eine Flasche, 200 Gramm); V7 price builder. |
| **Körper & Befinden** · fillBlank · `quest_a1_2_koerper` | 4 rules (tut weh, -schmerzen, how you feel, genders), context, 3 mistakes. | Body outline with labelled parts in gender colours (picture-book style); tut weh / tun weh singular–plural card. |
| **Lesen: Eine kleine Reise** · reading · `quest_a1_2_lesen_reise` | 3 rules (four questions four signals, mit dem, wohnen in). | V11 story map (when · how long · how much · how); V9 map with the route; words step. |
| **Lesen: Anzeigen & Schilder** · reading · `quest_a1_2_lesen_anzeigen` | 3 rules (no sentences scan nouns, ad vocabulary, several numbers). | Show one real ad with its parts labelled (price, size, contact, time) as V11; abbreviation card (qm, NK, WG, Zi.). |
| **Gespräch: Mein Alltag** · speaking · `quest_a1_2_sprechen_dialog` | 3 rules (bracket, times and days, keep going). | V14 script; V8 clock; V1 bracket reminder. |
| **Schreiben: Eine kurze Nachricht** · writing · `quest_a1_2_schreiben_absage` | 3 rules (modal bracket, denn, say when), 7 words, 4 mistakes. | Model message with V11 labels (sorry · can't · reason · alternative time); V1 bracket. |
| **Wohin? — nach, zu, in** · fillBlank · `quest_a1_2_wohin` | 4 rules (nach, in + article, zu, nach Hause vs zu Hause), 10 words, context, 3 mistakes, 17 rows. | V5 tree (city/country? → nach; person/event? → zu; place you enter? → in); V9 map arrows; V4 house with "nach Hause" arrow vs "zu Hause" dot. |
| **unser, euer, Ihr** · fillBlank · `quest_a1_2_possessiv_plural` | 4 rules (owner first, endings, euer drops e, Ihr capital), 10 words, context, 3 mistakes, 3×4 table. | V13 grid plural owners only; euer → eure as a V12 block losing a tile. |
| **Wortschatz** · vocabulary · `quest_a1_2_wortschatz` | 3 generic rules. | G4: tips about this deck (errand nouns, -e feminine, compound heads) + 6 card pictures. |
| **Suchbild: Die Küche** · suchbild · `quest_a1_2_suchbild_kueche` | 3 rules (compound, -e, -er exceptions), 32 words. | G5: picture with 3 labels; group the 32 by article. |
| **Suchbild: Der Supermarkt** · suchbild · `quest_a1_2_suchbild_supermarkt` | 3 rules (compound, -e but der Käse, -chen), 32 words. | G5: same. |

---

## 5. A2.1 — 29 lessons

| Exercise | What the lesson has | What would make it teach better |
|---|---|---|
| **Perfekt mit haben** · fillBlank · `quest_a2_1_perfekt_haben` | 6 rules (haben at 2, ge-t/ge-en, mixed verbs, no ge- for -ieren/be-/ver-, separable ge- in the middle, say the pair), 17 words, context, 3 mistakes, derived list of 15. | G3: author a 3-group participle table (regular / irregular / mixed, 5 each); V12 blocks for ge+stem+t, auf·ge·räumt, be·zahlt (no ge); V1 bracket. Six rules is long: merge rule 1 with the bracket visual. |
| **Perfekt mit sein** · fillBlank · `quest_a2_1_perfekt_sein` | 4 rules (movers and changers, mostly irregular, object → haben, sein/bleiben odd), 14 words, context, 3 mistakes. | V5 tree (movement A→B? change of state? → sein); V4 scene with arrows for gehen/fahren/fliegen vs a dot for bleiben; "ich bin … gefahren / ich habe das Auto gefahren" pair card. |
| **Sprechen: Mein Wochenende** · speakRepeat · `quest_a2_1_sprechen_wochenende` | 3 rules (time word first, story words, habe or bin). | V3 weekend timeline with zuerst/dann/danach/am Ende; V14 script. |
| **Dativ: bestimmte Artikel** · fillBlank · `quest_a2_1_dativ_artikel` | 4 rules (dem/der/dem/den+n, wem, dative verbs, einem/einer), 11 words, context, 3 mistakes. | V2 grid: Nom + Akk already known, Dat row glows; giver → gift → receiver arrow picture for wem; dative-verb icon row (helfen, danken, gehören…). |
| **Hören: Eine Reise** · listening · `quest_a2_1_hoeren_reise` | 4 rules (wait for participle, travel prepositions, war vs Perfekt, weil/deshalb). | V11 story map; V9 route map; words step. |
| **Dativpräpositionen** · fillBlank · `quest_a2_1_dativ_praep` | 4 rules (chant, contractions, nach vs zu, seit + present), 11 words, context, 3 mistakes. | Seven icons for aus/bei/mit/nach/seit/von/zu; chant as audio with rhythm dots; V3 for seit. |
| **Zeitangaben: seit, vor, nach, in…** · fillBlank · `quest_a2_1_temporal_2` | 4 rules (seit/für/vor, vor/nach/in, dative plural -n, ab/über/zwischen), 10 words, context, 4 mistakes. | V3 timeline is the lesson: seit as a bar reaching now, vor a dot in the past, in a dot in the future, für a bounded span. |
| **Woher? Wo? Wohin?** · fillBlank · `quest_a2_1_woher_wo_wohin` | 4 rules (places aus/in/in, people von/bei/zu, cities aus/in/nach, home), 9 words, context, 3 mistakes, 3×12 table. | V4 three-arrow scene (out of / at / into) for one place; the 3×12 table is right, add the arrow icons to the column heads. |
| **Personalpronomen im Dativ** · fillBlank · `quest_a2_1_pronomen_dativ` | 4 rules (nine forms, gefallen/schmecken/gehören/passen, ihr/ihnen/Ihnen, after dative prepositions), 11 words, context, 3 mistakes. | V13 grid with Nom/Akk/Dat rows; subject-flip diagram for gefallen (reuse A1.2). |
| **Wem? Was?** · fillBlank · `quest_a2_1_dativ_akkusativ` | 4 rules (person dative thing accusative, person first, pronoun jumps, verbs of giving), 10 words, context, 3 mistakes. | Giver/gift/receiver picture with colour-coded roles; V1 Mittelfeld ordering with the pronoun jump animated. |
| **Lesen: Ein Wochenende in Hamburg** · reading · `quest_a2_1_lesen_hamburg` | 4 rules (deshalb, day by day, aber, weil). | V11 text map by day; weil ↔ deshalb arrow pair (cause → effect both directions). |
| **Kurzcheck: Perfekt** · speaking · `quest_a2_1_sprechen_kurzcheck` | 2 rules. | G7 script; V5 haben/sein tree as a pocket card. |
| **war & hatte (Präteritum)** · fillBlank · `quest_a2_1_war_hatte` | 4 rules (background vs events, paradigms, prefer war/hatte, Als Kind), 10 words, context, 3 mistakes. | Story diagram: background band (war/hatte) with event dots (Perfekt) on top; V13 grid. |
| **Modalverben im Präteritum** · fillBlank · `quest_a2_1_modal_praeteritum` | 4 rules (stem minus umlaut + te, infinitive end, no Perfekt for modals, umlaut goes), 11 words, context, 3 mistakes, 5×6 table. | V12 blocks könn → konn + te; V13 grid; "excuse" cartoon (Ich konnte nicht, ich musste…). |
| **Großer Text: Ein Wochenende bei Oma** · reading(inline) · `quest_a2_1_bigtext_wochenende` | 3 rules (read to the participle, mit/bei/nach → dem/der, states = war). | V11 passage map with gap types; V15 scene (grandmother's house) as hook image. |
| **Das Wetter & Jahreszeiten** · fillBlank · `quest_a2_1_wetter` | 4 rules (es + verb, temperatures, seasons and compass, weather kit), 12 words, context, 3 mistakes. | Weather icon row with the es-sentences; V19 season wheel + compass rose; a thermometer with "es wird kälter". |
| **Diktat: Im Perfekt** · dictation · `quest_a2_1_diktat_perfekt` | 3 rules (hear helper predict participle, ge- written, questions start with helper). | Worked example; V1 bracket. |
| **Sprechen: Nach dem Weg fragen** · speakRepeat · `quest_a2_1_sprechen_weg` | 3 rules (zum/zur, four direction words, repeat back). | V4 street map with links/rechts/geradeaus/gegenüber arrows; V14 script. |
| **Komparativ** · fillBlank · `quest_a2_1_komparativ` | 4 rules (-er + als, umlaut, irregular four + teuer, genauso wie), 12 words, context, 3 mistakes. | Two-object picture pairs (bigger house, cheaper ticket); V12 stem + er with umlaut dots; irregular four as a card. |
| **welcher? dieser!** · fillBlank · `quest_a2_1_welcher_dieser` | 4 rules (der-endings, pointing, possessives in dative, -m/-r/-m/-n), 8 words, context, 3 mistakes. | V2 grid showing welch-/dies- endings identical to der; shop-counter cartoon (Welchen? Diesen!). |
| **Hören: Wetterbericht** · listening · `quest_a2_1_hoeren_wetter` | 3 rules (slot where and when, es wird + comparative, advice last). | V9 DACH map with weather icons per region as the listening grid; V11 forecast formula. |
| **Lesen: Emmas erste Woche** · reading · `quest_a2_1_lesen_emma` | 3 rules (each day one event, war vs Perfekt, gefällt ihr). | V11 week map; V3 timeline Mon–Sun. |
| **Gespräch: Erlebnisse** · speaking · `quest_a2_1_sprechen_dialog` | 3 rules. | V14 script; V3 timeline words. |
| **Schreiben: E-Mail an einen Freund** · writing · `quest_a2_1_schreiben_wochenende` | 3 rules, 9 words, 4 mistakes. | Model e-mail with V11 labels; V5 haben/sein pocket tree. |
| **Indefinitpronomen** · fillBlank · `quest_a2_1_indefinitpronomen` | 5 rules (man, jemand/niemand, etwas/nichts + capital adjective, alle/alles, pairs), 11 words, context, 4 mistakes, authored 4-col × 7 table. | Good table. Add a crowd picture with man/jemand/niemand/alle highlighted figures; pairs card as opposites. |
| **Wortschatz** · vocabulary · `quest_a2_1_wortschatz` | 3 generic rules. | G4. |
| **Suchbild: Das Badezimmer** · suchbild · `quest_a2_1_suchbild_badezimmer` | 3 rules, 32 words. | G5. |
| **Suchbild: Der Bahnhof** · suchbild · `quest_a2_1_suchbild_bahnhof` | 3 rules, 32 words. | G5. |

---

## 6. A2.2 — 36 lessons

| Exercise | What the lesson has | What would make it teach better |
|---|---|---|
| **Wechselpräpositionen: Wo?** · fillBlank · `quest_a2_2_wechsel_wo` | 4 rules (Wo → Dativ, position verbs, cat on the box, the nine), 14 words, context, 3 mistakes. | V4 room scene with the cat and nine prepositions as dots; this is the canonical diagram and the lesson text already describes it. |
| **Wechselpräpositionen: Wohin?** · fillBlank · `quest_a2_2_wechsel_wohin` | 4 rules (Wohin → Akk, putting verbs, cat jumps, ins/ans/aufs), 11 words, context, 3 mistakes. | Same V4 scene with arrows; legen/stellen/setzen/hängen as four icons (lying, standing, sitting, hanging). |
| **Großer Text: Mein Zimmer** · reading(inline) · `quest_a2_2_bigtext_zimmer` | 3 rules (verb gives it away, same preposition two cases, the switch). | V11 passage map split "describing" vs "tidying"; V4 before/after room pictures. |
| **Sprechen: Mein Zimmer** · speakRepeat · `quest_a2_2_sprechen_zimmer` | 3 rules (position = dative, es gibt, clockwise). | V4 room with a clockwise tour arrow; V14. |
| **Reflexive Verben** · fillBlank · `quest_a2_2_reflexiv` | 4 rules (pronouns, always reflexive, can be reflexive, position), 11 words, context, 3 mistakes. | Bounce-back arrow picture (verb → back to subject); V13 grid with reflexive column (only sich new). |
| **Nebensatz mit weil** · fillBlank · `quest_a2_2_weil` | 4 rules (verb end, two verbs helper last, weil vs denn, kick the verb back), 11 words, context, 3 mistakes. | V1 bracket "subordinate mode": the verb slides from slot 2 to the end on tapping weil; denn stays at position 0 (contrast). |
| **Hören: Eine Verabredung** · listening · `quest_a2_2_hoeren_verabredung` | 4 rules. | V11 voicemail map; V8 clock; V4 vor dem Museum dot. |
| **Nebensatz mit dass** · fillBlank · `quest_a2_2_dass` | 4 rules (verb end, verbs that take dass, dass or das, drop dass in speech), 11 words, context, 3 mistakes. | V1 subordinate mode again (G6: "same move as weil"); dass/das card with the dieses/welches test. |
| **wenn & deshalb** · fillBlank · `quest_a2_2_wenn_deshalb` | 4 rules (wenn verb end verbs meet at comma, deshalb position 1, weil ↔ deshalb, wenn ≠ single past when), 9 words, context, 3 mistakes. | V1 two-clause diagram with "verbs meet at the comma" highlighted; cause→effect arrow pair. |
| **Indirekte Fragen: ob & W-Wort** · fillBlank · `quest_a2_2_indirekte_fragen` | 4 rules (W-word + verb end, ob, openers, politeness by wrapping), 9 words, context, 3 mistakes. | Wrapping animation: direct question slides inside "Können Sie mir sagen, …?" and the verb moves to the end (V1). B1.1/B2.1 versions should reference this (G6). |
| **Verben mit Präposition: worauf? darauf!** · fillBlank · `quest_a2_2_verben_praep_intro` | 4 rules (verb + preposition + case, auf vs über, wo(r)-, da(r)-), 12 words, context, 3 mistakes, 3×12 table. | V12 blocks wo + r + auf; V3 for sich freuen auf (future) vs über (now). |
| **Kurzcheck: Wo oder wohin?** · speaking · `quest_a2_2_sprechen_kurzcheck` | 2 rules. | V4 pocket card; G7 script. |
| **Körper & Gesundheit** · fillBlank · `quest_a2_2_gesundheit` | 4 rules (complaints, seit + dative, doctor's side, Praxis → Rezept → Apotheke), 14 words, context, 3 mistakes. | Body picture (reuse A1.2) with complaint phrases; V14 doctor script; three-step flow picture Praxis → Rezept → Apotheke. |
| **Kleidung & Einkaufen** · fillBlank · `quest_a2_2_kleidung` | 4 rules (passen/stehen dative, shop script, sizes/materials/zu, tragen/anziehen/anprobieren), 12 words, context, 3 mistakes. | Clothes picture with articles in colour; V14 shop script; zu klein / zu groß slider. |
| **Lesen: Beim Arzt** · reading · `quest_a2_2_lesen_arzt` | 4 rules. | V11 text map; words step. |
| **Imperativ** · fillBlank · `quest_a2_2_imperativ` | 4 rules (du stem + e→i, ihr and Sie, sein/haben, softeners), 10 words, context, 3 mistakes. | G6: open with "you know du/ihr/Sie from A1.2"; only the e→i cells glow (V13); softener ladder bitte/doch/mal (V10). |
| **Diktat: Beschreiben** · dictation · `quest_a2_2_diktat_alltag` | 3 rules. | Worked example; dem vs den minimal-pair audio card. |
| **Sprechen: Personen beschreiben** · speakRepeat · `quest_a2_2_sprechen_person` | 4 rules. | Picture of 3 people with adjective labels; V14. |
| **Adjektive vor dem Nomen: erste Begegnung** · fillBlank · `quest_a2_2_adjektiv_intro` | 4 rules (after ein adjective shows gender, after der just -e/-en, one strong signal, plural -en), 11 words, context, 3 mistakes, 3×12 table. | V2 grid Nom/Akk only, "signal moves from article to adjective" animation (der → ein + -er); this is the seed of B1.1's three lessons, say so. |
| **könnte, sollte** · fillBlank · `quest_a2_2_koennte_sollte` | 4 rules, 12 words, context, 3 mistakes, 2×6 table. | V10 tone ladder (musst → solltest → könntest); könnte ≠ konnte umlaut card; V1 bracket. |
| **Relativsätze: der, die, das (Nom/Akk)** · fillBlank · `quest_a2_2_relativ_intro` | 4 rules (pronoun = article, Nom vs Akk, comma + verb end, only den is new), 9 words, context, 3 mistakes. | V2 grid Nom/Akk with den glowing; V1 subordinate mode; noun → pronoun link arrow on one sentence. |
| **Präteritum: erste Schritte** · fillBlank · `quest_a2_2_praeteritum_intro` | 4 rules, 12 words, context, 3 mistakes, 2×12 table. | Fairy-tale book picture (where you meet it); V12 stem + te; V13 grid with ich = er marked. |
| **Passiv Präsens** · fillBlank · `quest_a2_2_passiv_intro` | 4 rules (werden + participle, von + dative, where you'll read it, become done), 10 words, context, 3 mistakes. | Sign pictures (Hier wird Deutsch gesprochen); active → passive object-becomes-subject arrow (V16); V1 bracket. |
| **Wortbildung: -er, -ung, un-, -los, -bar** · fillBlank · `quest_a2_2_wortbildung` | 4 rules, 11 words, context, 3 mistakes. | V12 blocks in gender colours (-er der, -ung die); un-/-los/-bar as prefix/suffix tiles on a stem. |
| **Superlativ** · fillBlank · `quest_a2_2_superlativ` | 4 rules (am -sten, irregulars + umlaut, before noun, three steps one ladder), 11 words, context, 4 mistakes. | Three-step podium picture (gut / besser / am besten); V12 stem + st + en. |
| **Wortstellung: Wann? Wie? Wo?** · fillBlank · `quest_a2_2_tekamolo` | 4 rules (time manner place, place next to verb, time first, Te-Ka-Mo-Lo), 9 words, context, 3 mistakes. | V1 Mittelfeld with three coloured slots (when/how/where) and the sentence tiles dropping into them. |
| **Lesen: Eine E-Mail** · reading · `quest_a2_2_lesen_email` | 3 rules. | V11 e-mail frame map; words step. |
| **Lesen: Formular & Anmeldung** · reading · `quest_a2_2_lesen_formular` | 3 rules (fields, dates, payment). | Show a form picture with fields labelled in English (Nachname, Vorname, Geb.-Datum, PLZ); date format card 03.10.2026. |
| **Gespräch: Beschreiben & Planen** · speaking · `quest_a2_2_sprechen_dialog` | 3 rules. | V14; V1 TeKaMoLo pocket card. |
| **Genitiv-s und Datum** · fillBlank · `quest_a2_2_genitiv_s_datum` | 5 rules, 10 words, context, 4 mistakes, 3×8 table. | Calendar page picture (der 3. Oktober / am dritten); apostrophe-crossed-out card (Annas, not Anna's). |
| **Schreiben: E-Mail-Bausteine** · fillBlank · `quest_a2_2_schreiben_email` | 5 rules (frame, opening, content moves, closing, answer every point), 11 words, context, 4 mistakes, 3×7 table. | V20 e-mail block diagram with the Redemittel in each block, du/Sie toggle. |
| **Schreiben: Einladung & Plan** · writing · `quest_a2_2_schreiben_einladung` | 3 rules, 9 words, 4 mistakes. | Model invitation with V11 labels (what · when · where · why · ask back). |
| **Wortschatz** · vocabulary · `quest_a2_2_wortschatz` | 3 generic rules. | G4. |
| **Suchbild: Das Kinderzimmer** · suchbild · `quest_a2_2_suchbild_kinderzimmer` | 3 rules, 32 words. | G5. |
| **Suchbild: Das Café** · suchbild · `quest_a2_2_suchbild_cafe` | 3 rules, 32 words. | G5. |

---

## 7. B1.1 — 34 lessons

| Exercise | What the lesson has | What would make it teach better |
|---|---|---|
| **Die Welt der Arbeit** · fillBlank · `quest_b1_1_arbeit` | 4 rules (finding a job, contract and money, people and the day, Feierabend), 16 words, context, 4 mistakes. | Job-application flow picture (Anzeige → Bewerbung → Gespräch → Vertrag); word-family card arbeiten / Arbeit / Arbeitgeber / Arbeitnehmer (V12). |
| **Adjektivendungen: bestimmter Artikel** · fillBlank · `quest_b1_1_adj_bestimmt` | 4 rules (-e in five slots, the -e block, plural -en, dieser/jeder/welcher), 12 words, context, 3 mistakes, authored 4×4 table. | V2 grid with the five -e cells as one glowing block (the lesson's own image); G6 link back to A2.2 adjektiv_intro. |
| **Sprechen: Höfliche Bitten** · speakRepeat · `quest_b1_1_sprechen_bitten` | 3 rules (five openers, answering, umlaut is the politeness). | V14 office script; V10 politeness ladder; V6 umlaut card. |
| **Adjektivendungen: unbestimmter Artikel** · fillBlank · `quest_b1_1_adj_unbestimmt` | 4 rules (three repairs -er/-es/-es, else like der, kein-/possessives, er-es-es), 10 words, context, 3 mistakes, 4×4 table. | V2 grid with the three "repair" cells glowing and the rest grey; animation "ein has no ending → adjective takes it". |
| **Großer Text: Meine neue Wohnung** · reading(inline) · `quest_b1_1_bigtext_wohnung` | 3 rules (three questions per gap, prepositions decide case, no article → der-ending). | V5 three-question tree for every gap (case? gender? article type?); V11 passage map; flat picture as hook. |
| **Adjektivendungen ohne Artikel** · fillBlank · `quest_b1_1_adj_nullartikel` | 4 rules (adjective wears the article's ending, where Nullartikel lives, dative plural, cut the d-), 12 words, context, 4 mistakes, 4×4 table. | V2 grid comparing der-row and adjective-row side by side (d-em → -em); menu/headline/ad pictures as "where it lives". |
| **Komparativ & Superlativ vor dem Nomen** · fillBlank · `quest_b1_1_adj_komparativ` | 4 rules, 12 words, context, 3 mistakes, 4×4 table. | V12 blocks stem + er + ending (billig·er·e); podium picture reused from A2.2. |
| **Adjektive und Partizipien als Nomen** · fillBlank · `quest_b1_1_adjektive_als_nomen` | 4 rules (capital + adjective ending, men/women/plural, das Gute/etwas Neues, imagine a noun behind), 12 words, context, 3 mistakes, 4×4 table. | "Ghost noun" picture: der Deutsche (Mann) with the invisible noun faded; V2 grid. |
| **Konjunktiv II: würde + Infinitiv** · fillBlank · `quest_b1_1_konj2_wuerde` | 4 rules (würde + infinitive end, four uses, standard not lazy, gern + würde), 10 words, context, 3 mistakes. | V1 bracket; four-use card with icons (wish, advice, polite ask, what-if). |
| **Hören: Vorstellungsgespräch** · listening · `quest_b1_1_hoeren_interview` | 3 rules (interview script, weil/deshalb, numbers alike). | V11 interview script map; words step; numbers minimal-pair audio (14/40, 17/70). |
| **Konjunktiv II: hätte / wäre / könnte** · fillBlank · `quest_b1_1_konj2_haette` | 4 rules (Präteritum + umlaut, unreal condition, wish with nur/doch, umlaut six), 10 words, context, 3 mistakes, 6×4 table. | V12 transformation hatte → hätte (umlaut tile drops in); V13 grid; wenn-sentence V1 two-clause diagram. |
| **Lesen: Die Zukunft der Arbeit** · reading · `quest_b1_1_lesen_arbeit` | 3 rules (shape of an opinion text, weil, exaggerations). | V20 opinion-text shape over the real text; words step. |
| **Kurzcheck: Konjunktiv II** · speaking · `quest_b1_1_sprechen_kurzcheck` | 2 rules. | G7 script; umlaut-six pocket card. |
| **Futur I** · fillBlank · `quest_b1_1_futur` | 4 rules (werden + infinitive, when vs present, wohl = probably, three hats), 11 words, context, 3 mistakes. | "werden has three hats" as a three-panel picture (become / will / passive helper); V3 timeline; V1 bracket. |
| **Relativsätze (Nom./Akk.)** · fillBlank · `quest_b1_1_relativ` | 4 rules (case from inside, clause in the middle, Perfekt/modals inside, Nom = article Akk except den), 10 words, context, 3 mistakes. | V1 nested bracket (main clause with the relative clause boxed inside and the main verb waiting); G6 link to A2.2. |
| **Relativsätze mit Dativ & Präposition** · fillBlank · `quest_b1_1_relativ_praep` | 4 rules (dem/der/dem/denen, preposition first, wo, denen is new), context, 3 mistakes, 4×3 table. | V2 grid with denen glowing; English dangling preposition crossed out vs German fronted (two-line contrast). |
| **Diktat: Wünsche & Bitten** · dictation · `quest_b1_1_diktat_konjunktiv` | 3 rules. | hatte/hätte minimal-pair audio; worked example. |
| **Genitiv** · fillBlank · `quest_b1_1_genitiv` | 4 rules (des -(e)s / der, names -s, von in speech, wegen/während/trotz), 11 words, context, 3 mistakes, 4×3 table. | V2 grid Gen row glows (table complete at last: celebrate the full 4×4); ownership arrow picture (das Auto des Mannes). |
| **Sprechen: Meinung äußern** · speakRepeat · `quest_b1_1_sprechen_meinung` | 3 rules (open, agree/disagree/weigh, opinion + weil). | V20 opinion move blocks with phrases; V14. |
| **Nebensätze: wenn / als / obwohl** · fillBlank · `quest_b1_1_konjunktionen` | 4 rules (als once past, wenn whenever/if/future, obwohl = trotzdem, snapshot), 10 words, context, 3 mistakes. | V3 timeline: als as a single past dot, wenn as repeated dots and future; V5 tree for English "when". |
| **Infinitiv mit zu** · fillBlank · `quest_b1_1_infinitiv_zu` | 4 rules (zu + infinitive end, triggers, no zu after modals, um…zu / brauchen nicht zu), 12 words, context, 3 mistakes. | V1 bracket with zu slot; separable split auf·zu·stehen as V12 blocks; "no zu" verb list card. |
| **es-Ausdrücke** · fillBlank · `quest_b1_1_es` | 4 rules (es gibt + Akk, feelings with dative, evaluations, which es drops), context, 3 mistakes. | Chunk cards with pictures (mir ist kalt = shivering figure); droppable-es animation (Kalt ist mir). |
| **Hören: Radio-Umfrage** · listening · `quest_b1_1_hoeren_umfrage` | 3 rules (one keyword per speaker, würde gern aber, frequency words). | V11 three-speaker lanes; frequency scale (nie → immer) as V17 bar. |
| **Lesen: Im Ausland studieren** · reading · `quest_b1_1_lesen_studium` | 3 rules. | V20 balanced-text shape; genitive chain highlighted in the text. |
| **Schreiben: Die E-Mail formell & informell** · fillBlank · `quest_b1_1_email_redemittel` | 4 rules (formal frame, informal frame, three points, never mix), 10 words, context, 3 mistakes, 3×7 table. | V20 two-column e-mail (formal left, informal right) with a register toggle; G6 link to A2.2 Bausteine. |
| **Schreiben: Eine formelle E-Mail** · writing · `quest_b1_1_schreiben_email` | 3 rules, 10 words, 4 mistakes. | Model formal e-mail with V11 labels; V10 register ladder for 5 verbs. |
| **Gespräch: Meinungen & Wünsche** · speaking · `quest_b1_1_sprechen_dialog` | 3 rules. | V14; V20 moves. |
| **Verben mit Präpositionen: worauf? – darauf!** · fillBlank · `quest_b1_1_verben_praep` | 4 rules, 10 words, context, 3 mistakes, 3×7 table. | G6: "you met wo(r)-/da(r)- at A2.2"; da- pointing-back arrow across two sentences; the 3×7 table is good. |
| **Indirekte Fragen** · fillBlank · `quest_b1_1_indirekte_fragen` | 4 rules, 10 words, context, 3 mistakes, 2×5 table. | G6: near-duplicate of A2.2; make this the "with separable verbs, modals and Perfekt" extension and say so; V1 wrapping animation. |
| **falls, da, trotzdem** · fillBlank · `quest_b1_1_falls_da_trotzdem` | 4 rules (falls, da, obwohl ↔ trotzdem / weil ↔ deshalb, look at the verb), 10 words, context, 3 mistakes, 3×3 table. | Two-column "verb last / verb second" twin cards with V1 mini brackets. |
| **Wortschatz** · vocabulary · `quest_b1_1_wortschatz` | 3 generic rules. | G4. |
| **Suchbild: Das Büro** · suchbild · `quest_b1_1_suchbild_buero` | 3 rules, 32 words. | G5. |
| **Suchbild: Die Arztpraxis** · suchbild · `quest_b1_1_suchbild_arztpraxis` | 3 rules, 32 words. | G5. |

---

## 8. B1.2 — 35 lessons

| Exercise | What the lesson has | What would make it teach better |
|---|---|---|
| **Technik & Medien** · fillBlank · `quest_b1_2_technik` | 4 rules (separable verbs, nouns and genders, problems and fixes, herunter/hoch), 14 words, context, 3 mistakes. | Phone/laptop picture with labelled parts and verbs (herunterladen arrow down, hochladen arrow up); V1 for the separable verbs. |
| **Präteritum: regelmäßig** · fillBlank · `quest_b1_2_praet_reg` | 4 rules (stem + te + ending, -ete, write vs say, ich = er), 12 words, context, 3 mistakes. | V12 blocks kauf + te + st; V13 grid; "written vs spoken" two-register picture (book vs speech bubble). |
| **Präteritum: unregelmäßig** · fillBlank · `quest_b1_2_praet_unreg` | 4 rules (vowel change no -te, vowel families, unique ones, learn the triple), 15 words, context, 3 mistakes. | Authored vowel-family table (ei→ie→ie, i→a→u, e→a→o…) with colour per family (G3); "sing the middle" audio triples. |
| **Präteritum: Mischverben** · fillBlank · `quest_b1_2_praet_misch` | 4 rules, 10 words, context, 4 mistakes, authored 3×9 table. | Good table. Add V12 blocks showing new vowel + te; -ennen quartet card. |
| **Plusquamperfekt** · fillBlank · `quest_b1_2_plusquamperfekt` | 4 rules (hatte/war + P II, nachdem, schon/bereits, two steps back), 10 words, context, 3 mistakes, 3×5 table. | V3 timeline with two past points labelled (train left → I arrived → now); V1 bracket with hatte … abgefahren. |
| **Temporalsätze** · fillBlank · `quest_b1_2_temporalsaetze` | 4 rules (nachdem/bevor/bis/während, seit(dem), als/wenn/sobald, preposition twin), 10 words, context, 4 mistakes. | V3 timeline with each conjunction as a shape (bevor arrow left, nachdem arrow right, während overlapping bar, bis stop line). |
| **Großer Text: Der kleine Ritter** · reading(inline) · `quest_b1_2_bigtext_ritter` | 3 rules (regular/irregular/mixed decide then form, subject decides ending, narrative skeleton). | V5 tree for each gap; story skeleton (Es war einmal … → Eines Tages … → Am Ende …) as V11; knight scene picture (exists). |
| **Sprechen: Eine Geschichte erzählen** · speakRepeat · `quest_b1_2_sprechen_geschichte` | 3 rules. | Story arc diagram (hook → events → turn → point) with signpost phrases; V14. |
| **Passiv (Präsens)** · fillBlank · `quest_b1_2_passiv` | 4 rules (werden + P II, object → subject, von/durch, man ↔ passive), 10 words, context, 3 mistakes. | G6: "A2.2 showed you this; new: the transformation"; V16 active → passive arrows; von (person) vs durch (means) icon pair. |
| **Hören: Eine Durchsage** · listening · `quest_b1_2_hoeren_durchsage` | 3 rules. | V11 announcement template; station sign picture; words step. |
| **Passiv (Präteritum)** · fillBlank · `quest_b1_2_passiv_praet` | 4 rules (wurde + P II, ist … worden, history verbs, wurde = -te of werden), 10 words, context, 3 mistakes. | V3 timeline with history facts (wurde gegründet 1810); V1 bracket. |
| **Passiv mit Modalverb & Passiv Perfekt** · fillBlank · `quest_b1_2_passiv_modal_intro` | 4 rules, context, 3 mistakes; no words. | Add 10 words; V1 bracket with three end slots (P II + werden + modal) — the stacked verb end is the hard part and wants a picture; sign pictures. |
| **Kurzcheck: Präteritum** · speaking · `quest_b1_2_sprechen_kurzcheck` | 2 rules. | G7 script; process-description picture (recipe steps) for the passive half. |
| **n-Deklination** · fillBlank · `quest_b1_2_n_deklination` | 4 rules, 12 words, context, 3 mistakes, 5×4 table. | V2 grid with -n cells glowing for one noun; membership card (who belongs) with icons for people/animals. |
| **Lesen: Ein Missgeschick** · reading · `quest_b1_2_lesen_technik` | 3 rules (problem → solution → lesson, Plusquamperfekt, passive). | V11 story map; V3 timeline of the mishap. |
| **Infinitivsätze: um/ohne/statt … zu** · fillBlank · `quest_b1_2_infinitiv` | 4 rules, 10 words, context, 3 mistakes. | Three icons (target, crossed-out, swap) for um/ohne/statt; V5 same subject → infinitive, else dass. |
| **damit oder um … zu?** · fillBlank · `quest_b1_2_damit_umzu` | 4 rules (count the subjects, damit full clause, um…zu, so that vs in order to), context, 3 mistakes; no words. | V5 tree is the whole lesson; two-figure picture (one person = um zu, two people = damit); add words. |
| **indem & sodass** · fillBlank · `quest_b1_2_indem_sodass` | 4 rules, context, 3 mistakes; no words. | Means → result arrow picture (indem on the arrow, sodass at the result); add words. |
| **Diktat: Eine kleine Geschichte** · dictation · `quest_b1_2_diktat_praeteritum` | 3 rules. | Worked example; vowel-family audio. |
| **Relativsätze (Dativ/Genitiv)** · fillBlank · `quest_b1_2_relativ_dat` | 4 rules (dessen/deren, dem/der/dem/denen, preposition leads, three new words), 10 words, context, 3 mistakes, 4×4 table. | V2 full relative-pronoun grid with the three new cells glowing (G6 across A2.2 → B1.1 → here). |
| **Zweiteilige Konnektoren** · fillBlank · `quest_b1_2_konnektoren_zweiteilig` | 4 rules (six pairs, je … desto, weder noch, zwar aber), context, 3 mistakes; no words. | Pair cards joined by a bridge graphic; je/desto V1 two-clause diagram; add words. |
| **Irreale Wünsche** · fillBlank · `quest_b1_2_irreale_wuensche` | 4 rules, 8 words, context, 3 mistakes. | V3 timeline with the regret arrow pointing back; sigh cartoon; V1 verb-first vs wenn shapes. |
| **trotz, wegen, während + Genitiv** · fillBlank · `quest_b1_2_trotz_wegen` | 4 rules, 10 words, context, 3 mistakes. | V16 clause ↔ phrase pairs (weil es regnet ↔ wegen des Regens); V2 Gen row. |
| **Partizip I & II als Adjektiv** · fillBlank · `quest_b1_2_partizip_adj_intro` | 4 rules (-end active now, P II passive done, kochend vs gekocht, -end = -ing), context, 3 mistakes; no words. | Two-panel picture: boiling water (kochend) vs cooked egg (gekocht); V12 blocks; add words. |
| **Sprechen: Etwas begründen** · speakRepeat · `quest_b1_2_sprechen_begruenden` | 3 rules. | Reason-frame wheel (weil / deshalb / um zu / das liegt daran, dass) to rotate; V14. |
| **Modalpartikeln: denn, doch, eigentlich, ja, mal** · fillBlank · `quest_b1_2_modalpartikeln_intro` | 4 rules, context, 3 mistakes; no words. | Tone cards: same sentence with/without the particle and a face icon for the tone; audio pairs; add words. |
| **Hören: Podcast** · listening · `quest_b1_2_hoeren_podcast` | 3 rules. | V11 podcast map (topic · tip · number · teaser); words step. |
| **Wortbildung: -heit, -keit, -ung, -schaft…** · fillBlank · `quest_b1_2_wortbildung` | 4 rules, 12 words, context, 3 mistakes, 4×7 table. | V12 blocks in gender colours; "die-quartet" badge. |
| **Lesen: Eine wahre Anekdote** · reading · `quest_b1_2_lesen_anekdote` | 3 rules. | V11 story map; words step. |
| **Gespräch: Erzählen & Begründen** · speaking · `quest_b1_2_sprechen_dialog` | 3 rules. | V14. |
| **Schreiben: Etwas ist schiefgegangen** · writing · `quest_b1_2_schreiben_geschichte` | 3 rules, 7 words, 4 mistakes. | Story arc with the "turn"; V3 tense mix diagram (Perfekt line, Plusquamperfekt dip). |
| **Zustandspassiv** · fillBlank · `quest_b1_2_zustandspassiv` | 4 rules, 10 words, context, 3 mistakes, 3×4 table. | Two-frame picture: door closing (wird geschlossen) / door closed (ist geschlossen); Geschlossen sign. |
| **Wortschatz** · vocabulary · `quest_b1_2_wortschatz` | 3 generic rules. | G4. |
| **Suchbild: Die Garage** · suchbild · `quest_b1_2_suchbild_garage` | 3 rules, 32 words. | G5. |
| **Suchbild: Der Park** · suchbild · `quest_b1_2_suchbild_park` | 3 rules, 32 words. | G5. |

---

## 9. B2.1 — 37 lessons

| Exercise | What the lesson has | What would make it teach better |
|---|---|---|
| **Gesellschaft & Politik** · fillBlank · `quest_b2_1_gesellschaft` | 4 rules (state and its verbs, economy, voices in a debate, -ung/-heit), 22 words, context, 3 mistakes. | Institutions diagram (Bundestag → Gesetz → Bürger) with the verbs on the arrows; V12 suffix colours. |
| **Konjunktiv I: indirekte Rede** · fillBlank · `quest_b2_1_konj1` | 4 rules (stem + e, sein/haben, clash → K II, drop the -t), 13 words, context, 3 mistakes, 6×5 table. | Newspaper picture with a quote and its reported form side by side (V16); V13 grid with the usable K I cells green and the clash cells red → K II. |
| **Großer Text: Die Pressekonferenz** · reading(inline) · `quest_b2_1_bigtext_presse` | 3 rules. | V11 passage map: indicative frame vs Konjunktiv body coloured; minister scene picture. |
| **Sprechen: Meinung verteidigen** · speakRepeat · `quest_b2_1_sprechen_verteidigen` | 3 rules. | V20 concede → contrast → reassert blocks; V14. |
| **Indirekte Fragen** · fillBlank · `quest_b2_1_indirekt_fragen` | 4 rules, 10 words, context, 3 mistakes. | G6: third indirect-question lesson; make it explicitly "reported questions in Konjunktiv I" and open with what is new; V16 direct ↔ reported. |
| **Indirekte Rede: Vergangenheit, Fragen, Bitten** · fillBlank · `quest_b2_1_konj1_vergangenheit` | 4 rules, 10 words, context, 3 mistakes. | V3 timeline mapping three past tenses → one reported form (habe/sei + P II); V16 pairs. |
| **Modalpassiv** · fillBlank · `quest_b2_1_modalpassiv` | 4 rules, 10 words, context, 3 mistakes, 2×5 table. | V1 bracket with stacked end slot (P II + werden + modal), tense toggle; form picture (Das Formular muss ausgefüllt werden). |
| **Hören: Eine Debatte** · listening · `quest_b2_1_hoeren_debatte` | 3 rules. | V11 three-lane debate map (Befürworter / Gegner / Moderator) with the moves; words step. |
| **Verben mit Präposition** · fillBlank · `quest_b2_1_verben_praep` | 4 rules, 14 words, context, 3 mistakes. | G6 link to A2.2/B1.1; authored table grouped by preposition (G3); auf-future vs über-present V3. |
| **Adjektive mit Präposition** · fillBlank · `quest_b2_1_adjektive_praep` | 4 rules, 11 words, context, 3 mistakes. | Authored table by preposition; "verb and adjective differ" contrast card (sich interessieren für / interessiert an). |
| **Nomen mit Präposition** · fillBlank · `quest_b2_1_nomen_praep` | 4 rules, 10 words, context, 3 mistakes. | Verb → noun → preposition change table (sich fürchten vor → Angst vor; hoffen auf → Hoffnung auf) as V16. |
| **Kurzcheck: Konjunktiv I** · speaking · `quest_b2_1_sprechen_kurzcheck` | 3 rules. | G7 script. |
| **Partizip als Adjektiv: Relativsatz ↔ Attribut** · fillBlank · `quest_b2_1_partizip_adj` | 5 rules, 11 words, context, 3 mistakes. | V16 fold/unfold animation (der Zug, der um acht ankommt ↔ der um acht ankommende Zug) with colour-linked parts; this is the lesson's core and currently prose only. |
| **Lesen: Pro & Contra Homeoffice** · reading · `quest_b2_1_lesen_homeoffice` | 3 rules. | V20 Stellungnahme shape over the text; jedoch/allerdings turn markers highlighted. |
| **Konnektoren** · fillBlank · `quest_b2_1_konnektoren` | 4 rules, 10 words, context, 3 mistakes, 3×5 table. | Twin-column V1 mini brackets (adverb verb 2nd / conjunction verb last) per relation; V10 register ladder. |
| **Mittelfeld: TeKaMoLo & Objektstellung** · fillBlank · `quest_b2_1_mittelfeld` | 4 rules, 10 words, context, 3 mistakes, 3×3 table. | V1 Mittelfeld with slots for pronouns → Te → Ka → Mo → Lo → noun objects, tiles dropping in; nicht's two landing spots. |
| **Kausal: verbal ↔ nominal** · fillBlank · `quest_b2_1_kausal_nominal` | 4 rules, 10 words, context, 3 mistakes, 3×5 table. | V16 pairs with colour-linked parts; aus vs vor icon pair (motive vs reaction). |
| **Temporal: verbal ↔ nominal** · fillBlank · `quest_b2_1_temporal_nominal` | 4 rules, 11 words, context, 3 mistakes, 2×7 table. | V16 pairs; V3 for bei/nach/vor/während. |
| **dass-Satz ↔ Infinitiv mit zu** · fillBlank · `quest_b2_1_dass_infinitiv` | 4 rules, 10 words, context, 3 mistakes. | V5 tree (same subject? object = subject? → infinitive); V16 pairs. |
| **lassen & Doppelinfinitiv** · fillBlank · `quest_b2_1_lassen` | 4 rules, 10 words, context, 3 mistakes. | Three-meaning picture (have done / let / can be); V1 bracket with the double infinitive end. |
| **Nachsilben & Genus** · fillBlank · `quest_b2_1_nachsilben_genus` | 4 rules, 11 words, context, 3 mistakes, 3×6 table. | V12 suffix tiles sorted into three coloured bins; exceptions ribbon. |
| **Diktat: Argumentieren** · dictation · `quest_b2_1_diktat_argument` | 3 rules. | Worked example; sei/habe quiet -e audio card. |
| **Passiv Perfekt** · fillBlank · `quest_b2_1_passiv_perfekt` | 4 rules, 10 words, context, 3 mistakes. | V1 bracket with ist … worden; V3 written wurde vs spoken ist worden as register, not time. |
| **Zustandspassiv: ist geöffnet vs wird geöffnet** · fillBlank · `quest_b2_1_zustandspassiv` | 4 rules, 10 words, context, 3 mistakes, 3×4 table. | G6: B1.2 taught this; reuse the door picture and add only past tense + von/durch. |
| **Subjektlose Passivsätze** · fillBlank · `quest_b2_1_passiv_subjektlos` | 4 rules, 10 words, context, 3 mistakes. | Party picture (Es wird getanzt); V16 man-sentence → es-passive. |
| **Hören: Nachrichten** · listening · `quest_b2_1_hoeren_nachrichten` | 3 rules. | V11 bulletin map (4 stories × event/detail/quote/reaction); steigen/sinken arrows. |
| **Sprechen: Ein Argument präsentieren** · speakRepeat · `quest_b2_1_sprechen_argument` | 3 rules. | V20 talk blocks; V14. |
| **Lesen: Leserbrief** · reading · `quest_b2_1_lesen_leserbrief` | 3 rules. | V20 Leserbrief moves over the text. |
| **Schreiben: Stellungnahme & Leserbrief** · fillBlank · `quest_b2_1_stellungnahme` | 4 rules, 10 words, context, 3 mistakes, 2×8 table. | V20 five-block shape with Redemittel per block; "Leserbrief = Stellungnahme + envelope" picture. |
| **Gespräch: Argumentieren** · speaking · `quest_b2_1_sprechen_dialog` | 3 rules. | V14; V20. |
| **Schreiben: Stellungnahme** · writing · `quest_b2_1_schreiben_stellungnahme` | 3 rules, 9 words, 4 mistakes. | Model text with V20 labels. |
| **um/ohne/statt … zu oder dass?** · fillBlank · `quest_b2_1_infinitivsaetze` | 4 rules, 10 words, context, 3 mistakes, 3×3 table. | G6: B1.2 damit/um zu; V5 tree; two-figure picture. |
| **nicht / nur brauchen + zu** · fillBlank · `quest_b2_1_brauchen_zu` | 4 rules, 9 words, context, 3 mistakes, 3×5 table. | Three-way card nicht müssen = nicht brauchen ≠ nicht dürfen with a no-entry icon only on dürfen. |
| **je … desto / umso** · fillBlank · `quest_b2_1_je_desto` | 4 rules, 9 words, context, 3 mistakes, 3×4 table. | Two rising lines graph (the longer → the harder); V1 two-clause diagram. |
| **Wortschatz** · vocabulary · `quest_b2_1_wortschatz` | 3 generic rules. | G4. |
| **Suchbild: Die Hotelrezeption** · suchbild · `quest_b2_1_suchbild_hotel` | 3 rules, 32 words. | G5. |
| **Suchbild: Die Baustelle** · suchbild · `quest_b2_1_suchbild_baustelle` | 3 rules, 32 words. | G5. |

---

## 10. B2.2 — 38 lessons

| Exercise | What the lesson has | What would make it teach better |
|---|---|---|
| **Wissenschaft & Umwelt** · fillBlank · `quest_b2_2_umwelt` | 4 rules (problem, response, science, verb + noun pairs), 15 words, context, 3 mistakes. | Problem → response diagram with the collocations on arrows (Müll → trennen, Energie → sparen); earth/recycling picture. |
| **Konjunktiv II der Vergangenheit** · fillBlank · `quest_b2_2_konj2_verg` | 4 rules, 9 words, context, 3 mistakes, 4×5 table. | V3 timeline with the "what did not happen" ghost branch; V1 bracket with hätte … machen können. |
| **Irreale Bedingungssätze** · fillBlank · `quest_b2_2_irreal` | 4 rules, 8 words, context, 3 mistakes. | V5 real/unreal tree ("could it still happen?"); V3 present vs past unreal. |
| **Irreale Vergleiche: als ob** · fillBlank · `quest_b2_2_als_ob` | 4 rules, 9 words, context, 3 mistakes. | Cartoon of pretending (als wäre er der Chef); V1 als ob (verb last) vs als (verb second). |
| **Großer Text: Verpasste Chancen** · reading(inline) · `quest_b2_2_bigtext_chancen` | 3 rules. | V11 passage map; V3 "the turn back to reality". |
| **Sprechen: Hypothesen & Bedauern** · speakRepeat · `quest_b2_2_sprechen_hypothese` | 3 rules. | Frame cards; pause-at-comma rhythm marks; V14. |
| **Futur II** · fillBlank · `quest_b2_2_futur2` | 4 rules, 9 words, context, 3 mistakes. | V3 timeline with two uses (guess about past; done by deadline); V17 certainty bar. |
| **Genitivpräpositionen** · fillBlank · `quest_b2_2_genitiv_praep` | 4 rules, 11 words, context, 3 mistakes, 3×12 table. | Icons per preposition on the table; V16 clause twins. |
| **Hören: Ein Vortrag** · listening · `quest_b2_2_hoeren_vortrag` | 3 rules. | V11 lecture moves map; words step. |
| **Erweitertes Partizipialattribut** · fillBlank · `quest_b2_2_partizip_attribut` | 4 rules, 9 words, context, 3 mistakes. | V16 fold/unfold with the bracket "Article … [complements] … participle+ending … noun" drawn; G6 link to B2.1 partizip_adj. |
| **Kurzcheck: Irreale Vergangenheit** · speaking · `quest_b2_2_sprechen_kurzcheck` | 2 rules. | G7 script. |
| **Modalpartikeln** · fillBlank · `quest_b2_2_modalpartikeln` | 4 rules, 9 words, context, 3 mistakes, 3×9 table. | Tone cards with face icons + audio pairs; G6 link to B1.2. |
| **Lesen: Klimawandel** · reading · `quest_b2_2_lesen_klima` | 3 rules. | V11 text map with "others say / author says" colouring; Doch as the hinge marker. |
| **Funktionsverbgefüge** · fillBlank · `quest_b2_2_fvg` | 4 rules, 12 words, context, 3 mistakes, 2×10 table. | "Noun carries meaning, verb carries grammar" weight picture; V10 register ladder (entscheiden → eine Entscheidung treffen). |
| **Verweiswörter & Textkohäsion** · fillBlank · `quest_b2_2_verweiswoerter` | 4 rules, 10 words, context, 3 mistakes, 2×4 table. | Backward-arrow diagram over a short paragraph (each pointer to its referent). |
| **Nominalisierung: die sechs Typen** · fillBlank · `quest_b2_2_nominalisierung_intro` | 4 rules, 11 words, context, 3 mistakes, 4×6 table. | V12 six block types from one verb (laufen → der Lauf, das Laufen, der Läufer…) in gender colours. |
| **Adjektivbildung** · fillBlank · `quest_b2_2_adjektivbildung` | 4 rules, 11 words, context, 3 mistakes, 3×9 table. | V12 suffix tiles; -reich/-arm/-los/-voll as a fill-level icon set. |
| **Diktat: Hypothesen** · dictation · `quest_b2_2_diktat_irreal` | 3 rules. | Worked example. |
| **Konzessivsätze** · fillBlank · `quest_b2_2_konzessiv` | 4 rules, 9 words, context, 3 mistakes, 3×5 table. | Five-way card with V1 mini brackets per type; V10 register (obwohl → wenngleich). |
| **Konditional: verbal ↔ nominal** · fillBlank · `quest_b2_2_konditional_nominal` | 4 rules, 9 words, context, 3 mistakes, 2×6 table. | V16 pairs; sign pictures (bei Regen, ohne Anmeldung). |
| **Konsekutiv & modal: verbal ↔ nominal** · fillBlank · `quest_b2_2_konsekutiv_modal_nominal` | 4 rules, 9 words, context, 3 mistakes, 3×3 table. | V16 pairs. |
| **Adversativ** · fillBlank · `quest_b2_2_adversativ` | 4 rules, 9 words, context, 3 mistakes, 3×3 table. | Two-panel contrast picture (north wet / south dry) with the connectors; contrast ≠ concession card. |
| **Hören: Fachinterview** · listening · `quest_b2_2_hoeren_fachinterview` | 3 rules. | V11 expert-moves map; "exaggeration trap" card. |
| **Subjektives sollen** · fillBlank · `quest_b2_2_sollen_subjektiv` | 4 rules, 9 words, context, 3 mistakes. | Rumour picture (crowd whispering = soll; speaker pointing at self = will); V17. |
| **Passiversatz: -bar, sich lassen, sein + zu** · fillBlank · `quest_b2_2_passiversatz_intro` | 4 rules, 10 words, context, 3 mistakes, 3×4 table. | "Four ways, one meaning" hub diagram with kann … werden in the centre. |
| **Relativsätze mit wer, was, wo** · fillBlank · `quest_b2_2_relativ_wer_was` | 4 rules, 9 words, context, 3 mistakes. | Proverb picture (Wer rastet, der rostet); was-trigger list card (alles, nichts, etwas, das, superlatives). |
| **Indefinitpronomen** · fillBlank · `quest_b2_2_indefinit` | 4 rules, 9 words, context, 3 mistakes, 4×6 table. | G6 link to A2.1; V2 grid for einer/keiner/welche. |
| **Sprechen: Einräumen & widersprechen** · speakRepeat · `quest_b2_2_sprechen_einraeumen` | 3 rules. | V20 concede → pivot blocks; V14. |
| **Lesen: Eine Buchrezension** · reading · `quest_b2_2_lesen_rezension` | 3 rules. | V20 review moves over the text. |
| **Lesen: Sprachbausteine** · reading · `quest_b2_2_lesen_textergaenzung` | 4 rules. | V5 "which relation does the gap carry?" tree; worked gap example. |
| **Gespräch: Differenzieren** · speaking · `quest_b2_2_sprechen_dialog` | 3 rules. | V14; V20. |
| **Schreiben: Beschwerde mit Zugeständnis** · writing · `quest_b2_2_schreiben_beschwerde` | 3 rules, 8 words, 4 mistakes. | Model complaint with V20 labels (concede · facts · demand · deadline). |
| **Relativsätze: dessen, deren, Präposition + Relativpronomen** · fillBlank · `quest_b2_2_relativ_dessen_deren` | 4 rules, 9 words, context, 3 mistakes, 5×4 table. | G6: fourth relative lesson; V2 grid with only dessen/deren new; "turn the English round" V16. |
| **Futur I: Vermutungen** · fillBlank · `quest_b2_2_futur1_vermutung` | 4 rules, 9 words, context, 3 mistakes, 3×4 table. | V17 certainty bar (wohl / sicher / bestimmt); doorbell cartoon (Das wird der Paketbote sein). |
| **Konjunktiv II der Gegenwart** · fillBlank · `quest_b2_2_konj2_gegenwart` | 4 rules, 10 words, context, 3 mistakes, 3×11 table. | G6: B1.1 taught hätte/wäre/würde; make this the "one-word forms" extension (käme, ginge, wüsste) and glow only those. |
| **Wortschatz** · vocabulary · `quest_b2_2_wortschatz` | 3 generic rules. | G4. |
| **Suchbild: Die Öko-Wohnung** · suchbild · `quest_b2_2_suchbild` | 3 rules, 32 words. | G5. |
| **Suchbild: Das Labor** · suchbild · `quest_b2_2_suchbild_labor` | 3 rules, 32 words. | G5. |

---

## 11. C1.1 — 34 lessons

| Exercise | What the lesson has | What would make it teach better |
|---|---|---|
| **Bildung & Wissenschaft** · fillBlank · `quest_c1_1_bildung` | 4 rules (research cycle, claim strength, institutions, -ung/-nis), 22 words, context, 3 mistakes. | Research-cycle wheel (Annahme → Erhebung → Auswertung → Nachweis) with the verbs; V17 claim-strength scale (vermuten → belegen → beweisen). |
| **Nominalisierung** · fillBlank · `quest_c1_1_nominalisierung` | 4 rules (subject → genitive, adverb → adjective, which noun, five moves), 12 words, context, 3 mistakes. | V16 five-move animation on one clause with colour-linked parts; G6 link to B2.2 six types. |
| **Sprechen: Strukturiert darstellen** · speakRepeat · `quest_c1_1_sprechen_darstellen` | 3 rules. | V20 talk skeleton; V14. |
| **Verbalisierung** · fillBlank · `quest_c1_1_verbalisierung` | 4 rules (preposition → conjunction map, restore subject and tense, verb from noun, verbal vs nominal), 11 words, context, 3 mistakes. | V16 in reverse (phrase → clause); authored preposition ↔ conjunction map table (G3). |
| **Tempuswahl** · fillBlank · `quest_c1_1_tempuswahl` | 4 rules, 10 words, context, 3 mistakes, 3×6 table. | V3 full tense timeline (Plusquamperfekt – Präteritum – Perfekt – Präsens – Futur I – Futur II) with the function of each; narrative-line diagram with the Präsens "jump" marked. |
| **Passiversatz** · fillBlank · `quest_c1_1_passiversatz` | 4 rules, 10 words, context, 3 mistakes. | Hub diagram (werden-passive in the centre, five substitutes around it with their shade of meaning); G6 link to B2.2. |
| **Großer Text: Hinweise zum neuen System** · reading(inline) · `quest_c1_1_bigtext_hinweise` | 3 rules. | V11 memo skeleton over the text; office memo picture. |
| **Hören: Vorlesung** · listening · `quest_c1_1_hoeren_vorlesung` | 3 rules. | V11 lecture scaffold; V17 hedging scale; words step. |
| **Adjektive auf -bar / -lich** · fillBlank · `quest_c1_1_bar_lich` | 4 rules, 14 words, context, 3 mistakes. | V12 stem + bar tiles with the passive paraphrase under each; un- prefix tile. |
| **Kurzcheck: Nominalisierung** · speaking · `quest_c1_1_sprechen_kurzcheck` | 2 rules. | G7 script with pack/unpack pairs. |
| **Konnektoren (insofern/sofern/zumal…)** · fillBlank · `quest_c1_1_konnektoren` | 5 rules, 11 words, context, 3 mistakes. | V10 register ladder; V1 mini brackets. |
| **Konjunktionaladverbien der Schriftsprache** · fillBlank · `quest_c1_1_konjunktionaladverbien` | 4 rules, 12 words, context, 3 mistakes, 3×4 table. | V10 ladder per relation (aber → jedoch → indes); "joints of an argument" skeleton picture. |
| **Adverbialsätze I** · fillBlank · `quest_c1_1_adverbialsaetze` | 4 rules, 9 words, context, 3 mistakes, 4×4 table. | The 4×4 "clause / adverb / noun" table is the right form; add V1 mini brackets in the cells and V16 arrows between columns. |
| **Adverbialsätze II** · fillBlank · `quest_c1_1_adverbialsaetze_2` | 4 rules, 11 words, context, 3 mistakes, 4×5 table. | Same as above; "nine relations" overview poster linking both lessons. |
| **Genitivpräpositionen der Schriftsprache** · fillBlank · `quest_c1_1_genitiv_schriftsprache` | 4 rules, 12 words, context, 3 mistakes, 3×10 table. | Letter picture with anlässlich/bezüglich/mangels highlighted in place; G6 link to B2.2. |
| **Adjektive mit Kasus & Nomen mit Präposition** · fillBlank · `quest_c1_1_adjektive_praep_kasus` | 4 rules, 10 words, context, 4 mistakes, 3×3 table. | Case-before-adjective diagram (des Risikos bewusst) with an English contrast (aware OF). |
| **Lesen: Wissenschaft** · reading · `quest_c1_1_lesen_wissenschaft` | 3 rules. | V11 map with "shown / suspected" colouring; V17 scale over the article's verbs. |
| **Lesen: Sätze einordnen** · reading · `quest_c1_1_lesen_saetze_einordnen` | 3 rules. | Backward-pointer arrows diagram on a 4-sentence example; worked example. |
| **Partizipialsätze** · fillBlank · `quest_c1_1_partizipialsatz` | 4 rules, 12 words, context, 3 mistakes. | V16 unfold (In Wien angekommen, … ↔ Als er in Wien angekommen war, …). |
| **Attribute** · fillBlank · `quest_c1_1_attribute` | 4 rules, 9 words, context, 3 mistakes, 3×6 table. | Noun-chain tree diagram with the head noun on top and attributes hanging left/right; "find the head first" animation. |
| **Diktat: Wissenschaftssprache** · dictation · `quest_c1_1_diktat_nominalstil` | 4 rules. | Worked example; genitive-chain audio. |
| **Sprechen: Eine Grafik beschreiben** · speakRepeat · `quest_c1_1_sprechen_grafik` | 3 rules. | A real chart in the lesson (this lesson is about describing one and has none); von … auf … um … marked on the chart. |
| **Hören: Diskussionsrunde** · listening · `quest_c1_1_hoeren_podiumsdiskussion` | 3 rules. | V11 speaker lanes with "position + condition" slots. |
| **Hören: Vortrag mit Detailfragen** · listening · `quest_c1_1_hoeren_vortrag_detail` | 3 rules. | V11 numbered-findings map; words step. |
| **Lesen: Ein Essay** · reading · `quest_c1_1_lesen_essay` | 3 rules. | V11 "common view / author view" two-colour map. |
| **Lesen: Sprachbausteine-Cloze** · reading · `quest_c1_1_lesen_sprachbausteine` | 4 rules. | V5 form-first tree; worked gap. |
| **Gespräch: Abstrahieren** · speaking · `quest_c1_1_sprechen_dialog` | 3 rules. | V14; V20. |
| **Schreiben: Zusammenfassung** · writing · `quest_c1_1_schreiben_zusammenfassung` | 3 rules, 8 words, 4 mistakes. | Source text → summary side by side with attribution verbs highlighted (V16). |
| **Erweiterte Partizipialattribute** · fillBlank · `quest_c1_1_partizipialattribute` | 4 rules, 10 words, context, 4 mistakes, 3×5 table. | G6: third participle-attribute lesson (B2.1, B2.2); only zu + Partizip I is new, say so; V16 unpack animation (article → noun → middle). |
| **Zweiteilige Konnektoren** · fillBlank · `quest_c1_1_konnektoren_zweiteilig` | 4 rules, 10 words, context, 4 mistakes, 3×9 table. | G6 link to B1.2; position 0 vs 1 V1 diagram. |
| **Funktionsverbgefüge der Fachsprache** · fillBlank · `quest_c1_1_funktionsverbgefuege` | 4 rules, 10 words, context, 4 mistakes, 3×15 table. | Active/passive light-verb pairs (in Kraft setzen / treten) as V16; V10. |
| **Wortschatz** · vocabulary · `quest_c1_1_wortschatz` | 3 generic rules. | G4. |
| **Suchbild: Das Krankenzimmer** · suchbild · `quest_c1_1_suchbild_krankenhaus` | 3 rules, 32 words. | G5. |
| **Suchbild: Hinter der Bühne** · suchbild · `quest_c1_1_suchbild_theater` | 3 rules, 32 words. | G5. |

---

## 12. C1.2 — 34 lessons

| Exercise | What the lesson has | What would make it teach better |
|---|---|---|
| **Kultur & Medien** · fillBlank · `quest_c1_2_kultur` | 4 rules, 19 words, context, 3 mistakes. | "Replace interessant" wheel of precise adjectives; review-moves V20. |
| **Subjektive Modalverben: Vermutung** · fillBlank · `quest_c1_2_modal_vermutung` | 4 rules, 10 words, context, 3 mistakes, 3×6 table. | V17 certainty scale is the lesson (muss 95 % → dürfte → könnte → kann nicht); objective/subjective two-panel cartoon. |
| **Sprechen: Andeuten & abschwächen** · speakRepeat · `quest_c1_2_sprechen_abschwaechen` | 3 rules. | V10 hedge ladder; V14. |
| **Konjunktiv II: Kritik & nachträgliche Empfehlung** · fillBlank · `quest_c1_2_konj2_kritik` | 4 rules, 10 words, context, 3 mistakes. | V3 "should have" arrow back + "next time" arrow forward; V1 bracket with hätte … müssen. |
| **Relativsätze advanced** · fillBlank · `quest_c1_2_relativ_advanced` | 4 rules, 8 words, context, 3 mistakes, 3×6 table. | V5 "what does it refer to?" tree (noun / whole clause / place / nobody in particular); G6 link to the four earlier relative lessons. |
| **Numerus & genderneutrale Bezeichnungen** · fillBlank · `quest_c1_2_numerus_gender` | 4 rules, 10 words, context, 3 mistakes, 2×5 table. | Plural-only / singular-only picture pairs (die Eltern, das Obst); institution sign with Studierende. |
| **Subjektive Modalverben: Hörensagen** · fillBlank · `quest_c1_2_modal_hoerensagen` | 4 rules, 10 words, context, 4 mistakes, 4×2 table. | G6: B2.2 taught soll/will; rumour picture reused; new = passive and modal inside. |
| **Großer Text: Der geheimnisvolle Nachbar** · reading(inline) · `quest_c1_2_bigtext_nachbar` | 3 rules, 3×7 table. | V11 passage map; V17 scale with the story's modals placed; mystery house picture (exists). |
| **Wortbildung: Vorsilben** · fillBlank · `quest_c1_2_wortbildung_vor` | 4 rules, 15 words, context, 3 mistakes. | V12 prefix tiles with a meaning icon each (ver- = away/wrong, zer- = broken, ent- = removed). |
| **Hören: Reportage** · listening · `quest_c1_2_hoeren_reportage` | 3 rules. | V11 asserted/relayed two-colour map. |
| **Hören: Interview — stimmt / stimmt nicht / nicht gesagt** · listening · `quest_c1_2_hoeren_interview_stimmt` | 3 rules. | V5 three-test tree (said it? denied it? never mentioned?); worked item. |
| **Wortbildung: Nachsilben** · fillBlank · `quest_c1_2_wortbildung_nach` | 4 rules, 10 words, context, 3 mistakes. | V12 chain animation (freund → freundlich → Freundlichkeit); G6 link to B1.2/B2.1 suffix lessons. |
| **Präfixe: trennbar oder untrennbar?** · fillBlank · `quest_c1_2_praefixe` | 4 rules, 9 words, context, 3 mistakes, 3×6 table. | Two-panel picture per pair (úmfahren knocks the post / umfáhren drives round) with stress marked and audio pairs. |
| **Kurzcheck: Subjektive Modalverben** · speaking · `quest_c1_2_sprechen_kurzcheck` | 2 rules. | G7 script; V17 pocket card. |
| **Redewendungen** · fillBlank · `quest_c1_2_redewendungen` | 4 rules, 14 words, context, 3 mistakes. | One picture-book image per idiom (literal picture of "auf die lange Bank schieben" etc.), the visual the lesson's own rule "learn the verb with the image" asks for. |
| **Lesen: Eine Kolumne** · reading · `quest_c1_2_lesen_kolumne` | 3 rules. | V20 column moves over the text. |
| **Lesen: Expertenmeinungen zuordnen** · reading · `quest_c1_2_lesen_experten` | 3 rules. | Four-expert stance grid (for / against / conditional) as the pre-reading picture. |
| **Textkohäsion** · fillBlank · `quest_c1_2_kohaesion` | 4 rules, 10 words, context, 3 mistakes. | Backward/forward pointer arrows over a paragraph; theme–rheme chain diagram. |
| **Redemittel: Vortrag, Grafik, Stellungnahme** · fillBlank · `quest_c1_2_redemittel_vortrag` | 4 rules, 10 words, context, 3 mistakes, 2×3 table. | V20 three skeletons; a real chart for the graph set. |
| **Umformulierung 1** · fillBlank · `quest_c1_2_umformung_1` | 4 rules, 8 words, context, 3 mistakes. | V16 for each of the four transformations, colour-linked. |
| **Register: informell → formell** · fillBlank · `quest_c1_2_register_formell` | 4 rules, 10 words, context, 3 mistakes, 2×10 table. | V10 register ladder with the 10 pairs on rungs; chat bubble → e-mail picture (V16). |
| **Schreiben: Forumsbeitrag & formelle Beschwerde** · fillBlank · `quest_c1_2_schreiben_forum_beschwerde` | 4 rules, 10 words, context, 3 mistakes, 3×5 table. | V20 two skeletons side by side. |
| **Diktat: Nuancen** · dictation · `quest_c1_2_diktat_idiom` | 3 rules. | Worked example. |
| **Sprechen: Ironie & Betonung** · speakRepeat · `quest_c1_2_sprechen_ironie` | 3 rules. | Same sentence twice as audio (flat vs sincere) with intonation curves drawn; face icons. |
| **Hören: Hörspiel** · listening · `quest_c1_2_hoeren_hoerspiel` | 3 rules. | V11 scene map; "small words carry the implication" highlighted transcript lines. |
| **Lesen: Literarischer Text** · reading · `quest_c1_2_lesen_literatur` | 3 rules. | V16 unpack of one participial clause from the text; image → meaning card. |
| **Gespräch: Nuancieren** · speaking · `quest_c1_2_sprechen_dialog` | 3 rules. | V14; V10. |
| **Konjunktiv I: indirekte Rede** · fillBlank · `quest_c1_2_konjunktiv1_indirekte_rede` | 4 rules, 10 words, context, 4 mistakes, 3×9 table. | G6: B2.1 covered this twice; make this the "questions, commands, future" extension; V16 pairs. |
| **Modalpartikeln** · fillBlank · `quest_c1_2_modalpartikeln` | 4 rules, 9 words, context, 4 mistakes, 3×11 table. | G6: third particle lesson; organise by sentence type (the table already does), add tone faces + audio. |
| **Schreiben: Bericht im Nominalstil** · fillBlank · `quest_c1_2_schreiben_nominalstil` | 4 rules, 10 words, context, 4 mistakes, 3×8 table. | V16 pairs; "don't overdo it" dosage gauge. |
| **Schreiben: Ein Forumsbeitrag** · writing · `quest_c1_2_schreiben_forumsbeitrag` | 3 rules, 7 words, 4 mistakes. | Model post with V20 labels; V17 three strengths of guess. |
| **Wortschatz** · vocabulary · `quest_c1_2_wortschatz` | 3 generic rules. | G4. |
| **Suchbild: Die Redaktion** · suchbild · `quest_c1_2_suchbild_redaktion` | 3 rules, 32 words. | G5. |
| **Suchbild: Der Flughafen** · suchbild · `quest_c1_2_suchbild_flughafen` | 3 rules, 32 words. | G5. |

---

## 13. C2.1 — 30 lessons

| Exercise | What the lesson has | What would make it teach better |
|---|---|---|
| **Wirtschaft & Recht** · fillBlank · `quest_c2_1_wirtschaft` | 4 rules, 17 words, context, 4 mistakes. | Umsatz > Gewinn > Rendite as a nested-bars picture; legal remedy flow (Bescheid → Widerspruch → Klage). |
| **Register: formell ↔ umgangssprachlich** · fillBlank · `quest_c2_1_register` | 4 rules, 15 words, context, 4 mistakes. | V10 three-level ladder with kriegen / bekommen / erhalten on rungs; G6 link to C1.2. |
| **Sprechen: Eine Rede halten** · speakRepeat · `quest_c2_1_sprechen_rede` | 3 rules. | Speech arc diagram (image → anaphora → pause → echo); audio with the pause marked. |
| **Kollokationen** · fillBlank · `quest_c2_1_kollokationen` | 4 rules, 22 words, context, 4 mistakes. | Noun-centred spider diagram (Kritik: üben / scharfe / verstummt); authored collocation table (G3). |
| **Valenz** · fillBlank · `quest_c2_1_valenz` | 4 rules, 10 words, context, 3 mistakes, 3×6 table. | Verb-with-slots diagram (verb in the centre, case slots as sockets). |
| **Komposita bilden & verstehen** · fillBlank · `quest_c2_1_komposita` | 4 rules, 12 words, context, 3 mistakes, 3×5 table. | V12 blocks with the joint tile (-s-, -n-, -er-) highlighted; decode-leftward animation. |
| **Komparation advanced** · fillBlank · `quest_c2_1_komparation_advanced` | 4 rules, 10 words, context, 4 mistakes, 3×7 table. | Degree scale picture (einer der größten / bei weitem / dreimal so). |
| **Adjektivbildung: -haft, -mäßig…** · fillBlank · `quest_c2_1_adjektivbildung` | 4 rules, 18 words, context, 3 mistakes, 3×8 table. | V12 suffix tiles with meaning icons. |
| **Großer Text: Aus der Vorstandssitzung** · reading(inline) · `quest_c2_1_bigtext_vorstand` | 3 rules, 3×9 table. | V11 passage map; boardroom picture (exists). |
| **Stilmittel & Rhetorik** · fillBlank · `quest_c2_1_stilmittel` | 4 rules, 15 words, context, 3 mistakes. | One mini-illustration per device (metaphor, anaphora as repeated bars, climax as stairs); authored device table (G3). |
| **Hören: Feature** · listening · `quest_c2_1_hoeren_feature` | 3 rules. | V11 image → plain-words map. |
| **Konjunktiv I (Journalismus)** · fillBlank · `quest_c2_1_konj1_lit` | 4 rules, 11 words, context, 3 mistakes, 3×7 table. | G6: fourth Konjunktiv I lesson; highlight only the "sustained over a paragraph" skill; newspaper column picture with source/paper voices coloured. |
| **Umformulierung 2** · fillBlank · `quest_c2_1_umformung_2` | 4 rules, 10 words, context, 4 mistakes, 3×6 table. | V16 for all three transformations; four-point checklist card. |
| **Kurzcheck: Register** · speaking · `quest_c2_1_sprechen_kurzcheck` | 4 rules. | G7 script with the same news in three registers. |
| **Konnotation & Wortwahl** · fillBlank · `quest_c2_1_konnotation` | 4 rules, 14 words, context, 3 mistakes, 3×9 table. | Thermometer picture (warm / neutral / cold words) — the lesson's own metaphor; the 3×9 table is good. |
| **Abtönung & Graduierung** · fillBlank · `quest_c2_1_abtoenung` | 4 rules, 13 words, context, 3 mistakes, 3×5 table. | V17 scale with the adverbs placed (keineswegs … durchaus … geradezu). |
| **Lesen: Zeitungsartikel** · reading · `quest_c2_1_lesen_artikel` | 3 rules. | V11 source/author two-colour map. |
| **Sprichwörter** · fillBlank · `quest_c2_1_sprichwoerter` | 4 rules, 14 words, context, 4 mistakes, 3×8 table. | Headline mock-ups with the truncated proverb; one picture per proverb (literal image). |
| **Diktat: Register & Stil** · dictation · `quest_c2_1_diktat_register` | 4 rules. | Worked example. |
| **Sprechen: Moderieren** · speakRepeat · `quest_c2_1_sprechen_moderieren` | 5 rules. | V14 panel script with the host's moves; V20. |
| **Hören: Satire** · listening · `quest_c2_1_hoeren_satire` | 4 rules. | V11 praise/fact two-lane map. |
| **Lesen: Kurzgeschichte** · reading · `quest_c2_1_lesen_kurzgeschichte` | 4 rules. | Symbol-tracking diagram (the object through the text); conventions checklist. |
| **Gespräch: Stilsicherheit** · speaking · `quest_c2_1_sprechen_dialog` | 6 rules. | Six rules is heavy for a speaking lesson; fold into 3 with a V20 moves card. |
| **Schreiben: Zweimal dasselbe** · writing · `quest_c2_1_schreiben_register` | 3 rules, 7 words, 4 mistakes. | Two-axis register diagram (formal/informal × personal/impersonal) with the two texts placed. |
| **Konjunktiv II: Nuancen** · fillBlank · `quest_c2_1_konj2_nuancen` | 5 rules, 10 words, context, 4 mistakes, 3×8 table. | V3 near-miss arrow (beinahe); V1 double-infinitive end. |
| **Konnektoren: indes, wiewohl…** · fillBlank · `quest_c2_1_konnektoren_nuancen` | 4 rules, 10 words, context, 3 mistakes, 4×10 table. | V10 ladder; V1 three word-order classes. |
| **Präfixe: Bedeutung von ver-, zer-…** · fillBlank · `quest_c2_1_praefixe_semantik` | 4 rules, 10 words, context, 3 mistakes, 4×7 table. | G6: C1.2 taught prefixes; V12 meaning icons; übersetzen two-panel (translate / ferry across). |
| **Wortschatz** · vocabulary · `quest_c2_1_wortschatz` | 3 generic rules. | G4. |
| **Suchbild: Die Tischlerei** · suchbild · `quest_c2_1_suchbild_tischlerei` | 3 rules, 32 words. | G5. |
| **Suchbild: Der Bauernhof** · suchbild · `quest_c2_1_suchbild_bauernhof` | 3 rules, 32 words. | G5. |

---

## 14. C2.2 — 30 lessons

| Exercise | What the lesson has | What would make it teach better |
|---|---|---|
| **Philosophie & Gesellschaft** · fillBlank · `quest_c2_2_philosophie` | 4 rules, 19 words, context, 4 mistakes, 3×5 table. | Concept map (Freiheit – Pflicht – Würde) with the verbs of argument on the edges. |
| **Wortstellung & Fokus** · fillBlank · `quest_c2_2_fokus` | 4 rules, 12 words, context, 4 mistakes. | V1 with a spotlight on the Vorfeld; same sentence with the focus particle moving and the stress shifting (audio pairs). |
| **Sprechen: Streitgespräch** · speakRepeat · `quest_c2_2_sprechen_streitgespraech` | 3 rules. | V14; V20 contradict → attack reasoning → reclaim. |
| **Anspielungen & Implikatur** · fillBlank · `quest_c2_2_anspielung` | 5 rules, 12 words, context, 3 mistakes. | Said / meant two-layer speech-bubble pictures; job-reference code card (stets bemüht = …). |
| **Paraphrase & Variation** · fillBlank · `quest_c2_2_paraphrase` | 5 rules, 15 words, context, 4 mistakes. | V10 "one rung up" ladder; equivalence-test checklist. |
| **Hören: Fachvortrag** · listening · `quest_c2_2_hoeren_fachvortrag` | 4 rules, 3×7 table. | V11 old model → new model map; V17 hedging. |
| **Wortspiel & Mehrdeutigkeit** · fillBlank · `quest_c2_2_wortspiel` | 5 rules, 15 words, context, 4 mistakes, 4×7 table. | Two-picture pairs for gender puns (die Steuer / das Steuer, der Leiter / die Leiter); headline mock-ups. |
| **Kurzcheck: Andeutung & Ironie** · speaking · `quest_c2_2_sprechen_kurzcheck` | 5 rules. | G7 script; five rules is many for a Kurzcheck, fold to 3. |
| **Lesen: Essay** · reading · `quest_c2_2_lesen_essay` | 3 rules. | V20 concession → hinge → limitation → conclusion over the text. |
| **Wissenschaftssprache** · fillBlank · `quest_c2_2_wissenschaftssprache` | 4 rules, 16 words, context, 4 mistakes. | Paper-structure diagram (Annahme → Befund → Schluss) with phrases per block; V17 hedging. |
| **Präpositionen der Schriftsprache** · fillBlank · `quest_c2_2_praepositionen_schriftsprache` | 5 rules, 11 words, context, 4 mistakes, 4×18 table. | Contract/notice picture with kraft/binnen/vorbehaltlich in place; the 18-row table should fold into the four groups the rules name. |
| **Nominalstil: verdichten und auflösen** · fillBlank · `quest_c2_2_nominalstil` | 5 rules, 10 words, context, 4 mistakes, 2×10 table. | V16 both directions; dosage gauge ("two genitives, then a compound"); G6 link to C1.1. |
| **Behördensprache** · fillBlank · `quest_c2_2_behoerdensprache` | 5 rules, 12 words, context, 4 mistakes, 2×12 table. | Official-letter picture with the three questions pinned (what · by when · or else); fine-type card (Verwarnungsgeld / Bußgeld / Geldstrafe). |
| **Lesen: Ein amtliches Schreiben** · reading · `quest_c2_2_lesen_amtliches_schreiben` | 4 rules, 3×7 table. | V11 over the letter itself; Anhörung ≠ Bescheid flow. |
| **Appositionen** · fillBlank · `quest_c2_2_appositionen` | 5 rules, 10 words, context, 4 mistakes, 3×9 table. | "Copy the case from the left" arrow diagram across the comma. |
| **Modalverben — das ganze System** · fillBlank · `quest_c2_2_modalverben_system` | 4 rules, 10 words, context, 4 mistakes, 4×7 table. | One poster: 6 modals × objective / subjective / reporting with V17 scale on the subjective row; G6 links to C1.2 and B2.2. |
| **Passiv-Meisterschaft** · fillBlank · `quest_c2_2_passiv_meisterschaft` | 4 rules, 10 words, context, 4 mistakes, 3×9 table. | Hub diagram "what is in focus?" (action / result / duty / possibility) — the capstone of 7 passive lessons, name them. |
| **Adverbialsätze umformen** · fillBlank · `quest_c2_2_adverbialsaetze_umformen` | 4 rules, 10 words, context, 4 mistakes, 4×8 table. | V16 three shapes per relation; V1 mini brackets in the table cells. |
| **Großer Text: Zum Wert des Lesens** · reading(inline) · `quest_c2_2_bigtext_lesen` | 3 rules, 3×4 table. | V11 reported/own-voice map. |
| **Hören: Literarische Lesung** · listening · `quest_c2_2_hoeren_lesung` | 4 rules. | Facts → symbol → meaning ladder diagram; suitcase picture. |
| **Sprechen: Eine Analyse vortragen** · speakRepeat · `quest_c2_2_sprechen_analyse` | 4 rules. | V20 analysis skeleton; V14. |
| **Rezension & Interpretation: Redemittel** · fillBlank · `quest_c2_2_rezension_redemittel` | 4 rules, 10 words, context, 4 mistakes, 2×10 table. | V20 review skeleton. |
| **Hören: Podiumsdiskussion (Capstone)** · listening · `quest_c2_2_hoeren_capstone` | 4 rules. | V11 four-lane map with fine-print slots. |
| **Lesen: Literatur & Deutung (Capstone)** · reading · `quest_c2_2_lesen_capstone` | 3 rules. | Ritual → reason → realisation diagram. |
| **Lesen: Lyrik** · reading · `quest_c2_2_lesen_lyrik` | 4 rules. | The poems with rhyme scheme and metre marked (the "check it line by line" rule needs the marked-up text). |
| **Gespräch: Meisterschaft** · speaking · `quest_c2_2_sprechen_dialog` | 6 rules. | Fold to 3 + V20 card. |
| **Schreiben: Erörterung** · writing · `quest_c2_2_schreiben_eroerterung` | 3 rules, 8 words, 4 mistakes. | V20 Erörterung skeleton with the objection block emphasised. |
| **Redewendungen** · fillBlank · `quest_c2_2_redewendungen` | 4 rules, 14 words, context, 4 mistakes, 3×10 table. | One picture per idiom (as C1.2); V10 register column already in the table. |
| **Fremdwörter und Latinismen** · fillBlank · `quest_c2_2_fremdwoerter` | 4 rules, 15 words, context, 4 mistakes, 3×14 table. | False-friend pairs card (eventuell ≠ eventually) with warning icons; V10. |
| **Deutsch in Österreich und der Schweiz** · fillBlank · `quest_c2_2_dach_varianten` | 4 rules, 14 words, context, 3 mistakes, 3×12 table. | V9 DACH map with the words placed on the country; menu/notice pictures. |
| **Wortschatz** · vocabulary · `quest_c2_2_wortschatz` | 3 generic rules. | G4. |
| **Suchbild: Der Antiquitätenladen** · suchbild · `quest_c2_2_suchbild_antiquitaeten` | 3 rules, 32 words. | G5. |
| **Suchbild: Der Hafen** · suchbild · `quest_c2_2_suchbild_hafen` | 3 rules, 32 words. | G5. |

---

## 15. Where to start

The table above is 403 rows; this is the order that buys the most learning per
hour of work.

1. **Build V1 (Satzklammer), V2 (case grid), V13 (people grid), V3 (timeline)** as four Svelte components fed from `tip.visual`. About 220 grammar lessons can use at least one of them, and the data per lesson is a handful of fields.
2. **Build V11 (text map)** and give every reading, listening and dictation lesson its own annotated excerpt plus a words step. This closes G2 for ~110 lessons with content that already exists (the passage and its answer key).
3. **Author paradigm tables** (G3) for the ~40 lessons whose derived table is a bare answer list but whose topic is a paradigm: both Perfekt lessons, all Präteritum, all pronoun and possessive lessons, Imperativ, Reflexiv, Modalverben, Futur, Passiv forms.
4. **Rewrite the 12 vocabulary-deck lessons and 24 Suchbild lessons** (G4, G5) with topic-specific tips and the picture shown. 36 lessons, a day of writing.
5. **Add the "you already know / new today" opener** (G6) to the ~40 lessons that extend an earlier topic, and glow only the new cells in the shared grid.
6. **Pictures via the image pipeline** (V15) where a picture is the content: Farben swatches, Familie tree, Körper, Kleidung, Wetter, Uhrzeit clock, Wechselpräpositionen room, the idiom lessons (C1.2, C2.2), the chart for Grafik beschreiben.

Items 1 and 2 need a `visual` field on `HelpTip` (and on `QuizHelp` for the hook)
in `src/lib/content/types.ts`, a renderer branch in `Lesson.svelte`, and a gate
test that every `visual.kind` is one the renderer knows.
