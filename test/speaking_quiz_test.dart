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

  group('family-gated rules never contradict the mode', () {
    late SpeakingTemplate template;

    setUp(() async {
      SpeakingPromptBuilder.resetCache();
      template = await SpeakingPromptBuilder.load('en', bundle: _DiskBundle());
    });

    String renderMode(SpeakingMode mode, {bool scaffolded = false}) =>
        SpeakingPromptBuilder(template).render(
          SpeakingExercise(
            topic: 'Anything',
            practisePoints: const ['one'],
            scoringCriteria: const ['accuracy'],
            material: 'Wort = word',
            mode: mode,
            scaffolded: scaffolded,
          ),
          learnLang: 'de',
          uiLang: 'en',
          cefr: 'B1',
        );

    test('drill prompts carry no no-drills rule and no no-corrections block',
        () {
      for (final mode in SpeakingMode.values) {
        if (mode.family != SpeakingFamily.drill) continue;
        final prompt = renderMode(mode);
        expect(prompt, isNot(contains('no drills')), reason: mode.name);
        expect(prompt, isNot(contains('gap-fills')), reason: mode.name);
        expect(prompt, isNot(contains('NO CORRECTIONS')), reason: mode.name);
        expect(prompt, contains('right or wrong'), reason: mode.name);
      }
    });

    test('conversation prompts keep the no-drills and no-corrections rules',
        () {
      for (final mode in SpeakingMode.values) {
        if (mode.family != SpeakingFamily.conversation) continue;
        final prompt = renderMode(mode);
        expect(prompt, contains('no drills'), reason: mode.name);
        expect(prompt, contains('NO CORRECTIONS'), reason: mode.name);
        expect(
          prompt,
          isNot(contains('right or wrong')),
          reason: mode.name,
        );
      }
    });

    test('presentation prompts allow the one long presenting turn', () {
      for (final mode in SpeakingMode.values) {
        if (mode.family != SpeakingFamily.presentation) continue;
        final prompt = renderMode(mode);
        expect(prompt, contains('one long turn'), reason: mode.name);
        expect(prompt, contains('NO CORRECTIONS'), reason: mode.name);
      }
    });

    test('the writing prompt drops voice framing and scores by rubric', () {
      final prompt = renderMode(SpeakingMode.writing);
      expect(prompt, contains('Voice is not needed'));
      expect(prompt, isNot(contains('out loud')));
      expect(prompt, contains('SCORING THE TEXT'));
      expect(prompt, isNot(contains('PER ANSWER')));
    });

    test('every prompt carries the plan, the markers and the score line', () {
      for (final mode in SpeakingMode.values) {
        for (final scaffolded in [true, false]) {
          final prompt = renderMode(mode, scaffolded: scaffolded);
          expect(prompt, contains('SESSION PLAN'), reason: mode.name);
          expect(prompt, contains(kSpeakingReportStart), reason: mode.name);
          expect(prompt, contains(kSpeakingReportEnd), reason: mode.name);
          expect(prompt, contains('SCORE='), reason: mode.name);
          expect(prompt, contains('FIX:'), reason: mode.name);
          // Exactly one of the two plan variants renders.
          expect(
            prompt.contains('TEACH, unscored'),
            scaffolded,
            reason: '${mode.name} scaffolded=$scaffolded',
          );
        }
      }
    });

    test('scaffolded prompts demand bilingual instructions in the scored part',
        () {
      // The regression that shipped: without this rule the AI reads "keep
      // questions and examples in German" and runs the whole A1.1 session in
      // German at a raw beginner.
      for (final mode in SpeakingMode.values) {
        final scaffolded = renderMode(mode, scaffolded: true);
        expect(
          scaffolded,
          contains('every instruction and explanation in English'),
          reason: mode.name,
        );
        final immersion = renderMode(mode);
        expect(
          immersion,
          isNot(contains('every instruction and explanation in English')),
          reason: mode.name,
        );
      }
    });

    test('reportLanguage overrides the UI language in the report rules', () {
      final prompt = SpeakingPromptBuilder(template).render(
        const SpeakingExercise(
          topic: 'Anything',
          practisePoints: ['one'],
          scoringCriteria: ['accuracy'],
          reportLanguage: 'de',
        ),
        learnLang: 'de',
        uiLang: 'en',
        cefr: 'B2',
      );
      expect(prompt, contains('Write it in German'));
    });

    test('the Help Memory rides along as course notes when provided', () {
      const exercise = SpeakingExercise(
        topic: 'Anything',
        practisePoints: ['one'],
        scoringCriteria: ['accuracy'],
      );
      final without = SpeakingPromptBuilder(template)
          .render(exercise, learnLang: 'de', uiLang: 'en', cefr: 'A2');
      expect(without, isNot(contains('COURSE NOTES')));

      final with_ = SpeakingPromptBuilder(template).render(
        exercise,
        learnLang: 'de',
        uiLang: 'en',
        cefr: 'A2',
        referenceNotes: 'Perfekt uses haben or sein.\n'
            '- Movement verbs: take sein (ich bin gegangen).',
      );
      expect(with_, contains('COURSE NOTES FOR THIS EXERCISE'));
      expect(with_, contains('Movement verbs'));
    });

    test('personal focus renders only when corrections are passed', () {
      const exercise = SpeakingExercise(
        topic: 'Anything',
        practisePoints: ['one'],
        scoringCriteria: ['accuracy'],
      );
      final without = SpeakingPromptBuilder(template)
          .render(exercise, learnLang: 'de', uiLang: 'en', cefr: 'A2');
      expect(without, isNot(contains('PERSONAL FOCUS')));

      final with_ = SpeakingPromptBuilder(template).render(
        exercise,
        learnLang: 'de',
        uiLang: 'en',
        cefr: 'A2',
        personalFocus: ['"ich habe gegangen" -> "ich bin gegangen"'],
      );
      expect(with_, contains('PERSONAL FOCUS'));
      expect(with_, contains('ich bin gegangen'));
    });
  });

  group('material pairs', () {
    test('parses word = meaning segments, dot-separated or one per line', () {
      const material =
          'Words to drill (word = meaning):\n'
          'Hallo = hello · bitte = please\n'
          'die Mutter = mother\n'
          'Drill: ask each word both ways.';
      final pairs = speakingMaterialPairsOf(material);
      expect(pairs, [
        ('Hallo', 'hello'),
        ('bitte', 'please'),
        ('die Mutter', 'mother'),
      ]);
    });

    test('label lines and prose never become pairs', () {
      // The regression: "Words to drill (word = meaning):" parsed as a pair.
      expect(speakingMaterialPairsOf('Words to drill (word = meaning):'),
          isEmpty);
      expect(speakingMaterialPairsOf('A passage without any pairs.'), isEmpty);
      expect(speakingMaterialPairsOf(''), isEmpty);
    });
  });

  group('report extraction', () {
    test('cuts the report out of a paste with both markers', () {
      final paste =
          'Great session!\n$kSpeakingReportStart\nFINAL SCORE: 80 / 100\n'
          'SCORE=80\n$kSpeakingReportEnd\ntrailing chatter';
      expect(
        extractSpeakingReport(paste),
        'FINAL SCORE: 80 / 100\nSCORE=80',
      );
    });

    test('a paste without markers comes back whole', () {
      expect(extractSpeakingReport('  just a score: 70  '), 'just a score: 70');
    });

    test('FIX lines parse with either arrow and an optional dash', () {
      const report = '''
FIX: ich habe gegangen -> ich bin gegangen
- FIX: der Auto → das Auto
FIX: incomplete line without arrow
Improve next time: nothing''';
      final fixes = parseSpeakingFixes(report);
      expect(fixes, hasLength(2));
      expect(fixes[0].said, 'ich habe gegangen');
      expect(fixes[0].correct, 'ich bin gegangen');
      expect(fixes[1].said, 'der Auto');
      expect(fixes[1].correct, 'das Auto');
    });

    test('the score still parses out of a marker-wrapped report', () {
      final paste =
          '$kSpeakingReportStart\nFINAL SCORE: 84 / 100\nFIX: a -> b\n'
          'SCORE=84\n$kSpeakingReportEnd';
      expect(parseSpeakingScore(paste), 84);
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
