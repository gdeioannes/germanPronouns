import 'package:flutter/material.dart';

import 'models/app_session.dart';
import 'pages/back_office/back_office_home_page.dart';
import 'pages/learner_home_page.dart';
import 'pages/login_page.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Germanquiz',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      home: const AuthGate(),
    );
  }
}

/// Routes to the right surface based on the current session: the login screen
/// when signed out, the back office for teachers, and the quizzes for learners.
class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppSession.instance,
      builder: (context, _) {
        switch (AppSession.instance.role) {
          case null:
            return const LoginPage();
          case UserRole.teacher:
            return const BackOfficeHomePage();
          case UserRole.learner:
            return const LearnerHomePage();
        }
      },
    );
  }
}
