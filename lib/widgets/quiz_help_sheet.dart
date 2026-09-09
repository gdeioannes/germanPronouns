import 'package:flutter/material.dart';

import '../models/course_session.dart';
import '../models/quiz_content.dart';
import '../models/speaking_exercise.dart';
import '../theme/app_theme.dart';
import 'help_memory.dart';
import 'help_memory_pdf_export.dart';
import 'speak_icon_button.dart';

/// The full Help Memory body for [content]: intro, tip cards, and — for a
/// speaking quiz — the exercise's whole study payload (MATERIAL verbatim,
/// practise points, target vocabulary). One definition shared by the Help
/// bottom sheet and the speaking page's on-page accordion, so "the content of
/// the quiz" means the same thing everywhere.
List<Widget> buildQuizStudyContent(BuildContext context, QuizContent content) {
  final theme = Theme.of(context);
  final speaking = content.speaking;
  final s = CourseSession.instance.strings.speaking;

  Widget heading(String text) => Padding(
    padding: const EdgeInsets.only(top: 16, bottom: 6),
    child: Text(
      text,
      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
    ),
  );

  // Material splits like the PDF: `word = meaning` pairs render as a styled
  // reference table, prose lines (passages, story beats, questions) as text;
  // label lines and the pair lines the table already covers are dropped.
  final pairs = speakingMaterialPairsOf(speaking?.material ?? '');
  final proseLines = [
    for (final line in (speaking?.material ?? '').split('\n'))
      if (line.trim().isNotEmpty && !line.contains(' = ')) line.trim(),
  ];

  return [
    if (content.helpMemoryIntro != null)
      HelpMemoryIntro(text: content.helpMemoryIntro!),
    for (final tip in content.helpMemoryTips) HelpTipCard(tip: tip),
    if (speaking != null) ...[
      if (pairs.isNotEmpty || proseLines.isNotEmpty) ...[
        heading(s.helpMaterialTitle),
        for (final line in proseLines)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              line,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
          ),
        if (pairs.isNotEmpty) ...[
          if (proseLines.isNotEmpty) const SizedBox(height: 8),
          _MaterialPairsTable(pairs: pairs),
        ],
      ],
      if (speaking.practisePoints.isNotEmpty) ...[
        heading(s.helpPractiseTitle),
        for (final point in speaking.practisePoints)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text('•  $point', style: theme.textTheme.bodyMedium),
          ),
      ],
      if (speaking.targetVocabulary.isNotEmpty) ...[
        heading(s.helpVocabularyTitle),
        Text(
          speaking.targetVocabulary.join(' · '),
          style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
        ),
      ],
    ],
  ];
}

/// The material's word/meaning pairs as a bordered reference table — the same
/// role the reference tables play on the other quizzes' Help Memory, with a
/// speak icon per entry so every word can be heard in the target language.
class _MaterialPairsTable extends StatelessWidget {
  const _MaterialPairsTable({required this.pairs});

  final List<(String, String)> pairs;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final s = CourseSession.instance.strings.speaking;

    Widget cell(Widget child, {EdgeInsetsGeometry? padding}) => Padding(
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: child,
    );

    Widget headerCell(String text) => cell(
      Text(
        text,
        style: theme.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: colorScheme.onSurfaceVariant,
        ),
      ),
    );

    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(kRadiusSmall),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(1.2),
          1: FlexColumnWidth(1),
        },
        border: TableBorder(
          horizontalInside: BorderSide(color: colorScheme.outlineVariant),
        ),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          TableRow(
            decoration: BoxDecoration(color: colorScheme.surfaceContainerHigh),
            children: [
              headerCell(s.helpWordColumn),
              headerCell(s.helpMeaningColumn),
            ],
          ),
          for (final (word, meaning) in pairs)
            TableRow(
              children: [
                cell(
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          word,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SpeakIconButton(text: word, size: 16),
                    ],
                  ),
                  padding: const EdgeInsets.only(left: 12, top: 2, bottom: 2),
                ),
                cell(
                  Text(
                    meaning,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

/// The Help bottom sheet shared by the reading / listening / dictation / speak
/// quizzes: the quiz title, its full study content ([buildQuizStudyContent]),
/// and a save-as-PDF action (one definition instead of an identical copy on
/// each page).
void showQuizHelpSheet(BuildContext context, QuizContent content) {
  final hasHelp =
      content.helpMemoryIntro != null || content.helpMemoryTips.isNotEmpty;
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    // The learner shell's RoomPanel door tab covers non-root sheets.
    useRootNavigator: true,
    builder: (context) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.6,
      maxChildSize: 0.9,
      builder: (context, controller) => ListView(
        controller: controller,
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        children: [
          Text(content.title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          ...buildQuizStudyContent(context, content),
          if (hasHelp) ...[
            const SizedBox(height: 16),
            OutlinedButton.icon(
              icon: const Icon(Icons.picture_as_pdf_rounded, size: 20),
              label: Text(CourseSession.instance.strings.saveAsPdf),
              onPressed: () => exportQuizHelpPdf(content),
            ),
          ],
        ],
      ),
    ),
  );
}
