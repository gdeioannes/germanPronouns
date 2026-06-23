import 'package:flutter/material.dart';

import '../data/content/active_course_content.dart';
import '../data/noun_article_data.dart';
import '../data/noun_progression_data.dart';
import '../data/quiz_content_adapter.dart';
import '../models/app_page.dart';
import '../models/quiz_config.dart';
import 'quiz_page.dart';

/// Runs a noun-progression quiz (a category sub-quiz or "All Nouns"): it loads
/// the full "All Nouns" content (active course bundle → database), filters it to
/// the entry's category, and builds the config. Falls back to the entry's
/// compiled config if neither source has it, so the learner flow never breaks.
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
    final allNouns = await resolveQuizContent('noun_article');
    if (allNouns == null) return widget.entry.config;
    final content = nounProgressionContent(allNouns, widget.entry.key);
    return buildQuizConfigFromContent(
      content,
      currentPage: AppPage.nounsArticles,
      progressionKey: widget.entry.key,
      explanationOverride: buildNounArticleExplanation,
    );
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
