import '../../../models/quiz_content.dart';
import '../es_de/es_de_builder.dart';

/// Builders for the "German Grammar in Detail" course (English speakers learning
/// German). Same shape as the Spanisch-Zertifikat (de_es) wrappers, but framed
/// for English → German: a [CourseItem]'s `prompt` is the **English** cue shown
/// to the learner and `answer` is the **German** target; all teaching text is in
/// English. A `**…**` marker inside the German answer isolates the single word
/// (e.g. the article) to blank — see [sentenceCourseQuiz].
export '../es_de/es_de_builder.dart' show CourseItem;

/// Fill-in quiz: English cue → German answer. Mark the quizzed word in the
/// German with `**…**` so just that word becomes the blank.
QuizContent enDeFill({
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
  categoryLabel: 'German',
  items: items,
  intro: intro,
  tips: tips,
);

/// Listen & repeat: the app speaks the German phrase (`answer`); the English
/// meaning (`prompt`) is shown underneath.
QuizContent enDeSpeak({
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
  subjectColumnLabel: 'German',
  items: items,
  intro: intro,
  tips: tips,
);

/// Listening ([QuizKind.listening]): the audio twin of [enDeRead]. The German
/// [passage] is the **hidden** script the app reads aloud; the learner answers
/// the [questions] from listening. The [passageTranslation] is the info-button
/// script.
QuizContent enDeListen({
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

/// Reading: a German [passage] (English [passageTranslation] behind an info
/// button) and German/English [questions].
QuizContent enDeRead({
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

/// A case-classification dropdown blank for the inline "big text": the learner
/// picks the [answer] case from the standard German three (Nominativ /
/// Akkusativ / Dativ, or a custom [options] set).
InlineBlank caseBlank(
  String answer, {
  List<String> options = const ['Nominativ', 'Akkusativ', 'Dativ'],
  String? translation,
}) => InlineBlank(
  kind: 'select',
  answer: answer,
  options: options,
  translation: translation,
);

/// A typed-input blank for the inline "big text" (e.g. an adjective ending the
/// learner types into the passage). [accepted] lists extra accepted spellings;
/// [hint] is shown faint inside the empty field.
InlineBlank inputBlank(
  String answer, {
  List<String> accepted = const [],
  String? hint,
}) => InlineBlank(kind: 'input', answer: answer, accepted: accepted, hint: hint);

final RegExp _inlinePlaceholder = RegExp(r'\{\{(\d+)\}\}');

/// Inline "big text" reading quiz: the [template] holds the passage with
/// `{{0}}`, `{{1}}`… placeholders, parallel to [blanks]. The clean read-first
/// passage (and the study-booklet text) is *derived* from the template —
/// `select` placeholders collapse to nothing, `input` placeholders are filled
/// with their answer — so one authored template drives both the inline exercise
/// and the printable passage. Runs through `InlineClozeQuizPage`.
QuizContent enDeBigText({
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
      .replaceAllMapped(_inlinePlaceholder, (m) {
        final blank = blanks[int.parse(m.group(1)!)];
        return blank.isSelect ? '' : blank.answer;
      })
      // Collapse any double spaces a removed select placeholder left behind, and
      // tidy a stray space before punctuation (replaceAllMapped, since
      // replaceAll does not substitute capture groups).
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
    subjectColumnLabel: 'German',
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

/// Dictation ([QuizKind.dictation]): the app reads each German line aloud and
/// the learner types what they hear (the English meaning is shown as the cue).
/// The shared builder set has no dictation helper, so this mirrors
/// [speakRepeatQuiz] with `kind: QuizKind.dictation`: the German [CourseItem.answer]
/// is the line to dictate, the English [CourseItem.prompt] its meaning.
QuizContent enDeDict({
  required String id,
  required String title,
  required List<CourseItem> items,
  required String intro,
  List<HelpMemoryTip> tips = const [],
}) {
  return QuizContent(
    id: id,
    title: title,
    kind: QuizKind.dictation,
    storageKeyPrefix: '${id}_',
    promptLabel: 'Sentence',
    subjectsLabel: 'Sentences',
    subjectColumnLabel: 'German',
    subjects: [
      for (var i = 0; i < items.length; i++)
        QuizSubjectData(
          key: 's$i',
          // The German line the learner hears and types.
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
}
