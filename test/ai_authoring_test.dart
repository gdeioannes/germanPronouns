import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:german_pronouns_articles/data/content/ai_authoring_service.dart';
import 'package:german_pronouns_articles/data/content/content_editor.dart';
import 'package:german_pronouns_articles/data/content/course_content_provider.dart';
import 'package:german_pronouns_articles/data/course_catalog.dart';
import 'package:german_pronouns_articles/models/content/populated_course.dart';
import 'package:german_pronouns_articles/models/content/quiz.dart';

import 'support/in_memory_content.dart';

void main() {
  const ai = TemplateAiAuthoringService();
  final course = defaultCourses.firstWhere((c) => c.id == 'en_de');
  final courseStr = jsonEncode(
    PopulatedCourse(course: course, version: 't', quizzes: const []).toJson(),
  );

  ContentEditor newEditor() {
    final store = InMemoryBundleStore();
    final provider = CachingCourseProvider(
      InMemoryContentSource(courseStr),
      store: store,
    );
    return ContentEditor(provider: provider, store: store);
  }

  const expectedType = {
    AiQuizType.fillBlank: FillBlankQuiz,
    AiQuizType.reading: ReadingQuiz,
    AiQuizType.listening: ListeningQuiz,
    AiQuizType.speakRepeat: SpeakRepeatQuiz,
    AiQuizType.dictation: DictationQuiz,
  };

  for (final type in AiQuizType.values) {
    test('drafts a valid ${type.name} quiz that round-trips and saves', () async {
      final draft = await ai.draftQuiz(
        type: type,
        id: 'ai_${type.name}',
        topic: 'Mein Thema',
      );

      // Right subtype, and survives the schema gate (fromJson(toJson)).
      expect(draft.runtimeType, expectedType[type]);
      final reparsed = Quiz.fromJson(
        jsonDecode(jsonEncode(draft.toJson())) as Map<String, dynamic>,
      );
      expect(reparsed.runtimeType, draft.runtimeType);

      // Flows through the same validated editor save path into the course.
      final editor = newEditor();
      await editor.saveQuiz('en_de', draft);
      expect(
        (await editor.course('en_de')).quizById('ai_${type.name}'),
        isNotNull,
      );
    });
  }

  test('a drafted quiz with a colliding storageKeyPrefix is rejected', () async {
    final editor = newEditor();
    final first = await ai.draftQuiz(
      type: AiQuizType.fillBlank,
      id: 'a',
      topic: 'A',
    );
    await editor.saveQuiz('en_de', first);

    // Different id, but reusing the first quiz's prefix — the editor rejects it.
    final clash = Quiz.fromJson(
      (await ai.draftQuiz(type: AiQuizType.reading, id: 'b', topic: 'B'))
          .toJson()
        ..['storageKeyPrefix'] = 'a_',
    );
    expect(() => editor.saveQuiz('en_de', clash), throwsArgumentError);
  });
}
