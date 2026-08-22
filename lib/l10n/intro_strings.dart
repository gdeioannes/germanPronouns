import '../models/course.dart';

/// Localized copy for the course introduction page (see
/// `pages/course_intro_page.dart`). Kept separate from [AppStrings] because the
/// intro is long-form teaching copy rather than short UI chrome. The copy is
/// deliberately language-neutral about the *target* language — the page itself
/// injects course-specific examples (see `_LangSample` in the page).
///
/// Access the active set with `introStringsFor(course.uiLang)`.
class IntroStrings {
  const IntroStrings({
    required this.menuTitle,
    required this.headline,
    required this.intro,
    required this.companionTitle,
    required this.companionBody,
    required this.quizTitle,
    required this.quizBody,
    required this.pathTitle,
    required this.pathBody,
    required this.helpTitle,
    required this.helpBody,
    required this.streakTitle,
    required this.streakBody,
    required this.startButton,
  });

  /// Title shown in the app bar and the "How it works" menu entry.
  final String menuTitle;
  final String headline;
  final String intro;
  final String companionTitle;
  final String companionBody;
  final String quizTitle;
  final String quizBody;

  /// The pass-to-unlock level chain card (only shown for gated courses).
  final String pathTitle;
  final String pathBody;
  final String helpTitle;
  final String helpBody;
  final String streakTitle;
  final String streakBody;
  final String startButton;
}

const IntroStrings _en = IntroStrings(
  menuTitle: 'How it works',
  headline: 'Practice the parts that actually trip you up',
  intro:
      'Short, sharp quizzes for the specifics that are easy to get wrong — '
      'with audio on every sentence and instant feedback.',
  companionTitle: 'A companion, not a replacement',
  companionBody:
      'Big apps move fast and leave gaps — the small rules you keep '
      'second-guessing. This app zooms in on exactly those until they become '
      'second nature.',
  quizTitle: 'Quick, focused quizzes',
  quizBody:
      'Read the sentence, fill the blank or pick the answer, and get instant '
      'feedback. Rounds are short, so you can practice anywhere.',
  pathTitle: 'A clear path, level by level',
  pathBody:
      'Finish a level to unlock the next — from your first words to mastery. '
      'Already know some? Take the placement test and start at your level.',
  helpTitle: 'A cheat-sheet on every quiz',
  helpBody:
      'Each quiz carries a color-coded reference with the rules, tables and '
      'tips you need — right where you practice, saveable as a PDF.',
  streakTitle: 'Streaks and coins',
  streakBody:
      'Correct answers build your streak and earn coins to furnish your own '
      'room. Practice becomes a habit — and a home.',
  startButton: 'Start the course',
);

const IntroStrings _es = IntroStrings(
  menuTitle: 'Cómo funciona',
  headline: 'Practica justo lo que se te resiste',
  intro:
      'Quizzes cortos y directos para los detalles que es fácil confundir — '
      'con audio en cada frase y corrección al instante.',
  companionTitle: 'Un complemento, no un reemplazo',
  companionBody:
      'Las apps grandes avanzan rápido y dejan huecos: las pequeñas reglas '
      'que siempre te hacen dudar. Esta app se centra justo en ellas hasta '
      'que te salgan solas.',
  quizTitle: 'Quizzes rápidos y enfocados',
  quizBody:
      'Lee la frase, completa el hueco o elige la respuesta y recibe '
      'corrección al instante. Las rondas son cortas: practica donde sea.',
  pathTitle: 'Un camino claro, nivel a nivel',
  pathBody:
      'Termina un nivel para desbloquear el siguiente, desde tus primeras '
      'palabras hasta el dominio. ¿Ya sabes algo? Haz la prueba de nivel y '
      'empieza donde te toca.',
  helpTitle: 'Una guía rápida en cada quiz',
  helpBody:
      'Cada quiz trae una referencia con colores: las reglas, tablas y '
      'consejos que necesitas, justo donde practicas, y descargable en PDF.',
  streakTitle: 'Rachas y monedas',
  streakBody:
      'Cada acierto alarga tu racha y gana monedas para amueblar tu propia '
      'habitación. La práctica se vuelve hábito… y hogar.',
  startButton: 'Empezar el curso',
);

const IntroStrings _de = IntroStrings(
  menuTitle: 'So funktioniert es',
  headline: 'Übe genau das, was dir Probleme macht',
  intro:
      'Kurze, knackige Quizze für die Feinheiten, die man leicht falsch '
      'macht — mit Audio zu jedem Satz und sofortigem Feedback.',
  companionTitle: 'Eine Ergänzung, kein Ersatz',
  companionBody:
      'Große Apps gehen schnell voran und lassen Lücken — die kleinen Regeln, '
      'bei denen du immer wieder zögerst. Diese App zoomt genau darauf, bis '
      'sie in Fleisch und Blut übergehen.',
  quizTitle: 'Kurze, gezielte Quizze',
  quizBody:
      'Lies den Satz, fülle die Lücke oder wähle die Antwort und bekomme '
      'sofort Feedback. Die Runden sind kurz — übe überall.',
  pathTitle: 'Ein klarer Weg, Stufe für Stufe',
  pathBody:
      'Schließe eine Stufe ab, um die nächste freizuschalten — von den ersten '
      'Wörtern bis zur Meisterschaft. Schon Vorkenntnisse? Mach den '
      'Einstufungstest und starte auf deinem Niveau.',
  helpTitle: 'Ein Spickzettel bei jedem Quiz',
  helpBody:
      'Jedes Quiz hat eine farbcodierte Referenz mit den Regeln, Tabellen und '
      'Tipps, die du brauchst — direkt beim Üben, als PDF speicherbar.',
  streakTitle: 'Serien und Münzen',
  streakBody:
      'Richtige Antworten verlängern deine Serie und bringen Münzen, mit '
      'denen du dein eigenes Zimmer einrichtest. Üben wird zur Gewohnheit — '
      'und zum Zuhause.',
  startButton: 'Kurs starten',
);

const IntroStrings _zh = IntroStrings(
  menuTitle: '使用说明',
  headline: '专攻真正让你卡壳的地方',
  intro: '针对容易出错的细节，做简短而精准的小测验——每句都有语音，回答立刻有反馈。',
  companionTitle: '是补充，不是替代',
  companionBody:
      '大型课程推进很快，会留下缝隙——那些总让你犹豫的小规则。'
      '这个应用正是聚焦它们，直到变成本能。',
  quizTitle: '简短、专注的练习',
  quizBody: '读句子，填空或选答案，立刻得到反馈。每轮都很短，随时随地都能练。',
  pathTitle: '一条清晰的路，一级一级走',
  pathBody: '完成一级解锁下一级——从第一句话到精通。已经有基础？做一次分级测试，从你的水平开始。',
  helpTitle: '每个练习都有小抄',
  helpBody: '每个练习都配有彩色标注的参考卡：你需要的规则、表格和提示，就在练习的地方，还能存成 PDF。',
  streakTitle: '连击与金币',
  streakBody: '答对延长连击、赚取金币，用来布置你自己的房间。练习变成习惯——也变成一个家。',
  startButton: '开始课程',
);

IntroStrings introStringsFor(UiLang lang) => switch (lang) {
  UiLang.en => _en,
  UiLang.es => _es,
  UiLang.de => _de,
  UiLang.zh => _zh,
};
