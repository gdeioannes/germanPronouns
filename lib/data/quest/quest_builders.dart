import '../../models/quiz_content.dart';

/// One explicit-answer item: a German [sentence] with a `____` blank (a clue or
/// a contextual sentence), the [answer] revealed when wrong, every accepted
/// spelling, an English gloss/translation, and an optional hint/explanation.
class QuestSentenceItem {
  const QuestSentenceItem({
    required this.sentence,
    required this.answer,
    required this.english,
    this.gloss,
    List<String>? accepted,
    this.hint,
    this.explanation,
  }) : accepted = accepted ?? const [];

  final String sentence;
  final String answer;
  final String english;

  /// Short label for the Help Memory reference table row (e.g. "mother" so it
  /// reads "mother → die Mutter"). When null, it is derived from the trailing
  /// parenthetical of [english] (e.g. "… (the mother)" → "mother"), falling back
  /// to the full [english].
  final String? gloss;

  final List<String> accepted;
  final String? hint;
  final String? explanation;
}

/// The Help Memory row label for [item]: its explicit gloss, else the trailing
/// "(…)" of its English (with a leading the/a/an stripped), else the English.
String _glossFor(QuestSentenceItem item) {
  if (item.gloss != null) return item.gloss!;
  final match = RegExp(r'\(([^)]+)\)[^)]*$').firstMatch(item.english);
  if (match != null) {
    return match
        .group(1)!
        .trim()
        .replaceFirst(RegExp(r'^(the|a|an)\s+', caseSensitive: false), '');
  }
  return item.english;
}

/// Compact positional constructor for a [QuestSentenceItem], used by the longer
/// A2–C2 content lists to keep each item to one or two lines:
/// `qsi('German ____', 'answer', 'English', 'gloss')`.
QuestSentenceItem qsi(
  String sentence,
  String answer,
  String english,
  String gloss, {
  List<String>? accepted,
}) =>
    QuestSentenceItem(
      sentence: sentence,
      answer: answer,
      english: english,
      gloss: gloss,
      accepted: accepted,
    );

/// Builds a single-category explicit-answer quiz. Each item becomes one subject
/// (keyed `s0`…, displayed as its English gloss) and one stored sentence, so the
/// learner reads a German clue/sentence (with its English translation) and types
/// the missing word. Used for contextual "light quiz" vocab as well as grammar
/// fill-ins — anything where each item needs its own accepted answer(s).
QuizContent sentenceQuestQuiz({
  required String id,
  required String title,
  required String promptLabel,
  required String subjectsLabel,
  required String subjectColumnLabel,
  required String categoryLabel,
  required List<QuestSentenceItem> items,
  String? intro,
  List<HelpMemoryTip> tips = const [],
  bool contextualLayout = false,
  bool stripSentenceCue = false,
}) {
  return QuizContent(
    id: id,
    title: title,
    storageKeyPrefix: '${id}_',
    promptLabel: promptLabel,
    subjectsLabel: subjectsLabel,
    subjectColumnLabel: subjectColumnLabel,
    contextualLayout: contextualLayout,
    stripSentenceCue: stripSentenceCue,
    subjects: [
      for (var i = 0; i < items.length; i++)
        QuizSubjectData(key: 's$i', display: _glossFor(items[i])),
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
          sentence: items[i].sentence,
          acceptedAnswers: {items[i].answer, ...items[i].accepted}.toList(),
          english: items[i].english,
          // In the contextual layout the answer cue is hidden from the visible
          // text, so surface it behind the info icon as the English word.
          hint: items[i].hint ??
              (contextualLayout ? 'English: ${_glossFor(items[i])}' : null),
          explanationSections: items[i].explanation == null
              ? const []
              : [items[i].explanation!],
        ),
    ],
    helpMemoryIntro: intro,
    helpMemoryTips: tips,
  );
}

/// Builders for the **Quest** (CEFR A1) skill exercises that don't run on the
/// fill-in engine: listen-&-repeat speaking quizzes and reading-comprehension
/// quizzes. Both leave the fill-in fields empty and carry their own data, so
/// they render through `SpeakRepeatQuizPage` / `ReadingQuizPage` (dispatched by
/// `QuestQuizLoader` on [QuizContent.kind]).

/// One phrase in a [speakQuestQuiz]: the German [phrase] the learner hears and
/// repeats, and its English [meaning] shown underneath.
class SpeakPhrase {
  const SpeakPhrase({
    required this.phrase,
    required this.meaning,
    this.gender,
  });
  final String phrase;
  final String meaning;

  /// Gender of the voice that reads this phrase. Null inherits the quiz's
  /// default voice; set it for a line spoken by a specific/different speaker.
  final VoiceGender? gender;
}

/// A listen-&-repeat pronunciation quiz ([QuizKind.speakRepeat]) for the cert
/// course. Each [SpeakPhrase] becomes one subject whose display is the German
/// phrase (spoken aloud) and whose english is the meaning shown beneath it.
/// Order phrases short → long so the difficulty ramps word → phrase → sentence.
QuizContent speakQuestQuiz({
  required String id,
  required String title,
  required String promptLabel,
  required String subjectsLabel,
  required String subjectColumnLabel,
  required List<SpeakPhrase> phrases,
  String? intro,
  List<HelpMemoryTip> tips = const [],
  VoiceGender voiceGender = VoiceGender.female,
}) {
  return QuizContent(
    id: id,
    title: title,
    kind: QuizKind.speakRepeat,
    storageKeyPrefix: '${id}_',
    promptLabel: promptLabel,
    subjectsLabel: subjectsLabel,
    subjectColumnLabel: subjectColumnLabel,
    voiceGender: voiceGender,
    subjects: [
      for (var i = 0; i < phrases.length; i++)
        QuizSubjectData(
          key: 's$i',
          display: phrases[i].phrase,
          english: phrases[i].meaning,
          voiceGender: phrases[i].gender,
        ),
    ],
    categories: const [],
    sentences: const [],
    helpMemoryIntro: intro,
    helpMemoryTips: tips,
  );
}

/// A dictation (Diktat) quiz ([QuizKind.dictation]) — a listen-&-write exercise.
/// TTS reads each German sentence aloud and the learner types what they hear,
/// checked forgivingly (umlaut spelling, case and punctuation are folded away).
/// It reuses the [speakQuestQuiz] data shape: each [SpeakPhrase] becomes one
/// subject whose display is the sentence to dictate and whose english is the
/// translation shown after answering. Order sentences short → long.
QuizContent dictationQuestQuiz({
  required String id,
  required String title,
  required String promptLabel,
  required String subjectsLabel,
  required String subjectColumnLabel,
  required List<SpeakPhrase> sentences,
  String? intro,
  List<HelpMemoryTip> tips = const [],
  VoiceGender voiceGender = VoiceGender.female,
}) {
  return QuizContent(
    id: id,
    title: title,
    kind: QuizKind.dictation,
    storageKeyPrefix: '${id}_',
    promptLabel: promptLabel,
    subjectsLabel: subjectsLabel,
    subjectColumnLabel: subjectColumnLabel,
    voiceGender: voiceGender,
    subjects: [
      for (var i = 0; i < sentences.length; i++)
        QuizSubjectData(
          key: 's$i',
          display: sentences[i].phrase,
          english: sentences[i].meaning,
          voiceGender: sentences[i].gender,
        ),
    ],
    categories: const [],
    sentences: const [],
    helpMemoryIntro: intro,
    helpMemoryTips: tips,
  );
}

/// A reading-comprehension quiz ([QuizKind.reading]): a short A1 passage plus
/// multiple-choice questions. The fill-in fields are left empty — the page reads
/// the passage and questions from the reading fields.
QuizContent readingQuestQuiz({
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
    // Reading runs on its own page, but these labels keep the content valid and
    // give the back-office list something sensible to show.
    promptLabel: 'Frage',
    subjectsLabel: 'Fragen',
    subjectColumnLabel: 'Frage',
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

/// A listening-comprehension quiz ([QuizKind.listening]) — the audio twin of
/// [readingQuestQuiz]. It reuses the reading fields, so the only difference is
/// [QuizContent.kind]: the [passage] (~40–60 German words) is **hidden** and
/// read aloud by TTS on `ListeningQuizPage`; the German [passage] and its
/// [passageTranslation] sit behind the info button as the script. Pass questions
/// that can be answered from listening alone (no on-screen text to scan).
QuizContent listeningQuestQuiz({
  required String id,
  required String title,
  required String category,
  required String passageTitle,
  required String passage,
  required List<ReadingQuestion> questions,
  required String passageTranslation,
  String? intro,
  List<HelpMemoryTip> tips = const [],
  VoiceGender voiceGender = VoiceGender.female,
}) {
  return QuizContent(
    id: id,
    title: title,
    kind: QuizKind.listening,
    storageKeyPrefix: '${id}_',
    // Listening runs on its own page; these labels keep the content valid and
    // give the back-office list something sensible to show.
    promptLabel: 'Frage',
    subjectsLabel: 'Fragen',
    subjectColumnLabel: 'Frage',
    voiceGender: voiceGender,
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
