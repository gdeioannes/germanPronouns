import '../../../models/quiz_content.dart';
import 'es_en_builder.dart';

/// A1.2 — La vida diaria. Spanish → English.
///
/// Big rocks: the present simple with its 3rd-person -s (⚑S13), do-support
/// for questions and negation (⚑S14), frequency adverbs before the verb,
/// have/has, can, plurals with audible finals (⚑S6) and the possessive
/// 's (⚑S17).

final QuizContent esEnA12Verbs = esEnVocab(
  id: 'es_en_a1_2_verbs',
  title: 'Verbos del día a día',
  intro: 'Los verbos que usarás cada día. En inglés el infinitivo es la forma '
      'básica, sin -ar/-er/-ir.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Una forma para casi todo',
      text: 'I work, you work, we work, they work — solo he/she/it añade -s '
          '(⚑S13). El presente inglés casi no se conjuga.',
    ),
  ],
  pairs: const [
    MapEntry('trabajar', 'work'),
    MapEntry('vivir', 'live'),
    MapEntry('comer', 'eat'),
    MapEntry('beber', 'drink'),
    MapEntry('hablar', 'speak'),
    MapEntry('estudiar', 'study'),
    MapEntry('dormir', 'sleep'),
    MapEntry('leer', 'read'),
    MapEntry('escribir', 'write'),
    MapEntry('ir', 'go'),
    MapEntry('venir', 'come'),
    MapEntry('querer', 'want'),
  ],
);

final QuizContent esEnA12PresentS = esEnFill(
  id: 'es_en_a1_2_present_s',
  title: 'La -s de he/she/it',
  intro: 'El presente simple solo cambia en tercera persona del singular: '
      'he works, she lives, it rains. Esa -s es la marca de calidad del A1.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚑S13 La -s que todos olvidan',
      text: 'He work ✗ → He work**s** ✓. Cada frase con he/she/it en presente '
          'lleva su -s. Dila y escríbela siempre.',
    ),
    HelpMemoryTip(
      kind: 'rule',
      title: 'Ortografía: -es y -ies',
      text: 'go→goes, watch→watches, study→studies (consonante + y → -ies). '
          'have es irregular: has.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Él trabaja en Madrid.', answer: 'He **works** in Madrid.'),
    CourseItem(prompt: 'Ella vive en Londres.', answer: 'She **lives** in London.'),
    CourseItem(prompt: 'Mi padre bebe café.', answer: 'My father **drinks** coffee.'),
    CourseItem(prompt: 'Ella habla tres idiomas.', answer: 'She **speaks** three languages.'),
    CourseItem(prompt: 'Él va a la escuela en autobús.', answer: 'He **goes** to school by bus.'),
    CourseItem(prompt: 'Mi hermana estudia inglés.', answer: 'My sister **studies** English.'),
    CourseItem(prompt: 'Llueve mucho aquí.', answer: 'It **rains** a lot here.'),
    CourseItem(prompt: 'Ella ve la tele por la noche.', answer: 'She **watches** TV at night.'),
    CourseItem(prompt: 'Él tiene un coche nuevo.', answer: 'He **has** a new car.'),
    CourseItem(prompt: 'Mi madre trabaja en un hospital.', answer: 'My mother **works** in a hospital.'),
    CourseItem(prompt: 'El tren sale a las ocho.', answer: 'The train **leaves** at eight.'),
    CourseItem(prompt: 'Ella come fruta cada día.', answer: 'She **eats** fruit every day.'),
    CourseItem(prompt: 'Él lee el periódico.', answer: 'He **reads** the newspaper.'),
    CourseItem(prompt: 'Mi perro duerme mucho.', answer: 'My dog **sleeps** a lot.'),
    CourseItem(prompt: 'Ella quiere un té.', answer: 'She **wants** a tea.'),
  ],
);

final QuizContent esEnA12SpeakRoutine = esEnSpeak(
  id: 'es_en_a1_2_speak_routine',
  title: 'A hablar: mi rutina',
  intro: 'Frases de rutina diaria. Escucha y repite marcando bien la -s de '
      'tercera persona.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚑S6 La -s final suena',
      text: 'works, gets, likes: la -s final se pronuncia SIEMPRE. Comértela '
          'es el acento español más reconocible.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Me levanto a las siete.', answer: 'I get up at seven.'),
    CourseItem(prompt: 'Desayuno en casa.', answer: 'I have breakfast at home.'),
    CourseItem(prompt: 'Voy al trabajo en metro.', answer: 'I go to work by underground.'),
    CourseItem(prompt: 'Ella empieza a las nueve.', answer: 'She starts at nine.'),
    CourseItem(prompt: 'Él almuerza a la una.', answer: 'He has lunch at one.'),
    CourseItem(prompt: 'Volvemos a casa a las seis.', answer: 'We come home at six.'),
    CourseItem(prompt: 'Ceno con mi familia.', answer: 'I have dinner with my family.'),
    CourseItem(prompt: 'Me acuesto a las once.', answer: 'I go to bed at eleven.'),
  ],
);

final QuizContent esEnA12DoQuestions = esEnFill(
  id: 'es_en_a1_2_do_questions',
  title: 'Preguntas con do / does',
  intro: 'Para preguntar en presente simple el inglés necesita un ayudante: '
      'do (o does con he/she/it). En español basta la entonación; en inglés no.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚑S14 Sin do no hay pregunta',
      text: '"¿Trabajas?" no es "You work?" sino **Do** you work? Con '
          'he/she/it: **Does** she work? — y el verbo pierde la -s.',
    ),
    HelpMemoryTip(
      kind: 'rule',
      title: 'does se lleva la -s',
      text: 'Does he work**s**? ✗ → Does he work? ✓. La -s ya va en does.',
    ),
  ],
  items: const [
    CourseItem(prompt: '¿Trabajas aquí?', answer: '**Do** you work here?'),
    CourseItem(prompt: '¿Vive ella en Madrid?', answer: '**Does** she live in Madrid?'),
    CourseItem(prompt: '¿Hablas inglés?', answer: '**Do** you speak English?'),
    CourseItem(prompt: '¿Bebe él café?', answer: '**Does** he drink coffee?'),
    CourseItem(prompt: '¿Estudian ellos aquí?', answer: '**Do** they study here?'),
    CourseItem(prompt: '¿Come ella carne?', answer: '**Does** she eat meat?'),
    CourseItem(prompt: '¿Quieres un té?', answer: '**Do** you want a tea?'),
    CourseItem(prompt: '¿Tiene él hermanos?', answer: '**Does** he have brothers?'),
    CourseItem(prompt: '¿Vivís vosotros cerca?', answer: '**Do** you live near here?'),
    CourseItem(prompt: '¿Trabaja tu madre?', answer: '**Does** your mother work?'),
    CourseItem(prompt: '¿Leen ellos el periódico?', answer: '**Do** they read the newspaper?'),
    CourseItem(prompt: '¿Duerme el bebé?', answer: '**Does** the baby sleep?'),
    CourseItem(prompt: '¿Necesitas ayuda?', answer: '**Do** you need help?'),
    CourseItem(prompt: '¿Va ella a la escuela?', answer: '**Does** she go to school?'),
    CourseItem(prompt: '¿Sabes la respuesta? (know)', answer: '**Do** you know the answer?'),
  ],
);

final QuizContent esEnA12Days = esEnVocab(
  id: 'es_en_a1_2_days',
  title: 'Días y momentos del día',
  intro: 'Los días de la semana y las partes del día. Los días llevan '
      'mayúscula y la preposición on.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: 'Mayúscula y on',
      text: 'Monday, Tuesday… siempre con mayúscula. "el lunes" = on Monday, '
          '"los lunes" = on Mondays — nunca "the Monday".',
    ),
  ],
  pairs: const [
    MapEntry('lunes', 'Monday'),
    MapEntry('martes', 'Tuesday'),
    MapEntry('miércoles', 'Wednesday'),
    MapEntry('jueves', 'Thursday'),
    MapEntry('viernes', 'Friday'),
    MapEntry('sábado', 'Saturday'),
    MapEntry('domingo', 'Sunday'),
    MapEntry('por la mañana', 'in the morning'),
    MapEntry('por la tarde', 'in the afternoon'),
    MapEntry('por la noche', 'at night'),
  ],
);

final QuizContent esEnA12ListenDay = esEnListen(
  id: 'es_en_a1_2_listen_day',
  title: 'Escucha: Daniel\'s day',
  passageTitle: "Daniel's day",
  passage:
      "Daniel works from home. He gets up at eight and drinks a big coffee. "
      "He works on his computer from nine to five. On Tuesdays he plays "
      "football with his friends. In the evening he cooks dinner and watches "
      "a film. He goes to bed at midnight.",
  passageTranslation:
      'Daniel trabaja desde casa. Se levanta a las ocho y toma un café '
      'grande. Trabaja en el ordenador de nueve a cinco. Los martes juega al '
      'fútbol con sus amigos. Por la noche cocina la cena y ve una película. '
      'Se acuesta a medianoche.',
  intro: 'La rutina de Daniel. Atento a las horas y a los días.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Las -s te dicen quién',
      text: 'works, gets, drinks: cada -s final te confirma que hablamos de '
          'él. Úsalas como pista al escuchar.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'What time does Daniel get up?',
      options: ['At seven', 'At eight', 'At nine'],
      correctIndex: 1,
      questionTranslation: '¿A qué hora se levanta Daniel?',
    ),
    ReadingQuestion(
      question: 'What does he do on Tuesdays?',
      options: ['He plays football', 'He cooks dinner', 'He watches films'],
      correctIndex: 0,
      questionTranslation: '¿Qué hace los martes?',
    ),
    ReadingQuestion(
      question: 'When does he go to bed?',
      options: ['At ten', 'At eleven', 'At midnight'],
      correctIndex: 2,
      questionTranslation: '¿Cuándo se acuesta?',
    ),
  ],
);

final QuizContent esEnA12DontNegation = esEnFill(
  id: 'es_en_a1_2_dont',
  title: 'Negar con don\'t / doesn\'t',
  intro: 'La negación del presente simple también necesita do: don\'t '
      '(doesn\'t con he/she/it) + verbo en forma base.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚑S14 doesn\'t + verbo SIN -s',
      text: 'She doesn\'t work**s** ✗ → She doesn\'t work ✓. La marca de '
          'tercera persona ya está en doesn\'t.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'No trabajo los domingos.', answer: 'I **don\'t** work on Sundays.'),
    CourseItem(prompt: 'Ella no bebe café.', answer: 'She **doesn\'t** drink coffee.'),
    CourseItem(prompt: 'No hablamos francés.', answer: 'We **don\'t** speak French.'),
    CourseItem(prompt: 'Él no come pescado.', answer: 'He **doesn\'t** eat fish.'),
    CourseItem(prompt: 'Ellos no viven aquí.', answer: 'They **don\'t** live here.'),
    CourseItem(prompt: 'No quiero azúcar.', answer: 'I **don\'t** want sugar.'),
    CourseItem(prompt: 'Mi padre no ve la tele.', answer: 'My father **doesn\'t** watch TV.'),
    CourseItem(prompt: 'No entiendo.', answer: 'I **don\'t** understand.'),
    CourseItem(prompt: 'Ella no tiene coche.', answer: 'She **doesn\'t** have a car.'),
    CourseItem(prompt: 'No estudiamos por la noche.', answer: 'We **don\'t** study at night.'),
    CourseItem(prompt: 'El bus no para aquí.', answer: 'The bus **doesn\'t** stop here.'),
    CourseItem(prompt: 'No me gusta el frío. (like)', answer: 'I **don\'t** like the cold.'),
    CourseItem(prompt: 'Él no juega al tenis.', answer: 'He **doesn\'t** play tennis.'),
    CourseItem(prompt: 'Ellos no necesitan ayuda.', answer: 'They **don\'t** need help.'),
    CourseItem(prompt: 'Ella no lee revistas.', answer: 'She **doesn\'t** read magazines.'),
  ],
);

final QuizContent esEnA12Adverbs = esEnFill(
  id: 'es_en_a1_2_adverbs',
  title: 'always, usually, never…',
  intro: 'Los adverbios de frecuencia van ANTES del verbo (pero después de '
      'be): I always walk · She is always late.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'La posición',
      text: 'Antes del verbo normal (I **usually** work), después de be '
          '(He **is** usually tired).',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: 'never ya es negativo',
      text: 'I never don\'t go ✗ → I never go ✓. Con never no se añade otra '
          'negación.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Siempre desayuno. (always)', answer: 'I **always** have breakfast.'),
    CourseItem(prompt: 'Normalmente trabajo en casa. (usually)', answer: 'I **usually** work at home.'),
    CourseItem(prompt: 'Ella nunca llega tarde. (never)', answer: 'She **never** arrives late.'),
    CourseItem(prompt: 'A veces como fuera. (sometimes)', answer: 'I **sometimes** eat out.'),
    CourseItem(prompt: 'Él siempre está cansado.', answer: 'He is **always** tired.'),
    CourseItem(prompt: 'A menudo leemos por la noche. (often)', answer: 'We **often** read at night.'),
    CourseItem(prompt: 'Nunca bebo café por la tarde.', answer: 'I **never** drink coffee in the afternoon.'),
    CourseItem(prompt: 'Ella normalmente está en casa.', answer: 'She is **usually** at home.'),
    CourseItem(prompt: 'Ellos a veces juegan al fútbol.', answer: 'They **sometimes** play football.'),
    CourseItem(prompt: 'Él a menudo va andando al trabajo.', answer: 'He **often** walks to work.'),
    CourseItem(prompt: 'Siempre estamos ocupados los lunes.', answer: 'We are **always** busy on Mondays.'),
    CourseItem(prompt: 'Mi madre nunca ve la tele.', answer: 'My mother **never** watches TV.'),
    CourseItem(prompt: 'Normalmente duermo ocho horas.', answer: 'I **usually** sleep eight hours.'),
    CourseItem(prompt: 'A veces está frío por la mañana.', answer: 'It is **sometimes** cold in the morning.'),
    CourseItem(prompt: 'Él siempre estudia por la tarde.', answer: 'He **always** studies in the afternoon.'),
  ],
);

final QuizContent esEnA12Time = esEnFill(
  id: 'es_en_a1_2_time',
  title: 'La hora y las preposiciones at / on / in',
  intro: 'at + hora (at seven), on + día (on Monday), in + parte del día o '
      'mes (in the morning, in May).',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'De pequeño a grande',
      text: 'at lo puntual (hora) → on el día → in lo grande (mes, año, '
          'mañana/tarde). Excepción: at night.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'a las siete', answer: '**at** seven o\'clock'),
    CourseItem(prompt: 'el lunes', answer: '**on** Monday'),
    CourseItem(prompt: 'por la mañana', answer: '**in** the morning'),
    CourseItem(prompt: 'por la noche', answer: '**at** night'),
    CourseItem(prompt: 'en mayo', answer: '**in** May'),
    CourseItem(prompt: 'los sábados', answer: '**on** Saturdays'),
    CourseItem(prompt: 'Trabajo a las nueve.', answer: 'I work **at** nine.'),
    CourseItem(prompt: 'La clase es el viernes.', answer: 'The class is **on** Friday.'),
    CourseItem(prompt: 'Leo por la tarde.', answer: 'I read **in** the afternoon.'),
    CourseItem(prompt: 'El tren llega a las diez y media.', answer: 'The train arrives **at** half past ten.'),
    CourseItem(prompt: 'Mi cumpleaños es en junio.', answer: 'My birthday is **in** June.'),
    CourseItem(prompt: 'No trabajamos los domingos.', answer: 'We don\'t work **on** Sundays.'),
    CourseItem(prompt: 'Estudio por la noche. (at)', answer: 'I study **at** night.'),
    CourseItem(prompt: 'La reunión es el martes por la mañana.', answer: 'The meeting is **on** Tuesday morning.'),
    CourseItem(prompt: 'Ceno a las ocho.', answer: 'I have dinner **at** eight.'),
  ],
);

final QuizContent esEnA12SpeakingMid = esEnSpeaking(
  id: 'es_en_a1_2_speaking_mid',
  title: 'Conversación: mi día',
  level: 'A1.2',
  topic: 'A slow, simple chat about my daily routine: when I get up, what I '
      'eat, my work or studies, and my week days.',
  practisePoints: [
    'Present simple in first person: I get up, I work, I have lunch',
    'Times and days with at/on/in',
    'Third person -s when I talk about my family',
  ],
  scoringCriteria: [
    'Correct present simple forms, especially the 3rd-person -s',
    'at/on/in used correctly with times and days',
    'Subject pronouns always present',
  ],
  priorityErrors: [
    'missing 3rd-person -s',
    'missing do/does in questions',
    'wrong time prepositions',
  ],
  mode: SpeakingMode.conversation,
  session: const SpeakingSession(
    durationMinutes: 3,
    minExchanges: 6,
    minQuestionsPerPoint: 1,
  ),
  intro: 'Punto de control: cuéntale tu rutina a tu asistente de IA. Copia '
      'el texto, habla y teclea aquí la puntuación final.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Frases cortas y completas',
      text: 'I get up at seven. I have breakfast. Sujeto + verbo + hora: con '
          'eso ya apruebas este nivel.',
    ),
  ],
);

final QuizContent esEnA12ReadWeek = esEnRead(
  id: 'es_en_a1_2_read_week',
  title: 'Lectura: Lucía\'s week',
  passageTitle: "Lucía's week",
  passage:
      "Lucía is from Guadalajara, but she lives in London now. From Monday to "
      "Friday she works in a hospital — she is a nurse. She starts at seven "
      "in the morning, so she always gets up very early. She doesn't work on "
      "Saturdays. On Sundays she calls her family in Mexico and cooks a big "
      "lunch. She loves her free days.",
  passageTranslation:
      'Lucía es de Guadalajara, pero ahora vive en Londres. De lunes a '
      'viernes trabaja en un hospital: es enfermera. Empieza a las siete de '
      'la mañana, así que siempre se levanta muy temprano. No trabaja los '
      'sábados. Los domingos llama a su familia en México y cocina una gran '
      'comida. Le encantan sus días libres.',
  intro: 'La semana de Lucía. Fíjate en las -s de tercera persona y en '
      'doesn\'t.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'so = así que',
      text: '"She starts at seven, so she gets up early": so conecta causa y '
          'consecuencia, tu primer conector.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: "What is Lucía's job?",
      options: ['Teacher', 'Nurse', 'Doctor'],
      correctIndex: 1,
      questionTranslation: '¿Cuál es el trabajo de Lucía?',
    ),
    ReadingQuestion(
      question: 'When does she start work?',
      options: ['At seven', 'At eight', 'At nine'],
      correctIndex: 0,
      questionTranslation: '¿A qué hora empieza a trabajar?',
    ),
    ReadingQuestion(
      question: 'What does she do on Sundays?',
      options: [
        'She works at the hospital',
        'She calls her family and cooks',
        'She plays football',
      ],
      correctIndex: 1,
      questionTranslation: '¿Qué hace los domingos?',
    ),
  ],
);

final QuizContent esEnA12Have = esEnFill(
  id: 'es_en_a1_2_have',
  title: 'have / has: tener',
  intro: 'have = tener (y también "tomar" comidas: have breakfast). Con '
      'he/she/it se convierte en has.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'have → has',
      text: 'I/you/we/they have · he/she/it has. En negativa vuelve la forma '
          'base: she doesn\'t have.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'have para las comidas',
      text: 'have breakfast/lunch/dinner = desayunar/comer/cenar. Sin '
          'artículo: have breakfast, no "have the breakfast".',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Tengo dos hermanas.', answer: 'I **have** two sisters.'),
    CourseItem(prompt: 'Ella tiene un gato.', answer: 'She **has** a cat.'),
    CourseItem(prompt: 'Tenemos una casa pequeña.', answer: 'We **have** a small house.'),
    CourseItem(prompt: 'Él tiene veinte años. (edad con be)', answer: 'He **is** twenty years old.'),
    CourseItem(prompt: 'Mis padres tienen un coche.', answer: 'My parents **have** a car.'),
    CourseItem(prompt: 'Desayuno a las siete.', answer: 'I **have** breakfast at seven.'),
    CourseItem(prompt: 'Ella tiene el pelo largo.', answer: 'She **has** long hair.'),
    CourseItem(prompt: 'La casa tiene tres habitaciones.', answer: 'The house **has** three rooms.'),
    CourseItem(prompt: '¿Tienes tiempo?', answer: 'Do you **have** time?'),
    CourseItem(prompt: 'Él no tiene hermanos.', answer: 'He doesn\'t **have** brothers.'),
    CourseItem(prompt: 'Como (almuerzo) a la una.', answer: 'I **have** lunch at one.'),
    CourseItem(prompt: 'Ella tiene una idea.', answer: 'She **has** an idea.'),
    CourseItem(prompt: 'Tenemos clase el lunes.', answer: 'We **have** class on Monday.'),
    CourseItem(prompt: 'Mi hermano tiene un perro.', answer: 'My brother **has** a dog.'),
    CourseItem(prompt: 'Ceno tarde.', answer: 'I **have** dinner late.'),
  ],
);

final QuizContent esEnA12Family = esEnVocab(
  id: 'es_en_a1_2_family',
  title: 'La familia · Family',
  intro: 'La familia cercana. Ojo: parents = padres, NO "parientes".',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚑S25 Falso amigo: parents',
      text: 'parents = padres (papá y mamá). "Parientes" se dice relatives. '
          'Tu primer falso amigo del curso.',
    ),
  ],
  pairs: const [
    MapEntry('madre', 'mother'),
    MapEntry('padre', 'father'),
    MapEntry('padres (papá y mamá)', 'parents'),
    MapEntry('hermano', 'brother'),
    MapEntry('hermana', 'sister'),
    MapEntry('hijo', 'son'),
    MapEntry('hija', 'daughter'),
    MapEntry('abuelo', 'grandfather'),
    MapEntry('abuela', 'grandmother'),
    MapEntry('marido', 'husband'),
    MapEntry('mujer (esposa)', 'wife'),
    MapEntry('parientes', 'relatives'),
  ],
);

final QuizContent esEnA12Possessive = esEnFill(
  id: 'es_en_a1_2_possessive',
  title: 'El posesivo \'s',
  intro: 'En inglés el dueño va primero con \'s: Ana\'s car = el coche de '
      'Ana. Nada de "the car of Ana".',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚑S17 Dueño + \'s + cosa',
      text: 'my sister\'s book = el libro de mi hermana. El orden español '
          '"de + dueño" se da la vuelta.',
    ),
    HelpMemoryTip(
      kind: 'rule',
      title: 'Plural en -s: solo apóstrofo',
      text: 'my parents\' house (la casa de mis padres): tras plural en -s se '
          'añade solo la comilla.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'el coche de Ana', answer: '**Ana\'s** car'),
    CourseItem(prompt: 'el libro de mi hermana', answer: 'my **sister\'s** book'),
    CourseItem(prompt: 'el perro de Tom', answer: '**Tom\'s** dog'),
    CourseItem(prompt: 'la casa de mis padres', answer: 'my **parents\'** house'),
    CourseItem(prompt: 'el nombre de tu madre', answer: 'your **mother\'s** name'),
    CourseItem(prompt: 'la mochila de ese chico', answer: 'that **boy\'s** bag'),
    CourseItem(prompt: 'El coche de mi padre es azul.', answer: 'My **father\'s** car is blue.'),
    CourseItem(prompt: 'la profesora de mi hijo', answer: 'my **son\'s** teacher'),
    CourseItem(prompt: 'El cumpleaños de Lucía es en mayo.', answer: '**Lucía\'s** birthday is in May.'),
    CourseItem(prompt: 'la oficina de mi mujer', answer: 'my **wife\'s** office'),
    CourseItem(prompt: 'el gato de los vecinos (neighbours)', answer: 'the **neighbours\'** cat'),
    CourseItem(prompt: 'la habitación de mi hermano', answer: 'my **brother\'s** room'),
    CourseItem(prompt: 'las llaves de Daniel', answer: '**Daniel\'s** keys'),
    CourseItem(prompt: 'el trabajo de mi marido', answer: 'my **husband\'s** job'),
    CourseItem(prompt: 'la amiga de mi hija', answer: 'my **daughter\'s** friend'),
  ],
);

final QuizContent esEnA12SpeakCan = esEnSpeak(
  id: 'es_en_a1_2_speak_can',
  title: 'A hablar: can y peticiones',
  intro: 'can = poder/saber hacer algo. Escucha la diferencia entre can '
      '(débil) y can\'t (fuerte y larga).',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚑S10 can débil, can\'t fuerte',
      text: 'En "I can swim" el can casi desaparece /kən/; en "I can\'t swim" '
          'suena claro y largo. Esa es la diferencia que oirás.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Sé nadar.', answer: 'I can swim.'),
    CourseItem(prompt: 'No sé conducir.', answer: "I can't drive."),
    CourseItem(prompt: '¿Sabes cocinar?', answer: 'Can you cook?'),
    CourseItem(prompt: 'Ella habla (sabe hablar) tres idiomas.', answer: 'She can speak three languages.'),
    CourseItem(prompt: '¿Puedes ayudarme?', answer: 'Can you help me?'),
    CourseItem(prompt: '¿Puedo entrar?', answer: 'Can I come in?'),
    CourseItem(prompt: 'No te oigo. (can)', answer: "I can't hear you."),
    CourseItem(prompt: '¿Puedes repetir, por favor?', answer: 'Can you repeat that, please?'),
  ],
);

final QuizContent esEnA12Plurals = esEnFill(
  id: 'es_en_a1_2_plurals',
  title: 'Plurales: -s, -es y los irregulares',
  intro: 'La mayoría añade -s. Tras -ch/-sh/-s/-x: -es. Y unos pocos son '
      'irregulares: man→men, child→children.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Los irregulares imprescindibles',
      text: 'man→men, woman→women, child→children, person→people, foot→feet, '
          'tooth→teeth. Sin -s: "two childrens" ✗.',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: '⚑S6 El plural se oye',
      text: 'books, tables, watches: la terminación del plural se pronuncia '
          'siempre, aunque en tu variante de español la -s se relaje.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'dos libros', answer: 'two **books**'),
    CourseItem(prompt: 'tres relojes (watch)', answer: 'three **watches**'),
    CourseItem(prompt: 'dos hombres', answer: 'two **men**'),
    CourseItem(prompt: 'cuatro mujeres', answer: 'four **women**'),
    CourseItem(prompt: 'cinco niños (child)', answer: 'five **children**'),
    CourseItem(prompt: 'mucha gente (person)', answer: 'many **people**'),
    CourseItem(prompt: 'dos autobuses', answer: 'two **buses**'),
    CourseItem(prompt: 'tres ciudades (city)', answer: 'three **cities**'),
    CourseItem(prompt: 'mis pies (foot)', answer: 'my **feet**'),
    CourseItem(prompt: 'los dientes (tooth)', answer: 'the **teeth**'),
    CourseItem(prompt: 'dos cajas (box)', answer: 'two **boxes**'),
    CourseItem(prompt: 'las familias', answer: 'the **families**'),
    CourseItem(prompt: 'seis días', answer: 'six **days**'),
    CourseItem(prompt: 'dos tomates (tomato)', answer: 'two **tomatoes**'),
    CourseItem(prompt: 'los países (country)', answer: 'the **countries**'),
  ],
);

final QuizContent esEnA12ListenShop = esEnListen(
  id: 'es_en_a1_2_listen_shop',
  title: 'Escucha: In the shop',
  passageTitle: 'At the supermarket',
  passage:
      "Excuse me, where is the milk? — It's over there, next to the eggs. — "
      "Thank you. And do you have brown bread? — Yes, it's here. Anything "
      "else? — Two apples and a bottle of water, please. — That's six pounds "
      "fifty. — Here you are. — Thanks! Have a good day!",
  passageTranslation:
      'Disculpe, ¿dónde está la leche? — Está allí, junto a los huevos. — '
      'Gracias. ¿Y tienen pan integral? — Sí, está aquí. ¿Algo más? — Dos '
      'manzanas y una botella de agua, por favor. — Son seis libras '
      'cincuenta. — Aquí tiene. — ¡Gracias! ¡Buen día!',
  intro: 'Una compra rápida. Escucha qué compra y cuánto paga.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Excuse me abre la puerta',
      text: 'Para dirigirte a un desconocido: Excuse me, … Es el "disculpe" '
          'universal.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'Where is the milk?',
      options: ['Next to the eggs', 'Next to the bread', 'At the door'],
      correctIndex: 0,
      questionTranslation: '¿Dónde está la leche?',
    ),
    ReadingQuestion(
      question: 'What fruit does the customer buy?',
      options: ['Oranges', 'Apples', 'Bananas'],
      correctIndex: 1,
      questionTranslation: '¿Qué fruta compra el cliente?',
    ),
    ReadingQuestion(
      question: 'How much is it?',
      options: ['Six pounds fifty', 'Five pounds sixty', 'Seven pounds'],
      correctIndex: 0,
      questionTranslation: '¿Cuánto es?',
    ),
  ],
);

final QuizContent esEnA12Dict = esEnDict(
  id: 'es_en_a1_2_dict',
  title: 'Dictado: la rutina',
  intro: 'Escucha y escribe. Atento a la -s de tercera persona y a los '
      'plurales: se oyen, y se escriben.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚑S13 Escribe la -s que oyes',
      text: 'She works, he gets up: si la frase habla de él o ella, busca la '
          '-s al final del verbo.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Me levanto a las siete.', answer: 'I get up at seven.'),
    CourseItem(prompt: 'Ella trabaja en un hospital.', answer: 'She works in a hospital.'),
    CourseItem(prompt: 'Desayunamos a las ocho.', answer: 'We have breakfast at eight.'),
    CourseItem(prompt: 'Él bebe mucho café.', answer: 'He drinks a lot of coffee.'),
    CourseItem(prompt: 'No trabajo los domingos.', answer: 'I do not work on Sundays.'),
    CourseItem(prompt: '¿Hablas inglés?', answer: 'Do you speak English?'),
    CourseItem(prompt: 'Mi hermana estudia por la noche.', answer: 'My sister studies at night.'),
    CourseItem(prompt: 'Ellos viven en una casa pequeña.', answer: 'They live in a small house.'),
    CourseItem(prompt: 'Ella nunca llega tarde.', answer: 'She never arrives late.'),
    CourseItem(prompt: 'Tengo dos hermanos y una hermana.', answer: 'I have two brothers and one sister.'),
    CourseItem(prompt: 'El tren sale a las nueve.', answer: 'The train leaves at nine.'),
    CourseItem(prompt: 'Los niños van a la escuela.', answer: 'The children go to school.'),
    CourseItem(prompt: 'Él no come carne.', answer: 'He does not eat meat.'),
    CourseItem(prompt: 'Siempre ceno con mi familia.', answer: 'I always have dinner with my family.'),
    CourseItem(prompt: 'La casa de mis padres es grande.', answer: 'My parents\' house is big.'),
  ],
);

final QuizContent esEnA12BigText = esEnBigText(
  id: 'es_en_a1_2_bigtext',
  title: 'Texto: A normal Tuesday',
  passageTitle: 'A normal Tuesday',
  intro: 'Completa el texto: presente simple (¡la -s!), do/does y las '
      'preposiciones de tiempo.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Piensa en quién hace la acción',
      text: 'Si el sujeto es Mateo/she/he, el verbo lleva -s; si es I/we/they, '
          'no. Y las horas van con at.',
    ),
  ],
  template:
      'Mateo {{0}} up at seven every day. He {{1}} a quick breakfast and '
      'goes to work {{2}} eight. He {{3}} in an office in the centre. His '
      'sister Lucía {{4}} in a hospital, so she always {{5}} up very early. '
      '{{6}} Tuesdays they have lunch together. Mateo {{7}} like coffee, so '
      'he {{8}} tea. In the evening they {{9}} TV or read.',
  blanks: [
    inputBlank('gets'),
    inputBlank('has'),
    inputBlank('at'),
    inputBlank('works'),
    inputBlank('works'),
    inputBlank('gets'),
    inputBlank('On', accepted: ['on']),
    inputBlank("doesn't", accepted: ['does not']),
    inputBlank('drinks'),
    inputBlank('watch'),
  ],
  passageTranslation:
      'Mateo se levanta a las siete todos los días. Toma un desayuno rápido '
      'y va al trabajo a las ocho. Trabaja en una oficina en el centro. Su '
      'hermana Lucía trabaja en un hospital, así que siempre se levanta muy '
      'temprano. Los martes comen juntos. A Mateo no le gusta el café, así '
      'que bebe té. Por la noche ven la tele o leen.',
);

final QuizContent esEnA12SpeakingClose = esEnSpeaking(
  id: 'es_en_a1_2_speaking_close',
  title: 'Conversación final: mi semana',
  level: 'A1.2',
  topic: 'An interview about my typical week: my routine from Monday to '
      'Sunday, my work or studies, my family\'s routines, and what I can do '
      '(languages, sports, cooking).',
  practisePoints: [
    'Present simple with correct 3rd-person -s',
    'Days, times and at/on/in',
    'Frequency adverbs: always, usually, sometimes, never',
    'can/can\'t for abilities',
  ],
  scoringCriteria: [
    'Present simple accuracy including questions with do/does',
    'Time expressions with the right preposition',
    'Frequency adverbs in the right position',
  ],
  targetVocabulary: [
    'get up', 'have breakfast', 'work', 'usually', 'never', 'can',
  ],
  priorityErrors: [
    'missing 3rd-person -s',
    'questions without do/does',
    'dropped subject pronouns',
  ],
  mode: SpeakingMode.interview,
  intro: 'Cierre del módulo A1.2: una entrevista sobre tu semana en tu '
      'asistente de IA. Copia, habla y trae tu puntuación.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Recicla las frases del módulo',
      text: 'I usually get up at seven. I never work on Sundays. Las frases '
          'de los quizzes son exactamente las que necesitas aquí.',
    ),
  ],
);

/// A1.2 in chain order.
final List<QuizContent> esEnA1_2 = [
  esEnA12Verbs,
  esEnA12PresentS,
  esEnA12SpeakRoutine,
  esEnA12DoQuestions,
  esEnA12Days,
  esEnA12ListenDay,
  esEnA12DontNegation,
  esEnA12Adverbs,
  esEnA12Time,
  esEnA12SpeakingMid,
  esEnA12ReadWeek,
  esEnA12Have,
  esEnA12Family,
  esEnA12Possessive,
  esEnA12SpeakCan,
  esEnA12Plurals,
  esEnA12ListenShop,
  esEnA12Dict,
  esEnA12BigText,
  esEnA12SpeakingClose,
];
