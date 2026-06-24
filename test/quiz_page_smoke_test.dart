import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:german_pronouns_articles/models/app_page.dart';
import 'package:german_pronouns_articles/models/app_session.dart';
import 'package:german_pronouns_articles/models/course_session.dart';
import 'package:german_pronouns_articles/models/noun_settings.dart';
import 'package:german_pronouns_articles/models/quiz_config.dart';
import 'package:german_pronouns_articles/widgets/quiz_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// First render coverage for the fill-in-the-blank engine (`quiz_page.dart`),
/// the largest, previously-untested page — the safety net a future refactor of
/// the monolith leans on. Built from a minimal hand-made [QuizConfig] with no
/// progression/content id, so `initState` resolves "next exercise" to null
/// without touching the database.
QuizConfig _minimalConfig() => QuizConfig(
  title: 'Smoke Quiz',
  storageKeyPrefix: 'smoke_quiz_',
  promptLabel: 'Wort',
  subjectsLabel: 'Subjects',
  subjectColumnLabel: 'Subject',
  subjects: const ['s0'],
  subjectDisplays: const ['Ich'],
  categories: const [
    QuizCategoryDefinition(label: 'Nominativ', values: ['mein'], group: 'g'),
  ],
  groupWeights: const {'g': 1.0},
  pickSentence: ({
    required String caseLabel,
    required String nominative,
    required String answer,
    required Random random,
  }) => '____ Buch',
  buildExplanation: ({
    required String caseLabel,
    required String nominative,
    required String answer,
    required String sentence,
  }) => 'Erklärung.',
  currentPage: AppPage.articles,
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await AppSession.instance.load();
    await CourseSession.instance.load();
    await NounSettings.instance.load();
  });

  testWidgets('QuizPage renders a fill-in question with an answer field',
      (tester) async {
    await tester.pumpWidget(MaterialApp(home: QuizPage(config: _minimalConfig())));
    // Repeating animations mean pumpAndSettle would never settle; a couple of
    // bounded pumps are enough to build the first frame.
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.byType(QuizPage), findsOneWidget);
    expect(find.byType(TextField), findsWidgets);
  });
}
