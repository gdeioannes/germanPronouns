import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:german_pronouns_articles/main.dart';

void main() {
  testWidgets('shows the login screen on launch', (tester) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.text('Start learning'), findsOneWidget);
    expect(find.text('Teacher sign in'), findsOneWidget);
  });
}
