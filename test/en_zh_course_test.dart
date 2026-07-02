import 'package:flutter_test/flutter_test.dart';
import 'package:german_pronouns_articles/data/course_catalog.dart';
import 'package:german_pronouns_articles/data/courses/en_zh/en_zh_builder.dart';
import 'package:german_pronouns_articles/data/courses/en_zh/en_zh_content.dart';
import 'package:german_pronouns_articles/models/course.dart';
import 'package:german_pronouns_articles/models/quiz_content.dart';

/// Whether [s] contains at least one CJK unified ideograph — i.e. real
/// Chinese, not just pinyin or English.
bool _hasHanzi(String s) => s.runes.any((r) => r >= 0x4E00 && r <= 0x9FFF);

/// Quality gate for the "Certification Chinese · HSK" course (English →
/// Mandarin): the course is registered with the right seams, every quiz
/// teaches (a Help Memory intro + at least one real tip), each quiz kind
/// carries answerable/consistent data, and the Chinese-specific conventions
/// hold (hanzi in the answers, pinyin acceptance, big-text blanks resolve).
void main() {
  group('en_zh course is registered correctly', () {
    final course = defaultCourses.firstWhere((c) => c.id == 'en_zh');

    test('uiLang en, learns Mandarin, British/Chinese flags', () {
      expect(course.uiLang, UiLang.en);
      expect(course.learnLocale, 'zh-CN');
      expect(course.speakFlag, '🇬🇧');
      expect(course.learnFlag, '🇨🇳');
    });

    test('the twelve level groups list exactly the module quizzes in order', () {
      final modules = <String, List<QuizContent>>{
        'a1_1': enZhA1_1,
        'a1_2': enZhA1_2,
        'a2_1': enZhA2_1,
        'a2_2': enZhA2_2,
        'b1_1': enZhB1_1,
        'b1_2': enZhB1_2,
        'b2_1': enZhB2_1,
        'b2_2': enZhB2_2,
        'c1_1': enZhC1_1,
        'c1_2': enZhC1_2,
        'c2_1': enZhC2_1,
        'c2_2': enZhC2_2,
      };
      for (final entry in modules.entries) {
        final group = course.nav.groups.firstWhere((g) => g.id == entry.key);
        expect(
          group.items.map((i) => i.ref).toList(),
          entry.value.map((q) => q.id).toList(),
          reason: 'group ${entry.key} drifted from its module list',
        );
        expect(group.gated, isTrue, reason: '${entry.key} must be gated');
      }
    });
  });

  test('quiz ids are unique and follow the en_zh_ prefix', () {
    final ids = enZhContent.map((q) => q.id).toList();
    expect(ids.toSet().length, ids.length, reason: 'duplicate quiz id');
    for (final id in ids) {
      expect(id, startsWith('en_zh_'));
    }
  });

  test('every module carries all core skills', () {
    final modules = <List<QuizContent>>[
      enZhA1_1, enZhA1_2, enZhA2_1, enZhA2_2,
      enZhB1_1, enZhB1_2, enZhB2_1, enZhB2_2,
      enZhC1_1, enZhC1_2, enZhC2_1, enZhC2_2,
    ];
    for (final module in modules) {
      final kinds = module.map((q) => q.kind).toSet();
      final level = module.first.id;
      expect(kinds, contains(QuizKind.speakRepeat), reason: '$level: no speaking');
      expect(kinds, contains(QuizKind.reading), reason: '$level: no reading');
      expect(kinds, contains(QuizKind.listening), reason: '$level: no listening');
      expect(kinds, contains(QuizKind.dictation), reason: '$level: no dictation');
    }
  });

  group('every en_zh quiz has a working Help Memory', () {
    for (final q in enZhContent) {
      test('${q.id}: intro + at least one tip', () {
        expect(q.helpMemoryIntro, isNotNull, reason: '${q.id} has no intro');
        expect(q.helpMemoryIntro!.trim(), isNotEmpty);
        expect(q.helpMemoryTips, isNotEmpty, reason: '${q.id} has no tips');
        for (final tip in q.helpMemoryTips) {
          expect(tip.text.trim(), isNotEmpty, reason: '${q.id} has an empty tip');
        }
      });
    }
  });

  group('reading & listening quizzes have answerable questions', () {
    final passages = enZhContent.where(
      (q) =>
          (q.kind == QuizKind.reading && q.inlineBlanks.isEmpty) ||
          q.kind == QuizKind.listening,
    );
    test('the course contains reading and listening quizzes', () {
      expect(passages.any((q) => q.kind == QuizKind.reading), isTrue);
      expect(passages.any((q) => q.kind == QuizKind.listening), isTrue);
    });
    for (final q in passages) {
      test('${q.id}: Chinese passage, translation, valid questions', () {
        expect(q.readingPassage, isNotNull);
        expect(q.readingPassage!.trim(), isNotEmpty);
        expect(_hasHanzi(q.readingPassage!), isTrue,
            reason: '${q.id}: passage is not Chinese');
        expect(q.readingPassageTranslation?.trim(), isNotEmpty,
            reason: '${q.id}: no info-button translation');
        expect(q.readingQuestions, isNotEmpty);
        for (final question in q.readingQuestions) {
          expect(question.options.length, greaterThanOrEqualTo(2));
          expect(question.correctIndex,
              inInclusiveRange(0, question.options.length - 1));
          expect(question.questionTranslation?.trim(), isNotEmpty,
              reason: '${q.id}: question "${question.question}" untranslated');
        }
      });
    }
  });

  group('inline big-text clozes resolve', () {
    final bigTexts =
        enZhContent.where((q) => q.inlineBlanks.isNotEmpty).toList();
    test('the course carries the three big-text clozes', () {
      expect(bigTexts, hasLength(3));
    });
    for (final q in bigTexts) {
      test('${q.id}: every placeholder has a blank and vice versa', () {
        final template = q.inlineTemplate!;
        final placeholders = RegExp(r'\{\{(\d+)\}\}')
            .allMatches(template)
            .map((m) => int.parse(m.group(1)!))
            .toSet();
        expect(placeholders, List.generate(q.inlineBlanks.length, (i) => i).toSet(),
            reason: '${q.id}: placeholders and blanks drifted');
        for (final blank in q.inlineBlanks) {
          expect(blank.answer.trim(), isNotEmpty);
          if (blank.isSelect) {
            expect(blank.options, contains(blank.answer),
                reason: '${q.id}: a select blank omits its own answer');
          }
        }
        // The derived clean passage carries every answer filled in.
        expect(q.readingPassage, isNot(contains('{{')));
      });
    }
  });

  test('speak & dictation quizzes carry Chinese lines with meanings', () {
    final spoken = enZhContent.where(
      (q) => q.kind == QuizKind.speakRepeat || q.kind == QuizKind.dictation,
    );
    expect(spoken, isNotEmpty);
    for (final q in spoken) {
      expect(q.subjects, isNotEmpty, reason: '${q.id} has no lines');
      for (final s in q.subjects) {
        expect(s.display.trim(), isNotEmpty, reason: '${q.id}: empty line');
        expect(_hasHanzi(s.display), isTrue,
            reason: '${q.id}: line "${s.display}" is not Chinese');
        expect(s.english, isNotNull,
            reason: '${q.id}: line "${s.display}" has no meaning');
      }
    }
  });

  test('fill-in quizzes carry subjects, Chinese answers and pinyin variants', () {
    final fills = enZhContent.where((q) => q.kind == QuizKind.fillBlank);
    expect(fills, isNotEmpty);
    for (final q in fills) {
      expect(q.subjects, isNotEmpty, reason: '${q.id} has no subjects');
      expect(q.categories, isNotEmpty, reason: '${q.id} has no answer category');
      for (final s in q.sentences) {
        expect(s.acceptedAnswers, isNotEmpty,
            reason: '${q.id}: a sentence accepts nothing');
        expect(s.acceptedAnswers.any(_hasHanzi), isTrue,
            reason: '${q.id}: "${s.sentence}" accepts no hanzi answer');
        // Tone-marked pinyin alternates must also accept the bare-letter
        // spelling (the builder auto-expands them).
        for (final a in s.acceptedAnswers) {
          final bare = bareTonePinyin(a);
          if (bare != a) {
            expect(s.acceptedAnswers, contains(bare),
                reason: '${q.id}: "$a" lacks its bare-pinyin variant');
          }
        }
      }
    }
  });

  test('the pinyin expander strips tones and maps ü to v/u', () {
    expect(bareTonePinyin('nǐ hǎo'), 'ni hao');
    expect(bareTonePinyin('lǜsè'), 'lvse');
    expect(expandPinyin(['nǚ']), containsAll(['nǚ', 'nv', 'nu']));
    expect(expandPinyin(['shū']), containsAll(['shū', 'shu']));
  });
}
