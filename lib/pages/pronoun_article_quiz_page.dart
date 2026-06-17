import 'package:flutter/material.dart';

import '../data/pronoun_article_quiz_config.dart';
import '../widgets/quiz_page.dart';

class PronounArticleQuizPage extends StatelessWidget {
  const PronounArticleQuizPage({super.key});

  @override
  Widget build(BuildContext context) {
    return QuizPage(config: pronounArticleQuizConfig);
  }
}
