import '../models/quiz_content.dart';
import 'german_grammar.dart';
import 'noun_article_data.dart';
import 'noun_database.dart';
import 'noun_plurals.dart';
import 'noun_sentences.dart';

/// The compiled German noun list enriched with the two reference fields the
/// noun-article quiz needs beyond the bare list — the plural-form display and
/// the custom example sentence. This is the *populated* noun reference: a
/// plain `List<GermanNoun>` that fully describes the quiz, so it can be built
/// either from here (compiled fallback) or from the shared
/// `nouns/<lang>.json` collection at runtime, via [buildNounArticleContent].
final List<GermanNoun> enrichedGermanNouns = [
  for (final n in germanNouns)
    n.copyWith(
      plural: pluralEndingDisplay(n.noun),
      sentence: nounSentences[n.noun],
    ),
];

/// Builds the Nouns & Articles quiz as serializable [QuizContent] from a list
/// of nouns — the single, data-driven source for both the compiled fallback
/// ([nounArticleQuizContent]) and the shared-collection path.
///
/// Each noun's [GermanNoun.gender] picks its article (the engine's default
/// answer / category value), [GermanNoun.sentence] (if present) becomes a
/// stored [QuizContent.sentences] entry, and [GermanNoun.plural] fills the
/// Help-Memory "Plural" column. Nouns without a sentence fall back to the
/// per-category [QuizContent.sentenceTemplates]. Sentences come out in noun
/// order (the engine looks them up by `subjectKey`, so order is cosmetic).
///
/// The live app renders the noun quizzes from this content, built from the
/// shared `nouns/<lang>.json` collection (via `resolveNounArticleContent`);
/// `nounArticleQuizConfig` is now only the compiled fallback + generator source.
QuizContent buildNounArticleContent(
  List<GermanNoun> nouns,
  Map<String, String> categoryDisplayNames,
) => QuizContent(
  id: 'noun_article',
  title: 'German Nouns & Articles',
  storageKeyPrefix: 'noun_article_',
  promptLabel: 'Word',
  subjectsLabel: 'Nouns',
  subjectColumnLabel: 'Noun',
  subjects: [
    for (final n in nouns)
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
    QuizCategoryData(
      label: 'Artikel',
      group: 'Artikel',
      values: [for (final n in nouns) baseArticles[n.gender]!],
    ),
  ],
  sentences: [
    for (final n in nouns)
      if (n.sentence != null)
        QuizSentenceData(
          subjectKey: n.noun,
          categoryLabel: 'Artikel',
          sentence: n.sentence!,
        ),
  ],
  sentenceTemplates: {
    'Artikel': [
      for (final t in nounArticleSentenceTemplates)
        t.replaceAll('{noun}', '{subject}'),
    ],
  },
  categoryDisplayNames: categoryDisplayNames,
  helpMemoryColorByGender: true,
  helpMemoryInfoColumns: [
    HelpMemoryInfoColumn(
      label: 'Plural',
      values: [for (final n in nouns) n.plural ?? ''],
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

/// The Nouns & Articles quiz expressed as serializable [QuizContent], built
/// from the compiled [enrichedGermanNouns]. Used as the compiled fallback when
/// the shared `nouns/<lang>.json` collection is unavailable, and as the golden
/// twin the shared-collection build is verified against.
final QuizContent nounArticleQuizContent = buildNounArticleContent(
  enrichedGermanNouns,
  nounCategoryDisplayNames,
);
