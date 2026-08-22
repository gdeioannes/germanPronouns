import '../../../models/quiz_content.dart';
import 'es_en_builder.dart';

/// C1.1 — Abstracción y precisión. Spanish → English.
///
/// Big rocks: nominalisation for formal style, inversion for emphasis,
/// advanced connectors, hedging, and strong collocations — the machinery of
/// precise written English (⚑S30).

final QuizContent esEnC11Nominal = esEnFill(
  id: 'es_en_c1_1_nominal',
  title: 'Nominalización: del verbo al nombre',
  intro: 'El inglés formal convierte verbos en nombres: we decided → our '
      'decision. Es la palanca de estilo número uno del C1.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'El efecto',
      text: '"We failed because we planned badly" → "The failure was due to '
          'poor planning": más frío, más formal, más C1.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'decidir → la decisión', answer: 'decide → **decision**'),
    CourseItem(prompt: 'crecer → el crecimiento', answer: 'grow → **growth**'),
    CourseItem(prompt: 'fracasar → el fracaso', answer: 'fail → **failure**'),
    CourseItem(prompt: 'negarse → la negativa', answer: 'refuse → **refusal**'),
    CourseItem(prompt: 'comparar → la comparación', answer: 'compare → **comparison**'),
    CourseItem(prompt: 'suponer → la suposición', answer: 'assume → **assumption**'),
    CourseItem(prompt: 'perder → la pérdida', answer: 'lose → **loss**'),
    CourseItem(prompt: 'explicar → la explicación', answer: 'explain → **explanation**'),
    CourseItem(prompt: 'Su negativa a firmar nos sorprendió.', answer: 'His **refusal** to sign surprised us.'),
    CourseItem(prompt: 'El crecimiento de la ciudad fue rápido.', answer: 'The **growth** of the city was fast.'),
    CourseItem(prompt: 'La pérdida de empleos preocupa al gobierno.', answer: 'The **loss** of jobs worries the government.'),
    CourseItem(prompt: 'Esa suposición resultó falsa.', answer: 'That **assumption** turned out to be false.'),
    CourseItem(prompt: 'Tomaron la decisión de vender.', answer: 'They made the **decision** to sell.'),
    CourseItem(prompt: 'No hay comparación posible.', answer: 'There is no possible **comparison**.'),
    CourseItem(prompt: 'La explicación no convenció a nadie.', answer: 'The **explanation** convinced nobody.'),
  ],
);

final QuizContent esEnC11Inversion = esEnFill(
  id: 'es_en_c1_1_inversion',
  title: 'Inversión enfática: Never have I…',
  intro: 'Para dar énfasis, ciertos adverbios negativos al inicio obligan a '
      'invertir: Never have I seen…, Not only did she…',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'El disparador',
      text: 'Never, Rarely, Not only, No sooner, Under no circumstances al '
          'principio → orden de pregunta: **have I**, **did she**.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Nunca he visto tal caos.', answer: 'Never **have** I seen such chaos.'),
    CourseItem(prompt: 'No solo llegó tarde, sino que además mintió.', answer: 'Not only **did** he arrive late, but he also lied.'),
    CourseItem(prompt: 'Rara vez es tan sencilla la respuesta.', answer: 'Rarely **is** the answer so simple.'),
    CourseItem(prompt: 'Bajo ninguna circunstancia debes abrir esa puerta.', answer: 'Under no circumstances **must** you open that door.'),
    CourseItem(prompt: 'Apenas había llegado cuando sonó el teléfono.', answer: 'No sooner **had** I arrived than the phone rang.'),
    CourseItem(prompt: 'Pocas veces ha estado tan claro el problema.', answer: 'Seldom **has** the problem been so clear.'),
    CourseItem(prompt: 'En ningún momento sospechamos de él.', answer: 'At no point **did** we suspect him.'),
    CourseItem(prompt: 'Solo entonces comprendí mi error.', answer: 'Only then **did** I understand my mistake.'),
    CourseItem(prompt: 'Nunca más volveré a ese hotel.', answer: 'Never again **will** I go back to that hotel.'),
    CourseItem(prompt: 'No solo es cara, sino también lenta.', answer: 'Not only **is** it expensive, but it is also slow.'),
    CourseItem(prompt: 'Solo cuando llegué a casa vi el mensaje.', answer: 'Only when I got home **did** I see the message.'),
    CourseItem(prompt: 'Rara vez encuentras un maestro así.', answer: 'Rarely **do** you find such a teacher.'),
    CourseItem(prompt: 'Apenas se había sentado cuando la llamaron.', answer: 'No sooner **had** she sat down than they called her.'),
    CourseItem(prompt: 'En ningún caso aceptaremos un retraso.', answer: 'Under no circumstances **will** we accept a delay.'),
    CourseItem(prompt: 'Poco sabía yo lo que venía.', answer: 'Little **did** I know what was coming.'),
  ],
);

final QuizContent esEnC11Hedging = esEnFill(
  id: 'es_en_c1_1_hedging',
  title: 'Matizar afirmaciones: hedging',
  intro: 'El académico no dice "esto es así": dice tend to, appear to, '
      'arguably, to some extent. Suaviza para poder afirmar.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'El kit del hedging',
      text: 'tend to, seem/appear to, arguably, presumably, broadly '
          'speaking, to some extent, it could be argued that…',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Los precios tienden a subir en verano.', answer: 'Prices **tend** to rise in summer.'),
    CourseItem(prompt: 'El plan parece funcionar.', answer: 'The plan **seems** to work.', accepted: ['appears']),
    CourseItem(prompt: 'Podría decirse que fue un error.', answer: 'It could be **argued** that it was a mistake.'),
    CourseItem(prompt: 'Es posiblemente su mejor obra. (arguably)', answer: 'It is **arguably** her best work.'),
    CourseItem(prompt: 'Hasta cierto punto, tiene razón.', answer: 'To some **extent**, he is right.'),
    CourseItem(prompt: 'En términos generales, el clima está cambiando.', answer: 'Broadly **speaking**, the climate is changing.'),
    CourseItem(prompt: 'Presumiblemente, el vuelo saldrá a su hora.', answer: '**Presumably**, the flight will leave on time.'),
    CourseItem(prompt: 'Los datos sugieren una mejora.', answer: 'The data **suggest** an improvement.', accepted: ['suggests']),
    CourseItem(prompt: 'Esto podría deberse al coste.', answer: 'This **might** be due to the cost.', accepted: ['could', 'may']),
    CourseItem(prompt: 'La gente suele subestimar el riesgo. (tend)', answer: 'People **tend** to underestimate the risk.'),
    CourseItem(prompt: 'Parece haber un malentendido.', answer: 'There **appears** to be a misunderstanding.', accepted: ['seems']),
    CourseItem(prompt: 'En cierta medida, ambos tienen razón.', answer: 'To a certain **extent**, both are right.'),
    CourseItem(prompt: 'Es probable que los resultados varíen. (likely)', answer: 'The results are **likely** to vary.'),
    CourseItem(prompt: 'Cabría suponer que el mercado se recupere.', answer: 'One might **assume** that the market will recover.'),
    CourseItem(prompt: 'Por regla general, cuanto más simple, mejor.', answer: 'As a general **rule**, the simpler, the better.'),
  ],
);

final QuizContent esEnC11Collocations = esEnVocab(
  id: 'es_en_c1_1_collocations',
  title: 'Colocaciones fuertes',
  intro: 'Las parejas de palabras que el nativo usa sin pensar. Saberlas '
      'es sonar natural; ignorarlas es sonar traducido.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: 'No traduzcas la pareja',
      text: '"cometer un error" es make a mistake (no commit); "prestar '
          'atención" es pay attention (no lend). La pareja se aprende '
          'entera.',
    ),
  ],
  pairs: const [
    MapEntry('prestar atención', 'pay attention'),
    MapEntry('sacar una conclusión', 'draw a conclusion'),
    MapEntry('plantear una pregunta', 'raise a question'),
    MapEntry('cumplir un plazo', 'meet a deadline'),
    MapEntry('desempeñar un papel', 'play a role'),
    MapEntry('correr un riesgo', 'take a risk'),
    MapEntry('llegar a un acuerdo', 'reach an agreement'),
    MapEntry('tener sentido', 'make sense'),
    MapEntry('lluvia intensa', 'heavy rain'),
    MapEntry('gran diferencia', 'a huge difference'),
    MapEntry('rotundo éxito', 'a resounding success'),
    MapEntry('conocimiento profundo', 'in-depth knowledge'),
  ],
);

final QuizContent esEnC11ListenLecture = esEnListen(
  id: 'es_en_c1_1_listen_lecture',
  title: 'Escucha: The lecture',
  passageTitle: 'Why cities grow',
  passage:
      "Why do some cities grow while others shrink? Broadly speaking, "
      "researchers point to three factors. First, jobs: people tend to "
      "follow employment, and employers tend to follow talent — a circle "
      "that is hard to break into and hard to fall out of. Second, "
      "universities appear to play a larger role than was assumed twenty "
      "years ago; graduates often stay where they studied. Third, and "
      "arguably most important, is housing. Where new homes cannot be "
      "built, growth simply moves elsewhere. Not only do high prices push "
      "young families out — they also discourage the very employers that "
      "started the circle.",
  passageTranslation:
      '¿Por qué crecen unas ciudades mientras otras menguan? En términos '
      'generales, los investigadores señalan tres factores. Primero, el '
      'empleo: la gente tiende a seguir al trabajo, y los empleadores '
      'tienden a seguir al talento: un círculo difícil de romper desde '
      'fuera y de abandonar desde dentro. Segundo, las universidades '
      'parecen desempeñar un papel mayor del que se suponía hace veinte '
      'años; los graduados suelen quedarse donde estudiaron. Tercero, y '
      'posiblemente lo más importante, la vivienda. Donde no se pueden '
      'construir casas nuevas, el crecimiento simplemente se traslada a '
      'otro lugar. Los precios altos no solo expulsan a las familias '
      'jóvenes: también desaniman precisamente a los empleadores que '
      'iniciaron el círculo.',
  intro: 'Una mini-conferencia académica: hedging, inversión y '
      'colocaciones, todo hablado.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Escucha el andamiaje',
      text: 'First… Second… Third, and arguably most important… — el '
          'esqueleto numerado es tu mapa del audio académico.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'How many factors does the lecture mention?',
      options: ['Two', 'Three', 'Four'],
      correctIndex: 1,
      questionTranslation: '¿Cuántos factores menciona la conferencia?',
    ),
    ReadingQuestion(
      question: 'What do graduates often do?',
      options: [
        'Move abroad',
        'Stay where they studied',
        'Change careers',
      ],
      correctIndex: 1,
      questionTranslation: '¿Qué suelen hacer los graduados?',
    ),
    ReadingQuestion(
      question: 'Which factor is described as arguably most important?',
      options: ['Jobs', 'Universities', 'Housing'],
      correctIndex: 2,
      questionTranslation: '¿Qué factor se describe como posiblemente el más importante?',
    ),
  ],
);

final QuizContent esEnC11SpeakingMid = esEnSpeaking(
  id: 'es_en_c1_1_speaking_mid',
  title: 'Conversación: analizar un tema',
  level: 'C1.1',
  topic: 'An analytical discussion: pick a trend you know well (in your '
      'city, your industry or your generation), explain its causes and '
      'effects, and qualify your claims like an analyst.',
  practisePoints: [
    'Hedged claims: tend to, appear to, arguably',
    'Cause and effect with nominalisations: the growth of…, the loss of…',
    'One inversion for emphasis: Not only… but also…',
  ],
  scoringCriteria: [
    'Claims are qualified, not absolute',
    'Formal vocabulary and collocations',
    'Inversion used correctly at least once',
  ],
  priorityErrors: [
    'absolute claims where hedging is needed',
    'collocations translated literally from Spanish',
    'inversion without auxiliary-subject order',
  ],
  mode: SpeakingMode.conversation,
  session: const SpeakingSession(
    durationMinutes: 3,
    minExchanges: 6,
    minQuestionsPerPoint: 1,
  ),
  intro: 'Punto de control: analiza una tendencia con tu asistente de IA '
      'como si presentaras a un comité. Copia, habla y trae la puntuación.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Piensa en columnas',
      text: 'Causas / efectos / matices. Un minuto por columna y habrás '
          'sonado más C1 que con diez opiniones sueltas.',
    ),
  ],
);

final QuizContent esEnC11ReadEssay = esEnRead(
  id: 'es_en_c1_1_read_essay',
  title: 'Lectura: The paradox of choice',
  passageTitle: 'The paradox of choice',
  passage:
      "It is widely assumed that more choice makes us happier. The evidence, "
      "however, points in a rather different direction. In a well-known "
      "study, shoppers who were offered twenty-four varieties of jam were "
      "far less likely to buy any of them than those offered only six. The "
      "growth of options appears to raise the cost of every decision: with "
      "so many alternatives, the fear of making the wrong choice can "
      "outweigh the pleasure of making any choice at all. This is not to "
      "say that choice is undesirable — merely that its benefits tend to "
      "flatten out surprisingly early. Rarely, it seems, does the "
      "twenty-fourth jam make anyone happier.",
  passageTranslation:
      'Se asume ampliamente que más opciones nos hacen más felices. La '
      'evidencia, sin embargo, apunta en una dirección bastante distinta. '
      'En un estudio célebre, los compradores a los que se ofrecieron '
      'veinticuatro variedades de mermelada compraron mucho menos que '
      'aquellos a los que se ofrecieron solo seis. El crecimiento de las '
      'opciones parece elevar el coste de cada decisión: con tantas '
      'alternativas, el miedo a elegir mal puede pesar más que el placer '
      'de elegir. Esto no significa que la variedad sea indeseable, solo '
      'que sus beneficios tienden a estancarse sorprendentemente pronto. '
      'Rara vez, parece, la mermelada número veinticuatro hace más feliz a '
      'nadie.',
  intro: 'Un mini-ensayo con la maquinaria completa del módulo: pasiva '
      'impersonal, hedging, nominalización e inversión final.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'It is widely assumed…',
      text: 'La pasiva impersonal abre el ensayo sin decir quién asume: '
          'un clásico del registro académico que conviene robar.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'What happened with 24 varieties of jam?',
      options: [
        'People bought more',
        'People were less likely to buy any',
        'The shop ran out',
      ],
      correctIndex: 1,
      questionTranslation: '¿Qué pasó con las 24 variedades de mermelada?',
    ),
    ReadingQuestion(
      question: 'What does the growth of options appear to raise?',
      options: [
        'The cost of every decision',
        'The pleasure of shopping',
        'The price of jam',
      ],
      correctIndex: 0,
      questionTranslation: '¿Qué parece elevar el crecimiento de opciones?',
    ),
    ReadingQuestion(
      question: 'Does the author think choice is undesirable?',
      options: [
        'Yes, completely',
        'No — only that its benefits flatten out early',
        'The text does not say',
      ],
      correctIndex: 1,
      questionTranslation: '¿Piensa el autor que la variedad es indeseable?',
    ),
  ],
);

final QuizContent esEnC11SpeakFlow = esEnSpeak(
  id: 'es_en_c1_1_speak_flow',
  title: 'A hablar: el ritmo académico',
  intro: 'Frases largas con subordinadas: el reto es respirar donde el '
      'inglés respira. Escucha las pausas y cópialas.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '⚑S10 Pausa en la coma mental',
      text: 'The evidence, however, points… — however va entre pausas. Esas '
          'micro-pausas son las comas habladas del registro formal.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'La evidencia, sin embargo, apunta a lo contrario.', answer: 'The evidence, however, points to the opposite.'),
    CourseItem(prompt: 'En términos generales, la tendencia es clara.', answer: 'Broadly speaking, the trend is clear.'),
    CourseItem(prompt: 'No solo es más rápido, sino más barato.', answer: 'Not only is it faster, but it is also cheaper.'),
    CourseItem(prompt: 'Podría argumentarse que el coste importa más.', answer: 'It could be argued that the cost matters more.'),
    CourseItem(prompt: 'Esto plantea una pregunta incómoda.', answer: 'This raises an uncomfortable question.'),
    CourseItem(prompt: 'Los datos sugieren, en cambio, una mejora.', answer: 'The data suggest, instead, an improvement.'),
    CourseItem(prompt: 'Hasta cierto punto, ambos modelos funcionan.', answer: 'To some extent, both models work.'),
    CourseItem(prompt: 'Rara vez es tan simple la respuesta.', answer: 'Rarely is the answer so simple.'),
  ],
);

final QuizContent esEnC11Dict = esEnDict(
  id: 'es_en_c1_1_dict',
  title: 'Dictado: registro formal',
  intro: 'Frases académicas al dictado: nominalizaciones, hedging e '
      'inversiones.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Anticipa la estructura',
      text: 'Si oyes Never o Not only al inicio, ya sabes que viene '
          'inversión: escribe el auxiliar antes del sujeto.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Nunca he visto un cambio tan rápido.', answer: 'Never have I seen such a fast change.'),
    CourseItem(prompt: 'Los precios tienden a subir en primavera.', answer: 'Prices tend to rise in spring.'),
    CourseItem(prompt: 'La decisión fue criticada ampliamente.', answer: 'The decision was widely criticised.'),
    CourseItem(prompt: 'Podría argumentarse que fue inevitable.', answer: 'It could be argued that it was inevitable.'),
    CourseItem(prompt: 'No solo llegó tarde, sino que además se quejó.', answer: 'Not only did he arrive late, but he also complained.'),
    CourseItem(prompt: 'El crecimiento de la demanda sorprendió a todos.', answer: 'The growth of demand surprised everyone.'),
    CourseItem(prompt: 'Hasta cierto punto, el plan funcionó.', answer: 'To some extent, the plan worked.'),
    CourseItem(prompt: 'Esto plantea varias preguntas.', answer: 'This raises several questions.'),
    CourseItem(prompt: 'Rara vez son tan claros los datos.', answer: 'Rarely are the data so clear.'),
    CourseItem(prompt: 'Su negativa a negociar prolongó la crisis.', answer: 'His refusal to negotiate prolonged the crisis.'),
    CourseItem(prompt: 'En términos generales, la calidad ha mejorado.', answer: 'Broadly speaking, quality has improved.'),
    CourseItem(prompt: 'La pérdida de confianza fue el verdadero coste.', answer: 'The loss of trust was the real cost.'),
    CourseItem(prompt: 'Parece haber una explicación más sencilla.', answer: 'There appears to be a simpler explanation.'),
    CourseItem(prompt: 'Solo entonces comprendimos la magnitud.', answer: 'Only then did we understand the scale.'),
    CourseItem(prompt: 'Cumplir el plazo exigirá más recursos.', answer: 'Meeting the deadline will require more resources.'),
  ],
);

final QuizContent esEnC11BigText = esEnBigText(
  id: 'es_en_c1_1_bigtext',
  title: 'Texto: The report',
  passageTitle: 'The quarterly report',
  intro: 'Completa un informe formal: nominalizaciones, hedging, pasivas e '
      'inversión.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Tono de informe',
      text: 'Nada de I think: aquí mandan it appears, the data suggest y '
          'los nombres abstractos.',
    ),
  ],
  template:
      'The {{0}} of sales in the northern region appears {{1}} be linked '
      'to three factors. First, the late launch: the product was {{2}} two '
      'months after our competitors\'. Second, prices {{3}} to be higher '
      'than the market average, a gap that has widened since January. '
      'Third, and {{4}} most damaging, the loss {{5}} two key partners in '
      'March. It could be {{6}} that the region was under-resourced from '
      'the start. Not only {{7}} the team lack local knowledge — they also '
      'received the new materials late. Only in June {{8}} the situation '
      'begin to improve, and early figures suggest the recovery will '
      '{{9}} sense of the investment.',
  blanks: [
    inputBlank('decline', accepted: ['fall', 'drop', 'loss']),
    inputBlank('to'),
    inputBlank('launched', accepted: ['released']),
    inputBlank('tend', accepted: ['appear', 'seem']),
    inputBlank('arguably'),
    inputBlank('of'),
    inputBlank('argued'),
    inputBlank('did'),
    inputBlank('did'),
    inputBlank('make'),
  ],
  passageTranslation:
      'El descenso de ventas en la región norte parece estar vinculado a '
      'tres factores. Primero, el lanzamiento tardío: el producto se lanzó '
      'dos meses después que el de la competencia. Segundo, los precios '
      'tienden a estar por encima de la media del mercado, una brecha que '
      'se ha ampliado desde enero. Tercero, y posiblemente lo más dañino, '
      'la pérdida de dos socios clave en marzo. Podría argumentarse que la '
      'región tuvo pocos recursos desde el principio. El equipo no solo '
      'carecía de conocimiento local: además recibió tarde los nuevos '
      'materiales. Solo en junio empezó a mejorar la situación, y las '
      'primeras cifras sugieren que la recuperación dará sentido a la '
      'inversión.',
);

final QuizContent esEnC11SpeakingClose = esEnSpeaking(
  id: 'es_en_c1_1_speaking_close',
  title: 'Conversación final: la presentación',
  level: 'C1.1',
  topic: 'Present a topic you know deeply for several minutes, as if to an '
      'expert audience, then take challenging questions: defend your '
      'analysis with qualified, precise language.',
  practisePoints: [
    'A structured argument: causes, effects, qualifications',
    'Formal register: nominalisations and collocations',
    'Hedging under pressure: that may be true to some extent, but…',
    'Emphasis with inversion where it counts',
  ],
  scoringCriteria: [
    'Register consistently formal',
    'Claims properly qualified and defended',
    'Grammar of inversion and nominalisation correct',
  ],
  targetVocabulary: [
    'arguably', 'tend to', 'raise a question', 'play a role', 'assumption',
  ],
  priorityErrors: [
    'register drops to casual speech',
    'literal Spanish collocations',
    'unqualified absolute claims',
  ],
  mode: SpeakingMode.roleplay,
  intro: 'Cierre del módulo C1.1: una presentación con preguntas hostiles '
      'amistosas. Copia, presenta y trae tu puntuación.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'La concesión elegante',
      text: 'That may be true to some extent; however… — concede un '
          'centímetro para ganar el metro.',
    ),
  ],
);

/// C1.1 in chain order.
final List<QuizContent> esEnC1_1 = [
  esEnC11Nominal,
  esEnC11Inversion,
  esEnC11Hedging,
  esEnC11Collocations,
  esEnC11ListenLecture,
  esEnC11SpeakingMid,
  esEnC11ReadEssay,
  esEnC11SpeakFlow,
  esEnC11Dict,
  esEnC11BigText,
  esEnC11SpeakingClose,
];
