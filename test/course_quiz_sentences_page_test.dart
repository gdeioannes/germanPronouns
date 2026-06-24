import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:german_pronouns_articles/data/content/content_editor.dart';
import 'package:german_pronouns_articles/data/content/course_content_provider.dart';
import 'package:german_pronouns_articles/data/course_catalog.dart';
import 'package:german_pronouns_articles/models/content/populated_course.dart';
import 'package:german_pronouns_articles/models/content/quiz.dart';
import 'package:german_pronouns_articles/models/quiz_content.dart';
import 'package:german_pronouns_articles/pages/back_office/course_quiz_sentences_page.dart';

import 'support/in_memory_content.dart';

void main() {
  final course = defaultCourses.firstWhere((c) => c.id == 'en_de');
  const quiz = FillBlankQuiz(
    id: 'q1',
    title: 'Q1',
    storageKeyPrefix: 'q1_',
    promptLabel: 'W',
    subjectsLabel: 'S',
    subjectColumnLabel: 'S',
    subjects: [QuizSubjectData(key: 's0', display: 'Ich')],
    categories: [QuizCategoryData(label: 'Nom', group: 'g', values: ['mein'])],
    sentences: [
      QuizSentenceData(
        subjectKey: 's0',
        categoryLabel: 'Nom',
        sentence: 'Das ist ____ Buch.',
        acceptedAnswers: ['mein'],
      ),
      QuizSentenceData(
        subjectKey: 's0',
        categoryLabel: 'Nom',
        sentence: 'Hier ist ____ Auto.',
        acceptedAnswers: ['mein'],
      ),
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

  testWidgets('lists sentences and deletes one, persisting via the editor',
      (tester) async {
    final editor = newEditor();
    await tester.pumpWidget(MaterialApp(
      home: CourseQuizSentencesPage(
        editor: editor,
        courseId: 'en_de',
        quizId: 'q1',
        title: 'Q1',
      ),
    ));
    await tester.pumpAndSettle();

    expect(find.text('Das ist ____ Buch.'), findsOneWidget);
    expect(find.text('Hier ist ____ Auto.'), findsOneWidget);

    await tester.tap(find.byTooltip('Delete').first);
    await tester.pumpAndSettle();

    expect(find.text('Das ist ____ Buch.'), findsNothing);
    final saved =
        (await editor.course('en_de')).quizById('q1')! as FillBlankQuiz;
    expect(saved.sentences.length, 1);
    expect(saved.sentences.first.sentence, 'Hier ist ____ Auto.');
  });
}
