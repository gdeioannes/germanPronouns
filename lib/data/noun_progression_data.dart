import '../models/quiz_config.dart';
import '../widgets/app_drawer.dart';
import 'noun_article_data.dart';
import 'noun_database.dart';

const Map<String, String> _baseArticles = {'m': 'der', 'f': 'die', 'n': 'das'};

/// Progression key for the "All Nouns" final-challenge quiz, which draws
/// from every noun in [germanNouns] (see `nounArticleQuizConfig`).
const String kAllNounsProgressionKey = 'all';

/// Number of correct answers in a row needed in a noun-category sub-quiz to
/// unlock the next entry in the progression.
const int kProgressionUnlockStreak = 5;

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
        values: subset.map((n) => _baseArticles[n.gender]!).toList(),
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
/// yet, given [completed] (the set of progression keys that have reached a
/// `kProgressionUnlockStreak`-answer streak). Entry 0 is always unlocked;
/// entry `i` (i>0) is
/// unlocked iff `nounProgressionEntries[i - 1].key` is in [completed].
/// Returns `nounProgressionEntries.length` if every entry is unlocked.
int firstLockedNounProgressionIndex(Set<String> completed) {
  for (var i = 1; i < nounProgressionEntries.length; i++) {
    if (!completed.contains(nounProgressionEntries[i - 1].key)) return i;
  }
  return nounProgressionEntries.length;
}

/// Resolves which [QuizConfig] to open for the main "Nouns & Articles"
/// drawer entry / app restart: [lastKey]'s entry if it's currently unlocked,
/// otherwise the first (easiest) category.
QuizConfig resolveNounProgressionConfig(String? lastKey, Set<String> completed) {
  final unlockedCount = firstLockedNounProgressionIndex(completed);
  if (lastKey != null) {
    final index = nounProgressionEntries.indexWhere((e) => e.key == lastKey);
    if (index >= 0 && index < unlockedCount) {
      return nounProgressionEntries[index].config;
    }
  }
  return nounProgressionEntries[0].config;
}
