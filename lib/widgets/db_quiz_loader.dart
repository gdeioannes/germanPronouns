import 'package:flutter/material.dart';

import '../data/content/active_course_content.dart';
import '../data/quiz_explanation_overrides.dart';
import '../models/app_page.dart';
import '../models/quiz_config.dart';
import '../models/quiz_content.dart';
import 'quiz_page.dart';
import 'quiz_page_dispatch.dart';

/// Loads a quiz's content (active course bundle → database) and renders it
/// with the page chosen by [QuizContent.kind] (see [pageForQuizContent]). If
/// nothing is found, it falls back to the [fallback] config so the learner
/// experience never breaks.
class DbQuizLoader extends StatefulWidget {
  const DbQuizLoader({
    super.key,
    required this.quizId,
    required this.currentPage,
    this.fallback,
    this.progressionKey,
  });

  /// The `QuizContent.id` to load.
  final String quizId;

  final AppPage currentPage;

  /// Used if neither the bundle nor the database has this quiz. May be null for
  /// a data-driven nav item with no compiled counterpart.
  final QuizConfig? fallback;

  final String? progressionKey;

  @override
  State<DbQuizLoader> createState() => _DbQuizLoaderState();
}

class _DbQuizLoaderState extends State<DbQuizLoader> {
  late final Future<Widget> _pageFuture = _loadPage();

  Future<Widget> _loadPage() async {
    final content = await resolveQuizContent(widget.quizId);

    // Audio/reading kinds render from the resolved content.
    if (content != null && content.kind != QuizKind.fillBlank) {
      return pageForQuizContent(content, currentPage: widget.currentPage);
    }
    // Fill-in-the-blank: build from resolved content, else the fallback config.
    if (content != null) {
      return pageForQuizContent(
        content,
        currentPage: widget.currentPage,
        progressionKey: widget.progressionKey,
        explanationOverride: explanationOverrides[widget.quizId],
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
