import '../../../models/quiz_content.dart';
import 'es_de_nivel1.dart';
import 'es_de_nivel2.dart';
import 'es_de_nivel3.dart';
import 'es_de_nivel4.dart';

export 'es_de_nivel1.dart';
export 'es_de_nivel2.dart';
export 'es_de_nivel3.dart';
export 'es_de_nivel4.dart';

/// Every quiz of the "Un viaje rápido a Alemania" travel course, for seeding
/// into the content database. (The "German Emotions" course lives separately in
/// [esDeEmocionesContent].)
final List<QuizContent> esDeContent = [
  ...esDeNivel1,
  ...esDeNivel2,
  ...esDeNivel3,
];
