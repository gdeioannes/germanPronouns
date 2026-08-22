import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:german_pronouns_articles/models/course_session.dart';
import 'package:german_pronouns_articles/models/noun_settings.dart';
import 'package:german_pronouns_articles/widgets/placement_start_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Pumps a page whose only job is to open the starting-point sheet, and records
/// what [showPlacementStartSheet] returned.
Future<List<bool>> _pumpAndOpen(WidgetTester tester) async {
  final results = <bool>[];
  tester.view.physicalSize = const Size(1200, 2200);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => TextButton(
            onPressed: () async =>
                results.add(await showPlacementStartSheet(context)),
            child: const Text('open'),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('open'));
  await tester.pumpAndSettle();
  return results;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await (await SharedPreferences.getInstance()).reload();
    await NounSettings.instance.load();
    await CourseSession.instance.loadCourses();
    // Deutsch → Tschechisch: three gated modules, the smallest real course
    // with a locked progression.
    await CourseSession.instance.setActiveCourse('de_cs');
    await CourseSession.instance.ensureActiveNavLoaded();
  });

  testWidgets('offers all three starting points', (tester) async {
    await _pumpAndOpen(tester);

    final s = CourseSession.instance.strings.placement;
    expect(find.text(s.entryTitle), findsOneWidget);
    expect(find.text(s.optionTestTitle), findsOneWidget);
    expect(find.text(s.optionPickTitle), findsOneWidget);
    expect(find.text(s.optionResetTitle), findsOneWidget);
    // The promise that placing isn't the same as earning is on the sheet
    // itself, not only on the result screen.
    expect(find.text(s.noRewardsNote), findsOneWidget);
  });

  testWidgets('the level picker lists every module and cancels clean',
      (tester) async {
    final results = await _pumpAndOpen(tester);
    final s = CourseSession.instance.strings.placement;

    await tester.tap(find.text(s.optionPickTitle));
    await tester.pumpAndSettle();

    expect(find.text(s.pickTitle), findsOneWidget);
    for (final module in ['ERSTE KLÄNGE', 'ICH & DIE ANDEREN', 'ASPEKT']) {
      expect(
        find.textContaining(module, findRichText: true),
        findsOneWidget,
        reason: 'module "$module" should be pickable',
      );
    }

    // Backing out must write nothing at all — the whole flow is destructive
    // once applied, so a cancel has to be inert.
    await tester.tap(find.text(CourseSession.instance.strings.cancel));
    await tester.pumpAndSettle();

    expect(results, [false]);
    expect(NounSettings.instance.placementUnlockedQuizzes, isEmpty);
  });

  testWidgets('dismissing the sheet changes nothing', (tester) async {
    final results = await _pumpAndOpen(tester);

    Navigator.of(tester.element(find.byType(Scaffold).first)).pop();
    await tester.pumpAndSettle();

    expect(results, [false]);
    expect(NounSettings.instance.placementUnlockedQuizzes, isEmpty);
  });
}
