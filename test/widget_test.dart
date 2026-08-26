import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:german_pronouns_articles/main.dart';

void main() {
  testWidgets('shows the landing screen with featured courses on launch', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Pick a course, start right away'), findsOneWidget);
    // Three one-tap featured course cards (English site language in tests).
    expect(find.text('Start now'), findsNWidgets(3));
    expect(find.text('More courses'), findsOneWidget);
    expect(find.text('Teacher sign in'), findsOneWidget);
  });
}
