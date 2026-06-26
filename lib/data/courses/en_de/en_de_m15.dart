import '../../../models/quiz_content.dart';
import 'en_de_builder.dart';

/// M15 — Konjunktiv II & Reflexive Verbs (B1). The polite/hypothetical mood
/// (würde, wäre, hätte, könnte) and reflexive verbs (mich vs mir).

const List<HelpMemoryTip> _konjunktivTips = [
  HelpMemoryTip(
    kind: 'rule',
    title: 'würde + infinitive',
    text: 'Most verbs: **würde** + infinitive — Ich **würde** gern kommen. '
        'sein/haben/modals have their own forms: **wäre, hätte, könnte, müsste, '
        'dürfte**.',
  ),
  HelpMemoryTip(
    kind: 'example',
    title: 'Instantly polite',
    text: '**Könnten** Sie mir helfen? · Ich **hätte** gern einen Kaffee. · Das '
        '**wäre** nett. · Ich **möchte** zahlen.',
  ),
  HelpMemoryTip(
    kind: 'warning',
    title: 'Reflexive: mich vs mir',
    text: 'Accusative reflexive normally (Ich freue **mich**); switch to dative '
        'when there is already a direct object (Ich wasche **mir** **die '
        'Hände**).',
  ),
  HelpMemoryTip(
    kind: 'tip',
    title: 'möchte = polite mögen',
    text: '**möchte** ("would like") is simply the Konjunktiv II of mögen — the '
        'everyday polite form.',
  ),
];

final QuizContent enDeM15Forms = enDeFill(
  id: 'en_de_m15_forms',
  title: 'würde / wäre / hätte / könnte',
  intro: 'Learn the core Konjunktiv II forms. These four cover most polite and '
      'hypothetical sentences.',
  tips: _konjunktivTips,
  items: const [
    CourseItem(prompt: 'I would (würde)', answer: 'ich **würde**'),
    CourseItem(prompt: 'I would be (wäre)', answer: 'ich **wäre**'),
    CourseItem(prompt: 'I would have (hätte)', answer: 'ich **hätte**'),
    CourseItem(prompt: 'I could (könnte)', answer: 'ich **könnte**'),
    CourseItem(prompt: 'you would be (du)', answer: 'du **wärst**'),
    CourseItem(prompt: 'we could (wir)', answer: 'wir **könnten**'),
    CourseItem(prompt: 'he would have (er)', answer: 'er **hätte**'),
    CourseItem(prompt: 'I would like (möchte)', answer: 'ich **möchte**'),
  ],
);

final QuizContent enDeM15Wuerde = enDeFill(
  id: 'en_de_m15_wuerde',
  title: 'würde + infinitive',
  intro: 'For ordinary verbs, use würde + the infinitive (which goes to the '
      'end).',
  tips: _konjunktivTips,
  items: const [
    CourseItem(prompt: 'I would help you. (würde)', answer: 'Ich **würde** dir helfen'),
    CourseItem(prompt: 'Would you come? (du)', answer: '**Würdest** du kommen?'),
    CourseItem(prompt: 'She would buy a car.', answer: 'Sie **würde** ein Auto kaufen'),
    CourseItem(prompt: 'We would travel to Italy.', answer: 'Wir **würden** nach Italien reisen'),
    CourseItem(prompt: 'They would stay home.', answer: 'Sie **würden** zu Hause bleiben'),
  ],
);

// 15.2a — warm-up big text (after the form + würde quizzes): type the
// Konjunktiv II. würde + infinitive for most verbs; wäre/hätte/könnte/müsste
// for sein/haben/modals.
final QuizContent enDeM15BigTextWarmup = enDeBigText(
  id: 'en_de_m15_bigtext_warmup',
  title: 'Big text (warm-up): Wenn ich reich wäre',
  passageTitle: 'Wenn ich reich wäre',
  template:
      'Stell dir nur einmal vor, ich {{0}} im Lotto gewinnen — was für ein Traum! '
      'Dann {{1}} ich endlich frei und müsste nie wieder zur Arbeit hetzen. Ich '
      '{{2}} ein kleines Haus am Meer, mit einem großen Pool und einem faulen '
      'Hund. Morgens {{3}} ich gern stundenlang schlafen, und nachmittags {{4}} '
      'ich um die ganze Welt reisen. „Das {{5}} doch das perfekte Leben!", sage '
      'ich mir oft. Aber zuerst {{6}} ich natürlich einen Lottoschein kaufen — '
      'und genau das vergesse ich jede einzelne Woche.',
  blanks: [
    inputBlank('würde', hint: 'würde + Infinitiv (ich)'),
    inputBlank('wäre', accepted: ['waere'], hint: 'sein → Konjunktiv II (ich)'),
    inputBlank('hätte', accepted: ['haette'], hint: 'haben → Konjunktiv II (ich)'),
    inputBlank('würde', hint: 'würde + Infinitiv (ich)'),
    inputBlank('könnte', accepted: ['koennte'], hint: 'können → Konjunktiv II (ich)'),
    inputBlank('wäre', accepted: ['waere'], hint: 'sein → Konjunktiv II (das)'),
    inputBlank('müsste', accepted: ['muesste'], hint: 'müssen → Konjunktiv II (ich)'),
  ],
  passageTranslation:
      'Just imagine for a moment that I won the lottery — what a dream! Then I '
      'would finally be free and would never have to rush to work again. I would '
      'have a little house by the sea, with a big pool and a lazy dog. In the '
      'mornings I would love to sleep for hours, and in the afternoons I could '
      'travel all around the world. "That really would be the perfect life!" I '
      'often tell myself. But first, of course, I would have to buy a lottery '
      'ticket — and that is exactly what I forget every single week.',
  intro: 'Type the Konjunktiv II form. Most verbs use würde + infinitive; '
      'sein/haben/modals have their own forms: wäre, hätte, könnte, müsste.',
  tips: _konjunktivTips,
);

final QuizContent enDeM15Polite = enDeFill(
  id: 'en_de_m15_polite',
  title: 'Polite requests & wishes',
  intro: 'Konjunktiv II makes requests and wishes polite. These are the phrases '
      'you use in a shop, a café or an office.',
  tips: _konjunktivTips,
  items: const [
    CourseItem(prompt: 'Could you help me? (können)', answer: '**Könnten** Sie mir helfen?'),
    CourseItem(prompt: 'I would like a coffee. (möchte)', answer: 'Ich **möchte** einen Kaffee'),
    CourseItem(prompt: 'I wish I had more time. (hätte)', answer: 'Ich wünschte, ich **hätte** mehr Zeit'),
    CourseItem(prompt: 'That would be nice. (wäre)', answer: 'Das **wäre** schön'),
    CourseItem(prompt: 'Would you have a minute? (hätte)', answer: '**Hätten** Sie eine Minute?'),
  ],
);

final QuizContent enDeM15Reflexive = enDeFill(
  id: 'en_de_m15_reflexive',
  title: 'Reflexive verbs (mich vs mir)',
  intro: 'Reflexive verbs point the action back at the subject. Use the '
      'accusative reflexive — switch to dative only when a direct object is '
      'already there.',
  tips: _konjunktivTips,
  items: const [
    CourseItem(prompt: "I'm happy. (sich freuen)", answer: 'Ich freue **mich**'),
    CourseItem(prompt: 'I wash (myself). (sich waschen)', answer: 'Ich wasche **mich**'),
    CourseItem(prompt: 'I wash my hands. (… die Hände)', answer: 'Ich wasche **mir** die Hände'),
    CourseItem(prompt: 'She remembers. (sich erinnern)', answer: 'Sie erinnert **sich**'),
    CourseItem(prompt: 'We meet (each other). (sich treffen)', answer: 'Wir treffen **uns**'),
    CourseItem(prompt: 'Imagine that! (sich vorstellen + Dat)', answer: 'Stell **dir** das vor!'),
  ],
);

final QuizContent enDeM15Speak = enDeSpeak(
  id: 'en_de_m15_speak',
  title: 'Speak: wishes & politeness',
  intro: 'Say these polite lines aloud — they instantly make your German '
      'sound friendlier.',
  tips: _konjunktivTips,
  items: const [
    CourseItem(prompt: 'Could you help me, please?', answer: 'Könnten Sie mir bitte helfen?'),
    CourseItem(prompt: 'I would like to pay.', answer: 'Ich möchte gern zahlen.'),
    CourseItem(prompt: 'Could I have the menu?', answer: 'Könnte ich die Karte haben?'),
    CourseItem(prompt: 'That would be very kind.', answer: 'Das wäre sehr nett.'),
    CourseItem(prompt: 'I wish I had more time.', answer: 'Ich wünschte, ich hätte mehr Zeit.'),
  ],
);

final QuizContent enDeM15Dictation = enDeDict(
  id: 'en_de_m15_dictation',
  title: 'Dictation: the umlaut forms',
  intro: 'Listen and write. The Konjunktiv II forms carry an umlaut you must '
      'hear: wäre, hätte, könnte, würde.',
  tips: _konjunktivTips,
  items: const [
    CourseItem(prompt: 'I would be happy.', answer: 'Ich wäre glücklich.'),
    CourseItem(prompt: 'I would have time.', answer: 'Ich hätte Zeit.'),
    CourseItem(prompt: 'Could you help me?', answer: 'Könnten Sie mir helfen?'),
    CourseItem(prompt: 'That would be nice.', answer: 'Das wäre schön.'),
    CourseItem(prompt: 'We would come.', answer: 'Wir würden kommen.'),
  ],
);

// 15.6 — mastery big text (module capstone): reflexive verbs (mich/mir/uns) for
// getting ready, then Konjunktiv II (würde/wäre/hätte/könnten) for the polite
// requests of the evening.
final QuizContent enDeM15BigText = enDeBigText(
  id: 'en_de_m15_bigtext',
  title: 'Big text: Ein besonderer Abend',
  passageTitle: 'Ein besonderer Abend',
  template:
      'Heute Abend habe ich ein wichtiges Date! Zuerst dusche ich {{0}}, dann '
      'wasche ich {{1}} schnell die Haare und ziehe {{2}} mein bestes Hemd an. '
      'Ich freue {{3}} riesig. Im Restaurant bin ich besonders höflich: '
      '„{{4}} Sie mir bitte die Karte geben?" Ich {{5}} gern einen ruhigen Tisch '
      'am Fenster. „Natürlich, das {{6}} überhaupt kein Problem", sagt der '
      'Kellner freundlich. Meine Begleitung lächelt und fragt: „{{7}} du mir '
      'einen guten Wein empfehlen?" Wir unterhalten {{8}} stundenlang und lachen '
      'viel. Am Ende denke ich: Ohne ein bisschen Mut {{9}} dieser schöne Abend '
      'nie passiert. Ich {{10}} mich gern öfter so trauen!',
  blanks: [
    inputBlank('mich', hint: 'sich duschen → ich dusche …'),
    inputBlank('mir', hint: 'sich die Haare waschen → ich wasche …'),
    inputBlank('mir', hint: 'sich das Hemd anziehen → ich ziehe …'),
    inputBlank('mich', hint: 'sich freuen → ich freue …'),
    inputBlank('Könnten', accepted: ['koennten'], hint: 'können → Konjunktiv II (Sie)'),
    inputBlank('hätte', accepted: ['haette'], hint: 'haben → Konjunktiv II (ich)'),
    inputBlank('wäre', accepted: ['waere'], hint: 'sein → Konjunktiv II (das)'),
    inputBlank('Würdest', hint: 'würde + Infinitiv (du)'),
    inputBlank('uns', hint: 'sich unterhalten → wir unterhalten …'),
    inputBlank('wäre', accepted: ['waere'], hint: 'sein → Konjunktiv II (… passiert)'),
    inputBlank('würde', hint: 'würde + Infinitiv (ich)'),
  ],
  passageTranslation:
      "Tonight I have an important date! First I shower, then I quickly wash my "
      'hair and put on my best shirt. I am really excited. At the restaurant I '
      'am especially polite: "Could you give me the menu, please?" I would like '
      'a quiet table by the window. "Of course, that is no problem at all," says '
      'the waiter kindly. My companion smiles and asks: "Would you recommend me '
      'a good wine?" We chat for hours and laugh a lot. In the end I think: '
      'without a little courage this lovely evening would never have happened. I '
      'would love to dare to do this more often!',
  intro: 'The whole module in one evening: the reflexive pronoun (mich/mir, uns) '
      'while getting ready, and the Konjunktiv II (würde + infinitive, plus '
      'wäre/hätte/könnten) for the polite, hypothetical lines.',
  tips: _konjunktivTips,
);

/// M15 — Konjunktiv II & Reflexive Verbs, in module order.
final List<QuizContent> enDeM15 = [
  enDeM15Forms,
  enDeM15Wuerde,
  enDeM15BigTextWarmup,
  enDeM15Polite,
  enDeM15Reflexive,
  enDeM15Speak,
  enDeM15Dictation,
  enDeM15BigText,
];
