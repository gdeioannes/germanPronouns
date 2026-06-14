import 'package:flutter/material.dart';

import '../data/noun_progression_data.dart';
import '../models/noun_settings.dart';
import '../widgets/quiz_page.dart';

class NounArticleQuizPage extends StatelessWidget {
  const NounArticleQuizPage({super.key});

  @override
  Widget build(BuildContext context) {
    return QuizPage(
      config: resolveNounProgressionConfig(
        NounSettings.instance.lastNounProgressionKey,
        NounSettings.instance.completedNounCategories,
      ),
    );
  }
}
