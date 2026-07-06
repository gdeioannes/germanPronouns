import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:german_pronouns_articles/data/content/asset_course_provider.dart';
import 'package:german_pronouns_articles/data/content/course_content_provider.dart';
import 'package:german_pronouns_articles/data/content/noun_collection.dart';
import 'package:german_pronouns_articles/data/content/verb_collection.dart';
import 'package:german_pronouns_articles/data/course_catalog.dart';

/// Gate for the Word Library's cross-language promise: **every** course's
/// learned language ships a shared noun list *and* a shared verb list, and
/// every entry carries a meaning in that course's main (UI) language — English
/// via the canonical `english` field, other UI languages via an explicit
/// `meanings[<uiLang>]` entry (no silent English fallback). Every verb carries
/// at least five conjugation tables.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // The learned-language codes across the catalog, each with the UI languages
  // of the courses that teach it (e.g. de → {en, es}).
  final uiLangsByLearnLang = <String, Set<String>>{};
  for (final course in defaultCourses) {
    final lang = course.learnLocale.split('-').first;
    uiLangsByLearnLang.putIfAbsent(lang, () => {}).add(course.uiLang.name);
  }

  Map<String, dynamic> readJson(String path) =>
      jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>;

  String? meaningOrNull(String english, Map<String, String> meanings, String ui) =>
      ui == 'en' ? english : meanings[ui];

  test('every learned language has a noun list with meanings in each of its '
      'courses\' main languages', () {
    for (final entry in uiLangsByLearnLang.entries) {
      final lang = entry.key;
      final collection = NounCollection.fromJson(
        readJson('assets/content/shared/nouns/$lang.json'),
      );
      expect(collection.nouns, isNotEmpty, reason: 'nouns/$lang.json is empty');
      for (final ui in entry.value) {
        for (final n in collection.nouns) {
          final meaning = meaningOrNull(n.english, n.meanings, ui);
          expect(
            meaning != null && meaning.trim().isNotEmpty,
            isTrue,
            reason: 'nouns/$lang.json: "${n.noun}" has no $ui meaning',
          );
        }
      }
    }
  });

  test('every learned language has a verb list; each verb carries a meaning '
      'in each course main language and at least 5 conjugation sets', () {
    for (final entry in uiLangsByLearnLang.entries) {
      final lang = entry.key;
      final collection = VerbCollection.fromJson(
        readJson('assets/content/shared/verbs/$lang.json'),
      );
      expect(collection.verbs, isNotEmpty, reason: 'verbs/$lang.json is empty');
      for (final v in collection.verbs) {
        for (final ui in entry.value) {
          final meaning = meaningOrNull(v.english, v.meanings, ui);
          expect(
            meaning != null && meaning.trim().isNotEmpty,
            isTrue,
            reason: 'verbs/$lang.json: "${v.verb}" has no $ui meaning',
          );
        }
        expect(
          v.sets.length,
          greaterThanOrEqualTo(5),
          reason: 'verbs/$lang.json: "${v.verb}" has ${v.sets.length} '
              'conjugation sets (needs ≥ 5)',
        );
        for (final s in v.sets) {
          expect(s.label.trim(), isNotEmpty,
              reason: 'verbs/$lang.json: "${v.verb}" has an unlabeled set');
          expect(s.forms, isNotEmpty,
              reason: 'verbs/$lang.json: "${v.verb}" · "${s.label}" is empty');
          for (final f in s.forms) {
            expect(f.form.trim(), isNotEmpty,
                reason:
                    'verbs/$lang.json: "${v.verb}" · "${s.label}" has an '
                    'empty form');
          }
        }
      }
    }
  });

  test('provider loads shared verb collections; unknown lang is empty',
      () async {
    final provider = CachingCourseProvider(const AssetContentSource());

    final de = await provider.verbCollection('de');
    expect(de.verbs, isNotEmpty);
    expect(de.verbs.first.sets.length, greaterThanOrEqualTo(5));

    final none = await provider.verbCollection('zz');
    expect(none.isEmpty, isTrue);
  });

  test('verb JSON round-trips losslessly through the model', () {
    for (final lang in uiLangsByLearnLang.keys) {
      final raw = readJson('assets/content/shared/verbs/$lang.json');
      final decoded = VerbCollection.fromJson(raw);
      expect(
        jsonEncode(decoded.toJson()),
        jsonEncode(raw),
        reason: 'verbs/$lang.json round-trip',
      );
    }
  });
}
