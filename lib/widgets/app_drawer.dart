import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/noun_settings.dart';
import '../pages/article_quiz_page.dart';
import '../pages/noun_article_quiz_page.dart';
import '../pages/pronoun_quiz_page.dart';
import '../pages/settings_page.dart';
import '../pages/word_library_page.dart';
import '../theme/app_theme.dart';

/// Identifies which top-level quiz page is currently shown, so the drawer
/// can highlight it.
enum AppPage { pronouns, articles, nounsArticles, wordLibrary, settings }

/// Builds the page widget for [page], used both by the drawer's navigation
/// and to reopen the app on the last-visited page.
Widget buildAppPage(AppPage page) => switch (page) {
  AppPage.pronouns => const PronounQuizPage(),
  AppPage.articles => const ArticleQuizPage(),
  AppPage.nounsArticles => const NounArticleQuizPage(),
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
  AppPage.nounsArticles: 'noun_article_',
};

/// Side navigation drawer shared by all quiz pages.
class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key, required this.currentPage});

  final AppPage currentPage;

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
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
    required AppPage page,
    Widget? subtitle,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final selected = widget.currentPage == page;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      child: Material(
        color: selected
            ? colorScheme.surfaceContainerHighest
            : Colors.transparent,
        borderRadius: BorderRadius.circular(kRadiusLarge),
        child: InkWell(
          borderRadius: BorderRadius.circular(kRadiusLarge),
          onTap: () => _navigateTo(context, page),
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
                          color: colorScheme.onSurface,
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

  Widget _quizTile(
    BuildContext context, {
    required IconData icon,
    required Color badgeColor,
    required String title,
    required AppPage page,
    required SharedPreferences? prefs,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final prefix = _quizStorageKeyPrefixes[page]!;
    final score = prefs?.getInt('${prefix}quiz_score') ?? 0;
    final streak = prefs?.getInt('${prefix}quiz_streak') ?? 0;
    final statStyle = Theme.of(context).textTheme.labelSmall?.copyWith(
      color: colorScheme.onSurfaceVariant,
    );

    return _navTile(
      context,
      icon: icon,
      badgeColor: badgeColor,
      title: title,
      page: page,
      subtitle: prefs == null
          ? null
          : Padding(
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
                  Text('$streak', style: statStyle),
                ],
              ),
            ),
    );
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
                      IconBadge(
                        icon: Icons.translate_rounded,
                        color: kSectionAccentColors[0],
                        size: 44,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'German Grammar Quiz',
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
                _sectionLabel(context, 'QUIZZES'),
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
                  icon: Icons.menu_book_rounded,
                  badgeColor: kSectionAccentColors[1],
                  title: 'Artikel (der/die/das)',
                  page: AppPage.articles,
                  prefs: prefs,
                ),
                _quizTile(
                  context,
                  icon: Icons.abc_rounded,
                  badgeColor: kSectionAccentColors[2],
                  title: 'Nouns & Articles',
                  page: AppPage.nounsArticles,
                  prefs: prefs,
                ),
                Divider(height: 1, color: colorScheme.outlineVariant),
                _sectionLabel(context, 'MORE'),
                _navTile(
                  context,
                  icon: Icons.library_books_rounded,
                  badgeColor: colorScheme.onSurfaceVariant,
                  title: 'Word Library',
                  page: AppPage.wordLibrary,
                ),
                _navTile(
                  context,
                  icon: Icons.settings_rounded,
                  badgeColor: colorScheme.onSurfaceVariant,
                  title: 'Settings',
                  page: AppPage.settings,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
