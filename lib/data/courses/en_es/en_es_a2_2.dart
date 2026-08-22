import '../../../models/quiz_content.dart';
import 'en_es_builder.dart';

/// A2.2 — Plans, wants & city life. English → Spanish.
///
/// Big rocks: ir a + infinitive for the future, tener que / hay que,
/// direct-object pronouns and clitic placement (⚑E17), the personal a
/// (⚑E16), comparisons (⚑E22), directions, food and shopping.

final QuizContent enEsA22IrA = enEsFill(
  id: 'en_es_a2_2_ir_a',
  title: 'Plans: voy a + infinitive',
  intro: 'The everyday future: ir a + infinitive. Voy a viajar = I am '
      'going to travel. Conjugate ir, leave the main verb whole.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'voy / vas / va / vamos / van + a',
      text: 'Only ir changes; the action verb stays infinitive: vamos a '
          'comer, van a estudiar.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'I am going to travel to Spain.', answer: 'Voy a **viajar** a España.'),
    CourseItem(prompt: 'She is going to study medicine.', answer: 'Va a **estudiar** medicina.'),
    CourseItem(prompt: 'We are going to buy a house.', answer: 'Vamos a **comprar** una casa.'),
    CourseItem(prompt: 'It is going to rain.', answer: 'Va a **llover**.'),
    CourseItem(prompt: 'They are going to sell the car.', answer: 'Van a **vender** el coche.'),
    CourseItem(prompt: 'What are you going to do tomorrow? (tú)', answer: '¿Qué **vas** a hacer mañana?'),
    CourseItem(prompt: 'I am going to cook tonight.', answer: '**Voy** a cocinar esta noche.'),
    CourseItem(prompt: 'We are going to watch a film.', answer: '**Vamos** a ver una película.'),
    CourseItem(prompt: 'He is going to visit his grandparents.', answer: '**Va** a visitar a sus abuelos.'),
    CourseItem(prompt: 'I am not going to work on Saturday.', answer: 'No **voy** a trabajar el sábado.'),
    CourseItem(prompt: 'Are you all going to come? (ustedes)', answer: '¿**Van** a venir ustedes?'),
    CourseItem(prompt: 'I am going to learn to drive.', answer: 'Voy a **aprender** a conducir.'),
    CourseItem(prompt: 'She is going to get up early.', answer: 'Va a **levantarse** temprano.'),
    CourseItem(prompt: 'We are going to have dinner out.', answer: 'Vamos a **cenar** fuera.'),
    CourseItem(prompt: 'They are going to open a restaurant.', answer: 'Van a **abrir** un restaurante.'),
  ],
);

final QuizContent enEsA22TenerQue = enEsFill(
  id: 'en_es_a2_2_tener_que',
  title: 'tener que / hay que: obligation',
  intro: 'tengo que estudiar = I have to study (personal). hay que '
      'estudiar = one has to study (general rule).',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Personal vs general',
      text: 'tener que + infinitive when someone specific must; hay que + '
          'infinitive for everyone/nobody in particular.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'I have to study tonight.', answer: '**Tengo** que estudiar esta noche.'),
    CourseItem(prompt: 'She has to work on Saturday.', answer: '**Tiene** que trabajar el sábado.'),
    CourseItem(prompt: 'We have to buy bread.', answer: '**Tenemos** que comprar pan.'),
    CourseItem(prompt: 'One has to practise every day.', answer: '**Hay** que practicar todos los días.'),
    CourseItem(prompt: 'You have to see this film! (tú)', answer: '¡**Tienes** que ver esta película!'),
    CourseItem(prompt: 'One has to be patient.', answer: '**Hay** que tener paciencia.'),
    CourseItem(prompt: 'They have to get up early.', answer: '**Tienen** que levantarse temprano.'),
    CourseItem(prompt: 'I have to call my mother.', answer: '**Tengo** que llamar a mi madre.'),
    CourseItem(prompt: 'One has to book in advance. (reservar)', answer: '**Hay** que reservar con antelación.'),
    CourseItem(prompt: 'Do you have to leave already? (tú, irte)', answer: '¿**Tienes** que irte ya?'),
    CourseItem(prompt: 'We have to clean the house.', answer: '**Tenemos** que limpiar la casa.'),
    CourseItem(prompt: 'One has to eat more vegetables.', answer: '**Hay** que comer más verduras.'),
    CourseItem(prompt: 'He has to finish the report.', answer: '**Tiene** que terminar el informe.'),
    CourseItem(prompt: 'I have to be at the airport at six.', answer: '**Tengo** que estar en el aeropuerto a las seis.'),
    CourseItem(prompt: 'One has to speak Spanish in class.', answer: '**Hay** que hablar español en clase.'),
  ],
);

final QuizContent enEsA22ObjectPronouns = enEsFill(
  id: 'en_es_a2_2_object_pronouns',
  title: 'lo / la / los / las: object pronouns',
  intro: 'it/them become lo/la/los/las — and they jump BEFORE the verb: '
      'Lo veo = I see it. With infinitives they can hang on the end: voy '
      'a comprarlo (⚑E17).',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚑E17 Before the verb!',
      text: '"I see it" → Lo veo, never "veo lo". The pronoun leapfrogs '
          'the conjugated verb. Attached only to infinitive/gerund/command.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'I see it. (el coche)', answer: '**Lo** veo.'),
    CourseItem(prompt: 'I see her.', answer: '**La** veo.'),
    CourseItem(prompt: 'I buy them. (los libros)', answer: '**Los** compro.'),
    CourseItem(prompt: 'Do you have it? (la llave, tú)', answer: '¿**La** tienes?'),
    CourseItem(prompt: 'I don\'t know him.', answer: 'No **lo** conozco.'),
    CourseItem(prompt: 'She calls me every day.', answer: '**Me** llama todos los días.'),
    CourseItem(prompt: 'I\'ll help you. (tú)', answer: '**Te** ayudo.'),
    CourseItem(prompt: 'I am going to buy it. (el pan, attached)', answer: 'Voy a **comprarlo**.'),
    CourseItem(prompt: 'We watch it at night. (la serie)', answer: '**La** vemos por la noche.'),
    CourseItem(prompt: 'They invite us.', answer: '**Nos** invitan.'),
    CourseItem(prompt: 'I want to see it. (la película, attached)', answer: 'Quiero **verla**.'),
    CourseItem(prompt: 'He doesn\'t eat them. (las verduras)', answer: 'No **las** come.'),
    CourseItem(prompt: 'I love you.', answer: '**Te** quiero.'),
    CourseItem(prompt: 'Do you understand me? (tú)', answer: '¿**Me** entiendes?'),
    CourseItem(prompt: 'I\'ll do it tomorrow.', answer: '**Lo** hago mañana.'),
  ],
);

final QuizContent enEsA22PersonalA = enEsFill(
  id: 'en_es_a2_2_personal_a',
  title: 'The personal a',
  intro: 'When the object of the verb is a PERSON, Spanish inserts a: Veo '
      'a María, but Veo la tele. Invisible in English, mandatory in '
      'Spanish (⚑E16).',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Person → a, thing → nothing',
      text: 'Busco a mi hermano (person) · Busco mis llaves (thing). Pets '
          'you love count as people: Veo a mi perro.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'I see María.', answer: 'Veo **a** María.'),
    CourseItem(prompt: 'I watch TV. (no a!)', answer: 'Veo **la** tele.'),
    CourseItem(prompt: 'I am looking for my brother.', answer: 'Busco **a** mi hermano.'),
    CourseItem(prompt: 'I am looking for my keys. (no a!)', answer: 'Busco **mis** llaves.'),
    CourseItem(prompt: 'We visit our grandmother.', answer: 'Visitamos **a** nuestra abuela.'),
    CourseItem(prompt: 'She calls her friend (f.).', answer: 'Llama **a** su amiga.'),
    CourseItem(prompt: 'I know your sister. (conocer)', answer: 'Conozco **a** tu hermana.'),
    CourseItem(prompt: 'Do you hear the music? (no a!)', answer: '¿Oyes **la** música?'),
    CourseItem(prompt: 'Do you hear the neighbour? (tú)', answer: '¿Oyes **al** vecino?'),
    CourseItem(prompt: 'I love my dog. (querer)', answer: 'Quiero **a** mi perro.'),
    CourseItem(prompt: 'They invite Carlos.', answer: 'Invitan **a** Carlos.'),
    CourseItem(prompt: 'I help my parents.', answer: 'Ayudo **a** mis padres.'),
    CourseItem(prompt: 'We are waiting for the bus. (no a before el… careful: esperar el)', answer: 'Esperamos **el** autobús.'),
    CourseItem(prompt: 'We are waiting for the teacher.', answer: 'Esperamos **al** profesor.'),
    CourseItem(prompt: 'She takes her son to school. (llevar)', answer: 'Lleva **a** su hijo a la escuela.'),
  ],
);

final QuizContent enEsA22Comparisons = enEsFill(
  id: 'en_es_a2_2_comparisons',
  title: 'Comparing: más… que, tan… como',
  intro: 'más alto que (taller than), menos caro que (less expensive '
      'than), tan grande como (as big as). Irregulars: mejor, peor, '
      'mayor, menor (⚑E22).',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'The four irregulars',
      text: 'más bueno → mejor · más malo → peor · más viejo (person) → '
          'mayor · más joven → menor.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'He is taller than me.', answer: 'Es **más** alto que yo.'),
    CourseItem(prompt: 'This book is less expensive.', answer: 'Este libro es **menos** caro.'),
    CourseItem(prompt: 'My city is as big as Madrid.', answer: 'Mi ciudad es **tan** grande como Madrid.'),
    CourseItem(prompt: 'The coffee here is better.', answer: 'El café aquí es **mejor**.'),
    CourseItem(prompt: 'The weather today is worse.', answer: 'El tiempo hoy es **peor**.'),
    CourseItem(prompt: 'My brother is older than me. (person)', answer: 'Mi hermano es **mayor** que yo.'),
    CourseItem(prompt: 'My sister is younger.', answer: 'Mi hermana es **menor**.'),
    CourseItem(prompt: 'The train is faster than the bus.', answer: 'El tren es **más** rápido que el autobús.'),
    CourseItem(prompt: 'This street is quieter. (tranquila)', answer: 'Esta calle es **más** tranquila.'),
    CourseItem(prompt: 'It\'s the best restaurant in the city.', answer: 'Es el **mejor** restaurante de la ciudad.'),
    CourseItem(prompt: 'It was the worst day of the year.', answer: 'Fue el **peor** día del año.'),
    CourseItem(prompt: 'She works as much as you. (tanto como)', answer: 'Trabaja **tanto** como tú.'),
    CourseItem(prompt: 'It is the biggest building. (grande)', answer: 'Es el edificio **más** grande.'),
    CourseItem(prompt: 'I have as many books as you. (tantos)', answer: 'Tengo **tantos** libros como tú.'),
    CourseItem(prompt: 'Lima is more expensive than before.', answer: 'Lima es **más** cara que antes.'),
  ],
);

final QuizContent enEsA22Town = enEsVocab(
  id: 'en_es_a2_2_town',
  title: 'Around town · La ciudad',
  intro: 'City places and how to move between them.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚑E25 librería ≠ library',
      text: 'la librería = bookshop; the library is la biblioteca. The '
          'classic false friend, in the other direction this time.',
    ),
  ],
  pairs: const [
    MapEntry('library', 'la biblioteca'),
    MapEntry('bookshop', 'la librería'),
    MapEntry('town hall', 'el ayuntamiento'),
    MapEntry('train station', 'la estación de tren'),
    MapEntry('chemist\'s / pharmacy', 'la farmacia'),
    MapEntry('supermarket', 'el supermercado'),
    MapEntry('church', 'la iglesia'),
    MapEntry('bridge', 'el puente'),
    MapEntry('square', 'la plaza'),
    MapEntry('corner', 'la esquina'),
    MapEntry('traffic lights', 'el semáforo'),
    MapEntry('bus stop', 'la parada de autobús'),
  ],
);

final QuizContent enEsA22ListenDirections = enEsListen(
  id: 'en_es_a2_2_listen_directions',
  title: 'Listening: ¿Cómo llego?',
  passageTitle: 'Camino al museo',
  passage:
      'Disculpe, ¿cómo llego al museo? — Es fácil. Siga todo recto dos '
      'calles y gire a la izquierda en el semáforo. El museo está a la '
      'derecha, al lado de la biblioteca. — ¿Está lejos? — No, a unos '
      'diez minutos a pie. — ¡Muchas gracias! — De nada. ¡Buen día!',
  passageTranslation:
      "Excuse me, how do I get to the museum? — It's easy. Go straight "
      "on for two streets and turn left at the traffic lights. The museum "
      "is on the right, next to the library. — Is it far? — No, about "
      "ten minutes on foot. — Thank you very much! — You're welcome. "
      "Have a good day!",
  intro: 'Street directions. Listen for left, right and straight on.',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'The directions kit',
      text: 'todo recto (straight on), gire a la izquierda/derecha '
          '(turn), al lado de (next to), a … minutos a pie.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '¿Dónde hay que girar a la izquierda?',
      options: ['En el puente', 'En el semáforo', 'En la plaza'],
      correctIndex: 1,
      questionTranslation: 'Where do you turn left?',
    ),
    ReadingQuestion(
      question: '¿Al lado de qué está el museo?',
      options: ['De la biblioteca', 'De la estación', 'De la iglesia'],
      correctIndex: 0,
      questionTranslation: 'What is the museum next to?',
    ),
    ReadingQuestion(
      question: '¿A cuántos minutos está a pie?',
      options: ['Cinco', 'Diez', 'Veinte'],
      correctIndex: 1,
      questionTranslation: 'How many minutes on foot?',
    ),
  ],
);

final QuizContent enEsA22SpeakingMid = enEsSpeaking(
  id: 'en_es_a2_2_speaking_mid',
  title: 'Conversation: my plans',
  level: 'A2.2',
  topic: 'A chat in Spanish about my plans: what I am going to do this '
      'week, next weekend, and my summer plans — plus what I have to do '
      'first.',
  practisePoints: [
    'ir a + infinitive for decided plans',
    'tener que for obligations in the way',
    'Time markers: mañana, la próxima semana, este verano',
  ],
  scoringCriteria: [
    'ir conjugated, main verb in infinitive',
    'tener que used naturally',
    'Days and times idiomatic',
  ],
  priorityErrors: [
    'ir a with conjugated second verb',
    'missing que after tener',
    'English word order in questions',
  ],
  mode: SpeakingMode.conversation,
  session: const SpeakingSession(
    durationMinutes: 3,
    minExchanges: 6,
    minQuestionsPerPoint: 1,
  ),
  intro: 'Checkpoint: tell your AI assistant your plans, in Spanish. '
      'Copy, speak, bring back the score.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'One sentence per plan',
      text: 'Este fin de semana voy a visitar a mis padres. Primero tengo '
          'que trabajar. Plan + obligation = a very real A2 sentence.',
    ),
  ],
);

final QuizContent enEsA22ReadMarket = enEsRead(
  id: 'en_es_a2_2_read_market',
  title: 'Reading: El mercado de La Merced',
  passageTitle: 'El mercado de La Merced',
  passage:
      'Los sábados por la mañana, Emma va al mercado de su barrio en '
      'Valencia. Es más barato que el supermercado y la fruta es mejor. '
      'Primero compra naranjas y tomates; el vendedor, don Paco, siempre '
      'le da una mandarina gratis. Después busca a su amiga Carmen, que '
      'vende flores en la esquina. «¿Vas a venir a la cena del domingo?», '
      'le pregunta Carmen. «¡Claro! Voy a llevar una tortilla», responde '
      'Emma. Tiene que practicar: la primera vez la cocinó demasiado. '
      'Esta semana va a comprar más huevos, por si acaso.',
  passageTranslation:
      'On Saturday mornings, Emma goes to her neighbourhood market in '
      'Valencia. It is cheaper than the supermarket and the fruit is '
      'better. First she buys oranges and tomatoes; the seller, don '
      'Paco, always gives her a free tangerine. Then she looks for her '
      'friend Carmen, who sells flowers on the corner. "Are you going to '
      'come to Sunday\'s dinner?" Carmen asks her. "Of course! I\'m '
      'going to bring a tortilla," Emma replies. She has to practise: '
      'the first time she overcooked it. This week she is going to buy '
      'extra eggs, just in case.',
  intro: 'A market morning that mixes the whole module: comparisons, ir '
      'a, tener que, the personal a and object pronouns.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Spot the machinery',
      text: 'más barato que, busca a su amiga, voy a llevar, tiene que '
          'practicar, la cocinó — every module rock appears once.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '¿Por qué le gusta el mercado a Emma?',
      options: [
        'Es más barato y la fruta es mejor',
        'Está más cerca',
        'Abre los domingos',
      ],
      correctIndex: 0,
      questionTranslation: 'Why does Emma like the market?',
    ),
    ReadingQuestion(
      question: '¿Qué vende Carmen?',
      options: ['Naranjas', 'Flores', 'Huevos'],
      correctIndex: 1,
      questionTranslation: 'What does Carmen sell?',
    ),
    ReadingQuestion(
      question: '¿Qué va a llevar Emma a la cena?',
      options: ['Una tortilla', 'Un pastel', 'Vino'],
      correctIndex: 0,
      questionTranslation: 'What is Emma going to bring to the dinner?',
    ),
  ],
);

final QuizContent enEsA22SpeakShopping = enEsSpeak(
  id: 'en_es_a2_2_speak_shopping',
  title: 'Speak: at the shop',
  intro: 'Shopping phrases, spoken. Repeat with confident intonation — '
      'buying things is your first real-world victory.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'quisiera opens doors',
      text: 'Quisiera un kilo de tomates — "I would like" — is polite '
          'everywhere in the Spanish-speaking world.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'How much does it cost?', answer: '¿Cuánto cuesta?'),
    CourseItem(prompt: 'I would like a kilo of tomatoes.', answer: 'Quisiera un kilo de tomates.'),
    CourseItem(prompt: 'Anything else? — Nothing else, thanks.', answer: '¿Algo más? — Nada más, gracias.'),
    CourseItem(prompt: 'Can I pay by card?', answer: '¿Puedo pagar con tarjeta?'),
    CourseItem(prompt: 'It\'s very expensive!', answer: '¡Es muy caro!'),
    CourseItem(prompt: 'Do you have it in blue?', answer: '¿Lo tiene en azul?'),
    CourseItem(prompt: 'I\'m just looking, thanks.', answer: 'Solo estoy mirando, gracias.'),
    CourseItem(prompt: 'Here you are. — Thank you!', answer: 'Aquí tiene. — ¡Gracias!'),
  ],
);

final QuizContent enEsA22Dict = enEsDict(
  id: 'en_es_a2_2_dict',
  title: 'Dictation: plans and city',
  intro: 'Listen and type: ir a, tener que, pronouns and comparisons.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: 'Little words first',
      text: 'lo, la, a, que — the tiny words carry the grammar. If a '
          'syllable seems missing, it was probably a clitic pronoun.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'I am going to buy a house.', answer: 'Voy a comprar una casa.'),
    CourseItem(prompt: 'We have to clean the kitchen.', answer: 'Tenemos que limpiar la cocina.'),
    CourseItem(prompt: 'My brother is taller than me.', answer: 'Mi hermano es más alto que yo.'),
    CourseItem(prompt: 'I see her every day.', answer: 'La veo todos los días.'),
    CourseItem(prompt: 'It is the best café in the city.', answer: 'Es el mejor café de la ciudad.'),
    CourseItem(prompt: 'Are you going to come tomorrow?', answer: '¿Vas a venir mañana?'),
    CourseItem(prompt: 'I am looking for my friend Carmen.', answer: 'Busco a mi amiga Carmen.'),
    CourseItem(prompt: 'One has to practise every day.', answer: 'Hay que practicar todos los días.'),
    CourseItem(prompt: 'I want to see it tonight.', answer: 'Quiero verla esta noche.'),
    CourseItem(prompt: 'The train is faster than the bus.', answer: 'El tren es más rápido que el autobús.'),
    CourseItem(prompt: 'It is going to rain this afternoon.', answer: 'Va a llover esta tarde.'),
    CourseItem(prompt: 'I have to call my mother.', answer: 'Tengo que llamar a mi madre.'),
    CourseItem(prompt: 'Turn left at the traffic lights.', answer: 'Gire a la izquierda en el semáforo.'),
    CourseItem(prompt: 'I don\'t know him.', answer: 'No lo conozco.'),
    CourseItem(prompt: 'This street is quieter than mine.', answer: 'Esta calle es más tranquila que la mía.'),
  ],
);

final QuizContent enEsA22BigText = enEsBigText(
  id: 'en_es_a2_2_bigtext',
  title: 'Big text: El plan del sábado',
  passageTitle: 'El plan del sábado',
  intro: 'Complete the plan: ir a, tener que, object pronouns, personal '
      'a and a comparison.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'The whole module in one plan',
      text: 'Every gap is a module rock: check whether the object is a '
          'person (→ a) and where the pronoun goes.',
    ),
  ],
  template:
      'Este sábado {{0}} a hacer muchas cosas. Por la mañana tengo {{1}} '
      'limpiar el apartamento. Después voy a visitar {{2}} mi abuela — '
      '{{3}} llamo todos los días, pero quiero verla en persona. Vamos a '
      'comer en su restaurante favorito, que es {{4}} barato que el '
      'centro. Por la tarde, mi amigo Nico y yo {{5}} a ver un partido. '
      'A Nico no {{6}} gusta el fútbol, pero viene igual. Después hay '
      '{{7}} comprar un regalo para Carmen: es su cumpleaños y vamos a '
      '{{8}} una fiesta sorpresa. ¡No se {{9}} puedes decir!',
  blanks: [
    inputBlank('voy'),
    inputBlank('que'),
    inputBlank('a'),
    inputBlank('la'),
    inputBlank('más'),
    inputBlank('vamos'),
    inputBlank('le'),
    inputBlank('que'),
    inputBlank('hacerle', accepted: ['organizarle', 'darle', 'hacer']),
    inputBlank('lo'),
  ],
  passageTranslation:
      'This Saturday I am going to do a lot of things. In the morning I '
      'have to clean the flat. Then I am going to visit my grandmother — '
      'I call her every day, but I want to see her in person. We are '
      'going to eat at her favourite restaurant, which is cheaper than '
      'the centre. In the afternoon, my friend Nico and I are going to '
      'watch a match. Nico doesn\'t like football, but he comes anyway. '
      'Afterwards one has to buy a present for Carmen: it\'s her '
      'birthday and we are going to throw her a surprise party. You '
      'can\'t tell her!',
);

final QuizContent enEsA22SpeakingClose = enEsSpeaking(
  id: 'en_es_a2_2_speaking_close',
  title: 'Final conversation: my future',
  level: 'A2.2',
  topic: 'An interview in Spanish about your plans and your city: what '
      'you are going to do next year, what you have to do first, and '
      'comparisons between your city and one you love.',
  practisePoints: [
    'ir a + infinitive across persons',
    'tener que / hay que obligations',
    'Comparisons: más…que, mejor, tan…como',
    'Object pronouns and the personal a in natural sentences',
  ],
  scoringCriteria: [
    'Future and obligation structures correct',
    'Comparatives without English calques',
    'Pronouns placed before the verb',
  ],
  targetVocabulary: [
    'voy a', 'tengo que', 'más … que', 'mejor', 'lo/la',
  ],
  priorityErrors: [
    '"más mejor"',
    'pronouns after the conjugated verb',
    'missing personal a',
  ],
  mode: SpeakingMode.interview,
  intro: 'Module A2.2 closer — the end of the A levels. Your plans and '
      'your city, in Spanish. Copy, speak, bring back your score.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Compare your cities',
      text: 'Mi ciudad es más pequeña que…, pero la comida es mejor. '
          'Comparing places is the most natural way to shine here.',
    ),
  ],
);

/// A2.2 in chain order.
final List<QuizContent> enEsA2_2 = [
  enEsA22IrA,
  enEsA22TenerQue,
  enEsA22ObjectPronouns,
  enEsA22PersonalA,
  enEsA22Comparisons,
  enEsA22Town,
  enEsA22ListenDirections,
  enEsA22SpeakingMid,
  enEsA22ReadMarket,
  enEsA22SpeakShopping,
  enEsA22Dict,
  enEsA22BigText,
  enEsA22SpeakingClose,
];
