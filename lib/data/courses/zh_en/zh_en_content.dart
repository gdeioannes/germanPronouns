import '../../../models/quiz_content.dart';
import 'zh_en_a1_1.dart';
import 'zh_en_a1_2.dart';
import 'zh_en_a2_1.dart';
import 'zh_en_a2_2.dart';
import 'zh_en_b1_1.dart';
import 'zh_en_b1_2.dart';
import 'zh_en_b2_1.dart';
import 'zh_en_b2_2.dart';
import 'zh_en_c1_1.dart';
import 'zh_en_c1_2.dart';
import 'zh_en_c2_1.dart';
import 'zh_en_c2_2.dart';

export 'zh_en_a1_1.dart';
export 'zh_en_a1_2.dart';
export 'zh_en_a2_1.dart';
export 'zh_en_a2_2.dart';
export 'zh_en_b1_1.dart';
export 'zh_en_b1_2.dart';
export 'zh_en_b2_1.dart';
export 'zh_en_b2_2.dart';
export 'zh_en_c1_1.dart';
export 'zh_en_c1_2.dart';
export 'zh_en_c2_1.dart';
export 'zh_en_c2_2.dart';

/// Every quiz of the "英语认证 A1–C2" course (Mandarin → English), in chain
/// order across the twelve CEFR sub-levels (A1.1 → C2.2), for seeding the
/// content database. See `docs/zh_en_certification_plan.md`.
final List<QuizContent> zhEnContent = [
  ...zhEnA1_1,
  ...zhEnA1_2,
  ...zhEnA2_1,
  ...zhEnA2_2,
  ...zhEnB1_1,
  ...zhEnB1_2,
  ...zhEnB2_1,
  ...zhEnB2_2,
  ...zhEnC1_1,
  ...zhEnC1_2,
  ...zhEnC2_1,
  ...zhEnC2_2,
];
