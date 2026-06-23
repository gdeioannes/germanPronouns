import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:german_pronouns_articles/models/content/populated_course.dart';
import 'package:german_pronouns_articles/models/quiz_content.dart';

import 'support/content_projection.dart';

/// Stage 3 gate: the generated per-course bundles under `assets/content/` must
/// reproduce today's content exactly. Each bundle is parsed back into typed
/// [Quiz]s, bridged to legacy [QuizContent], and compared against the frozen
/// Stage 0 snapshot — so moving content out of Dart into JSON changed nothing a
/// learner sees (and no saved-progress key moved).
List<QuizContent> _allBundleContent() {
  final dir = Directory('assets/content/courses');
  final files =
      dir.listSync().whereType<File>().where((f) => f.path.endsWith('.json')).toList()
        ..sort((a, b) => a.path.compareTo(b.path));
  return [
    for (final f in files)
      for (final q
          in PopulatedCourse.fromJson(
            jsonDecode(f.readAsStringSync()) as Map<String, dynamic>,
          ).quizzes)
        q.toLegacy(),
  ];
}

void main() {
  test('generated course bundles reproduce the content snapshot', () {
    final golden = File('test/golden/content_snapshot.json').readAsStringSync();
    expect(canonicalContentProjection(_allBundleContent()), golden);
  });

  test('generated bundles preserve every storageKeyPrefix', () {
    final sorted = _allBundleContent()..sort((a, b) => a.id.compareTo(b.id));
    final ordered = {for (final c in sorted) c.id: c.storageKeyPrefix};
    final current = const JsonEncoder.withIndent('  ').convert(ordered);
    final golden = File('test/golden/storage_keys.json').readAsStringSync();
    expect(current, golden);
  });
}
