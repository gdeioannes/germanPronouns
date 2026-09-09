/// Learner-facing chrome for the speaking quiz ([QuizKind.speaking]).
///
/// Grouped into its own object rather than ~20 more fields on [AppStrings]:
/// one nested value per language instead of twenty entries in every locale
/// block. `{n}` in [duration] is the exercise's minutes.
class SpeakingStrings {
  const SpeakingStrings({
    required this.kindLabel,
    required this.howItWorksTitle,
    required this.step1,
    required this.step2,
    required this.step3,
    required this.step4,
    required this.copyExercise,
    required this.copied,
    required this.openTitle,
    required this.openAssistant,
    required this.openPasteHint,
    required this.sayOutLoud,
    required this.duration,
    required this.disclaimerShort,
    required this.scoreSectionTitle,
    required this.scoreHint,
    required this.scoreField,
    required this.scorePlaceholder,
    required this.helpMaterialTitle,
    required this.helpPractiseTitle,
    required this.helpVocabularyTitle,
    required this.helpWordColumn,
    required this.helpMeaningColumn,
    required this.saveScore,
    required this.savedTitle,
    required this.bestScore,
    required this.readFeedback,
    required this.runAgain,
    required this.tryAgain,
    required this.gold,
    required this.silver,
    required this.bronze,
    required this.whyTitle,
    required this.whyBody,
    required this.qualityTitle,
    required this.qualityBody,
  });

  /// The one-line kind label on the course-home row and drawer tile.
  final String kindLabel;

  final String howItWorksTitle;
  final String step1;
  final String step2;
  final String step3;
  final String step4;
  final String copyExercise;
  final String copied;

  /// Heading over the hand-off buttons, which only appear once the prompt is
  /// on the clipboard.
  final String openTitle;

  /// '{ai}' is replaced with the assistant's own (untranslated) name, e.g.
  /// "Open ChatGPT".
  final String openAssistant;

  /// Under the buttons: the prompt is copied, so paste it once you're there.
  final String openPasteHint;

  final String sayOutLoud;

  /// '{n}' is replaced with the exercise's expected minutes.
  final String duration;

  /// The one line that stays on screen under the copy button — the disclaimer
  /// learners actually see, since the first-run sheet is read once.
  final String disclaimerShort;

  final String scoreSectionTitle;
  final String scoreHint;
  final String scoreField;

  /// In-field placeholder showing exactly what a valid paste looks like.
  /// `SCORE=72` and the ===== markers are protocol and stay untranslated.
  final String scorePlaceholder;

  /// Help Memory section headings for the exercise's study content: the
  /// MATERIAL payload, the practise points, and the target vocabulary.
  final String helpMaterialTitle;
  final String helpPractiseTitle;
  final String helpVocabularyTitle;

  /// Column headers of the word/meaning table the material pairs render as.
  final String helpWordColumn;
  final String helpMeaningColumn;
  final String saveScore;
  final String savedTitle;
  final String bestScore;
  final String readFeedback;
  final String runAgain;
  final String tryAgain;
  final String gold;
  final String silver;
  final String bronze;

  /// First-run explainer: why the exercise runs in another app at all.
  final String whyTitle;
  final String whyBody;

  /// First-run explainer: the quality/comparability disclaimer.
  final String qualityTitle;
  final String qualityBody;
}

const SpeakingStrings kSpeakingStringsEn = SpeakingStrings(
  kindLabel: 'Talk with an AI',
  howItWorksTitle: 'How this exercise works',
  step1: 'Copy the exercise below.',
  step2: 'Paste it into your AI assistant (we tested with Gemini\'s free tier).',
  step3: 'Turn on its voice or live conversation mode.',
  step4: 'Say the phrase below out loud to start. When it gives you a score at '
      'the end, come back and enter it here.',
  copyExercise: 'Copy exercise',
  copied: 'Copied',
  openTitle: 'Now open your AI',
  openAssistant: 'Open {ai}',
  openPasteHint:
      'The exercise is on your clipboard — paste it there, then switch on '
      'voice mode.',
  sayOutLoud: 'Say this out loud to start',
  duration: 'About {n} minutes',
  disclaimerShort:
      'Quality depends on the AI you use — we tested with Gemini\'s free tier. '
      'Different AIs grade differently, so stay with one to keep your scores '
      'comparable.',
  scoreSectionTitle: 'Enter your score',
  scoreHint:
      'Best: paste the AI\'s whole report (everything between the ===== '
      'lines) — we\'ll read the score and remember your corrections. A bare '
      'number works too.',
  scoreField: 'Score out of 100',
  scorePlaceholder: 'Paste the report here, or type e.g. 72 or SCORE=72',
  helpMaterialTitle: 'Exercise material',
  helpPractiseTitle: 'What you practise',
  helpVocabularyTitle: 'Words to use',
  helpWordColumn: 'Word / phrase',
  helpMeaningColumn: 'Meaning',
  saveScore: 'Save score',
  savedTitle: 'Score saved',
  bestScore: 'Best',
  readFeedback:
      'Read the AI\'s corrections before you close it — that\'s where the '
      'learning is.',
  runAgain: 'Run again',
  tryAgain: 'Not there yet — run it again and beat this score.',
  gold: 'Gold',
  silver: 'Silver',
  bronze: 'Bronze',
  whyTitle: 'Why does this exercise use another app?',
  whyBody:
      'This app is free, with no accounts and no subscriptions. Live AI voice '
      'conversation is the one feature we can\'t host for free — so instead we '
      'hand you a ready-made exercise you can run in any AI assistant you '
      'already have. You get the full power of the newest voice models, and the '
      'app stays free for everyone.\n\n'
      'The conversation happens in that provider\'s app, under their terms and '
      'privacy policy. We send them nothing, and we store nothing but the score '
      'you type in.\n\n'
      'If we ever find a way to build this in, for free, for everyone, we will.',
  qualityTitle: 'The quality depends on the AI you use, not on us',
  qualityBody:
      'Some assistants follow the exercise closely, grade carefully and give '
      'useful feedback. Others rush, correct you in the middle of the '
      'conversation, or forget to give you a score at all. Paid or newer models '
      'are usually noticeably better.\n\n'
      'We built and tested these exercises with Gemini\'s free tier, and that\'s '
      'where our best results came from — but these services change, and we have '
      'no control over that.\n\n'
      'One thing worth knowing: different AIs grade differently. The same '
      'conversation can score 70 with one and 80 with another. If you want your '
      'progress to mean something, stick to the same assistant.\n\n'
      'If an exercise goes badly — no score, corrections all the way through, '
      'wrong language — that\'s the assistant, not your German. Start again, or '
      'try a different one.',
);

const SpeakingStrings kSpeakingStringsDe = SpeakingStrings(
  kindLabel: 'Mit einer KI sprechen',
  howItWorksTitle: 'So funktioniert diese Übung',
  step1: 'Kopiere die Übung unten.',
  step2: 'Füge sie in deine KI-App ein (getestet mit Gemini, Gratisversion).',
  step3: 'Schalte den Sprach- oder Live-Modus ein.',
  step4: 'Sag den Satz unten laut, um zu starten. Wenn du am Ende eine '
      'Punktzahl bekommst, komm zurück und trag sie hier ein.',
  copyExercise: 'Übung kopieren',
  copied: 'Kopiert',
  openTitle: 'Jetzt deine KI öffnen',
  openAssistant: '{ai} öffnen',
  openPasteHint:
      'Die Übung ist in der Zwischenablage — füge sie dort ein und schalte dann '
      'den Sprachmodus ein.',
  sayOutLoud: 'Sag das laut, um zu starten',
  duration: 'Etwa {n} Minuten',
  disclaimerShort:
      'Die Qualität hängt von der KI ab, die du benutzt — getestet mit Gemini '
      '(Gratisversion). Verschiedene KIs bewerten unterschiedlich: bleib bei '
      'einer, damit deine Punktzahlen vergleichbar bleiben.',
  scoreSectionTitle: 'Punktzahl eintragen',
  scoreHint:
      'Am besten: füge den ganzen Bericht der KI ein (alles zwischen den '
      '=====-Zeilen) — wir lesen die Punktzahl und merken uns deine '
      'Korrekturen. Eine bloße Zahl geht auch.',
  scoreField: 'Punktzahl von 100',
  scorePlaceholder: 'Bericht hier einfügen, oder z. B. 72 oder SCORE=72',
  helpMaterialTitle: 'Übungsmaterial',
  helpPractiseTitle: 'Was du übst',
  helpVocabularyTitle: 'Wörter zum Verwenden',
  helpWordColumn: 'Wort / Wendung',
  helpMeaningColumn: 'Bedeutung',
  saveScore: 'Punktzahl speichern',
  savedTitle: 'Punktzahl gespeichert',
  bestScore: 'Bestwert',
  readFeedback:
      'Lies die Korrekturen der KI, bevor du sie schließt — da steckt das '
      'Lernen drin.',
  runAgain: 'Nochmal machen',
  tryAgain: 'Noch nicht geschafft — mach die Übung nochmal und übertriff diesen '
      'Wert.',
  gold: 'Gold',
  silver: 'Silber',
  bronze: 'Bronze',
  whyTitle: 'Warum läuft diese Übung in einer anderen App?',
  whyBody:
      'Diese App ist kostenlos, ohne Konto und ohne Abo. Ein echtes '
      'KI-Sprachgespräch ist das Einzige, was wir nicht kostenlos anbieten '
      'können — deshalb bekommst du stattdessen eine fertige Übung, die du in '
      'jeder KI-App laufen lassen kannst, die du schon hast. Du bekommst die '
      'volle Leistung der neuesten Sprachmodelle, und die App bleibt für alle '
      'kostenlos.\n\n'
      'Das Gespräch findet in der App des jeweiligen Anbieters statt, nach '
      'dessen Bedingungen und Datenschutzerklärung. Wir senden nichts dorthin '
      'und speichern nichts außer der Punktzahl, die du einträgst.\n\n'
      'Wenn wir je einen Weg finden, das direkt in die App zu bauen — kostenlos, '
      'für alle — machen wir das.',
  qualityTitle: 'Die Qualität hängt von der KI ab, nicht von uns',
  qualityBody:
      'Manche KI-Apps halten sich genau an die Übung, bewerten sorgfältig und '
      'geben nützliches Feedback. Andere hetzen durch, korrigieren mitten im '
      'Gespräch oder vergessen die Punktzahl ganz. Bezahlte oder neuere Modelle '
      'sind meist deutlich besser.\n\n'
      'Wir haben diese Übungen mit der Gratisversion von Gemini gebaut und '
      'getestet, und dort kamen unsere besten Ergebnisse heraus — aber diese '
      'Dienste ändern sich, und darauf haben wir keinen Einfluss.\n\n'
      'Wichtig zu wissen: Verschiedene KIs bewerten unterschiedlich. Dasselbe '
      'Gespräch kann bei der einen 70 und bei der anderen 80 Punkte bekommen. '
      'Wenn dein Fortschritt etwas heißen soll, bleib bei derselben KI.\n\n'
      'Wenn eine Übung schiefgeht — keine Punktzahl, ständige Korrekturen, '
      'falsche Sprache — liegt das an der KI, nicht an deinem Können. Fang neu '
      'an oder probier eine andere.',
);

const SpeakingStrings kSpeakingStringsEs = SpeakingStrings(
  kindLabel: 'Hablar con una IA',
  howItWorksTitle: 'Cómo funciona este ejercicio',
  step1: 'Copia el ejercicio de abajo.',
  step2: 'Pégalo en tu asistente de IA (lo probamos con la versión gratuita de '
      'Gemini).',
  step3: 'Activa su modo de voz o conversación en vivo.',
  step4: 'Di en voz alta la frase de abajo para empezar. Cuando te dé una '
      'puntuación al final, vuelve y anótala aquí.',
  copyExercise: 'Copiar ejercicio',
  copied: 'Copiado',
  openTitle: 'Ahora abre tu IA',
  openAssistant: 'Abrir {ai}',
  openPasteHint:
      'El ejercicio está en el portapapeles — pégalo ahí y activa el modo de '
      'voz.',
  sayOutLoud: 'Di esto en voz alta para empezar',
  duration: 'Unos {n} minutos',
  disclaimerShort:
      'La calidad depende de la IA que uses — lo probamos con la versión '
      'gratuita de Gemini. Cada IA califica distinto: quédate con una para que '
      'tus puntuaciones sean comparables.',
  scoreSectionTitle: 'Anota tu puntuación',
  scoreHint:
      'Lo mejor: pega el informe completo de la IA (todo lo que hay entre las '
      'líneas =====) — leemos la puntuación y recordamos tus correcciones. '
      'Un número solo también vale.',
  scoreField: 'Puntuación sobre 100',
  scorePlaceholder: 'Pega aquí el informe, o escribe p. ej. 72 o SCORE=72',
  helpMaterialTitle: 'Material del ejercicio',
  helpPractiseTitle: 'Qué practicas',
  helpVocabularyTitle: 'Palabras para usar',
  helpWordColumn: 'Palabra / expresión',
  helpMeaningColumn: 'Significado',
  saveScore: 'Guardar puntuación',
  savedTitle: 'Puntuación guardada',
  bestScore: 'Mejor',
  readFeedback:
      'Lee las correcciones de la IA antes de cerrarla — ahí está el '
      'aprendizaje.',
  runAgain: 'Repetir',
  tryAgain: 'Todavía no — repite el ejercicio y supera esta puntuación.',
  gold: 'Oro',
  silver: 'Plata',
  bronze: 'Bronce',
  whyTitle: '¿Por qué este ejercicio usa otra app?',
  whyBody:
      'Esta app es gratuita, sin cuentas ni suscripciones. La conversación de '
      'voz con IA en vivo es lo único que no podemos ofrecer gratis, así que en '
      'su lugar te damos un ejercicio listo para usar en cualquier asistente de '
      'IA que ya tengas. Aprovechas los mejores modelos de voz, y la app sigue '
      'siendo gratis para todos.\n\n'
      'La conversación ocurre en la app de ese proveedor, bajo sus términos y '
      'su política de privacidad. No les enviamos nada, y no guardamos nada '
      'salvo la puntuación que escribes.\n\n'
      'Si algún día encontramos la forma de integrarlo, gratis y para todos, lo '
      'haremos.',
  qualityTitle: 'La calidad depende de la IA que uses, no de nosotros',
  qualityBody:
      'Algunos asistentes siguen el ejercicio con fidelidad, califican con '
      'cuidado y dan buen feedback. Otros van deprisa, te corrigen en mitad de '
      'la conversación, o se olvidan de darte una puntuación. Los modelos de '
      'pago o más nuevos suelen ser bastante mejores.\n\n'
      'Creamos y probamos estos ejercicios con la versión gratuita de Gemini, y '
      'de ahí salieron nuestros mejores resultados — pero estos servicios '
      'cambian, y eso no está en nuestras manos.\n\n'
      'Algo que conviene saber: cada IA califica distinto. La misma '
      'conversación puede sacar 70 con una y 80 con otra. Si quieres que tu '
      'progreso signifique algo, quédate con el mismo asistente.\n\n'
      'Si un ejercicio sale mal — sin puntuación, correcciones todo el rato, '
      'idioma equivocado — es el asistente, no tu alemán. Empieza de nuevo, o '
      'prueba con otro.',
);

const SpeakingStrings kSpeakingStringsZh = SpeakingStrings(
  kindLabel: '和 AI 对话',
  howItWorksTitle: '这个练习怎么做',
  step1: '复制下面的练习。',
  step2: '粘贴到你的 AI 助手里（我们用 Gemini 免费版测试过）。',
  step3: '打开它的语音或实时对话模式。',
  step4: '大声说出下面这句话开始。结束时它会给你分数，回到这里填进去。',
  copyExercise: '复制练习',
  copied: '已复制',
  openTitle: '现在打开你的 AI',
  openAssistant: '打开 {ai}',
  openPasteHint: '练习已复制到剪贴板——到那边粘贴，然后打开语音模式。',
  sayOutLoud: '大声说这句话开始',
  duration: '大约 {n} 分钟',
  disclaimerShort: '质量取决于你用的 AI——我们用 Gemini 免费版测试。不同的 AI 打分不同，'
      '固定用一个，分数才有可比性。',
  scoreSectionTitle: '填写分数',
  scoreField: '分数（满分 100）',
  scoreHint: '最好：把 AI 的整份报告（===== 行之间的全部内容）粘贴进来——我们会读出分数并记住你的更正。也可以只填数字。',
  scorePlaceholder: '在此粘贴报告，或输入如 72 或 SCORE=72',
  helpMaterialTitle: '练习材料',
  helpPractiseTitle: '练习内容',
  helpVocabularyTitle: '要用到的词',
  helpWordColumn: '词语 / 短语',
  helpMeaningColumn: '意思',
  saveScore: '保存分数',
  savedTitle: '分数已保存',
  bestScore: '最好成绩',
  readFeedback: '关掉之前先读 AI 的批改——学习就在那里。',
  runAgain: '再做一次',
  tryAgain: '还没达到——再做一次，超过这个分数。',
  gold: '金牌',
  silver: '银牌',
  bronze: '铜牌',
  whyTitle: '为什么这个练习要用别的应用？',
  whyBody: '这个应用是免费的，不需要账号，也没有订阅。实时 AI 语音对话是我们唯一无法免费提供的功能——'
      '所以我们改为给你一份现成的练习，你可以在任何已有的 AI 助手里运行。你用得上最新的语音模型，'
      '而这个应用对所有人都保持免费。\n\n'
      '对话发生在那家服务商的应用里，遵循他们的条款和隐私政策。我们不向他们发送任何内容，'
      '也只保存你填进来的分数。\n\n'
      '如果哪天我们找到办法把它免费做进应用里，给所有人用，我们一定会做。',
  qualityTitle: '质量取决于你用的 AI，不取决于我们',
  qualityBody: '有些助手会严格照着练习走，认真打分，给出有用的反馈。有些则草草了事，'
      '在对话中途纠正你，或者干脆忘了给分。付费或更新的模型通常明显更好。\n\n'
      '我们用 Gemini 免费版做出并测试了这些练习，最好的效果也来自那里——'
      '但这些服务会变，我们无法控制。\n\n'
      '有一点要知道：不同的 AI 打分不同。同一段对话，这个给 70，那个给 80。'
      '如果你希望进度有意义，就固定用同一个助手。\n\n'
      '如果练习做砸了——没有分数、全程纠正、语言不对——那是助手的问题，不是你的德语。'
      '重新开始，或者换一个试试。',
);
