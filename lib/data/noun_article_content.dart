import '../models/quiz_content.dart';
import 'noun_article_data.dart';
import 'noun_database.dart';
import 'noun_sentences.dart';

/// The Nouns & Articles quiz expressed as serializable [QuizContent].
///
/// Mixed source: nouns with a hand-written sentence in [nounSentences] become
/// stored [QuizContent.sentences]; the rest fall back to the per-category
/// [QuizContent.sentenceTemplates]. The correct article for each noun is the
/// category value (the engine's default answer). Database-ready twin of
/// `nounArticleQuizConfig`; the live app still runs on the latter.
final QuizContent nounArticleQuizContent = QuizContent(
  id: 'noun_article',
  title: 'German Nouns & Articles',
  storageKeyPrefix: 'noun_article_',
  promptLabel: 'Word',
  subjectsLabel: 'Nouns',
  subjectColumnLabel: 'Noun',
  subjects: [
    for (final n in germanNouns)
      QuizSubjectData(
        key: n.noun,
        display: n.noun,
        english: n.english,
        gender: n.gender,
        difficulty: n.difficulty.name,
        categories: n.categories,
      ),
  ],
  categories: [
    for (final c in nounArticleQuizCategories)
      QuizCategoryData(label: c.label, group: c.group, values: c.values),
  ],
  sentences: [
    for (final entry in nounSentences.entries)
      QuizSentenceData(
        subjectKey: entry.key,
        categoryLabel: 'Artikel',
        sentence: entry.value,
      ),
  ],
  sentenceTemplates: {
    'Artikel': [
      for (final t in nounArticleSentenceTemplates)
        t.replaceAll('{noun}', '{subject}'),
    ],
  },
  categoryDisplayNames: nounCategoryDisplayNames,
);
