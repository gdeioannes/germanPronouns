import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:german_pronouns_articles/data/course_catalog.dart';
import 'package:german_pronouns_articles/data/courses/en_de_ai/en_de_ai_content.dart';
import 'package:german_pronouns_articles/models/nav_layout.dart';
import 'package:german_pronouns_articles/models/quiz_content.dart';
import 'package:german_pronouns_articles/models/speaking_exercise.dart';

/// Quality gate for the all-AI "German with Your AI Coach" course (en_de_ai).
/// Every exercise is a [QuizKind.speaking] prompt; the generic speaking gate
/// (template parity, placeholder rendering, session arithmetic) lives in
/// speaking_quiz_test.dart — this file checks the course's own promises from
/// docs/en_de_ai_course_plan.md.
void main() {
  final modules = <String, List<QuizContent>>{
    'm1': enDeAiM1Quizzes,
    'm2': enDeAiM2Quizzes,
    'm3': enDeAiM3Quizzes,
    'm4': enDeAiM4Quizzes,
    'm5': enDeAiM5Quizzes,
    'm6': enDeAiM6Quizzes,
    'm7': enDeAiM7Quizzes,
    'm8': enDeAiM8Quizzes,
    'm9': enDeAiM9Quizzes,
    'm10': enDeAiM10Quizzes,
    'm11': enDeAiM11Quizzes,
    'm12': enDeAiM12Quizzes,
  };

  /// Modes whose prompt is meaningless without authored material.
  const materialModes = {
    SpeakingMode.vocabDrill,
    SpeakingMode.wordGame,
    SpeakingMode.storytelling,
    SpeakingMode.listenRetell,
    SpeakingMode.readingQa,
    SpeakingMode.readingGen,
    SpeakingMode.writing,
    SpeakingMode.translationDrill,
  };

  test('twelve modules of ten AI exercises each, ids in module namespaces', () {
    expect(modules, hasLength(12));
    final seen = <String>{};
    modules.forEach((key, quizzes) {
      expect(quizzes, hasLength(10), reason: '$key must ship 10 exercises');
      for (final quiz in quizzes) {
        expect(
          quiz.id,
          startsWith('en_de_ai_${key}_'),
          reason: '${quiz.id} is filed under $key',
        );
        expect(seen.add(quiz.id), isTrue, reason: '${quiz.id} is duplicated');
        expect(
          quiz.kind,
          QuizKind.speaking,
          reason: '${quiz.id}: all-AI course',
        );
      }
    });
  });

  test('every exercise carries Help Memory intro and tips', () {
    for (final quiz in enDeAiContent) {
      expect(
        quiz.helpMemoryIntro?.trim() ?? '',
        isNotEmpty,
        reason: '${quiz.id}: missing intro',
      );
      expect(
        quiz.helpMemoryTips.length,
        greaterThanOrEqualTo(2),
        reason: '${quiz.id}: needs the how-it-works tip plus a content tip',
      );
    }
  });

  test(
    'material modes ship material; drills and games are curriculum-loaded',
    () {
      for (final quiz in enDeAiContent) {
        final e = quiz.speaking!;
        if (materialModes.contains(e.mode)) {
          expect(
            e.material.trim(),
            isNotEmpty,
            reason: '${quiz.id} (${e.mode.name}): material is the exercise',
          );
        }
      }
    },
  );

  test('each module mixes at least six distinct exercise modes', () {
    modules.forEach((key, quizzes) {
      final kinds = {for (final q in quizzes) q.speaking!.mode};
      expect(
        kinds.length,
        greaterThanOrEqualTo(6),
        reason: '$key: variety is the rhythm (${kinds.map((m) => m.name)})',
      );
    });
  });

  test('pass scores climb the CEFR ladder', () {
    int? expected(String key) => switch (key) {
      'm1' || 'm2' || 'm3' || 'm4' => null, // manifest default (50)
      'm5' || 'm6' || 'm7' || 'm8' => 60,
      _ => 70,
    };
    modules.forEach((key, quizzes) {
      for (final quiz in quizzes) {
        expect(
          quiz.speaking!.passScore,
          expected(key),
          reason: '${quiz.id}: passScore ladder from the course plan',
        );
      }
    });
  });

  test('every exercise teaches before it tests (A1.1 → C2.2)', () {
    for (final quiz in enDeAiContent) {
      expect(
        quiz.speaking!.scaffolded,
        isTrue,
        reason: '${quiz.id}: the AI must teach the material before scoring',
      );
    }
  });

  test('reports switch to German from B2.1 (m7) on', () {
    // Carried by the first-class reportLanguage field (the builder derives it
    // from the level), never as topic text — a free-text request would lose
    // to the template's own report-language line.
    modules.forEach((key, quizzes) {
      final n = int.parse(key.substring(1));
      for (final quiz in quizzes) {
        expect(
          quiz.speaking!.reportLanguage,
          n >= 7 ? 'de' : isNull,
          reason: '${quiz.id}: reading your own feedback is the exercise',
        );
        expect(
          quiz.speaking!.topic,
          isNot(contains('report in German')),
          reason: '${quiz.id}: report language must not live in topic text',
        );
      }
    });
  });

  test(
    'the catalog course is gated A1.1 → C2.2 and its nav matches content',
    () {
      final course = defaultCourses.singleWhere((c) => c.id == 'en_de_ai');
      expect(course.level, 'A1–C2');
      final levelGroups = course.nav.groups
          .where((g) => g.type == NavGroupType.quizzes)
          .toList();
      expect(levelGroups, hasLength(12));
      for (var i = 0; i < levelGroups.length; i++) {
        final group = levelGroups[i];
        expect(group.gated, isTrue, reason: '${group.id}: chain must gate');
        final refs = [for (final item in group.items) item.ref];
        final ids = [for (final q in modules['m${i + 1}']!) q.id];
        expect(
          refs,
          ids,
          reason: '${group.id}: nav refs drifted — rerun generate_nav_refs',
        );
      }
    },
  );

  test('every mode used has an instruction in every speaking template', () {
    final manifest =
        jsonDecode(
              File('assets/content/speaking/manifest.json').readAsStringSync(),
            )
            as Map<String, dynamic>;
    final paths = Map<String, dynamic>.from(manifest['templates'] as Map);
    for (final path in paths.values) {
      final template =
          jsonDecode(File(path as String).readAsStringSync())
              as Map<String, dynamic>;
      final modes = Map<String, dynamic>.from(template['modes'] as Map);
      for (final mode in SpeakingMode.values) {
        expect(
          (modes[mode.name] as String?)?.trim() ?? '',
          isNotEmpty,
          reason: '$path: no instruction for mode ${mode.name}',
        );
      }
    }
  });
}
