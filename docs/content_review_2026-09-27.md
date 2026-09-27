# Content review — German Course A1–C2 (2026-09-27)

Full review of the shipped bundle (`assets/content/courses/de_cert_a1.json`, 326 quizzes,
12 modules) plus the exercise engine and the pages that present it. Section 1 is what
breaks on the site today; section 2 is what holds the course back as a whole; section 3
is the module-by-module list. Quiz ids are the bundle ids.

Verified against the built HTML in `build/` where a rendering claim is made.

---

## 1. Defects visible on the live site (fix first)

| # | Where | What |
|---|---|---|
| 1 | Level pages B1.1 → C2.2 | `syllabus/de_cert_a1.json` stores `exam` as a **string** for the eight B1–C2 modules (A-levels use an array). The level page iterates it, so "In the exam" renders **one bullet per character** ("B", "1", " ", "e", "x", …). |
| 2 | Help Memory, 61 quizzes (all B1–C2 authored tables) | Reference tables store rows as plain arrays and use `title` instead of `caption`. The renderer expects `{cells}` + `caption`, so the table shows a **header row and an empty body**. |
| 3 | `quest_c1_1_hoeren_vortrag_detail`, `quest_c1_2_hoeren_interview_stimmt` | Field is `title` not `passageTitle` → heading renders as **"undefined"**. |
| 4 | 198 quiz pages | Tip "trap" lines print the internal contrastive-spine codes ("E13 — …", "E20 — …") to learners. Strip the prefix in the renderer or the data. |
| 5 | ~50 fill-blank sentences with two gaps (`je … desto`, `sowohl … als auch`, `hatte … verlassen`, all of `quest_b2_2_futur2`, `quest_b1_2_konnektoren_zweiteilig`, `quest_c1_1_tempuswahl`, …) | `FillBlankQuiz` turns only the **first** `____` into an input; the second stays as literal underscores, and the accepted answer contains a literal "…". In strict mode these are unanswerable; in relaxed mode the learner must guess to type "je desto". Needs a two-input renderer or a rewrite to one gap. (38 sentences have **every** accepted answer containing "…".) |
| 6 | `quest_a1_1_laender` template `"Er ist ____ , und sie ist ____ in."` | Appends *-in* to the masculine → **Deutscherin, Franzosein, Türkein, Polein, Russein, Chinesein**. |
| 7 | `quest_a1_2_imperativ` (template × sein/haben) | Generates "Sei doch mal!", "Hab bitte!", "Haben Sie bitte hier!". |
| 8 | `quest_a1_1_wortbildung` templates | "Er ist Lehrer, sie ist … (Arzt) → ____" hard-codes Lehrer; "Viele Frauen: die Lehrerinnen" (article after *viele*). |
| 9 | `quest_b1_2_plusquamperfekt` templates | "Nachdem er ____ , …" + *hatte gegessen* → **Nachdem er hatte gegessen**; "Er ____ schon, als" → **Er hatte gegessen schon**. Every item is wrong word order. |
| 10 | `quest_b1_2_partizip_adj_intro` | Template is accusative ("Siehst du ____ ?") but every answer is nominative (*der schlafende Hund*). |
| 11 | `quest_b1_1_adj_nullartikel`, `quest_b1_2_trotz_wegen` | Template × subject produces nonsense: "Ich trinke gern nette Leute", "während des Wetters", "trotz des Essens". |
| 12 | Relaxed checking (default on) folds ä/ö/ü/ß | So **"hatte" passes for "hätte"**, "konnte" for "könnte", "grosser" for "größer" — the whole Konjunktiv II and comparative strand cannot be failed on its defining feature. Umlaut folding should be off for quizzes whose target *is* the umlaut (or at least for those quizzes' answer keys). |
| 13 | `quest_c2_2_lesen_lyrik` intro + exam line | Claims Mascha Kaléko is "out of copyright / public domain". **False** (d. 1975, protected to end of 2045). Ringelnatz is fine. Remove before anyone quotes her. |
| 14 | `quest_c2_2_nominalstil`, `quest_c2_2_adverbialsaetze_umformen` intros | Name a commercial textbook ("Erkundungen C2 makes this its final/second chapter"). Strip, per the IP policy. |
| 15 | Leftover author notes shown to learners | `quest_b2_1_mittelfeld` subject "(Te before objects? no: pron/noun order)"; `quest_b2_2_adjektivbildung` "Mut → mutig? (no: mutig)"; `quest_c2_2_appositionen` "ihre Rolle als Vorsitzender?", "(als, Gen → Akk/Dat?)"; `quest_c2_2_modalverben_system` context "(gern haben? nein: …)"; `quest_c1_2_praefixe` "hínterlassen? —". |

---

## 2. Course-wide problems

### 2.1 Reading and listening are the same length at every level
Passage word counts (r = reading, l = listening, c = inline cloze):

| Level | Passages |
|---|---|
| A1.1 | l45 r65 r54c l46 |
| A2.2 | r61c l49 r60 r62 r81 |
| B2.2 | r78c l59 r64 l55 r63 r95 |
| C1.2 | r66c l58 l160 r69 r158 l60 r67 |
| C2.2 | l60 r76 r146 r65c l62 l66 r80 r37 |

Exam texts run ~150–300 words at B1, 300–450 at B2, 400–600+ at C1/C2, with 5–10 items
each. Only four passages in the whole course (`c1_1_hoeren_vortrag_detail`,
`c1_2_hoeren_interview_stimmt`, `c1_2_lesen_experten`, `c2_2_lesen_amtliches_schreiben`)
approach their level's shape. Everywhere else the receptive skills are B1 tasks with higher
labels, and five MC items on a five-sentence text force trivial questions.

### 2.2 Multiple-choice keys are guessable
- `correctIndex` distribution across all 263 items: **0 → 151, 1 → 106, 2 → 6**. The
  third option is essentially never right.
- 15 quizzes have the **same** correct index on every question
  (`a1_2_hoeren_termine`, `a2_1_hoeren_reise`, `a2_1_hoeren_wetter`, `a2_2_lesen_email` all
  index 1; `b2_2_lesen_textergaenzung` and ten C1/C2 quizzes all index 0).
- The correct option is the uniquely longest in 147/263 items.
- Distractors are often jokes or absurdities at B2–C2 ("Das Ehrenamt ist verboten",
  "obwohl die Ameisen tot sind", "ein Verbot von KI").
Cheapest fix: shuffle options at render time and keep the key by value; then rewrite
distractors as paraphrase/exaggeration traps from B1 upward.

### 2.3 Intros and tips describe texts that are not the ones shipped
At B1, C1 and C2 the Help Memory quotes sentences that do not occur in the passage, and in
at least seven cases primes the wrong answer (`c2_2_hoeren_lesung`, `c2_2_lesen_capstone`,
`c2_1_lesen_kurzgeschichte`, `c2_1_hoeren_satire`, `c2_1_hoeren_feature`,
`c2_2_hoeren_fachvortrag`, `c2_2_hoeren_capstone`; also `c1_2_lesen_literatur`,
`c1_1_hoeren_vorlesung` where the key contradicts the tip, `b1_2_lesen_technik`,
`b1_2_hoeren_podcast`, `b1_1_lesen_studium`). The intro and the text were written in
separate passes; every passage quiz needs a consistency check.

### 2.4 Fill-blank accepts one string where several are right
Systematic from A1 to C2, worst at B2–C2 where the task is synonym choice or transformation:
- Connector families (Deshalb/Daher/Folglich/Deswegen; Trotzdem/Dennoch; Außerdem/Zudem;
  Obwohl/Obgleich/Obschon) — one accepted per item in `b2_1_konnektoren`,
  `b2_2_konzessiv`, `b2_2_genitiv_praep`, `c1_2_kohaesion`, `c1_1_verbalisierung`.
- Modal particles (`b1_2_modalpartikeln_intro`, `b2_2_modalpartikeln`, `c2_2_fokus`) —
  doch/ja/denn/mal/halt/eben interchangeable in most stems.
- Register/transformation tasks (`c1_2_register_formell`, `c1_2_umformung_1`,
  `c2_1_umformung_2`, `c2_2_nominalstil`, `c2_2_adverbialsaetze_umformen`,
  `c2_2_passiv_meisterschaft`, `c2_2_appositionen`) — whole-sentence exact match, often
  with required trailing commas or typographic quotes.
- A1 basics: *Wie heißt das auf Deutsch* (only *was*), official clock times
  (`a1_2_uhrzeit`), *aus der Uni*, *violett*, imperative *-e* forms, *Website*
  (`b1_2_technik`), *Nachweis*, *entkommen*, *vermitteln*, *einreichen*, *fällen*.
Either widen the keys, make the cue disambiguate ("(formal)", "(colloquial)"), or move
these items to select/MC.

### 2.5 Fill-blank keys that cannot be typed
Metadata strings used as answers: `a2_2_verben_praep_intro` ("auf + Akk", "Worauf?",
"Darauf."), `c1_1_adverbialsaetze` ("wenn / falls / sofern", "Verb an 1 (Regnet es, …)"),
`c1_2_redemittel_vortrag`, `c1_2_schreiben_forum_beschwerde`, `c2_2_modalverben_system`
("Beispiel: ____" → "Er muss krank sein."), `c2_2_rezension_redemittel`,
`c2_2_behoerdensprache`, `c2_1_valenz`, `c2_1_komposita` ("— (kein)"),
`c2_1_adjektivbildung` ("-haft: in der Art von"). These are matching/MC content.

### 2.6 Drills that do not test the target
- Hint = answer: `b1_2_praet_unreg` ("(kommen → kam)"), `b2_2_fvg`, `b2_2_modalpartikeln`
  ("(resignation: halt)"), `c1_1_passiversatz`, `c1_2_wortbildung_vor`, `c1_2_modal_hoerensagen`,
  A2 big-text hints ("fahren (Bewegung)", "Wo? → Dativ").
- Only the auxiliary is blanked: `b1_1_konj2_wuerde`, `b1_2_passiv`, `b1_2_passiv_praet`,
  `a2_2_passiv_intro` (all wird/werden), `b2_1_modalpassiv` (13/15 = werden),
  `b2_1_passiv_perfekt` (11/15 = worden).
- Conjugation tables in disguise: `a1_1_sein_haben`, `a1_1_praesens`, `a1_1_vokalwechsel`,
  `a1_2_modalverben` — "Ich ____ . (machen)", no object, no context.
- `b1_2_infinitiv`: learner never places *um* or *zu*. `b1_1_genitiv`: noun pre-declined,
  only des/der chosen.

### 2.7 Speak-repeat and dictation banks are thin and mis-described
- 20 speakRepeat quizzes (A2.1 → C2.2) have **6–7 lines**; every intro promises "eight
  sentences" and lists eight different ones. The 10-item minimum is enforced only for
  fillBlank/dictation.
- Dictation intros promise features the sentences don't contain (`b2_1_diktat_argument`:
  Konjunktiv I; `c1_1_diktat_nominalstil`: genitive chains, compounds; `c2_1_diktat_register`).
- `a2_2_sprechen_person` switches from Paul to a woman to the sister mid-set.

### 2.8 Speaking specs disagree with their own Help Memory
`b1_1_sprechen_kurzcheck` (adjective endings in tips, absent from JSON),
`b1_2_sprechen_kurzcheck` (passive), `b2_1_sprechen_kurzcheck`/`_dialog`,
`b2_2_sprechen_dialog` (duplicates kurzcheck topic; "eigentlich" never taught),
`b1_2` priorityErrors penalise the tense mixing `sprechen_geschichte` teaches; `c1_2`
practisePoints name *geschweige denn*, taught nowhere. `durationMinutes`/`passScore` are
unset on all 24 and fall back to manifest defaults (4 min / 50).

### 2.9 Listening is a single voice reading dialogues
Nine passages are dialogues (`a1_2_hoeren_cafe`, `_termine`, `b1_1_hoeren_interview`,
all C1/C2 interviews and discussions) read by one TTS voice with no speaker labels.
`voiceGender` is set on 10 of 27 listening quizzes.

### 2.10 Level drift and redundancy
- A2.2 second half is B1 (relative clauses, irregular Präteritum, passive, wo-/da-,
  TeKaMoLo) while Indefinitpronomen, Genitiv-s, ordinal dates are missing.
- B2.1 `indirekt_fragen`, `partizip_adj`, `gesellschaft` are A2/B1 content.
- C1 and C2 vocabulary quizzes (`c1_1_bildung`, `c1_2_redewendungen`, `c2_1_wirtschaft`,
  `c2_2_philosophie`, `c2_1_kollokationen`, `c2_2_wortspiel` where the answer is the
  headword) are B1–B2 items in A2 frames.
- Repeats: dem/der/den drilled in three A2.1 quizzes; café script five times in A1.2;
  n-Deklination twice (same example sentence) at B1; um…zu three times at B1;
  trotzdem/dennoch family in four B2 quizzes; sein+zu/lassen/-bar in five C1.1 quizzes;
  subjective modals in six C1.2 quizzes; register pairs verbatim across three C2 quizzes.
  Cross-level duplicate sentences: `c1_2_relativ_advanced`/`b2_2_relativ_wer_was`,
  `c1_2_wortbildung_nach`/`c1_1_nominalisierung`, `c1_2_umformung_1`/`b2_2_passiversatz_intro`.

### 2.11 Syllabus gaps (topics with no quiz)
- **A1**: alphabet/spelling (the exam asks for it and two quizzes say so), *Wohin?*
  (nach/zu/in + Akk), numbers > 100, unser/euer/Ihr, mögen forms, gern/lieber, es gibt,
  Wohnung/Berufe/Hobbys/Wetter vocabulary, ordinal dates.
- **A2**: Indefinitpronomen, Genitiv-s with names, dates productively, a writing task.
- **B1**: Verben mit Präpositionen + da-/wo- (biggest gap), indirect questions, Zustandspassiv,
  Mittelfeld order, jemand/niemand/irgend-; `b1.falls-da-trotzdem` tag is attached to a quiz
  containing none of them.
- **B2**: um…zu/ohne…zu/statt…zu vs dass, dessen/deren and prep + relative, brauchen zu,
  Futur I Vermutung, Plusquamperfekt in narration, je…desto, a dedicated Konjunktiv II
  present drill.
- **C1**: Konjunktiv I / indirekte Rede as a drill, Funktionsverbgefüge, erweiterte
  Partizipialattribute, zweiteilige Konnektoren, Modalpartikeln, a real Nominalstil writing task.
- **C2**: Konjunktiv II nuances, idioms beyond proverbs, connector nuance (indes, zumal,
  gleichwohl), Latinisms, prefix semantics, DACH variation, any long-form writing or
  authentic-length text.
- The exam model is inconsistent between quizzes at C1 (2010-style vs 2024 modular
  format); pick one and align every `exam` line.

---

## 3. Per-level itemised findings

### A1.1 / A1.2
1. `a1_1_laender` — nationality template (see §1.6).
2. `a1_2_sprechen_alltag` — intro/mnemonic claim *Uhr, um* have ü. They have plain u. Wrong pronunciation guidance in a pronunciation quiz.
3. `a1_2_hoeren_bahnhof` — intro says "the second number is the true one"; tip and passage say the number *before* "nicht" is right. Only listening quiz with no explanations.
4. `a1_2_hoeren_cafe` — guest orders *einen Kaffee*, waiter then asks "Und etwas zu trinken? – Nein, danke", MC asks what he drinks → Kaffee. Logic error.
5. `a1_1_wortbildung` — "die Haus + die Tür" (das Haus); template bugs (§1.8).
6. `a1_2_imperativ` — sein/haben nonsense (§1.7); optional *-e* forms (Mache!, Gehe!) rejected.
7. `a1_1_vokalwechsel`, `a1_1_sein_haben` — MISTAKES lines garbled (correct form listed on the wrong side).
8. `a1_2_dativ_pronomen_intro` s(ich) — "Wie geht es mir? – Gut, danke" (asking oneself).
9. `a1_1_bigtext_dasbinich` — intro mentions a separable verb that isn't in the text and hasn't been taught.
10. `a1_1_wfragen` s14 — "____ heißt das auf Deutsch?" only *was*; *Wie* is the textbook phrase. s11 add *wie viel Uhr*.
11. `a1_2_uhrzeit` — only colloquial clock accepted; official (neun Uhr dreißig) rejected though the intro says both are A1. *fünf nach / zehn vor* taught, never tested.
12. `a1_1_wo_praepositionen` — *aus der Uni* rejected; "Ich komme aus dem Bett" unnatural; intro lists auf/vor/unter/nach, none practised.
13. `a1_1_familie` — *mein Freund/meine Freundin* rejected though hinted; relative-clause and genitive clues at A1.
14. `a1_1_farben` — *violett* rejected; "Mischung" clue above A1; tip says adjective endings are B1 (they are A2 here).
15. `a1_2_koerper` — x12 no article variant; x13 duplicates Knie; x14 reflexive dative + Perfekt at A1.
16. `a1_2_wann_praepositionen` — *für zwei Wochen* taught but rejected; "Wann? – zwei Wochen" mismatched; subject "2020" → "2020" non-item.
17. `a1_2_hoeflich`, `a1_2_einkaufen_mengen` — x12/x13 duplicate s0/s1 with different accepted lists.
18. `a1_2_trennbare` s5/s12 — sentence-initial *Sie* ambiguous (she / formal you).
19. `a1_1_hoeren_zahlen` — passage "einen Euro fünfzig" vs tip "ein Euro fünfzig" side by side, unexplained.
20. `a1_2_pronomen_akk` — intro says uns/euch "(almost) don't change". They change completely.
21. `a1_2_datum` — "only die Nacht is feminine" contradicted by own vocab (das Wochenende, die Woche); ordinals promised, never practised; s16 Oktoberfest giveaway and factually shaky.
22. `a1_1_sein_haben` MISTAKES — "Romance languages" note irrelevant for English speakers; target *hungrig/durstig* instead.
23. `a1_1_pronomen` REMEMBER — "Two people = du/ihr" garbled (friends = du/ihr).
24. `a1_2_praepositionen` — "um den Brunnen" contrived (am Brunnen).
25. `a1_2_hoeren_termine` — tip explains a question not asked; option "(19:30)" gives the conversion away; all five keys index 1.
26. `a1_2_sprechen_einkaufen` — "hätte gern more natural than möchte" unsupported.
27. `a1_2_satzbau` — x12–x14 filed under "Konnektor" with none present; exact full-sentence match.
28. Order: `a1_1_zahlen3` (20–100) comes after quizzes using 23/30; `a1_2_uhrzeit`/`trennbare` come after speak/dictation/big-text quizzes that require them.
29. A1.2 numbers 650, 500, 1995, 2020 appear before hundreds/thousands are taught.
30. Trap lines tagged E20/E13/E14 attached to non-issues ("billig ≠ billing").

### A2.1 / A2.2
1. `a2_2_wenn_deshalb` MISTAKES — corrected form "Als ich Kind war" is itself wrong (ein Kind / Als Kind).
2. `a2_1_woher_wo_wohin` — one template "Ich gehe ____" for cities/countries (→ *gehe nach Berlin*); subject label prints the answer.
3. `a2_1_dativ_praep` — intro says *gegenüber* follows the noun, item puts it before; "always contract with definite article" overstated.
4. `a2_2_superlativ` tip — "-t/-d/-s/-z → -esten" then "groß → am größten".
5. `a2_1_wetter` MISTAKES — "Es ist zwanzig Grad" marked wrong; Duden accepts it.
6. `a2_1_komparativ` — context "als dass ich fahre" is B2 and stilted; "usually take an umlaut" → "many".
7. `a2_2_wortbildung` — "-er → der" stated as a gender rule (die Butter, das Fenster); *Computer* listed as verb+-er.
8. `a2_1_dativ_akkusativ` s7 English "She recommends him the film"; `a2_2_tekamolo` s2 "im Büro" ≠ "in an office".
9. `a2_2_sprechen_person` — person changes mid-set.
10. `a2_2_kleidung` — intro references adjective endings from a quiz that comes *later*; category says "mit Artikel", answers have none; Mütze glossed "cap".
11. `a2_2_reflexiv` s4 — "Wascht euch die Hände" is dative reflexive, never taught.
12. `a2_2_verben_praep_intro` — metadata answers (§2.5).
13. `a2_2_passiv_intro` — all answers wird/werden; x12–x14 duplicate s1–s3.
14. A2 big-text hints give the case away.
15. `a2_2_lesen_formular` — 4 questions, no explanations.
16. `a2_1_perfekt_haben` — no mixed verbs (gebracht, gedacht); *bekommen* listed, never drilled.
17. `a2_1_perfekt_sein` s10 "bin … gewesen" vs `a2_1_war_hatte` "never say bin gewesen".
18. `a2_1_lesen_hamburg` — "Wie sind sie nach Hause gekommen?" ambiguous (transport vs state).
19. `a2_1_hoeren_reise` — intro promises text-order questions; order is 1,3,5,2,4. All keys index 1.
20. `a2_1_temporal_2` — *für* + Akk never stated.
21. `a2_2_bigtext_zimmer` "auf das Regal" vs `a2_2_wechsel_wohin` "ins Regal".
22. `a2_2_indirekte_fragen` — x12/x13 duplicate s4/s0. `a2_2_gesundheit` s10–s12 filler ("Ich sehe mit den Augen").
23. `a2_2_weil`, `a2_2_dass` — none tests modal/Perfekt-helper-last that the tips stress.
24. `a2_1_sprechen_dialog`, `a2_2_sprechen_dialog` — no mode; targetVocabulary "meiner" is a bare ending.
25. Minor: `a2_1_pronomen_dativ` s8 "(it)" for a child; `a2_2_superlativ` s10 "am weitesten von hier"; `a2_2_wechsel_wo` s9 "an dem Bahnhof".

### B1.1 / B1.2
1. `b1_2_partizip_adj_intro` — accusative template, nominative answers (§1.10); kochen→Wasser ambiguous.
2. `b1_2_plusquamperfekt` — word order (§1.9).
3. `b1_2_temporalsaetze` s8 — Präteritum in nachdem-clause contradicts own MISTAKES/REMEMBER.
4. `b1_2_modalpartikeln_intro` — "Das ist doch schön!" marked wrong (it's fine); s3/s4/s6/s7 have two valid particles.
5. `b1_2_technik` s14 — *Website* (own vocab) rejected; s4 declined adjective in a vocab drill.
6. `b1_1_adj_nullartikel`, `b1_2_trotz_wegen` — nonsense pairings (§1.11).
7. `b1_2_praet_misch` — sandte/wandte only (sendete/wendete rejected); "only eight" then lists nine; garbled tip.
8. `b1_2_praet_unreg` — includes wissen while tip defers it; hints contain the answers (copy exercise).
9. `b1_1_futur` s4/s12 — werden = "become", not Futur I, in a Futur I drill.
10. `b1_1_es` s5 — *geht um* rejected; s6 forces "es ist mir kalt" while trap teaches "Mir ist kalt".
11. `b1_1_relativ_praep` s1 — *wo* rejected though taught and accepted elsewhere.
12. `b1_2_damit_umzu` — single strings for free production (s3, s6, x13, x14).
13. `b1_2_irreale_wuensche` — *bloß/doch nur* taught, rejected; x12–x14 no wenn-variant; context uses B2.2 past unreal.
14. `b1_1_email_redemittel` — "Würden Sie mir bitte", "Herzliche Grüße" rejected.
15. `b1_1_arbeit` — kündigen glossed "be given notice"; `b1_1_adj_komparativ` trap example undermines its point.
16. `b1_2_infinitiv`, `b1_1_konj2_wuerde`, `b1_2_passiv`, `b1_2_passiv_praet`, `b1_1_genitiv`, `b1_1_konjunktionen`, `b1_2_temporalsaetze` — target not tested (§2.6).
17. `b1_1_lesen_arbeit` Q4, `b1_1_hoeren_umfrage` Q5 — giveaways.
18. `b1_2_sprechen_geschichte` — lines use Präteritum action verbs after teaching Perfekt for actions; kurzcheck/dialog then penalise the mixing.
19. `b1_2_lesen_technik`, `b1_2_hoeren_podcast`, `b1_1_lesen_studium`, `b1_1_lesen_arbeit` — tips quote sentences not in the text.
20. `b1_1_sprechen_kurzcheck`, `b1_2_sprechen_kurzcheck`, `b1_2_sprechen_dialog` — spec vs Help Memory mismatch; "active instead of passive" is not an error.
21. `b1_1_konj2_haette` mnemonic count wrong; s7 needs möchte outside the stated set. `b1_1_adj_unbestimmt` "R-S-E" chant doesn't match "er-es-es".
22. `b1_2_lesen_anekdote` — "next quiz introduces hätte+PII" but that quiz precedes it.
23. `b1_1_hoeren_interview` — two speakers, one unlabeled block.
24. `b1_2_diktat_praeteritum` — "a small story" that jumps between a dog, a girl, a train, a fire.
25. `b1_2_technik` context uses Konjunktiv I before it's taught; `b1_2_partizip_adj_intro` context "zerlesene", "kochende Kaffeemaschine".
26. `b1_1_adjektive_als_nomen` / `b1_2_n_deklination` — near-identical; `b1_2_relativ_dat` only 3/15 genitive; um…zu ×3; *statt* in a title, never drilled.
27. `b1_2_indem_sodass` s3/s7/s11/x14 and all of `b1_2_konnektoren_zweiteilig` — two-gap items (§1.5).
28. `b1_1_bigtext_wohnung` intro "seven sentences" but 8 gaps.
29. ASCII-umlaut alternates accepted arbitrarily (Ueberstunden yes, haette no) — moot while relaxed folding is on, but see §1.12.

### B2.1 / B2.2
1. All passages 55–95 words (§2.1); `b2_2_lesen_textergaenzung` 5 gaps vs 10 in the exam; gap (3) has two defensible options.
2. `b2_1_modalpassiv` 13/15 = werden; `b2_1_passiv_perfekt` 11/15 = worden; Perfekt form in tips never tested.
3. `b2_1_indirekt_fragen` — A2 content; Konjunktiv I/solle/wo(r)- promised, absent.
4. `b2_2_umwelt` s10–s14, `b2_1_gesellschaft` — A1/A2 vocabulary; intro's B2 words untested; only two theme sets at the level.
5. Speaking spec mismatches (§2.8).
6. Four speakRepeat quizzes: 6 lines, intro promises 8 (§2.7).
7. `b2_1_diktat_argument`, `b2_2_diktat_irreal` — promised features absent.
8. `b2_2_irreal` s1 — "Wenn du fragst, würde ich" breaks the quiz's own rule.
9. `b2_2_konzessiv` s3 — "Zwar teuer, ist es …" not German.
10. `b2_2_konsekutiv_modal_nominal` s11 — "ohne dass jemand unterstützte" (transitive, no object); s8 clunky.
11. `b2_2_verweiswoerter` s6 — masculine "Ersterer … letzterer" accepted for feminine Optionen.
12. `b2_2_adversativ` s5 — stray colon in key.
13. `b2_2_futur2` s5 — Futur I labelled Futur II; s1 "schon" doubled; "…" keys (§1.5). Also `b2_1_kausal_nominal` s10, `b2_2_relativ_wer_was` s0/s1, `b2_2_relativ` s5 (", was"), `b2_1_stellungnahme` s6/x13 trailing commas.
14. `b2_1_konnektoren`, `b2_2_konzessiv`, `b2_2_genitiv_praep`, `b2_2_modalpartikeln` — one of an interchangeable family accepted (§2.4); particle hints give the answer.
15. `b2_2_fvg` — hints print the answer; s3/s4 print the FVG in the stem; s11 stattfinden isn't an FVG; "Druck aus-" garbled.
16. `b2_1_verben_praep` s3 — *auf* also grammatical, only über accepted.
17. `b2_2_sollen_subjektiv` s9 — objective reading; `b2_1_lassen` s8 "Sie half mir tragen" marginal.
18. `b2_1_mittelfeld` s4 "fliegt mit dem Flugzeug"; x13 one of several neutral orders; author note in subject (§1.15).
19. `b2_1_kausal_nominal` s5/s6 — "weil ein Sturm war", "weil die Ergebnisse so waren" placeholders.
20. `b2_2_konj2_verg` s6/s9 English wrong ("He almost won"); "bräuchte" called literary (it's colloquial).
21. `b2_2_indefinit` context "die finden einem alles" unidiomatic; translation nonsense.
22. `b2_1_partizip_adj` MISTAKES garbled; near-duplicate of `b2_2_partizip_attribut` and B1-level.
23. `b2_1_hoeren_nachrichten` — indicative sollen + Konjunktiv I während in one sentence.
24. `b2_1_nomen_praep` — tip lists *Interesse für*, MISTAKES marks it wrong.
25. `b2_2_als_ob` mnemonic offers indicative *hört*, trap calls it an exam error.
26. `b2_1_zustandspassiv` — "von einem Erdbeben" marked wrong; standard.
27. `b2_1_nachsilben_genus` — "-or … n-Deklination" false; "das Tor" example misleading.
28. `b2_1_adjektive_praep`, `b2_1_nomen_praep` templates — "guess the example" ("stolz auf seine Tochter" with subject Sie).
29. Redundancy: trotzdem family ×4, wegen/trotz/während ×3; `b2_2_genitiv_praep` tests 6 of 14 listed. `b2_1_konj1` 15× third-person singular only.
30. Giveaway MC: `hoeren_debatte` Q1, `hoeren_nachrichten` Q1/Q5, `hoeren_vortrag` Q5, `hoeren_fachinterview` Q3, `lesen_leserbrief` Q5.

### C1.1 / C1.2
1. `c1_1_hoeren_vorlesung` Q1 key "ob …" contradicts the quiz's own tip ("not ob but inwiefern").
2. Two listening quizzes titled "undefined" (§1.3).
3. `c1_1_attribute` context — "Herr Klein, ihrem Stellvertreter" → *Herrn*; empty category entry.
4. `c1_2_modal_hoerensagen` — tip example "… und will der Händler legal erworben haben" ungrammatical; "Der Minister soll zurücktreten" read objectively.
5. `c1_2_modal_vermutung` context — "Eingebrochen worden sein kann aber nicht" not German; s12 objective können.
6. `c1_2_lesen_literatur` — tips built on an image not in the passage; participial clauses promised, absent.
7. `c1_1_lesen_sprachbausteine` gap (3) — non-reflexive *erinnerten* (jargon); learners will reject the key.
8. `c1_2_redewendungen` s11 — *nicht mein Bier* glossed "not my thing" (= not my business).
9. `c1_1_tempuswahl` s9 — junk key "ergab / hat ergeben"; "…" keys (§1.5); muddled context.
10. `c1_1_adverbialsaetze`/`_2` — category labels as keys, *als* accepted for "Es kam ____ erwartet".
11. `c1_2_redemittel_vortrag`, `c1_2_schreiben_forum_beschwerde`, `c1_2_praefixe` — untypeable keys (§2.5).
12. Under-acceptance: `c1_1_bildung` (Nachweis, Masterarbeit), `c1_1_verbalisierung` (da/obgleich/seit/falls), `c1_1_genitiv_schriftsprache` (hinsichtlich vs bezüglich; *laut* "+ Genitiv" contradicted by own key), `c1_2_modal_vermutung` s14, `c1_2_kohaesion`, `c1_2_umformung_1` (ist lösbar, ungeachtet; x13 = s7), `c1_2_register_formell` (single formal rendering), `c1_2_kultur` s11 (vermitteln), `c1_2_numerus_gender` s9 (Lehrende), `c1_2_wortbildung_vor` s2 (entkommen).
13. `c1_1_attribute` s9 — comma before dependent infinitive should be primary.
14. `c1_1_partizipialsatz` — comma after participial group is optional, not an error; tip contradicts itself; s3 unnatural.
15. `c1_1_konnektoren` — "um so mehr" is pre-1996 (umso).
16. `c1_1_tempuswahl` trap E17 — Präteritum/Perfekt ≠ English simple/present perfect, even in writing.
17. `c1_1_verbalisierung` vocab "infolge → sodass" wrong twin.
18. `c1_2_wortbildung_nach` — "Einsamkeit" not an exception; context sentences nonsensical.
19. `c1_2_numerus_gender` — "ein Möbel doesn't exist" (Duden lists it).
20. `c1_2_register_formell`, `c1_2_schreiben_forum_beschwerde` — comma after "Mit freundlichen Grüßen"; tip keeps *Bescheid geben* after telling learner to replace it.
21. `c1_2_sprechen_abschwaechen` "Vermutlich dürfte" double hedge; `c1_2_sprechen_ironie` advises irony in the exam; s2 English wrong.
22. `c1_2_hoeren_interview_stimmt` Q1 — keyed *stimmt nicht*, text supports *nicht gesagt*.
23. Passages B2 length; giveaway distractors; only three passages C1-shaped (§2.1).
24. Hint = answer: `c1_1_passiversatz` (never tests bekommen-Passiv/reflexive/gehören it introduces), `c1_2_wortbildung_vor`, `c1_1_bar_lich`, `c1_1_nominalisierung`.
25. `c1_2_modal_hoerensagen` (15× soll/will), `c1_1_verbalisierung` — B2 mechanics.
26. Four speakRepeat: 6 lines vs 8 promised; `sprechen_ironie` s4/s5 not ironic.
27. `c1_1_diktat_nominalstil` promises absent; `c1_2_diktat_idiom` recycles sentences verbatim.
28. Redundancy/gaps (§2.10, §2.11); `sprechen_dialog` names *geschweige denn*, taught nowhere; exam model inconsistent (2010 vs 2024 format).

### C2.1 / C2.2
1. All passages 60–100 words with joke distractors (§2.1); only `lesen_amtliches_schreiben` and `lesen_lyrik` are genre-true.
2. Seven quizzes whose intro quotes a different text (§2.3).
3. Whole-sentence exact match and unguessable template keys (§2.4, §2.5).
4. Kaléko copyright claim (§1.13); textbook named (§1.14).
5. Vocabulary quizzes B1–B2 in A2 frames: `c2_1_wirtschaft`, `c2_2_philosophie`, `c2_2_wortspiel` (answer = headword ×6), `c2_1_sprichwoerter`, `c2_1_kollokationen`.
6. Four speakRepeat: 6 generic lines vs 8 promised with named devices; `c2_1_diktat_register` promised features absent.
7. `c2_1_lesen_kurzgeschichte` — "ihr gegenüber" for a dead wife; translation compounds it.
8. `c2_1_lesen_artikel` tip — weak-verb Konjunktiv II "entdeckten" is identical to Präteritum, so the "tells you who is speaking" claim is false for the example.
9. `c2_2_philosophie` — vocab "der freier Wille", "das / der Mittel / Zweck"; s7 Verhalten rejected though glossed; s10 "freien Willen" rejected; "nearly all feminine" contradicted by own vocab.
10. `c2_2_fokus` — Selbst/Sogar accepted inconsistently for the same hint; s14 Gerade vs own vocab ausgerechnet; s2/s5/s7 alternatives rejected.
11. `c2_1_register` — Geld as "formell", beginnen/unterstützen as "gehoben"; bekommen/stehlen/äußern/prüfen rejected though listed in the intro.
12. `c2_1_kollokationen` — "ein starkes Argument" marked wrong (it's standard); trap garbled; fällen/einreichen rejected.
13. `c2_1_wirtschaft` — "ein Gesetz erlassen" marked wrong; context legally nonsensical (Einspruch against a statute).
14. `c2_2_paraphrase` — "ums Leben kommen" as elevated *sterben* contradicts own trap; "den Anfang machen" ≠ begin sth; tip "geschah keinerlei" ungrammatical.
15. `c2_2_wissenschaftssprache` s1 — "der Plan ist kritisch"; s3/s10/s13 alternatives rejected.
16. `c2_2_hoeren_fachvortrag` — Konjunktiv I after "die Forschung deutet darauf hin" (not reported speech).
17. `c2_1_komparation_advanced` s3 — two blanks, "…" key.
18. `c2_2_appositionen` — trailing-comma keys, "roten Weins" rejected, author notes (§1.15).
19. `c2_2_modalverben_system` — author monologue in context; "kann man ihm nicht vorwerfen" mislabelled subjective.
20. `c2_2_nominalstil` — keys are fragments; the correct exam answer (with *erfolgte*) fails; "never von" overstated.
21. `c2_2_behoerdensprache` — Geldstrafe for an Ordnungswidrigkeit (should be Geldbuße), contradicting own trap.
22. `c2_1_adjektivbildung` — "-frei positive / -los negative" wrong as a rule; nonsense contexts.
23. `c2_1_konnotation` — neugierig/alt/Problem as negatives; alternatives rejected.
24. `c2_1_stilmittel` s8 Litotes rejected; `c2_2_anspielung` s12 mislabelled, s7 A1 gap, tip overstates.
25. `c2_1_umformung_2` — x13 accepts unidiomatic "Vor seinem Gehen", rejects Aufbruch; s3 requires typographic quotes.
26. `c2_2_adverbialsaetze_umformen` s7 — expected form unnatural; x14 rejects *kann*; *da* listed as main-clause connector.
27. `c2_2_passiv_meisterschaft` — learner must guess lexical content; x12 demands a form the tip calls rare.
28. Big texts ~70 words; `bigtext_vorstand` "Kritiker üben scharfe Kritik" tautology; `bigtext_lesen` gap 0 rejects indicative.
29. `c2_1_konj1_lit` — single-verb gaps; the C2 skill (sustaining mood across a paragraph) untested.
30. Redundancy: register pairs verbatim in three quizzes; "nicht schlecht" in four; nominal↔verbal twice; FVG three times.
31. `c2_2_wortspiel`, `c2_1_sprichwoerter` — garbled vocab/MISTAKES entries.
32. `c2_1_sprechen_dialog` — "use one proverb" pushes folksy language into a C2 exam turn.

---

## 4. Suggested order of work
1. Engine/data fixes that are wrong today: §1.1–§1.5, §1.12, MC option shuffle (§2.2).
2. IP: §1.13, §1.14.
3. The eleven template quizzes that emit ungrammatical German (§1.6–§1.11) and the
   author-note leaks (§1.15).
4. Passage/intro consistency pass on every reading/listening quiz (§2.3), then rewrite
   the receptive texts to level length from B1 up (§2.1).
5. Accepted-answer widening or MC conversion for connector/particle/transformation items
   (§2.4, §2.5); un-hint the copy drills (§2.6).
6. Bring speakRepeat banks to 10 and align intros (§2.7); align speaking specs (§2.8).
7. Syllabus additions (§2.11) and de-duplication (§2.10).
