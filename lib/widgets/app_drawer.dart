import 'package:flutter/material.dart';

import '../pages/article_quiz_page.dart';
import '../pages/noun_article_quiz_page.dart';
import '../pages/pronoun_quiz_page.dart';
import '../pages/word_library_page.dart';

/// Identifies which top-level quiz page is currently shown, so the drawer
/// can highlight it.
enum AppPage { pronouns, articles, nounsArticles, wordLibrary }

/// Side navigation drawer shared by all quiz pages.
class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key, required this.currentPage});

  final AppPage currentPage;

  void _navigateTo(BuildContext context, AppPage page) {
    Navigator.pop(context);
    if (page == currentPage) return;

    final route = switch (page) {
      AppPage.pronouns => MaterialPageRoute<void>(
        builder: (_) => const PronounQuizPage(),
      ),
      AppPage.articles => MaterialPageRoute<void>(
        builder: (_) => const ArticleQuizPage(),
      ),
      AppPage.nounsArticles => MaterialPageRoute<void>(
        builder: (_) => const NounArticleQuizPage(),
      ),
      AppPage.wordLibrary => MaterialPageRoute<void>(
        builder: (_) => const WordLibraryPage(),
      ),
    };
    Navigator.pushReplacement(context, route);
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
          ],
        ),
      ),
    );
  }
}
