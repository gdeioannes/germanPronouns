import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:german_pronouns_articles/data/content/asset_course_provider.dart';
import 'package:german_pronouns_articles/models/noun_settings.dart';
import 'package:german_pronouns_articles/pages/word_library_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The Word Library renders the noun list loaded from the shared JSON collection
/// (`assets/content/shared/nouns/de.json`) — not a compiled list.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('loads + renders nouns from the shared collection',
      (tester) async {
    // rootBundle asset I/O doesn't resolve under the fake test clock, so warm
    // the shared caches with real async first; the page then reads them.
    await tester.runAsync(() async {
      await NounSettings.instance.load();
      await courseContentProvider.nounCollection('de');
    });

    await tester.pumpWidget(const MaterialApp(home: WordLibraryPage()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    // The default active course learns German, so the page renders the shared
    // German nouns as filter chips.
    expect(find.byType(FilterChip), findsWidgets);
  });
}
