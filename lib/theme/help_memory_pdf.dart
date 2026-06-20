import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../data/gender_reference.dart';
import '../models/course_session.dart';
import '../models/noun_settings.dart';
import '../models/quiz_config.dart';
import 'pdf_theme.dart';

/// Builds the Help Memory reference material as PDF widgets, shared by the
/// per-quiz export in the quiz engine (widgets/quiz_page.dart) and by the
/// all-quizzes booklet ([exportQuizzesBookletPdf]) on the quiz home page, so the
/// two render identically.

/// Whether [config] collapses its reference tables to one row per article
/// gender (der/die/das) instead of one row per subject — mirrors the on-screen
/// `_useGenderReferenceRows`.
bool _useGenderRows(QuizConfig config) =>
    config.collapseReferenceTablesByGender && config.subjectGenders != null;

/// The page format that best fits [config]'s Help Memory table: focused
/// [HelpMemoryTable]s stay on A4, otherwise the size grows with the column
/// count (matching the engine's original export logic).
PdfPageFormat helpMemoryPageFormat(QuizConfig config) {
  if (config.helpMemoryTables != null) return PdfPageFormat.a4;
  final columnCount =
      1 + config.categories.length + config.helpMemoryInfoColumns.length;
  if (columnCount > 15) return PdfPageFormat.a3.landscape;
  if (columnCount > 5) return PdfPageFormat.a4.landscape;
  return PdfPageFormat.a4;
}

/// The `pw.MultiPage` body for one quiz's Help Memory: a branded header, the
/// intro, the reference table(s) (or focused [HelpMemoryTable]s + ending
/// tables), the gender rules of thumb (when collapsed by gender), and the tip
/// cards. Reads everything from [config] and the [NounSettings]/[CourseSession]
/// singletons, so it works without a live quiz page.
List<pw.Widget> buildHelpMemoryPdfBody(QuizPdfTheme pdf, QuizConfig config) {
  final strings = CourseSession.instance.strings;
  final helpIntro = config.helpMemoryIntro;
  final helpTips = config.helpMemoryTips;
  final pdfTips = <pw.Widget>[
    if (helpTips.isNotEmpty) ...[
      pw.SizedBox(height: 6),
      pdf.section(strings.tipsAndRules),
      for (final t in helpTips)
        pdf.tip(kind: t.kind, title: t.title, text: t.text),
    ],
  ];

  // Focused-table layout: one table per [HelpMemoryTable], plus any ending
  // pattern tables.
  if (config.helpMemoryTables != null) {
    final categoriesByLabel = {for (final c in config.categories) c.label: c};

    return [
      pdf.brandHeader(config.title, subtitle: strings.helpMemory),
      if (helpIntro != null) pdf.intro(helpIntro),
      for (final table in config.helpMemoryTables!) ...[
        pdf.section(table.title),
        pdf.table(
          headers: [
            config.subjectColumnLabel,
            for (final column in table.columns)
              column.displayLabel ?? column.categoryLabel,
          ],
          data: [
            for (var i = 0; i < config.subjectDisplays.length; i++)
              [
                config.subjectEnglish != null &&
                        config.subjectEnglish![i].isNotEmpty
                    ? '${config.subjectDisplays[i]}\n${config.subjectEnglish![i]}'
                    : config.subjectDisplays[i],
                for (final column in table.columns)
                  categoriesByLabel[column.categoryLabel]!.values[i],
              ],
          ],
        ),
        pw.SizedBox(height: 14),
      ],
      for (final table
          in config.endingPatternTables ?? const <EndingPatternTable>[]) ...[
        pdf.section(table.title),
        pdf.table(
          headers: [table.cornerLabel, ...table.columnLabels],
          data: [
            for (var i = 0; i < table.rowLabels.length; i++)
              [table.rowLabels[i], ...table.rows[i]],
          ],
        ),
        if (table.notes != null) ...[
          pw.SizedBox(height: 4),
          for (final note in table.notes!)
            pw.Bullet(text: note, style: pdf.bulletStyle()),
        ],
        pw.SizedBox(height: 14),
      ],
      ...pdfTips,
    ];
  }

  // Default single-table layout covering every category (plus info columns).
  // The Help Memory is a study reference, so it always shows the English
  // meaning next to the German when the quiz carries one — independent of the
  // in-quiz "Show English" toggle.
  final showEnglish = config.subjectEnglish != null;
  final genderRows = _useGenderRows(config) ? kGenderRowOrder : null;
  final rowCount = genderRows?.length ?? config.subjectDisplays.length;
  // Bilingual rows (German over English, answer bold in both) — mirrors the
  // on-screen Help Memory table. Only when the quiz carries both example forms
  // and isn't gender-collapsed.
  final bilingual = genderRows == null &&
      config.helpMemoryExample != null &&
      config.helpMemoryExampleEnglish != null;
  final infoColumns = config.helpMemoryInfoColumns;
  final headers = [
    config.subjectColumnLabel,
    ...config.categories.map((c) => c.label),
    ...infoColumns.map((c) => c.label),
  ];

  // Match the on-screen gender coloring: tint each row's value cells by gender
  // (der=blue, die=red, das=green), using the same user-set colors.
  PdfColor? rowColor(String? gender) =>
      (config.helpMemoryColorByGender && gender != null)
          ? PdfColor.fromInt(
              NounSettings.instance.colorForGender(gender).toARGB32(),
            )
          : null;

  final rows = <List<String>>[];
  final rowColors = <PdfColor?>[];
  for (var index = 0; index < rowCount; index++) {
    if (genderRows != null) {
      final gender = genderRows[index];
      final subjectIndex = config.subjectGenders!.indexOf(gender);
      rows.add([
        '${kGenderArticles[gender]} (${kGenderRowNames[gender]})',
        ...config.categories.map((c) => c.values[subjectIndex]),
        ...infoColumns.map((_) => ''),
      ]);
      rowColors.add(rowColor(gender));
    } else if (bilingual) {
      final answer = config.categories.isEmpty
          ? config.subjectDisplays[index]
          : config.categories.first.values[index];
      rows.add([
        '$answer\n${config.subjectDisplays[index]}',
        ...config.categories.map((c) {
          final german =
              config.helpMemoryExample?.call(config.subjects[index], c.label) ??
              c.values[index];
          final english = config.helpMemoryExampleEnglish?.call(
            config.subjects[index],
            c.label,
          );
          return english == null ? german : '$german\n$english';
        }),
        ...infoColumns.map((c) => c.values[index]),
      ]);
      rowColors.add(
        rowColor(
          config.subjectGenders != null
              ? config.subjectGenders![index]
              : null,
        ),
      );
    } else {
      var label = config.subjectDisplays[index];
      if (showEnglish) {
        label = '$label (${config.subjectEnglish![index]})';
      }
      rows.add([
        label,
        ...config.categories.map(
          (c) =>
              config.helpMemoryExample?.call(config.subjects[index], c.label) ??
              c.values[index],
        ),
        ...infoColumns.map((c) => c.values[index]),
      ]);
      rowColors.add(
        rowColor(
          config.subjectGenders != null
              ? config.subjectGenders![index]
              : null,
        ),
      );
    }
  }

  final columnCount = headers.length;
  final cellFontSize = columnCount > 15
      ? 7.0
      : columnCount > 7
          ? 8.0
          : 10.0;

  return [
    pdf.brandHeader(config.title, subtitle: strings.helpMemory),
    pdf.table(
      headers: headers,
      data: rows,
      fontSize: cellFontSize,
      rowColors: config.helpMemoryColorByGender ? rowColors : null,
      coloredColumns: config.categories.length,
      columnWidths: {
        for (var i = 0; i < columnCount; i++) i: const pw.FlexColumnWidth(1),
      },
    ),
    if (_useGenderRows(config)) ...[
      pw.SizedBox(height: 16),
      pdf.section('Gender rules of thumb'),
      for (final gender in kGenderRowOrder) ...[
        pw.SizedBox(height: 6),
        pw.Text(
          '${kGenderArticles[gender]} (${kGenderRowNames[gender]})',
          style: pdf.subheading(fontSize: 12),
        ),
        for (final rule in kGenderRules[gender]!)
          pw.Bullet(text: rule, style: pdf.bulletStyle(fontSize: 10)),
      ],
    ],
    ...pdfTips,
  ];
}

/// Builds and shares a single combined booklet covering [configs] — one branded
/// Help Memory section per quiz, each on its own best-fit page format. Caller
/// should ensure [configs] is non-empty.
Future<void> exportQuizzesBookletPdf(List<QuizConfig> configs) async {
  final pdf = await QuizPdfTheme.load();
  final doc = pdf.newDocument();
  for (final config in configs) {
    doc.addPage(
      pw.MultiPage(
        pageFormat: helpMemoryPageFormat(config),
        margin: const pw.EdgeInsets.all(28),
        footer: pdf.footer,
        build: (context) => buildHelpMemoryPdfBody(pdf, config),
      ),
    );
  }
  await Printing.sharePdf(
    bytes: await doc.save(),
    filename: 'all_quizzes_reference.pdf',
  );
}
