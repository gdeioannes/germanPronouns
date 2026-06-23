import 'package:flutter_test/flutter_test.dart';
import 'package:german_pronouns_articles/data/quiz_content_library.dart';

/// Cross-collection invariants the per-course bundle model depends on: a quiz
/// id is the global key by which courses/nav reference a quiz, and the
/// storageKeyPrefix keys its saved progress — both must be globally unique
/// across every course's content, not just within one course.
void main() {
  test('every quiz id is globally unique', () {
    final counts = <String, int>{};
    for (final c in allQuizContent) {
      counts.update(c.id, (n) => n + 1, ifAbsent: () => 1);
    }
    final dupes = counts.entries.where((e) => e.value > 1).map((e) => e.key);
    expect(dupes, isEmpty, reason: 'Duplicate quiz ids: ${dupes.toList()}');
  });

  test('every storageKeyPrefix is globally unique', () {
    final counts = <String, int>{};
    for (final c in allQuizContent) {
      counts.update(c.storageKeyPrefix, (n) => n + 1, ifAbsent: () => 1);
    }
    final dupes = counts.entries.where((e) => e.value > 1).map((e) => e.key);
    expect(dupes, isEmpty, reason: 'Duplicate storageKeyPrefixes: ${dupes.toList()}');
  });
}
