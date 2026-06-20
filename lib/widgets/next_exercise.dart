import 'package:flutter/material.dart';

import '../data/db/content_repository.dart';
import '../data/noun_progression_data.dart';
import '../data/quest_data.dart';
import '../data/section_catalog.dart';
import '../models/course_session.dart';
import '../models/nav_layout.dart';
import '../models/noun_settings.dart';
import '../models/quiz_config.dart';
import 'app_drawer.dart';
import 'noun_progression_quiz_loader.dart';
import 'quest_quiz_loader.dart';

/// A pointer to the exercise that follows the current one: its display [title]
/// and an [open] action that replaces the current route with it. Surfaced as a
/// "Next exercise" button once the learner finishes a listen-&-repeat quiz or
/// hits a streak in a fill-in quiz.
class NextExercise {
  const NextExercise({required this.title, required this.open});

  /// Human label for the upcoming exercise (its quiz title / chain step name).
  final String title;

  /// Navigates to the next exercise, replacing the current page (so the back
  /// button still returns to wherever the learner came from).
  final void Function(BuildContext context) open;
}

/// Resolves the exercise that should follow a quiz running [config], or null if
/// it's the last one in its sequence (so no button is shown).
///
/// Quest and noun-category quizzes follow their unlock chains; a plain
/// data-driven quiz follows the order of the active course's navigation.
Future<NextExercise?> resolveNextExerciseForConfig(QuizConfig config) {
  final progressionKey = config.progressionKey;
  if (progressionKey != null) {
    return Future.value(
      config.questProgression
          ? _nextQuest(progressionKey)
          : _nextNoun(progressionKey),
    );
  }
  final contentId = config.contentId;
  if (contentId != null) return _nextNavQuiz(contentId);
  return Future.value(null);
}

/// Resolves the exercise after the data-driven quiz with [contentId] — used by
/// the listen-&-repeat page, which runs without a [QuizConfig].
Future<NextExercise?> resolveNextExerciseForContent(String contentId) =>
    _nextNavQuiz(contentId);

/// The next Quest-chain exercise after [key], for the speak/reading skill pages
/// that run as a Quest entry (no [QuizConfig], so they can't use
/// [resolveNextExerciseForConfig]). The cert course has no `quizzes` nav group,
/// so the nav-based resolver wouldn't find anything.
NextExercise? questNextExercise(String key) => _nextQuest(key);

/// The next quiz in the Quest chain after [key], if any.
NextExercise? _nextQuest(String key) {
  final entries = questEntries;
  final index = entries.indexWhere((e) => e.key == key);
  if (index < 0 || index + 1 >= entries.length) return null;
  final next = entries[index + 1];
  return NextExercise(
    title: next.displayName,
    open: (context) {
      NounSettings.instance.setLastQuestQuizKey(next.key);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(builder: (_) => QuestQuizLoader(entry: next)),
      );
    },
  );
}

/// The next quiz in the noun-category chain after [key], if any.
NextExercise? _nextNoun(String key) {
  final entries = nounProgressionEntries;
  final index = entries.indexWhere((e) => e.key == key);
  if (index < 0 || index + 1 >= entries.length) return null;
  final next = entries[index + 1];
  return NextExercise(
    title: next.displayName,
    open: (context) {
      NounSettings.instance.setLastPage(AppPage.nounsArticles.name);
      NounSettings.instance.setLastNounProgressionKey(next.key);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => NounProgressionQuizLoader(entry: next),
        ),
      );
    },
  );
}

/// The next data-driven quiz after [contentId] in the active course's nav,
/// flattening every visible quiz item across all `quizzes` groups in order.
Future<NextExercise?> _nextNavQuiz(String contentId) async {
  // A quiz can open on app-resume before the drawer/home have loaded the course
  // list; make sure the active course's real navigation is available first.
  await CourseSession.instance.loadCourses();
  final refs = <String>[];
  for (final group in CourseSession.instance.activeCourse.nav.groups) {
    if (group.type != NavGroupType.quizzes) continue;
    for (final item in group.items) {
      if (!item.hidden) refs.add(item.ref);
    }
  }
  final index = refs.indexOf(contentId);
  if (index < 0 || index + 1 >= refs.length) return null;
  final nextRef = refs[index + 1];
  return NextExercise(
    title: await _navQuizTitle(nextRef),
    open: (context) {
      NounSettings.instance.setLastContentId(nextRef);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => buildQuizPageForContent(nextRef),
        ),
      );
    },
  );
}

/// Best-effort display title for the quiz stored under [ref]: a navigation
/// title override wins, then the database title, then the compiled section
/// title, falling back to the raw id.
Future<String> _navQuizTitle(String ref) async {
  for (final group in CourseSession.instance.activeCourse.nav.groups) {
    if (group.type != NavGroupType.quizzes) continue;
    for (final item in group.items) {
      if (item.ref == ref && item.titleOverride != null) {
        return item.titleOverride!;
      }
    }
  }
  try {
    final content = await (await contentRepository()).quizContent(ref);
    if (content != null) return content.title;
  } catch (_) {
    // Database unavailable — fall back to the compiled section title.
  }
  return sectionForContentId(ref)?.title ?? ref;
}
