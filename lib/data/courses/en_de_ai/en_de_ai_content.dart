import '../../../models/quiz_content.dart';
import 'en_de_ai_m1.dart';
import 'en_de_ai_m2.dart';
import 'en_de_ai_m3.dart';
import 'en_de_ai_m4.dart';
import 'en_de_ai_m5.dart';
import 'en_de_ai_m6.dart';
import 'en_de_ai_m7.dart';
import 'en_de_ai_m8.dart';
import 'en_de_ai_m9.dart';
import 'en_de_ai_m10.dart';
import 'en_de_ai_m11.dart';
import 'en_de_ai_m12.dart';

export 'en_de_ai_m1.dart';
export 'en_de_ai_m2.dart';
export 'en_de_ai_m3.dart';
export 'en_de_ai_m4.dart';
export 'en_de_ai_m5.dart';
export 'en_de_ai_m6.dart';
export 'en_de_ai_m7.dart';
export 'en_de_ai_m8.dart';
export 'en_de_ai_m9.dart';
export 'en_de_ai_m10.dart';
export 'en_de_ai_m11.dart';
export 'en_de_ai_m12.dart';

/// "German with Your AI Coach" (en_de_ai): the all-AI English → German course.
/// Every exercise is a [QuizKind.speaking] prompt run in the learner's own AI
/// assistant; twelve gated modules climb A1.1 → C2.2. See
/// `docs/en_de_ai_course_plan.md`.
final List<QuizContent> enDeAiContent = [
  ...enDeAiM1Quizzes,
  ...enDeAiM2Quizzes,
  ...enDeAiM3Quizzes,
  ...enDeAiM4Quizzes,
  ...enDeAiM5Quizzes,
  ...enDeAiM6Quizzes,
  ...enDeAiM7Quizzes,
  ...enDeAiM8Quizzes,
  ...enDeAiM9Quizzes,
  ...enDeAiM10Quizzes,
  ...enDeAiM11Quizzes,
  ...enDeAiM12Quizzes,
];
