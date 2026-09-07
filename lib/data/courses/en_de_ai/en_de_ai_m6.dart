import '../../../models/quiz_content.dart';
import 'en_de_ai_builder.dart';

/// M6 · B1.2 — *Erzählen & Begründen* (Narrate & justify).
///
/// Can-do: narrate past events in written style; summarize a story;
/// describe processes; justify decisions in connected speech.
/// Grammar: Präteritum (sein/haben/modals + strong verbs), Passiv
/// present/past (werden + Partizip II), relative clauses (nom/akk/dat),
/// als vs wenn, Plusquamperfekt intro, n-declension nouns.
///
/// B1 session shape: ~4 minutes, 8 exchanges, pass 60.
const _b1Session = SpeakingSession(durationMinutes: 4, minExchanges: 8);

const _copyTip = HelpMemoryTip(
  kind: 'rule',
  title: 'How this course works',
  text:
      'Copy the exercise into your AI assistant (voice mode is best), do the '
      'exercise there, and paste the score it gives you back here. Stay with '
      'one assistant so your scores stay comparable.',
);

final List<QuizContent> enDeAiM6Quizzes = [
  enDeAiEx(
    id: 'en_de_ai_m6_praet_ladder',
    title: 'Words: the Präteritum ladder',
    level: 'B1',
    mode: SpeakingMode.vocabDrill,
    session: _b1Session,
    passScore: 60,
    topic:
        'Strong-verb Präteritum, drilled as a ladder: infinitive up, '
        'Präteritum down, both directions, fast. After every 5 verbs, make '
        'me build one instant micro-sentence with a form I just drilled.',
    material:
        'Verb ladder to drill (infinitive = Präteritum, er/sie form):\n'
        'gehen = ging · kommen = kam · sehen = sah · geben = gab · '
        'nehmen = nahm · finden = fand · fahren = fuhr · schreiben = '
        'schrieb · lesen = las · sprechen = sprach · essen = aß · '
        'trinken = trank · laufen = lief · schlafen = schlief · '
        'bleiben = blieb · rufen = rief · treffen = traf · '
        'beginnen = begann · verlieren = verlor · wissen = wusste\n'
        'Plus the backbone: sein = war · haben = hatte · werden = wurde · '
        'können = konnte · müssen = musste · wollen = wollte\n'
        'Micro-sentence rule: after each block of 5, give me a subject and '
        'a verb from the block; I answer with one Präteritum sentence '
        '(Er ging gestern nach Hause).',
    practisePoints: [
      'Strong-verb vowel changes (gehen → ging, nehmen → nahm)',
      'war/hatte/wurde and the modal Präteritum forms',
      'No endings on ich/er in Präteritum (ich ging, not ich ginge)',
    ],
    scoringCriteria: [
      'the correct Präteritum form both directions',
      'well-formed micro-sentences',
      'increasing speed on repeats',
    ],
    priorityErrors: [
      'weak -te endings on strong verbs (gehte, kommte)',
      'Perfekt used where Präteritum was asked',
    ],
    intro:
        'The narrative tense begins here: twenty strong verbs plus the '
        'backbone six, drilled until ging, kam and sah come out without '
        'thinking.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'mnemonic',
        title: 'Sing the vowel families',
        text:
            'Strong verbs move in choirs: ei → ie (schreiben/schrieb, '
            'bleiben/blieb), i/e → a (finden/fand, sprechen/sprach). Learn '
            'one family member and you get its siblings for free.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m6_fairy_tale',
    title: 'Tell it: a modern fairy tale',
    level: 'B1',
    mode: SpeakingMode.storytelling,
    session: _b1Session,
    passScore: 60,
    topic:
        'You hand me a scrambled Grimm-style story skeleton; I tell it as '
        'a flowing modern fairy tale, entirely in Präteritum, opening with '
        '"Es war einmal…". Interrupt only for tense slips.',
    material:
        'Story skeleton (present it scrambled, I must order it):\n'
        '- eine junge Programmiererin, die in einem grauen Hochhaus wohnte\n'
        '- ein sprechender Kaffeeautomat mit einem geheimen Wunsch\n'
        '- ein Chef, der nie Danke sagte\n'
        '- eine Reise in den Keller der Firma, wo etwas Seltsames wartete\n'
        '- ein Tausch: eine Woche Schweigen gegen einen echten Wunsch\n'
        '- ein Ende, in dem jemand etwas Wichtiges lernte\n'
        'Required forms:\n'
        '- Opening: Es war einmal…\n'
        '- Präteritum throughout (war, hatte, ging, sagte, wusste…).\n'
        '- At least 2 relative clauses (die Frau, die…; der Automat, '
        'den…).\n'
        '- One als-clause for a single past moment (Als sie den Keller '
        'öffnete, …).',
    practisePoints: [
      'Sustained Präteritum narration',
      'Relative clauses to introduce characters',
      'als for one-time past events',
    ],
    scoringCriteria: [
      'correct Präteritum forms across the tale',
      'at least two correct relative clauses',
      'a coherent story using every skeleton element',
    ],
    priorityErrors: [
      'Perfekt creeping into the narration',
      'wenn used where als belongs',
    ],
    intro:
        'Es war einmal… a programmer, a talking coffee machine and a '
        'thankless boss. Untangle the skeleton and tell it like the '
        'Brothers Grimm would — in clean Präteritum.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'rule',
        title: 'als, not wenn',
        text:
            'A single completed moment in the past takes als: "Als sie den '
            'Keller öffnete…". wenn in the past means "whenever" — every '
            'time, not once upon a time.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m6_passive_shift',
    title: 'Translate: the passive shift',
    level: 'B1',
    mode: SpeakingMode.translationDrill,
    session: _b1Session,
    passScore: 60,
    topic:
        'Ten active English sentences that must come out as German '
        'passive — werden + Partizip II in the present, wurde + Partizip '
        'II in the past. Serve one at a time; re-serve my misses.',
    material:
        'Sentences to serve one at a time (German passive required):\n'
        '1. The bridge was built in 1900.\n'
        '2. German is spoken here.\n'
        '3. The letter is being written right now.\n'
        '4. The window was broken yesterday.\n'
        '5. The bread is baked every morning.\n'
        '6. My bike was stolen last week.\n'
        '7. The house is being renovated.\n'
        '8. The song was sung by all the children.\n'
        '9. Dinner is served at seven.\n'
        '10. The museum was opened in May.',
    practisePoints: [
      'Present passive: wird + Partizip II',
      'Past passive: wurde + Partizip II',
      'The agent with von + Dativ where the English names one',
    ],
    scoringCriteria: [
      'the correct form of werden',
      'the correct Partizip II at the end',
      'von-phrases with the right case',
    ],
    priorityErrors: [
      'ist + Partizip used instead of wird/wurde',
      'Partizip II not clause-final',
    ],
    intro:
        'Flip the sentences: the doer disappears, werden takes over. Ten '
        'English actives in, ten German passives out — your AI grades each '
        'on the spot.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'rule',
        title: 'werden is the engine',
        text:
            'German passive always runs on werden: "Das Brot wird gebacken" '
            '(is baked), "Die Brücke wurde gebaut" (was built). The '
            'Partizip waits at the end of the clause.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m6_news_item',
    title: 'Reading: the local news item',
    level: 'B1',
    mode: SpeakingMode.readingQa,
    session: _b1Session,
    passScore: 60,
    topic:
        'A short newspaper item in narrative Präteritum. Keep everything '
        'at B1 — no rewording upwards. Question 5 asks me to hunt down a '
        'passive sentence and turn it back into an active one.',
    material:
        'Passage (show it to me exactly like this):\n'
        'Aufregung im Stadtpark\n'
        'Am Dienstagmorgen entdeckte eine Joggerin im Stadtpark einen '
        'offenen Koffer, der voller alter Briefe war. Sie rief sofort die '
        'Polizei, die nach zwanzig Minuten kam. Die Briefe wurden von '
        'zwei Beamten vorsichtig eingepackt. Ein Sprecher der Stadt '
        'sagte, dass der Koffer wahrscheinlich seit Jahren in einem '
        'Gebüsch lag. Die Besitzerin, eine 90-jährige Frau aus dem '
        'Viertel, wurde noch am selben Tag gefunden. Sie freute sich '
        'sehr, denn die Briefe stammten von ihrem Mann. Der Koffer war '
        'vor langer Zeit bei einem Umzug verloren gegangen.\n'
        '\n'
        'Ask me (one at a time):\n'
        '1. Was entdeckte die Joggerin, und wo?\n'
        '2. Wer kam nach zwanzig Minuten?\n'
        '3. Wie lange lag der Koffer wahrscheinlich im Gebüsch?\n'
        '4. Warum freute sich die Besitzerin so sehr?\n'
        '5. Finde einen Passivsatz im Text und mach daraus einen '
        'Aktivsatz. (Check my active version carefully.)',
    practisePoints: [
      'Reading narrative Präteritum fluently',
      'Spotting passive constructions in real text',
      'Re-activating a passive sentence with the right subject',
    ],
    scoringCriteria: [
      'correct information from the text',
      'a correctly re-activated passive sentence',
      'answers in the past tenses of the text',
    ],
    priorityErrors: [
      'answering in present tense about past events',
      'keeping wurde in the "active" version',
    ],
    intro:
        'A tiny local-news mystery: a suitcase, old letters, a happy '
        'ending. Read it, answer about it, and for the finale, flip one of '
        'its passive sentences back to active.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'tip',
        title: 'Passive radar',
        text:
            'Scan for wurde(n) + a participle at the end — that\'s your '
            'passive. To re-activate it, promote the von-phrase (or invent '
            'a doer) to subject: "Zwei Beamte packten die Briefe ein."',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m6_passiv_game',
    title: 'Game: Was wird hier gemacht?',
    level: 'B1',
    mode: SpeakingMode.wordGame,
    session: _b1Session,
    passScore: 60,
    topic:
        'A profession-guessing game played entirely in the passive. First '
        'you mime professions in words, I guess; then we swap and you '
        'guess mine. Any non-passive clue sentence loses the round.',
    material:
        'Game rules:\n'
        '- Round type A (4 rounds): you describe a profession using ONLY '
        'passive sentences, never naming it — "Hier werden Haare '
        'geschnitten. Die Kunden werden gefragt, wie kurz." I guess the '
        'profession in German (der Friseur!).\n'
        '- Round type B (4 rounds): we swap. I describe a profession in '
        'passive sentences (at least 2 per round), you guess. If one of '
        'my clue sentences is not a correct passive, the round is void.\n'
        '- Scoring: type A — 10 points per profession I guess right. '
        'Type B — 10 points if my passives are correct AND you can guess, '
        '+5 bonus for a third correct passive clue.\n'
        '- 8 rounds total, then convert my points to the final score.',
    practisePoints: [
      'Present passive under game pressure (wird/werden + Partizip II)',
      'Profession vocabulary in both directions',
      'Partizip II placed clause-final every time',
    ],
    scoringCriteria: [
      'correct passive clue sentences',
      'right profession guesses',
      'variety of verbs across rounds',
    ],
    priorityErrors: [
      'active sentences smuggled in as clues',
      'wrong Partizip II forms',
    ],
    intro:
        'Charades, but the costume is grammar: professions described only '
        'through what gets done. Guess your AI\'s, then make yours '
        'guessable — in flawless passive.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'example',
        title: 'A clue that works',
        text:
            '"Hier wird Brot gebacken. Der Teig wird sehr früh am Morgen '
            'gemacht." Two clean passives, one obvious Bäcker — that\'s a '
            'full-points round.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m6_big_decision',
    title: 'The decision that changed things',
    level: 'B1',
    mode: SpeakingMode.conversation,
    session: _b1Session,
    passScore: 60,
    topic:
        'I narrate one life decision — real or invented — that changed '
        'things: what came before, the decision itself, what followed. I '
        'justify it with deshalb, daher and nämlich. You listen like a '
        'curious friend, then challenge exactly one of my justifications '
        'and make me defend it.',
    practisePoints: [
      'Connected past narration (Präteritum and Perfekt mixed naturally)',
      'Justifying with deshalb/daher (verb right after) and nämlich',
      'Defending a reason under a follow-up challenge',
    ],
    targetVocabulary: [
      'die Entscheidung',
      'sich entscheiden für',
      'deshalb',
      'nämlich',
      'bereuen',
      'der Grund',
    ],
    scoringCriteria: [
      'a clear before–decision–after arc',
      'correct connector word order',
      'a real defence when challenged',
    ],
    priorityErrors: [
      'deshalb followed by subject instead of verb',
      'nämlich placed at the start of its clause',
    ],
    intro:
        'Everyone has one decision that split life into before and after. '
        'Tell yours — or invent one — and be ready: your AI will pick one '
        'of your reasons and push back.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'rule',
        title: 'deshalb flips, nämlich hides',
        text:
            'deshalb takes position one and pulls the verb next: "Deshalb '
            'zog ich um." nämlich never starts a clause — it tucks in '
            'after the verb: "Ich zog um, ich hatte nämlich einen neuen '
            'Job."',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m6_radio_news',
    title: 'Listen & retell: the radio miniature',
    level: 'B1',
    mode: SpeakingMode.listenRetell,
    session: _b1Session,
    passScore: 60,
    topic:
        'You read a 90-second radio-style news miniature aloud (voice '
        'mode), normal pace, once — twice only if I ask. Then I retell it '
        'in my own words in past tenses, and you check me with three '
        'detail questions.',
    material:
        'The piece to read aloud (write your own, but it must be):\n'
        '- A local-news miniature of about 90 seconds / 8–10 sentences, '
        'B1 vocabulary only.\n'
        '- Topic: a small, concrete event — a rescued animal, a reopened '
        'bridge, a record-breaking bake sale, a found treasure.\n'
        '- Written in narrative Präteritum with at least two passive '
        'sentences (wurde gerettet, wurde eröffnet…) and one relative '
        'clause.\n'
        'Then:\n'
        '- I retell the story in my own words (past tenses, not a '
        'word-for-word echo).\n'
        '- Ask me 3 detail questions about facts I did not mention.\n'
        '- Grade the retelling for coverage and tense control, the '
        'questions for accuracy.',
    practisePoints: [
      'Catching the who/what/when of spoken German',
      'Retelling in Präteritum and Perfekt, not quoting',
      'Holding details for the follow-up questions',
    ],
    scoringCriteria: [
      'main events covered in the retelling',
      'correct past-tense forms',
      'detail questions answered from memory',
    ],
    priorityErrors: [
      'retelling in present tense',
      'inventing details not in the piece',
    ],
    intro:
        'Ears only: your AI becomes a radio newsreader for 90 seconds. '
        'Then the microphone is yours — retell the story, survive three '
        'detail questions.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'tip',
        title: 'Listen for anchors, not words',
        text:
            'Grab the five anchors — wer, was, wo, wann, Ergebnis — and let '
            'the rest go. A retelling built on five anchors beats a broken '
            'word-for-word echo every time.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m6_accident_report',
    title: 'Write: the insurance report',
    level: 'B1',
    mode: SpeakingMode.writing,
    session: _b1Session,
    passScore: 60,
    topic:
        'An accident report for an insurance form, written in three '
        'tense layers: what had happened before (Plusquamperfekt), what '
        'happened (Präteritum), what was damaged (Passiv). Grade it '
        'against the rubric, layer by layer.',
    material:
        'Writing task:\n'
        '- Invent a small, harmless household or bicycle accident and '
        'write the report (8–10 sentences) for the insurance form.\n'
        '- Layer 1 — the background: at least 2 sentences in '
        'Plusquamperfekt about what had happened before (Ich hatte das '
        'Fenster geöffnet…, Es hatte geregnet…).\n'
        '- Layer 2 — the event: the accident itself in Präteritum.\n'
        '- Layer 3 — the damage: at least 2 passive sentences (Die Vase '
        'wurde zerbrochen. Das Fahrrad wurde beschädigt.).\n'
        'Rubric (grade against this):\n'
        '- Each layer present and in its tense (biggest weight).\n'
        '- Plusquamperfekt formed with hatte/war + Partizip II.\n'
        '- Sober report style: no du/ihr, no exclamation marks.\n'
        '- Clear time order, ideally with nachdem or als.',
    practisePoints: [
      'Plusquamperfekt for the pre-history',
      'Präteritum for the event line',
      'Passive for damage — the classic report voice',
    ],
    scoringCriteria: [
      'each tense layer correct and in place',
      'formed Plusquamperfekt (hatte/war + Partizip II)',
      'report register throughout',
    ],
    priorityErrors: [
      'Perfekt where Plusquamperfekt is required',
      'active sentences in the damage layer',
    ],
    intro:
        'Bureaucratic German, the fun way: one silly accident, three tense '
        'layers. Before, during, damage — each layer has its own grammar, '
        'and the rubric checks all three.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'rule',
        title: 'One step further back',
        text:
            'Plusquamperfekt is the past of the past: hatte/war + Partizip '
            'II. "Es hatte geregnet, deshalb war die Straße nass, und dann '
            'passierte es." Three layers, three tenses.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m6_witness',
    title: 'Roleplay: the witness interview',
    level: 'B1',
    mode: SpeakingMode.roleplay,
    session: _b1Session,
    passScore: 60,
    topic:
        'You are a patient, very thorough police officer; I witnessed a '
        'silly bicycle incident (nobody hurt, much confusion). Take my '
        'statement: what happened, in what order, and exactly WHO was '
        'involved — push me to identify every person with a relative '
        'clause (der Mann, der…; die Frau, die…; der Junge, den…).',
    practisePoints: [
      'Relative clauses in nominative, accusative and dative',
      'Ordered past narration under questioning',
      'n-declension in action (der Junge → den Jungen)',
    ],
    targetVocabulary: [
      'der Zeuge',
      'der Unfall',
      'zusammenstoßen',
      'beobachten',
      'der Radfahrer',
      'passieren',
    ],
    scoringCriteria: [
      'correct relative pronouns for each case',
      'a consistent, ordered account',
      'past tenses held throughout',
    ],
    priorityErrors: [
      'wrong relative pronoun case (der Mann, den ich half)',
      'der Junge left undeclined (mit der Junge)',
    ],
    intro:
        'You saw everything, officer — now say it precisely. Every person '
        'in your statement needs a relative clause, and the officer will '
        'keep asking "Welcher Mann genau?" until they get one.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'rule',
        title: 'The clause case is local',
        text:
            'The relative pronoun takes its case from its OWN clause: "der '
            'Mann, DEN ich sah" (I saw him — accusative), "der Mann, DEM '
            'ich half" (I helped him — dative). Ignore the main clause.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m6_gate_narrate',
    title: 'Module exam: narrate and justify',
    level: 'B1',
    mode: SpeakingMode.interview,
    session: SpeakingSession(durationMinutes: 5, minExchanges: 9),
    passScore: 60,
    topic:
        'The closing exam of the module: a narrate-and-justify session '
        'across everything — retell a past event in Präteritum, describe '
        'how something is made in the passive, identify people with '
        'relative clauses, and justify two decisions with deshalb and '
        'nämlich. Mix the topics; keep me moving.',
    practisePoints: [
      'Präteritum narration on demand',
      'Passive descriptions (wird/wurde + Partizip II)',
      'Relative clauses with the right pronoun case',
      'Justification connectors with correct word order',
    ],
    scoringCriteria: [
      'correct Präteritum forms in free narration',
      'well-built passive sentences',
      'relative pronoun cases',
      'connector word order (deshalb, nämlich)',
    ],
    priorityErrors: [
      'wrong or weak Präteritum forms',
      'broken passive construction',
      'relative pronoun in the wrong case',
    ],
    intro:
        'The module gate: one session, every M6 skill — narrating, '
        'describing processes, pointing people out, justifying. Pass it '
        'and B2.1 unlocks; your best score counts.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'tip',
        title: 'Change gears audibly',
        text:
            'Each task wants its own grammar: stories run on Präteritum, '
            'processes on wird…gemacht, people on der/die/den clauses. '
            'Hear the task type, shift the gear first, then speak.',
      ),
    ],
  ),
];
