import '../models/app_page.dart';
import '../models/nav_layout.dart';
import '../models/quiz_config.dart';
import '../models/quiz_content.dart';
import 'quest/quest_a1_1_content.dart';
import 'quest/quest_a1_2_content.dart';
import 'quest/quest_a2_1_content.dart';
import 'quest/quest_a2_2_content.dart';
import 'quest/quest_b1_1_content.dart';
import 'quest/quest_b1_2_content.dart';
import 'quest/quest_b2_1_content.dart';
import 'quest/quest_b2_2_content.dart';
import 'quest/quest_c1_1_content.dart';
import 'quest/quest_c1_2_content.dart';
import 'quest/quest_c2_1_content.dart';
import 'quest/quest_c2_2_content.dart';
import 'quiz_content_adapter.dart';

/// One quiz in the **Quest** (CEFR A-level) progression — a single ordered,
/// streak-unlocked chain across all sub-levels (A1.1, A1.2, …). This mirrors
/// the noun-category progression (`nounProgressionEntries`) but is a separate
/// chain with its own completion set and unlock goal (`NounSettings`).
class QuestEntry {
  QuestEntry({required this.content})
    : key = content.id,
      levelLabel = content.level ?? '',
      displayName = _shortName(content.title),
      config = buildQuizConfigFromContent(
        content,
        currentPage: AppPage.quest,
        progressionKey: content.id,
        questProgression: true,
      );

  /// CEFR sub-level header this quiz belongs to, e.g. 'A1.1' — taken from
  /// [QuizContent.level], the single source of a quiz's level.
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

/// The compiled Quest chain in its default order: the full Goethe ladder from
/// A1.1 to C2.2. Each sub-level's quizzes run as a contiguous block; a whole
/// sub-level unlocks only once every quiz in the preceding ones is done
/// (`isQuestLevelUnlocked`). Append further levels here.
final List<QuestEntry> _compiledQuestEntries = [
  for (final c in questA1_1Content) QuestEntry(content: c.copyWith(level: 'A1.1')),
  for (final c in questA1_2Content) QuestEntry(content: c.copyWith(level: 'A1.2')),
  for (final c in questA2_1Content) QuestEntry(content: c.copyWith(level: 'A2.1')),
  for (final c in questA2_2Content) QuestEntry(content: c.copyWith(level: 'A2.2')),
  for (final c in questB1_1Content) QuestEntry(content: c.copyWith(level: 'B1.1')),
  for (final c in questB1_2Content) QuestEntry(content: c.copyWith(level: 'B1.2')),
  for (final c in questB2_1Content) QuestEntry(content: c.copyWith(level: 'B2.1')),
  for (final c in questB2_2Content) QuestEntry(content: c.copyWith(level: 'B2.2')),
  for (final c in questC1_1Content) QuestEntry(content: c.copyWith(level: 'C1.1')),
  for (final c in questC1_2Content) QuestEntry(content: c.copyWith(level: 'C1.2')),
  for (final c in questC2_1Content) QuestEntry(content: c.copyWith(level: 'C2.1')),
  for (final c in questC2_2Content) QuestEntry(content: c.copyWith(level: 'C2.2')),
];

/// A teacher-defined order (content ids) for the Quest chain, or null for the
/// default. Applied from the saved navigation layout at startup.
List<String>? _questOrder;

/// Reorders the Quest chain (and therefore the streak-unlock sequence) to
/// [keys]. Entries not listed keep their default order, appended after. An
/// empty list resets to the default.
void applyQuestOrder(List<String> keys) {
  _questOrder = keys.isEmpty ? null : keys;
}

/// Applies the Quest order taken from the `questChain` group of a saved
/// navigation [layout] (resets to default if there is no such group).
void applyQuestOrderFromLayout(NavLayout layout) {
  for (final group in layout.groups) {
    if (group.type == NavGroupType.questChain) {
      applyQuestOrder([for (final item in group.items) item.ref]);
      return;
    }
  }
  applyQuestOrder(const []);
}

/// The Quest chain in its current (possibly teacher-reordered) order.
List<QuestEntry> get questEntries {
  final order = _questOrder;
  if (order == null) return _compiledQuestEntries;
  final byKey = {for (final e in _compiledQuestEntries) e.key: e};
  final ordered = <QuestEntry>[];
  for (final key in order) {
    final entry = byKey.remove(key);
    if (entry != null) ordered.add(entry);
  }
  ordered.addAll(byKey.values); // any not listed (e.g. newly added) go last
  return ordered;
}

/// All Quest quiz content, for seeding the database / back office (default
/// order; the chain order doesn't affect content).
final List<QuizContent> questQuizContent = [
  for (final entry in _compiledQuestEntries) entry.content,
];

QuestEntry? questEntryByKey(String key) {
  for (final entry in questEntries) {
    if (entry.key == key) return entry;
  }
  return null;
}

/// The distinct CEFR sub-levels of the Quest chain, in chain order
/// (e.g. `['A1.1', 'A1.2']`).
List<String> get questLevels {
  final levels = <String>[];
  for (final entry in questEntries) {
    if (!levels.contains(entry.levelLabel)) levels.add(entry.levelLabel);
  }
  return levels;
}

/// The sub-level immediately before [level] in the chain, or null if [level] is
/// the first level (or isn't found).
String? questLevelBefore(String level) {
  final levels = questLevels;
  final index = levels.indexOf(level);
  return index > 0 ? levels[index - 1] : null;
}

/// Whether [level]'s quizzes are unlocked as a whole: true once **every** quiz
/// in all preceding sub-levels has been completed (reached the Quest streak
/// goal). The first level is always unlocked. This gates a whole sub-level
/// (A1.2) behind finishing the previous one (A1.1), on top of the per-quiz
/// streak unlocking *within* a level.
bool isQuestLevelUnlocked(String level, Set<String> completed) {
  for (final entry in questEntries) {
    if (entry.levelLabel == level) break; // reached the level → all priors done
    if (!completed.contains(entry.key)) return false;
  }
  return true;
}

/// Index of the first Quest quiz that isn't unlocked yet, given [completed]
/// (the keys that have reached the Quest streak goal). Entry 0 is always
/// unlocked; entry `i` (i>0) is unlocked iff `questEntries[i-1].key` is in
/// [completed]. Returns `questEntries.length` if every entry is unlocked.
int firstLockedQuestIndex(Set<String> completed) {
  final entries = questEntries;
  for (var i = 1; i < entries.length; i++) {
    if (!completed.contains(entries[i - 1].key)) return i;
  }
  return entries.length;
}

/// Resolves which Quest entry to open for the section's drawer tile / restart:
/// [lastKey]'s entry if it's currently unlocked, otherwise the first quiz.
QuestEntry resolveQuestEntry(String? lastKey, Set<String> completed) {
  final entries = questEntries;
  final unlockedCount = firstLockedQuestIndex(completed);
  if (lastKey != null) {
    final index = entries.indexWhere((e) => e.key == lastKey);
    if (index >= 0 && index < unlockedCount) return entries[index];
  }
  return entries[0];
}

/// Display name of the quiz unlocked by completing [key], or null if [key] is
/// the last quiz in the chain.
String? nextQuestEntryName(String key) {
  final entries = questEntries;
  final index = entries.indexWhere((e) => e.key == key);
  if (index >= 0 && index + 1 < entries.length) {
    return entries[index + 1].displayName;
  }
  return null;
}
