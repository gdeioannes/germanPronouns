import 'dart:math' as math;

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../data/exercise_sheet_builder.dart';
import '../models/course_session.dart';
import '../services/analytics.dart';
import 'pdf_theme.dart';

/// The printable exercise worksheet: numbered exercises with room to answer by
/// hand on the left, and every answer printed beside its exercise in a narrow
/// column on the right — separated by a dashed fold line, so the learner folds
/// the answers away while writing and unfolds to self-check.
///
/// Data comes from `buildExerciseSheet` (data/exercise_sheet_builder.dart);
/// branding from the shared [QuizPdfTheme].

/// Share of the paper width given to the fold-away answer column (fold line
/// position). The remaining right-hand strip holds the answers.
const double _kFoldFraction = 0.78;

/// Builds and shares the worksheet PDF. [scope] prints (localized) in the
/// subtitle; [requestedSize] is the size the learner picked in the dialog
/// (null = "all"), reported to analytics alongside the actual exercise count.
/// Caller ensures [sections] is non-empty.
Future<void> exportExerciseSheetPdf(
  List<ExerciseSection> sections, {
  required ExerciseScope scope,
  int? requestedSize,
}) async {
  final strings = CourseSession.instance.strings;
  final scopeLabel = switch (scope) {
    ExerciseScope.fullCourse => strings.exerciseScopeFull,
    ExerciseScope.achieved => strings.exerciseScopeAchieved,
    ExerciseScope.weakSpots => strings.exerciseScopeWeak,
  };
  final pdf = await QuizPdfTheme.load();
  final doc = pdf.newDocument();

  const format = PdfPageFormat.a4;
  const marginLeft = 32.0, marginRight = 24.0;
  const marginTop = 34.0, marginBottom = 34.0;
  final foldX = format.width * _kFoldFraction;
  final contentWidth = format.width - marginLeft - marginRight;
  final questionWidth = foldX - marginLeft - 10;
  final answerWidth = format.width - marginRight - foldX - 8;
  final spacerWidth = contentWidth - questionWidth - answerWidth;

  // ── Shared styles ──────────────────────────────────────────────────────
  // Generous line spacing leaves handwriting room inside cloze sentences.
  final promptStyle = pdf.cellStyle(fontSize: 10.5).copyWith(lineSpacing: 7);
  final numberStyle = pw.TextStyle(
    fontSize: 10.5,
    fontWeight: pw.FontWeight.bold,
    fontFallback: pdf.boldFallback,
    color: PdfBrandColors.navy,
  );
  final contextStyle = pw.TextStyle(
    fontSize: 8.5,
    fontStyle: pw.FontStyle.italic,
    color: PdfBrandColors.inkMuted,
  );
  final optionStyle = pdf.cellStyle(fontSize: 9.5);
  final answerNumberStyle = pw.TextStyle(
    fontSize: 8,
    color: PdfBrandColors.inkMuted,
  );
  final answerStyle = pw.TextStyle(
    fontSize: 9,
    fontWeight: pw.FontWeight.bold,
    fontFallback: pdf.boldFallback,
    color: PdfBrandColors.forest,
  );
  final answerLabelStyle = pw.TextStyle(
    fontSize: 6.5,
    color: PdfBrandColors.inkMuted,
  );

  // ── Layout helpers ─────────────────────────────────────────────────────

  /// One worksheet line: the exercise on the left of the fold, its answer
  /// aligned beside it on the right.
  pw.Widget line(pw.Widget question, pw.Widget answer, {double bottom = 12}) =>
      pw.Padding(
        padding: pw.EdgeInsets.only(bottom: bottom),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.SizedBox(width: questionWidth, child: question),
            pw.SizedBox(width: spacerWidth),
            pw.SizedBox(width: answerWidth, child: answer),
          ],
        ),
      );

  /// A widget confined to the question area, with the answer column empty.
  pw.Widget leftOnly(pw.Widget question, {double bottom = 12}) =>
      line(question, pw.SizedBox(), bottom: bottom);

  pw.Widget answerCell(int number, String answer, {String? label}) =>
      pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.RichText(
            text: pw.TextSpan(
              children: [
                pw.TextSpan(text: '$number. ', style: answerNumberStyle),
                pw.TextSpan(text: answer, style: answerStyle),
              ],
            ),
          ),
          if (label != null && label.length <= 28)
            pw.Text(label, style: answerLabelStyle),
        ],
      );

  /// A handwriting blank sized to its answer.
  String blankFor(String answer) => '_' * (answer.length + 6).clamp(10, 26);

  pw.Widget numberedText(int number, String text, {pw.TextStyle? style}) =>
      pw.RichText(
        text: pw.TextSpan(
          children: [
            pw.TextSpan(text: '$number.  ', style: numberStyle),
            pw.TextSpan(text: text, style: style ?? promptStyle),
          ],
        ),
      );

  pw.Widget clozeQuestion(int number, ExerciseItem item) {
    final sentence = item.prompt.replaceAll(
      RegExp('_{2,}'),
      blankFor(item.answer),
    );
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        if (item.secondary != null && item.secondary!.isNotEmpty) ...[
          pw.Padding(
            padding: const pw.EdgeInsets.only(left: 14, bottom: 1),
            child: pw.Text(item.secondary!, style: contextStyle),
          ),
        ],
        numberedText(number, sentence),
      ],
    );
  }

  pw.Widget choiceQuestion(int number, ExerciseItem item) => pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      numberedText(number, item.prompt),
      pw.SizedBox(height: 4),
      for (var o = 0; o < item.options.length; o++)
        pw.Padding(
          padding: const pw.EdgeInsets.only(left: 14, bottom: 3),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Container(
                width: 8,
                height: 8,
                margin: const pw.EdgeInsets.only(top: 1.5),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(
                    color: PdfBrandColors.inkMuted,
                    width: 0.7,
                  ),
                ),
              ),
              pw.SizedBox(width: 5),
              pw.Expanded(
                child: pw.Text(
                  '${String.fromCharCode(0x61 + o)})  ${item.options[o]}',
                  style: optionStyle,
                ),
              ),
            ],
          ),
        ),
    ],
  );

  pw.Widget writingQuestion(int number, ExerciseItem item) => pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      numberedText(number, item.prompt, style: pdf.cellStyle(fontSize: 10.5)),
      pw.SizedBox(height: 4),
      pw.Padding(
        padding: const pw.EdgeInsets.only(left: 14),
        child: pw.Row(
          children: [
            for (var b = 0; b < 4; b++)
              pw.Container(
                width: 24,
                height: 24,
                margin: const pw.EdgeInsets.only(right: 6),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(
                    color: PdfBrandColors.outline,
                    width: 0.8,
                  ),
                ),
              ),
          ],
        ),
      ),
    ],
  );

  pw.Widget passageBox(String passage) => pw.Container(
    padding: const pw.EdgeInsets.all(10),
    margin: const pw.EdgeInsets.only(bottom: 10),
    decoration: pw.BoxDecoration(
      color: PdfBrandColors.paperMid,
      border: pw.Border.all(color: PdfBrandColors.outline, width: 0.5),
    ),
    child: pw.Text(
      passage,
      style: pdf.cellStyle(fontSize: 10).copyWith(lineSpacing: 3),
    ),
  );

  // ── Document body ──────────────────────────────────────────────────────
  final count = sections.fold<int>(0, (n, s) => n + s.items.length);
  final now = DateTime.now();
  final date =
      '${now.year}-${now.month.toString().padLeft(2, '0')}-'
      '${now.day.toString().padLeft(2, '0')}';

  final widgets = <pw.Widget>[
    pdf.brandHeader(
      strings.exerciseSheetTitle,
      subtitle: '$scopeLabel  ·  $count ${strings.exercisesWord}  ·  $date',
    ),
    line(
      pw.Text(
        '${strings.nameLabel}: ________________________        '
        '${strings.dateLabel}: ______________',
        style: pdf.cellStyle(fontSize: 10),
      ),
      pw.Text(
        strings.answersColumn,
        style: pw.TextStyle(
          fontSize: 9,
          fontWeight: pw.FontWeight.bold,
          fontFallback: pdf.boldFallback,
          color: PdfBrandColors.navy,
        ),
      ),
      bottom: 10,
    ),
    leftOnly(
      pdf.tip(
        kind: 'rule',
        title: strings.exerciseFoldTitle,
        text: strings.exerciseFoldBody,
      ),
      bottom: 8,
    ),
  ];

  var number = 0;
  for (final section in sections) {
    widgets.add(
      leftOnly(
        pw.Padding(
          padding: const pw.EdgeInsets.only(top: 8),
          child: pdf.section(section.quizTitle),
        ),
        bottom: 2,
      ),
    );

    switch (section.kind) {
      case ExerciseSectionKind.cloze:
        for (final item in section.items) {
          number++;
          widgets.add(
            line(
              clozeQuestion(number, item),
              answerCell(number, item.answer, label: item.categoryLabel),
            ),
          );
        }
      case ExerciseSectionKind.reading:
        if (section.passage != null) {
          widgets.add(leftOnly(passageBox(section.passage!), bottom: 4));
        }
        for (final item in section.items) {
          number++;
          widgets.add(
            line(choiceQuestion(number, item), answerCell(number, item.answer)),
          );
        }
      case ExerciseSectionKind.inlineCloze:
        // Number the blanks, substitute them into the passage, and print the
        // whole passage with its answers stacked beside it.
        final firstNumber = number + 1;
        final numbered = section.passage!.replaceAllMapped(
          RegExp(r'\{\{(\d+)\}\}'),
          (m) {
            final i = int.parse(m.group(1)!);
            final item = i < section.items.length ? section.items[i] : null;
            final blank = blankFor(item?.answer ?? '');
            return '$blank(${firstNumber + i})';
          },
        );
        number += section.items.length;
        final choiceLines = <String>[
          for (var i = 0; i < section.items.length; i++)
            if (section.items[i].options.isNotEmpty ||
                section.items[i].prompt.isNotEmpty)
              '${firstNumber + i}.  '
                  '${section.items[i].prompt.isNotEmpty ? '${section.items[i].prompt}  ' : ''}'
                  '${section.items[i].options.isNotEmpty ? '( ${section.items[i].options.join('  /  ')} )' : ''}',
        ];
        widgets.add(
          line(
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  numbered,
                  style: pdf.cellStyle(fontSize: 10.5).copyWith(lineSpacing: 7),
                ),
                if (choiceLines.isNotEmpty) pw.SizedBox(height: 6),
                for (final l in choiceLines)
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: 2),
                    child: pw.Text(l, style: contextStyle),
                  ),
              ],
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < section.items.length; i++)
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: 3),
                    child: answerCell(
                      firstNumber + i,
                      section.items[i].answer,
                    ),
                  ),
              ],
            ),
          ),
        );
      case ExerciseSectionKind.writing:
        for (final item in section.items) {
          number++;
          widgets.add(
            line(
              writingQuestion(number, item),
              pw.RichText(
                text: pw.TextSpan(
                  children: [
                    pw.TextSpan(text: '$number. ', style: answerNumberStyle),
                    pw.TextSpan(
                      text: item.answer,
                      style: answerStyle.copyWith(fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
    }
  }

  // ── Page chrome: dashed fold line + rotated label on every page ───────
  final foldLabel =
      '${strings.answersColumn}  ·  ${strings.foldHere}'.toUpperCase();

  pw.Widget buildBackground(pw.Context context) => pw.FullPage(
    ignoreMargins: true,
    child: pw.Stack(
      children: [
        pw.CustomPaint(
          size: PdfPoint(format.width, format.height),
          painter: (PdfGraphics canvas, PdfPoint size) {
            canvas
              ..setStrokeColor(PdfBrandColors.inkMuted)
              ..setLineWidth(0.7)
              ..setLineDashPattern(<int>[4, 4], 0)
              ..moveTo(foldX, 14)
              ..lineTo(foldX, size.y - 14)
              ..strokePath();
          },
        ),
        // The fold hint sits in the empty gutter *left* of the line — clear of
        // the answer column, and still visible once the page is folded —
        // centered vertically along the crease.
        pw.Positioned(
          left: foldX - 8,
          top: 0,
          child: pw.SizedBox(
            height: format.height,
            child: pw.Center(
              child: pw.Transform.rotateBox(
                angle: -math.pi / 2,
                child: pw.Text(
                  foldLabel,
                  style: pw.TextStyle(
                    fontSize: 4.5,
                    color: PdfBrandColors.inkMuted,
                    letterSpacing: 1.4,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );

  doc.addPage(
    pw.MultiPage(
      pageTheme: pw.PageTheme(
        pageFormat: format,
        margin: const pw.EdgeInsets.fromLTRB(
          marginLeft,
          marginTop,
          marginRight,
          marginBottom,
        ),
        buildBackground: buildBackground,
      ),
      // Page number stays left of the fold so it survives the fold-away.
      footer: (context) => pw.Container(
        width: questionWidth,
        alignment: pw.Alignment.centerRight,
        margin: const pw.EdgeInsets.only(top: 10),
        child: pw.Text(
          '${CourseSession.instance.activeCourse.name}      '
          '${context.pageNumber} / ${context.pagesCount}',
          style: const pw.TextStyle(
            fontSize: 8,
            color: PdfBrandColors.inkMuted,
          ),
        ),
      ),
      build: (context) => widgets,
    ),
  );

  Analytics.track('exercise_pdf', {
    'course': CourseSession.instance.activeCourse.id,
    'scope': scope.name,
    'size': requestedSize?.toString() ?? 'all',
    'count': count,
  });
  await Printing.sharePdf(
    bytes: await doc.save(),
    filename: 'exercise_worksheet.pdf',
  );
}
