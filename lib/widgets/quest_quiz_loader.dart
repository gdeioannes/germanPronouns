import 'package:flutter/material.dart';

import '../data/content/active_course_content.dart';
import '../data/quest_data.dart';
import '../models/app_page.dart';
import 'quiz_page_dispatch.dart';

/// Runs a Quest quiz, picking the page by [QuizContent.kind] (see
/// [pageForQuizContent]) with the Quest progression key so finishing it unlocks
/// the next quiz in the chain. Content comes from the active course bundle →
/// database → the entry's compiled content, so the flow never breaks.
class QuestQuizLoader extends StatefulWidget {
  const QuestQuizLoader({super.key, required this.entry});

  final QuestEntry entry;

  @override
  State<QuestQuizLoader> createState() => _QuestQuizLoaderState();
}

class _QuestQuizLoaderState extends State<QuestQuizLoader> {
  late final Future<Widget> _pageFuture = _loadPage();

  Future<Widget> _loadPage() async {
    final content = await resolveQuizContent(widget.entry.key);
    final effective = content ?? widget.entry.content;
    return pageForQuizContent(
      effective,
      currentPage: AppPage.quest,
      questProgressionKey: widget.entry.key,
      progressionKey: widget.entry.key,
      questProgression: true,
    );
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
