import 'package:flutter_test/flutter_test.dart';
import 'package:german_pronouns_articles/data/course_catalog.dart';
import 'package:german_pronouns_articles/data/courses/en_zh_hanzi/en_zh_hanzi_content.dart';
import 'package:german_pronouns_articles/models/course.dart';
import 'package:german_pronouns_articles/models/quiz_content.dart';

/// Quality gate for the "Hanzi Writing · 汉字" course: the 1000-character data
/// set is complete and duplicate-free, every themed module opens with a
/// culture reading followed by valid draw quizzes, and the course/nav
/// registration is consistent.
void main() {
  group('the hanzi data set', () {
    test('has exactly 1000 characters across the categories', () {
      expect(hanzi1000, hasLength(1000));
      expect(hanziCategories.length, greaterThanOrEqualTo(12));
      for (final c in hanziCategories) {
        expect(c.entries, isNotEmpty, reason: 'category ${c.id} is empty');
        expect(c.title.trim(), isNotEmpty, reason: c.id);
      }
      final ids = hanziCategories.map((c) => c.id).toList();
      expect(ids.toSet().length, ids.length, reason: 'duplicate category id');
    });

    test('every character is unique', () {
      final seen = <String, int>{};
      final dups = <String>[];
      for (final (i, e) in hanzi1000.indexed) {
        final first = seen[e.char];
        if (first != null) {
          dups.add('"${e.char}" at ${first + 1} and ${i + 1}');
        } else {
          seen[e.char] = i;
        }
      }
      expect(dups, isEmpty, reason: 'duplicate characters: ${dups.join('; ')}');
    });

    test('every entry is a single hanzi with pinyin and meaning', () {
      for (final e in hanzi1000) {
        expect(e.char.runes.length, 1, reason: '"${e.char}" is not one char');
        // CJK Unified Ideographs (the block every simplified hanzi lives in).
        final code = e.char.runes.first;
        expect(
          code >= 0x4E00 && code <= 0x9FFF,
          isTrue,
          reason: '"${e.char}" is not a CJK ideograph',
        );
        expect(e.pinyin.trim(), isNotEmpty, reason: '"${e.char}" has no pinyin');
        expect(e.meaning.trim(), isNotEmpty, reason: '"${e.char}" has no meaning');
      }
    });
  });

  group('the themed modules', () {
    test('one module per category, reading first, then draw parts', () {
      expect(enZhHanziModules, hasLength(hanziCategories.length));
      for (final m in enZhHanziModules) {
        expect(m.quizzes, isNotEmpty, reason: m.category.id);
        // The culture reading opens the module…
        expect(m.quizzes.first.kind, QuizKind.reading,
            reason: '${m.category.id} does not open with a culture reading');
        // …and everything after it draws.
        for (final q in m.quizzes.skip(1)) {
          expect(q.kind, QuizKind.draw, reason: q.id);
          expect(q.subjects.length, lessThanOrEqualTo(kHanziBatchSize),
              reason: q.id);
          expect(q.subjects.length, greaterThanOrEqualTo(8),
              reason: '${q.id}: parts should stay substantial');
        }
      }
    });

    test('culture readings have a passage and answerable questions', () {
      for (final m in enZhHanziModules) {
        final r = m.quizzes.first;
        expect(r.readingPassage?.trim(), isNotEmpty, reason: r.id);
        expect(r.readingQuestions.length, greaterThanOrEqualTo(2), reason: r.id);
        for (final q in r.readingQuestions) {
          expect(q.options.length, greaterThanOrEqualTo(2), reason: r.id);
          expect(q.correctIndex, inInclusiveRange(0, q.options.length - 1),
              reason: r.id);
        }
      }
    });

    test('every quiz teaches (intro + tips) and ids are unique', () {
      final ids = <String>{};
      for (final q in enZhHanziContent) {
        expect(q.helpMemoryIntro?.trim(), isNotEmpty, reason: q.id);
        expect(q.helpMemoryTips, isNotEmpty, reason: q.id);
        expect(ids.add(q.id), isTrue, reason: 'duplicate id ${q.id}');
      }
    });

    test('draw quizzes cover the 1000 characters exactly, in course order', () {
      final flattened = [
        for (final q in enZhHanziContent)
          if (q.kind == QuizKind.draw)
            for (final s in q.subjects) s.display,
      ];
      expect(flattened, [for (final e in hanzi1000) e.char]);
      // Every drawn line carries its big-cue "pinyin · meaning".
      for (final q in enZhHanziContent) {
        if (q.kind != QuizKind.draw) continue;
        for (final s in q.subjects) {
          expect(s.english, contains(' · '),
              reason: '${q.id}: "${s.display}" cue is not "pinyin · meaning"');
        }
      }
    });
  });

  group('the course registration', () {
    final course = defaultCourses.firstWhere((c) => c.id == 'en_zh_hanzi');

    test('speaks English, learns Chinese, has finder metadata', () {
      expect(course.uiLang, UiLang.en);
      expect(course.learnLocale, 'zh-CN');
      expect(course.goal, isNotNull);
      expect(course.level, isNotNull);
    });

    test('nav mirrors the themed modules in order', () {
      final gated = course.nav.groups.where((g) => g.gated).toList();
      expect(gated, hasLength(enZhHanziModules.length));
      final refs = [
        for (final g in gated)
          for (final item in g.items) item.ref,
      ];
      expect(refs, [for (final q in enZhHanziContent) q.id]);
      // Friendly titles — no rank-number ranges.
      for (final g in gated) {
        expect(g.title, isNot(matches(r'\d+–\d+')),
            reason: '"${g.title}" still uses intimidating number ranges');
      }
    });
  });
}
