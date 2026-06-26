import '../../../models/quiz_content.dart';
import 'en_de_builder.dart';

/// M17 — Indirect Speech & Participles (B2). Konjunktiv I for reported speech,
/// Partizip I/II as adjectives, and advanced connectors. Theme: the news.

const List<HelpMemoryTip> _indirectTips = [
  HelpMemoryTip(
    kind: 'rule',
    title: 'Konjunktiv I for reporting',
    text: 'Formal/written reporting uses Konjunktiv I (er-form): er **sei**, er '
        '**habe**, er **gehe**, er **könne**. If it looks like the present, '
        'switch to Konjunktiv II (**würde** + infinitive).',
  ),
  HelpMemoryTip(
    kind: 'example',
    title: 'Direct → indirect',
    text: '„Ich **bin** krank." → Er sagt, er **sei** krank. · „Ich **habe** '
        'keine Zeit." → Sie sagt, sie **habe** keine Zeit.',
  ),
  HelpMemoryTip(
    kind: 'warning',
    title: 'Partizip I vs II',
    text: '**Partizip I** (-end) = active/ongoing: das schlaf**ende** Kind. '
        '**Partizip II** = passive/finished: das gekoch**te** Essen. Both take '
        'normal adjective endings.',
  ),
  HelpMemoryTip(
    kind: 'tip',
    title: 'Advanced connectors',
    text: '**deshalb/darum** (therefore) + inversion · **trotzdem** '
        '(nevertheless) + inversion · **obwohl** (although) sends the verb to '
        'the end.',
  ),
];

final QuizContent enDeM17KonjunktivI = enDeFill(
  id: 'en_de_m17_konjunktiv_i',
  title: 'Konjunktiv I forms',
  intro: 'The er-forms of Konjunktiv I — the ones you actually use in reported '
      'speech.',
  tips: _indirectTips,
  items: const [
    CourseItem(prompt: 'sein → er …', answer: 'sei'),
    CourseItem(prompt: 'haben → er …', answer: 'habe'),
    CourseItem(prompt: 'gehen → er …', answer: 'gehe'),
    CourseItem(prompt: 'können → er …', answer: 'könne'),
    CourseItem(prompt: 'kommen → er …', answer: 'komme'),
    CourseItem(prompt: 'wissen → er …', answer: 'wisse'),
    CourseItem(prompt: 'werden → er …', answer: 'werde'),
    CourseItem(prompt: 'müssen → er …', answer: 'müsse'),
  ],
);

final QuizContent enDeM17Reported = enDeFill(
  id: 'en_de_m17_reported',
  title: 'Reported speech',
  intro: 'Turn direct speech into reported speech with Konjunktiv I (or '
      'Konjunktiv II where KI is ambiguous).',
  tips: _indirectTips,
  items: const [
    CourseItem(prompt: 'He says he is sick. (sei)', answer: 'Er sagt, er **sei** krank'),
    CourseItem(prompt: 'She says she has no time. (habe)', answer: 'Sie sagt, sie **habe** keine Zeit'),
    CourseItem(prompt: 'He claims he knows it. (wisse)', answer: 'Er behauptet, er **wisse** es'),
    CourseItem(prompt: 'They say they would come. (würden)', answer: 'Sie sagen, sie **würden** kommen'),
    CourseItem(prompt: 'He says he can help. (könne)', answer: 'Er sagt, er **könne** helfen'),
  ],
);

// 17.2a — warm-up big text (after the Konjunktiv I + reported quizzes): type the
// Konjunktiv I er-form used in reported speech.
final QuizContent enDeM17BigTextWarmup = enDeBigText(
  id: 'en_de_m17_bigtext_warmup',
  title: 'Big text (warm-up): Der neue Kollege',
  passageTitle: 'Der neue Kollege',
  template:
      'Hast du schon den Neuen im Büro gesehen? Über ihn wird gerade unglaublich '
      'viel geredet! Anna sagt, er {{0}} wahnsinnig nett. Tom meint, er {{1}} aus '
      'München und kenne dort jeden. Die Chefin behauptet, er {{2}} schon drei '
      'Sprachen fließend. Lisa flüstert, er {{3}} heimlich in jemanden verliebt. '
      'Und Max ist sich ganz sicher, er {{4}} schon bald befördert werden. '
      'Ehrlich gesagt weiß niemand etwas Genaues — aber geredet wird trotzdem '
      'ununterbrochen!',
  blanks: [
    inputBlank('sei', hint: 'sein → Konjunktiv I (er)'),
    inputBlank('komme', hint: 'kommen → Konjunktiv I (er)'),
    inputBlank('habe', hint: 'haben → Konjunktiv I (er)'),
    inputBlank('sei', hint: 'sein → Konjunktiv I (er)'),
    inputBlank('könne', accepted: ['koenne'], hint: 'können → Konjunktiv I (er)'),
  ],
  passageTranslation:
      'Have you seen the new guy at the office yet? People are talking about him '
      'an incredible amount right now! Anna says he is incredibly nice. Tom '
      'thinks he comes from Munich and knows everyone there. The boss claims he '
      'already speaks three languages fluently. Lisa whispers that he is secretly '
      'in love with someone. And Max is absolutely sure that he will soon be '
      'promoted. Honestly, nobody knows anything for certain — but the talking '
      'goes on non-stop anyway!',
  intro: 'Type the Konjunktiv I er-form used in reported speech: sein → sei, '
      'haben → habe, kommen → komme, können → könne.',
  tips: _indirectTips,
);

final QuizContent enDeM17Participles = enDeFill(
  id: 'en_de_m17_participles',
  title: 'Participles as adjectives',
  intro: 'Partizip I (-end, ongoing) and Partizip II (finished) can describe a '
      'noun — and then they take normal adjective endings.',
  tips: _indirectTips,
  items: const [
    CourseItem(prompt: 'the sleeping child (Partizip I: schlafend)', answer: 'das **schlafende** Kind'),
    CourseItem(prompt: 'the crying baby (weinend)', answer: 'das **weinende** Baby'),
    CourseItem(prompt: 'the broken window (Partizip II: zerbrochen)', answer: 'das **zerbrochene** Fenster'),
    CourseItem(prompt: 'the cooked meal (gekocht)', answer: 'das **gekochte** Essen'),
    CourseItem(prompt: 'the laughing children (lachend)', answer: 'die **lachenden** Kinder'),
  ],
);

final QuizContent enDeM17Connectors = enDeFill(
  id: 'en_de_m17_connectors',
  title: 'Advanced connectors',
  intro: 'deshalb and trotzdem trigger inversion (verb before subject); obwohl '
      'sends the verb to the end of its clause.',
  tips: _indirectTips,
  items: const [
    CourseItem(prompt: 'It rained, therefore we stayed home. (deshalb)', answer: 'Es regnete, **deshalb** blieben wir zu Hause'),
    CourseItem(prompt: 'It rained; nevertheless we went out. (trotzdem)', answer: 'Es regnete, **trotzdem** gingen wir raus'),
    CourseItem(prompt: 'Although it rained, we went out. (obwohl)', answer: '**Obwohl** es regnete, gingen wir raus'),
    CourseItem(prompt: 'He is rich; nevertheless he is unhappy. (trotzdem)', answer: 'Er ist reich, **trotzdem** ist er unglücklich'),
    CourseItem(prompt: 'Although she is tired, she works. (obwohl)', answer: '**Obwohl** sie müde ist, arbeitet sie'),
  ],
);

final QuizContent enDeM17Reading = enDeRead(
  id: 'en_de_m17_reading',
  title: 'Reading: In den Nachrichten',
  passageTitle: 'In den Nachrichten',
  passage:
      'In den Nachrichten: Der Minister sagte, die Wirtschaft sei stark und es '
      'gebe viele neue Jobs. Experten meinen jedoch, dass die Preise weiter '
      'steigen würden. Die Regierung habe einen neuen Plan, sagte der Sprecher. '
      'Viele Bürger sind allerdings skeptisch.',
  passageTranslation:
      'In the news: The minister said the economy is strong and there are many '
      'new jobs. Experts, however, think that prices will keep rising. The '
      'government has a new plan, the spokesman said. Many citizens, however, '
      'are sceptical.',
  intro: 'Read the news report, written in indirect speech (sei, gebe, habe), '
      'and answer.',
  tips: _indirectTips,
  questions: const [
    ReadingQuestion(
      question: 'Was sagte der Minister über die Wirtschaft?',
      options: ['Sie sei stark.', 'Sie sei schwach.', 'Sie sei kaputt.'],
      correctIndex: 0,
      questionTranslation: 'What did the minister say about the economy?',
    ),
    ReadingQuestion(
      question: 'Was meinen die Experten?',
      options: [
        'Die Preise würden steigen.',
        'Die Preise würden fallen.',
        'Alles sei gut.',
      ],
      correctIndex: 0,
      questionTranslation: 'What do the experts think?',
    ),
    ReadingQuestion(
      question: 'Wie sind viele Bürger?',
      options: ['Skeptisch', 'Glücklich', 'Reich'],
      correctIndex: 0,
      questionTranslation: 'How do many citizens feel?',
    ),
  ],
);

final QuizContent enDeM17Listening = enDeListen(
  id: 'en_de_m17_listening',
  title: 'Listening: news in indirect speech',
  passageTitle: 'Polizeibericht',
  passage:
      'Die Polizei sagte, der Dieb sei am Morgen gefasst worden. Er habe das '
      'Geld zurückgegeben. Der Richter werde nächste Woche entscheiden.',
  passageTranslation:
      'The police said the thief had been caught in the morning. He had '
      'returned the money. The judge will decide next week.',
  intro: 'Listen to the police report in indirect speech (sei, habe, werde) and '
      'answer.',
  tips: _indirectTips,
  questions: const [
    ReadingQuestion(
      question: 'Wann sei der Dieb gefasst worden?',
      options: ['Am Morgen', 'Am Abend', 'In der Nacht'],
      correctIndex: 0,
      questionTranslation: 'When was the thief caught?',
    ),
    ReadingQuestion(
      question: 'Was habe der Dieb gemacht?',
      options: [
        'Das Geld zurückgegeben',
        'Das Geld behalten',
        'Nichts gesagt',
      ],
      correctIndex: 0,
      questionTranslation: 'What had the thief done?',
    ),
    ReadingQuestion(
      question: 'Wann werde der Richter entscheiden?',
      options: ['Nächste Woche', 'Heute', 'Nie'],
      correctIndex: 0,
      questionTranslation: 'When will the judge decide?',
    ),
  ],
);

final QuizContent enDeM17Speak = enDeSpeak(
  id: 'en_de_m17_speak',
  title: 'Speak: report what was said',
  intro: 'Report each statement aloud in Konjunktiv I — the register of news '
      'and formal writing.',
  tips: _indirectTips,
  items: const [
    CourseItem(prompt: 'He says he is sick.', answer: 'Er sagt, er sei krank.'),
    CourseItem(prompt: 'She says she has no time.', answer: 'Sie sagt, sie habe keine Zeit.'),
    CourseItem(prompt: 'They say they would come tomorrow.', answer: 'Sie sagen, sie würden morgen kommen.'),
    CourseItem(prompt: 'He claims he knows nothing.', answer: 'Er behauptet, er wisse nichts.'),
    CourseItem(prompt: 'The minister said the economy is strong.', answer: 'Der Minister sagte, die Wirtschaft sei stark.'),
  ],
);

// 17.8 — mastery big text (module + course capstone): reported speech
// (Konjunktiv I), participles as adjectives, and the advanced connectors, woven
// into one dramatic news story.
final QuizContent enDeM17BigText = enDeBigText(
  id: 'en_de_m17_bigtext',
  title: 'Big text: Held des Tages',
  passageTitle: 'Held des Tages',
  template:
      'Gestern Abend in den Nachrichten: Ein mutiger Feuerwehrmann hat eine '
      'Familie aus einem {{0}} Haus gerettet. Die Reporterin berichtete, der '
      'Mann {{1}} sofort ins Gebäude gelaufen und {{2}} dabei keine einzige '
      'Sekunde gezögert. {{3}} das Feuer schon riesig war, lief er ohne Angst '
      'hinein. Drinnen fand er zwei laut {{4}} Kinder und trug sie nach draußen. '
      'Die {{5}} Familie weinte vor Erleichterung. Später sagte der Held ganz '
      'bescheiden, er {{6}} doch nur seine Pflicht getan. Die Flammen waren '
      'wirklich gefährlich, {{7}} blieb er die ganze Zeit ruhig. Der '
      'Bürgermeister erklärte, der Feuerwehrmann {{8}} bald eine Medaille '
      'bekommen. Der Einsatz war lebensgefährlich, {{9}} ist der Mann heute in '
      'der ganzen Stadt berühmt. Und die Mutter? Sie sah ihn mit einem {{10}} '
      'Lächeln an und bedankte sich tausendmal.',
  blanks: [
    inputBlank('brennenden', hint: 'brennend (aus einem … Haus, Dat n)'),
    inputBlank('sei', hint: 'sein → Konjunktiv I (er)'),
    inputBlank('habe', hint: 'haben → Konjunktiv I (er)'),
    inputBlank('Obwohl', hint: 'although (Verb ans Ende)'),
    inputBlank('weinende', hint: 'weinend (zwei … Kinder, Akk pl)'),
    inputBlank('gerettete', hint: 'gerettet (die … Familie, Nom f)'),
    inputBlank('habe', hint: 'haben → Konjunktiv I (er)'),
    inputBlank('trotzdem', hint: 'nevertheless (+ Inversion)'),
    inputBlank('werde', hint: 'werden → Konjunktiv I (er)'),
    inputBlank('deshalb', hint: 'therefore (+ Inversion)'),
    inputBlank('strahlenden', hint: 'strahlend (mit einem … Lächeln, Dat n)'),
  ],
  passageTranslation:
      'On the news last night: a brave firefighter rescued a family from a '
      'burning house. The reporter said the man had run into the building '
      'immediately and had not hesitated for a single second. Although the fire '
      'was already huge, he ran in without fear. Inside he found two loudly '
      'crying children and carried them outside. The rescued family wept with '
      'relief. Afterwards the hero said quite modestly that he had only done his '
      'duty. The flames were really dangerous; nevertheless he stayed calm the '
      'whole time. The mayor announced that the firefighter would soon receive a '
      'medal. The operation was life-threatening, so the man is famous '
      'throughout the city today. And the mother? She looked at him with a '
      'beaming smile and thanked him a thousand times.',
  intro: 'The grand finale: reported speech in Konjunktiv I (sei, habe, werde), '
      'participles as adjectives (brennend → brennenden, gerettet → gerettete), '
      'and the connectors obwohl / trotzdem / deshalb — all in one news story.',
  tips: _indirectTips,
);

/// M17 — Indirect Speech & Participles, in module order.
final List<QuizContent> enDeM17 = [
  enDeM17KonjunktivI,
  enDeM17Reported,
  enDeM17BigTextWarmup,
  enDeM17Participles,
  enDeM17Connectors,
  enDeM17Reading,
  enDeM17Listening,
  enDeM17Speak,
  enDeM17BigText,
];
