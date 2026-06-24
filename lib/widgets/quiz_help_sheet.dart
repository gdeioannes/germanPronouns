import 'package:flutter/material.dart';

import '../models/quiz_content.dart';
import 'help_memory.dart';

/// The Help bottom sheet shared by the reading / listening / dictation / speak
/// quizzes: the quiz title, its Help Memory intro, and its tip cards (one
/// definition instead of an identical copy on each page).
void showQuizHelpSheet(BuildContext context, QuizContent content) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      builder: (context, controller) => ListView(
        controller: controller,
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        children: [
          Text(content.title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          if (content.helpMemoryIntro != null)
            HelpMemoryIntro(text: content.helpMemoryIntro!),
          for (final tip in content.helpMemoryTips) HelpTipCard(tip: tip),
        ],
      ),
    ),
  );
}
