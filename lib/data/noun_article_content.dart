import '../models/quiz_content.dart';
import 'noun_article_data.dart';
import 'noun_database.dart';
import 'noun_plurals.dart';
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
  helpMemoryColorByGender: true,
  helpMemoryInfoColumns: [
    HelpMemoryInfoColumn(
      label: 'Plural',
      values: [for (final n in germanNouns) pluralEndingDisplay(n.noun)],
    ),
  ],
  helpMemoryIntro:
      'German noun genders are mostly unpredictable from meaning, so always '
      'learn a noun together with its article (der/die/das). The table lists '
      'each noun with its gender — colored so the article sticks.',
  helpMemoryTips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Feminine endings',
      text: 'Most nouns ending in -e are die; -ung, -heit, -keit, -schaft, '
          '-ion and -tät are (almost) always feminine.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Masculine & neuter clues',
      text: 'der: many -er (jobs/tools), -ig, -ling, and most days/months/'
          'seasons. das: -chen and -lein are always neuter (das Mädchen).',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: 'Rules have exceptions',
      text: 'These endings are strong tendencies, not laws. When in doubt, '
          'trust the memorized article over the rule.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Plurals',
      text: 'In the plural the article is always "die", whatever the gender: '
          'der Hund → die Hunde. The Plural column shows each noun\'s plural '
          'ending (e.g. -e, ¨-er); irregular plurals are written in full.',
    ),
  ],
);
