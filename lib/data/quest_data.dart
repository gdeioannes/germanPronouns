import '../models/app_page.dart';
import '../models/nav_layout.dart';
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

/// The compiled Quest chain in its default order: every A1.1 quiz, then every
/// A1.2 quiz. (A2 is a pure follow-up: append more entries here.)
final List<QuestEntry> _compiledQuestEntries = [
  for (final c in questA1_1Content) QuestEntry(levelLabel: 'A1.1', content: c),
  for (final c in questA1_2Content) QuestEntry(levelLabel: 'A1.2', content: c),
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
