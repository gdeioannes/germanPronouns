import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:german_pronouns_articles/data/content/course_content_provider.dart';
import 'package:german_pronouns_articles/data/course_catalog.dart';
import 'package:german_pronouns_articles/data/quiz_content_library.dart';
import 'package:german_pronouns_articles/models/content/catalog.dart';
import 'package:german_pronouns_articles/models/content/populated_course.dart';
import 'package:german_pronouns_articles/models/content/quiz.dart';

/// In-memory [ContentSource] that counts reads, so tests can prove the catalog
/// loads no course bundles and a second open is served from cache.
class _CountingSource implements ContentSource {
  _CountingSource({
    required this.catalogStr,
    required this.appStr,
    required this.courseStr,
  });

  final String catalogStr;
  final String appStr;
  final String courseStr;

  int catalogReads = 0;
  int appReads = 0;
  int courseReads = 0;

  @override
  Future<String> catalogJson() async {
    catalogReads++;
    return catalogStr;
  }

  @override
  Future<String> appConfigJson() async {
    appReads++;
    return appStr;
  }

  @override
  Future<String> courseJson(String courseId) async {
    courseReads++;
    return courseStr;
  }

  @override
  Future<String> sharedNounsJson(String langCode) async => '{"nouns":[]}';
}

void main() {
  final course = defaultCourses.first;
  final quizzes = allQuizContent.take(3).map(Quiz.fromLegacy).toList();

  final catalogStr = jsonEncode(
    Catalog(
      version: 'test-1',
      courses: [
        for (final c in defaultCourses) CourseCard.fromCourse(c, version: 'test-1'),
      ],
    ).toJson(),
  );
  final appStr = jsonEncode(const AppConfig(version: 'test-1').toJson());
  final courseStr = jsonEncode(
    PopulatedCourse(course: course, version: 'test-1', quizzes: quizzes).toJson(),
  );

  _CountingSource newSource() => _CountingSource(
    catalogStr: catalogStr,
    appStr: appStr,
    courseStr: courseStr,
  );

  test('catalog loads with no course bundle read', () async {
    final src = newSource();
    final provider = CachingCourseProvider(src);

    final catalog = await provider.catalog();

    expect(catalog.courses, isNotEmpty);
    expect(catalog.courses.first.id, defaultCourses.first.id);
    expect(src.courseReads, 0, reason: 'catalog must not touch course bundles');
  });

  test('populated() assembles the graph and resolves quizzes by id', () async {
    final provider = CachingCourseProvider(newSource());

    final populated = await provider.populated(course.id);

    expect(populated.id, course.id);
    expect(populated.quizzes.length, quizzes.length);
    expect(populated.quizById(quizzes.first.id), isNotNull);
    expect(populated.quizById('does-not-exist'), isNull);
  });

  test('second populated() is a cache hit (source read once)', () async {
    final src = newSource();
    final provider = CachingCourseProvider(src);

    await provider.populated(course.id);
    await provider.populated(course.id);

    expect(src.courseReads, 1);
  });

  test('invalidate() forces the next populated() to reload', () async {
    final src = newSource();
    final provider = CachingCourseProvider(src);

    await provider.populated(course.id);
    provider.invalidate(course.id);
    await provider.populated(course.id);

    expect(src.courseReads, 2);
  });

  test('catalog and app config are memoized', () async {
    final src = newSource();
    final provider = CachingCourseProvider(src);

    await provider.catalog();
    await provider.catalog();
    await provider.appConfig();
    await provider.appConfig();

    expect(src.catalogReads, 1);
    expect(src.appReads, 1);
  });
}
