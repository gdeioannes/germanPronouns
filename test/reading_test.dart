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
  final listeningEntries = [
    for (final e in questEntries)
      if (e.content.kind == QuizKind.listening) e,
  ];
  final dictationEntries = [
    for (final e in questEntries)
      if (e.content.kind == QuizKind.dictation) e,
  ];

  group('Quest chain has the new skill exercises', () {
    test('contains reading, speaking, listening and dictation quizzes', () {
      expect(readingEntries, isNotEmpty, reason: 'no reading quizzes in chain');
      expect(speakEntries, isNotEmpty, reason: 'no speaking quizzes in chain');
      expect(listeningEntries, isNotEmpty,
          reason: 'no listening quizzes in chain');
      expect(dictationEntries, isNotEmpty,
          reason: 'no dictation quizzes in chain');
    });
  });

  group('Dictation content is well-formed', () {
    for (final entry in dictationEntries) {
      final c = entry.content;

      test('${c.id}: has sentences with translations and no fill-in fields', () {
        expect(c.subjects, isNotEmpty);
        // Each subject is a sentence to dictate (display) with its translation.
        expect(c.subjects.every((s) => s.display.trim().isNotEmpty), isTrue);
        expect(c.subjects.every((s) => (s.english ?? '').trim().isNotEmpty),
            isTrue,
            reason: '${c.id}: every dictation sentence needs a translation');
        expect(c.categories, isEmpty);
        expect(c.sentences, isEmpty);
        expect(c.readingQuestions, isEmpty);
      });

      test('${c.id}: content round-trips through JSON as dictation', () {
        final restored = QuizContent.fromJson(_throughJson(c.toJson()));
        expect(restored.toJson(), c.toJson());
        expect(restored.kind, QuizKind.dictation);
      });
    }
  });

  group('Listening content is well-formed', () {
    for (final entry in listeningEntries) {
      final c = entry.content;

      test('${c.id}: has a hidden script, a translation and questions', () {
        expect(c.readingPassage, isNotNull);
        expect(c.readingPassage, isNotEmpty);
        // The info button shows the script in German + English, so listening
        // (unlike reading) requires the translation.
        expect(c.readingPassageTranslation, isNotNull,
            reason: '${c.id}: listening needs a German+English script');
        expect(c.readingTitle, isNotNull);
        expect(c.readingQuestions, isNotEmpty);
      });

      test('${c.id}: script is short enough to hear in one pass (~25–80 words)',
          () {
        final words = c.readingPassage!.trim().split(RegExp(r'\s+')).length;
        expect(words, greaterThanOrEqualTo(25),
            reason: '${c.id}: script too short ($words words)');
        expect(words, lessThanOrEqualTo(80),
            reason: '${c.id}: script too long to hold by ear ($words words)');
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

      test('${c.id}: content round-trips through JSON as listening', () {
        final restored = QuizContent.fromJson(_throughJson(c.toJson()));
        expect(restored.toJson(), c.toJson());
        expect(restored.kind, QuizKind.listening);
      });

      test('${c.id}: leaves the fill-in fields empty', () {
        expect(c.categories, isEmpty);
        expect(c.sentences, isEmpty);
      });
    }
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
