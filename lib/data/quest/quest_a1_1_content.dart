import '../../models/quiz_content.dart';

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

/// 2. Personalpronomen im Nominativ — English → German subject pronoun.
final QuizContent questPronomenContent = vocabQuestQuiz(
  id: 'quest_a1_1_pronomen',
  title: 'A1.1 · Personalpronomen',
  promptLabel: 'Pronomen',
  subjectsLabel: 'Pronomen',
  subjectColumnLabel: 'English',
  categoryLabel: 'Deutsch',
  template: '"{subject}" auf Deutsch: ____',
  pairs: const [
    MapEntry('I', 'ich'),
    MapEntry('you (informal)', 'du'),
    MapEntry('he', 'er'),
    MapEntry('she', 'sie'),
    MapEntry('it', 'es'),
    MapEntry('we', 'wir'),
    MapEntry('you (plural)', 'ihr'),
    MapEntry('they', 'sie'),
    MapEntry('you (formal)', 'Sie'),
  ],
  intro: 'Subject (nominative) pronouns say who does the action. They replace '
      'the person or thing doing the verb.',
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

/// 6. Farben — English → German colour word.
final QuizContent questFarbenContent = vocabQuestQuiz(
  id: 'quest_a1_1_farben',
  title: 'A1.1 · Farben',
  promptLabel: 'Farbe',
  subjectsLabel: 'Farben',
  subjectColumnLabel: 'English',
  categoryLabel: 'Deutsch',
  template: '"{subject}" auf Deutsch: ____',
  pairs: const [
    MapEntry('red', 'rot'),
    MapEntry('blue', 'blau'),
    MapEntry('green', 'grün'),
    MapEntry('yellow', 'gelb'),
    MapEntry('black', 'schwarz'),
    MapEntry('white', 'weiß'),
    MapEntry('orange', 'orange'),
    MapEntry('brown', 'braun'),
    MapEntry('grey', 'grau'),
    MapEntry('pink', 'rosa'),
    MapEntry('purple', 'lila'),
    MapEntry('colourful', 'bunt'),
  ],
  intro: 'Colours are adjectives. On their own (after sein) they stay in this '
      'base form; before a noun they take an ending.',
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

/// 7. Familie & Menschen — English → German noun *with its article*.
final QuizContent questFamilieContent = vocabQuestQuiz(
  id: 'quest_a1_1_familie',
  title: 'A1.1 · Familie & Menschen',
  promptLabel: 'Wort',
  subjectsLabel: 'Wörter',
  subjectColumnLabel: 'English',
  categoryLabel: 'Deutsch (mit Artikel)',
  template: '"{subject}" auf Deutsch (mit Artikel): ____',
  pairs: const [
    MapEntry('father', 'der Vater'),
    MapEntry('mother', 'die Mutter'),
    MapEntry('brother', 'der Bruder'),
    MapEntry('sister', 'die Schwester'),
    MapEntry('son', 'der Sohn'),
    MapEntry('daughter', 'die Tochter'),
    MapEntry('grandfather', 'der Großvater'),
    MapEntry('grandmother', 'die Großmutter'),
    MapEntry('child', 'das Kind'),
    MapEntry('the man', 'der Mann'),
    MapEntry('the woman', 'die Frau'),
    MapEntry('boy', 'der Junge'),
    MapEntry('girl', 'das Mädchen'),
    MapEntry('friend (male)', 'der Freund'),
    MapEntry('friend (female)', 'die Freundin'),
    MapEntry('the family', 'die Familie'),
  ],
  intro: 'Learn each family word together with its article — the gender is '
      'part of the word.',
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

/// Every A1.1 quiz, in chain order. The three number drills are spread out
/// (positions 1, 4, 7) and the vocab/grammar quizzes interleaved, so the
/// learner never faces two same-type quizzes back-to-back.
final List<QuizContent> questA1_1Content = [
  questZahlen1Content, //   Zahlen 0–10
  questPronomenContent, //  Personalpronomen
  questArtikelContent, //   Artikel im Nominativ
  questZahlen2Content, //   Zahlen 11–20
  questSeinHabenContent, // sein & haben
  questFarbenContent, //    Farben
  questZahlen3Content, //   Zahlen 20–100
  questPraesensContent, //  Regelmäßige Verben
  questFamilieContent, //   Familie & Menschen
];
