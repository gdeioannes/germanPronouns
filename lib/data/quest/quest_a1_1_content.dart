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
  questions: const [
    ReadingQuestion(
      question: 'Wie alt ist Lena?',
      options: ['dreizehn', 'dreißig', 'dreiundzwanzig'],
      correctIndex: 1,
      explanation: '"Ich bin dreißig Jahre alt" — she is thirty (30).',
    ),
    ReadingQuestion(
      question: 'Woher kommt Lena?',
      options: ['aus Deutschland', 'aus der Schweiz', 'aus Österreich'],
      correctIndex: 2,
      explanation: '"… und komme aus Österreich."',
    ),
    ReadingQuestion(
      question: 'Was ist Lena von Beruf?',
      options: ['Ärztin', 'Lehrerin', 'Studentin'],
      correctIndex: 1,
      explanation: '"Ich bin Lehrerin und arbeite an einer Schule."',
    ),
    ReadingQuestion(
      question: 'Was trinkt Lena am Morgen?',
      options: ['Kaffee', 'Tee', 'Wasser'],
      correctIndex: 1,
      explanation: '"Am Morgen trinke ich Tee …" — coffee is for the afternoon.',
    ),
    ReadingQuestion(
      question: 'Was macht Lena gern am Wochenende?',
      options: ['Tennis spielen', 'schwimmen', 'kochen'],
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

/// Every A1.1 quiz, in chain order. Number drills, vocab and grammar are
/// interleaved with the new Speaking and Reading skill exercises so the learner
/// never faces two same-type quizzes back-to-back (knowledge → speaking →
/// knowledge → reading …), following the Goethe A1 progression.
final List<QuizContent> questA1_1Content = [
  questZahlen1Content, //          Zahlen 0–10            (knowledge)
  questPronomenContent, //         Personalpronomen       (knowledge)
  questSpeakBegruessungContent, // Sprechen: Vorstellung  (speaking)
  questArtikelContent, //          Artikel im Nominativ   (knowledge)
  questZahlen2Content, //          Zahlen 11–20           (knowledge)
  questWFragenContent, //          W-Fragen               (knowledge)
  questSeinHabenContent, //        sein & haben           (knowledge)
  questFarbenContent, //           Farben                 (knowledge)
  questReadingDasBinIchContent, // Lesen: Das bin ich     (reading)
  questZahlen3Content, //          Zahlen 20–100          (knowledge)
  questPraesensContent, //         Regelmäßige Verben     (knowledge)
  questFamilieContent, //          Familie & Menschen     (knowledge)
  questSpeakZahlenContent, //      Sprechen: Zahlen       (speaking)
];
