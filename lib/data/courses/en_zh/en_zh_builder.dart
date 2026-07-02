import '../../../models/quiz_content.dart';
import '../es_de/es_de_builder.dart';

/// Builders for the "Certification Chinese · HSK" course (English speakers
/// learning Mandarin, 🇬🇧 → 🇨🇳). Same shape as the `zh_en` wrappers but
/// mirrored: a [CourseItem]'s `prompt` is the **English** cue shown to the
/// learner and `answer` is the **Chinese** target; all teaching text (intros,
/// tips) is authored in English. A `**…**` marker inside the Chinese answer
/// isolates the word to blank — see [sentenceCourseQuiz].
///
/// Chinese twist: fill-blank answers accept **pinyin as well as hanzi**. Any
/// tone-marked pinyin in an item's `accepted` list is auto-expanded with its
/// bare-letter variant (nǐ hǎo → ni hao, nǚ → nv + nu), so learners without a
/// Chinese IME can still answer — see [expandPinyin].
export '../es_de/es_de_builder.dart' show CourseItem;

/// Tone-marked pinyin vowels → bare letters (ü → v, the standard IME spelling).
const Map<String, String> _toneless = {
  'ā': 'a', 'á': 'a', 'ǎ': 'a', 'à': 'a',
  'ē': 'e', 'é': 'e', 'ě': 'e', 'è': 'e', 'ê': 'e',
  'ī': 'i', 'í': 'i', 'ǐ': 'i', 'ì': 'i',
  'ō': 'o', 'ó': 'o', 'ǒ': 'o', 'ò': 'o',
  'ū': 'u', 'ú': 'u', 'ǔ': 'u', 'ù': 'u',
  'ǖ': 'v', 'ǘ': 'v', 'ǚ': 'v', 'ǜ': 'v', 'ü': 'v',
  'ń': 'n', 'ň': 'n', 'ǹ': 'n',
};

/// [pinyin] with its tone marks stripped to bare letters (nǐ hǎo → ni hao,
/// lǜ → lv). Used to auto-accept the keyboard-friendly spelling.
String bareTonePinyin(String pinyin) {
  final buffer = StringBuffer();
  for (final rune in pinyin.runes) {
    final ch = String.fromCharCode(rune);
    buffer.write(_toneless[ch] ?? ch);
  }
  return buffer.toString();
}

/// Expands [accepted] with the bare-letter variants of any tone-marked pinyin
/// entries (and a `u`-for-`v` fallback, so both `nv` and `nu` pass for nǚ).
/// Hanzi entries pass through untouched.
List<String> expandPinyin(List<String> accepted) {
  final out = <String>{};
  for (final a in accepted) {
    out.add(a);
    final bare = bareTonePinyin(a);
    if (bare != a) {
      out.add(bare);
      if (bare.contains('v')) out.add(bare.replaceAll('v', 'u'));
    }
  }
  return out.toList();
}

/// [items] with each `accepted` list run through [expandPinyin].
List<CourseItem> _withPinyinVariants(List<CourseItem> items) => [
  for (final it in items)
    CourseItem(
      prompt: it.prompt,
      answer: it.answer,
      accepted: expandPinyin(it.accepted),
      hint: it.hint,
    ),
];

/// Fill-in quiz: English cue → Chinese answer. Mark the quizzed word in the
/// Chinese with `**…**` so just that word becomes the blank (the rest shows as
/// context). List the blank's pinyin in `accepted` (tone-marked is enough —
/// bare-letter variants are added automatically) and put the full-sentence
/// pinyin in `hint` so the eye icon reveals it.
QuizContent enZhFill({
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
  categoryLabel: 'Chinese',
  items: _withPinyinVariants(items),
  intro: intro,
  tips: tips,
);

/// Listen & repeat ([QuizKind.speakRepeat]): the app speaks the Chinese phrase
/// (`answer`); the pinyin + English meaning (`prompt`) is shown underneath.
QuizContent enZhSpeak({
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
  subjectColumnLabel: 'Chinese',
  items: items,
  intro: intro,
  tips: tips,
);

/// Reading ([QuizKind.reading]): a Chinese [passage] (pinyin + English
/// [passageTranslation] behind the info button — English-only from B2.1, once
/// the pinyin scaffold is retired) and Chinese [questions].
QuizContent enZhRead({
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

/// Listening ([QuizKind.listening]): the audio twin of [enZhRead]. The Chinese
/// [passage] is the **hidden** script the app reads aloud; the learner answers
/// the [questions] from listening. The pinyin/English [passageTranslation] is
/// the info-button script.
QuizContent enZhListen({
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

/// Dictation ([QuizKind.dictation]): the app reads each Chinese line aloud and
/// the learner **types** what they hear with a pinyin IME (the English meaning
/// is shown as the cue). The [CourseItem.answer] is the Chinese line to
/// dictate, [CourseItem.prompt] its English meaning. This is the computer-based
/// HSK writing mechanic: hearing → pinyin → recognizing the right character.
QuizContent enZhDict({
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
  subjectColumnLabel: 'Chinese',
  subjects: [
    for (var i = 0; i < items.length; i++)
      QuizSubjectData(
        key: 's$i',
        // The Chinese line the learner hears and types.
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

/// A particle-choice dropdown blank for the inline "big text": the learner
/// picks the [answer] particle from [options] (e.g. 的/得/地 or 了/过/着).
/// Unlike the German case-classification blanks, the options here are real
/// words of the passage, so [enZhBigText] fills — not collapses — them in the
/// derived clean passage.
InlineBlank particleBlank(
  String answer, {
  required List<String> options,
  String? translation,
}) => InlineBlank(
  kind: 'select',
  answer: answer,
  options: options,
  translation: translation,
);

/// A typed-input blank for the inline "big text". [accepted] lists extra
/// accepted spellings (tone-marked pinyin is auto-expanded); [hint] shows faint
/// inside the empty field.
InlineBlank zhInputBlank(
  String answer, {
  List<String> accepted = const [],
  String? hint,
}) => InlineBlank(
  kind: 'input',
  answer: answer,
  accepted: expandPinyin(accepted),
  hint: hint,
);

final RegExp _inlinePlaceholder = RegExp(r'\{\{(\d+)\}\}');

/// Inline "big text" reading quiz for Chinese: the [template] holds the passage
/// with `{{0}}`, `{{1}}`… placeholders, parallel to [blanks]. The clean
/// read-first passage is derived by filling **every** placeholder with its
/// answer — select blanks included, since a Chinese particle choice is a word
/// of the text, not a case label. Runs through `InlineClozeQuizPage`.
QuizContent enZhBigText({
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
      .replaceAllMapped(
        _inlinePlaceholder,
        (m) => blanks[int.parse(m.group(1)!)].answer,
      )
      .trim();
  return QuizContent(
    id: id,
    title: title,
    kind: QuizKind.reading,
    storageKeyPrefix: '${id}_',
    promptLabel: 'Sentence',
    subjectsLabel: 'Sentences',
    subjectColumnLabel: 'Chinese',
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
