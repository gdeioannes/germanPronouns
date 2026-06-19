import 'package:flutter/material.dart';

import '../data/db/content_repository.dart';
import '../data/quest_data.dart';
import '../data/quiz_content_adapter.dart';
import '../models/app_page.dart';
import '../models/quiz_config.dart';
import 'quiz_page.dart';

/// Runs a Quest quiz from the editable database, building its config with the
/// Quest progression flag so the engine uses the Quest streak goal to unlock
/// the next quiz in the chain. Falls back to the entry's compiled config if the
/// database is unavailable, so the learner flow never breaks.
class QuestQuizLoader extends StatefulWidget {
  const QuestQuizLoader({super.key, required this.entry});

  final QuestEntry entry;

  @override
  State<QuestQuizLoader> createState() => _QuestQuizLoaderState();
}

class _QuestQuizLoaderState extends State<QuestQuizLoader> {
  late final Future<QuizConfig> _configFuture = _loadConfig();

  Future<QuizConfig> _loadConfig() async {
    try {
      final repo = await contentRepository();
      final content = await repo.quizContent(widget.entry.key);
      if (content == null) return widget.entry.config;
      return buildQuizConfigFromContent(
        content,
        currentPage: AppPage.quest,
        progressionKey: widget.entry.key,
        questProgression: true,
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
