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

/// A "listen & repeat" pronunciation quiz ([QuizKind.speakRepeat]). The app
/// reads each German phrase aloud (TTS) and the learner repeats it (STT). Each
/// [CourseItem]'s German [CourseItem.answer] is the phrase to speak and show;
/// its Spanish [CourseItem.prompt] is shown underneath as the meaning. The
/// fill-in fields ([QuizContent.categories]/[QuizContent.sentences]) are left
/// empty — speak quizzes are rendered by `SpeakRepeatQuizPage`, not the engine.
QuizContent speakRepeatQuiz({
  required String id,
  required String title,
  required String promptLabel,
  required String subjectsLabel,
  required String subjectColumnLabel,
  required List<CourseItem> items,
  String? intro,
  List<HelpMemoryTip> tips = const [],
}) {
  return QuizContent(
    id: id,
    title: title,
    kind: QuizKind.speakRepeat,
    storageKeyPrefix: '${id}_',
    promptLabel: promptLabel,
    subjectsLabel: subjectsLabel,
    subjectColumnLabel: subjectColumnLabel,
    subjects: [
      for (var i = 0; i < items.length; i++)
        QuizSubjectData(
          key: 's$i',
          // The German phrase the learner hears and repeats.
          display: items[i].answer,
          // Repurposed (like the other es_de builders) to carry the Spanish
          // meaning, shown under the phrase.
          english: items[i].prompt,
        ),
    ],
    categories: const [],
    sentences: const [],
    helpMemoryIntro: intro,
    helpMemoryTips: tips,
  );
}

/// A reading-comprehension quiz ([QuizKind.reading]) for the Español → Alemán
/// course: a short German [passage] and German [questions], all read and
/// answered in German. The Spanish [passageTranslation] and the per-question
/// translations are offered behind info buttons, so the learner reads the
/// German first. The fill-in fields are left empty — it renders through
/// `ReadingQuizPage`, like the Quest reading quizzes.
QuizContent readingCourseQuiz({
  required String id,
  required String title,
  required String category,
  required String passageTitle,
  required String passage,
  required List<ReadingQuestion> questions,
  String? passageTranslation,
  String? intro,
  List<HelpMemoryTip> tips = const [],
}) {
  return QuizContent(
    id: id,
    title: title,
    kind: QuizKind.reading,
    storageKeyPrefix: '${id}_',
    // Reading runs on its own page; these labels just keep the content valid
    // and give the back-office list something sensible to show.
    promptLabel: 'Pregunta',
    subjectsLabel: 'Preguntas',
    subjectColumnLabel: 'Pregunta',
    subjects: const [],
    categories: const [],
    sentences: const [],
    readingCategory: category,
    readingTitle: passageTitle,
    readingPassage: passage,
    readingPassageTranslation: passageTranslation,
    readingQuestions: questions,
    helpMemoryIntro: intro,
    helpMemoryTips: tips,
  );
}

/// Marks the vocabulary word to isolate inside a German [CourseItem.answer].
/// Wrapping a word in `**…**` (e.g. `**Vertrauen** baut sich langsam wieder
/// auf`) turns just that word into the blank — the rest of the sentence is
/// shown as context — and makes it the only accepted answer. An answer with no
/// marker keeps the full-sentence behavior: the learner types the whole German
/// translation. The `**…**` convention is the same one the Help Memory uses to
/// bold the quizzed word, so the reference table renders these consistently.
final RegExp _focusWordMarker = RegExp(r'\*\*(.+?)\*\*');

/// The engine data derived from a [CourseItem]: the German [template] (with
/// `____` where the blank goes), the [acceptedAnswers] for that blank, and the
/// [categoryValue] used as the answer key (and first-letter-hint source). For a
/// marked item the blank is the single isolated word; otherwise it is the whole
/// sentence.
({String template, List<String> acceptedAnswers, String categoryValue})
_courseItemCloze(CourseItem item) {
  final marker = _focusWordMarker.firstMatch(item.answer);
  if (marker == null) {
    return (
      template: '____',
      acceptedAnswers: {item.answer, ...item.accepted}.toList(),
      categoryValue: item.answer,
    );
  }
  final word = marker.group(1)!;
  // Blank out only the marked word; strip any stray markers so none render.
  final template = item.answer
      .replaceRange(marker.start, marker.end, '____')
      .replaceAll('**', '');
  return (
    template: template,
    acceptedAnswers: {word, ...item.accepted}.toList(),
    categoryValue: word,
  );
}

/// The Spanish [keyword] marked inside a [CourseItem.prompt] with `**…**`
/// (mirroring the German marker), plus the [cleanPrompt] with the markers
/// stripped. The clean prompt is what the live quiz shows and keys on; the
/// keyword feeds the Help Memory's both-languages vocabulary cell. A prompt with
/// no marker yields a null keyword (the reference cell then keeps the prompt).
({String cleanPrompt, String? keyword}) _promptKeyword(String prompt) {
  final marker = _focusWordMarker.firstMatch(prompt);
  if (marker == null) return (cleanPrompt: prompt, keyword: null);
  return (cleanPrompt: prompt.replaceAll('**', ''), keyword: marker.group(1));
}

/// A "say it in German" quiz where several German forms are accepted. The
/// subject display is the Spanish prompt; one stored sentence per item carries
/// the accepted German answers. Each item may isolate a single vocabulary word
/// to quiz via a `**…**` marker (see [_courseItemCloze]); the Spanish
/// [CourseItem.prompt] may mark its matching word the same way, which the Help
/// Memory reference table shows as a `palabra · **Wort**` pair plus a
/// both-languages example, instead of repeating the full Spanish prompt.
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
  final clozes = [for (final it in items) _courseItemCloze(it)];
  final prompts = [for (final it in items) _promptKeyword(it.prompt)];
  return QuizContent(
    id: id,
    title: title,
    storageKeyPrefix: '${id}_',
    promptLabel: promptLabel,
    subjectsLabel: subjectsLabel,
    subjectColumnLabel: subjectColumnLabel,
    subjects: [
      for (var i = 0; i < items.length; i++)
        QuizSubjectData(
          key: 's$i',
          display: prompts[i].cleanPrompt,
          // The Help Memory shows the vocabulary word in both languages
          // (Spanish keyword + the bold German word) when the prompt marks one,
          // so the row no longer repeats the whole Spanish sentence.
          referenceLabel: prompts[i].keyword == null
              ? null
              : '${prompts[i].keyword} · **${clozes[i].categoryValue}**',
        ),
    ],
    categories: [
      QuizCategoryData(
        label: categoryLabel,
        group: categoryLabel,
        values: [for (final c in clozes) c.categoryValue],
      ),
    ],
    sentences: [
      for (var i = 0; i < items.length; i++)
        QuizSentenceData(
          subjectKey: 's$i',
          categoryLabel: categoryLabel,
          // Unique per item (the Spanish prompt) so accepted answers don't
          // collapse; shows the prompt, then the German with the blank.
          sentence: '${prompts[i].cleanPrompt} → ${clozes[i].template}',
          acceptedAnswers: clozes[i].acceptedAnswers,
          english: prompts[i].cleanPrompt,
          hint: items[i].hint,
          // Both-languages example for the reference column, with the Spanish
          // and German words bold (kept as authored). Only when the prompt
          // marks a keyword; otherwise the adapter fills the blank itself.
          referenceExample: prompts[i].keyword == null
              ? null
              : '${items[i].prompt} → ${items[i].answer}',
        ),
    ],
    helpMemoryIntro: intro,
    helpMemoryTips: tips,
  );
}
