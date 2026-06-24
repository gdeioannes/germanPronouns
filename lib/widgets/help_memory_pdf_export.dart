import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../models/quiz_config.dart';
import '../theme/help_memory_pdf.dart';
import '../theme/pdf_theme.dart';

/// Builds a PDF of the quiz's Help Memory reference (and, for the Artikel quiz,
/// the gender rules below it) and saves/shares it directly as a PDF file (no
/// print dialog). Extracted from `quiz_page.dart`'s `_exportHelpMemoryPdf` so
/// the monolith no longer pulls in the PDF/printing packages directly.
Future<void> exportHelpMemoryPdf(QuizConfig config) async {
  final pdf = await QuizPdfTheme.load();
  final doc = pdf.newDocument();
  doc.addPage(
    pw.MultiPage(
      pageFormat: helpMemoryPageFormat(config),
      margin: const pw.EdgeInsets.all(28),
      footer: pdf.footer,
      build: (context) => buildHelpMemoryPdfBody(pdf, config),
    ),
  );
  await Printing.sharePdf(
    bytes: await doc.save(),
    filename: '${config.storageKeyPrefix}help_memory.pdf',
  );
}
