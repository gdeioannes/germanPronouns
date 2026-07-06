import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:german_pronouns_articles/data/content/asset_course_provider.dart';
import 'package:german_pronouns_articles/data/content/noun_collection.dart';
import 'package:german_pronouns_articles/models/noun_settings.dart';
import 'package:german_pronouns_articles/pages/word_library_page.dart';
import 'package:german_pronouns_articles/widgets/word_detail_panels.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The Word Library renders the noun and verb lists loaded from the shared
/// JSON collections (`assets/content/shared/{nouns,verbs}/de.json`) — not a
/// compiled list — and tapping an entry opens its meaning/conjugation panel.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  // rootBundle asset I/O doesn't resolve under the fake test clock, so warm
  // the shared caches with real async first; widgets then read them.
  Future<NounCollection> warmCaches(WidgetTester tester) async {
    late NounCollection collection;
    await tester.runAsync(() async {
      await NounSettings.instance.load();
      collection = await courseContentProvider.nounCollection('de');
      await courseContentProvider.verbCollection('de');
    });
    return collection;
  }

  Future<void> pumpLibrary(WidgetTester tester) async {
    await warmCaches(tester);
    await tester.pumpWidget(const MaterialApp(home: WordLibraryPage()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
  }

  testWidgets('loads + renders nouns from the shared collection',
      (tester) async {
    await pumpLibrary(tester);

    // The default active course learns German, so the page renders the shared
    // German nouns as filter chips.
    expect(find.byType(FilterChip), findsWidgets);
  });

  testWidgets('the noun panel shows the meaning in the course main language',
      (tester) async {
    final collection = await warmCaches(tester);
    final noun = collection.nouns.first;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Center(
            child: ElevatedButton(
              onPressed: () => showNounDetailPanel(context, noun),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    // The default course's UI language is English, so the meaning is the
    // English gloss; the include-in-quizzes switch rides along.
    expect(find.text('Meaning'), findsOneWidget);
    expect(find.text(noun.english), findsOneWidget);
    expect(find.text('Include in quizzes'), findsOneWidget);
  });

  testWidgets('the Verbs tab lists verbs and opens the conjugation panel',
      (tester) async {
    await pumpLibrary(tester);

    await tester.tap(find.text('Verbs'));
    await tester.pumpAndSettle();
    expect(find.text('sein'), findsOneWidget);

    await tester.tap(find.text('sein'));
    await tester.pumpAndSettle();

    // The panel builds lazily, so assert on the first table (the full ≥5-set
    // guarantee is covered by shared_collections_test on the data). At the
    // default 800-wide test surface the panel opens as a centered dialog.
    expect(find.byType(Dialog), findsOneWidget);
    expect(find.text('Präsens'), findsOneWidget);
    expect(find.text('bin'), findsOneWidget);
    // Once in the verbs-tab tile behind the panel, once in the pinned header.
    expect(find.text('to be'), findsNWidgets(2));

    // Scrolling deep into the tables keeps the verb + translation pinned
    // above the list (the problem the panel originally had). Drag the panel's
    // own ListView until the last table is reached.
    final panelList = find.descendant(
      of: find.byType(Dialog),
      matching: find.byType(ListView),
    );
    await tester.dragUntilVisible(
      find.text('Imperativ'),
      panelList,
      const Offset(0, -120),
    );
    await tester.pumpAndSettle();
    expect(find.text('to be'), findsNWidgets(2));
    expect(find.text('Imperativ'), findsOneWidget);
  });

  testWidgets('on a phone-width screen the panel opens as a bottom sheet',
      (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await pumpLibrary(tester);

    await tester.tap(find.text('Verbs'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('sein'));
    await tester.pumpAndSettle();

    expect(find.byType(DraggableScrollableSheet), findsOneWidget);
    expect(find.byType(Dialog), findsNothing);
    expect(find.text('Präsens'), findsOneWidget);
  });
}
