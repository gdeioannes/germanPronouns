import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:german_pronouns_articles/l10n/app_strings.dart';
import 'package:german_pronouns_articles/models/course.dart';
import 'package:german_pronouns_articles/pages/about_me_page.dart';

/// Reads the challenge ("7 + 4 = ?") off the screen and solves it, so the test
/// works whatever random sum the card generated.
int _sumOnScreen(WidgetTester tester) {
  final text = tester
      .widgetList<Text>(find.byType(Text))
      .map((t) => t.data ?? '')
      .firstWhere((d) => RegExp(r'^\d+ \+ \d+ = \?$').hasMatch(d));
  final parts = RegExp(r'\d+').allMatches(text).map((m) => int.parse(m[0]!));
  return parts.reduce((a, b) => a + b);
}

/// Taps the answer button for [value] when it is offered; the four options are
/// near misses, so a deliberately wrong answer may not be on screen — in that
/// case tap whichever option is not the correct one.
Future<void> _tapAnswer(WidgetTester tester, int value) async {
  var target = find.widgetWithText(OutlinedButton, '$value');
  if (target.evaluate().isEmpty) {
    final correct = '${_sumOnScreen(tester)}';
    target = find
        .byWidgetPredicate((w) =>
            w is OutlinedButton && (w.child as Text).data != correct)
        .first;
  }
  await tester.tap(target);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('shows the story and a copyable contact address', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: AboutMePage()));
    await tester.pumpAndSettle();

    final en = stringsFor(UiLang.en);
    expect(find.text(en.aboutMeWhy), findsOneWidget);
    expect(find.text(en.aboutMeContent), findsOneWidget);
    expect(find.text(en.aboutMeFeedback), findsOneWidget);
    // The contact card sits below the fold on a small test screen.
    final email = find.byWidgetPredicate(
      (w) => w is SelectableText && w.data == contactEmail(),
    );
    await tester.drag(find.byType(ListView), const Offset(0, -400));
    await tester.pumpAndSettle();

    // Anti-harvesting gate: nothing resembling the address is in the widget
    // tree until a human taps to reveal it.
    expect(email, findsNothing);
    expect(find.byIcon(Icons.copy_outlined), findsNothing);
    expect(find.text(en.aboutMeShowEmail), findsOneWidget);

    await tester.tap(find.text(en.aboutMeShowEmail));
    await tester.pumpAndSettle();

    // A sum stands between the reader and the address; still nothing to grab.
    expect(find.text(en.aboutMeRobotCheck), findsOneWidget);
    expect(email, findsNothing);

    // A wrong answer reveals nothing and swaps in a fresh sum.
    final firstSum = _sumOnScreen(tester);
    await _tapAnswer(tester, firstSum + 1);
    expect(email, findsNothing);
    expect(find.text(en.aboutMeRobotWrong), findsOneWidget);

    await _tapAnswer(tester, _sumOnScreen(tester));
    expect(email, findsOneWidget);

    String? copied;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          copied = (call.arguments as Map)['text'] as String?;
        }
        return null;
      },
    );
    addTearDown(() => tester.binding.defaultBinaryMessenger
        .setMockMethodCallHandler(SystemChannels.platform, null));

    await tester.tap(find.byIcon(Icons.copy_outlined));
    await tester.pump();
    expect(copied, contactEmail());
  });

  test('the address is assembled at runtime, never a literal in the bundle',
      () {
    expect(contactEmail(), 'gdeioannes@gmail.com');
    final source =
        File('lib/pages/about_me_page.dart').readAsStringSync();
    expect(
      RegExp(r'[\w.]+@[\w.]+\.\w+').allMatches(source).map((m) => m[0]),
      isEmpty,
      reason: 'no plain address may appear in the source (it is compiled '
          'into the shipped web bundle, where harvesters grep for it)',
    );
  });

  test('every UI language translates the About me page', () {
    for (final lang in UiLang.values) {
      final s = stringsFor(lang);
      for (final text in [
        s.aboutMeTitle,
        s.aboutMeWhy,
        s.aboutMeContent,
        s.aboutMeFeedback,
        s.aboutMeContact,
        s.aboutMeWriteMe,
        s.aboutMeShowEmail,
        s.aboutMeRobotCheck,
        s.aboutMeRobotWrong,
      ]) {
        expect(text.trim(), isNotEmpty, reason: '$lang has an empty string');
      }
      // The English copy must not leak into the other languages.
      if (lang != UiLang.en) {
        expect(s.aboutMeWhy, isNot(stringsFor(UiLang.en).aboutMeWhy));
      }
    }
  });
}
