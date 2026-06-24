import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:german_pronouns_articles/data/content/noun_collection.dart';
import 'package:german_pronouns_articles/data/course_catalog.dart';
import 'package:german_pronouns_articles/data/noun_article_content.dart';
import 'package:german_pronouns_articles/models/content/populated_course.dart';
import 'package:german_pronouns_articles/models/quiz_content.dart';

import 'support/content_projection.dart';

/// Stage 3 gate: the generated content under `assets/content/` must reproduce
/// today's content exactly — the per-course bundles **plus** the shared
/// cross-course collections. Each bundle quiz is parsed back into a typed
/// [Quiz], bridged to legacy [QuizContent]; the noun-article quiz is rebuilt
/// from the shared `nouns/de.json` collection (it's deliberately not baked into
/// any bundle). The union is compared against the frozen Stage 0 snapshot — so
/// moving content out of Dart into JSON changed nothing a learner sees (and no
/// saved-progress key moved).
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
    // The noun-article quiz is derived from the shared collection, not a bundle.
    ..._sharedDerivedContent(),
  ];
}

/// Content rebuilt from the shared cross-course collections (deduped out of the
/// course bundles): today, the German noun-article quiz from `nouns/de.json`.
List<QuizContent> _sharedDerivedContent() {
  final raw = File('assets/content/shared/nouns/de.json').readAsStringSync();
  final collection = NounCollection.fromJson(
    jsonDecode(raw) as Map<String, dynamic>,
  );
  return [buildNounArticleContent(collection.nouns, collection.categoryDisplayNames)];
}

void main() {
  test('generated course bundles reproduce the content snapshot', () {
    final golden = File('test/golden/content_snapshot.json').readAsStringSync();
    expect(lf(canonicalContentProjection(_allBundleContent())), lf(golden));
  });

  test('generated bundles carry each course nav unchanged', () {
    // The learner runtime sources its menu/drawer from the bundle nav
    // (CourseSession.ensureActiveNavLoaded), so it must match the compiled nav.
    for (final course in defaultCourses) {
      final raw =
          File('assets/content/courses/${course.id}.json').readAsStringSync();
      final populated = PopulatedCourse.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
      expect(
        lf(const JsonEncoder.withIndent('  ').convert(populated.course.nav.toJson())),
        lf(const JsonEncoder.withIndent('  ').convert(course.nav.toJson())),
        reason: 'nav for ${course.id} drifted from the compiled course',
      );
    }
  });

  test('generated bundles preserve every storageKeyPrefix', () {
    final sorted = _allBundleContent()..sort((a, b) => a.id.compareTo(b.id));
    final ordered = {for (final c in sorted) c.id: c.storageKeyPrefix};
    final current = const JsonEncoder.withIndent('  ').convert(ordered);
    final golden = File('test/golden/storage_keys.json').readAsStringSync();
    expect(lf(current), lf(golden));
  });
}
