import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:german_pronouns_articles/models/app_page.dart';
import 'package:german_pronouns_articles/models/app_session.dart';
import 'package:german_pronouns_articles/models/course_session.dart';
import 'package:german_pronouns_articles/models/noun_settings.dart';
import 'package:german_pronouns_articles/models/quiz_content.dart';
import 'package:german_pronouns_articles/pages/inline_cloze_quiz_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// First-render + scoring coverage for the inline "big text" quiz
/// (`InlineClozeQuizPage`): a `reading` quiz whose answers live *inside* the
/// passage — a case dropdown (`select`) and a typed field (`input`).
QuizContent _inlineContent() => const QuizContent(
  id: 'inline_smoke',
  title: 'Inline Smoke',
  kind: QuizKind.reading,
  storageKeyPrefix: 'inline_smoke_',
  promptLabel: 'Sentence',
  subjectsLabel: 'Sentences',
  subjectColumnLabel: 'German',
  subjects: [],
  categories: [],
  sentences: [],
  readingTitle: 'Test',
  readingPassage: 'Mio frisst den Tisch und die Lampe.',
  readingPassageTranslation: 'Mio eats the table and the lamp.',
  inlineTemplate: 'Mio frisst den Tisch {{0}} und die {{1}} Lampe.',
  inlineBlanks: [
    InlineBlank(
      kind: 'select',
      answer: 'Akkusativ',
      options: ['Nominativ', 'Akkusativ', 'Dativ'],
    ),
    InlineBlank(kind: 'input', answer: 'neue'),
  ],
  helpMemoryIntro: 'Pick the case; type the ending.',
  helpMemoryTips: [HelpMemoryTip(text: 'Only the masculine changes.')],
);

Widget _wrap() => MaterialApp(
  home: InlineClozeQuizPage(
    content: _inlineContent(),
    currentPage: AppPage.articles,
  ),
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await AppSession.instance.load();
    await CourseSession.instance.load();
    await NounSettings.instance.load();
  });

  testWidgets('renders an inline dropdown and a typed field', (tester) async {
    await tester.pumpWidget(_wrap());
    await tester.pump();

    expect(find.byType(InlineClozeQuizPage), findsOneWidget);
    expect(find.byType(DropdownButton<String>), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    // The passage text flows around the controls.
    expect(find.textContaining('Mio frisst den Tisch'), findsOneWidget);
  });

  testWidgets('scores both inline blanks and passes when correct',
      (tester) async {
    final strings = CourseSession.instance.strings;
    await tester.pumpWidget(_wrap());
    await tester.pump();

    // Choose the correct case from the dropdown.
    await tester.tap(find.byType(DropdownButton<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Akkusativ').last);
    await tester.pumpAndSettle();

    // Type the correct adjective ending into the inline field.
    await tester.enterText(find.byType(TextField), 'neue');
    await tester.pump();

    // Submit and verify the pass result.
    await tester.tap(find.widgetWithText(FilledButton, strings.readingCheckAnswers));
    await tester.pumpAndSettle();

    expect(find.text(strings.readingPassed), findsOneWidget);
    expect(find.textContaining('2 / 2'), findsOneWidget);
  });
}
