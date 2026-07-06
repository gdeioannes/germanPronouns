import 'dart:math' as math;

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../data/exercise_sheet_builder.dart';
import '../models/course_session.dart';
import '../services/analytics.dart';
import 'pdf_theme.dart';

/// The printable exercise worksheet: numbered exercises with room to answer by
/// hand, and the answers printed where the learner chose — beside each
/// exercise in a fold-away column, grouped at the end of every page, or
/// collected in one answer key at the end of the document.
///
/// Data comes from `buildExerciseSheet` (data/exercise_sheet_builder.dart);
/// branding from the shared [QuizPdfTheme].

/// Where the answers print on the worksheet.
enum ExerciseAnswerPlacement {
  /// Beside each exercise in the fold-away right column (the classic sheet).
  side,

  /// Grouped in a small key at the end of every page.
  pageEnd,

  /// Collected in one answer key on the final page(s).
  documentEnd,
}

/// Share of the paper width given to the fold-away answer column (fold line
/// position). The remaining right-hand strip holds the answers.
const double _kFoldFraction = 0.78;

/// One entry of a grouped answer key (pageEnd / documentEnd placements).
typedef _AnswerEntry = ({int number, String answer, String? label});

/// A worksheet fragment plus what the pageEnd paginator needs to know about
/// it: its estimated height and the answers it contributes to the page key.
class _Piece {
  _Piece(
    this.widget, {
    this.height = 0,
    this.answers = const [],
    this.keepWithNext = false,
  });

  final pw.Widget widget;
  final double height;
  final List<_AnswerEntry> answers;

  /// Section headers and reading passages must not be stranded as the last
  /// thing on a page — they travel with the following exercise.
  final bool keepWithNext;
}

/// Builds and shares the worksheet PDF. [scope] prints (localized) in the
/// subtitle; [requestedSize] is the size the learner picked in the dialog
/// (null = "all"); [placement] is where the answers go — all three are
/// reported to analytics alongside the actual exercise count.
/// Caller ensures [sections] is non-empty.
Future<void> exportExerciseSheetPdf(
  List<ExerciseSection> sections, {
  required ExerciseScope scope,
  ExerciseAnswerPlacement placement = ExerciseAnswerPlacement.side,
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

  final side = placement == ExerciseAnswerPlacement.side;
  const format = PdfPageFormat.a4;
  const marginLeft = 32.0, marginRight = 24.0;
  const marginTop = 34.0, marginBottom = 34.0;
  final foldX = format.width * _kFoldFraction;
  final contentWidth = format.width - marginLeft - marginRight;
  final questionWidth = side ? foldX - marginLeft - 10 : contentWidth;
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
  /// aligned beside it on the right (side placement only).
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

  /// A question-only fragment: confined left of the fold when the sheet has
  /// an answer column, full width otherwise.
  pw.Widget only(pw.Widget question, {double bottom = 12}) => side
      ? line(question, pw.SizedBox(), bottom: bottom)
      : pw.Padding(
          padding: pw.EdgeInsets.only(bottom: bottom),
          child: question,
        );

  final cjk = RegExp(r'[⺀-鿿豈-﫿]');

  pw.Widget answerCell(int number, String answer, {String? label}) =>
      pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.RichText(
            text: pw.TextSpan(
              children: [
                pw.TextSpan(text: '$number. ', style: answerNumberStyle),
                pw.TextSpan(
                  text: answer,
                  // Hanzi answers need more size to stay legible in a key.
                  style: cjk.hasMatch(answer)
                      ? answerStyle.copyWith(fontSize: 13)
                      : answerStyle,
                ),
              ],
            ),
          ),
          if (label != null && label.length <= 28)
            pw.Text(label, style: answerLabelStyle),
        ],
      );

  /// The grouped answer key as independent 4-column rows, so the document-end
  /// key flows across pages instead of overflowing as one block.
  List<pw.Widget> answerRows(List<_AnswerEntry> entries) => [
    for (var i = 0; i < entries.length; i += 4)
      pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 5),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            for (var j = i; j < i + 4; j++)
              pw.Expanded(
                child: j < entries.length
                    ? pw.Padding(
                        padding: const pw.EdgeInsets.only(right: 8),
                        child: answerCell(
                          entries[j].number,
                          entries[j].answer,
                          label: entries[j].label,
                        ),
                      )
                    : pw.SizedBox(),
              ),
          ],
        ),
      ),
  ];

  /// The end-of-page answers box (pageEnd placement).
  pw.Widget answersBox(List<_AnswerEntry> entries) => pw.Container(
    margin: const pw.EdgeInsets.only(top: 4, bottom: 8),
    padding: const pw.EdgeInsets.fromLTRB(10, 8, 10, 3),
    decoration: pw.BoxDecoration(
      color: PdfBrandColors.paperMid,
      border: pw.Border.all(color: PdfBrandColors.outline, width: 0.5),
    ),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          strings.answersColumn.toUpperCase(),
          style: pw.TextStyle(
            fontSize: 7,
            fontWeight: pw.FontWeight.bold,
            fontFallback: pdf.boldFallback,
            letterSpacing: 1.2,
            color: PdfBrandColors.navy,
          ),
        ),
        pw.SizedBox(height: 5),
        ...answerRows(entries),
      ],
    ),
  );

  /// A handwriting blank sized to its answer.
  String blankFor(String answer) => '_' * (answer.length + 6).clamp(10, 26);

  /// Rough wrapped-line count for the pageEnd paginator: average glyph width
  /// ~0.52 em for latin scripts, a full em for CJK.
  double textLines(String text, double width, double fontSize) {
    var lines = 0.0;
    for (final seg in text.split('\n')) {
      var w = 0.0;
      for (final r in seg.runes) {
        w += r > 0x2e7f ? fontSize : fontSize * 0.52;
      }
      lines += math.max(1, (w / width).ceil());
    }
    return lines;
  }

  pw.Widget numberedText(int number, String text, {pw.TextStyle? style}) =>
      pw.RichText(
        text: pw.TextSpan(
          children: [
            pw.TextSpan(text: '$number.  ', style: numberStyle),
            pw.TextSpan(text: text, style: style ?? promptStyle),
          ],
        ),
      );

  pw.Widget clozeQuestion(int number, ExerciseItem item, String sentence) =>
      pw.Column(
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

  final nameLine = pw.Text(
    '${strings.nameLabel}: ________________________        '
    '${strings.dateLabel}: ______________',
    style: pdf.cellStyle(fontSize: 10),
  );
  final widgets = <pw.Widget>[
    pdf.brandHeader(
      strings.exerciseSheetTitle,
      subtitle: '$scopeLabel  ·  $count ${strings.exercisesWord}  ·  $date',
    ),
    if (side)
      line(
        nameLine,
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
      )
    else
      only(nameLine, bottom: 10),
    if (side)
      only(
        pdf.tip(
          kind: 'rule',
          title: strings.exerciseFoldTitle,
          text: strings.exerciseFoldBody,
        ),
        bottom: 8,
      ),
  ];

  // Every exercise becomes a _Piece; the assembly step below decides whether
  // pieces just concatenate (side / documentEnd) or get paginated with an
  // answers box per page (pageEnd).
  final pieces = <_Piece>[];
  const lineH = 17.5; // 10.5pt prompt + 7pt handwriting line spacing
  var number = 0;
  for (final section in sections) {
    pieces.add(
      _Piece(
        only(
          pw.Padding(
            padding: const pw.EdgeInsets.only(top: 8),
            child: pdf.section(section.quizTitle),
          ),
          bottom: 2,
        ),
        height: 32,
        keepWithNext: true,
      ),
    );

    switch (section.kind) {
      case ExerciseSectionKind.cloze:
        for (final item in section.items) {
          number++;
          final sentence = item.prompt.replaceAll(
            RegExp('_{2,}'),
            blankFor(item.answer),
          );
          final entry = (
            number: number,
            answer: item.answer,
            label: item.categoryLabel,
          );
          final question = clozeQuestion(number, item, sentence);
          pieces.add(
            _Piece(
              side
                  ? line(
                      question,
                      answerCell(number, item.answer, label: item.categoryLabel),
                    )
                  : only(question),
              height:
                  (item.secondary?.isNotEmpty ?? false ? 12 : 0) +
                  textLines(sentence, questionWidth - 20, 10.5) * lineH +
                  12,
              answers: [entry],
            ),
          );
        }
      case ExerciseSectionKind.reading:
        if (section.passage != null) {
          pieces.add(
            _Piece(
              only(passageBox(section.passage!), bottom: 4),
              height:
                  textLines(section.passage!, questionWidth - 20, 10) * 13 + 34,
              keepWithNext: true,
            ),
          );
        }
        for (final item in section.items) {
          number++;
          final entry = (number: number, answer: item.answer, label: null);
          final question = choiceQuestion(number, item);
          var height =
              textLines(item.prompt, questionWidth - 20, 10.5) * lineH + 16;
          for (final o in item.options) {
            height += textLines(o, questionWidth - 46, 9.5) * 12 + 3;
          }
          pieces.add(
            _Piece(
              side
                  ? line(question, answerCell(number, item.answer))
                  : only(question),
              height: height,
              answers: [entry],
            ),
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
        final question = pw.Column(
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
        );
        var height = textLines(numbered, questionWidth, 10.5) * lineH + 18;
        for (final l in choiceLines) {
          height += textLines(l, questionWidth, 8.5) * 11 + 2;
        }
        pieces.add(
          _Piece(
            side
                ? line(
                    question,
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
                  )
                : only(question),
            height: height,
            answers: [
              for (var i = 0; i < section.items.length; i++)
                (
                  number: firstNumber + i,
                  answer: section.items[i].answer,
                  label: null,
                ),
            ],
          ),
        );
      case ExerciseSectionKind.writing:
        for (final item in section.items) {
          number++;
          final entry = (number: number, answer: item.answer, label: null);
          pieces.add(
            _Piece(
              side
                  ? line(
                      writingQuestion(number, item),
                      pw.RichText(
                        text: pw.TextSpan(
                          children: [
                            pw.TextSpan(
                              text: '$number. ',
                              style: answerNumberStyle,
                            ),
                            pw.TextSpan(
                              text: item.answer,
                              style: answerStyle.copyWith(fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    )
                  : only(writingQuestion(number, item)),
              height: 58,
              answers: [entry],
            ),
          );
        }
    }
  }

  // ── Assembly per placement ─────────────────────────────────────────────
  switch (placement) {
    case ExerciseAnswerPlacement.side:
      widgets.addAll(pieces.map((p) => p.widget));
    case ExerciseAnswerPlacement.documentEnd:
      widgets.addAll(pieces.map((p) => p.widget));
      widgets.add(pw.NewPage());
      widgets.add(
        pw.Padding(
          padding: const pw.EdgeInsets.only(top: 8, bottom: 6),
          child: pdf.section(strings.answerKeyTitle),
        ),
      );
      widgets.addAll(
        answerRows([for (final p in pieces) ...p.answers]),
      );
    case ExerciseAnswerPlacement.pageEnd:
      // Greedy pagination on estimated heights: fill a page, close it with
      // its answers box, break. Estimates run conservative on purpose — if
      // one is off, MultiPage just flows the box to the next page, keeping
      // it right after its exercises.
      const pageBudget = 730.0; // A4 height minus margins and footer
      double boxHeight(int n) => n == 0 ? 0 : 34 + ((n + 3) ~/ 4) * 17.0;

      var pageUsed = 100.0; // brand header + name line on the first page
      var pageHasItems = false;
      var pending = <_AnswerEntry>[];
      var held = <_Piece>[];
      for (final piece in pieces) {
        if (piece.keepWithNext) {
          held.add(piece);
          continue;
        }
        final group = [...held, piece];
        held = [];
        final groupHeight = group.fold(0.0, (s, p) => s + p.height);
        final answersAfter = pending.length + piece.answers.length;
        if (pageHasItems &&
            pageUsed + groupHeight + boxHeight(answersAfter) > pageBudget) {
          widgets.add(answersBox(pending));
          widgets.add(pw.NewPage());
          pending = [];
          pageUsed = 0;
          pageHasItems = false;
        }
        widgets.addAll(group.map((p) => p.widget));
        pending.addAll(piece.answers);
        pageUsed += groupHeight;
        pageHasItems = true;
      }
      widgets.addAll(held.map((p) => p.widget));
      if (pending.isNotEmpty) widgets.add(answersBox(pending));
  }

  // ── Page chrome: dashed fold line + rotated label on every page ───────
  // (side placement only — the other placements use the full page width)
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
      maxPages: 400,
      pageTheme: pw.PageTheme(
        pageFormat: format,
        margin: const pw.EdgeInsets.fromLTRB(
          marginLeft,
          marginTop,
          marginRight,
          marginBottom,
        ),
        buildBackground: side ? buildBackground : null,
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
    'answers': placement.name,
    'count': count,
  });
  await Printing.sharePdf(
    bytes: await doc.save(),
    filename: 'exercise_worksheet.pdf',
  );
}
