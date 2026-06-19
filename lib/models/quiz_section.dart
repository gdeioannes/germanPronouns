import 'package:flutter/widgets.dart';

import 'app_page.dart';
import 'quiz_config.dart';
import 'quiz_stats_keys.dart';

/// A top-level quiz section: a group of one or more related quizzes shown as a
/// single entry in the navigation drawer's "QUIZZES" group and reachable as
/// its own page.
///
/// Each section currently wraps in-memory [QuizConfig]s. [quizzes] is the
/// extension point for the planned database step: a future DB-backed
/// `QuizRepository` would supply this list per section, so new quizzes can be
/// added to a section without changing the drawer, router, or quiz engine.
class QuizSection {
  const QuizSection({
    required this.page,
    required this.title,
    required this.icon,
    required this.accent,
    required this.contentId,
    required this.quizzes,
  }) : assert(quizzes.length > 0, 'A section needs at least one quiz');

  /// Identifies this section for navigation and drawer highlighting.
  final AppPage page;

  /// The `QuizContent.id` this section's primary quiz is stored under in the
  /// content database, so the learner page can load editable content.
  final String contentId;

  /// Drawer title for the section.
  final String title;

  /// Drawer badge icon.
  final IconData icon;

  /// Drawer badge color.
  final Color accent;

  /// The quizzes that make up this section. Today this is a fixed in-memory
  /// list (usually a single quiz); a future database can populate it per
  /// section.
  final List<QuizConfig> quizzes;

  /// The quiz opened when the user taps this section in the drawer.
  QuizConfig get primaryQuiz => quizzes.first;

  /// Stats-key builder for this section's primary quiz.
  QuizStatsKeys get statsKeys => QuizStatsKeys(primaryQuiz.storageKeyPrefix);
}
