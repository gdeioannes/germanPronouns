import '../../../models/quiz_content.dart';
import 'es_en_builder.dart';

/// A1.1 — Primer contacto. Spanish → English.
///
/// Big rocks: the verb `be` and mandatory subject pronouns (⚑S11 — Spanish
/// drops them), `a/an` before jobs (⚑S16), fixed question order (⚑S26), and
/// the first sounds Spanish lacks: long/short vowels (⚑S1), no e- before
/// s+consonant (⚑S2), th (⚑S5).

final QuizContent esEnA11Numbers = esEnVocab(
  id: 'es_en_a1_1_numbers',
  title: 'Números 0–20 · Numbers',
  intro: 'Los números del 0 al 20 son la base de todos los demás. Apréndelos primero.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: 'Ortografía difícil',
      text: 'Los que más se fallan: four / fourteen (llevan u), eight, twelve, '
          'thirteen y fifteen (no es "five-teen").',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Pronunciación',
      text: 'three lleva el sonido th (⚑S5): lengua entre los dientes, no "tri" ni "free".',
    ),
  ],
  pairs: const [
    MapEntry('0', 'zero'),
    MapEntry('1', 'one'),
    MapEntry('2', 'two'),
    MapEntry('3', 'three'),
    MapEntry('4', 'four'),
    MapEntry('5', 'five'),
    MapEntry('6', 'six'),
    MapEntry('7', 'seven'),
    MapEntry('8', 'eight'),
    MapEntry('9', 'nine'),
    MapEntry('10', 'ten'),
    MapEntry('11', 'eleven'),
    MapEntry('12', 'twelve'),
    MapEntry('13', 'thirteen'),
    MapEntry('14', 'fourteen'),
    MapEntry('15', 'fifteen'),
    MapEntry('16', 'sixteen'),
    MapEntry('17', 'seventeen'),
    MapEntry('18', 'eighteen'),
    MapEntry('19', 'nineteen'),
    MapEntry('20', 'twenty'),
  ],
);

final QuizContent esEnA11Alphabet = esEnSpeak(
  id: 'es_en_a1_1_alphabet',
  title: 'El alfabeto y las vocales',
  intro: 'Las letras son casi las mismas que en español, pero sus nombres — y '
      'sobre todo las vocales — suenan muy distinto. Escucha y repite.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚑S1 Las vocales no son las tuyas',
      text: 'En inglés a≈/eɪ/, e≈/iː/, i≈/aɪ/. No leas con las vocales del '
          'español: "name" no es "na-me".',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: '⚑S2 Sin e- de apoyo',
      text: 'school, Spain, student empiezan con s + consonante, SIN vocal '
          'delante: "sku:l", nunca "eschool".',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Letras A–G', answer: 'A, B, C, D, E, F, G'),
    CourseItem(prompt: 'Letras H–N', answer: 'H, I, J, K, L, M, N'),
    CourseItem(prompt: 'Letras O–T', answer: 'O, P, Q, R, S, T'),
    CourseItem(prompt: 'Letras U–Z', answer: 'U, V, W, X, Y, Z'),
    CourseItem(prompt: 'Deletrear: hello', answer: 'H-E-L-L-O, hello'),
    CourseItem(prompt: 's + consonante, sin e- (⚑S2)', answer: 'school, Spain, student, Spanish'),
    CourseItem(prompt: 'Vocal larga vs corta (⚑S1)', answer: 'sheep – ship, green – it'),
  ],
);

final QuizContent esEnA11Pronouns = esEnVocab(
  id: 'es_en_a1_1_pronouns',
  title: 'Pronombres de sujeto · I, you, he…',
  intro: 'Quien hace la acción. En inglés el pronombre de sujeto es '
      'OBLIGATORIO: no existe "soy médico" sin el I.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚑S11 El sujeto nunca se omite',
      text: 'En español dices "hablo", en inglés SIEMPRE "I speak". Frase sin '
          'sujeto = frase incorrecta.',
    ),
    HelpMemoryTip(
      kind: 'rule',
      title: 'I siempre en mayúscula',
      text: '"yo" = I, con mayúscula en cualquier posición de la frase.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'you sirve para todo',
      text: 'tú, usted, vosotros y ustedes son todos "you". Una sola forma.',
    ),
  ],
  pairs: const [
    MapEntry('yo', 'I'),
    MapEntry('tú / usted', 'you'),
    MapEntry('él', 'he'),
    MapEntry('ella', 'she'),
    MapEntry('ello (cosa, animal)', 'it'),
    MapEntry('nosotros / nosotras', 'we'),
    MapEntry('vosotros / ustedes', 'you'),
    MapEntry('ellos / ellas', 'they'),
    MapEntry('usted (formal)', 'you'),
    MapEntry('ellas (solo mujeres)', 'they'),
  ],
);

final QuizContent esEnA11Be = esEnFill(
  id: 'es_en_a1_1_be',
  title: 'El verbo be: am / is / are',
  intro: 'be = ser Y estar, todo en uno. Cambia según el sujeto: I am, '
      'he/she/it is, you/we/they are.',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'La regla corta',
      text: 'I → am · he/she/it → is · you/we/they → are.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Un solo verbo para ser y estar',
      text: 'She is a doctor (ser) y She is in Madrid (estar) usan el mismo '
          'is. Una preocupación menos.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Yo soy estudiante.', answer: 'I **am** a student.'),
    CourseItem(prompt: 'Tú eres profesor.', answer: 'You **are** a teacher.'),
    CourseItem(prompt: 'Él es alto.', answer: 'He **is** tall.'),
    CourseItem(prompt: 'Ella es mi amiga.', answer: 'She **is** my friend.'),
    CourseItem(prompt: 'Es un gato.', answer: 'It **is** a cat.'),
    CourseItem(prompt: 'Nosotros somos mexicanos.', answer: 'We **are** Mexican.'),
    CourseItem(prompt: 'Ellos están ocupados.', answer: 'They **are** busy.'),
    CourseItem(prompt: 'Esto es un libro.', answer: 'This **is** a book.'),
    CourseItem(prompt: 'Ustedes son estudiantes.', answer: 'You **are** students.'),
    CourseItem(prompt: 'Mi madre es enfermera.', answer: 'My mother **is** a nurse.'),
    CourseItem(prompt: 'Tu libro es viejo.', answer: 'Your book **is** old.'),
    CourseItem(prompt: 'Hoy estoy cansado.', answer: 'I **am** tired today.'),
    CourseItem(prompt: 'Esas sillas son nuevas.', answer: 'Those chairs **are** new.'),
    CourseItem(prompt: 'El tiempo está frío.', answer: 'The weather **is** cold.'),
    CourseItem(prompt: 'Tú y yo somos buenos amigos.', answer: 'You and I **are** good friends.'),
  ],
);

final QuizContent esEnA11SpeakIntro = esEnSpeak(
  id: 'es_en_a1_1_speak_intro',
  title: 'A hablar: presentarte',
  intro: 'Preséntate en inglés: escucha y repite.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Las contracciones suenan natural',
      text: "I am → I'm, What is → What's. En conversación casi siempre se contrae.",
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: '⚑S3 La h de hello se aspira',
      text: 'hello, how llevan una h suave pero audible, como la j andaluza '
          'ligera — no muda como en español.',
    ),
  ],
  items: const [
    CourseItem(prompt: '¡Hola!', answer: 'Hello!'),
    CourseItem(prompt: 'Me llamo Lucía.', answer: "I'm Lucía."),
    CourseItem(prompt: 'Soy de México.', answer: "I'm from Mexico."),
    CourseItem(prompt: 'Soy estudiante.', answer: "I'm a student."),
    CourseItem(prompt: '¿Cómo te llamas?', answer: "What's your name?"),
    CourseItem(prompt: '¿Cómo estás?', answer: 'How are you?'),
    CourseItem(prompt: 'Muy bien, gracias.', answer: "I'm fine, thank you."),
    CourseItem(prompt: 'Encantado de conocerte.', answer: 'Nice to meet you.'),
  ],
);

final QuizContent esEnA11AAn = esEnFill(
  id: 'es_en_a1_1_a_an',
  title: 'El artículo a / an',
  intro: 'a/an = un/una, sin género. La elección depende del SONIDO siguiente: '
      'consonante → a, vocal → an. Y ojo: delante de profesiones es obligatorio.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: '¿a o an?',
      text: 'Sonido de consonante → a (a book). Sonido de vocal → an (an apple).',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: '⚑S16 Profesión con artículo',
      text: 'En español "soy médico", sin artículo. En inglés SIEMPRE '
          "I'm **a** doctor — nunca \"I'm doctor\".",
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: 'Se decide por el sonido, no la letra',
      text: 'an hour (la h es muda) pero a university (suena /juː/, consonante).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'una manzana', answer: "It's **an** apple."),
    CourseItem(prompt: 'un libro', answer: "It's **a** book."),
    CourseItem(prompt: 'un huevo (egg)', answer: "It's **an** egg."),
    CourseItem(prompt: 'Ella es profesora.', answer: "She's **a** teacher."),
    CourseItem(prompt: 'una naranja', answer: "It's **an** orange."),
    CourseItem(prompt: 'dentro de una hora (h muda)', answer: 'in **an** hour'),
    CourseItem(prompt: 'una universidad (suena /juː/)', answer: "It's **a** university."),
    CourseItem(prompt: 'un coche', answer: "It's **a** car."),
    CourseItem(prompt: 'Él es ingeniero.', answer: "He's **an** engineer."),
    CourseItem(prompt: 'un perro', answer: "It's **a** dog."),
    CourseItem(prompt: 'un paraguas (umbrella)', answer: "It's **an** umbrella."),
    CourseItem(prompt: 'una idea', answer: "It's **an** idea."),
    CourseItem(prompt: 'Ella es enfermera.', answer: "She's **a** nurse."),
    CourseItem(prompt: 'un chico honesto (honest, h muda)', answer: "He's **an** honest boy."),
    CourseItem(prompt: 'Yo soy artista.', answer: "I'm **an** artist."),
  ],
);

final QuizContent esEnA11Countries = esEnVocab(
  id: 'es_en_a1_1_countries',
  title: 'Países e idiomas · Countries',
  intro: 'Países, nacionalidades e idiomas — siempre con mayúscula en inglés.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: 'Mayúscula obligatoria',
      text: 'Spanish, Mexican, English llevan mayúscula SIEMPRE, también en '
          'mitad de frase. En español no; en inglés sí.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Un mundo hispano',
      text: 'Spanish es el idioma y también "español/española de España". Para '
          'el resto: Mexican, Argentinian, Colombian…',
    ),
  ],
  pairs: const [
    MapEntry('España', 'Spain'),
    MapEntry('español (idioma)', 'Spanish'),
    MapEntry('inglés (idioma)', 'English'),
    MapEntry('México', 'Mexico'),
    MapEntry('mexicano', 'Mexican'),
    MapEntry('Argentina', 'Argentina'),
    MapEntry('Estados Unidos', 'the United States'),
    MapEntry('Inglaterra', 'England'),
    MapEntry('Colombia', 'Colombia'),
    MapEntry('Reino Unido', 'the United Kingdom'),
  ],
);

final QuizContent esEnA11ListenMeet = esEnListen(
  id: 'es_en_a1_1_listen_meet',
  title: 'Escucha: Nice to meet you',
  passageTitle: 'Meet Emma',
  passage:
      "Hi! My name is Emma. I'm from Leeds, in England. I'm twenty years old "
      "and I'm a student. I live with two friends. I like music and books. "
      "Nice to meet you! What's your name?",
  passageTranslation:
      '¡Hola! Me llamo Emma. Soy de Leeds, en Inglaterra. Tengo veinte años y '
      'soy estudiante. Vivo con dos amigas. Me gusta la música y los libros. '
      '¡Encantada! ¿Cómo te llamas?',
  intro: 'El texto no aparece en pantalla: primero escucha, luego responde. '
      'Puedes reproducirlo las veces que quieras.',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'Caza las palabras clave',
      text: 'Escucha where (dónde), how old (edad) y like (qué le gusta). Con '
          'esos tres datos respondes todo.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'Where is Emma from?',
      options: ['Madrid', 'Leeds', 'Paris'],
      correctIndex: 1,
      questionTranslation: '¿De dónde es Emma?',
    ),
    ReadingQuestion(
      question: 'How old is she?',
      options: ['12', '20', '22'],
      correctIndex: 1,
      questionTranslation: '¿Cuántos años tiene?',
    ),
    ReadingQuestion(
      question: 'What does she like?',
      options: ['Sport', 'Music and books', 'Films'],
      correctIndex: 1,
      questionTranslation: '¿Qué le gusta?',
    ),
  ],
);

final QuizContent esEnA11ThisThat = esEnFill(
  id: 'es_en_a1_1_this_that',
  title: 'this / that / these / those',
  intro: 'Cerca: this (este/esta), plural these. Lejos: that (ese/aquel), '
      'plural those.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Cerca vs lejos, singular vs plural',
      text: 'this (esto, sing.) / these (estos, pl.) · that (eso, sing.) / '
          'those (esos, pl.).',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: '⚑S5 this y these llevan th sonora',
      text: 'La lengua toca los dientes y vibra: /ð/. No es "dis" con d dura. '
          'Y these lleva vocal larga /iː/, this corta /ɪ/ (⚑S1).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Este es mi libro.', answer: '**This** is my book.'),
    CourseItem(prompt: 'Esa es tu mochila.', answer: '**That** is your bag.'),
    CourseItem(prompt: 'Estos son mis amigos.', answer: '**These** are my friends.'),
    CourseItem(prompt: 'Aquellos son sus libros (de ellos).', answer: '**Those** are their books.'),
    CourseItem(prompt: '¿Cómo se dice esto en inglés?', answer: "What's **this** in English?"),
    CourseItem(prompt: '¿Qué es eso?', answer: "What's **that**?"),
    CourseItem(prompt: 'Esto es una manzana.', answer: '**This** is an apple.'),
    CourseItem(prompt: 'Aquellas son nuestras sillas.', answer: '**Those** are our chairs.'),
    CourseItem(prompt: 'Estos libros son nuevos.', answer: '**These** books are new.'),
    CourseItem(prompt: 'Ese chico es mi hermano pequeño.', answer: '**That** boy is my little brother.'),
    CourseItem(prompt: 'Estas manzanas están riquísimas.', answer: '**These** apples are delicious.'),
    CourseItem(prompt: 'Aquellas personas son profesores.', answer: '**Those** people are teachers.'),
    CourseItem(prompt: 'Este bolígrafo es rojo.', answer: '**This** pen is red.'),
    CourseItem(prompt: 'Ese coche es de mi padre.', answer: "**That** car is my father's."),
    CourseItem(prompt: '¿Son estas tus llaves?', answer: 'Are **these** your keys?'),
  ],
);

final QuizContent esEnA11Jobs = esEnVocab(
  id: 'es_en_a1_1_jobs',
  title: 'Profesiones · Jobs',
  intro: 'Profesiones frecuentes. Para preguntar: What do you do?',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚑S16 Con a delante',
      text: "Al decir tu profesión, artículo obligatorio: I'm **a** teacher, "
          'nunca "I\'m teacher".',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Sin masculino/femenino',
      text: 'teacher, doctor, nurse sirven para hombres y mujeres. El inglés '
          'no marca el género en la profesión.',
    ),
  ],
  pairs: const [
    MapEntry('profesor / profesora', 'teacher'),
    MapEntry('estudiante', 'student'),
    MapEntry('médico / médica', 'doctor'),
    MapEntry('enfermero / enfermera', 'nurse'),
    MapEntry('ingeniero / ingeniera', 'engineer'),
    MapEntry('cocinero / cocinera', 'cook'),
    MapEntry('conductor / conductora', 'driver'),
    MapEntry('policía', 'police officer'),
    MapEntry('camarero / camarera', 'waiter'),
    MapEntry('abogado / abogada', 'lawyer'),
  ],
);

final QuizContent esEnA11SpeakingMid = esEnSpeaking(
  id: 'es_en_a1_1_speaking_mid',
  title: 'Conversación: primeros saludos',
  level: 'A1.1',
  topic: 'A very simple first meeting: greet me, ask my name, where I am from '
      'and what I do. Speak very slowly and use only basic words.',
  practisePoints: [
    'Greetings: hello, how are you, nice to meet you',
    'Saying who I am with be: I am… / I\'m from…',
    'Saying my job with a/an: I\'m a student',
  ],
  scoringCriteria: [
    'Uses am/is/are correctly',
    'Never drops the subject pronoun (I, you, he…)',
    'Uses a/an before jobs',
  ],
  priorityErrors: [
    'missing subject pronouns ("am tired" instead of "I am tired")',
    'missing a/an before professions',
    'Spanish vowels in very common words',
  ],
  mode: SpeakingMode.conversation,
  session: const SpeakingSession(
    durationMinutes: 3,
    minExchanges: 6,
    minQuestionsPerPoint: 1,
  ),
  intro: 'Punto de control a mitad del módulo: una conversación mínima de '
      'presentación en tu asistente de IA. Copia el texto, actívale el modo '
      'voz y al final teclea aquí tu puntuación.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Habla despacio y con sujeto',
      text: 'Cada frase con su pronombre: I am…, She is… (⚑S11). Mejor lento '
          'y completo que rápido y sin sujeto.',
    ),
  ],
);

final QuizContent esEnA11ReadFamily = esEnRead(
  id: 'es_en_a1_1_read_family',
  title: 'Lectura: This is my family',
  passageTitle: 'My family',
  passage:
      'This is my family. My name is Mateo. I have a father, a mother, and a '
      'little sister. My father is a doctor and my mother is a teacher. My '
      'sister is six years old. We have a small dog. Its name is Rocky. I love '
      'my family.',
  passageTranslation:
      'Esta es mi familia. Me llamo Mateo. Tengo padre, madre y una hermana '
      'pequeña. Mi padre es médico y mi madre es profesora. Mi hermana tiene '
      'seis años. Tenemos un perro pequeño que se llama Rocky. Quiero mucho a '
      'mi familia.',
  intro: 'Una presentación corta. Lee primero el inglés; la traducción está '
      'en el botón de información.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: 'La edad se TIENE… en español',
      text: 'En inglés la edad va con be: My sister **is** six years old — '
          'nunca "has six years".',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: "What is the father's job?",
      options: ['Teacher', 'Doctor', 'Driver'],
      correctIndex: 1,
      questionTranslation: '¿Cuál es la profesión del padre?',
    ),
    ReadingQuestion(
      question: 'How old is the sister?',
      options: ['Four', 'Six', 'Ten'],
      correctIndex: 1,
      questionTranslation: '¿Cuántos años tiene la hermana?',
    ),
    ReadingQuestion(
      question: "What is the dog's name?",
      options: ['Mateo', 'Rocky', 'Coco'],
      correctIndex: 1,
      questionTranslation: '¿Cómo se llama el perro?',
    ),
  ],
);

final QuizContent esEnA11Wh = esEnFill(
  id: 'es_en_a1_1_wh',
  title: 'Preguntas con what / where / who',
  intro: 'what (qué), where (dónde), who (quién). La palabra interrogativa va '
      'SIEMPRE al principio, y sin signo de apertura.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚑S26 Orden fijo',
      text: 'Interrogativa + verbo + sujeto: What is your name? El inglés no '
          'permite mover la pregunta de sitio.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Solo un signo',
      text: 'El inglés no abre con ¿. Solo cierra: What is this?',
    ),
  ],
  items: const [
    CourseItem(prompt: '¿Cómo te llamas? (qué nombre)', answer: '**What** is your name?'),
    CourseItem(prompt: '¿Dónde vives?', answer: '**Where** do you live?'),
    CourseItem(prompt: '¿Quién es ella?', answer: '**Who** is she?'),
    CourseItem(prompt: '¿Qué es esto?', answer: '**What** is this?'),
    CourseItem(prompt: '¿Quién es tu profesor?', answer: '**Who** is your teacher?'),
    CourseItem(prompt: '¿Dónde está tu escuela?', answer: '**Where** is your school?'),
    CourseItem(prompt: '¿Dónde está tu libro?', answer: '**Where** is your book?'),
    CourseItem(prompt: '¿Quién es esa chica?', answer: '**Who** is that girl?'),
    CourseItem(prompt: '¿Cuál es tu color favorito?', answer: '**What** is your favourite colour?'),
    CourseItem(prompt: '¿Qué hay en tu mochila?', answer: '**What** is in your bag?'),
    CourseItem(prompt: '¿Dónde está el baño?', answer: '**Where** is the bathroom?'),
    CourseItem(prompt: '¿Quién es tu profesora de inglés?', answer: '**Who** is your English teacher?'),
    CourseItem(prompt: '¿Cuál es tu trabajo?', answer: '**What** is your job?'),
    CourseItem(prompt: '¿Dónde están tus padres?', answer: '**Where** are your parents?'),
    CourseItem(prompt: '¿Quién es el hombre de la puerta?', answer: '**Who** is the man at the door?'),
  ],
);

final QuizContent esEnA11Colours = esEnVocab(
  id: 'es_en_a1_1_colours',
  title: 'Colores y clase · Colours',
  intro: 'Colores básicos y objetos del aula.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚑S12 Adjetivo DELANTE y sin plural',
      text: 'a red pen, two red pens: el color va antes del nombre y nunca '
          'cambia — no existe "pens reds".',
    ),
  ],
  pairs: const [
    MapEntry('rojo', 'red'),
    MapEntry('azul', 'blue'),
    MapEntry('verde', 'green'),
    MapEntry('amarillo', 'yellow'),
    MapEntry('negro', 'black'),
    MapEntry('blanco', 'white'),
    MapEntry('libro', 'book'),
    MapEntry('bolígrafo', 'pen'),
    MapEntry('mesa (escritorio)', 'desk'),
    MapEntry('silla', 'chair'),
  ],
);

final QuizContent esEnA11SpeakSounds = esEnSpeak(
  id: 'es_en_a1_1_speak_sounds',
  title: 'Sonidos: th, h y vocal larga',
  intro: 'Los sonidos que el español no tiene y que delatan a cualquier '
      'principiante. Escucha con atención y repite.',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: '⚑S5 La lengua entre los dientes',
      text: 'Para th, punta de la lengua entre los dientes y sopla: think no '
          'es "sink" ni "fink"; this no es "dis".',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: '⚑S1 Larga no es igual que corta',
      text: 'sheep (larga /iː/) y ship (corta /ɪ/) son palabras distintas. En '
          'español solo hay una i; en inglés son dos sonidos.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'th sorda', answer: 'think, thank, three, mouth'),
    CourseItem(prompt: 'th sonora', answer: 'this, that, they, mother'),
    CourseItem(prompt: 'Contraste s / th', answer: 'sink – think, sing – thing'),
    CourseItem(prompt: 'La h aspirada (⚑S3)', answer: 'hello, house, how, hot'),
    CourseItem(prompt: 'Contraste corta / larga (⚑S1)', answer: 'ship – sheep, it – eat, live – leave'),
    CourseItem(prompt: 'Una frase entera', answer: 'I think these three sheep are healthy.'),
  ],
);

final QuizContent esEnA11PronounsFill = esEnFill(
  id: 'es_en_a1_1_pronouns_fill',
  title: 'El sujeto obligatorio',
  intro: 'La trampa nº 1 del hispanohablante: dejar la frase sin sujeto. '
      'Completa cada frase con el pronombre que falta.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚑S11 Sin sujeto no hay frase',
      text: '"Es tarde" → **It** is late. "Llueve" → **It** rains. Cuando en '
          'español no hay nadie, en inglés lo pone it.',
    ),
    HelpMemoryTip(
      kind: 'rule',
      title: 'it para el tiempo y la hora',
      text: 'It is cold. It is three o\'clock. It rains a lot. Ese it vacío es '
          'obligatorio.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Soy de Lima.', answer: '**I** am from Lima.'),
    CourseItem(prompt: 'Es tarde.', answer: '**It** is late.'),
    CourseItem(prompt: 'Somos amigos.', answer: '**We** are friends.'),
    CourseItem(prompt: 'Está frío (el tiempo).', answer: '**It** is cold.'),
    CourseItem(prompt: 'Eres muy amable.', answer: '**You** are very kind.'),
    CourseItem(prompt: 'Es mi hermana. (ella)', answer: '**She** is my sister.'),
    CourseItem(prompt: 'Son las tres.', answer: '**It** is three o\'clock.'),
    CourseItem(prompt: 'Están en casa. (ellos)', answer: '**They** are at home.'),
    CourseItem(prompt: 'Es médico. (él)', answer: '**He** is a doctor.'),
    CourseItem(prompt: 'Estoy cansada.', answer: '**I** am tired.'),
    CourseItem(prompt: 'Es lunes.', answer: '**It** is Monday.'),
    CourseItem(prompt: 'Sois estudiantes.', answer: '**You** are students.'),
    CourseItem(prompt: 'Es un buen día.', answer: '**It** is a good day.'),
    CourseItem(prompt: 'Somos de Bogotá.', answer: '**We** are from Bogotá.'),
    CourseItem(prompt: 'Es importante. (la tarea)', answer: '**It** is important.'),
  ],
);

final QuizContent esEnA11ListenCafe = esEnListen(
  id: 'es_en_a1_1_listen_cafe',
  title: 'Escucha: At the café',
  passageTitle: 'Two coffees, please',
  passage:
      "Good morning! Two coffees, please. And a glass of water. — Of course. "
      "Anything else? — Yes, a chocolate cake, please. How much is it? — "
      "That's nine pounds, please. — Here you are. Thank you! — Thank you. "
      "Have a nice day!",
  passageTranslation:
      '¡Buenos días! Dos cafés, por favor. Y un vaso de agua. — Claro. ¿Algo '
      'más? — Sí, una tarta de chocolate, por favor. ¿Cuánto es? — Son nueve '
      'libras, por favor. — Aquí tiene. ¡Gracias! — Gracias. ¡Que tenga un '
      'buen día!',
  intro: 'Un pedido en una cafetería. Escucha los números y lo que piden.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'please y thank you, siempre',
      text: 'El inglés cotidiano suaviza todo con please y thank you. Pedir '
          'sin please suena brusco.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'How many coffees do they order?',
      options: ['One', 'Two', 'Three'],
      correctIndex: 1,
      questionTranslation: '¿Cuántos cafés piden?',
    ),
    ReadingQuestion(
      question: 'What else do they order?',
      options: ['A sandwich', 'A chocolate cake', 'An orange juice'],
      correctIndex: 1,
      questionTranslation: '¿Qué más piden?',
    ),
    ReadingQuestion(
      question: 'How much is it?',
      options: ['Nine pounds', 'Five pounds', 'Ten pounds'],
      correctIndex: 0,
      questionTranslation: '¿Cuánto cuesta?',
    ),
  ],
);

final QuizContent esEnA11Negation = esEnFill(
  id: 'es_en_a1_1_negation',
  title: 'Negar con be: isn\'t / aren\'t',
  intro: 'Con be la negación es fácil: añade not (o las contracciones isn\'t, '
      'aren\'t, I\'m not) después del verbo.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'be + not',
      text: "I'm not · he/she/it isn't · you/we/they aren't. El not va DESPUÉS "
          'del verbo be.',
    ),
    HelpMemoryTip(
      kind: 'warning',
      title: 'Una sola negación',
      text: 'En español "no hay nada"; en inglés una única negación: '
          '"There isn\'t anything" — nunca dos no seguidos.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'No soy profesor.', answer: 'I am **not** a teacher.'),
    CourseItem(prompt: 'Ella no está cansada.', answer: 'She **isn\'t** tired.'),
    CourseItem(prompt: 'No somos de Madrid.', answer: 'We **aren\'t** from Madrid.'),
    CourseItem(prompt: 'Esto no es mi libro.', answer: 'This **isn\'t** my book.'),
    CourseItem(prompt: 'Ellos no están en casa.', answer: 'They **aren\'t** at home.'),
    CourseItem(prompt: 'Él no es médico.', answer: 'He **isn\'t** a doctor.'),
    CourseItem(prompt: 'No está frío hoy.', answer: 'It **isn\'t** cold today.'),
    CourseItem(prompt: 'Tú no eres viejo.', answer: 'You **aren\'t** old.'),
    CourseItem(prompt: 'La escuela no es grande.', answer: 'The school **isn\'t** big.'),
    CourseItem(prompt: 'No estoy triste.', answer: 'I am **not** sad.'),
    CourseItem(prompt: 'Mis padres no son ingleses.', answer: 'My parents **aren\'t** English.'),
    CourseItem(prompt: 'Esa silla no es nueva.', answer: 'That chair **isn\'t** new.'),
    CourseItem(prompt: 'El café no está caliente.', answer: 'The coffee **isn\'t** hot.'),
    CourseItem(prompt: 'No somos hermanos.', answer: 'We **aren\'t** brothers.'),
    CourseItem(prompt: 'Ella no es mi madre.', answer: 'She **isn\'t** my mother.'),
  ],
);

final QuizContent esEnA11Dict = esEnDict(
  id: 'es_en_a1_1_dict',
  title: 'Dictado: presentaciones',
  intro: 'Escucha cada frase y escríbela. Entrena el oído para las '
      'consonantes finales y las palabras débiles que el español no tiene.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚑S6 No te comas los finales',
      text: 'friends termina en -ds y student en -t: en inglés las consonantes '
          'finales se pronuncian y se escriben.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Me llamo Anna.', answer: 'My name is Anna.'),
    CourseItem(prompt: 'Soy de España.', answer: 'I am from Spain.'),
    CourseItem(prompt: 'Soy estudiante.', answer: 'I am a student.'),
    CourseItem(prompt: 'Tengo dos hermanos.', answer: 'I have two brothers.'),
    CourseItem(prompt: 'Ella es profesora.', answer: 'She is a teacher.'),
    CourseItem(prompt: 'Este es mi libro.', answer: 'This is my book.'),
    CourseItem(prompt: 'Tengo veinte años.', answer: 'I am twenty years old.'),
    CourseItem(prompt: 'Él es médico.', answer: 'He is a doctor.'),
    CourseItem(prompt: 'Somos de México.', answer: 'We are from Mexico.'),
    CourseItem(prompt: 'Eso es un gato.', answer: 'That is a cat.'),
    CourseItem(prompt: 'Mi número de teléfono es nueve cero cinco.', answer: 'My phone number is nine zero five.'),
    CourseItem(prompt: 'Ella tiene dieciocho años.', answer: 'She is eighteen years old.'),
    CourseItem(prompt: 'Somos estudiantes.', answer: 'We are students.'),
    CourseItem(prompt: 'Él se llama Tom.', answer: 'His name is Tom.'),
    CourseItem(prompt: 'Estos son mis amigos.', answer: 'These are my friends.'),
  ],
);

final QuizContent esEnA11BigText = esEnBigText(
  id: 'es_en_a1_1_bigtext',
  title: 'Texto: A new friend in class',
  passageTitle: 'A new friend',
  intro: 'Un texto con huecos: escribe en cada hueco la forma de be, el '
      'artículo o el pronombre que falta. Primero lee el texto completo.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Todo lo del módulo, junto',
      text: 'be (am/is/are), a/an y los pronombres obligatorios (⚑S11, ⚑S16): '
          'este texto lo mezcla todo.',
    ),
  ],
  template:
      'Hello! My name {{0}} Lucía and I {{1}} from Guadalajara. I am {{2}} '
      'student in London. This {{3}} my classroom and that {{4}} my teacher, '
      'Mrs. Park. {{5}} is very kind. My friend Mateo is {{6}} engineer from '
      'Buenos Aires. We {{7}} good friends. Our school {{8}} small, but '
      '{{9}} is nice.',
  blanks: [
    inputBlank('is'),
    inputBlank('am', accepted: ["'m"]),
    inputBlank('a'),
    inputBlank('is'),
    inputBlank('is'),
    inputBlank('She', accepted: ['she']),
    inputBlank('an'),
    inputBlank('are', accepted: ["'re"]),
    inputBlank('is'),
    inputBlank('it'),
  ],
  passageTranslation:
      '¡Hola! Me llamo Lucía y soy de Guadalajara. Soy estudiante en Londres. '
      'Esta es mi clase y esa es mi profesora, la señora Park. Es muy amable. '
      'Mi amigo Mateo es un ingeniero de Buenos Aires. Somos buenos amigos. '
      'Nuestra escuela es pequeña, pero es bonita.',
);

final QuizContent esEnA11DictNumbers = esEnDict(
  id: 'es_en_a1_1_dict_numbers',
  title: 'Dictado: números y letras',
  intro: 'Escucha y escribe: números, edades y deletreos. Los números por '
      'teléfono se dicen cifra a cifra.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '-teen vs -ty',
      text: 'thirteen (13) y thirty (30) se distinguen por el acento: '
          'thirTEEN / THIRty (⚑S8). Afina el oído.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'tres', answer: 'three'),
    CourseItem(prompt: 'ocho', answer: 'eight'),
    CourseItem(prompt: 'doce', answer: 'twelve'),
    CourseItem(prompt: 'trece', answer: 'thirteen'),
    CourseItem(prompt: 'quince', answer: 'fifteen'),
    CourseItem(prompt: 'veinte', answer: 'twenty'),
    CourseItem(prompt: 'Tengo once años.', answer: 'I am eleven years old.'),
    CourseItem(prompt: 'Son las siete.', answer: 'It is seven o\'clock.'),
    CourseItem(prompt: 'Mi número es cuatro cinco nueve.', answer: 'My number is four five nine.'),
    CourseItem(prompt: 'Dos cafés, por favor.', answer: 'Two coffees, please.'),
    CourseItem(prompt: 'Somos cinco.', answer: 'We are five.'),
    CourseItem(prompt: 'Ella tiene dieciséis años.', answer: 'She is sixteen years old.'),
    CourseItem(prompt: 'Son diez libras.', answer: 'It is ten pounds.'),
    CourseItem(prompt: 'Catorce libros', answer: 'fourteen books'),
    CourseItem(prompt: 'Diecinueve estudiantes', answer: 'nineteen students'),
  ],
);

final QuizContent esEnA11SpeakingClose = esEnSpeaking(
  id: 'es_en_a1_1_speaking_close',
  title: 'Conversación final: quién soy',
  level: 'A1.1',
  topic: 'A friendly get-to-know-you chat: my name, my age, where I am from, '
      'my job, my family and my favourite colour. Very slow, very simple.',
  practisePoints: [
    'Introducing myself with be: name, age, origin',
    'My job and my family members with a/an',
    'Simple questions back: What\'s your name? Where are you from?',
    'this/that to point at things around me',
  ],
  scoringCriteria: [
    'Correct am/is/are for each subject',
    'Subject pronouns always present',
    'a/an used before jobs and singular nouns',
  ],
  targetVocabulary: [
    'student', 'teacher', 'family', 'brother', 'sister', 'favourite',
  ],
  priorityErrors: [
    'dropped subject pronouns',
    'missing a/an',
    '"has X years" instead of "is X years old"',
  ],
  mode: SpeakingMode.interview,
  intro: 'Cierre del módulo A1.1: una entrevista sencilla sobre ti. Copia el '
      'texto en tu asistente de IA con voz, habla y trae la puntuación.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'La edad con be',
      text: 'I am twenty years old — la edad en inglés se ES, no se tiene.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: 'Pide repetición sin miedo',
      text: '"Can you repeat, please?" es una frase perfectamente A1 y muy útil.',
    ),
  ],
);

/// A1.1 in chain order (sound / knowledge / listening / reading / dictation
/// interleaved; speaking checkpoint at the midpoint, closing speaking last).
final List<QuizContent> esEnA1_1 = [
  esEnA11Numbers,
  esEnA11Alphabet,
  esEnA11Pronouns,
  esEnA11Be,
  esEnA11SpeakIntro,
  esEnA11AAn,
  esEnA11Countries,
  esEnA11ListenMeet,
  esEnA11ThisThat,
  esEnA11Jobs,
  esEnA11SpeakingMid,
  esEnA11ReadFamily,
  esEnA11Wh,
  esEnA11Colours,
  esEnA11SpeakSounds,
  esEnA11PronounsFill,
  esEnA11ListenCafe,
  esEnA11Negation,
  esEnA11Dict,
  esEnA11BigText,
  esEnA11DictNumbers,
  esEnA11SpeakingClose,
];
