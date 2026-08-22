import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:german_pronouns_articles/models/course_session.dart';
import 'package:german_pronouns_articles/models/noun_settings.dart';
import 'package:german_pronouns_articles/pages/course_home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// How many rows the home currently shows as locked.
int _lockedRows() =>
    find.byIcon(Icons.lock_outline_rounded).evaluate().length +
    find.byIcon(Icons.lock_outline).evaluate().length;

/// Lets the page's async load actually run (asset + DB I/O needs the real
/// event loop), then paints. pumpAndSettle can't be used: the page animates.
Future<void> _letItLoad(WidgetTester tester) async {
  for (var i = 0; i < 12; i++) {
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 50)),
    );
    await tester.pump(const Duration(milliseconds: 50));
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    // The content DB lives under the documents dir; without a stub the page's
    // load throws and never resolves.
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (call) async => Directory.systemTemp.createTempSync('home_test').path,
    );
    SharedPreferences.setMockInitialValues({});
    await (await SharedPreferences.getInstance()).reload();
    await NounSettings.instance.load();
    await CourseSession.instance.loadCourses();
    await CourseSession.instance.setActiveCourse('de_cs');
    await CourseSession.instance.ensureActiveNavLoaded();
  });

  testWidgets('picking a starting level unlocks rows without reopening the page',
      (tester) async {
    tester.view.physicalSize = const Size(1200, 2200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MaterialApp(home: CourseHomePage()));
    // Something on the page animates forever, so pumpAndSettle never returns.
    await _letItLoad(tester);

    final lockedBefore = _lockedRows();
    expect(lockedBefore, greaterThan(0), reason: 'gated course starts locked');

    // The write a placement makes, without driving the sheet: the page must
    // notice it on its own.
    final refs = [
      for (final g in CourseSession.instance.activeCourse.nav.groups)
        for (final i in g.items) i.ref,
    ];
    await NounSettings.instance.setPlacementUnlocked(
      courseRefs: refs,
      unlocked: refs,
    );
    await _letItLoad(tester);

    expect(_lockedRows(), 0, reason: 'placed learner sees the course open');
  });
}
