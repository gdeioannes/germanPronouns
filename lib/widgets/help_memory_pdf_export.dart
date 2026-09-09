import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../data/quiz_content_adapter.dart';
import '../models/app_page.dart';
import '../models/course_session.dart';
import '../models/quiz_config.dart';
import '../models/quiz_content.dart';
import '../services/analytics.dart';
import '../theme/help_memory_pdf.dart';
import '../theme/pdf_theme.dart';

/// Builds a PDF of the quiz's Help Memory reference (and, for the Artikel quiz,
/// the gender rules below it) and saves/shares it directly as a PDF file (no
/// print dialog). Extracted from `quiz_page.dart`'s `_exportHelpMemoryPdf` so
/// the monolith no longer pulls in the PDF/printing packages directly.
Future<void> exportHelpMemoryPdf(QuizConfig config) async {
  Analytics.track('help_memory_pdf', {
    'course': CourseSession.instance.activeCourse.id,
    'quiz': config.contentId ?? config.storageKeyPrefix,
  });
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

/// Saves/shares the Help Memory PDF for [content], picking the right layout
/// by quiz kind: a speaking quiz gets its full study page (intro, tips,
/// MATERIAL, practise points, vocabulary); everything else goes through the
/// regular config-driven reference layout.
Future<void> exportQuizHelpPdf(QuizContent content) async {
  if (content.kind == QuizKind.speaking) {
    Analytics.track('help_memory_pdf', {
      'course': CourseSession.instance.activeCourse.id,
      'quiz': content.id,
    });
    final pdf = await QuizPdfTheme.load();
    final doc = pdf.newDocument();
    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(28),
        footer: pdf.footer,
        build: (context) => buildSpeakingHelpPdfBody(pdf, content),
      ),
    );
    await Printing.sharePdf(
      bytes: await doc.save(),
      filename: '${content.storageKeyPrefix}help_memory.pdf',
    );
    return;
  }
  await exportHelpMemoryPdf(
    buildQuizConfigFromContent(content, currentPage: AppPage.articles),
  );
}
