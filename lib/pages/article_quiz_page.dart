import 'package:flutter/material.dart';

import '../data/article_data.dart';
import '../widgets/quiz_page.dart';

class ArticleQuizPage extends StatelessWidget {
  const ArticleQuizPage({super.key});

  @override
  Widget build(BuildContext context) {
    return QuizPage(config: articleQuizConfig);
  }
}
