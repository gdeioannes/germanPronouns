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
    required this.exercisePdf,
    required this.exerciseSheetTitle,
    required this.exerciseScopeLabel,
    required this.exerciseScopeFull,
    required this.exerciseScopeAchieved,
    required this.exerciseScopeWeak,
    required this.exerciseScopeWeakHint,
    required this.exerciseCountLabel,
    required this.exerciseCountAll,
    required this.createPdf,
    required this.exerciseFoldTitle,
    required this.exerciseFoldBody,
    required this.answersColumn,
    required this.foldHere,
    required this.exerciseAnswersSide,
    required this.exerciseAnswersPageEnd,
    required this.exerciseAnswersDocEnd,
    required this.answerKeyTitle,
    required this.nameLabel,
    required this.dateLabel,
    required this.nothingToPrint,
    required this.exercisesWord,
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
    required this.listen,
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
    required this.correctLabel,
    required this.incorrectLabel,
    required this.feedbackTipPrefix,
    required this.feedbackMistakeFallback,
    required this.feedbackSuccessPrefix,
    required this.feedbackSuccessTrigger,
    required this.feedbackSuccessFallback,
    required this.lastAnswerTitle,
    required this.yourAnswerPrefix,
    required this.correctAnswerPrefix,
    required this.noneAnswer,
    required this.resetProgressTitle,
    required this.resetProgressBody,
    required this.resetProgressIrreversible,
    required this.cancel,
    required this.resetAction,
    required this.scoreHistoryReset,
    required this.historySubtitle,
    required this.noHistoryYet,
    required this.mistakeAnalytics,
    required this.noMistakesTracked,
    required this.analyticsSubtitle,
    required this.colorNounsByArticle,
    required this.colorNounsByArticleSubtitle,
    required this.showScript,
    required this.scriptLabel,
    required this.replay,
    required this.listenAndRepeat,
    required this.readAndAnswer,
    required this.listenAndAnswer,
    required this.listenAndWrite,
    required this.listeningInstruction,
    required this.tipRule,
    required this.tipNote,
    required this.tipExample,
    required this.tipMemoryAid,
    required this.tipGeneric,
    required this.whatIsThisCalled,
    required this.flip,
    required this.unflip,
    required this.giveAway,
    required this.shopAnother,
    required this.notEnoughCoins,
    required this.gaveAwayItem,
    required this.addedAnotherItem,
    required this.nouns,
    required this.verbs,
    required this.meaning,
    required this.showMeanings,
    required this.includeInQuizzes,
    required this.pluralLabel,
    required this.exampleLabel,
    required this.conjugations,
    required this.wordLibraryIntro,
    required this.difficulty,
    required this.category,
    required this.noWordList,
    required this.noVerbList,
    required this.difficultyBeginner,
    required this.difficultyIntermediate,
    required this.difficultyAdvanced,
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

  // Printable exercise worksheet (course home): button, options dialog and the
  // labels printed on the PDF itself (fold-away answer column).
  final String exercisePdf;
  final String exerciseSheetTitle;
  final String exerciseScopeLabel;
  final String exerciseScopeFull;
  final String exerciseScopeAchieved;
  final String exerciseScopeWeak;
  final String exerciseScopeWeakHint;
  final String exerciseCountLabel;
  final String exerciseCountAll;
  final String createPdf;
  final String exerciseFoldTitle;
  final String exerciseFoldBody;
  final String answersColumn;
  final String foldHere;
  final String exerciseAnswersSide;
  final String exerciseAnswersPageEnd;
  final String exerciseAnswersDocEnd;
  final String answerKeyTitle;
  final String nameLabel;
  final String dateLabel;
  final String nothingToPrint;

  /// Unit word after a count in the worksheet subtitle (e.g. "40 exercises").
  final String exercisesWord;

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

  /// Tooltip for the inline speaker icon shown next to learning-content
  /// sentences (passages, questions, options, examples) so any of them can be
  /// heard in the target language.
  final String listen;

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

  // Typed-answer quiz feedback.
  /// Badge shown over a correct / incorrect answer.
  final String correctLabel;
  final String incorrectLabel;

  /// Prefix for a mistake tip drawn from the explanation's Trigger/Grammar note.
  final String feedbackTipPrefix;

  /// Fallback mistake reminder when no Trigger/Grammar note exists. `{answer}`
  /// is replaced with the correct answer.
  final String feedbackMistakeFallback;

  /// Prefix for a success note drawn from the explanation's Grammar note.
  final String feedbackSuccessPrefix;

  /// Success note that reuses the explanation's Trigger note. `{hint}` is
  /// replaced with the trigger text.
  final String feedbackSuccessTrigger;

  /// Fallback success note when no Trigger/Grammar note exists. `{answer}` is
  /// replaced with the correct answer.
  final String feedbackSuccessFallback;

  // "Last answer" info dialog.
  final String lastAnswerTitle;
  final String yourAnswerPrefix;
  final String correctAnswerPrefix;

  /// Shown in place of the answer when the learner submitted nothing.
  final String noneAnswer;

  // Reset-progress dialog.
  final String resetProgressTitle;
  final String resetProgressBody;
  final String resetProgressIrreversible;
  final String cancel;
  final String resetAction;
  final String scoreHistoryReset;

  // History & analytics panels.
  final String historySubtitle;
  final String noHistoryYet;
  final String mistakeAnalytics;
  final String noMistakesTracked;
  final String analyticsSubtitle;

  // Quiz settings toggles.
  final String colorNounsByArticle;
  final String colorNounsByArticleSubtitle;

  // Listening quiz: reveal the script / replay the audio.
  final String showScript;
  final String scriptLabel;
  final String replay;

  // Quiz-kind subtitles on the course home tiles.
  final String listenAndRepeat;
  final String readAndAnswer;
  final String listenAndAnswer;
  final String listenAndWrite;

  /// Stage-1 prompt on a listening quiz.
  final String listeningInstruction;

  // PDF tip-callout kind labels (fallback heading when a tip has no title).
  final String tipRule;
  final String tipNote;
  final String tipExample;
  final String tipMemoryAid;
  final String tipGeneric;

  // Room item info card.
  /// Prompt under the piece's picture ("What is this called?").
  final String whatIsThisCalled;
  final String flip;
  final String unflip;
  final String giveAway;
  final String shopAnother;
  final String notEnoughCoins;

  /// Snackbar after donating a piece. `{item}` is the piece's name.
  final String gaveAwayItem;

  /// Snackbar after buying another copy. `{item}` is the piece's name.
  final String addedAnotherItem;

  // Word Library: the Nouns/Verbs tabs, the tap-to-see-meaning detail panel
  // and the verb conjugation panel.
  final String nouns;
  final String verbs;
  final String meaning;
  final String showMeanings;

  /// Label of the switch in the noun detail panel that enables/disables the
  /// word for the quizzes drawing from the shared noun list.
  final String includeInQuizzes;
  final String pluralLabel;
  final String exampleLabel;
  final String conjugations;
  final String wordLibraryIntro;
  final String difficulty;
  final String category;
  final String noWordList;
  final String noVerbList;
  final String difficultyBeginner;
  final String difficultyIntermediate;
  final String difficultyAdvanced;
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
  exercisePdf: 'Exercise PDF (worksheet)',
  exerciseSheetTitle: 'Exercise Worksheet',
  exerciseScopeLabel: 'Exercises from',
  exerciseScopeFull: 'Whole course',
  exerciseScopeAchieved: 'Completed quizzes',
  exerciseScopeWeak: 'Weakest knowledge',
  exerciseScopeWeakHint: 'Trains what you get wrong most often.',
  exerciseCountLabel: 'Number of exercises',
  exerciseCountAll: 'All',
  createPdf: 'Create PDF',
  exerciseFoldTitle: 'Fold the answers away',
  exerciseFoldBody:
      'The column on the right holds the answer to every exercise. Fold the '
      'page along the dashed line to hide it while you write, then unfold it '
      'to check yourself.',
  answersColumn: 'Answers',
  foldHere: 'fold here',
  exerciseAnswersSide: 'Beside each exercise (fold away)',
  exerciseAnswersPageEnd: 'At the end of each page',
  exerciseAnswersDocEnd: 'At the end of the document',
  answerKeyTitle: 'Answer key',
  nameLabel: 'Name',
  dateLabel: 'Date',
  nothingToPrint: 'Nothing to print for this selection yet.',
  exercisesWord: 'exercises',
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
  listen: 'Listen',
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
  correctLabel: 'Correct',
  incorrectLabel: 'Incorrect',
  feedbackTipPrefix: 'Tip: ',
  feedbackMistakeFallback: 'Reminder: "{answer}" is the right answer here.',
  feedbackSuccessPrefix: 'Nice work: ',
  feedbackSuccessTrigger:
      'Nice work: keep an eye on this trigger next time too — {hint}',
  feedbackSuccessFallback: 'Nice work: "{answer}" is the right answer here.',
  lastAnswerTitle: 'Last Answer',
  yourAnswerPrefix: 'Your answer: ',
  correctAnswerPrefix: 'Correct answer: ',
  noneAnswer: '(none)',
  resetProgressTitle: 'Reset Progress',
  resetProgressBody: 'This will reset your score and clear your history data.',
  resetProgressIrreversible: 'This action is irreversible.',
  cancel: 'Cancel',
  resetAction: 'Reset',
  scoreHistoryReset: 'Score and history reset.',
  historySubtitle: 'Recent answers and common mistakes.',
  noHistoryYet: 'No history yet.',
  mistakeAnalytics: 'Mistake Analytics',
  noMistakesTracked: 'No mistakes tracked yet.',
  analyticsSubtitle: 'Performance heatmap: red bad, yellow mixed, green good.',
  colorNounsByArticle: 'Color nouns by article',
  colorNounsByArticleSubtitle:
      'Highlights known nouns in sentences by their article color '
      '(may reveal quiz answers).',
  showScript: 'Show text',
  scriptLabel: 'Text',
  replay: 'Replay',
  listenAndRepeat: 'Listen & repeat',
  readAndAnswer: 'Read & answer',
  listenAndAnswer: 'Listen & answer',
  listenAndWrite: 'Listen & write',
  listeningInstruction: 'Listen to the audio, then answer the questions.',
  tipRule: 'Rule',
  tipNote: 'Note',
  tipExample: 'Example',
  tipMemoryAid: 'Memory aid',
  tipGeneric: 'Tip',
  whatIsThisCalled: 'What is this called?',
  flip: 'Flip',
  unflip: 'Unflip',
  giveAway: 'Give away',
  shopAnother: 'Shop another',
  notEnoughCoins: 'Not enough coins.',
  gaveAwayItem: 'You gave away the {item} 💛  Someone will love it!',
  addedAnotherItem: 'Added another {item}!',
  nouns: 'Nouns',
  verbs: 'Verbs',
  meaning: 'Meaning',
  showMeanings: 'Show meanings',
  includeInQuizzes: 'Include in quizzes',
  pluralLabel: 'Plural',
  exampleLabel: 'Example',
  conjugations: 'Conjugations',
  wordLibraryIntro:
      'Tap a word to see its meaning. Toggle it to include or exclude it '
      'from the quizzes.',
  difficulty: 'Difficulty',
  category: 'Category',
  noWordList: 'No word list for this course.',
  noVerbList: 'No verb list for this course.',
  difficultyBeginner: 'Beginner',
  difficultyIntermediate: 'Intermediate',
  difficultyAdvanced: 'Advanced',
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
  exercisePdf: 'PDF de ejercicios (hoja de práctica)',
  exerciseSheetTitle: 'Hoja de ejercicios',
  exerciseScopeLabel: 'Ejercicios de',
  exerciseScopeFull: 'Todo el curso',
  exerciseScopeAchieved: 'Quizzes completados',
  exerciseScopeWeak: 'Puntos débiles',
  exerciseScopeWeakHint: 'Entrena lo que más fallas.',
  exerciseCountLabel: 'Número de ejercicios',
  exerciseCountAll: 'Todos',
  createPdf: 'Crear PDF',
  exerciseFoldTitle: 'Dobla las respuestas',
  exerciseFoldBody:
      'La columna derecha contiene la respuesta de cada ejercicio. Dobla la '
      'hoja por la línea discontinua para ocultarla mientras escribes y '
      'desdóblala para corregirte.',
  answersColumn: 'Respuestas',
  foldHere: 'dobla aquí',
  exerciseAnswersSide: 'Junto a cada ejercicio (para doblar)',
  exerciseAnswersPageEnd: 'Al final de cada página',
  exerciseAnswersDocEnd: 'Al final del documento',
  answerKeyTitle: 'Soluciones',
  nameLabel: 'Nombre',
  dateLabel: 'Fecha',
  nothingToPrint: 'Aún no hay nada que imprimir para esta selección.',
  exercisesWord: 'ejercicios',
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
  listen: 'Escuchar',
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
  correctLabel: 'Correcto',
  incorrectLabel: 'Incorrecto',
  feedbackTipPrefix: 'Consejo: ',
  feedbackMistakeFallback: 'Recordatorio: «{answer}» es la respuesta correcta aquí.',
  feedbackSuccessPrefix: '¡Bien hecho! ',
  feedbackSuccessTrigger:
      '¡Bien hecho! La próxima vez sigue atento a este detonante: {hint}',
  feedbackSuccessFallback: '¡Bien hecho! «{answer}» es la respuesta correcta aquí.',
  lastAnswerTitle: 'Última respuesta',
  yourAnswerPrefix: 'Tu respuesta: ',
  correctAnswerPrefix: 'Respuesta correcta: ',
  noneAnswer: '(ninguna)',
  resetProgressTitle: 'Reiniciar progreso',
  resetProgressBody: 'Esto reiniciará tu puntuación y borrará tu historial.',
  resetProgressIrreversible: 'Esta acción es irreversible.',
  cancel: 'Cancelar',
  resetAction: 'Reiniciar',
  scoreHistoryReset: 'Puntuación e historial reiniciados.',
  historySubtitle: 'Respuestas recientes y errores comunes.',
  noHistoryYet: 'Aún no hay historial.',
  mistakeAnalytics: 'Análisis de errores',
  noMistakesTracked: 'Aún no se registran errores.',
  analyticsSubtitle:
      'Mapa de rendimiento: rojo mal, amarillo regular, verde bien.',
  colorNounsByArticle: 'Colorear sustantivos por artículo',
  colorNounsByArticleSubtitle:
      'Resalta los sustantivos conocidos en las frases con el color de su '
      'artículo (puede revelar respuestas).',
  showScript: 'Ver texto',
  scriptLabel: 'Texto',
  replay: 'Repetir',
  listenAndRepeat: 'Escuchar y repetir',
  readAndAnswer: 'Leer y responder',
  listenAndAnswer: 'Escuchar y responder',
  listenAndWrite: 'Escuchar y escribir',
  listeningInstruction: 'Escucha el audio y luego responde las preguntas.',
  tipRule: 'Regla',
  tipNote: 'Nota',
  tipExample: 'Ejemplo',
  tipMemoryAid: 'Regla mnemotécnica',
  tipGeneric: 'Consejo',
  whatIsThisCalled: '¿Cómo se llama esto?',
  flip: 'Girar',
  unflip: 'Deshacer giro',
  giveAway: 'Regalar',
  shopAnother: 'Comprar otro',
  notEnoughCoins: 'No tienes monedas suficientes.',
  gaveAwayItem: 'Regalaste {item} 💛  ¡Alguien lo va a adorar!',
  addedAnotherItem: '¡Añadiste otro: {item}!',
  nouns: 'Sustantivos',
  verbs: 'Verbos',
  meaning: 'Significado',
  showMeanings: 'Mostrar significados',
  includeInQuizzes: 'Incluir en los ejercicios',
  pluralLabel: 'Plural',
  exampleLabel: 'Ejemplo',
  conjugations: 'Conjugaciones',
  wordLibraryIntro:
      'Toca una palabra para ver su significado. Actívala o desactívala para '
      'los ejercicios.',
  difficulty: 'Dificultad',
  category: 'Categoría',
  noWordList: 'No hay lista de palabras para este curso.',
  noVerbList: 'No hay lista de verbos para este curso.',
  difficultyBeginner: 'Principiante',
  difficultyIntermediate: 'Intermedio',
  difficultyAdvanced: 'Avanzado',
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
  exercisePdf: 'Übungs-PDF (Arbeitsblatt)',
  exerciseSheetTitle: 'Arbeitsblatt',
  exerciseScopeLabel: 'Übungen aus',
  exerciseScopeFull: 'Ganzer Kurs',
  exerciseScopeAchieved: 'Abgeschlossene Quizze',
  exerciseScopeWeak: 'Schwächstes Wissen',
  exerciseScopeWeakHint: 'Trainiert, was du am häufigsten falsch machst.',
  exerciseCountLabel: 'Anzahl der Übungen',
  exerciseCountAll: 'Alle',
  createPdf: 'PDF erstellen',
  exerciseFoldTitle: 'Antworten wegfalten',
  exerciseFoldBody:
      'Die rechte Spalte enthält die Antwort zu jeder Übung. Falte das Blatt '
      'an der gestrichelten Linie, um sie beim Schreiben zu verdecken — und '
      'falte es zum Korrigieren wieder auf.',
  answersColumn: 'Antworten',
  foldHere: 'hier falten',
  exerciseAnswersSide: 'Neben jeder Übung (zum Wegfalten)',
  exerciseAnswersPageEnd: 'Am Ende jeder Seite',
  exerciseAnswersDocEnd: 'Am Ende des Dokuments',
  answerKeyTitle: 'Lösungen',
  nameLabel: 'Name',
  dateLabel: 'Datum',
  nothingToPrint: 'Für diese Auswahl gibt es noch nichts zu drucken.',
  exercisesWord: 'Übungen',
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
  listen: 'Anhören',
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
  correctLabel: 'Richtig',
  incorrectLabel: 'Falsch',
  feedbackTipPrefix: 'Tipp: ',
  feedbackMistakeFallback: 'Tipp: „{answer}" ist hier richtig.',
  feedbackSuccessPrefix: 'Gut gemacht: ',
  feedbackSuccessTrigger:
      'Gut gemacht: Achte beim nächsten Mal weiter auf diesen Auslöser – {hint}',
  feedbackSuccessFallback: 'Gut gemacht: „{answer}" ist hier richtig.',
  lastAnswerTitle: 'Letzte Antwort',
  yourAnswerPrefix: 'Deine Antwort: ',
  correctAnswerPrefix: 'Richtige Antwort: ',
  noneAnswer: '(keine)',
  resetProgressTitle: 'Fortschritt zurücksetzen',
  resetProgressBody:
      'Damit werden deine Punktzahl und dein Verlauf zurückgesetzt.',
  resetProgressIrreversible: 'Diese Aktion ist unwiderruflich.',
  cancel: 'Abbrechen',
  resetAction: 'Zurücksetzen',
  scoreHistoryReset: 'Punktzahl und Verlauf zurückgesetzt.',
  historySubtitle: 'Letzte Antworten und häufige Fehler.',
  noHistoryYet: 'Noch kein Verlauf.',
  mistakeAnalytics: 'Fehler-Analyse',
  noMistakesTracked: 'Noch keine Fehler erfasst.',
  analyticsSubtitle: 'Leistungs-Heatmap: Rot schlecht, Gelb gemischt, Grün gut.',
  colorNounsByArticle: 'Nomen nach Artikel einfärben',
  colorNounsByArticleSubtitle:
      'Hebt bekannte Nomen in Sätzen in der Farbe ihres Artikels hervor '
      '(kann Quizantworten verraten).',
  showScript: 'Text anzeigen',
  scriptLabel: 'Text',
  replay: 'Erneut abspielen',
  listenAndRepeat: 'Hören & nachsprechen',
  readAndAnswer: 'Lesen & beantworten',
  listenAndAnswer: 'Hören & beantworten',
  listenAndWrite: 'Hören & schreiben',
  listeningInstruction: 'Höre die Aufnahme und beantworte dann die Fragen.',
  tipRule: 'Regel',
  tipNote: 'Hinweis',
  tipExample: 'Beispiel',
  tipMemoryAid: 'Eselsbrücke',
  tipGeneric: 'Tipp',
  whatIsThisCalled: 'Wie heißt das?',
  flip: 'Umdrehen',
  unflip: 'Zurückdrehen',
  giveAway: 'Verschenken',
  shopAnother: 'Noch eins kaufen',
  notEnoughCoins: 'Nicht genug Münzen.',
  gaveAwayItem: 'Du hast {item} verschenkt 💛  Jemand wird es lieben!',
  addedAnotherItem: '{item} noch einmal hinzugefügt!',
  nouns: 'Nomen',
  verbs: 'Verben',
  meaning: 'Bedeutung',
  showMeanings: 'Bedeutungen anzeigen',
  includeInQuizzes: 'In Übungen verwenden',
  pluralLabel: 'Plural',
  exampleLabel: 'Beispiel',
  conjugations: 'Konjugationen',
  wordLibraryIntro:
      'Tippe auf ein Wort, um seine Bedeutung zu sehen. Schalte es für die '
      'Übungen ein oder aus.',
  difficulty: 'Schwierigkeit',
  category: 'Kategorie',
  noWordList: 'Für diesen Kurs gibt es keine Wortliste.',
  noVerbList: 'Für diesen Kurs gibt es keine Verbliste.',
  difficultyBeginner: 'Anfänger',
  difficultyIntermediate: 'Mittelstufe',
  difficultyAdvanced: 'Fortgeschritten',
);

const AppStrings _zh = AppStrings(
  chooseCourse: '选择你的课程',
  switchCourse: '切换课程',
  howItWorks: '使用说明',
  logOut: '退出登录',
  settings: '设置',
  wordLibrary: '词库',
  history: '历史记录',
  analytics: '数据分析',
  helpMemory: '记忆助手',
  saveAsPdf: '保存为 PDF',
  gotIt: '知道了',
  close: '关闭',
  helpPanelSubtitle: '快速参考——随时在下方重新打开。',
  helpPanelTagline: '把它放进口袋：保存为 PDF，遇到难题时随时翻看。',
  tipsAndRules: '技巧与规则',
  showAll: '全部显示',
  showLess: '收起',
  resetThisQuiz: '重置本练习的进度',
  best: '最佳',
  sentenceInfo: '句子信息',
  masculine: '阳性',
  feminine: '阴性',
  neuter: '中性',
  learnerContinue: '以学习者身份继续',
  teacherMode: '教师',
  generateAllPdf: '参考 PDF（全部练习）',
  exercisePdf: '练习 PDF（练习纸）',
  exerciseSheetTitle: '练习纸',
  exerciseScopeLabel: '练习范围',
  exerciseScopeFull: '整个课程',
  exerciseScopeAchieved: '已完成的练习',
  exerciseScopeWeak: '薄弱知识点',
  exerciseScopeWeakHint: '针对你最常出错的内容进行训练。',
  exerciseCountLabel: '练习数量',
  exerciseCountAll: '全部',
  createPdf: '生成 PDF',
  exerciseFoldTitle: '把答案折起来',
  exerciseFoldBody: '右侧栏是每道练习的答案。沿虚线把纸折起来，写答案时就看不到它；写完后展开即可自我批改。',
  answersColumn: '答案',
  foldHere: '沿此折叠',
  exerciseAnswersSide: '在每道题旁边（可折起来）',
  exerciseAnswersPageEnd: '在每页末尾',
  exerciseAnswersDocEnd: '在文档末尾',
  answerKeyTitle: '参考答案',
  nameLabel: '姓名',
  dateLabel: '日期',
  nothingToPrint: '当前选择还没有可打印的内容。',
  exercisesWord: '道练习',
  doneLabel: '完成',
  home: '首页',
  quizzesFinished: '个练习已完成',
  nextExercise: '下一个练习',
  lockedHint: '完成上一个练习即可解锁',
  help: '帮助',
  noPhrases: '本课没有句子。',
  micUnavailable: '麦克风不可用。请听录音并大声跟读，然后点击"下一个"。',
  listening: '正在聆听……请跟读句子。',
  tapMicAndRepeat: '点击麦克风并跟读句子。',
  wellDone: '很好！',
  almostTryAgain: '差一点……再试一次',
  iHeard: '我听到的是：',
  finish: '结束',
  next: '下一个',
  stop: '停止',
  repeat: '重复',
  retry: '重试',
  playAll: '全部播放',
  decrease: '更少',
  increase: '更多',
  playing: '播放中……',
  pause: '暂停',
  resume: '继续',
  tapToListen: '点击收听',
  listen: '收听',
  finished: '完成！',
  speakFinishedBody: '你已经练习了这些句子。随时可以重复本课。',
  repeatAgain: '再练一次',
  listenIn: '收听语言',
  readingStartQuestions: '开始答题',
  readingQuestionsTitle: '问题',
  readingCheckAnswers: '检查答案',
  readingTryAgain: '再试一次',
  readingReadAgain: '再读一遍课文',
  readingPassed: '通过！',
  readingKeepPracticing: '差一点——再读一遍并重试',
  readingCorrect: '正确',
  readingAnswerAll: '回答所有问题后即可检查。',
  readingText: '阅读',
  translation: '翻译',
  answer: '答案',
  relaxedCorrectionTitle: '宽松批改',
  relaxedCorrectionShort: '不会仅因大小写或标点的差异就把答案判错。',
  relaxedCorrectionLong:
      '批改你输入的答案时，会忽略大小写和标点等细节。当你的键盘不便输入这些符号时很有用，'
      '这样你就不会仅因大小写或标点被判错。系统仍会显示正确的拼写。',
  relaxedCorrectionHintTitle: '只是大小写或标点的问题吗？',
  relaxedCorrectionHintBody:
      '你的答案只差在大小写或标点上。你可以开启"宽松批改"，这样答案就不会仅因这些差异被判错。'
      '可随时在设置中更改。',
  relaxedCorrectionEnable: '开启宽松批改',
  relaxedCorrectionNotNow: '暂时不用',
  correctLabel: '正确',
  incorrectLabel: '错误',
  feedbackTipPrefix: '提示：',
  feedbackMistakeFallback: '记住："{answer}" 才是这里的正确答案。',
  feedbackSuccessPrefix: '做得好：',
  feedbackSuccessTrigger: '做得好：下次也要留意这个要点——{hint}',
  feedbackSuccessFallback: '做得好："{answer}" 是这里的正确答案。',
  lastAnswerTitle: '上一题',
  yourAnswerPrefix: '你的答案：',
  correctAnswerPrefix: '正确答案：',
  noneAnswer: '（无）',
  resetProgressTitle: '重置进度',
  resetProgressBody: '这会重置你的分数并清除历史数据。',
  resetProgressIrreversible: '此操作不可撤销。',
  cancel: '取消',
  resetAction: '重置',
  scoreHistoryReset: '分数和历史已重置。',
  historySubtitle: '最近的答题和常见错误。',
  noHistoryYet: '暂无历史记录。',
  mistakeAnalytics: '错误分析',
  noMistakesTracked: '尚未记录错误。',
  analyticsSubtitle: '表现热力图：红色差，黄色一般，绿色好。',
  colorNounsByArticle: '按冠词给名词着色',
  colorNounsByArticleSubtitle: '用冠词颜色高亮句中已知的名词（可能会泄露答案）。',
  showScript: '显示文本',
  scriptLabel: '文本',
  replay: '重播',
  listenAndRepeat: '听并跟读',
  readAndAnswer: '读并作答',
  listenAndAnswer: '听并作答',
  listenAndWrite: '听并拼写',
  listeningInstruction: '先听录音，然后回答问题。',
  tipRule: '规则',
  tipNote: '注意',
  tipExample: '例子',
  tipMemoryAid: '记忆法',
  tipGeneric: '提示',
  whatIsThisCalled: '这个叫什么？',
  flip: '翻转',
  unflip: '翻回',
  giveAway: '赠送',
  shopAnother: '再买一个',
  notEnoughCoins: '金币不足。',
  gaveAwayItem: '你把 {item} 送出去了 💛  一定会有人喜欢！',
  addedAnotherItem: '又添加了一个 {item}！',
  nouns: '名词',
  verbs: '动词',
  meaning: '意思',
  showMeanings: '显示意思',
  includeInQuizzes: '包含在练习中',
  pluralLabel: '复数',
  exampleLabel: '例句',
  conjugations: '动词变化',
  wordLibraryIntro: '点击单词查看意思。用开关决定是否在练习中使用它。',
  difficulty: '难度',
  category: '类别',
  noWordList: '本课程没有词汇表。',
  noVerbList: '本课程没有动词表。',
  difficultyBeginner: '初级',
  difficultyIntermediate: '中级',
  difficultyAdvanced: '高级',
);

AppStrings stringsFor(UiLang lang) => switch (lang) {
  UiLang.en => _en,
  UiLang.es => _es,
  UiLang.de => _de,
  UiLang.zh => _zh,
};
