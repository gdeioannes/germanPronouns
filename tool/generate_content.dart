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
import 'package:german_pronouns_articles/data/content/noun_collection.dart';
import 'package:german_pronouns_articles/data/course_catalog.dart';
import 'package:german_pronouns_articles/data/courses/de_cs/de_cs_content.dart';
import 'package:german_pronouns_articles/data/courses/de_es/de_es_content.dart';
import 'package:german_pronouns_articles/data/courses/en_de/en_de_content.dart';
import 'package:german_pronouns_articles/data/courses/en_de_ai/en_de_ai_content.dart';
import 'package:german_pronouns_articles/data/courses/en_es/en_es_content.dart';
import 'package:german_pronouns_articles/data/courses/en_zh/en_zh_content.dart';
import 'package:german_pronouns_articles/data/courses/en_zh_hanzi/en_zh_hanzi_content.dart';
import 'package:german_pronouns_articles/data/courses/es_de/es_de_content.dart';
import 'package:german_pronouns_articles/data/courses/es_en/es_en_content.dart';
import 'package:german_pronouns_articles/data/courses/zh_en/zh_en_content.dart';
import 'package:german_pronouns_articles/data/data_version.dart';
import 'package:german_pronouns_articles/data/noun_article_content.dart';
import 'package:german_pronouns_articles/data/noun_database.dart';
import 'package:german_pronouns_articles/data/noun_progression_data.dart';
import 'package:german_pronouns_articles/data/preposition_content.dart';
import 'package:german_pronouns_articles/data/pronoun_article_content.dart';
import 'package:german_pronouns_articles/data/pronoun_content.dart';
import 'package:german_pronouns_articles/data/quest_data.dart';
import 'package:german_pronouns_articles/data/shared_nouns/nouns_cs.dart';
import 'package:german_pronouns_articles/data/shared_nouns/nouns_en.dart';
import 'package:german_pronouns_articles/data/shared_nouns/nouns_es.dart';
import 'package:german_pronouns_articles/data/shared_nouns/nouns_zh.dart';
import 'package:german_pronouns_articles/data/shared_verbs/verbs_cs.dart';
import 'package:german_pronouns_articles/data/shared_verbs/verbs_de.dart';
import 'package:german_pronouns_articles/data/shared_verbs/verbs_en.dart';
import 'package:german_pronouns_articles/data/shared_verbs/verbs_es.dart';
import 'package:german_pronouns_articles/data/shared_verbs/verbs_zh.dart';
import 'package:german_pronouns_articles/models/content/catalog.dart';
import 'package:german_pronouns_articles/models/content/populated_course.dart';
import 'package:german_pronouns_articles/models/content/quiz.dart';
import 'package:german_pronouns_articles/models/quiz_content.dart';

/// The quizzes that belong to each course, by course id. Mirrors the modules
/// concatenated in `allQuizContent`, so every quiz lands in exactly one bundle.
Map<String, List<QuizContent>> _contentByCourse() => {
  'de_cert_a1': [...questQuizContent],
  // noun_article is intentionally absent: it's derived at runtime from the
  // shared `nouns/de.json` collection (below), not baked into the bundle, so
  // every German course can share one noun list.
  'en_de': [
    pronounQuizContent,
    articleQuizContent,
    pronounArticleQuizContent,
    prepositionQuizContent,
    // Step-by-step grammar modules (M3 — The Accusative, …).
    ...enDeGrammarContent,
  ],
  'es_de': [...esDeContent],
  'es_de_emotions': [...esDeEmocionesContent],
  'de_es': [...deEsContent],
  'de_cs': [...deCsContent],
  'es_en': [...esEnContent],
  'en_es': [...enEsContent],
  'zh_en': [...zhEnContent],
  'en_zh': [...enZhContent],
  'en_zh_hanzi': [...enZhHanziContent],
  'en_de_ai': [...enDeAiContent],
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
    defaultCourseId: kDefaultCourseId,
    courses: [
      for (final c in defaultCourses) CourseCard.fromCourse(c, version: kDataVersion),
    ],
  );
  File('assets/content/catalog.json')
      .writeAsStringSync(encoder.convert(catalog.toJson()));

  // Global, non-course UI content (placeholder until a screen reads from it).
  File('assets/content/app.json')
      .writeAsStringSync(encoder.convert(AppConfig(version: kDataVersion).toJson()));

  // Shared, cross-course reference collections, keyed by learned-language code.
  // The German noun list lives here once — as the *populated* reference
  // ([enrichedGermanNouns]: each noun carries its plural + custom sentence) —
  // instead of being baked into every German course's bundle. The noun-article
  // quiz is rebuilt from this at runtime via `buildNounArticleContent`.
  Directory('assets/content/shared/nouns').createSync(recursive: true);
  File('assets/content/shared/nouns/de.json').writeAsStringSync(
    encoder.convert(
      NounCollection(
        categoryDisplayNames: nounCategoryDisplayNames,
        // The difficulty-sorted progression order + the capstone label, so the
        // chain travels in the JSON instead of only being recomputed in code.
        progressionOrder: nounCategoryOrder,
        allNounsLabel: nounProgressionEntries.last.displayName,
        nouns: enrichedGermanNouns,
      ).toJson(),
    ),
  );

  // The other learned languages' noun lists (authored, not enriched from a
  // compiled quiz) — one file per language a course teaches, so the Word
  // Library has a clickable list with meanings in each course's main language.
  final nounCollections = {
    'es': spanishNounCollection,
    'cs': czechNounCollection,
    'zh': mandarinNounCollection,
    'en': englishNounCollection,
  };
  for (final entry in nounCollections.entries) {
    File('assets/content/shared/nouns/${entry.key}.json')
        .writeAsStringSync(encoder.convert(entry.value.toJson()));
  }

  // The shared verb lists (≥5 conjugation tables per verb), keyed by the
  // learned language — the Word Library's Verbs tab reads these.
  Directory('assets/content/shared/verbs').createSync(recursive: true);
  final verbCollections = {
    'de': germanVerbCollection,
    'es': spanishVerbCollection,
    'cs': czechVerbCollection,
    'en': englishVerbCollection,
    'zh': mandarinVerbCollection,
  };
  for (final entry in verbCollections.entries) {
    File('assets/content/shared/verbs/${entry.key}.json')
        .writeAsStringSync(encoder.convert(entry.value.toJson()));
  }

  stdout.writeln(
    'Wrote catalog.json + app.json + ${defaultCourses.length} course bundles '
    '($quizCount quizzes) + ${nounCollections.length + 1} noun lists + '
    '${verbCollections.length} verb lists under assets/content/.',
  );
}
