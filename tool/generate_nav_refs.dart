// Regenerates lib/data/course_nav_refs.g.dart — the tiny quiz-id lists the
// course catalog builds its default navs from.
//
//   dart run tool/generate_nav_refs.dart
//
// The catalog used to build its nav items straight from the compiled course
// content lists, which kept multi-megabytes of quiz content reachable (and
// therefore compiled into the learner build) even though the same content
// ships as JSON. This generator snapshots just the ids, so the catalog can
// drop those imports and tree-shaking can remove the compiled content. Re-run
// it whenever a course's quiz list changes (alongside generate_seed.dart).
import 'dart:io';

import 'package:german_pronouns_articles/data/courses/de_cs/de_cs_content.dart';
import 'package:german_pronouns_articles/data/courses/de_es/de_es_content.dart';
import 'package:german_pronouns_articles/data/courses/en_de/en_de_content.dart';
import 'package:german_pronouns_articles/data/courses/en_de_ai/en_de_ai_content.dart';
import 'package:german_pronouns_articles/data/courses/en_es/en_es_content.dart';
import 'package:german_pronouns_articles/data/courses/en_zh/en_zh_content.dart';
import 'package:german_pronouns_articles/data/courses/en_zh_hanzi/en_zh_hanzi_content.dart';
import 'package:german_pronouns_articles/data/courses/es_de/es_de_content.dart';
import 'package:german_pronouns_articles/data/courses/es_en/es_en_content.dart';
import 'package:german_pronouns_articles/data/courses/zh_en/zh_en_content.dart';
import 'package:german_pronouns_articles/models/quiz_content.dart';

void main() {
  final buffer = StringBuffer('''
// GENERATED FILE — do not edit by hand.
//
// Quiz-id lists for the default course navs, snapshotted from the course
// content by `dart run tool/generate_nav_refs.dart`. Re-run after changing
// any course's quiz list (the content-fidelity test catches drift).

''');

  void refs(String name, List<QuizContent> quizzes) {
    buffer.writeln('const List<String> $name = [');
    for (final c in quizzes) {
      buffer.writeln("  '${c.id}',");
    }
    buffer.writeln('];\n');
  }

  refs('enDeM1Refs', enDeM1);
  refs('enDeM2Refs', enDeM2);
  refs('enDeM3Refs', enDeM3);
  refs('enDeM4Refs', enDeM4);
  refs('enDeM5Refs', enDeM5);
  refs('enDeM6Refs', enDeM6);
  refs('enDeM7Refs', enDeM7);
  refs('enDeM8Refs', enDeM8);
  refs('enDeM9Refs', enDeM9);
  refs('enDeM10Refs', enDeM10);
  refs('enDeM11Refs', enDeM11);
  refs('enDeM12Refs', enDeM12);
  refs('enDeM13Refs', enDeM13);
  refs('enDeM14Refs', enDeM14);
  refs('enDeM15Refs', enDeM15);
  refs('enDeM16Refs', enDeM16);
  refs('enDeM17Refs', enDeM17);

  refs('enDeAiM1Refs', enDeAiM1Quizzes);
  refs('enDeAiM2Refs', enDeAiM2Quizzes);
  refs('enDeAiM3Refs', enDeAiM3Quizzes);
  refs('enDeAiM4Refs', enDeAiM4Quizzes);
  refs('enDeAiM5Refs', enDeAiM5Quizzes);
  refs('enDeAiM6Refs', enDeAiM6Quizzes);
  refs('enDeAiM7Refs', enDeAiM7Quizzes);
  refs('enDeAiM8Refs', enDeAiM8Quizzes);
  refs('enDeAiM9Refs', enDeAiM9Quizzes);
  refs('enDeAiM10Refs', enDeAiM10Quizzes);
  refs('enDeAiM11Refs', enDeAiM11Quizzes);
  refs('enDeAiM12Refs', enDeAiM12Quizzes);

  refs('esDeNivel1Refs', esDeNivel1);
  refs('esDeNivel2Refs', esDeNivel2);
  refs('esDeNivel3Refs', esDeNivel3);
  refs('esDeEmocionesBloqueARefs', esDeEmocionesBloqueA);
  refs('esDeEmocionesBloqueBRefs', esDeEmocionesBloqueB);
  refs('esDeEmocionesBloqueCRefs', esDeEmocionesBloqueC);
  refs('esDeEmocionesBloqueDRefs', esDeEmocionesBloqueD);
  refs('esDeEmocionesBloqueERefs', esDeEmocionesBloqueE);
  refs('esDeEmocionesBloqueFRefs', esDeEmocionesBloqueF);
  refs('esDeEmocionesBloqueGRefs', esDeEmocionesBloqueG);
  refs('esDeEmocionesBloqueHRefs', esDeEmocionesBloqueH);

  refs('deEsA1_1Refs', deEsA1_1);
  refs('deEsA1_2Refs', deEsA1_2);
  refs('deEsA2_1Refs', deEsA2_1);
  refs('deEsA2_2Refs', deEsA2_2);
  refs('deEsB1_1Refs', deEsB1_1);
  refs('deEsB1_2Refs', deEsB1_2);
  refs('deEsB2Refs', deEsB2);

  refs('deCsM1Refs', deCsM1);
  refs('deCsM2Refs', deCsM2);
  refs('deCsM3Refs', deCsM3);

  refs('zhEnA1_1Refs', zhEnA1_1);
  refs('zhEnA1_2Refs', zhEnA1_2);
  refs('zhEnA2_1Refs', zhEnA2_1);
  refs('zhEnA2_2Refs', zhEnA2_2);
  refs('zhEnB1_1Refs', zhEnB1_1);
  refs('zhEnB1_2Refs', zhEnB1_2);
  refs('zhEnB2_1Refs', zhEnB2_1);
  refs('zhEnB2_2Refs', zhEnB2_2);
  refs('zhEnC1_1Refs', zhEnC1_1);
  refs('zhEnC1_2Refs', zhEnC1_2);
  refs('zhEnC2_1Refs', zhEnC2_1);
  refs('zhEnC2_2Refs', zhEnC2_2);

  refs('esEnA1_1Refs', esEnA1_1);
  refs('esEnA1_2Refs', esEnA1_2);
  refs('esEnA2_1Refs', esEnA2_1);
  refs('esEnA2_2Refs', esEnA2_2);
  refs('esEnB1_1Refs', esEnB1_1);
  refs('esEnB1_2Refs', esEnB1_2);
  refs('esEnB2_1Refs', esEnB2_1);
  refs('esEnB2_2Refs', esEnB2_2);
  refs('esEnC1_1Refs', esEnC1_1);
  refs('esEnC1_2Refs', esEnC1_2);
  refs('esEnC2_1Refs', esEnC2_1);
  refs('esEnC2_2Refs', esEnC2_2);

  refs('enEsA1_1Refs', enEsA1_1);
  refs('enEsA1_2Refs', enEsA1_2);
  refs('enEsA2_1Refs', enEsA2_1);
  refs('enEsA2_2Refs', enEsA2_2);
  refs('enEsB1_1Refs', enEsB1_1);
  refs('enEsB1_2Refs', enEsB1_2);
  refs('enEsB2_1Refs', enEsB2_1);
  refs('enEsB2_2Refs', enEsB2_2);
  refs('enEsC1_1Refs', enEsC1_1);
  refs('enEsC1_2Refs', enEsC1_2);
  refs('enEsC2_1Refs', enEsC2_1);
  refs('enEsC2_2Refs', enEsC2_2);

  refs('enZhA1_1Refs', enZhA1_1);
  refs('enZhA1_2Refs', enZhA1_2);
  refs('enZhA2_1Refs', enZhA2_1);
  refs('enZhA2_2Refs', enZhA2_2);
  refs('enZhB1_1Refs', enZhB1_1);
  refs('enZhB1_2Refs', enZhB1_2);
  refs('enZhB2_1Refs', enZhB2_1);
  refs('enZhB2_2Refs', enZhB2_2);
  refs('enZhC1_1Refs', enZhC1_1);
  refs('enZhC1_2Refs', enZhC1_2);
  refs('enZhC2_1Refs', enZhC2_1);
  refs('enZhC2_2Refs', enZhC2_2);

  buffer.writeln('''
/// One Hanzi Writing drawer group: the module's id, display title and its
/// quiz ids in order.
class HanziModuleNav {
  const HanziModuleNav({
    required this.id,
    required this.title,
    required this.refs,
  });

  final String id;
  final String title;
  final List<String> refs;
}
''');
  buffer.writeln('const List<HanziModuleNav> enZhHanziModuleNavs = [');
  for (final m in enZhHanziModules) {
    buffer.writeln('  HanziModuleNav(');
    buffer.writeln("    id: '${m.category.id}',");
    buffer.writeln("    title: ${_dartString(m.category.title)},");
    buffer.writeln('    refs: [');
    for (final c in m.quizzes) {
      buffer.writeln("      '${c.id}',");
    }
    buffer.writeln('    ],');
    buffer.writeln('  ),');
  }
  buffer.writeln('];');

  final file = File('lib/data/course_nav_refs.g.dart');
  file.writeAsStringSync(buffer.toString());
  stdout.writeln('Wrote ${file.path} (${buffer.length} chars).');
}

String _dartString(String s) =>
    "'${s.replaceAll(r'\', r'\\').replaceAll("'", r"\'").replaceAll('\$', r'\$')}'";
