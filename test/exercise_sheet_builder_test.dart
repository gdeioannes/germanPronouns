import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:german_pronouns_articles/data/exercise_sheet_builder.dart';
import 'package:german_pronouns_articles/models/quiz_content.dart';
import 'package:german_pronouns_articles/models/quiz_stats.dart';

/// Unit tests for the exercise worksheet's pure logic: how each quiz kind
/// turns into printable items (exerciseSectionFor) and how the selection step
/// caps, orders, and weak-spot-ranks them (selectExerciseSections). The
/// course-walking side of buildExerciseSheet is exercised by the app itself.

QuizContent _content({
  QuizKind kind = QuizKind.fillBlank,
  List<QuizSubjectData> subjects = const [],
  List<QuizCategoryData> categories = const [],
  List<QuizSentenceData> sentences = const [],
  Map<String, List<String>> sentenceTemplates = const {},
  bool stripSentenceCue = false,
  String? readingPassage,
  List<ReadingQuestion> readingQuestions = const [],
  String? inlineTemplate,
  List<InlineBlank> inlineBlanks = const [],
}) => QuizContent(
  id: 'test_quiz',
  title: 'Test Quiz',
  storageKeyPrefix: 'test_quiz_',
  promptLabel: 'Prompt',
  subjectsLabel: 'Subjects',
  subjectColumnLabel: 'Subject',
  kind: kind,
  subjects: subjects,
  categories: categories,
  sentences: sentences,
  sentenceTemplates: sentenceTemplates,
  stripSentenceCue: stripSentenceCue,
  readingPassage: readingPassage,
  readingQuestions: readingQuestions,
  inlineTemplate: inlineTemplate,
  inlineBlanks: inlineBlanks,
);

ExerciseSection _clozeSection(
  String title,
  int count, {
  double weakness = 0,
}) => ExerciseSection(
  quizTitle: title,
  kind: ExerciseSectionKind.cloze,
  items: [
    for (var i = 0; i < count; i++)
      ExerciseItem(prompt: '$title ____ $i', answer: '$i', weakness: weakness),
  ],
);

void main() {
  group('exerciseSectionFor — fill-in quizzes', () {
    test('sentence bank: explicit and category-derived answers', () {
      final section = exerciseSectionFor(
        _content(
          subjects: const [QuizSubjectData(key: 'ich', display: 'ich')],
          categories: const [
            QuizCategoryData(label: 'Dativ', group: 'case', values: ['mir']),
          ],
          sentences: const [
            QuizSentenceData(
              subjectKey: 'ich',
              categoryLabel: 'Dativ',
              sentence: 'Gib ____ das Buch.',
              acceptedAnswers: ['mir'],
              prompt: 'Wer bekommt das Buch?',
            ),
            // No stored answer: falls back to the category value for 'ich'.
            QuizSentenceData(
              subjectKey: 'ich',
              categoryLabel: 'Dativ',
              sentence: 'Er hilft ____.',
            ),
            // No blank to write into: not printable.
            QuizSentenceData(
              subjectKey: 'ich',
              categoryLabel: 'Dativ',
              sentence: 'Kein Blank hier.',
            ),
          ],
        ),
        const QuizStats(),
      );

      expect(section!.kind, ExerciseSectionKind.cloze);
      expect(section.items, hasLength(2));
      expect(section.items[0].answer, 'mir');
      expect(section.items[0].secondary, 'Wer bekommt das Buch?');
      expect(section.items[0].categoryLabel, 'Dativ');
      expect(section.items[1].answer, 'mir');
    });

    test('stripSentenceCue drops the trailing cue when a prompt shows it', () {
      final section = exerciseSectionFor(
        _content(
          stripSentenceCue: true,
          sentences: const [
            QuizSentenceData(
              subjectKey: 'x',
              categoryLabel: 'Uhrzeit',
              sentence: 'Es ist ____ Uhr. (21:15)',
              acceptedAnswers: ['einundzwanzig Uhr fünfzehn'],
              prompt: '21:15',
            ),
          ],
        ),
        const QuizStats(),
      );

      expect(section!.items.single.prompt, 'Es ist ____ Uhr.');
      expect(section.items.single.secondary, '21:15');
    });

    test('templates: one item per subject with the parallel answer', () {
      final section = exerciseSectionFor(
        _content(
          subjects: const [
            QuizSubjectData(key: 'Hund', display: 'der Hund', english: 'dog'),
            QuizSubjectData(key: 'Katze', display: 'die Katze', english: 'cat'),
          ],
          categories: const [
            QuizCategoryData(
              label: 'Akkusativ',
              group: 'case',
              values: ['den', 'die'],
            ),
          ],
          sentenceTemplates: const {
            'Akkusativ': ['Ich sehe ____ {subject}.'],
          },
        ),
        const QuizStats(),
        random: Random(7),
      );

      expect(section!.items, hasLength(2));
      expect(section.items[0].prompt, 'Ich sehe ____ Hund.');
      expect(section.items[0].answer, 'den');
      expect(section.items[0].secondary, 'dog');
      expect(section.items[1].prompt, 'Ich sehe ____ Katze.');
      expect(section.items[1].answer, 'die');
    });
  });

  group('exerciseSectionFor — other kinds', () {
    test('reading: lettered answers, passage kept, bad index skipped', () {
      final section = exerciseSectionFor(
        _content(
          kind: QuizKind.reading,
          readingPassage: 'Anna geht in die Schule.',
          readingQuestions: const [
            ReadingQuestion(
              question: 'Wohin geht Anna?',
              options: ['nach Hause', 'in die Schule', 'ins Kino'],
              correctIndex: 1,
            ),
            ReadingQuestion(question: 'Kaputt?', options: ['a'], correctIndex: 5),
          ],
        ),
        const QuizStats(),
      );

      expect(section!.kind, ExerciseSectionKind.reading);
      expect(section.passage, 'Anna geht in die Schule.');
      expect(section.items, hasLength(1));
      expect(section.items.single.answer, startsWith('b)'));
      expect(section.items.single.answer, contains('in die Schule'));
      expect(section.items.single.options, hasLength(3));
    });

    test('inline cloze: template with placeholders and per-blank answers', () {
      final section = exerciseSectionFor(
        _content(
          kind: QuizKind.reading,
          inlineTemplate: 'Der Mann sieht {{0}} und kauft {{1}} Apfel.',
          inlineBlanks: const [
            InlineBlank(
              kind: 'select',
              answer: 'Akkusativ',
              options: ['Nominativ', 'Akkusativ', 'Dativ'],
            ),
            InlineBlank(kind: 'input', answer: 'einen', hint: 'ein'),
          ],
        ),
        const QuizStats(),
      );

      expect(section!.kind, ExerciseSectionKind.inlineCloze);
      expect(section.passage, contains('{{0}}'));
      expect(section.items[0].options, contains('Akkusativ'));
      expect(section.items[1].prompt, 'ein');
      expect(section.items[1].answer, 'einen');
    });

    test('draw: clue prompts, character answers, clueless entries skipped', () {
      final section = exerciseSectionFor(
        _content(
          kind: QuizKind.draw,
          subjects: const [
            QuizSubjectData(key: 'de', display: '的', english: 'de · possessive'),
            QuizSubjectData(key: 'x', display: '了'),
          ],
        ),
        const QuizStats(),
      );

      expect(section!.kind, ExerciseSectionKind.writing);
      expect(section.items, hasLength(1));
      expect(section.items.single.prompt, 'de · possessive');
      expect(section.items.single.answer, '的');
    });

    test('audio-only kinds have no paper form', () {
      for (final kind in [
        QuizKind.speakRepeat,
        QuizKind.listening,
        QuizKind.dictation,
      ]) {
        expect(exerciseSectionFor(_content(kind: kind), const QuizStats()),
            isNull);
      }
    });
  });

  group('weak-spot scoring', () {
    test('blends quiz mistake rate with category mistake share', () {
      // 2 wrong out of 4 → mistake rate 0.5; Dativ carries the most mistakes.
      const stats = QuizStats(
        answerHistory: [
          {'correct': false},
          {'correct': false},
          {'correct': true},
          {'correct': true},
        ],
        mistakesByCase: {'Dativ': 4, 'Akkusativ': 1},
      );
      final section = exerciseSectionFor(
        _content(
          sentences: const [
            QuizSentenceData(
              subjectKey: 'x',
              categoryLabel: 'Dativ',
              sentence: 'Er hilft ____ Mann.',
              acceptedAnswers: ['dem'],
            ),
            QuizSentenceData(
              subjectKey: 'x',
              categoryLabel: 'Akkusativ',
              sentence: 'Er sieht ____ Mann.',
              acceptedAnswers: ['den'],
            ),
          ],
        ),
        stats,
      );

      final dativ = section!.items[0].weakness;
      final akkusativ = section.items[1].weakness;
      expect(dativ, closeTo(0.6 * 0.5 + 0.4 * 1.0, 1e-9));
      expect(akkusativ, closeTo(0.6 * 0.5 + 0.4 * 0.25, 1e-9));
      expect(dativ, greaterThan(akkusativ));
    });
  });

  group('selectExerciseSections', () {
    test('caps the total and preserves section and item order', () {
      final picked = selectExerciseSections(
        [_clozeSection('A', 10), _clozeSection('B', 10)],
        cap: 8,
        scope: ExerciseScope.fullCourse,
        random: Random(1),
      );

      final total = picked.fold<int>(0, (n, s) => n + s.items.length);
      expect(total, 8);
      expect(picked.map((s) => s.quizTitle), isNot(contains('C')));
      // Section order preserved (A before B when both survive) and in-section
      // item order preserved (answers encode the original indices).
      for (final section in picked) {
        final indices = [for (final i in section.items) int.parse(i.answer)];
        expect(indices, orderedEquals([...indices]..sort()));
      }
    });

    test('returns everything untouched when it already fits', () {
      final sections = [_clozeSection('A', 3)];
      expect(
        selectExerciseSections(
          sections,
          cap: 20,
          scope: ExerciseScope.fullCourse,
          random: Random(1),
        ),
        same(sections),
      );
    });

    test('weak-spot mode keeps the weakest items', () {
      final picked = selectExerciseSections(
        [
          _clozeSection('easy', 5, weakness: 0.1),
          _clozeSection('hard', 5, weakness: 0.9),
        ],
        cap: 5,
        scope: ExerciseScope.weakSpots,
        random: Random(1),
      );

      expect(picked, hasLength(1));
      expect(picked.single.quizTitle, 'hard');
      expect(picked.single.items, hasLength(5));
    });

    test('inline-cloze sections are kept whole or not at all', () {
      final inline = ExerciseSection(
        quizTitle: 'big text',
        kind: ExerciseSectionKind.inlineCloze,
        passage: '{{0}} {{1}} {{2}} {{3}} {{4}}',
        items: [
          for (var i = 0; i < 5; i++)
            ExerciseItem(prompt: '', answer: '$i', weakness: 1.0),
        ],
      );
      // The inline section (5 items, weakest) doesn't fit a cap of 3, so the
      // selection falls through to the weakest single items instead.
      final picked = selectExerciseSections(
        [inline, _clozeSection('cloze', 5, weakness: 0.5)],
        cap: 3,
        scope: ExerciseScope.weakSpots,
        random: Random(1),
      );

      expect(picked, hasLength(1));
      expect(picked.single.quizTitle, 'cloze');
      expect(picked.single.items, hasLength(3));

      // With room for it, the inline section arrives complete.
      final withRoom = selectExerciseSections(
        [inline, _clozeSection('cloze', 5, weakness: 0.5)],
        cap: 7,
        scope: ExerciseScope.weakSpots,
        random: Random(1),
      );
      final inlinePicked =
          withRoom.singleWhere((s) => s.kind == ExerciseSectionKind.inlineCloze);
      expect(inlinePicked.items, hasLength(5));
    });
  });
}
