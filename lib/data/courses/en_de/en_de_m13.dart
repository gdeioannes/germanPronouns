import '../../../models/quiz_content.dart';
import 'en_de_builder.dart';

/// M13 — Genitive & Präteritum (B1). The fourth case ("of/'s") and the written
/// past. Theme: a little fairy tale, told in the Präteritum.

const List<HelpMemoryTip> _genitiveTips = [
  HelpMemoryTip(
    kind: 'rule',
    title: 'The genitive (of / \'s)',
    text: 'm & n → **des** + noun + **-(e)s** (des Mann**es**, des Kind**es**); '
        'f & pl → **der**. In speech, **von** + dative often replaces it.',
  ),
  HelpMemoryTip(
    kind: 'warning',
    title: 'n-declension',
    text: 'A few masculine nouns add **-(e)n** in every case but the nominative: '
        'der Junge → den **Jungen**, der Student → dem **Studenten**, der Name → '
        'des **Namens**.',
  ),
  HelpMemoryTip(
    kind: 'rule',
    title: 'Präteritum — the written past',
    text: 'sein/haben/modals use it even in speech: **war, hatte, konnte, '
        'musste, wollte, durfte**.',
  ),
  HelpMemoryTip(
    kind: 'example',
    title: 'Strong Präteritum (no -te)',
    text: 'gehen → **ging**, kommen → **kam**, sehen → **sah**, geben → **gab**, '
        'fahren → **fuhr**, finden → **fand**, bleiben → **blieb**.',
  ),
];

final QuizContent enDeM13Genitive = enDeFill(
  id: 'en_de_m13_genitive',
  title: 'The genitive (des/der)',
  intro: 'Build the genitive: des + -(e)s for masculine/neuter, der for '
      'feminine and plural.',
  tips: _genitiveTips,
  items: const [
    CourseItem(prompt: "the man's car (Auto … Mann)", answer: 'das Auto **des** Mannes'),
    CourseItem(prompt: "the woman's house", answer: 'das Haus **der** Frau'),
    CourseItem(prompt: "the child's toy", answer: 'das Spielzeug **des** Kindes'),
    CourseItem(prompt: 'the title of the book', answer: 'der Titel **des** Buches'),
    CourseItem(prompt: 'the colour of the car', answer: 'die Farbe **des** Autos'),
    CourseItem(prompt: 'the end of the film', answer: 'das Ende **des** Films'),
  ],
);

final QuizContent enDeM13GenitiveVon = enDeFill(
  id: 'en_de_m13_genitive_von',
  title: 'Genitive vs von + dative',
  intro: 'Everyday speech often replaces the genitive with von + dative. '
      'Practise both.',
  tips: _genitiveTips,
  items: const [
    CourseItem(prompt: 'a friend of my father (von + Dat)', answer: 'ein Freund von **meinem** Vater'),
    CourseItem(prompt: 'the roof of the house (Genitiv)', answer: 'das Dach **des** Hauses'),
    CourseItem(prompt: 'the mother of the children (von + Dat)', answer: 'die Mutter von **den** Kindern'),
    CourseItem(prompt: 'the door of the car (Genitiv)', answer: 'die Tür **des** Autos'),
    CourseItem(prompt: 'a photo of my sister (von + Dat)', answer: 'ein Foto von **meiner** Schwester'),
  ],
);

// 13.2a — warm-up big text (after the genitive quizzes): type the genitive
// article. des (+ -s on the noun) for m/n, der for f/pl.
final QuizContent enDeM13BigTextWarmup = enDeBigText(
  id: 'en_de_m13_bigtext_warmup',
  title: 'Big text (warm-up): Der Detektiv',
  passageTitle: 'Der Detektiv',
  template:
      'Detektiv Schwarz untersucht das Zimmer ganz genau. Auf dem Tisch liegt '
      'die Brille {{0}} Professors. Daneben steht die kalte Tasse {{1}} Frau. Am '
      'Boden findet er den Schlüssel {{2}} Autos und das zerrissene Foto {{3}} '
      'Kindes. „Aha!", ruft er plötzlich, „das ist eindeutig die Handschrift '
      '{{4}} Mörders!" Nur das Motiv {{5}} Tat bleibt vorerst ein großes Rätsel.',
  blanks: [
    inputBlank('des', hint: 'Genitiv: der Professor → …'),
    inputBlank('der', hint: 'Genitiv: die Frau → …'),
    inputBlank('des', hint: 'Genitiv: das Auto → …'),
    inputBlank('des', hint: 'Genitiv: das Kind → …'),
    inputBlank('des', hint: 'Genitiv: der Mörder → …'),
    inputBlank('der', hint: 'Genitiv: die Tat → …'),
  ],
  passageTranslation:
      'Detective Schwarz examines the room very carefully. On the table lie the '
      "professor's glasses. Next to them stands the woman's cold cup. On the "
      "floor he finds the car's key and the child's torn photo. \"Aha!\" he "
      "suddenly shouts, \"that is clearly the murderer's handwriting!\" Only the "
      'motive of the deed remains, for now, a great mystery.',
  intro: 'Type the genitive article (the "of/\'s" case): des for masculine and '
      'neuter (the noun also adds -s), der for feminine and plural.',
  tips: _genitiveTips,
);

final QuizContent enDeM13NDeclension = enDeFill(
  id: 'en_de_m13_n_declension',
  title: 'n-declension',
  intro: 'A small group of masculine nouns adds -(e)n in every case except the '
      'nominative singular. Learn the frequent ones.',
  tips: _genitiveTips,
  items: const [
    CourseItem(prompt: 'I see the boy. (der Junge)', answer: 'Ich sehe den **Jungen**'),
    CourseItem(prompt: 'I help the colleague. (der Kollege)', answer: 'Ich helfe dem **Kollegen**'),
    CourseItem(prompt: 'I know the name. (der Name)', answer: 'Ich kenne den **Namen**'),
    CourseItem(prompt: 'with the student (der Student)', answer: 'mit dem **Studenten**'),
    CourseItem(prompt: 'I ask the neighbour. (der Nachbar)', answer: 'Ich frage den **Nachbarn**'),
    CourseItem(prompt: 'I see the customer. (der Kunde)', answer: 'Ich sehe den **Kunden**'),
  ],
);

final QuizContent enDeM13Praeteritum = enDeFill(
  id: 'en_de_m13_praeteritum',
  title: 'Präteritum forms',
  intro: 'The simple past. Learn sein/haben/modals (used in speech) and the '
      'high-frequency strong verbs.',
  tips: _genitiveTips,
  items: const [
    CourseItem(prompt: 'sein → was (ich)', answer: 'war'),
    CourseItem(prompt: 'haben → had (ich)', answer: 'hatte'),
    CourseItem(prompt: 'können → could (ich)', answer: 'konnte'),
    CourseItem(prompt: 'gehen → went (ich)', answer: 'ging'),
    CourseItem(prompt: 'kommen → came (ich)', answer: 'kam'),
    CourseItem(prompt: 'sehen → saw (ich)', answer: 'sah'),
    CourseItem(prompt: 'geben → gave (ich)', answer: 'gab'),
    CourseItem(prompt: 'fahren → drove (ich)', answer: 'fuhr'),
  ],
);

final QuizContent enDeM13Listening = enDeListen(
  id: 'en_de_m13_listening',
  title: 'Listening: Ein Märchen',
  passageTitle: 'Ein Märchen',
  passage:
      'Es war einmal eine Prinzessin. Sie wohnte in einem großen Schloss. Eines '
      'Tages ging sie in den Wald und sah einen Frosch. Der Frosch sprach mit '
      'ihr und wurde am Ende ein Prinz.',
  passageTranslation:
      'Once upon a time there was a princess. She lived in a big castle. One '
      'day she went into the forest and saw a frog. The frog talked with her '
      'and in the end became a prince.',
  intro: 'Listen to the fairy tale, told in the Präteritum (war, wohnte, ging, '
      'sah), and answer.',
  tips: _genitiveTips,
  questions: const [
    ReadingQuestion(
      question: 'Wo wohnte die Prinzessin?',
      options: ['In einem Schloss', 'In einem Dorf', 'Im Wald'],
      correctIndex: 0,
      questionTranslation: 'Where did the princess live?',
    ),
    ReadingQuestion(
      question: 'Was sah sie im Wald?',
      options: ['Einen Frosch', 'Einen Prinzen', 'Einen Hund'],
      correctIndex: 0,
      questionTranslation: 'What did she see in the forest?',
    ),
    ReadingQuestion(
      question: 'Was wurde der Frosch am Ende?',
      options: ['Ein Prinz', 'Ein König', 'Ein Vogel'],
      correctIndex: 0,
      questionTranslation: 'What did the frog become in the end?',
    ),
  ],
);

final QuizContent enDeM13Dictation = enDeDict(
  id: 'en_de_m13_dictation',
  title: 'Dictation: Präteritum',
  intro: 'Listen and write each past-tense sentence. The strong forms (ging, '
      'kam, sah) have no -te ending.',
  tips: _genitiveTips,
  items: const [
    CourseItem(prompt: 'I was at home.', answer: 'Ich war zu Hause.'),
    CourseItem(prompt: 'She had a dog.', answer: 'Sie hatte einen Hund.'),
    CourseItem(prompt: 'We went into the forest.', answer: 'Wir gingen in den Wald.'),
    CourseItem(prompt: 'He came late.', answer: 'Er kam spät.'),
    CourseItem(prompt: 'I saw the king.', answer: 'Ich sah den König.'),
  ],
);

// 13.6 — mastery big text (module capstone): a fairy tale that weaves the
// Präteritum together with the genitive (and the n-declension "des Drachen").
final QuizContent enDeM13BigText = enDeBigText(
  id: 'en_de_m13_bigtext',
  title: 'Big text: Die Legende vom tapferen Ritter',
  passageTitle: 'Die Legende vom tapferen Ritter',
  template:
      'Vor langer, langer Zeit {{0}} ein junger Ritter am Rand eines dunklen '
      'Waldes. Eines Morgens {{1}} er den Hilferuf {{2}} Königs und {{3}} sofort '
      'auf sein Pferd. Im Schloss {{4}} alle in heller Panik: Ein Drache {{5}} '
      'die Tochter {{6}} Königs entführt. „Nur der Mut {{7}} Ritters kann uns '
      'jetzt noch retten!", rief die verzweifelte Königin. Der junge Held {{8}} '
      'drei Tage und drei Nächte, bis er endlich die Höhle {{9}} Drachen fand. '
      'Dort {{10}} er lange und tapfer und {{11}} am Ende den furchtbaren Kampf. '
      'Die Prinzessin war frei, und das Lächeln {{12}} Mädchens war für ihn der '
      'schönste Lohn der Welt.',
  blanks: [
    inputBlank('lebte', hint: 'leben → Präteritum (er)'),
    inputBlank('hörte', hint: 'hören → Präteritum (er)'),
    inputBlank('des', hint: 'Genitiv: der König → …'),
    inputBlank('sprang', hint: 'springen → Präteritum (er)'),
    inputBlank('waren', hint: 'sein → Präteritum (alle …)'),
    inputBlank('hatte', hint: 'haben → Präteritum (er)'),
    inputBlank('des', hint: 'Genitiv: der König → …'),
    inputBlank('des', hint: 'Genitiv: der Ritter → …'),
    inputBlank('ritt', hint: 'reiten → Präteritum (er)'),
    inputBlank('des', hint: 'Genitiv (n-Dekl.): der Drache → … Drachen'),
    inputBlank('kämpfte', accepted: ['kaempfte'], hint: 'kämpfen → Präteritum (er)'),
    inputBlank('gewann', hint: 'gewinnen → Präteritum (er)'),
    inputBlank('des', hint: 'Genitiv: das Mädchen → …'),
  ],
  passageTranslation:
      'Long, long ago a young knight lived at the edge of a dark forest. One '
      "morning he heard the king's cry for help and immediately jumped onto his "
      'horse. At the castle everyone was in sheer panic: a dragon had kidnapped '
      "the king's daughter. \"Only the knight's courage can still save us now!\" "
      'cried the desperate queen. The young hero rode for three days and three '
      "nights until he finally found the dragon's cave. There he fought long and "
      'bravely and in the end won the terrible battle. The princess was free, '
      "and the girl's smile was the finest reward in the world for him.",
  intro: 'The whole module in one fairy tale: put each verb into the Präteritum '
      '(the narrative past — war, hatte, ging…) and form the genitive (des/der, '
      'and des Drachen with the n-declension).',
  tips: _genitiveTips,
);

/// M13 — Genitive & Präteritum, in module order.
final List<QuizContent> enDeM13 = [
  enDeM13Genitive,
  enDeM13GenitiveVon,
  enDeM13BigTextWarmup,
  enDeM13NDeclension,
  enDeM13Praeteritum,
  enDeM13Listening,
  enDeM13Dictation,
  enDeM13BigText,
];
