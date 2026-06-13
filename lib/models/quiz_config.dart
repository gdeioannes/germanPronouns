import 'dart:math';

import '../widgets/app_drawer.dart';

/// Difficulty tier for a noun, used for bulk Settings toggles.
enum NounDifficulty { beginner, intermediate, advanced }

/// One quizzable category (e.g. a grammatical case for the pronoun quiz, or
/// Nominative/Accusative/Dative for the article quiz).
///
/// [values] is parallel to [QuizConfig.subjects]: `values[i]` is the correct
/// answer for `subjects[i]` in this category.
class QuizCategoryDefinition {
  const QuizCategoryDefinition({
    required this.label,
    required this.values,
    required this.group,
  });

  final String label;
  final List<String> values;
  final String group;
}

/// Picks a fill-in-the-blank sentence for a given answer.
///
/// [nominative] is the subject's reference key (the pronoun's nominative
/// form, or the noun itself for the article quiz).
typedef SentencePicker =
    String Function({
      required String caseLabel,
      required String nominative,
      required String answer,
      required Random random,
    });

/// Builds the multi-section explanation text shown for a question.
typedef ExplanationBuilder =
    String Function({
      required String caseLabel,
      required String nominative,
      required String answer,
      required String sentence,
    });

/// Everything the generic quiz engine needs to render and run a quiz.
class QuizConfig {
  const QuizConfig({
    required this.title,
    required this.storageKeyPrefix,
    required this.promptLabel,
    required this.subjectsLabel,
    required this.subjectColumnLabel,
    required this.subjects,
    required this.subjectDisplays,
    required this.categories,
    required this.groupWeights,
    required this.pickSentence,
    required this.buildExplanation,
    required this.currentPage,
    this.legacyCategoryLabelMigration = const {},
    this.subjectCategories,
    this.subjectDifficulties,
    this.categoryDisplayNames,
    this.subjectEnglish,
  });

  /// AppBar title for this quiz's page.
  final String title;

  /// Prefix applied to every SharedPreferences key used by this quiz, so
  /// each quiz persists its own score/streak/history/settings. The pronoun
  /// quiz uses '' to keep its existing keys unchanged.
  final String storageKeyPrefix;

  /// Singular label for the "current question" card, e.g. "Pronoun"/"Word".
  final String promptLabel;

  /// Plural label used in the settings section, e.g. "Pronouns"/"Nouns".
  final String subjectsLabel;

  /// Header for the fixed left column of the reference/analytics tables,
  /// e.g. "Nominative"/"Noun".
  final String subjectColumnLabel;

  /// Internal keys for each quiz subject (row), parallel to [subjectDisplays]
  /// and to every [QuizCategoryDefinition.values] list.
  final List<String> subjects;

  /// Display labels for each subject, shown in the table and settings.
  final List<String> subjectDisplays;

  /// Quizzable categories (columns).
  final List<QuizCategoryDefinition> categories;

  /// Relative chance weight per category group, used when picking a random
  /// question.
  final Map<String, double> groupWeights;

  final SentencePicker pickSentence;
  final ExplanationBuilder buildExplanation;

  /// Maps old, stored category labels to their current label, for settings
  /// persisted under previous app versions.
  final Map<String, String> legacyCategoryLabelMigration;

  /// Which page this quiz represents, for drawer highlighting.
  final AppPage currentPage;

  /// Semantic category keys per subject (a subject may belong to more than
  /// one category), parallel to [subjects]. When non-null, Settings shows
  /// per-category bulk-toggle chips and groups the "Active {subjectsLabel}"
  /// chips by category.
  final List<List<String>>? subjectCategories;

  /// Difficulty per subject, parallel to [subjects]. When non-null, Settings
  /// shows per-difficulty bulk-toggle chips.
  final List<NounDifficulty>? subjectDifficulties;

  /// Maps [subjectCategories] keys to bilingual display labels, e.g.
  /// {'kitchen': 'Kitchen (Küche)'}.
  final Map<String, String>? categoryDisplayNames;

  /// English translation per subject, parallel to [subjects]. When non-null
  /// and the user enables "Show English meanings", tables append
  /// "(translation)" after each subject's display name.
  final List<String>? subjectEnglish;
}
