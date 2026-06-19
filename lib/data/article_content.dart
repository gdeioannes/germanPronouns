import '../models/quiz_content.dart';
import 'article_data.dart';
import 'noun_database.dart';

/// The Artikel (der/die/das) quiz expressed as serializable [QuizContent].
///
/// This quiz generates its sentences from templates rather than storing a
/// bank, so the content carries [QuizContent.sentenceTemplates] (per case)
/// instead of a sentence list. The correct article for each (noun, case) is
/// the category value, which the engine uses as the answer. Database-ready
/// twin of `articleQuizConfig`; the live app still runs on the latter.
final QuizContent articleQuizContent = QuizContent(
  id: 'article',
  title: 'German Artikel Quiz',
  storageKeyPrefix: 'article_',
  promptLabel: 'Word',
  subjectsLabel: 'Nouns',
  subjectColumnLabel: 'Noun',
  subjects: [
    for (final n in articleNouns)
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
    for (final c in articleQuizCategories)
      QuizCategoryData(label: c.label, group: c.group, values: c.values),
  ],
  sentences: const [],
  sentenceTemplates: {
    for (final entry in articleSentenceTemplates.entries)
      entry.key: [
        for (final t in entry.value) t.replaceAll('{noun}', '{subject}'),
      ],
  },
  categoryDisplayNames: nounCategoryDisplayNames,
  collapseReferenceTablesByGender: true,
  helpMemoryColorByGender: true,
  helpMemoryIntro:
      'Every German noun has a gender — der (masculine), die (feminine), '
      'das (neuter) — and the article changes with the grammatical case. The '
      'table shows the definite article for each gender in every case.',
  helpMemoryTips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Accusative: only "der" changes',
      text: 'In the accusative, masculine der → den. die, das and the plural '
          'stay the same as the nominative.',
    ),
    HelpMemoryTip(
      kind: 'rule',
      title: 'Dative endings',
      text: 'Dative: dem (m/n), der (f), and den + an extra -n on the plural '
          'noun (die Kinder → den Kindern).',
    ),
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'Color code',
      text: 'Blue = der (m), red = die (f), green = das (n) — the same colors '
          'used across the app.',
    ),
  ],
);
