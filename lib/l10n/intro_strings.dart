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

const IntroStrings _de = IntroStrings(
  menuTitle: 'So funktioniert es',
  headline: 'Übe genau das, was dir Probleme macht',
  intro:
      'Dies ist ein gezieltes Übungstool — kurze, knackige Quizze für die '
      'Feinheiten, die man leicht falsch macht. Nutze es ergänzend zu dem, '
      'womit du schon lernst.',
  companionTitle: 'Eine Ergänzung, kein Ersatz',
  companionBody:
      'Große Apps und Kurse gehen schnell voran und lassen Lücken — ser oder '
      'estar, das richtige Pronomen, der Subjuntivo. Diese App zoomt genau '
      'darauf, damit es kein Ratespiel mehr ist, sondern in Fleisch und Blut '
      'übergeht.',
  featuresHeader: 'WAS DRIN IST',
  quizTitle: 'Kurze, gezielte Quizze',
  quizBody:
      'Lies den Satz, fülle die Lücke oder wähle die Antwort und bekomme sofort '
      'Feedback. Die Runden sind kurz — übe überall.',
  streakTitle: 'Serien, die Schwung geben',
  streakBody:
      'Jede richtige Antwort verlängert deine Serie und füllt den Balken. Jage '
      'deinen Rekord — so wird Übung zur Gewohnheit.',
  helpTitle: 'Schnellhilfe-Spickzettel',
  helpBody:
      'Jedes Quiz hat eine farbcodierte Referenz mit den Regeln und Tabellen, '
      'die du brauchst — direkt dort, wo du übst.',
  tipsTitle: 'Tipps & Erklärungen',
  tipsBody:
      'Wenn etwas knifflig ist, erklärt ein kurzer Tipp das Warum — damit du '
      'die Regel lernst, nicht nur die richtige Antwort.',
  pdfTitle: 'Nimm es mit (PDF)',
  pdfBody:
      'Speichere jede Schnellhilfe als sauberes PDF und schau sie offline an, '
      'wann immer eine Frage dich ins Stolpern bringt.',
  analyticsTitle: 'Sieh deinen Fortschritt',
  analyticsBody:
      'Verlauf und Statistiken zeigen deine Genauigkeit und deine Schwachstellen, '
      'damit du immer weißt, was als Nächstes dran ist.',
  closing: 'Das war\'s. Wähle ein Quiz und leg los, wann du bereit bist.',
  startButton: 'Üben starten',
);

const IntroStrings _zh = IntroStrings(
  menuTitle: '使用说明',
  headline: '专攻真正让你卡壳的地方',
  intro:
      '这是一个专注的练习工具——针对容易出错的细节，做简短而精准的小测验。'
      '把它当作你现有学习方式的补充。',
  companionTitle: '是补充，不是替代',
  companionBody:
      '像 Duolingo 这样的大型课程推进很快，会留下缝隙——什么时候用 a、an 还是 the，'
      '动词第三人称要不要加 -s，时态怎么变。这个应用正是聚焦这些，'
      '让它们不再靠猜，而变成本能。',
  featuresHeader: '内容包含',
  quizTitle: '简短、专注的练习',
  quizBody:
      '读句子，填空或选答案，立刻得到反馈。每轮都很短，随时随地都能练。',
  streakTitle: '连击带来动力',
  streakBody:
      '每答对一题都会延长你的连击并填满进度条。挑战你的最佳纪录——让练习成为习惯。',
  helpTitle: '记忆助手小抄',
  helpBody:
      '每个练习都配有一份参考卡，附上你需要的规则和表格，就在你练习的地方。',
  tipsTitle: '技巧与讲解',
  tipsBody:
      '遇到难点时，一条简短的提示会解释"为什么"——让你学到规则，而不只是正确答案。',
  pdfTitle: '随身携带（PDF）',
  pdfBody:
      '把任意记忆助手保存为简洁的 PDF，离线随时复习。',
  analyticsTitle: '看见你的进步',
  analyticsBody:
      '历史和分析显示你的正确率和薄弱环节，让你随时知道接下来该练什么。',
  closing: '就这些。准备好了就挑一个练习开始吧。',
  startButton: '开始练习',
);

IntroStrings introStringsFor(UiLang lang) => switch (lang) {
  UiLang.en => _en,
  UiLang.es => _es,
  UiLang.de => _de,
  UiLang.zh => _zh,
};
