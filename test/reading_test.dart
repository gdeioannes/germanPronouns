import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:german_pronouns_articles/data/quest_data.dart';
import 'package:german_pronouns_articles/models/quiz_content.dart';

Map<String, dynamic> _throughJson(Map<String, dynamic> json) =>
    jsonDecode(jsonEncode(json)) as Map<String, dynamic>;

void main() {
  final readingEntries = [
    for (final e in questEntries)
      if (e.content.kind == QuizKind.reading) e,
  ];
  final speakEntries = [
    for (final e in questEntries)
      if (e.content.kind == QuizKind.speakRepeat) e,
  ];

  group('Quest chain has the new skill exercises', () {
    test('contains reading and speaking quizzes', () {
      expect(readingEntries, isNotEmpty, reason: 'no reading quizzes in chain');
      expect(speakEntries, isNotEmpty, reason: 'no speaking quizzes in chain');
    });
  });

  group('Reading content is well-formed', () {
    for (final entry in readingEntries) {
      final c = entry.content;

      test('${c.id}: has a passage and questions', () {
        expect(c.readingPassage, isNotNull);
        expect(c.readingPassage, isNotEmpty);
        expect(c.readingTitle, isNotNull);
        expect(c.readingCategory, isNotNull);
        expect(c.readingQuestions, isNotEmpty);
      });

      test('${c.id}: every question is answerable', () {
        for (final q in c.readingQuestions) {
          expect(q.options.length, greaterThanOrEqualTo(2),
              reason: '${c.id}: "${q.question}" needs ≥2 options');
          expect(q.correctIndex, greaterThanOrEqualTo(0));
          expect(q.correctIndex, lessThan(q.options.length),
              reason: '${c.id}: correctIndex out of range for "${q.question}"');
        }
      });

      test('${c.id}: ReadingQuestion round-trips through JSON', () {
        for (final q in c.readingQuestions) {
          final restored = ReadingQuestion.fromJson(_throughJson(q.toJson()));
          expect(restored.toJson(), q.toJson());
        }
      });

      test('${c.id}: reading content round-trips through JSON', () {
        final restored = QuizContent.fromJson(_throughJson(c.toJson()));
        expect(restored.toJson(), c.toJson());
        expect(restored.kind, QuizKind.reading);
      });

      test('${c.id}: leaves the fill-in fields empty', () {
        expect(c.categories, isEmpty);
        expect(c.sentences, isEmpty);
      });
    }
  });

  group('Speaking content is well-formed', () {
    for (final entry in speakEntries) {
      final c = entry.content;

      test('${c.id}: has phrases and no fill-in fields', () {
        expect(c.subjects, isNotEmpty);
        // Each phrase carries the German phrase (display) + English meaning.
        expect(c.subjects.every((s) => s.display.isNotEmpty), isTrue);
        expect(c.categories, isEmpty);
        expect(c.sentences, isEmpty);
      });
    }
  });
}
