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
);

AppStrings stringsFor(UiLang lang) => switch (lang) {
  UiLang.en => _en,
  UiLang.es => _es,
};
