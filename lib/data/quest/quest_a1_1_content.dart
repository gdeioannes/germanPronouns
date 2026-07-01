import '../../models/quiz_content.dart';
import 'quest_builders.dart';

/// CEFR **A1.1 — "Erste Schritte"** Quest quizzes, authored as serializable
/// [QuizContent] so they seed into the database, are editable in the back
/// office, and run on the shared quiz engine (see `buildQuizConfigFromContent`).
///
/// All quizzes here use the engine's default answer path: the correct answer
/// for a (subject, category) is that category's value, and a per-category
/// [QuizContent.sentenceTemplates] entry renders a clean fill-in prompt. None
/// store per-sentence `acceptedAnswers` (mixing the two breaks template
/// prompts — see the adapter), so any quiz needing multiple accepted forms is
/// authored with explicit sentences instead (see A1.2's Uhrzeit).

/// Builds a single-category "translate / spell this" quiz from [pairs]
/// (subject → the one correct answer). [template] is the fill-in prompt and
/// must contain a `____` blank; `{subject}` is replaced with the subject.
QuizContent vocabQuestQuiz({
  required String id,
  required String title,
  required String promptLabel,
  required String subjectsLabel,
  required String subjectColumnLabel,
  required String categoryLabel,
  required List<MapEntry<String, String>> pairs,
  required String template,
  String? intro,
  List<HelpMemoryTip> tips = const [],
}) {
  return QuizContent(
    id: id,
    title: title,
    storageKeyPrefix: '${id}_',
    promptLabel: promptLabel,
    subjectsLabel: subjectsLabel,
    subjectColumnLabel: subjectColumnLabel,
    subjects: [
      for (final p in pairs) QuizSubjectData(key: p.key, display: p.key),
    ],
    categories: [
      QuizCategoryData(
        label: categoryLabel,
        group: categoryLabel,
        values: [for (final p in pairs) p.value],
      ),
    ],
    sentences: const [],
    sentenceTemplates: {
      categoryLabel: [template],
    },
    helpMemoryIntro: intro,
    helpMemoryTips: tips,
  );
}

/// 1a. Zahlen 0–10 — write the number out in German.
final QuizContent questZahlen1Content = vocabQuestQuiz(
  id: 'quest_a1_1_zahlen',
  title: 'A1.1 · Zahlen 0–10',
  promptLabel: 'Zahl',
  subjectsLabel: 'Zahlen',
  subjectColumnLabel: 'Zahl',
  categoryLabel: 'Auf Deutsch',
  template: '{subject} = ____',
  pairs: const [
    MapEntry('0', 'null'),
    MapEntry('1', 'eins'),
    MapEntry('2', 'zwei'),
    MapEntry('3', 'drei'),
    MapEntry('4', 'vier'),
    MapEntry('5', 'fünf'),
    MapEntry('6', 'sechs'),
    MapEntry('7', 'sieben'),
    MapEntry('8', 'acht'),
    MapEntry('9', 'neun'),
    MapEntry('10', 'zehn'),
  ],
  intro: 'The numbers 0–10 are the foundation — every larger number is built '
      'from them, so learn to say and spell each one by heart.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: 'Tricky spellings',
      text: 'Watch zwei, drei, sechs and sieben. Note "eins" when counting, '
          'but "ein" before a noun (ein Apfel).',
    ),
  ],
);

/// 1b. Zahlen 11–20 — the teens (note sechzehn/siebzehn drop letters).
final QuizContent questZahlen2Content = vocabQuestQuiz(
  id: 'quest_a1_1_zahlen2',
  title: 'A1.1 · Zahlen 11–20',
  promptLabel: 'Zahl',
  subjectsLabel: 'Zahlen',
  subjectColumnLabel: 'Zahl',
  categoryLabel: 'Auf Deutsch',
  template: '{subject} = ____',
  pairs: const [
    MapEntry('11', 'elf'),
    MapEntry('12', 'zwölf'),
    MapEntry('13', 'dreizehn'),
    MapEntry('14', 'vierzehn'),
    MapEntry('15', 'fünfzehn'),
    MapEntry('16', 'sechzehn'),
    MapEntry('17', 'siebzehn'),
    MapEntry('18', 'achtzehn'),
    MapEntry('19', 'neunzehn'),
    MapEntry('20', 'zwanzig'),
  ],
  intro: 'The teens (13–19) follow one simple pattern — unit + "zehn" — with a '
      'couple of spellings to watch.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Pattern: unit + zehn',
      text: 'vier + zehn = vierzehn, acht + zehn = achtzehn.',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: 'Exceptions',
      text: '16 = sechzehn (drops the -s), 17 = siebzehn (drops the -en). '
          '11 = elf and 12 = zwölf are irregular.',
    ),
  ],
);

/// 1c. Zahlen 20–100 — the tens and compound numbers (einundzwanzig …).
final QuizContent questZahlen3Content = vocabQuestQuiz(
  id: 'quest_a1_1_zahlen3',
  title: 'A1.1 · Zahlen 20–100',
  promptLabel: 'Zahl',
  subjectsLabel: 'Zahlen',
  subjectColumnLabel: 'Zahl',
  categoryLabel: 'Auf Deutsch',
  template: '{subject} = ____',
  pairs: const [
    MapEntry('20', 'zwanzig'),
    MapEntry('21', 'einundzwanzig'),
    MapEntry('22', 'zweiundzwanzig'),
    MapEntry('25', 'fünfundzwanzig'),
    MapEntry('30', 'dreißig'),
    MapEntry('33', 'dreiunddreißig'),
    MapEntry('40', 'vierzig'),
    MapEntry('47', 'siebenundvierzig'),
    MapEntry('50', 'fünfzig'),
    MapEntry('58', 'achtundfünfzig'),
    MapEntry('60', 'sechzig'),
    MapEntry('64', 'vierundsechzig'),
    MapEntry('70', 'siebzig'),
    MapEntry('76', 'sechsundsiebzig'),
    MapEntry('80', 'achtzig'),
    MapEntry('89', 'neunundachtzig'),
    MapEntry('90', 'neunzig'),
    MapEntry('99', 'neunundneunzig'),
    MapEntry('100', 'hundert'),
  ],
  intro: 'From 21 upward, German names the units BEFORE the tens, joined by '
      '"und" and written as one word.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Units first',
      text: '21 = ein + und + zwanzig = einundzwanzig. Read it right-to-left: '
          'the last digit comes first.',
    ),
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'It is "ein", not "eins"',
      text: 'Before "und" the 1 loses its -s: einundzwanzig, einunddreißig.',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: 'Tens spelling',
      text: 'zwanzig, dreißig (ß!), vierzig, fünfzig, sechzig, siebzig, '
          'achtzig, neunzig, (ein)hundert.',
    ),
  ],
);

/// 2. Personalpronomen im Nominativ — fill the subject pronoun in context.
final QuizContent questPronomenContent = sentenceQuestQuiz(
  id: 'quest_a1_1_pronomen',
  title: 'A1.1 · Personalpronomen',
  promptLabel: 'Welches Pronomen?',
  subjectsLabel: 'Pronomen',
  subjectColumnLabel: 'English',
  categoryLabel: 'Welches Pronomen?',
  contextualLayout: true,
  items: const [
    QuestSentenceItem(
      sentence: '____ bin müde. (I)',
      answer: 'ich',
      english: '____ am tired. (I)',
      gloss: 'I',
    ),
    QuestSentenceItem(
      sentence: '____ bist mein Freund. (you, informal)',
      answer: 'du',
      english: '____ are my friend. (you, informal)',
      gloss: 'you (informal)',
    ),
    QuestSentenceItem(
      sentence: 'Das ist Tom. ____ ist groß. (he)',
      answer: 'er',
      english: 'That is Tom. ____ is tall. (he)',
      gloss: 'he',
    ),
    QuestSentenceItem(
      sentence: 'Das ist Anna. ____ ist nett. (she)',
      answer: 'sie',
      english: 'That is Anna. ____ is nice. (she)',
      gloss: 'she',
    ),
    QuestSentenceItem(
      sentence: 'Das ist das Kind. ____ spielt. (it)',
      answer: 'es',
      english: 'That is the child. ____ plays. (it)',
      gloss: 'it',
    ),
    QuestSentenceItem(
      sentence: 'Anna und ich lernen Deutsch. ____ sind Studenten.',
      answer: 'wir',
      english: 'Anna and I study German. ____ are students.',
      gloss: 'we',
    ),
    QuestSentenceItem(
      sentence: '____ seid meine Freunde. (you, plural)',
      answer: 'ihr',
      english: '____ are my friends. (you all)',
      gloss: 'you (plural)',
    ),
    QuestSentenceItem(
      sentence: 'Das sind Tom und Anna. ____ kommen aus Berlin. (they)',
      answer: 'sie',
      english: 'Those are Tom and Anna. ____ come from Berlin. (they)',
      gloss: 'they',
    ),
    QuestSentenceItem(
      sentence: '____ sind sehr nett, Herr Müller. (you, formal)',
      answer: 'Sie',
      english: '____ are very kind, Mr Müller. (you, formal)',
      gloss: 'you (formal)',
    ),
  ],
  intro: 'Subject (nominative) pronouns say who does the action. Read the '
      'sentence — the verb ending and the English hint tell you which one '
      'fits.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '"sie" is three things',
      text: 'sie = she, sie = they, and Sie (always capitalized) = you '
          '(formal). The verb ending and context tell them apart.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'du vs. Sie',
      text: 'Use du with friends, family and children; Sie with strangers, '
          'elders and in formal settings.',
    ),
  ],
);

/// 6. Farben — name the colour from a clue.
final QuizContent questFarbenContent = sentenceQuestQuiz(
  id: 'quest_a1_1_farben',
  title: 'A1.1 · Farben',
  promptLabel: 'Welche Farbe?',
  subjectsLabel: 'Farben',
  subjectColumnLabel: 'English',
  categoryLabel: 'Welche Farbe?',
  contextualLayout: true,
  items: const [
    QuestSentenceItem(
      sentence: 'Die Farbe von Blut und Erdbeeren ist ____.',
      answer: 'rot',
      english: 'The colour of blood and strawberries is ____ (red).',
    ),
    QuestSentenceItem(
      sentence: 'Die Farbe vom Himmel ist ____.',
      answer: 'blau',
      english: 'The colour of the sky is ____ (blue).',
    ),
    QuestSentenceItem(
      sentence: 'Die Farbe von Gras und Blättern ist ____.',
      answer: 'grün',
      english: 'The colour of grass and leaves is ____ (green).',
    ),
    QuestSentenceItem(
      sentence: 'Die Farbe von der Sonne und Bananen ist ____.',
      answer: 'gelb',
      english: 'The colour of the sun and bananas is ____ (yellow).',
    ),
    QuestSentenceItem(
      sentence: 'Die Farbe von der Nacht ist ____.',
      answer: 'schwarz',
      english: 'The colour of the night is ____ (black).',
    ),
    QuestSentenceItem(
      sentence: 'Die Farbe von Schnee und Milch ist ____.',
      answer: 'weiß',
      english: 'The colour of snow and milk is ____ (white).',
      accepted: ['weiss'],
    ),
    QuestSentenceItem(
      sentence: 'Die Farbe von einer Orange und Karotten ist ____.',
      answer: 'orange',
      english: 'The colour of an orange and carrots is ____ (orange).',
    ),
    QuestSentenceItem(
      sentence: 'Die Farbe von Schokolade und Holz ist ____.',
      answer: 'braun',
      english: 'The colour of chocolate and wood is ____ (brown).',
    ),
    QuestSentenceItem(
      sentence: 'Die Farbe von einem Elefanten und Wolken ist ____.',
      answer: 'grau',
      english: 'The colour of an elephant and clouds is ____ (grey).',
    ),
    QuestSentenceItem(
      sentence: 'Eine helle Mischung aus Rot und Weiß ist ____.',
      answer: 'rosa',
      english: 'A light mix of red and white is ____ (pink).',
    ),
    QuestSentenceItem(
      sentence: 'Die Farbe von einer Aubergine ist ____.',
      answer: 'lila',
      english: 'The colour of an aubergine is ____ (purple).',
    ),
    QuestSentenceItem(
      sentence: 'Viele Farben zusammen (ein Regenbogen) sind ____.',
      answer: 'bunt',
      english: 'Many colours together (a rainbow) are ____ (colourful).',
    ),
  ],
  intro: 'Read the clue and name the colour. Colours are adjectives: on their '
      'own (after sein) they stay in this base form; before a noun they take an '
      'ending (ein rotes Auto).',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      text: 'Das Auto ist rot. (base form)   →   ein rotes Auto. (with ending)',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: 'No endings ever',
      text: 'rosa, lila and orange never change: ein rosa Kleid, ein lila Hut.',
    ),
  ],
);

/// 7. Familie & Menschen — read a clue, name the person *with their article*.
final QuizContent questFamilieContent = sentenceQuestQuiz(
  id: 'quest_a1_1_familie',
  title: 'A1.1 · Familie & Menschen',
  promptLabel: 'Wer ist das?',
  subjectsLabel: 'Wörter',
  subjectColumnLabel: 'English',
  categoryLabel: 'Wer ist das?',
  contextualLayout: true,
  items: const [
    QuestSentenceItem(
      sentence: 'Eine Frau mit einem Kind ist ____.',
      answer: 'die Mutter',
      english: 'A woman with a child is ____ (the mother).',
      accepted: ['Mutter', 'eine Mutter'],
    ),
    QuestSentenceItem(
      sentence: 'Ein Mann mit einem Kind ist ____.',
      answer: 'der Vater',
      english: 'A man with a child is ____ (the father).',
      accepted: ['Vater', 'ein Vater'],
    ),
    QuestSentenceItem(
      sentence: 'Der andere Sohn meiner Eltern ist ____.',
      answer: 'der Bruder',
      english: "My parents' other son is ____ (my brother).",
      accepted: ['Bruder', 'ein Bruder', 'mein Bruder'],
    ),
    QuestSentenceItem(
      sentence: 'Die andere Tochter meiner Eltern ist ____.',
      answer: 'die Schwester',
      english: "My parents' other daughter is ____ (my sister).",
      accepted: ['Schwester', 'eine Schwester', 'meine Schwester'],
    ),
    QuestSentenceItem(
      sentence: 'Das männliche Kind der Familie ist ____.',
      answer: 'der Sohn',
      english: "The family's male child is ____ (the son).",
      accepted: ['Sohn', 'ein Sohn'],
    ),
    QuestSentenceItem(
      sentence: 'Das weibliche Kind der Familie ist ____.',
      answer: 'die Tochter',
      english: "The family's female child is ____ (the daughter).",
      accepted: ['Tochter', 'eine Tochter'],
    ),
    QuestSentenceItem(
      sentence: 'Der Vater meines Vaters ist ____.',
      answer: 'der Großvater',
      english: "My father's father is ____ (the grandfather).",
      accepted: ['Großvater', 'ein Großvater', 'der Opa', 'Opa'],
    ),
    QuestSentenceItem(
      sentence: 'Die Mutter meiner Mutter ist ____.',
      answer: 'die Großmutter',
      english: "My mother's mother is ____ (the grandmother).",
      accepted: ['Großmutter', 'eine Großmutter', 'die Oma', 'Oma'],
    ),
    QuestSentenceItem(
      sentence: 'Ein Junge oder ein Mädchen ist ____.',
      answer: 'das Kind',
      english: 'A boy or a girl is ____ (a child).',
      accepted: ['Kind', 'ein Kind'],
    ),
    QuestSentenceItem(
      sentence: 'Eine erwachsene männliche Person ist ____.',
      answer: 'der Mann',
      english: 'An adult male person is ____ (the man).',
      accepted: ['Mann', 'ein Mann'],
    ),
    QuestSentenceItem(
      sentence: 'Eine erwachsene weibliche Person ist ____.',
      answer: 'die Frau',
      english: 'An adult female person is ____ (the woman).',
      accepted: ['Frau', 'eine Frau'],
    ),
    QuestSentenceItem(
      sentence: 'Ein männliches Kind ist ____.',
      answer: 'der Junge',
      english: 'A male child is ____ (a boy).',
      accepted: ['Junge', 'ein Junge'],
    ),
    QuestSentenceItem(
      sentence: 'Ein weibliches Kind ist ____.',
      answer: 'das Mädchen',
      english: 'A female child is ____ (a girl).',
      accepted: ['Mädchen', 'ein Mädchen'],
    ),
    QuestSentenceItem(
      sentence: 'Eltern und Kinder zusammen sind ____.',
      answer: 'die Familie',
      english: 'Parents and children together are ____ (a family).',
      accepted: ['Familie', 'eine Familie'],
    ),
    QuestSentenceItem(
      sentence: 'Eine männliche Person, die du magst, ist ____.',
      answer: 'der Freund',
      english: 'A male person you like is ____ (a friend).',
      accepted: ['Freund', 'ein Freund'],
    ),
    QuestSentenceItem(
      sentence: 'Eine weibliche Person, die du magst, ist ____.',
      answer: 'die Freundin',
      english: 'A female person you like is ____ (a friend).',
      accepted: ['Freundin', 'eine Freundin'],
    ),
  ],
  intro: 'Read the clue (and its English translation), then write the family '
      'word — with its article der/die/das, since the gender is part of the '
      'word. "die Mutter" or just "Mutter" both count.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Female forms end in -in',
      text: 'der Freund → die Freundin; der Lehrer → die Lehrerin. Many '
          'people-words form the female this way.',
    ),
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'Color code',
      text: 'der = blue, die = red, das = green — the same across the app.',
    ),
  ],
);

/// Subject pronouns shared by the conjugation quizzes (key == display).
const List<String> _conjugationPronouns = [
  'ich',
  'du',
  'er/sie/es',
  'wir',
  'ihr',
  'sie/Sie',
];

/// 3. *sein* & *haben* — conjugate the two key verbs in the present tense.
final QuizContent questSeinHabenContent = QuizContent(
  id: 'quest_a1_1_sein_haben',
  title: 'A1.1 · sein & haben',
  storageKeyPrefix: 'quest_a1_1_sein_haben_',
  promptLabel: 'Pronomen',
  subjectsLabel: 'Pronomen',
  subjectColumnLabel: 'Pronomen',
  subjects: [for (final p in _conjugationPronouns) QuizSubjectData(key: p, display: p)],
  categories: const [
    QuizCategoryData(
      label: 'sein (to be)',
      group: 'sein',
      values: ['bin', 'bist', 'ist', 'sind', 'seid', 'sind'],
    ),
    QuizCategoryData(
      label: 'haben (to have)',
      group: 'haben',
      values: ['habe', 'hast', 'hat', 'haben', 'habt', 'haben'],
    ),
  ],
  sentences: const [],
  sentenceTemplates: const {
    'sein (to be)': ['{subject} ____ . (sein)'],
    'haben (to have)': ['{subject} ____ . (haben)'],
  },
  helpMemoryIntro:
      'sein (to be) and haben (to have) are the two most important verbs in '
      'German — you use them constantly, and later to build the perfect tense. '
      'Both are irregular, so memorize the full set.',
  helpMemoryTips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: 'sein is fully irregular',
      text: 'bin, bist, ist, sind, seid, sind — there is no pattern, so learn '
          'it by heart.',
    ),
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'haben loses its -b-',
      text: 'Only du hast and er/sie/es hat drop the -b-; the rest keep it '
          '(habe, haben, habt, haben).',
    ),
  ],
);

/// 4. Regelmäßige Verben — conjugate a regular verb for the shown person.
/// Subjects are the verbs; categories are the six persons; the value is the
/// conjugated form. `arbeiten`/`finden` carry the extra `-e-` (du arbeitest).
const List<String> _regularVerbs = [
  'machen',
  'wohnen',
  'spielen',
  'lernen',
  'kaufen',
  'kommen',
  'gehen',
  'hören',
  'arbeiten',
  'finden',
];

QuizCategoryData _personColumn(String label, String group, List<String> forms) =>
    QuizCategoryData(label: label, group: group, values: forms);

final QuizContent questPraesensContent = QuizContent(
  id: 'quest_a1_1_praesens',
  title: 'A1.1 · Regelmäßige Verben (Präsens)',
  storageKeyPrefix: 'quest_a1_1_praesens_',
  promptLabel: 'Verb',
  subjectsLabel: 'Verben',
  subjectColumnLabel: 'Verb (Infinitiv)',
  subjects: [for (final v in _regularVerbs) QuizSubjectData(key: v, display: v)],
  categories: [
    _personColumn('ich', 'ich', const [
      'mache', 'wohne', 'spiele', 'lerne', 'kaufe',
      'komme', 'gehe', 'höre', 'arbeite', 'finde',
    ]),
    _personColumn('du', 'du', const [
      'machst', 'wohnst', 'spielst', 'lernst', 'kaufst',
      'kommst', 'gehst', 'hörst', 'arbeitest', 'findest',
    ]),
    _personColumn('er/sie/es', 'er/sie/es', const [
      'macht', 'wohnt', 'spielt', 'lernt', 'kauft',
      'kommt', 'geht', 'hört', 'arbeitet', 'findet',
    ]),
    _personColumn('wir', 'wir', const [
      'machen', 'wohnen', 'spielen', 'lernen', 'kaufen',
      'kommen', 'gehen', 'hören', 'arbeiten', 'finden',
    ]),
    _personColumn('ihr', 'ihr', const [
      'macht', 'wohnt', 'spielt', 'lernt', 'kauft',
      'kommt', 'geht', 'hört', 'arbeitet', 'findet',
    ]),
    _personColumn('sie/Sie', 'sie/Sie', const [
      'machen', 'wohnen', 'spielen', 'lernen', 'kaufen',
      'kommen', 'gehen', 'hören', 'arbeiten', 'finden',
    ]),
  ],
  sentences: const [],
  sentenceTemplates: const {
    'ich': ['Ich ____ . ({subject})'],
    'du': ['Du ____ . ({subject})'],
    'er/sie/es': ['Er ____ . ({subject})'],
    'wir': ['Wir ____ . ({subject})'],
    'ihr': ['Ihr ____ . ({subject})'],
    'sie/Sie': ['Sie ____ . ({subject})'],
  },
  helpMemoryIntro:
      'Regular verbs in the present tense use the stem (the infinitive minus '
      '-en) plus an ending that matches the subject.',
  helpMemoryTips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Present-tense endings',
      text: 'ich -e, du -st, er/sie/es -t, wir -en, ihr -t, sie/Sie -en.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Extra -e- after -t/-d',
      text: 'If the stem ends in -t or -d, add -e- before -st/-t: '
          'du arbeitest, er arbeitet, ihr findet.',
    ),
  ],
);

/// 4b. Unregelmäßige Verben (Vokalwechsel) — the very common stem-changing
/// verbs. Only the du and er/sie/es forms shift the stem vowel (a→ä, e→i, e→ie);
/// every ending stays regular. Subjects are the verbs; categories are the six
/// persons. Authored right after the regular verbs so the contrast is fresh.
const List<String> _stemChangingVerbs = [
  'fahren',
  'schlafen',
  'lesen',
  'sehen',
  'sprechen',
  'essen',
  'nehmen',
  'geben',
];

final QuizContent questVokalwechselContent = QuizContent(
  id: 'quest_a1_1_vokalwechsel',
  title: 'A1.1 · Unregelmäßige Verben (Vokalwechsel)',
  storageKeyPrefix: 'quest_a1_1_vokalwechsel_',
  promptLabel: 'Verb',
  subjectsLabel: 'Verben',
  subjectColumnLabel: 'Verb (Infinitiv)',
  subjects: [
    for (final v in _stemChangingVerbs) QuizSubjectData(key: v, display: v),
  ],
  categories: [
    _personColumn('ich', 'ich', const [
      'fahre', 'schlafe', 'lese', 'sehe', 'spreche', 'esse', 'nehme', 'gebe',
    ]),
    _personColumn('du', 'du', const [
      'fährst', 'schläfst', 'liest', 'siehst', 'sprichst', 'isst', 'nimmst',
      'gibst',
    ]),
    _personColumn('er/sie/es', 'er/sie/es', const [
      'fährt', 'schläft', 'liest', 'sieht', 'spricht', 'isst', 'nimmt', 'gibt',
    ]),
    _personColumn('wir', 'wir', const [
      'fahren', 'schlafen', 'lesen', 'sehen', 'sprechen', 'essen', 'nehmen',
      'geben',
    ]),
    _personColumn('ihr', 'ihr', const [
      'fahrt', 'schlaft', 'lest', 'seht', 'sprecht', 'esst', 'nehmt', 'gebt',
    ]),
    _personColumn('sie/Sie', 'sie/Sie', const [
      'fahren', 'schlafen', 'lesen', 'sehen', 'sprechen', 'essen', 'nehmen',
      'geben',
    ]),
  ],
  sentences: const [],
  sentenceTemplates: const {
    'ich': ['Ich ____ . ({subject})'],
    'du': ['Du ____ . ({subject})'],
    'er/sie/es': ['Er ____ . ({subject})'],
    'wir': ['Wir ____ . ({subject})'],
    'ihr': ['Ihr ____ . ({subject})'],
    'sie/Sie': ['Sie ____ . ({subject})'],
  },
  helpMemoryIntro:
      'A handful of very common verbs change their stem vowel in the present '
      'tense — but ONLY in the du and er/sie/es forms. The endings stay '
      'perfectly regular; just the vowel shifts. Master these eight and you have '
      'most of the A1 irregular verbs.',
  helpMemoryTips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Only du & er/sie/es change',
      text: 'ich, wir, ihr and sie/Sie keep the infinitive stem (ich fahre, wir '
          'fahren). Only du and er/sie/es shift the vowel (du fährst, er fährt).',
    ),
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'Three shifts: a→ä, e→i, e→ie',
      text: 'a→ä: fahren → du fährst. e→i: sprechen → du sprichst, essen → du '
          'isst. e→ie: lesen → du liest, sehen → du siehst.',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: 'nehmen is extra irregular',
      text: 'nehmen doubles the m and drops the h: du nimmst, er nimmt. Worth '
          'learning on its own.',
    ),
  ],
);

/// One A1 noun used in the article quizzes, with its gender.
class _ArtikelNoun {
  const _ArtikelNoun(this.noun, this.gender, this.english);
  final String noun;
  final String gender; // 'm' / 'f' / 'n'
  final String english;
}

const List<_ArtikelNoun> _questArtikelNouns = [
  _ArtikelNoun('Mann', 'm', 'man'),
  _ArtikelNoun('Tisch', 'm', 'table'),
  _ArtikelNoun('Stuhl', 'm', 'chair'),
  _ArtikelNoun('Hund', 'm', 'dog'),
  _ArtikelNoun('Apfel', 'm', 'apple'),
  _ArtikelNoun('Ball', 'm', 'ball'),
  _ArtikelNoun('Computer', 'm', 'computer'),
  _ArtikelNoun('Schlüssel', 'm', 'key'),
  _ArtikelNoun('Frau', 'f', 'woman'),
  _ArtikelNoun('Lampe', 'f', 'lamp'),
  _ArtikelNoun('Tür', 'f', 'door'),
  _ArtikelNoun('Katze', 'f', 'cat'),
  _ArtikelNoun('Banane', 'f', 'banana'),
  _ArtikelNoun('Tasche', 'f', 'bag'),
  _ArtikelNoun('Uhr', 'f', 'clock'),
  _ArtikelNoun('Kind', 'n', 'child'),
  _ArtikelNoun('Haus', 'n', 'house'),
  _ArtikelNoun('Auto', 'n', 'car'),
  _ArtikelNoun('Buch', 'n', 'book'),
  _ArtikelNoun('Fenster', 'n', 'window'),
  _ArtikelNoun('Brot', 'n', 'bread'),
];

const Map<String, String> _definiteNominative = {'m': 'der', 'f': 'die', 'n': 'das'};
const Map<String, String> _indefiniteNominative = {'m': 'ein', 'f': 'eine', 'n': 'ein'};

/// 5. Artikel im Nominativ — der/die/das and ein/eine for A1 nouns.
final QuizContent questArtikelContent = QuizContent(
  id: 'quest_a1_1_artikel',
  title: 'A1.1 · Artikel im Nominativ',
  storageKeyPrefix: 'quest_a1_1_artikel_',
  promptLabel: 'Nomen',
  subjectsLabel: 'Nomen',
  subjectColumnLabel: 'Nomen',
  subjects: [
    for (final n in _questArtikelNouns)
      QuizSubjectData(
        key: n.noun,
        display: n.noun,
        english: n.english,
        gender: n.gender,
      ),
  ],
  categories: [
    QuizCategoryData(
      label: 'bestimmt (der/die/das)',
      group: 'bestimmt',
      values: [for (final n in _questArtikelNouns) _definiteNominative[n.gender]!],
    ),
    QuizCategoryData(
      label: 'unbestimmt (ein/eine)',
      group: 'unbestimmt',
      values: [for (final n in _questArtikelNouns) _indefiniteNominative[n.gender]!],
    ),
  ],
  sentences: const [],
  sentenceTemplates: const {
    'bestimmt (der/die/das)': ['____ {subject} ist hier.'],
    'unbestimmt (ein/eine)': ['Das ist ____ {subject}.'],
  },
  helpMemoryColorByGender: true,
  helpMemoryIntro:
      'In the nominative (the subject of the sentence) use der/die/das for '
      '"the" (definite) or ein/eine for "a/an" (indefinite). The form depends '
      "on the noun's gender.",
  helpMemoryTips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Indefinite article',
      text: 'ein for masculine and neuter (der-/das-words), eine for feminine '
          '(die-words). Plural has no indefinite article.',
    ),
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'Color code',
      text: 'der = blue, die = red, das = green.',
    ),
  ],
);

/// 8. W-Fragen — pick the right question word for what is being asked.
final QuizContent questWFragenContent = sentenceQuestQuiz(
  id: 'quest_a1_1_wfragen',
  title: 'A1.1 · W-Fragen',
  promptLabel: 'Welches Fragewort?',
  subjectsLabel: 'Fragewörter',
  subjectColumnLabel: 'English',
  categoryLabel: 'Welches Fragewort?',
  contextualLayout: true,
  items: const [
    QuestSentenceItem(
      sentence: 'Du fragst nach einer Person: ____ ist das?',
      answer: 'wer',
      english: 'You ask about a person: ____ is that? (who)',
    ),
    QuestSentenceItem(
      sentence: 'Du fragst nach einer Sache: ____ ist das?',
      answer: 'was',
      english: 'You ask about a thing: ____ is that? (what)',
    ),
    QuestSentenceItem(
      sentence: 'Du fragst nach dem Ort: ____ wohnst du?',
      answer: 'wo',
      english: 'You ask about the place: ____ do you live? (where)',
    ),
    QuestSentenceItem(
      sentence: 'Du fragst nach dem Ziel: ____ gehst du?',
      answer: 'wohin',
      english: 'You ask about the destination: ____ are you going? (where to)',
    ),
    QuestSentenceItem(
      sentence: 'Du fragst nach der Herkunft: ____ kommst du?',
      answer: 'woher',
      english: 'You ask about origin: ____ do you come from? (where from)',
    ),
    QuestSentenceItem(
      sentence: 'Du fragst nach der Zeit: ____ beginnt der Film?',
      answer: 'wann',
      english: 'You ask about time: ____ does the film start? (when)',
    ),
    QuestSentenceItem(
      sentence: 'Du fragst nach dem Befinden: ____ geht es dir?',
      answer: 'wie',
      english: 'You ask how someone is: ____ are you? (how)',
    ),
    QuestSentenceItem(
      sentence: 'Du fragst nach dem Grund: ____ lernst du Deutsch?',
      answer: 'warum',
      english: 'You ask about the reason: ____ are you learning German? (why)',
    ),
    QuestSentenceItem(
      sentence: 'Du fragst nach dem Preis: ____ kostet das?',
      answer: 'wie viel',
      english: 'You ask about the price: ____ does that cost? (how much)',
      accepted: ['wieviel'],
    ),
    QuestSentenceItem(
      sentence: 'Du fragst nach der Anzahl: ____ Personen kommen?',
      answer: 'wie viele',
      english: 'You ask about the number: ____ people are coming? (how many)',
    ),
  ],
  intro: 'W-questions start with a question word (almost all begin with "w-") '
      'followed by the verb in second position: Wo wohnst du? They ask for '
      'specific information, unlike yes/no questions.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Word order',
      text: 'Question word + verb + subject: Wann kommst du? Woher kommt sie?',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: 'wo / wohin / woher',
      text: 'wo = where (location), wohin = where to (direction), woher = where '
          'from (origin). Three different words in German.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'wie in combinations',
      text: 'wie viel = how much, wie viele = how many, wie alt = how old, '
          'wie spät = what time.',
    ),
  ],
);

/// Speaking 1 — Begrüßung & Vorstellung: greet people and introduce yourself.
final QuizContent questSpeakBegruessungContent = speakQuestQuiz(
  id: 'quest_a1_1_sprechen_vorstellung',
  title: 'A1.1 · Sprechen: Vorstellung',
  promptLabel: 'Satz',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Deutsch',
  intro: 'Listen to each phrase in German and repeat it aloud. If your '
      'microphone is available we tell you how it sounded; if not, just listen '
      'and repeat at your own pace, then continue. These are the first things '
      'you say when you meet someone.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Copy the rhythm',
      text: 'Do not chase every single sound — imitate the melody and stress of '
          'the whole phrase. It will sound far more natural.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'The "ei" and "ie"',
      text: '"heiße" sounds like "high-sse"; "Wie" sounds like "vee". German '
          '"w" is an English "v".',
    ),
  ],
  phrases: const [
    SpeakPhrase(phrase: 'Hallo!', meaning: 'Hello!'),
    SpeakPhrase(phrase: 'Guten Tag!', meaning: 'Good day!'),
    SpeakPhrase(phrase: 'Tschüss!', meaning: 'Bye!'),
    SpeakPhrase(phrase: 'Danke!', meaning: 'Thank you!'),
    SpeakPhrase(phrase: 'Ich heiße Anna.', meaning: 'My name is Anna.'),
    SpeakPhrase(phrase: 'Wie heißt du?', meaning: "What's your name?"),
    SpeakPhrase(phrase: 'Freut mich.', meaning: 'Nice to meet you.'),
    SpeakPhrase(phrase: 'Ich komme aus Spanien.', meaning: 'I come from Spain.'),
    SpeakPhrase(phrase: 'Woher kommst du?', meaning: 'Where are you from?'),
    SpeakPhrase(phrase: 'Ich wohne in Berlin.', meaning: 'I live in Berlin.'),
    SpeakPhrase(
      phrase: 'Wie geht es Ihnen?',
      meaning: 'How are you? (formal)',
    ),
    SpeakPhrase(
      phrase: 'Ich spreche ein bisschen Deutsch.',
      meaning: 'I speak a little German.',
    ),
  ],
);

/// Speaking 2 — Zahlen & Preise: say numbers and prices aloud.
final QuizContent questSpeakZahlenContent = speakQuestQuiz(
  id: 'quest_a1_1_sprechen_zahlen',
  title: 'A1.1 · Sprechen: Zahlen & Preise',
  promptLabel: 'Wort',
  subjectsLabel: 'Wörter',
  subjectColumnLabel: 'Deutsch',
  intro: 'Say the numbers and prices out loud. Being able to say them helps '
      'with prices, platforms and room numbers. Listen and repeat each one.',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: 'The "z" and "ei"',
      text: '"zwei" sounds like "tsvai" and "zwanzig" like "tsvan-tsig". German '
          '"z" is always "ts".',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Prices',
      text: '"3,50 €" is said "drei Euro fünfzig": first the euros, then the '
          'cents.',
    ),
  ],
  phrases: const [
    SpeakPhrase(phrase: 'null', meaning: 'zero (0)'),
    SpeakPhrase(phrase: 'eins', meaning: 'one (1)'),
    SpeakPhrase(phrase: 'zwei', meaning: 'two (2)'),
    SpeakPhrase(phrase: 'drei', meaning: 'three (3)'),
    SpeakPhrase(phrase: 'vier', meaning: 'four (4)'),
    SpeakPhrase(phrase: 'fünf', meaning: 'five (5)'),
    SpeakPhrase(phrase: 'sechs', meaning: 'six (6)'),
    SpeakPhrase(phrase: 'sieben', meaning: 'seven (7)'),
    SpeakPhrase(phrase: 'acht', meaning: 'eight (8)'),
    SpeakPhrase(phrase: 'neun', meaning: 'nine (9)'),
    SpeakPhrase(phrase: 'zehn', meaning: 'ten (10)'),
    SpeakPhrase(phrase: 'zwanzig', meaning: 'twenty (20)'),
    SpeakPhrase(phrase: 'einundzwanzig', meaning: 'twenty-one (21)'),
    SpeakPhrase(phrase: 'Was kostet das?', meaning: 'How much is that?'),
    SpeakPhrase(
      phrase: 'Das kostet drei Euro fünfzig.',
      meaning: 'That costs 3.50.',
    ),
  ],
);

/// Reading 1 — "Das bin ich" (Daily Life / personal information).
final QuizContent questReadingDasBinIchContent = readingQuestQuiz(
  id: 'quest_a1_1_lesen_dasbinich',
  title: 'A1.1 · Lesen: Das bin ich',
  category: 'Daily Life',
  passageTitle: 'Das bin ich',
  passage:
      'Hallo! Ich heiße Lena Müller. Ich bin dreißig Jahre alt und komme aus '
      'Österreich. Jetzt wohne ich in Hamburg. Ich bin Lehrerin und arbeite an '
      'einer Schule. Ich habe einen Bruder und eine Schwester. Mein Bruder '
      'heißt Tim. Am Wochenende spiele ich gern Tennis und lese viele Bücher. '
      'Am Morgen trinke ich Tee, aber am Nachmittag trinke ich gern Kaffee. '
      'Ich spreche Deutsch und Englisch.',
  passageTranslation:
      'Hi! My name is Lena Müller. I am thirty years old and come from Austria. '
      'Now I live in Hamburg. I am a teacher and work at a school. I have a '
      'brother and a sister. My brother is called Tim. On the weekend I like to '
      'play tennis and read a lot of books. In the morning I drink tea, but in '
      'the afternoon I like to drink coffee. I speak German and English.',
  questions: const [
    ReadingQuestion(
      question: 'Wie alt ist Lena?',
      questionTranslation: 'How old is Lena?',
      options: ['dreizehn', 'dreißig', 'dreiundzwanzig'],
      optionsTranslation: ['thirteen', 'thirty', 'twenty-three'],
      correctIndex: 1,
      explanation: '"Ich bin dreißig Jahre alt" — she is thirty (30).',
    ),
    ReadingQuestion(
      question: 'Woher kommt Lena?',
      questionTranslation: 'Where is Lena from?',
      options: ['aus Deutschland', 'aus der Schweiz', 'aus Österreich'],
      optionsTranslation: ['from Germany', 'from Switzerland', 'from Austria'],
      correctIndex: 2,
      explanation: '"… und komme aus Österreich."',
    ),
    ReadingQuestion(
      question: 'Was ist Lena von Beruf?',
      questionTranslation: "What is Lena's profession?",
      options: ['Ärztin', 'Lehrerin', 'Studentin'],
      optionsTranslation: ['doctor', 'teacher', 'student'],
      correctIndex: 1,
      explanation: '"Ich bin Lehrerin und arbeite an einer Schule."',
    ),
    ReadingQuestion(
      question: 'Was trinkt Lena am Morgen?',
      questionTranslation: 'What does Lena drink in the morning?',
      options: ['Kaffee', 'Tee', 'Wasser'],
      optionsTranslation: ['coffee', 'tea', 'water'],
      correctIndex: 1,
      explanation: '"Am Morgen trinke ich Tee …" — coffee is for the afternoon.',
    ),
    ReadingQuestion(
      question: 'Was macht Lena gern am Wochenende?',
      questionTranslation: 'What does Lena like to do on the weekend?',
      options: ['Tennis spielen', 'schwimmen', 'kochen'],
      optionsTranslation: ['play tennis', 'swim', 'cook'],
      correctIndex: 0,
      explanation: '"Am Wochenende spiele ich gern Tennis …"',
    ),
  ],
  intro: 'Read the short text once, then answer the questions. You can re-read '
      'the passage at any time. Read for the gist first — you do not need to '
      'understand every single word.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Find the key word',
      text: 'Each question has a key word (alt = age, woher = origin, Beruf = '
          'job). Scan the text for it instead of reading everything again.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Guess from context',
      text: 'Unknown word? The sentence around it usually tells you enough. '
          'A1 reading is about understanding the main idea.',
    ),
  ],
);

/// Listening 1 — Begrüßung & Vorstellung: a short self-introduction the learner
/// only HEARS (TTS reads it; the text is hidden behind the info button). Kept
/// deliberately distinct from the "Das bin ich" reading so the two don't overlap.
final QuizContent questHoerenVorstellungContent = listeningQuestQuiz(
  id: 'quest_a1_1_hoeren_vorstellung',
  title: 'A1.1 · Hören: Vorstellung',
  category: 'Daily Life',
  passageTitle: 'Max stellt sich vor',
  passage:
      'Hallo! Ich heiße Max. Ich bin Student und komme aus England. Jetzt wohne '
      'ich in München und lerne Deutsch. Ich bin dreiundzwanzig Jahre alt. Ich '
      'habe einen Hund. Mein Hund heißt Rocky. Am Wochenende spiele ich Fußball '
      'und höre gern Musik. Und wer bist du?',
  passageTranslation:
      'Hello! My name is Max. I am a student and come from England. Now I live '
      'in Munich and I am learning German. I am twenty-three years old. I have a '
      'dog. My dog is called Rocky. On the weekend I play football and like '
      'listening to music. And who are you?',
  questions: const [
    ReadingQuestion(
      question: 'Woher kommt Max?',
      questionTranslation: 'Where is Max from?',
      options: ['aus Deutschland', 'aus England', 'aus Österreich'],
      optionsTranslation: ['from Germany', 'from England', 'from Austria'],
      correctIndex: 1,
      explanation: '"… und komme aus England."',
    ),
    ReadingQuestion(
      question: 'Was macht Max?',
      questionTranslation: 'What does Max do?',
      options: ['Er ist Lehrer.', 'Er ist Student.', 'Er ist Arzt.'],
      optionsTranslation: [
        'He is a teacher.',
        'He is a student.',
        'He is a doctor.',
      ],
      correctIndex: 1,
      explanation: '"Ich bin Student …"',
    ),
    ReadingQuestion(
      question: 'Wie alt ist Max?',
      questionTranslation: 'How old is Max?',
      options: ['dreizehn', 'dreiundzwanzig', 'dreißig'],
      optionsTranslation: ['thirteen', 'twenty-three', 'thirty'],
      correctIndex: 1,
      explanation: '"Ich bin dreiundzwanzig Jahre alt."',
    ),
    ReadingQuestion(
      question: 'Was hat Max?',
      questionTranslation: 'What does Max have?',
      options: ['eine Katze', 'einen Hund', 'ein Auto'],
      optionsTranslation: ['a cat', 'a dog', 'a car'],
      correctIndex: 1,
      explanation: '"Ich habe einen Hund. Mein Hund heißt Rocky."',
    ),
    ReadingQuestion(
      question: 'Wo wohnt Max jetzt?',
      questionTranslation: 'Where does Max live now?',
      options: ['in Berlin', 'in München', 'in Hamburg'],
      optionsTranslation: ['in Berlin', 'in Munich', 'in Hamburg'],
      correctIndex: 1,
      explanation: '"Jetzt wohne ich in München …"',
    ),
    ReadingQuestion(
      question: 'Was macht Max am Wochenende?',
      questionTranslation: 'What does Max do on the weekend?',
      options: [
        'Er spielt Fußball.',
        'Er lernt Englisch.',
        'Er arbeitet.',
      ],
      optionsTranslation: [
        'He plays football.',
        'He studies English.',
        'He works.',
      ],
      correctIndex: 0,
      explanation: '"Am Wochenende spiele ich Fußball und höre gern Musik."',
    ),
    ReadingQuestion(
      question: 'Wie heißt der Hund von Max?',
      questionTranslation: "What is Max's dog called?",
      options: ['Rocky', 'Bello', 'Max'],
      optionsTranslation: ['Rocky', 'Bello', 'Max'],
      correctIndex: 0,
      explanation: '"Mein Hund heißt Rocky."',
    ),
  ],
  intro: 'You will only HEAR this short text — it is not shown. Press play and '
      'listen, then answer the questions. You can replay the audio as often as '
      'you like, and the full text (German + English) is behind "Show text".',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Listen for the W-answers',
      text: 'Each question answers a W-word: woher (origin), was (job), wie alt '
          '(age). Wait for that part instead of trying to catch every word.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Replay is free',
      text: 'Real exams play the audio twice. Use the replay button — listening '
          'again is part of the skill, not cheating.',
    ),
  ],
  // The narrator is Max, a young man, so it is read with a male voice.
  voiceGender: VoiceGender.male,
);

/// Listening 2 — Im Geschäft: Zahlen & Preise: a market seller calling out
/// prices, heard not read. Trains number + price comprehension.
final QuizContent questHoerenZahlenContent = listeningQuestQuiz(
  id: 'quest_a1_1_hoeren_zahlen',
  // A market vendor calling out prices — read with a male voice.
  voiceGender: VoiceGender.male,
  title: 'A1.1 · Hören: Zahlen & Preise',
  category: 'Shopping',
  passageTitle: 'Auf dem Markt',
  passage:
      'Guten Tag und herzlich willkommen auf dem Markt! Heute sind die Äpfel '
      'billig: ein Kilo kostet nur zwei Euro. Die Bananen kosten drei Euro. Ein '
      'Brot kostet einen Euro fünfzig. Möchten Sie auch Eier? Zehn Eier kosten '
      'zwei Euro zwanzig. Vielen Dank und einen schönen Tag!',
  passageTranslation:
      'Good day and welcome to the market! Today the apples are cheap: one kilo '
      'costs only two euros. The bananas cost three euros. A loaf of bread costs '
      'one euro fifty. Would you like eggs too? Ten eggs cost two euros twenty. '
      'Thank you and have a nice day!',
  questions: const [
    ReadingQuestion(
      question: 'Wie viel kostet ein Kilo Äpfel?',
      questionTranslation: 'How much does one kilo of apples cost?',
      options: ['zwei Euro', 'drei Euro', 'ein Euro fünfzig'],
      optionsTranslation: ['two euros', 'three euros', 'one euro fifty'],
      correctIndex: 0,
      explanation: '"… ein Kilo kostet nur zwei Euro."',
    ),
    ReadingQuestion(
      question: 'Was kostet drei Euro?',
      questionTranslation: 'What costs three euros?',
      options: ['die Äpfel', 'die Bananen', 'das Brot'],
      optionsTranslation: ['the apples', 'the bananas', 'the bread'],
      correctIndex: 1,
      explanation: '"Die Bananen kosten drei Euro."',
    ),
    ReadingQuestion(
      question: 'Wie viele Eier kosten zwei Euro zwanzig?',
      questionTranslation: 'How many eggs cost two euros twenty?',
      options: ['fünf', 'zehn', 'zwanzig'],
      optionsTranslation: ['five', 'ten', 'twenty'],
      correctIndex: 1,
      explanation: '"Zehn Eier kosten zwei Euro zwanzig."',
    ),
    ReadingQuestion(
      question: 'Was kostet ein Brot?',
      questionTranslation: 'What does a loaf of bread cost?',
      options: ['einen Euro fünfzig', 'zwei Euro', 'drei Euro'],
      optionsTranslation: ['one euro fifty', 'two euros', 'three euros'],
      correctIndex: 0,
      explanation: '"Ein Brot kostet einen Euro fünfzig."',
    ),
    ReadingQuestion(
      question: 'Wie sind die Äpfel heute?',
      questionTranslation: 'How are the apples today?',
      options: ['teuer', 'billig', 'alt'],
      optionsTranslation: ['expensive', 'cheap', 'old'],
      correctIndex: 1,
      explanation: '"Heute sind die Äpfel billig …"',
    ),
  ],
  intro: 'A market seller calls out today\'s prices — you only hear it. Press '
      'play, listen for the numbers, and match each price to its product. '
      'Replay as needed; the text is behind "Show text".',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Catch the product, then the price',
      text: 'The price always follows the product name: "Äpfel … zwei Euro". '
          'Hold the pair together in your head.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'Saying prices',
      text: '"2,20 €" is "zwei Euro zwanzig" — euros first, then cents, with no '
          'word for the comma.',
    ),
  ],
);

/// Dictation (Diktat) — Steckbrief: short self-introduction sentences the
/// learner HEARS and TYPES. The writing (Schreiben) counterpart of the listening
/// quizzes; it reinforces the spelling of the A1.1 verbs and vocabulary.
final QuizContent questDiktatSteckbriefContent = dictationQuestQuiz(
  id: 'quest_a1_1_diktat_steckbrief',
  title: 'A1.1 · Diktat: Steckbrief',
  promptLabel: 'Satz',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Deutsch',
  intro: 'A dictation: you HEAR a sentence and TYPE it. Press play, listen, then '
      'write exactly what you heard. You can replay as often as you like. '
      'Capitalisation and umlaut spelling are judged leniently (ä or ae both '
      'count), but spell the words correctly.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Listen, then write',
      text: 'Play the sentence as many times as you need before typing. Hold the '
          'whole sentence in your head, then write it in one go.',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: 'German nouns are capitalised',
      text: 'Hund, Student, Deutsch — every noun starts with a capital. The '
          'check is lenient, but build the habit now.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'No ß or ä on your keyboard?',
      text: 'Type "ss" and "ae": "ich heisse" is accepted for "ich heiße", '
          '"Fussball" for "Fußball".',
    ),
  ],
  sentences: const [
    SpeakPhrase(phrase: 'Ich heiße Anna.', meaning: 'My name is Anna.'),
    SpeakPhrase(
      phrase: 'Ich komme aus England.',
      meaning: 'I come from England.',
    ),
    SpeakPhrase(phrase: 'Ich wohne in Berlin.', meaning: 'I live in Berlin.'),
    SpeakPhrase(phrase: 'Ich bin Student.', meaning: 'I am a student.'),
    SpeakPhrase(phrase: 'Ich lerne Deutsch.', meaning: 'I am learning German.'),
    SpeakPhrase(phrase: 'Ich habe einen Hund.', meaning: 'I have a dog.'),
    SpeakPhrase(
      phrase: 'Ich spiele gern Fußball.',
      meaning: 'I like playing football.',
    ),
    SpeakPhrase(phrase: 'Wie heißt du?', meaning: "What's your name?"),
  ],
);

/// Big text (inline cloze) — Das bin ich: the learner fills the missing verbs
/// and articles straight into a whole self-introduction. It recycles every A1.1
/// structure at once (present-tense endings, sein/haben, nominative der/ein,
/// possessives) in a connected text, so no single item can repeat the way a
/// short drill does. Read-first passage is derived from the template.
final QuizContent questBigTextDasBinIchContent = bigTextQuestQuiz(
  id: 'quest_a1_1_bigtext_dasbinich',
  title: 'A1.1 · Großer Text: Das bin ich',
  passageTitle: 'Das bin ich',
  template:
      'Hallo! Ich {{0}} Lisa und ich {{1}} aus Italien. Jetzt {{2}} ich in '
      'Köln. Ich {{3}} Studentin und ich {{4}} Deutsch an der Universität. Ich '
      '{{5}} eine Schwester und einen Bruder. {{6}} Bruder heißt Marco. Wir '
      '{{7}} einen Hund. {{8}} Hund ist klein und braun. Ich {{9}} '
      'dreiundzwanzig Jahre alt. Und wer bist du?',
  blanks: [
    inputBlank('heiße', accepted: const ['heisse'], hint: 'heißen · ich'),
    inputBlank('komme', hint: 'kommen · ich'),
    inputBlank('wohne', hint: 'wohnen · ich'),
    inputBlank('bin', hint: 'sein · ich'),
    inputBlank('lerne', hint: 'lernen · ich'),
    inputBlank('habe', hint: 'haben · ich'),
    inputBlank('Mein', hint: 'my (der Bruder)'),
    inputBlank('haben', hint: 'haben · wir'),
    inputBlank('Der', hint: 'the (der Hund)'),
    inputBlank('bin', hint: 'sein · ich'),
  ],
  passageTranslation:
      'Hi! My name is Lisa and I come from Italy. Now I live in Cologne. I am a '
      'student and I study German at university. I have a sister and a brother. '
      'My brother is called Marco. We have a dog. The dog is small and brown. I '
      'am twenty-three years old. And who are you?',
  intro: 'Fill the missing words straight into the text. It uses everything from '
      'A1.1 at once — present-tense verbs (ich -e), sein/haben, and the '
      'nominative articles der/ein/mein. Read it once first, then fill the gaps.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Verb endings (ich / wir)',
      text: 'ich + verb-stem + -e (ich wohne); wir + infinitive (wir haben). '
          'sein is irregular: ich bin.',
    ),
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'der Hund, mein Bruder',
      text: 'Both are masculine, so in the nominative they take der and mein '
          '(the ein-word with no ending).',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: 'Capital nouns',
      text: 'Bruder, Hund, Deutsch — nouns keep their capital even mid-sentence.',
    ),
  ],
);

/// Every A1.1 quiz, in chain order. Number drills, vocab and grammar are
/// interleaved with the Speaking, Reading, Listening and Dictation skill
/// exercises so the learner never faces more than two same-type quizzes in a row
/// (knowledge → speaking → knowledge → listening → reading …), following the
/// Goethe A1 progression. All five exercise types appear in this sub-level.
final List<QuizContent> questA1_1Content = [
  questZahlen1Content, //           Zahlen 0–10               (knowledge)
  questPronomenContent, //          Personalpronomen          (knowledge)
  questSpeakBegruessungContent, //  Sprechen: Vorstellung     (speaking)
  questArtikelContent, //           Artikel im Nominativ      (knowledge)
  questZahlen2Content, //           Zahlen 11–20              (knowledge)
  questHoerenVorstellungContent, // Hören: Vorstellung        (listening)
  questSeinHabenContent, //         sein & haben              (knowledge·verb)
  questWFragenContent, //           W-Fragen                  (knowledge)
  questReadingDasBinIchContent, //  Lesen: Das bin ich        (reading)
  questPraesensContent, //          Regelmäßige Verben        (knowledge·verb)
  questVokalwechselContent, //      Unregelmäßige Verben      (knowledge·verb)
  questBigTextDasBinIchContent, //  Großer Text: Das bin ich  (reading·cloze)
  questDiktatSteckbriefContent, //  Diktat: Steckbrief        (dictation)
  questHoerenZahlenContent, //      Hören: Zahlen & Preise    (listening)
  questZahlen3Content, //           Zahlen 20–100             (knowledge)
  questFarbenContent, //            Farben                    (knowledge)
  questSpeakZahlenContent, //       Sprechen: Zahlen          (speaking)
  questFamilieContent, //           Familie & Menschen        (knowledge)
];
