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

  test('defaultCourses is the single German certification track', () {
    expect(defaultCourses.map((c) => c.id), [kDefaultCourseId]);
    final cert = defaultCourses.single;
    expect(cert.id, 'de_cert_a1');
    expect(cert.uiLang, UiLang.en);
    expect(
      cert.nav.groups.map((g) => g.type),
      isNot(contains(NavGroupType.nounChain)),
    );
    final certQuests = cert.nav.groups
        .where((g) => g.type == NavGroupType.questChain)
        .toList();
    expect(certQuests.map((g) => g.level), [
      'A1.1', 'A1.2', 'A2.1', 'A2.2', 'B1.1', 'B1.2',
      'B2.1', 'B2.2', 'C1.1', 'C1.2', 'C2.1', 'C2.2',
    ]);
  });

  test('every course nav quiz ref resolves to a real quiz', () {
    final ids = {for (final q in allQuizContent) q.id};
    const builtIn = {
      kWordLibraryRef,
      kSettingsRef,
      kCoursesRef,
      kHowItWorksRef,
    };
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
