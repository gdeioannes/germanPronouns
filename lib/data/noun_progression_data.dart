import '../models/app_page.dart';
import '../models/quiz_config.dart';
import '../models/quiz_content.dart';
import 'german_grammar.dart';
import 'noun_article_data.dart';
import 'noun_database.dart';

/// Progression key for the "All Nouns" final-challenge quiz, which draws
/// from every noun in [germanNouns] (see `nounArticleQuizConfig`).
const String kAllNounsProgressionKey = 'all';

/// All ~30 category keys from [nounCategoryDisplayNames], ordered
/// easiest-first by each category's average noun [NounDifficulty]
/// (beginner=0/intermediate=1/advanced=2), ties broken alphabetically.
final List<String> nounCategoryOrder = _computeNounCategoryOrder();

List<String> _computeNounCategoryOrder() {
  const weightByDifficulty = {
    NounDifficulty.beginner: 0,
    NounDifficulty.intermediate: 1,
    NounDifficulty.advanced: 2,
  };
  final difficultySum = <String, int>{};
  final nounCount = <String, int>{};
  for (final noun in germanNouns) {
    for (final category in noun.categories) {
      difficultySum[category] =
          (difficultySum[category] ?? 0) + weightByDifficulty[noun.difficulty]!;
      nounCount[category] = (nounCount[category] ?? 0) + 1;
    }
  }

  final keys = nounCategoryDisplayNames.keys.toList();
  keys.sort((a, b) {
    final avgA = difficultySum[a]! / nounCount[a]!;
    final avgB = difficultySum[b]! / nounCount[b]!;
    if (avgA != avgB) return avgA.compareTo(avgB);
    return a.compareTo(b);
  });
  return keys;
}

/// Builds a [QuizConfig] for the noun-category sub-quiz identified by
/// [categoryKey], drawing only nouns tagged with that category.
QuizConfig nounCategoryQuizConfig(String categoryKey) {
  final subset = germanNouns
      .where((n) => n.categories.contains(categoryKey))
      .toList();

  return QuizConfig(
    title: nounCategoryDisplayNames[categoryKey]!,
    storageKeyPrefix: 'noun_cat_${categoryKey}_',
    promptLabel: 'Word',
    subjectsLabel: 'Nouns',
    subjectColumnLabel: 'Noun',
    subjects: subset.map((n) => n.noun).toList(),
    subjectDisplays: subset.map((n) => n.noun).toList(),
    subjectEnglish: subset.map((n) => n.english).toList(),
    subjectGenders: subset.map((n) => n.gender).toList(),
    categories: [
      QuizCategoryDefinition(
        label: 'Artikel',
        values: subset.map((n) => baseArticles[n.gender]!).toList(),
        group: 'Artikel',
      ),
    ],
    groupWeights: nounArticleGroupChanceWeights,
    pickSentence: pickNounArticleSentence,
    buildExplanation: buildNounArticleExplanation,
    currentPage: AppPage.nounsArticles,
    progressionKey: categoryKey,
  );
}

/// One entry in the noun-category progression: either a single category's
/// sub-quiz, or (last) the full "All Nouns" quiz.
class NounProgressionEntry {
  const NounProgressionEntry({
    required this.key,
    required this.displayName,
    required this.config,
  });

  final String key;
  final String displayName;
  final QuizConfig config;
}

/// The full noun-category progression: one entry per [nounCategoryOrder]
/// category, followed by the "All Nouns" final-challenge entry.
final List<NounProgressionEntry> nounProgressionEntries = [
  for (final key in nounCategoryOrder)
    NounProgressionEntry(
      key: key,
      displayName: nounCategoryDisplayNames[key]!,
      config: nounCategoryQuizConfig(key),
    ),
  NounProgressionEntry(
    key: kAllNounsProgressionKey,
    displayName: 'All Nouns — Final Challenge',
    config: nounArticleQuizConfig,
  ),
];

/// Index of the first entry in [nounProgressionEntries] that isn't unlocked
/// yet, given [completed] (the set of progression keys that have reached the
/// configured streak-unlock goal, `NounSettings.progressionUnlockStreak`).
/// Entry 0 is always unlocked; entry `i` (i>0) is
/// unlocked iff `nounProgressionEntries[i - 1].key` is in [completed].
/// Returns `nounProgressionEntries.length` if every entry is unlocked.
int firstLockedNounProgressionIndex(Set<String> completed) {
  for (var i = 1; i < nounProgressionEntries.length; i++) {
    if (!completed.contains(nounProgressionEntries[i - 1].key)) return i;
  }
  return nounProgressionEntries.length;
}

/// Resolves which entry to open for the main "Nouns & Articles" drawer entry /
/// app restart: [lastKey]'s entry if it's currently unlocked, otherwise the
/// first (easiest) category.
NounProgressionEntry resolveNounProgressionEntry(
  String? lastKey,
  Set<String> completed,
) {
  final unlockedCount = firstLockedNounProgressionIndex(completed);
  if (lastKey != null) {
    final index = nounProgressionEntries.indexWhere((e) => e.key == lastKey);
    if (index >= 0 && index < unlockedCount) {
      return nounProgressionEntries[index];
    }
  }
  return nounProgressionEntries[0];
}

/// Resolves which [QuizConfig] to open for the main "Nouns & Articles" drawer
/// entry / app restart.
QuizConfig resolveNounProgressionConfig(String? lastKey, Set<String> completed) =>
    resolveNounProgressionEntry(lastKey, completed).config;

/// Derives the [QuizContent] for noun-progression entry [key] from the full
/// "All Nouns" content [allNouns] (loaded from the database).
///
/// The full content holds every noun and its sentence; a category quiz is just
/// the subset of subjects (and their parallel article values + sentences)
/// tagged with that category. This means a teacher edits a noun once and the
/// change flows to "All Nouns" and every category quiz containing it.
QuizContent nounProgressionContent(QuizContent allNouns, String key) {
  if (key == kAllNounsProgressionKey) return allNouns;

  final keptKeys = <String>{};
  final subjects = <QuizSubjectData>[];
  for (final subject in allNouns.subjects) {
    if (subject.categories.contains(key)) {
      subjects.add(subject);
      keptKeys.add(subject.key);
    }
  }

  final categories = [
    for (final category in allNouns.categories)
      QuizCategoryData(
        label: category.label,
        group: category.group,
        values: [
          for (var i = 0; i < allNouns.subjects.length; i++)
            if (keptKeys.contains(allNouns.subjects[i].key)) category.values[i],
        ],
      ),
  ];

  return QuizContent(
    id: 'noun_cat_$key',
    title: nounCategoryDisplayNames[key] ?? key,
    storageKeyPrefix: 'noun_cat_${key}_',
    promptLabel: allNouns.promptLabel,
    subjectsLabel: allNouns.subjectsLabel,
    subjectColumnLabel: allNouns.subjectColumnLabel,
    subjects: subjects,
    categories: categories,
    sentences: [
      for (final sentence in allNouns.sentences)
        if (keptKeys.contains(sentence.subjectKey)) sentence,
    ],
    sentenceTemplates: allNouns.sentenceTemplates,
    categoryDisplayNames: allNouns.categoryDisplayNames,
    collapseReferenceTablesByGender: allNouns.collapseReferenceTablesByGender,
    helpMemoryIntro: allNouns.helpMemoryIntro,
    helpMemoryTips: allNouns.helpMemoryTips,
    helpMemoryColorByGender: allNouns.helpMemoryColorByGender,
    helpMemoryInfoColumns: [
      for (final col in allNouns.helpMemoryInfoColumns)
        HelpMemoryInfoColumn(
          label: col.label,
          values: [
            for (var i = 0; i < allNouns.subjects.length; i++)
              if (keptKeys.contains(allNouns.subjects[i].key)) col.values[i],
          ],
        ),
    ],
  );
}
