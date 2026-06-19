import 'package:flutter/material.dart';

import '../data/db/content_repository.dart';
import '../data/quest_data.dart';
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
  Widget? _home;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await NounSettings.instance.load();
    // Apply the teacher's Quest chain order before any quiz can unlock the next.
    try {
      final repo = await contentRepository();
      applyQuestOrderFromLayout(await repo.navLayout());
    } catch (_) {
      // Default order if the database is unavailable.
    }
    if (!mounted) return;
    final contentId = NounSettings.instance.lastContentId;
    setState(() {
      // A data-driven nav quiz takes resume priority; otherwise the last fixed
      // page (default: the pronoun quiz).
      _home = contentId != null
          ? buildQuizPageForContent(contentId)
          : buildAppPage(
              appPageFromName(NounSettings.instance.lastPage) ??
                  AppPage.pronouns,
            );
    });
  }

  @override
  Widget build(BuildContext context) =>
      _home ?? const Scaffold(body: SizedBox.shrink());
}
