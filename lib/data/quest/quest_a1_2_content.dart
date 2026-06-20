import '../../models/quiz_content.dart';
import 'quest_builders.dart';

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
  // The "(21:15)" in each sentence is only there to keep the sentence string
  // unique for answer-keying; the time is already shown in the prompt, so hide
  // the duplicate cue from the interactive line.
  stripSentenceCue: true,
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

final QuizContent questDatumContent = sentenceQuestQuiz(
  id: 'quest_a1_2_datum',
  title: 'A1.2 · Wochentage & Monate',
  promptLabel: 'Welcher Tag/Monat?',
  subjectsLabel: 'Wörter',
  subjectColumnLabel: 'English',
  categoryLabel: 'Welcher Tag/Monat?',
  contextualLayout: true,
  items: const [
    QuestSentenceItem(
      sentence: 'Der erste Arbeitstag der Woche ist ____.',
      answer: 'Montag',
      english: 'The first workday of the week is ____ (Monday).',
    ),
    QuestSentenceItem(
      sentence: 'Der Tag nach Montag ist ____.',
      answer: 'Dienstag',
      english: 'The day after Monday is ____ (Tuesday).',
    ),
    QuestSentenceItem(
      sentence: 'Die Mitte der Arbeitswoche ist ____.',
      answer: 'Mittwoch',
      english: 'The middle of the workweek is ____ (Wednesday).',
    ),
    QuestSentenceItem(
      sentence: 'Der Tag vor Freitag ist ____.',
      answer: 'Donnerstag',
      english: 'The day before Friday is ____ (Thursday).',
    ),
    QuestSentenceItem(
      sentence: 'Der letzte Arbeitstag der Woche ist ____.',
      answer: 'Freitag',
      english: 'The last workday of the week is ____ (Friday).',
    ),
    QuestSentenceItem(
      sentence: 'Der erste Tag vom Wochenende ist ____.',
      answer: 'Samstag',
      english: 'The first day of the weekend is ____ (Saturday).',
      accepted: ['Sonnabend'],
    ),
    QuestSentenceItem(
      sentence: 'Der Ruhetag vor Montag ist ____.',
      answer: 'Sonntag',
      english: 'The day of rest before Monday is ____ (Sunday).',
    ),
    QuestSentenceItem(
      sentence: 'Der erste Monat im Jahr ist ____.',
      answer: 'Januar',
      english: 'The first month of the year is ____ (January).',
    ),
    QuestSentenceItem(
      sentence: 'Der kürzeste Monat im Jahr ist ____.',
      answer: 'Februar',
      english: 'The shortest month of the year is ____ (February).',
    ),
    QuestSentenceItem(
      sentence: 'Im ____ beginnt der Frühling.',
      answer: 'März',
      english: 'Spring begins in ____ (March).',
    ),
    QuestSentenceItem(
      sentence: 'Der Monat nach März ist ____.',
      answer: 'April',
      english: 'The month after March is ____ (April).',
    ),
    QuestSentenceItem(
      sentence: 'Der Monat nach April ist ____.',
      answer: 'Mai',
      english: 'The month after April is ____ (May).',
    ),
    QuestSentenceItem(
      sentence: 'Der erste Sommermonat ist ____.',
      answer: 'Juni',
      english: 'The first month of summer is ____ (June).',
    ),
    QuestSentenceItem(
      sentence: 'Der Monat nach Juni ist ____.',
      answer: 'Juli',
      english: 'The month after June is ____ (July).',
    ),
    QuestSentenceItem(
      sentence: 'Der Monat nach Juli ist ____.',
      answer: 'August',
      english: 'The month after July is ____ (August).',
    ),
    QuestSentenceItem(
      sentence: 'Im ____ beginnt oft die Schule.',
      answer: 'September',
      english: 'School often begins in ____ (September).',
    ),
    QuestSentenceItem(
      sentence: 'Der Monat vom Oktoberfest ist ____.',
      answer: 'Oktober',
      english: 'The month of Oktoberfest is ____ (October).',
    ),
    QuestSentenceItem(
      sentence: 'Der Monat vor Dezember ist ____.',
      answer: 'November',
      english: 'The month before December is ____ (November).',
    ),
    QuestSentenceItem(
      sentence: 'Der letzte Monat im Jahr (mit Weihnachten) ist ____.',
      answer: 'Dezember',
      english: 'The last month of the year (with Christmas) is ____ (December).',
    ),
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

// ── 9. Personalpronomen im Akkusativ (mich/dich/ihn …) ───────────────────────

final QuizContent questPronomenAkkContent = sentenceQuestQuiz(
  id: 'quest_a1_2_pronomen_akk',
  title: 'A1.2 · Personalpronomen (Akkusativ)',
  promptLabel: 'Welches Pronomen?',
  subjectsLabel: 'Pronomen',
  subjectColumnLabel: 'English',
  categoryLabel: 'Welches Pronomen? (Akkusativ)',
  contextualLayout: true,
  items: const [
    QuestSentenceItem(
      sentence: 'Das bin ich auf dem Foto. Siehst du ____?',
      answer: 'mich',
      english: "That's me in the photo. Do you see ____?",
      gloss: 'me',
    ),
    QuestSentenceItem(
      sentence: 'Du bist mein bester Freund. Ich mag ____ sehr.',
      answer: 'dich',
      english: 'You are my best friend. I like ____ a lot.',
      gloss: 'you (informal)',
    ),
    QuestSentenceItem(
      sentence: 'Das ist Tom. Ich kenne ____. (him)',
      answer: 'ihn',
      english: 'That is Tom. I know ____ (him).',
    ),
    QuestSentenceItem(
      sentence: 'Das ist Anna. Ich kenne ____. (her)',
      answer: 'sie',
      english: 'That is Anna. I know ____ (her).',
    ),
    QuestSentenceItem(
      sentence: 'Das ist das Buch. Ich lese ____. (it)',
      answer: 'es',
      english: 'That is the book. I read ____ (it).',
    ),
    QuestSentenceItem(
      sentence: 'Wir sind zu Hause. Besuchst du ____?',
      answer: 'uns',
      english: 'We are at home. Are you visiting ____?',
      gloss: 'us',
    ),
    QuestSentenceItem(
      sentence: 'Ihr seid meine Freunde. Ich besuche ____ am Sonntag.',
      answer: 'euch',
      english: 'You are my friends. I visit ____ on Sunday.',
      gloss: 'you (plural)',
    ),
    QuestSentenceItem(
      sentence: 'Das sind meine Freunde. Ich treffe ____. (them)',
      answer: 'sie',
      english: "Those are my friends. I'm meeting ____ (them).",
    ),
    QuestSentenceItem(
      sentence: 'Ich verstehe ____ gut, Frau Müller. (you, formal)',
      answer: 'Sie',
      english: 'I understand ____ (you) well, Mrs Müller.',
    ),
  ],
  intro: 'When a pronoun is the direct object (the accusative), it changes form: '
      '"Ich sehe DICH" (I see you). Only ich, du, er change a lot; the others '
      'look like the nominative.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'The ones that change',
      text: 'ich → mich, du → dich, er → ihn. The rest are the same as the '
          'subject form: sie → sie, es → es, wir → uns, ihr → euch.',
    ),
    HelpMemoryTip(
      kind: 'example',
      text: 'Liebst du mich? — Ja, ich liebe dich. / Kennst du ihn? — Ja, ich '
          'kenne ihn.',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: '"sie" again',
      text: 'sie = her/them and Sie = you (formal) look identical in the '
          'accusative — context decides.',
    ),
  ],
);

// ── Reading: "Im Café" (Food & drink) ────────────────────────────────────────

final QuizContent questReadingCafeContent = readingQuestQuiz(
  id: 'quest_a1_2_lesen_cafe',
  title: 'A1.2 · Lesen: Im Café',
  category: 'Food & Drink',
  passageTitle: 'Im Café',
  passage:
      'Anna und Tom gehen in ein Café. Der Kellner kommt und fragt: "Was '
      'möchten Sie trinken?" Anna möchte einen Kaffee mit Milch. Tom nimmt '
      'einen Tee und ein Glas Wasser. Sie haben Hunger und bestellen auch zwei '
      'Stück Kuchen. Der Kuchen ist sehr lecker. Am Ende bezahlt Tom. Der '
      'Kaffee kostet drei Euro, der Tee zwei Euro. Tom gibt dem Kellner ein '
      'kleines Trinkgeld.',
  questions: const [
    ReadingQuestion(
      question: 'Wohin gehen Anna und Tom?',
      options: ['in die Schule', 'in ein Café', 'nach Hause'],
      correctIndex: 1,
      explanation: '"Anna und Tom gehen in ein Café."',
    ),
    ReadingQuestion(
      question: 'Was möchte Anna trinken?',
      options: ['einen Tee', 'ein Wasser', 'einen Kaffee mit Milch'],
      correctIndex: 2,
      explanation: '"Anna möchte einen Kaffee mit Milch."',
    ),
    ReadingQuestion(
      question: 'Wer bezahlt am Ende?',
      options: ['Anna', 'Tom', 'der Kellner'],
      correctIndex: 1,
      explanation: '"Am Ende bezahlt Tom."',
    ),
    ReadingQuestion(
      question: 'Wie viel kostet der Kaffee?',
      options: ['zwei Euro', 'drei Euro', 'vier Euro'],
      correctIndex: 1,
      explanation: '"Der Kaffee kostet drei Euro …"',
    ),
    ReadingQuestion(
      question: 'Was essen Anna und Tom im Café?',
      options: ['Kuchen', 'Brot', 'Suppe'],
      correctIndex: 0,
      explanation: '"… bestellen auch zwei Stück Kuchen."',
    ),
  ],
  intro: 'Read the café scene once, then answer. Watch the verbs of ordering '
      '(möchten, nehmen, bestellen, bezahlen) — they come up constantly when '
      'eating out.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Scan for numbers',
      text: 'Price and quantity questions are easy points: find the digits and '
          'the Euro amounts in the text.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Who does what',
      text: 'Underline the names (Anna, Tom, der Kellner) so you can quickly '
          'see who orders, who pays and who serves.',
    ),
  ],
);

// ── Speaking: Alltag & Uhrzeit (daily routine & time) ────────────────────────

final QuizContent questSpeakAlltagContent = speakQuestQuiz(
  id: 'quest_a1_2_sprechen_alltag',
  title: 'A1.2 · Sprechen: Alltag & Uhrzeit',
  promptLabel: 'Satz',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Deutsch',
  intro: 'Say your daily routine and the time out loud. Listen and repeat each '
      'sentence; if a microphone is available we tell you how it sounded, '
      'otherwise just repeat and continue.',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: 'Separable verbs',
      text: '"Ich stehe um sieben Uhr auf" — say the prefix "auf" at the end '
          'clearly; it carries the stress.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'The "ü" in Uhr / um',
      text: 'Round your lips for "ü". Practise "Wie spät ist es?" until it '
          'flows.',
    ),
  ],
  phrases: const [
    SpeakPhrase(phrase: 'Wie spät ist es?', meaning: 'What time is it?'),
    SpeakPhrase(phrase: 'Es ist acht Uhr.', meaning: "It's eight o'clock."),
    SpeakPhrase(phrase: 'Es ist halb zehn.', meaning: "It's half past nine."),
    SpeakPhrase(
      phrase: 'Es ist Viertel nach drei.',
      meaning: "It's quarter past three.",
    ),
    SpeakPhrase(
      phrase: 'Ich stehe um sieben Uhr auf.',
      meaning: 'I get up at seven.',
    ),
    SpeakPhrase(
      phrase: 'Ich frühstücke um acht Uhr.',
      meaning: 'I have breakfast at eight.',
    ),
    SpeakPhrase(
      phrase: 'Ich gehe um neun Uhr zur Arbeit.',
      meaning: 'I go to work at nine.',
    ),
    SpeakPhrase(phrase: 'Am Abend sehe ich fern.', meaning: 'In the evening I watch TV.'),
    SpeakPhrase(phrase: 'Wann stehst du auf?', meaning: 'When do you get up?'),
    SpeakPhrase(
      phrase: 'Ich gehe um elf Uhr ins Bett.',
      meaning: 'I go to bed at eleven.',
    ),
  ],
);

// ── Reading: "Eine kleine Reise" (Travel) ────────────────────────────────────

final QuizContent questReadingReiseContent = readingQuestQuiz(
  id: 'quest_a1_2_lesen_reise',
  title: 'A1.2 · Lesen: Eine kleine Reise',
  category: 'Travel',
  passageTitle: 'Eine kleine Reise',
  passage:
      'Im Sommer macht Familie Schmidt eine Reise nach München. Sie fahren mit '
      'dem Zug. Der Zug fährt um neun Uhr am Bahnhof ab. Die Fahrkarte kostet '
      'vierzig Euro. Die Reise dauert vier Stunden. In München wohnen sie in '
      'einem Hotel im Zentrum. Sie besuchen ein Museum und einen großen Park. '
      'Das Wetter ist schön und warm. Am Abend essen sie in einem Restaurant. '
      'Die Kinder sind sehr glücklich.',
  questions: const [
    ReadingQuestion(
      question: 'Wohin fährt Familie Schmidt?',
      options: ['nach Berlin', 'nach München', 'nach Hamburg'],
      correctIndex: 1,
      explanation: '"… eine Reise nach München."',
    ),
    ReadingQuestion(
      question: 'Wie fahren sie?',
      options: ['mit dem Auto', 'mit dem Bus', 'mit dem Zug'],
      correctIndex: 2,
      explanation: '"Sie fahren mit dem Zug."',
    ),
    ReadingQuestion(
      question: 'Wie viel kostet die Fahrkarte?',
      options: ['vierzig Euro', 'vierzehn Euro', 'vier Euro'],
      correctIndex: 0,
      explanation: '"Die Fahrkarte kostet vierzig Euro."',
    ),
    ReadingQuestion(
      question: 'Wie ist das Wetter?',
      options: ['kalt', 'schön und warm', 'windig'],
      correctIndex: 1,
      explanation: '"Das Wetter ist schön und warm."',
    ),
    ReadingQuestion(
      question: 'Was besuchen sie in München?',
      options: ['ein Museum und einen Park', 'ein Theater', 'ein Kino'],
      correctIndex: 0,
      explanation: '"Sie besuchen ein Museum und einen großen Park."',
    ),
  ],
  intro: 'Read the travel story once, then answer. Travel words (Zug, Bahnhof, '
      'Fahrkarte, Hotel) and times/prices are common in the A1 reading exam.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Times and places',
      text: 'Note the time the train leaves and where they stay — questions '
          'often ask exactly those details.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'mit dem …',
      text: 'Transport uses "mit dem Zug / Bus / Auto" — a good clue for the '
          '"how do they travel?" question.',
    ),
  ],
);

/// Every A1.2 quiz, in chain order — grammar interleaved with the new Reading
/// and Speaking skill exercises (knowledge → reading → knowledge → speaking …),
/// following the Goethe A1 progression.
final List<QuizContent> questA1_2Content = [
  questAkkusativContent, //       Akkusativ (Artikel)        (knowledge)
  questPossessivContent, //       Possessivartikel           (knowledge)
  questPronomenAkkContent, //     Personalpronomen Akkusativ (knowledge)
  questNegationContent, //        Negation (kein/nicht)      (knowledge)
  questReadingCafeContent, //     Lesen: Im Café             (reading)
  questModalverbenContent, //     Modalverben                (knowledge)
  questUhrzeitContent, //         Uhrzeit                    (knowledge)
  questSpeakAlltagContent, //     Sprechen: Alltag & Uhrzeit (speaking)
  questDatumContent, //           Wochentage & Monate        (knowledge)
  questPraepositionenContent, //  Akkusativpräpositionen     (knowledge)
  questReadingReiseContent, //    Lesen: Eine kleine Reise   (reading)
  questTrennbareContent, //       Trennbare Verben           (knowledge)
];
