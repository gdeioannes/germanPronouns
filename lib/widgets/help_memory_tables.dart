import 'package:flutter/material.dart';

import '../models/quiz_config.dart';
import 'help_memory.dart';

/// The Help Memory reference table for one [HelpMemoryTable]: a header row of
/// the table's columns, then one row per subject with values read from the
/// quiz's [config] (gender-tinted when the quiz colors by gender).
///
/// Extracted verbatim from `quiz_page.dart`'s `_buildHelpMemoryTable` so the
/// reference-table rendering lives in one focused widget.
class HelpMemoryDataTable extends StatelessWidget {
  const HelpMemoryDataTable({
    super.key,
    required this.config,
    required this.table,
  });

  final QuizConfig config;
  final HelpMemoryTable table;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // Phone-width screens get smaller type, tighter padding and a narrower
    // label column so the table fits without cramped, wrapped-to-death cells.
    final compact = MediaQuery.sizeOf(context).width < 480;
    final categoriesByLabel = {
      for (final c in config.categories) c.label: c,
    };

    Widget cell(
      String text, {
      bool header = false,
      ({Color background, Color foreground})? tint,
      String? subtitle,
    }) {
      final main = Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: header ? Colors.white : tint?.foreground,
          fontWeight: header || tint != null
              ? FontWeight.w700
              : FontWeight.w500,
          fontSize: compact ? 12.5 : null,
        ),
      );
      return Container(
        color: tint?.background,
        padding: EdgeInsets.symmetric(horizontal: compact ? 6 : 10, vertical: 8),
        alignment: Alignment.center,
        child: subtitle == null || subtitle.isEmpty
            ? main
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  main,
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: compact ? 10 : 11,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
      );
    }

    TableRow buildRow(int? subjectIndex) {
      final background = subjectIndex == null
          ? colorScheme.primary
          : (subjectIndex.isEven
                ? colorScheme.surface
                : colorScheme.surfaceContainerHighest.withValues(alpha: 0.35));
      final tint = (subjectIndex != null && config.helpMemoryColorByGender)
          ? genderTint(config.subjectGenders?[subjectIndex])
          : null;
      return TableRow(
        decoration: BoxDecoration(color: background),
        children: [
          cell(
            subjectIndex == null
                ? config.subjectColumnLabel
                : config.subjectDisplays[subjectIndex],
            header: subjectIndex == null,
            subtitle: subjectIndex == null
                ? null
                : config.subjectEnglish?[subjectIndex],
          ),
          for (final column in table.columns)
            cell(
              subjectIndex == null
                  ? (column.displayLabel ?? column.categoryLabel)
                  : categoriesByLabel[column.categoryLabel]!
                        .values[subjectIndex],
              header: subjectIndex == null,
              tint: tint,
            ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          table.title,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Table(
          border: TableBorder.all(color: colorScheme.outlineVariant),
          columnWidths: {0: FixedColumnWidth(compact ? 84 : 110)},
          defaultColumnWidth: const FlexColumnWidth(),
          children: [
            buildRow(null),
            for (
              var index = 0;
              index < config.subjectDisplays.length;
              index++
            )
              buildRow(index),
          ],
        ),
      ],
    );
  }
}
