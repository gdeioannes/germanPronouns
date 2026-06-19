import '../models/app_page.dart';
import '../models/quiz_config.dart';
import '../models/quiz_content.dart';
import 'quest/quest_a1_1_content.dart';
import 'quest/quest_a1_2_content.dart';
import 'quiz_content_adapter.dart';

/// One quiz in the **Quest** (CEFR A-level) progression — a single ordered,
/// streak-unlocked chain across all sub-levels (A1.1, A1.2, …). This mirrors
/// the noun-category progression (`nounProgressionEntries`) but is a separate
/// chain with its own completion set and unlock goal (`NounSettings`).
class QuestEntry {
  QuestEntry({required this.levelLabel, required this.content})
    : key = content.id,
      displayName = _shortName(content.title),
      config = buildQuizConfigFromContent(
        content,
        currentPage: AppPage.quest,
        progressionKey: content.id,
        questProgression: true,
      );

  /// CEFR sub-level header this quiz belongs to, e.g. 'A1.1'.
  final String levelLabel;

  /// The serializable content this quiz runs from (the DB fallback source).
  final QuizContent content;

  /// Stable key for this quiz in the chain (the content id). Used as the
  /// quiz's `progressionKey` and tracked in `completedQuestQuizzes`.
  final String key;

  /// Short drawer label, with the redundant "A1.1 · " level prefix stripped.
  final String displayName;

  /// Compiled fallback config (the live quiz loads editable content from the
  /// database and falls back to this — see `QuestQuizLoader`).
  final QuizConfig config;
}

String _shortName(String title) =>
    title.contains('· ') ? title.split('· ').last.trim() : title;

/// The full Quest chain, in order: every A1.1 quiz, then every A1.2 quiz.
/// (A2 is a pure follow-up: append more entries here, no other changes.)
final List<QuestEntry> questEntries = [
  for (final c in questA1_1Content) QuestEntry(levelLabel: 'A1.1', content: c),
  for (final c in questA1_2Content) QuestEntry(levelLabel: 'A1.2', content: c),
];

/// All Quest quiz content, for seeding the database / back office.
final List<QuizContent> questQuizContent = [
  for (final entry in questEntries) entry.content,
];

QuestEntry? questEntryByKey(String key) {
  for (final entry in questEntries) {
    if (entry.key == key) return entry;
  }
  return null;
}

/// Index of the first Quest quiz that isn't unlocked yet, given [completed]
/// (the keys that have reached the Quest streak goal). Entry 0 is always
/// unlocked; entry `i` (i>0) is unlocked iff `questEntries[i-1].key` is in
/// [completed]. Returns `questEntries.length` if every entry is unlocked.
int firstLockedQuestIndex(Set<String> completed) {
  for (var i = 1; i < questEntries.length; i++) {
    if (!completed.contains(questEntries[i - 1].key)) return i;
  }
  return questEntries.length;
}

/// Resolves which Quest entry to open for the section's drawer tile / restart:
/// [lastKey]'s entry if it's currently unlocked, otherwise the first quiz.
QuestEntry resolveQuestEntry(String? lastKey, Set<String> completed) {
  final unlockedCount = firstLockedQuestIndex(completed);
  if (lastKey != null) {
    final index = questEntries.indexWhere((e) => e.key == lastKey);
    if (index >= 0 && index < unlockedCount) return questEntries[index];
  }
  return questEntries[0];
}

/// Display name of the quiz unlocked by completing [key], or null if [key] is
/// the last quiz in the chain.
String? nextQuestEntryName(String key) {
  final index = questEntries.indexWhere((e) => e.key == key);
  if (index >= 0 && index + 1 < questEntries.length) {
    return questEntries[index + 1].displayName;
  }
  return null;
}
