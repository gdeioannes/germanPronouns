import 'package:flutter/material.dart';

import '../data/db/content_repository.dart';
import '../data/quiz_content_adapter.dart';
import '../data/quiz_explanation_overrides.dart';
import '../models/app_page.dart';
import '../models/quiz_config.dart';
import 'quiz_page.dart';

/// Loads a quiz's content from the local database and runs it through the
/// shared [QuizPage] engine, so teacher edits in the back office show up for
/// learners.
///
/// If the database can't be opened or the quiz isn't found, it falls back to
/// the compiled-in [fallback] config, so the learner experience never breaks.
class DbQuizLoader extends StatefulWidget {
  const DbQuizLoader({
    super.key,
    required this.quizId,
    required this.currentPage,
    required this.fallback,
    this.progressionKey,
  });

  /// The `QuizContent.id` to load from the database.
  final String quizId;

  final AppPage currentPage;

  /// Used if the database is unavailable or has no such quiz.
  final QuizConfig fallback;

  final String? progressionKey;

  @override
  State<DbQuizLoader> createState() => _DbQuizLoaderState();
}

class _DbQuizLoaderState extends State<DbQuizLoader> {
  late final Future<QuizConfig> _configFuture = _loadConfig();

  Future<QuizConfig> _loadConfig() async {
    try {
      final repo = await contentRepository();
      final content = await repo.quizContent(widget.quizId);
      if (content == null) return widget.fallback;
      return buildQuizConfigFromContent(
        content,
        currentPage: widget.currentPage,
        progressionKey: widget.progressionKey,
        explanationOverride: explanationOverrides[widget.quizId],
      );
    } catch (_) {
      return widget.fallback;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuizConfig>(
      future: _configFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return QuizPage(config: snapshot.data!);
      },
    );
  }
}
