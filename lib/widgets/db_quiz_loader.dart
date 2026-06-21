import 'package:flutter/material.dart';

import '../data/db/content_repository.dart';
import '../data/quiz_content_adapter.dart';
import '../data/quiz_content_library.dart';
import '../data/quiz_explanation_overrides.dart';
import '../models/app_page.dart';
import '../models/quiz_config.dart';
import '../models/quiz_content.dart';
import '../pages/reading_quiz_page.dart';
import '../pages/speak_repeat_quiz_page.dart';
import 'quiz_page.dart';

/// Loads a quiz's content from the local database and renders it, so teacher
/// edits in the back office show up for learners.
///
/// The page is chosen by [QuizContent.kind]: fill-in-the-blank quizzes run
/// through the shared [QuizPage] engine, while [QuizKind.speakRepeat] quizzes
/// render [SpeakRepeatQuizPage] and [QuizKind.reading] quizzes render
/// [ReadingQuizPage].
///
/// If the database can't be opened or the quiz isn't found, it falls back to
/// the compiled-in content (or the [fallback] config), so the learner
/// experience never breaks.
class DbQuizLoader extends StatefulWidget {
  const DbQuizLoader({
    super.key,
    required this.quizId,
    required this.currentPage,
    this.fallback,
    this.progressionKey,
  });

  /// The `QuizContent.id` to load from the database.
  final String quizId;

  final AppPage currentPage;

  /// Used if the database is unavailable or has no such quiz. May be null for
  /// a data-driven nav item with no compiled counterpart.
  final QuizConfig? fallback;

  final String? progressionKey;

  @override
  State<DbQuizLoader> createState() => _DbQuizLoaderState();
}

class _DbQuizLoaderState extends State<DbQuizLoader> {
  late final Future<Widget> _pageFuture = _loadPage();

  /// The compiled-in content for this quiz id, used as a fallback for the
  /// page-kind decision when the database is unavailable.
  QuizContent? get _compiledContent {
    for (final c in allQuizContent) {
      if (c.id == widget.quizId) return c;
    }
    return null;
  }

  Future<Widget> _loadPage() async {
    QuizContent? content;
    try {
      final repo = await contentRepository();
      content = await repo.quizContent(widget.quizId);
    } catch (_) {
      // Database unavailable — fall through to the compiled content / fallback.
    }

    // Pick the page by kind, preferring DB content and falling back to the
    // compiled-in content for the decision when the database has nothing.
    final effective = content ?? _compiledContent;
    if (effective != null && effective.kind == QuizKind.speakRepeat) {
      return SpeakRepeatQuizPage(
        content: effective,
        currentPage: widget.currentPage,
      );
    }
    if (effective != null && effective.kind == QuizKind.reading) {
      return ReadingQuizPage(
        content: effective,
        currentPage: widget.currentPage,
      );
    }

    // Fill-in-the-blank path (unchanged): run DB content through the engine,
    // else fall back to the compiled-in [fallback] config.
    if (content != null) {
      return QuizPage(
        config: buildQuizConfigFromContent(
          content,
          currentPage: widget.currentPage,
          progressionKey: widget.progressionKey,
          explanationOverride: explanationOverrides[widget.quizId],
        ),
      );
    }
    final fallback = widget.fallback;
    if (fallback == null) return _notFound();
    return QuizPage(config: fallback);
  }

  Widget _notFound() => Scaffold(
    appBar: AppBar(),
    body: const Center(child: Text('Quiz not found.')),
  );

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _pageFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return snapshot.data ?? _notFound();
      },
    );
  }
}
