import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/course.dart';
import '../models/nav_layout.dart';
import '../models/noun_settings.dart';
import '../models/quiz_content.dart';
import '../models/quiz_stats_keys.dart';
import 'db/content_repository.dart';
import 'noun_progression_data.dart';
import 'quest_data.dart';
import 'section_catalog.dart';

/// A lightweight per-course learning summary for the course finder's "your
/// courses" cards: the share of quizzes finished plus the score/accuracy
/// aggregates the course home's overview shows — computed straight from the
/// persisted stats, without loading the course's content.
class CourseProgress {
  const CourseProgress({
    required this.total,
    required this.finished,
    required this.score,
    required this.answered,
    required this.correct,
  });

  /// Finishable quizzes in the course, and how many are done.
  final int total;
  final int finished;

  /// Score and answer counts summed across the course's quizzes.
  final int score;
  final int answered;
  final int correct;

  double get fractionFinished => total == 0 ? 0.0 : finished / total;

  /// Percentage of correct answers, or null before anything was answered.
  int? get accuracyPct =>
      answered == 0 ? null : (correct * 100 / answered).round();

  /// Whether the learner has actually done anything in this course yet.
  bool get hasActivity => finished > 0 || answered > 0 || score > 0;
}

/// One quiz's identity for progress purposes: its content id / chain key (what
/// the completion sets track), where its stats live, and whether it already
/// counts as finished.
class _QuizRef {
  const _QuizRef(this.id, this.prefix, this.done);

  final String id;
  final String prefix;
  final bool done;
}

/// Every quiz in [course]'s nav as a [_QuizRef], walking the same group types
/// the course home does (plain quiz lists, quest chains by level, the noun
/// chain).
List<_QuizRef> _courseQuizRefs(
  Course course,
  Map<String, QuizSummary> summaries,
  SharedPreferences prefs,
) {
  final quizzes = <_QuizRef>[];
  for (final group in course.nav.groups) {
    switch (group.type) {
      case NavGroupType.quizzes:
        for (final item in group.items) {
          if (item.hidden) continue;
          quizzes.add(_resolveItem(item.ref, summaries[item.ref], prefs));
        }
      case NavGroupType.questChain:
        final level = group.level;
        for (final e in questEntries) {
          if (level != null && e.levelLabel != level) continue;
          quizzes.add(
            _QuizRef(
              e.key,
              e.config.storageKeyPrefix,
              NounSettings.instance.isQuestQuizCompleted(e.key),
            ),
          );
        }
      case NavGroupType.nounChain:
        for (final e in nounProgressionEntries) {
          quizzes.add(
            _QuizRef(
              e.key,
              e.config.storageKeyPrefix,
              NounSettings.instance.isNounCategoryCompleted(e.key),
            ),
          );
        }
      case NavGroupType.links:
        break;
    }
  }
  return quizzes;
}

Future<Map<String, QuizSummary>>? _summariesFuture;

/// Quiz id → summary map from the content database, or empty when the database
/// is unavailable (the resolvers then fall back to section-catalog/ref-derived
/// prefixes, like the drawer).
///
/// Memoized for the session: a quiz's kind and storage prefix are stable (the
/// golden tests pin the prefixes), so the finder and My Courses page don't
/// re-list the whole database every time they open.
Future<Map<String, QuizSummary>> _quizSummaries() =>
    _summariesFuture ??= _loadQuizSummaries();

Future<Map<String, QuizSummary>> _loadQuizSummaries() async {
  try {
    final repo = await contentRepository();
    return {for (final q in await repo.listQuizzes()) q.id: q};
  } catch (_) {
    return const {};
  }
}

/// Computes a [CourseProgress] per course id, mirroring the done/score
/// semantics of the course home and drawer: listen-&-repeat once played
/// through, reading/listening once passed, fill-in once the best streak
/// reaches the goal, quest and noun chains via their completion sets.
Future<Map<String, CourseProgress>> loadCourseProgress(
  List<Course> courses,
) async {
  final prefs = await SharedPreferences.getInstance();
  final summaries = await _quizSummaries();

  final result = <String, CourseProgress>{};
  for (final course in courses) {
    final quizzes = _courseQuizRefs(course, summaries, prefs);

    var finished = 0;
    var score = 0;
    var answered = 0;
    var correct = 0;
    for (final q in quizzes) {
      if (q.done) finished++;
      final keys = QuizStatsKeys(q.prefix);
      score += prefs.getInt(keys.score) ?? 0;
      final raw = prefs.getString(keys.answerHistory);
      if (raw == null || raw.isEmpty) continue;
      try {
        final decoded = jsonDecode(raw);
        if (decoded is List) {
          answered += decoded.length;
          correct += decoded
              .where((h) => h is Map && h['correct'] == true)
              .length;
        }
      } catch (_) {
        // A malformed history just contributes nothing.
      }
    }

    result[course.id] = CourseProgress(
      total: quizzes.length,
      finished: finished,
      score: score,
      answered: answered,
      correct: correct,
    );
  }
  return result;
}

/// Resolves a plain nav quiz item to its storage prefix + done state, matching
/// the drawer's rules; [summary] may be null when the database is unavailable,
/// in which case the ref falls back to the fill-in streak check.
_QuizRef _resolveItem(
  String ref,
  QuizSummary? summary,
  SharedPreferences prefs,
) {
  switch (summary?.kind) {
    case QuizKind.speakRepeat:
    case QuizKind.speaking:
      return _QuizRef(
        ref,
        summary!.storageKeyPrefix,
        NounSettings.instance.isSpeakQuizCompleted(ref),
      );
    case QuizKind.reading:
      return _QuizRef(
        ref,
        summary!.storageKeyPrefix,
        NounSettings.instance.isReadingQuizCompleted(ref),
      );
    case QuizKind.listening:
      return _QuizRef(
        ref,
        summary!.storageKeyPrefix,
        NounSettings.instance.isListeningQuizCompleted(ref),
      );
    case QuizKind.dictation:
      return _QuizRef(
        ref,
        summary!.storageKeyPrefix,
        NounSettings.instance.isDictationQuizCompleted(ref),
      );
    case QuizKind.draw:
      // Drawing completes on play-through, sharing the speak completion set.
      return _QuizRef(
        ref,
        summary!.storageKeyPrefix,
        NounSettings.instance.isSpeakQuizCompleted(ref),
      );
    case QuizKind.fillBlank:
    case null:
      final prefix =
          summary?.storageKeyPrefix ??
          sectionForContentId(ref)?.primaryQuiz.storageKeyPrefix ??
          '${ref}_';
      final best = prefs.getInt(QuizStatsKeys(prefix).bestStreakAbsolute) ?? 0;
      return _QuizRef(
        ref,
        prefix,
        NounSettings.instance.isQuizDone(bestStreakAbsolute: best),
      );
  }
}

/// Permanently deletes all persisted progress for [course]: every quiz's
/// stats (score, streaks, answer history, mistakes, saved selections) and its
/// entries in the completion sets.
///
/// Content shared between courses (e.g. the Quest chain, which both German
/// courses reference) loses its progress everywhere — stats are stored once
/// per quiz, not per course. The course itself stays available in the finder,
/// starting from zero.
Future<void> clearCourseProgress(Course course) async {
  final prefs = await SharedPreferences.getInstance();
  final summaries = await _quizSummaries();
  final quizzes = _courseQuizRefs(course, summaries, prefs);

  for (final q in quizzes) {
    final keys = QuizStatsKeys(q.prefix);
    await prefs.remove(keys.score);
    await prefs.remove(keys.streak);
    await prefs.remove(keys.bestStreakLap);
    await prefs.remove(keys.bestStreakAbsolute);
    await prefs.remove(keys.answerHistory);
    await prefs.remove(keys.mistakesByCase);
    await prefs.remove(keys.enabledSubjects);
    await prefs.remove(keys.enabledCategories);
  }
  await NounSettings.instance.unmarkCompletions([
    for (final q in quizzes) q.id,
  ]);
}
