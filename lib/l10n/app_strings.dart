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
    required this.lockedHint,
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
    required this.pause,
    required this.resume,
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
    required this.readingText,
    required this.translation,
    required this.answer,
    required this.relaxedCorrectionTitle,
    required this.relaxedCorrectionShort,
    required this.relaxedCorrectionLong,
    required this.relaxedCorrectionHintTitle,
    required this.relaxedCorrectionHintBody,
    required this.relaxedCorrectionEnable,
    required this.relaxedCorrectionNotNow,
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

  /// Subtitle on a locked quiz tile in a pass-to-unlock certification chain.
  final String lockedHint;

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
  final String pause;
  final String resume;
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

  /// Booklet/PDF labels: the "Reading" section subtitle, the "Translation"
  /// heading for a passage's translation, and the "Answer" label marking a
  /// reading question's correct option.
  final String readingText;
  final String translation;
  final String answer;

  // Relaxed correction (accent/umlaut-insensitive answer checking).
  /// Title of the setting, shown on the in-quiz card and the Settings panel.
  final String relaxedCorrectionTitle;

  /// One-line explanation shown under the in-quiz toggle.
  final String relaxedCorrectionShort;

  /// Fuller explanation shown in the global Settings panel.
  final String relaxedCorrectionLong;

  /// Title of the one-time hint panel.
  final String relaxedCorrectionHintTitle;

  /// Body of the one-time hint panel.
  final String relaxedCorrectionHintBody;

  /// Label of the hint panel's "turn it on now" button.
  final String relaxedCorrectionEnable;

  /// Label of the hint panel's dismiss button.
  final String relaxedCorrectionNotNow;
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
  lockedHint: 'Finish the previous quiz to unlock',
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
  pause: 'Pause',
  resume: 'Resume',
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
  readingText: 'Reading',
  translation: 'Translation',
  answer: 'Answer',
  relaxedCorrectionTitle: 'Relaxed correction',
  relaxedCorrectionShort:
      'Don\'t mark answers wrong just for missing accents or umlauts '
      '(ä→a, é→e, ß→ss).',
  relaxedCorrectionLong:
      'When checking your typed answers, accents, umlauts and similar marks '
      'are ignored: ä, ö, ü become a, o, u; ß becomes ss; á, é, í, ó, ú and ñ '
      'lose their accent. Question and exclamation marks (¿ ? ¡ !) are ignored '
      'too. Handy when your keyboard can\'t easily type these characters, so '
      'you\'re not marked wrong just for a missing accent or mark. The expected '
      'answer still shows the correct spelling.',
  relaxedCorrectionHintTitle: 'Was it just an accent?',
  relaxedCorrectionHintBody:
      'Your answer was only off by an accent or umlaut. You can turn on '
      '"Relaxed correction" so answers aren\'t marked wrong just for missing '
      'accents, umlauts or ß. You can change this anytime in Settings.',
  relaxedCorrectionEnable: 'Enable relaxed correction',
  relaxedCorrectionNotNow: 'Not now',
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
  lockedHint: 'Completa el quiz anterior para desbloquear',
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
  pause: 'Pausar',
  resume: 'Reanudar',
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
  readingText: 'Lectura',
  translation: 'Traducción',
  answer: 'Respuesta',
  relaxedCorrectionTitle: 'Corrección flexible',
  relaxedCorrectionShort:
      'No marca mal las respuestas solo por acentos o diéresis que falten '
      '(ä→a, é→e, ß→ss).',
  relaxedCorrectionLong:
      'Al revisar tus respuestas escritas, se ignoran los acentos, las '
      'diéresis y marcas similares: ä, ö, ü pasan a a, o, u; ß pasa a ss; á, '
      'é, í, ó, ú y ñ pierden el acento. También se ignoran los signos de '
      'interrogación y exclamación (¿ ? ¡ !). Útil cuando tu teclado no puede '
      'escribir fácilmente estos caracteres, para que no te marquen mal solo '
      'por un acento o signo que falte. La respuesta esperada sigue mostrando '
      'la ortografía correcta.',
  relaxedCorrectionHintTitle: '¿Era solo un acento?',
  relaxedCorrectionHintBody:
      'Tu respuesta solo falló por un acento o una diéresis. Puedes activar '
      'la "Corrección flexible" para que las respuestas no se marquen mal solo '
      'por acentos, diéresis o ß que falten. Puedes cambiarlo cuando quieras '
      'en Ajustes.',
  relaxedCorrectionEnable: 'Activar corrección flexible',
  relaxedCorrectionNotNow: 'Ahora no',
);

const AppStrings _de = AppStrings(
  chooseCourse: 'Wähle deinen Kurs',
  switchCourse: 'Kurs wechseln',
  howItWorks: 'So funktioniert es',
  logOut: 'Abmelden',
  settings: 'Einstellungen',
  wordLibrary: 'Wortschatz',
  history: 'Verlauf',
  analytics: 'Statistiken',
  helpMemory: 'Schnellhilfe',
  saveAsPdf: 'Als PDF speichern',
  gotIt: 'Verstanden',
  close: 'Schließen',
  helpPanelSubtitle: 'Eine schnelle Referenz — jederzeit unten wieder öffnen.',
  helpPanelTagline:
      'Steck sie ein: Speichere sie als PDF und schau nach, wann immer eine '
      'Frage dich ins Stolpern bringt.',
  tipsAndRules: 'Tipps & Regeln',
  showAll: 'Alle anzeigen',
  showLess: 'Weniger anzeigen',
  resetThisQuiz: 'Fortschritt dieses Quiz zurücksetzen',
  best: 'Bestwert',
  sentenceInfo: 'Satz-Info',
  masculine: 'maskulin',
  feminine: 'feminin',
  neuter: 'neutrum',
  learnerContinue: 'Als Lernende/r fortfahren',
  teacherMode: 'Lehrkraft',
  generateAllPdf: 'Referenz-PDF (alle Quizze)',
  doneLabel: 'Fertig',
  home: 'Start',
  quizzesFinished: 'Quizze abgeschlossen',
  nextExercise: 'Nächste Übung',
  lockedHint: 'Schließe zuerst das vorherige Quiz ab',
  help: 'Hilfe',
  noPhrases: 'Keine Sätze in dieser Lektion.',
  micUnavailable:
      'Mikrofon nicht verfügbar. Höre den Satz und sprich ihn laut nach, dann '
      'drücke Weiter.',
  listening: 'Ich höre zu… sprich den Satz nach.',
  tapMicAndRepeat: 'Drücke das Mikrofon und sprich den Satz nach.',
  wellDone: 'Sehr gut!',
  almostTryAgain: 'Fast… versuch es nochmal',
  iHeard: 'Ich habe gehört:',
  finish: 'Beenden',
  next: 'Weiter',
  stop: 'Stopp',
  repeat: 'Wiederholen',
  retry: 'Erneut',
  playAll: 'Alle abspielen',
  decrease: 'Weniger',
  increase: 'Mehr',
  playing: 'Wird abgespielt…',
  pause: 'Pause',
  resume: 'Fortsetzen',
  tapToListen: 'Zum Anhören tippen',
  finished: 'Fertig!',
  speakFinishedBody:
      'Du hast die Sätze geübt. Wiederhole die Lektion jederzeit.',
  repeatAgain: 'Nochmal wiederholen',
  listenIn: 'Anhören auf',
  readingStartQuestions: 'Fragen starten',
  readingQuestionsTitle: 'Fragen',
  readingCheckAnswers: 'Antworten prüfen',
  readingTryAgain: 'Versuch es nochmal',
  readingReadAgain: 'Text nochmal lesen',
  readingPassed: 'Bestanden!',
  readingKeepPracticing: 'Fast… lies nochmal und versuch es erneut',
  readingCorrect: 'richtig',
  readingAnswerAll: 'Beantworte alle Fragen zum Prüfen.',
  readingText: 'Lesen',
  translation: 'Übersetzung',
  answer: 'Antwort',
  relaxedCorrectionTitle: 'Nachsichtige Korrektur',
  relaxedCorrectionShort:
      'Antworten gelten nicht als falsch, nur weil Akzente oder Umlaute '
      'fehlen (ä→a, é→e, ß→ss).',
  relaxedCorrectionLong:
      'Beim Prüfen deiner getippten Antworten werden Akzente, Umlaute und '
      'ähnliche Zeichen ignoriert: ä, ö, ü werden zu a, o, u; ß wird zu ss; á, '
      'é, í, ó, ú und ñ verlieren ihren Akzent. Frage- und Ausrufezeichen '
      '(¿ ? ¡ !) werden ebenfalls ignoriert. Praktisch, wenn deine Tastatur '
      'diese Zeichen nicht leicht tippen kann, damit dir ein fehlender Akzent '
      'oder ein fehlendes Zeichen nicht als Fehler angerechnet wird. Die '
      'erwartete Antwort zeigt weiterhin die korrekte Schreibweise.',
  relaxedCorrectionHintTitle: 'War es nur ein Akzent?',
  relaxedCorrectionHintBody:
      'Deine Antwort war nur wegen eines Akzents oder Umlauts falsch. Du '
      'kannst die „Nachsichtige Korrektur" aktivieren, damit Antworten nicht '
      'als falsch gelten, nur weil Akzente, Umlaute oder ß fehlen. Du kannst '
      'das jederzeit in den Einstellungen ändern.',
  relaxedCorrectionEnable: 'Nachsichtige Korrektur aktivieren',
  relaxedCorrectionNotNow: 'Jetzt nicht',
);

AppStrings stringsFor(UiLang lang) => switch (lang) {
  UiLang.en => _en,
  UiLang.es => _es,
  UiLang.de => _de,
};
