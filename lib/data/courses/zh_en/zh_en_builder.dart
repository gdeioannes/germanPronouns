import '../../../models/quiz_content.dart';
import '../es_de/es_de_builder.dart';

/// Builders for the "英语认证 A1–C2" course (Mandarin-Chinese speakers learning
/// English, 🇨🇳 → 🇬🇧). Same shape as the `de_es` / `en_de` wrappers, but framed
/// for "say it in English": a [CourseItem]'s `prompt` is the **Chinese** cue
/// shown to the learner and `answer` is the **English** target; all teaching
/// text (intros, tips) is authored in Chinese. A `**…**` marker inside the
/// English answer isolates the single word (e.g. the article, the `be`-form, the
/// `-s`) to blank — see [sentenceCourseQuiz].
export '../es_de/es_de_builder.dart' show CourseItem;

/// Fill-in quiz: Chinese cue → English answer. Mark the quizzed word in the
/// English with `**…**` so just that word becomes the blank (the rest shows as
/// context, which is what we want when *English* is the language being learned).
QuizContent zhEnFill({
  required String id,
  required String title,
  required List<CourseItem> items,
  required String intro,
  List<HelpMemoryTip> tips = const [],
}) => sentenceCourseQuiz(
  id: id,
  title: title,
  promptLabel: '句子',
  subjectsLabel: '句子',
  subjectColumnLabel: '中文',
  categoryLabel: 'English',
  items: items,
  intro: intro,
  tips: tips,
);

/// Vocab quiz: Chinese term → English term (single accepted answer per pair).
QuizContent zhEnVocab({
  required String id,
  required String title,
  required List<MapEntry<String, String>> pairs,
  required String intro,
  String template = '「{subject}」的英文：____',
  List<HelpMemoryTip> tips = const [],
}) => vocabCourseQuiz(
  id: id,
  title: title,
  promptLabel: '词',
  subjectsLabel: '词',
  subjectColumnLabel: '中文',
  categoryLabel: 'English',
  template: template,
  pairs: pairs,
  intro: intro,
  tips: tips,
);

/// Listen & repeat ([QuizKind.speakRepeat]): the app speaks the English phrase
/// (`answer`); the Chinese meaning (`prompt`) is shown underneath.
QuizContent zhEnSpeak({
  required String id,
  required String title,
  required List<CourseItem> items,
  required String intro,
  List<HelpMemoryTip> tips = const [],
}) => speakRepeatQuiz(
  id: id,
  title: title,
  promptLabel: '短语',
  subjectsLabel: '短语',
  subjectColumnLabel: 'English',
  items: items,
  intro: intro,
  tips: tips,
);

/// Reading ([QuizKind.reading]): an English [passage] (Chinese
/// [passageTranslation] behind an info button) and English [questions].
QuizContent zhEnRead({
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
  category: '阅读',
  passageTitle: passageTitle,
  passage: passage,
  passageTranslation: passageTranslation,
  questions: questions,
  intro: intro,
  tips: tips,
);

/// Listening ([QuizKind.listening]): the audio twin of [zhEnRead]. The English
/// [passage] is the **hidden** script the app reads aloud; the learner answers
/// the [questions] from listening. The Chinese [passageTranslation] is the
/// info-button script. Mirrors the shared reading data shape with
/// `kind: QuizKind.listening`.
QuizContent zhEnListen({
  required String id,
  required String title,
  required String passageTitle,
  required String passage,
  required String passageTranslation,
  required List<ReadingQuestion> questions,
  required String intro,
  List<HelpMemoryTip> tips = const [],
}) => QuizContent(
  id: id,
  title: title,
  kind: QuizKind.listening,
  storageKeyPrefix: '${id}_',
  promptLabel: '问题',
  subjectsLabel: '问题',
  subjectColumnLabel: '问题',
  subjects: const [],
  categories: const [],
  sentences: const [],
  readingCategory: 'Listening',
  readingTitle: passageTitle,
  readingPassage: passage,
  readingPassageTranslation: passageTranslation,
  readingQuestions: questions,
  helpMemoryIntro: intro,
  helpMemoryTips: tips,
);

/// Dictation ([QuizKind.dictation]): the app reads each English line aloud and
/// the learner **types** what they hear (the Chinese meaning is shown as the
/// cue). The [CourseItem.answer] is the English line to dictate,
/// [CourseItem.prompt] its Chinese meaning. This is the highest-signal drill for
/// this L1: it forces perception + production of the `-s`, `-ed`, and articles a
/// Chinese learner habitually drops.
QuizContent zhEnDict({
  required String id,
  required String title,
  required List<CourseItem> items,
  required String intro,
  List<HelpMemoryTip> tips = const [],
}) => QuizContent(
  id: id,
  title: title,
  kind: QuizKind.dictation,
  storageKeyPrefix: '${id}_',
  promptLabel: '句子',
  subjectsLabel: '句子',
  subjectColumnLabel: 'English',
  subjects: [
    for (var i = 0; i < items.length; i++)
      QuizSubjectData(
        key: 's$i',
        // The English line the learner hears and types.
        display: items[i].answer,
        // The Chinese meaning, shown as the cue.
        english: items[i].prompt,
      ),
  ],
  categories: const [],
  sentences: const [],
  helpMemoryIntro: intro,
  helpMemoryTips: tips,
);
