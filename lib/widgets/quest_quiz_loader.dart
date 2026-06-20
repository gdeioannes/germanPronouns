import 'package:flutter/material.dart';

import '../data/db/content_repository.dart';
import '../data/quest_data.dart';
import '../data/quiz_content_adapter.dart';
import '../models/app_page.dart';
import '../models/quiz_content.dart';
import '../pages/reading_quiz_page.dart';
import '../pages/speak_repeat_quiz_page.dart';
import 'quiz_page.dart';

/// Runs a Quest quiz from the editable database, picking the right page by the
/// content's [QuizContent.kind]:
///
/// * [QuizKind.fillBlank] → the shared [QuizPage] engine, with the Quest
///   progression flag so reaching the streak goal unlocks the next quiz;
/// * [QuizKind.speakRepeat] → [SpeakRepeatQuizPage] (unlocks the next quiz once
///   played through to the end — never needs a microphone);
/// * [QuizKind.reading] → [ReadingQuizPage] (unlocks the next quiz on a passing
///   score).
///
/// Falls back to the entry's compiled content/config if the database is
/// unavailable, so the learner flow never breaks.
class QuestQuizLoader extends StatefulWidget {
  const QuestQuizLoader({super.key, required this.entry});

  final QuestEntry entry;

  @override
  State<QuestQuizLoader> createState() => _QuestQuizLoaderState();
}

class _QuestQuizLoaderState extends State<QuestQuizLoader> {
  late final Future<Widget> _pageFuture = _loadPage();

  Future<Widget> _loadPage() async {
    QuizContent? content;
    try {
      final repo = await contentRepository();
      content = await repo.quizContent(widget.entry.key);
    } catch (_) {
      // Database unavailable — fall back to the compiled content/config.
    }
    final effective = content ?? widget.entry.content;

    switch (effective.kind) {
      case QuizKind.speakRepeat:
        return SpeakRepeatQuizPage(
          content: effective,
          currentPage: AppPage.quest,
          questProgressionKey: widget.entry.key,
        );
      case QuizKind.reading:
        return ReadingQuizPage(
          content: effective,
          currentPage: AppPage.quest,
          questProgressionKey: widget.entry.key,
        );
      case QuizKind.fillBlank:
        final config = content != null
            ? buildQuizConfigFromContent(
                content,
                currentPage: AppPage.quest,
                progressionKey: widget.entry.key,
                questProgression: true,
              )
            : widget.entry.config;
        return QuizPage(config: config);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: _pageFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        return snapshot.data!;
      },
    );
  }
}
