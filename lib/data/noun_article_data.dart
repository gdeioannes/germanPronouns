import 'dart:math';

import '../models/app_page.dart';
import '../models/quiz_config.dart';
import 'german_grammar.dart';
import 'noun_database.dart';
import 'noun_progression_data.dart';
import 'noun_sentences.dart';

final Map<String, GermanNoun> _nounsByName = {
  for (final n in germanNouns) n.noun: n,
};

/// Generic fill-in-the-blank templates for nouns without a custom sentence in
/// [nounSentences]. `____` marks the article blank and `{noun}` is replaced
/// with the noun. Public so the quiz-content layer can expose them as data.
const List<String> nounArticleSentenceTemplates = [
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
  final custom = nounSentences[nominative];
  if (custom != null) return custom;

  final template = nounArticleSentenceTemplates[random.nextInt(
    nounArticleSentenceTemplates.length,
  )];
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
  final genderName = genderNames[info.gender]!;
  final article = baseArticles[info.gender]!;

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
    values: germanNouns.map((n) => baseArticles[n.gender]!).toList(),
    group: 'Artikel',
  ),
];

const Map<String, double> nounArticleGroupChanceWeights = {'Artikel': 1};

final QuizConfig nounArticleQuizConfig = QuizConfig(
  title: 'German Nouns & Articles',
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
  subjectGenders: germanNouns.map((n) => n.gender).toList(),
  categories: nounArticleQuizCategories,
  groupWeights: nounArticleGroupChanceWeights,
  pickSentence: pickNounArticleSentence,
  buildExplanation: buildNounArticleExplanation,
  currentPage: AppPage.nounsArticles,
  progressionKey: kAllNounsProgressionKey,
);
