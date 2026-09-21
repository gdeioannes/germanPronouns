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
  final course = defaultCourses.firstWhere((c) => c.id == 'de_cert_a1');
  final seedQuizzes = [
    for (final c in allQuizContent)
      if (c.id == 'quest_a1_1_zahlen' || c.id == 'quest_a1_1_pronomen') Quiz.fromLegacy(c),
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
    final original = (await t.editor.course('de_cert_a1')).quizById('quest_a1_1_zahlen')!;

    await t.editor.saveQuiz('de_cert_a1', _edited(original, 'title', 'Edited Title'));

    final reloaded = (await t.editor.course('de_cert_a1')).quizById('quest_a1_1_zahlen')!;
    expect(reloaded.title, 'Edited Title');
    expect(t.store.data['de_cert_a1'], isNotNull, reason: 'edit persisted to store');
  });

  test('adding a new quiz appends it to the course', () async {
    final t = build();
    final base = (await t.editor.course('de_cert_a1')).quizById('quest_a1_1_pronomen')!;
    final added = _edited(
      _edited(base, 'id', 'new_quiz'),
      'storageKeyPrefix',
      'new_quiz_',
    );

    await t.editor.saveQuiz('de_cert_a1', added);

    expect((await t.editor.course('de_cert_a1')).quizById('new_quiz'), isNotNull);
  });

  test('deleting a quiz removes it', () async {
    final t = build();
    await t.editor.deleteQuiz('de_cert_a1', 'quest_a1_1_zahlen');
    expect((await t.editor.course('de_cert_a1')).quizById('quest_a1_1_zahlen'), isNull);
    expect((await t.editor.course('de_cert_a1')).quizById('quest_a1_1_pronomen'), isNotNull);
  });

  test('reorderQuizzes persists the new order', () async {
    final t = build();
    final before =
        (await t.editor.course('de_cert_a1')).quizzes.map((q) => q.id).toList();
    expect(before.length, 2);

    await t.editor.reorderQuizzes(
      'de_cert_a1',
      (await t.editor.course('de_cert_a1')).quizzes.reversed.toList(),
    );

    final after =
        (await t.editor.course('de_cert_a1')).quizzes.map((q) => q.id).toList();
    expect(after, before.reversed.toList());
  });

  test('reorderQuizzes rejects adding/dropping a quiz', () async {
    final t = build();
    final quizzes = (await t.editor.course('de_cert_a1')).quizzes;
    expect(
      () => t.editor.reorderQuizzes('de_cert_a1', [quizzes.first]),
      throwsArgumentError,
    );
  });

  test('createQuiz adds an empty typed quiz the teacher can fill', () async {
    final t = build();

    final created = await t.editor.createQuiz(
      'de_cert_a1',
      type: 'reading',
      id: 'r1',
      title: 'New Reading',
      storageKeyPrefix: 'r1_',
    );
    expect(created, isA<ReadingQuiz>());

    final reloaded = (await t.editor.course('de_cert_a1')).quizById('r1');
    expect(reloaded, isA<ReadingQuiz>());
    expect(reloaded!.title, 'New Reading');
    expect(reloaded.storageKeyPrefix, 'r1_');
  });

  test('createQuiz rejects a duplicate storageKeyPrefix', () async {
    final t = build();
    final existing = (await t.editor.course('de_cert_a1')).quizById('quest_a1_1_zahlen')!;
    expect(
      () => t.editor.createQuiz(
        'de_cert_a1',
        type: 'fillBlank',
        id: 'dup',
        title: 'Dup',
        storageKeyPrefix: existing.storageKeyPrefix,
      ),
      throwsArgumentError,
    );
  });

  test('emptyQuiz builds the right subtype for each discriminator', () {
    expect(
      emptyQuiz(type: 'fillBlank', id: 'a', title: 'A', storageKeyPrefix: 'a_'),
      isA<FillBlankQuiz>(),
    );
    expect(
      emptyQuiz(type: 'reading', id: 'b', title: 'B', storageKeyPrefix: 'b_'),
      isA<ReadingQuiz>(),
    );
    expect(
      emptyQuiz(type: 'listening', id: 'c', title: 'C', storageKeyPrefix: 'c_'),
      isA<ListeningQuiz>(),
    );
    expect(
      emptyQuiz(
        type: 'speakRepeat',
        id: 'd',
        title: 'D',
        storageKeyPrefix: 'd_',
      ),
      isA<SpeakRepeatQuiz>(),
    );
    expect(
      emptyQuiz(
        type: 'dictation',
        id: 'e',
        title: 'E',
        storageKeyPrefix: 'e_',
      ),
      isA<DictationQuiz>(),
    );
  });

  test('resetCourse drops edits and reverts to the shipped bundle', () async {
    final t = build();
    final original = (await t.editor.course('de_cert_a1')).quizById('quest_a1_1_zahlen')!;
    await t.editor.saveQuiz('de_cert_a1', _edited(original, 'title', 'X'));

    await t.editor.resetCourse('de_cert_a1');

    expect((await t.editor.course('de_cert_a1')).quizById('quest_a1_1_zahlen')!.title,
        original.title);
    expect(t.store.data['de_cert_a1'], isNull);
  });

  test('changing a storageKeyPrefix is rejected (it keys saved progress)',
      () async {
    final t = build();
    final original = (await t.editor.course('de_cert_a1')).quizById('quest_a1_1_zahlen')!;
    final moved = _edited(original, 'storageKeyPrefix', 'moved_');

    expect(
      () => t.editor.saveQuiz('de_cert_a1', moved),
      throwsArgumentError,
    );
  });
}
