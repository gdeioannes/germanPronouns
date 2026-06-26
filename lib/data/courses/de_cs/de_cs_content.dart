import '../../../models/quiz_content.dart';
import 'de_cs_m1.dart';
import 'de_cs_m2.dart';
import 'de_cs_m3.dart';

export 'de_cs_m1.dart';
export 'de_cs_m2.dart';
export 'de_cs_m3.dart';

/// Every quiz of the "Tschechisch entdecken" intro course (Deutsch →
/// Tschechisch), in chain order across the three modules, for seeding the
/// content database.
final List<QuizContent> deCsContent = [
  ...deCsM1,
  ...deCsM2,
  ...deCsM3,
];
