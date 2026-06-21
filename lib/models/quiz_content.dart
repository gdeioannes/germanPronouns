import 'quiz_config.dart';

// Re-exported so content files (which import this) can author Help Memory tips
// and info columns without a separate import.
export 'quiz_config.dart' show HelpMemoryTip, HelpMemoryInfoColumn;

/// How a quiz is played.
///
/// [fillBlank] is the default typing quiz driven by the generic `QuizPage`
/// engine. [speakRepeat] is a pronunciation quiz: the app reads each phrase
/// aloud (TTS) and the learner repeats it (STT), rendered by
/// `SpeakRepeatQuizPage` instead of going through the fill-in engine.
/// [reading] is a reading-comprehension quiz: a short passage followed by
/// multiple-choice questions, rendered by `ReadingQuizPage`. Both [speakRepeat]
/// and [reading] leave the fill-in fields (categories/sentences) empty and
/// carry their own data ([QuizContent.subjects] for speak; the reading fields
/// for reading).
enum QuizKind { fillBlank, speakRepeat, reading }

/// One multiple-choice question in a [QuizKind.reading] quiz: a [question]
/// stem, the answer [options], the index of the correct option, and an optional
/// [explanation] shown after answering.
class ReadingQuestion {
  const ReadingQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    this.explanation,
    this.questionTranslation,
    this.optionsTranslation,
    this.explanationTranslation,
  });

  /// The question stem, in German (the target language).
  final String question;

  /// The answer options, in German.
  final List<String> options;

  /// Index into [options] of the correct answer.
  final int correctIndex;

  /// Optional explanation shown once the question is answered/submitted, in
  /// German. Its [explanationTranslation] is offered behind the info button.
  final String? explanation;

  /// Translation of [question] into the learner's language, shown behind the
  /// per-question info button so the quiz itself stays in German. Null hides
  /// the button for this question.
  final String? questionTranslation;

  /// Translations of [options], parallel to it, shown alongside the German
  /// alternatives in the same info panel.
  final List<String>? optionsTranslation;

  /// Translation of [explanation], shown in the same info panel.
  final String? explanationTranslation;

  Map<String, dynamic> toJson() => {
    'question': question,
    'options': options,
    'correctIndex': correctIndex,
    if (explanation != null) 'explanation': explanation,
    if (questionTranslation != null) 'questionTranslation': questionTranslation,
    if (optionsTranslation != null) 'optionsTranslation': optionsTranslation,
    if (explanationTranslation != null)
      'explanationTranslation': explanationTranslation,
  };

  factory ReadingQuestion.fromJson(Map<String, dynamic> json) => ReadingQuestion(
    question: json['question'] as String,
    options: (json['options'] as List).cast<String>(),
    correctIndex: json['correctIndex'] as int,
    explanation: json['explanation'] as String?,
    questionTranslation: json['questionTranslation'] as String?,
    optionsTranslation: (json['optionsTranslation'] as List?)?.cast<String>(),
    explanationTranslation: json['explanationTranslation'] as String?,
  );
}

/// One quizzable subject (a table row): a pronoun, a noun, a preposition, etc.
class QuizSubjectData {
  const QuizSubjectData({
    required this.key,
    required this.display,
    this.referenceLabel,
    this.english,
    this.gender,
    this.difficulty,
    this.notes,
    this.categories = const [],
  });

  /// Internal key, parallel to each [QuizCategoryData.values] entry and to
  /// [QuizSentenceData.subjectKey].
  final String key;

  /// Label shown in the UI.
  final String display;

  /// Optional override for this row's first cell in the Help Memory reference
  /// table only (the live quiz still shows [display]). Used by the Español →
  /// Alemán courses to show the vocabulary word in both languages (e.g.
  /// `feliz · **glücklich**`) instead of repeating the full Spanish prompt that
  /// already appears in the example column. May carry `**…**` bold markup. Null
  /// keeps [display] as the cell.
  final String? referenceLabel;

  /// English translation, when available.
  final String? english;

  /// Grammatical gender ('m'/'f'/'n'), when relevant.
  final String? gender;

  /// Difficulty tier name (a [NounDifficulty] value's name), when relevant.
  final String? difficulty;

  /// Extra usage notes used when building explanations, when available.
  final String? notes;

  /// Semantic category keys this subject belongs to.
  final List<String> categories;

  Map<String, dynamic> toJson() => {
    'key': key,
    'display': display,
    if (referenceLabel != null) 'referenceLabel': referenceLabel,
    if (english != null) 'english': english,
    if (gender != null) 'gender': gender,
    if (difficulty != null) 'difficulty': difficulty,
    if (notes != null) 'notes': notes,
    if (categories.isNotEmpty) 'categories': categories,
  };

  factory QuizSubjectData.fromJson(Map<String, dynamic> json) => QuizSubjectData(
    key: json['key'] as String,
    display: json['display'] as String,
    referenceLabel: json['referenceLabel'] as String?,
    english: json['english'] as String?,
    gender: json['gender'] as String?,
    difficulty: json['difficulty'] as String?,
    notes: json['notes'] as String?,
    categories: (json['categories'] as List?)?.cast<String>() ?? const [],
  );
}

/// One quizzable category (a table column), e.g. a grammatical case.
/// [values] is parallel to [QuizContent.subjects]: `values[i]` is the correct
/// answer for `subjects[i]` in this category.
class QuizCategoryData {
  const QuizCategoryData({
    required this.label,
    required this.group,
    required this.values,
  });

  final String label;
  final String group;
  final List<String> values;

  Map<String, dynamic> toJson() => {
    'label': label,
    'group': group,
    'values': values,
  };

  factory QuizCategoryData.fromJson(Map<String, dynamic> json) =>
      QuizCategoryData(
        label: json['label'] as String,
        group: json['group'] as String,
        values: (json['values'] as List).cast<String>(),
      );
}

/// One fill-in-the-blank item: a sentence with a `____` blank, the answer(s)
/// that fill it, and optional hint/translation/explanation.
class QuizSentenceData {
  const QuizSentenceData({
    required this.subjectKey,
    required this.categoryLabel,
    required this.sentence,
    this.acceptedAnswers = const [],
    this.prompt,
    this.hint,
    this.english,
    this.referenceExample,
    this.explanationSections = const [],
  });

  /// The [QuizSubjectData.key] this sentence is filed under, for selection.
  final String subjectKey;

  /// The [QuizCategoryData.label] this sentence tests.
  final String categoryLabel;

  /// The sentence, containing one (or more) `____` blank(s).
  final String sentence;

  /// Every answer accepted as correct, case-insensitive. When empty, the
  /// engine accepts the category value for the current subject instead (used
  /// by article/noun quizzes, where the answer is computed from gender+case).
  final List<String> acceptedAnswers;

  /// Optional prompt/question shown alongside this sentence (e.g. the dialogue
  /// question in the Pronouns & Articles quiz).
  final String? prompt;

  /// Optional hidden hint, revealed via the eye icon.
  final String? hint;

  /// Optional English translation of the filled sentence.
  final String? english;

  /// Optional pre-built example for the Help Memory reference column,
  /// already filled in (no `____`) and with `**…**` bold markup around the
  /// word(s) to learn — e.g. `Hoy soy muy **feliz** → Heute bin ich sehr
  /// **glücklich**`. When set, the adapter shows this instead of reconstructing
  /// the example from [sentence] + [acceptedAnswers], so the Español → Alemán
  /// courses can bold the Spanish keyword too. Null keeps the reconstruction.
  final String? referenceExample;

  /// Optional pre-built explanation paragraphs. When empty, the engine builds
  /// a generic explanation from the subject/answer data.
  final List<String> explanationSections;

  Map<String, dynamic> toJson() => {
    'subjectKey': subjectKey,
    'categoryLabel': categoryLabel,
    'sentence': sentence,
    if (acceptedAnswers.isNotEmpty) 'acceptedAnswers': acceptedAnswers,
    if (prompt != null) 'prompt': prompt,
    if (hint != null) 'hint': hint,
    if (english != null) 'english': english,
    if (referenceExample != null) 'referenceExample': referenceExample,
    if (explanationSections.isNotEmpty)
      'explanationSections': explanationSections,
  };

  factory QuizSentenceData.fromJson(Map<String, dynamic> json) =>
      QuizSentenceData(
        subjectKey: json['subjectKey'] as String,
        categoryLabel: json['categoryLabel'] as String,
        sentence: json['sentence'] as String,
        acceptedAnswers:
            (json['acceptedAnswers'] as List?)?.cast<String>() ?? const [],
        prompt: json['prompt'] as String?,
        hint: json['hint'] as String?,
        english: json['english'] as String?,
        referenceExample: json['referenceExample'] as String?,
        explanationSections:
            (json['explanationSections'] as List?)?.cast<String>() ?? const [],
      );
}

/// Serializable, database-ready description of a single quiz's content.
///
/// This is the persistent twin of `QuizConfig`: it holds only data (no
/// behavior/closures), so it can be stored in and loaded from a database or a
/// JSON file. A runtime `QuizConfig` is produced from it by
/// `buildQuizConfigFromContent` (see data/quiz_content_adapter.dart).
class QuizContent {
  const QuizContent({
    required this.id,
    required this.title,
    required this.storageKeyPrefix,
    required this.promptLabel,
    required this.subjectsLabel,
    required this.subjectColumnLabel,
    required this.subjects,
    required this.categories,
    required this.sentences,
    this.kind = QuizKind.fillBlank,
    this.sentenceTemplates = const {},
    this.categoryDisplayNames = const {},
    this.legacyCategoryLabelMigration = const {},
    this.collapseReferenceTablesByGender = false,
    this.helpMemorySubtitle,
    this.helpMemoryTables = const [],
    this.endingPatternTables = const [],
    this.helpMemoryIntro,
    this.helpMemoryTips = const [],
    this.helpMemoryColorByGender = false,
    this.helpMemoryInfoColumns = const [],
    this.readingCategory,
    this.readingTitle,
    this.readingPassage,
    this.readingPassageTranslation,
    this.readingQuestions = const [],
    this.contextualLayout = false,
    this.stripSentenceCue = false,
  });

  /// Stable identifier (e.g. a database primary key or a slug).
  final String id;

  final String title;
  final String storageKeyPrefix;
  final String promptLabel;
  final String subjectsLabel;
  final String subjectColumnLabel;

  /// How this quiz is played; selects which page renders it. Defaults to
  /// [QuizKind.fillBlank].
  final QuizKind kind;

  final List<QuizSubjectData> subjects;
  final List<QuizCategoryData> categories;
  final List<QuizSentenceData> sentences;

  /// Sentence templates keyed by category label, used by quizzes that build
  /// sentences on the fly instead of storing a full bank (article/noun
  /// quizzes). Each template contains a `____` blank and a `{subject}`
  /// placeholder filled with the subject's key.
  final Map<String, List<String>> sentenceTemplates;

  /// Optional bilingual display labels for category keys, keyed by category
  /// key (e.g. {'kitchen': 'Kitchen (Küche)'}).
  final Map<String, String> categoryDisplayNames;

  /// Maps category labels stored by older app versions to their current label.
  final Map<String, String> legacyCategoryLabelMigration;

  /// When true (with per-subject genders), reference/analytics tables show one
  /// row per article gender (der/die/das) instead of one per subject. Used by
  /// the Artikel quiz, where answers depend only on gender.
  final bool collapseReferenceTablesByGender;

  final String? helpMemorySubtitle;
  final List<HelpMemoryTable> helpMemoryTables;
  final List<EndingPatternTable> endingPatternTables;

  /// Rich intro paragraph shown at the top of the Help Memory section.
  final String? helpMemoryIntro;

  /// Rule/mnemonic/example/warning callouts shown in the Help Memory section.
  final List<HelpMemoryTip> helpMemoryTips;

  /// When true, Help Memory tables tint value cells by gender (der/die/das).
  final bool helpMemoryColorByGender;

  /// Extra info-only columns appended to the Help Memory table (parallel to
  /// [subjects]); e.g. a preposition's case or a noun's plural.
  final List<HelpMemoryInfoColumn> helpMemoryInfoColumns;

  /// For [QuizKind.reading] quizzes: the passage's topic category label shown
  /// as a chip (e.g. 'Daily Life'), the on-screen title, the passage body
  /// (50–100 A1-level words), and the multiple-choice questions. Empty/null for
  /// other quiz kinds.
  final String? readingCategory;
  final String? readingTitle;
  final String? readingPassage;

  /// Translation of [readingPassage] into the learner's language, offered
  /// behind the passage's info button so the passage itself stays in German.
  final String? readingPassageTranslation;

  final List<ReadingQuestion> readingQuestions;

  /// When true, the quiz page shows the German sentence as the question (with
  /// its English translation beneath it) instead of the default subject/Case
  /// summary — used by the contextual "light quiz" vocab quizzes so the German
  /// comes first and the English is the translation.
  final bool contextualLayout;

  /// When true, a trailing "(…)" cue is stripped from the displayed quiz
  /// sentence (e.g. Uhrzeit's "(21:15)"), which exists only to keep each
  /// sentence unique for answer-keying and is already shown in the prompt. The
  /// full sentence is still used as the answer key.
  final bool stripSentenceCue;

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'storageKeyPrefix': storageKeyPrefix,
    'promptLabel': promptLabel,
    'subjectsLabel': subjectsLabel,
    'subjectColumnLabel': subjectColumnLabel,
    if (kind != QuizKind.fillBlank) 'kind': kind.name,
    'subjects': [for (final s in subjects) s.toJson()],
    'categories': [for (final c in categories) c.toJson()],
    'sentences': [for (final s in sentences) s.toJson()],
    if (sentenceTemplates.isNotEmpty) 'sentenceTemplates': sentenceTemplates,
    if (categoryDisplayNames.isNotEmpty)
      'categoryDisplayNames': categoryDisplayNames,
    if (legacyCategoryLabelMigration.isNotEmpty)
      'legacyCategoryLabelMigration': legacyCategoryLabelMigration,
    if (collapseReferenceTablesByGender)
      'collapseReferenceTablesByGender': true,
    if (helpMemorySubtitle != null) 'helpMemorySubtitle': helpMemorySubtitle,
    if (helpMemoryTables.isNotEmpty)
      'helpMemoryTables': [for (final t in helpMemoryTables) t.toJson()],
    if (endingPatternTables.isNotEmpty)
      'endingPatternTables': [for (final t in endingPatternTables) t.toJson()],
    if (helpMemoryIntro != null) 'helpMemoryIntro': helpMemoryIntro,
    if (helpMemoryTips.isNotEmpty)
      'helpMemoryTips': [for (final t in helpMemoryTips) t.toJson()],
    if (helpMemoryColorByGender) 'helpMemoryColorByGender': true,
    if (helpMemoryInfoColumns.isNotEmpty)
      'helpMemoryInfoColumns': [
        for (final c in helpMemoryInfoColumns) c.toJson(),
      ],
    if (readingCategory != null) 'readingCategory': readingCategory,
    if (readingTitle != null) 'readingTitle': readingTitle,
    if (readingPassage != null) 'readingPassage': readingPassage,
    if (readingPassageTranslation != null)
      'readingPassageTranslation': readingPassageTranslation,
    if (readingQuestions.isNotEmpty)
      'readingQuestions': [for (final q in readingQuestions) q.toJson()],
    if (contextualLayout) 'contextualLayout': true,
    if (stripSentenceCue) 'stripSentenceCue': true,
  };

  factory QuizContent.fromJson(Map<String, dynamic> json) => QuizContent(
    id: json['id'] as String,
    title: json['title'] as String,
    storageKeyPrefix: json['storageKeyPrefix'] as String,
    promptLabel: json['promptLabel'] as String,
    subjectsLabel: json['subjectsLabel'] as String,
    subjectColumnLabel: json['subjectColumnLabel'] as String,
    kind: QuizKind.values.byName(json['kind'] as String? ?? 'fillBlank'),
    subjects: [
      for (final s in json['subjects'] as List)
        QuizSubjectData.fromJson(s as Map<String, dynamic>),
    ],
    categories: [
      for (final c in json['categories'] as List)
        QuizCategoryData.fromJson(c as Map<String, dynamic>),
    ],
    sentences: [
      for (final s in json['sentences'] as List)
        QuizSentenceData.fromJson(s as Map<String, dynamic>),
    ],
    sentenceTemplates:
        (json['sentenceTemplates'] as Map?)?.map(
          (key, value) =>
              MapEntry(key as String, (value as List).cast<String>()),
        ) ??
        const {},
    categoryDisplayNames:
        (json['categoryDisplayNames'] as Map?)?.cast<String, String>() ??
        const {},
    legacyCategoryLabelMigration:
        (json['legacyCategoryLabelMigration'] as Map?)?.cast<String, String>() ??
        const {},
    collapseReferenceTablesByGender:
        json['collapseReferenceTablesByGender'] as bool? ?? false,
    helpMemorySubtitle: json['helpMemorySubtitle'] as String?,
    helpMemoryTables: [
      for (final t in (json['helpMemoryTables'] as List?) ?? const [])
        HelpMemoryTable.fromJson(t as Map<String, dynamic>),
    ],
    endingPatternTables: [
      for (final t in (json['endingPatternTables'] as List?) ?? const [])
        EndingPatternTable.fromJson(t as Map<String, dynamic>),
    ],
    helpMemoryIntro: json['helpMemoryIntro'] as String?,
    helpMemoryTips: [
      for (final t in (json['helpMemoryTips'] as List?) ?? const [])
        HelpMemoryTip.fromJson(t as Map<String, dynamic>),
    ],
    helpMemoryColorByGender:
        json['helpMemoryColorByGender'] as bool? ?? false,
    helpMemoryInfoColumns: [
      for (final c in (json['helpMemoryInfoColumns'] as List?) ?? const [])
        HelpMemoryInfoColumn.fromJson(c as Map<String, dynamic>),
    ],
    readingCategory: json['readingCategory'] as String?,
    readingTitle: json['readingTitle'] as String?,
    readingPassage: json['readingPassage'] as String?,
    readingPassageTranslation: json['readingPassageTranslation'] as String?,
    readingQuestions: [
      for (final q in (json['readingQuestions'] as List?) ?? const [])
        ReadingQuestion.fromJson(q as Map<String, dynamic>),
    ],
    contextualLayout: json['contextualLayout'] as bool? ?? false,
    stripSentenceCue: json['stripSentenceCue'] as bool? ?? false,
  );
}
