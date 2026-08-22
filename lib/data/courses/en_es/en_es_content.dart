import '../../../models/quiz_content.dart';
import 'en_es_a1_1.dart';
import 'en_es_a1_2.dart';
import 'en_es_a2_1.dart';
import 'en_es_a2_2.dart';
import 'en_es_b1_1.dart';
import 'en_es_b1_2.dart';
import 'en_es_b2_1.dart';
import 'en_es_b2_2.dart';
import 'en_es_c1_1.dart';
import 'en_es_c1_2.dart';
import 'en_es_c2_1.dart';
import 'en_es_c2_2.dart';

export 'en_es_a1_1.dart';
export 'en_es_a1_2.dart';
export 'en_es_a2_1.dart';
export 'en_es_a2_2.dart';
export 'en_es_b1_1.dart';
export 'en_es_b1_2.dart';
export 'en_es_b2_1.dart';
export 'en_es_b2_2.dart';
export 'en_es_c1_1.dart';
export 'en_es_c1_2.dart';
export 'en_es_c2_1.dart';
export 'en_es_c2_2.dart';

/// Every quiz of the "Certification Spanish A1–C2" course (English →
/// Spanish), in chain order across the twelve CEFR sub-levels (A1.1 →
/// C2.2), for seeding the content database. See
/// `docs/en_es_certification_plan.md`.
final List<QuizContent> enEsContent = [
  ...enEsA1_1,
  ...enEsA1_2,
  ...enEsA2_1,
  ...enEsA2_2,
  ...enEsB1_1,
  ...enEsB1_2,
  ...enEsB2_1,
  ...enEsB2_2,
  ...enEsC1_1,
  ...enEsC1_2,
  ...enEsC2_1,
  ...enEsC2_2,
];
