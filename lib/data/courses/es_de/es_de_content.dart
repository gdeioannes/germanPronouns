import '../../../models/quiz_content.dart';
import 'es_de_nivel1.dart';
import 'es_de_nivel2.dart';
import 'es_de_nivel3.dart';

export 'es_de_nivel1.dart';
export 'es_de_nivel2.dart';
export 'es_de_nivel3.dart';

/// Every Español → Alemán travel quiz, for seeding into the content database.
final List<QuizContent> esDeContent = [
  ...esDeNivel1,
  ...esDeNivel2,
  ...esDeNivel3,
];
