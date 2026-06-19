import '../../models/quiz_content.dart';
import 'quest_a1_1_content.dart' show vocabQuestQuiz;

/// CEFR **A1.2 — "Im Alltag"** Quest quizzes (serializable [QuizContent]).
///
/// Two answer styles are used (and never mixed within one quiz — see the
/// adapter note in [quest_a1_1_content.dart]):
/// * **default-value** quizzes (Akkusativ, Possessiv, Modalverben, Datum) take
///   the category value as the answer and render a per-category template;
/// * **explicit-answer** quizzes (Negation, Uhrzeit, Präpositionen, Trennbare)
///   store one sentence per item with its own `acceptedAnswers`, so several
///   spellings/forms can be accepted. Their subject *display* is the English
///   gloss (shown above the German fill-in), giving context without revealing
///   the German answer.

// ── Explicit-answer (sentence bank) helper ──────────────────────────────────

/// One explicit-answer item: a German [sentence] with a `____` blank, the
/// [answer] revealed when wrong, every accepted spelling, an English gloss, and
/// an optional hint/explanation.
class QuestSentenceItem {
  const QuestSentenceItem({
    required this.sentence,
    required this.answer,
    required this.english,
    List<String>? accepted,
    this.hint,
    this.explanation,
  }) : accepted = accepted ?? const [];

  final String sentence;
  final String answer;
  final String english;
  final List<String> accepted;
  final String? hint;
  final String? explanation;
}

/// Builds a single-category explicit-answer quiz. Each item becomes one subject
/// (keyed `s0`…, displayed as its English gloss) and one stored sentence.
QuizContent sentenceQuestQuiz({
  required String id,
  required String title,
  required String promptLabel,
  required String subjectsLabel,
  required String subjectColumnLabel,
  required String categoryLabel,
  required List<QuestSentenceItem> items,
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
      for (var i = 0; i < items.length; i++)
        QuizSubjectData(key: 's$i', display: items[i].english),
    ],
    categories: [
      QuizCategoryData(
        label: categoryLabel,
        group: categoryLabel,
        values: [for (final it in items) it.answer],
      ),
    ],
    sentences: [
      for (var i = 0; i < items.length; i++)
        QuizSentenceData(
          subjectKey: 's$i',
          categoryLabel: categoryLabel,
          sentence: items[i].sentence,
          acceptedAnswers: {items[i].answer, ...items[i].accepted}.toList(),
          english: items[i].english,
          hint: items[i].hint,
          explanationSections: items[i].explanation == null
              ? const []
              : [items[i].explanation!],
        ),
    ],
    helpMemoryIntro: intro,
    helpMemoryTips: tips,
  );
}

// ── 1. Akkusativ — Artikel (den/die/das + einen/eine/ein) ────────────────────

class _GenderedNoun {
  const _GenderedNoun(this.noun, this.gender, this.english);
  final String noun;
  final String gender;
  final String english;
}

const List<_GenderedNoun> _akkNouns = [
  _GenderedNoun('Mann', 'm', 'man'),
  _GenderedNoun('Tisch', 'm', 'table'),
  _GenderedNoun('Hund', 'm', 'dog'),
  _GenderedNoun('Apfel', 'm', 'apple'),
  _GenderedNoun('Ball', 'm', 'ball'),
  _GenderedNoun('Frau', 'f', 'woman'),
  _GenderedNoun('Lampe', 'f', 'lamp'),
  _GenderedNoun('Katze', 'f', 'cat'),
  _GenderedNoun('Tasche', 'f', 'bag'),
  _GenderedNoun('Banane', 'f', 'banana'),
  _GenderedNoun('Kind', 'n', 'child'),
  _GenderedNoun('Auto', 'n', 'car'),
  _GenderedNoun('Buch', 'n', 'book'),
  _GenderedNoun('Haus', 'n', 'house'),
  _GenderedNoun('Brot', 'n', 'bread'),
];

const Map<String, String> _defAkk = {'m': 'den', 'f': 'die', 'n': 'das'};
const Map<String, String> _indefAkk = {'m': 'einen', 'f': 'eine', 'n': 'ein'};

final QuizContent questAkkusativContent = QuizContent(
  id: 'quest_a1_2_akkusativ',
  title: 'A1.2 · Akkusativ (Artikel)',
  storageKeyPrefix: 'quest_a1_2_akkusativ_',
  promptLabel: 'Nomen',
  subjectsLabel: 'Nomen',
  subjectColumnLabel: 'Nomen',
  subjects: [
    for (final n in _akkNouns)
      QuizSubjectData(
        key: n.noun,
        display: n.noun,
        english: n.english,
        gender: n.gender,
      ),
  ],
  categories: [
    QuizCategoryData(
      label: 'bestimmt (den/die/das)',
      group: 'bestimmt',
      values: [for (final n in _akkNouns) _defAkk[n.gender]!],
    ),
    QuizCategoryData(
      label: 'unbestimmt (einen/eine/ein)',
      group: 'unbestimmt',
      values: [for (final n in _akkNouns) _indefAkk[n.gender]!],
    ),
  ],
  sentences: const [],
  sentenceTemplates: const {
    'bestimmt (den/die/das)': ['Ich sehe ____ {subject}.'],
    'unbestimmt (einen/eine/ein)': ['Ich habe ____ {subject}.'],
  },
  helpMemoryColorByGender: true,
  helpMemoryIntro:
      'The accusative marks the direct object — the thing the action happens '
      'to (Ich sehe DEN Mann). Only the masculine article changes from the '
      'nominative.',
  helpMemoryTips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Only masculine changes',
      text: 'der → den and ein → einen. Feminine (die/eine), neuter (das/ein) '
          'and plural look exactly like the nominative.',
    ),
    HelpMemoryTip(
      kind: 'example',
      text: 'Ich habe einen Hund, eine Katze und ein Auto.',
    ),
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'Color code',
      text: 'der/den = blue, die = red, das = green.',
    ),
  ],
);

// ── 2. Possessivartikel (mein/dein/sein/ihr) ─────────────────────────────────

const List<_GenderedNoun> _possNouns = [
  _GenderedNoun('Vater', 'm', 'father'),
  _GenderedNoun('Bruder', 'm', 'brother'),
  _GenderedNoun('Hund', 'm', 'dog'),
  _GenderedNoun('Mutter', 'f', 'mother'),
  _GenderedNoun('Schwester', 'f', 'sister'),
  _GenderedNoun('Tasche', 'f', 'bag'),
  _GenderedNoun('Kind', 'n', 'child'),
  _GenderedNoun('Auto', 'n', 'car'),
  _GenderedNoun('Haus', 'n', 'house'),
];

/// Possessive endings: masculine/neuter take the bare stem in the nominative,
/// feminine (and plural) take `-e`; the masculine accusative takes `-en`.
List<String> _possValues(String stem, {required bool accusative}) => [
  for (final n in _possNouns)
    switch (n.gender) {
      'f' => '${stem}e',
      'm' => accusative ? '${stem}en' : stem,
      _ => stem,
    },
];

final QuizContent questPossessivContent = QuizContent(
  id: 'quest_a1_2_possessiv',
  title: 'A1.2 · Possessivartikel',
  storageKeyPrefix: 'quest_a1_2_possessiv_',
  promptLabel: 'Nomen',
  subjectsLabel: 'Nomen',
  subjectColumnLabel: 'Nomen',
  subjects: [
    for (final n in _possNouns)
      QuizSubjectData(
        key: n.noun,
        display: n.noun,
        english: n.english,
        gender: n.gender,
      ),
  ],
  categories: [
    QuizCategoryData(
      label: 'mein (my, Nom.)',
      group: 'nominativ',
      values: _possValues('mein', accusative: false),
    ),
    QuizCategoryData(
      label: 'dein (your, Nom.)',
      group: 'nominativ',
      values: _possValues('dein', accusative: false),
    ),
    QuizCategoryData(
      label: 'sein (his, Nom.)',
      group: 'nominativ',
      values: _possValues('sein', accusative: false),
    ),
    QuizCategoryData(
      label: 'ihr (her, Nom.)',
      group: 'nominativ',
      values: _possValues('ihr', accusative: false),
    ),
    QuizCategoryData(
      label: 'mein (my, Akk.)',
      group: 'akkusativ',
      values: _possValues('mein', accusative: true),
    ),
  ],
  sentences: const [],
  sentenceTemplates: const {
    'mein (my, Nom.)': ['Das ist ____ {subject}.'],
    'dein (your, Nom.)': ['Das ist ____ {subject}.'],
    'sein (his, Nom.)': ['Das ist ____ {subject}.'],
    'ihr (her, Nom.)': ['Das ist ____ {subject}.'],
    'mein (my, Akk.)': ['Ich sehe ____ {subject}.'],
  },
  helpMemoryColorByGender: true,
  helpMemoryIntro:
      'Possessive articles (mein, dein, sein, ihr …) take the SAME endings as '
      'ein/eine. The ending depends on the gender and case of the noun that '
      'follows — not on the owner.',
  helpMemoryTips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Nominative endings',
      text: 'Bare stem for masculine/neuter (mein Vater, mein Kind); add -e for '
          'feminine and plural (meine Mutter, meine Eltern).',
    ),
    HelpMemoryTip(
      kind: 'rule',
      title: 'Accusative',
      text: 'Like the accusative article, only masculine adds -en: '
          'Ich sehe meinen Vater (but meine Mutter, mein Kind).',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: 'sein vs. ihr',
      text: 'sein = his/its, ihr = her/their. Choose by the OWNER, then add the '
          'ending for the noun.',
    ),
  ],
);

// ── 3. Negation: kein vs nicht ───────────────────────────────────────────────

final QuizContent questNegationContent = sentenceQuestQuiz(
  id: 'quest_a1_2_negation',
  title: 'A1.2 · Negation (kein/nicht)',
  promptLabel: 'Satz',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'English',
  categoryLabel: 'Verneinung',
  items: const [
    QuestSentenceItem(
      sentence: 'Ich habe ____ Auto.',
      answer: 'kein',
      english: 'I have no car.',
      hint: 'Negates a neuter noun (das Auto) → kein.',
      explanation: 'kein negates nouns. Auto is neuter (das), so: kein Auto.',
    ),
    QuestSentenceItem(
      sentence: 'Das ist ____ Problem.',
      answer: 'kein',
      english: 'That is not a problem.',
      hint: 'Negates a neuter noun → kein.',
    ),
    QuestSentenceItem(
      sentence: 'Ich habe ____ Zeit.',
      answer: 'keine',
      english: 'I have no time.',
      hint: 'Zeit is feminine (die) → keine.',
    ),
    QuestSentenceItem(
      sentence: 'Er hat ____ Geld.',
      answer: 'kein',
      english: 'He has no money.',
      hint: 'Geld is neuter (das) → kein.',
    ),
    QuestSentenceItem(
      sentence: 'Wir haben ____ Hund.',
      answer: 'keinen',
      english: 'We have no dog.',
      hint: 'Hund is masculine (der) in the accusative → keinen.',
    ),
    QuestSentenceItem(
      sentence: 'Ich trinke ____ Kaffee.',
      answer: 'keinen',
      english: 'I do not drink coffee.',
      hint: 'Kaffee is masculine, accusative object → keinen.',
    ),
    QuestSentenceItem(
      sentence: 'Sie hat ____ Geschwister.',
      answer: 'keine',
      english: 'She has no siblings.',
      hint: 'Plural noun → keine.',
    ),
    QuestSentenceItem(
      sentence: 'Sie ist ____ müde.',
      answer: 'nicht',
      english: 'She is not tired.',
      hint: 'Negates an adjective → nicht.',
      explanation: 'nicht negates verbs, adjectives and adverbs. "müde" is an '
          'adjective, so: nicht müde.',
    ),
    QuestSentenceItem(
      sentence: 'Ich verstehe das ____.',
      answer: 'nicht',
      english: 'I do not understand that.',
      hint: 'Negates the verb → nicht.',
    ),
    QuestSentenceItem(
      sentence: 'Das Buch ist ____ teuer.',
      answer: 'nicht',
      english: 'The book is not expensive.',
      hint: 'Negates an adjective → nicht.',
    ),
    QuestSentenceItem(
      sentence: 'Ich kenne ihn ____.',
      answer: 'nicht',
      english: 'I do not know him.',
      hint: 'Negates the verb → nicht.',
    ),
    QuestSentenceItem(
      sentence: 'Der Film ist ____ gut.',
      answer: 'nicht',
      english: 'The film is not good.',
      hint: 'Negates an adjective → nicht.',
    ),
  ],
  intro: 'German has two ways to say "not". kein negates a noun (it replaces '
      'ein or the article); nicht negates everything else — verbs, adjectives '
      'and adverbs.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'kein for nouns',
      text: 'Use kein/keine/keinen where English says "no" or "not a": '
          'kein Auto, keine Zeit, keinen Hund.',
    ),
    HelpMemoryTip(
      kind: 'rule',
      title: 'nicht for the rest',
      text: 'Use nicht to negate a verb, adjective or adverb: '
          'Ich verstehe nicht; sie ist nicht müde.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'kein takes ein-endings',
      text: 'kein declines exactly like ein, so masculine accusative is keinen '
          '(Ich habe keinen Hund).',
    ),
  ],
);

// ── 4. Modalverben (können/müssen/wollen/möchten) ────────────────────────────

const List<String> _modalPronouns = [
  'ich',
  'du',
  'er/sie/es',
  'wir',
  'ihr',
  'sie/Sie',
];

final QuizContent questModalverbenContent = QuizContent(
  id: 'quest_a1_2_modalverben',
  title: 'A1.2 · Modalverben',
  storageKeyPrefix: 'quest_a1_2_modalverben_',
  promptLabel: 'Pronomen',
  subjectsLabel: 'Pronomen',
  subjectColumnLabel: 'Pronomen',
  subjects: [for (final p in _modalPronouns) QuizSubjectData(key: p, display: p)],
  categories: const [
    QuizCategoryData(
      label: 'können (can)',
      group: 'können',
      values: ['kann', 'kannst', 'kann', 'können', 'könnt', 'können'],
    ),
    QuizCategoryData(
      label: 'müssen (must)',
      group: 'müssen',
      values: ['muss', 'musst', 'muss', 'müssen', 'müsst', 'müssen'],
    ),
    QuizCategoryData(
      label: 'wollen (want)',
      group: 'wollen',
      values: ['will', 'willst', 'will', 'wollen', 'wollt', 'wollen'],
    ),
    QuizCategoryData(
      label: 'möchten (would like)',
      group: 'möchten',
      values: ['möchte', 'möchtest', 'möchte', 'möchten', 'möchtet', 'möchten'],
    ),
  ],
  sentences: const [],
  sentenceTemplates: const {
    'können (can)': ['{subject} ____ … (können)'],
    'müssen (must)': ['{subject} ____ … (müssen)'],
    'wollen (want)': ['{subject} ____ … (wollen)'],
    'möchten (would like)': ['{subject} ____ … (möchten)'],
  },
  helpMemoryIntro:
      'Modal verbs (können, müssen, wollen, möchten …) express ability, '
      'necessity or desire. They are irregular in the singular and push the '
      'main verb to the end of the clause as an infinitive.',
  helpMemoryTips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'ich and er are the same',
      text: 'The ich- and er/sie/es-forms are identical and take NO ending: '
          'ich kann, er kann; ich muss, sie muss.',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: 'Vowel change in the singular',
      text: 'The singular often changes the stem vowel: können → kann, '
          'müssen → muss, wollen → will. The plural keeps the infinitive stem.',
    ),
    HelpMemoryTip(
      kind: 'example',
      text: 'Ich kann gut schwimmen. — the second verb (schwimmen) goes to '
          'the end as an infinitive.',
    ),
  ],
);

// ── 5. Uhrzeit (telling time) ────────────────────────────────────────────────

/// (digital time, main colloquial form, other accepted forms). The digital
/// time is embedded in the sentence so each item's text is unique — the engine
/// keys per-sentence accepted answers by the sentence string.
QuestSentenceItem _time(String digital, String main, List<String> also) =>
    QuestSentenceItem(
      sentence: 'Es ist ____ . ($digital)',
      answer: main,
      english: 'It is $digital.',
      accepted: also,
      hint: 'Colloquial German time for $digital.',
    );

final QuizContent questUhrzeitContent = sentenceQuestQuiz(
  id: 'quest_a1_2_uhrzeit',
  title: 'A1.2 · Uhrzeit',
  promptLabel: 'Uhrzeit',
  subjectsLabel: 'Uhrzeiten',
  subjectColumnLabel: 'Zeit',
  categoryLabel: 'Wie spät ist es?',
  items: [
    _time('07:00', 'sieben Uhr', ['sieben']),
    _time('08:15', 'Viertel nach acht', []),
    _time('09:30', 'halb zehn', []),
    _time('10:45', 'Viertel vor elf', []),
    _time('12:00', 'zwölf Uhr', ['zwölf']),
    _time('13:00', 'ein Uhr', ['eins']),
    _time('14:30', 'halb drei', []),
    _time('15:30', 'halb vier', []),
    _time('16:45', 'Viertel vor fünf', []),
    _time('18:15', 'Viertel nach sechs', []),
    _time('20:45', 'Viertel vor neun', []),
    _time('21:15', 'Viertel nach neun', []),
  ],
  intro: 'Colloquial German clock times use "nach" (past) and "vor" (to). The '
      'word "halb" counts toward the NEXT hour, which trips up English '
      'speakers.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '"halb" looks ahead',
      text: 'halb drei = 2:30 (half on the way TO three), NOT 3:30.',
    ),
    HelpMemoryTip(
      kind: 'rule',
      title: 'nach / vor',
      text: 'Viertel nach acht = 8:15; Viertel vor neun = 8:45.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Official time',
      text: 'Timetables read the digits: 14:30 = vierzehn Uhr dreißig. Always '
          'understood, never wrong.',
    ),
  ],
);

// ── 6. Datum: Wochentage & Monate ────────────────────────────────────────────

final QuizContent questDatumContent = vocabQuestQuiz(
  id: 'quest_a1_2_datum',
  title: 'A1.2 · Wochentage & Monate',
  promptLabel: 'Wort',
  subjectsLabel: 'Wörter',
  subjectColumnLabel: 'English',
  categoryLabel: 'Deutsch',
  template: '"{subject}" auf Deutsch: ____',
  pairs: const [
    MapEntry('Monday', 'Montag'),
    MapEntry('Tuesday', 'Dienstag'),
    MapEntry('Wednesday', 'Mittwoch'),
    MapEntry('Thursday', 'Donnerstag'),
    MapEntry('Friday', 'Freitag'),
    MapEntry('Saturday', 'Samstag'),
    MapEntry('Sunday', 'Sonntag'),
    MapEntry('January', 'Januar'),
    MapEntry('February', 'Februar'),
    MapEntry('March', 'März'),
    MapEntry('April', 'April'),
    MapEntry('May', 'Mai'),
    MapEntry('June', 'Juni'),
    MapEntry('July', 'Juli'),
    MapEntry('August', 'August'),
    MapEntry('September', 'September'),
    MapEntry('October', 'Oktober'),
    MapEntry('November', 'November'),
    MapEntry('December', 'Dezember'),
  ],
  intro: 'All days of the week and months are masculine (der-words) and are '
      'always written with a capital letter.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Always "der"',
      text: 'der Montag, der Januar … every day and month is masculine.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: '"am" for days, "im" for months',
      text: 'am Freitag (on Friday), im Mai (in May). Both come from an/in + '
          'dem (dative).',
    ),
  ],
);

// ── 7. Akkusativpräpositionen (durch/für/gegen/ohne/um) ───────────────────────

final QuizContent questPraepositionenContent = sentenceQuestQuiz(
  id: 'quest_a1_2_praepositionen',
  title: 'A1.2 · Akkusativpräpositionen',
  promptLabel: 'Satz',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'English',
  categoryLabel: 'Artikel (Akkusativ)',
  items: const [
    QuestSentenceItem(
      sentence: 'Das Geschenk ist für ____ Mann.',
      answer: 'den',
      english: 'The gift is for the man.',
      hint: 'für → accusative. der Mann → den Mann.',
      explanation: 'für, durch, gegen, ohne, um always take the accusative. '
          'der → den, die → die, das → das.',
    ),
    QuestSentenceItem(
      sentence: 'Ich kaufe etwas für ____ Mutter.',
      answer: 'die',
      english: 'I buy something for the mother.',
      hint: 'für → accusative. die Mutter stays die.',
    ),
    QuestSentenceItem(
      sentence: 'Das ist ein Geschenk für ____ Kind.',
      answer: 'das',
      english: 'That is a gift for the child.',
      hint: 'für → accusative. das Kind stays das.',
    ),
    QuestSentenceItem(
      sentence: 'Wir gehen durch ____ Park.',
      answer: 'den',
      english: 'We walk through the park.',
      hint: 'durch → accusative. der Park → den Park.',
    ),
    QuestSentenceItem(
      sentence: 'Sie läuft durch ____ Stadt.',
      answer: 'die',
      english: 'She runs through the city.',
      hint: 'durch → accusative. die Stadt stays die.',
    ),
    QuestSentenceItem(
      sentence: 'Ich habe nichts gegen ____ Plan.',
      answer: 'den',
      english: 'I have nothing against the plan.',
      hint: 'gegen → accusative. der Plan → den Plan.',
    ),
    QuestSentenceItem(
      sentence: 'Ohne ____ Auto ist es schwer.',
      answer: 'das',
      english: 'Without the car it is hard.',
      hint: 'ohne → accusative. das Auto stays das.',
    ),
    QuestSentenceItem(
      sentence: 'Er geht ohne ____ Tasche.',
      answer: 'die',
      english: 'He leaves without the bag.',
      hint: 'ohne → accusative. die Tasche stays die.',
    ),
    QuestSentenceItem(
      sentence: 'Wir sitzen um ____ Tisch.',
      answer: 'den',
      english: 'We sit around the table.',
      hint: 'um → accusative. der Tisch → den Tisch.',
    ),
    QuestSentenceItem(
      sentence: 'Das Auto fährt gegen ____ Baum.',
      answer: 'den',
      english: 'The car drives into the tree.',
      hint: 'gegen → accusative. der Baum → den Baum.',
    ),
  ],
  intro: 'The prepositions durch, für, gegen, ohne and um always take the '
      'accusative, so the article on the following noun shifts to its '
      'accusative form.',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'Five accusative prepositions',
      text: 'durch, für, gegen, ohne, um — always accusative, no exceptions.',
    ),
    HelpMemoryTip(
      kind: 'rule',
      title: 'What actually changes',
      text: 'Only masculine: der → den (für den Mann). Feminine (die) and '
          'neuter (das) look the same as the nominative.',
    ),
  ],
);

// ── 8. Trennbare Verben (separable verbs) ────────────────────────────────────

final QuizContent questTrennbareContent = sentenceQuestQuiz(
  id: 'quest_a1_2_trennbare',
  title: 'A1.2 · Trennbare Verben',
  promptLabel: 'Satz',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'English',
  categoryLabel: 'Verbform',
  items: const [
    QuestSentenceItem(
      sentence: 'Ich ____ um 7 Uhr auf. (aufstehen)',
      answer: 'stehe',
      english: 'I get up at 7.',
      hint: 'Separable verb: the prefix "auf" goes to the end.',
      explanation: 'Separable verbs split: the prefix moves to the end of the '
          'clause and the conjugated stem takes the verb position.',
    ),
    QuestSentenceItem(
      sentence: 'Wann ____ du auf? (aufstehen)',
      answer: 'stehst',
      english: 'When do you get up?',
      hint: 'du form of (auf)stehen.',
    ),
    QuestSentenceItem(
      sentence: 'Der Zug ____ um 9 Uhr ab. (abfahren)',
      answer: 'fährt',
      english: 'The train departs at 9.',
      hint: 'er/es form of (ab)fahren — stem-changing a → ä.',
    ),
    QuestSentenceItem(
      sentence: 'Ich ____ am Montag ein. (einkaufen)',
      answer: 'kaufe',
      english: 'I go shopping on Monday.',
      hint: 'ich form of (ein)kaufen.',
    ),
    QuestSentenceItem(
      sentence: 'Wir ____ Freunde ein. (einladen)',
      answer: 'laden',
      english: 'We invite friends.',
      hint: 'wir form of (ein)laden.',
    ),
    QuestSentenceItem(
      sentence: 'Sie ____ die Tür zu. (zumachen)',
      answer: 'macht',
      english: 'She closes the door.',
      hint: 'sie (she) form of (zu)machen.',
    ),
    QuestSentenceItem(
      sentence: 'Ich ____ fern. (fernsehen)',
      answer: 'sehe',
      english: 'I watch TV.',
      hint: 'ich form of (fern)sehen.',
    ),
    QuestSentenceItem(
      sentence: 'Das Geschäft ____ um 8 Uhr auf. (aufmachen)',
      answer: 'macht',
      english: 'The shop opens at 8.',
      hint: 'es form of (auf)machen.',
    ),
    QuestSentenceItem(
      sentence: 'Ich ____ meine Freunde an. (anrufen)',
      answer: 'rufe',
      english: 'I call my friends.',
      hint: 'ich form of (an)rufen.',
    ),
    QuestSentenceItem(
      sentence: 'Ich komme mit. Wir ____ am Freitag zurück. (zurückkommen)',
      answer: 'kommen',
      english: 'We come back on Friday.',
      hint: 'wir form of (zurück)kommen.',
    ),
  ],
  intro: 'Separable verbs split in a main clause: the prefix jumps to the END '
      'of the sentence while the conjugated stem stays in second position.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Prefix goes to the end',
      text: 'aufstehen → Ich stehe um 7 Uhr auf. The prefix "auf" lands last.',
    ),
    HelpMemoryTip(
      kind: 'example',
      text: 'einkaufen → Ich kaufe heute ein.   anrufen → Ich rufe dich an.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Common separable prefixes',
      text: 'auf-, ab-, an-, aus-, ein-, mit-, vor-, zu-, zurück- are usually '
          'separable and carry the stress.',
    ),
  ],
);

/// Every A1.2 quiz, in display order.
final List<QuizContent> questA1_2Content = [
  questAkkusativContent,
  questPossessivContent,
  questNegationContent,
  questModalverbenContent,
  questUhrzeitContent,
  questDatumContent,
  questPraepositionenContent,
  questTrennbareContent,
];
