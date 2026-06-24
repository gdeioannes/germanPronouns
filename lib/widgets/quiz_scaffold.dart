import 'package:flutter/material.dart';

import '../models/course_session.dart';
import '../models/quiz_content.dart';
import 'app_drawer.dart';
import 'quiz_help_sheet.dart';

/// The shared shell for the reading / listening / dictation / speak quiz pages:
/// an app bar with the (shrink-to-fit) quiz title and a Help action, the nav
/// drawer, and the page's [body]. One definition instead of an identical
/// Scaffold + AppBar + drawer on every page.
class QuizScaffold extends StatelessWidget {
  const QuizScaffold({
    super.key,
    required this.content,
    required this.currentPage,
    required this.body,
  });

  final QuizContent content;
  final AppPage currentPage;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Shrink long titles to fit on one line instead of truncating with "…".
        title: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(content.title),
        ),
        actions: [
          IconButton(
            tooltip: CourseSession.instance.strings.help,
            icon: const Icon(Icons.help_outline_rounded),
            onPressed: () => showQuizHelpSheet(context, content),
          ),
        ],
      ),
      drawer: AppDrawer(
        currentPage: currentPage,
        currentContentId: content.id,
      ),
      body: body,
    );
  }
}
