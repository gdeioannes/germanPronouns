import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:german_pronouns_articles/data/content/content_editor.dart';
import 'package:german_pronouns_articles/data/content/course_content_provider.dart';
import 'package:german_pronouns_articles/data/course_catalog.dart';
import 'package:german_pronouns_articles/models/content/populated_course.dart';
import 'package:german_pronouns_articles/models/content/quiz.dart';
import 'package:german_pronouns_articles/models/quiz_content.dart';
import 'package:german_pronouns_articles/pages/back_office/course_reading_questions_page.dart';

import 'support/in_memory_content.dart';

void main() {
  final course = defaultCourses.firstWhere((c) => c.id == 'en_de');
  const quiz = ReadingQuiz(
    id: 'r1',
    title: 'R1',
    storageKeyPrefix: 'r1_',
    promptLabel: 'Frage',
    subjectsLabel: 'Fragen',
    subjectColumnLabel: 'Frage',
    passage: 'Ein kurzer Text.',
    questions: [
      ReadingQuestion(question: 'Was?', options: ['a', 'b'], correctIndex: 0),
      ReadingQuestion(question: 'Wer?', options: ['x', 'y'], correctIndex: 1),
    ],
  );
  final courseStr = jsonEncode(
    PopulatedCourse(course: course, version: 't', quizzes: [quiz]).toJson(),
  );

  ContentEditor newEditor() {
    final store = InMemoryBundleStore();
    final provider = CachingCourseProvider(
      InMemoryContentSource(courseStr),
      store: store,
    );
    return ContentEditor(provider: provider, store: store);
  }

  testWidgets('lists reading questions and deletes one, persisting',
      (tester) async {
    final editor = newEditor();
    await tester.pumpWidget(MaterialApp(
      home: CourseReadingQuestionsPage(
        editor: editor,
        courseId: 'en_de',
        quizId: 'r1',
        title: 'R1',
      ),
    ));
    await tester.pumpAndSettle();

    expect(find.text('Was?'), findsOneWidget);
    expect(find.text('Wer?'), findsOneWidget);

    await tester.tap(find.byTooltip('Delete').first);
    await tester.pumpAndSettle();

    expect(find.text('Was?'), findsNothing);
    final saved = (await editor.course('en_de')).quizById('r1')!;
    expect(questionsOf(saved).length, 1);
    expect(questionsOf(saved).first.question, 'Wer?');
  });
}
