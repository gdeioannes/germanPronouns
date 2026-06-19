import 'package:flutter/material.dart';

import '../data/quest_data.dart';
import '../models/noun_settings.dart';
import '../widgets/quest_quiz_loader.dart';

/// Entry point for the Quest (CEFR A-level) section: opens the Quest quiz the
/// learner last visited (if still unlocked), otherwise the first quiz in the
/// chain.
class QuestQuizPage extends StatelessWidget {
  const QuestQuizPage({super.key});

  @override
  Widget build(BuildContext context) {
    return QuestQuizLoader(
      entry: resolveQuestEntry(
        NounSettings.instance.lastQuestQuizKey,
        NounSettings.instance.completedQuestQuizzes,
      ),
    );
  }
}
