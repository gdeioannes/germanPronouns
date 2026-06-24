import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:german_pronouns_articles/data/content/content_editor.dart';
import 'package:german_pronouns_articles/data/content/course_content_provider.dart';
import 'package:german_pronouns_articles/data/course_catalog.dart';
import 'package:german_pronouns_articles/models/content/populated_course.dart';
import 'package:german_pronouns_articles/models/content/quiz.dart';
import 'package:german_pronouns_articles/pages/back_office/course_spoken_lines_page.dart';

import 'support/in_memory_content.dart';

void main() {
  final course = defaultCourses.firstWhere((c) => c.id == 'en_de');
  const quiz = SpeakRepeatQuiz(
    id: 'sp1',
    title: 'SP1',
    storageKeyPrefix: 'sp1_',
    promptLabel: 'Phrase',
    subjectsLabel: 'Phrasen',
    subjectColumnLabel: 'Phrase',
    phrases: [
      SpokenLine(id: 's0', text: 'Guten Tag', translation: 'Good day'),
      SpokenLine(id: 's1', text: 'Danke', translation: 'Thanks'),
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

  testWidgets('lists spoken lines and deletes one, persisting', (tester) async {
    final editor = newEditor();
    await tester.pumpWidget(MaterialApp(
      home: CourseSpokenLinesPage(
        editor: editor,
        courseId: 'en_de',
        quizId: 'sp1',
        title: 'SP1',
      ),
    ));
    await tester.pumpAndSettle();

    expect(find.text('Guten Tag'), findsOneWidget);
    expect(find.text('Danke'), findsOneWidget);

    await tester.tap(find.byTooltip('Delete').first);
    await tester.pumpAndSettle();

    expect(find.text('Guten Tag'), findsNothing);
    final saved = (await editor.course('en_de')).quizById('sp1')!;
    expect(linesOf(saved).length, 1);
    expect(linesOf(saved).first.text, 'Danke');
  });
}
