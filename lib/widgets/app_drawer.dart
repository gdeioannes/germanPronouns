import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/db/content_repository.dart';
import '../data/nav_layout_data.dart';
import '../data/noun_progression_data.dart';
import '../data/quest_data.dart';
import '../data/section_catalog.dart';
import '../models/app_page.dart';
import '../models/course.dart';
import '../models/course_session.dart';
import '../models/nav_layout.dart';
import '../models/noun_settings.dart';
import '../models/quiz_content.dart';
import '../models/quiz_stats_keys.dart';
import '../pages/noun_article_quiz_page.dart';
import '../pages/quest_quiz_page.dart';
import '../pages/settings_page.dart';
import '../pages/word_library_page.dart';
import '../theme/app_theme.dart';
import 'completion_ribbon.dart';
import 'db_quiz_loader.dart';

// Re-exported so the many files that import this drawer for [AppPage] keep
// working; the enum itself now lives in the model layer (see app_page.dart).
export '../models/app_page.dart';

/// Lock state of a quiz tile inside a [NavGroup.gated] (pass-to-unlock) chain:
/// [unlocked] is open (it's done, or it's the one in progress); [next] is the
/// immediate goal still to unlock; [locked] is a further quiz down the chain.
enum _QuizLock { unlocked, next, locked }

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

/// Builds the learner page for a data-driven nav item that opens the quiz
/// stored under [contentId] (from the editable navigation layout).
Widget buildQuizPageForContent(String contentId) {
  final section = sectionForContentId(contentId);
  return DbQuizLoader(
    // Keyed by the quiz id: `/quiz/article` and `/quiz/pronoun` match the same
    // route template, so go_router gives them the same page key and would reuse
    // the loader's State (and its already-resolved quiz) on switch. The id key
    // forces a fresh State — and a fresh load — for each quiz.
    key: ValueKey('quiz-$contentId'),
    quizId: contentId,
    currentPage: section?.page ?? AppPage.articles,
    fallback: section?.primaryQuiz,
  );
}

/// Everything the drawer needs, loaded once: prefs (for scores), the editable
/// navigation [layout], and a quiz id → summary map (for default titles/keys).
class _DrawerData {
  const _DrawerData(this.prefs, this.layout, this.quizzes);

  final SharedPreferences? prefs;
  final NavLayout layout;
  final Map<String, QuizSummary> quizzes;
}

Future<_DrawerData> _loadDrawerData() async {
  final prefs = await SharedPreferences.getInstance();
  var layout = defaultNavLayout;
  final quizzes = <String, QuizSummary>{};
  await CourseSession.instance.loadCourses();
  layout = CourseSession.instance.activeCourse.nav;
  applyQuestOrderFromLayout(layout);
  try {
    final repo = await contentRepository();
    for (final q in await repo.listQuizzes()) {
      quizzes[q.id] = q;
    }
  } catch (_) {
    // Fall back to the (already-set) layout if the database is unavailable.
  }
  return _DrawerData(prefs, layout, quizzes);
}

/// Side navigation drawer shared by all quiz pages.
class AppDrawer extends StatefulWidget {
  const AppDrawer({
    super.key,
    required this.currentPage,
    this.currentNounProgressionKey,
    this.currentQuestKey,
    this.currentContentId,
  });

  final AppPage currentPage;

  /// `QuizContent.id` of the currently open data-driven nav quiz, used to
  /// highlight its item in the drawer.
  final String? currentContentId;

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
  late final Future<_DrawerData> _drawerDataFuture = _loadDrawerData();

  void _navigateTo(BuildContext context, AppPage page) {
    Navigator.pop(context);
    NounSettings.instance.setLastPage(page.name);
    if (page == widget.currentPage) return;
    context.go(_pathForAppPage(page));
  }

  /// Route for a built-in link page. Only the Word Library and Settings reach
  /// here (the other [AppPage]s are quizzes, navigated by ref/key); anything
  /// else falls back to the course home.
  String _pathForAppPage(AppPage page) => switch (page) {
    AppPage.wordLibrary => '/library',
    AppPage.settings => '/settings',
    _ => '/home',
  };

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
    bool done = false,
    int doneLaps = 0,
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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: Row(
              children: [
                Container(
                  width: 3,
                  height: 24,
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
                IconBadge(icon: icon, color: badgeColor, size: 30),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: textTheme.bodyMedium?.copyWith(
                          height: 1.2,
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
                if (done) ...[
                  const SizedBox(width: 10),
                  BookmarkRibbon(color: tierColorForLaps(doneLaps), width: 18),
                ],
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
      padding: const EdgeInsets.only(top: 1),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star_rounded,
            size: 12,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 3),
          Text('$score', style: statStyle),
          const SizedBox(width: 12),
          Icon(
            Icons.bolt_rounded,
            size: 12,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(width: 3),
          Text('×$streaks', style: statStyle),
        ],
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
    context.go('/noun/$key');
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
      done: NounSettings.instance.isNounCategoryCompleted(entry.key),
      doneLaps: bestStreakAbsolute ~/ NounSettings.streakLapSize,
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
    context.go('/quest/$key');
  }

  Widget _questTile(
    BuildContext context, {
    required QuestEntry entry,
    required SharedPreferences? prefs,
    int? number,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final keys = QuizStatsKeys(entry.config.storageKeyPrefix);
    final score = prefs?.getInt(keys.score) ?? 0;
    final bestStreakAbsolute = prefs?.getInt(keys.bestStreakAbsolute) ?? 0;
    final kind = entry.content.kind;

    // Speaking/reading quizzes have no streak — they show a kind label instead
    // of the score/streak line and their own icon.
    final (IconData icon, String? kindLabel) = switch (kind) {
      QuizKind.speakRepeat => (quizKindIcon(QuizKind.speakRepeat), 'Listen & repeat'),
      QuizKind.reading => (quizKindIcon(QuizKind.reading), 'Read & answer'),
      // Knowledge quizzes in the quest chain keep the quest flag (a milestone
      // marker) rather than the generic question icon.
      QuizKind.fillBlank => (Icons.flag_rounded, null),
    };

    Widget? subtitle;
    if (kindLabel != null) {
      subtitle = Padding(
        padding: const EdgeInsets.only(top: 1),
        child: Text(
          kindLabel,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      );
    } else if (prefs != null) {
      subtitle = _statsSubtitle(
        context,
        score: score,
        bestStreakAbsolute: bestStreakAbsolute,
      );
    }

    return _navTile(
      context,
      icon: icon,
      badgeColor: quizKindColor(kind),
      title: entry.displayName,
      selected:
          widget.currentPage == AppPage.quest &&
          entry.key == widget.currentQuestKey,
      onTap: () => _navigateToQuest(context, entry.key),
      done: NounSettings.instance.isQuestQuizCompleted(entry.key),
      doneLaps: bestStreakAbsolute ~/ NounSettings.streakLapSize,
      subtitle: subtitle,
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

  List<Widget> _buildQuestTiles(
    BuildContext context,
    SharedPreferences? prefs, {
    String? level,
  }) {
    final completed = NounSettings.instance.completedQuestQuizzes;
    final unlockedCount = firstLockedQuestIndex(completed);

    // A level-scoped group (e.g. 'A1.1') lists just that level's quizzes with
    // their current lock state — the unlock frontier stays global, so A1.2 only
    // opens up once A1.1 is finished.
    if (level != null) {
      return _buildQuestLevelTiles(context, prefs, level, unlockedCount);
    }

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

  /// Tiles for a single CEFR sub-[level] of the Quest chain (e.g. 'A1.1'): every
  /// quiz of that level, each shown unlocked / next-to-unlock / further-locked
  /// according to the global [unlockedCount] frontier.
  List<Widget> _buildQuestLevelTiles(
    BuildContext context,
    SharedPreferences? prefs,
    String level,
    int unlockedCount,
  ) {
    // The whole sub-level is gated behind finishing the previous one — show a
    // single locked tile until then.
    final completed = NounSettings.instance.completedQuestQuizzes;
    if (!isQuestLevelUnlocked(level, completed)) {
      return [
        _lockedQuestLevelTile(
          context,
          level: level,
          priorLevel: questLevelBefore(level),
        ),
      ];
    }

    final entries = questEntries;
    final tiles = <Widget>[];
    for (var i = 0; i < entries.length; i++) {
      final entry = entries[i];
      if (entry.levelLabel != level) continue;
      if (i < unlockedCount) {
        tiles.add(_questTile(context, entry: entry, prefs: prefs, number: i + 1));
      } else if (i == unlockedCount) {
        tiles.add(
          _lockedQuestTile(
            context,
            entry: entry,
            previousEntry: entries[i - 1],
            prefs: prefs,
            number: i + 1,
          ),
        );
      } else {
        tiles.add(_lockedQuestPreviewTile(context, entry: entry, number: i + 1));
      }
    }
    // A long level (e.g. A1.1 has 9 quizzes) is capped to a scrollable window so
    // it doesn't push the rest of the drawer (and the next level) off-screen.
    if (tiles.length > 4) {
      return [
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 320),
          child: Scrollbar(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              children: tiles,
            ),
          ),
        ),
      ];
    }
    return tiles;
  }

  /// A single locked tile standing in for a whole gated sub-level (e.g. A1.2),
  /// shown until [priorLevel] is finished.
  Widget _lockedQuestLevelTile(
    BuildContext context, {
    required String level,
    String? priorLevel,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return _navTile(
      context,
      icon: Icons.lock_rounded,
      badgeColor: colorScheme.onSurfaceVariant,
      title: level,
      selected: false,
      onTap: null,
      titleColor: colorScheme.onSurfaceVariant,
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Text(
          priorLevel == null ? 'Locked' : 'Complete $priorLevel to unlock',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  void _navigateToContent(BuildContext context, String contentId) {
    Navigator.pop(context);
    NounSettings.instance.setLastContentId(contentId);
    if (widget.currentContentId == contentId) return;
    context.go('/quiz/$contentId');
  }

  /// Whether the quiz behind a nav [item] counts as finished — the same rule the
  /// tile's "done" ribbon uses: listen-&-repeat once played through, reading
  /// once passed, every other quiz once its best streak reaches the goal. Used
  /// to advance the pass-to-unlock frontier of a [NavGroup.gated] chain.
  bool _isQuizItemDone(NavItem item, _DrawerData data) {
    final summary = data.quizzes[item.ref];
    switch (summary?.kind) {
      case QuizKind.speakRepeat:
        return NounSettings.instance.isSpeakQuizCompleted(item.ref);
      case QuizKind.reading:
        return NounSettings.instance.isReadingQuizCompleted(item.ref);
      case QuizKind.fillBlank:
      case null:
        final prefix =
            summary?.storageKeyPrefix ??
            sectionForContentId(item.ref)?.primaryQuiz.storageKeyPrefix ??
            '${item.ref}_';
        final best =
            data.prefs?.getInt(QuizStatsKeys(prefix).bestStreakAbsolute) ?? 0;
        return NounSettings.instance.isQuizDone(bestStreakAbsolute: best);
    }
  }

  /// Resolves the lock state of every quiz in the course's gated chain. The
  /// frontier runs continuously through *all* [NavGroup.gated] quizzes groups in
  /// layout order (so an A1–B2 certification unlocks one quiz at a time straight
  /// across its levels): walking in order, each quiz is [_QuizLock.unlocked]
  /// until the first one that isn't finished yet (still open — it's the one in
  /// progress); the quiz right after it is [_QuizLock.next] and the rest are
  /// [_QuizLock.locked]. Refs of ungated groups are absent (always open).
  Map<String, _QuizLock> _computeQuizLocks(NavLayout layout, _DrawerData data) {
    final locks = <String, _QuizLock>{};
    var sawIncomplete = false;
    var markedNext = false;
    for (final group in layout.groups) {
      if (group.type != NavGroupType.quizzes || !group.gated) continue;
      for (final item in group.items) {
        if (item.hidden) continue;
        if (!sawIncomplete) {
          locks[item.ref] = _QuizLock.unlocked;
          if (!_isQuizItemDone(item, data)) sawIncomplete = true;
        } else if (!markedNext) {
          locks[item.ref] = _QuizLock.next;
          markedNext = true;
        } else {
          locks[item.ref] = _QuizLock.locked;
        }
      }
    }
    return locks;
  }

  /// A non-tappable tile for a quiz still locked in a gated chain: a lock badge
  /// and the "finish the previous quiz" hint.
  Widget _lockedQuizItemTile(
    BuildContext context, {
    required String title,
    required bool isNext,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return _navTile(
      context,
      icon: isNext ? Icons.lock_rounded : Icons.lock_outline_rounded,
      badgeColor: colorScheme.onSurfaceVariant,
      title: title,
      selected: false,
      onTap: null,
      titleColor: colorScheme.onSurfaceVariant,
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Text(
          CourseSession.instance.strings.lockedHint,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  /// A drawer tile for a data-driven quiz item (resolved title/icon/color, with
  /// the quiz's score/streak), highlighted when it's the open quiz. When [lock]
  /// is [_QuizLock.next] or [_QuizLock.locked] (a gated chain) it renders the
  /// locked variant instead.
  Widget _quizItemTile(
    BuildContext context, {
    required NavItem item,
    required _DrawerData data,
    _QuizLock? lock,
  }) {
    final section = sectionForContentId(item.ref);
    final summary = data.quizzes[item.ref];
    final title =
        item.titleOverride ?? summary?.title ?? section?.title ?? item.ref;

    if (lock == _QuizLock.next || lock == _QuizLock.locked) {
      return _lockedQuizItemTile(
        context,
        title: title,
        isNext: lock == _QuizLock.next,
      );
    }
    // Default icon per quiz kind via the shared [quizKindIcon] map, so the
    // drawer and the course home stay in sync: reading → book, fill-in
    // "question" quizzes → quiz card, speak → voice. A known grammar section
    // icon still wins for fill-in; an explicit per-item iconKey wins over all.
    final kind = summary?.kind;
    final isSpeak = kind == QuizKind.speakRepeat;
    final isReading = kind == QuizKind.reading;
    final defaultIcon = switch (kind) {
      null => section?.icon ?? Icons.menu_book_rounded,
      QuizKind.fillBlank => section?.icon ?? quizKindIcon(QuizKind.fillBlank),
      final k => quizKindIcon(k),
    };
    final icon = navIconFor(item.iconKey, defaultIcon);
    // Badge color mirrors the icon: explicit per-item colorIndex wins, then a
    // grammar section accent, else the shared per-kind accent so the drawer
    // tints each kind the same as the home.
    final color = navColorFor(
      item.colorIndex,
      section?.accent ??
          (kind == null ? kSectionAccentColors[0] : quizKindColor(kind)),
    );
    final prefix = summary?.storageKeyPrefix ??
        section?.primaryQuiz.storageKeyPrefix ??
        '${item.ref}_';
    final keys = QuizStatsKeys(prefix);
    final prefs = data.prefs;
    final bestStreakAbsolute = prefs?.getInt(keys.bestStreakAbsolute) ?? 0;

    return _navTile(
      context,
      icon: icon,
      badgeColor: color,
      title: title,
      selected: widget.currentContentId == item.ref,
      onTap: () => _navigateToContent(context, item.ref),
      // Speak and reading quizzes have no streak — they're "done" once played
      // through / passed, matching how the course home marks them; fill-in
      // quizzes are done once their best streak reaches the goal.
      done: isSpeak
          ? NounSettings.instance.isSpeakQuizCompleted(item.ref)
          : isReading
              ? NounSettings.instance.isReadingQuizCompleted(item.ref)
              : NounSettings.instance.isQuizDone(
                  bestStreakAbsolute: bestStreakAbsolute,
                ),
      doneLaps: bestStreakAbsolute ~/ NounSettings.streakLapSize,
      subtitle: prefs == null
          ? null
          : _statsSubtitle(
              context,
              score: prefs.getInt(keys.score) ?? 0,
              bestStreakAbsolute: bestStreakAbsolute,
            ),
    );
  }

  /// A drawer tile for a built-in link item (Word Library / Settings).
  Widget _linkItemTile(BuildContext context, NavItem item) {
    final colorScheme = Theme.of(context).colorScheme;
    final strings = CourseSession.instance.strings;

    // "How it works" opens the course intro page (no fixed AppPage).
    if (item.ref == kHowItWorksRef) {
      return _navTile(
        context,
        icon: navIconFor(item.iconKey, Icons.help_outline_rounded),
        badgeColor: navColorFor(item.colorIndex, colorScheme.onSurfaceVariant),
        title: item.titleOverride ?? strings.howItWorks,
        selected: false,
        onTap: () {
          Navigator.pop(context);
          context.push('/intro');
        },
      );
    }

    // "Switch course" opens the course selector (no fixed AppPage).
    if (item.ref == kCoursesRef) {
      return _navTile(
        context,
        icon: navIconFor(item.iconKey, Icons.translate_rounded),
        badgeColor: navColorFor(item.colorIndex, colorScheme.onSurfaceVariant),
        title: item.titleOverride ?? strings.switchCourse,
        selected: false,
        onTap: () {
          Navigator.pop(context);
          context.push('/courses');
        },
      );
    }

    final (AppPage, IconData, String) spec;
    if (item.ref == kWordLibraryRef) {
      spec = (
        AppPage.wordLibrary,
        Icons.library_books_rounded,
        strings.wordLibrary,
      );
    } else if (item.ref == kSettingsRef) {
      spec = (AppPage.settings, Icons.settings_rounded, strings.settings);
    } else {
      return const SizedBox.shrink();
    }
    return _navTile(
      context,
      icon: navIconFor(item.iconKey, spec.$2),
      badgeColor: navColorFor(item.colorIndex, colorScheme.onSurfaceVariant),
      title: item.titleOverride ?? spec.$3,
      selected: widget.currentPage == spec.$1,
      onTap: () => _navigateTo(context, spec.$1),
    );
  }

  /// A fixed tile at the top of the drawer that returns to the active course's
  /// overview (the `/home` route).
  Widget _homeTile(BuildContext context) {
    return _navTile(
      context,
      icon: Icons.home_rounded,
      badgeColor: kSectionAccentColors[0],
      title: CourseSession.instance.strings.home,
      selected: false,
      onTap: () {
        Navigator.pop(context);
        context.go('/home');
      },
    );
  }

  // ── Course switcher (drawer header) ───────────────────────────────────────

  /// The drawer header, which doubles as a course switcher: it shows the
  /// active course (logo, name, language pair, tagline) and, when more than one
  /// course exists, opens a sheet to switch between them.
  Widget _buildCourseHeader(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final course = CourseSession.instance.activeCourse;
    final multiple = CourseSession.instance.courses.length > 1;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(kRadiusLarge),
        child: InkWell(
          borderRadius: BorderRadius.circular(kRadiusLarge),
          onTap: multiple ? () => _showCourseSwitcher(context) : null,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 10, 12),
            child: Row(
              children: [
                SvgPicture.asset(
                  'assets/icons/QuizLogo-02.svg',
                  width: 40,
                  height: 40,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        course.name,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            '${course.speakFlag} → ${course.learnFlag}',
                            style: const TextStyle(fontSize: 13),
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              course.tagline,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (multiple) ...[
                  const SizedBox(width: 6),
                  Icon(
                    Icons.unfold_more_rounded,
                    size: 20,
                    color: colorScheme.primary,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Opens a bottom sheet to pick a course; switches if a different one is
  /// chosen.
  Future<void> _showCourseSwitcher(BuildContext context) async {
    final courses = CourseSession.instance.courses;
    final activeId = CourseSession.instance.activeCourseId;
    final strings = CourseSession.instance.strings;

    final chosen = await showModalBottomSheet<Course>(
      context: context,
      showDragHandle: true,
      constraints: const BoxConstraints(maxWidth: 480),
      builder: (sheetContext) {
        final colorScheme = Theme.of(sheetContext).colorScheme;
        final textTheme = Theme.of(sheetContext).textTheme;
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
                child: Row(
                  children: [
                    Icon(
                      Icons.translate_rounded,
                      size: 20,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      strings.switchCourse,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              for (final course in courses)
                _courseSwitcherTile(
                  sheetContext,
                  course: course,
                  active: course.id == activeId,
                ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );

    if (!context.mounted) return;
    if (chosen != null && chosen.id != activeId) {
      _switchCourse(context, chosen);
    }
  }

  Widget _courseSwitcherTile(
    BuildContext context, {
    required Course course,
    required bool active,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
      child: Material(
        color: active
            ? colorScheme.primaryContainer.withValues(alpha: 0.5)
            : colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(kRadiusLarge),
        child: InkWell(
          borderRadius: BorderRadius.circular(kRadiusLarge),
          onTap: () => Navigator.pop(context, course),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Text(
                  '${course.speakFlag} → ${course.learnFlag}',
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        course.name,
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        course.tagline,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  active
                      ? Icons.check_circle_rounded
                      : Icons.chevron_right_rounded,
                  color: active
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Activates [course] and reopens the app on its home, clearing the old
  /// course's navigation stack.
  void _switchCourse(BuildContext context, Course course) {
    // Navigate to the course's own home; LearnerHomePage adopts it from the
    // route (sets it active, applies its Quest order), so the URL stays the
    // single source of truth.
    context.go('/course/${course.id}');
  }

  /// Renders one navigation group's tiles by [NavGroup.type]. [locks] holds the
  /// pass-to-unlock state of every quiz in the course's gated chain (see
  /// [_computeQuizLocks]); refs absent from it are open.
  List<Widget> _buildGroup(
    BuildContext context,
    NavGroup group,
    _DrawerData? data,
    SharedPreferences? prefs,
    Map<String, _QuizLock> locks,
  ) {
    switch (group.type) {
      case NavGroupType.questChain:
        return _buildQuestTiles(context, prefs, level: group.level);
      case NavGroupType.nounChain:
        return _buildNounProgressionTiles(context, prefs);
      case NavGroupType.quizzes:
        if (data == null) return const [];
        return [
          for (final item in group.items)
            if (!item.hidden)
              _quizItemTile(
                context,
                item: item,
                data: data,
                lock: group.gated ? locks[item.ref] : null,
              ),
        ];
      case NavGroupType.links:
        return [
          for (final item in group.items)
            if (!item.hidden) _linkItemTile(context, item),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Drawer(
      backgroundColor: colorScheme.surfaceContainerLow,
      child: SafeArea(
        child: FutureBuilder<_DrawerData>(
          future: _drawerDataFuture,
          builder: (context, snapshot) {
            final data = snapshot.data;
            // Fall back to the active course's nav (available in memory now),
            // not defaultNavLayout — otherwise the drawer briefly flashes the
            // default course's menu before _loadDrawerData resolves.
            final layout =
                data?.layout ?? CourseSession.instance.activeCourse.nav;
            final prefs = data?.prefs;
            // Pass-to-unlock state for every quiz in the course's gated chain.
            // Empty until the drawer data resolves (so quizzes show open during
            // the brief load rather than flashing locked).
            final locks = data == null
                ? const <String, _QuizLock>{}
                : _computeQuizLocks(layout, data);

            // Fade + slide the whole menu in each time the drawer opens (the
            // drawer's State is rebuilt per open, so this replays every time),
            // so the content arrives smoothly instead of snapping into place.
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOutCubic,
              builder: (context, t, child) => Opacity(
                opacity: t,
                child: Transform.translate(
                  offset: Offset(0, (1 - t) * 16),
                  child: child,
                ),
              ),
              child: ListView(
                padding: const EdgeInsets.only(bottom: 8),
                children: [
                  _buildCourseHeader(context),
                  _homeTile(context),
                  for (final group in layout.groups) ...[
                    Divider(height: 1, color: colorScheme.outlineVariant),
                    _sectionLabel(context, group.title),
                    ..._buildGroup(context, group, data, prefs, locks),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
