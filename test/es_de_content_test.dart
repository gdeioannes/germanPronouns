import 'dart:convert';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

import 'package:german_pronouns_articles/data/courses/es_de/es_de_content.dart';
import 'package:german_pronouns_articles/data/quiz_content_adapter.dart';
import 'package:german_pronouns_articles/models/app_page.dart';
import 'package:german_pronouns_articles/models/quiz_content.dart';

Map<String, dynamic> _throughJson(Map<String, dynamic> json) =>
    jsonDecode(jsonEncode(json)) as Map<String, dynamic>;

void main() {
  test('there are ~10 travel quizzes, all ids namespaced es_de_', () {
    expect(esDeContent.length, greaterThanOrEqualTo(10));
    for (final c in esDeContent) {
      expect(c.id, startsWith('es_de_'));
      expect(c.storageKeyPrefix, startsWith('es_de_'));
    }
  });

  for (final content in esDeContent) {
    test('${content.id}: round-trips + answerable + Spanish help', () {
      // JSON round-trip.
      expect(QuizContent.fromJson(_throughJson(content.toJson())).toJson(),
          content.toJson());

      // Every (subject, category) is answerable.
      final config = buildQuizConfigFromContent(content, currentPage: AppPage.settings);
      for (var s = 0; s < config.subjects.length; s++) {
        for (final category in config.categories) {
          final answer = category.values[s];
          final sentence = config.pickSentence(
            caseLabel: category.label,
            nominative: config.subjects[s],
            answer: answer,
            random: Random(s),
          );
          expect(sentence, isNotEmpty);
          final override = config.acceptableAnswersForSentence?.call(sentence);
          if (override != null) {
            expect(override.contains(answer.toLowerCase()), isTrue,
                reason: '${content.id}: "$sentence" must accept "$answer"');
          }
        }
      }

      // Spanish teaching content present.
      expect(content.helpMemoryIntro, isNotNull);
      expect(content.helpMemoryTips, isNotEmpty);
    });
  }
}
