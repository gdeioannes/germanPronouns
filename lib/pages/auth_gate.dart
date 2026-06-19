import 'package:flutter/material.dart';

import '../models/app_session.dart';
import 'back_office/back_office_home_page.dart';
import 'learner_home_page.dart';
import 'login_page.dart';

/// Decides which surface to show based on the session: a brief splash while the
/// remembered role loads, then the login screen, the back office (teachers), or
/// the quizzes (learners).
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  late final Future<void> _loaded = AppSession.instance.load();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _loaded,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(body: SizedBox.shrink());
        }
        return AnimatedBuilder(
          animation: AppSession.instance,
          builder: (context, _) {
            switch (AppSession.instance.role) {
              case UserRole.teacher:
                return const BackOfficeHomePage();
              case UserRole.learner:
                return const LearnerHomePage();
              case null:
                // A remembered teacher must re-enter the passcode, so open the
                // login screen straight in teacher mode for them.
                return LoginPage(
                  startInTeacherMode:
                      AppSession.instance.rememberedRole == UserRole.teacher,
                );
            }
          },
        );
      },
    );
  }
}

/// Signs out and resets the navigator to a fresh [AuthGate] (the login screen).
///
/// Needed because the drawer navigates with `pushReplacement`, which can
/// replace the original [AuthGate] — so simply flipping the session role isn't
/// enough to return to login from a quiz.
Future<void> signOutToLogin(BuildContext context) async {
  final navigator = Navigator.of(context, rootNavigator: true);
  await AppSession.instance.signOut();
  navigator.pushAndRemoveUntil(
    MaterialPageRoute<void>(builder: (_) => const AuthGate()),
    (route) => false,
  );
}
