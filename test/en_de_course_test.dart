import 'package:flutter_test/flutter_test.dart';
import 'package:german_pronouns_articles/data/courses/en_de/en_de_content.dart';
import 'package:german_pronouns_articles/models/quiz_content.dart';

/// Quality gate for the authored "German Grammar in Detail" modules (M1–M17):
/// every quiz must teach (a Help Memory intro + at least one real tip), and the
/// interactive content must be internally consistent — inline "big text" blanks
/// match their placeholders, selects offer their answer, and reading/listening
/// quizzes carry answerable questions.
final RegExp _placeholder = RegExp(r'\{\{(\d+)\}\}');

void main() {
  group('every en_de grammar quiz has a working Help Memory', () {
    for (final q in enDeGrammarContent) {
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

  group('inline big-text quizzes are internally consistent', () {
    final bigTexts =
        enDeGrammarContent.where((q) => q.inlineBlanks.isNotEmpty).toList();
    test('the course contains inline big-text quizzes', () {
      expect(bigTexts, isNotEmpty, reason: 'expected several inline big texts');
    });
    for (final q in bigTexts) {
      test('${q.id}: placeholders match blanks', () {
        final template = q.inlineTemplate;
        expect(template, isNotNull, reason: '${q.id} has blanks but no template');
        final indices = _placeholder
            .allMatches(template!)
            .map((m) => int.parse(m.group(1)!))
            .toList();
        // One placeholder per blank, numbered 0..n-1 in order.
        expect(
          indices,
          List<int>.generate(q.inlineBlanks.length, (i) => i),
          reason: '${q.id}: {{n}} placeholders must be 0..n-1 and match the '
              'number of blanks',
        );
        for (final b in q.inlineBlanks) {
          expect(b.answer.trim(), isNotEmpty, reason: '${q.id}: empty answer');
          if (b.isSelect) {
            expect(b.options.length, greaterThanOrEqualTo(2),
                reason: '${q.id}: a select needs >= 2 options');
            expect(b.options, contains(b.answer),
                reason: '${q.id}: options must contain the correct answer '
                    '"${b.answer}"');
          }
        }
      });
    }
  });

  group('reading & listening quizzes have answerable questions', () {
    final passages = enDeGrammarContent.where(
      (q) => q.kind == QuizKind.reading || q.kind == QuizKind.listening,
    );
    for (final q in passages) {
      // The inline big texts are reading-kind but use inlineBlanks instead of
      // multiple-choice questions, so skip those here.
      if (q.inlineBlanks.isNotEmpty) continue;
      test('${q.id}: has a passage and valid questions', () {
        expect(q.readingPassage, isNotNull);
        expect(q.readingPassage!.trim(), isNotEmpty);
        expect(q.readingQuestions, isNotEmpty);
        for (final question in q.readingQuestions) {
          expect(question.options.length, greaterThanOrEqualTo(2));
          expect(question.correctIndex, inInclusiveRange(0, question.options.length - 1));
        }
      });
    }
  });

  test('speak & dictation quizzes carry spoken lines with translations', () {
    final spoken = enDeGrammarContent.where(
      (q) => q.kind == QuizKind.speakRepeat || q.kind == QuizKind.dictation,
    );
    for (final q in spoken) {
      expect(q.subjects, isNotEmpty, reason: '${q.id} has no lines');
      for (final s in q.subjects) {
        expect(s.display.trim(), isNotEmpty, reason: '${q.id}: empty line');
        expect(s.english, isNotNull, reason: '${q.id}: line "${s.display}" has no translation');
      }
    }
  });
}
