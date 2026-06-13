import 'package:flutter/material.dart';

import '../data/noun_article_data.dart';
import '../widgets/quiz_page.dart';

class NounArticleQuizPage extends StatelessWidget {
  const NounArticleQuizPage({super.key});

  @override
  Widget build(BuildContext context) {
    return QuizPage(config: nounArticleQuizConfig);
  }
}
