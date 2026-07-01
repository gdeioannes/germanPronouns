import '../../models/quiz_content.dart';
import 'quest_builders.dart';

/// CEFR **C1.1 — "Abstrahieren"** Quest quizzes (Goethe C1). Big rocks:
/// **nominalisation ↔ verbalisation** (switching register), **passive
/// alternatives** (sein+zu, sich lassen, -bar), advanced connectors and
/// participial clauses.

/// 1. Bildung & Wissenschaft (vocab).
final QuizContent questC11BildungContent = sentenceQuestQuiz(
  id: 'quest_c1_1_bildung',
  title: 'C1.1 · Bildung & Wissenschaft',
  promptLabel: 'Wort',
  subjectsLabel: 'Wissenschaft',
  subjectColumnLabel: 'English',
  categoryLabel: 'Wissenschaft',
  contextualLayout: true,
  intro: 'Academic vocabulary for the abstract, nominal style of C1 texts.',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: 'Academic nouns',
      text: 'die Erkenntnis (insight), die Voraussetzung (precondition), die '
          'Annahme (assumption), die Schlussfolgerung (conclusion).',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Nominal register',
      text: 'C1 prefers nouns over verbs: "die Durchführung der Untersuchung" '
          'instead of "die Untersuchung durchführen".',
    ),
  ],
  items: [
    qsi('Die Studie führte zu einer wichtigen ____. (insight)', 'Erkenntnis',
        'The study led to an important insight.', 'insight'),
    qsi('Eine gute Ausbildung ist eine ____ für Erfolg. (precondition)',
        'Voraussetzung', 'A good education is a precondition for success.',
        'precondition'),
    qsi('Diese ____ muss noch bewiesen werden. (assumption)', 'Annahme',
        'This assumption still has to be proven.', 'assumption'),
    qsi('Am Ende zog der Autor eine klare ____. (conclusion)',
        'Schlussfolgerung', 'In the end the author drew a clear conclusion.',
        'conclusion'),
    qsi('Die ____ der Studie dauerte zwei Jahre. (carrying out)',
        'Durchführung', 'Carrying out the study took two years.',
        'execution/carrying out'),
  ],
);

/// 2. Nominalisierung (verbal → nominal).
final QuizContent questC11NominalisierungContent = sentenceQuestQuiz(
  id: 'quest_c1_1_nominalisierung',
  title: 'C1.1 · Nominalisierung',
  promptLabel: 'Nomen',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Verb → Nomen',
  categoryLabel: 'Nominalisierung',
  intro: 'Academic German turns verbs and clauses into nouns. Recognise and form '
      'the noun from the verb: ankommen → die Ankunft, entscheiden → die '
      'Entscheidung.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Productive endings',
      text: '-ung (die Lösung), -tion (die Information), nominalised infinitive '
          '(das Lesen), -nis (das Ergebnis).',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Clause → noun phrase',
      text: '"Nachdem er angekommen war …" → "Nach seiner Ankunft …". Same '
          'meaning, denser style.',
    ),
  ],
  items: [
    qsi('entscheiden → die ____ (decision)', 'Entscheidung',
        'the decision', 'Entscheidung'),
    qsi('lösen → die ____ (solution)', 'Lösung', 'the solution', 'Lösung'),
    qsi('ankommen → die ____ (arrival)', 'Ankunft', 'the arrival', 'Ankunft'),
    qsi('entwickeln → die ____ (development)', 'Entwicklung',
        'the development', 'Entwicklung'),
    qsi('untersuchen → die ____ (investigation)', 'Untersuchung',
        'the investigation', 'Untersuchung'),
  ],
);

/// 3. Verbalisierung (nominal → verbal).
final QuizContent questC11VerbalisierungContent = sentenceQuestQuiz(
  id: 'quest_c1_1_verbalisierung',
  title: 'C1.1 · Verbalisierung',
  promptLabel: 'Verb',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Nomen → Verb',
  categoryLabel: 'Verbalisierung',
  intro: 'The reverse skill: unpack a dense noun phrase into a clearer verbal '
      'clause. "Nach der Prüfung der Daten …" → "Nachdem man die Daten geprüft '
      'hat …".',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Preposition → conjunction',
      text: 'nach → nachdem, vor → bevor, wegen → weil, trotz → obwohl, durch → '
          'indem.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Why verbalise?',
      text: 'Spoken and clearer writing prefer verbs; turning nouns back into '
          'verbs makes a dense text easier to follow.',
    ),
  ],
  items: [
    qsi('Wegen des Regens … → ____ es regnete, … (because)', 'weil',
        'because it rained', 'wegen → weil'),
    qsi('Nach dem Essen … → ____ wir gegessen hatten, … (after)', 'nachdem',
        'after we had eaten', 'nach → nachdem'),
    qsi('Trotz der Kälte … → ____ es kalt war, … (although)', 'obwohl',
        'although it was cold', 'trotz → obwohl'),
    qsi('Vor der Abreise … → ____ wir abreisten, … (before)', 'bevor',
        'before we departed', 'vor → bevor'),
    qsi('Durch hartes Training … → ____ er hart trainierte, … (by …-ing)',
        'indem', 'by training hard', 'durch → indem'),
  ],
);

/// 4. Sprechen: Ein Thema strukturiert darstellen.
final QuizContent questC11SprechenDarstellenContent = speakQuestQuiz(
  id: 'quest_c1_1_sprechen_darstellen',
  title: 'C1.1 · Sprechen: Strukturiert darstellen',
  promptLabel: 'Satz',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Deutsch',
  intro: 'Present a topic clearly and academically. Listen and repeat these '
      'structuring phrases for a C1 presentation.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Frame the talk',
      text: '"Zunächst möchte ich … , anschließend … , abschließend …" guides '
          'the listener.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'Refer to sources',
      text: '"Laut einer aktuellen Studie …" introduces evidence formally.',
    ),
  ],
  phrases: const [
    SpeakPhrase(
        phrase: 'Im Folgenden möchte ich auf drei Aspekte eingehen.',
        meaning: 'In the following I would like to address three aspects.'),
    SpeakPhrase(
        phrase: 'Zunächst ist festzuhalten, dass …',
        meaning: 'First it should be noted that …'),
    SpeakPhrase(
        phrase: 'Laut einer aktuellen Studie …',
        meaning: 'According to a recent study …'),
    SpeakPhrase(
        phrase: 'Daraus lässt sich schließen, dass …',
        meaning: 'From this one can conclude that …'),
    SpeakPhrase(
        phrase: 'Abschließend lässt sich festhalten, dass …',
        meaning: 'In conclusion it can be stated that …'),
    SpeakPhrase(
        phrase: 'Vielen Dank, ich freue mich auf Ihre Fragen.',
        meaning: 'Thank you, I look forward to your questions.'),
  ],
);

/// 5. Passiversatz: sein + zu / sich lassen.
final QuizContent questC11PassiversatzContent = sentenceQuestQuiz(
  id: 'quest_c1_1_passiversatz',
  title: 'C1.1 · Passiversatz',
  promptLabel: 'Form',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Bedeutung',
  categoryLabel: 'Passiversatz',
  intro: 'C1 German often replaces the passive with **sein + zu + Infinitiv** '
      '(must/can be done) or **sich lassen + Infinitiv** (can be done). Both '
      'sound more elegant than "kann/muss … werden".',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'sein + zu = must/can be',
      text: '"Das Formular ist auszufüllen" = must be filled in. "Der Text ist '
          'leicht zu verstehen" = can be understood.',
    ),
    HelpMemoryTip(
      kind: 'rule',
      title: 'sich lassen = can be',
      text: '"Das Problem __lässt sich__ lösen" = can be solved (= kann gelöst '
          'werden).',
    ),
  ],
  items: [
    qsi('Das Formular ist bis Freitag auszu____. (füllen)', 'füllen',
        'The form must be filled in by Friday.', 'ist auszufüllen'),
    qsi('Der Text ist leicht zu ____. (verstehen)', 'verstehen',
        'The text is easy to understand.', 'ist zu verstehen'),
    qsi('Das Problem lässt ____ leicht lösen. (sich)', 'sich',
        'The problem can be solved easily.', 'lässt sich lösen'),
    qsi('Die Tür lässt sich nicht ____. (öffnen)', 'öffnen',
        'The door cannot be opened.', 'lässt sich öffnen'),
    qsi('Diese Frage ist nicht leicht zu ____. (beantworten)', 'beantworten',
        'This question is not easy to answer.', 'ist zu beantworten'),
  ],
);

/// 6. Adjektive auf -bar / -lich.
final QuizContent questC11BarLichContent = sentenceQuestQuiz(
  id: 'quest_c1_1_bar_lich',
  title: 'C1.1 · Adjektive auf -bar / -lich',
  promptLabel: 'Adjektiv',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Verb → Adjektiv',
  categoryLabel: '-bar / -lich',
  intro: 'Another passive alternative: the suffix **-bar** (and sometimes '
      '**-lich**) turns a verb into "able to be …": lösen → lösbar (solvable).',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'verb + -bar = can be …-ed',
      text: 'machen → machbar (doable), essen → essbar (edible), lesen → lesbar '
          '(legible).',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: '-lich variants',
      text: 'verstehen → verständlich (understandable), erklären → erklärlich. '
          'Often with a stem change.',
    ),
  ],
  items: [
    qsi('Das Problem ist ____. (lösen → -bar)', 'lösbar',
        'The problem is solvable.', 'lösbar'),
    qsi('Der Plan ist durchaus ____. (machen → -bar)', 'machbar',
        'The plan is quite doable.', 'machbar'),
    qsi('Diese Pilze sind nicht ____. (essen → -bar)', 'essbar',
        'These mushrooms are not edible.', 'essbar'),
    qsi('Seine Schrift ist kaum ____. (lesen → -bar)', 'lesbar',
        'His handwriting is barely legible.', 'lesbar'),
    qsi('Die Erklärung war gut ____. (verstehen → -lich)', 'verständlich',
        'The explanation was easy to understand.', 'verständlich'),
  ],
);

/// 7. Hören: Ein Universitätsvortrag.
final QuizContent questC11HoerenVorlesungContent = listeningQuestQuiz(
  id: 'quest_c1_1_hoeren_vorlesung',
  // University lecturer (no gendered cue) — cast as a male voice for variety.
  voiceGender: VoiceGender.male,
  title: 'C1.1 · Hören: Vorlesung',
  category: 'Education',
  passageTitle: 'Vorlesung: Sprache und Denken',
  passage:
      'In der heutigen Sitzung beschäftigen wir uns mit der Frage, inwiefern '
      'unsere Sprache unser Denken beeinflusst. Lange Zeit nahm man an, Sprache '
      'sei lediglich ein Werkzeug, um Gedanken auszudrücken. Neuere Studien '
      'legen jedoch nahe, dass die Struktur einer Sprache durchaus prägt, wie '
      'wir die Welt wahrnehmen. Allerdings ist dieser Einfluss schwer zu messen '
      'und bleibt umstritten. Im zweiten Teil werden wir konkrete Beispiele '
      'betrachten.',
  passageTranslation:
      'In today’s session we deal with the question of to what extent our '
      'language influences our thinking. For a long time it was assumed that '
      'language was merely a tool for expressing thoughts. However, newer '
      'studies suggest that the structure of a language does shape how we '
      'perceive the world. This influence is hard to measure, though, and '
      'remains controversial. In the second part we will look at concrete '
      'examples.',
  questions: const [
    ReadingQuestion(
      question: 'Welche Frage steht im Mittelpunkt der Sitzung?',
      questionTranslation: 'Which question is at the centre of the session?',
      options: [
        'ob Sprache das Denken beeinflusst',
        'wie man eine Sprache lernt',
        'wann Sprache entstand'
      ],
      optionsTranslation: [
        'whether language influences thinking',
        'how to learn a language',
        'when language arose'
      ],
      correctIndex: 0,
      explanation: '"… inwiefern unsere Sprache unser Denken beeinflusst."',
    ),
    ReadingQuestion(
      question: 'Was nahm man lange Zeit an?',
      questionTranslation: 'What was assumed for a long time?',
      options: [
        'Sprache sei nur ein Werkzeug.',
        'Sprache habe keinen Einfluss.',
        'Denken sei unmöglich ohne Sprache.'
      ],
      optionsTranslation: [
        'that language is merely a tool',
        'that language has no influence',
        'that thinking is impossible without language'
      ],
      correctIndex: 0,
      explanation: '"… Sprache sei lediglich ein Werkzeug …"',
    ),
    ReadingQuestion(
      question: 'Wie bewertet der Redner den Einfluss?',
      questionTranslation: 'How does the speaker assess the influence?',
      options: [
        'als eindeutig bewiesen',
        'als schwer zu messen und umstritten',
        'als völlig unwichtig'
      ],
      optionsTranslation: [
        'as clearly proven',
        'as hard to measure and controversial',
        'as completely unimportant'
      ],
      correctIndex: 1,
      explanation: '"… ist dieser Einfluss schwer zu messen und bleibt '
          'umstritten."',
    ),
    ReadingQuestion(
      question: 'Was legen neuere Studien nahe?',
      questionTranslation: 'What do newer studies suggest?',
      options: [
        'dass die Sprachstruktur unsere Wahrnehmung prägt',
        'dass Sprache keine Rolle spielt',
        'dass alle Sprachen gleich sind',
      ],
      optionsTranslation: [
        'that language structure shapes our perception',
        'that language plays no role',
        'that all languages are the same',
      ],
      correctIndex: 0,
      explanation: '"… dass die Struktur einer Sprache durchaus prägt, wie wir '
          'die Welt wahrnehmen."',
    ),
    ReadingQuestion(
      question: 'Was kündigt der Redner für den zweiten Teil an?',
      questionTranslation: 'What does the speaker announce for the second part?',
      options: [
        'konkrete Beispiele',
        'eine Prüfung',
        'eine Pause',
      ],
      optionsTranslation: [
        'concrete examples',
        'an exam',
        'a break',
      ],
      correctIndex: 0,
      explanation: '"Im zweiten Teil werden wir konkrete Beispiele betrachten."',
    ),
  ],
  intro: 'An academic lecture — you only hear it. Listen for the central '
      'question, the old assumption (Konjunktiv I: sei) and the speaker’s '
      'caveat. Replay as needed.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'inwiefern = to what extent',
      text: 'Academic questions often start "inwiefern …" — note what is being '
          'asked.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Hedging',
      text: '"legen nahe" (suggest), "allerdings" (however), "umstritten" '
          '(controversial) signal caution — important for the assessment '
          'question.',
    ),
  ],
);

/// 8. Konnektoren: insofern / sofern / zumal.
final QuizContent questC11KonnektorenContent = sentenceQuestQuiz(
  id: 'quest_c1_1_konnektoren',
  title: 'C1.1 · Konnektoren (insofern/sofern/zumal)',
  promptLabel: 'Konnektor',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Bedeutung',
  categoryLabel: 'Konnektor',
  intro: 'Sophisticated connectors give precise logical relations: **sofern** '
      '(provided that), **insofern** (in that respect), **zumal** (especially '
      'since), **indem** (by …-ing).',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: 'Precise links',
      text: 'sofern = if/provided that; zumal = all the more so because; indem = '
          'by means of (manner).',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: 'Verb position',
      text: 'sofern/zumal/indem are subordinating → verb to the end. insofern as '
          'an adverb → verb second.',
    ),
  ],
  items: [
    qsi('Ich helfe dir, ____ ich Zeit habe. (provided that)', 'sofern',
        'I’ll help you, provided I have time.', 'sofern'),
    qsi('Er kam pünktlich, ____ er sonst immer zu spät ist. (especially since)',
        'zumal', 'He came on time, especially since he’s usually late.',
        'zumal'),
    qsi('Man lernt eine Sprache, ____ man sie benutzt. (by …-ing)', 'indem',
        'You learn a language by using it.', 'indem'),
    qsi('Der Plan ist gut, ____ er auch Kosten spart. (especially since)',
        'zumal', 'The plan is good, all the more so as it also saves costs.',
        'zumal'),
    qsi('Wir fahren, ____ das Wetter es zulässt. (provided that)', 'sofern',
        'We’ll go, provided the weather allows it.', 'sofern'),
  ],
);

/// 9. Lesen: Populärwissenschaftlicher Artikel.
final QuizContent questC11LesenWissenschaftContent = readingQuestQuiz(
  id: 'quest_c1_1_lesen_wissenschaft',
  title: 'C1.1 · Lesen: Wissenschaft',
  category: 'Science',
  passageTitle: 'Warum wir Musik mögen',
  passage:
      'Warum berührt uns Musik so stark? Forscher vermuten, dass Musik '
      'verschiedene Bereiche des Gehirns gleichzeitig aktiviert, unter anderem '
      'jene, die für Emotionen zuständig sind. Interessanterweise schüttet das '
      'Gehirn beim Hören eines geliebten Liedes denselben Botenstoff aus wie '
      'beim Essen oder bei anderen angenehmen Erfahrungen. Dies erklärt, weshalb '
      'Musik nicht nur unterhält, sondern auch zur Entspannung und sogar zur '
      'Therapie eingesetzt werden kann. Die Forschung steht hier allerdings erst '
      'am Anfang.',
  passageTranslation:
      'Why does music move us so strongly? Researchers suspect that music '
      'activates various areas of the brain at the same time, among them those '
      'responsible for emotions. Interestingly, when listening to a beloved '
      'song the brain releases the same messenger substance as when eating or '
      'during other pleasant experiences. This explains why music not only '
      'entertains but can also be used for relaxation and even therapy. However, '
      'research here is only at the beginning.',
  questions: const [
    ReadingQuestion(
      question: 'Was vermuten die Forscher über Musik?',
      questionTranslation: 'What do researchers suspect about music?',
      options: [
        'Sie aktiviert mehrere Hirnbereiche gleichzeitig.',
        'Sie schadet dem Gehirn.',
        'Sie wirkt nur auf Kinder.'
      ],
      optionsTranslation: [
        'It activates several brain areas at once.',
        'It harms the brain.',
        'It only affects children.'
      ],
      correctIndex: 0,
      explanation: '"… Musik verschiedene Bereiche des Gehirns gleichzeitig '
          'aktiviert …"',
    ),
    ReadingQuestion(
      question: 'Womit wird das Hören eines geliebten Liedes verglichen?',
      questionTranslation: 'What is listening to a beloved song compared with?',
      options: ['mit dem Schlafen', 'mit dem Essen', 'mit dem Lesen'],
      optionsTranslation: ['with sleeping', 'with eating', 'with reading'],
      correctIndex: 1,
      explanation: '"… denselben Botenstoff … wie beim Essen …"',
    ),
    ReadingQuestion(
      question: 'Wie steht es um die Forschung?',
      questionTranslation: 'What is the state of the research?',
      options: [
        'Sie ist abgeschlossen.',
        'Sie steht erst am Anfang.',
        'Sie wurde gestoppt.'
      ],
      optionsTranslation: [
        'It is complete.',
        'It is only at the beginning.',
        'It has been stopped.'
      ],
      correctIndex: 1,
      explanation: '"Die Forschung steht hier allerdings erst am Anfang."',
    ),
  ],
  intro: 'A popular-science article with passive alternatives (eingesetzt werden '
      'kann) and nominal style. C1-level density.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'nicht nur …, sondern auch …',
      text: 'Adds a second function of music — a likely question target.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Hedge at the end',
      text: '"allerdings erst am Anfang" qualifies the claims — note the caution.',
    ),
  ],
);

/// 10. Partizipialsätze (verkürzte Nebensätze).
final QuizContent questC11PartizipialsatzContent = sentenceQuestQuiz(
  id: 'quest_c1_1_partizipialsatz',
  title: 'C1.1 · Partizipialsätze',
  promptLabel: 'Partizip',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Bedeutung',
  categoryLabel: 'Partizipialsatz',
  intro: 'A participial clause shortens a subordinate clause to a participle '
      'phrase: "In Berlin __angekommen__, suchte er ein Hotel" = Having arrived '
      'in Berlin, he looked for a hotel.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Partizip II = completed',
      text: '"Angekommen, …" / "Erschöpft, …" — the action is finished before '
          'the main clause.',
    ),
    HelpMemoryTip(
      kind: 'rule',
      title: 'Partizip I = simultaneous',
      text: '"Lächelnd verließ sie den Raum" = Smiling, she left the room. Both '
          'happen at once.',
    ),
  ],
  items: [
    qsi('In Berlin ____, suchte er ein Hotel. (ankommen → Partizip II)',
        'angekommen', 'Having arrived in Berlin, he looked for a hotel.',
        'angekommen'),
    qsi('____ verließ sie den Raum. (lächeln → Partizip I)', 'Lächelnd',
        'Smiling, she left the room.', 'lächelnd'),
    qsi('Von der Reise ____, ging er sofort ins Bett. (erschöpfen → Partizip '
        'II)', 'erschöpft', 'Exhausted from the trip, he went straight to bed.',
        'erschöpft'),
    qsi('____ blieb er den ganzen Abend. (schweigen → Partizip I)', 'Schweigend',
        'Silent, he stayed the whole evening.', 'schweigend'),
    qsi('Tief ____, sagte er nichts mehr. (beeindrucken → Partizip II)',
        'beeindruckt', 'Deeply impressed, he said nothing more.',
        'beeindruckt'),
  ],
);

/// 11. Diktat: Nominalstil.
final QuizContent questC11DiktatContent = dictationQuestQuiz(
  id: 'quest_c1_1_diktat_nominalstil',
  title: 'C1.1 · Diktat: Wissenschaftssprache',
  promptLabel: 'Satz',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Deutsch',
  intro: 'A dictation in academic register. You HEAR a sentence and TYPE it. '
      'Listen for nominal phrases, passive alternatives (lässt sich, ist zu) and '
      'precise connectors.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Long nominal phrases',
      text: 'Hold the whole noun phrase ("die Durchführung der Untersuchung") '
          'before you write.',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: 'Spell the compounds',
      text: 'Academic compounds (Schlussfolgerung, Voraussetzung) are written as '
          'one word.',
    ),
  ],
  sentences: const [
    SpeakPhrase(
        phrase: 'Die Durchführung der Untersuchung dauerte mehrere Jahre.',
        meaning: 'Carrying out the investigation took several years.'),
    SpeakPhrase(
        phrase: 'Das Problem lässt sich nicht einfach lösen.',
        meaning: 'The problem cannot be solved easily.'),
    SpeakPhrase(
        phrase: 'Daraus lässt sich eine wichtige Schlussfolgerung ziehen.',
        meaning: 'From this an important conclusion can be drawn.'),
    SpeakPhrase(
        phrase: 'Der Text ist ohne Vorwissen kaum zu verstehen.',
        meaning: 'The text is hard to understand without prior knowledge.'),
    SpeakPhrase(
        phrase: 'Eine gute Ausbildung ist die Voraussetzung für Erfolg.',
        meaning: 'A good education is the precondition for success.'),
    SpeakPhrase(
        phrase: 'Die Ergebnisse sind insofern überraschend, als sie neu sind.',
        meaning: 'The results are surprising in that they are new.'),
  ],
);

/// 12. Sprechen: Eine Grafik beschreiben.
final QuizContent questC11SprechenGrafikContent = speakQuestQuiz(
  id: 'quest_c1_1_sprechen_grafik',
  title: 'C1.1 · Sprechen: Eine Grafik beschreiben',
  promptLabel: 'Satz',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Deutsch',
  intro: 'Describe and interpret a chart — a frequent C1 exam task. Listen and '
      'repeat these phrases for trends and figures.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Trend verbs',
      text: 'steigen (rise), sinken (fall), gleich bleiben (stay the same), '
          'sich verdoppeln (double).',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'Refer to the data',
      text: '"Die Grafik zeigt …", "Auffällig ist, dass …", "im Vergleich zu …".',
    ),
  ],
  phrases: const [
    SpeakPhrase(
        phrase: 'Die Grafik zeigt die Entwicklung der Preise.',
        meaning: 'The chart shows the development of prices.'),
    SpeakPhrase(
        phrase: 'Die Zahlen sind deutlich gestiegen.',
        meaning: 'The figures have risen significantly.'),
    SpeakPhrase(
        phrase: 'Im Vergleich zum Vorjahr sank der Wert.',
        meaning: 'Compared with the previous year the value fell.'),
    SpeakPhrase(
        phrase: 'Auffällig ist, dass der Anteil gleich blieb.',
        meaning: 'Notably, the share stayed the same.'),
    SpeakPhrase(
        phrase: 'Daraus lässt sich schließen, dass …',
        meaning: 'From this one can conclude that …'),
    SpeakPhrase(
        phrase: 'Zusammenfassend zeigt die Grafik einen klaren Trend.',
        meaning: 'In summary the chart shows a clear trend.'),
  ],
);

/// 13. Hören: Eine Diskussionsrunde.
final QuizContent questC11HoerenPodiumContent = listeningQuestQuiz(
  id: 'quest_c1_1_hoeren_podiumsdiskussion',
  // Panel moderator (no gendered cue) — cast as a male voice for variety.
  voiceGender: VoiceGender.male,
  title: 'C1.1 · Hören: Diskussionsrunde',
  category: 'Society',
  passageTitle: 'Podium: Digitalisierung der Schule',
  passage:
      'In unserer Diskussionsrunde geht es um die Digitalisierung der Schulen. '
      'Herr Lang argumentiert, Tablets könnten den Unterricht bereichern, sofern '
      'die Lehrkräfte gut geschult seien. Frau Roth hält dagegen, die '
      'Konzentration der Schüler leide unter ständiger Ablenkung. Beide sind '
      'sich jedoch einig, dass die Technik allein keinen guten Unterricht '
      'garantiere. Entscheidend bleibe, wie sie eingesetzt werde.',
  passageTranslation:
      'In our panel discussion the topic is the digitalisation of schools. Mr '
      'Lang argues that tablets could enrich teaching, provided the teachers are '
      'well trained. Ms Roth counters that pupils’ concentration suffers from '
      'constant distraction. Both agree, however, that the technology alone does '
      'not guarantee good teaching. What remains decisive is how it is used.',
  questions: const [
    ReadingQuestion(
      question: 'Was ist Herrn Langs Position?',
      questionTranslation: 'What is Mr Lang’s position?',
      options: [
        'Tablets könnten den Unterricht bereichern.',
        'Tablets sind reine Geldverschwendung.',
        'Schulen brauchen keine Technik.'
      ],
      optionsTranslation: [
        'Tablets could enrich teaching.',
        'Tablets are a waste of money.',
        'Schools need no technology.'
      ],
      correctIndex: 0,
      explanation: '"… Tablets könnten den Unterricht bereichern …"',
    ),
    ReadingQuestion(
      question: 'Was kritisiert Frau Roth?',
      questionTranslation: 'What does Ms Roth criticise?',
      options: [
        'die Kosten',
        'die Ablenkung der Schüler',
        'die Ausbildung der Lehrer'
      ],
      optionsTranslation: [
        'the cost',
        'the distraction of pupils',
        'the training of teachers'
      ],
      correctIndex: 1,
      explanation: '"… die Konzentration der Schüler leide unter ständiger '
          'Ablenkung."',
    ),
    ReadingQuestion(
      question: 'Worüber sind sich beide einig?',
      questionTranslation: 'What do both agree on?',
      options: [
        'dass Technik allein keinen guten Unterricht garantiert',
        'dass Tablets verboten werden sollten',
        'dass nichts geändert werden muss'
      ],
      optionsTranslation: [
        'that technology alone does not guarantee good teaching',
        'that tablets should be banned',
        'that nothing needs to change'
      ],
      correctIndex: 0,
      explanation: '"… die Technik allein keinen guten Unterricht garantiere."',
    ),
  ],
  intro: 'A panel discussion — you only hear it. Track the two positions and '
      'their common ground, in reported speech (könnten, leide, garantiere). '
      'Replay as needed.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'argues vs counters',
      text: '"argumentiert" (Lang) vs "hält dagegen" (Roth) — opposite sides. '
          'Then "einig" marks agreement.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'sofern = provided that',
      text: 'Lang’s support is conditional: "… sofern die Lehrkräfte gut '
          'geschult seien."',
    ),
  ],
);

/// 14. Lesen: Ein Essay-Auszug.
final QuizContent questC11LesenEssayContent = readingQuestQuiz(
  id: 'quest_c1_1_lesen_essay',
  title: 'C1.1 · Lesen: Ein Essay',
  category: 'Society',
  passageTitle: 'Über die Langeweile',
  passage:
      'Langeweile gilt heute als etwas, das es um jeden Preis zu vermeiden gilt. '
      'Kaum entsteht eine freie Minute, greifen wir zum Smartphone. Dabei wird '
      'oft übersehen, dass gerade die Langeweile eine wichtige Funktion erfüllt: '
      'Sie schafft Raum für eigene Gedanken und für Kreativität. Wer sich nie '
      'langweilt, lässt seinem Geist keine Gelegenheit, neue Ideen zu '
      'entwickeln. Vielleicht wäre es klug, die Langeweile nicht als Feind, '
      'sondern als Quelle zu begreifen.',
  passageTranslation:
      'Boredom is regarded today as something to be avoided at all costs. Hardly '
      'has a free minute arisen before we reach for the smartphone. Yet it is '
      'often overlooked that boredom in particular fulfils an important '
      'function: it creates space for one’s own thoughts and for creativity. '
      'Anyone who is never bored gives their mind no opportunity to develop new '
      'ideas. Perhaps it would be wise to understand boredom not as an enemy but '
      'as a source.',
  questions: const [
    ReadingQuestion(
      question: 'Wie wird Langeweile heute meist gesehen?',
      questionTranslation: 'How is boredom mostly seen today?',
      options: [
        'als etwas, das man vermeiden sollte',
        'als angenehm',
        'als notwendig'
      ],
      optionsTranslation: [
        'as something to be avoided',
        'as pleasant',
        'as necessary'
      ],
      correctIndex: 0,
      explanation: '"… etwas, das es um jeden Preis zu vermeiden gilt."',
    ),
    ReadingQuestion(
      question: 'Welche Funktion schreibt der Autor der Langeweile zu?',
      questionTranslation: 'What function does the author ascribe to boredom?',
      options: [
        'Sie schafft Raum für Kreativität.',
        'Sie macht krank.',
        'Sie ist reine Zeitverschwendung.'
      ],
      optionsTranslation: [
        'It creates space for creativity.',
        'It makes you ill.',
        'It is pure waste of time.'
      ],
      correctIndex: 0,
      explanation: '"Sie schafft Raum für eigene Gedanken und für Kreativität."',
    ),
    ReadingQuestion(
      question: 'Was schlägt der Autor am Ende vor?',
      questionTranslation: 'What does the author suggest at the end?',
      options: [
        'Langeweile als Quelle zu begreifen',
        'Langeweile ganz zu verbieten',
        'mehr Smartphones zu nutzen'
      ],
      optionsTranslation: [
        'to understand boredom as a source',
        'to ban boredom entirely',
        'to use more smartphones'
      ],
      correctIndex: 0,
      explanation: '"… die Langeweile nicht als Feind, sondern als Quelle zu '
          'begreifen."',
    ),
  ],
  intro: 'An essay extract — abstract and reflective, with passive alternatives '
      '(zu vermeiden gilt) and a Konjunktiv II suggestion (wäre … klug). A '
      'demanding C1 read.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'The author’s thesis',
      text: 'Essays defend a view. Here: boredom is valuable. The "nicht … '
          'sondern" ending states it.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Dabei wird übersehen',
      text: 'This phrase signals the author is about to correct the common view.',
    ),
  ],
);

/// Big text (inline cloze) — Hinweise zum neuen System: the passive-substitute
/// forms (Passiversatzformen) in their natural home, a formal office notice. The
/// gaps rotate through sich lassen, sein + zu, the -bar adjective and the plain
/// modal passive — the four ways C1 German avoids a bare "werden" passive.
final QuizContent questC11BigTextHinweiseContent = bigTextQuestQuiz(
  id: 'quest_c1_1_bigtext_hinweise',
  title: 'C1.1 · Großer Text: Hinweise zum neuen System',
  passageTitle: 'Hinweise zum neuen System',
  template:
      'Liebe Kolleginnen und Kollegen, hier einige Hinweise zum neuen System. '
      'Das Programm {{0}} sich in wenigen Minuten installieren. Die Anleitung '
      'ist auf der Webseite zu {{1}}. Alle technischen Probleme sind sofort dem '
      'Support zu {{2}}. Das Passwort ist jederzeit {{3}}. Das alte System {{4}} '
      'sich nicht mehr verwenden. Diese Regeln {{5}} von allen beachtet werden. '
      'Fehler sind unbedingt zu {{6}}. Wir danken für Ihr {{7}}.',
  blanks: [
    inputBlank('lässt', accepted: const ['laesst'],
        hint: 'sich lassen = kann … werden'),
    inputBlank('finden', hint: 'sein + zu … (= muss gefunden werden)'),
    inputBlank('melden', hint: 'sein + zu … (= müssen gemeldet werden)'),
    inputBlank('änderbar', accepted: const ['aenderbar'],
        hint: '-bar = kann geändert werden (ändern)'),
    inputBlank('lässt', accepted: const ['laesst'],
        hint: 'sich lassen = kann … werden'),
    inputBlank('müssen', hint: 'Modalpassiv: … beachtet werden'),
    inputBlank('vermeiden', hint: 'sein + zu … (= müssen vermieden werden)'),
    inputBlank('Verständnis', accepted: const ['Verstaendnis'],
        hint: 'Nomen: danken für Ihr …'),
  ],
  passageTranslation:
      'Dear colleagues, here are some notes on the new system. The programme can '
      'be installed in a few minutes. The instructions can be found on the '
      'website. All technical problems must be reported to support immediately. '
      'The password can be changed at any time. The old system can no longer be '
      'used. These rules must be observed by everyone. Errors are absolutely to '
      'be avoided. Thank you for your understanding.',
  intro: 'Formal German rarely leaves a plain "werden" passive standing. It '
      'prefers substitutes: sich lassen (lässt sich …), sein + zu + Infinitiv '
      '(ist zu …), and the -bar adjective (änderbar). Fill each with the right '
      'form.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Three ways to say "can be done"',
      text: 'kann installiert werden = lässt sich installieren = ist installierbar. '
          'All three mean the same; the notice mixes them for style.',
    ),
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'sein + zu = müssen/können + Passiv',
      text: '"ist zu melden" = muss gemeldet werden (obligation); "ist zu finden" '
          '= kann gefunden werden (possibility). Context tells you which.',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: '-bar means "-able"',
      text: 'machbar (doable), lesbar (legible), änderbar (changeable): the -bar '
          'adjective packs a whole "can be …ed" passive into one word.',
    ),
  ],
);

/// Every C1.1 quiz, in chain order — all five exercise types, interleaved.
final List<QuizContent> questC1_1Content = [
  questC11BildungContent, //            Bildung & Wissenschaft  (knowledge)
  questC11NominalisierungContent, //    Nominalisierung         (knowledge)
  questC11SprechenDarstellenContent, // Sprechen: darstellen    (speaking)
  questC11VerbalisierungContent, //     Verbalisierung          (knowledge)
  questC11PassiversatzContent, //       Passiversatz            (knowledge·verb)
  questC11BigTextHinweiseContent, //    Großer Text: Hinweise   (reading·cloze)
  questC11HoerenVorlesungContent, //    Hören: Vorlesung        (listening)
  questC11BarLichContent, //            Adjektive -bar/-lich    (knowledge)
  questC11KonnektorenContent, //        Konnektoren             (knowledge)
  questC11LesenWissenschaftContent, //  Lesen: Wissenschaft     (reading)
  questC11PartizipialsatzContent, //    Partizipialsätze        (knowledge)
  questC11DiktatContent, //             Diktat: Nominalstil     (dictation)
  questC11SprechenGrafikContent, //     Sprechen: Grafik        (speaking)
  questC11HoerenPodiumContent, //       Hören: Podium           (listening)
  questC11LesenEssayContent, //         Lesen: Essay            (reading)
];
