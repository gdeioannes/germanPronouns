import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/noun_settings.dart';
import '../pages/article_quiz_page.dart';
import '../pages/noun_article_quiz_page.dart';
import '../pages/pronoun_quiz_page.dart';
import '../pages/settings_page.dart';
import '../pages/word_library_page.dart';

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

  Widget _quizTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required AppPage page,
    required SharedPreferences? prefs,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final prefix = _quizStorageKeyPrefixes[page]!;
    final score = prefs?.getInt('${prefix}quiz_score') ?? 0;
    final streak = prefs?.getInt('${prefix}quiz_streak') ?? 0;

    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: prefs == null
          ? null
          : Row(
              children: [
                Icon(
                  Icons.star_rounded,
                  size: 14,
                  color: Colors.amber.shade700,
                ),
                const SizedBox(width: 2),
                Text('$score', style: Theme.of(context).textTheme.labelSmall),
                const SizedBox(width: 10),
                Icon(Icons.bolt_rounded, size: 14, color: colorScheme.primary),
                const SizedBox(width: 2),
                Text(
                  '$streak',
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
      selected: widget.currentPage == page,
      onTap: () => _navigateTo(context, page),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Drawer(
      child: SafeArea(
        child: FutureBuilder<SharedPreferences>(
          future: SharedPreferences.getInstance(),
          builder: (context, snapshot) {
            final prefs = snapshot.data;

            return ListView(
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                  ),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'German Grammar Quiz',
                      style: TextStyle(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                _quizTile(
                  context,
                  icon: Icons.groups_rounded,
                  title: 'Pronouns',
                  page: AppPage.pronouns,
                  prefs: prefs,
                ),
                _quizTile(
                  context,
                  icon: Icons.menu_book_rounded,
                  title: 'Artikel (der/die/das)',
                  page: AppPage.articles,
                  prefs: prefs,
                ),
                _quizTile(
                  context,
                  icon: Icons.abc_rounded,
                  title: 'Nouns & Articles',
                  page: AppPage.nounsArticles,
                  prefs: prefs,
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.library_books_rounded),
                  title: const Text('Word Library'),
                  selected: widget.currentPage == AppPage.wordLibrary,
                  onTap: () => _navigateTo(context, AppPage.wordLibrary),
                ),
                ListTile(
                  leading: const Icon(Icons.settings_rounded),
                  title: const Text('Settings'),
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
