import '../../../models/quiz_content.dart';
import '../../../models/speaking_exercise.dart';
import '../es_de/es_de_builder.dart';

/// Builders for the "Certificación de Inglés A1–C2" course (Spanish speakers
/// learning English, 🇪🇸 → 🇬🇧). Same shape as the `zh_en` wrappers, but framed
/// in Spanish: a [CourseItem]'s `prompt` is the **Spanish** cue shown to the
/// learner and `answer` is the **English** target; all teaching text (intros,
/// tips) is authored in Spanish. A `**…**` marker inside the English answer
/// isolates the single word (the article, the `-s`, the auxiliary) to blank —
/// see [sentenceCourseQuiz]. Contrastive spine ⚑S1–S30 in
/// `docs/es_en_certification_plan.md`.
export '../es_de/es_de_builder.dart' show CourseItem;
export '../en_de/en_de_builder.dart' show inputBlank;
export '../../../models/speaking_exercise.dart'
    show SpeakingMode, SpeakingSession, SpeakingReport;

/// Fill-in quiz: Spanish cue → English answer. Mark the quizzed word in the
/// English with `**…**` so just that word becomes the blank.
QuizContent esEnFill({
  required String id,
  required String title,
  required List<CourseItem> items,
  required String intro,
  List<HelpMemoryTip> tips = const [],
}) => sentenceCourseQuiz(
  id: id,
  title: title,
  promptLabel: 'Frase',
  subjectsLabel: 'Frases',
  subjectColumnLabel: 'Español',
  categoryLabel: 'English',
  items: items,
  intro: intro,
  tips: tips,
);

/// Vocab quiz: Spanish term → English term (single accepted answer per pair).
QuizContent esEnVocab({
  required String id,
  required String title,
  required List<MapEntry<String, String>> pairs,
  required String intro,
  String template = '«{subject}» en inglés: ____',
  List<HelpMemoryTip> tips = const [],
}) => vocabCourseQuiz(
  id: id,
  title: title,
  promptLabel: 'Palabra',
  subjectsLabel: 'Palabras',
  subjectColumnLabel: 'Español',
  categoryLabel: 'English',
  template: template,
  pairs: pairs,
  intro: intro,
  tips: tips,
);

/// Listen & repeat ([QuizKind.speakRepeat]): the app speaks the English phrase
/// (`answer`); the Spanish meaning (`prompt`) is shown underneath.
QuizContent esEnSpeak({
  required String id,
  required String title,
  required List<CourseItem> items,
  required String intro,
  List<HelpMemoryTip> tips = const [],
}) => speakRepeatQuiz(
  id: id,
  title: title,
  promptLabel: 'Frase',
  subjectsLabel: 'Frases',
  subjectColumnLabel: 'English',
  items: items,
  intro: intro,
  tips: tips,
);

/// Reading ([QuizKind.reading]): an English [passage] (Spanish
/// [passageTranslation] behind an info button) and English [questions].
QuizContent esEnRead({
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

/// Listening ([QuizKind.listening]): the audio twin of [esEnRead]. The English
/// [passage] is the **hidden** script the app reads aloud; the learner answers
/// the [questions] from listening. The Spanish [passageTranslation] is the
/// info-button script.
QuizContent esEnListen({
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
  promptLabel: 'Pregunta',
  subjectsLabel: 'Preguntas',
  subjectColumnLabel: 'Pregunta',
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
/// the learner **types** what they hear (the Spanish meaning is shown as the
/// cue). Highest-signal drill for this L1: it forces perception of final
/// consonants, the `-ed`/`-s` endings and the weak forms Spanish ears miss
/// (⚑S6, ⚑S7, ⚑S10).
QuizContent esEnDict({
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
  promptLabel: 'Frase',
  subjectsLabel: 'Frases',
  subjectColumnLabel: 'English',
  subjects: [
    for (var i = 0; i < items.length; i++)
      QuizSubjectData(
        key: 's$i',
        // The English line the learner hears and types.
        display: items[i].answer,
        // The Spanish meaning, shown as the cue.
        english: items[i].prompt,
      ),
  ],
  categories: const [],
  sentences: const [],
  helpMemoryIntro: intro,
  helpMemoryTips: tips,
);

/// Inline "big text" reading quiz for this course: an English passage with
/// `{{0}}`, `{{1}}`… placeholders resolved against [blanks] (use [inputBlank]
/// / [InlineBlank] from the shared set). The clean read-first passage is
/// derived from the template. Runs through `InlineClozeQuizPage`.
QuizContent esEnBigText({
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
    promptLabel: 'Frase',
    subjectsLabel: 'Frases',
    subjectColumnLabel: 'English',
    subjects: const [],
    categories: const [],
    sentences: const [],
    readingCategory: 'Lectura',
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
/// their own AI assistant (prompt rendered from the Spanish template in
/// `assets/content/speaking/template.es.json`). Keep [practisePoints] to 3–4 —
/// the gate test enforces `practisePoints × minQuestionsPerPoint <= minExchanges`.
QuizContent esEnSpeaking({
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
  promptLabel: 'Ejercicio',
  subjectsLabel: 'Ejercicio',
  subjectColumnLabel: 'Ejercicio',
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
