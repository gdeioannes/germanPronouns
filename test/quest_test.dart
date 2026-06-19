import 'dart:convert';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

import 'package:german_pronouns_articles/data/quest_data.dart';
import 'package:german_pronouns_articles/data/quiz_content_adapter.dart';
import 'package:german_pronouns_articles/models/app_page.dart';
import 'package:german_pronouns_articles/models/quiz_content.dart';

Map<String, dynamic> _throughJson(Map<String, dynamic> json) =>
    jsonDecode(jsonEncode(json)) as Map<String, dynamic>;

void main() {
  group('Quest content is database-ready and runnable', () {
    for (final entry in questEntries) {
      final content = entry.content;

      test('${content.id}: round-trips through JSON unchanged', () {
        final json = content.toJson();
        final restored = QuizContent.fromJson(_throughJson(json));
        expect(restored.toJson(), json);
      });

      test('${content.id}: every question is answerable', () {
        final config = buildQuizConfigFromContent(
          content,
          currentPage: AppPage.quest,
          progressionKey: entry.key,
          questProgression: true,
        );
        expect(config.questProgression, isTrue);

        // For every (subject, category) the engine can land on, the picked
        // sentence must be non-empty and its accepted answers (whether the
        // category-value default or a per-sentence override) must contain the
        // correct answer. This guards the "duplicate sentence text →
        // unanswerable" class of bug.
        for (var s = 0; s < config.subjects.length; s++) {
          for (final category in config.categories) {
            final answer = category.values[s];
            final sentence = config.pickSentence(
              caseLabel: category.label,
              nominative: config.subjects[s],
              answer: answer,
              random: Random(s * 31 + category.label.length),
            );
            expect(sentence, isNotEmpty,
                reason: '${content.id} ${config.subjects[s]}/${category.label}');

            final override = config.acceptableAnswersForSentence?.call(sentence);
            if (override != null) {
              expect(
                override.contains(answer.toLowerCase()),
                isTrue,
                reason:
                    '${content.id}: "$sentence" must accept "$answer" '
                    '(got $override)',
              );
            }
          }
        }
      });
    }
  });

  group('Quest catalog integrity', () {
    test('keys and storage prefixes are unique', () {
      final keys = questEntries.map((e) => e.key).toList();
      final prefixes =
          questEntries.map((e) => e.config.storageKeyPrefix).toList();
      expect(keys.toSet().length, keys.length, reason: 'duplicate quest keys');
      expect(prefixes.toSet().length, prefixes.length,
          reason: 'duplicate storage prefixes');
    });

    test('storage prefixes are namespaced under quest_', () {
      for (final entry in questEntries) {
        expect(entry.config.storageKeyPrefix, startsWith('quest_'));
      }
    });

    test('chain starts at A1.1 and contains A1.2', () {
      expect(questEntries.first.levelLabel, 'A1.1');
      expect(questEntries.map((e) => e.levelLabel), contains('A1.2'));
    });

    test('drawer display names strip the level prefix', () {
      for (final entry in questEntries) {
        expect(entry.displayName, isNot(contains('·')));
      }
    });

    test('every quest quiz has rich Help Memory content', () {
      for (final entry in questEntries) {
        final c = entry.content;
        expect(c.helpMemoryIntro, isNotNull,
            reason: '${c.id} is missing a Help Memory intro');
        expect(c.helpMemoryIntro, isNotEmpty);
        expect(c.helpMemoryTips, isNotEmpty,
            reason: '${c.id} has no Help Memory tips');
      }
    });
  });

  group('Quest unlock chain logic', () {
    test('nothing completed → only the first quiz is unlocked', () {
      expect(firstLockedQuestIndex(<String>{}), 1);
      expect(resolveQuestEntry(null, <String>{}).key, questEntries.first.key);
    });

    test('completing entries unlocks the next, in order', () {
      final completed = <String>{};
      for (var i = 0; i < questEntries.length - 1; i++) {
        completed.add(questEntries[i].key);
        expect(firstLockedQuestIndex(completed), i + 2);
      }
      // Every entry now unlocked.
      completed.add(questEntries.last.key);
      expect(firstLockedQuestIndex(completed), questEntries.length);
    });

    test('resolveQuestEntry only returns a still-unlocked last key', () {
      // A later, not-yet-unlocked key falls back to the first quiz.
      final lockedKey = questEntries[3].key;
      expect(resolveQuestEntry(lockedKey, <String>{}).key, questEntries.first.key);

      // An unlocked last key is honored.
      final completed = {questEntries[0].key, questEntries[1].key};
      expect(resolveQuestEntry(questEntries[1].key, completed).key,
          questEntries[1].key);
    });

    test('nextQuestEntryName points to the following quiz, null at the end', () {
      expect(
        nextQuestEntryName(questEntries.first.key),
        questEntries[1].displayName,
      );
      expect(nextQuestEntryName(questEntries.last.key), isNull);
    });
  });

  group('answer-style invariants', () {
    test('explicit-answer quizzes expose a per-sentence override', () {
      final config = buildQuizConfigFromContent(
        questEntryByKey('quest_a1_2_uhrzeit')!.content,
        currentPage: AppPage.quest,
      );
      expect(config.acceptableAnswersForSentence, isNotNull);
    });

    test('default-value quizzes have no per-sentence override', () {
      final config = buildQuizConfigFromContent(
        questEntryByKey('quest_a1_1_zahlen')!.content,
        currentPage: AppPage.quest,
      );
      expect(config.acceptableAnswersForSentence, isNull);
    });
  });
}
