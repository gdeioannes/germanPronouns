import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:german_pronouns_articles/data/course_catalog.dart';
import 'package:german_pronouns_articles/data/quiz_content_library.dart';
import 'package:german_pronouns_articles/l10n/app_strings.dart';
import 'package:german_pronouns_articles/models/course.dart';
import 'package:german_pronouns_articles/models/nav_layout.dart';

void main() {
  test('Course round-trips through JSON unchanged', () {
    for (final course in defaultCourses) {
      final restored = Course.fromJson(
        jsonDecode(jsonEncode(course.toJson())) as Map<String, dynamic>,
      );
      expect(restored.toJson(), course.toJson());
    }
  });

  test('defaultCourses has English→German (en) and Español→Alemán (es)', () {
    final byId = {for (final c in defaultCourses) c.id: c};
    expect(byId.containsKey(kDefaultCourseId), isTrue);
    expect(byId['en_de']!.uiLang, UiLang.en);
    expect(byId['es_de']!.uiLang, UiLang.es);
  });

  test('every course nav quiz ref resolves to a real quiz', () {
    final ids = {for (final q in allQuizContent) q.id};
    const builtIn = {kWordLibraryRef, kSettingsRef, kCoursesRef};
    for (final course in defaultCourses) {
      for (final group in course.nav.groups) {
        if (group.type == NavGroupType.questChain ||
            group.type == NavGroupType.nounChain) {
          continue; // rendered from code, not item refs
        }
        for (final item in group.items) {
          final ok = ids.contains(item.ref) || builtIn.contains(item.ref);
          expect(ok, isTrue, reason: 'unknown nav ref: ${item.ref}');
        }
      }
    }
  });

  test('strings differ by UI language', () {
    expect(stringsFor(UiLang.en).settings, 'Settings');
    expect(stringsFor(UiLang.es).settings, isNot('Settings'));
  });
}
