import 'dart:math';

import '../models/app_page.dart';
import '../models/quiz_config.dart';
import 'german_grammar.dart';
import 'noun_database.dart';

/// A German noun with its grammatical gender, used to derive the correct
/// definite article (der/die/das/den/dem) per case.
class ArticleNoun {
  const ArticleNoun({
    required this.noun,
    required this.gender,
    required this.english,
    required this.categories,
    required this.difficulty,
  });

  /// The noun itself, without an article (e.g. "Hund").
  final String noun;

  /// 'm' (masculine/der), 'f' (feminine/die), or 'n' (neuter/das).
  final String gender;

  /// English translation, used in explanations.
  final String english;

  /// Semantic category keys, see [nounCategoryDisplayNames].
  final List<String> categories;

  final NounDifficulty difficulty;
}

/// Only declension-safe nouns (regular accusative/dative singular forms) are
/// suitable for the case-drilling quiz — weak/n-declension nouns like "der
/// Junge" -> "den Jungen" would make the noun itself change, not just the
/// article.
final List<ArticleNoun> articleNouns = germanNouns
    .where((n) => n.declensionSafe)
    .map(
      (n) => ArticleNoun(
        noun: n.noun,
        gender: n.gender,
        english: n.english,
        categories: n.categories,
        difficulty: n.difficulty,
      ),
    )
    .toList();

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

/// Fill-in-the-blank sentence templates per case. `____` marks the article
/// blank and `{noun}` is replaced with the noun. Public so the quiz-content
/// layer can expose them as data (see article_content.dart).
const Map<String, List<String>> articleSentenceTemplates = {
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
  final templates =
      articleSentenceTemplates[caseLabel] ?? const ['____ {noun}.'];
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
  final genderName = genderNames[gender] ?? 'neuter';
  final baseArticle = baseArticles[gender] ?? 'das';

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
  subjectCategories: articleNouns.map((n) => n.categories).toList(),
  subjectDifficulties: articleNouns.map((n) => n.difficulty).toList(),
  categoryDisplayNames: nounCategoryDisplayNames,
  subjectGenders: articleNouns.map((n) => n.gender).toList(),
  collapseReferenceTablesByGender: true,
  categories: articleQuizCategories,
  groupWeights: articleGroupChanceWeights,
  pickSentence: pickArticleSentence,
  buildExplanation: buildArticleExplanation,
  currentPage: AppPage.articles,
);
