import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'brand_palette.dart';

/// Brand palette for generated PDFs, derived from the shared [brand_palette]
/// (the same ints the on-screen theme uses), so printed output matches the app.
/// To recolor, edit `brand_palette.dart` — both the app and its PDFs follow.
class PdfBrandColors {
  const PdfBrandColors._();

  static const navy = PdfColor.fromInt(kBrandNavy);
  static const terracotta = PdfColor.fromInt(kBrandTerracotta);
  static const forest = PdfColor.fromInt(kBrandForest);
  static const ochre = PdfColor.fromInt(kBrandOchre);
  static const paper = PdfColor.fromInt(kBrandPaper);
  static const paperLow = PdfColor.fromInt(kBrandPaperLow);
  static const paperMid = PdfColor.fromInt(kBrandPaperMid);
  static const inkText = PdfColor.fromInt(kBrandInkText);
  static const inkMuted = PdfColor.fromInt(kBrandInkMuted);
  static const outline = PdfColor.fromInt(kBrandOutline);
}

/// Centralized PDF styling that mirrors the app's identity: Source Serif 4
/// headings + Inter body (the same pairing as the UI), ink-navy on warm paper,
/// a terracotta accent, and the QuizLogo brand mark.
///
/// One place to change the look of every PDF: load once with [load], then build
/// documents from [newDocument], [brandHeader], [footer] and [table], using the
/// shared text-style getters. To restyle, edit this file (and [PdfBrandColors]).
class QuizPdfTheme {
  QuizPdfTheme._(this._serif, this._serifBold, this._theme, this._logoSvg);

  final pw.Font _serif;
  final pw.Font _serifBold;
  final pw.ThemeData _theme;
  final String? _logoSvg;

  /// The square brand mark shown in the drawer header, reused on PDFs.
  static const String _logoAsset = 'assets/icons/QuizLogo-02.svg';

  /// Loads the brand fonts (Inter body + Source Serif 4 headings, matching the
  /// app) and the logo. Call once per export.
  static Future<QuizPdfTheme> load() async {
    final inter = await PdfGoogleFonts.interRegular();
    final interBold = await PdfGoogleFonts.interBold();
    final interItalic = await PdfGoogleFonts.interItalic();
    final serif = await PdfGoogleFonts.sourceSerif4Regular();
    final serifBold = await PdfGoogleFonts.sourceSerif4Bold();
    String? logoSvg;
    try {
      logoSvg = await rootBundle.loadString(_logoAsset);
    } catch (_) {
      logoSvg = null; // Export still works without the mark.
    }
    final theme = pw.ThemeData.withFont(
      base: inter,
      bold: interBold,
      italic: interItalic,
    );
    return QuizPdfTheme._(serif, serifBold, theme, logoSvg);
  }

  /// A new document pre-set with the Inter base theme.
  pw.Document newDocument() => pw.Document(theme: _theme);

  // ── Shared text styles ─────────────────────────────────────────────────

  pw.TextStyle get documentTitle =>
      pw.TextStyle(font: _serifBold, fontSize: 22, color: PdfBrandColors.navy);

  pw.TextStyle get sectionHeading =>
      pw.TextStyle(font: _serifBold, fontSize: 13, color: PdfBrandColors.navy);

  pw.TextStyle subheading({double fontSize = 11}) => pw.TextStyle(
        font: _serifBold,
        fontSize: fontSize,
        color: PdfBrandColors.inkText,
      );

  pw.TextStyle tableHeaderStyle({double fontSize = 10}) => pw.TextStyle(
        fontSize: fontSize,
        fontWeight: pw.FontWeight.bold,
        color: PdfColors.white,
      );

  pw.TextStyle cellStyle({double fontSize = 10}) =>
      pw.TextStyle(fontSize: fontSize, color: PdfBrandColors.inkText);

  pw.TextStyle bulletStyle({double fontSize = 9}) =>
      pw.TextStyle(fontSize: fontSize, color: PdfBrandColors.inkMuted);

  // ── Reusable branded widgets ───────────────────────────────────────────

  /// A section heading with a small leading terracotta tick, matching the
  /// app's "stamp" accents.
  pw.Widget section(String title) => pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 6),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Container(
              width: 4,
              height: 14,
              margin: const pw.EdgeInsets.only(right: 6),
              color: PdfBrandColors.terracotta,
            ),
            pw.Text(title, style: sectionHeading),
          ],
        ),
      );

  /// Branded page header: the logo + wordmark, the document [title] (and
  /// optional [subtitle]), and a terracotta accent divider.
  pw.Widget brandHeader(String title, {String? subtitle}) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            if (_logoSvg != null) ...[
              pw.SvgImage(svg: _logoSvg, width: 32, height: 32),
              pw.SizedBox(width: 10),
            ],
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'German Grammar',
                  style: pw.TextStyle(
                    font: _serifBold,
                    fontSize: 13,
                    color: PdfBrandColors.navy,
                  ),
                ),
                pw.Text(
                  'der · die · das',
                  style: pw.TextStyle(
                    font: _serif,
                    fontSize: 9,
                    color: PdfBrandColors.inkMuted,
                  ),
                ),
              ],
            ),
          ],
        ),
        pw.SizedBox(height: 12),
        pw.Text(title, style: documentTitle),
        if (subtitle != null) ...[
          pw.SizedBox(height: 2),
          pw.Text(
            subtitle,
            style: pw.TextStyle(
              font: _serif,
              fontSize: 11,
              color: PdfBrandColors.inkMuted,
            ),
          ),
        ],
        pw.SizedBox(height: 6),
        pw.Container(height: 2, color: PdfBrandColors.terracotta),
        pw.SizedBox(height: 14),
      ],
    );
  }

  /// Branded page footer for `pw.MultiPage.footer`: wordmark + page number.
  pw.Widget footer(pw.Context context) {
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      margin: const pw.EdgeInsets.only(top: 10),
      child: pw.Text(
        'German Grammar · der · die · das      '
        '${context.pageNumber} / ${context.pagesCount}',
        style: pw.TextStyle(
          font: _serif,
          fontSize: 8,
          color: PdfBrandColors.inkMuted,
        ),
      ),
    );
  }

  /// A branded data table: navy header row with white text, subtle paper
  /// row-striping, and light outline borders.
  pw.Widget table({
    required List<String> headers,
    required List<List<String>> data,
    double fontSize = 10,
    Map<int, pw.TableColumnWidth>? columnWidths,
  }) {
    return pw.TableHelper.fromTextArray(
      headers: headers,
      data: data,
      border: pw.TableBorder.all(color: PdfBrandColors.outline, width: 0.5),
      headerStyle: tableHeaderStyle(fontSize: fontSize),
      headerDecoration: const pw.BoxDecoration(color: PdfBrandColors.navy),
      cellStyle: cellStyle(fontSize: fontSize),
      oddRowDecoration: const pw.BoxDecoration(color: PdfBrandColors.paperMid),
      cellAlignment: pw.Alignment.centerLeft,
      cellPadding: const pw.EdgeInsets.symmetric(horizontal: 5, vertical: 4),
      columnWidths: columnWidths,
    );
  }
}
