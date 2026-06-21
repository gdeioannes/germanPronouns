// Regenerates the seed asset from the compiled content twins.
//
//   dart run tool/generate_seed.dart
//
// The output (assets/seed/quiz_content.json) is what the app seeds its local
// database from. After a teacher edits content and exports it, commit the
// exported JSON over this file to publish the edits in the next build.
import 'dart:convert';
import 'dart:io';

import 'package:german_pronouns_articles/data/course_catalog.dart';
import 'package:german_pronouns_articles/data/data_version.dart';
import 'package:german_pronouns_articles/data/quiz_content_library.dart';

void main() {
  final json = const JsonEncoder.withIndent('  ').convert({
    'version': kDataVersion,
    'quizzes': [for (final content in allQuizContent) content.toJson()],
    'courses': [for (final course in defaultCourses) course.toJson()],
  });

  final file = File('assets/seed/quiz_content.json');
  file.parent.createSync(recursive: true);
  file.writeAsStringSync(json);

  stdout.writeln('Wrote ${file.path} (${json.length} bytes).');
}
