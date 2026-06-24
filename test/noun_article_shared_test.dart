import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:german_pronouns_articles/data/content/noun_collection.dart';
import 'package:german_pronouns_articles/data/noun_article_content.dart';
import 'package:german_pronouns_articles/data/noun_database.dart';
import 'package:german_pronouns_articles/data/noun_sentences.dart';

import 'support/content_projection.dart';

/// Step 2 fidelity: the noun-article quiz is now built data-driven from a list
/// of nouns ([buildNounArticleContent]) so it can come from either the compiled
/// [enrichedGermanNouns] or the shared `nouns/de.json` collection. These tests
/// prove the two paths produce the identical quiz, and that going data-driven
/// dropped no content (only re-ordered sentences into noun order).
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('builder preserves every custom sentence (no orphan keys dropped)', () {
    final built = buildNounArticleContent(
      enrichedGermanNouns,
      nounCategoryDisplayNames,
    );

    // If any nounSentences key were not a real germanNouns noun, the
    // noun-driven build would silently drop it and the counts would differ.
    expect(built.sentences.length, nounSentences.length);

    final builtPairs = {
      for (final s in built.sentences) '${s.subjectKey}=${s.sentence}',
    };
    final sourcePairs = {
      for (final e in nounSentences.entries) '${e.key}=${e.value}',
    };
    expect(builtPairs, sourcePairs);
  });

  test('shared nouns/de.json rebuilds the exact compiled noun-article quiz', () {
    final raw = File('assets/content/shared/nouns/de.json').readAsStringSync();
    final collection = NounCollection.fromJson(
      jsonDecode(raw) as Map<String, dynamic>,
    );

    final fromShared = buildNounArticleContent(
      collection.nouns,
      collection.categoryDisplayNames,
    );

    expect(
      lf(canonicalContentProjection([fromShared])),
      lf(canonicalContentProjection([nounArticleQuizContent])),
    );
  });
}
