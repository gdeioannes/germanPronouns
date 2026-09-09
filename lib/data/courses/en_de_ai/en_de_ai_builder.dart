import '../../../models/quiz_content.dart';
import '../../../models/speaking_exercise.dart';

// Re-exported so module files can tune mode/session/report and author tips
// without importing the models directly.
export '../../../models/quiz_config.dart' show HelpMemoryTip;
export '../../../models/speaking_exercise.dart'
    show SpeakingMode, SpeakingSession, SpeakingReport;

/// The one builder of the "German with Your AI Coach" course (en_de_ai):
/// every exercise is a [QuizKind.speaking] prompt the learner copies into
/// their own AI assistant, whatever the mode — conversation, vocabulary
/// drill, word game, storytelling, reading, writing or translation. The app
/// renders the prompt and records the `SCORE=` the AI hands back.
///
/// Conventions for this course (see `docs/en_de_ai_course_plan.md`):
/// - [material] carries the exercise's curriculum payload verbatim — a word
///   list with meanings, an embedded passage, story beats, game rules, or
///   generation constraints. Author it as short plain-text lines.
/// - Keep [practisePoints] to 3–4; the gate test enforces
///   `practisePoints.length * minQuestionsPerPoint <= minExchanges`.
/// - Session length and passScore rise with the level (A1 3 min/6 exchanges
///   pass 50 → C1+ 5–6 min/10 exchanges pass 70); pass them explicitly.
/// - From B2.1 on the closing report is written in German (course policy,
///   applied below via [reportLanguage] — never as topic text, which the
///   template's own report-language line would override).
QuizContent enDeAiEx({
  required String id,
  required String title,
  required String level,
  required String topic,
  required List<String> practisePoints,
  required List<String> scoringCriteria,
  required String intro,
  String material = '',
  List<String> targetVocabulary = const [],
  List<String> priorityErrors = const [],
  SpeakingMode mode = SpeakingMode.conversation,
  SpeakingSession session = const SpeakingSession(),
  SpeakingReport report = const SpeakingReport(),
  int? passScore,
  bool? scaffolded,
  String? reportLanguage,
  List<HelpMemoryTip> tips = const [],
}) => QuizContent(
  id: id,
  title: title,
  kind: QuizKind.speaking,
  level: level,
  storageKeyPrefix: '${id}_',
  promptLabel: 'Exercise',
  subjectsLabel: 'Exercise',
  subjectColumnLabel: 'Exercise',
  subjects: const [],
  categories: const [],
  sentences: const [],
  speaking: SpeakingExercise(
    topic: topic,
    practisePoints: practisePoints,
    scoringCriteria: scoringCriteria,
    targetVocabulary: targetVocabulary,
    priorityErrors: priorityErrors,
    material: material,
    // Every exercise teaches before it tests: the AI walks through the
    // material first (explanations in English, examples in German, unscored
    // try-outs) and keeps instructions in English during the scored part —
    // at every level A1.1 → C2.2. Override per quiz if ever needed.
    scaffolded: scaffolded ?? true,
    mode: mode,
    session: session,
    report: report,
    passScore: passScore,
    reportLanguage:
        reportLanguage ??
        (level.startsWith('B2') || level.startsWith('C') ? 'de' : null),
  ),
  helpMemoryIntro: intro,
  helpMemoryTips: tips,
);
