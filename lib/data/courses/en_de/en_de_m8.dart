import '../../../models/quiz_content.dart';
import 'en_de_builder.dart';

/// M8 — The Perfekt (A2), the spoken past. haben/sein + past participle (at the
/// end). Theme: "my disastrous weekend" — a chain of past actions.

const List<HelpMemoryTip> _perfektTips = [
  HelpMemoryTip(
    kind: 'rule',
    title: 'haben/sein + participle',
    text: 'Perfekt = **haben** or **sein** (position 2) + the past participle at '
        'the very end: Ich **habe** Fußball **gespielt**.',
  ),
  HelpMemoryTip(
    kind: 'mnemonic',
    title: 'Building participles',
    text: 'Regular: **ge-** + stem + **-t** (ge·mach·t, ge·spiel·t). Strong: '
        '**ge-** + stem + **-en**, often with a vowel change (ge·gess·en, '
        'ge·trunk·en, ge·gang·en).',
  ),
  HelpMemoryTip(
    kind: 'warning',
    title: 'sein = movement / change of state',
    text: 'gehen → ist **gegangen**, fahren → ist **gefahren**, kommen → ist '
        '**gekommen**, bleiben → ist **geblieben**, sein → ist **gewesen**. '
        'Everything else takes **haben**.',
  ),
  HelpMemoryTip(
    kind: 'warning',
    title: 'No ge- with -ieren / be-/ver-/er-',
    text: 'Verbs in -ieren and inseparable be-/ver-/er- verbs drop ge-: '
        'studier**t**, telefonier**t**, **be**·such·t, **ver**·gess·en.',
  ),
  HelpMemoryTip(
    kind: 'example',
    title: 'Word order',
    text: 'Gestern **habe** ich Pizza **gegessen.** — helper second, participle '
        'last.',
  ),
];

final QuizContent enDeM8Regular = enDeFill(
  id: 'en_de_m8_regular',
  title: 'Regular participles (ge-…-t)',
  intro: 'Most verbs form the participle with ge- + stem + -t. Learn the '
      'pattern on these everyday verbs.',
  tips: _perfektTips,
  items: const [
    CourseItem(prompt: 'machen → made', answer: 'gemacht'),
    CourseItem(prompt: 'spielen → played', answer: 'gespielt'),
    CourseItem(prompt: 'lernen → learned', answer: 'gelernt'),
    CourseItem(prompt: 'kaufen → bought', answer: 'gekauft'),
    CourseItem(prompt: 'kochen → cooked', answer: 'gekocht'),
    CourseItem(prompt: 'hören → heard', answer: 'gehört'),
    CourseItem(prompt: 'arbeiten → worked', answer: 'gearbeitet'),
    CourseItem(prompt: 'wohnen → lived', answer: 'gewohnt'),
  ],
);

final QuizContent enDeM8Strong = enDeFill(
  id: 'en_de_m8_strong',
  title: 'Strong participles (ge-…-en)',
  intro: 'Strong verbs end in -en and often change the vowel. There is no rule '
      '— learn these high-frequency ones by heart.',
  tips: _perfektTips,
  items: const [
    CourseItem(prompt: 'gehen → gone', answer: 'gegangen'),
    CourseItem(prompt: 'sehen → seen', answer: 'gesehen'),
    CourseItem(prompt: 'essen → eaten', answer: 'gegessen'),
    CourseItem(prompt: 'trinken → drunk', answer: 'getrunken'),
    CourseItem(prompt: 'fahren → driven/gone', answer: 'gefahren'),
    CourseItem(prompt: 'lesen → read', answer: 'gelesen'),
    CourseItem(prompt: 'schreiben → written', answer: 'geschrieben'),
    CourseItem(prompt: 'nehmen → taken', answer: 'genommen'),
  ],
);

final QuizContent enDeM8HabenSein = enDeFill(
  id: 'en_de_m8_haben_sein',
  title: 'haben or sein?',
  intro: 'Pick the helper. Most verbs take haben; verbs of movement or change '
      'of state take sein.',
  tips: _perfektTips,
  items: const [
    CourseItem(prompt: 'I have played football. (haben)', answer: 'Ich **habe** Fußball gespielt'),
    CourseItem(prompt: 'I went home. (sein, gehen)', answer: 'Ich **bin** nach Hause gegangen'),
    CourseItem(prompt: 'She has eaten pizza. (haben)', answer: 'Sie **hat** Pizza gegessen'),
    CourseItem(prompt: 'We drove to Berlin. (sein, fahren)', answer: 'Wir **sind** nach Berlin gefahren'),
    CourseItem(prompt: 'He has bought a car. (haben)', answer: 'Er **hat** ein Auto gekauft'),
    CourseItem(prompt: 'They stayed at home. (sein, bleiben)', answer: 'Sie **sind** zu Hause geblieben'),
  ],
);

final QuizContent enDeM8WordOrder = enDeFill(
  id: 'en_de_m8_word_order',
  title: 'Word order: participle at the end',
  intro: 'In a Perfekt sentence the participle always jumps to the very end — '
      'the helper verb holds position 2.',
  tips: _perfektTips,
  items: const [
    CourseItem(prompt: 'Yesterday I played football. (spielen)', answer: 'Gestern habe ich Fußball **gespielt**'),
    CourseItem(prompt: 'She has bought a new dress. (kaufen)', answer: 'Sie hat ein neues Kleid **gekauft**'),
    CourseItem(prompt: 'We drove to Berlin. (fahren)', answer: 'Wir sind nach Berlin **gefahren**'),
    CourseItem(prompt: 'I have learned a lot. (lernen)', answer: 'Ich habe viel **gelernt**'),
    CourseItem(prompt: 'He has read the book. (lesen)', answer: 'Er hat das Buch **gelesen**'),
  ],
);

final QuizContent enDeM8Speak = enDeSpeak(
  id: 'en_de_m8_speak',
  title: 'Speak: Mein Wochenende',
  intro: 'Narrate your weekend in the Perfekt. Say each line aloud — this is '
      'exactly how Germans talk about the past.',
  tips: _perfektTips,
  items: const [
    CourseItem(prompt: 'On Saturday I played football.', answer: 'Am Samstag habe ich Fußball gespielt.'),
    CourseItem(prompt: 'In the evening I cooked.', answer: 'Am Abend habe ich gekocht.'),
    CourseItem(prompt: 'On Sunday I drove to Berlin.', answer: 'Am Sonntag bin ich nach Berlin gefahren.'),
    CourseItem(prompt: 'There I met friends.', answer: 'Dort habe ich Freunde getroffen.'),
    CourseItem(prompt: 'We ate pizza.', answer: 'Wir haben Pizza gegessen.'),
    CourseItem(prompt: 'It was a great weekend.', answer: 'Es war ein tolles Wochenende.'),
  ],
);

final QuizContent enDeM8Listening = enDeListen(
  id: 'en_de_m8_listening',
  title: 'Listening: Eine Reise',
  passageTitle: 'Eine Reise',
  passage:
      'Letztes Jahr bin ich nach Italien gefahren. Ich habe viel Pizza gegessen '
      'und das Meer gesehen. Am Ende habe ich viele Fotos gemacht.',
  passageTranslation:
      'Last year I went to Italy. I ate a lot of pizza and saw the sea. At the '
      'end I took lots of photos.',
  intro: 'Listen to the holiday story (Perfekt) and answer. Follow the chain of '
      'past actions.',
  tips: _perfektTips,
  questions: const [
    ReadingQuestion(
      question: 'Wohin ist die Person gefahren?',
      options: ['Nach Italien', 'Nach Spanien', 'Nach Berlin'],
      correctIndex: 0,
      questionTranslation: 'Where did the person go?',
    ),
    ReadingQuestion(
      question: 'Was hat sie gegessen?',
      options: ['Pizza', 'Sushi', 'Brot'],
      correctIndex: 0,
      questionTranslation: 'What did they eat?',
    ),
    ReadingQuestion(
      question: 'Was hat sie am Ende gemacht?',
      options: ['Fotos gemacht', 'Ein Buch gelesen', 'Fußball gespielt'],
      correctIndex: 0,
      questionTranslation: 'What did they do at the end?',
    ),
  ],
);

final QuizContent enDeM8BigTextWarmup = enDeBigText(
  id: 'en_de_m8_bigtext_warmup',
  title: 'Big text (warm-up): Ein fauler Sonntag',
  passageTitle: 'Ein fauler Sonntag',
  template:
      'Gestern war Sonntag, und ich habe fast nichts {{0}}! Am Morgen habe ich '
      'lange Musik {{1}} und drei Tassen Kaffee {{2}}. Dann habe ich ein '
      'spannendes Buch {{3}} und meiner Oma eine lange E-Mail {{4}}. Mittags '
      'habe ich Spaghetti {{5}} und viel zu viel {{6}}. Am Nachmittag habe ich '
      'einen alten Film {{7}}. Faul? Ja. Aber herrlich!',
  blanks: [
    inputBlank('gemacht', hint: 'machen → …'),
    inputBlank('gehört', hint: 'hören → …'),
    inputBlank('getrunken', hint: 'trinken → …'),
    inputBlank('gelesen', hint: 'lesen → …'),
    inputBlank('geschrieben', hint: 'schreiben → …'),
    inputBlank('gekocht', hint: 'kochen → …'),
    inputBlank('gegessen', hint: 'essen → …'),
    inputBlank('gesehen', hint: 'sehen → …'),
  ],
  passageTranslation:
      'Yesterday was Sunday, and I did almost nothing! In the morning I '
      'listened to music for a long time and drank three cups of coffee. Then '
      'I read an exciting book and wrote my grandma a long email. At lunchtime '
      'I cooked spaghetti and ate far too much. In the afternoon I watched an '
      'old film. Lazy? Yes. But wonderful!',
  intro: 'Type the past participle of each verb (the helper habe is already '
      'there). A mix of regular (ge-…-t) and strong (ge-…-en) — the very forms '
      'from the last two quizzes.',
  tips: _perfektTips,
);

final QuizContent enDeM8BigText = enDeBigText(
  id: 'en_de_m8_bigtext',
  title: 'Big text: Mein chaotisches Wochenende',
  passageTitle: 'Mein chaotisches Wochenende',
  template:
      'Was für ein Wochenende! Am Freitag {{0}} ich mit dem Zug nach München '
      '{{1}}. Im Hotel {{2}} ich erst einmal etwas {{3}}, denn ich hatte '
      'großen Hunger. Am Samstag {{4}} ich durch die ganze Altstadt {{5}} und '
      '{{6}} dabei hundert Fotos {{7}}. Abends {{8}} ich in einem Biergarten '
      'ein riesiges Bier {{9}}. Am Sonntag {{10}} ich völlig erschöpft nach '
      'Hause {{11}}. Mein Geld ist weg, aber die Erinnerungen bleiben!',
  blanks: [
    inputBlank('bin', hint: 'helper? (fahren)'),
    inputBlank('gefahren', hint: 'fahren → …'),
    inputBlank('habe', hint: 'helper? (essen)'),
    inputBlank('gegessen', hint: 'essen → …'),
    inputBlank('bin', hint: 'helper? (gehen)'),
    inputBlank('gegangen', hint: 'gehen → …'),
    inputBlank('habe', hint: 'helper? (machen)'),
    inputBlank('gemacht', hint: 'machen → …'),
    inputBlank('habe', hint: 'helper? (trinken)'),
    inputBlank('getrunken', hint: 'trinken → …'),
    inputBlank('bin', hint: 'helper? (kommen)'),
    inputBlank('gekommen', hint: 'kommen → …'),
  ],
  passageTranslation:
      'What a weekend! On Friday I took the train to Munich. At the hotel I '
      'first ate something, because I was very hungry. On Saturday I walked '
      'through the whole old town and took a hundred photos. In the evening I '
      'drank a huge beer in a beer garden. On Sunday I came home completely '
      'exhausted. My money is gone, but the memories remain!',
  intro: 'The full Perfekt: choose the helper (haben, or sein for movement — '
      'fahren, gehen, kommen) and form the participle. The helper sits in '
      'position 2, the participle jumps to the very end.',
  tips: _perfektTips,
);

/// M8 — The Perfekt, in module order.
final List<QuizContent> enDeM8 = [
  enDeM8Regular,
  enDeM8Strong,
  enDeM8BigTextWarmup,
  enDeM8HabenSein,
  enDeM8WordOrder,
  enDeM8BigText,
  enDeM8Speak,
  enDeM8Listening,
];
