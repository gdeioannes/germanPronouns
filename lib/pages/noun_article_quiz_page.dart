import 'package:flutter/material.dart';

import '../data/noun_progression_data.dart';
import '../models/noun_settings.dart';
import '../widgets/noun_progression_quiz_loader.dart';

class NounArticleQuizPage extends StatelessWidget {
  const NounArticleQuizPage({super.key});

  @override
  Widget build(BuildContext context) {
    return NounProgressionQuizLoader(
      entry: resolveNounProgressionEntry(
        NounSettings.instance.lastNounProgressionKey,
        NounSettings.instance.completedNounCategories,
      ),
    );
  }
}
