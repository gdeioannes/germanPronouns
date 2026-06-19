import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/noun_progression_data.dart';
import '../data/quest_data.dart';
import '../data/section_catalog.dart';
import '../models/app_page.dart';
import '../models/noun_settings.dart';
import '../models/quiz_section.dart';
import '../models/quiz_stats_keys.dart';
import '../pages/noun_article_quiz_page.dart';
import '../pages/quest_quiz_page.dart';
import '../pages/settings_page.dart';
import '../pages/word_library_page.dart';
import '../theme/app_theme.dart';
import 'db_quiz_loader.dart';
import 'noun_progression_quiz_loader.dart';
import 'quest_quiz_loader.dart';

// Re-exported so the many files that import this drawer for [AppPage] keep
// working; the enum itself now lives in the model layer (see app_page.dart).
export '../models/app_page.dart';

/// Builds the page widget for [page], used both by the drawer's navigation
/// and to reopen the app on the last-visited page. Quiz sections are resolved
/// from the [quizSections] catalog so adding a section requires no change here.
Widget buildAppPage(AppPage page) {
  final section = sectionForPage(page);
  if (section != null) {
    // Run the quiz from the editable database, falling back to the compiled
    // config if the database is unavailable.
    return DbQuizLoader(
      quizId: section.contentId,
      currentPage: section.page,
      fallback: section.primaryQuiz,
    );
  }
  return switch (page) {
    AppPage.nounsArticles => const NounArticleQuizPage(),
    AppPage.quest => const QuestQuizPage(),
    AppPage.wordLibrary => const WordLibraryPage(),
    AppPage.settings => const SettingsPage(),
    // Every other page is a catalog section, handled above.
    _ => const SettingsPage(),
  };
}

/// Side navigation drawer shared by all quiz pages.
class AppDrawer extends StatefulWidget {
  const AppDrawer({
    super.key,
    required this.currentPage,
    this.currentNounProgressionKey,
    this.currentQuestKey,
  });

  final AppPage currentPage;

  /// When [currentPage] is [AppPage.nounsArticles], the progression key
  /// (from [nounProgressionEntries]) of the currently open noun-category
  /// sub-quiz, used to highlight it in the "Noun Categories" section.
  final String? currentNounProgressionKey;

  /// When [currentPage] is [AppPage.quest], the key (from [questEntries]) of
  /// the currently open Quest quiz, used to highlight it in the "Quest"
  /// section.
  final String? currentQuestKey;

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool _nounCategoriesExpanded = false;
  bool _questExpanded = false;

  void _navigateTo(BuildContext context, AppPage page) {
    Navigator.pop(context);
    NounSettings.instance.setLastPage(page.name);
    if (page == widget.currentPage) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(builder: (_) => buildAppPage(page)),
    );
  }

  Widget _sectionLabel(BuildContext context, String text) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 6),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.1,
        ),
      ),
    );
  }

  Widget _navTile(
    BuildContext context, {
    required IconData icon,
    required Color badgeColor,
    required String title,
    required bool selected,
    required VoidCallback? onTap,
    Widget? subtitle,
    Color? titleColor,
    int? number,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Material(
        color: selected
            ? colorScheme.surfaceContainerHighest
            : Colors.transparent,
        borderRadius: BorderRadius.circular(kRadiusLarge),
        child: InkWell(
          borderRadius: BorderRadius.circular(kRadiusLarge),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Container(
                  width: 3,
                  height: 28,
                  decoration: BoxDecoration(
                    color: selected ? colorScheme.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                if (number != null) ...[
                  SizedBox(
                    width: 20,
                    child: Text(
                      '$number',
                      textAlign: TextAlign.center,
                      style: textTheme.labelMedium?.copyWith(
                        color: titleColor ?? colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                IconBadge(icon: icon, color: badgeColor, size: 36),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: textTheme.bodyLarge?.copyWith(
                          fontWeight: selected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: titleColor ?? colorScheme.onSurface,
                        ),
                      ),
                      ?subtitle,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _statsSubtitle(
    BuildContext context, {
    required int score,
    required int bestStreakAbsolute,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final statStyle = Theme.of(context).textTheme.labelSmall?.copyWith(
      color: colorScheme.onSurfaceVariant,
    );
    final streaks = bestStreakAbsolute ~/ NounSettings.streakLapSize;

    return Padding(
      padding: const EdgeInsets.only(top: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star_rounded,
            size: 13,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 3),
          Text('$score', style: statStyle),
          const SizedBox(width: 12),
          Icon(
            Icons.bolt_rounded,
            size: 13,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 3),
          Text('×$streaks', style: statStyle),
        ],
      ),
    );
  }

  Widget _quizTile(
    BuildContext context, {
    required QuizSection section,
    required SharedPreferences? prefs,
  }) {
    final keys = section.statsKeys;
    final score = prefs?.getInt(keys.score) ?? 0;
    final bestStreakAbsolute = prefs?.getInt(keys.bestStreakAbsolute) ?? 0;

    return _navTile(
      context,
      icon: section.icon,
      badgeColor: section.accent,
      title: section.title,
      selected: widget.currentPage == section.page,
      onTap: () => _navigateTo(context, section.page),
      subtitle: prefs == null
          ? null
          : _statsSubtitle(
              context,
              score: score,
              bestStreakAbsolute: bestStreakAbsolute,
            ),
    );
  }

  void _navigateToNounProgression(BuildContext context, String key) {
    Navigator.pop(context);
    NounSettings.instance.setLastPage(AppPage.nounsArticles.name);
    NounSettings.instance.setLastNounProgressionKey(key);
    if (widget.currentPage == AppPage.nounsArticles &&
        key == widget.currentNounProgressionKey) {
      return;
    }

    final entry = nounProgressionEntries.firstWhere((e) => e.key == key);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(
        builder: (_) => NounProgressionQuizLoader(entry: entry),
      ),
    );
  }

  Widget _nounProgressionTile(
    BuildContext context, {
    required NounProgressionEntry entry,
    required SharedPreferences? prefs,
    int? number,
  }) {
    final isFinal = entry.key == kAllNounsProgressionKey;
    final keys = QuizStatsKeys(entry.config.storageKeyPrefix);
    final score = prefs?.getInt(keys.score) ?? 0;
    final bestStreakAbsolute = prefs?.getInt(keys.bestStreakAbsolute) ?? 0;

    return _navTile(
      context,
      icon: isFinal ? Icons.workspace_premium_rounded : Icons.abc_rounded,
      badgeColor: isFinal
          ? kSectionAccentColors[3]
          : kSectionAccentColors[2],
      title: entry.displayName,
      selected:
          widget.currentPage == AppPage.nounsArticles &&
          entry.key == widget.currentNounProgressionKey,
      onTap: () => _navigateToNounProgression(context, entry.key),
      subtitle: prefs == null
          ? null
          : _statsSubtitle(
              context,
              score: score,
              bestStreakAbsolute: bestStreakAbsolute,
            ),
      number: number,
    );
  }

  Widget _lockedNounProgressionTile(
    BuildContext context, {
    required NounProgressionEntry entry,
    required NounProgressionEntry previousEntry,
    required SharedPreferences? prefs,
    int? number,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final previousKeys = QuizStatsKeys(previousEntry.config.storageKeyPrefix);
    final bestStreakAbsolute =
        prefs?.getInt(previousKeys.bestStreakAbsolute) ?? 0;
    final bestStreaks = bestStreakAbsolute ~/ NounSettings.streakLapSize;
    final unlockLaps = NounSettings.instance.progressionUnlockLaps;
    final unlockStreak = NounSettings.instance.progressionUnlockStreak;

    return _navTile(
      context,
      icon: Icons.lock_rounded,
      badgeColor: colorScheme.onSurfaceVariant,
      title: entry.displayName,
      selected: false,
      onTap: null,
      titleColor: colorScheme.onSurfaceVariant,
      number: number,
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Text(
          "Reach $unlockLaps streaks in a row "
          "($unlockStreak correct answers) in "
          "'${previousEntry.displayName}' to unlock "
          '(best: ×$bestStreaks/×$unlockLaps)',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  /// The progression entry to show when the "Noun Categories" section is
  /// collapsed: the currently-open sub-quiz if there is one, else the most
  /// recently unlocked category.
  NounProgressionEntry _currentNounProgressionEntry(Set<String> completed) {
    final unlockedCount = firstLockedNounProgressionIndex(completed);
    final key = widget.currentNounProgressionKey;
    if (key != null) {
      final index = nounProgressionEntries.indexWhere((e) => e.key == key);
      if (index >= 0 && index < unlockedCount) {
        return nounProgressionEntries[index];
      }
    }
    return nounProgressionEntries[unlockedCount - 1];
  }

  Widget _nounCategoriesToggleTile(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(kRadiusLarge),
        child: InkWell(
          borderRadius: BorderRadius.circular(kRadiusLarge),
          onTap: () =>
              setState(() => _nounCategoriesExpanded = !_nounCategoriesExpanded),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                const SizedBox(width: 15),
                Icon(
                  _nounCategoriesExpanded
                      ? Icons.expand_less_rounded
                      : Icons.expand_more_rounded,
                  size: 20,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Text(
                  _nounCategoriesExpanded
                      ? 'Show less'
                      : 'Show all categories',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildNounProgressionTiles(
    BuildContext context,
    SharedPreferences? prefs,
  ) {
    final completed = NounSettings.instance.completedNounCategories;
    final unlockedCount = firstLockedNounProgressionIndex(completed);

    final tiles = <Widget>[
      _nounProgressionTile(
        context,
        entry: _currentNounProgressionEntry(completed),
        prefs: prefs,
      ),
      _nounCategoriesToggleTile(context),
    ];

    if (_nounCategoriesExpanded) {
      final categoryTiles = <Widget>[
        for (var i = 0; i < unlockedCount; i++)
          _nounProgressionTile(
            context,
            entry: nounProgressionEntries[i],
            prefs: prefs,
            number: i + 1,
          ),
        if (unlockedCount < nounProgressionEntries.length)
          _lockedNounProgressionTile(
            context,
            entry: nounProgressionEntries[unlockedCount],
            previousEntry: nounProgressionEntries[unlockedCount - 1],
            prefs: prefs,
            number: unlockedCount + 1,
          ),
      ];

      tiles.add(
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 280),
          child: Scrollbar(
            child: ListView(shrinkWrap: true, children: categoryTiles),
          ),
        ),
      );
    }

    return tiles;
  }

  // ── Quest (CEFR A-level) section ──────────────────────────────────────────

  void _navigateToQuest(BuildContext context, String key) {
    Navigator.pop(context);
    // Tracked for in-section highlight/resume; the app's cross-session
    // last-page resume deliberately does not include Quest.
    NounSettings.instance.setLastQuestQuizKey(key);
    if (widget.currentPage == AppPage.quest && key == widget.currentQuestKey) {
      return;
    }
    final entry = questEntries.firstWhere((e) => e.key == key);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(builder: (_) => QuestQuizLoader(entry: entry)),
    );
  }

  Widget _questTile(
    BuildContext context, {
    required QuestEntry entry,
    required SharedPreferences? prefs,
    int? number,
  }) {
    final keys = QuizStatsKeys(entry.config.storageKeyPrefix);
    final score = prefs?.getInt(keys.score) ?? 0;
    final bestStreakAbsolute = prefs?.getInt(keys.bestStreakAbsolute) ?? 0;

    return _navTile(
      context,
      icon: Icons.flag_rounded,
      badgeColor: kSectionAccentColors[0],
      title: entry.displayName,
      selected:
          widget.currentPage == AppPage.quest &&
          entry.key == widget.currentQuestKey,
      onTap: () => _navigateToQuest(context, entry.key),
      subtitle: prefs == null
          ? null
          : _statsSubtitle(
              context,
              score: score,
              bestStreakAbsolute: bestStreakAbsolute,
            ),
      number: number,
    );
  }

  Widget _lockedQuestTile(
    BuildContext context, {
    required QuestEntry entry,
    required QuestEntry previousEntry,
    required SharedPreferences? prefs,
    int? number,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final previousKeys = QuizStatsKeys(previousEntry.config.storageKeyPrefix);
    final bestStreakAbsolute =
        prefs?.getInt(previousKeys.bestStreakAbsolute) ?? 0;
    final bestStreaks = bestStreakAbsolute ~/ NounSettings.streakLapSize;
    final unlockLaps = NounSettings.instance.questUnlockLaps;
    final unlockStreak = NounSettings.instance.questUnlockStreak;

    return _navTile(
      context,
      icon: Icons.lock_rounded,
      badgeColor: colorScheme.onSurfaceVariant,
      title: entry.displayName,
      selected: false,
      onTap: null,
      titleColor: colorScheme.onSurfaceVariant,
      number: number,
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Text(
          "Reach $unlockLaps streaks in a row "
          "($unlockStreak correct answers) in "
          "'${previousEntry.displayName}' to unlock "
          '(best: ×$bestStreaks/×$unlockLaps)',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  /// A compact, dimmed tile for a locked Quest quiz beyond the immediate next
  /// one — shown so the learner can see upcoming goals without the full
  /// unlock-hint text.
  Widget _lockedQuestPreviewTile(
    BuildContext context, {
    required QuestEntry entry,
    int? number,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return _navTile(
      context,
      icon: Icons.lock_outline_rounded,
      badgeColor: colorScheme.onSurfaceVariant,
      title: entry.displayName,
      selected: false,
      onTap: null,
      titleColor: colorScheme.onSurfaceVariant,
      number: number,
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Text(
          'Locked — keep going to reach this',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  /// The Quest entry to show when the section is collapsed: the currently-open
  /// quiz if there is one, else the most recently unlocked quiz.
  QuestEntry _currentQuestEntry(Set<String> completed) {
    final unlockedCount = firstLockedQuestIndex(completed);
    final key = widget.currentQuestKey;
    if (key != null) {
      final index = questEntries.indexWhere((e) => e.key == key);
      if (index >= 0 && index < unlockedCount) return questEntries[index];
    }
    return questEntries[unlockedCount - 1];
  }

  Widget _questToggleTile(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(kRadiusLarge),
        child: InkWell(
          borderRadius: BorderRadius.circular(kRadiusLarge),
          onTap: () => setState(() => _questExpanded = !_questExpanded),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                const SizedBox(width: 15),
                Icon(
                  _questExpanded
                      ? Icons.expand_less_rounded
                      : Icons.expand_more_rounded,
                  size: 20,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 8),
                Text(
                  _questExpanded ? 'Show less' : 'Show all A1 quizzes',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _questLevelSubheader(BuildContext context, String level) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 10, 24, 2),
      child: Text(
        level,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  List<Widget> _buildQuestTiles(BuildContext context, SharedPreferences? prefs) {
    final completed = NounSettings.instance.completedQuestQuizzes;
    final unlockedCount = firstLockedQuestIndex(completed);

    final tiles = <Widget>[
      _questTile(context, entry: _currentQuestEntry(completed), prefs: prefs),
      _questToggleTile(context),
    ];

    if (_questExpanded) {
      // Show a scrollable window of up to [maxVisible] quizzes that always
      // includes the frontier (the next locked quiz). Locked quizzes stay
      // visible — dimmed, with a lock — so the learner sees the goals ahead.
      const maxVisible = 10;
      final total = questEntries.length;
      final end = min(total, max(unlockedCount + 1, maxVisible));
      final start = max(0, end - maxVisible);

      final levelTiles = <Widget>[];
      String? lastLevel;
      for (var i = start; i < end; i++) {
        final entry = questEntries[i];
        if (entry.levelLabel != lastLevel) {
          levelTiles.add(_questLevelSubheader(context, entry.levelLabel));
          lastLevel = entry.levelLabel;
        }
        if (i < unlockedCount) {
          levelTiles.add(
            _questTile(context, entry: entry, prefs: prefs, number: i + 1),
          );
        } else if (i == unlockedCount) {
          // The immediate next goal — show the full unlock hint.
          levelTiles.add(
            _lockedQuestTile(
              context,
              entry: entry,
              previousEntry: questEntries[i - 1],
              prefs: prefs,
              number: i + 1,
            ),
          );
        } else {
          // Further goals — a compact locked preview.
          levelTiles.add(
            _lockedQuestPreviewTile(context, entry: entry, number: i + 1),
          );
        }
      }

      tiles.add(
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 360),
          child: Scrollbar(
            child: ListView(shrinkWrap: true, children: levelTiles),
          ),
        ),
      );
    }

    return tiles;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Drawer(
      backgroundColor: colorScheme.surfaceContainerLow,
      child: SafeArea(
        child: FutureBuilder<SharedPreferences>(
          future: SharedPreferences.getInstance(),
          builder: (context, snapshot) {
            final prefs = snapshot.data;

            return ListView(
              padding: const EdgeInsets.only(bottom: 8),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/QuizLogo-02.svg',
                        width: 44,
                        height: 44,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'German Grammar',
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'der · die · das',
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, color: colorScheme.outlineVariant),
                _sectionLabel(context, 'QUEST · A1'),
                ..._buildQuestTiles(context, prefs),
                Divider(height: 1, color: colorScheme.outlineVariant),
                _sectionLabel(context, 'NOUN CATEGORIES'),
                ..._buildNounProgressionTiles(context, prefs),
                Divider(height: 1, color: colorScheme.outlineVariant),
                _sectionLabel(context, 'QUIZZES'),
                for (final section in quizSections)
                  _quizTile(context, section: section, prefs: prefs),
                Divider(height: 1, color: colorScheme.outlineVariant),
                _sectionLabel(context, 'MORE'),
                _navTile(
                  context,
                  icon: Icons.library_books_rounded,
                  badgeColor: colorScheme.onSurfaceVariant,
                  title: 'Word Library',
                  selected: widget.currentPage == AppPage.wordLibrary,
                  onTap: () => _navigateTo(context, AppPage.wordLibrary),
                ),
                _navTile(
                  context,
                  icon: Icons.settings_rounded,
                  badgeColor: colorScheme.onSurfaceVariant,
                  title: 'Settings',
                  selected: widget.currentPage == AppPage.settings,
                  onTap: () => _navigateTo(context, AppPage.settings),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
