import 'package:flutter/material.dart';

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

/// Side navigation drawer shared by all quiz pages.
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key, required this.currentPage});

  final AppPage currentPage;

  void _navigateTo(BuildContext context, AppPage page) {
    Navigator.pop(context);
    NounSettings.instance.setLastPage(page.name);
    if (page == currentPage) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute<void>(builder: (_) => buildAppPage(page)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: colorScheme.primaryContainer),
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
            ListTile(
              leading: const Icon(Icons.groups_rounded),
              title: const Text('Pronouns'),
              selected: currentPage == AppPage.pronouns,
              onTap: () => _navigateTo(context, AppPage.pronouns),
            ),
            ListTile(
              leading: const Icon(Icons.menu_book_rounded),
              title: const Text('Artikel (der/die/das)'),
              selected: currentPage == AppPage.articles,
              onTap: () => _navigateTo(context, AppPage.articles),
            ),
            ListTile(
              leading: const Icon(Icons.abc_rounded),
              title: const Text('Nouns & Articles'),
              selected: currentPage == AppPage.nounsArticles,
              onTap: () => _navigateTo(context, AppPage.nounsArticles),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.library_books_rounded),
              title: const Text('Word Library'),
              selected: currentPage == AppPage.wordLibrary,
              onTap: () => _navigateTo(context, AppPage.wordLibrary),
            ),
            ListTile(
              leading: const Icon(Icons.settings_rounded),
              title: const Text('Settings'),
              selected: currentPage == AppPage.settings,
              onTap: () => _navigateTo(context, AppPage.settings),
            ),
          ],
        ),
      ),
    );
  }
}
