import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// The standard raised card panel used across the reading / listening /
/// dictation quizzes (one definition instead of a copy per page).
class QuizPanel extends StatelessWidget {
  const QuizPanel({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kRadiusLarge),
        boxShadow: [
          BoxShadow(color: colorScheme.outline, offset: const Offset(0, 3)),
        ],
      ),
      child: Card(
        margin: EdgeInsets.zero,
        color: colorScheme.surfaceContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(kRadiusLarge),
          side: BorderSide(color: Colors.grey.shade400),
        ),
        child: Padding(padding: const EdgeInsets.all(16), child: child),
      ),
    );
  }
}
