import 'package:flutter/material.dart';

import '../data/pronoun_data.dart';
import '../widgets/quiz_page.dart';

class PronounQuizPage extends StatelessWidget {
  const PronounQuizPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const QuizPage(config: pronounQuizConfig);
  }
}
