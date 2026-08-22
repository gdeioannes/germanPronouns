import '../../../models/quiz_content.dart';
import '../../../models/speaking_exercise.dart';
import '../es_de/es_de_builder.dart';

/// Builders for the "Certification Spanish A1–C2" course (English speakers
/// learning Spanish, 🇬🇧 → 🇪🇸). Same shape as the `es_en` wrappers, mirrored:
/// a [CourseItem]'s `prompt` is the **English** cue shown to the learner and
/// `answer` is the **Spanish** target; all teaching text is authored in
/// English. A `**…**` marker inside the Spanish answer isolates the single
/// word (the article, the verb ending, the pronoun) to blank — see
/// [sentenceCourseQuiz]. Contrastive spine ⚑E1–E30 in
/// `docs/en_es_certification_plan.md`.
export '../es_de/es_de_builder.dart' show CourseItem;
export '../en_de/en_de_builder.dart' show inputBlank;
export '../../../models/speaking_exercise.dart'
    show SpeakingMode, SpeakingSession, SpeakingReport;

/// Fill-in quiz: English cue → Spanish answer. Mark the quizzed word in the
/// Spanish with `**…**` so just that word becomes the blank.
QuizContent enEsFill({
  required String id,
  required String title,
  required List<CourseItem> items,
  required String intro,
  List<HelpMemoryTip> tips = const [],
}) => sentenceCourseQuiz(
  id: id,
  title: title,
  promptLabel: 'Sentence',
  subjectsLabel: 'Sentences',
  subjectColumnLabel: 'English',
  categoryLabel: 'Español',
  items: items,
  intro: intro,
  tips: tips,
);

/// Vocab quiz: English term → Spanish term (single accepted answer per pair).
QuizContent enEsVocab({
  required String id,
  required String title,
  required List<MapEntry<String, String>> pairs,
  required String intro,
  String template = '"{subject}" in Spanish: ____',
  List<HelpMemoryTip> tips = const [],
}) => vocabCourseQuiz(
  id: id,
  title: title,
  promptLabel: 'Word',
  subjectsLabel: 'Words',
  subjectColumnLabel: 'English',
  categoryLabel: 'Español',
  template: template,
  pairs: pairs,
  intro: intro,
  tips: tips,
);

/// Listen & repeat ([QuizKind.speakRepeat]): the app speaks the Spanish phrase
/// (`answer`); the English meaning (`prompt`) is shown underneath.
QuizContent enEsSpeak({
  required String id,
  required String title,
  required List<CourseItem> items,
  required String intro,
  List<HelpMemoryTip> tips = const [],
}) => speakRepeatQuiz(
  id: id,
  title: title,
  promptLabel: 'Phrase',
  subjectsLabel: 'Phrases',
  subjectColumnLabel: 'Español',
  items: items,
  intro: intro,
  tips: tips,
);

/// Reading ([QuizKind.reading]): a Spanish [passage] (English
/// [passageTranslation] behind an info button) and Spanish/English [questions].
QuizContent enEsRead({
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
  category: 'Reading',
  passageTitle: passageTitle,
  passage: passage,
  passageTranslation: passageTranslation,
  questions: questions,
  intro: intro,
  tips: tips,
);

/// Listening ([QuizKind.listening]): the audio twin of [enEsRead]. The Spanish
/// [passage] is the **hidden** script the app reads aloud; the learner answers
/// the [questions] from listening. The English [passageTranslation] is the
/// info-button script.
QuizContent enEsListen({
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
  promptLabel: 'Question',
  subjectsLabel: 'Questions',
  subjectColumnLabel: 'Question',
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

/// Dictation ([QuizKind.dictation]): the app reads each Spanish line aloud and
/// the learner **types** what they hear (the English meaning is shown as the
/// cue). Targets what English ears miss in Spanish: gender endings, written
/// accents, clitic pronouns glued to the verb (⚑E5, ⚑E7, ⚑E17).
QuizContent enEsDict({
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
  promptLabel: 'Sentence',
  subjectsLabel: 'Sentences',
  subjectColumnLabel: 'Español',
  subjects: [
    for (var i = 0; i < items.length; i++)
      QuizSubjectData(
        key: 's$i',
        // The Spanish line the learner hears and types.
        display: items[i].answer,
        // The English meaning, shown as the cue.
        english: items[i].prompt,
      ),
  ],
  categories: const [],
  sentences: const [],
  helpMemoryIntro: intro,
  helpMemoryTips: tips,
);

/// Inline "big text" reading quiz for this course: a Spanish passage with
/// `{{0}}`, `{{1}}`… placeholders resolved against [blanks]. The clean
/// read-first passage is derived from the template. Runs through
/// `InlineClozeQuizPage`.
QuizContent enEsBigText({
  required String id,
  required String title,
  required String passageTitle,
  required String template,
  required List<InlineBlank> blanks,
  required String passageTranslation,
  required String intro,
  List<HelpMemoryTip> tips = const [],
}) {
  final clean = template
      .replaceAllMapped(RegExp(r'\{\{(\d+)\}\}'), (m) {
        final blank = blanks[int.parse(m.group(1)!)];
        return blank.isSelect ? '' : blank.answer;
      })
      .replaceAll(RegExp(r' {2,}'), ' ')
      .replaceAllMapped(RegExp(r' ([.,!?])'), (m) => m.group(1)!)
      .trim();
  return QuizContent(
    id: id,
    title: title,
    kind: QuizKind.reading,
    storageKeyPrefix: '${id}_',
    promptLabel: 'Sentence',
    subjectsLabel: 'Sentences',
    subjectColumnLabel: 'Español',
    subjects: const [],
    categories: const [],
    sentences: const [],
    readingCategory: 'Reading',
    readingTitle: passageTitle,
    readingPassage: clean,
    readingPassageTranslation: passageTranslation,
    inlineTemplate: template,
    inlineBlanks: blanks,
    helpMemoryIntro: intro,
    helpMemoryTips: tips,
  );
}

/// Speaking ([QuizKind.speaking]): a conversation exercise the learner runs in
/// their own AI assistant (English template). Keep [practisePoints] to 3–4 —
/// the gate test enforces `practisePoints × minQuestionsPerPoint <= minExchanges`.
QuizContent enEsSpeaking({
  required String id,
  required String title,
  required String level,
  required String topic,
  required List<String> practisePoints,
  required List<String> scoringCriteria,
  required String intro,
  List<String> targetVocabulary = const [],
  List<String> priorityErrors = const [],
  SpeakingMode mode = SpeakingMode.conversation,
  SpeakingSession session = const SpeakingSession(),
  SpeakingReport report = const SpeakingReport(),
  int? passScore,
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
    mode: mode,
    session: session,
    report: report,
    passScore: passScore,
  ),
  helpMemoryIntro: intro,
  helpMemoryTips: tips,
);
