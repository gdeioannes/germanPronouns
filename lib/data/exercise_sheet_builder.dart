import 'dart:math';

import '../models/course.dart';
import '../models/nav_layout.dart';
import '../models/noun_settings.dart';
import '../models/quiz_content.dart';
import '../models/quiz_stats.dart';
import 'content/active_course_content.dart';
import 'noun_progression_data.dart';
import 'quest_data.dart';
import 'quiz_stats_store.dart';

/// Assembles the printable exercise worksheet (see theme/exercise_sheet_pdf.dart)
/// from the active course's existing quizzes: which quizzes are in scope, which
/// of their exercises to print, and — for the "weakest knowledge" mode — how
/// weak each exercise is, blending the quiz's accuracy (answer history) with
/// its per-category mistake counts.

/// Which quizzes feed the worksheet.
enum ExerciseScope {
  /// Every printable quiz in the course.
  fullCourse,

  /// Only quizzes the learner has already finished (the home page's "done").
  achieved,

  /// Only quizzes with recorded answers, ranked by mistakes — a training sheet
  /// for what the learner gets wrong most often.
  weakSpots,
}

/// How a worksheet section is laid out on paper.
enum ExerciseSectionKind {
  /// Fill-in-the-blank sentences with a handwriting blank per item.
  cloze,

  /// A reading passage followed by multiple-choice questions.
  reading,

  /// A "big text" passage with numbered blanks answered inside it.
  inlineCloze,

  /// Character writing (hanzi): a clue plus empty practice boxes per item.
  writing,
}

/// One printable exercise: the [prompt] the learner works on (left of the
/// fold) and the [answer] printed in the fold-away column.
class ExerciseItem {
  ExerciseItem({
    required this.prompt,
    required this.answer,
    this.secondary,
    this.options = const [],
    this.categoryLabel,
    this.weakness = 0,
  });

  /// The sentence with its `____` blank, the question stem, the inline-blank
  /// hint, or the pinyin·meaning clue of a character to write.
  final String prompt;

  /// What goes in the fold-away answer column.
  final String answer;

  /// Optional context line printed above the prompt (a dialogue question, a
  /// hint) — mirrors the on-screen quiz's contextual prompt.
  final String? secondary;

  /// Multiple-choice options (reading questions) or the choices of an inline
  /// select blank. Empty elsewhere.
  final List<String> options;

  /// The grammar category this item tests (feeds the weak-spot weighting and
  /// prints as a small label under the answer).
  final String? categoryLabel;

  /// 0..1 weak-spot score; higher prints first in [ExerciseScope.weakSpots].
  final double weakness;
}

/// A titled group of exercises from one quiz.
class ExerciseSection {
  ExerciseSection({
    required this.quizTitle,
    required this.kind,
    required this.items,
    this.passage,
  });

  final String quizTitle;
  final ExerciseSectionKind kind;

  /// The reading passage, or the inline-cloze template still carrying its
  /// `{{n}}` placeholders (the PDF layout numbers and substitutes them).
  final String? passage;

  final List<ExerciseItem> items;

  ExerciseSection copyWithItems(List<ExerciseItem> items) => ExerciseSection(
    quizTitle: quizTitle,
    kind: kind,
    items: items,
    passage: passage,
  );
}

/// Hard cap for the "all exercises" option, so a course with thousands of
/// generated noun/article combinations still produces a printable workbook.
const int kExerciseSheetMaxItems = 500;

/// Weak-spot blend: how much the quiz's overall mistake rate counts versus the
/// per-category mistake concentration within that quiz.
const double _kQuizAccuracyWeight = 0.6;
const double _kCategoryMistakeWeight = 0.4;

/// One course quiz that can contribute exercises: its content, its persisted
/// stats, and whether the course home considers it finished.
class _ExerciseSource {
  _ExerciseSource(this.content, this.stats, {required this.done});

  final QuizContent content;
  final QuizStats stats;
  final bool done;

  int get answered => stats.answerHistory.length;

  /// Share of recorded answers that were wrong (0 when nothing was answered).
  double get mistakeRate {
    if (answered == 0) return 0;
    final correct = stats.answerHistory
        .where((h) => h['correct'] == true)
        .length;
    return 1 - correct / answered;
  }
}

/// Builds the worksheet sections for [course]: gathers every printable quiz
/// (fill-in, reading, inline cloze, character writing — audio-only kinds have
/// no paper form), filters by [scope], and samples down to [maxItems]
/// (null = everything, still capped at [kExerciseSheetMaxItems]). Returns an
/// empty list when the selection has nothing to print.
Future<List<ExerciseSection>> buildExerciseSheet(
  Course course, {
  required ExerciseScope scope,
  int? maxItems,
  Random? random,
}) async {
  final rng = random ?? Random();
  final sources = await _courseExerciseSources(course);

  final inScope = switch (scope) {
    ExerciseScope.fullCourse => sources,
    ExerciseScope.achieved => [
      for (final s in sources)
        if (s.done) s,
    ],
    ExerciseScope.weakSpots => [
      for (final s in sources)
        if (s.answered > 0) s,
    ],
  };

  final sections = <ExerciseSection>[];
  for (final source in inScope) {
    final section = _sectionFor(source, rng);
    if (section != null && section.items.isNotEmpty) sections.add(section);
  }

  final cap = maxItems == null
      ? kExerciseSheetMaxItems
      : min(maxItems, kExerciseSheetMaxItems);
  return selectExerciseSections(sections, cap: cap, scope: scope, random: rng);
}

/// The worksheet section for one quiz's [content] given its persisted [stats]
/// (which feed each item's weak-spot score), or null when the quiz has no
/// paper form. The per-quiz step of [buildExerciseSheet], public for tests.
ExerciseSection? exerciseSectionFor(
  QuizContent content,
  QuizStats stats, {
  Random? random,
}) => _sectionFor(
  _ExerciseSource(content, stats, done: false),
  random ?? Random(),
);

// ── Gathering ───────────────────────────────────────────────────────────────

/// Every printable quiz of [course]'s nav with its stats and done state,
/// walking the same group types as the course home (plain quiz lists, quest
/// chains by level, the noun chain).
Future<List<_ExerciseSource>> _courseExerciseSources(Course course) async {
  final sources = <_ExerciseSource>[];
  final seen = <String>{};

  Future<void> add(QuizContent content, {required bool done}) async {
    if (!seen.add(content.id)) return;
    final stats = await quizStatsStore.load(
      content.storageKeyPrefix,
      legacyCategoryLabelMigration: content.legacyCategoryLabelMigration,
    );
    sources.add(_ExerciseSource(content, stats, done: done));
  }

  for (final group in course.nav.groups) {
    switch (group.type) {
      case NavGroupType.quizzes:
        for (final item in group.items) {
          if (item.hidden) continue;
          final content = await resolveQuizContent(item.ref);
          if (content == null || !_printable(content)) continue;
          await add(content, done: await _regularQuizDone(item.ref, content));
        }
      case NavGroupType.questChain:
        final level = group.level;
        for (final e in questEntries) {
          if (level != null && e.levelLabel != level) continue;
          final content = await resolveQuizContent(e.key) ?? e.content;
          if (!_printable(content)) continue;
          await add(
            content,
            done: NounSettings.instance.isQuestQuizCompleted(e.key),
          );
        }
      case NavGroupType.nounChain:
        // Per-category noun quizzes derived from the shared collection; the
        // final "all nouns" entry only repeats them and is skipped.
        final allNouns = await resolveNounArticleContent();
        if (allNouns == null) break;
        for (final e in nounProgressionEntries) {
          if (e.key == kAllNounsProgressionKey) continue;
          await add(
            nounProgressionContent(allNouns, e.key),
            done: NounSettings.instance.isNounCategoryCompleted(e.key),
          );
        }
      case NavGroupType.links:
        break;
    }
  }
  return sources;
}

/// Whether [content] has a paper form: audio-only kinds (listen-&-repeat,
/// listening, dictation) can't be answered on a printed sheet.
bool _printable(QuizContent content) => switch (content.kind) {
  QuizKind.fillBlank || QuizKind.reading || QuizKind.draw => true,
  QuizKind.speakRepeat || QuizKind.listening || QuizKind.dictation => false,
};

/// Done state of a plain nav quiz, mirroring the course home's rules for the
/// printable kinds (drawing shares the speak completion set).
Future<bool> _regularQuizDone(String ref, QuizContent content) async {
  switch (content.kind) {
    case QuizKind.reading:
      return NounSettings.instance.isReadingQuizCompleted(ref);
    case QuizKind.draw:
      return NounSettings.instance.isSpeakQuizCompleted(ref);
    case QuizKind.fillBlank:
    case QuizKind.speakRepeat:
    case QuizKind.listening:
    case QuizKind.dictation:
      final stats = await quizStatsStore.load(content.storageKeyPrefix);
      return NounSettings.instance.isQuizDone(
        bestStreakAbsolute: stats.bestStreakAbsolute,
      );
  }
}

// ── Exercise extraction ─────────────────────────────────────────────────────

/// Converts one quiz into a worksheet section, or null when it has nothing
/// printable (e.g. a fill-in quiz without sentences or templates).
ExerciseSection? _sectionFor(_ExerciseSource source, Random rng) {
  final content = source.content;
  switch (content.kind) {
    case QuizKind.draw:
      return _writingSection(source);
    case QuizKind.reading:
      if (content.inlineBlanks.isNotEmpty && content.inlineTemplate != null) {
        return _inlineClozeSection(source);
      }
      return _readingSection(source);
    case QuizKind.fillBlank:
      if (content.sentences.isNotEmpty) return _sentenceClozeSection(source);
      if (content.sentenceTemplates.isNotEmpty) {
        return _templateClozeSection(source, rng);
      }
      return null;
    case QuizKind.speakRepeat:
    case QuizKind.listening:
    case QuizKind.dictation:
      return null;
  }
}

/// The weak-spot score of an item in [source] testing [categoryLabel]:
/// the quiz's overall mistake rate blended with how concentrated the quiz's
/// mistakes are on that category.
double _weakness(_ExerciseSource source, String? categoryLabel) {
  final mistakes = source.stats.mistakesByCase;
  var categoryShare = 0.0;
  if (categoryLabel != null && mistakes.isNotEmpty) {
    final maxMistakes = mistakes.values.reduce(max);
    if (maxMistakes > 0) {
      categoryShare = (mistakes[categoryLabel] ?? 0) / maxMistakes;
    }
  }
  return _kQuizAccuracyWeight * source.mistakeRate +
      _kCategoryMistakeWeight * categoryShare;
}

/// Cloze items from an authored sentence bank: each sentence prints with its
/// blank; the answer is the stored one, or the category value for the
/// sentence's subject (article/noun quizzes store no explicit answers).
ExerciseSection _sentenceClozeSection(_ExerciseSource source) {
  final content = source.content;
  final subjectIndexByKey = {
    for (var i = 0; i < content.subjects.length; i++) content.subjects[i].key: i,
  };
  final categoryByLabel = {for (final c in content.categories) c.label: c};

  final items = <ExerciseItem>[];
  for (final s in content.sentences) {
    if (!s.sentence.contains('____')) continue;
    var answer = s.acceptedAnswers.isNotEmpty ? s.acceptedAnswers.first : null;
    if (answer == null) {
      final i = subjectIndexByKey[s.subjectKey];
      final category = categoryByLabel[s.categoryLabel];
      if (i != null && category != null && i < category.values.length) {
        answer = category.values[i];
      }
    }
    if (answer == null || answer.isEmpty) continue;
    // A trailing "(…)" cue exists only to keep sentences unique when the
    // contextual prompt already shows it — drop it on paper too.
    var sentence = s.sentence;
    if (content.stripSentenceCue && s.prompt != null) {
      sentence = sentence.replaceAll(RegExp(r'\s*\([^)]*\)\s*$'), '');
    }
    items.add(
      ExerciseItem(
        prompt: sentence,
        answer: answer,
        secondary: s.prompt,
        categoryLabel: s.categoryLabel,
        weakness: _weakness(source, s.categoryLabel),
      ),
    );
  }
  return ExerciseSection(
    quizTitle: content.title,
    kind: ExerciseSectionKind.cloze,
    items: items,
  );
}

/// Cloze items generated from sentence templates (article/noun quizzes have no
/// stored bank): one item per subject, testing one randomly chosen category
/// that has both a template and an answer value for it.
ExerciseSection _templateClozeSection(_ExerciseSource source, Random rng) {
  final content = source.content;
  final items = <ExerciseItem>[];
  for (var i = 0; i < content.subjects.length; i++) {
    final subject = content.subjects[i];
    final candidates = <(QuizCategoryData, String)>[];
    for (final category in content.categories) {
      final templates = content.sentenceTemplates[category.label];
      if (templates == null || templates.isEmpty) continue;
      if (i >= category.values.length || category.values[i].isEmpty) continue;
      candidates.add((category, templates[rng.nextInt(templates.length)]));
    }
    if (candidates.isEmpty) continue;
    final (category, template) = candidates[rng.nextInt(candidates.length)];
    items.add(
      ExerciseItem(
        prompt: template.replaceAll('{subject}', subject.key),
        answer: category.values[i],
        secondary: subject.english,
        categoryLabel: category.label,
        weakness: _weakness(source, category.label),
      ),
    );
  }
  return ExerciseSection(
    quizTitle: content.title,
    kind: ExerciseSectionKind.cloze,
    items: items,
  );
}

/// Reading comprehension: the passage plus its multiple-choice questions; the
/// answer column shows the correct option's letter and text.
ExerciseSection _readingSection(_ExerciseSource source) {
  final content = source.content;
  final weakness = _weakness(source, content.readingCategory);
  final items = <ExerciseItem>[
    for (final q in content.readingQuestions)
      if (q.correctIndex >= 0 && q.correctIndex < q.options.length)
        ExerciseItem(
          prompt: q.question,
          answer:
              '${String.fromCharCode(0x61 + q.correctIndex)})  '
              '${q.options[q.correctIndex]}',
          options: q.options,
          categoryLabel: content.readingCategory,
          weakness: weakness,
        ),
  ];
  return ExerciseSection(
    quizTitle: content.readingTitle ?? content.title,
    kind: ExerciseSectionKind.reading,
    passage: content.readingPassage,
    items: items,
  );
}

/// A "big text" passage: one item per inline blank (numbered inside the
/// passage by the PDF layout); select blanks carry their choices.
ExerciseSection _inlineClozeSection(_ExerciseSource source) {
  final content = source.content;
  final weakness = _weakness(source, null);
  return ExerciseSection(
    quizTitle: content.title,
    kind: ExerciseSectionKind.inlineCloze,
    passage: content.inlineTemplate,
    items: [
      for (final b in content.inlineBlanks)
        ExerciseItem(
          prompt: b.hint ?? '',
          answer: b.answer,
          options: b.options,
          weakness: weakness,
        ),
    ],
  );
}

/// Character writing: the pinyin·meaning clue prints with empty practice
/// boxes; the character itself goes in the answer column.
ExerciseSection _writingSection(_ExerciseSource source) {
  final content = source.content;
  final weakness = _weakness(source, null);
  return ExerciseSection(
    quizTitle: content.title,
    kind: ExerciseSectionKind.writing,
    items: [
      for (final s in content.subjects)
        if (s.english != null && s.english!.isNotEmpty)
          ExerciseItem(
            prompt: s.english!,
            answer: s.display,
            weakness: weakness,
          ),
    ],
  );
}

// ── Selection / sampling ────────────────────────────────────────────────────

/// A selectable unit: one item, or a whole inline-cloze section (its blanks
/// belong to one passage and can't be sampled individually).
class _Unit {
  _Unit(this.sectionIndex, this.itemIndex, this.size, this.weakness);

  final int sectionIndex;

  /// Index into the section's items, or null for a whole-section unit.
  final int? itemIndex;

  final int size;
  final double weakness;
}

/// Trims [sections] down to at most [cap] exercises: weak-spot mode keeps the
/// weakest units, the other scopes sample randomly — both spread naturally
/// across the course because units keep their section identity. Section and
/// in-section order are preserved for the printout.
List<ExerciseSection> selectExerciseSections(
  List<ExerciseSection> sections, {
  required int cap,
  required ExerciseScope scope,
  required Random random,
}) {
  final total = sections.fold<int>(0, (n, s) => n + s.items.length);
  if (total <= cap) return sections;

  final units = <_Unit>[];
  for (var s = 0; s < sections.length; s++) {
    final section = sections[s];
    if (section.kind == ExerciseSectionKind.inlineCloze) {
      final avg =
          section.items.fold<double>(0, (sum, i) => sum + i.weakness) /
          section.items.length;
      units.add(_Unit(s, null, section.items.length, avg));
    } else {
      for (var i = 0; i < section.items.length; i++) {
        units.add(_Unit(s, i, 1, section.items[i].weakness));
      }
    }
  }

  // Shuffle first so equal-weakness units tie-break randomly.
  units.shuffle(random);
  if (scope == ExerciseScope.weakSpots) {
    units.sort((a, b) => b.weakness.compareTo(a.weakness));
  }

  var remaining = cap;
  final pickedBySection = <int, Set<int>>{};
  final wholeSections = <int>{};
  for (final unit in units) {
    if (unit.size > remaining) continue;
    remaining -= unit.size;
    if (unit.itemIndex == null) {
      wholeSections.add(unit.sectionIndex);
    } else {
      pickedBySection
          .putIfAbsent(unit.sectionIndex, () => {})
          .add(unit.itemIndex!);
    }
    if (remaining == 0) break;
  }

  final result = <ExerciseSection>[];
  for (var s = 0; s < sections.length; s++) {
    final section = sections[s];
    if (wholeSections.contains(s)) {
      result.add(section);
      continue;
    }
    final picked = pickedBySection[s];
    if (picked == null || picked.isEmpty) continue;
    result.add(
      section.copyWithItems([
        for (var i = 0; i < section.items.length; i++)
          if (picked.contains(i)) section.items[i],
      ]),
    );
  }
  return result;
}
