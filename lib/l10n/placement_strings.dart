/// Learner-facing chrome for the placement flow: the "where do I start?" sheet
/// on the course home, the placement test itself, the self-declared level
/// picker, and the confirmation that applying a result wipes existing progress.
///
/// Grouped into its own object rather than ~25 more fields on [AppStrings], the
/// same way [SpeakingStrings] is. `{n}`, `{i}`, `{level}`, `{correct}` and
/// `{asked}` are substituted by the caller.
class PlacementStrings {
  const PlacementStrings({
    required this.entryButton,
    required this.entryTitle,
    required this.entryBody,
    required this.optionTestTitle,
    required this.optionTestBody,
    required this.optionPickTitle,
    required this.optionPickBody,
    required this.optionResetTitle,
    required this.optionResetBody,
    required this.pickTitle,
    required this.pickBody,
    required this.testTitle,
    required this.questionCounter,
    required this.answerLabel,
    required this.dontKnow,
    required this.next,
    required this.seeResult,
    required this.notEnoughContent,
    required this.resultTitle,
    required this.resultStopped,
    required this.resultCleared,
    required this.resultScoreLine,
    required this.startHere,
    required this.noRewardsNote,
    required this.wipeTitle,
    required this.wipeBody,
    required this.wipeConfirm,
    required this.applied,
  });

  /// The always-available course-home button that opens the sheet.
  final String entryButton;

  final String entryTitle;
  final String entryBody;

  /// '{n}' is the number of questions in the test.
  final String optionTestTitle;
  final String optionTestBody;

  final String optionPickTitle;
  final String optionPickBody;
  final String optionResetTitle;
  final String optionResetBody;

  final String pickTitle;
  final String pickBody;

  final String testTitle;

  /// '{i}' is the current question (1-based), '{n}' the total.
  final String questionCounter;

  final String answerLabel;
  final String dontKnow;
  final String next;
  final String seeResult;

  /// Shown instead of the test when a course has too few auto-usable questions.
  final String notEnoughContent;

  /// '{level}' is the module the learner is placed in.
  final String resultTitle;

  /// Why they landed there: the test stopped at a level they struggled with.
  final String resultStopped;

  /// …or they cleared everything the test had.
  final String resultCleared;

  /// '{correct}' of '{asked}' answered correctly.
  final String resultScoreLine;

  final String startHere;

  /// The standing reminder that placing is not the same as earning.
  final String noRewardsNote;

  final String wipeTitle;

  /// '{n}' is how many quizzes are already finished, '{level}' the new start.
  final String wipeBody;

  final String wipeConfirm;

  /// Confirmation snack after applying. '{level}' is the new starting module.
  final String applied;
}

const PlacementStrings kPlacementStringsEn = PlacementStrings(
  entryButton: 'Set your starting point',
  entryTitle: 'Where should this course start?',
  entryBody:
      'By default you begin at the very first quiz and unlock the rest as you '
      'go. If you already know some of this, you can skip ahead instead.',
  optionTestTitle: 'Take the placement test',
  optionTestBody:
      '{n} questions, easiest level first. It stops as soon as it finds your '
      'level, so it is usually much shorter than that.',
  optionPickTitle: 'I already know my level',
  optionPickBody: 'Pick it yourself and open everything up to it.',
  optionResetTitle: 'Start from the beginning',
  optionResetBody: 'Clear everything and begin at the first quiz.',
  pickTitle: 'Which level do you want to start at?',
  pickBody:
      'Everything before your choice opens straight away. Your chosen level is '
      'where you begin.',
  testTitle: 'Placement test',
  questionCounter: 'Question {i} of {n}',
  answerLabel: 'Your answer',
  dontKnow: "I don't know",
  next: 'Next',
  seeResult: 'See my result',
  notEnoughContent:
      "This course doesn't have enough auto-checkable questions for a "
      'placement test yet. You can still pick your level by hand.',
  resultTitle: 'Start at {level}',
  resultStopped:
      'You handled the earlier levels, and this is where the questions started '
      'getting away from you — so this is a good place to begin.',
  resultCleared:
      'You cleared every level in the test, so we placed you at the last one.',
  resultScoreLine: '{correct} of {asked} correct',
  startHere: 'Start here',
  noRewardsNote:
      'Placing only opens the levels. It gives no medals and no coins — those '
      'are still there for you to earn.',
  wipeTitle: 'This deletes your progress',
  wipeBody:
      "You've finished {n} quizzes in this course. Starting again at {level} "
      'clears all of it — scores, streaks and medals — and cannot be undone.',
  wipeConfirm: 'Delete and start there',
  applied: 'Opened everything up to {level}.',
);

const PlacementStrings kPlacementStringsDe = PlacementStrings(
  entryButton: 'Startpunkt festlegen',
  entryTitle: 'Wo soll dieser Kurs anfangen?',
  entryBody:
      'Normalerweise startest du bei der allerersten Übung und schaltest den '
      'Rest nach und nach frei. Wenn du davon schon etwas kannst, kannst du '
      'auch weiter vorne einsteigen.',
  optionTestTitle: 'Einstufungstest machen',
  optionTestBody:
      '{n} Fragen, einfachste Stufe zuerst. Der Test hört auf, sobald deine '
      'Stufe feststeht — meist ist er also deutlich kürzer.',
  optionPickTitle: 'Ich kenne meine Stufe',
  optionPickBody: 'Wähle sie selbst und schalte alles bis dahin frei.',
  optionResetTitle: 'Von vorne anfangen',
  optionResetBody: 'Alles löschen und bei der ersten Übung beginnen.',
  pickTitle: 'Mit welcher Stufe willst du anfangen?',
  pickBody:
      'Alles vor deiner Wahl wird sofort freigeschaltet. Bei der gewählten '
      'Stufe steigst du ein.',
  testTitle: 'Einstufungstest',
  questionCounter: 'Frage {i} von {n}',
  answerLabel: 'Deine Antwort',
  dontKnow: 'Weiß ich nicht',
  next: 'Weiter',
  seeResult: 'Ergebnis ansehen',
  notEnoughContent:
      'Dieser Kurs hat noch nicht genug automatisch prüfbare Fragen für einen '
      'Einstufungstest. Du kannst deine Stufe aber selbst wählen.',
  resultTitle: 'Start bei {level}',
  resultStopped:
      'Die früheren Stufen hast du sicher beantwortet, und ab hier wurde es '
      'schwierig — ein guter Einstieg.',
  resultCleared:
      'Du hast alle Stufen im Test geschafft, deshalb steigst du bei der '
      'letzten ein.',
  resultScoreLine: '{correct} von {asked} richtig',
  startHere: 'Hier einsteigen',
  noRewardsNote:
      'Die Einstufung schaltet nur die Stufen frei. Es gibt dafür keine '
      'Medaillen und keine Münzen — die kannst du dir weiterhin verdienen.',
  wipeTitle: 'Das löscht deinen Fortschritt',
  wipeBody:
      'Du hast in diesem Kurs {n} Übungen abgeschlossen. Ein Neustart bei '
      '{level} löscht alles davon — Punkte, Serien und Medaillen — und lässt '
      'sich nicht rückgängig machen.',
  wipeConfirm: 'Löschen und dort starten',
  applied: 'Alles bis {level} freigeschaltet.',
);

const PlacementStrings kPlacementStringsEs = PlacementStrings(
  entryButton: 'Elegir por dónde empezar',
  entryTitle: '¿Por dónde empieza este curso?',
  entryBody:
      'Por defecto empiezas en el primer ejercicio y vas desbloqueando el '
      'resto. Si ya sabes parte de esto, puedes saltar hacia adelante.',
  optionTestTitle: 'Hacer la prueba de nivel',
  optionTestBody:
      '{n} preguntas, empezando por el nivel más fácil. Se detiene en cuanto '
      'encuentra tu nivel, así que suele ser mucho más corta.',
  optionPickTitle: 'Ya sé mi nivel',
  optionPickBody: 'Elígelo tú y abre todo hasta ahí.',
  optionResetTitle: 'Empezar desde cero',
  optionResetBody: 'Borrar todo y empezar en el primer ejercicio.',
  pickTitle: '¿En qué nivel quieres empezar?',
  pickBody:
      'Todo lo anterior a tu elección se abre de inmediato. El nivel que elijas '
      'es donde empiezas.',
  testTitle: 'Prueba de nivel',
  questionCounter: 'Pregunta {i} de {n}',
  answerLabel: 'Tu respuesta',
  dontKnow: 'No lo sé',
  next: 'Siguiente',
  seeResult: 'Ver mi resultado',
  notEnoughContent:
      'Este curso todavía no tiene suficientes preguntas corregibles '
      'automáticamente para una prueba de nivel. Puedes elegir tu nivel a mano.',
  resultTitle: 'Empieza en {level}',
  resultStopped:
      'Los niveles anteriores los resolviste bien, y aquí es donde las '
      'preguntas se te empezaron a escapar — un buen punto de partida.',
  resultCleared:
      'Superaste todos los niveles de la prueba, así que empiezas en el último.',
  resultScoreLine: '{correct} de {asked} correctas',
  startHere: 'Empezar aquí',
  noRewardsNote:
      'Situarte solo abre los niveles. No da medallas ni monedas: esas siguen '
      'ahí para que las ganes.',
  wipeTitle: 'Esto borra tu progreso',
  wipeBody:
      'Has terminado {n} ejercicios en este curso. Volver a empezar en {level} '
      'borra todo — puntuaciones, rachas y medallas — y no se puede deshacer.',
  wipeConfirm: 'Borrar y empezar ahí',
  applied: 'Abierto todo hasta {level}.',
);

const PlacementStrings kPlacementStringsZh = PlacementStrings(
  entryButton: '设置起点',
  entryTitle: '这门课从哪里开始？',
  entryBody: '默认从第一个练习开始，之后逐个解锁。如果你已经会一些了，可以直接跳到后面。',
  optionTestTitle: '做分级测试',
  optionTestBody: '{n} 道题，从最简单的等级开始。一旦测出你的等级就会结束，通常比这短得多。',
  optionPickTitle: '我知道自己的等级',
  optionPickBody: '自己选，并解锁到那一级为止的全部内容。',
  optionResetTitle: '从头开始',
  optionResetBody: '清空全部记录，从第一个练习开始。',
  pickTitle: '你想从哪一级开始？',
  pickBody: '你选的等级之前的内容会立刻打开，你从所选等级开始学。',
  testTitle: '分级测试',
  questionCounter: '第 {i} 题，共 {n} 题',
  answerLabel: '你的答案',
  dontKnow: '不知道',
  next: '下一题',
  seeResult: '查看结果',
  notEnoughContent: '这门课还没有足够多可自动批改的题目来做分级测试。你可以自己选等级。',
  resultTitle: '从 {level} 开始',
  resultStopped: '前面的等级你答得不错，从这一级开始题目变难了——正好从这里入手。',
  resultCleared: '测试里的每一级你都通过了，所以放在最后一级。',
  resultScoreLine: '答对 {correct} / {asked}',
  startHere: '从这里开始',
  noRewardsNote: '分级只负责解锁等级，不给奖牌也不给金币——那些还等着你去挣。',
  wipeTitle: '这会删除你的进度',
  wipeBody: '你在这门课已完成 {n} 个练习。从 {level} 重新开始会清空全部——分数、连击和奖牌——且无法撤销。',
  wipeConfirm: '删除并从那里开始',
  applied: '已解锁到 {level}。',
);
