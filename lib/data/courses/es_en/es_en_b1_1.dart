import '../../../models/quiz_content.dart';
import 'es_en_builder.dart';

/// B1.1 — Opiniones y experiencias. Spanish → English.
///
/// Big rocks: present perfect vs past simple (⚑S19 — the usage differs from
/// pretérito perfecto compuesto), since/for (⚑S20), the first phrasal verbs
/// (⚑S21), gerund vs infinitive after verbs (⚑S27), and opinion language.

final QuizContent esEnB11PresentPerfect = esEnFill(
  id: 'es_en_b1_1_present_perfect',
  title: 'El present perfect: have + participio',
  intro: 'Experiencias y hechos con efecto en el presente: I have visited '
      'Rome = he visitado Roma. Se forma con have/has + participio.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Participios irregulares clave',
      text: 'go→gone, see→seen, do→done, eat→eaten, write→written, '
          'be→been, break→broken, take→taken.',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: '⚑S19 No siempre como en español',
      text: 'En España "hoy he comido paella" usa perfecto; el inglés con '
          '"today"+momento terminado suele preferir pasado. La regla inglesa: '
          '¿importa el resultado ahora? → perfect.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'He visitado Roma dos veces.', answer: 'I **have** visited Rome twice.'),
    CourseItem(prompt: 'Ella ha terminado el informe.', answer: 'She **has** finished the report.'),
    CourseItem(prompt: 'Hemos visto esa película.', answer: 'We have **seen** that film.'),
    CourseItem(prompt: 'Él ha perdido las llaves.', answer: 'He has **lost** his keys.'),
    CourseItem(prompt: '¿Has estado en Londres?', answer: 'Have you **been** to London?'),
    CourseItem(prompt: 'No he leído ese libro.', answer: 'I have not **read** that book.'),
    CourseItem(prompt: 'Ellos han comprado una casa.', answer: 'They have **bought** a house.'),
    CourseItem(prompt: 'Ella ha escrito tres novelas.', answer: 'She has **written** three novels.'),
    CourseItem(prompt: 'Se ha roto la ventana. (break)', answer: 'The window has **broken**.'),
    CourseItem(prompt: 'Hemos comido ya.', answer: 'We have already **eaten**.'),
    CourseItem(prompt: 'Él se ha ido. (go)', answer: 'He has **gone**.'),
    CourseItem(prompt: '¿Habéis hecho los deberes?', answer: 'Have you **done** your homework?'),
    CourseItem(prompt: 'He olvidado su nombre.', answer: 'I have **forgotten** her name.'),
    CourseItem(prompt: 'Ella nunca ha conducido.', answer: 'She has never **driven**.'),
    CourseItem(prompt: 'Han llegado los invitados.', answer: 'The guests have **arrived**.'),
  ],
);

final QuizContent esEnB11PerfectVsPast = esEnFill(
  id: 'es_en_b1_1_perfect_vs_past',
  title: 'Perfect o pasado: ¿cuándo importa?',
  intro: 'Momento terminado y dicho (yesterday, in 2010, last week) → past '
      'simple. Experiencia sin fecha o efecto presente → present perfect.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚑S19 La fecha manda',
      text: 'I have seen it yesterday ✗ → I saw it yesterday ✓. En cuanto '
          'aparece la fecha, el perfect se prohíbe.',
    ),
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'Las palabras señal',
      text: 'ever, never, already, yet, just → perfect. yesterday, ago, '
          'last…, in 1999 → past.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Vi esa película ayer.', answer: 'I **saw** that film yesterday.'),
    CourseItem(prompt: 'He visto esa película. (sin fecha)', answer: 'I have **seen** that film.'),
    CourseItem(prompt: 'Ella vivió en París en 2010.', answer: 'She **lived** in Paris in 2010.'),
    CourseItem(prompt: 'Ella ha vivido en tres países.', answer: 'She has **lived** in three countries.'),
    CourseItem(prompt: '¿Alguna vez has probado el sushi?', answer: 'Have you ever **tried** sushi?'),
    CourseItem(prompt: 'Probé el sushi la semana pasada.', answer: 'I **tried** sushi last week.'),
    CourseItem(prompt: 'Acabo de terminar. (just)', answer: 'I have **just** finished.'),
    CourseItem(prompt: 'Todavía no he terminado. (yet)', answer: 'I haven\'t finished **yet**.'),
    CourseItem(prompt: 'Ya hemos pedido. (already)', answer: 'We have **already** ordered.'),
    CourseItem(prompt: 'Fuimos a la playa el domingo.', answer: 'We **went** to the beach on Sunday.'),
    CourseItem(prompt: 'Nunca he estado en Asia.', answer: 'I have **never** been to Asia.'),
    CourseItem(prompt: 'Él llegó hace una hora.', answer: 'He **arrived** an hour ago.'),
    CourseItem(prompt: '¿Has terminado ya el informe?', answer: 'Have you finished the report **yet**?'),
    CourseItem(prompt: 'Compré este coche en 2020.', answer: 'I **bought** this car in 2020.'),
    CourseItem(prompt: 'He perdido el pasaporte (y no aparece).', answer: 'I have **lost** my passport.'),
  ],
);

final QuizContent esEnB11SinceFor = esEnFill(
  id: 'es_en_b1_1_since_for',
  title: 'since / for: desde y durante',
  intro: 'since + punto de inicio (since 2015, since Monday), for + '
      'duración (for two years). Con perfect: I have lived here for ten years.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚑S20 "Llevo dos años" cambia de verbo',
      text: '"Llevo dos años aquí" = I **have been** here for two years — '
          'presente perfecto, no presente: "I am here since…" ✗.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Vivo aquí desde 2015.', answer: 'I have lived here **since** 2015.'),
    CourseItem(prompt: 'Llevo dos años en Londres.', answer: 'I have been in London **for** two years.'),
    CourseItem(prompt: 'La conozco desde enero.', answer: 'I have known her **since** January.'),
    CourseItem(prompt: 'Trabaja aquí desde hace seis meses.', answer: 'He has worked here **for** six months.'),
    CourseItem(prompt: 'No la veo desde el lunes.', answer: 'I haven\'t seen her **since** Monday.'),
    CourseItem(prompt: 'Estudiamos inglés desde hace un año.', answer: 'We have studied English **for** a year.'),
    CourseItem(prompt: 'Llueve desde esta mañana.', answer: 'It has rained **since** this morning.'),
    CourseItem(prompt: 'Tienen ese coche desde hace diez años.', answer: 'They have had that car **for** ten years.'),
    CourseItem(prompt: 'Está enfermo desde el viernes.', answer: 'He has been ill **since** Friday.'),
    CourseItem(prompt: 'Te espero desde hace una hora.', answer: 'I have waited **for** an hour.'),
    CourseItem(prompt: 'Somos amigos desde la escuela.', answer: 'We have been friends **since** school.'),
    CourseItem(prompt: 'Vive sola desde hace mucho tiempo.', answer: 'She has lived alone **for** a long time.'),
    CourseItem(prompt: 'No como carne desde 2019.', answer: 'I haven\'t eaten meat **since** 2019.'),
    CourseItem(prompt: 'Llevamos veinte minutos aquí.', answer: 'We have been here **for** twenty minutes.'),
    CourseItem(prompt: 'Nos conocemos desde aquel verano.', answer: 'We have known each other **since** that summer.'),
  ],
);

final QuizContent esEnB11Phrasals = esEnVocab(
  id: 'es_en_b1_1_phrasals',
  title: 'Phrasal verbs I',
  intro: 'verbo + partícula = nuevo significado. No son jerga: son el inglés '
      'de cada día. Apréndelos como palabras completas.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚑S21 La partícula cambia todo',
      text: 'look = mirar, pero look for = buscar y look after = cuidar. '
          'Traducir el verbo suelto no sirve: memoriza el conjunto.',
    ),
  ],
  pairs: const [
    MapEntry('levantarse', 'get up'),
    MapEntry('buscar', 'look for'),
    MapEntry('cuidar', 'look after'),
    MapEntry('descubrir / averiguar', 'find out'),
    MapEntry('rendirse / dejar (un hábito)', 'give up'),
    MapEntry('seguir / continuar', 'go on'),
    MapEntry('volver', 'come back'),
    MapEntry('apuntarse / inscribirse', 'sign up'),
    MapEntry('encender', 'turn on'),
    MapEntry('apagar', 'turn off'),
    MapEntry('probarse (ropa)', 'try on'),
    MapEntry('llevarse bien', 'get on'),
  ],
);

final QuizContent esEnB11GerundInf = esEnFill(
  id: 'es_en_b1_1_gerund_inf',
  title: 'enjoy doing / want to do',
  intro: 'Tras ciertos verbos va -ing (enjoy, finish, mind); tras otros, '
      'to + infinitivo (want, decide, hope). No hay lógica: hay listas.',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: '⚑S27 Las dos listas',
      text: '-ing: enjoy, finish, mind, keep, avoid, suggest. to: want, '
          'decide, hope, need, plan, learn, promise.',
    ),
    HelpMemoryTip(
      kind: 'rule',
      title: 'Preposición + -ing',
      text: 'Tras preposición SIEMPRE -ing: interested in learning, good at '
          'cooking, before leaving.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Disfruto leyendo.', answer: 'I enjoy **reading**.'),
    CourseItem(prompt: 'Quiero viajar.', answer: 'I want **to travel**.'),
    CourseItem(prompt: 'Terminó de trabajar a las seis.', answer: 'She finished **working** at six.'),
    CourseItem(prompt: 'Decidimos quedarnos.', answer: 'We decided **to stay**.'),
    CourseItem(prompt: 'Evita comer tarde.', answer: 'He avoids **eating** late.'),
    CourseItem(prompt: 'Espero verte pronto.', answer: 'I hope **to see** you soon.'),
    CourseItem(prompt: 'Sigue practicando. (keep)', answer: 'Keep **practising**.'),
    CourseItem(prompt: 'Aprendí a conducir el año pasado.', answer: 'I learned **to drive** last year.'),
    CourseItem(prompt: '¿Te importa esperar?', answer: 'Do you mind **waiting**?'),
    CourseItem(prompt: 'Necesito descansar.', answer: 'I need **to rest**.'),
    CourseItem(prompt: 'Dejó de fumar. (give up)', answer: 'He gave up **smoking**.'),
    CourseItem(prompt: 'Planeamos visitar Escocia.', answer: 'We plan **to visit** Scotland.'),
    CourseItem(prompt: 'Me interesa aprender idiomas.', answer: 'I am interested in **learning** languages.'),
    CourseItem(prompt: 'Prometió llamar.', answer: 'She promised **to call**.'),
    CourseItem(prompt: 'Es buena cocinando.', answer: 'She is good at **cooking**.'),
  ],
);

final QuizContent esEnB11ListenInterview = esEnListen(
  id: 'es_en_b1_1_listen_interview',
  title: 'Escucha: The job interview',
  passageTitle: 'An interview at the café',
  passage:
      "So, Lucía, have you worked in a café before? — Yes, I have. I worked "
      "in a coffee shop in Guadalajara for three years. — Great. How long "
      "have you lived in London? — Since 2023. I've just finished an English "
      "course, and now I'm looking for a part-time job. — Do you enjoy "
      "working with people? — I love it. I've never had a boring day in a "
      "café. — Perfect. Can you start on Monday?",
  passageTranslation:
      'Bien, Lucía, ¿has trabajado antes en una cafetería? — Sí. Trabajé en '
      'una cafetería de Guadalajara durante tres años. — Genial. ¿Cuánto '
      'llevas viviendo en Londres? — Desde 2023. Acabo de terminar un curso '
      'de inglés y ahora busco un trabajo a tiempo parcial. — ¿Disfrutas '
      'trabajando con gente? — Me encanta. Nunca he tenido un día aburrido '
      'en una cafetería. — Perfecto. ¿Puedes empezar el lunes?',
  intro: 'Una entrevista de trabajo llena de present perfect. Escucha cómo '
      'alternan have you…? y el pasado con fecha.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'El patrón entrevista',
      text: 'Have you ever…? abre la experiencia; la respuesta con detalles '
          'salta al pasado: Yes, I worked in… for three years.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'How long did Lucía work in Guadalajara?',
      options: ['Two years', 'Three years', 'Five years'],
      correctIndex: 1,
      questionTranslation: '¿Cuánto tiempo trabajó Lucía en Guadalajara?',
    ),
    ReadingQuestion(
      question: 'How long has she lived in London?',
      options: ['Since 2023', 'Since 2020', 'For ten years'],
      correctIndex: 0,
      questionTranslation: '¿Desde cuándo vive en Londres?',
    ),
    ReadingQuestion(
      question: 'What has she just finished?',
      options: ['A cooking course', 'An English course', 'A job interview'],
      correctIndex: 1,
      questionTranslation: '¿Qué acaba de terminar?',
    ),
  ],
);

final QuizContent esEnB11Opinions = esEnFill(
  id: 'es_en_b1_1_opinions',
  title: 'Opinar: I think, I agree…',
  intro: 'Dar tu opinión, acordar y discrepar con suavidad: el kit de '
      'conversación del B1.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: 'agree es verbo, no adjetivo',
      text: '"Estoy de acuerdo" = I agree — nunca "I am agree". Uno de los '
          'errores más repetidos del hispanohablante.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Creo que tienes razón.', answer: 'I **think** you are right.'),
    CourseItem(prompt: 'Estoy de acuerdo contigo.', answer: 'I **agree** with you.'),
    CourseItem(prompt: 'No estoy de acuerdo.', answer: 'I **disagree**.', accepted: ["don't agree"]),
    CourseItem(prompt: 'En mi opinión, es demasiado caro.', answer: 'In my **opinion**, it is too expensive.'),
    CourseItem(prompt: 'Para mí, el invierno es mejor.', answer: '**For** me, winter is better.'),
    CourseItem(prompt: 'Tienes razón.', answer: 'You are **right**.'),
    CourseItem(prompt: 'Te equivocas. (wrong)', answer: 'You are **wrong**.'),
    CourseItem(prompt: '¿Qué opinas de esto? (think of)', answer: 'What do you **think** of this?'),
    CourseItem(prompt: 'Depende.', answer: 'It **depends**.'),
    CourseItem(prompt: 'Estoy seguro de que vendrá.', answer: 'I am **sure** she will come.'),
    CourseItem(prompt: 'Puede que sí. (maybe)', answer: '**Maybe** yes.'),
    CourseItem(prompt: 'No estoy seguro.', answer: 'I am not **sure**.'),
    CourseItem(prompt: 'Estoy totalmente de acuerdo.', answer: 'I completely **agree**.'),
    CourseItem(prompt: 'Ese es un buen argumento. (point)', answer: 'That is a good **point**.'),
    CourseItem(prompt: 'Creo que no. (so)', answer: 'I don\'t think **so**.'),
  ],
);

final QuizContent esEnB11SpeakingMid = esEnSpeaking(
  id: 'es_en_b1_1_speaking_mid',
  title: 'Conversación: experiencias',
  level: 'B1.1',
  topic: 'A chat about my life experiences: places I have visited, foods I '
      'have tried, things I have never done but want to do.',
  practisePoints: [
    'Have you ever…? questions and natural answers',
    'Present perfect for experience, past simple for the details',
    'since/for with how long questions',
  ],
  scoringCriteria: [
    'Perfect vs past chosen correctly',
    'Irregular participles (been, seen, eaten) correct',
    'since/for used correctly',
  ],
  priorityErrors: [
    'perfect used with finished-time expressions',
    '"I am here since" instead of "I have been here for/since"',
    '"I am agree"',
  ],
  mode: SpeakingMode.conversation,
  session: const SpeakingSession(
    durationMinutes: 3,
    minExchanges: 6,
    minQuestionsPerPoint: 1,
  ),
  intro: 'Punto de control: charla de experiencias con tu asistente de IA. '
      'Copia, habla y trae la puntuación.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'El baile perfecto-pasado',
      text: 'Anuncia con perfect (I have been to Italy), detalla con pasado '
          '(I went in 2022). Ese vaivén es el B1 auténtico.',
    ),
  ],
);

final QuizContent esEnB11ReadHobbies = esEnRead(
  id: 'es_en_b1_1_read_hobbies',
  title: 'Lectura: A new hobby',
  passageTitle: 'Daniel tries everything',
  passage:
      "Daniel has tried many hobbies since he moved to Mexico City. First he "
      "signed up for a salsa class, but he gave it up after two months — he "
      "says he has never danced so badly in his life. Then he decided to "
      "learn photography. He has taken thousands of photos since January, "
      "and he really enjoys walking around the city with his camera. \"I "
      "haven't found my perfect hobby yet,\" he says, \"but I love trying "
      "new things. Next month I'm going to try rock climbing.\"",
  passageTranslation:
      'Daniel ha probado muchas aficiones desde que se mudó a Ciudad de '
      'México. Primero se apuntó a una clase de salsa, pero la dejó a los '
      'dos meses: dice que nunca ha bailado tan mal en su vida. Luego '
      'decidió aprender fotografía. Ha hecho miles de fotos desde enero y '
      'disfruta mucho paseando por la ciudad con su cámara. «Todavía no he '
      'encontrado mi afición perfecta», dice, «pero me encanta probar cosas '
      'nuevas. El mes que viene voy a probar la escalada.»',
  intro: 'Un texto que mezcla todo el módulo: perfect, since, phrasal verbs '
      'y verbos con -ing o to.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Caza los patrones',
      text: 'signed up, gave up (phrasals), decided to learn, enjoys walking '
          '(⚑S27), has taken… since (⚑S19-20). El módulo entero vive aquí.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'Why did Daniel give up salsa?',
      options: [
        'It was expensive',
        'He danced very badly',
        'He had no time',
      ],
      correctIndex: 1,
      questionTranslation: '¿Por qué dejó Daniel la salsa?',
    ),
    ReadingQuestion(
      question: 'How long has he taken photos?',
      options: ['Since January', 'For ten years', 'Since he was a child'],
      correctIndex: 0,
      questionTranslation: '¿Desde cuándo hace fotos?',
    ),
    ReadingQuestion(
      question: 'What is he going to try next month?',
      options: ['Salsa again', 'Rock climbing', 'Painting'],
      correctIndex: 1,
      questionTranslation: '¿Qué va a probar el mes que viene?',
    ),
  ],
);

final QuizContent esEnB11SpeakPerfect = esEnSpeak(
  id: 'es_en_b1_1_speak_perfect',
  title: 'A hablar: I\'ve been, I\'ve seen',
  intro: 'El perfect hablado vive en contracciones: I\'ve, she\'s, we\'ve. '
      'Escucha y repite hasta que salgan solas.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚑S10 has y have débiles',
      text: "En «I've seen it» el have es una v pegada: /aɪv/. Si buscas un "
          '"jav" fuerte no lo oirás nunca.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'He estado en Italia.', answer: "I've been to Italy."),
    CourseItem(prompt: 'Ella ha visto esa serie.', answer: "She's seen that series."),
    CourseItem(prompt: 'Hemos probado la comida tailandesa.', answer: "We've tried Thai food."),
    CourseItem(prompt: '¿Alguna vez has montado a caballo?', answer: 'Have you ever ridden a horse?'),
    CourseItem(prompt: 'Nunca he esquiado.', answer: "I've never skied."),
    CourseItem(prompt: 'Acaba de llegar.', answer: "He's just arrived."),
    CourseItem(prompt: 'Ya he terminado.', answer: "I've already finished."),
    CourseItem(prompt: 'Todavía no hemos decidido.', answer: "We haven't decided yet."),
  ],
);

final QuizContent esEnB11Dict = esEnDict(
  id: 'es_en_b1_1_dict',
  title: 'Dictado: experiencias',
  intro: 'Escucha y escribe. La dificultad: oír los have/has contraídos y '
      'los participios.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚑S10 \'ve y \'s escondidos',
      text: '"I\'ve worked", "She\'s lived": la contracción es casi '
          'invisible al oído. Si la frase habla de experiencia, búscala.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'He vivido aquí durante cinco años.', answer: 'I have lived here for five years.'),
    CourseItem(prompt: 'Ella ha perdido el tren.', answer: 'She has missed the train.'),
    CourseItem(prompt: '¿Has estado alguna vez en México?', answer: 'Have you ever been to Mexico?'),
    CourseItem(prompt: 'Nunca hemos visto la nieve.', answer: 'We have never seen snow.'),
    CourseItem(prompt: 'Acabo de terminar el libro.', answer: 'I have just finished the book.'),
    CourseItem(prompt: 'Trabaja aquí desde 2019.', answer: 'He has worked here since 2019.'),
    CourseItem(prompt: 'Todavía no han llegado.', answer: 'They have not arrived yet.'),
    CourseItem(prompt: 'Estoy buscando mis gafas.', answer: 'I am looking for my glasses.'),
    CourseItem(prompt: 'Ella dejó de fumar el año pasado.', answer: 'She gave up smoking last year.'),
    CourseItem(prompt: 'Disfruto cocinando para mis amigos.', answer: 'I enjoy cooking for my friends.'),
    CourseItem(prompt: 'Ya he visto esa película dos veces.', answer: 'I have already seen that film twice.'),
    CourseItem(prompt: 'Queremos aprender francés.', answer: 'We want to learn French.'),
    CourseItem(prompt: '¿Cuánto tiempo llevas esperando?', answer: 'How long have you waited?'),
    CourseItem(prompt: 'Él ha escrito muchas cartas.', answer: 'He has written many letters.'),
    CourseItem(prompt: 'No he encontrado mis llaves todavía.', answer: 'I have not found my keys yet.'),
  ],
);

final QuizContent esEnB11BigText = esEnBigText(
  id: 'es_en_b1_1_bigtext',
  title: 'Texto: Ten years in London',
  passageTitle: 'Ten years in London',
  intro: 'Completa: perfect o pasado, since/for, y el -ing o to correcto.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '¿Fecha cerrada o vida abierta?',
      text: 'in 2016, two months later → pasado. since/for, ever, yet → '
          'perfect. Decide hueco a hueco.',
    ),
  ],
  template:
      'Mrs. Park {{0}} lived in London {{1}} ten years. She moved here in '
      '2016, when she {{2}} a job at a language school. Since then she '
      '{{3}} taught hundreds of students. "I enjoy {{4}} people grow," she '
      'says. She has never {{5}} of changing jobs, but last year she '
      'decided {{6}} something new: she signed {{7}} for a pottery class. '
      '"I {{8}} made fifty cups since September — and I have given most of '
      'them {{9}} to my students."',
  blanks: [
    inputBlank('has'),
    inputBlank('for'),
    inputBlank('found', accepted: ['got', 'took']),
    inputBlank('has'),
    inputBlank('watching', accepted: ['seeing', 'helping']),
    inputBlank('thought'),
    inputBlank('to try', accepted: ['to do', 'to learn']),
    inputBlank('up'),
    inputBlank('have', accepted: ["'ve"]),
    inputBlank('away'),
  ],
  passageTranslation:
      'La señora Park lleva diez años viviendo en Londres. Se mudó aquí en '
      '2016, cuando encontró trabajo en una escuela de idiomas. Desde '
      'entonces ha enseñado a cientos de estudiantes. «Disfruto viendo '
      'crecer a la gente», dice. Nunca ha pensado en cambiar de trabajo, '
      'pero el año pasado decidió probar algo nuevo: se apuntó a una clase '
      'de cerámica. «He hecho cincuenta tazas desde septiembre… y he '
      'regalado la mayoría a mis alumnos.»',
);

final QuizContent esEnB11SpeakingClose = esEnSpeaking(
  id: 'es_en_b1_1_speaking_close',
  title: 'Conversación final: mi trayectoria',
  level: 'B1.1',
  topic: 'An interview about my life so far: how long I have done my job or '
      'studies, places I have lived, hobbies I have tried and given up, and '
      'my opinions about learning English.',
  practisePoints: [
    'Present perfect + since/for for my current situation',
    'Perfect for experience, past for the story details',
    'Phrasal verbs: sign up, give up, look for, find out',
    'Giving opinions: I think, I agree, in my opinion',
  ],
  scoringCriteria: [
    'Perfect vs past accuracy',
    'since/for correct',
    'Opinions expressed with correct verb patterns',
  ],
  targetVocabulary: [
    'have been', 'since', 'for', 'give up', 'sign up', 'in my opinion',
  ],
  priorityErrors: [
    '"I am agree"',
    'perfect with yesterday/ago',
    'infinitive after enjoy/finish',
  ],
  mode: SpeakingMode.interview,
  intro: 'Cierre del módulo B1.1: una entrevista sobre tu trayectoria. '
      'Copia, habla y trae tu puntuación.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Tu frase estrella',
      text: "I've worked as a … for … years — preséntate así y ya has "
          'demostrado medio módulo.',
    ),
  ],
);

/// B1.1 in chain order.
final List<QuizContent> esEnB1_1 = [
  esEnB11PresentPerfect,
  esEnB11PerfectVsPast,
  esEnB11SinceFor,
  esEnB11Phrasals,
  esEnB11GerundInf,
  esEnB11ListenInterview,
  esEnB11Opinions,
  esEnB11SpeakingMid,
  esEnB11ReadHobbies,
  esEnB11SpeakPerfect,
  esEnB11Dict,
  esEnB11BigText,
  esEnB11SpeakingClose,
];
