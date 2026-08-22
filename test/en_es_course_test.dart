import 'package:flutter_test/flutter_test.dart';
import 'package:german_pronouns_articles/data/course_catalog.dart';
import 'package:german_pronouns_articles/data/courses/en_es/en_es_content.dart';
import 'package:german_pronouns_articles/models/course.dart';
import 'package:german_pronouns_articles/models/quiz_content.dart';

/// Quality gate for the "Certification Spanish A1–C2" course (English →
/// Spanish): the course is registered with the right seams, every quiz
/// teaches (a Help Memory intro + at least one real tip), and each quiz kind
/// carries answerable/consistent data. Mirror of `es_en_course_test.dart`.
void main() {
  group('en_es course is registered correctly', () {
    final course = defaultCourses.firstWhere((c) => c.id == 'en_es');

    test('uiLang en, learns Spanish, British/Spanish flags', () {
      expect(course.uiLang, UiLang.en);
      expect(course.learnLocale, 'es-ES');
      expect(course.speakFlag, '🇬🇧');
      expect(course.learnFlag, '🇪🇸');
    });

    test('all twelve CEFR sub-level groups are gated and match the content', () {
      final levelGroups =
          course.nav.groups.where((g) => g.id != 'more').toList();
      expect(levelGroups, hasLength(12));
      for (final g in levelGroups) {
        expect(g.gated, isTrue, reason: '${g.id} is not gated');
        expect(g.items, isNotEmpty);
      }
      final a11 = course.nav.groups.firstWhere((g) => g.id == 'a1_1');
      expect(
        a11.items.map((i) => i.ref).toList(),
        enEsA1_1.map((q) => q.id).toList(),
      );
    });
  });

  test('quiz ids are unique and prefixed en_es_', () {
    final ids = enEsContent.map((q) => q.id).toList();
    expect(ids.toSet().length, ids.length, reason: 'duplicate quiz id');
    for (final id in ids) {
      expect(id, startsWith('en_es_'));
    }
  });

  group('every en_es quiz has a working Help Memory', () {
    for (final q in enEsContent) {
      test('${q.id}: intro + at least one tip', () {
        expect(q.helpMemoryIntro, isNotNull, reason: '${q.id} has no intro');
        expect(q.helpMemoryIntro!.trim(), isNotEmpty);
        expect(q.helpMemoryTips, isNotEmpty, reason: '${q.id} has no tips');
        for (final tip in q.helpMemoryTips) {
          expect(tip.text.trim(), isNotEmpty,
              reason: '${q.id} has an empty tip');
        }
      });
    }
  });

  group('reading & listening quizzes have answerable questions', () {
    final passages = enEsContent.where(
      (q) =>
          (q.kind == QuizKind.reading || q.kind == QuizKind.listening) &&
          q.inlineBlanks.isEmpty,
    );
    test('the course contains reading and listening quizzes', () {
      expect(passages.any((q) => q.kind == QuizKind.reading), isTrue);
      expect(passages.any((q) => q.kind == QuizKind.listening), isTrue);
    });
    for (final q in passages) {
      test('${q.id}: has a passage and valid questions', () {
        expect(q.readingPassage, isNotNull);
        expect(q.readingPassage!.trim(), isNotEmpty);
        expect(q.readingPassageTranslation?.trim(), isNotEmpty,
            reason: '${q.id}: no English translation');
        expect(q.readingQuestions, isNotEmpty);
        for (final question in q.readingQuestions) {
          expect(question.options.length, greaterThanOrEqualTo(2));
          expect(question.correctIndex,
              inInclusiveRange(0, question.options.length - 1));
        }
      });
    }
  });

  group('inline big-text quizzes are internally consistent', () {
    final bigTexts = enEsContent.where((q) => q.inlineBlanks.isNotEmpty);
    test('every module ships one big text', () {
      expect(bigTexts, hasLength(12));
    });
    for (final q in bigTexts) {
      test('${q.id}: placeholders match blanks', () {
        final template = q.inlineTemplate!;
        for (var i = 0; i < q.inlineBlanks.length; i++) {
          expect(template.contains('{{$i}}'), isTrue,
              reason: '${q.id}: missing placeholder {{$i}}');
        }
        expect(q.readingPassage!.contains('{{'), isFalse,
            reason: '${q.id}: clean passage still has placeholders');
      });
    }
  });

  test('speak & dictation quizzes carry Spanish lines with English meanings',
      () {
    final spoken = enEsContent.where(
      (q) => q.kind == QuizKind.speakRepeat || q.kind == QuizKind.dictation,
    );
    expect(spoken, isNotEmpty);
    for (final q in spoken) {
      expect(q.subjects, isNotEmpty, reason: '${q.id} has no lines');
      for (final s in q.subjects) {
        expect(s.display.trim(), isNotEmpty, reason: '${q.id}: empty line');
        expect(s.english, isNotNull,
            reason: '${q.id}: line "${s.display}" has no meaning');
      }
    }
  });

  test('fill-in quizzes carry subjects and answer categories', () {
    final fills = enEsContent.where((q) => q.kind == QuizKind.fillBlank);
    expect(fills, isNotEmpty);
    for (final q in fills) {
      expect(q.subjects, isNotEmpty, reason: '${q.id} has no subjects');
      expect(q.categories, isNotEmpty, reason: '${q.id} has no answer category');
    }
  });

  group('speaking exercises are well-formed', () {
    final speakings =
        enEsContent.where((q) => q.kind == QuizKind.speaking).toList();
    test('every module ships two speaking exercises', () {
      expect(speakings, hasLength(24));
    });
    for (final q in speakings) {
      test('${q.id}: session maths and content hold', () {
        final ex = q.speaking!;
        expect(ex.practisePoints.length, inInclusiveRange(3, 4));
        expect(
          ex.practisePoints.length * (ex.session.minQuestionsPerPoint ?? 1),
          lessThanOrEqualTo(ex.session.minExchanges ?? 7),
          reason: '${q.id}: more required questions than exchanges',
        );
        expect(ex.scoringCriteria, isNotEmpty);
        expect(q.level, isNotNull);
      });
    }
  });
}
