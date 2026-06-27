import 'package:flutter/material.dart';

import '../models/noun_settings.dart';
import '../models/quiz_config.dart';
import 'help_memory.dart';
import 'speak_icon_button.dart';

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

/// A small declension-ending reference table (e.g. the endings added to
/// "mein-"/"dein-" to form possessive pronouns), shown below the
/// [HelpMemoryDataTable]s. Depends only on its [table] data. Extracted verbatim
/// from `quiz_page.dart`'s `_buildEndingPatternTable`.
class EndingPatternTableView extends StatelessWidget {
  const EndingPatternTableView({super.key, required this.table});

  final EndingPatternTable table;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    // Match the responsive sizing of the reference tables above so endings stay
    // readable on a phone.
    final compact = MediaQuery.sizeOf(context).width < 480;

    Widget cell(String text, {bool header = false}) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: compact ? 6 : 10, vertical: 8),
        alignment: Alignment.center,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: header ? Colors.white : null,
            fontWeight: header ? FontWeight.w700 : FontWeight.w500,
            fontSize: compact ? 12.5 : null,
          ),
        ),
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
            TableRow(
              decoration: BoxDecoration(color: colorScheme.primary),
              children: [
                cell(table.cornerLabel, header: true),
                for (final label in table.columnLabels)
                  cell(label, header: true),
              ],
            ),
            for (var index = 0; index < table.rowLabels.length; index++)
              TableRow(
                decoration: BoxDecoration(
                  color: index.isEven
                      ? colorScheme.surface
                      : colorScheme.surfaceContainerHighest.withValues(
                          alpha: 0.35,
                        ),
                ),
                children: [
                  cell(table.rowLabels[index]),
                  for (final value in table.rows[index]) cell(value),
                ],
              ),
          ],
        ),
        if (table.notes != null) ...[
          const SizedBox(height: 8),
          for (final note in table.notes!)
            Padding(
              padding: const EdgeInsets.only(left: 8, bottom: 2),
              child: Text('• $note'),
            ),
        ],
      ],
    );
  }
}

/// The Help Memory reference for noun quizzes: one row per noun as a merged
/// "die Uhr, -en" line (article gender-colored, then the word with its plural
/// ending and English meaning beneath) instead of the generic subject/value
/// table. Reads the quiz's [config] and the learner's color settings from
/// [NounSettings]. Extracted verbatim from `quiz_page.dart`'s
/// `_buildNounReferenceList`.
class NounReferenceList extends StatelessWidget {
  const NounReferenceList({super.key, required this.config});

  final QuizConfig config;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final articles =
        config.categories.isNotEmpty ? config.categories.first.values : null;
    final genders = config.subjectGenders;
    final english = config.subjectEnglish;
    final colorNouns = NounSettings.instance.colorNouns;

    // Plural endings ("-e", "¨-er", or a full irregular form) from the Plural
    // info column; "—"/empty means there's no plural to show.
    List<String>? plurals;
    for (final c in config.helpMemoryInfoColumns) {
      if (c.label.toLowerCase() == 'plural') {
        plurals = c.values;
        break;
      }
    }

    Widget row(int i) {
      final gender =
          (genders != null && i < genders.length) ? genders[i] : null;
      final article =
          (articles != null && i < articles.length) ? articles[i] : null;
      // The article always carries its gender color (the der/die/das system);
      // the noun follows the user's "color nouns" toggle.
      final articleColor = gender != null
          ? NounSettings.instance.colorForGender(gender)
          : colorScheme.onSurface;
      final nounColor = (gender != null && colorNouns)
          ? NounSettings.instance.colorForGender(gender)
          : colorScheme.onSurface;
      final plural = (plurals != null && i < plurals.length) ? plurals[i] : null;
      final hasPlural = plural != null && plural.isNotEmpty && plural != '—';
      final meaning =
          (english != null && i < english.length) ? english[i] : null;
      // The noun with its article, e.g. "die Uhr" — read aloud by the speaker.
      final spoken =
          '${article != null ? '$article ' : ''}${config.subjectDisplays[i]}';

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: i.isEven
              ? colorScheme.surface
              : colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
          border: Border(bottom: BorderSide(color: colorScheme.outlineVariant)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                style: const TextStyle(fontSize: 15),
                children: [
                  if (article != null)
                    TextSpan(
                      text: '$article ',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: articleColor,
                      ),
                    ),
                  TextSpan(
                    text: config.subjectDisplays[i],
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: nounColor,
                    ),
                  ),
                  if (hasPlural)
                    TextSpan(
                      text: ', $plural',
                      style: TextStyle(color: colorScheme.onSurfaceVariant),
                    ),
                ],
              ),
            ),
            if (meaning != null && meaning.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  meaning,
                  style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
                ],
              ),
            ),
            SpeakIconButton(text: spoken, size: 18),
          ],
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          for (var i = 0; i < config.subjectDisplays.length; i++) row(i),
        ],
      ),
    );
  }
}
