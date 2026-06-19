/// Serializable, database-ready snapshot of one quiz's persisted progress.
///
/// The persistent twin of the score/streak/history state held in the quiz
/// engine (see widgets/quiz_page.dart). Pure data, so it can be stored in and
/// read from a database or JSON. A [QuizStatsStore] reads and writes it under
/// the keys built by `QuizStatsKeys` from a quiz's storage prefix.
class QuizStats {
  const QuizStats({
    this.score = 0,
    this.streak = 0,
    this.bestStreakLap = 0,
    this.bestStreakAbsolute = 0,
    this.answerHistory = const [],
    this.mistakesByCase = const {},
    this.enabledSubjects = const [],
    this.enabledCategories = const [],
  });

  /// Total correct answers.
  final int score;

  /// Current run of correct answers (resets to 0 on a wrong answer).
  final int streak;

  final int bestStreakLap;

  /// Highest [streak] ever reached (never resets) — the drawer's streak stat.
  final int bestStreakAbsolute;

  /// Recent answers, newest first. Each entry mirrors what the engine stores
  /// (exercise/answer/correct, etc.).
  final List<Map<String, dynamic>> answerHistory;

  /// Wrong-answer counts keyed by category label.
  final Map<String, int> mistakesByCase;

  /// Indices of the subjects (rows) currently enabled. Empty means "all".
  final List<int> enabledSubjects;

  /// Labels of the categories (columns) currently enabled. Empty means "all".
  final List<String> enabledCategories;

  QuizStats copyWith({
    int? score,
    int? streak,
    int? bestStreakLap,
    int? bestStreakAbsolute,
    List<Map<String, dynamic>>? answerHistory,
    Map<String, int>? mistakesByCase,
    List<int>? enabledSubjects,
    List<String>? enabledCategories,
  }) => QuizStats(
    score: score ?? this.score,
    streak: streak ?? this.streak,
    bestStreakLap: bestStreakLap ?? this.bestStreakLap,
    bestStreakAbsolute: bestStreakAbsolute ?? this.bestStreakAbsolute,
    answerHistory: answerHistory ?? this.answerHistory,
    mistakesByCase: mistakesByCase ?? this.mistakesByCase,
    enabledSubjects: enabledSubjects ?? this.enabledSubjects,
    enabledCategories: enabledCategories ?? this.enabledCategories,
  );

  Map<String, dynamic> toJson() => {
    'score': score,
    'streak': streak,
    'bestStreakLap': bestStreakLap,
    'bestStreakAbsolute': bestStreakAbsolute,
    'answerHistory': answerHistory,
    'mistakesByCase': mistakesByCase,
    'enabledSubjects': enabledSubjects,
    'enabledCategories': enabledCategories,
  };

  factory QuizStats.fromJson(Map<String, dynamic> json) => QuizStats(
    score: json['score'] as int? ?? 0,
    streak: json['streak'] as int? ?? 0,
    bestStreakLap: json['bestStreakLap'] as int? ?? 0,
    bestStreakAbsolute: json['bestStreakAbsolute'] as int? ?? 0,
    answerHistory: [
      for (final e in (json['answerHistory'] as List?) ?? const [])
        (e as Map).map((k, v) => MapEntry(k.toString(), v)),
    ],
    mistakesByCase:
        (json['mistakesByCase'] as Map?)?.map(
          (k, v) => MapEntry(k.toString(), (v as num).toInt()),
        ) ??
        const {},
    enabledSubjects: [
      for (final v in (json['enabledSubjects'] as List?) ?? const [])
        (v as num).toInt(),
    ],
    enabledCategories:
        (json['enabledCategories'] as List?)?.cast<String>() ?? const [],
  );
}
