import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:german_pronouns_articles/data/quiz_content_library.dart';
import 'package:german_pronouns_articles/models/content/quiz.dart';

/// Stage 1 guarantees: the typed [Quiz] model is a *lossless* re-packaging of
/// the legacy [QuizContent] (so the JSON bundles generated from it in Stage 3
/// can't change any learner-visible content), and it serializes round-trip.
void main() {
  group('Quiz.fromLegacy -> toLegacy is lossless', () {
    for (final c in allQuizContent) {
      test(c.id, () {
        final round = Quiz.fromLegacy(c).toLegacy();
        expect(jsonEncode(round.toJson()), jsonEncode(c.toJson()));
      });
    }
  });

  group('Quiz JSON round-trips and keeps its subtype', () {
    for (final c in allQuizContent) {
      test(c.id, () {
        final quiz = Quiz.fromLegacy(c);
        final decoded =
            jsonDecode(jsonEncode(quiz.toJson())) as Map<String, dynamic>;
        final round = Quiz.fromJson(decoded);
        expect(round.runtimeType, quiz.runtimeType);
        expect(jsonEncode(round.toJson()), jsonEncode(quiz.toJson()));
      });
    }
  });
}
