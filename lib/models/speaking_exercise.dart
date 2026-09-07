/// How the AI should run a [QuizKind.speaking] exercise.
///
/// The first three are the original spoken-conversation modes; the rest were
/// added for the all-AI course (en_de_ai) and cover text-first exercises too.
/// Unknown names parse as [conversation], so adding values stays seed-safe.
enum SpeakingMode {
  /// Free back-and-forth: the AI invents questions from the topic and reacts.
  conversation,

  /// Discrete questions, one at a time, each answered in full.
  interview,

  /// The AI plays the role described in the topic and stays in character.
  roleplay,

  /// Direct vocabulary questioning over the exercise's word list, both
  /// directions, with missed items re-asked before the end.
  vocabDrill,

  /// A little language game with explicit rules and scoring in the material.
  wordGame,

  /// The learner tells a story from the skeleton in the material.
  storytelling,

  /// The AI performs something aloud (voice) and the learner retells it.
  listenRetell,

  /// The AI presents the passage in the material and asks about it.
  readingQa,

  /// The AI writes a fresh passage under the material's constraints, then
  /// asks about it.
  readingGen,

  /// A writing task: the learner types a short text, graded against a rubric.
  writing,

  /// Sentence-by-sentence translation into the target language.
  translationDrill;

  static SpeakingMode fromName(String? name) => SpeakingMode.values.firstWhere(
    (m) => m.name == name,
    orElse: () => SpeakingMode.conversation,
  );
}

/// Session-length overrides. Anything null falls back to the manifest defaults.
///
/// The invariant the gate test enforces is
/// `practisePoints.length * minQuestionsPerPoint <= minExchanges`: a quiz that
/// demands more questions than it allows exchanges is impossible, and an AI
/// resolves that conflict by rushing, dropping practise points, or overrunning.
class SpeakingSession {
  const SpeakingSession({
    this.durationMinutes,
    this.minExchanges,
    this.minQuestionsPerPoint,
  });

  final int? durationMinutes;
  final int? minExchanges;
  final int? minQuestionsPerPoint;

  bool get isEmpty =>
      durationMinutes == null &&
      minExchanges == null &&
      minQuestionsPerPoint == null;

  Map<String, dynamic> toJson() => {
    if (durationMinutes != null) 'durationMinutes': durationMinutes,
    if (minExchanges != null) 'minExchanges': minExchanges,
    if (minQuestionsPerPoint != null)
      'minQuestionsPerPoint': minQuestionsPerPoint,
  };

  factory SpeakingSession.fromJson(Map<String, dynamic> json) =>
      SpeakingSession(
        durationMinutes: json['durationMinutes'] as int?,
        minExchanges: json['minExchanges'] as int?,
        minQuestionsPerPoint: json['minQuestionsPerPoint'] as int?,
      );
}

/// Report-length overrides. Null falls back to the manifest defaults.
class SpeakingReport {
  const SpeakingReport({this.maxWords, this.maxCorrections});

  final int? maxWords;
  final int? maxCorrections;

  bool get isEmpty => maxWords == null && maxCorrections == null;

  Map<String, dynamic> toJson() => {
    if (maxWords != null) 'maxWords': maxWords,
    if (maxCorrections != null) 'maxCorrections': maxCorrections,
  };

  factory SpeakingReport.fromJson(Map<String, dynamic> json) => SpeakingReport(
    maxWords: json['maxWords'] as int?,
    maxCorrections: json['maxCorrections'] as int?,
  );
}

/// The authored half of a speaking exercise: everything that differs between
/// one speaking quiz and the next. The other half — the ~60 lines of tutor
/// instructions that never change — lives in the per-UI-language templates under
/// `assets/content/speaking/`, and the two are merged into the copied prompt by
/// `SpeakingPromptBuilder`.
class SpeakingExercise {
  const SpeakingExercise({
    required this.topic,
    required this.practisePoints,
    required this.scoringCriteria,
    this.targetVocabulary = const [],
    this.priorityErrors = const [],
    this.material = '',
    this.scaffolded = false,
    this.mode = SpeakingMode.conversation,
    this.session = const SpeakingSession(),
    this.report = const SpeakingReport(),
    this.passScore,
  });

  /// What the conversation is about, one or two sentences.
  final String topic;

  /// The grammar concepts/forms to exercise. Author 3–4: each one costs at least
  /// `minQuestionsPerPoint` of the session's exchanges.
  final List<String> practisePoints;

  /// What the AI grades each answer on (rendered as a comma-joined list; the
  /// template appends "and whether the answer fits the question").
  final List<String> scoringCriteria;

  /// Words the AI should steer the learner into using — never revealed, never
  /// drilled, and reported if unused. Empty drops the whole section.
  final List<String> targetVocabulary;

  /// The error types worth reporting at this level; everything else is filtered
  /// out of the feedback so a short report stays useful.
  final List<String> priorityErrors;

  /// Pre-formatted material the exercise runs on — a word list with meanings
  /// (drill/game modes), an embedded reading passage, a story skeleton, game
  /// rules, or generation constraints. Rendered verbatim in its own prompt
  /// section; empty drops the section.
  final String material;

  /// Beginner scaffolding: the AI teaches the material first (UI-language
  /// explanations, target-language examples, unscored try-outs) and keeps
  /// instructions bilingual during the scored part. Answers still count only
  /// in the target language. Off = full immersion (B1+).
  final bool scaffolded;

  final SpeakingMode mode;
  final SpeakingSession session;
  final SpeakingReport report;

  /// Score (0–100) needed to complete the quiz. Null uses the manifest default.
  final int? passScore;

  Map<String, dynamic> toJson() => {
    'topic': topic,
    'practisePoints': practisePoints,
    'scoringCriteria': scoringCriteria,
    if (targetVocabulary.isNotEmpty) 'targetVocabulary': targetVocabulary,
    if (priorityErrors.isNotEmpty) 'priorityErrors': priorityErrors,
    if (material.isNotEmpty) 'material': material,
    if (scaffolded) 'scaffolded': true,
    if (mode != SpeakingMode.conversation) 'mode': mode.name,
    if (!session.isEmpty) 'session': session.toJson(),
    if (!report.isEmpty) 'report': report.toJson(),
    if (passScore != null) 'passScore': passScore,
  };

  factory SpeakingExercise.fromJson(Map<String, dynamic> json) =>
      SpeakingExercise(
        topic: json['topic'] as String? ?? '',
        practisePoints:
            (json['practisePoints'] as List?)?.cast<String>() ?? const [],
        scoringCriteria:
            (json['scoringCriteria'] as List?)?.cast<String>() ?? const [],
        targetVocabulary:
            (json['targetVocabulary'] as List?)?.cast<String>() ?? const [],
        priorityErrors:
            (json['priorityErrors'] as List?)?.cast<String>() ?? const [],
        material: json['material'] as String? ?? '',
        scaffolded: json['scaffolded'] as bool? ?? false,
        mode: SpeakingMode.fromName(json['mode'] as String?),
        session: json['session'] == null
            ? const SpeakingSession()
            : SpeakingSession.fromJson(
                Map<String, dynamic>.from(json['session'] as Map),
              ),
        report: json['report'] == null
            ? const SpeakingReport()
            : SpeakingReport.fromJson(
                Map<String, dynamic>.from(json['report'] as Map),
              ),
        passScore: json['passScore'] as int?,
      );
}

// ---------------------------------------------------------------------------
// Score → grade → medal
// ---------------------------------------------------------------------------

/// The 1–10 grade for a 0–100 [score], as the learner-facing number.
int speakingGrade(int score) {
  final g = (score / 10).round();
  return g.clamp(1, 10);
}

/// The medal tiers a speaking score can earn.
///
/// Deliberately *not* `RibbonTier`: that lives next to the ribbon widget and
/// drags Flutter in with it, and this file is on the import path of the plain
/// `dart run` content generators (see [kDataVersion]'s note). The UI maps these
/// onto the ribbon tiers, which is where the two meanings meet.
enum SpeakingMedal { bronze, silver, gold }

/// The medal a [score] earns: gold at grade 9–10, silver at 7–8, bronze at 5–6,
/// and **null** below that — a "try again", not a failure.
SpeakingMedal? speakingMedal(int score) {
  final grade = speakingGrade(score);
  if (grade >= 9) return SpeakingMedal.gold;
  if (grade >= 7) return SpeakingMedal.silver;
  if (grade >= 5) return SpeakingMedal.bronze;
  return null;
}

final RegExp _scoreLine = RegExp(
  r'SCORE\s*=\s*(\d{1,3})',
  caseSensitive: false,
);

/// Reads the score out of what the learner typed or pasted into the score field:
/// the AI's exact `SCORE=84` last line when the whole report was pasted, else a
/// bare number. Returns null for anything unparseable or outside 0–100, so the
/// Save button stays disabled rather than storing a wrong result.
///
/// The `SCORE=` line wins over a bare number so pasting a report that also
/// contains "FINAL SCORE: 84 / 100" can't pick up the 100.
int? parseSpeakingScore(String input) {
  final text = input.trim();
  if (text.isEmpty) return null;
  final tagged = _scoreLine.firstMatch(text);
  if (tagged != null) {
    final value = int.tryParse(tagged.group(1)!);
    return (value != null && value >= 0 && value <= 100) ? value : null;
  }
  final bare = int.tryParse(text);
  if (bare != null && bare >= 0 && bare <= 100) return bare;
  return null;
}
