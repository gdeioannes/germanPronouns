import '../../models/quiz_content.dart';
import 'quest_builders.dart';

/// CEFR **B2.1 — "Argumentieren"** Quest quizzes (Goethe B2). Big rocks: the
/// **Konjunktiv I** (reported speech), the **modal passive** (kann gemacht
/// werden), participles as adjectives, verbs with fixed prepositions and
/// da-/wo-compounds.

/// 1. Gesellschaft & Politik (vocab).
final QuizContent questB21GesellschaftContent = sentenceQuestQuiz(
  id: 'quest_b2_1_gesellschaft',
  title: 'B2.1 · Gesellschaft & Politik',
  promptLabel: 'Wort',
  subjectsLabel: 'Gesellschaft',
  subjectColumnLabel: 'English',
  categoryLabel: 'Gesellschaft',
  contextualLayout: true,
  intro: 'Abstract vocabulary for debate and current affairs — the register of '
      'the B2 exam.',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: 'Debate nouns',
      text: 'die Gesellschaft (society), die Regierung (government), die '
          'Mehrheit (majority), die Entwicklung (development).',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Nominal style',
      text: 'B2 texts prefer nouns: "die Förderung" (the promotion of), "die '
          'Auswirkung" (the effect). Recognise them.',
    ),
  ],
  items: [
    qsi('Die ____ hat ein neues Gesetz beschlossen. (government)',
        'Regierung', 'The government passed a new law.', 'government'),
    qsi('Die ____ der Bürger ist dagegen. (majority)', 'Mehrheit',
        'The majority of citizens are against it.', 'majority'),
    qsi('Die wirtschaftliche ____ ist positiv. (development)', 'Entwicklung',
        'The economic development is positive.', 'development'),
    qsi('Wir leben in einer modernen ____. (society)', 'Gesellschaft',
        'We live in a modern society.', 'society'),
    qsi('Klimaschutz ist eine große ____. (challenge)', 'Herausforderung',
        'Climate protection is a big challenge.', 'challenge'),
  ],
);

/// 2. Konjunktiv I: indirekte Rede.
final QuizContent questB21Konj1Content = sentenceQuestQuiz(
  id: 'quest_b2_1_konj1',
  title: 'B2.1 · Konjunktiv I: indirekte Rede',
  promptLabel: 'Konjunktiv I',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Bedeutung',
  categoryLabel: 'Konjunktiv I',
  intro: 'In formal reported speech (news, reports), German uses the **Konjunktiv '
      'I** to show that someone else said it: "Er sagt, er __sei__ krank." It '
      'signals distance from the claim.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Common Konjunktiv I forms',
      text: 'sein → sei/seien, haben → habe, können → könne, werden → werde; '
          'most verbs: stem + -e (er gehe, er komme).',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Switch to Konjunktiv II if identical',
      text: 'If the Konj. I looks like the present (sie haben → sie haben), use '
          'Konj. II instead (sie hätten).',
    ),
  ],
  items: [
    qsi('Er sagt, er ____ krank. (sein → Konj. I)', 'sei',
        'He says he is ill.', 'er sei'),
    qsi('Sie meint, sie ____ keine Zeit. (haben → Konj. I)', 'habe',
        'She says she has no time.', 'sie habe'),
    qsi('Der Minister sagt, er ____ bald zurücktreten. (werden → Konj. I)',
        'werde', 'The minister says he will soon resign.', 'er werde'),
    qsi('Man sagt, er ____ sehr reich. (sein → Konj. I)', 'sei',
        'They say he is very rich.', 'er sei'),
    qsi('Sie behauptet, sie ____ nichts davon gewusst. (haben → Konj. I)',
        'habe', 'She claims she knew nothing about it.', 'sie habe'),
  ],
);

/// 3. Indirekte Fragen & Bitten.
final QuizContent questB21IndirektContent = sentenceQuestQuiz(
  id: 'quest_b2_1_indirekt_fragen',
  title: 'B2.1 · Indirekte Fragen',
  promptLabel: 'Einleitewort',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Bedeutung',
  categoryLabel: 'indirekte Frage',
  intro: 'Reported questions become subordinate clauses (verb to the end). '
      'W-questions keep their W-word; yes/no questions use **ob** (whether).',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'ob = whether',
      text: '"Kommst du?" → "Er fragt, __ob__ ich __komme__." Verb at the end, '
          'no question mark inside.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'W-word stays',
      text: '"Wo wohnst du?" → "Sie fragt, __wo__ ich __wohne__."',
    ),
  ],
  items: [
    qsi('Er fragt, ____ ich morgen komme. (whether)', 'ob',
        'He asks whether I’m coming tomorrow.', 'ob'),
    qsi('Sie möchte wissen, ____ ich wohne. (where)', 'wo',
        'She wants to know where I live.', 'wo'),
    qsi('Ich frage mich, ____ das wahr ist. (whether)', 'ob',
        'I wonder whether that is true.', 'ob'),
    qsi('Er fragt, ____ viel das kostet. (how much → wie)', 'wie',
        'He asks how much it costs.', 'wie'),
    qsi('Wissen Sie, ____ der Zug fährt? (when → wann)', 'wann',
        'Do you know when the train leaves?', 'wann'),
  ],
);

/// 4. Sprechen: Eine Meinung verteidigen.
final QuizContent questB21SprechenVerteidigenContent = speakQuestQuiz(
  id: 'quest_b2_1_sprechen_verteidigen',
  title: 'B2.1 · Sprechen: Meinung verteidigen',
  promptLabel: 'Satz',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Deutsch',
  intro: 'Defend a position and respond to counter-arguments — a core B2 '
      'speaking skill. Listen and repeat these discourse phrases.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Concede, then counter',
      text: '"Das mag stimmen, aber …", "Zwar …, trotzdem …" let you accept a '
          'point and still disagree.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'Strengthen a claim',
      text: '"Ich bin fest davon überzeugt, dass …" sounds confident and B2.',
    ),
  ],
  phrases: const [
    SpeakPhrase(
        phrase: 'Ich bin davon überzeugt, dass …',
        meaning: 'I am convinced that …'),
    SpeakPhrase(
        phrase: 'Das mag stimmen, aber man muss bedenken, dass …',
        meaning: 'That may be true, but one must consider that …'),
    SpeakPhrase(
        phrase: 'Ein wichtiges Argument dafür ist …',
        meaning: 'An important argument for it is …'),
    SpeakPhrase(
        phrase: 'Dem kann ich nicht zustimmen.',
        meaning: 'I can’t agree with that.'),
    SpeakPhrase(
        phrase: 'Lassen Sie mich das erklären.',
        meaning: 'Let me explain that.'),
    SpeakPhrase(
        phrase: 'Zusammenfassend lässt sich sagen, dass …',
        meaning: 'In summary, one can say that …'),
  ],
);

/// 5. Modalpassiv (kann/muss gemacht werden).
final QuizContent questB21ModalpassivContent = sentenceQuestQuiz(
  id: 'quest_b2_1_modalpassiv',
  title: 'B2.1 · Modalpassiv',
  promptLabel: 'Form',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Bedeutung',
  categoryLabel: 'Modalpassiv',
  intro: 'A modal + passive expresses what can/must be done: **Modal + Partizip '
      'II + werden** (infinitive). "Das __kann gemacht werden__."',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'modal … Partizip + werden',
      text: '"Das Problem __muss gelöst werden__." The modal is conjugated; '
          '"Partizip + werden" goes to the end.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Common in instructions',
      text: 'Rules and manuals love it: "Hier darf nicht geraucht werden."',
    ),
  ],
  items: [
    qsi('Das Problem muss schnell gelöst ____. (werden)', 'werden',
        'The problem must be solved quickly.', 'muss gelöst werden'),
    qsi('Hier darf nicht geraucht ____. (werden)', 'werden',
        'Smoking is not allowed here.', 'darf … werden'),
    qsi('Die Aufgabe kann leicht gemacht ____. (werden)', 'werden',
        'The task can be done easily.', 'kann gemacht werden'),
    qsi('Das Formular muss unterschrieben ____. (werden)', 'werden',
        'The form must be signed.', 'muss unterschrieben werden'),
    qsi('Der Termin sollte verschoben ____. (werden)', 'werden',
        'The appointment should be postponed.', 'sollte verschoben werden'),
  ],
);

/// 6. Hören: Eine Debatte.
final QuizContent questB21HoerenDebatteContent = listeningQuestQuiz(
  id: 'quest_b2_1_hoeren_debatte',
  title: 'B2.1 · Hören: Eine Debatte',
  category: 'Society',
  passageTitle: 'Debatte: Autofreie Innenstadt',
  passage:
      'In der heutigen Debatte geht es um autofreie Innenstädte. Die Befürworter '
      'argumentieren, dass die Luft sauberer werde und die Straßen sicherer '
      'seien. Die Gegner meinen dagegen, dass viele Geschäfte Kunden verlieren '
      'könnten. Eine Sprecherin betont, man müsse den öffentlichen Verkehr '
      'zuerst verbessern. Am Ende waren sich beide Seiten einig, dass eine '
      'Lösung gefunden werden muss.',
  passageTranslation:
      'Today’s debate is about car-free city centres. The supporters argue that '
      'the air would become cleaner and the streets safer. The opponents, on the '
      'other hand, think that many shops could lose customers. A spokeswoman '
      'stresses that public transport must be improved first. In the end both '
      'sides agreed that a solution must be found.',
  questions: const [
    ReadingQuestion(
      question: 'Worum geht es in der Debatte?',
      questionTranslation: 'What is the debate about?',
      options: [
        'um höhere Steuern',
        'um autofreie Innenstädte',
        'um mehr Parkplätze'
      ],
      optionsTranslation: [
        'about higher taxes',
        'about car-free city centres',
        'about more parking'
      ],
      correctIndex: 1,
      explanation: '"… geht es um autofreie Innenstädte."',
    ),
    ReadingQuestion(
      question: 'Was befürchten die Gegner?',
      questionTranslation: 'What do the opponents fear?',
      options: [
        'dass Geschäfte Kunden verlieren',
        'dass die Luft schlechter wird',
        'dass es teurer wird'
      ],
      optionsTranslation: [
        'that shops lose customers',
        'that the air gets worse',
        'that it gets more expensive'
      ],
      correctIndex: 0,
      explanation: '"… dass viele Geschäfte Kunden verlieren könnten."',
    ),
    ReadingQuestion(
      question: 'Worüber waren sich am Ende beide Seiten einig?',
      questionTranslation: 'What did both sides agree on in the end?',
      options: [
        'dass eine Lösung gefunden werden muss',
        'dass nichts geändert wird',
        'dass die Gegner recht haben'
      ],
      optionsTranslation: [
        'that a solution must be found',
        'that nothing will change',
        'that the opponents are right'
      ],
      correctIndex: 0,
      explanation: '"… dass eine Lösung gefunden werden muss."',
    ),
  ],
  intro: 'A debate — you only hear it. Keep the two sides apart: Befürworter '
      '(supporters) vs Gegner (opponents). Note the Konjunktiv I (werde, seien). '
      'Replay as needed.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Pro vs contra',
      text: 'Befürworter argue for, Gegner against. Sort each claim to its side.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Reported speech',
      text: '"… argumentieren, dass die Luft sauberer __werde__" is Konjunktiv '
          'I — a reported claim, not a fact.',
    ),
  ],
);

/// 7. Verben mit Präposition + da-/wo-Kompositum.
final QuizContent questB21VerbenPraepContent = sentenceQuestQuiz(
  id: 'quest_b2_1_verben_praep',
  title: 'B2.1 · Verben mit Präposition',
  promptLabel: 'Präposition',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Verb',
  categoryLabel: 'Verb + Präposition',
  intro: 'Many verbs take a fixed preposition you must learn together: warten '
      '**auf**, sich freuen **auf/über**, denken **an**, sich interessieren '
      '**für**. For things, use da-/wo-compounds (darauf, worauf).',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'da-/wo-compounds',
      text: 'For things: "Ich warte __darauf__." Question: "__Worauf__ wartest '
          'du?" For people, keep the preposition: auf wen?',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'Learn verb + preposition as a unit',
      text: 'warten auf (+Akk), denken an (+Akk), sich freuen über (+Akk), '
          'teilnehmen an (+Dat).',
    ),
  ],
  items: [
    qsi('Ich warte ____ den Bus. (warten + …)', 'auf',
        'I’m waiting for the bus.', 'warten auf'),
    qsi('Sie interessiert sich ____ Kunst. (sich interessieren + …)', 'für',
        'She is interested in art.', 'sich interessieren für'),
    qsi('Wir denken oft ____ dich. (denken + …)', 'an',
        'We often think of you.', 'denken an'),
    qsi('Er freut sich ____ das Geschenk. (sich freuen + …, Akk.)', 'über',
        'He is happy about the gift.', 'sich freuen über'),
    qsi('Viele Menschen nehmen ____ der Demonstration teil. (teilnehmen + …)',
        'an', 'Many people take part in the demonstration.', 'teilnehmen an'),
  ],
);

/// 8. Partizip I & II als Adjektiv.
final QuizContent questB21PartizipAdjContent = sentenceQuestQuiz(
  id: 'quest_b2_1_partizip_adj',
  title: 'B2.1 · Partizip als Adjektiv',
  promptLabel: 'Partizip',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Bedeutung',
  categoryLabel: 'Partizip-Adjektiv',
  intro: 'Participles can work as adjectives (with endings). **Partizip I** '
      '(-end) is active/ongoing: "das __spielende__ Kind". **Partizip II** is '
      'passive/finished: "das __gekochte__ Ei".',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Partizip I = Infinitiv + -d',
      text: 'lachen → lachend → das __lachende__ Kind (the laughing child). '
          'Active, happening now.',
    ),
    HelpMemoryTip(
      kind: 'rule',
      title: 'Partizip II = passive/finished',
      text: 'kochen → gekocht → das __gekochte__ Ei (the boiled egg). The action '
          'is done to the noun.',
    ),
  ],
  items: [
    qsi('Das ____ Kind ist süß. (lachen → Partizip I)', 'lachende',
        'The laughing child is sweet.', 'das lachende Kind'),
    qsi('Die ____ Sonne ist wunderschön. (untergehen → Partizip I)',
        'untergehende', 'The setting sun is beautiful.',
        'die untergehende Sonne'),
    qsi('Ich esse ein ____ Ei. (kochen → Partizip II)', 'gekochtes',
        'I eat a boiled egg.', 'ein gekochtes Ei'),
    qsi('Das ist ein gut ____ Buch. (schreiben → Partizip II)', 'geschriebenes',
        'That is a well-written book.', 'ein geschriebenes Buch'),
    qsi('Die ____ Blumen sind schön. (blühen → Partizip I)', 'blühenden',
        'The blooming flowers are beautiful.', 'die blühenden Blumen'),
  ],
);

/// 9. Lesen: Pro & Contra Homeoffice.
final QuizContent questB21LesenHomeofficeContent = readingQuestQuiz(
  id: 'quest_b2_1_lesen_homeoffice',
  title: 'B2.1 · Lesen: Pro & Contra Homeoffice',
  category: 'Work',
  passageTitle: 'Homeoffice: Fluch oder Segen?',
  passage:
      'Das Arbeiten von zu Hause wird oft als ideale Lösung dargestellt. '
      'Befürworter betonen die gewonnene Flexibilität: Termine könnten besser '
      'mit dem Familienleben vereinbart werden. Kritiker weisen jedoch darauf '
      'hin, dass die Grenze zwischen Arbeit und Freizeit verschwimme. Wer ständig '
      'erreichbar sei, arbeite am Ende mehr, nicht weniger. Entscheidend ist '
      'daher nicht der Ort, sondern eine klare Regelung der Arbeitszeiten.',
  passageTranslation:
      'Working from home is often presented as the ideal solution. Supporters '
      'stress the flexibility gained: appointments could be better combined with '
      'family life. Critics, however, point out that the line between work and '
      'free time blurs. Anyone who is constantly reachable ends up working more, '
      'not less. The decisive thing is therefore not the place, but a clear '
      'arrangement of working hours.',
  questions: const [
    ReadingQuestion(
      question: 'Welchen Vorteil nennen die Befürworter?',
      questionTranslation: 'Which advantage do the supporters mention?',
      options: [
        'mehr Gehalt',
        'mehr Flexibilität',
        'einen kürzeren Arbeitstag'
      ],
      optionsTranslation: [
        'more salary',
        'more flexibility',
        'a shorter working day'
      ],
      correctIndex: 1,
      explanation: '"Befürworter betonen die gewonnene Flexibilität …"',
    ),
    ReadingQuestion(
      question: 'Wovor warnen die Kritiker?',
      questionTranslation: 'What do the critics warn about?',
      options: [
        'dass man weniger verdient',
        'dass die Grenze zwischen Arbeit und Freizeit verschwimmt',
        'dass die Technik fehlt'
      ],
      optionsTranslation: [
        'that you earn less',
        'that the line between work and free time blurs',
        'that the technology is missing'
      ],
      correctIndex: 1,
      explanation: '"… dass die Grenze zwischen Arbeit und Freizeit verschwimme."',
    ),
    ReadingQuestion(
      question: 'Was ist laut Text entscheidend?',
      questionTranslation: 'What is decisive according to the text?',
      options: [
        'der Arbeitsort',
        'eine klare Regelung der Arbeitszeiten',
        'ein guter Computer'
      ],
      optionsTranslation: [
        'the workplace',
        'a clear arrangement of working hours',
        'a good computer'
      ],
      correctIndex: 1,
      explanation: '"… nicht der Ort, sondern eine klare Regelung …"',
    ),
  ],
  intro: 'An argumentative text with reported speech (verschwimme, sei, arbeite) '
      'and a "nicht …, sondern …" conclusion. Typical B2 reading.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Find the thesis',
      text: 'The conclusion ("Entscheidend ist …") states the author’s view — a '
          'common question target.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Reported = Konjunktiv I',
      text: 'verschwimme, sei, arbeite mark the critics’ reported claims, not '
          'the author’s facts.',
    ),
  ],
);

/// 10. Konnektoren: trotzdem / dennoch / folglich.
final QuizContent questB21KonnektorenContent = sentenceQuestQuiz(
  id: 'quest_b2_1_konnektoren',
  title: 'B2.1 · Konnektoren',
  promptLabel: 'Konnektor',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Bedeutung',
  categoryLabel: 'Konnektor',
  intro: 'Adverbial connectors link sentences and take **position 1 + verb '
      'second**: trotzdem (nevertheless), deshalb/folglich (therefore), '
      'außerdem (moreover).',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Connector + verb second',
      text: '"Es regnete. __Trotzdem__ __gingen__ wir spazieren." The verb '
          'follows the connector directly.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'Meaning groups',
      text: 'Concession: trotzdem/dennoch. Result: deshalb/folglich/daher. '
          'Addition: außerdem/zudem.',
    ),
  ],
  items: [
    qsi('Es war teuer. ____ haben wir es gekauft. (nevertheless)', 'Trotzdem',
        'It was expensive. Nevertheless we bought it.', 'trotzdem'),
    qsi('Er hat viel gelernt. ____ bestand er die Prüfung. (therefore)',
        'Folglich', 'He studied a lot. Therefore he passed the exam.',
        'folglich'),
    qsi('Das Hotel war gut. ____ war es zentral gelegen. (moreover)',
        'Außerdem', 'The hotel was good. Moreover it was centrally located.',
        'außerdem'),
    qsi('Sie war krank. ____ ging sie zur Arbeit. (nevertheless)', 'Dennoch',
        'She was ill. Nevertheless she went to work.', 'dennoch'),
    qsi('Es ist spät. ____ müssen wir gehen. (therefore)', 'Deshalb',
        'It is late. Therefore we have to go.', 'deshalb'),
  ],
);

/// 11. Diktat: Argumentieren.
final QuizContent questB21DiktatContent = dictationQuestQuiz(
  id: 'quest_b2_1_diktat_argument',
  title: 'B2.1 · Diktat: Argumentieren',
  promptLabel: 'Satz',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Deutsch',
  intro: 'A dictation with argumentative language and the modal passive. You '
      'HEAR a sentence and TYPE it. Listen for connectors and "werden" at the '
      'end of passive phrases.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Position-1 connectors',
      text: 'After Trotzdem/Deshalb the verb comes next. Keep that order when '
          'you write.',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: 'Long compound nouns',
      text: 'B2 nouns can be long (Arbeitszeiten, Herausforderung). Write them '
          'as one word.',
    ),
  ],
  sentences: const [
    SpeakPhrase(
        phrase: 'Meiner Meinung nach ist das ein wichtiges Thema.',
        meaning: 'In my opinion this is an important topic.'),
    SpeakPhrase(
        phrase: 'Das Problem muss schnell gelöst werden.',
        meaning: 'The problem must be solved quickly.'),
    SpeakPhrase(
        phrase: 'Es war spät, trotzdem haben wir weiterdiskutiert.',
        meaning: 'It was late, nevertheless we kept discussing.'),
    SpeakPhrase(
        phrase: 'Einerseits ist es teuer, andererseits sehr praktisch.',
        meaning: 'On the one hand it’s expensive, on the other very practical.'),
    SpeakPhrase(
        phrase: 'Viele Menschen nehmen an der Diskussion teil.',
        meaning: 'Many people take part in the discussion.'),
    SpeakPhrase(
        phrase: 'Zusammenfassend lässt sich sagen, dass beide recht haben.',
        meaning: 'In summary, both are right.'),
  ],
);

/// 12. Passiv Perfekt (ist gemacht worden).
final QuizContent questB21PassivPerfektContent = sentenceQuestQuiz(
  id: 'quest_b2_1_passiv_perfekt',
  title: 'B2.1 · Passiv Perfekt',
  promptLabel: 'Form',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Bedeutung',
  categoryLabel: 'Passiv Perfekt',
  intro: 'The perfect passive uses **sein + Partizip II + worden** (note: '
      'worden, not geworden, in the passive): "Das Haus __ist gebaut worden__."',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: 'worden, not geworden',
      text: 'In the passive perfect the auxiliary participle is __worden__: "Es '
          'ist gemacht __worden__." (geworden only when werden = to become.)',
    ),
    HelpMemoryTip(
      kind: 'rule',
      title: 'sein + Partizip + worden',
      text: '"Die Briefe __sind__ gestern __geschrieben worden__." sein agrees '
          'with the subject.',
    ),
  ],
  items: [
    qsi('Das Haus ist 1990 gebaut ____. (worden)', 'worden',
        'The house was built in 1990.', 'ist gebaut worden'),
    qsi('Die Briefe sind schon geschrieben ____. (worden)', 'worden',
        'The letters have already been written.', 'sind geschrieben worden'),
    qsi('Der Dieb ist gestern gefunden ____. (worden)', 'worden',
        'The thief was found yesterday.', 'ist gefunden worden'),
    qsi('Das Konzert ist leider abgesagt ____. (worden)', 'worden',
        'The concert was unfortunately cancelled.', 'ist abgesagt worden'),
    qsi('Mir ist nichts gesagt ____. (worden)', 'worden',
        'I wasn’t told anything.', 'ist gesagt worden'),
  ],
);

/// 13. Hören: Ein Nachrichtenbeitrag.
final QuizContent questB21HoerenNachrichtenContent = listeningQuestQuiz(
  id: 'quest_b2_1_hoeren_nachrichten',
  title: 'B2.1 · Hören: Nachrichten',
  category: 'Media',
  passageTitle: 'Kurznachrichten',
  passage:
      'Und nun zu den Nachrichten. Die Regierung hat heute ein neues '
      'Klimagesetz vorgestellt. Ab nächstem Jahr sollen die Preise für Benzin '
      'steigen, während der öffentliche Verkehr günstiger werde. Ein Sprecher '
      'erklärte, das Ziel sei, weniger Autos in den Städten zu haben. '
      'Umweltverbände begrüßen den Plan, doch die Wirtschaft warnt vor höheren '
      'Kosten für die Bürger.',
  passageTranslation:
      'And now to the news. The government today presented a new climate law. '
      'From next year petrol prices are to rise, while public transport will '
      'become cheaper. A spokesperson explained that the goal is to have fewer '
      'cars in the cities. Environmental groups welcome the plan, but the '
      'business sector warns of higher costs for citizens.',
  questions: const [
    ReadingQuestion(
      question: 'Was hat die Regierung vorgestellt?',
      questionTranslation: 'What did the government present?',
      options: ['ein neues Klimagesetz', 'einen neuen Bahnhof', 'ein neues Auto'],
      optionsTranslation: ['a new climate law', 'a new station', 'a new car'],
      correctIndex: 0,
      explanation: '"… ein neues Klimagesetz vorgestellt."',
    ),
    ReadingQuestion(
      question: 'Was passiert mit den Benzinpreisen?',
      questionTranslation: 'What happens to petrol prices?',
      options: ['Sie sinken.', 'Sie steigen.', 'Sie bleiben gleich.'],
      optionsTranslation: ['They fall.', 'They rise.', 'They stay the same.'],
      correctIndex: 1,
      explanation: '"… sollen die Preise für Benzin steigen …"',
    ),
    ReadingQuestion(
      question: 'Wer warnt vor höheren Kosten?',
      questionTranslation: 'Who warns of higher costs?',
      options: ['die Umweltverbände', 'die Wirtschaft', 'die Schüler'],
      optionsTranslation: ['the environmental groups', 'the business sector', 'the pupils'],
      correctIndex: 1,
      explanation: '"… doch die Wirtschaft warnt vor höheren Kosten …"',
    ),
  ],
  intro: 'A news bulletin — you only hear it. Reported speech (werde, sei) marks '
      'official claims. Track who supports and who warns. Replay as needed.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Two reactions',
      text: 'Umweltverbände begrüßen (welcome) vs Wirtschaft warnt (warns). Note '
          'each side.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'während = while/whereas',
      text: '"… während der öffentliche Verkehr günstiger werde" contrasts two '
          'changes.',
    ),
  ],
);

/// 14. Sprechen: Ein Argument präsentieren.
final QuizContent questB21SprechenArgumentContent = speakQuestQuiz(
  id: 'quest_b2_1_sprechen_argument',
  title: 'B2.1 · Sprechen: Ein Argument präsentieren',
  promptLabel: 'Satz',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Deutsch',
  intro: 'Structure a short argument: introduce, give examples, conclude. Listen '
      'and repeat these signposting phrases.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Signposting',
      text: 'Erstens … zweitens … (firstly … secondly …); zum Beispiel (for '
          'example); abschließend (finally).',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'Introduce a point',
      text: '"Ich möchte auf einen wichtigen Punkt eingehen." opens a structured '
          'argument.',
    ),
  ],
  phrases: const [
    SpeakPhrase(
        phrase: 'Ich möchte auf einen wichtigen Punkt eingehen.',
        meaning: 'I’d like to address an important point.'),
    SpeakPhrase(
        phrase: 'Erstens spart man Zeit, zweitens spart man Geld.',
        meaning: 'Firstly you save time, secondly you save money.'),
    SpeakPhrase(
        phrase: 'Ein gutes Beispiel dafür ist …',
        meaning: 'A good example of this is …'),
    SpeakPhrase(
        phrase: 'Das zeigt deutlich, dass …',
        meaning: 'This clearly shows that …'),
    SpeakPhrase(
        phrase: 'Abschließend möchte ich betonen, dass …',
        meaning: 'Finally I would like to stress that …'),
    SpeakPhrase(
        phrase: 'Vielen Dank für Ihre Aufmerksamkeit.',
        meaning: 'Thank you for your attention.'),
  ],
);

/// 15. Lesen: Leserbrief an die Redaktion.
final QuizContent questB21LesenLeserbriefContent = readingQuestQuiz(
  id: 'quest_b2_1_lesen_leserbrief',
  title: 'B2.1 · Lesen: Leserbrief',
  category: 'Media',
  passageTitle: 'Leserbrief: Zu wenig Grün in der Stadt',
  passage:
      'Sehr geehrte Redaktion, mit großem Interesse habe ich Ihren Artikel über '
      'die Stadtplanung gelesen. Als langjähriger Bewohner möchte ich jedoch '
      'einen Punkt ergänzen: In unserem Viertel fehlt es eindeutig an '
      'Grünflächen. Wo früher ein Park war, ist ein Parkhaus gebaut worden. '
      'Kinder haben kaum noch Platz zum Spielen. Ich fordere die Stadt deshalb '
      'auf, beim nächsten Projekt mehr an die Bewohner zu denken. Mit '
      'freundlichen Grüßen, K. Schmidt.',
  passageTranslation:
      'Dear Editors, I read your article about urban planning with great '
      'interest. As a long-time resident, however, I would like to add one '
      'point: in our district there is clearly a lack of green spaces. Where '
      'there used to be a park, a multi-storey car park has been built. Children '
      'hardly have any space left to play. I therefore call on the city to think '
      'more about the residents in the next project. Yours sincerely, K. Schmidt.',
  questions: const [
    ReadingQuestion(
      question: 'Worauf reagiert der Leserbrief?',
      questionTranslation: 'What is the letter responding to?',
      options: [
        'auf einen Artikel über Stadtplanung',
        'auf eine Werbung',
        'auf einen anderen Leserbrief'
      ],
      optionsTranslation: [
        'an article about urban planning',
        'an advertisement',
        'another reader’s letter'
      ],
      correctIndex: 0,
      explanation: '"… Ihren Artikel über die Stadtplanung gelesen."',
    ),
    ReadingQuestion(
      question: 'Was kritisiert der Autor?',
      questionTranslation: 'What does the author criticise?',
      options: [
        'zu viele Autos',
        'fehlende Grünflächen',
        'zu hohe Mieten'
      ],
      optionsTranslation: [
        'too many cars',
        'a lack of green spaces',
        'rents that are too high'
      ],
      correctIndex: 1,
      explanation: '"… fehlt es eindeutig an Grünflächen."',
    ),
    ReadingQuestion(
      question: 'Was fordert der Autor von der Stadt?',
      questionTranslation: 'What does the author demand of the city?',
      options: [
        'mehr an die Bewohner zu denken',
        'das Parkhaus abzureißen',
        'die Mieten zu senken'
      ],
      optionsTranslation: [
        'to think more about the residents',
        'to demolish the car park',
        'to lower the rents'
      ],
      correctIndex: 0,
      explanation: '"… mehr an die Bewohner zu denken."',
    ),
  ],
  intro: 'A formal reader’s letter — a B2 text type. It uses the perfect passive '
      '(ist gebaut worden), um…zu, and a polite demand (Ich fordere … auf).',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Letter conventions',
      text: '"Sehr geehrte Redaktion" opens, "Mit freundlichen Grüßen" closes — '
          'the formal register.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'The demand at the end',
      text: 'Leserbriefe usually end with a request/demand ("Ich fordere …"). '
          'That’s the writer’s goal.',
    ),
  ],
);

/// Every B2.1 quiz, in chain order — all five exercise types, interleaved.
final List<QuizContent> questB2_1Content = [
  questB21GesellschaftContent, //       Gesellschaft & Politik  (knowledge)
  questB21Konj1Content, //              Konjunktiv I            (knowledge·verb)
  questB21SprechenVerteidigenContent, // Sprechen: verteidigen  (speaking)
  questB21IndirektContent, //           Indirekte Fragen        (knowledge)
  questB21ModalpassivContent, //        Modalpassiv             (knowledge·verb)
  questB21HoerenDebatteContent, //      Hören: Debatte          (listening)
  questB21VerbenPraepContent, //        Verben + Präposition    (knowledge)
  questB21PartizipAdjContent, //        Partizip als Adjektiv   (knowledge)
  questB21LesenHomeofficeContent, //    Lesen: Homeoffice       (reading)
  questB21KonnektorenContent, //        Konnektoren             (knowledge)
  questB21DiktatContent, //             Diktat: Argumentieren   (dictation)
  questB21PassivPerfektContent, //      Passiv Perfekt          (knowledge·verb)
  questB21HoerenNachrichtenContent, //  Hören: Nachrichten      (listening)
  questB21SprechenArgumentContent, //   Sprechen: Argument      (speaking)
  questB21LesenLeserbriefContent, //    Lesen: Leserbrief       (reading)
];
