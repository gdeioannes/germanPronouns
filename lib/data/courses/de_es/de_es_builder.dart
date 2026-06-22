import '../../../models/quiz_content.dart';
import '../es_de/es_de_builder.dart';

/// Thin German-framed wrappers over the shared course builders (reused from the
/// Español → Alemán course) for the "Spanisch-Zertifikat" (Deutsch → Spanisch)
/// course. Here a [CourseItem]'s `prompt` is the **German** phrase shown to the
/// learner and `answer` is the **Spanish** target; all teaching text is German.
/// These wrappers fix the column labels so the 105 quizzes stay compact.
export '../es_de/es_de_builder.dart' show CourseItem;

/// Fill-in quiz: German prompt → Spanish answer. Each [CourseItem] may isolate a
/// single Spanish word to quiz with the `**…**` marker (see `sentenceCourseQuiz`).
QuizContent deEsFill({
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
  categoryLabel: 'Auf Spanisch',
  items: items,
  intro: intro,
  tips: tips,
);

/// Vocab quiz: German term → Spanish term (single accepted answer per pair).
QuizContent deEsVocab({
  required String id,
  required String title,
  required List<MapEntry<String, String>> pairs,
  required String intro,
  String template = '»{subject}« auf Spanisch: ____',
  List<HelpMemoryTip> tips = const [],
}) => vocabCourseQuiz(
  id: id,
  title: title,
  promptLabel: 'Wort',
  subjectsLabel: 'Wörter',
  subjectColumnLabel: 'Deutsch',
  categoryLabel: 'Auf Spanisch',
  template: template,
  pairs: pairs,
  intro: intro,
  tips: tips,
);

/// Listen & repeat: the app speaks the Spanish phrase (`answer`); the German
/// meaning (`prompt`) is shown underneath.
QuizContent deEsSpeak({
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
  subjectColumnLabel: 'Spanisch',
  items: items,
  intro: intro,
  tips: tips,
);

/// Reading: a Spanish [passage] (German [passageTranslation] behind an info
/// button) and Spanish [questions].
QuizContent deEsRead({
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
  category: 'Lectura',
  passageTitle: passageTitle,
  passage: passage,
  passageTranslation: passageTranslation,
  questions: questions,
  intro: intro,
  tips: tips,
);
