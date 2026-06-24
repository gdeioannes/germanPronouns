import '../quiz_content.dart';
import 'help_memory.dart';

/// Type-safe, serializable quiz content — the replacement for the single fat
/// [QuizContent], split into one subtype per quiz kind so each carries only the
/// fields it actually uses (illegal states become unrepresentable, and a
/// `switch` over a [Quiz] is exhaustive).
///
/// Through Stages 1–4 the runtime engine + pages still consume [QuizContent];
/// [Quiz.fromLegacy] / [toLegacy] bridge between the two **losslessly** (proved
/// per quiz in `test/quiz_model_test.dart`), so the typed model can be
/// introduced and the JSON bundles generated without changing behavior.
sealed class Quiz {
  const Quiz({
    required this.id,
    required this.title,
    required this.storageKeyPrefix,
    required this.promptLabel,
    required this.subjectsLabel,
    required this.subjectColumnLabel,
    this.help = const HelpMemory(),
  });

  final String id;
  final String title;
  final String storageKeyPrefix;
  final String promptLabel;
  final String subjectsLabel;
  final String subjectColumnLabel;
  final HelpMemory help;

  /// JSON discriminator (`'fillBlank'` | `'reading'` | `'listening'` |
  /// `'speakRepeat'` | `'dictation'`).
  String get type;

  Map<String, dynamic> toJson();

  /// The legacy twin the engine/pages still run on during the transition.
  QuizContent toLegacy();

  factory Quiz.fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String? ?? 'fillBlank';
    return switch (type) {
      'reading' => ReadingQuiz.fromJson(json),
      'listening' => ListeningQuiz.fromJson(json),
      'speakRepeat' => SpeakRepeatQuiz.fromJson(json),
      'dictation' => DictationQuiz.fromJson(json),
      _ => FillBlankQuiz.fromJson(json),
    };
  }

  factory Quiz.fromLegacy(QuizContent c) => switch (c.kind) {
    QuizKind.reading => ReadingQuiz.fromContent(c),
    QuizKind.listening => ListeningQuiz.fromContent(c),
    QuizKind.speakRepeat => SpeakRepeatQuiz.fromContent(c),
    QuizKind.dictation => DictationQuiz.fromContent(c),
    QuizKind.fillBlank => FillBlankQuiz.fromContent(c),
  };
}

/// Shared base fields, read once from JSON / a [QuizContent].
typedef _Base = ({
  String id,
  String title,
  String storageKeyPrefix,
  String promptLabel,
  String subjectsLabel,
  String subjectColumnLabel,
  HelpMemory help,
});

_Base _baseFromJson(Map<String, dynamic> json) => (
  id: json['id'] as String,
  title: json['title'] as String,
  storageKeyPrefix: json['storageKeyPrefix'] as String,
  promptLabel: json['promptLabel'] as String,
  subjectsLabel: json['subjectsLabel'] as String,
  subjectColumnLabel: json['subjectColumnLabel'] as String,
  help: json['help'] == null
      ? const HelpMemory()
      : HelpMemory.fromJson(Map<String, dynamic>.from(json['help'] as Map)),
);

_Base _baseFromContent(QuizContent c) => (
  id: c.id,
  title: c.title,
  storageKeyPrefix: c.storageKeyPrefix,
  promptLabel: c.promptLabel,
  subjectsLabel: c.subjectsLabel,
  subjectColumnLabel: c.subjectColumnLabel,
  help: HelpMemory.fromContent(c),
);

Map<String, dynamic> _baseJson(Quiz q) => {
  'type': q.type,
  'id': q.id,
  'title': q.title,
  'storageKeyPrefix': q.storageKeyPrefix,
  'promptLabel': q.promptLabel,
  'subjectsLabel': q.subjectsLabel,
  'subjectColumnLabel': q.subjectColumnLabel,
  if (!q.help.isEmpty) 'help': q.help.toJson(),
};

// ---------------------------------------------------------------------------
// Fill-in-the-blank
// ---------------------------------------------------------------------------

final class FillBlankQuiz extends Quiz {
  const FillBlankQuiz({
    required super.id,
    required super.title,
    required super.storageKeyPrefix,
    required super.promptLabel,
    required super.subjectsLabel,
    required super.subjectColumnLabel,
    super.help,
    this.subjects = const [],
    this.categories = const [],
    this.sentences = const [],
    this.sentenceTemplates = const {},
    this.categoryDisplayNames = const {},
    this.legacyCategoryLabelMigration = const {},
    this.collapseReferenceTablesByGender = false,
    this.contextualLayout = false,
    this.stripSentenceCue = false,
  });

  final List<QuizSubjectData> subjects;
  final List<QuizCategoryData> categories;
  final List<QuizSentenceData> sentences;
  final Map<String, List<String>> sentenceTemplates;
  final Map<String, String> categoryDisplayNames;
  final Map<String, String> legacyCategoryLabelMigration;
  final bool collapseReferenceTablesByGender;
  final bool contextualLayout;
  final bool stripSentenceCue;

  @override
  String get type => 'fillBlank';

  @override
  Map<String, dynamic> toJson() => {
    ..._baseJson(this),
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
    if (contextualLayout) 'contextualLayout': true,
    if (stripSentenceCue) 'stripSentenceCue': true,
  };

  factory FillBlankQuiz.fromJson(Map<String, dynamic> json) {
    final b = _baseFromJson(json);
    return FillBlankQuiz(
      id: b.id,
      title: b.title,
      storageKeyPrefix: b.storageKeyPrefix,
      promptLabel: b.promptLabel,
      subjectsLabel: b.subjectsLabel,
      subjectColumnLabel: b.subjectColumnLabel,
      help: b.help,
      subjects: [
        for (final s in (json['subjects'] as List?) ?? const [])
          QuizSubjectData.fromJson(Map<String, dynamic>.from(s as Map)),
      ],
      categories: [
        for (final c in (json['categories'] as List?) ?? const [])
          QuizCategoryData.fromJson(Map<String, dynamic>.from(c as Map)),
      ],
      sentences: [
        for (final s in (json['sentences'] as List?) ?? const [])
          QuizSentenceData.fromJson(Map<String, dynamic>.from(s as Map)),
      ],
      sentenceTemplates:
          (json['sentenceTemplates'] as Map?)?.map(
            (k, v) => MapEntry(k as String, (v as List).cast<String>()),
          ) ??
          const {},
      categoryDisplayNames:
          (json['categoryDisplayNames'] as Map?)?.cast<String, String>() ??
          const {},
      legacyCategoryLabelMigration:
          (json['legacyCategoryLabelMigration'] as Map?)
              ?.cast<String, String>() ??
          const {},
      collapseReferenceTablesByGender:
          json['collapseReferenceTablesByGender'] as bool? ?? false,
      contextualLayout: json['contextualLayout'] as bool? ?? false,
      stripSentenceCue: json['stripSentenceCue'] as bool? ?? false,
    );
  }

  factory FillBlankQuiz.fromContent(QuizContent c) {
    final b = _baseFromContent(c);
    return FillBlankQuiz(
      id: b.id,
      title: b.title,
      storageKeyPrefix: b.storageKeyPrefix,
      promptLabel: b.promptLabel,
      subjectsLabel: b.subjectsLabel,
      subjectColumnLabel: b.subjectColumnLabel,
      help: b.help,
      subjects: c.subjects,
      categories: c.categories,
      sentences: c.sentences,
      sentenceTemplates: c.sentenceTemplates,
      categoryDisplayNames: c.categoryDisplayNames,
      legacyCategoryLabelMigration: c.legacyCategoryLabelMigration,
      collapseReferenceTablesByGender: c.collapseReferenceTablesByGender,
      contextualLayout: c.contextualLayout,
      stripSentenceCue: c.stripSentenceCue,
    );
  }

  @override
  QuizContent toLegacy() => QuizContent(
    id: id,
    title: title,
    storageKeyPrefix: storageKeyPrefix,
    promptLabel: promptLabel,
    subjectsLabel: subjectsLabel,
    subjectColumnLabel: subjectColumnLabel,
    subjects: subjects,
    categories: categories,
    sentences: sentences,
    sentenceTemplates: sentenceTemplates,
    categoryDisplayNames: categoryDisplayNames,
    legacyCategoryLabelMigration: legacyCategoryLabelMigration,
    collapseReferenceTablesByGender: collapseReferenceTablesByGender,
    contextualLayout: contextualLayout,
    stripSentenceCue: stripSentenceCue,
    helpMemorySubtitle: help.subtitle,
    helpMemoryIntro: help.intro,
    helpMemoryTips: help.tips,
    helpMemoryTables: help.tables,
    endingPatternTables: help.endingPatternTables,
    helpMemoryInfoColumns: help.infoColumns,
    helpMemoryColorByGender: help.colorByGender,
  );
}

// ---------------------------------------------------------------------------
// Reading / Listening (a passage + multiple-choice questions; listening hides
// the passage and reads it aloud — same shape, different `type`/`kind`)
// ---------------------------------------------------------------------------

Map<String, dynamic> _passageJson({
  String? category,
  String? passageTitle,
  String? passage,
  String? passageTranslation,
  required List<ReadingQuestion> questions,
}) => {
  'category': ?category,
  'passageTitle': ?passageTitle,
  'passage': ?passage,
  'passageTranslation': ?passageTranslation,
  if (questions.isNotEmpty) 'questions': [for (final q in questions) q.toJson()],
};

typedef _Passage = ({
  String? category,
  String? passageTitle,
  String? passage,
  String? passageTranslation,
  List<ReadingQuestion> questions,
});

_Passage _passageFromJson(Map<String, dynamic> json) => (
  category: json['category'] as String?,
  passageTitle: json['passageTitle'] as String?,
  passage: json['passage'] as String?,
  passageTranslation: json['passageTranslation'] as String?,
  questions: [
    for (final q in (json['questions'] as List?) ?? const [])
      ReadingQuestion.fromJson(Map<String, dynamic>.from(q as Map)),
  ],
);

_Passage _passageFromContent(QuizContent c) => (
  category: c.readingCategory,
  passageTitle: c.readingTitle,
  passage: c.readingPassage,
  passageTranslation: c.readingPassageTranslation,
  questions: c.readingQuestions,
);

QuizContent _passageToLegacy(
  Quiz q,
  _Passage p,
  QuizKind kind, {
  VoiceGender voiceGender = VoiceGender.female,
}) => QuizContent(
  id: q.id,
  title: q.title,
  storageKeyPrefix: q.storageKeyPrefix,
  promptLabel: q.promptLabel,
  subjectsLabel: q.subjectsLabel,
  voiceGender: voiceGender,
  subjectColumnLabel: q.subjectColumnLabel,
  kind: kind,
  subjects: const [],
  categories: const [],
  sentences: const [],
  readingCategory: p.category,
  readingTitle: p.passageTitle,
  readingPassage: p.passage,
  readingPassageTranslation: p.passageTranslation,
  readingQuestions: p.questions,
  helpMemorySubtitle: q.help.subtitle,
  helpMemoryIntro: q.help.intro,
  helpMemoryTips: q.help.tips,
  helpMemoryTables: q.help.tables,
  endingPatternTables: q.help.endingPatternTables,
  helpMemoryInfoColumns: q.help.infoColumns,
  helpMemoryColorByGender: q.help.colorByGender,
);

final class ReadingQuiz extends Quiz {
  const ReadingQuiz({
    required super.id,
    required super.title,
    required super.storageKeyPrefix,
    required super.promptLabel,
    required super.subjectsLabel,
    required super.subjectColumnLabel,
    super.help,
    this.category,
    this.passageTitle,
    this.passage,
    this.passageTranslation,
    this.questions = const [],
  });

  final String? category;
  final String? passageTitle;
  final String? passage;
  final String? passageTranslation;
  final List<ReadingQuestion> questions;

  @override
  String get type => 'reading';

  @override
  Map<String, dynamic> toJson() => {
    ..._baseJson(this),
    ..._passageJson(
      category: category,
      passageTitle: passageTitle,
      passage: passage,
      passageTranslation: passageTranslation,
      questions: questions,
    ),
  };

  factory ReadingQuiz.fromJson(Map<String, dynamic> json) {
    final b = _baseFromJson(json);
    final p = _passageFromJson(json);
    return ReadingQuiz(
      id: b.id,
      title: b.title,
      storageKeyPrefix: b.storageKeyPrefix,
      promptLabel: b.promptLabel,
      subjectsLabel: b.subjectsLabel,
      subjectColumnLabel: b.subjectColumnLabel,
      help: b.help,
      category: p.category,
      passageTitle: p.passageTitle,
      passage: p.passage,
      passageTranslation: p.passageTranslation,
      questions: p.questions,
    );
  }

  factory ReadingQuiz.fromContent(QuizContent c) {
    final b = _baseFromContent(c);
    final p = _passageFromContent(c);
    return ReadingQuiz(
      id: b.id,
      title: b.title,
      storageKeyPrefix: b.storageKeyPrefix,
      promptLabel: b.promptLabel,
      subjectsLabel: b.subjectsLabel,
      subjectColumnLabel: b.subjectColumnLabel,
      help: b.help,
      category: p.category,
      passageTitle: p.passageTitle,
      passage: p.passage,
      passageTranslation: p.passageTranslation,
      questions: p.questions,
    );
  }

  @override
  QuizContent toLegacy() => _passageToLegacy(
    this,
    (
      category: category,
      passageTitle: passageTitle,
      passage: passage,
      passageTranslation: passageTranslation,
      questions: questions,
    ),
    QuizKind.reading,
  );
}

final class ListeningQuiz extends Quiz {
  const ListeningQuiz({
    required super.id,
    required super.title,
    required super.storageKeyPrefix,
    required super.promptLabel,
    required super.subjectsLabel,
    required super.subjectColumnLabel,
    super.help,
    this.category,
    this.passageTitle,
    this.passage,
    this.passageTranslation,
    this.questions = const [],
    this.voiceGender = VoiceGender.female,
  });

  final String? category;
  final String? passageTitle;
  final String? passage;
  final String? passageTranslation;
  final List<ReadingQuestion> questions;

  /// Gender of the narrator voice that reads the (hidden) passage aloud.
  final VoiceGender voiceGender;

  @override
  String get type => 'listening';

  @override
  Map<String, dynamic> toJson() => {
    ..._baseJson(this),
    ..._passageJson(
      category: category,
      passageTitle: passageTitle,
      passage: passage,
      passageTranslation: passageTranslation,
      questions: questions,
    ),
    if (voiceGender != VoiceGender.female) 'voiceGender': voiceGender.name,
  };

  factory ListeningQuiz.fromJson(Map<String, dynamic> json) {
    final b = _baseFromJson(json);
    final p = _passageFromJson(json);
    return ListeningQuiz(
      id: b.id,
      title: b.title,
      storageKeyPrefix: b.storageKeyPrefix,
      promptLabel: b.promptLabel,
      subjectsLabel: b.subjectsLabel,
      subjectColumnLabel: b.subjectColumnLabel,
      help: b.help,
      category: p.category,
      passageTitle: p.passageTitle,
      passage: p.passage,
      passageTranslation: p.passageTranslation,
      questions: p.questions,
      voiceGender: VoiceGender.fromName(json['voiceGender'] as String?),
    );
  }

  factory ListeningQuiz.fromContent(QuizContent c) {
    final b = _baseFromContent(c);
    final p = _passageFromContent(c);
    return ListeningQuiz(
      id: b.id,
      title: b.title,
      storageKeyPrefix: b.storageKeyPrefix,
      promptLabel: b.promptLabel,
      subjectsLabel: b.subjectsLabel,
      subjectColumnLabel: b.subjectColumnLabel,
      help: b.help,
      category: p.category,
      passageTitle: p.passageTitle,
      passage: p.passage,
      passageTranslation: p.passageTranslation,
      questions: p.questions,
      voiceGender: c.voiceGender,
    );
  }

  @override
  QuizContent toLegacy() => _passageToLegacy(
    this,
    (
      category: category,
      passageTitle: passageTitle,
      passage: passage,
      passageTranslation: passageTranslation,
      questions: questions,
    ),
    QuizKind.listening,
    voiceGender: voiceGender,
  );
}

// ---------------------------------------------------------------------------
// Speak-repeat / Dictation (a list of spoken lines: the German text + its
// translation. Speak = hear & repeat; dictation = hear & type.)
// ---------------------------------------------------------------------------

/// One spoken line: the German [text] read aloud, and its [translation].
class SpokenLine {
  const SpokenLine({
    required this.id,
    required this.text,
    this.translation,
    this.gender,
  });

  final String id;
  final String text;
  final String? translation;

  /// Gender of the voice that reads this line. Null inherits the quiz's default
  /// voice; set it only for a line spoken by a different/specific speaker.
  final VoiceGender? gender;

  Map<String, dynamic> toJson() => {
    'id': id,
    'text': text,
    if (translation != null) 'translation': translation,
    if (gender != null) 'gender': gender!.name,
  };

  factory SpokenLine.fromJson(Map<String, dynamic> json) => SpokenLine(
    id: json['id'] as String,
    text: json['text'] as String,
    translation: json['translation'] as String?,
    gender: json['gender'] == null
        ? null
        : VoiceGender.fromName(json['gender'] as String?),
  );

  /// A legacy speak/dictation subject stores the phrase in `display` and its
  /// meaning in `english`, keyed by the subject key.
  factory SpokenLine.fromSubject(QuizSubjectData s) => SpokenLine(
    id: s.key,
    text: s.display,
    translation: s.english,
    gender: s.voiceGender,
  );

  QuizSubjectData toSubject() => QuizSubjectData(
    key: id,
    display: text,
    english: translation,
    voiceGender: gender,
  );
}

QuizContent _spokenToLegacy(
  Quiz q,
  List<SpokenLine> lines,
  QuizKind kind, {
  VoiceGender voiceGender = VoiceGender.female,
}) => QuizContent(
  id: q.id,
  title: q.title,
  storageKeyPrefix: q.storageKeyPrefix,
  promptLabel: q.promptLabel,
  subjectsLabel: q.subjectsLabel,
  subjectColumnLabel: q.subjectColumnLabel,
  kind: kind,
  voiceGender: voiceGender,
  subjects: [for (final l in lines) l.toSubject()],
  categories: const [],
  sentences: const [],
  helpMemorySubtitle: q.help.subtitle,
  helpMemoryIntro: q.help.intro,
  helpMemoryTips: q.help.tips,
  helpMemoryTables: q.help.tables,
  endingPatternTables: q.help.endingPatternTables,
  helpMemoryInfoColumns: q.help.infoColumns,
  helpMemoryColorByGender: q.help.colorByGender,
);

final class SpeakRepeatQuiz extends Quiz {
  const SpeakRepeatQuiz({
    required super.id,
    required super.title,
    required super.storageKeyPrefix,
    required super.promptLabel,
    required super.subjectsLabel,
    required super.subjectColumnLabel,
    super.help,
    this.phrases = const [],
    this.voiceGender = VoiceGender.female,
  });

  final List<SpokenLine> phrases;

  /// Default gender of the voice that reads the phrases aloud; individual
  /// [SpokenLine.gender]s override it per line.
  final VoiceGender voiceGender;

  @override
  String get type => 'speakRepeat';

  @override
  Map<String, dynamic> toJson() => {
    ..._baseJson(this),
    'phrases': [for (final p in phrases) p.toJson()],
    if (voiceGender != VoiceGender.female) 'voiceGender': voiceGender.name,
  };

  factory SpeakRepeatQuiz.fromJson(Map<String, dynamic> json) {
    final b = _baseFromJson(json);
    return SpeakRepeatQuiz(
      id: b.id,
      title: b.title,
      storageKeyPrefix: b.storageKeyPrefix,
      promptLabel: b.promptLabel,
      subjectsLabel: b.subjectsLabel,
      subjectColumnLabel: b.subjectColumnLabel,
      help: b.help,
      phrases: [
        for (final p in (json['phrases'] as List?) ?? const [])
          SpokenLine.fromJson(Map<String, dynamic>.from(p as Map)),
      ],
      voiceGender: VoiceGender.fromName(json['voiceGender'] as String?),
    );
  }

  factory SpeakRepeatQuiz.fromContent(QuizContent c) {
    final b = _baseFromContent(c);
    return SpeakRepeatQuiz(
      id: b.id,
      title: b.title,
      storageKeyPrefix: b.storageKeyPrefix,
      promptLabel: b.promptLabel,
      subjectsLabel: b.subjectsLabel,
      subjectColumnLabel: b.subjectColumnLabel,
      help: b.help,
      phrases: [for (final s in c.subjects) SpokenLine.fromSubject(s)],
      voiceGender: c.voiceGender,
    );
  }

  @override
  QuizContent toLegacy() =>
      _spokenToLegacy(this, phrases, QuizKind.speakRepeat,
          voiceGender: voiceGender);
}

final class DictationQuiz extends Quiz {
  const DictationQuiz({
    required super.id,
    required super.title,
    required super.storageKeyPrefix,
    required super.promptLabel,
    required super.subjectsLabel,
    required super.subjectColumnLabel,
    super.help,
    this.items = const [],
    this.voiceGender = VoiceGender.female,
  });

  final List<SpokenLine> items;

  /// Default gender of the voice that dictates the sentences; individual
  /// [SpokenLine.gender]s override it per line.
  final VoiceGender voiceGender;

  @override
  String get type => 'dictation';

  @override
  Map<String, dynamic> toJson() => {
    ..._baseJson(this),
    'items': [for (final i in items) i.toJson()],
    if (voiceGender != VoiceGender.female) 'voiceGender': voiceGender.name,
  };

  factory DictationQuiz.fromJson(Map<String, dynamic> json) {
    final b = _baseFromJson(json);
    return DictationQuiz(
      id: b.id,
      title: b.title,
      storageKeyPrefix: b.storageKeyPrefix,
      promptLabel: b.promptLabel,
      subjectsLabel: b.subjectsLabel,
      subjectColumnLabel: b.subjectColumnLabel,
      help: b.help,
      items: [
        for (final i in (json['items'] as List?) ?? const [])
          SpokenLine.fromJson(Map<String, dynamic>.from(i as Map)),
      ],
      voiceGender: VoiceGender.fromName(json['voiceGender'] as String?),
    );
  }

  factory DictationQuiz.fromContent(QuizContent c) {
    final b = _baseFromContent(c);
    return DictationQuiz(
      id: b.id,
      title: b.title,
      storageKeyPrefix: b.storageKeyPrefix,
      promptLabel: b.promptLabel,
      subjectsLabel: b.subjectsLabel,
      subjectColumnLabel: b.subjectColumnLabel,
      help: b.help,
      items: [for (final s in c.subjects) SpokenLine.fromSubject(s)],
      voiceGender: c.voiceGender,
    );
  }

  @override
  QuizContent toLegacy() =>
      _spokenToLegacy(this, items, QuizKind.dictation, voiceGender: voiceGender);
}
