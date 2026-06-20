import '../../../models/quiz_content.dart';
import 'es_de_builder.dart';

/// Nivel 4 — Emociones y pareja ("German Emotions").
///
/// Va más allá del alemán de viaje: nombrar lo que sentimos y comunicarnos de
/// forma sana en pareja. La idea central es la *Ich-Botschaft* (mensaje-yo) de
/// la comunicación no violenta: hablar de los propios sentimientos y
/// necesidades en vez de acusar. Registro A2–B1, trato informal ("du").
///
/// 16 quizzes: 2 de vocabulario, 8 de frases, 6 de "Hablar" (audio) y 1 de
/// lectura como cierre.

// ───────────────────────────── Bloque A · Las emociones ────────────────────

final QuizContent esDeEmocionesBasicas = sentenceCourseQuiz(
  id: 'es_de_emociones_basicas',
  title: 'Emociones básicas',
  promptLabel: 'Frase',
  subjectsLabel: 'Frases',
  subjectColumnLabel: 'Español',
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
    CourseItem(prompt: 'Hoy soy muy feliz', answer: 'Heute bin ich sehr glücklich'),
    CourseItem(
      prompt: 'Estoy contento con el resultado',
      answer: 'Ich bin zufrieden mit dem Ergebnis',
    ),
    CourseItem(
      prompt: 'Hoy estoy un poco triste',
      answer: 'Heute bin ich ein bisschen traurig',
    ),
    CourseItem(
      prompt: 'Estoy enfadado contigo',
      answer: 'Ich bin wütend auf dich',
      accepted: ['Ich bin sauer auf dich'],
    ),
    CourseItem(prompt: 'Estoy un poco nervioso', answer: 'Ich bin ein bisschen nervös'),
    CourseItem(prompt: 'Hoy estoy muy cansado', answer: 'Ich bin heute sehr müde'),
    CourseItem(prompt: 'Estoy aburrido', answer: 'Mir ist langweilig'),
    CourseItem(prompt: 'Estoy muy sorprendido', answer: 'Ich bin sehr überrascht'),
    CourseItem(prompt: 'Ahora estoy tranquilo', answer: 'Jetzt bin ich ruhig'),
    CourseItem(
      prompt: 'Estoy emocionado por el viaje',
      answer: 'Ich bin aufgeregt wegen der Reise',
    ),
    CourseItem(prompt: 'Estoy muy estresado en el trabajo', answer: 'Ich bin sehr gestresst bei der Arbeit'),
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
  subjectColumnLabel: 'Español',
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
      prompt: 'Estoy decepcionado contigo',
      answer: 'Ich bin enttäuscht von dir',
    ),
    CourseItem(prompt: 'A veces soy celoso', answer: 'Manchmal bin ich eifersüchtig'),
    CourseItem(prompt: 'Estoy muy dolido', answer: 'Ich bin sehr verletzt'),
    CourseItem(
      prompt: 'A veces me siento abrumado',
      answer: 'Manchmal fühle ich mich überfordert',
    ),
    CourseItem(
      prompt: 'A veces me siento muy solo',
      answer: 'Manchmal fühle ich mich sehr einsam',
    ),
    CourseItem(
      prompt: 'Estoy agradecido por tu ayuda',
      answer: 'Ich bin dankbar für deine Hilfe',
    ),
    CourseItem(prompt: 'Ahora estoy aliviado', answer: 'Jetzt bin ich erleichtert'),
    CourseItem(prompt: 'Me da vergüenza', answer: 'Es ist mir peinlich'),
    CourseItem(prompt: 'Me siento inseguro', answer: 'Ich fühle mich unsicher'),
    CourseItem(prompt: 'Estoy orgulloso de nosotros', answer: 'Ich bin stolz auf uns'),
    CourseItem(prompt: 'A veces estoy frustrado', answer: 'Manchmal bin ich frustriert'),
    CourseItem(
      prompt: 'Estoy preocupado por ti',
      answer: 'Ich bin besorgt um dich',
      accepted: ['Ich mache mir Sorgen um dich'],
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

// ──────────────────────── Bloque B · Expresar sentimientos ──────────────────

final QuizContent esDeExpresarSentimientos = sentenceCourseQuiz(
  id: 'es_de_expresar_sentimientos',
  title: 'Expresar cómo me siento',
  promptLabel: 'Frase',
  subjectsLabel: 'Frases',
  subjectColumnLabel: 'Español',
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
    CourseItem(prompt: 'Me siento triste', answer: 'Ich fühle mich traurig'),
    CourseItem(
      prompt: 'Me siento solo',
      answer: 'Ich fühle mich allein',
      accepted: ['Ich fühle mich einsam'],
    ),
    CourseItem(prompt: 'Estoy abrumado', answer: 'Ich bin überfordert'),
    CourseItem(prompt: 'Te echo de menos', answer: 'Ich vermisse dich'),
    CourseItem(prompt: 'Soy feliz contigo', answer: 'Ich bin glücklich mit dir'),
    CourseItem(prompt: 'Tengo miedo', answer: 'Ich habe Angst'),
    CourseItem(prompt: 'Estoy decepcionado', answer: 'Ich bin enttäuscht'),
    CourseItem(
      prompt: 'No me siento bien',
      answer: 'Es geht mir nicht gut',
      accepted: ['Mir geht es nicht gut'],
    ),
    CourseItem(
      prompt: 'Necesito tiempo para mí',
      answer: 'Ich brauche Zeit für mich',
    ),
    CourseItem(prompt: 'Me siento herido', answer: 'Ich fühle mich verletzt'),
    CourseItem(
      prompt: 'Estoy agradecido por ti',
      answer: 'Ich bin dankbar für dich',
    ),
    CourseItem(
      prompt: 'Me cuesta hablar de esto',
      answer: 'Es fällt mir schwer, darüber zu reden',
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

// ─────────────────────── Bloque C · Comunicación en pareja ──────────────────

final QuizContent esDeAbrirConversacion = sentenceCourseQuiz(
  id: 'es_de_abrir_conversacion',
  title: 'Abrir la conversación',
  promptLabel: 'Frase',
  subjectsLabel: 'Frases',
  subjectColumnLabel: 'Español',
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
    CourseItem(prompt: '¿Podemos hablar?', answer: 'Können wir reden?'),
    CourseItem(prompt: '¿Tienes un momento?', answer: 'Hast du kurz Zeit?'),
    CourseItem(prompt: 'Tenemos que hablar', answer: 'Wir müssen reden'),
    CourseItem(
      prompt: 'Quiero hablar contigo de algo',
      answer: 'Ich möchte mit dir über etwas reden',
    ),
    CourseItem(
      prompt: '¿Es un buen momento?',
      answer: 'Passt es dir gerade?',
      accepted: ['Ist es ein guter Moment?'],
    ),
    CourseItem(prompt: 'No quiero discutir', answer: 'Ich will nicht streiten'),
    CourseItem(
      prompt: 'Hablémoslo con calma',
      answer: 'Lass uns in Ruhe reden',
      accepted: ['Lass uns in Ruhe darüber reden'],
    ),
    CourseItem(prompt: 'Esto es importante para mí', answer: 'Das ist mir wichtig'),
    CourseItem(
      prompt: '¿Cómo te sientes con esto?',
      answer: 'Wie fühlst du dich damit?',
    ),
    CourseItem(prompt: 'Quiero entenderte', answer: 'Ich möchte dich verstehen'),
  ],
);

final QuizContent esDeMensajesYo = sentenceCourseQuiz(
  id: 'es_de_mensajes_yo',
  title: 'Mensajes-yo (Ich-Botschaften)',
  promptLabel: 'Frase',
  subjectsLabel: 'Frases',
  subjectColumnLabel: 'Español',
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
      prompt: 'Me siento herido cuando me ignoras',
      answer: 'Ich fühle mich verletzt, wenn du mich ignorierst',
    ),
    CourseItem(
      prompt: 'Me siento solo cuando llegas tarde',
      answer: 'Ich fühle mich allein, wenn du spät kommst',
    ),
    CourseItem(
      prompt: 'Para mí es importante que hablemos',
      answer: 'Mir ist wichtig, dass wir reden',
    ),
    CourseItem(
      prompt: 'Me gustaría que pasáramos más tiempo juntos',
      answer: 'Ich wünsche mir, dass wir mehr Zeit zusammen verbringen',
    ),
    CourseItem(
      prompt: 'No me gusta cuando gritas',
      answer: 'Ich mag es nicht, wenn du schreist',
    ),
    CourseItem(
      prompt: 'Quiero que me escuches',
      answer: 'Ich möchte, dass du mir zuhörst',
    ),
    CourseItem(prompt: 'Necesito tu apoyo', answer: 'Ich brauche deine Unterstützung'),
    CourseItem(
      prompt: '¿Podemos buscar una solución juntos?',
      answer: 'Können wir zusammen eine Lösung finden?',
    ),
    CourseItem(
      prompt: 'Necesito sentir que me valoras',
      answer: 'Ich brauche das Gefühl, dass du mich wertschätzt',
    ),
    CourseItem(
      prompt: 'Me siento mejor cuando hablamos',
      answer: 'Ich fühle mich besser, wenn wir reden',
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
  subjectColumnLabel: 'Español',
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
    CourseItem(prompt: 'Te entiendo', answer: 'Ich verstehe dich'),
    CourseItem(
      prompt: 'Entiendo cómo te sientes',
      answer: 'Ich verstehe, wie du dich fühlst',
    ),
    CourseItem(prompt: 'Tienes razón', answer: 'Du hast recht'),
    CourseItem(prompt: 'Cuéntame más', answer: 'Erzähl mir mehr'),
    CourseItem(prompt: 'Te escucho', answer: 'Ich höre dir zu'),
    CourseItem(prompt: '¿Qué necesitas de mí?', answer: 'Was brauchst du von mir?'),
    CourseItem(
      prompt: 'Eso suena difícil',
      answer: 'Das klingt schwer',
      accepted: ['Das hört sich schwer an'],
    ),
    CourseItem(prompt: 'Estoy aquí para ti', answer: 'Ich bin für dich da'),
    CourseItem(
      prompt: 'Gracias por contármelo',
      answer: 'Danke, dass du es mir sagst',
    ),
    CourseItem(prompt: 'Lo siento mucho', answer: 'Das tut mir sehr leid'),
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

// ─────────────────────── Bloque D · Conflicto y reconciliación ──────────────

final QuizContent esDeConflictos = sentenceCourseQuiz(
  id: 'es_de_conflictos',
  title: 'Conflictos y desacuerdos',
  promptLabel: 'Frase',
  subjectsLabel: 'Frases',
  subjectColumnLabel: 'Español',
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
      prompt: 'No estoy de acuerdo',
      answer: 'Ich bin nicht einverstanden',
      accepted: ['Ich bin anderer Meinung'],
    ),
    CourseItem(prompt: 'Lo veo diferente', answer: 'Ich sehe das anders'),
    CourseItem(prompt: 'Eso no es justo', answer: 'Das ist nicht fair'),
    CourseItem(
      prompt: 'Estoy enfadado',
      answer: 'Ich bin wütend',
      accepted: ['Ich bin sauer'],
    ),
    CourseItem(prompt: 'Me has decepcionado', answer: 'Du hast mich enttäuscht'),
    CourseItem(
      prompt: 'No me gusta cómo me hablas',
      answer: 'Ich mag nicht, wie du mit mir redest',
    ),
    CourseItem(prompt: 'Necesito una pausa', answer: 'Ich brauche eine Pause'),
    CourseItem(prompt: 'Hablemos más tarde', answer: 'Lass uns später reden'),
    CourseItem(
      prompt: 'No quiero pelear',
      answer: 'Ich will mich nicht streiten',
      accepted: ['Ich will nicht streiten'],
    ),
    CourseItem(prompt: 'Cálmate, por favor', answer: 'Beruhige dich bitte'),
  ],
);

final QuizContent esDeReconciliacion = sentenceCourseQuiz(
  id: 'es_de_reconciliacion',
  title: 'Reconciliación y perdón',
  promptLabel: 'Frase',
  subjectsLabel: 'Frases',
  subjectColumnLabel: 'Español',
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
      prompt: 'Lo siento, tienes razón',
      answer: 'Es tut mir leid, du hast recht',
    ),
    CourseItem(
      prompt: 'No quería herirte',
      answer: 'Ich wollte dich nicht verletzen',
    ),
    CourseItem(
      prompt: 'Perdóname',
      answer: 'Verzeih mir',
      accepted: ['Entschuldige'],
    ),
    CourseItem(prompt: 'Fue culpa mía', answer: 'Es war mein Fehler'),
    CourseItem(
      prompt: 'Hagamos las paces',
      answer: 'Vertragen wir uns wieder',
      accepted: ['Lass uns Frieden schließen'],
    ),
    CourseItem(prompt: 'Te perdono', answer: 'Ich verzeihe dir'),
    CourseItem(prompt: 'Empecemos de nuevo', answer: 'Lass uns neu anfangen'),
    CourseItem(
      prompt: 'Lo solucionaremos',
      answer: 'Wir bekommen das hin',
      accepted: ['Wir schaffen das'],
    ),
    CourseItem(prompt: 'Te quiero a pesar de todo', answer: 'Ich liebe dich trotz allem'),
    CourseItem(
      prompt: 'Gracias por entenderme',
      answer: 'Danke, dass du mich verstehst',
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
  subjectColumnLabel: 'Español',
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
    CourseItem(prompt: 'Te quiero (cariño)', answer: 'Ich hab dich lieb'),
    CourseItem(prompt: 'Te amo', answer: 'Ich liebe dich'),
    CourseItem(prompt: 'Significas mucho para mí', answer: 'Du bedeutest mir viel'),
    CourseItem(prompt: 'Me haces feliz', answer: 'Du machst mich glücklich'),
    CourseItem(prompt: 'Estoy orgulloso de ti', answer: 'Ich bin stolz auf dich'),
    CourseItem(prompt: 'Gracias por estar aquí', answer: 'Danke, dass du da bist'),
    CourseItem(prompt: 'Eres importante para mí', answer: 'Du bist mir wichtig'),
    CourseItem(prompt: 'Te aprecio', answer: 'Ich schätze dich'),
    CourseItem(prompt: 'Me encanta estar contigo', answer: 'Ich bin gern mit dir zusammen'),
    CourseItem(
      prompt: 'Eres lo mejor que me ha pasado',
      answer: 'Du bist das Beste, was mir passiert ist',
    ),
  ],
);

// ─────────────────────────── Bloque E · Lectura ─────────────────────────────

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
      question: '¿Por qué estaba preocupada Anna?',
      options: [
        'Porque Tom llegó tarde sin avisar',
        'Porque Tom le gritó',
        'Porque Tom olvidó su cumpleaños',
        'Porque Tom quería separarse',
      ],
      correctIndex: 0,
      explanation:
          '"Tom kam spät … nach Hause, ohne anzurufen." Llegó tarde sin llamar, '
          'y por eso Anna se preocupó.',
    ),
    ReadingQuestion(
      question: '¿Cómo reaccionó Anna al principio y qué hizo después?',
      options: [
        'Se enfadó, pero respiró hondo y habló con calma',
        'Se puso a gritar enseguida',
        'Se fue de casa sin decir nada',
        'Fingió que no pasaba nada',
      ],
      correctIndex: 0,
      explanation:
          '"Anna war zuerst wütend, aber dann atmete sie tief durch" y habló '
          '"ruhig" (con calma).',
    ),
    ReadingQuestion(
      question: '¿Qué respondió Tom?',
      options: [
        '«Lo siento, tienes razón»',
        '«No es culpa mía»',
        '«No quiero hablar de esto»',
        '«Siempre te quejas»',
      ],
      correctIndex: 0,
      explanation:
          '«Es tut mir leid … Du hast recht.» Tom reconoce el error en lugar de '
          'defenderse.',
    ),
    ReadingQuestion(
      question: '¿Cuál de estas frases es un "mensaje-yo" (Ich-Botschaft)?',
      options: [
        '«Me sentí sola cuando no llamaste»',
        '«Siempre llegas tarde»',
        '«Nunca piensas en mí»',
        '«Eres un egoísta»',
      ],
      correctIndex: 0,
      explanation:
          'Un mensaje-yo habla de los propios sentimientos sin acusar: "Ich '
          'habe mich allein gefühlt". Las otras tres son reproches ("tú …").',
    ),
  ],
);

// ─────────────────────────────── Bloques ───────────────────────────────────
// The "German Emotions" course is its own course (not part of the travel
// course); these per-bloque lists feed its drawer groups in the catalog.

/// Bloque A · Las emociones (vocabulario + audio).
final List<QuizContent> esDeEmocionesBloqueA = [
  esDeEmocionesBasicas,
  esDeHablarEmocionesBasicas,
  esDeEmocionesMatices,
  esDeHablarEmocionesMatices,
];

/// Bloque B · Expresar sentimientos.
final List<QuizContent> esDeEmocionesBloqueB = [
  esDeExpresarSentimientos,
  esDeHablarSentimientos,
];

/// Bloque C · Comunicación en pareja.
final List<QuizContent> esDeEmocionesBloqueC = [
  esDeAbrirConversacion,
  esDeMensajesYo,
  esDeHablarComunicacion,
  esDeEscucharEmpatia,
  esDeHablarEmpatia,
];

/// Bloque D · Conflicto y reconciliación.
final List<QuizContent> esDeEmocionesBloqueD = [
  esDeConflictos,
  esDeReconciliacion,
  esDeHablarReconciliacion,
  esDeAmorAprecio,
];

/// Bloque E · Lectura.
final List<QuizContent> esDeEmocionesBloqueE = [
  esDeLecturaPareja,
];

/// "German Emotions" — Emociones y pareja. 16 quizzes en orden de uso.
final List<QuizContent> esDeEmocionesContent = [
  ...esDeEmocionesBloqueA,
  ...esDeEmocionesBloqueB,
  ...esDeEmocionesBloqueC,
  ...esDeEmocionesBloqueD,
  ...esDeEmocionesBloqueE,
];
