import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/noun_progression_data.dart';
import '../models/noun_settings.dart';
import '../pages/article_quiz_page.dart';
import '../pages/noun_article_quiz_page.dart';
import '../pages/preposition_quiz_page.dart';
import '../pages/pronoun_article_quiz_page.dart';
import '../pages/pronoun_quiz_page.dart';
import '../pages/settings_page.dart';
import '../pages/word_library_page.dart';
import '../theme/app_theme.dart';
import 'quiz_page.dart';

/// Identifies which top-level quiz page is currently shown, so the drawer
/// can highlight it.
enum AppPage {
  pronouns,
  articles,
  nounsArticles,
  pronounsAndArticles,
  prepositions,
  wordLibrary,
  settings,
}

/// Builds the page widget for [page], used both by the drawer's navigation
/// and to reopen the app on the last-visited page.
Widget buildAppPage(AppPage page) => switch (page) {
  AppPage.pronouns => const PronounQuizPage(),
  AppPage.articles => const ArticleQuizPage(),
  AppPage.nounsArticles => const NounArticleQuizPage(),
  AppPage.pronounsAndArticles => const PronounArticleQuizPage(),
  AppPage.prepositions => const PrepositionQuizPage(),
  AppPage.wordLibrary => const WordLibraryPage(),
  AppPage.settings => const SettingsPage(),
};

/// Looks up an [AppPage] by its enum name (as stored via
/// [NounSettings.setLastPage]), or null if [name] doesn't match any page.
AppPage? appPageFromName(String? name) {
  for (final page in AppPage.values) {
    if (page.name == name) return page;
  }
  return null;
}

/// Storage key prefixes for each quiz page's score/streak, matching
/// `QuizConfig.storageKeyPrefix` in lib/data/*.
const Map<AppPage, String> _quizStorageKeyPrefixes = {
  AppPage.pronouns: '',
  AppPage.articles: 'article_',
  AppPage.pronounsAndArticles: 'pronoun_article_',
  AppPage.prepositions: 'preposition_',
};

/// Side navigation drawer shared by all quiz pages.
class AppDrawer extends StatefulWidget {
  const AppDrawer({
    super.key,
    required this.currentPage,
    this.currentNounProgressionKey,
  });

  final AppPage currentPage;

  /// When [currentPage] is [AppPage.nounsArticles], the progression key
  /// (from [nounProgressionEntries]) of the currently open noun-category
  /// sub-quiz, used to highlight it in the "Noun Categories" section.
  final String? currentNounProgressionKey;

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool _nounCategoriesExpanded = false;

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
    required IconData icon,
    required Color badgeColor,
    required String title,
    required AppPage page,
    required SharedPreferences? prefs,
  }) {
    final prefix = _quizStorageKeyPrefixes[page]!;
    final score = prefs?.getInt('${prefix}quiz_score') ?? 0;
    final bestStreakAbsolute =
        prefs?.getInt('${prefix}quiz_best_streak_absolute') ?? 0;

    return _navTile(
      context,
      icon: icon,
      badgeColor: badgeColor,
      title: title,
      selected: widget.currentPage == page,
      onTap: () => _navigateTo(context, page),
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
        builder: (_) => QuizPage(config: entry.config),
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
    final prefix = entry.config.storageKeyPrefix;
    final score = prefs?.getInt('${prefix}quiz_score') ?? 0;
    final bestStreakAbsolute =
        prefs?.getInt('${prefix}quiz_best_streak_absolute') ?? 0;

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
    final bestStreakAbsolute =
        prefs?.getInt(
          '${previousEntry.config.storageKeyPrefix}quiz_best_streak_absolute',
        ) ??
        0;
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
                _sectionLabel(context, 'NOUN CATEGORIES'),
                ..._buildNounProgressionTiles(context, prefs),
                Divider(height: 1, color: colorScheme.outlineVariant),
                _sectionLabel(context, 'QUIZZES'),
                _quizTile(
                  context,
                  icon: Icons.menu_book_rounded,
                  badgeColor: kSectionAccentColors[1],
                  title: 'Artikel (der/die/das)',
                  page: AppPage.articles,
                  prefs: prefs,
                ),
                _quizTile(
                  context,
                  icon: Icons.groups_rounded,
                  badgeColor: kSectionAccentColors[0],
                  title: 'Pronouns',
                  page: AppPage.pronouns,
                  prefs: prefs,
                ),
                _quizTile(
                  context,
                  icon: Icons.article_rounded,
                  badgeColor: kSectionAccentColors[3],
                  title: 'Pronouns & Articles',
                  page: AppPage.pronounsAndArticles,
                  prefs: prefs,
                ),
                _quizTile(
                  context,
                  icon: Icons.signpost_rounded,
                  badgeColor: kSectionAccentColors[2],
                  title: 'Prepositions',
                  page: AppPage.prepositions,
                  prefs: prefs,
                ),
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
