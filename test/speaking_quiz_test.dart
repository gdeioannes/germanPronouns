import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:german_pronouns_articles/data/quiz_content_library.dart';
import 'package:german_pronouns_articles/models/quiz_content.dart';
import 'package:german_pronouns_articles/models/speaking_exercise.dart';
import 'package:german_pronouns_articles/services/speaking_prompt.dart';

/// An [AssetBundle] that reads the repo's asset files straight off disk, so the
/// template gate runs without a Flutter asset manifest.
class _DiskBundle extends CachingAssetBundle {
  @override
  Future<String> loadString(String key, {bool cache = true}) async =>
      File(key).readAsString();

  @override
  Future<ByteData> load(String key) async {
    final bytes = await File(key).readAsBytes();
    return ByteData.view(bytes.buffer);
  }
}

List<QuizContent> get _speakingQuizzes =>
    allQuizContent.where((c) => c.kind == QuizKind.speaking).toList();

Map<String, dynamic> _json(String path) =>
    jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>;

void main() {
  final manifest = _json(kSpeakingManifestAsset);
  final templatePaths = Map<String, dynamic>.from(
    manifest['templates'] as Map,
  ).map((k, v) => MapEntry(k, v as String));

  group('speaking templates', () {
    test('every template carries the same section ids as English', () {
      List<String> ids(String path) => [
        for (final s in _json(path)['sections'] as List)
          (s as Map)['id'] as String,
      ];
      final english = ids(templatePaths['en']!);
      expect(english, isNotEmpty);
      for (final entry in templatePaths.entries) {
        // A missing translation must fail here rather than silently fall back
        // to English in front of a learner.
        expect(
          ids(entry.value),
          english,
          reason: 'template.${entry.key}.json drifted from template.en.json',
        );
      }
    });

    test('an unknown UI language falls back to English', () async {
      SpeakingPromptBuilder.resetCache();
      final template = await SpeakingPromptBuilder.load(
        'xx',
        bundle: _DiskBundle(),
      );
      expect(template.uiLang, 'en');
    });
  });

  group('authored speaking quizzes', () {
    late SpeakingTemplate template;

    setUp(() async {
      SpeakingPromptBuilder.resetCache();
      template = await SpeakingPromptBuilder.load('en', bundle: _DiskBundle());
    });

    test('the course ships at least one', () {
      expect(_speakingQuizzes, isNotEmpty);
    });

    test('each has a topic, practise points and scoring criteria', () {
      for (final quiz in _speakingQuizzes) {
        final e = quiz.speaking;
        expect(e, isNotNull, reason: '${quiz.id} has no speaking payload');
        expect(e!.topic.trim(), isNotEmpty, reason: '${quiz.id}: empty topic');
        expect(
          e.practisePoints,
          isNotEmpty,
          reason: '${quiz.id}: no practise points',
        );
        expect(
          e.scoringCriteria,
          isNotEmpty,
          reason: '${quiz.id}: no scoring criteria',
        );
        expect(quiz.level, isNotNull, reason: '${quiz.id}: no CEFR level');
      }
    });

    test('the questions fit inside the session', () {
      for (final quiz in _speakingQuizzes) {
        final e = quiz.speaking!;
        final s = resolvedSpeakingSession(e, template);
        // Demanding more questions than the session allows exchanges makes the
        // brief impossible; the AI resolves it by rushing or overrunning.
        expect(
          e.practisePoints.length * s.minQuestionsPerPoint,
          lessThanOrEqualTo(s.minExchanges),
          reason:
              '${quiz.id}: ${e.practisePoints.length} practise points × '
              '${s.minQuestionsPerPoint} questions > ${s.minExchanges} exchanges',
        );
        expect(s.passScore, inInclusiveRange(0, 100));
      }
    });

    test('renders in every UI language with no placeholder left behind',
        () async {
      for (final uiLang in templatePaths.keys) {
        SpeakingPromptBuilder.resetCache();
        final t = await SpeakingPromptBuilder.load(
          uiLang,
          bundle: _DiskBundle(),
        );
        for (final quiz in _speakingQuizzes) {
          final prompt = SpeakingPromptBuilder(t).render(
            quiz.speaking!,
            learnLang: 'de-DE',
            uiLang: uiLang,
            cefr: quiz.level!,
          );
          expect(
            RegExp(r'\{\w+\}').firstMatch(prompt),
            isNull,
            reason: '${quiz.id} ($uiLang) left a placeholder unresolved',
          );
          // The three rules the whole feature rests on.
          expect(prompt, contains('SCORE='));
          expect(prompt.toLowerCase(), contains(quiz.speaking!.topic
              .split(' ')
              .first
              .toLowerCase()));
        }
      }
    });

    test('an empty vocabulary list drops the section, heading and all',
        () async {
      const bare = SpeakingExercise(
        topic: 'Anything',
        practisePoints: ['one'],
        scoringCriteria: ['accuracy'],
      );
      final prompt = SpeakingPromptBuilder(template).render(
        bare,
        learnLang: 'de',
        uiLang: 'en',
        cefr: 'A1',
      );
      expect(prompt, isNot(contains('WORDS I SHOULD USE')));
    });
  });

  group('score parsing', () {
    test('reads the AI\'s exact last line out of a pasted report', () {
      const report = '''
FINAL SCORE: 84 / 100
Points lost: wrong auxiliary twice.
SCORE=84''';
      expect(parseSpeakingScore(report), 84);
    });

    test('the SCORE= line wins over other numbers in the report', () {
      expect(parseSpeakingScore('FINAL SCORE: 72 / 100\nSCORE=72'), 72);
    });

    test('accepts a bare number', () {
      expect(parseSpeakingScore('  67 '), 67);
      expect(parseSpeakingScore('0'), 0);
      expect(parseSpeakingScore('100'), 100);
    });

    test('rejects out-of-range and unparseable input', () {
      expect(parseSpeakingScore('101'), isNull);
      expect(parseSpeakingScore('SCORE=120'), isNull);
      expect(parseSpeakingScore('eighty'), isNull);
      expect(parseSpeakingScore(''), isNull);
      expect(parseSpeakingScore('   '), isNull);
    });
  });

  group('grades and medals', () {
    test('grade is the score in tens, clamped to 1-10', () {
      expect(speakingGrade(100), 10);
      expect(speakingGrade(84), 8);
      expect(speakingGrade(85), 9);
      expect(speakingGrade(0), 1);
    });

    test('medal bands', () {
      expect(speakingMedal(95), SpeakingMedal.gold);
      expect(speakingMedal(85), SpeakingMedal.gold);
      expect(speakingMedal(84), SpeakingMedal.silver);
      expect(speakingMedal(65), SpeakingMedal.silver);
      expect(speakingMedal(64), SpeakingMedal.bronze);
      expect(speakingMedal(45), SpeakingMedal.bronze);
      // Below grade 5 is a "try again", not a medal.
      expect(speakingMedal(44), isNull);
      expect(speakingMedal(0), isNull);
    });
  });
}
