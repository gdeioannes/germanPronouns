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
      question: '¿Qué le confiesa Markus a Lena?',
      options: [
        'Que incluso había pensado en marcharse',
        'Que ha conocido a otra persona',
        'Que quiere mudarse de ciudad',
        'Que ha perdido su trabajo',
      ],
      correctIndex: 0,
      explanation:
          '«In letzter Zeit habe ich sogar daran gedacht, zu gehen.» Reconoce '
          'que pensó en dejar la relación.',
    ),
    ReadingQuestion(
      question: '¿Cómo reacciona Lena ante esa confesión?',
      options: [
        'Le duele, pero agradece su sinceridad',
        'Se enfada y se va de la cocina',
        'Le grita y le hace reproches',
        'Se ríe y no le da importancia',
      ],
      correctIndex: 0,
      explanation:
          '«Das tut weh zu hören. Aber ich bin froh, dass du es aussprichst.» '
          'Valida su honestidad pese al dolor.',
    ),
    ReadingQuestion(
      question: '¿Qué actitud madura muestra Lena en el conflicto?',
      options: [
        'Asume su parte sin culpar al otro',
        'Culpa a Markus de todo lo ocurrido',
        'Niega que haya ningún problema',
        'Le exige que se disculpe primero',
      ],
      correctIndex: 0,
      explanation:
          '«Ich will dir keine Vorwürfe machen … Ich übernehme meinen Anteil '
          'daran.» Evita los reproches y asume responsabilidad.',
    ),
    ReadingQuestion(
      question: '¿Qué deciden hacer al final?',
      options: [
        'Intentar un nuevo comienzo, quizá con terapia de pareja',
        'Separarse de inmediato',
        'Dejar de hablarse durante un tiempo',
        'Seguir como hasta ahora sin cambios',
      ],
      correctIndex: 0,
      explanation:
          '«Dann wagen wir einen Neuanfang …» y barajan una "Paartherapie": '
          'eligen reparar la relación.',
    ),
  ],
);

// ─────────────────────────────── Bloques ───────────────────────────────────
// The "German Emotions" course is its own course (not part of the travel
// course); these per-bloque lists feed its drawer groups in the catalog.
// Bloques A–D son el tronco A1–B1; E–G son el tier avanzado B2–C1.

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

/// Bloque E · Comunicación emocional profunda (B2–C1).
final List<QuizContent> esDeEmocionesBloqueE = [
  esDeVinculoVocab,
  esDeVulnerabilidad,
  esDeDistancia,
  esDeHablarProfunda,
];

/// Bloque F · Confrontación y conflicto (B2–C1).
final List<QuizContent> esDeEmocionesBloqueF = [
  esDeConflictoVocab,
  esDeAfrontarConflicto,
  esDeConfianzaRota,
  esDeHablarConfrontacion,
];

/// Bloque G · Ruptura y reconciliación (B2–C1).
final List<QuizContent> esDeEmocionesBloqueG = [
  esDeRuptura,
  esDeSeparacionRespetuosa,
  esDeReconstruir,
  esDeHablarRupturaReconciliacion,
];

/// Bloque H · Lectura (A2–B1 y B2–C1).
final List<QuizContent> esDeEmocionesBloqueH = [
  esDeLecturaPareja,
  esDeLecturaAussprache,
];

/// "German Emotions" — Emociones y pareja. 29 quizzes en orden de uso
/// (A–D: A1–B1; E–G: B2–C1; H: lectura).
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
