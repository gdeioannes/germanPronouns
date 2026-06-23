// Regenerates the JSON content collections from the compiled content twins:
//
//   dart run tool/generate_content.dart
//
// Output (the future database's local stand-in):
//   assets/content/catalog.json        the course index (cards only; always loaded)
//   assets/content/app.json            global, non-course UI content
//   assets/content/courses/<id>.json   one self-contained, *populated* bundle per
//                                       course (course meta + nav + all its quizzes)
//
// Each course owns the quizzes of one content module; the union is exactly
// `allQuizContent`, so the per-course bundles reproduce today's content with no
// drift (proved by test/bundle_fidelity_test.dart).
import 'dart:convert';
import 'dart:io';

import 'package:german_pronouns_articles/data/article_content.dart';
import 'package:german_pronouns_articles/data/course_catalog.dart';
import 'package:german_pronouns_articles/data/courses/de_es/de_es_content.dart';
import 'package:german_pronouns_articles/data/courses/es_de/es_de_content.dart';
import 'package:german_pronouns_articles/data/data_version.dart';
import 'package:german_pronouns_articles/data/noun_article_content.dart';
import 'package:german_pronouns_articles/data/preposition_content.dart';
import 'package:german_pronouns_articles/data/pronoun_article_content.dart';
import 'package:german_pronouns_articles/data/pronoun_content.dart';
import 'package:german_pronouns_articles/data/quest_data.dart';
import 'package:german_pronouns_articles/models/content/catalog.dart';
import 'package:german_pronouns_articles/models/content/populated_course.dart';
import 'package:german_pronouns_articles/models/content/quiz.dart';
import 'package:german_pronouns_articles/models/quiz_content.dart';

/// The quizzes that belong to each course, by course id. Mirrors the modules
/// concatenated in `allQuizContent`, so every quiz lands in exactly one bundle.
Map<String, List<QuizContent>> _contentByCourse() => {
  'de_cert_a1': [...questQuizContent],
  'en_de': [
    pronounQuizContent,
    articleQuizContent,
    nounArticleQuizContent,
    pronounArticleQuizContent,
    prepositionQuizContent,
  ],
  'es_de': [...esDeContent],
  'es_de_emotions': [...esDeEmocionesContent],
  'de_es': [...deEsContent],
};

void main() {
  const encoder = JsonEncoder.withIndent('  ');
  final byCourse = _contentByCourse();

  Directory('assets/content/courses').createSync(recursive: true);

  // One populated bundle per course.
  var quizCount = 0;
  for (final course in defaultCourses) {
    final contents = byCourse[course.id] ?? const [];
    final quizzes = [for (final c in contents) Quiz.fromLegacy(c)];
    quizCount += quizzes.length;
    final bundle = PopulatedCourse(
      course: course,
      version: kDataVersion,
      quizzes: quizzes,
    );
    File('assets/content/courses/${course.id}.json')
        .writeAsStringSync(encoder.convert(bundle.toJson()));
  }

  // The always-loaded catalog (cards only — no course content).
  final catalog = Catalog(
    version: kDataVersion,
    courses: [
      for (final c in defaultCourses) CourseCard.fromCourse(c, version: kDataVersion),
    ],
  );
  File('assets/content/catalog.json')
      .writeAsStringSync(encoder.convert(catalog.toJson()));

  // Global, non-course UI content (placeholder until a screen reads from it).
  File('assets/content/app.json')
      .writeAsStringSync(encoder.convert(AppConfig(version: kDataVersion).toJson()));

  stdout.writeln(
    'Wrote catalog.json + app.json + ${defaultCourses.length} course bundles '
    '($quizCount quizzes) under assets/content/.',
  );
}
