import 'dart:convert';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

import 'package:german_pronouns_articles/data/article_content.dart';
import 'package:german_pronouns_articles/data/noun_article_content.dart';
import 'package:german_pronouns_articles/data/noun_article_data.dart';
import 'package:german_pronouns_articles/data/noun_database.dart';
import 'package:german_pronouns_articles/data/noun_progression_data.dart';
import 'package:german_pronouns_articles/data/preposition_content.dart';
import 'package:german_pronouns_articles/data/preposition_data.dart';
import 'package:german_pronouns_articles/data/pronoun_article_content.dart';
import 'package:german_pronouns_articles/data/pronoun_article_sentences.dart';
import 'package:german_pronouns_articles/data/pronoun_content.dart';
import 'package:german_pronouns_articles/data/quiz_content_adapter.dart';
import 'package:german_pronouns_articles/data/quiz_explanation_overrides.dart';
import 'package:german_pronouns_articles/models/app_page.dart';
import 'package:german_pronouns_articles/models/quiz_content.dart';

/// Encodes [json] to a string and back, proving it is genuinely
/// JSON-serializable (no Sets, enums, or other non-encodable values).
Map<String, dynamic> _throughJson(Map<String, dynamic> json) =>
    jsonDecode(jsonEncode(json)) as Map<String, dynamic>;

/// Every quiz as database-ready content, paired with the page it represents.
final Map<QuizContent, AppPage> _allContent = {
  prepositionQuizContent: AppPage.prepositions,
  pronounArticleQuizContent: AppPage.pronounsAndArticles,
  pronounQuizContent: AppPage.pronouns,
  articleQuizContent: AppPage.articles,
  nounArticleQuizContent: AppPage.nounsArticles,
};

void main() {
  group('raw data models round-trip through JSON', () {
    test('GermanNoun', () {
      final noun = germanNouns.first;
      expect(GermanNoun.fromJson(_throughJson(noun.toJson())).toJson(),
          noun.toJson());
    });

    test('PrepositionInfo', () {
      final info = prepositionInfos.first;
      expect(PrepositionInfo.fromJson(_throughJson(info.toJson())).toJson(),
          info.toJson());
    });

    test('PrepositionSentence', () {
      final sentence = prepositionSentenceBank.first;
      expect(
        PrepositionSentence.fromJson(_throughJson(sentence.toJson())).toJson(),
        sentence.toJson(),
      );
    });

    test('PronounArticlePair', () {
      final pair = pronounArticleSentences.first;
      expect(PronounArticlePair.fromJson(_throughJson(pair.toJson())).toJson(),
          pair.toJson());
    });
  });

  group('every quiz is database-ready QuizContent', () {
    for (final entry in _allContent.entries) {
      final content = entry.key;

      test('${content.id}: round-trips through JSON unchanged', () {
        final json = content.toJson();
        final restored = QuizContent.fromJson(_throughJson(json));
        expect(restored.toJson(), json);
      });

      test('${content.id}: builds a runnable config with sentences', () {
        final config = buildQuizConfigFromContent(
          content,
          currentPage: entry.value,
        );
        expect(config.storageKeyPrefix, content.storageKeyPrefix);
        expect(config.subjects.length, content.subjects.length);

        // Every (subject, category) the engine can land on must yield a
        // non-empty sentence — whether stored or generated from a template.
        final picked = config.pickSentence(
          caseLabel: content.categories.first.label,
          nominative: content.subjects.first.key,
          answer: content.categories.first.values.first,
          random: Random(0),
        );
        expect(picked, isNotEmpty);
      });
    }
  });

  group('every quiz has rich Help Memory content', () {
    for (final content in _allContent.keys) {
      test('${content.id}: has an intro and at least one tip', () {
        expect(content.helpMemoryIntro, isNotNull);
        expect(content.helpMemoryIntro, isNotEmpty);
        expect(content.helpMemoryTips, isNotEmpty);
      });

      test('${content.id}: HelpMemoryTip round-trips through JSON', () {
        for (final tip in content.helpMemoryTips) {
          final restored = HelpMemoryTip.fromJson(_throughJson(tip.toJson()));
          expect(restored.toJson(), tip.toJson());
        }
      });
    }
  });

  group('Prepositions content drives the engine like the original', () {
    final config = buildQuizConfigFromContent(
      prepositionQuizContent,
      currentPage: AppPage.prepositions,
    );

    test('answers and hints come from the sentence bank', () {
      final sample = prepositionSentenceBank.first;
      expect(
        config.acceptableAnswersForSentence!(sample.sentence),
        sample.accepted.map((a) => a.toLowerCase()).toSet(),
      );
      expect(config.sentenceHint!(sample.sentence), sample.hint);
    });
  });

  group('generated quizzes use the default category-value answer', () {
    test('Artikel exposes no per-sentence answer override', () {
      final config = buildQuizConfigFromContent(
        articleQuizContent,
        currentPage: AppPage.articles,
      );
      // article/noun answers are the category value, so the bank override is
      // intentionally absent (matching the original configs).
      expect(config.acceptableAnswersForSentence, isNull);
      expect(config.sentenceHint, isNull);
    });
  });

  group('live switch keeps rich behavior', () {
    test('Artikel content carries the gender-collapse flag', () {
      expect(articleQuizContent.collapseReferenceTablesByGender, isTrue);
    });

    test('explanation override reproduces the original rich explanation', () {
      final config = buildQuizConfigFromContent(
        articleQuizContent,
        currentPage: AppPage.articles,
        explanationOverride: explanationOverrides['article'],
      );
      expect(config.collapseReferenceTablesByGender, isTrue);

      final subject = articleQuizContent.subjects.first;
      final explanation = config.buildExplanation(
        caseLabel: 'Nominative',
        nominative: subject.key,
        answer: articleQuizContent.categories.first.values.first,
        sentence: 'Hier ist ____ ${subject.key}.',
      );
      // The generic fallback never emits this section; the original builder does.
      expect(explanation, contains('Base form'));
    });
  });

  group('noun progression derives category quizzes from the DB content', () {
    const key = 'kitchen';

    test('filters to a category and stays internally consistent', () {
      final content = nounProgressionContent(nounArticleQuizContent, key);

      expect(content.storageKeyPrefix, 'noun_cat_kitchen_');
      expect(content.subjects, isNotEmpty);
      expect(content.subjects.every((s) => s.categories.contains(key)), isTrue);
      // The article values stay parallel to the filtered subjects.
      expect(content.categories.first.values.length, content.subjects.length);
      // Sentences only reference kept subjects.
      final keptKeys = content.subjects.map((s) => s.key).toSet();
      expect(
        content.sentences.every((s) => keptKeys.contains(s.subjectKey)),
        isTrue,
      );

      final config = buildQuizConfigFromContent(
        content,
        currentPage: AppPage.nounsArticles,
        explanationOverride: buildNounArticleExplanation,
      );
      expect(config.subjects.length, content.subjects.length);
      expect(config.storageKeyPrefix, 'noun_cat_kitchen_');
    });

    test('the all-nouns key returns the full content unchanged', () {
      final content = nounProgressionContent(
        nounArticleQuizContent,
        kAllNounsProgressionKey,
      );
      expect(content.subjects.length, nounArticleQuizContent.subjects.length);
    });
  });
}
