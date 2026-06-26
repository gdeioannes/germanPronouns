import '../../../models/quiz_content.dart';
import 'en_de_builder.dart';

/// M16 — The Passive (B2). Vorgangspassiv (werden + participle), all tenses,
/// modals, the sein-passive and alternatives (man, sich lassen). Theme: how
/// things are made.

const List<HelpMemoryTip> _passiveTips = [
  HelpMemoryTip(
    kind: 'rule',
    title: 'werden + participle',
    text: 'Process passive = **werden** (position 2) + past participle at the '
        'end. The doer is unimportant or appears with **von**: Das Brot **wird** '
        '(vom Bäcker) **gebacken**.',
  ),
  HelpMemoryTip(
    kind: 'example',
    title: 'Across the tenses',
    text: 'Präsens: **wird** gebaut · Präteritum: **wurde** gebaut · Perfekt: '
        '**ist** gebaut **worden** · Futur/Modal: **muss** gebaut **werden**.',
  ),
  HelpMemoryTip(
    kind: 'warning',
    title: 'Perfekt uses worden, not geworden',
    text: 'In the passive Perfekt, werden\'s participle is bare **worden**: Der '
        'Brief ist geschrieben **worden** (not geworden).',
  ),
  HelpMemoryTip(
    kind: 'tip',
    title: 'Quick alternatives',
    text: '**man** (Man spricht hier Deutsch), **sein** + participle for a '
        'finished state (Die Tür **ist** geöffnet), **sich lassen** (Das '
        '**lässt sich** machen).',
  ),
];

final QuizContent enDeM16Present = enDeFill(
  id: 'en_de_m16_present',
  title: 'werden + participle (present)',
  intro: 'Form the process passive in the present: conjugate werden, put the '
      'participle at the end.',
  tips: _passiveTips,
  items: const [
    CourseItem(prompt: 'The bread is baked. (werden)', answer: 'Das Brot **wird** gebacken'),
    CourseItem(prompt: 'The houses are built. (werden)', answer: 'Die Häuser **werden** gebaut'),
    CourseItem(prompt: 'The letter is written. (werden)', answer: 'Der Brief **wird** geschrieben'),
    CourseItem(prompt: 'The room is cleaned. (werden)', answer: 'Das Zimmer **wird** geputzt'),
    CourseItem(prompt: 'The books are read. (werden)', answer: 'Die Bücher **werden** gelesen'),
    CourseItem(prompt: 'The door is opened. (werden)', answer: 'Die Tür **wird** geöffnet'),
  ],
);

final QuizContent enDeM16Tenses = enDeFill(
  id: 'en_de_m16_tenses',
  title: 'Passive in all tenses',
  intro: 'The tense lives in werden: wird (present), wurde (past), ist … worden '
      '(perfect), wird … werden (future).',
  tips: _passiveTips,
  items: const [
    CourseItem(prompt: 'The bread was baked. (Präteritum)', answer: 'Das Brot **wurde** gebacken'),
    CourseItem(prompt: 'The house was built. (Präteritum)', answer: 'Das Haus **wurde** gebaut'),
    CourseItem(prompt: 'The letter has been written. (Perfekt: ist … worden)', answer: 'Der Brief ist geschrieben **worden**'),
    CourseItem(prompt: 'The room will be cleaned. (Futur: wird … werden)', answer: 'Das Zimmer wird geputzt **werden**'),
    CourseItem(prompt: 'The car was repaired. (Präteritum)', answer: 'Das Auto **wurde** repariert'),
  ],
);

// 16.2a — warm-up big text (after the present + tenses quizzes): type the form
// of werden that carries the passive — wird/werden (present) or wurde (past).
final QuizContent enDeM16BigTextWarmup = enDeBigText(
  id: 'en_de_m16_bigtext_warmup',
  title: 'Big text (warm-up): Ein Tag im Büro',
  passageTitle: 'Ein Tag im Büro',
  template:
      'In unserem kleinen Büro {{0}} jeden Morgen zuerst die Fenster geöffnet. '
      'Der Kaffee {{1}} natürlich sofort gekocht, sonst geht hier gar nichts. '
      'Dann {{2}} die vielen E-Mails der Reihe nach beantwortet. Gestern {{3}} '
      'sogar ein wichtiger Vertrag unterschrieben — was für ein guter Tag! Heute '
      '{{4}} endlich der alte Drucker repariert, der schon ewig kaputt ist. Und '
      'am Freitag {{5}} bei uns traditionell zusammen Pizza bestellt. So {{6}} '
      'bei uns gearbeitet: entspannt, aber erstaunlich effektiv.',
  blanks: [
    inputBlank('werden', hint: 'werden: die Fenster … (Präsens)'),
    inputBlank('wird', hint: 'werden: der Kaffee … (Präsens)'),
    inputBlank('werden', hint: 'werden: die E-Mails … (Präsens)'),
    inputBlank('wurde', hint: 'werden → Präteritum (ein Vertrag …)'),
    inputBlank('wird', hint: 'werden: der Drucker … (Präsens)'),
    inputBlank('wird', hint: 'werden: Pizza … (Präsens)'),
    inputBlank('wird', hint: 'werden: so … (Präsens)'),
  ],
  passageTranslation:
      'In our little office, every morning the windows are opened first. The '
      'coffee is of course made immediately, otherwise nothing happens here at '
      'all. Then the many emails are answered one by one. Yesterday an important '
      'contract was even signed — what a good day! Today the old printer, which '
      'has been broken forever, is finally being repaired. And on Fridays we '
      "traditionally order pizza together. That's how we work here: relaxed, but "
      'surprisingly effective.',
  intro: 'Type the form of werden that carries the passive: wird (singular), '
      'werden (plural), or wurde (past). The participle already sits at the end '
      'of each sentence.',
  tips: _passiveTips,
);

final QuizContent enDeM16Modals = enDeFill(
  id: 'en_de_m16_modals',
  title: 'Passive with modals',
  intro: 'With a modal, the structure is modal + participle + werden (infinitive '
      'at the end).',
  tips: _passiveTips,
  items: const [
    CourseItem(prompt: 'The car must be repaired. (… werden)', answer: 'Das Auto muss repariert **werden**'),
    CourseItem(prompt: 'The work can be done. (… werden)', answer: 'Die Arbeit kann gemacht **werden**'),
    CourseItem(prompt: 'The window should be opened. (… werden)', answer: 'Das Fenster soll geöffnet **werden**'),
    CourseItem(prompt: 'The homework must be done. (… werden)', answer: 'Die Hausaufgaben müssen gemacht **werden**'),
  ],
);

final QuizContent enDeM16Alternatives = enDeFill(
  id: 'en_de_m16_alternatives',
  title: 'sein-passive & alternatives',
  intro: 'A finished state uses sein + participle (Zustandspassiv). Common '
      'alternatives are man and sich lassen.',
  tips: _passiveTips,
  items: const [
    CourseItem(prompt: 'The door is open (state). (ist …)', answer: 'Die Tür ist **geöffnet**'),
    CourseItem(prompt: 'One speaks German here. (man)', answer: '**Man** spricht hier Deutsch'),
    CourseItem(prompt: 'The shop is closed (state). (ist …)', answer: 'Das Geschäft ist **geschlossen**'),
    CourseItem(prompt: 'That can be done. (sich lassen)', answer: 'Das **lässt** sich machen'),
    CourseItem(prompt: 'German is spoken here. (man)', answer: 'Hier spricht **man** Deutsch'),
  ],
);

// 16.5 — big text with TYPED inputs: produce the past participle in a process
// description (the whole passage is in the passive).
final QuizContent enDeM16BigText = enDeBigText(
  id: 'en_de_m16_bigtext',
  title: 'Big text: Wie wird Brot gemacht?',
  passageTitle: 'Wie wird Brot gemacht?',
  template:
      'Hast du dich schon einmal gefragt, wie eigentlich dein Brot gemacht '
      'wird? Es ist überraschend viel Arbeit! Zuerst wird das Mehl sorgfältig '
      'mit Wasser, Salz und Hefe {{0}}. Dann wird der weiche Teig mindestens '
      'zehn Minuten lang kräftig {{1}}, bis er schön elastisch ist. Danach wird '
      'er abgedeckt und für eine Stunde an einen warmen Ort {{2}}. In dieser '
      'Zeit geht der Teig langsam auf. Anschließend wird er in den heißen Ofen '
      '{{3}} und bei 220 Grad etwa vierzig Minuten lang goldbraun {{4}}. Ganz '
      'am Ende wird das duftende Brot aus dem Ofen {{5}}, kurz abgekühlt und am '
      'liebsten mit Butter {{6}}. Guten Appetit!',
  blanks: [
    inputBlank('gemischt', hint: 'mischen → Partizip II'),
    inputBlank('geknetet', hint: 'kneten → Partizip II'),
    inputBlank('gestellt', hint: 'stellen → Partizip II'),
    inputBlank('geschoben', hint: 'schieben → Partizip II'),
    inputBlank('gebacken', hint: 'backen → Partizip II'),
    inputBlank('genommen', hint: 'nehmen → Partizip II'),
    inputBlank('gegessen', hint: 'essen → Partizip II'),
  ],
  passageTranslation:
      'Have you ever wondered how your bread is actually made? It is '
      'surprisingly a lot of work! First the flour is carefully mixed with '
      'water, salt and yeast. Then the soft dough is kneaded firmly for at '
      "least ten minutes, until it is nice and elastic. After that it is "
      'covered and placed in a warm spot for an hour. During this time the '
      'dough slowly rises. Then it is pushed into the hot oven and baked golden '
      'brown at 220 degrees for about forty minutes. Right at the end the '
      'fragrant bread is taken out of the oven, cooled briefly, and best of all '
      'eaten with butter. Enjoy!',
  intro: 'The whole text is in the passive (wird … + participle). Type the past '
      'participle of each verb (the infinitive is the hint).',
  tips: _passiveTips,
);

final QuizContent enDeM16Listening = enDeListen(
  id: 'en_de_m16_listening',
  title: 'Listening: a process',
  passageTitle: 'So wird Kaffee gemacht',
  passage:
      'So wird Kaffee gemacht: Zuerst werden die Bohnen gemahlen. Dann wird '
      'heißes Wasser dazugegeben. Nach drei Minuten wird der Kaffee serviert.',
  passageTranslation:
      'This is how coffee is made: First the beans are ground. Then hot water '
      'is added. After three minutes the coffee is served.',
  intro: 'Listen to the process, all in the passive, and answer. Follow the '
      'steps: zuerst, dann, nach drei Minuten.',
  tips: _passiveTips,
  questions: const [
    ReadingQuestion(
      question: 'Was wird zuerst gemacht?',
      options: [
        'Die Bohnen werden gemahlen.',
        'Wasser wird gekocht.',
        'Der Kaffee wird serviert.',
      ],
      correctIndex: 0,
      questionTranslation: 'What is done first?',
    ),
    ReadingQuestion(
      question: 'Was wird dann dazugegeben?',
      options: ['Heißes Wasser', 'Milch', 'Zucker'],
      correctIndex: 0,
      questionTranslation: 'What is added then?',
    ),
    ReadingQuestion(
      question: 'Wann wird der Kaffee serviert?',
      options: ['Nach drei Minuten', 'Nach einer Stunde', 'Sofort'],
      correctIndex: 0,
      questionTranslation: 'When is the coffee served?',
    ),
  ],
);

final QuizContent enDeM16Dictation = enDeDict(
  id: 'en_de_m16_dictation',
  title: 'Dictation: passive sentences',
  intro: 'Listen and write each passive sentence. Mind the Perfekt: "ist … '
      'worden", not "geworden".',
  tips: _passiveTips,
  items: const [
    CourseItem(prompt: 'The bread is baked.', answer: 'Das Brot wird gebacken.'),
    CourseItem(prompt: 'The house was built.', answer: 'Das Haus wurde gebaut.'),
    CourseItem(prompt: 'The car must be repaired.', answer: 'Das Auto muss repariert werden.'),
    CourseItem(prompt: 'The letter has been written.', answer: 'Der Brief ist geschrieben worden.'),
    CourseItem(prompt: 'German is spoken here.', answer: 'Hier wird Deutsch gesprochen.'),
  ],
);

/// M16 — The Passive, in module order.
final List<QuizContent> enDeM16 = [
  enDeM16Present,
  enDeM16Tenses,
  enDeM16BigTextWarmup,
  enDeM16Modals,
  enDeM16Alternatives,
  enDeM16Listening,
  enDeM16Dictation,
  enDeM16BigText,
];
