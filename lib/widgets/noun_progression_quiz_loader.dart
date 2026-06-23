import 'package:flutter/material.dart';

import '../data/content/active_course_content.dart';
import '../data/db/content_repository.dart';
import '../data/noun_article_data.dart';
import '../data/noun_progression_data.dart';
import '../data/quiz_content_adapter.dart';
import '../models/app_page.dart';
import '../models/quiz_config.dart';
import '../models/quiz_content.dart';
import 'quiz_page.dart';

/// Runs a noun-progression quiz (a category sub-quiz or "All Nouns") from the
/// editable database: it loads the full "All Nouns" content, filters it to the
/// entry's category, and builds the config. Falls back to the entry's compiled
/// config if the database is unavailable, so the learner flow never breaks.
class NounProgressionQuizLoader extends StatefulWidget {
  const NounProgressionQuizLoader({super.key, required this.entry});

  final NounProgressionEntry entry;

  @override
  State<NounProgressionQuizLoader> createState() =>
      _NounProgressionQuizLoaderState();
}

class _NounProgressionQuizLoaderState extends State<NounProgressionQuizLoader> {
  late final Future<QuizConfig> _configFuture = _loadConfig();

  Future<QuizConfig> _loadConfig() async {
    try {
      // The "All Nouns" source comes from the active course bundle (lazy +
      // cached) first, then the database; the per-category quiz is derived from
      // it exactly as before.
      QuizContent? allNouns = (await activeCourseQuiz('noun_article'))?.toLegacy();
      allNouns ??= await (await contentRepository()).quizContent('noun_article');
      if (allNouns == null) return widget.entry.config;
      final content = nounProgressionContent(allNouns, widget.entry.key);
      return buildQuizConfigFromContent(
        content,
        currentPage: AppPage.nounsArticles,
        progressionKey: widget.entry.key,
        explanationOverride: buildNounArticleExplanation,
      );
    } catch (_) {
      return widget.entry.config;
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
