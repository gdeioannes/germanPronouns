import '../../../models/quiz_content.dart';
import 'es_en_builder.dart';

/// A2.2 — Planes y comparaciones. Spanish → English.
///
/// Big rocks: going to / will for the future, the present continuous and its
/// contrast with the simple (⚑S15 — Spanish presente covers both), the
/// comparative/superlative machinery, and countable vs uncountable with
/// some/any/much/many (⚑S18).

final QuizContent esEnA22Continuous = esEnFill(
  id: 'es_en_a2_2_continuous',
  title: 'El presente continuo: be + -ing',
  intro: 'Lo que pasa AHORA va con be + -ing: I am working = estoy '
      'trabajando. El inglés separa "trabajo" y "estoy trabajando" con más '
      'rigor que el español.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚑S15 Ahora = continuo',
      text: '"Vivo en Madrid" (siempre) → I live in Madrid. "Ahora vivo con '
          'mi tía" (temporal) → I am living with my aunt. El presente simple '
          'inglés NO sirve para el ahora.',
    ),
    HelpMemoryTip(
      kind: 'rule',
      title: 'Ortografía del -ing',
      text: 'make→making (cae la e), run→running (dobla), study→studying (la '
          'y se queda).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Estoy trabajando ahora.', answer: 'I am **working** now.'),
    CourseItem(prompt: 'Ella está cocinando.', answer: 'She is **cooking**.'),
    CourseItem(prompt: 'Están viendo la tele.', answer: 'They are **watching** TV.'),
    CourseItem(prompt: 'Está lloviendo.', answer: 'It is **raining**.'),
    CourseItem(prompt: 'Estamos aprendiendo inglés.', answer: 'We are **learning** English.'),
    CourseItem(prompt: 'Él está corriendo en el parque.', answer: 'He is **running** in the park.'),
    CourseItem(prompt: '¿Qué estás haciendo?', answer: 'What are you **doing**?'),
    CourseItem(prompt: 'El bebé está durmiendo.', answer: 'The baby is **sleeping**.'),
    CourseItem(prompt: 'Estoy leyendo un buen libro.', answer: 'I am **reading** a good book.'),
    CourseItem(prompt: 'Ella está escribiendo un correo.', answer: 'She is **writing** an email.'),
    CourseItem(prompt: 'No estoy escuchando música.', answer: 'I am not **listening** to music.'),
    CourseItem(prompt: '¿Está él estudiando?', answer: 'Is he **studying**?'),
    CourseItem(prompt: 'Los niños están jugando fuera.', answer: 'The children are **playing** outside.'),
    CourseItem(prompt: 'Estamos esperando el autobús.', answer: 'We are **waiting** for the bus.'),
    CourseItem(prompt: 'Ella está haciendo la cena. (make)', answer: 'She is **making** dinner.'),
  ],
);

final QuizContent esEnA22SimpleVsCont = esEnFill(
  id: 'es_en_a2_2_simple_vs_cont',
  title: 'Simple o continuo: ¿hábito o ahora?',
  intro: 'Hábito o verdad general → presente simple. Ahora mismo o temporal '
      '→ continuo. Elige en cada frase.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚑S15 Las pistas',
      text: 'usually, every day, on Mondays → simple. now, at the moment, '
          'today, Look! → continuo.',
    ),
    HelpMemoryTip(
      kind: 'rule',
      title: 'Verbos sin continuo',
      text: 'want, like, know, need casi nunca van en -ing: I want ✓, '
          '"I am wanting" ✗.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Normalmente bebo café. (drink)', answer: 'I usually **drink** coffee.'),
    CourseItem(prompt: 'Hoy estoy bebiendo té.', answer: 'Today I am **drinking** tea.'),
    CourseItem(prompt: 'Ella trabaja todos los días. (work)', answer: 'She **works** every day.'),
    CourseItem(prompt: 'Ahora mismo ella está trabajando.', answer: 'Right now she is **working**.'),
    CourseItem(prompt: '¡Mira! Está nevando. (snow)', answer: 'Look! It is **snowing**.'),
    CourseItem(prompt: 'Llueve mucho en invierno. (rain)', answer: 'It **rains** a lot in winter.'),
    CourseItem(prompt: 'Quiero un helado. (want)', answer: 'I **want** an ice cream.'),
    CourseItem(prompt: 'Los lunes juego al fútbol. (play)', answer: 'On Mondays I **play** football.'),
    CourseItem(prompt: 'Este mes estoy viviendo con mi tía.', answer: 'This month I am **living** with my aunt.'),
    CourseItem(prompt: 'Él sabe la respuesta. (know)', answer: 'He **knows** the answer.'),
    CourseItem(prompt: 'Silencio, el bebé está durmiendo.', answer: 'Quiet, the baby is **sleeping**.'),
    CourseItem(prompt: 'Mi padre cocina los domingos. (cook)', answer: 'My father **cooks** on Sundays.'),
    CourseItem(prompt: 'Hoy papá está cocinando pasta.', answer: 'Today dad is **cooking** pasta.'),
    CourseItem(prompt: 'Necesito ayuda. (need)', answer: 'I **need** help.'),
    CourseItem(prompt: 'En este momento estamos estudiando.', answer: 'At the moment we are **studying**.'),
  ],
);

final QuizContent esEnA22SpeakNow = esEnSpeak(
  id: 'es_en_a2_2_speak_now',
  title: 'A hablar: ¿qué está pasando?',
  intro: 'Describe lo que pasa a tu alrededor. Repite marcando el -ing final '
      'con su g suave.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚑S6 El -ing es /ŋ/',
      text: 'working termina en el sonido de "tengo" sin la g: /ŋ/. Ni '
          '"workin" ni "workin-G" con g dura.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Estoy hablando por teléfono.', answer: "I'm talking on the phone."),
    CourseItem(prompt: 'Ella está tomando un café.', answer: "She's having a coffee."),
    CourseItem(prompt: 'Están esperando el tren.', answer: "They're waiting for the train."),
    CourseItem(prompt: 'Está saliendo el sol.', answer: 'The sun is coming out.'),
    CourseItem(prompt: '¿Qué estás cocinando?', answer: 'What are you cooking?'),
    CourseItem(prompt: 'Estamos llegando ahora.', answer: "We're arriving now."),
    CourseItem(prompt: 'El niño está llorando.', answer: 'The child is crying.'),
    CourseItem(prompt: 'Me estoy preparando.', answer: "I'm getting ready."),
  ],
);

final QuizContent esEnA22GoingTo = esEnFill(
  id: 'es_en_a2_2_going_to',
  title: 'Planes: going to',
  intro: 'Para planes ya decididos: be going to + verbo. Es tu "voy a…" '
      'calcado — esta vez el español te ayuda.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'be + going to + verbo base',
      text: "I'm going to travel · She's going to study. No olvides el be: "
          '"I going to" ✗.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Voy a viajar a Perú.', answer: 'I am **going** to travel to Peru.'),
    CourseItem(prompt: 'Ella va a estudiar medicina.', answer: 'She is going to **study** medicine.'),
    CourseItem(prompt: 'Vamos a comprar una casa.', answer: 'We are going to **buy** a house.'),
    CourseItem(prompt: 'Va a llover.', answer: 'It is going to **rain**.'),
    CourseItem(prompt: 'Ellos van a vender el coche.', answer: 'They are going to **sell** the car.'),
    CourseItem(prompt: '¿Qué vas a hacer mañana?', answer: 'What are you going to **do** tomorrow?'),
    CourseItem(prompt: 'Él va a cocinar esta noche.', answer: 'He is going to **cook** tonight.'),
    CourseItem(prompt: 'No voy a trabajar el sábado.', answer: 'I am not going to **work** on Saturday.'),
    CourseItem(prompt: 'Voy a aprender a conducir.', answer: 'I am going to **learn** to drive.'),
    CourseItem(prompt: 'Ella va a visitar a sus abuelos.', answer: 'She is going to **visit** her grandparents.'),
    CourseItem(prompt: '¿Vais a venir a la fiesta?', answer: 'Are you going to **come** to the party?'),
    CourseItem(prompt: 'Van a abrir un restaurante.', answer: 'They are going to **open** a restaurant.'),
    CourseItem(prompt: 'Me voy a levantar temprano.', answer: 'I am going to **get** up early.'),
    CourseItem(prompt: 'Vamos a ver una película.', answer: 'We are going to **watch** a film.'),
    CourseItem(prompt: 'Él no va a jugar hoy.', answer: 'He is not going to **play** today.'),
  ],
);

final QuizContent esEnA22Will = esEnFill(
  id: 'es_en_a2_2_will',
  title: 'Futuro con will',
  intro: 'Decisiones del momento, promesas y predicciones: will + verbo. '
      '"I\'ll help you" — lo decides mientras hablas.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'will vs going to',
      text: 'Plan decidido antes → going to. Decisión espontánea, promesa o '
          'predicción → will. "Te ayudo" (ahora) = I\'ll help you.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Te ayudaré.', answer: 'I **will** help you.'),
    CourseItem(prompt: 'Mañana hará sol. (be sunny)', answer: 'It **will** be sunny tomorrow.'),
    CourseItem(prompt: 'Yo abro la puerta. (decisión ahora)', answer: 'I **will** open the door.'),
    CourseItem(prompt: 'Ella vendrá más tarde.', answer: 'She **will** come later.'),
    CourseItem(prompt: 'No lo olvidaré.', answer: 'I **won\'t** forget it.'),
    CourseItem(prompt: '¿Estarás en casa esta noche?', answer: '**Will** you be at home tonight?'),
    CourseItem(prompt: 'Te llamo luego. (call)', answer: 'I **will** call you later.'),
    CourseItem(prompt: 'Creo que ganarán.', answer: 'I think they **will** win.'),
    CourseItem(prompt: 'No lloverá este fin de semana.', answer: 'It **won\'t** rain this weekend.'),
    CourseItem(prompt: 'Algún día seré médico.', answer: 'One day I **will** be a doctor.'),
    CourseItem(prompt: 'Yo llevo las bolsas. (carry)', answer: 'I **will** carry the bags.'),
    CourseItem(prompt: 'El tren llegará pronto.', answer: 'The train **will** arrive soon.'),
    CourseItem(prompt: 'Te lo prometo: estaré allí.', answer: 'I promise: I **will** be there.'),
    CourseItem(prompt: '¿Me ayudarás con esto?', answer: '**Will** you help me with this?'),
    CourseItem(prompt: 'No se lo diré a nadie. (tell)', answer: 'I **won\'t** tell anyone.'),
  ],
);

final QuizContent esEnA22Town = esEnVocab(
  id: 'es_en_a2_2_town',
  title: 'La ciudad · Around town',
  intro: 'Lugares de la ciudad y cómo moverte.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚑S25 Falso amigo: library',
      text: 'library = biblioteca. La librería (tienda) es bookshop. Uno de '
          'los falsos amigos más traicioneros.',
    ),
  ],
  pairs: const [
    MapEntry('biblioteca', 'library'),
    MapEntry('librería (tienda)', 'bookshop'),
    MapEntry('ayuntamiento', 'town hall'),
    MapEntry('estación de tren', 'train station'),
    MapEntry('farmacia', 'chemist\'s'),
    MapEntry('supermercado', 'supermarket'),
    MapEntry('iglesia', 'church'),
    MapEntry('puente', 'bridge'),
    MapEntry('plaza', 'square'),
    MapEntry('esquina', 'corner'),
    MapEntry('semáforo', 'traffic lights'),
    MapEntry('parada de autobús', 'bus stop'),
  ],
);

final QuizContent esEnA22ListenDirections = esEnListen(
  id: 'es_en_a2_2_listen_directions',
  title: 'Escucha: How do I get there?',
  passageTitle: 'Directions to the museum',
  passage:
      "Excuse me, how do I get to the museum? — It's easy. Go straight on "
      "for two streets, then turn left at the traffic lights. The museum is "
      "on the right, next to the library. — Is it far? — No, about ten "
      "minutes on foot. — Thank you very much! — You're welcome.",
  passageTranslation:
      'Disculpe, ¿cómo llego al museo? — Es fácil. Siga recto dos calles y '
      'gire a la izquierda en el semáforo. El museo está a la derecha, al '
      'lado de la biblioteca. — ¿Está lejos? — No, unos diez minutos a pie. '
      '— ¡Muchas gracias! — De nada.',
  intro: 'Indicaciones por la calle. Escucha izquierda, derecha y recto.',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'El kit de direcciones',
      text: 'go straight on (recto), turn left/right (gira), on the '
          'left/right (a mano…), next to (al lado de).',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'Where do they turn left?',
      options: ['At the bridge', 'At the traffic lights', 'At the square'],
      correctIndex: 1,
      questionTranslation: '¿Dónde giran a la izquierda?',
    ),
    ReadingQuestion(
      question: 'What is the museum next to?',
      options: ['The library', 'The station', 'The church'],
      correctIndex: 0,
      questionTranslation: '¿Al lado de qué está el museo?',
    ),
    ReadingQuestion(
      question: 'How far is it on foot?',
      options: ['Five minutes', 'Ten minutes', 'Twenty minutes'],
      correctIndex: 1,
      questionTranslation: '¿A cuánto está a pie?',
    ),
  ],
);

final QuizContent esEnA22Comparatives = esEnFill(
  id: 'es_en_a2_2_comparatives',
  title: 'Comparar: -er que, more… than',
  intro: 'Adjetivo corto + -er (taller than); adjetivo largo con more (more '
      'expensive than). Irregulares: good→better, bad→worse.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Corto o largo',
      text: '1 sílaba → -er (older). 3+ sílabas → more (more interesting). '
          '2 sílabas en -y → -ier (happier).',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: 'Nunca dobles',
      text: '"more taller" ✗ — o -er o more, jamás los dos.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Él es más alto que yo.', answer: 'He is **taller** than me.'),
    CourseItem(prompt: 'Este libro es más interesante que ese.', answer: 'This book is **more interesting** than that one.'),
    CourseItem(prompt: 'Mi coche es más viejo que el tuyo.', answer: 'My car is **older** than yours.'),
    CourseItem(prompt: 'El café aquí es mejor.', answer: 'The coffee here is **better**.'),
    CourseItem(prompt: 'El tiempo hoy es peor.', answer: 'The weather today is **worse**.'),
    CourseItem(prompt: 'Ella es más feliz ahora. (happy)', answer: 'She is **happier** now.'),
    CourseItem(prompt: 'Londres es más caro que Madrid.', answer: 'London is **more expensive** than Madrid.'),
    CourseItem(prompt: 'Este ejercicio es más fácil. (easy)', answer: 'This exercise is **easier**.'),
    CourseItem(prompt: 'Mi hermano es más joven que yo.', answer: 'My brother is **younger** than me.'),
    CourseItem(prompt: 'El tren es más rápido que el bus.', answer: 'The train is **faster** than the bus.'),
    CourseItem(prompt: 'Esta calle es más ruidosa. (noisy)', answer: 'This street is **noisier**.'),
    CourseItem(prompt: 'El examen fue más difícil.', answer: 'The exam was **more difficult**.'),
    CourseItem(prompt: 'Hoy hace más frío. (cold)', answer: 'Today it is **colder**.'),
    CourseItem(prompt: 'Mi mochila es más grande. (big)', answer: 'My bag is **bigger**.'),
    CourseItem(prompt: 'Esta película es más aburrida. (boring)', answer: 'This film is **more boring**.'),
  ],
);

final QuizContent esEnA22SpeakingMid = esEnSpeaking(
  id: 'es_en_a2_2_speaking_mid',
  title: 'Conversación: mis planes',
  level: 'A2.2',
  topic: 'A chat about my plans: what I am doing this week, what I am going '
      'to do next weekend, and my plans for the summer.',
  practisePoints: [
    'Present continuous for what is happening now / this week',
    'going to for decided plans',
    'will for spontaneous promises and predictions',
  ],
  scoringCriteria: [
    'be + -ing formed correctly',
    'going to vs will chosen sensibly',
    'Time expressions: tomorrow, next week, this summer',
  ],
  priorityErrors: [
    'present simple used for right-now actions',
    'missing be before going to',
    'dropped subject pronouns',
  ],
  mode: SpeakingMode.conversation,
  session: const SpeakingSession(
    durationMinutes: 3,
    minExchanges: 6,
    minQuestionsPerPoint: 1,
  ),
  intro: 'Punto de control: cuéntale tus planes a tu asistente de IA y trae '
      'la puntuación.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Una frase por plan',
      text: "This weekend I'm going to visit my parents. Next month I'm "
          'going to start a course. Plan + going to, sin miedo.',
    ),
  ],
);

final QuizContent esEnA22Superlatives = esEnFill(
  id: 'es_en_a2_2_superlatives',
  title: 'El superlativo: the -est',
  intro: 'El más… = the + -est (cortos) o the most… (largos): the tallest, '
      'the most expensive.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Siempre con the',
      text: 'the best, the biggest, the most famous — el superlativo lleva '
          'su the delante.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Es el edificio más alto de la ciudad.', answer: 'It is the **tallest** building in the city.'),
    CourseItem(prompt: 'Es el mejor restaurante.', answer: 'It is the **best** restaurant.'),
    CourseItem(prompt: 'Fue el peor día del año.', answer: 'It was the **worst** day of the year.'),
    CourseItem(prompt: 'Es la ciudad más cara.', answer: 'It is the **most expensive** city.'),
    CourseItem(prompt: 'Ella es la más joven de la familia.', answer: 'She is the **youngest** in the family.'),
    CourseItem(prompt: 'Es el río más largo del mundo.', answer: 'It is the **longest** river in the world.'),
    CourseItem(prompt: 'Es la película más famosa.', answer: 'It is the **most famous** film.'),
    CourseItem(prompt: 'Este es el ejercicio más fácil.', answer: 'This is the **easiest** exercise.'),
    CourseItem(prompt: 'Es el hombre más rico del país.', answer: 'He is the **richest** man in the country.'),
    CourseItem(prompt: 'Fue el viaje más interesante.', answer: 'It was the **most interesting** trip.'),
    CourseItem(prompt: 'Es el día más feliz de mi vida.', answer: 'It is the **happiest** day of my life.'),
    CourseItem(prompt: 'Es la habitación más grande.', answer: 'It is the **biggest** room.'),
    CourseItem(prompt: 'Enero es el mes más frío.', answer: 'January is the **coldest** month.'),
    CourseItem(prompt: 'Es la pregunta más difícil.', answer: 'It is the **most difficult** question.'),
    CourseItem(prompt: 'Este es el camino más corto.', answer: 'This is the **shortest** way.'),
  ],
);

final QuizContent esEnA22SomeAny = esEnFill(
  id: 'es_en_a2_2_some_any',
  title: 'some / any, much / many',
  intro: 'some en afirmativas, any en preguntas y negativas. much con '
      'incontables, many con contables (⚑S18).',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚑S18 Incontables sin plural',
      text: 'money, water, bread, advice, news no llevan -s ni "a": some '
          'money, not "a money" ni "moneys".',
    ),
    HelpMemoryTip(
      kind: 'rule',
      title: 'much / many',
      text: 'How much water? (incontable) · How many books? (contable). much '
          'dinero, many libros.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Hay algo de leche.', answer: 'There is **some** milk.'),
    CourseItem(prompt: '¿Hay leche?', answer: 'Is there **any** milk?'),
    CourseItem(prompt: 'No hay huevos.', answer: 'There aren\'t **any** eggs.'),
    CourseItem(prompt: 'Necesito algo de dinero.', answer: 'I need **some** money.'),
    CourseItem(prompt: '¿Cuánta agua bebes?', answer: 'How **much** water do you drink?'),
    CourseItem(prompt: '¿Cuántos libros tienes?', answer: 'How **many** books do you have?'),
    CourseItem(prompt: 'No tengo mucho tiempo.', answer: 'I don\'t have **much** time.'),
    CourseItem(prompt: 'Hay muchas sillas.', answer: 'There are **many** chairs.'),
    CourseItem(prompt: 'Compra algo de pan.', answer: 'Buy **some** bread.'),
    CourseItem(prompt: '¿Tienes hermanos? (any)', answer: 'Do you have **any** brothers?'),
    CourseItem(prompt: 'No hay mucho café.', answer: 'There isn\'t **much** coffee.'),
    CourseItem(prompt: '¿Cuánta gente había? (many)', answer: 'How **many** people were there?'),
    CourseItem(prompt: 'Tengo algunas preguntas.', answer: 'I have **some** questions.'),
    CourseItem(prompt: 'No quiero azúcar. (any)', answer: 'I don\'t want **any** sugar.'),
    CourseItem(prompt: 'Ella tiene muchos amigos.', answer: 'She has **many** friends.'),
  ],
);

final QuizContent esEnA22ReadCity = esEnRead(
  id: 'es_en_a2_2_read_city',
  title: 'Lectura: Two cities',
  passageTitle: 'Manchester or Brighton?',
  passage:
      "Mateo is going to move next month, but where? Manchester is bigger "
      "and cheaper than Brighton, and there are more jobs there. But "
      "Brighton is sunnier and it is next to the sea. \"Manchester has the "
      "best music in the country,\" says his friend Tom. \"But Brighton is "
      "the most beautiful town in the south,\" says Emma. Mateo isn't sure "
      "yet. He is going to visit both cities in May, and then he will "
      "decide.",
  passageTranslation:
      'Mateo se va a mudar el mes que viene, pero ¿adónde? Manchester es más '
      'grande y más barata que Brighton, y hay más trabajo allí. Pero '
      'Brighton es más soleada y está junto al mar. «Manchester tiene la '
      'mejor música del país», dice su amigo Tom. «Pero Brighton es la '
      'ciudad más bonita del sur», dice Emma. Mateo aún no está seguro. Va a '
      'visitar las dos ciudades en mayo y entonces decidirá.',
  intro: 'Comparaciones y planes en un mismo texto: bigger, the best, going '
      'to y will trabajando juntos.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Observa la decisión',
      text: 'Plan hecho → is going to visit. Decisión futura aún abierta → '
          'he will decide. El texto muestra la diferencia exacta.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'Which city is cheaper?',
      options: ['Brighton', 'Manchester', 'Neither'],
      correctIndex: 1,
      questionTranslation: '¿Qué ciudad es más barata?',
    ),
    ReadingQuestion(
      question: 'Why does Emma prefer Brighton?',
      options: [
        'It has more jobs',
        'It is the most beautiful town in the south',
        'It has the best music',
      ],
      correctIndex: 1,
      questionTranslation: '¿Por qué prefiere Emma Brighton?',
    ),
    ReadingQuestion(
      question: 'What is Mateo going to do in May?',
      options: ['Move to Manchester', 'Visit both cities', 'Buy a house'],
      correctIndex: 1,
      questionTranslation: '¿Qué va a hacer Mateo en mayo?',
    ),
  ],
);

final QuizContent esEnA22Clothes = esEnVocab(
  id: 'es_en_a2_2_clothes',
  title: 'Ropa y compras · Clothes',
  intro: 'Ropa básica y palabras de tienda.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: 'trousers siempre en plural',
      text: 'trousers, jeans, shorts van en plural: these trousers ARE nice. '
          'Y en EE. UU. trousers = pants (⚑S29).',
    ),
  ],
  pairs: const [
    MapEntry('camisa', 'shirt'),
    MapEntry('camiseta', 'T-shirt'),
    MapEntry('pantalones', 'trousers'),
    MapEntry('falda', 'skirt'),
    MapEntry('vestido', 'dress'),
    MapEntry('zapatos', 'shoes'),
    MapEntry('abrigo', 'coat'),
    MapEntry('talla', 'size'),
    MapEntry('caro', 'expensive'),
    MapEntry('barato', 'cheap'),
    MapEntry('probador', 'fitting room'),
    MapEntry('rebajas', 'sales'),
  ],
);

final QuizContent esEnA22Dict = esEnDict(
  id: 'es_en_a2_2_dict',
  title: 'Dictado: planes y comparaciones',
  intro: 'Escucha y escribe. Atento a going to (suena "gonna" relajado, '
      'escríbelo entero) y a los -er/-est.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚑S10 Escribe la forma completa',
      text: 'Oirás "gonna" y "I\'ll": escribe going to y I will (o I\'ll). '
          'El inglés relajado se escribe formal.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Voy a comprar una casa.', answer: 'I am going to buy a house.'),
    CourseItem(prompt: 'Está lloviendo ahora.', answer: 'It is raining now.'),
    CourseItem(prompt: 'Mi hermano es más alto que yo.', answer: 'My brother is taller than me.'),
    CourseItem(prompt: 'Te ayudaré mañana.', answer: 'I will help you tomorrow.'),
    CourseItem(prompt: 'Es el mejor café de la ciudad.', answer: 'It is the best coffee in the city.'),
    CourseItem(prompt: '¿Hay pan?', answer: 'Is there any bread?'),
    CourseItem(prompt: 'Ella está esperando el autobús.', answer: 'She is waiting for the bus.'),
    CourseItem(prompt: 'Vamos a visitar a mis padres.', answer: 'We are going to visit my parents.'),
    CourseItem(prompt: 'Este hotel es más caro.', answer: 'This hotel is more expensive.'),
    CourseItem(prompt: 'No tengo mucho tiempo.', answer: 'I do not have much time.'),
    CourseItem(prompt: '¿Qué estás haciendo?', answer: 'What are you doing?'),
    CourseItem(prompt: 'El tren llegará pronto.', answer: 'The train will arrive soon.'),
    CourseItem(prompt: 'Necesito algo de dinero.', answer: 'I need some money.'),
    CourseItem(prompt: 'Es la ciudad más bonita del sur.', answer: 'It is the most beautiful town in the south.'),
    CourseItem(prompt: 'Los niños están jugando fuera.', answer: 'The children are playing outside.'),
  ],
);

final QuizContent esEnA22BigText = esEnBigText(
  id: 'es_en_a2_2_bigtext',
  title: 'Texto: Moving day plans',
  passageTitle: 'Moving day plans',
  intro: 'Completa el texto: continuo, going to, will, comparativos y '
      'some/any.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Todo el módulo en un texto',
      text: 'Pregúntate en cada hueco: ¿pasa ahora (-ing)? ¿plan (going '
          'to)? ¿promesa (will)? ¿comparación (-er/most)?',
    ),
  ],
  template:
      'Mateo is {{0}} his boxes right now because he is {{1}} to move to '
      'Manchester next week. His new flat is {{2}} than his old one, and '
      'the rent is cheaper. "I {{3}} visit you in the summer," says Emma. '
      '"Great! It is the {{4}} city for music in the country," Mateo says. '
      'He still needs {{5}} boxes for his books — he has too {{6}} of '
      'them. Tomorrow his friends {{7}} help him with the van, and then '
      'they are going to {{8}} pizza together. "Don\'t worry," says Tom, '
      '"moving day {{9}} be fun."',
  blanks: [
    inputBlank('packing'),
    inputBlank('going'),
    inputBlank('bigger'),
    inputBlank('will', accepted: ["'ll"]),
    inputBlank('best'),
    inputBlank('some'),
    inputBlank('many'),
    inputBlank('will'),
    inputBlank('eat', accepted: ['have', 'order']),
    inputBlank('will'),
  ],
  passageTranslation:
      'Mateo está embalando sus cajas ahora mismo porque se va a mudar a '
      'Manchester la semana que viene. Su piso nuevo es más grande que el '
      'viejo, y el alquiler es más barato. «Te visitaré en verano», dice '
      'Emma. «¡Genial! Es la mejor ciudad del país para la música», dice '
      'Mateo. Aún necesita algunas cajas para sus libros: tiene demasiados. '
      'Mañana sus amigos le ayudarán con la furgoneta y después van a comer '
      'pizza juntos. «Tranquilo», dice Tom, «el día de la mudanza será '
      'divertido».',
);

final QuizContent esEnA22SpeakingClose = esEnSpeaking(
  id: 'es_en_a2_2_speaking_close',
  title: 'Conversación final: mi futuro',
  level: 'A2.2',
  topic: 'An interview about my life now and my future: what I am doing '
      'these days, my plans for next year, and comparisons between my city '
      'and another city I like.',
  practisePoints: [
    'Present continuous for these days',
    'going to and will for plans and promises',
    'Comparatives and superlatives about places',
    'some/any with shopping and food',
  ],
  scoringCriteria: [
    'The three futures used sensibly',
    'Comparative forms correct (no "more better")',
    'Continuous formed with be + -ing',
  ],
  targetVocabulary: [
    'going to', 'bigger', 'the best', 'expensive', 'move', 'plan',
  ],
  priorityErrors: [
    'present simple for right-now actions',
    'double comparatives',
    'missing be in continuous or going to',
  ],
  mode: SpeakingMode.interview,
  intro: 'Cierre del módulo A2.2 — y del nivel A. Una entrevista sobre tu '
      'presente y tu futuro. Copia, habla y trae tu puntuación.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Compara tu ciudad',
      text: 'My city is smaller than…, but the food is better. Comparar '
          'lugares es la manera más natural de lucir este módulo.',
    ),
  ],
);

/// A2.2 in chain order.
final List<QuizContent> esEnA2_2 = [
  esEnA22Continuous,
  esEnA22SimpleVsCont,
  esEnA22SpeakNow,
  esEnA22GoingTo,
  esEnA22Will,
  esEnA22Town,
  esEnA22ListenDirections,
  esEnA22Comparatives,
  esEnA22SpeakingMid,
  esEnA22Superlatives,
  esEnA22SomeAny,
  esEnA22ReadCity,
  esEnA22Clothes,
  esEnA22Dict,
  esEnA22BigText,
  esEnA22SpeakingClose,
];
