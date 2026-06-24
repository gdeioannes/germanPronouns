import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:german_pronouns_articles/data/quiz_content_library.dart';

import 'support/content_projection.dart';

void main() {
  test('all quiz content matches the frozen fidelity snapshot', () {
    final golden = File('test/golden/content_snapshot.json');
    final current = canonicalContentProjection(allQuizContent);

    // Bootstrap the golden on first run (or refresh it deliberately with
    // UPDATE_GOLDEN=1); otherwise assert exact equality.
    final refreshing = Platform.environment['UPDATE_GOLDEN'] == '1';
    if (!golden.existsSync() || refreshing) {
      golden.parent.createSync(recursive: true);
      golden.writeAsStringSync(current);
    }

    expect(
      lf(current),
      lf(golden.readAsStringSync()),
      reason: 'Quiz content changed vs the frozen snapshot. If this change is '
          'intentional, refresh it with UPDATE_GOLDEN=1 and review the diff.',
    );
  });
}
