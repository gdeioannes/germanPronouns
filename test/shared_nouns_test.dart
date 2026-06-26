import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:german_pronouns_articles/data/content/asset_course_provider.dart';
import 'package:german_pronouns_articles/data/content/course_content_provider.dart';
import 'package:german_pronouns_articles/data/content/noun_collection.dart';
import 'package:german_pronouns_articles/data/noun_article_content.dart';
import 'package:german_pronouns_articles/data/noun_database.dart';
import 'package:german_pronouns_articles/data/noun_progression_data.dart';

import 'support/content_projection.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  String encode(NounCollection c) =>
      const JsonEncoder.withIndent('  ').convert(c.toJson());

  test('shared nouns/de.json reproduces the enriched German noun list', () {
    final raw = File('assets/content/shared/nouns/de.json').readAsStringSync();
    final loaded = NounCollection.fromJson(
      jsonDecode(raw) as Map<String, dynamic>,
    );
    // The shared collection is the *populated* reference: each noun carries its
    // plural + custom sentence (see enrichedGermanNouns), not the bare list.
    final source = NounCollection(
      categoryDisplayNames: nounCategoryDisplayNames,
      progressionOrder: nounCategoryOrder,
      allNounsLabel: nounProgressionEntries.last.displayName,
      nouns: enrichedGermanNouns,
    );
    expect(lf(encode(loaded)), lf(encode(source)));
  });

  test('provider loads the shared de noun collection; unknown lang is empty',
      () async {
    final provider = CachingCourseProvider(const AssetContentSource());

    final de = await provider.nounCollection('de');
    expect(de.nouns, isNotEmpty);
    expect(de.categoryDisplayNames, isNotEmpty);

    final none = await provider.nounCollection('zz');
    expect(none.isEmpty, isTrue);
  });
}
