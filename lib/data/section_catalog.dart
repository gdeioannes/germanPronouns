import 'package:flutter/material.dart';

import '../models/app_page.dart';
import '../models/quiz_section.dart';
import '../theme/app_theme.dart';
import 'article_data.dart';
import 'preposition_data.dart';
import 'pronoun_article_quiz_config.dart';
import 'pronoun_data.dart';

/// The app's quiz sections shown in the drawer's "QUIZZES" group, in display
/// order.
///
/// Single source of truth: the drawer renders its quiz tiles from this list,
/// the router (`buildAppPage`) opens these sections from it, and each quiz's
/// stored score/streak is read via [QuizSection.statsKeys]. Adding a quiz
/// section means adding one entry here — the drawer and router pick it up
/// automatically.
///
/// The "Noun Categories" progression is a separate, dynamically-unlocked
/// section (see `nounProgressionEntries`) and is intentionally not listed here.
///
/// When the database step lands, a `QuizRepository` can build these entries
/// (and their quizzes) from stored data instead of the const configs below.
final List<QuizSection> quizSections = [
  QuizSection(
    page: AppPage.articles,
    title: 'Artikel (der/die/das)',
    icon: Icons.menu_book_rounded,
    accent: kSectionAccentColors[1],
    contentId: 'article',
    quizzes: [articleQuizConfig],
  ),
  QuizSection(
    page: AppPage.pronouns,
    title: 'Pronouns',
    icon: Icons.groups_rounded,
    accent: kSectionAccentColors[0],
    contentId: 'pronoun',
    quizzes: [pronounQuizConfig],
  ),
  QuizSection(
    page: AppPage.pronounsAndArticles,
    title: 'Pronouns & Articles',
    icon: Icons.article_rounded,
    accent: kSectionAccentColors[3],
    contentId: 'pronoun_article',
    quizzes: [pronounArticleQuizConfig],
  ),
  QuizSection(
    page: AppPage.prepositions,
    title: 'Prepositions',
    icon: Icons.signpost_rounded,
    accent: kSectionAccentColors[2],
    contentId: 'preposition',
    quizzes: [prepositionQuizConfig],
  ),
];

/// The section for [page], or null if [page] is not a [QuizSection] (e.g. the
/// noun progression, Word Library, or Settings).
QuizSection? sectionForPage(AppPage page) {
  for (final section in quizSections) {
    if (section.page == page) return section;
  }
  return null;
}

/// The section whose primary quiz is stored under [contentId], or null. Used by
/// the data-driven drawer to find a known quiz's default icon/accent/config.
QuizSection? sectionForContentId(String contentId) {
  for (final section in quizSections) {
    if (section.contentId == contentId) return section;
  }
  return null;
}
