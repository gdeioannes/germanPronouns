import '../../../models/quiz_content.dart';

/// Builders for the Español → Alemán course. Same shape as the German Quest
/// helpers, but framed for "say it in German": the subject is a Spanish phrase
/// and the answer is its German form. Teaching text is authored in Spanish.

/// A single-answer "say it in German" quiz from [pairs] (Spanish → German).
/// [template] is the fill-in prompt (must contain `____`; `{subject}` is the
/// Spanish phrase).
QuizContent vocabCourseQuiz({
  required String id,
  required String title,
  required String promptLabel,
  required String subjectsLabel,
  required String subjectColumnLabel,
  required String categoryLabel,
  required List<MapEntry<String, String>> pairs,
  String template = '«{subject}» en alemán: ____',
  String? intro,
  List<HelpMemoryTip> tips = const [],
}) {
  return QuizContent(
    id: id,
    title: title,
    storageKeyPrefix: '${id}_',
    promptLabel: promptLabel,
    subjectsLabel: subjectsLabel,
    subjectColumnLabel: subjectColumnLabel,
    subjects: [for (final p in pairs) QuizSubjectData(key: p.key, display: p.key)],
    categories: [
      QuizCategoryData(
        label: categoryLabel,
        group: categoryLabel,
        values: [for (final p in pairs) p.value],
      ),
    ],
    sentences: const [],
    sentenceTemplates: {
      categoryLabel: [template],
    },
    helpMemoryIntro: intro,
    helpMemoryTips: tips,
  );
}

/// One explicit-answer item: a German [answer] for the Spanish [prompt], with
/// every accepted German spelling, and an optional hint.
class CourseItem {
  const CourseItem({
    required this.prompt,
    required this.answer,
    List<String>? accepted,
    this.hint,
  }) : accepted = accepted ?? const [];

  /// The Spanish phrase shown to the learner.
  final String prompt;

  /// The main German answer (revealed when wrong).
  final String answer;

  /// Other accepted German forms (case-insensitive).
  final List<String> accepted;

  /// Optional Spanish hint, revealed via the eye icon.
  final String? hint;
}

/// A "say it in German" quiz where several German forms are accepted. The
/// subject display is the Spanish prompt; one stored sentence per item carries
/// the accepted German answers.
QuizContent sentenceCourseQuiz({
  required String id,
  required String title,
  required String promptLabel,
  required String subjectsLabel,
  required String subjectColumnLabel,
  required String categoryLabel,
  required List<CourseItem> items,
  String? intro,
  List<HelpMemoryTip> tips = const [],
}) {
  return QuizContent(
    id: id,
    title: title,
    storageKeyPrefix: '${id}_',
    promptLabel: promptLabel,
    subjectsLabel: subjectsLabel,
    subjectColumnLabel: subjectColumnLabel,
    subjects: [
      for (var i = 0; i < items.length; i++)
        QuizSubjectData(key: 's$i', display: items[i].prompt),
    ],
    categories: [
      QuizCategoryData(
        label: categoryLabel,
        group: categoryLabel,
        values: [for (final it in items) it.answer],
      ),
    ],
    sentences: [
      for (var i = 0; i < items.length; i++)
        QuizSentenceData(
          subjectKey: 's$i',
          categoryLabel: categoryLabel,
          // Unique per item (the Spanish prompt) so accepted answers don't
          // collapse; shows the prompt with the blank.
          sentence: '${items[i].prompt} → ____',
          acceptedAnswers: {items[i].answer, ...items[i].accepted}.toList(),
          english: items[i].prompt,
          hint: items[i].hint,
        ),
    ],
    helpMemoryIntro: intro,
    helpMemoryTips: tips,
  );
}
