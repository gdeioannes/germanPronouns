import 'dart:math';

import '../models/quiz_config.dart';
import '../widgets/app_drawer.dart';
import 'noun_database.dart';

const Map<String, String> _baseArticles = {'m': 'der', 'f': 'die', 'n': 'das'};

const Map<String, String> _genderNames = {
  'm': 'masculine',
  'f': 'feminine',
  'n': 'neuter',
};

final Map<String, GermanNoun> _nounsByName = {
  for (final n in germanNouns) n.noun: n,
};

const List<String> _sentenceTemplates = [
  '____ {noun} ist hier.',
  '____ {noun} sieht gut aus.',
  'Wo ist ____ {noun}?',
  '____ {noun} gefällt mir.',
];

/// Picks a fill-in-the-blank sentence for a noun-article quiz question. The
/// blank (`____`) is where the article belongs; [nominative] is the noun
/// itself (e.g. "Hund").
String pickNounArticleSentence({
  required String caseLabel,
  required String nominative,
  required String answer,
  required Random random,
}) {
  final template = _sentenceTemplates[random.nextInt(_sentenceTemplates.length)];
  return template.replaceAll('{noun}', nominative);
}

/// Builds the multi-section explanation for a noun-article quiz question.
/// [nominative] is the noun itself (e.g. "Hund"). The `Grammar:` section
/// pairs the noun, its article, and its English meaning, which is picked up
/// by the existing mistake/success reminder logic in `quiz_page.dart`.
String buildNounArticleExplanation({
  required String caseLabel,
  required String nominative,
  required String answer,
  required String sentence,
}) {
  final info = _nounsByName[nominative]!;
  final genderName = _genderNames[info.gender]!;
  final article = _baseArticles[info.gender]!;

  return [
    'Example: $sentence',
    'English: "$nominative" means "${info.english}".',
    'Answer: "$article $nominative" ($genderName).',
    'Grammar: "$article $nominative" — ${info.english}. ($nominative is $genderName, so it takes "$article".)',
  ].join('\n\n');
}

final List<QuizCategoryDefinition> nounArticleQuizCategories = [
  QuizCategoryDefinition(
    label: 'Artikel',
    values: germanNouns.map((n) => _baseArticles[n.gender]!).toList(),
    group: 'Artikel',
  ),
];

const Map<String, double> nounArticleGroupChanceWeights = {'Artikel': 1};

final QuizConfig nounArticleQuizConfig = QuizConfig(
  title: 'Nouns & Articles',
  storageKeyPrefix: 'noun_article_',
  promptLabel: 'Word',
  subjectsLabel: 'Nouns',
  subjectColumnLabel: 'Noun',
  subjects: germanNouns.map((n) => n.noun).toList(),
  subjectDisplays: germanNouns.map((n) => n.noun).toList(),
  subjectCategories: germanNouns.map((n) => n.categories).toList(),
  subjectDifficulties: germanNouns.map((n) => n.difficulty).toList(),
  categoryDisplayNames: nounCategoryDisplayNames,
  subjectEnglish: germanNouns.map((n) => n.english).toList(),
  categories: nounArticleQuizCategories,
  groupWeights: nounArticleGroupChanceWeights,
  pickSentence: pickNounArticleSentence,
  buildExplanation: buildNounArticleExplanation,
  currentPage: AppPage.nounsArticles,
);
