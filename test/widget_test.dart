import 'package:flutter_test/flutter_test.dart';

import 'package:german_pronouns_articles/main.dart';

void main() {
  testWidgets('shows the login screen on launch', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    expect(find.text('Continue as learner'), findsOneWidget);
    expect(find.text('Teacher sign in'), findsOneWidget);
  });
}
