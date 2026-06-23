import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:german_pronouns_articles/data/content/content_editor.dart';
import 'package:german_pronouns_articles/data/content/course_content_provider.dart';
import 'package:german_pronouns_articles/data/course_catalog.dart';
import 'package:german_pronouns_articles/data/quiz_content_library.dart';
import 'package:german_pronouns_articles/models/content/populated_course.dart';
import 'package:german_pronouns_articles/models/content/quiz.dart';

import 'support/in_memory_content.dart';

/// Returns a copy of [q] with one JSON field changed — a stand-in for the
/// editor forms building an edited quiz.
Quiz _edited(Quiz q, String key, Object? value) =>
    Quiz.fromJson(q.toJson()..[key] = value);

void main() {
  final course = defaultCourses.firstWhere((c) => c.id == 'en_de');
  final seedQuizzes = [
    for (final c in allQuizContent)
      if (c.id == 'article' || c.id == 'pronoun') Quiz.fromLegacy(c),
  ];
  final courseStr = jsonEncode(
    PopulatedCourse(course: course, version: 't', quizzes: seedQuizzes).toJson(),
  );

  ({
    ContentEditor editor,
    CachingCourseProvider provider,
    InMemoryBundleStore store,
  }) build() {
    final store = InMemoryBundleStore();
    final provider = CachingCourseProvider(
      InMemoryContentSource(courseStr),
      store: store,
    );
    return (
      editor: ContentEditor(provider: provider, store: store),
      provider: provider,
      store: store,
    );
  }

  test('editing a quiz persists and is served to the learner', () async {
    final t = build();
    final original = (await t.editor.course('en_de')).quizById('article')!;

    await t.editor.saveQuiz('en_de', _edited(original, 'title', 'Edited Title'));

    final reloaded = (await t.editor.course('en_de')).quizById('article')!;
    expect(reloaded.title, 'Edited Title');
    expect(t.store.data['en_de'], isNotNull, reason: 'edit persisted to store');
  });

  test('adding a new quiz appends it to the course', () async {
    final t = build();
    final base = (await t.editor.course('en_de')).quizById('pronoun')!;
    final added = _edited(
      _edited(base, 'id', 'new_quiz'),
      'storageKeyPrefix',
      'new_quiz_',
    );

    await t.editor.saveQuiz('en_de', added);

    expect((await t.editor.course('en_de')).quizById('new_quiz'), isNotNull);
  });

  test('deleting a quiz removes it', () async {
    final t = build();
    await t.editor.deleteQuiz('en_de', 'article');
    expect((await t.editor.course('en_de')).quizById('article'), isNull);
    expect((await t.editor.course('en_de')).quizById('pronoun'), isNotNull);
  });

  test('resetCourse drops edits and reverts to the shipped bundle', () async {
    final t = build();
    final original = (await t.editor.course('en_de')).quizById('article')!;
    await t.editor.saveQuiz('en_de', _edited(original, 'title', 'X'));

    await t.editor.resetCourse('en_de');

    expect((await t.editor.course('en_de')).quizById('article')!.title,
        original.title);
    expect(t.store.data['en_de'], isNull);
  });

  test('changing a storageKeyPrefix is rejected (it keys saved progress)',
      () async {
    final t = build();
    final original = (await t.editor.course('en_de')).quizById('article')!;
    final moved = _edited(original, 'storageKeyPrefix', 'moved_');

    expect(
      () => t.editor.saveQuiz('en_de', moved),
      throwsArgumentError,
    );
  });
}
