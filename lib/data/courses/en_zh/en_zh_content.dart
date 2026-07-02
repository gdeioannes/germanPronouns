import '../../../models/quiz_content.dart';
import 'en_zh_a1_1.dart';
import 'en_zh_a1_2.dart';
import 'en_zh_a2_1.dart';
import 'en_zh_a2_2.dart';
import 'en_zh_b1_1.dart';
import 'en_zh_b1_2.dart';
import 'en_zh_b2_1.dart';
import 'en_zh_b2_2.dart';
import 'en_zh_c1_1.dart';
import 'en_zh_c1_2.dart';
import 'en_zh_c2_1.dart';
import 'en_zh_c2_2.dart';

export 'en_zh_a1_1.dart';
export 'en_zh_a1_2.dart';
export 'en_zh_a2_1.dart';
export 'en_zh_a2_2.dart';
export 'en_zh_b1_1.dart';
export 'en_zh_b1_2.dart';
export 'en_zh_b2_1.dart';
export 'en_zh_b2_2.dart';
export 'en_zh_c1_1.dart';
export 'en_zh_c1_2.dart';
export 'en_zh_c2_1.dart';
export 'en_zh_c2_2.dart';

/// Every quiz of the "Certification Chinese · HSK" course (English → Mandarin),
/// in chain order across the twelve CEFR sub-levels (A1.1 → C2.2), for seeding
/// the content database. See `docs/en_zh_certification_plan.md`.
final List<QuizContent> enZhContent = [
  ...enZhA1_1,
  ...enZhA1_2,
  ...enZhA2_1,
  ...enZhA2_2,
  ...enZhB1_1,
  ...enZhB1_2,
  ...enZhB2_1,
  ...enZhB2_2,
  ...enZhC1_1,
  ...enZhC1_2,
  ...enZhC2_1,
  ...enZhC2_2,
];
