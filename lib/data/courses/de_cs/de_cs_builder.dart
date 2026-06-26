import '../../../models/quiz_content.dart';
import '../es_de/es_de_builder.dart';

/// Thin German-framed wrappers over the shared course builders (reused from the
/// Español → Alemán course) for the "Tschechisch entdecken" intro course
/// (Deutsch → Tschechisch). Here a [CourseItem]'s `prompt` is the **German**
/// phrase shown to the learner and `answer` is the **Czech** target; all teaching
/// text is German. These wrappers fix the column labels so the quizzes stay
/// compact, exactly as `de_es_builder.dart` does for Spanish.
export '../es_de/es_de_builder.dart' show CourseItem;

/// Fill-in quiz: German prompt → Czech answer. Each [CourseItem] may isolate a
/// single Czech word to quiz with the `**…**` marker (see `sentenceCourseQuiz`).
QuizContent deCsFill({
  required String id,
  required String title,
  required List<CourseItem> items,
  required String intro,
  List<HelpMemoryTip> tips = const [],
}) => sentenceCourseQuiz(
  id: id,
  title: title,
  promptLabel: 'Satz',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Deutsch',
  categoryLabel: 'Auf Tschechisch',
  items: items,
  intro: intro,
  tips: tips,
);

/// Vocab quiz: German term → Czech term (single accepted answer per pair).
QuizContent deCsVocab({
  required String id,
  required String title,
  required List<MapEntry<String, String>> pairs,
  required String intro,
  String template = '»{subject}« auf Tschechisch: ____',
  List<HelpMemoryTip> tips = const [],
}) => vocabCourseQuiz(
  id: id,
  title: title,
  promptLabel: 'Wort',
  subjectsLabel: 'Wörter',
  subjectColumnLabel: 'Deutsch',
  categoryLabel: 'Auf Tschechisch',
  template: template,
  pairs: pairs,
  intro: intro,
  tips: tips,
);

/// Listen & repeat: the app speaks the Czech phrase (`answer`); the German
/// meaning — here enriched with the French parallel and a micro-tip — (`prompt`)
/// is shown underneath. Only the Czech `answer` is sent to TTS, so the French
/// text is shown, never mis-pronounced by the Czech voice.
QuizContent deCsSpeak({
  required String id,
  required String title,
  required List<CourseItem> items,
  required String intro,
  List<HelpMemoryTip> tips = const [],
}) => speakRepeatQuiz(
  id: id,
  title: title,
  promptLabel: 'Satz',
  subjectsLabel: 'Sätze',
  subjectColumnLabel: 'Tschechisch',
  items: items,
  intro: intro,
  tips: tips,
);

/// Reading: a Czech [passage] (German [passageTranslation] behind an info
/// button) and Czech [questions] (each with a German `questionTranslation`).
QuizContent deCsRead({
  required String id,
  required String title,
  required String passageTitle,
  required String passage,
  required String passageTranslation,
  required List<ReadingQuestion> questions,
  required String intro,
  List<HelpMemoryTip> tips = const [],
}) => readingCourseQuiz(
  id: id,
  title: title,
  category: 'Lektüre',
  passageTitle: passageTitle,
  passage: passage,
  passageTranslation: passageTranslation,
  questions: questions,
  intro: intro,
  tips: tips,
);
