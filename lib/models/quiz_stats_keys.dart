/// Builds the SharedPreferences key names for one quiz's persisted stats,
/// derived from the quiz's `QuizConfig.storageKeyPrefix`.
///
/// Single source of truth for these key strings: used by the quiz engine
/// (read + write) and by the drawer (read), which previously each built the
/// same `'${prefix}quiz_...'` strings by hand — a sync hazard if either side
/// changed a key.
class QuizStatsKeys {
  const QuizStatsKeys(this.prefix);

  /// The owning quiz's `QuizConfig.storageKeyPrefix` (e.g. 'article_'). The
  /// original pronoun quiz uses '' to keep its existing, unprefixed keys.
  final String prefix;

  String get answerHistory => '${prefix}quiz_answer_history';
  String get mistakesByCase => '${prefix}quiz_mistakes_by_case';
  String get score => '${prefix}quiz_score';
  String get streak => '${prefix}quiz_streak';
  String get bestStreakLap => '${prefix}quiz_best_streak_lap';
  String get bestStreakAbsolute => '${prefix}quiz_best_streak_absolute';

  /// Legacy key names ('..._pronouns' / '..._cases') are kept verbatim — even
  /// for non-pronoun quizzes — so users' saved subject/category selections
  /// survive this refactor.
  String get enabledSubjects => '${prefix}quiz_enabled_pronouns';
  String get enabledCategories => '${prefix}quiz_enabled_cases';
}
