import 'package:flutter/material.dart';

import '../data/preposition_data.dart';
import '../widgets/quiz_page.dart';

class PrepositionQuizPage extends StatelessWidget {
  const PrepositionQuizPage({super.key});

  @override
  Widget build(BuildContext context) {
    return QuizPage(config: prepositionQuizConfig);
  }
}
