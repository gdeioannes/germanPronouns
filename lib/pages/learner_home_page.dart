import 'package:flutter/material.dart';

import '../models/noun_settings.dart';
import '../widgets/app_drawer.dart';

/// The learner-facing entry point: reopens the app on the page the user last
/// visited (see [NounSettings.lastPage]), defaulting to the Pronoun quiz.
class LearnerHomePage extends StatefulWidget {
  const LearnerHomePage({super.key});

  @override
  State<LearnerHomePage> createState() => _LearnerHomePageState();
}

class _LearnerHomePageState extends State<LearnerHomePage> {
  AppPage? _page;

  @override
  void initState() {
    super.initState();
    NounSettings.instance.load().then((_) {
      if (!mounted) return;
      setState(() {
        _page =
            appPageFromName(NounSettings.instance.lastPage) ?? AppPage.pronouns;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final page = _page;
    if (page == null) {
      return const Scaffold(body: SizedBox.shrink());
    }
    return buildAppPage(page);
  }
}
