import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:german_pronouns_articles/data/placement/placement_modules.dart';
import 'package:german_pronouns_articles/data/placement/placement_test.dart';
import 'package:german_pronouns_articles/models/course.dart';
import 'package:german_pronouns_articles/models/course_session.dart';
import 'package:german_pronouns_articles/models/nav_layout.dart';
import 'package:german_pronouns_articles/pages/placement_test_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Two modules of three questions each, all answerable with 'right'.
///
/// Three, not two: at two per module a single "I don't know" scores 1/2, which
/// is under the pass bar and ends the test — so the paper could never reach the
/// second module to check that focus survives a module boundary.
final _modules = placementModules(
  Course(
    id: 'placement_ui',
    name: 'T',
    tagline: 'T',
    speakFlag: 'gb',
    learnFlag: 'de',
    uiLang: UiLang.en,
    nav: NavLayout(
      groups: [
        NavGroup(
          id: 'a1_1',
          title: 'A1.1 · START',
          type: NavGroupType.quizzes,
          gated: true,
          items: [NavItem(ref: 'q1')],
        ),
        NavGroup(
          id: 'a1_2',
          title: 'A1.2 · NEXT',
          type: NavGroupType.quizzes,
          gated: true,
          items: [NavItem(ref: 'q2')],
        ),
      ],
    ),
  ),
);

List<PlacementQuestion> _questions() => [
  for (var m = 0; m < 2; m++)
    for (var i = 0; i < 3; i++)
      PlacementQuestion(
        moduleIndex: m,
        sentence: 'Module $m question $i: ich ____ hier.',
        acceptedAnswers: const ['right'],
      ),
];

Future<void> _pump(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1200, 2200);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      home: PlacementTestPage(modules: _modules, questions: _questions()),
    ),
  );
  await tester.pumpAndSettle();
}

bool _fieldHasFocus(WidgetTester tester) =>
    tester.widget<TextField>(find.byType(TextField)).focusNode?.hasFocus ??
    false;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await CourseSession.instance.loadCourses();
  });

  testWidgets('the answer field holds focus from one question to the next',
      (tester) async {
    await _pump(tester);
    final s = CourseSession.instance.strings.placement;

    expect(_fieldHasFocus(tester), isTrue, reason: 'first question');

    // Advancing with the button hands focus to the button — the field has to
    // take it back, or every question after the first needs a tap.
    await tester.enterText(find.byType(TextField), 'right');
    await tester.tap(find.text(s.next));
    await tester.pumpAndSettle();

    expect(find.textContaining('Module 0 question 1'), findsOneWidget);
    expect(_fieldHasFocus(tester), isTrue, reason: 'after Next');

    // "I don't know" is the other way forward, and must behave the same. One
    // skip leaves module 0 at 2/3, over the bar, so the test carries on.
    await tester.tap(find.text(s.dontKnow));
    await tester.pumpAndSettle();

    expect(find.textContaining('Module 0 question 2'), findsOneWidget);
    expect(_fieldHasFocus(tester), isTrue, reason: "after I don't know");

    // And across a module boundary, where the level chip changes too.
    await tester.enterText(find.byType(TextField), 'right');
    await tester.tap(find.text(s.next));
    await tester.pumpAndSettle();

    expect(find.textContaining('Module 1 question 0'), findsOneWidget);
    expect(_fieldHasFocus(tester), isTrue, reason: 'after a module boundary');
  });

  testWidgets('the field is cleared for each new question', (tester) async {
    await _pump(tester);

    await tester.enterText(find.byType(TextField), 'right');
    await tester.tap(find.text(CourseSession.instance.strings.placement.next));
    await tester.pumpAndSettle();

    expect(tester.widget<TextField>(find.byType(TextField)).controller?.text,
        isEmpty);
  });
}
