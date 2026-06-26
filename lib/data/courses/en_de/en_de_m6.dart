import '../../../models/quiz_content.dart';
import 'en_de_builder.dart';

/// M6 — Two-Way Prepositions (A2). The nine Wechselpräpositionen take the
/// accusative for movement (Wohin?) and the dative for location (Wo?). Theme:
/// a cat that will not stay put.

const List<HelpMemoryTip> _zweiwegTips = [
  HelpMemoryTip(
    kind: 'rule',
    title: 'The nine two-way prepositions',
    text: '**an, auf, hinter, in, neben, über, unter, vor, zwischen** — '
        'accusative for motion (Wohin?), dative for position (Wo?).',
  ),
  HelpMemoryTip(
    kind: 'mnemonic',
    title: 'Wohin → Akk, Wo → Dat',
    text: 'Moving to a *new* place = **Akkusativ** (into). Already *being* there '
        '= **Dativ** (in). Even "Wohi**n**" ends in -n, like de**n**.',
  ),
  HelpMemoryTip(
    kind: 'example',
    title: 'The classic pair',
    text: 'Die Katze springt auf **den** Tisch (Wohin? → Akk) — und sitzt dann '
        'auf **dem** Tisch (Wo? → Dat).',
  ),
  HelpMemoryTip(
    kind: 'warning',
    title: 'Let the verb decide',
    text: 'Motion verbs (gehen, springen, legen, stellen, sich setzen) → '
        '**Akk**. Position verbs (sein, sitzen, liegen, stehen, bleiben) → '
        '**Dat**.',
  ),
  HelpMemoryTip(
    kind: 'tip',
    title: 'Handy contractions',
    text: 'in+das = **ins**, in+dem = **im**, an+das = **ans**, an+dem = **am**, '
        'auf+das = **aufs**.',
  ),
];

final QuizContent enDeM6List = enDeFill(
  id: 'en_de_m6_list',
  title: 'The nine two-way prepositions',
  intro: 'Meet the nine prepositions that can take either case. Learn the list '
      'first; the case comes next.',
  tips: _zweiwegTips,
  items: const [
    CourseItem(prompt: 'on (vertical surface), at', answer: 'an'),
    CourseItem(prompt: 'on (top of)', answer: 'auf'),
    CourseItem(prompt: 'behind', answer: 'hinter'),
    CourseItem(prompt: 'in, into', answer: 'in'),
    CourseItem(prompt: 'next to', answer: 'neben'),
    CourseItem(prompt: 'over, above', answer: 'über'),
    CourseItem(prompt: 'under', answer: 'unter'),
    CourseItem(prompt: 'in front of', answer: 'vor'),
    CourseItem(prompt: 'between', answer: 'zwischen'),
  ],
);

final QuizContent enDeM6Wohin = enDeFill(
  id: 'en_de_m6_wohin',
  title: 'Wohin? → accusative (motion)',
  intro: 'When the cat moves to a new place, the answer is Wohin? and the case '
      'is accusative.',
  tips: _zweiwegTips,
  items: const [
    CourseItem(prompt: 'The cat jumps onto the table. (auf, der Tisch)', answer: 'Die Katze springt auf **den** Tisch'),
    CourseItem(prompt: 'It runs into the kitchen. (in, die Küche)', answer: 'Sie rennt in **die** Küche'),
    CourseItem(prompt: 'It climbs under the bed. (unter, das Bett)', answer: 'Sie klettert unter **das** Bett'),
    CourseItem(prompt: 'It goes behind the curtain. (hinter, der Vorhang)', answer: 'Sie geht hinter **den** Vorhang'),
    CourseItem(prompt: 'It jumps onto the sofa. (auf, das Sofa)', answer: 'Sie springt auf **das** Sofa'),
    CourseItem(prompt: 'It hides between the boxes. (zwischen, die Kisten, pl)', answer: 'Sie versteckt sich zwischen **die** Kisten'),
  ],
);

// 6.2a — warm-up big text (after the Wohin? quiz): the cat is always moving, so
// every phrase is Wohin? → accusative. Type the accusative article.
final QuizContent enDeM6BigTextWarmup = enDeBigText(
  id: 'en_de_m6_bigtext_warmup',
  title: 'Big text (warm-up): Minka auf Entdeckungstour',
  passageTitle: 'Minka auf Entdeckungstour',
  template:
      'Die kleine Katze Minka kann einfach nie still sitzen! Zuerst springt sie '
      'auf {{0}} Tisch, dann klettert sie in {{1}} Karton und kriecht neugierig '
      'unter {{2}} Sofa. Gleich danach rennt sie hinter {{3}} Vorhang, hüpft '
      'elegant auf {{4}} Fensterbank und verschwindet schließlich in {{5}} '
      'Küche. Überall will sie gleichzeitig hin — nur schlafen, das will sie nie!',
  blanks: [
    inputBlank('den', hint: 'Wohin? auf … Tisch (der)'),
    inputBlank('den', hint: 'Wohin? in … Karton (der)'),
    inputBlank('das', hint: 'Wohin? unter … Sofa (das)'),
    inputBlank('den', hint: 'Wohin? hinter … Vorhang (der)'),
    inputBlank('die', hint: 'Wohin? auf … Fensterbank (die)'),
    inputBlank('die', hint: 'Wohin? in … Küche (die)'),
  ],
  passageTranslation:
      'Little cat Minka simply can never sit still! First she jumps onto the '
      'table, then climbs into the box and crawls curiously under the sofa. '
      'Right after that she runs behind the curtain, hops elegantly onto the '
      'windowsill, and finally disappears into the kitchen. She wants to be '
      'everywhere at once — the one thing she never wants is to sleep!',
  intro: 'The cat is always on the move, so every phrase answers Wohin? → '
      'accusative. Type the accusative article: der → den (masculine), while die '
      'and das stay the same.',
  tips: _zweiwegTips,
);

final QuizContent enDeM6Wo = enDeFill(
  id: 'en_de_m6_wo',
  title: 'Wo? → dative (location)',
  intro: 'When the cat simply is somewhere, the answer is Wo? and the case is '
      'dative.',
  tips: _zweiwegTips,
  items: const [
    CourseItem(prompt: 'The cat sits on the table. (auf, der Tisch)', answer: 'Die Katze sitzt auf **dem** Tisch'),
    CourseItem(prompt: 'It sleeps in the kitchen. (in, die Küche)', answer: 'Sie schläft in **der** Küche'),
    CourseItem(prompt: 'It lies under the bed. (unter, das Bett)', answer: 'Sie liegt unter **dem** Bett'),
    CourseItem(prompt: 'It is behind the curtain. (hinter, der Vorhang)', answer: 'Sie ist hinter **dem** Vorhang'),
    CourseItem(prompt: 'It sits on the sofa. (auf, das Sofa)', answer: 'Sie sitzt auf **dem** Sofa'),
    CourseItem(prompt: 'It waits between the boxes. (zwischen, die Kisten, pl)', answer: 'Sie wartet zwischen **den** Kisten'),
  ],
);

final QuizContent enDeM6Mixed = enDeFill(
  id: 'en_de_m6_mixed',
  title: 'Mixed: read the verb',
  intro: 'Now both are mixed. Look at the verb: is the cat moving (Akkusativ) '
      'or staying (Dativ)? Same preposition, different case.',
  tips: _zweiwegTips,
  items: const [
    CourseItem(prompt: 'The cat jumps onto the table. (auf, der Tisch)', answer: 'Die Katze springt auf **den** Tisch'),
    CourseItem(prompt: 'The cat sits on the table. (auf, der Tisch)', answer: 'Die Katze sitzt auf **dem** Tisch'),
    CourseItem(prompt: 'It runs under the chair. (unter, der Stuhl)', answer: 'Sie rennt unter **den** Stuhl'),
    CourseItem(prompt: 'It sleeps under the chair. (unter, der Stuhl)', answer: 'Sie schläft unter **dem** Stuhl'),
    CourseItem(prompt: 'It climbs onto the wardrobe. (auf, der Schrank)', answer: 'Sie klettert auf **den** Schrank'),
    CourseItem(prompt: 'It sits on the wardrobe. (auf, der Schrank)', answer: 'Sie sitzt auf **dem** Schrank'),
  ],
);

// 6.5 — big text: pick Akkusativ (motion) or Dativ (location) at the marked
// two-way phrases. The pairs (unter einen/dem Tisch, auf den/dem Schrank) make
// the contrast jump out; some phrases are left as prose.
final QuizContent enDeM6BigText = enDeBigText(
  id: 'en_de_m6_bigtext',
  title: 'Big text: Die Katze in der Stadt',
  passageTitle: 'Die Katze in der Stadt',
  template:
      'Heute hat die kleine Katze Minka große Pläne: Sie geht ganz allein in '
      'die Stadt {{0}}. Zuerst springt sie elegant auf eine Bank {{1}} und '
      'beobachtet neugierig die vielen Menschen. Dann schleicht sie in ein '
      'gemütliches Café und setzt sich frech unter einen Tisch {{2}}. Dort '
      'sitzt sie ganz ruhig unter dem Tisch {{3}} und wartet auf einen Krümel '
      'Kuchen. Plötzlich stürmt ein großer, lauter Hund herein! Minka '
      'erschrickt, springt blitzschnell auf den Schrank {{4}} und bleibt '
      'zitternd oben auf dem Schrank {{5}}, bis der Hund endlich wieder '
      'draußen ist. Was für ein Abenteuer für so eine kleine Katze!',
  blanks: [
    caseBlank('Akkusativ', options: _akkDat), // in die Stadt (motion)
    caseBlank('Akkusativ', options: _akkDat), // auf eine Bank (motion)
    caseBlank('Akkusativ', options: _akkDat), // unter einen Tisch (sich setzen)
    caseBlank('Dativ', options: _akkDat), // unter dem Tisch (sitzen)
    caseBlank('Akkusativ', options: _akkDat), // auf den Schrank (springen)
    caseBlank('Dativ', options: _akkDat), // auf dem Schrank (bleiben)
  ],
  passageTranslation:
      'Today the little cat Minka has big plans: she goes into the city all by '
      'herself. First she jumps elegantly onto a bench and curiously watches '
      'the many people. Then she sneaks into a cosy café and cheekily sits down '
      'under a table. There she sits very quietly under the table and waits for '
      'a crumb of cake. Suddenly a big, loud dog storms in! Minka gets a '
      'fright, jumps lightning-fast onto the wardrobe, and stays trembling up '
      'on the wardrobe until the dog is finally outside again. What an '
      'adventure for such a little cat!',
  intro: 'For each marked phrase pick the case. Ask: is the cat moving there '
      '(Wohin? → Akkusativ) or already there (Wo? → Dativ)? Watch the pairs: '
      'sich setzen unter einen Tisch vs sitzen unter dem Tisch.',
  tips: _zweiwegTips,
);

const List<String> _akkDat = ['Akkusativ', 'Dativ'];

final QuizContent enDeM6Listening = enDeListen(
  id: 'en_de_m6_listening',
  title: 'Listening: in den vs im',
  passageTitle: 'Die Katze zu Hause',
  passage:
      'Die Katze springt auf den Tisch. Dann sitzt sie auf dem Tisch und '
      'schläft. Am Abend geht sie in die Küche und frisst.',
  passageTranslation:
      'The cat jumps onto the table. Then it sits on the table and sleeps. In '
      'the evening it goes into the kitchen and eats.',
  intro: 'Listen carefully: the only clue to motion vs location is the case you '
      'hear — "auf den Tisch" (Akk) vs "auf dem Tisch" (Dat).',
  tips: _zweiwegTips,
  questions: const [
    ReadingQuestion(
      question: 'Was passiert zuerst?',
      options: [
        'Die Katze springt auf den Tisch (Bewegung).',
        'Die Katze sitzt auf dem Tisch (Ort).',
        'Die Katze frisst in der Küche.',
      ],
      correctIndex: 0,
      questionTranslation: 'What happens first?',
    ),
    ReadingQuestion(
      question: '„auf dem Tisch" — Bewegung oder Ort?',
      options: ['Ort (Dativ)', 'Bewegung (Akkusativ)'],
      correctIndex: 0,
      questionTranslation: 'Motion or location?',
    ),
    ReadingQuestion(
      question: 'Wohin geht die Katze am Abend?',
      options: ['In die Küche', 'In den Garten', 'Auf den Tisch'],
      correctIndex: 0,
      questionTranslation: 'Where does the cat go in the evening?',
    ),
  ],
);

final QuizContent enDeM6Speak = enDeSpeak(
  id: 'en_de_m6_speak',
  title: 'Speak: Wo / Wohin',
  intro: 'Say the pairs aloud. Hearing "den" vs "dem" back to back trains your '
      'ear for motion vs location.',
  tips: _zweiwegTips,
  items: const [
    CourseItem(prompt: 'The cat is on the table.', answer: 'Die Katze ist auf dem Tisch.'),
    CourseItem(prompt: 'The cat jumps onto the table.', answer: 'Die Katze springt auf den Tisch.'),
    CourseItem(prompt: 'It sleeps in the kitchen.', answer: 'Sie schläft in der Küche.'),
    CourseItem(prompt: 'It runs into the kitchen.', answer: 'Sie rennt in die Küche.'),
    CourseItem(prompt: 'The book lies on the table.', answer: 'Das Buch liegt auf dem Tisch.'),
    CourseItem(prompt: 'I put the book on the table.', answer: 'Ich lege das Buch auf den Tisch.'),
  ],
);

/// M6 — Two-Way Prepositions, in module order.
final List<QuizContent> enDeM6 = [
  enDeM6List,
  enDeM6Wohin,
  enDeM6BigTextWarmup,
  enDeM6Wo,
  enDeM6Mixed,
  enDeM6Listening,
  enDeM6Speak,
  enDeM6BigText,
];
