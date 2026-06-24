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
QuizConfig _config({
  List<HelpMemoryTable>? helpMemoryTables,
  String storageKeyPrefix = 'smoke_quiz_',
}) => QuizConfig(
  title: 'Smoke Quiz',
  storageKeyPrefix: storageKeyPrefix,
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
  helpMemoryTables: helpMemoryTables,
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

  testWidgets(
      'renders a fill-in question and auto-opens Help Memory on first visit',
      (tester) async {
    await tester.pumpWidget(MaterialApp(home: QuizPage(config: _config())));
    // First frame schedules the first-visit Help Memory dialog; a second bounded
    // pump lets its route build. (Repeating animations mean pumpAndSettle would
    // never settle.)
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byType(QuizPage), findsOneWidget);
    expect(find.byType(TextField), findsWidgets);
    // The auto-opened Help Memory exercises the complex, content-aware
    // reference-table rendering — the safety net for extracting that builder.
    expect(
      find.text(CourseSession.instance.strings.helpMemory),
      findsWidgets,
    );
  });

  testWidgets('renders the extracted Help Memory reference table',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: QuizPage(
        config: _config(
          storageKeyPrefix: 'smoke_table_',
          helpMemoryTables: const [
            HelpMemoryTable(
              title: 'Reference',
              columns: [HelpMemoryColumn(categoryLabel: 'Nominativ')],
            ),
          ],
        ),
      ),
    ));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    // The first-visit Help Memory renders the table via HelpMemoryDataTable.
    expect(find.text('Reference'), findsWidgets);
  });
}
