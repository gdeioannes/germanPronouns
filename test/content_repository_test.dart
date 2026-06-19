import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:sembast/sembast_memory.dart';

import 'package:german_pronouns_articles/data/db/content_repository.dart';
import 'package:german_pronouns_articles/models/nav_layout.dart';
import 'package:german_pronouns_articles/data/preposition_content.dart';
import 'package:german_pronouns_articles/data/quiz_content_library.dart';
import 'package:german_pronouns_articles/models/quiz_content.dart';

void main() {
  var counter = 0;

  Future<Database> openDb() =>
      databaseFactoryMemory.openDatabase('test_${counter++}.db');

  Future<ContentRepository> openSeeded() async {
    // A fresh in-memory database per test, so seeding always runs.
    final repo = ContentRepository(await openDb());
    await repo.seedIfEmpty(allQuizContent);
    return repo;
  }

  test('seeds every quiz from the content library', () async {
    final repo = await openSeeded();
    final quizzes = await repo.listQuizzes();
    expect(quizzes.length, allQuizContent.length);
    expect(
      quizzes.firstWhere((q) => q.id == 'preposition').sentenceCount,
      prepositionQuizContent.sentences.length,
    );
  });

  test('reconstructs a quiz identical to its seed', () async {
    final repo = await openSeeded();
    final restored = await repo.quizContent('preposition');
    expect(restored!.toJson(), prepositionQuizContent.toJson());
  });

  test('adds then deletes a sentence', () async {
    final repo = await openSeeded();
    final before = (await repo.sentencesFor('preposition')).length;

    final key = await repo.addSentence(
      'preposition',
      const QuizSentenceData(
        subjectKey: 'durch',
        categoryLabel: 'Präposition',
        sentence: 'Wir laufen ____ den Park.',
        acceptedAnswers: ['durch'],
      ),
    );
    expect((await repo.sentencesFor('preposition')).length, before + 1);

    await repo.deleteSentence(key);
    expect((await repo.sentencesFor('preposition')).length, before);
  });

  test('updates a sentence in place', () async {
    final repo = await openSeeded();
    final first = (await repo.sentencesFor('preposition')).first;

    await repo.updateSentence(
      'preposition',
      first.key,
      QuizSentenceData(
        subjectKey: first.data.subjectKey,
        categoryLabel: first.data.categoryLabel,
        sentence: 'EDITED ____ sentence.',
        acceptedAnswers: first.data.acceptedAnswers,
      ),
    );

    final reloaded =
        (await repo.sentencesFor('preposition')).firstWhere((s) => s.key == first.key);
    expect(reloaded.data.sentence, 'EDITED ____ sentence.');
  });

  test('exports quizzes and the nav layout as a JSON object', () async {
    final repo = await openSeeded();
    final decoded = jsonDecode(await repo.exportJson()) as Map<String, dynamic>;
    expect((decoded['quizzes'] as List).length, allQuizContent.length);
    expect(decoded['nav'], isA<Map>());
  });

  test('navLayout defaults, persists and reseeds', () async {
    final repo = ContentRepository(await openDb());
    expect((await repo.navLayout()).groups, isNotEmpty); // default

    final edited = NavLayout(groups: [
      (await repo.navLayout()).groups.first.copyWith(title: 'EDITED'),
    ]);
    await repo.saveNavLayout(edited);
    expect((await repo.navLayout()).groups.single.title, 'EDITED');
  });

  group('seedOrUpgrade', () {
    test('seeds a fresh database and records the version', () async {
      final repo = ContentRepository(await openDb());
      await repo.seedOrUpgrade(allQuizContent);
      expect(await repo.seededVersion(), kSeedVersion);
      expect((await repo.listQuizzes()).length, allQuizContent.length);
    });

    test('keeps local edits when the version is unchanged', () async {
      final repo = ContentRepository(await openDb());
      await repo.seedOrUpgrade(allQuizContent);
      final before = (await repo.sentencesFor('preposition')).length;
      await repo.addSentence(
        'preposition',
        const QuizSentenceData(
          subjectKey: 'durch',
          categoryLabel: 'Präposition',
          sentence: 'Local ____ edit.',
          acceptedAnswers: ['durch'],
        ),
      );
      // Same version → no reseed, the local edit survives.
      await repo.seedOrUpgrade(allQuizContent);
      expect((await repo.sentencesFor('preposition')).length, before + 1);
    });

    test('re-seeds an install with an older content version', () async {
      final db = await openDb();
      final repo = ContentRepository(db);
      await repo.seedOrUpgrade(allQuizContent);
      // A local edit + a stale stored version (older install).
      await repo.addSentence(
        'preposition',
        const QuizSentenceData(
          subjectKey: 'durch',
          categoryLabel: 'Präposition',
          sentence: 'Stale ____ edit.',
          acceptedAnswers: ['durch'],
        ),
      );
      await stringMapStoreFactory
          .store('meta')
          .record('seed')
          .put(db, {'version': kSeedVersion - 1});

      final canonical = (await repo.sentencesFor('preposition')).length - 1;
      await repo.seedOrUpgrade(allQuizContent);

      // Re-seeded back to the published content (edit gone) + version restored.
      expect((await repo.sentencesFor('preposition')).length, canonical);
      expect(await repo.seededVersion(), kSeedVersion);
    });
  });
}
