import 'dart:math';

import 'app_page.dart';

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

/// One column of a [HelpMemoryTable], referencing an existing
/// [QuizCategoryDefinition] by its [categoryLabel].
class HelpMemoryColumn {
  const HelpMemoryColumn({required this.categoryLabel, this.displayLabel});

  /// Must match a [QuizCategoryDefinition.label] in [QuizConfig.categories].
  final String categoryLabel;

  /// Header shown for this column instead of [categoryLabel], e.g. showing
  /// "Accusative" instead of the more verbose "Poss. Masc. Acc.".
  final String? displayLabel;

  Map<String, dynamic> toJson() => {
    'categoryLabel': categoryLabel,
    if (displayLabel != null) 'displayLabel': displayLabel,
  };

  factory HelpMemoryColumn.fromJson(Map<String, dynamic> json) =>
      HelpMemoryColumn(
        categoryLabel: json['categoryLabel'] as String,
        displayLabel: json['displayLabel'] as String?,
      );
}

/// One focused reference table shown in the Help Memory section, as an
/// alternative to the default single table covering every category.
///
/// Each table's fixed first column is always
/// [QuizConfig.subjectColumnLabel]/[QuizConfig.subjectDisplays] (e.g. the
/// nominative pronouns), followed by one column per entry in [columns].
class HelpMemoryTable {
  const HelpMemoryTable({required this.title, required this.columns});

  final String title;
  final List<HelpMemoryColumn> columns;

  Map<String, dynamic> toJson() => {
    'title': title,
    'columns': [for (final c in columns) c.toJson()],
  };

  factory HelpMemoryTable.fromJson(Map<String, dynamic> json) => HelpMemoryTable(
    title: json['title'] as String,
    columns: [
      for (final c in json['columns'] as List)
        HelpMemoryColumn.fromJson(c as Map<String, dynamic>),
    ],
  );
}

/// A short, visually distinct callout shown in the Help Memory section — a
/// rule, mnemonic, worked example, or warning that makes the reference tables
/// easier to understand.
class HelpMemoryTip {
  const HelpMemoryTip({required this.text, this.title, this.kind = 'tip'});

  /// One of: 'tip', 'rule', 'warning', 'example', 'mnemonic'. Drives the
  /// card's leading icon and accent color (see help_memory.dart). Unknown
  /// values fall back to the 'tip' style.
  final String kind;

  /// Optional bold heading shown above [text].
  final String? title;

  /// The callout body.
  final String text;

  Map<String, dynamic> toJson() => {
    if (kind != 'tip') 'kind': kind,
    if (title != null) 'title': title,
    'text': text,
  };

  factory HelpMemoryTip.fromJson(Map<String, dynamic> json) => HelpMemoryTip(
    kind: json['kind'] as String? ?? 'tip',
    title: json['title'] as String?,
    text: json['text'] as String,
  );
}

/// A small reference table of declension endings (e.g. the endings added to
/// "mein-"/"dein-"/etc. to form possessive pronouns), shown below the
/// [HelpMemoryTable]s in the Help Memory section.
class EndingPatternTable {
  const EndingPatternTable({
    required this.title,
    required this.cornerLabel,
    required this.columnLabels,
    required this.rowLabels,
    required this.rows,
    this.notes,
  });

  final String title;

  /// Label shown in the empty top-left cell, e.g. "Case".
  final String cornerLabel;
  final List<String> columnLabels;
  final List<String> rowLabels;

  /// `rows[i]` has one ending per entry in [columnLabels].
  final List<List<String>> rows;

  /// Bullet-point notes shown below the table.
  final List<String>? notes;

  Map<String, dynamic> toJson() => {
    'title': title,
    'cornerLabel': cornerLabel,
    'columnLabels': columnLabels,
    'rowLabels': rowLabels,
    'rows': rows,
    if (notes != null) 'notes': notes,
  };

  factory EndingPatternTable.fromJson(Map<String, dynamic> json) =>
      EndingPatternTable(
        title: json['title'] as String,
        cornerLabel: json['cornerLabel'] as String,
        columnLabels: (json['columnLabels'] as List).cast<String>(),
        rowLabels: (json['rowLabels'] as List).cast<String>(),
        rows: [
          for (final row in json['rows'] as List) (row as List).cast<String>(),
        ],
        notes: (json['notes'] as List?)?.cast<String>(),
      );
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
    this.subjectGenders,
    this.collapseReferenceTablesByGender = false,
    this.helpMemoryTables,
    this.endingPatternTables,
    this.helpMemorySubtitle,
    this.helpMemoryIntro,
    this.helpMemoryTips = const [],
    this.helpMemoryColorByGender = false,
    this.progressionKey,
    this.questProgression = false,
    this.acceptableAnswersForSentence,
    this.sentenceHint,
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

  /// Grammatical gender per subject ('m'/'f'/'n'), parallel to [subjects].
  /// When non-null, the subject is highlighted with its article's color
  /// (see [NounSettings.colorForGender]) in the word display and tables.
  final List<String>? subjectGenders;

  /// When true (and [subjectGenders] is set), the Help Memory and Analytics
  /// tables show one row per article gender (der/die/das) instead of one
  /// row per subject — used when the per-subject values in [categories]
  /// only depend on gender, not on the specific noun, making a per-subject
  /// table redundant.
  final bool collapseReferenceTablesByGender;

  /// When non-null, the Help Memory section (and its PDF export) shows one
  /// focused table per entry instead of a single table covering every
  /// category in [categories].
  final List<HelpMemoryTable>? helpMemoryTables;

  /// When non-null, these declension-ending reference tables are shown (and
  /// exported to PDF) below the [helpMemoryTables].
  final List<EndingPatternTable>? endingPatternTables;

  /// Overrides the default Help Memory section subtitle shown when
  /// [helpMemoryTables] is non-null. When null, a generic default is used.
  final String? helpMemorySubtitle;

  /// Optional rich intro paragraph shown at the top of the Help Memory section.
  final String? helpMemoryIntro;

  /// Visually distinct rule/mnemonic/example/warning callouts shown below the
  /// Help Memory tables (and in the PDF export).
  final List<HelpMemoryTip> helpMemoryTips;

  /// When true (and gender is known per subject/row), Help Memory table value
  /// cells are tinted by their gender (der=blue, die=red, das=green). This is
  /// always-on reference coloring, independent of the answer-revealing
  /// `NounSettings.colorNouns` toggle.
  final bool helpMemoryColorByGender;

  /// When non-null, identifies this quiz within the noun-category
  /// progression (a key from `nounCategoryDisplayNames`, or
  /// `kAllNounsProgressionKey`). Reaching the configured streak-unlock goal
  /// (`NounSettings.progressionUnlockStreak`) marks this key as "completed"
  /// via `NounSettings.markNounCategoryCompleted`, which may unlock the next
  /// progression entry.
  final String? progressionKey;

  /// When true, [progressionKey] identifies an entry in the **Quest** chain
  /// (`questEntries`) rather than the noun-category chain, so the engine uses
  /// the Quest streak goal and Quest completion tracking to unlock the next
  /// quiz. Defaults to false (noun-category behavior).
  final bool questProgression;

  /// When non-null, returns the set of answers (case-insensitive) accepted
  /// as correct for [sentence] — the current question's reference sentence.
  /// When null, only `categories[currentCategoryIndex].values[currentSubjectIndex]`
  /// is accepted.
  final Set<String> Function(String sentence)? acceptableAnswersForSentence;

  /// When non-null, returns a hint for [sentence] that is hidden by default
  /// and revealed via an eye icon next to the quiz sentence.
  final String? Function(String sentence)? sentenceHint;
}
