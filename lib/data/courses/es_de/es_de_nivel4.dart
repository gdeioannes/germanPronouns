import '../../../models/quiz_content.dart';
import 'es_de_builder.dart';

/// Nivel 4 — Emociones y pareja ("German Emotions").
///
/// Va más allá del alemán de viaje: nombrar lo que sentimos y comunicarnos de
/// forma sana en pareja. La idea central es la *Ich-Botschaft* (mensaje-yo) de
/// la comunicación no violenta: hablar de los propios sentimientos y
/// necesidades en vez de acusar. Registro A2–B1, trato informal ("du").
///
/// Cada bloque temático (A–G) cierra con una lectura situacional que reutiliza
/// su propio vocabulario; los bloques H añaden dos lecturas-resumen (capstone).
/// Las lecturas se leen y se responden en alemán, con la traducción al español
/// detrás de un icono "i" (en el texto y en cada pregunta).

// ───────────────────────────── Bloque A · Las emociones ────────────────────

final QuizContent esDeEmocionesBasicas = sentenceCourseQuiz(
  id: 'es_de_emociones_basicas',
  title: 'Emociones básicas',
  promptLabel: 'Frase',
  subjectsLabel: 'Frases',
  subjectColumnLabel: 'Sentimiento',
  categoryLabel: 'En alemán',
  intro:
      'Lo primero para hablar de sentimientos es poder nombrarlos, pero en una '
      'frase completa. Estos adjetivos de emoción casi siempre van con el verbo '
      '"sein": "Ich bin müde" (estoy cansado). Fíjate en las preposiciones que '
      'acompañan a cada emoción.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Estados con "sein"',
      text: 'Para un estado de ánimo se usa "sein": "Ich bin glücklich". El '
          'adjetivo no cambia después de "sein".',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: '"wütend auf" / "Mir ist langweilig"',
      text: '"enfadado con alguien" = "wütend auf jemanden". Y "estoy aburrido" '
          'se dice con dativo: "Mir ist langweilig", no "Ich bin gelangweilt".',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Hoy soy muy **feliz**', answer: 'Heute bin ich sehr **glücklich**'),
    CourseItem(
      prompt: 'Estoy **contento** con el resultado',
      answer: 'Ich bin **zufrieden** mit dem Ergebnis',
    ),
    CourseItem(
      prompt: 'Hoy estoy un poco **triste**',
      answer: 'Heute bin ich ein bisschen **traurig**',
    ),
    CourseItem(
      prompt: 'Estoy **enfadado** contigo',
      answer: 'Ich bin **wütend** auf dich',
    ),
    CourseItem(prompt: 'Estoy un poco **nervioso**', answer: 'Ich bin ein bisschen **nervös**'),
    CourseItem(prompt: 'Hoy estoy muy **cansado**', answer: 'Ich bin heute sehr **müde**'),
    CourseItem(prompt: 'Estoy **aburrido**', answer: 'Mir ist **langweilig**'),
    CourseItem(prompt: 'Estoy muy **sorprendido**', answer: 'Ich bin sehr **überrascht**'),
    CourseItem(prompt: 'Ahora estoy **tranquilo**', answer: 'Jetzt bin ich **ruhig**'),
    CourseItem(
      prompt: 'Estoy **emocionado** por el viaje',
      answer: 'Ich bin **aufgeregt** wegen der Reise',
    ),
    CourseItem(prompt: 'Estoy muy **estresado** en el trabajo', answer: 'Ich bin sehr **gestresst** bei der Arbeit'),
  ],
);

/// Listen & repeat (audio 1/6).
final QuizContent esDeHablarEmocionesBasicas = speakRepeatQuiz(
  id: 'es_de_hablar_emociones_basicas',
  title: 'Hablar: emociones básicas',
  promptLabel: 'Frase',
  subjectsLabel: 'Frases',
  subjectColumnLabel: 'Alemán',
  intro:
      'Escucha y repite frases enteras con las emociones básicas. Decir la '
      'emoción dentro de una frase suena mucho más natural que decir la palabra '
      'suelta.',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: 'La "ü"',
      text: '"müde" (cansado) suena "mü-de": redondea los labios como para decir '
          '"u" pero di "i". Practica "Ich bin heute sehr müde".',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Dilo con la emoción',
      text: 'Pon el tono de la emoción al repetir: "traurig" triste y bajo, '
          '"aufgeregt" con energía. Ayuda a memorizar.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Hoy soy muy feliz', answer: 'Heute bin ich sehr glücklich'),
    CourseItem(prompt: 'Estoy contento con el resultado', answer: 'Ich bin zufrieden mit dem Ergebnis'),
    CourseItem(prompt: 'Hoy estoy un poco triste', answer: 'Heute bin ich ein bisschen traurig'),
    CourseItem(prompt: 'Estoy enfadado contigo', answer: 'Ich bin wütend auf dich'),
    CourseItem(prompt: 'Estoy un poco nervioso', answer: 'Ich bin ein bisschen nervös'),
    CourseItem(prompt: 'Hoy estoy muy cansado', answer: 'Ich bin heute sehr müde'),
    CourseItem(prompt: 'Estoy aburrido', answer: 'Mir ist langweilig'),
    CourseItem(prompt: 'Ahora estoy tranquilo', answer: 'Jetzt bin ich ruhig'),
    CourseItem(prompt: 'Estoy emocionado por el viaje', answer: 'Ich bin aufgeregt wegen der Reise'),
    CourseItem(prompt: 'Estoy muy estresado en el trabajo', answer: 'Ich bin sehr gestresst bei der Arbeit'),
  ],
);

final QuizContent esDeEmocionesMatices = sentenceCourseQuiz(
  id: 'es_de_emociones_matices',
  title: 'Emociones y matices',
  promptLabel: 'Frase',
  subjectsLabel: 'Frases',
  subjectColumnLabel: 'Sentimiento',
  categoryLabel: 'En alemán',
  intro:
      'Emociones más profundas, las que aparecen en una conversación de pareja, '
      'también en frases completas. Muchas piden una preposición fija: '
      '"enttäuscht von", "dankbar für", "stolz auf", "besorgt um".',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Emoción + preposición',
      text: 'Cada emoción suele llevar su preposición: "enttäuscht von dir" '
          '(decepcionado de ti), "stolz auf uns" (orgulloso de nosotros).',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: '"Es ist mir peinlich"',
      text: 'Para "me da vergüenza" lo natural es "Es ist mir peinlich" (con '
          'dativo), más que "Ich bin beschämt".',
    ),
  ],
  items: const [
    CourseItem(
      prompt: 'Estoy **decepcionado** contigo',
      answer: 'Ich bin **enttäuscht** von dir',
    ),
    CourseItem(prompt: 'A veces soy **celoso**', answer: 'Manchmal bin ich **eifersüchtig**'),
    CourseItem(prompt: 'Estoy muy **dolido**', answer: 'Ich bin sehr **verletzt**'),
    CourseItem(
      prompt: 'A veces me siento **abrumado**',
      answer: 'Manchmal fühle ich mich **überfordert**',
    ),
    CourseItem(
      prompt: 'A veces me siento muy **solo**',
      answer: 'Manchmal fühle ich mich sehr **einsam**',
    ),
    CourseItem(
      prompt: 'Estoy **agradecido** por tu ayuda',
      answer: 'Ich bin **dankbar** für deine Hilfe',
    ),
    CourseItem(prompt: 'Ahora estoy **aliviado**', answer: 'Jetzt bin ich **erleichtert**'),
    CourseItem(prompt: 'Me da **vergüenza**', answer: 'Es ist mir **peinlich**'),
    CourseItem(prompt: 'Me siento **inseguro**', answer: 'Ich fühle mich **unsicher**'),
    CourseItem(prompt: 'Estoy **orgulloso** de nosotros', answer: 'Ich bin **stolz** auf uns'),
    CourseItem(prompt: 'A veces estoy **frustrado**', answer: 'Manchmal bin ich **frustriert**'),
    CourseItem(
      prompt: 'Estoy **preocupado** por ti',
      answer: 'Ich bin **besorgt** um dich',
    ),
  ],
);

/// Listen & repeat (audio 2/6).
final QuizContent esDeHablarEmocionesMatices = speakRepeatQuiz(
  id: 'es_de_hablar_emociones_matices',
  title: 'Hablar: emociones y matices',
  promptLabel: 'Frase',
  subjectsLabel: 'Frases',
  subjectColumnLabel: 'Alemán',
  intro:
      'Repite frases enteras con las emociones más profundas. Son frases con '
      'palabras largas: haz una pequeña pausa y di cada parte con calma.',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: 'Palabras largas, por partes',
      text: '"enttäuscht" = ent-täuscht; "eifersüchtig" = ei-fer-süch-tig. '
          'Primero despacio, luego más fluido.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'La "ei" y la "eu/äu"',
      text: '"ei" suena "ái" (einsam = "áin-zam") y "äu" suena "oi" '
          '(enttäuscht).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Estoy decepcionado contigo', answer: 'Ich bin enttäuscht von dir'),
    CourseItem(prompt: 'A veces soy celoso', answer: 'Manchmal bin ich eifersüchtig'),
    CourseItem(prompt: 'Estoy muy dolido', answer: 'Ich bin sehr verletzt'),
    CourseItem(prompt: 'A veces me siento abrumado', answer: 'Manchmal fühle ich mich überfordert'),
    CourseItem(prompt: 'A veces me siento muy solo', answer: 'Manchmal fühle ich mich sehr einsam'),
    CourseItem(prompt: 'Estoy agradecido por tu ayuda', answer: 'Ich bin dankbar für deine Hilfe'),
    CourseItem(prompt: 'Me da vergüenza', answer: 'Es ist mir peinlich'),
    CourseItem(prompt: 'Estoy orgulloso de nosotros', answer: 'Ich bin stolz auf uns'),
    CourseItem(prompt: 'A veces estoy frustrado', answer: 'Manchmal bin ich frustriert'),
    CourseItem(prompt: 'Estoy preocupado por ti', answer: 'Ich bin besorgt um dich'),
  ],
);

/// Reading (Bloque A): a short diary entry naming the emotions of a normal day.
/// Reuses the basic + nuanced emotion adjectives with "sein"/"sich fühlen".
final QuizContent esDeLecturaEmocionesDia = readingCourseQuiz(
  id: 'es_de_lectura_emociones_dia',
  title: 'Lectura: un día de muchas emociones',
  category: 'Las emociones',
  passageTitle: 'Ein Tag voller Gefühle',
  intro:
      'Lee el diario de un día normal y fíjate en las emociones (müde, '
      'gestresst, glücklich…) con "sein" y "sich fühlen". Léelo primero en '
      'alemán; el icono de traducción está si lo necesitas.',
  passage:
      'Heute war ein Tag voller Gefühle. Am Morgen war ich sehr müde und ein '
      'bisschen nervös, denn ich hatte viel Arbeit. Im Büro war ich gestresst '
      'und am Mittag sogar ein bisschen frustriert.\n\n'
      'Am Nachmittag kam eine gute Nachricht: Mein Projekt ist fertig! '
      'Plötzlich war ich erleichtert und richtig glücklich. Ich war auch stolz '
      'auf mich.\n\n'
      'Am Abend war ich zwar noch müde, aber zufrieden. Jetzt bin ich ruhig '
      'und dankbar für diesen Tag.',
  passageTranslation:
      'Hoy ha sido un día lleno de emociones. Por la mañana estaba muy cansado '
      'y un poco nervioso, porque tenía mucho trabajo. En la oficina estaba '
      'estresado y al mediodía incluso un poco frustrado.\n\n'
      'Por la tarde llegó una buena noticia: ¡mi proyecto está terminado! De '
      'repente estaba aliviado y realmente feliz. También estaba orgulloso de '
      'mí.\n\n'
      'Por la noche todavía estaba cansado, pero satisfecho. Ahora estoy '
      'tranquilo y agradecido por este día.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: '"sein" o "sich fühlen"',
      text: 'Para un estado se usa "sein" ("Ich bin müde") o el reflexivo '
          '"sich fühlen" ("Ich fühle mich allein"). No olvides el "mich".',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Emoción + preposición',
      text: '"stolz auf mich" (orgulloso de mí), "dankbar für" (agradecido '
          'por). Cada emoción suele llevar su preposición fija.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'Wie fühlt sich die Person am Morgen?',
      questionTranslation: '¿Cómo se siente la persona por la mañana?',
      options: [
        'Müde und ein bisschen nervös',
        'Glücklich und ruhig',
        'Stolz und erleichtert',
        'Wütend und eifersüchtig',
      ],
      optionsTranslation: [
        'Cansada y un poco nerviosa',
        'Feliz y tranquila',
        'Orgullosa y aliviada',
        'Enfadada y celosa',
      ],
      correctIndex: 0,
      explanation:
          '«Am Morgen war ich sehr müde und ein bisschen nervös.»',
      explanationTranslation:
          'Por la mañana estaba muy cansada y un poco nerviosa.',
    ),
    ReadingQuestion(
      question: 'Warum war die Person gestresst?',
      questionTranslation: '¿Por qué estaba estresada la persona?',
      options: [
        'Weil sie viel Arbeit hatte',
        'Weil sie krank war',
        'Weil sie Streit hatte',
        'Weil sie kein Geld hatte',
      ],
      optionsTranslation: [
        'Porque tenía mucho trabajo',
        'Porque estaba enferma',
        'Porque había discutido',
        'Porque no tenía dinero',
      ],
      correctIndex: 0,
      explanation:
          '«… denn ich hatte viel Arbeit. Im Büro war ich gestresst.»',
      explanationTranslation:
          '«… denn ich hatte viel Arbeit.» Estaba estresada por la carga de '
          'trabajo.',
    ),
    ReadingQuestion(
      question: 'Wie fühlt sich die Person nach der guten Nachricht?',
      questionTranslation: '¿Cómo se siente tras la buena noticia?',
      options: [
        'Erleichtert und richtig glücklich',
        'Traurig und einsam',
        'Nervös und unsicher',
        'Müde und frustriert',
      ],
      optionsTranslation: [
        'Aliviada y muy feliz',
        'Triste y sola',
        'Nerviosa e insegura',
        'Cansada y frustrada',
      ],
      correctIndex: 0,
      explanation:
          '«Plötzlich war ich erleichtert und richtig glücklich.»',
      explanationTranslation:
          'Tras la buena noticia se sintió aliviada y muy feliz.',
    ),
    ReadingQuestion(
      question: 'Wie ist ihre Stimmung am Abend?',
      questionTranslation: '¿Cuál es su estado de ánimo por la noche?',
      options: [
        'Müde, aber zufrieden und dankbar',
        'Wütend und enttäuscht',
        'Gelangweilt',
        'Eifersüchtig',
      ],
      optionsTranslation: [
        'Cansada, pero satisfecha y agradecida',
        'Enfadada y decepcionada',
        'Aburrida',
        'Celosa',
      ],
      correctIndex: 0,
      explanation:
          '«Am Abend war ich zwar noch müde, aber zufrieden … dankbar für '
          'diesen Tag.»',
      explanationTranslation:
          'Por la noche sigue cansada, pero satisfecha y agradecida.',
    ),
  ],
);

// ──────────────────────── Bloque B · Expresar sentimientos ──────────────────

final QuizContent esDeExpresarSentimientos = sentenceCourseQuiz(
  id: 'es_de_expresar_sentimientos',
  title: 'Expresar cómo me siento',
  promptLabel: 'Frase',
  subjectsLabel: 'Frases',
  subjectColumnLabel: 'Sentimiento',
  categoryLabel: 'En alemán',
  intro:
      'Dos formas básicas para decir cómo estás: "Ich bin …" (estoy …) y "Ich '
      'fühle mich …" (me siento …). "sich fühlen" es reflexivo: no olvides el '
      '"mich".',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: '"Ich fühle mich …"',
      text: '"fühlen" es reflexivo aquí: siempre "Ich fühle mich" + adjetivo. '
          '"Ich fühle mich allein" = me siento solo.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: '"Mir geht es gut/schlecht"',
      text: 'Para "estoy bien/mal" se usa una construcción con dativo: "Mir geht '
          'es gut" o "Es geht mir gut". Las dos valen.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Me siento **triste**', answer: 'Ich fühle mich **traurig**'),
    CourseItem(
      prompt: 'Me siento **solo**',
      answer: 'Ich fühle mich **allein**',
    ),
    CourseItem(prompt: 'Estoy **abrumado**', answer: 'Ich bin **überfordert**'),
    CourseItem(prompt: 'Te **echo de menos**', answer: 'Ich **vermisse** dich'),
    CourseItem(prompt: 'Soy **feliz** contigo', answer: 'Ich bin **glücklich** mit dir'),
    CourseItem(prompt: 'Tengo **miedo**', answer: 'Ich habe **Angst**'),
    CourseItem(prompt: 'Estoy **decepcionado**', answer: 'Ich bin **enttäuscht**'),
    CourseItem(
      prompt: 'No me siento **bien**',
      answer: 'Es geht mir nicht **gut**',
    ),
    CourseItem(
      prompt: 'Necesito **tiempo** para mí',
      answer: 'Ich brauche **Zeit** für mich',
    ),
    CourseItem(prompt: 'Me siento **herido**', answer: 'Ich fühle mich **verletzt**'),
    CourseItem(
      prompt: 'Estoy **agradecido** por ti',
      answer: 'Ich bin **dankbar** für dich',
    ),
    CourseItem(
      prompt: 'Me **cuesta** hablar de esto',
      answer: 'Es fällt mir **schwer**, darüber zu reden',
    ),
  ],
);

/// Listen & repeat (audio 3/6).
final QuizContent esDeHablarSentimientos = speakRepeatQuiz(
  id: 'es_de_hablar_sentimientos',
  title: 'Hablar: expresar sentimientos',
  promptLabel: 'Frase',
  subjectsLabel: 'Frases',
  subjectColumnLabel: 'Alemán',
  intro:
      'Di en voz alta cómo te sientes. Frases cortas que conviene tener listas '
      'para el momento en que de verdad las necesites.',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: '"Ich vermisse dich"',
      text: 'Suena "ish fer-mí-se dish". La "v" se dice "f" y la "ch" de "ich/'
          'dich" es suave.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Tono honesto',
      text: 'Estas frases tienen fuerza por sí solas. Dilas despacio y con '
          'calma; no hace falta exagerar.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Me siento triste', answer: 'Ich fühle mich traurig'),
    CourseItem(prompt: 'Me siento solo', answer: 'Ich fühle mich allein'),
    CourseItem(prompt: 'Estoy abrumado', answer: 'Ich bin überfordert'),
    CourseItem(prompt: 'Te echo de menos', answer: 'Ich vermisse dich'),
    CourseItem(prompt: 'Tengo miedo', answer: 'Ich habe Angst'),
    CourseItem(prompt: 'Estoy decepcionado', answer: 'Ich bin enttäuscht'),
    CourseItem(prompt: 'No me siento bien', answer: 'Es geht mir nicht gut'),
    CourseItem(prompt: 'Necesito tiempo para mí', answer: 'Ich brauche Zeit für mich'),
    CourseItem(prompt: 'Me siento herido', answer: 'Ich fühle mich verletzt'),
    CourseItem(prompt: 'Estoy agradecido por ti', answer: 'Ich bin dankbar für dich'),
  ],
);

/// Reading (Bloque B): an honest little note to a partner. Reuses "Ich fühle
/// mich …", "Ich vermisse dich", "Ich brauche Zeit für mich", "dankbar für".
final QuizContent esDeLecturaNotaSincera = readingCourseQuiz(
  id: 'es_de_lectura_nota_sincera',
  title: 'Lectura: una nota sincera',
  category: 'Expresar sentimientos',
  passageTitle: 'Eine ehrliche Nachricht',
  intro:
      'Jan le escribe una nota a Sofia para decirle cómo se siente. Fíjate en '
      'las fórmulas para expresar sentimientos y léelo primero en alemán.',
  passage:
      'Liebe Sofia,\n\n'
      'ich möchte dir ehrlich schreiben, wie es mir geht. In letzter Zeit geht '
      'es mir nicht gut. Ich bin oft überfordert und manchmal fühle ich mich '
      'allein.\n\n'
      'Es fällt mir schwer, darüber zu reden. Aber ich vermisse dich, wenn du '
      'auf der Arbeit bist. Ich brauche auch ein bisschen Zeit für mich.\n\n'
      'Trotzdem bin ich glücklich mit dir und sehr dankbar für dich. Lass uns '
      'bald in Ruhe reden.\n\n'
      'Jan',
  passageTranslation:
      'Querida Sofia:\n\n'
      'quiero escribirte con sinceridad cómo me siento. Últimamente no me '
      'siento bien. A menudo estoy abrumado y a veces me siento solo.\n\n'
      'Me cuesta hablar de esto. Pero te echo de menos cuando estás en el '
      'trabajo. También necesito un poco de tiempo para mí.\n\n'
      'Aun así soy feliz contigo y estoy muy agradecido por ti. Hablémoslo '
      'pronto con calma.\n\n'
      'Jan',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: '"Ich fühle mich …"',
      text: '"fühlen" es reflexivo: "Ich fühle mich allein". Y para "estoy '
          'bien/mal" se usa el dativo: "Es geht mir (nicht) gut".',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: '"Ich vermisse dich"',
      text: '"vermissen" = echar de menos. "Ich vermisse dich" es una de las '
          'frases más sinceras que puedes decir.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'Wie geht es Jan in letzter Zeit?',
      questionTranslation: '¿Cómo se siente Jan últimamente?',
      options: [
        'Nicht gut, er ist oft überfordert',
        'Sehr gut und entspannt',
        'Wütend auf Sofia',
        'Gelangweilt',
      ],
      optionsTranslation: [
        'No muy bien, a menudo está abrumado',
        'Muy bien y relajado',
        'Enfadado con Sofia',
        'Aburrido',
      ],
      correctIndex: 0,
      explanation:
          '«… geht es mir nicht gut. Ich bin oft überfordert …»',
      explanationTranslation:
          'No se siente bien; a menudo está abrumado.',
    ),
    ReadingQuestion(
      question: 'Was fällt Jan schwer?',
      questionTranslation: '¿Qué le cuesta a Jan?',
      options: [
        'Über seine Gefühle zu reden',
        'Zur Arbeit zu gehen',
        'Zu schlafen',
        'Zu essen',
      ],
      optionsTranslation: [
        'Hablar de sus sentimientos',
        'Ir al trabajo',
        'Dormir',
        'Comer',
      ],
      correctIndex: 0,
      explanation: '«Es fällt mir schwer, darüber zu reden.»',
      explanationTranslation: 'Le cuesta hablar de sus sentimientos.',
    ),
    ReadingQuestion(
      question: 'Was braucht Jan?',
      questionTranslation: '¿Qué necesita Jan?',
      options: [
        'Ein bisschen Zeit für sich',
        'Mehr Geld',
        'Eine neue Arbeit',
        'Einen Urlaub',
      ],
      optionsTranslation: [
        'Un poco de tiempo para sí mismo',
        'Más dinero',
        'Un nuevo trabajo',
        'Unas vacaciones',
      ],
      correctIndex: 0,
      explanation: '«Ich brauche auch ein bisschen Zeit für mich.»',
      explanationTranslation: 'Necesita un poco de tiempo para sí mismo.',
    ),
    ReadingQuestion(
      question: 'Wie fühlt sich Jan trotz allem?',
      questionTranslation: '¿Cómo se siente Jan a pesar de todo?',
      options: [
        'Glücklich mit Sofia und dankbar',
        'Allein und traurig',
        'Enttäuscht von Sofia',
        'Eifersüchtig',
      ],
      optionsTranslation: [
        'Feliz con Sofia y agradecido',
        'Solo y triste',
        'Decepcionado de Sofia',
        'Celoso',
      ],
      correctIndex: 0,
      explanation:
          '«Trotzdem bin ich glücklich mit dir und sehr dankbar für dich.»',
      explanationTranslation:
          'A pesar de todo es feliz con ella y le está agradecido.',
    ),
  ],
);

// ─────────────────────── Bloque C · Comunicación en pareja ──────────────────

final QuizContent esDeAbrirConversacion = sentenceCourseQuiz(
  id: 'es_de_abrir_conversacion',
  title: 'Abrir la conversación',
  promptLabel: 'Frase',
  subjectsLabel: 'Frases',
  subjectColumnLabel: 'Palabra clave',
  categoryLabel: 'En alemán',
  intro:
      'Antes de hablar de algo importante, conviene abrir bien la conversación: '
      'pedir un momento, elegir el tono y dejar claro que no quieres pelear, '
      'sino entenderte.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: '"reden" vs. "sprechen"',
      text: 'Para "hablar de algo" en pareja se usa mucho "reden": "Können wir '
          'reden?". "über etwas reden" = hablar sobre algo.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: '"Passt es dir?"',
      text: '"Passt es dir gerade?" = ¿te viene bien ahora? Preguntar por el '
          'momento adecuado evita discusiones a destiempo.',
    ),
  ],
  items: const [
    CourseItem(prompt: '¿Podemos **hablar**?', answer: 'Können wir **reden**?'),
    CourseItem(prompt: '¿Tienes un **momento**?', answer: 'Hast du kurz **Zeit**?'),
    CourseItem(prompt: '**Tenemos que** hablar', answer: 'Wir **müssen** reden'),
    CourseItem(
      prompt: 'Quiero **hablar** contigo de algo',
      answer: 'Ich möchte mit dir über etwas **reden**',
    ),
    CourseItem(
      prompt: '¿Es un **buen momento**?',
      answer: '**Passt** es dir gerade?',
    ),
    CourseItem(prompt: 'No quiero **discutir**', answer: 'Ich will nicht **streiten**'),
    CourseItem(
      prompt: 'Hablémoslo con **calma**',
      answer: 'Lass uns in **Ruhe** reden',
    ),
    CourseItem(prompt: 'Esto es **importante** para mí', answer: 'Das ist mir **wichtig**'),
    CourseItem(
      prompt: '¿Cómo te **sientes** con esto?',
      answer: 'Wie **fühlst** du dich damit?',
    ),
    CourseItem(prompt: 'Quiero **entenderte**', answer: 'Ich möchte dich **verstehen**'),
  ],
);

final QuizContent esDeMensajesYo = sentenceCourseQuiz(
  id: 'es_de_mensajes_yo',
  title: 'Mensajes-yo (Ich-Botschaften)',
  promptLabel: 'Frase',
  subjectsLabel: 'Frases',
  subjectColumnLabel: 'Palabra clave',
  categoryLabel: 'En alemán',
  intro:
      'El corazón de este nivel: la "Ich-Botschaft" (mensaje-yo). En vez de '
      'acusar ("siempre haces…"), hablas de ti: "me siento … cuando … porque '
      'necesito …". Suena menos a ataque y abre el diálogo.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'El verbo al final',
      text: 'Tras "wenn" (cuando) y "dass" (que) el verbo va al final: "Ich '
          'fühle mich allein, wenn du spät *kommst*".',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'Yo en vez de tú',
      text: 'Compara "Du hörst nie zu" (acusación) con "Ich möchte, dass du mir '
          'zuhörst" (mensaje-yo). La segunda invita a colaborar.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: '"Mir ist wichtig, dass …"',
      text: 'Una fórmula muy útil para pedir algo sin exigir: "Mir ist wichtig, '
          'dass wir ehrlich sind" (para mí es importante que seamos sinceros).',
    ),
  ],
  items: const [
    CourseItem(
      prompt: 'Me siento herido cuando me **ignoras**',
      answer: 'Ich fühle mich verletzt, wenn du mich **ignorierst**',
    ),
    CourseItem(
      prompt: 'Me siento solo cuando **llegas** tarde',
      answer: 'Ich fühle mich allein, wenn du spät **kommst**',
    ),
    CourseItem(
      prompt: 'Para mí es **importante** que hablemos',
      answer: 'Mir ist **wichtig**, dass wir reden',
    ),
    CourseItem(
      prompt: 'Me gustaría que **pasáramos** más tiempo juntos',
      answer: 'Ich wünsche mir, dass wir mehr Zeit zusammen **verbringen**',
    ),
    CourseItem(
      prompt: 'No me gusta cuando **gritas**',
      answer: 'Ich mag es nicht, wenn du **schreist**',
    ),
    CourseItem(
      prompt: 'Quiero que me **escuches**',
      answer: 'Ich möchte, dass du mir **zuhörst**',
    ),
    CourseItem(prompt: 'Necesito tu **apoyo**', answer: 'Ich brauche deine **Unterstützung**'),
    CourseItem(
      prompt: '¿Podemos buscar una **solución** juntos?',
      answer: 'Können wir zusammen eine **Lösung** finden?',
    ),
    CourseItem(
      prompt: 'Necesito sentir que me **valoras**',
      answer: 'Ich brauche das Gefühl, dass du mich **wertschätzt**',
    ),
    CourseItem(
      prompt: 'Me siento **mejor** cuando hablamos',
      answer: 'Ich fühle mich **besser**, wenn wir reden',
    ),
  ],
);

/// Listen & repeat (audio 4/6).
final QuizContent esDeHablarComunicacion = speakRepeatQuiz(
  id: 'es_de_hablar_comunicacion',
  title: 'Hablar: comunicación en pareja',
  promptLabel: 'Frase',
  subjectsLabel: 'Frases',
  subjectColumnLabel: 'Alemán',
  intro:
      'Practica en voz alta cómo abrir una conversación y formular mensajes-yo. '
      'El tono importa tanto como las palabras: tranquilo y sin reproche.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Ritmo de frase larga',
      text: 'En "Ich fühle mich allein, wenn du spät kommst" haz una pequeña '
          'pausa en la coma. Ayuda a que se entienda.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: '"zuhören"',
      text: '"Ich möchte, dass du mir zuhörst" — "zuhören" es escuchar (con '
          'atención). Suena "tsú-hö-ren".',
    ),
  ],
  items: const [
    CourseItem(prompt: '¿Podemos hablar?', answer: 'Können wir reden?'),
    CourseItem(prompt: '¿Tienes un momento?', answer: 'Hast du kurz Zeit?'),
    CourseItem(prompt: 'No quiero discutir', answer: 'Ich will nicht streiten'),
    CourseItem(prompt: 'Hablémoslo con calma', answer: 'Lass uns in Ruhe reden'),
    CourseItem(prompt: 'Quiero entenderte', answer: 'Ich möchte dich verstehen'),
    CourseItem(
      prompt: 'Me siento solo cuando llegas tarde',
      answer: 'Ich fühle mich allein, wenn du spät kommst',
    ),
    CourseItem(prompt: 'Quiero que me escuches', answer: 'Ich möchte, dass du mir zuhörst'),
    CourseItem(prompt: 'Necesito tu apoyo', answer: 'Ich brauche deine Unterstützung'),
    CourseItem(
      prompt: '¿Podemos buscar una solución juntos?',
      answer: 'Können wir zusammen eine Lösung finden?',
    ),
    CourseItem(prompt: 'Esto es importante para mí', answer: 'Das ist mir wichtig'),
  ],
);

final QuizContent esDeEscucharEmpatia = sentenceCourseQuiz(
  id: 'es_de_escuchar_empatia',
  title: 'Escuchar con empatía',
  promptLabel: 'Frase',
  subjectsLabel: 'Frases',
  subjectColumnLabel: 'Palabra clave',
  categoryLabel: 'En alemán',
  intro:
      'Comunicarse bien es la mitad escuchar. Estas frases muestran que estás '
      'presente, validan al otro y le invitan a seguir hablando.',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: '"Ich bin für dich da"',
      text: '"für dich da sein" = estar ahí para alguien. "Ich bin für dich da" '
          'es una de las frases de apoyo más bonitas en alemán.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Validar, no resolver',
      text: 'A veces basta con "Das klingt schwer" (eso suena difícil). No hace '
          'falta dar una solución; escuchar ya ayuda.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Te **entiendo**', answer: 'Ich **verstehe** dich'),
    CourseItem(
      prompt: 'Entiendo cómo te **sientes**',
      answer: 'Ich verstehe, wie du dich **fühlst**',
    ),
    CourseItem(prompt: 'Tienes **razón**', answer: 'Du hast **recht**'),
    CourseItem(prompt: '**Cuéntame** más', answer: '**Erzähl** mir mehr'),
    CourseItem(prompt: 'Te **escucho**', answer: 'Ich **höre** dir zu'),
    CourseItem(prompt: '¿Qué **necesitas** de mí?', answer: 'Was **brauchst** du von mir?'),
    CourseItem(
      prompt: 'Eso **suena** difícil',
      answer: 'Das **klingt** schwer',
    ),
    CourseItem(prompt: 'Estoy **aquí** para ti', answer: 'Ich bin für dich **da**'),
    CourseItem(
      prompt: 'Gracias por **contármelo**',
      answer: 'Danke, dass du es mir **sagst**',
    ),
    CourseItem(prompt: '**Lo siento** mucho', answer: 'Das tut mir sehr **leid**'),
  ],
);

/// Listen & repeat (audio 5/6).
final QuizContent esDeHablarEmpatia = speakRepeatQuiz(
  id: 'es_de_hablar_empatia',
  title: 'Hablar: escuchar con empatía',
  promptLabel: 'Frase',
  subjectsLabel: 'Frases',
  subjectColumnLabel: 'Alemán',
  intro:
      'Repite las frases de empatía y apoyo. Dilas con suavidad: aquí el tono '
      'cálido es la mitad del mensaje.',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: '"Ich höre dir zu"',
      text: 'Verbo separable "zuhören": el "zu" se va al final → "Ich höre dir '
          'zu". Suena "ish hö-re dir tsú".',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Voz tranquila',
      text: 'No subas el volumen: "Ich bin für dich da" funciona mejor dicho '
          'bajito y despacio.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Te entiendo', answer: 'Ich verstehe dich'),
    CourseItem(prompt: 'Entiendo cómo te sientes', answer: 'Ich verstehe, wie du dich fühlst'),
    CourseItem(prompt: 'Tienes razón', answer: 'Du hast recht'),
    CourseItem(prompt: 'Cuéntame más', answer: 'Erzähl mir mehr'),
    CourseItem(prompt: 'Te escucho', answer: 'Ich höre dir zu'),
    CourseItem(prompt: '¿Qué necesitas de mí?', answer: 'Was brauchst du von mir?'),
    CourseItem(prompt: 'Eso suena difícil', answer: 'Das klingt schwer'),
    CourseItem(prompt: 'Estoy aquí para ti', answer: 'Ich bin für dich da'),
    CourseItem(prompt: 'Gracias por contármelo', answer: 'Danke, dass du es mir sagst'),
    CourseItem(prompt: 'Lo siento mucho', answer: 'Das tut mir sehr leid'),
  ],
);

/// Reading (Bloque C): one partner opens a calm conversation with an
/// Ich-Botschaft and the other listens with empathy. Reuses the opener phrases,
/// the "Ich fühle mich …, wenn …" pattern and the empathy phrases.
final QuizContent esDeLecturaConversacionCalma = readingCourseQuiz(
  id: 'es_de_lectura_conversacion_calma',
  title: 'Lectura: una conversación con calma',
  category: 'Comunicación en pareja',
  passageTitle: 'In Ruhe reden',
  intro:
      'Nora abre una conversación con calma y usa un mensaje-yo; Paul escucha '
      'con empatía. Fíjate en cómo lo dice sin acusar y léelo primero en '
      'alemán.',
  passage:
      'Nora setzte sich neben Paul. «Hast du kurz Zeit? Ich möchte mit dir '
      'über etwas reden. Ich will nicht streiten», sagte sie ruhig.\n\n'
      '«Klar, erzähl mir mehr», antwortete Paul.\n\n'
      '«Mir ist wichtig, dass wir am Abend zusammen sind. Ich fühle mich '
      'allein, wenn du immer am Handy bist», sagte Nora. «Ich möchte, dass du '
      'mir mehr zuhörst.»\n\n'
      'Paul nickte. «Du hast recht. Das tut mir leid. Ich verstehe dich, und '
      'ich bin für dich da», sagte er. «Lass uns zusammen eine Lösung finden.»',
  passageTranslation:
      'Nora se sentó al lado de Paul. «¿Tienes un momento? Quiero hablar '
      'contigo de algo. No quiero discutir», dijo con calma.\n\n'
      '«Claro, cuéntame más», respondió Paul.\n\n'
      '«Para mí es importante que estemos juntos por la noche. Me siento sola '
      'cuando siempre estás con el móvil», dijo Nora. «Me gustaría que me '
      'escucharas más.»\n\n'
      'Paul asintió. «Tienes razón. Lo siento. Te entiendo y estoy aquí para '
      'ti», dijo. «Busquemos juntos una solución.»',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: 'Mensaje-yo, no acusación',
      text: 'Compara «Du bist immer am Handy» (acusación) con «Ich fühle mich '
          'allein, wenn du immer am Handy bist» (mensaje-yo).',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Escuchar con empatía',
      text: '«Du hast recht», «Ich verstehe dich», «Ich bin für dich da»: '
          'frases que validan al otro y abren el diálogo.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'Wie beginnt Nora das Gespräch?',
      questionTranslation: '¿Cómo empieza Nora la conversación?',
      options: [
        'Ruhig; sie fragt, ob Paul kurz Zeit hat',
        'Sie schreit Paul an',
        'Sie macht Paul Vorwürfe',
        'Sie geht wütend weg',
      ],
      optionsTranslation: [
        'Con calma; pregunta si Paul tiene un momento',
        'Le grita a Paul',
        'Le hace reproches',
        'Se va enfadada',
      ],
      correctIndex: 0,
      explanation:
          '«Hast du kurz Zeit? … Ich will nicht streiten», sagte sie ruhig.',
      explanationTranslation:
          'Empieza con calma y pide un momento para hablar.',
    ),
    ReadingQuestion(
      question: 'Was ist Nora wichtig?',
      questionTranslation: '¿Qué es importante para Nora?',
      options: [
        'Dass sie am Abend zusammen sind',
        'Dass Paul mehr arbeitet',
        'Dass Paul ihr Geschenke macht',
        'Dass sie allein ist',
      ],
      optionsTranslation: [
        'Estar juntos por la noche',
        'Que Paul trabaje más',
        'Que Paul le haga regalos',
        'Estar sola',
      ],
      correctIndex: 0,
      explanation: '«Mir ist wichtig, dass wir am Abend zusammen sind.»',
      explanationTranslation: 'Le importa estar juntos por la noche.',
    ),
    ReadingQuestion(
      question: 'Welchen Satz benutzt Nora als Ich-Botschaft?',
      questionTranslation: '¿Qué frase usa Nora como mensaje-yo?',
      options: [
        '«Ich fühle mich allein, wenn du immer am Handy bist»',
        '«Du bist immer am Handy»',
        '«Nie hörst du mir zu»',
        '«Du bist egoistisch»',
      ],
      optionsTranslation: [
        '«Me siento sola cuando siempre estás con el móvil»',
        '«Siempre estás con el móvil»',
        '«Nunca me escuchas»',
        '«Eres un egoísta»',
      ],
      correctIndex: 0,
      explanation:
          'Una Ich-Botschaft habla del propio sentimiento: «Ich fühle mich '
          'allein …», en vez de acusar.',
      explanationTranslation:
          'Una Ich-Botschaft habla del propio sentimiento, no acusa al otro.',
    ),
    ReadingQuestion(
      question: 'Wie reagiert Paul?',
      questionTranslation: '¿Cómo reacciona Paul?',
      options: [
        'Mit Empathie; er hört zu und will eine Lösung finden',
        'Er wird wütend',
        'Er ignoriert sie',
        'Er verlässt die Wohnung',
      ],
      optionsTranslation: [
        'Con empatía; escucha y quiere buscar una solución',
        'Se enfada',
        'La ignora',
        'Se va de casa',
      ],
      correctIndex: 0,
      explanation:
          '«Du hast recht … Ich bin für dich da … Lass uns zusammen eine '
          'Lösung finden.»',
      explanationTranslation:
          'Reacciona con empatía: valida, se disculpa y busca una solución.',
    ),
  ],
);

// ─────────────────────── Bloque D · Conflicto y reconciliación ──────────────

final QuizContent esDeConflictos = sentenceCourseQuiz(
  id: 'es_de_conflictos',
  title: 'Conflictos y desacuerdos',
  promptLabel: 'Frase',
  subjectsLabel: 'Frases',
  subjectColumnLabel: 'Palabra clave',
  categoryLabel: 'En alemán',
  intro:
      'Discrepar es normal y sano. Lo importante es hacerlo con respeto: marcar '
      'tu postura, poner un límite y, si hace falta, pedir una pausa antes de '
      'que la cosa suba de tono.',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: '"Ich sehe das anders"',
      text: '"Lo veo diferente" suena mucho mejor que "estás equivocado". '
          '"anders" = de otra manera.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Pedir una pausa',
      text: '"Ich brauche eine Pause" (necesito una pausa) es una herramienta '
          'clave: parar a tiempo evita decir cosas de las que te arrepientas.',
    ),
  ],
  items: const [
    CourseItem(
      prompt: 'No estoy **de acuerdo**',
      answer: 'Ich bin nicht **einverstanden**',
    ),
    CourseItem(prompt: 'Lo veo **diferente**', answer: 'Ich sehe das **anders**'),
    CourseItem(prompt: 'Eso no es **justo**', answer: 'Das ist nicht **fair**'),
    CourseItem(
      prompt: 'Estoy **enfadado**',
      answer: 'Ich bin **wütend**',
    ),
    CourseItem(prompt: 'Me has **decepcionado**', answer: 'Du hast mich **enttäuscht**'),
    CourseItem(
      prompt: 'No me gusta cómo me **hablas**',
      answer: 'Ich mag nicht, wie du mit mir **redest**',
    ),
    CourseItem(prompt: 'Necesito una **pausa**', answer: 'Ich brauche eine **Pause**'),
    CourseItem(prompt: 'Hablemos **más tarde**', answer: 'Lass uns **später** reden'),
    CourseItem(
      prompt: 'No quiero **pelear**',
      answer: 'Ich will mich nicht **streiten**',
    ),
    CourseItem(prompt: '**Cálmate**, por favor', answer: '**Beruhige** dich bitte'),
  ],
);

final QuizContent esDeReconciliacion = sentenceCourseQuiz(
  id: 'es_de_reconciliacion',
  title: 'Reconciliación y perdón',
  promptLabel: 'Frase',
  subjectsLabel: 'Frases',
  subjectColumnLabel: 'Palabra clave',
  categoryLabel: 'En alemán',
  intro:
      'Saber reparar es lo que mantiene fuerte una relación: reconocer el '
      'error, disculparse de verdad y volver a empezar.',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: '"Es tut mir leid"',
      text: 'La disculpa estándar. Para más fuerza: "Es tut mir wirklich leid" '
          '(lo siento de verdad).',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: '"sich vertragen"',
      text: '"Vertragen wir uns wieder" = hagamos las paces. "sich vertragen" '
          'es reconciliarse, llevarse bien de nuevo.',
    ),
  ],
  items: const [
    CourseItem(
      prompt: '**Lo siento**, tienes razón',
      answer: 'Es tut mir **leid**, du hast recht',
    ),
    CourseItem(
      prompt: 'No quería **herirte**',
      answer: 'Ich wollte dich nicht **verletzen**',
    ),
    CourseItem(
      prompt: '**Perdóname**',
      answer: '**Verzeih** mir',
    ),
    CourseItem(prompt: 'Fue **culpa** mía', answer: 'Es war mein **Fehler**'),
    CourseItem(
      prompt: 'Hagamos **las paces**',
      answer: '**Vertragen** wir uns wieder',
    ),
    CourseItem(prompt: 'Te **perdono**', answer: 'Ich **verzeihe** dir'),
    CourseItem(prompt: '**Empecemos** de nuevo', answer: 'Lass uns neu **anfangen**'),
    CourseItem(
      prompt: 'Lo **solucionaremos**',
      answer: 'Wir **bekommen** das hin',
    ),
    CourseItem(prompt: 'Te quiero **a pesar de** todo', answer: 'Ich liebe dich **trotz** allem'),
    CourseItem(
      prompt: 'Gracias por **entenderme**',
      answer: 'Danke, dass du mich **verstehst**',
    ),
  ],
);

/// Listen & repeat (audio 6/6).
final QuizContent esDeHablarReconciliacion = speakRepeatQuiz(
  id: 'es_de_hablar_reconciliacion',
  title: 'Hablar: reconciliación',
  promptLabel: 'Frase',
  subjectsLabel: 'Frases',
  subjectColumnLabel: 'Alemán',
  intro:
      'Practica en voz alta las disculpas y la reconciliación. Que suenen '
      'sinceras: despacio, con contacto visual imaginado y sin prisa.',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: '"Verzeih mir"',
      text: 'Suena "fer-tsái mir". La "v" es "f" y la "z" es "ts". Es más íntimo '
          'que "Entschuldigung".',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Frases de cierre',
      text: '"Wir schaffen das" (lo conseguiremos) cierra bien una '
          'reconciliación. Dilo con seguridad y calma.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Lo siento, tienes razón', answer: 'Es tut mir leid, du hast recht'),
    CourseItem(prompt: 'No quería herirte', answer: 'Ich wollte dich nicht verletzen'),
    CourseItem(prompt: 'Perdóname', answer: 'Verzeih mir'),
    CourseItem(prompt: 'Fue culpa mía', answer: 'Es war mein Fehler'),
    CourseItem(prompt: 'Hagamos las paces', answer: 'Vertragen wir uns wieder'),
    CourseItem(prompt: 'Te perdono', answer: 'Ich verzeihe dir'),
    CourseItem(prompt: 'Empecemos de nuevo', answer: 'Lass uns neu anfangen'),
    CourseItem(prompt: 'Lo solucionaremos', answer: 'Wir schaffen das'),
    CourseItem(prompt: 'Gracias por entenderme', answer: 'Danke, dass du mich verstehst'),
    CourseItem(prompt: 'Te quiero a pesar de todo', answer: 'Ich liebe dich trotz allem'),
  ],
);

final QuizContent esDeAmorAprecio = sentenceCourseQuiz(
  id: 'es_de_amor_aprecio',
  title: 'Amor y aprecio',
  promptLabel: 'Frase',
  subjectsLabel: 'Frases',
  subjectColumnLabel: 'Palabra clave',
  categoryLabel: 'En alemán',
  intro:
      'El cariño también se entrena. Decir lo que valoras del otro, a menudo y '
      'en voz alta, es lo que más cuida una relación.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: '"lieben" vs. "lieb haben"',
      text: '"Ich liebe dich" es el "te amo" pleno. "Ich hab dich lieb" es más '
          'suave y cariñoso, también entre familia y amigos.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: '"Du bedeutest mir viel"',
      text: '"Significas mucho para mí": "bedeuten" = significar, con dativo '
          '("mir"). Una frase de aprecio muy natural.',
    ),
  ],
  items: const [
    CourseItem(prompt: '**Te quiero** (cariño)', answer: 'Ich hab dich **lieb**'),
    CourseItem(prompt: 'Te **amo**', answer: 'Ich **liebe** dich'),
    CourseItem(prompt: '**Significas** mucho para mí', answer: 'Du **bedeutest** mir viel'),
    CourseItem(prompt: 'Me haces **feliz**', answer: 'Du machst mich **glücklich**'),
    CourseItem(prompt: 'Estoy **orgulloso** de ti', answer: 'Ich bin **stolz** auf dich'),
    CourseItem(prompt: 'Gracias por **estar aquí**', answer: 'Danke, dass du **da** bist'),
    CourseItem(prompt: 'Eres **importante** para mí', answer: 'Du bist mir **wichtig**'),
    CourseItem(prompt: 'Te **aprecio**', answer: 'Ich **schätze** dich'),
    CourseItem(prompt: '**Me encanta** estar contigo', answer: 'Ich bin **gern** mit dir zusammen'),
    CourseItem(
      prompt: 'Eres lo mejor que me ha **pasado**',
      answer: 'Du bist das Beste, was mir **passiert** ist',
    ),
  ],
);

/// Reading (Bloque D): a small argument that is paused and then repaired with
/// an apology and words of affection. Reuses the conflict, reconciliation and
/// "amor y aprecio" phrases.
final QuizContent esDeLecturaPeleaPaces = readingCourseQuiz(
  id: 'es_de_lectura_pelea_paces',
  title: 'Lectura: la pelea y las paces',
  category: 'Conflicto y reconciliación',
  passageTitle: 'Streit und Versöhnung',
  intro:
      'Mia y Leon discuten, piden una pausa y luego hacen las paces. Fíjate en '
      'cómo se pone un límite con respeto y cómo se pide perdón. Léelo primero '
      'en alemán.',
  passage:
      'Mia und Leon hatten Streit. «Das ist nicht fair! Du hast mich '
      'enttäuscht», sagte Mia wütend.\n\n'
      '«Ich sehe das anders», antwortete Leon laut. Dann hielt er kurz inne. '
      '«Stopp. Ich will mich nicht streiten. Ich brauche eine Pause. Lass uns '
      'später reden.»\n\n'
      'Eine Stunde später war es ruhiger. «Es tut mir leid, du hast recht», '
      'sagte Leon. «Ich wollte dich nicht verletzen. Verzeih mir.»\n\n'
      '«Ich verzeihe dir», sagte Mia. «Vertragen wir uns wieder. Ich liebe '
      'dich trotz allem.» Leon lächelte: «Du bedeutest mir viel. Wir schaffen '
      'das.»',
  passageTranslation:
      'Mia y Leon discutieron. «¡Eso no es justo! Me has decepcionado», dijo '
      'Mia enfadada.\n\n'
      '«Yo lo veo diferente», respondió Leon en voz alta. Luego se detuvo un '
      'momento. «Para. No quiero pelear. Necesito una pausa. Hablemos más '
      'tarde.»\n\n'
      'Una hora después estaba todo más tranquilo. «Lo siento, tienes razón», '
      'dijo Leon. «No quería herirte. Perdóname.»\n\n'
      '«Te perdono», dijo Mia. «Hagamos las paces. Te quiero a pesar de todo.» '
      'Leon sonrió: «Significas mucho para mí. Lo conseguiremos.»',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Pedir una pausa',
      text: '«Ich brauche eine Pause. Lass uns später reden» evita que la '
          'discusión suba de tono. Parar a tiempo es una herramienta clave.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'Disculpa + aprecio',
      text: '«Es tut mir leid … Verzeih mir» (disculpa) y «Du bedeutest mir '
          'viel» (aprecio): reparar la relación tras el conflicto.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'Warum ist Mia wütend?',
      questionTranslation: '¿Por qué está enfadada Mia?',
      options: [
        'Weil Leon sie enttäuscht hat',
        'Weil Leon zu spät kam',
        'Weil Leon krank ist',
        'Weil Leon kein Geld hat',
      ],
      optionsTranslation: [
        'Porque Leon la ha decepcionado',
        'Porque Leon llegó tarde',
        'Porque Leon está enfermo',
        'Porque Leon no tiene dinero',
      ],
      correctIndex: 0,
      explanation: '«Das ist nicht fair! Du hast mich enttäuscht», sagte Mia.',
      explanationTranslation: 'Está enfadada porque Leon la ha decepcionado.',
    ),
    ReadingQuestion(
      question: 'Was macht Leon, als der Streit lauter wird?',
      questionTranslation: '¿Qué hace Leon cuando la pelea sube de tono?',
      options: [
        'Er bittet um eine Pause',
        'Er schreit weiter',
        'Er geht für immer',
        'Er lacht',
      ],
      optionsTranslation: [
        'Pide una pausa',
        'Sigue gritando',
        'Se va para siempre',
        'Se ríe',
      ],
      correctIndex: 0,
      explanation: '«Ich brauche eine Pause. Lass uns später reden.»',
      explanationTranslation: 'Pide una pausa para no seguir discutiendo.',
    ),
    ReadingQuestion(
      question: 'Wie entschuldigt sich Leon?',
      questionTranslation: '¿Cómo se disculpa Leon?',
      options: [
        '«Es tut mir leid … Verzeih mir»',
        '«Es war nicht meine Schuld»',
        '«Du bist schuld»',
        '«Das ist mir egal»',
      ],
      optionsTranslation: [
        '«Lo siento … Perdóname»',
        '«No fue culpa mía»',
        '«Es culpa tuya»',
        '«Me da igual»',
      ],
      correctIndex: 0,
      explanation:
          '«Es tut mir leid, du hast recht … Verzeih mir.» Reconoce su error.',
      explanationTranslation:
          '«Es tut mir leid … Verzeih mir.» Reconoce su error y pide perdón.',
    ),
    ReadingQuestion(
      question: 'Wie endet die Szene?',
      questionTranslation: '¿Cómo termina la escena?',
      options: [
        'Sie versöhnen sich und zeigen Zuneigung',
        'Sie trennen sich',
        'Sie reden nie wieder',
        'Sie streiten weiter',
      ],
      optionsTranslation: [
        'Se reconcilian y muestran cariño',
        'Se separan',
        'No vuelven a hablar',
        'Siguen peleando',
      ],
      correctIndex: 0,
      explanation:
          '«Vertragen wir uns wieder. Ich liebe dich … Du bedeutest mir viel.»',
      explanationTranslation:
          'Hacen las paces y se expresan cariño y aprecio.',
    ),
  ],
);

// ─────────────── Bloque E · Comunicación emocional profunda (B2–C1) ─────────
// Tier avanzado: vocabulario abstracto y matices para hablar de vínculo,
// vulnerabilidad y distancia emocional. Usa Konjunktiv II para suavizar deseos.

final QuizContent esDeVinculoVocab = sentenceCourseQuiz(
  id: 'es_de_vinculo_vocab',
  title: 'Vínculo: vocabulario (B2)',
  promptLabel: 'Frase',
  subjectsLabel: 'Frases',
  subjectColumnLabel: 'Palabra clave',
  categoryLabel: 'En alemán',
  intro:
      'Nivel B2: los sustantivos abstractos del vínculo emocional. Casi todos '
      'son femeninos (die Nähe, die Geborgenheit) y aparecen en frases con '
      '"brauchen", "schätzen" o "sich sehnen nach".',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: '"sich sehnen nach"',
      text: '"anhelar algo" = "sich nach etwas sehnen" (+ dativo): "Ich sehne '
          'mich nach Nähe". El "nach" rige dativo.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'Sustantivos abstractos',
      text: 'die Geborgenheit (seguridad afectiva), die Wertschätzung '
          '(aprecio), die Sehnsucht (anhelo): conceptos clave a nivel B2.',
    ),
  ],
  items: const [
    CourseItem(
      prompt: 'La **confianza** es la base de todo',
      answer: '**Vertrauen** ist die Basis von allem',
    ),
    CourseItem(prompt: 'Necesito más **cercanía** emocional', answer: 'Ich brauche mehr emotionale **Nähe**'),
    CourseItem(
      prompt: 'Para mí la **seguridad afectiva** es importante',
      answer: '**Geborgenheit** ist mir wichtig',
    ),
    CourseItem(prompt: 'Valoro mucho tu **sinceridad**', answer: 'Ich schätze deine **Ehrlichkeit** sehr'),
    CourseItem(
      prompt: 'Tengo una gran **necesidad** de afecto',
      answer: 'Ich habe ein großes **Bedürfnis** nach Zuneigung',
    ),
    CourseItem(
      prompt: 'Siento mucho **aprecio** por ti',
      answer: 'Ich empfinde große **Wertschätzung** für dich',
    ),
    CourseItem(prompt: 'A veces siento un **vacío**', answer: 'Manchmal fühle ich eine **Leere**'),
    CourseItem(
      prompt: 'Anhelo más **ternura**',
      answer: 'Ich sehne mich nach mehr **Zärtlichkeit**',
    ),
    CourseItem(
      prompt: 'El **respeto** mutuo es esencial',
      answer: 'Gegenseitiger **Respekt** ist entscheidend',
    ),
    CourseItem(
      prompt: 'Nuestra relación necesita más **atención**',
      answer: 'Unsere Beziehung braucht mehr **Aufmerksamkeit**',
    ),
    CourseItem(prompt: 'Quiero sentirme **comprendido**', answer: 'Ich möchte mich **verstanden** fühlen'),
    CourseItem(
      prompt: 'Echo de menos nuestra **complicidad**',
      answer: 'Ich vermisse unsere **Vertrautheit**',
    ),
  ],
);

final QuizContent esDeVulnerabilidad = sentenceCourseQuiz(
  id: 'es_de_vulnerabilidad',
  title: 'Vulnerabilidad y cercanía (B2–C1)',
  promptLabel: 'Frase',
  subjectsLabel: 'Frases',
  subjectColumnLabel: 'Palabra clave',
  categoryLabel: 'En alemán',
  intro:
      'Abrirse de verdad. A este nivel se usa mucho el Konjunktiv II para '
      'suavizar ("Ich würde mir wünschen, dass…", "Ich wünschte, wir würden…") '
      'y oraciones con verbo al final.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Konjunktiv II para suavizar',
      text: '"Ich würde mir wünschen, dass du fragst…" suena más delicado que '
          '"Ich will, dass…". Es la cortesía del alemán culto.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: '"sich verlassen auf"',
      text: '"contar con alguien" = "sich auf jemanden verlassen": "Ich kann '
          'mich auf dich verlassen". No confundir con "verlassen" (abandonar).',
    ),
  ],
  items: const [
    CourseItem(
      prompt: 'Me cuesta mostrarme **vulnerable**',
      answer: 'Es fällt mir schwer, mich **verletzlich** zu zeigen',
    ),
    CourseItem(prompt: 'Quiero **abrirme** más a ti', answer: 'Ich möchte mich dir mehr **öffnen**'),
    CourseItem(
      prompt: 'A veces me escondo tras una **fachada**',
      answer: 'Manchmal verstecke ich mich hinter einer **Fassade**',
    ),
    CourseItem(
      prompt: 'Necesito sentir que puedo **contar contigo**',
      answer: 'Ich muss das Gefühl haben, dass ich mich auf dich **verlassen** kann',
    ),
    CourseItem(prompt: 'Te muestro mi lado más **sensible**', answer: 'Ich zeige dir meine **verletzliche** Seite'),
    CourseItem(prompt: 'A tu lado me siento **seguro**', answer: 'An deiner Seite fühle ich mich **geborgen**'),
    CourseItem(
      prompt: 'Ojalá **habláramos** más de nuestros sentimientos',
      answer: 'Ich wünschte, wir würden mehr über unsere Gefühle **sprechen**',
    ),
    CourseItem(prompt: 'Necesito tu **cercanía**, no soluciones', answer: 'Ich brauche deine **Nähe**, keine Lösungen'),
    CourseItem(
      prompt: 'Me gustaría que me **preguntaras** cómo estoy',
      answer: 'Ich würde mir wünschen, dass du mich **fragst**, wie es mir geht',
    ),
    CourseItem(
      prompt: 'Confiar me da miedo, pero quiero **intentarlo**',
      answer: 'Vertrauen macht mir Angst, aber ich möchte es **versuchen**',
    ),
    CourseItem(
      prompt: 'Cuando me **abrazas**, me siento comprendido',
      answer: 'Wenn du mich **umarmst**, fühle ich mich verstanden',
    ),
    CourseItem(
      prompt: 'Quiero que me **aceptes** como soy',
      answer: 'Ich möchte, dass du mich so **akzeptierst**, wie ich bin',
    ),
  ],
);

final QuizContent esDeDistancia = sentenceCourseQuiz(
  id: 'es_de_distancia',
  title: 'Distancia y desconexión (B2–C1)',
  promptLabel: 'Frase',
  subjectsLabel: 'Frases',
  subjectColumnLabel: 'Palabra clave',
  categoryLabel: 'En alemán',
  intro:
      'Nombrar el distanciamiento antes de que sea tarde. Verbos reflexivos y '
      'separables clave: "sich auseinanderleben" (distanciarse), "sich '
      'entfernen" (alejarse), "zueinander finden" (reencontrarse).',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: '"sich auseinanderleben"',
      text: '"Wir haben uns auseinandergelebt" = nos hemos distanciado (con el '
          'tiempo). Es una expresión muy típica al hablar de crisis.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: '"an erster Stelle stehen"',
      text: '"ser la prioridad" = "an erster Stelle stehen". "Ich stehe nicht '
          'mehr an erster Stelle" = ya no soy la prioridad.',
    ),
  ],
  items: const [
    CourseItem(
      prompt: 'Tengo la sensación de que nos hemos **distanciado**',
      answer: 'Ich habe das Gefühl, dass wir uns **auseinandergelebt** haben',
    ),
    CourseItem(prompt: 'Me siento emocionalmente **descuidado**', answer: 'Ich fühle mich emotional **vernachlässigt**'),
    CourseItem(prompt: 'Últimamente **apenas** hablamos', answer: 'In letzter Zeit reden wir **kaum** noch'),
    CourseItem(
      prompt: 'Me siento solo **aunque** estés aquí',
      answer: 'Ich fühle mich allein, **obwohl** du da bist',
    ),
    CourseItem(prompt: 'Echo de menos cómo éramos **antes**', answer: 'Ich vermisse, wie wir **früher** waren'),
    CourseItem(
      prompt: 'Tengo miedo de que nos estemos **alejando**',
      answer: 'Ich habe Angst, dass wir uns voneinander **entfernen**',
    ),
    CourseItem(
      prompt: 'Ya no siento que sea tu **prioridad**',
      answer: 'Ich habe nicht mehr das Gefühl, an erster **Stelle** zu stehen',
    ),
    CourseItem(prompt: 'Necesito que volvamos a **conectar**', answer: 'Ich brauche, dass wir wieder **zueinander** finden'),
    CourseItem(prompt: 'A veces me siento **invisible**', answer: 'Manchmal fühle ich mich **übersehen**'),
    CourseItem(prompt: 'Quiero **recuperar** nuestra cercanía', answer: 'Ich möchte unsere Nähe **zurückgewinnen**'),
    CourseItem(prompt: 'Me duele tu **indiferencia**', answer: 'Deine **Gleichgültigkeit** verletzt mich'),
    CourseItem(prompt: 'Deberíamos **cuidar** más lo nuestro', answer: 'Wir sollten mehr auf uns **achten**'),
  ],
);

/// Listen & repeat (audio 7/9 — tier avanzado).
final QuizContent esDeHablarProfunda = speakRepeatQuiz(
  id: 'es_de_hablar_profunda',
  title: 'Hablar: comunicación profunda',
  promptLabel: 'Frase',
  subjectsLabel: 'Frases',
  subjectColumnLabel: 'Alemán',
  intro:
      'Di en voz alta frases largas y delicadas. A este nivel, las pausas y la '
      'entonación transmiten tanto como las palabras: tómate tu tiempo.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Frases subordinadas',
      text: 'En "…, dass wir uns auseinandergelebt haben" el verbo va al final. '
          'Haz una pausa tras la coma para que se entienda.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'La "v" de "vernachlässigt"',
      text: '"vernachlässigt" suena "fer-náj-le-sigt". La "v" es "f" y la "ch" '
          'es suave.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Necesito más cercanía emocional', answer: 'Ich brauche mehr emotionale Nähe'),
    CourseItem(prompt: 'Anhelo más ternura', answer: 'Ich sehne mich nach mehr Zärtlichkeit'),
    CourseItem(prompt: 'Quiero sentirme comprendido', answer: 'Ich möchte mich verstanden fühlen'),
    CourseItem(prompt: 'Me cuesta mostrarme vulnerable', answer: 'Es fällt mir schwer, mich verletzlich zu zeigen'),
    CourseItem(prompt: 'A tu lado me siento seguro', answer: 'An deiner Seite fühle ich mich geborgen'),
    CourseItem(prompt: 'Quiero que me aceptes como soy', answer: 'Ich möchte, dass du mich so akzeptierst, wie ich bin'),
    CourseItem(prompt: 'Nos hemos distanciado', answer: 'Wir haben uns auseinandergelebt'),
    CourseItem(prompt: 'Me siento emocionalmente descuidado', answer: 'Ich fühle mich emotional vernachlässigt'),
    CourseItem(prompt: 'Me siento solo aunque estés aquí', answer: 'Ich fühle mich allein, obwohl du da bist'),
    CourseItem(prompt: 'Quiero recuperar nuestra cercanía', answer: 'Ich möchte unsere Nähe zurückgewinnen'),
  ],
);

/// Reading (Bloque E): a reflective B2 journal entry about emotional distance
/// and the wish for closeness. Reuses the abstract bond vocabulary, the
/// vulnerability verbs and Konjunktiv II ("Ich wünschte, wir würden …").
final QuizContent esDeLecturaMasCerca = readingCourseQuiz(
  id: 'es_de_lectura_mas_cerca',
  title: 'Lectura: más cerca otra vez (B2–C1)',
  category: 'Comunicación profunda',
  passageTitle: 'Wieder zueinander finden',
  intro:
      'Un texto reflexivo (B2). Alguien escribe sobre el distanciamiento y su '
      'deseo de cercanía. Fíjate en el vocabulario abstracto (Nähe, '
      'Vertrautheit) y el Konjunktiv II. Léelo primero en alemán.',
  passage:
      'Seit einigen Monaten habe ich das Gefühl, dass wir uns auseinandergelebt '
      'haben. Wir reden kaum noch, und manchmal fühle ich mich allein, obwohl '
      'du neben mir sitzt.\n\n'
      'Ich vermisse unsere Vertrautheit und die emotionale Nähe von früher. Ich '
      'brauche mehr Aufmerksamkeit und das Gefühl, an erster Stelle zu '
      'stehen.\n\n'
      'Es fällt mir schwer, mich verletzlich zu zeigen. Aber ich möchte mich '
      'dir wieder öffnen, denn ich vertraue dir. Ich wünschte, wir würden öfter '
      'über unsere Gefühle sprechen.\n\n'
      'Ich will keine Vorwürfe machen. Ich möchte nur, dass wir wieder '
      'zueinander finden und mehr auf uns achten.',
  passageTranslation:
      'Desde hace unos meses tengo la sensación de que nos hemos ido '
      'distanciando. Apenas hablamos, y a veces me siento solo, aunque estés '
      'sentado a mi lado.\n\n'
      'Echo de menos nuestra complicidad y la cercanía emocional de antes. '
      'Necesito más atención y sentir que soy la prioridad.\n\n'
      'Me cuesta mostrarme vulnerable. Pero quiero volver a abrirme a ti, '
      'porque confío en ti. Ojalá habláramos más a menudo de nuestros '
      'sentimientos.\n\n'
      'No quiero hacer reproches. Solo quiero que volvamos a reconectar y que '
      'nos cuidemos más.',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: '"sich auseinanderleben"',
      text: '«Wir haben uns auseinandergelebt» = nos hemos distanciado con el '
          'tiempo. Expresión muy típica para hablar de una crisis.',
    ),
    HelpMemoryTip(
      kind: 'rule',
      title: 'Konjunktiv II para suavizar',
      text: '«Ich wünschte, wir würden … sprechen» suena más delicado que «Ich '
          'will, dass …». Es la cortesía del alemán culto.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'Welches Gefühl beschreibt die Person?',
      questionTranslation: '¿Qué sensación describe la persona?',
      options: [
        'Dass sie sich auseinandergelebt haben',
        'Dass alles perfekt ist',
        'Dass sie verliebt wie am Anfang ist',
        'Dass sie umziehen will',
      ],
      optionsTranslation: [
        'Que se han ido distanciando',
        'Que todo es perfecto',
        'Que está enamorada como al principio',
        'Que quiere mudarse',
      ],
      correctIndex: 0,
      explanation:
          '«… dass wir uns auseinandergelebt haben.» Siente que se han '
          'distanciado.',
      explanationTranslation:
          'Describe la sensación de haberse ido distanciando.',
    ),
    ReadingQuestion(
      question: 'Was vermisst die Person?',
      questionTranslation: '¿Qué echa de menos la persona?',
      options: [
        'Die Vertrautheit und emotionale Nähe von früher',
        'Mehr Geld',
        'Mehr Urlaub',
        'Eine größere Wohnung',
      ],
      optionsTranslation: [
        'La complicidad y la cercanía emocional de antes',
        'Más dinero',
        'Más vacaciones',
        'Una casa más grande',
      ],
      correctIndex: 0,
      explanation:
          '«Ich vermisse unsere Vertrautheit und die emotionale Nähe von '
          'früher.»',
      explanationTranslation:
          'Echa de menos la complicidad y la cercanía emocional de antes.',
    ),
    ReadingQuestion(
      question: 'Was fällt der Person schwer?',
      questionTranslation: '¿Qué le cuesta a la persona?',
      options: [
        'Sich verletzlich zu zeigen',
        'Zu arbeiten',
        'Zu reisen',
        'Zu kochen',
      ],
      optionsTranslation: [
        'Mostrarse vulnerable',
        'Trabajar',
        'Viajar',
        'Cocinar',
      ],
      correctIndex: 0,
      explanation: '«Es fällt mir schwer, mich verletzlich zu zeigen.»',
      explanationTranslation: 'Le cuesta mostrarse vulnerable.',
    ),
    ReadingQuestion(
      question: 'Was wünscht sich die Person am Ende?',
      questionTranslation: '¿Qué desea la persona al final?',
      options: [
        'Dass sie wieder zueinander finden und mehr aufeinander achten',
        'Dass sie sich trennen',
        'Dass der andere geht',
        'Dass sich nichts ändert',
      ],
      optionsTranslation: [
        'Que vuelvan a reconectar y se cuiden más',
        'Que se separen',
        'Que el otro se vaya',
        'Que nada cambie',
      ],
      correctIndex: 0,
      explanation:
          '«… dass wir wieder zueinander finden und mehr auf uns achten.»',
      explanationTranslation:
          'Desea que vuelvan a reconectar y se cuiden más.',
    ),
  ],
);

// ──────────────── Bloque F · Confrontación y conflicto (B2–C1) ───────────────
// Discusiones serias, límites, patrones que se repiten y ruptura de confianza,
// siempre buscando una salida constructiva.

final QuizContent esDeConflictoVocab = sentenceCourseQuiz(
  id: 'es_de_conflicto_vocab',
  title: 'Conflicto: vocabulario (B2)',
  promptLabel: 'Frase',
  subjectsLabel: 'Frases',
  subjectColumnLabel: 'Palabra clave',
  categoryLabel: 'En alemán',
  intro:
      'El léxico preciso del conflicto: der Vorwurf (reproche), die '
      'Auseinandersetzung (enfrentamiento), der Kompromiss, die Grenze. '
      'Diferéncialos del lenguaje básico de la pelea cotidiana.',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: '"Grenzen ziehen/setzen"',
      text: '"poner límites" = "Grenzen ziehen" o "Grenzen setzen". "Ich muss '
          'eine Grenze ziehen" = tengo que poner un límite.',
    ),
    HelpMemoryTip(
      kind: 'rule',
      title: '"jemandem Vorwürfe machen"',
      text: '"hacer reproches a alguien" rige dativo: "Ich will dir keine '
          'Vorwürfe machen". El "dir" es dativo.',
    ),
  ],
  items: const [
    CourseItem(
      prompt: 'Otra vez la misma **discusión**',
      answer: 'Schon wieder dieselbe **Auseinandersetzung**',
    ),
    CourseItem(prompt: 'No quiero hacerte **reproches**', answer: 'Ich will dir keine **Vorwürfe** machen'),
    CourseItem(prompt: 'Necesitamos un **compromiso**', answer: 'Wir brauchen einen **Kompromiss**'),
    CourseItem(prompt: 'Tengo que poner un **límite**', answer: 'Ich muss eine **Grenze** ziehen'),
    CourseItem(prompt: 'Esto fue un **malentendido**', answer: 'Das war ein **Missverständnis**'),
    CourseItem(prompt: 'Las **acusaciones** no ayudan', answer: '**Schuldzuweisungen** helfen nicht'),
    CourseItem(prompt: 'La situación se está **agravando**', answer: 'Die Situation **eskaliert**'),
    CourseItem(
      prompt: 'Necesitamos una **conversación franca**',
      answer: 'Wir brauchen eine offene **Aussprache**',
    ),
    CourseItem(prompt: 'Estás **evitando** el tema', answer: 'Du **weichst** dem Thema aus'),
    CourseItem(prompt: 'No **soporto** estas peleas constantes', answer: 'Ich **ertrage** diese ständigen Streits nicht'),
    CourseItem(prompt: 'Hay mucha **tensión** entre nosotros', answer: 'Zwischen uns herrscht viel **Spannung**'),
    CourseItem(prompt: 'Quiero que nos **respetemos**', answer: 'Ich möchte, dass wir uns **respektieren**'),
  ],
);

final QuizContent esDeAfrontarConflicto = sentenceCourseQuiz(
  id: 'es_de_afrontar_conflicto',
  title: 'Afrontar el conflicto (B2–C1)',
  promptLabel: 'Frase',
  subjectsLabel: 'Frases',
  subjectColumnLabel: 'Palabra clave',
  categoryLabel: 'En alemán',
  intro:
      'Discutir sin destruir: mantenerse objetivo, dejar terminar al otro y '
      'buscar una solución conjunta. Verbos útiles: ausreden lassen (dejar '
      'terminar), nachgeben (ceder), sachlich bleiben (ser objetivo).',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: '"ausreden lassen"',
      text: '"dejar terminar de hablar" = "jemanden ausreden lassen". "Lass '
          'mich bitte ausreden" = déjame terminar, por favor.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: '"sachlich bleiben"',
      text: '"sachlich" = objetivo, centrado en los hechos. "Lass uns sachlich '
          'bleiben" baja la temperatura de una discusión.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Tenemos que hablar **en serio**', answer: 'Wir müssen **ernsthaft** reden'),
    CourseItem(prompt: 'Así no podemos **seguir**', answer: 'Das geht so nicht **weiter**'),
    CourseItem(prompt: 'Quiero entender tu **punto de vista**', answer: 'Ich möchte deine **Sichtweise** verstehen'),
    CourseItem(prompt: 'Seamos **objetivos**', answer: 'Lass uns **sachlich** bleiben'),
    CourseItem(prompt: 'No me **grites**, por favor', answer: 'Bitte **schrei** mich nicht an'),
    CourseItem(
      prompt: 'Me gustaría que me dejaras **terminar**',
      answer: 'Ich würde mir wünschen, dass du mich **ausreden** lässt',
    ),
    CourseItem(prompt: 'Estamos dando vueltas en **círculo**', answer: 'Wir drehen uns im **Kreis**'),
    CourseItem(prompt: 'Busquemos juntos una **solución**', answer: 'Lass uns gemeinsam eine **Lösung** finden'),
    CourseItem(prompt: 'Necesito que asumas tu **parte**', answer: 'Ich brauche, dass du deinen **Anteil** übernimmst'),
    CourseItem(prompt: 'Estoy dispuesto a **ceder**', answer: 'Ich bin bereit, **nachzugeben**'),
    CourseItem(
      prompt: 'No quiero **ganar**, quiero que nos entendamos',
      answer: 'Ich will nicht **gewinnen**, ich will uns verstehen',
    ),
    CourseItem(
      prompt: 'Hagamos una pausa antes de **seguir**',
      answer: 'Lass uns eine Pause machen, bevor wir **weiterreden**',
    ),
  ],
);

final QuizContent esDeConfianzaRota = sentenceCourseQuiz(
  id: 'es_de_confianza_rota',
  title: 'Cuando se rompe la confianza (B2–C1)',
  promptLabel: 'Frase',
  subjectsLabel: 'Frases',
  subjectColumnLabel: 'Palabra clave',
  categoryLabel: 'En alemán',
  intro:
      'Las palabras para la herida más difícil: la traición y la confianza '
      'rota. Verbos clave: hintergehen (traicionar), missbrauchen (abusar de), '
      'anlügen (mentir a). El objetivo sigue siendo reparar, no hundir.',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: '"jemanden hintergehen"',
      text: '"traicionar a alguien" = "jemanden hintergehen". "Ich fühle mich '
          'hintergangen" = me siento traicionado.',
    ),
    HelpMemoryTip(
      kind: 'rule',
      title: '"schaden" + dativo',
      text: '"perjudicar a algo/alguien" rige dativo: "Das hat unserer '
          'Beziehung geschadet" (eso ha dañado nuestra relación).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Me has **decepcionado** profundamente', answer: 'Du hast mich zutiefst **enttäuscht**'),
    CourseItem(prompt: 'Me siento **traicionado**', answer: 'Ich fühle mich **hintergangen**'),
    CourseItem(prompt: 'Has **abusado** de mi confianza', answer: 'Du hast mein Vertrauen **missbraucht**'),
    CourseItem(prompt: 'Me has **mentido**', answer: 'Du hast mich **angelogen**'),
    CourseItem(prompt: 'Necesito tiempo para volver a **confiar**', answer: 'Ich brauche Zeit, um wieder zu **vertrauen**'),
    CourseItem(prompt: '¿Cómo voy a volver a **creerte**?', answer: 'Wie soll ich dir wieder **glauben**?'),
    CourseItem(
      prompt: 'Me siento **herido** y enfadado a la vez',
      answer: 'Ich fühle mich **verletzt** und wütend zugleich',
    ),
    CourseItem(prompt: 'Necesito **sinceridad** total', answer: 'Ich brauche absolute **Ehrlichkeit**'),
    CourseItem(prompt: 'La **confianza** se reconstruye despacio', answer: '**Vertrauen** baut sich langsam wieder auf'),
    CourseItem(prompt: 'Quiero creer que puedes **cambiar**', answer: 'Ich will glauben, dass du dich **ändern** kannst'),
    CourseItem(prompt: 'Esto ha **dañado** mucho nuestra relación', answer: 'Das hat unserer Beziehung sehr **geschadet**'),
    CourseItem(prompt: 'No puedo **seguir** así', answer: 'So kann ich nicht **weitermachen**'),
  ],
);

/// Listen & repeat (audio 8/9 — tier avanzado).
final QuizContent esDeHablarConfrontacion = speakRepeatQuiz(
  id: 'es_de_hablar_confrontacion',
  title: 'Hablar: confrontación',
  promptLabel: 'Frase',
  subjectsLabel: 'Frases',
  subjectColumnLabel: 'Alemán',
  intro:
      'Practica frases de confrontación con firmeza pero sin gritar. El tono '
      'controlado es lo que las hace eficaces en un conflicto real.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Firme, no agresivo',
      text: '"Das geht so nicht weiter" gana fuerza dicho despacio y serio, no '
          'a gritos. Controla el volumen.',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'Verbos separables',
      text: '"Du weichst dem Thema aus" — el "aus" va al final. "anschreien", '
          '"anlügen" funcionan igual.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Tenemos que hablar en serio', answer: 'Wir müssen ernsthaft reden'),
    CourseItem(prompt: 'Así no podemos seguir', answer: 'Das geht so nicht weiter'),
    CourseItem(prompt: 'Seamos objetivos', answer: 'Lass uns sachlich bleiben'),
    CourseItem(prompt: 'Estamos dando vueltas en círculo', answer: 'Wir drehen uns im Kreis'),
    CourseItem(prompt: 'No quiero hacerte reproches', answer: 'Ich will dir keine Vorwürfe machen'),
    CourseItem(prompt: 'Me siento traicionado', answer: 'Ich fühle mich hintergangen'),
    CourseItem(prompt: 'Necesito tiempo para volver a confiar', answer: 'Ich brauche Zeit, um wieder zu vertrauen'),
    CourseItem(prompt: 'No quiero ganar, quiero que nos entendamos', answer: 'Ich will nicht gewinnen, ich will uns verstehen'),
    CourseItem(prompt: 'Necesito que asumas tu parte', answer: 'Ich brauche, dass du deinen Anteil übernimmst'),
    CourseItem(prompt: 'Busquemos juntos una solución', answer: 'Lass uns gemeinsam eine Lösung finden'),
  ],
);

/// Reading (Bloque F): a serious but constructive confrontation. Reuses the
/// conflict nouns (Auseinandersetzung, Vorwürfe, Grenze, Kompromiss) and the
/// "afrontar el conflicto" phrases (sachlich bleiben, ausreden lassen, Anteil).
final QuizContent esDeLecturaConversacionFranca = readingCourseQuiz(
  id: 'es_de_lectura_conversacion_franca',
  title: 'Lectura: una conversación franca (B2–C1)',
  category: 'Confrontación y conflicto',
  passageTitle: 'Eine offene Aussprache',
  intro:
      'Clara y Tomás afrontan una discusión que se repite. Fíjate en cómo '
      'mantienen el tono objetivo, ponen un límite y buscan una solución. '
      'Léelo primero en alemán.',
  passage:
      '«Schon wieder dieselbe Auseinandersetzung», seufzte Clara. «Wir drehen '
      'uns im Kreis. Das geht so nicht weiter.»\n\n'
      '«Ich will dir keine Vorwürfe machen», sagte Tomás, «aber ich brauche '
      'eine offene Aussprache. Lass uns sachlich bleiben, und bitte schrei '
      'mich nicht an.»\n\n'
      '«Du weichst dem Thema immer aus», antwortete Clara. «Ich muss eine '
      'Grenze ziehen. Ich möchte, dass wir uns respektieren und einander '
      'ausreden lassen.»\n\n'
      'Tomás atmete tief durch. «Du hast recht. Ich übernehme meinen Anteil. '
      'Ich will nicht gewinnen, ich will, dass wir eine Lösung finden. '
      'Vielleicht brauchen wir einen Kompromiss.»',
  passageTranslation:
      '«Otra vez la misma discusión», suspiró Clara. «Estamos dando vueltas en '
      'círculo. Así no podemos seguir.»\n\n'
      '«No quiero hacerte reproches», dijo Tomás, «pero necesito una '
      'conversación franca. Seamos objetivos y, por favor, no me grites.»\n\n'
      '«Siempre evitas el tema», respondió Clara. «Tengo que poner un límite. '
      'Quiero que nos respetemos y que nos dejemos terminar de hablar.»\n\n'
      'Tomás respiró hondo. «Tienes razón. Asumo mi parte. No quiero ganar, '
      'quiero que encontremos una solución. Quizá necesitemos un compromiso.»',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: '"Grenzen ziehen"',
      text: '«Ich muss eine Grenze ziehen» = tengo que poner un límite. '
          'También vale «Grenzen setzen».',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: '"sachlich bleiben"',
      text: '«Lass uns sachlich bleiben» (seamos objetivos) baja la temperatura '
          'de una discusión. «jemanden ausreden lassen» = dejar terminar.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'Worüber beschwert sich Clara am Anfang?',
      questionTranslation: '¿De qué se queja Clara al principio?',
      options: [
        'Dass sie sich im Kreis drehen und es so nicht weitergeht',
        'Dass Tomás zu viel arbeitet',
        'Dass Tomás sie hintergangen hat',
        'Dass sie umziehen müssen',
      ],
      optionsTranslation: [
        'De que dan vueltas en círculo y así no pueden seguir',
        'De que Tomás trabaja demasiado',
        'De que Tomás la ha traicionado',
        'De que tienen que mudarse',
      ],
      correctIndex: 0,
      explanation: '«Wir drehen uns im Kreis. Das geht so nicht weiter.»',
      explanationTranslation:
          'Se queja de que dan vueltas en círculo y así no pueden seguir.',
    ),
    ReadingQuestion(
      question: 'Was braucht Tomás?',
      questionTranslation: '¿Qué necesita Tomás?',
      options: [
        'Eine offene Aussprache, sachlich und ohne Schreien',
        'Mehr Freiheit',
        'Ein neues Auto',
        'Eine Pause vom Job',
      ],
      optionsTranslation: [
        'Una conversación franca, objetiva y sin gritos',
        'Más libertad',
        'Un coche nuevo',
        'Una pausa del trabajo',
      ],
      correctIndex: 0,
      explanation:
          '«… ich brauche eine offene Aussprache. Lass uns sachlich bleiben …»',
      explanationTranslation:
          'Necesita una conversación franca, objetiva y sin gritos.',
    ),
    ReadingQuestion(
      question: 'Was möchte Clara setzen?',
      questionTranslation: '¿Qué quiere poner Clara?',
      options: [
        'Eine Grenze; sie will einander ausreden lassen',
        'Ein Ultimatum',
        'Eine Wette',
        'Eine Frist',
      ],
      optionsTranslation: [
        'Un límite; quiere que se dejen terminar de hablar',
        'Un ultimátum',
        'Una apuesta',
        'Un plazo',
      ],
      correctIndex: 0,
      explanation:
          '«Ich muss eine Grenze ziehen. Ich möchte, dass wir uns '
          'respektieren und einander ausreden lassen.»',
      explanationTranslation:
          'Quiere poner un límite y que se dejen terminar de hablar.',
    ),
    ReadingQuestion(
      question: 'Wie reagiert Tomás am Ende konstruktiv?',
      questionTranslation: '¿Cómo reacciona Tomás de forma constructiva al final?',
      options: [
        'Er übernimmt seinen Anteil und sucht eine Lösung',
        'Er will unbedingt gewinnen',
        'Er weicht weiter aus',
        'Er macht ihr Vorwürfe',
      ],
      optionsTranslation: [
        'Asume su parte y busca una solución',
        'Quiere ganar a toda costa',
        'Sigue evitando el tema',
        'Le hace reproches',
      ],
      correctIndex: 0,
      explanation:
          '«Ich übernehme meinen Anteil. Ich will nicht gewinnen, ich will, '
          'dass wir eine Lösung finden.»',
      explanationTranslation:
          'Asume su parte y, en vez de ganar, busca una solución.',
    ),
  ],
);

// ──────────────── Bloque G · Ruptura y reconciliación (B2–C1) ────────────────
// Las conversaciones más duras: la ruptura, la separación respetuosa y la
// reconstrucción profunda de la relación. Énfasis en la reparación.

final QuizContent esDeRuptura = sentenceCourseQuiz(
  id: 'es_de_ruptura',
  title: 'La ruptura (B2–C1)',
  promptLabel: 'Frase',
  subjectsLabel: 'Frases',
  subjectColumnLabel: 'Palabra clave',
  categoryLabel: 'En alemán',
  intro:
      'Cómo decir lo más difícil con honestidad y respeto. Verbos clave: sich '
      'trennen (separarse), sich entlieben (desenamorarse), sich entfernen '
      '(alejarse). Decir la verdad no está reñido con el cuidado.',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: '"Es liegt an …"',
      text: '"es por…" / "la causa es…" = "es liegt an …" (+ dativo): "Es liegt '
          'nicht an dir" = no es por ti.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: '"der Liebeskummer"',
      text: '"el mal de amores / corazón roto" = "der Liebeskummer". "Ich habe '
          'Liebeskummer" es lo natural, más que "mein Herz ist gebrochen".',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Creo que deberíamos **separarnos**', answer: 'Ich glaube, wir sollten uns **trennen**'),
    CourseItem(prompt: 'Necesito un **tiempo**', answer: 'Ich brauche eine **Auszeit**'),
    CourseItem(prompt: 'Ya no **encajamos**', answer: 'Wir passen einfach nicht mehr **zusammen**'),
    CourseItem(prompt: 'Te quiero, pero ya no **basta**', answer: 'Ich liebe dich, aber es **reicht** nicht mehr'),
    CourseItem(prompt: 'Me he **desenamorado**', answer: 'Ich habe mich **entliebt**'),
    CourseItem(
      prompt: 'No **imagino** un futuro juntos',
      answer: 'Ich kann mir keine gemeinsame Zukunft mehr **vorstellen**',
    ),
    CourseItem(prompt: 'No es **por ti**, soy yo', answer: 'Es **liegt** nicht an dir, es liegt an mir'),
    CourseItem(prompt: 'Esto me resulta muy **difícil**', answer: 'Das fällt mir unglaublich **schwer**'),
    CourseItem(
      prompt: 'Nos hemos ido **alejando** con el tiempo',
      answer: 'Wir haben uns mit der Zeit voneinander **entfernt**',
    ),
    CourseItem(prompt: 'Necesito seguir mi propio **camino**', answer: 'Ich muss meinen eigenen **Weg** gehen'),
    CourseItem(prompt: 'Tengo el **corazón roto**', answer: 'Ich habe **Liebeskummer**'),
    CourseItem(prompt: 'No quiero seguir fingiendo', answer: 'Ich will nicht länger so tun als ob'),
  ],
);

final QuizContent esDeSeparacionRespetuosa = sentenceCourseQuiz(
  id: 'es_de_separacion_respetuosa',
  title: 'Separarse en buenos términos (B2–C1)',
  promptLabel: 'Frase',
  subjectsLabel: 'Frases',
  subjectColumnLabel: 'Palabra clave',
  categoryLabel: 'En alemán',
  intro:
      'Si la relación termina, terminar bien también es una forma de cuidado. '
      'Gratitud, respeto y buenos deseos: "im Guten auseinandergehen" '
      '(separarse en buenos términos).',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: '"im Guten auseinandergehen"',
      text: '"separarse en buenos términos" = "im Guten auseinandergehen". Lo '
          'contrario: "im Streit auseinandergehen" (terminar peleados).',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: '"in guter Erinnerung behalten"',
      text: '"guardar un buen recuerdo de alguien" = "jemanden in guter '
          'Erinnerung behalten".',
    ),
  ],
  items: const [
    CourseItem(
      prompt: 'Quiero que nos separemos **en buenos términos**',
      answer: 'Ich möchte, dass wir im Guten **auseinandergehen**',
    ),
    CourseItem(
      prompt: 'Te **agradezco** nuestro tiempo juntos',
      answer: 'Ich bin **dankbar** für unsere gemeinsame Zeit',
    ),
    CourseItem(
      prompt: 'Siempre te **recordaré** con cariño',
      answer: 'Ich werde dich immer in guter **Erinnerung** behalten',
    ),
    CourseItem(prompt: 'Sigamos siendo **respetuosos**', answer: 'Lass uns **respektvoll** bleiben'),
    CourseItem(
      prompt: 'No quiero que terminemos con **rencor**',
      answer: 'Ich möchte nicht im **Streit** auseinandergehen',
    ),
    CourseItem(prompt: '**Aprendí** mucho contigo', answer: 'Ich habe viel von dir **gelernt**'),
    CourseItem(prompt: 'Te **deseo** lo mejor', answer: 'Ich **wünsche** dir alles Gute'),
    CourseItem(
      prompt: 'Hablémoslo con calma y sin **reproches**',
      answer: 'Lass uns in Ruhe und ohne **Vorwürfe** reden',
    ),
    CourseItem(prompt: 'Espero que sigamos en **contacto**', answer: 'Ich hoffe, wir bleiben in **Kontakt**'),
    CourseItem(
      prompt: 'Esto no borra lo bueno que **vivimos**',
      answer: 'Das löscht nicht aus, was wir Schönes **erlebt** haben',
    ),
    CourseItem(prompt: '**Cuídate** mucho', answer: '**Pass** gut auf dich auf'),
    CourseItem(prompt: 'No te **guardo rencor**', answer: 'Ich bin dir nicht **böse**'),
  ],
);

final QuizContent esDeReconstruir = sentenceCourseQuiz(
  id: 'es_de_reconstruir',
  title: 'Reconstruir la relación (B2–C1)',
  promptLabel: 'Frase',
  subjectsLabel: 'Frases',
  subjectColumnLabel: 'Palabra clave',
  categoryLabel: 'En alemán',
  intro:
      'El camino de vuelta: asumir la responsabilidad, recuperar la confianza y '
      'atreverse a empezar de nuevo. Aquí está el corazón reparador del curso: '
      '"an der Beziehung arbeiten" (trabajar en la relación).',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: '"Verantwortung übernehmen"',
      text: '"asumir la responsabilidad" = "Verantwortung übernehmen". "Ich '
          'übernehme die Verantwortung für meinen Anteil" suena muy maduro.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: '"um jemanden kämpfen"',
      text: '"luchar por alguien" = "um jemanden kämpfen": "Ich will um uns '
          'kämpfen" = quiero luchar por nosotros.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Quiero **trabajar** en nuestra relación', answer: 'Ich möchte an unserer Beziehung **arbeiten**'),
    CourseItem(prompt: 'Atrevámonos a un **nuevo comienzo**', answer: 'Lass uns einen **Neuanfang** wagen'),
    CourseItem(
      prompt: 'Asumo la **responsabilidad** de mi parte',
      answer: 'Ich übernehme die **Verantwortung** für meinen Anteil',
    ),
    CourseItem(prompt: 'Quiero **recuperar** tu confianza', answer: 'Ich möchte dein Vertrauen **zurückgewinnen**'),
    CourseItem(prompt: 'Estoy dispuesto a **perdonarte**', answer: 'Ich bin bereit, dir zu **verzeihen**'),
    CourseItem(
      prompt: 'Te prometo que voy a **esforzarme**',
      answer: 'Ich verspreche dir, dass ich mich **bemühen** werde',
    ),
    CourseItem(
      prompt: 'Me he **dado cuenta** de lo importante que eres para mí',
      answer: 'Mir ist **klar** geworden, wie wichtig du mir bist',
    ),
    CourseItem(prompt: '¿Podemos **empezar de cero**?', answer: 'Können wir noch einmal von vorne **anfangen**?'),
    CourseItem(prompt: 'Quizá una **terapia de pareja** nos ayude', answer: 'Vielleicht hilft uns eine **Paartherapie**'),
    CourseItem(prompt: 'Quiero **luchar** por nosotros', answer: 'Ich will um uns **kämpfen**'),
    CourseItem(prompt: 'Necesitaremos **paciencia**', answer: 'Wir werden **Geduld** brauchen'),
    CourseItem(prompt: 'Te perdono **de verdad**', answer: 'Ich verzeihe dir **wirklich**'),
  ],
);

/// Listen & repeat (audio 9/9 — tier avanzado).
final QuizContent esDeHablarRupturaReconciliacion = speakRepeatQuiz(
  id: 'es_de_hablar_ruptura_reconciliacion',
  title: 'Hablar: ruptura y reconciliación',
  promptLabel: 'Frase',
  subjectsLabel: 'Frases',
  subjectColumnLabel: 'Alemán',
  intro:
      'Las frases más difíciles, en voz alta. Dilas despacio y con calma: tanto '
      'una despedida como una reconciliación merecen un tono cuidado.',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: '"sich trennen"',
      text: '"wir sollten uns trennen" suena "viir zóllten uns trénnen". La "z" '
          'es "ts" y la "tr" es nítida.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Tono según el mensaje',
      text: 'Una ruptura pide calma y suavidad; una reconciliación, calidez y '
          'seguridad. Adapta la voz al contenido.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Creo que deberíamos separarnos', answer: 'Ich glaube, wir sollten uns trennen'),
    CourseItem(prompt: 'Ya no encajamos', answer: 'Wir passen einfach nicht mehr zusammen'),
    CourseItem(prompt: 'Quiero que nos separemos en buenos términos', answer: 'Ich möchte, dass wir im Guten auseinandergehen'),
    CourseItem(prompt: 'Te deseo lo mejor', answer: 'Ich wünsche dir alles Gute'),
    CourseItem(prompt: 'Quiero trabajar en nuestra relación', answer: 'Ich möchte an unserer Beziehung arbeiten'),
    CourseItem(prompt: 'Asumo la responsabilidad de mi parte', answer: 'Ich übernehme die Verantwortung für meinen Anteil'),
    CourseItem(prompt: 'Quiero recuperar tu confianza', answer: 'Ich möchte dein Vertrauen zurückgewinnen'),
    CourseItem(prompt: '¿Podemos empezar de cero?', answer: 'Können wir noch einmal von vorne anfangen?'),
    CourseItem(prompt: 'Quiero luchar por nosotros', answer: 'Ich will um uns kämpfen'),
    CourseItem(prompt: 'Te perdono de verdad', answer: 'Ich verzeihe dir wirklich'),
  ],
);

/// Reading (Bloque G): a respectful goodbye. The capstone (Bloque H) shows a
/// couple that repairs; this one shows a couple that ends well. Reuses the
/// breakup verbs and the "separarse en buenos términos" phrases.
final QuizContent esDeLecturaDespedida = readingCourseQuiz(
  id: 'es_de_lectura_despedida',
  title: 'Lectura: una despedida en buenos términos (B2–C1)',
  category: 'Ruptura y reconciliación',
  passageTitle: 'Im Guten auseinandergehen',
  intro:
      'Eva y Daniel deciden separarse, pero con respeto y gratitud. Fíjate en '
      'los verbos de la ruptura (sich trennen, sich entfernen) y en las frases '
      'para terminar en buenos términos. Léelo primero en alemán.',
  passage:
      'Es war eine schwere Entscheidung, aber Eva und Daniel hatten sie '
      'gemeinsam getroffen: Sie wollten sich trennen.\n\n'
      '«Wir passen einfach nicht mehr zusammen», sagte Eva leise. «Wir haben '
      'uns mit der Zeit voneinander entfernt. Es liegt nicht an dir.»\n\n'
      '«Ich weiß», antwortete Daniel. «Es fällt mir schwer, aber ich möchte, '
      'dass wir im Guten auseinandergehen. Ich bin dankbar für unsere '
      'gemeinsame Zeit und habe viel von dir gelernt.»\n\n'
      '«Lass uns ohne Vorwürfe reden und respektvoll bleiben», sagte Eva. «Ich '
      'werde dich in guter Erinnerung behalten. Ich wünsche dir alles Gute. '
      'Pass gut auf dich auf.»',
  passageTranslation:
      'Fue una decisión difícil, pero Eva y Daniel la habían tomado juntos: '
      'querían separarse.\n\n'
      '«Simplemente ya no encajamos», dijo Eva en voz baja. «Nos hemos ido '
      'alejando con el tiempo. No es por ti.»\n\n'
      '«Lo sé», respondió Daniel. «Me resulta difícil, pero quiero que nos '
      'separemos en buenos términos. Estoy agradecido por nuestro tiempo '
      'juntos y he aprendido mucho de ti.»\n\n'
      '«Hablémoslo sin reproches y sigamos siendo respetuosos», dijo Eva. «Te '
      'recordaré con cariño. Te deseo lo mejor. Cuídate mucho.»',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: '"im Guten auseinandergehen"',
      text: '«Im Guten auseinandergehen» = separarse en buenos términos. Lo '
          'contrario: «im Streit auseinandergehen» (terminar peleados).',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: '"Es liegt nicht an dir"',
      text: '«Es liegt an …» (+ dativo) = la causa es… «Es liegt nicht an dir» '
          '= no es por ti.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'Welche Entscheidung haben Eva und Daniel getroffen?',
      questionTranslation: '¿Qué decisión han tomado Eva y Daniel?',
      options: [
        'Sich zu trennen',
        'Zu heiraten',
        'Zusammenzuziehen',
        'Ein Kind zu bekommen',
      ],
      optionsTranslation: [
        'Separarse',
        'Casarse',
        'Irse a vivir juntos',
        'Tener un hijo',
      ],
      correctIndex: 0,
      explanation: '«… sie wollten sich trennen.»',
      explanationTranslation: 'Han decidido separarse.',
    ),
    ReadingQuestion(
      question: 'Wie erklärt Eva die Trennung?',
      questionTranslation: '¿Cómo explica Eva la separación?',
      options: [
        'Sie passen nicht mehr zusammen und haben sich entfernt',
        'Daniel hat sie hintergangen',
        'Daniel hat sie angelogen',
        'Sie hat jemand Neuen',
      ],
      optionsTranslation: [
        'Ya no encajan y se han alejado',
        'Daniel la ha traicionado',
        'Daniel le ha mentido',
        'Ella tiene a otra persona',
      ],
      correctIndex: 0,
      explanation:
          '«Wir passen einfach nicht mehr zusammen … Wir haben uns … '
          'voneinander entfernt.»',
      explanationTranslation:
          'Ya no encajan y se han ido alejando con el tiempo.',
    ),
    ReadingQuestion(
      question: 'Wie möchte Daniel auseinandergehen?',
      questionTranslation: '¿Cómo quiere separarse Daniel?',
      options: [
        'Im Guten, dankbar für die gemeinsame Zeit',
        'Im Streit',
        'Ohne ein Wort',
        'Mit Vorwürfen',
      ],
      optionsTranslation: [
        'En buenos términos, agradecido por el tiempo juntos',
        'Peleados',
        'Sin decir nada',
        'Con reproches',
      ],
      correctIndex: 0,
      explanation:
          '«… ich möchte, dass wir im Guten auseinandergehen. Ich bin dankbar '
          'für unsere gemeinsame Zeit …»',
      explanationTranslation:
          'Quiere separarse en buenos términos y agradece el tiempo juntos.',
    ),
    ReadingQuestion(
      question: 'Was wünscht Eva Daniel zum Schluss?',
      questionTranslation: '¿Qué le desea Eva a Daniel al final?',
      options: [
        'Alles Gute; sie behält ihn in guter Erinnerung',
        'Dass es ihm schlecht geht',
        'Dass er sie vergisst',
        'Dass er alles bezahlt',
      ],
      optionsTranslation: [
        'Todo lo mejor; lo recordará con cariño',
        'Que le vaya mal',
        'Que la olvide',
        'Que lo pague todo',
      ],
      correctIndex: 0,
      explanation:
          '«Ich werde dich in guter Erinnerung behalten. Ich wünsche dir alles '
          'Gute.»',
      explanationTranslation:
          'Le desea lo mejor y lo recordará con cariño.',
    ),
  ],
);

// ─────────────────────────── Bloque H · Lectura ─────────────────────────────

/// Reading-comprehension capstone: a couple resolves a misunderstanding using
/// an Ich-Botschaft. Ties together the vocabulary and the communication tools.
final QuizContent esDeLecturaPareja = readingCourseQuiz(
  id: 'es_de_lectura_pareja',
  title: 'Lectura: una conversación de pareja',
  category: 'Emociones y pareja',
  passageTitle: 'Ein schwieriger Abend',
  intro:
      'Lee un breve diálogo entre Anna y Tom. Fíjate en cómo Anna usa un '
      'mensaje-yo en vez de acusar, y responde luego a las preguntas.',
  passage:
      'Anna und Tom hatten einen schwierigen Abend. Tom kam spät von der Arbeit '
      'nach Hause, ohne anzurufen. Anna war zuerst wütend, aber dann atmete sie '
      'tief durch.\n\n'
      '«Tom, können wir kurz reden? Ich möchte nicht streiten», sagte sie ruhig. '
      '«Ich habe mir Sorgen gemacht, als du nicht angerufen hast. Ich habe mich '
      'allein gefühlt.»\n\n'
      'Tom hörte ihr zu. «Es tut mir leid», antwortete er. «Du hast recht. Ich '
      'war im Stress und habe nicht an dich gedacht. Das nächste Mal schreibe '
      'ich dir eine Nachricht.»\n\n'
      'Anna lächelte. «Danke. Das ist mir wichtig.» Sie umarmten sich, und der '
      'Abend wurde doch noch schön.',
  passageTranslation:
      'Anna y Tom tuvieron una noche difícil. Tom llegó tarde del trabajo a '
      'casa, sin avisar. Anna al principio estaba enfadada, pero luego respiró '
      'hondo.\n\n'
      '«Tom, ¿podemos hablar un momento? No quiero discutir», dijo con calma. '
      '«Me preocupé cuando no llamaste. Me sentí sola.»\n\n'
      'Tom la escuchó. «Lo siento», respondió. «Tienes razón. Estaba estresado '
      'y no pensé en ti. La próxima vez te escribiré un mensaje.»\n\n'
      'Anna sonrió. «Gracias. Eso es importante para mí.» Se abrazaron, y la '
      'noche acabó siendo bonita de todos modos.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '"als" para el pasado',
      text: '"als du nicht angerufen hast" = cuando no llamaste. Para un momento '
          'concreto del pasado se usa "als", no "wenn".',
    ),
    HelpMemoryTip(
      kind: 'example',
      title: 'La clave: la Ich-Botschaft',
      text: 'Anna no dice "Du rufst nie an!" (acusación), sino "Ich habe mich '
          'allein gefühlt" (mensaje-yo). Por eso Tom no se pone a la defensiva.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'Warum hat sich Anna Sorgen gemacht?',
      questionTranslation: '¿Por qué estaba preocupada Anna?',
      options: [
        'Weil Tom spät und ohne anzurufen nach Hause kam',
        'Weil Tom sie angeschrien hat',
        'Weil Tom ihren Geburtstag vergessen hat',
        'Weil Tom sich trennen wollte',
      ],
      optionsTranslation: [
        'Porque Tom llegó tarde sin avisar',
        'Porque Tom le gritó',
        'Porque Tom olvidó su cumpleaños',
        'Porque Tom quería separarse',
      ],
      correctIndex: 0,
      explanation:
          '«Tom kam spät … nach Hause, ohne anzurufen.» Er kam spät und ohne '
          'anzurufen — deshalb hat sich Anna Sorgen gemacht.',
      explanationTranslation:
          '"Tom kam spät … nach Hause, ohne anzurufen." Llegó tarde sin llamar, '
          'y por eso Anna se preocupó.',
    ),
    ReadingQuestion(
      question: 'Wie hat Anna zuerst reagiert und was hat sie dann gemacht?',
      questionTranslation: '¿Cómo reaccionó Anna al principio y qué hizo después?',
      options: [
        'Sie war wütend, aber sie atmete tief durch und sprach ruhig',
        'Sie fing sofort an zu schreien',
        'Sie ging ohne ein Wort aus dem Haus',
        'Sie tat so, als wäre nichts passiert',
      ],
      optionsTranslation: [
        'Se enfadó, pero respiró hondo y habló con calma',
        'Se puso a gritar enseguida',
        'Se fue de casa sin decir nada',
        'Fingió que no pasaba nada',
      ],
      correctIndex: 0,
      explanation:
          '«Anna war zuerst wütend, aber dann atmete sie tief durch» und sie '
          'sprach «ruhig».',
      explanationTranslation:
          '"Anna war zuerst wütend, aber dann atmete sie tief durch" y habló '
          '"ruhig" (con calma).',
    ),
    ReadingQuestion(
      question: 'Was hat Tom geantwortet?',
      questionTranslation: '¿Qué respondió Tom?',
      options: [
        '«Es tut mir leid, du hast recht»',
        '«Das ist nicht meine Schuld»',
        '«Ich will darüber nicht reden»',
        '«Du beschwerst dich immer»',
      ],
      optionsTranslation: [
        '«Lo siento, tienes razón»',
        '«No es culpa mía»',
        '«No quiero hablar de esto»',
        '«Siempre te quejas»',
      ],
      correctIndex: 0,
      explanation:
          '«Es tut mir leid … Du hast recht.» Tom gibt den Fehler zu, statt '
          'sich zu verteidigen.',
      explanationTranslation:
          '«Es tut mir leid … Du hast recht.» Tom reconoce el error en lugar de '
          'defenderse.',
    ),
    ReadingQuestion(
      question: 'Welcher dieser Sätze ist eine Ich-Botschaft?',
      questionTranslation: '¿Cuál de estas frases es un "mensaje-yo" (Ich-Botschaft)?',
      options: [
        '«Ich habe mich allein gefühlt, als du nicht angerufen hast»',
        '«Du kommst immer zu spät»',
        '«Du denkst nie an mich»',
        '«Du bist egoistisch»',
      ],
      optionsTranslation: [
        '«Me sentí sola cuando no llamaste»',
        '«Siempre llegas tarde»',
        '«Nunca piensas en mí»',
        '«Eres un egoísta»',
      ],
      correctIndex: 0,
      explanation:
          'Eine Ich-Botschaft spricht über die eigenen Gefühle, ohne '
          'anzuklagen: «Ich habe mich allein gefühlt.» Die anderen drei sind '
          'Vorwürfe («Du …»).',
      explanationTranslation:
          'Un mensaje-yo habla de los propios sentimientos sin acusar: "Ich '
          'habe mich allein gefühlt". Las otras tres son reproches ("tú …").',
    ),
  ],
);

/// Reading-comprehension capstone (B2–C1): a couple that has drifted apart has
/// an honest "Aussprache", owns their share, and chooses repair over breakup.
final QuizContent esDeLecturaAussprache = readingCourseQuiz(
  id: 'es_de_lectura_aussprache',
  title: 'Lectura: la conversación decisiva (B2–C1)',
  category: 'Emociones y pareja',
  passageTitle: 'Die Aussprache',
  intro:
      'Un diálogo más exigente (B2–C1). Lena y Markus llevan meses '
      'distanciados. Fíjate en el vocabulario avanzado (sich auseinanderleben, '
      'Vorwürfe, Verantwortung übernehmen, Neuanfang) y luego responde.',
  passage:
      'Lena und Markus saßen sich am Küchentisch gegenüber. Seit Monaten hatten '
      'sie sich auseinandergelebt – sie stritten oft, oder sie schwiegen.\n\n'
      '«Ich muss ehrlich sein», begann Markus leise. «In letzter Zeit habe ich '
      'sogar daran gedacht, zu gehen.» Lena schluckte. «Das tut weh zu hören. '
      'Aber ich bin froh, dass du es aussprichst.»\n\n'
      '«Ich will dir keine Vorwürfe machen», sagte sie. «Ich habe mich auch '
      'zurückgezogen. Ich übernehme meinen Anteil daran.» Markus nickte. '
      '«Vielleicht brauchen wir Hilfe von außen. Was hältst du von einer '
      'Paartherapie?»\n\n'
      'Lena überlegte. «Ich möchte es versuchen. Ich bin noch nicht bereit '
      'aufzugeben.» Zum ersten Mal seit Langem griff Markus nach ihrer Hand. '
      '«Dann wagen wir einen Neuanfang – langsam, Schritt für Schritt.»',
  passageTranslation:
      'Lena y Markus estaban sentados frente a frente en la mesa de la cocina. '
      'Desde hacía meses se habían ido distanciando: discutían a menudo, o se '
      'quedaban en silencio.\n\n'
      '«Tengo que ser sincero», empezó Markus en voz baja. «Últimamente '
      'incluso he pensado en marcharme.» Lena tragó saliva. «Duele oír eso. '
      'Pero me alegra que lo digas.»\n\n'
      '«No quiero hacerte reproches», dijo ella. «Yo también me he ido '
      'apartando. Asumo mi parte en esto.» Markus asintió. «Quizá necesitemos '
      'ayuda de fuera. ¿Qué te parece una terapia de pareja?»\n\n'
      'Lena reflexionó. «Quiero intentarlo. Todavía no estoy lista para '
      'rendirme.» Por primera vez en mucho tiempo, Markus tomó su mano. '
      '«Entonces nos atrevemos a un nuevo comienzo, despacio, paso a paso.»',
  tips: const [
    HelpMemoryTip(
      kind: 'example',
      title: '"sich zurückziehen"',
      text: '"Ich habe mich zurückgezogen" = me he ido apartando/encerrando. '
          'Reconocer el propio repliegue es asumir el "Anteil" (la parte).',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: '"Was hältst du von …?"',
      text: '"¿qué te parece…?" = "Was hältst du von …?" (+ dativo). Una forma '
          'culta de proponer algo, como aquí la "Paartherapie".',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'Was gesteht Markus Lena?',
      questionTranslation: '¿Qué le confiesa Markus a Lena?',
      options: [
        'Dass er sogar daran gedacht hat zu gehen',
        'Dass er jemand anderen kennengelernt hat',
        'Dass er in eine andere Stadt ziehen will',
        'Dass er seine Arbeit verloren hat',
      ],
      optionsTranslation: [
        'Que incluso había pensado en marcharse',
        'Que ha conocido a otra persona',
        'Que quiere mudarse de ciudad',
        'Que ha perdido su trabajo',
      ],
      correctIndex: 0,
      explanation:
          '«In letzter Zeit habe ich sogar daran gedacht, zu gehen.» Er gibt '
          'zu, dass er an eine Trennung gedacht hat.',
      explanationTranslation:
          '«In letzter Zeit habe ich sogar daran gedacht, zu gehen.» Reconoce '
          'que pensó en dejar la relación.',
    ),
    ReadingQuestion(
      question: 'Wie reagiert Lena auf dieses Geständnis?',
      questionTranslation: '¿Cómo reacciona Lena ante esa confesión?',
      options: [
        'Es tut ihr weh, aber sie ist froh über seine Ehrlichkeit',
        'Sie wird wütend und verlässt die Küche',
        'Sie schreit ihn an und macht ihm Vorwürfe',
        'Sie lacht und nimmt es nicht ernst',
      ],
      optionsTranslation: [
        'Le duele, pero agradece su sinceridad',
        'Se enfada y se va de la cocina',
        'Le grita y le hace reproches',
        'Se ríe y no le da importancia',
      ],
      correctIndex: 0,
      explanation:
          '«Das tut weh zu hören. Aber ich bin froh, dass du es aussprichst.» '
          'Sie würdigt seine Ehrlichkeit trotz des Schmerzes.',
      explanationTranslation:
          '«Das tut weh zu hören. Aber ich bin froh, dass du es aussprichst.» '
          'Valida su honestidad pese al dolor.',
    ),
    ReadingQuestion(
      question: 'Welche reife Haltung zeigt Lena im Konflikt?',
      questionTranslation: '¿Qué actitud madura muestra Lena en el conflicto?',
      options: [
        'Sie übernimmt ihren Anteil, ohne den anderen zu beschuldigen',
        'Sie gibt Markus die Schuld an allem',
        'Sie leugnet, dass es überhaupt ein Problem gibt',
        'Sie verlangt, dass er sich zuerst entschuldigt',
      ],
      optionsTranslation: [
        'Asume su parte sin culpar al otro',
        'Culpa a Markus de todo lo ocurrido',
        'Niega que haya ningún problema',
        'Le exige que se disculpe primero',
      ],
      correctIndex: 0,
      explanation:
          '«Ich will dir keine Vorwürfe machen … Ich übernehme meinen Anteil '
          'daran.» Sie vermeidet Vorwürfe und übernimmt Verantwortung.',
      explanationTranslation:
          '«Ich will dir keine Vorwürfe machen … Ich übernehme meinen Anteil '
          'daran.» Evita los reproches y asume responsabilidad.',
    ),
    ReadingQuestion(
      question: 'Was beschließen sie am Ende?',
      questionTranslation: '¿Qué deciden hacer al final?',
      options: [
        'Einen Neuanfang zu versuchen, vielleicht mit einer Paartherapie',
        'Sich sofort zu trennen',
        'Eine Zeit lang nicht miteinander zu reden',
        'Weiterzumachen wie bisher, ohne etwas zu ändern',
      ],
      optionsTranslation: [
        'Intentar un nuevo comienzo, quizá con terapia de pareja',
        'Separarse de inmediato',
        'Dejar de hablarse durante un tiempo',
        'Seguir como hasta ahora sin cambios',
      ],
      correctIndex: 0,
      explanation:
          '«Dann wagen wir einen Neuanfang …» und sie überlegen eine '
          '«Paartherapie»: Sie wählen, die Beziehung zu reparieren.',
      explanationTranslation:
          '«Dann wagen wir einen Neuanfang …» y barajan una "Paartherapie": '
          'eligen reparar la relación.',
    ),
  ],
);

// ─────────────────────────────── Bloques ───────────────────────────────────
// The "German Emotions" course is its own course (not part of the travel
// course); these per-bloque lists feed its drawer groups in the catalog.
// Bloques A–D son el tronco A1–B1; E–G son el tier avanzado B2–C1.

/// Bloque A · Las emociones (vocabulario + audio + lectura).
final List<QuizContent> esDeEmocionesBloqueA = [
  esDeEmocionesBasicas,
  esDeHablarEmocionesBasicas,
  esDeEmocionesMatices,
  esDeHablarEmocionesMatices,
  esDeLecturaEmocionesDia,
];

/// Bloque B · Expresar sentimientos.
final List<QuizContent> esDeEmocionesBloqueB = [
  esDeExpresarSentimientos,
  esDeHablarSentimientos,
  esDeLecturaNotaSincera,
];

/// Bloque C · Comunicación en pareja.
final List<QuizContent> esDeEmocionesBloqueC = [
  esDeAbrirConversacion,
  esDeMensajesYo,
  esDeHablarComunicacion,
  esDeEscucharEmpatia,
  esDeHablarEmpatia,
  esDeLecturaConversacionCalma,
];

/// Bloque D · Conflicto y reconciliación.
final List<QuizContent> esDeEmocionesBloqueD = [
  esDeConflictos,
  esDeReconciliacion,
  esDeHablarReconciliacion,
  esDeAmorAprecio,
  esDeLecturaPeleaPaces,
];

/// Bloque E · Comunicación emocional profunda (B2–C1).
final List<QuizContent> esDeEmocionesBloqueE = [
  esDeVinculoVocab,
  esDeVulnerabilidad,
  esDeDistancia,
  esDeHablarProfunda,
  esDeLecturaMasCerca,
];

/// Bloque F · Confrontación y conflicto (B2–C1).
final List<QuizContent> esDeEmocionesBloqueF = [
  esDeConflictoVocab,
  esDeAfrontarConflicto,
  esDeConfianzaRota,
  esDeHablarConfrontacion,
  esDeLecturaConversacionFranca,
];

/// Bloque G · Ruptura y reconciliación (B2–C1).
final List<QuizContent> esDeEmocionesBloqueG = [
  esDeRuptura,
  esDeSeparacionRespetuosa,
  esDeReconstruir,
  esDeHablarRupturaReconciliacion,
  esDeLecturaDespedida,
];

/// Bloque H · Lectura (capstones A2–B1 y B2–C1).
final List<QuizContent> esDeEmocionesBloqueH = [
  esDeLecturaPareja,
  esDeLecturaAussprache,
];

/// "German Emotions" — Emociones y pareja, en orden de uso
/// (A–D: A1–B1; E–G: B2–C1; H: lecturas-resumen). Cada bloque A–G termina con
/// su propia lectura situacional.
final List<QuizContent> esDeEmocionesContent = [
  ...esDeEmocionesBloqueA,
  ...esDeEmocionesBloqueB,
  ...esDeEmocionesBloqueC,
  ...esDeEmocionesBloqueD,
  ...esDeEmocionesBloqueE,
  ...esDeEmocionesBloqueF,
  ...esDeEmocionesBloqueG,
  ...esDeEmocionesBloqueH,
];
