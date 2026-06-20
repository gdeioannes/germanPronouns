import '../models/course.dart';

/// Localized strings for the learner-facing chrome. English values are exactly
/// the app's previous literals (so the English course is unchanged); Spanish
/// values localize the whole experience for the Español → Alemán course.
///
/// Access the active set via `CourseSession.instance.strings`.
class AppStrings {
  const AppStrings({
    required this.chooseCourse,
    required this.switchCourse,
    required this.howItWorks,
    required this.logOut,
    required this.settings,
    required this.wordLibrary,
    required this.history,
    required this.analytics,
    required this.helpMemory,
    required this.saveAsPdf,
    required this.gotIt,
    required this.close,
    required this.helpPanelSubtitle,
    required this.helpPanelTagline,
    required this.tipsAndRules,
    required this.showAll,
    required this.showLess,
    required this.resetThisQuiz,
    required this.best,
    required this.sentenceInfo,
    required this.masculine,
    required this.feminine,
    required this.neuter,
    required this.learnerContinue,
    required this.teacherMode,
    required this.generateAllPdf,
    required this.doneLabel,
    required this.home,
    required this.quizzesFinished,
    required this.nextExercise,
    required this.help,
    required this.noPhrases,
    required this.micUnavailable,
    required this.listening,
    required this.tapMicAndRepeat,
    required this.wellDone,
    required this.almostTryAgain,
    required this.iHeard,
    required this.finish,
    required this.next,
    required this.stop,
    required this.repeat,
    required this.retry,
    required this.playAll,
    required this.decrease,
    required this.increase,
    required this.playing,
    required this.tapToListen,
    required this.finished,
    required this.speakFinishedBody,
    required this.repeatAgain,
    required this.listenIn,
    required this.readingStartQuestions,
    required this.readingQuestionsTitle,
    required this.readingCheckAnswers,
    required this.readingTryAgain,
    required this.readingReadAgain,
    required this.readingPassed,
    required this.readingKeepPracticing,
    required this.readingCorrect,
    required this.readingAnswerAll,
  });

  final String chooseCourse;
  final String switchCourse;
  final String howItWorks;
  final String logOut;
  final String settings;
  final String wordLibrary;
  final String history;
  final String analytics;
  final String helpMemory;
  final String saveAsPdf;
  final String gotIt;
  final String close;
  final String helpPanelSubtitle;
  final String helpPanelTagline;
  final String tipsAndRules;
  final String showAll;
  final String showLess;
  final String resetThisQuiz;
  final String best;
  final String sentenceInfo;
  final String masculine;
  final String feminine;
  final String neuter;
  final String learnerContinue;
  final String teacherMode;
  final String generateAllPdf;
  final String doneLabel;
  final String home;
  final String quizzesFinished;
  final String nextExercise;

  // Speaking (listen & repeat) page.
  final String help;
  final String noPhrases;
  final String micUnavailable;
  final String listening;
  final String tapMicAndRepeat;
  final String wellDone;
  final String almostTryAgain;
  final String iHeard;
  final String finish;
  final String next;
  final String stop;
  final String repeat;
  final String retry;
  final String playAll;
  final String decrease;
  final String increase;
  final String playing;
  final String tapToListen;
  final String finished;
  final String speakFinishedBody;
  final String repeatAgain;
  final String listenIn;

  // Reading page.
  final String readingStartQuestions;
  final String readingQuestionsTitle;
  final String readingCheckAnswers;
  final String readingTryAgain;
  final String readingReadAgain;
  final String readingPassed;
  final String readingKeepPracticing;
  final String readingCorrect;
  final String readingAnswerAll;
}

const AppStrings _en = AppStrings(
  chooseCourse: 'Choose your course',
  switchCourse: 'Switch course',
  howItWorks: 'How it works',
  logOut: 'Log out',
  settings: 'Settings',
  wordLibrary: 'Word Library',
  history: 'History',
  analytics: 'Analytics',
  helpMemory: 'Help Memory',
  saveAsPdf: 'Save as PDF',
  gotIt: 'Got it',
  close: 'Close',
  helpPanelSubtitle: 'A quick reference — reopen it anytime below.',
  helpPanelTagline:
      'Keep this in your pocket: save it as a PDF and glance back whenever a '
      'question trips you up.',
  tipsAndRules: 'Tips & rules',
  showAll: 'Show all',
  showLess: 'Show less',
  resetThisQuiz: "Reset this quiz's progress",
  best: 'Best',
  sentenceInfo: 'Sentence Info',
  masculine: 'masculine',
  feminine: 'feminine',
  neuter: 'neuter',
  learnerContinue: 'Continue as learner',
  teacherMode: 'Teacher',
  generateAllPdf: 'Reference PDF (all quizzes)',
  doneLabel: 'Done',
  home: 'Home',
  quizzesFinished: 'quizzes finished',
  nextExercise: 'Next exercise',
  help: 'Help',
  noPhrases: 'No phrases in this lesson.',
  micUnavailable:
      'Microphone unavailable. Listen to the phrase and repeat it aloud, then '
      'press Next.',
  listening: 'Listening… repeat the phrase.',
  tapMicAndRepeat: 'Press the microphone and repeat the phrase.',
  wellDone: 'Well done!',
  almostTryAgain: 'Almost… try again',
  iHeard: 'I heard:',
  finish: 'Finish',
  next: 'Next',
  stop: 'Stop',
  repeat: 'Repeat',
  retry: 'Retry',
  playAll: 'Play all',
  decrease: 'Less',
  increase: 'More',
  playing: 'Playing…',
  tapToListen: 'Tap to listen',
  finished: 'Finished!',
  speakFinishedBody: 'You practiced the phrases. Repeat the lesson anytime.',
  repeatAgain: 'Repeat again',
  listenIn: 'Listen in',
  readingStartQuestions: 'Start questions',
  readingQuestionsTitle: 'Questions',
  readingCheckAnswers: 'Check answers',
  readingTryAgain: 'Try again',
  readingReadAgain: 'Read the text again',
  readingPassed: 'Passed!',
  readingKeepPracticing: 'Almost — read again and retry',
  readingCorrect: 'correct',
  readingAnswerAll: 'Answer every question to check.',
);

const AppStrings _es = AppStrings(
  chooseCourse: 'Elige tu curso',
  switchCourse: 'Cambiar curso',
  howItWorks: 'Cómo funciona',
  logOut: 'Salir',
  settings: 'Ajustes',
  wordLibrary: 'Vocabulario',
  history: 'Historial',
  analytics: 'Estadísticas',
  helpMemory: 'Guía rápida',
  saveAsPdf: 'Guardar como PDF',
  gotIt: 'Entendido',
  close: 'Cerrar',
  helpPanelSubtitle: 'Una referencia rápida — vuelve a abrirla cuando quieras.',
  helpPanelTagline:
      'Llévatela en el bolsillo: guárdala como PDF y échale un vistazo cuando '
      'una pregunta se te resista.',
  tipsAndRules: 'Consejos y reglas',
  showAll: 'Ver todo',
  showLess: 'Ver menos',
  resetThisQuiz: 'Reiniciar el progreso de este quiz',
  best: 'Mejor',
  sentenceInfo: 'Información de la frase',
  masculine: 'masculino',
  feminine: 'femenino',
  neuter: 'neutro',
  learnerContinue: 'Entrar como estudiante',
  teacherMode: 'Profesor',
  generateAllPdf: 'PDF de referencia (todos)',
  doneLabel: 'Hecho',
  home: 'Inicio',
  quizzesFinished: 'quizzes completados',
  nextExercise: 'Siguiente ejercicio',
  help: 'Ayuda',
  noPhrases: 'No hay frases en esta lección.',
  micUnavailable:
      'Micrófono no disponible. Escucha la frase y repítela en voz alta, luego '
      'pulsa Siguiente.',
  listening: 'Escuchando… repite la frase.',
  tapMicAndRepeat: 'Pulsa el micrófono y repite la frase.',
  wellDone: '¡Bien hecho!',
  almostTryAgain: 'Casi… inténtalo otra vez',
  iHeard: 'Te escuché:',
  finish: 'Terminar',
  next: 'Siguiente',
  stop: 'Detener',
  repeat: 'Repetir',
  retry: 'Reintentar',
  playAll: 'Reproducir todo',
  decrease: 'Menos',
  increase: 'Más',
  playing: 'Reproduciendo…',
  tapToListen: 'Toca para escuchar',
  finished: '¡Terminado!',
  speakFinishedBody:
      'Has practicado las frases. Repite la lección cuando quieras.',
  repeatAgain: 'Repetir de nuevo',
  listenIn: 'Escuchar en',
  readingStartQuestions: 'Empezar preguntas',
  readingQuestionsTitle: 'Preguntas',
  readingCheckAnswers: 'Comprobar respuestas',
  readingTryAgain: 'Inténtalo otra vez',
  readingReadAgain: 'Leer el texto otra vez',
  readingPassed: '¡Aprobado!',
  readingKeepPracticing: 'Casi… vuelve a leer e inténtalo',
  readingCorrect: 'correctas',
  readingAnswerAll: 'Responde todas las preguntas para comprobar.',
);

AppStrings stringsFor(UiLang lang) => switch (lang) {
  UiLang.en => _en,
  UiLang.es => _es,
};
