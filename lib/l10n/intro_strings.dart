import '../models/course.dart';

/// Localized copy for the course introduction page (see
/// `pages/course_intro_page.dart`). Kept separate from [AppStrings] because the
/// intro is long-form marketing/teaching copy rather than short UI chrome.
///
/// Access the active set with `introStringsFor(course.uiLang)`.
class IntroStrings {
  const IntroStrings({
    required this.menuTitle,
    required this.headline,
    required this.intro,
    required this.companionTitle,
    required this.companionBody,
    required this.featuresHeader,
    required this.quizTitle,
    required this.quizBody,
    required this.streakTitle,
    required this.streakBody,
    required this.helpTitle,
    required this.helpBody,
    required this.tipsTitle,
    required this.tipsBody,
    required this.pdfTitle,
    required this.pdfBody,
    required this.analyticsTitle,
    required this.analyticsBody,
    required this.closing,
    required this.startButton,
  });

  /// Title shown in the app bar and the "How it works" menu entry.
  final String menuTitle;
  final String headline;
  final String intro;
  final String companionTitle;
  final String companionBody;
  final String featuresHeader;
  final String quizTitle;
  final String quizBody;
  final String streakTitle;
  final String streakBody;
  final String helpTitle;
  final String helpBody;
  final String tipsTitle;
  final String tipsBody;
  final String pdfTitle;
  final String pdfBody;
  final String analyticsTitle;
  final String analyticsBody;
  final String closing;
  final String startButton;
}

const IntroStrings _en = IntroStrings(
  menuTitle: 'How it works',
  headline: 'Practice the parts that actually trip you up',
  intro:
      'This is a focused practice tool — short, sharp quizzes for the specifics '
      'that are easy to get wrong. Use it next to whatever you already learn '
      'with.',
  companionTitle: 'A companion, not a replacement',
  companionBody:
      'Big apps and courses like Duolingo move forward fast and leave gaps — '
      'when to use der, die or das, the right pronoun, the case after a '
      'preposition. This app zooms in on exactly those, so they stop being '
      'guesswork and become second nature.',
  featuresHeader: "WHAT'S INSIDE",
  quizTitle: 'Quick, focused quizzes',
  quizBody:
      'Read the sentence, fill the blank or pick the answer, and get instant '
      'feedback. Rounds are short, so you can practice anywhere.',
  streakTitle: 'Streaks that build momentum',
  streakBody:
      'Every correct answer extends your streak and fills the bar. Chase your '
      'best run — it turns practice into a habit.',
  helpTitle: 'Help Memory cheat-sheet',
  helpBody:
      'Each quiz comes with a color-coded reference — der is blue, die is red, '
      'das is green — with the rules and tables you need, right where you '
      'practice.',
  tipsTitle: 'Tips & explanations',
  tipsBody:
      'When something is tricky, a short tip explains the why — so you learn '
      'the rule, not just the right answer.',
  pdfTitle: 'Take it with you (PDF)',
  pdfBody:
      'Save any Help Memory as a clean, branded PDF and review it offline '
      'whenever a question trips you up.',
  analyticsTitle: 'See your progress',
  analyticsBody:
      'History and analytics show your accuracy and your weak spots, so you '
      'always know what to practice next.',
  closing: "That's it. Pick a quiz and start whenever you're ready.",
  startButton: 'Start practicing',
);

const IntroStrings _es = IntroStrings(
  menuTitle: 'Cómo funciona',
  headline: 'Practica justo lo que se te resiste',
  intro:
      'Esta es una herramienta de práctica enfocada — quizzes cortos y directos '
      'para los detalles que es fácil confundir. Úsala junto a lo que ya uses '
      'para aprender.',
  companionTitle: 'Un complemento, no un reemplazo',
  companionBody:
      'Las apps y los cursos como Duolingo avanzan rápido y dejan huecos — '
      'cuándo usar der, die o das, el pronombre correcto, el caso después de '
      'una preposición. Esta app se centra justo en eso, para que dejes de '
      'adivinar y te salga solo.',
  featuresHeader: 'QUÉ INCLUYE',
  quizTitle: 'Quizzes rápidos y enfocados',
  quizBody:
      'Lee la frase, completa el hueco o elige la respuesta y recibe corrección '
      'al instante. Las rondas son cortas, para practicar en cualquier momento.',
  streakTitle: 'Rachas que dan impulso',
  streakBody:
      'Cada acierto alarga tu racha y llena la barra. Supera tu mejor marca — '
      'convierte la práctica en un hábito.',
  helpTitle: 'Guía rápida (Help Memory)',
  helpBody:
      'Cada quiz trae una referencia con colores — der en azul, die en rojo, '
      'das en verde — con las reglas y tablas que necesitas, justo donde '
      'practicas.',
  tipsTitle: 'Consejos y explicaciones',
  tipsBody:
      'Cuando algo es complicado, un consejo corto explica el porqué — para que '
      'aprendas la regla, no solo la respuesta correcta.',
  pdfTitle: 'Llévatela contigo (PDF)',
  pdfBody:
      'Guarda cualquier guía rápida como un PDF con un diseño cuidado y repásala '
      'sin conexión cuando una pregunta se te resista.',
  analyticsTitle: 'Mira tu progreso',
  analyticsBody:
      'El historial y las estadísticas muestran tu precisión y tus puntos '
      'débiles, para que siempre sepas qué practicar después.',
  closing: 'Eso es todo. Elige un quiz y empieza cuando quieras.',
  startButton: 'Empezar a practicar',
);

IntroStrings introStringsFor(UiLang lang) => switch (lang) {
  UiLang.en => _en,
  UiLang.es => _es,
};
