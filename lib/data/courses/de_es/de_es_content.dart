import '../../../models/quiz_content.dart';
import 'de_es_a1_1.dart';
import 'de_es_a1_2.dart';
import 'de_es_a2_1.dart';
import 'de_es_a2_2.dart';
import 'de_es_b1_1.dart';
import 'de_es_b1_2.dart';
import 'de_es_b2.dart';

export 'de_es_a1_1.dart';
export 'de_es_a1_2.dart';
export 'de_es_a2_1.dart';
export 'de_es_a2_2.dart';
export 'de_es_b1_1.dart';
export 'de_es_b1_2.dart';
export 'de_es_b2.dart';

/// Every quiz of the "Spanisch-Zertifikat A1–B2" course (Deutsch → Spanisch),
/// in chain order across the seven CEFR sub-levels, for seeding the content
/// database.
final List<QuizContent> deEsContent = [
  ...deEsA1_1,
  ...deEsA1_2,
  ...deEsA2_1,
  ...deEsA2_2,
  ...deEsB1_1,
  ...deEsB1_2,
  ...deEsB2,
];
