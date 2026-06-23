import 'dart:convert';

import 'package:german_pronouns_articles/models/quiz_content.dart';

/// Canonical, formatting-independent projection of quiz CONTENT — the fidelity
/// oracle shared by the Stage 0 snapshot test and the Stage 3 bundle test.
/// Quizzes are keyed + sorted by id so the result is order-independent, and the
/// comparison format is always the legacy [QuizContent] JSON, which the typed
/// [Quiz] model reproduces via its `toLegacy()` bridge.
String canonicalContentProjection(List<QuizContent> contents) {
  final sorted = [...contents]..sort((a, b) => a.id.compareTo(b.id));
  final map = <String, dynamic>{for (final c in sorted) c.id: c.toJson()};
  return const JsonEncoder.withIndent('  ').convert(map);
}
