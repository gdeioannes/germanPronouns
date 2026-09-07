# en_de_ai — "German with Your AI Coach" (English → German, A1.1–C2.2)

A course built **entirely** on the external-AI prompt system. Every exercise
is a carefully engineered prompt the learner copies into their own AI
assistant (voice or text); the AI runs the exercise and grades it; the
learner pastes the `SCORE=` report back. The app is, deliberately and
transparently, the **curriculum + logbook**: it authors world-class prompts,
sequences them A1.1 → C2.2, and records what was done and how it went —
medals, coins, gated progression, retakes, best scores. It hosts no LLM and
stores one number per run, exactly the contract in
`docs/speaking_quiz_feature.md`.

## 1. Positioning & transparency

- **Audience**: English speakers (UiLang.en) learning German, A1.1 → C2.2.
- **Pitch (course card / intro, stated plainly)**: "A complete German course
  that runs inside the AI you already use. We wrote the curriculum and the
  prompts; your AI runs the exercises; this site keeps score." No pretense
  that the app runs anything itself — that honesty is the brand.
- The course intro doubles as AI setup: which assistants work (tested with
  Gemini free tier), how to enable voice, why grades vary between AIs, and
  the stay-with-one-assistant advice. Existing disclaimer surfaces carry over.
- An AI assistant is **required** — unlike the cert chains, the dependency IS
  the course, so AI exercises may gate freely.

## 2. Prompt engineering is the product

Every prompt is assembled by `SpeakingPromptBuilder` from the static template
(tutor contract: no mid-session corrections, target-language-only, report
rules, `SCORE=` line) plus a **rich authored payload**. The payload is where
this course invests — each exercise ships real curriculum data, not a vague
topic line:

- **`targetVocabulary`** — 10–20 specific words/chunks per exercise, drawn
  from the module's word list (see §5). The AI steers the learner into using
  them, never shows the list, and reports which stayed unused. Vocab-drill
  modes DO show and quiz them directly.
- **`practisePoints`** — named grammar concepts with example forms
  ("Perfekt with sein: *ich bin gefahren*"), mirrored from the de_cert_a1 /
  en_de curricula so levels mean the same thing across courses.
- **`topic`** — a concrete scenario, not a category: "You are ordering at a
  Berlin Currywurst stand and the seller is out of everything you ask for."
- **`scoringCriteria` + `priorityErrors`** — per-level: A1 grades verb-second
  and gender; C2 grades register, idiomaticity, nominal style.
- **`generation` constraints** for AI-authored material (word count, allowed
  tenses, required forms, "no vocabulary above level X").

Content reference: reuse the existing curricula as the source of truth —
`de_cert_a1` quest chain (A1.1–C2.2 competency arc,
`docs/a1_competency_matrix.md`), `en_de` grammar modules M1–M17 (grammar
inventory), and the shared German noun/verb collections (word lists with
conjugation sets). The AI course re-expresses the same syllabus as prompts.

## 3. The exercise repertoire (variety is the rhythm)

All modes ride `QuizKind.speaking` + `SpeakingExercise` + `SCORE=` + best
score storage (keys immutable). `SpeakingMode` grows additive values (old
parsers fall back to `conversation` — seed-safe). Per-mode template sections
(`how_to_run.<mode>`) join the parity test.

**Talk** (voice, text fallback):
- `conversation` / `interview` / `roleplay` — existing, scenario-rich.
- `storytelling` **(new)** — the AI gives a story skeleton (pictures in
  words: setting, 4 beats, required tense + 8 vocabulary items); the learner
  tells the story; the AI asks two follow-ups, then grades.
- `listenRetell` **(new)** — the AI tells a short story aloud and the learner
  retells it and answers inference questions.

**Words** (text-first):
- `vocabDrill` **(new)** — direct word questioning, both directions, with
  spaced re-asks of missed words within the session; the prompt carries the
  exact word list + meanings from the module.
- `wordGame` **(new)** — little games, one per prompt: word-chain
  (last-letter), "taboo" (describe without saying it), odd-one-out with
  justification, 20-questions in German, "the AI lies about word meanings —
  catch it". Games have explicit scoring rules so `SCORE=` stays meaningful.

**Read & write** (text-first):
- `readingQa` **(new)** — the prompt embeds a passage we authored; the AI
  presents it and asks comprehension + inference questions, grades, reports.
- `readingGen` **(new)** — the AI writes a fresh passage under our
  constraints, then quizzes on it — infinitely replayable.
- `writing` **(new)** — a concrete writing task (complaint email, story
  continuation, opinion paragraph) graded against a rubric in the prompt.
- `translationDrill` **(new)** — English sentences targeting the module
  grammar, translated to German, per-sentence partial credit.

Payload additions (JSON-additive, all optional): `passage`, `wordList`
(word + meaning pairs for drill/game modes), `generation`, `storyBeats`,
`gameRules`.

UI: `SpeakingQuizPage` gets per-mode step lists (no trigger-phrase/voice step
for text-first modes) and a mode badge + duration on the quiz tile so the
learner can pick by mood.

## 4. Course structure — 12 gated modules, A1.1 → C2.2

`NavGroup.gated` pass-to-unlock chain. No placement test (placement needs
auto-checkable questions; this course has none) — course home offers "pick
your level" via the existing starting-point sheet instead.

The grammar ladder is the **`de_cert` ladder verbatim**
(`docs/de_certification_a1_c2_plan.md` §1): one "big rock" per module,
spiraled (cases before adjective endings; Konjunktiv II → I → II past;
passive intro → all tenses → Ersatzformen), Goethe Wortlisten as the A1–B1
vocabulary anchor. Each module below lists its can-do goals, precise grammar
inventory, vocabulary domains (the ~40–60 item module word list is authored
from these), and the full 10-exercise lineup with what each prompt carries.

### M1 · A1.1 — *Erste Schritte* (First steps)

- **Can-do:** greet and introduce yourself; say age, origin, languages,
  job; count 0–100; ask and answer W-questions; order a drink.
- **Grammar:** `sein`/`haben` present; regular present tense (-e/-st/-t);
  verb-second; W-questions (wer/was/wo/woher/wie); der/die/das + ein/eine
  (nominative); common plurals; personal pronouns (nominative).
- **Vocabulary domains:** greetings & courtesy (Hallo, Tschüss, bitte,
  danke), family (Mutter, Bruder, Eltern…), numbers 0–100, countries &
  languages, professions, café items (Kaffee, Wasser, Kuchen), colours.
- **Exercises:**
  1. `vocabDrill` — "Meet your first 20 words": greetings + family, both
     directions, gender always required with every noun.
  2. `conversation` — first contact: the AI is a friendly stranger at a
     language-café; introduce yourself, ask them 3 W-questions back.
     Vocab steer: family + origin words.
  3. `translationDrill` — 10 English sentences onto verb-second and
     sein/haben ("I am tired. My brother has a dog.").
  4. `wordGame` — gender casino: the AI bets coins-of-honour on noun
     genders, learner calls der/die/das, AI explains patterns (-e→die,
     -chen→das) after each round.
  5. `vocabDrill` — numbers 0–100 + prices: the AI quizzes numbers aloud
     and as digits, then mixes in "Was kostet…?" price answers.
  6. `readingQa` — embedded passage "Das bin ich" (5-sentence
     self-introduction, A1-locked); AI asks 5 comprehension questions.
  7. `storytelling` — picture-in-words: describe the AI's imaginary family
     photo (it narrates who is in it, learner retells: "Das ist…, er
     ist…"); required forms: sein + nominative articles.
  8. `roleplay` — mid-checkpoint: order at a Berlin café; the AI is the
     waiter and is out of the first two things ordered.
  9. `writing` — 5 sentences introducing yourself to a tandem partner;
     rubric: verb-second in every sentence, ≥3 module vocab domains used.
  10. `interview` — **gate**: the AI interviews "for the A1.1 diploma":
      8 questions across all module domains; priorityErrors: verb-second,
      article gender, pronoun choice.

### M2 · A1.2 — *Im Alltag* (Everyday life)

- **Can-do:** describe a daily routine with times; shop for food and ask
  prices; say what you like/don't like; make simple negative statements;
  name days, months, appointments.
- **Grammar:** **accusative** (articles, pronouns, kein); kein vs nicht;
  modal verbs (können/müssen/möchten); separable verbs (aufstehen,
  einkaufen); possessive articles; clock time (colloquial + formal); am/im/um
  temporal prepositions; gern/lieber.
- **Vocabulary domains:** daily-routine verbs, food & drink + supermarket,
  clock/calendar words, household objects, hobbies & free time.
- **Exercises:**
  1. `vocabDrill` — routine verbs incl. separable prefixes: the AI asks
     "What do you do at 7:00?" forcing *ich stehe … auf* word order.
  2. `translationDrill` — accusative gauntlet: 12 sentences pitting
     den/einen/keinen against nominative lookalikes.
  3. `readingQa` — "Im Café" ordering scene (from the cert reading
     catalogue); questions include two price/time extractions.
  4. `conversation` — your typical Tuesday, morning to night; AI enforces
     ≥4 separable verbs and 3 exact times; steers to hobby vocab.
  5. `wordGame` — "Einkaufs-Taboo": describe 8 supermarket items without
     saying them (der runde, rote Obst… nein, sag es nicht!); AI guesses.
  6. `vocabDrill` — food & drink with kein: "Do you have milk?" — "Nein,
     ich habe keine Milch"; AI re-asks every missed item.
  7. `roleplay` — market stall haggling-lite: buy 5 items, ask prices,
     refuse one politely (möchte/kein).
  8. `storytelling` — "Ein chaotischer Morgen": story skeleton with 4
     beats (overslept → no coffee → bus missed → happy end), required:
     separable verbs + times.
  9. `writing` — a note to your flatmate: what you're buying, when you're
     back, what they should do (modal verbs; 6–8 sentences).
  10. `interview` — **gate**: day-in-your-life interview; priorityErrors:
      accusative endings, kein/nicht choice, separable-verb order.

### M3 · A2.1 — *Erlebnisse* (Experiences)

- **Can-do:** tell what happened yesterday/last weekend; describe a trip;
  give and follow directions; talk about locations and giving/receiving.
- **Grammar:** **Perfekt** with haben/sein (regular + core irregular
  participles); **dative** articles & pronouns; dative verbs (helfen,
  gefallen, gehören); dative prepositions (mit/nach/bei/von/zu/aus);
  imperative (Sie/du); ordinal numbers & dates.
- **Vocabulary domains:** travel & transport, city places & directions,
  weekend activities, gifts & celebrations, weather basics.
- **Exercises:**
  1. `vocabDrill` — participle pairs: infinitive ↔ Perfekt (gehen → ist
     gegangen), haben/sein auxiliary always demanded.
  2. `conversation` — "Wie war dein Wochenende?" — strictly in Perfekt;
     the AI asks follow-ups only about things already mentioned.
  3. `translationDrill` — dative targets: 12 sentences on mit/zu/bei +
     dative verbs ("She helps her brother", "The gift is from my aunt").
  4. `wordGame` — "Wo bin ich?": the AI describes city locations with
     dative prepositions, learner guesses the place; then roles swap.
  5. `readingQa` — postcard from a trip gone slightly wrong (A2-locked,
     full of Perfekt); inference question: why was the writer happy anyway?
  6. `roleplay` — lost in Munich: ask a local (the AI) for directions to
     three places; the AI uses imperative, learner must confirm back.
  7. `storytelling` — retell "the best trip of your life" (real or
     invented): skeleton beats + required forms: 6 Perfekt verbs, 2 sein-
     auxiliary, 3 dative prepositions.
  8. `listenRetell` — the AI narrates a 60-second anecdote aloud (voice),
     learner retells it in Perfekt and answers 3 questions.
  9. `writing` — a thank-you message after staying with a host family
     (dative verbs: danken, gefallen, helfen).
  10. `interview` — **gate**: past-weekend + directions mixed interview;
      priorityErrors: auxiliary choice, participle forms, dative endings.

### M4 · A2.2 — *Beschreiben & Planen* (Describe & plan)

- **Can-do:** describe rooms/positions precisely; compare things; make
  plans and appointments; explain simple reasons; talk about health.
- **Grammar:** **Wechselpräpositionen** (wo+Dat/wohin+Akk); subordinate
  clauses with weil/dass/wenn (verb-final); comparative & superlative;
  Futur with werden (intro); body & health expressions (wehtun + dative);
  temporal clauses (als/wenn intro).
- **Vocabulary domains:** furniture & rooms, appointments & scheduling,
  body & health, comparisons (adjective pairs), plans & intentions.
- **Exercises:**
  1. `vocabDrill` — furniture with both cases: "Where is the lamp?" (Dat)
     vs "Where do I put the lamp?" (Akk), the two-way prepositions live.
  2. `wordGame` — "Mein Zimmer, dein Zimmer": memory game — the AI
     describes its room in 6 sentences, learner reconstructs positions,
     then describes their own; AI checks case choice sentence by sentence.
  3. `translationDrill` — weil/dass verb-final: 12 sentences whose English
     order must be broken ("I'm tired because I slept badly").
  4. `conversation` — making weekend plans together; AI creates two
     scheduling conflicts the learner must resolve (wenn-clauses).
  5. `readingQa` — flat-viewing ad + a renter's email (two short texts);
     cross-text question: does the flat fit what the renter wants?
  6. `roleplay` — doctor's appointment: describe 3 symptoms (wehtun +
     dative), understand the advice, negotiate a follow-up date.
  7. `vocabDrill` — adjective pairs & comparatives: alt/älter/am ältesten
     across 15 pairs, then "compare these two things" mini-prompts.
  8. `storytelling` — "Als ich klein war": 4 beats contrasting then/now
     (comparatives + weil).
  9. `writing` — describe your dream room for a design blog (8 sentences,
     ≥6 position phrases, ≥3 comparatives).
  10. `interview` — **gate**: describe-compare-plan interview;
      priorityErrors: two-way preposition case, verb-final order.

### M5 · B1.1 — *Meinungen & Wünsche* (Opinions & wishes)

- **Can-do:** state and defend opinions; express wishes and polite
  hypotheticals; describe people/things with full adjective phrases; talk
  about work and living situations.
- **Grammar:** **Konjunktiv II present** (würde/hätte/wäre/könnte);
  **adjective endings** (all three declension patterns); reflexive verbs;
  verbs with prepositions (sich freuen auf/über…); Nebensätze expanded
  (obwohl, damit, um…zu).
- **Vocabulary domains:** work & office life, flat-share/living together,
  opinion & discussion phrases (meiner Meinung nach…), character
  adjectives, feelings.
- **Exercises:**
  1. `vocabDrill` — character adjectives **with endings**: the AI gives
     noun+case frames ("ein ___ Kollege / mit meiner ___ Chefin"),
     learner supplies inflected adjectives.
  2. `conversation` — flat-share conflict: the dishes rota has collapsed;
     express annoyance politely (Konjunktiv II: könntest du…, ich hätte
     gern…) and negotiate a fix.
  3. `translationDrill` — wish machine: 12 English "I would/could/If only"
     sentences into würde/hätte/wäre forms.
  4. `wordGame` — "Advocatus Diaboli": AI states 5 mild opinions (Katzen
     sind besser als Hunde), learner must disagree with obwohl/damit +
     one adjective-ending noun phrase per turn.
  5. `readingQa` — two job ads + a candidate profile; judgment question:
     which job fits and why (answer needs weil + Konjunktiv).
  6. `writing` — polite complaint email to a landlord (Konjunktiv II
     requests, ≥5 inflected adjective phrases).
  7. `vocabDrill` — verbs with prepositions: sich freuen auf/über,
     warten auf, sich ärgern über — the AI drills the pairing then forces
     free sentences.
  8. `storytelling` — "Mein Traumjob": beats from morning commute to
     evening, told in Konjunktiv II throughout (würde-forms).
  9. `roleplay` — job interview (the friendly kind): strengths,
     weaknesses, wishes; AI probes with "Warum?" twice.
  10. `interview` — **gate**: opinions round-table on 3 everyday theses;
      priorityErrors: adjective endings, Konjunktiv formation, verb-final.

### M6 · B1.2 — *Erzählen & Begründen* (Narrate & justify)

- **Can-do:** narrate past events in written style; summarize a story;
  describe processes; justify decisions in connected speech.
- **Grammar:** **Präteritum** (narrative: sein/haben/modals + strong
  verbs); **Passiv present/past** (werden + Partizip II); relative clauses
  (nom/akk/dat); als vs wenn mastered; Plusquamperfekt intro; n-deletion
  nouns (der Junge, den Jungen).
- **Vocabulary domains:** storytelling verbs & fairy-tale register,
  processes & manufacturing lite ("wie wird … gemacht"), news/event
  words, justification connectors (deshalb, daher, nämlich).
- **Exercises:**
  1. `vocabDrill` — strong-verb Präteritum ladder: gehen/ging,
     kommen/kam… 20 verbs, then instant micro-sentences.
  2. `storytelling` — modern fairy tale: the AI provides a scrambled
     Grimm-style skeleton; tell it in Präteritum with es-war-einmal
     framing; ≥2 relative clauses required.
  3. `translationDrill` — passive shift: 10 active English sentences into
     German passive ("The bridge was built in 1900").
  4. `readingQa` — short newspaper item (B1-locked, Präteritum-heavy);
     questions include one "find the passive sentence and re-activate it".
  5. `wordGame` — "Was wird hier gemacht?": AI mimes professions in words
     (nur Passiv-Sätze), learner guesses; then learner describes, AI
     guesses.
  6. `conversation` — "the decision that changed things": narrate a life
     decision (real/invented), justify with deshalb/nämlich; AI challenges
     one justification.
  7. `listenRetell` — AI reads a 90-second radio-style news miniature
     aloud; retell in own words + 3 detail questions.
  8. `writing` — accident report for an insurance form: what had happened
     (Plusquamperfekt), what happened (Präteritum), what was damaged
     (Passiv).
  9. `roleplay` — witness interview: the AI is a police officer, learner
     recounts a (silly) bicycle incident; relative clauses to identify
     people ("der Mann, der…").
  10. `interview` — **gate**: narrate-and-justify session across module
      topics; priorityErrors: Präteritum forms, passive construction,
      relative pronoun case.

### M7 · B2.1 — *Argumentieren* (Argue)

- **Can-do:** argue a position with structured pros/cons; report what
  others said; moderate disagreement; understand editorial text.
- **Grammar:** **Konjunktiv I** (reported speech, incl. fallback to K II);
  passive in all tenses + with modals (muss gemacht werden);
  Partizipialattribute intro (die steigenden Preise); concessive &
  consecutive connectors (dennoch, folglich, je…desto).
- **Vocabulary domains:** media & news, environment & climate debate,
  argumentation scaffolds (einerseits…andererseits, es lässt sich nicht
  leugnen), statistics language (die Mehrheit, der Anteil).
- **Exercises:**
  1. `vocabDrill` — argumentation scaffolds as chunks: the AI gives a
     bare claim, learner must re-express it through an assigned scaffold.
  2. `readingQa` — editorial on e-scooters (B2-locked); questions target
     author stance, one reported-speech transformation.
  3. `translationDrill` — reported speech: 10 "She said that…" sentences
     into Konjunktiv I with correct fallbacks.
  4. `conversation` — structured debate: learner draws the anti position
     on "cars out of city centres"; 2 rounds of argument + rebuttal;
     je…desto sentence mandatory.
  5. `wordGame` — "Schlagzeilen-Poker": AI shows 6 headlines, some fake;
     learner interrogates it (reported speech: die Zeitung schreibe…),
     then calls fake/real with justification.
  6. `writing` — Leserbrief (letter to the editor) responding to the M7
     reading passage: 120 words, thesis + 2 arguments + concession.
  7. `listenRetell` — AI delivers a 2-minute panel statement aloud;
     learner reports it to a "colleague" entirely in reported speech.
  8. `vocabDrill` — statistics language with a twist: AI gives numbers
     ("Der Anteil stieg von 20 auf 35 Prozent"), learner verbalizes
     charts-in-words both directions.
  9. `roleplay` — talk-show: the AI is a provocative guest, the learner
     the moderator — summarize, challenge, keep order (dennoch, folglich).
  10. `interview` — **gate**: defend a drawn position for 4 exchanges,
      then switch sides mid-way on command; priorityErrors: K I forms,
      passive with modals, connector logic.

### M8 · B2.2 — *Differenzieren* (Differentiate)

- **Can-do:** discuss what could/should have been; qualify statements
  precisely; handle formal work communication; read contract-adjacent prose.
- **Grammar:** **Konjunktiv II Vergangenheit** (hätte machen sollen —
  irreal past incl. with modals); full Partizipialattribute (der von der
  Firma entwickelte Plan); **Genitiv** + genitive prepositions (trotz,
  während, aufgrund, infolge); Nominalstil intro; modal particles (doch,
  ja, eben, halt) receptively + first productive use.
- **Vocabulary domains:** professional life & applications, negotiation
  phrases, regret & evaluation language, formal correspondence formulas.
- **Exercises:**
  1. `vocabDrill` — genitive prepositions in formal frames: trotz des
     Wetters, aufgrund der Verspätung — 15 frames then free production.
  2. `conversation` — "Das hätte ich anders gemacht": the AI tells 4 short
     decision stories; the learner evaluates each in irreal past.
  3. `translationDrill` — unpacking participles: 8 English relative-clause
     sentences into Partizipialattribute and back.
  4. `readingQa` — excerpt of a (simplified) rental contract + cover
     letter; questions: obligations, one trotz/aufgrund paraphrase.
  5. `wordGame` — "Partikel-Gefühl": same sentence, different particles
     (Komm doch! / Komm halt!); learner picks the speaker's mood, then
     produces particle sentences the AI mood-guesses.
  6. `writing` — formal application email for a fictional job (from the
     M5 dream-job thread), full formal register + 2 nominal-style phrases.
  7. `storytelling` — "Beinahe-Katastrophe": tell a near-miss story, then
     replay it as what would have happened (wäre…gewesen, hätte…müssen).
  8. `roleplay` — salary negotiation: AI is the budget-shy boss; learner
     uses concessions + Konjunktiv II courtesy without folding twice.
  9. `listenRetell` — voicemail chain (AI speaks 3 short voicemails);
     learner summarizes the situation and what should have been done.
  10. `interview` — **gate**: professional scenario mix; priorityErrors:
      irreal past with modals, genitive forms, register slips.

### M9 · C1.1 — *Abstrahieren* (Abstract)

- **Can-do:** discuss abstract/societal topics; compress verbal prose into
  nominal style and unpack it; use passive alternatives naturally.
- **Grammar:** **Nominalstil ↔ Verbalstil** transformations;
  Passiversatzformen (sein + zu, sich lassen, -bar); subjectless passive
  (es wird…/hier wird…); extended participial constructions; advanced
  connectors (insofern, gleichwohl, zumal).
- **Vocabulary domains:** society & politics, science-for-laypeople,
  academic verbs (darstellen, erörtern, zugrunde liegen), abstract nouns
  with their verb partners (die Entwicklung ↔ entwickeln).
- **Exercises:**
  1. `vocabDrill` — noun↔verb partners: 20 abstraction pairs, each
     direction, then embed in a sentence on demand.
  2. `translationDrill` — style transformer: 8 verbal sentences → nominal
     style, 4 nominal monsters → clean verbal German.
  3. `readingQa` — popular-science piece (C1-locked, e.g. sleep research);
     one question demands paraphrasing a sein+zu construction.
  4. `conversation` — town-hall on a societal question (e.g. four-day
     week): learner must produce 2 Passiversatz forms and one zumal.
  5. `wordGame` — "Bürokratie-Duell": AI states simple facts, learner
     inflates to maximal Amtsdeutsch; then deflation round — most
     accurate transformations win.
  6. `writing` — abstract (100 words) of the M9 reading passage in
     nominal style, then a 3-sentence plain-language version.
  7. `listenRetell` — AI lectures 2 minutes on an invented study; learner
     reconstructs method-result-implication.
  8. `storytelling` — "Die Stadt in 30 Jahren": structured speculation,
     subjectless passives required (es wird gebaut werden…).
  9. `roleplay` — expert panel: learner is the expert, AI a skeptical lay
     host demanding plain-language unpacking of jargon on the spot.
  10. `interview` — **gate**: abstract-topic examination with one forced
      register shift; priorityErrors: style-transformation accuracy,
      Ersatzform choice, connector precision.

### M10 · C1.2 — *Nuancieren* (Nuance)

- **Can-do:** convey attitude and inference; read between lines of
  literary/journalistic text; handle idioms and word formation actively.
- **Grammar:** **subjective modals** (er muss/dürfte/soll/will es getan
  haben); Wortbildung (Ver-/Ent-/Zer-, -ung/-heit/-keit/-bar/-los);
  idioms & collocations; rhetorical devices (irony markers, litotes);
  aspect-like nuances (gerade dabei sein zu…).
- **Vocabulary domains:** culture & film & literature, humor & irony
  vocabulary, 30 core idioms (jmdm. die Daumen drücken…), evaluative
  adverbs (angeblich, offenbar, keineswegs).
- **Exercises:**
  1. `vocabDrill` — idiom decoder: literal image → meaning → use in a
     situation the AI proposes; missed idioms return.
  2. `conversation` — film club: discuss a film both "watched" (the AI
     invents a plot, shares it first); learner infers motives with
     subjective modals (er dürfte…, sie soll…).
  3. `wordGame` — word-formation lab: AI gives roots (binden, Kraft…),
     learner builds real derivatives + one plausible fake; AI catches
     fakes, explains morphology.
  4. `readingQa` — short literary excerpt (public-domain flavor, C1/C2
     border); questions on tone, irony, one litotes paraphrase.
  5. `translationDrill` — hedge & attitude: 10 English sentences whose
     "allegedly/apparently/supposedly" must land as angeblich/offenbar/
     soll…haben correctly.
  6. `listenRetell` — AI performs a monologue with clear ironic intent;
     learner states literal content vs actual meaning.
  7. `storytelling` — "Erzähl es zweimal": same 4-beat anecdote told
     straight, then retold dripping with irony; AI grades the *contrast*.
  8. `writing` — a review (film/book, 130 words) with 3 idioms, 2
     subjective-modal inferences, no register breaks.
  9. `roleplay` — dinner-party diplomacy: a guest (AI) keeps making
     awkward claims; deflect with humor and hedged disagreement.
  10. `interview` — **gate**: culture conversation where the AI plants 3
      idioms and 2 ironic statements the learner must catch and mirror;
      priorityErrors: modal-inference accuracy, idiom usage, tone control.

### M11 · C2.1 — *Stilsicherheit* (Stylistic command)

- **Can-do:** switch registers on demand; write professional prose;
  deploy Funktionsverbgefüge and precise collocations; persuade.
- **Grammar:** Funktionsverbgefüge (zur Verfügung stellen, in Anspruch
  nehmen…); register system (formal/neutral/colloquial triplets);
  advanced word order for emphasis (Vorfeld manipulation, Ausklammerung);
  precision collocations (Kritik üben an, Maßnahmen ergreifen).
- **Vocabulary domains:** professional/rhetorical prose, 25
  Funktionsverbgefüge, register triplets (kriegen/bekommen/erhalten),
  persuasion & concession language.
- **Exercises:**
  1. `vocabDrill` — Funktionsverbgefüge ↔ simple verb (in Erwägung
     ziehen ↔ erwägen), both directions with register commentary.
  2. `wordGame` — register slider: one message, three targets — AI names
     a random audience (Behörde / Kollegin / WhatsApp an Freund), learner
     re-voices the same content instantly; 6 rounds.
  3. `translationDrill` — collocation precision: 10 sentences where the
     obvious verb is wrong (do criticism → Kritik *üben*).
  4. `readingQa` — dense op-ed (C2-locked); questions on rhetorical
     structure: where does the concession live, what does the Vorfeld
     emphasize.
  5. `conversation` — persuade the AI (a stubborn mayor) to fund a
     project; must use 3 FVG and one deliberate emphasis fronting.
  6. `writing` — position paper (150 words) + its 40-word executive
     summary; rubric: FVG density without stiffness.
  7. `storytelling` — one story, two publications: narrate an event as a
     tabloid would, then as a broadsheet; AI grades register purity.
  8. `listenRetell` — AI reads a formal statement; learner renders it for
     a colleague in relaxed but professional spoken German.
  9. `roleplay` — press conference: learner is the spokesperson defending
     an unpopular decision; AI journalists interrupt, bait, misquote.
  10. `interview` — **gate**: style-command exam — content held constant,
      register switched on the AI's command mid-answer; priorityErrors:
      register purity, collocation choice, FVG correctness.

### M12 · C2.2 — *Meisterschaft* (Mastery)

- **Can-do:** debate any topic spontaneously; mediate between positions;
  understand dialect-coloured and highly colloquial speech; improvise.
- **Grammar:** near-native control audit (everything recycled under
  pressure); colloquial/dialect awareness (receptive: mal, isses,
  haste; regional greetings); discourse management (turn-taking phrases,
  repair strategies); prosody & emphasis in speech.
- **Vocabulary domains:** contemporary colloquialisms & youth language
  (receptive), mediation language (beide Seiten, der Kompromiss läge
  darin…), high-register discourse markers, "untranslatables"
  (doch-mastery, jein, Feierabend).
- **Exercises:**
  1. `vocabDrill` — untranslatables & colloquialisms: the AI serves
     colloquial mini-dialogues, learner translates the *effect*, then
     answers in matching register.
  2. `conversation` — no-net free talk: the AI picks 3 random topics of
     escalating abstraction and changes topic mid-sentence; grading
     weights flexibility and repair strategies.
  3. `wordGame` — "Absurde These": defend a drawn absurd thesis (socks
     conspiracy) against genuine cross-examination for 5 exchanges;
     conceding a round costs points, dodging a question costs more.
  4. `listenRetell` — AI speaks the same short scene twice: once neutral,
     once colloquial/dialect-tinged; learner maps one onto the other.
  5. `readingQa` — two texts, one event: a satirical column + a sober
     report; questions demand mediation between their claims.
  6. `roleplay` — mediation: two flatmates (both played by the AI, in
     different voices/registers) are at war; broker a written-out
     compromise both accept.
  7. `writing` — the hardest brief: a eulogy for a houseplant — genuine
     C2 register control in a deliberately absurd frame; graded on tone
     tightrope, not humor.
  8. `storytelling` — improvised chain story: AI and learner alternate
     sentences; AI injects genre shifts (Krimi → Märchen → Nachrichten),
     learner's sentences must land each register instantly.
  9. `interview` — capstone rehearsal: 10-question full-range interview,
     A1 topics answered at C2 depth ("Erzählen Sie von Ihrer Familie —
     als Essayist").
  10. `roleplay` — **gate & finale**: "Der Salon" — a dinner party where
      the AI plays three guests (a pedant, a provocateur, a mumbler);
      survive 12 exchanges hosting all three; priorityErrors: register
      agility, discourse management, everything.

### Difficulty scaling across the chain

- **Session length** grows with level: A1 3 min / 6 exchanges → B1 4 min /
  8 → C1+ 5–6 min / 10 (all via the existing `session` overrides; the
  arithmetic rule `points × questionsPerPoint ≤ exchanges` holds).
- **Report language**: UI-language (English) reports through B1; from B2.1
  the prompt asks for the report itself in German — reading your own
  feedback becomes an exercise.
- **passScore** rises: 50 (A1–A2) → 60 (B1–B2) → 70 (C1–C2).
- **priorityErrors narrow**: A-levels forgive everything but the module's
  big rock; C-levels grade register and idiomaticity.

## 5. Word & grammar data flow

Each module's word list (~40–60 items) is authored once in the module file
and sliced into the exercises' `targetVocabulary`/`wordList` fields — drill
modes quiz the list directly, talk modes steer toward subsets, games play
with them. Cross-check against the shared German noun/verb collections so
meanings/genders match the Word Library. The gate test asserts every module
word appears in ≥2 exercises (once drilled, once used in context).

## 6. Course identity & catalog seams

- `Course(id: 'en_de_ai', uiLang: UiLang.en, learnLocale: de-DE)`, name
  **"German with Your AI Coach"**, tagline "The full course runs in your AI —
  we bring the prompts and keep score. A1–C2." Level badge `A1–C2`.
- Goal: `discover` (won't displace certification cards in `featuredCourses`;
  reachable via finder + shareable links). If we later want to feature it,
  introduce a ranked `ai` goal instead of reshuffling.
- Nav: 12 gated groups + `more`, per the de_es recipe.
- **SEO sync**: `web/index.html` landing + JSON-LD must gain the course; its
  description is a marketing surface for the transparent AI positioning.
- No exam-brand names (IP rule); "CEFR-aligned" only.

## 7. Tests & pipeline checklist

- `speaking_quiz_test.dart`: template parity across mode variants; zero
  unresolved placeholders rendering every exercise; session arithmetic;
  mode-specific payload presence (`passage` for readingQa, `wordList` for
  drill/games, `gameRules` for games).
- New `test/en_de_ai_course_test.dart`: Help Memory intro+tips everywhere
  (including "get a good run from your AI" tips), gating chain complete,
  word-list coverage rule (§5), 10 exercises per module, mode variety per
  module (≥6 distinct modes).
- `content_snapshot.json` golden refresh, `dart run
  tool/generate_content.dart`, asset count bump, **`kDataVersion` bump**.
- Quiz-completion widget tests: feature poll on cooldown.

## 8. Open decisions

1. Game scoring: is 0–100 per game credible enough to gate, or should games
   be practice-only (complete on any score) to keep gates on the graded
   conversation/writing modes?
2. `readingGen` grades its own generated text — practice-only or gated?
3. Per-mode medals on the quiz tile (e.g. a game die icon vs. speech bubble)
   — worth the extra chrome?
4. A "streak of days with any AI exercise" stat on the course home, since
   the site's role is explicitly the logbook.
