import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../data/gender_reference.dart';
import '../models/app_page.dart';
import '../models/course_session.dart';
import '../models/noun_settings.dart';
import '../models/quiz_config.dart';
import '../models/quiz_content.dart';
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

  // Nouns & Articles: a compact, multi-column reference of "der Hund" entries
  // (article colored by gender) with the plural and English meaning — far
  // denser than the single wide gender-colored table.
  if (config.currentPage == AppPage.nounsArticles &&
      config.categories.isNotEmpty &&
      config.subjectGenders != null) {
    return _buildNounReferenceBody(pdf, config, helpIntro, pdfTips);
  }

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
      // The reference table may show a different first-cell label than the live
      // quiz (e.g. the Español → Alemán vocab word in both languages), carrying
      // `**…**` bold markup the table renderer already honors.
      var label =
          config.subjectReferenceLabels?[index] ?? config.subjectDisplays[index];
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

/// Compact reference body for the Nouns & Articles quiz: a three-column grid of
/// entries, each showing the article (colored by gender) right next to the
/// noun, with the plural ending appended — "der Hund, -e" — and the English
/// meaning beneath. Replaces the single full-width gender-colored table so the
/// booklet fits many more nouns per page. The grid is a [pw.Table] whose rows
/// the surrounding `pw.MultiPage` splits across pages as needed.
List<pw.Widget> _buildNounReferenceBody(
  QuizPdfTheme pdf,
  QuizConfig config,
  String? helpIntro,
  List<pw.Widget> pdfTips,
) {
  final strings = CourseSession.instance.strings;
  final articles = config.categories.first.values;
  final genders = config.subjectGenders!;
  final english = config.subjectEnglish;

  // The plural lives in the "Plural" info column as a compact ending notation
  // (e.g. "-e", "¨-er"), or the full form for irregulars; "—" means no plural.
  List<String>? plurals;
  for (final column in config.helpMemoryInfoColumns) {
    if (column.label.toLowerCase() == 'plural') {
      plurals = column.values;
      break;
    }
  }

  pw.Widget nounEntry(int i) {
    final color = PdfColor.fromInt(
      NounSettings.instance.colorForGender(genders[i]).toARGB32(),
    );
    final plural = (plurals != null && i < plurals.length) ? plurals[i] : null;
    final hasPlural = plural != null && plural.isNotEmpty && plural != '—';
    final meaning = (english != null && i < english.length) ? english[i] : null;

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.RichText(
          text: pw.TextSpan(
            children: [
              // Article carries the gender color, sitting next to the noun.
              pw.TextSpan(
                text: '${articles[i]} ',
                style: pw.TextStyle(
                  fontSize: 10.5,
                  fontWeight: pw.FontWeight.bold,
                  color: color,
                ),
              ),
              pw.TextSpan(
                text: config.subjectDisplays[i],
                style: pw.TextStyle(
                  fontSize: 10.5,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfBrandColors.inkText,
                ),
              ),
              // Plural ending appended to the noun (e.g. ", -e"), not the full
              // "die …" form, which is redundant.
              if (hasPlural)
                pw.TextSpan(
                  text: ', $plural',
                  style: pw.TextStyle(
                    fontSize: 9,
                    color: PdfBrandColors.inkMuted,
                  ),
                ),
            ],
          ),
        ),
        if (meaning != null && meaning.isNotEmpty)
          pw.Text(
            meaning,
            style: pw.TextStyle(fontSize: 8, color: PdfBrandColors.inkMuted),
          ),
      ],
    );
  }

  const columns = 3;
  final count = config.subjectDisplays.length;
  final rows = <pw.TableRow>[];
  for (var start = 0; start < count; start += columns) {
    rows.add(
      pw.TableRow(
        children: [
          for (var col = 0; col < columns; col++)
            pw.Padding(
              padding: const pw.EdgeInsets.symmetric(vertical: 3, horizontal: 4),
              child: start + col < count
                  ? nounEntry(start + col)
                  : pw.SizedBox(),
            ),
        ],
      ),
    );
  }

  return [
    pdf.brandHeader(config.title, subtitle: strings.helpMemory),
    if (helpIntro != null) pdf.intro(helpIntro),
    pw.Table(
      columnWidths: const {
        0: pw.FlexColumnWidth(1),
        1: pw.FlexColumnWidth(1),
        2: pw.FlexColumnWidth(1),
      },
      children: rows,
    ),
    pw.SizedBox(height: 12),
    ...pdfTips,
  ];
}

/// The `pw.MultiPage` body for one reading quiz: a branded header, the German
/// passage, its translation, and the comprehension questions (each with its
/// translation and the correct answer marked). Mirrors the on-screen reading
/// page so the booklet doubles as a study reference. Reads localized labels
/// from the [CourseSession] singleton, so it works without a live quiz page.
List<pw.Widget> buildReadingPdfBody(QuizPdfTheme pdf, QuizContent content) {
  final strings = CourseSession.instance.strings;
  final passageStyle = pw.TextStyle(
    fontSize: 11,
    color: PdfBrandColors.inkText,
    lineSpacing: 2,
  );
  final translationStyle = pw.TextStyle(
    fontSize: 10,
    color: PdfBrandColors.inkMuted,
    fontStyle: pw.FontStyle.italic,
    lineSpacing: 2,
  );
  final mutedSmall = pw.TextStyle(
    fontSize: 9,
    color: PdfBrandColors.inkMuted,
    fontStyle: pw.FontStyle.italic,
  );

  final widgets = <pw.Widget>[
    pdf.brandHeader(
      content.readingTitle ?? content.title,
      subtitle: strings.readingText,
    ),
  ];

  if (content.readingCategory != null) {
    widgets
      ..add(
        pw.Text(
          content.readingCategory!.toUpperCase(),
          style: pw.TextStyle(
            fontSize: 9,
            fontWeight: pw.FontWeight.bold,
            color: PdfBrandColors.terracotta,
          ),
        ),
      )
      ..add(pw.SizedBox(height: 8));
  }

  if (content.readingPassage != null) {
    widgets.add(pw.Text(content.readingPassage!, style: passageStyle));
  }

  if (content.readingPassageTranslation != null) {
    widgets
      ..add(pw.SizedBox(height: 12))
      ..add(pdf.section(strings.translation))
      ..add(pw.Text(content.readingPassageTranslation!, style: translationStyle));
  }

  if (content.readingQuestions.isNotEmpty) {
    widgets
      ..add(pw.SizedBox(height: 16))
      ..add(pdf.section(strings.readingQuestionsTitle));
    for (var i = 0; i < content.readingQuestions.length; i++) {
      final q = content.readingQuestions[i];
      final optionTranslation = q.optionsTranslation;
      widgets.add(
        pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 12),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                '${i + 1}. ${q.question}',
                style: pdf.subheading(fontSize: 11),
              ),
              if (q.questionTranslation != null)
                pw.Text(q.questionTranslation!, style: mutedSmall),
              pw.SizedBox(height: 4),
              for (var o = 0; o < q.options.length; o++)
                pw.Bullet(
                  text: optionTranslation != null &&
                          o < optionTranslation.length
                      ? '${q.options[o]}  —  ${optionTranslation[o]}'
                      : q.options[o],
                  style: pdf.cellStyle(fontSize: 10),
                ),
              pw.SizedBox(height: 2),
              pw.Text(
                '${strings.answer}: ${q.options[q.correctIndex]}',
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfBrandColors.forest,
                ),
              ),
              if (q.explanation != null) ...[
                pw.SizedBox(height: 2),
                pw.Text(q.explanation!, style: mutedSmall),
              ],
              if (q.explanationTranslation != null)
                pw.Text(q.explanationTranslation!, style: mutedSmall),
            ],
          ),
        ),
      );
    }
  }

  return widgets;
}

/// One section of the all-quizzes reference booklet ([exportQuizzesBookletPdf]):
/// either a Help-Memory quiz (reference tables, intro and tips) or a reading
/// quiz (German passage, its translation and the questions).
sealed class BookletEntry {
  const BookletEntry();
}

/// A Help-Memory quiz section of the booklet.
class HelpMemoryBookletEntry extends BookletEntry {
  const HelpMemoryBookletEntry(this.config);
  final QuizConfig config;
}

/// A reading quiz section of the booklet (passage + translation + questions).
class ReadingBookletEntry extends BookletEntry {
  const ReadingBookletEntry(this.content);
  final QuizContent content;
}

/// Builds and shares a single combined booklet covering [entries] — one branded
/// section per quiz (Help-Memory tables, or a reading passage with its
/// translation and questions), each on its own best-fit page format. Caller
/// should ensure [entries] is non-empty.
Future<void> exportQuizzesBookletPdf(List<BookletEntry> entries) async {
  final pdf = await QuizPdfTheme.load();
  final doc = pdf.newDocument();
  for (final entry in entries) {
    switch (entry) {
      case HelpMemoryBookletEntry(:final config):
        doc.addPage(
          pw.MultiPage(
            pageFormat: helpMemoryPageFormat(config),
            margin: const pw.EdgeInsets.all(28),
            footer: pdf.footer,
            build: (context) => buildHelpMemoryPdfBody(pdf, config),
          ),
        );
      case ReadingBookletEntry(:final content):
        doc.addPage(
          pw.MultiPage(
            pageFormat: PdfPageFormat.a4,
            margin: const pw.EdgeInsets.all(28),
            footer: pdf.footer,
            build: (context) => buildReadingPdfBody(pdf, content),
          ),
        );
    }
  }
  await Printing.sharePdf(
    bytes: await doc.save(),
    filename: 'all_quizzes_reference.pdf',
  );
}
