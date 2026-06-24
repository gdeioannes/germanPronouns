import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:german_pronouns_articles/data/quiz_content_library.dart';

import 'support/content_projection.dart';

/// Pins every quiz's `storageKeyPrefix`. These prefixes key a learner's saved
/// score/streak/history in SharedPreferences, so the JSON-collections rewrite
/// must never change them — doing so would silently orphan saved progress.
void main() {
  test('quiz storageKeyPrefixes are pinned (they key saved learner progress)', () {
    final golden = File('test/golden/storage_keys.json');

    final sorted = [...allQuizContent]..sort((a, b) => a.id.compareTo(b.id));
    final ordered = {for (final c in sorted) c.id: c.storageKeyPrefix};
    final current = const JsonEncoder.withIndent('  ').convert(ordered);

    final refreshing = Platform.environment['UPDATE_GOLDEN'] == '1';
    if (!golden.existsSync() || refreshing) {
      golden.parent.createSync(recursive: true);
      golden.writeAsStringSync(current);
    }

    expect(
      lf(current),
      lf(golden.readAsStringSync()),
      reason: 'A quiz storageKeyPrefix changed — this orphans learners\' saved '
          'scores/streaks. Prefixes must stay stable across the rewrite.',
    );
  });
}
