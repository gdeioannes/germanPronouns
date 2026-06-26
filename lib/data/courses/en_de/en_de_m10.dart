import '../../../models/quiz_content.dart';
import 'en_de_builder.dart';

/// M10 — Comparisons (A2). Comparative (-er + als), superlative (am …-sten),
/// the irregulars, and so … wie for equality. Theme: city vs country.

const List<HelpMemoryTip> _comparisonTips = [
  HelpMemoryTip(
    kind: 'rule',
    title: 'Comparative & superlative',
    text: 'Comparative: adjective + **-er** (+ **als**): schnell**er als**. '
        'Superlative: **am** …**-sten**: **am** schnell**sten**.',
  ),
  HelpMemoryTip(
    kind: 'warning',
    title: 'Short adjectives add an umlaut',
    text: 'alt → **älter**, groß → **größer**, jung → **jünger**, lang → '
        '**länger**, kalt → **kälter**, stark → **stärker**.',
  ),
  HelpMemoryTip(
    kind: 'mnemonic',
    title: 'als vs wie',
    text: '**…er als** for a difference (größer **als**); **so … wie** for '
        'equality (so groß **wie**).',
  ),
  HelpMemoryTip(
    kind: 'example',
    title: 'The big irregulars — learn cold',
    text: 'gut → **besser** → am **besten** · viel → **mehr** → am **meisten** · '
        'gern → **lieber** → am **liebsten** · hoch → **höher** → am '
        '**höchsten**.',
  ),
];

final QuizContent enDeM10Forms = enDeFill(
  id: 'en_de_m10_forms',
  title: 'Comparative & superlative forms',
  intro: 'Build the forms. Watch for the umlauts and the irregular trio '
      'gut/viel/gern.',
  tips: _comparisonTips,
  items: const [
    CourseItem(prompt: 'groß → bigger', answer: 'größer', accepted: ['groesser']),
    CourseItem(prompt: 'alt → older', answer: 'älter', accepted: ['aelter']),
    CourseItem(prompt: 'jung → younger', answer: 'jünger', accepted: ['juenger']),
    CourseItem(prompt: 'gut → better', answer: 'besser'),
    CourseItem(prompt: 'viel → more', answer: 'mehr'),
    CourseItem(prompt: 'gern → more gladly', answer: 'lieber'),
    CourseItem(prompt: 'schnell → fastest (am …)', answer: 'am schnellsten'),
    CourseItem(prompt: 'gut → best (am …)', answer: 'am besten'),
  ],
);

final QuizContent enDeM10AlsWie = enDeFill(
  id: 'en_de_m10_als_wie',
  title: 'als vs wie',
  intro: 'Choose the linker: als for a difference, (so …) wie for equality.',
  tips: _comparisonTips,
  items: const [
    CourseItem(prompt: 'Anna is taller than Tom.', answer: 'Anna ist größer **als** Tom'),
    CourseItem(prompt: 'Tom is as tall as Mia. (so … wie)', answer: 'Tom ist so groß **wie** Mia'),
    CourseItem(prompt: 'The car is faster than the bike.', answer: 'Das Auto ist schneller **als** das Fahrrad'),
    CourseItem(prompt: 'She is as nice as her sister.', answer: 'Sie ist so nett **wie** ihre Schwester'),
    CourseItem(prompt: 'Today it is colder than yesterday.', answer: 'Heute ist es kälter **als** gestern'),
  ],
);

// 10.2a — warm-up big text (after the form + als/wie quizzes): type the
// comparative (adjective + -er, watch the umlaut) or the linker als/wie.
final QuizContent enDeM10BigTextWarmup = enDeBigText(
  id: 'en_de_m10_bigtext_warmup',
  title: 'Big text (warm-up): Max und Felix',
  passageTitle: 'Max und Felix',
  template:
      'Max und Felix sind beste Freunde, aber in allem verschieden. Max ist '
      '{{0}} als Felix, dafür läuft Felix viel {{1}} {{2}} Max. In der Schule '
      'lernt Max {{3}} als sein Freund, doch beim Fußball ist Felix einfach '
      '{{4}}. „Du bist eben nicht so sportlich {{5}} ich!", lacht Felix. Max '
      'grinst nur: „Stimmt — aber dafür bin ich {{6}} als du." Am Ende sind sich '
      'beide einig: Zusammen sind sie sowieso unschlagbar.',
  blanks: [
    inputBlank('größer', accepted: ['groesser'], hint: 'groß → Komparativ'),
    inputBlank('schneller', hint: 'schnell → Komparativ'),
    inputBlank('als', hint: 'schneller … Max (als/wie?)'),
    inputBlank('mehr', hint: 'viel → Komparativ'),
    inputBlank('besser', hint: 'gut → Komparativ'),
    inputBlank('wie', hint: 'so sportlich … ich (als/wie?)'),
    inputBlank('klüger', accepted: ['klueger'], hint: 'klug → Komparativ'),
  ],
  passageTranslation:
      'Max and Felix are best friends, but different in everything. Max is '
      'taller than Felix, but Felix runs much faster than Max. At school Max '
      'learns more than his friend, yet at football Felix is simply better. '
      '"You\'re just not as sporty as I am!" laughs Felix. Max just grins: '
      '"True — but I\'m cleverer than you." In the end they both agree: together '
      'they are unbeatable anyway.',
  intro: 'Type the comparative (adjective + -er, and watch the umlaut: groß → '
      'größer) or the right linker — als for a difference, wie for equality '
      '(so … wie).',
  tips: _comparisonTips,
);

final QuizContent enDeM10Reading = enDeRead(
  id: 'en_de_m10_reading',
  title: 'Reading: Stadt oder Land?',
  passageTitle: 'Stadt oder Land?',
  passage:
      'Anna wohnt in der Stadt, ihr Bruder Tom auf dem Land. Anna sagt: „Die '
      'Stadt ist interessanter als das Land. Hier gibt es mehr Cafés, Kinos und '
      'Geschäfte." Tom findet das Land schöner und ruhiger. „Die Luft ist '
      'besser, und ich habe einen großen Garten", sagt er. Beide sind '
      'glücklich — aber am Wochenende besucht Anna oft ihren Bruder, denn auf '
      'dem Land kann man am besten entspannen.',
  passageTranslation:
      'Anna lives in the city, her brother Tom in the country. Anna says: "The '
      'city is more interesting than the country. There are more cafés, cinemas '
      'and shops here." Tom finds the country prettier and quieter. "The air is '
      'better, and I have a big garden," he says. Both are happy — but at the '
      'weekend Anna often visits her brother, because in the country you can '
      'relax best.',
  intro: 'Read the comparison of city and country life, then answer. Look for '
      'the comparative forms (interessanter, schöner, besser).',
  tips: _comparisonTips,
  questions: const [
    ReadingQuestion(
      question: 'Wo wohnt Anna?',
      options: ['In der Stadt', 'Auf dem Land', 'Am Meer'],
      correctIndex: 0,
      questionTranslation: 'Where does Anna live?',
    ),
    ReadingQuestion(
      question: 'Warum mag Tom das Land?',
      options: [
        'Es ist ruhiger und die Luft ist besser.',
        'Es gibt mehr Cafés.',
        'Es ist interessanter.',
      ],
      correctIndex: 0,
      questionTranslation: 'Why does Tom like the country?',
    ),
    ReadingQuestion(
      question: 'Was macht Anna am Wochenende oft?',
      options: [
        'Sie besucht ihren Bruder.',
        'Sie bleibt in der Stadt.',
        'Sie geht ins Kino.',
      ],
      correctIndex: 0,
      questionTranslation: 'What does Anna often do at the weekend?',
    ),
  ],
);

final QuizContent enDeM10Speak = enDeSpeak(
  id: 'en_de_m10_speak',
  title: 'Speak: comparisons aloud',
  intro: 'Say each comparison aloud. These patterns let you express '
      'preferences in any conversation.',
  tips: _comparisonTips,
  items: const [
    CourseItem(prompt: 'Anna is taller than Tom.', answer: 'Anna ist größer als Tom.'),
    CourseItem(prompt: 'The train is faster than the bus.', answer: 'Der Zug ist schneller als der Bus.'),
    CourseItem(prompt: 'Today it is colder than yesterday.', answer: 'Heute ist es kälter als gestern.'),
    CourseItem(prompt: 'I like tea more than coffee.', answer: 'Ich mag Tee lieber als Kaffee.'),
    CourseItem(prompt: 'This is the best café in the city.', answer: 'Das ist das beste Café in der Stadt.'),
  ],
);

final QuizContent enDeM10Listening = enDeListen(
  id: 'en_de_m10_listening',
  title: 'Listening: compare them',
  passageTitle: 'Zug, Auto, Fahrrad',
  passage:
      'Der Zug ist schneller als das Auto, aber das Auto ist bequemer. Das '
      'Fahrrad ist am billigsten und am gesündesten.',
  passageTranslation:
      'The train is faster than the car, but the car is more comfortable. The '
      'bike is the cheapest and the healthiest.',
  intro: 'Listen to the comparison and answer. Catch the comparative (-er als) '
      'and superlative (am …-sten) forms.',
  tips: _comparisonTips,
  questions: const [
    ReadingQuestion(
      question: 'Was ist schneller, der Zug oder das Auto?',
      options: ['Der Zug', 'Das Auto', 'Das Fahrrad'],
      correctIndex: 0,
      questionTranslation: 'What is faster, the train or the car?',
    ),
    ReadingQuestion(
      question: 'Was ist am billigsten?',
      options: ['Das Fahrrad', 'Der Zug', 'Das Auto'],
      correctIndex: 0,
      questionTranslation: 'What is the cheapest?',
    ),
    ReadingQuestion(
      question: 'Was ist bequemer als der Zug?',
      options: ['Das Auto', 'Das Fahrrad', 'Der Bus'],
      correctIndex: 0,
      questionTranslation: 'What is more comfortable than the train?',
    ),
  ],
);

// 10.6 — mastery big text (module capstone): comparatives + superlatives
// (am …-sten) + irregulars (gut/viel/gern) + als vs wie, all in one story.
final QuizContent enDeM10BigText = enDeBigText(
  id: 'en_de_m10_bigtext',
  title: 'Big text: Meine drei Geschwister',
  passageTitle: 'Meine drei Geschwister',
  template:
      'Meine drei Geschwister und ich sind völlig verschieden — perfekt für '
      'einen kleinen Familienwettbewerb! Meine Schwester Lena ist {{0}} als ich, '
      'aber ich laufe {{1}} als sie. Beim Lernen ist Lena allerdings {{2}} als '
      'wir alle; sie hat einfach immer die besten Noten. Mein Bruder Tim ist der '
      'Jüngste und isst am {{3}} von uns allen — wirklich unglaublich! Dafür ist '
      'er morgens nie so wach {{4}} ich. Ich singe gern, aber Lena singt {{5}} '
      'und auch viel {{6}}. „Du bist eben nicht so musikalisch {{7}} ich!", lacht '
      'sie. Am Ende sind wir uns trotzdem einig: Unsere Mutter kocht am {{8}}, '
      'unser Vater erzählt die Witze am {{9}}, und zusammen sind wir einfach am '
      '{{10}} — na ja, fast immer.',
  blanks: [
    inputBlank('größer', accepted: ['groesser'], hint: 'groß → Komparativ'),
    inputBlank('schneller', hint: 'schnell → Komparativ'),
    inputBlank('besser', hint: 'gut → Komparativ'),
    inputBlank('meisten', hint: 'viel → am …-sten'),
    inputBlank('wie', hint: 'so wach … ich (als/wie?)'),
    inputBlank('lieber', hint: 'gern → Komparativ'),
    inputBlank('schöner', accepted: ['schoener'], hint: 'schön → Komparativ'),
    inputBlank('wie', hint: 'so musikalisch … ich (als/wie?)'),
    inputBlank('besten', hint: 'gut → am …-sten'),
    inputBlank('lustigsten', hint: 'lustig → am …-sten'),
    inputBlank('glücklichsten', accepted: ['gluecklichsten'], hint: 'glücklich → am …-sten'),
  ],
  passageTranslation:
      'My three siblings and I are completely different — perfect for a little '
      'family competition! My sister Lena is taller than me, but I run faster '
      'than her. When it comes to studying, though, Lena is better than all of '
      'us; she simply always has the best grades. My brother Tim is the youngest '
      'and eats the most of all of us — really unbelievable! On the other hand, '
      'in the mornings he is never as awake as me. I like singing, but Lena '
      'likes it more — and sings far more beautifully too. "You\'re just not as '
      'musical as I am!" she laughs. In the end we still agree: our mother cooks '
      'the best, our father tells jokes the funniest, and together we are simply '
      'the happiest — well, almost always.',
  intro: 'The whole module in one story: form comparatives (adjective + -er + '
      'als, with umlauts), superlatives (am …-sten), the irregulars '
      '(gut/viel/gern), and choose als vs wie.',
  tips: _comparisonTips,
);

/// M10 — Comparisons, in module order.
final List<QuizContent> enDeM10 = [
  enDeM10Forms,
  enDeM10AlsWie,
  enDeM10BigTextWarmup,
  enDeM10Reading,
  enDeM10Speak,
  enDeM10Listening,
  enDeM10BigText,
];
