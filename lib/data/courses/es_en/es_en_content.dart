import '../../../models/quiz_content.dart';
import 'es_en_a1_1.dart';
import 'es_en_a1_2.dart';
import 'es_en_a2_1.dart';
import 'es_en_a2_2.dart';
import 'es_en_b1_1.dart';
import 'es_en_b1_2.dart';
import 'es_en_b2_1.dart';
import 'es_en_b2_2.dart';
import 'es_en_c1_1.dart';
import 'es_en_c1_2.dart';
import 'es_en_c2_1.dart';
import 'es_en_c2_2.dart';

export 'es_en_a1_1.dart';
export 'es_en_a1_2.dart';
export 'es_en_a2_1.dart';
export 'es_en_a2_2.dart';
export 'es_en_b1_1.dart';
export 'es_en_b1_2.dart';
export 'es_en_b2_1.dart';
export 'es_en_b2_2.dart';
export 'es_en_c1_1.dart';
export 'es_en_c1_2.dart';
export 'es_en_c2_1.dart';
export 'es_en_c2_2.dart';

/// Every quiz of the "Certificación de Inglés A1–C2" course (Spanish →
/// English), in chain order across the twelve CEFR sub-levels (A1.1 → C2.2),
/// for seeding the content database. See `docs/es_en_certification_plan.md`.
final List<QuizContent> esEnContent = [
  ...esEnA1_1,
  ...esEnA1_2,
  ...esEnA2_1,
  ...esEnA2_2,
  ...esEnB1_1,
  ...esEnB1_2,
  ...esEnB2_1,
  ...esEnB2_2,
  ...esEnC1_1,
  ...esEnC1_2,
  ...esEnC2_1,
  ...esEnC2_2,
];
