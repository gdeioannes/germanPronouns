import 'dart:math';

import '../models/quiz_config.dart';
import '../widgets/app_drawer.dart';

/// A German noun with its grammatical gender, used to derive the correct
/// definite article (der/die/das/den/dem) per case.
class ArticleNoun {
  const ArticleNoun({required this.noun, required this.gender, required this.english});

  /// The noun itself, without an article (e.g. "Hund").
  final String noun;

  /// 'm' (masculine/der), 'f' (feminine/die), or 'n' (neuter/das).
  final String gender;

  /// English translation, used in explanations.
  final String english;
}

const List<ArticleNoun> articleNouns = [
  // ── Masculine (der) ──────────────────────────────────────────────────
  ArticleNoun(noun: 'Hund', gender: 'm', english: 'dog'),
  ArticleNoun(noun: 'Tisch', gender: 'm', english: 'table'),
  ArticleNoun(noun: 'Stuhl', gender: 'm', english: 'chair'),
  ArticleNoun(noun: 'Apfel', gender: 'm', english: 'apple'),
  ArticleNoun(noun: 'Computer', gender: 'm', english: 'computer'),
  ArticleNoun(noun: 'Schrank', gender: 'm', english: 'wardrobe'),
  ArticleNoun(noun: 'Mantel', gender: 'm', english: 'coat'),
  ArticleNoun(noun: 'Garten', gender: 'm', english: 'garden'),
  ArticleNoun(noun: 'Spiegel', gender: 'm', english: 'mirror'),
  ArticleNoun(noun: 'Ball', gender: 'm', english: 'ball'),
  ArticleNoun(noun: 'Berg', gender: 'm', english: 'mountain'),
  ArticleNoun(noun: 'Wagen', gender: 'm', english: 'car'),
  ArticleNoun(noun: 'Schlüssel', gender: 'm', english: 'key'),
  ArticleNoun(noun: 'Teppich', gender: 'm', english: 'carpet'),
  ArticleNoun(noun: 'Koffer', gender: 'm', english: 'suitcase'),

  // ── Feminine (die) ───────────────────────────────────────────────────
  ArticleNoun(noun: 'Katze', gender: 'f', english: 'cat'),
  ArticleNoun(noun: 'Lampe', gender: 'f', english: 'lamp'),
  ArticleNoun(noun: 'Tasche', gender: 'f', english: 'bag'),
  ArticleNoun(noun: 'Blume', gender: 'f', english: 'flower'),
  ArticleNoun(noun: 'Uhr', gender: 'f', english: 'clock'),
  ArticleNoun(noun: 'Tür', gender: 'f', english: 'door'),
  ArticleNoun(noun: 'Flasche', gender: 'f', english: 'bottle'),
  ArticleNoun(noun: 'Zeitung', gender: 'f', english: 'newspaper'),
  ArticleNoun(noun: 'Brille', gender: 'f', english: 'glasses'),
  ArticleNoun(noun: 'Gitarre', gender: 'f', english: 'guitar'),
  ArticleNoun(noun: 'Kamera', gender: 'f', english: 'camera'),
  ArticleNoun(noun: 'Wand', gender: 'f', english: 'wall'),
  ArticleNoun(noun: 'Treppe', gender: 'f', english: 'staircase'),
  ArticleNoun(noun: 'Küche', gender: 'f', english: 'kitchen'),
  ArticleNoun(noun: 'Bank', gender: 'f', english: 'bench'),

  // ── Neuter (das) ─────────────────────────────────────────────────────
  ArticleNoun(noun: 'Buch', gender: 'n', english: 'book'),
  ArticleNoun(noun: 'Auto', gender: 'n', english: 'car'),
  ArticleNoun(noun: 'Fenster', gender: 'n', english: 'window'),
  ArticleNoun(noun: 'Haus', gender: 'n', english: 'house'),
  ArticleNoun(noun: 'Bett', gender: 'n', english: 'bed'),
  ArticleNoun(noun: 'Telefon', gender: 'n', english: 'phone'),
  ArticleNoun(noun: 'Bild', gender: 'n', english: 'picture'),
  ArticleNoun(noun: 'Glas', gender: 'n', english: 'glass'),
  ArticleNoun(noun: 'Regal', gender: 'n', english: 'shelf'),
  ArticleNoun(noun: 'Fahrrad', gender: 'n', english: 'bicycle'),
  ArticleNoun(noun: 'Hemd', gender: 'n', english: 'shirt'),
  ArticleNoun(noun: 'Messer', gender: 'n', english: 'knife'),
  ArticleNoun(noun: 'Sofa', gender: 'n', english: 'sofa'),
  ArticleNoun(noun: 'Radio', gender: 'n', english: 'radio'),
  ArticleNoun(noun: 'Klavier', gender: 'n', english: 'piano'),
];

const Map<String, String> _genderNames = {
  'm': 'masculine',
  'f': 'feminine',
  'n': 'neuter',
};

const Map<String, String> _baseArticles = {'m': 'der', 'f': 'die', 'n': 'das'};

/// Definite article for each gender, per case.
const Map<String, Map<String, String>> _articleTable = {
  'm': {'Nominative': 'der', 'Accusative': 'den', 'Dative': 'dem'},
  'f': {'Nominative': 'die', 'Accusative': 'die', 'Dative': 'der'},
  'n': {'Nominative': 'das', 'Accusative': 'das', 'Dative': 'dem'},
};

List<String> _articlesForCase(String caseLabel) =>
    articleNouns.map((n) => _articleTable[n.gender]![caseLabel]!).toList();

final Map<String, ArticleNoun> _nounsByName = {
  for (final n in articleNouns) n.noun: n,
};

const Map<String, List<String>> _sentenceTemplates = {
  'Nominative': [
    '____ {noun} ist hier.',
    'Wo ist ____ {noun}?',
    '____ {noun} gefällt mir sehr.',
    '____ {noun} sieht toll aus.',
  ],
  'Accusative': [
    'Ich sehe ____ {noun}.',
    'Kennst du ____ {noun}?',
    'Wir suchen ____ {noun}.',
    'Magst du ____ {noun}?',
  ],
  'Dative': [
    'Das gehört ____ {noun}.',
    'Ich nähere mich ____ {noun}.',
    'Wir widmen ____ {noun} viel Aufmerksamkeit.',
    'Mit ____ {noun} ist alles in Ordnung.',
  ],
};

/// Picks a fill-in-the-blank sentence for an article quiz question. The
/// blank (`____`) is where the article belongs; [nominative] is the noun
/// itself (e.g. "Hund").
String pickArticleSentence({
  required String caseLabel,
  required String nominative,
  required String answer,
  required Random random,
}) {
  final templates = _sentenceTemplates[caseLabel] ?? const ['____ {noun}.'];
  final template = templates[random.nextInt(templates.length)];
  return template.replaceAll('{noun}', nominative);
}

String _caseRoleNote(String caseLabel) {
  switch (caseLabel) {
    case 'Nominative':
      return 'The nominative marks the subject of the sentence: who or what the sentence is about.';
    case 'Accusative':
      return 'The accusative marks the direct object: the person or thing directly affected by the verb.';
    case 'Dative':
      return 'The dative marks the indirect object: the recipient, beneficiary, or thing related to the action.';
    default:
      return 'This case determines the article form used here.';
  }
}

const Map<String, Map<String, String>> _caseChangeTips = {
  'm': {
    'Nominative': 'Masculine nouns take "der" in the nominative (subject) position.',
    'Accusative':
        'Masculine nouns change "der" to "den" in the accusative — this is the key shift to remember.',
    'Dative': 'Masculine and neuter nouns both take "dem" in the dative.',
  },
  'f': {
    'Nominative': 'Feminine nouns take "die" in the nominative.',
    'Accusative':
        'Feminine articles don\'t change between nominative and accusative — both are "die".',
    'Dative':
        'Feminine nouns switch to "der" in the dative — easy to confuse with the masculine nominative "der".',
  },
  'n': {
    'Nominative': 'Neuter nouns take "das" in the nominative.',
    'Accusative':
        'Neuter articles don\'t change between nominative and accusative — both are "das".',
    'Dative': 'Masculine and neuter nouns both take "dem" in the dative.',
  },
};

String _caseChangeTip({required String gender, required String caseLabel}) =>
    _caseChangeTips[gender]?[caseLabel] ?? '';

/// Builds the multi-section explanation for an article quiz question.
/// [nominative] is the noun itself (e.g. "Hund").
String buildArticleExplanation({
  required String caseLabel,
  required String nominative,
  required String answer,
  required String sentence,
}) {
  final info = _nounsByName[nominative];
  final gender = info?.gender ?? 'n';
  final english = info?.english ?? nominative.toLowerCase();
  final genderName = _genderNames[gender] ?? 'neuter';
  final baseArticle = _baseArticles[gender] ?? 'das';

  final englishMeaning = switch (caseLabel) {
    'Nominative' =>
      'This sentence states something about "$nominative" ($english) as the subject.',
    'Accusative' =>
      'This sentence uses "$nominative" ($english) as the direct object of the verb.',
    'Dative' =>
      'This sentence uses "$nominative" ($english) as the indirect object — the recipient or thing related to the action.',
    _ => 'The missing word is the definite article for "$nominative" ($english).',
  };

  return [
    'Example: $sentence',
    'English: $englishMeaning',
    'Answer: "$answer" — the $caseLabel definite article for "$nominative" ($genderName noun).',
    'Grammar: ${_caseRoleNote(caseLabel)}',
    'Trigger: ${_caseChangeTip(gender: gender, caseLabel: caseLabel)}',
    'Base form (nominative): "$baseArticle $nominative".',
  ].join('\n\n');
}

final List<QuizCategoryDefinition> articleQuizCategories = [
  QuizCategoryDefinition(
    label: 'Nominative',
    values: _articlesForCase('Nominative'),
    group: 'Nominative',
  ),
  QuizCategoryDefinition(
    label: 'Accusative',
    values: _articlesForCase('Accusative'),
    group: 'Accusative',
  ),
  QuizCategoryDefinition(
    label: 'Dative',
    values: _articlesForCase('Dative'),
    group: 'Dative',
  ),
];

const Map<String, double> articleGroupChanceWeights = {
  'Nominative': 1,
  'Accusative': 1,
  'Dative': 1,
};

final QuizConfig articleQuizConfig = QuizConfig(
  title: 'German Artikel Quiz',
  storageKeyPrefix: 'article_',
  promptLabel: 'Word',
  subjectsLabel: 'Nouns',
  subjectColumnLabel: 'Noun',
  subjects: articleNouns.map((n) => n.noun).toList(),
  subjectDisplays: articleNouns.map((n) => n.noun).toList(),
  categories: articleQuizCategories,
  groupWeights: articleGroupChanceWeights,
  pickSentence: pickArticleSentence,
  buildExplanation: buildArticleExplanation,
  currentPage: AppPage.articles,
);
