import '../../../models/quiz_content.dart';
import 'en_es_builder.dart';

/// A1.1 — First sounds & selves. English → Spanish.
///
/// Big rocks: the five pure vowels and r/ñ/j (⚑E1–E3), ser + subject
/// pronouns, grammatical gender and el/la (⚑E7), hay, numbers, greetings.
/// The Spanish taught is pan-Hispanic neutral: ustedes is the default
/// plural "you"; vosotros is flagged as Spain-only (⚑E28).

final QuizContent enEsA11Vowels = enEsSpeak(
  id: 'en_es_a1_1_vowels',
  title: 'The five pure vowels',
  intro: 'Spanish has exactly five vowel sounds — a e i o u — and they '
      'never change or reduce. Master these and your accent is halfway '
      'there.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚑E1 No schwa, ever',
      text: 'English relaxes unstressed vowels ("banana" → buh-NAH-nuh). '
          'Spanish never does: ba-na-na, every a identical.',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: '⚑E2 The r is a tap',
      text: 'pero has a single tap of the tongue, like the tt in American '
          '"butter". perro rolls it — two different words!',
    ),
  ],
  items: const [
    CourseItem(prompt: 'The five vowels', answer: 'a, e, i, o, u'),
    CourseItem(prompt: 'Same vowel, every time', answer: 'banana, casa, mañana'),
    CourseItem(prompt: 'Tap vs trill (⚑E2)', answer: 'pero – perro, caro – carro'),
    CourseItem(prompt: 'The ñ sound (⚑E3)', answer: 'mañana, español, niño, año'),
    CourseItem(prompt: 'The j sound (⚑E3)', answer: 'trabajo, hijo, mujer, joven'),
    CourseItem(prompt: 'Silent h', answer: 'hola, hombre, hora, hermano'),
    CourseItem(prompt: 'A whole sentence', answer: 'La niña pequeña habla español mañana.'),
  ],
);

final QuizContent enEsA11Greetings = enEsVocab(
  id: 'en_es_a1_1_greetings',
  title: 'Greetings · Saludos',
  intro: 'Your first Spanish words: greetings for every hour of the day.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Buenos vs buenas',
      text: 'buenos días (masculine plural) but buenas tardes / buenas '
          'noches (feminine plural) — your first taste of gender '
          'agreement (⚑E7).',
    ),
  ],
  pairs: const [
    MapEntry('hello', 'hola'),
    MapEntry('good morning', 'buenos días'),
    MapEntry('good afternoon', 'buenas tardes'),
    MapEntry('good night', 'buenas noches'),
    MapEntry('goodbye', 'adiós'),
    MapEntry('see you later', 'hasta luego'),
    MapEntry('see you tomorrow', 'hasta mañana'),
    MapEntry('please', 'por favor'),
    MapEntry('thank you', 'gracias'),
    MapEntry('you\'re welcome', 'de nada'),
  ],
);

final QuizContent enEsA11Gender = enEsFill(
  id: 'en_es_a1_1_gender',
  title: 'el / la: every noun has a gender',
  intro: 'Every Spanish noun is masculine (el) or feminine (la). Nouns in '
      '-o are usually masculine, in -a usually feminine — learn the '
      'article WITH the word.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚑E7 The article is part of the word',
      text: 'Never learn "mesa" — learn "la mesa". The gender drives '
          'articles AND adjectives, so it must come bundled.',
    ),
    HelpMemoryTip(
      kind: 'rule',
      title: 'The famous exceptions',
      text: 'el día, el mapa, el problema (masculine despite -a); la mano '
          '(feminine despite -o). A short list — memorise it early.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'the book', answer: '**el** libro'),
    CourseItem(prompt: 'the table', answer: '**la** mesa'),
    CourseItem(prompt: 'the house', answer: '**la** casa'),
    CourseItem(prompt: 'the boy', answer: '**el** niño'),
    CourseItem(prompt: 'the girl', answer: '**la** niña'),
    CourseItem(prompt: 'the day (exception!)', answer: '**el** día'),
    CourseItem(prompt: 'the hand (exception!)', answer: '**la** mano'),
    CourseItem(prompt: 'the problem (exception!)', answer: '**el** problema'),
    CourseItem(prompt: 'the coffee', answer: '**el** café'),
    CourseItem(prompt: 'the city', answer: '**la** ciudad'),
    CourseItem(prompt: 'the map (exception!)', answer: '**el** mapa'),
    CourseItem(prompt: 'the night', answer: '**la** noche'),
    CourseItem(prompt: 'the car', answer: '**el** coche'),
    CourseItem(prompt: 'the school', answer: '**la** escuela'),
    CourseItem(prompt: 'the friend (male)', answer: '**el** amigo'),
  ],
);

final QuizContent enEsA11Ser = enEsFill(
  id: 'en_es_a1_1_ser',
  title: 'ser: soy, eres, es…',
  intro: 'ser = to be (for identity: who/what you are). It conjugates for '
      'every person: soy, eres, es, somos, son.',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'The ser table',
      text: 'yo soy · tú eres · él/ella/usted es · nosotros somos · '
          'ustedes/ellos son (Spain adds vosotros sois ⚑E28).',
    ),
    HelpMemoryTip(
      kind: 'tip',
      title: '⚑E10 Drop the pronoun',
      text: 'Soy médico already means "I am a doctor" — the -oy ending '
          'says who. Add yo only for emphasis.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'I am a student.', answer: '**Soy** estudiante.'),
    CourseItem(prompt: 'You are my friend. (tú)', answer: '**Eres** mi amigo.'),
    CourseItem(prompt: 'She is a doctor.', answer: 'Ella **es** médica.'),
    CourseItem(prompt: 'We are Mexican.', answer: '**Somos** mexicanos.'),
    CourseItem(prompt: 'They are teachers.', answer: '**Son** profesores.'),
    CourseItem(prompt: 'He is tall.', answer: 'Él **es** alto.'),
    CourseItem(prompt: 'I am Ana.', answer: '**Soy** Ana.'),
    CourseItem(prompt: 'You (formal) are very kind.', answer: 'Usted **es** muy amable.'),
    CourseItem(prompt: 'It is a book.', answer: '**Es** un libro.'),
    CourseItem(prompt: 'We are friends.', answer: '**Somos** amigos.'),
    CourseItem(prompt: 'You all are students. (ustedes)', answer: 'Ustedes **son** estudiantes.'),
    CourseItem(prompt: 'My mother is a nurse.', answer: 'Mi madre **es** enfermera.'),
    CourseItem(prompt: 'The house is big.', answer: 'La casa **es** grande.'),
    CourseItem(prompt: 'You are young. (tú)', answer: '**Eres** joven.'),
    CourseItem(prompt: 'Today is Monday.', answer: 'Hoy **es** lunes.'),
  ],
);

final QuizContent enEsA11SpeakIntro = enEsSpeak(
  id: 'en_es_a1_1_speak_intro',
  title: 'Speak: introducing yourself',
  intro: 'Introduce yourself in Spanish — listen and repeat.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚑E6 Questions open upside down',
      text: '¿Cómo te llamas? — written Spanish opens questions with ¿ '
          'and the voice rises differently. Listen for the melody.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Hello! How are you?', answer: '¡Hola! ¿Cómo estás?'),
    CourseItem(prompt: 'My name is Emma.', answer: 'Me llamo Emma.'),
    CourseItem(prompt: 'I am from England.', answer: 'Soy de Inglaterra.'),
    CourseItem(prompt: 'I am a student.', answer: 'Soy estudiante.'),
    CourseItem(prompt: 'What is your name?', answer: '¿Cómo te llamas?'),
    CourseItem(prompt: 'Nice to meet you.', answer: 'Mucho gusto.'),
    CourseItem(prompt: 'Very well, thank you.', answer: 'Muy bien, gracias.'),
    CourseItem(prompt: 'Where are you from?', answer: '¿De dónde eres?'),
  ],
);

final QuizContent enEsA11Numbers = enEsVocab(
  id: 'en_es_a1_1_numbers',
  title: 'Numbers 0–20 · Números',
  intro: 'The numbers 0 to 20 — the building blocks of every price, age '
      'and phone number.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: 'The teens with accents',
      text: 'dieciséis, veintidós carry written accents (⚑E5). And note '
          'the pattern break: once, doce, trece, catorce, quince — then '
          'dieciséis.',
    ),
  ],
  pairs: const [
    MapEntry('zero', 'cero'),
    MapEntry('one', 'uno'),
    MapEntry('two', 'dos'),
    MapEntry('three', 'tres'),
    MapEntry('four', 'cuatro'),
    MapEntry('five', 'cinco'),
    MapEntry('six', 'seis'),
    MapEntry('seven', 'siete'),
    MapEntry('eight', 'ocho'),
    MapEntry('nine', 'nueve'),
    MapEntry('ten', 'diez'),
    MapEntry('eleven', 'once'),
    MapEntry('twelve', 'doce'),
    MapEntry('thirteen', 'trece'),
    MapEntry('fourteen', 'catorce'),
    MapEntry('fifteen', 'quince'),
    MapEntry('sixteen', 'dieciséis'),
    MapEntry('seventeen', 'diecisiete'),
    MapEntry('eighteen', 'dieciocho'),
    MapEntry('nineteen', 'diecinueve'),
    MapEntry('twenty', 'veinte'),
  ],
);

final QuizContent enEsA11Plural = enEsFill(
  id: 'en_es_a1_1_plural',
  title: 'Plurals and los / las',
  intro: 'Plural: add -s after a vowel, -es after a consonant. The '
      'articles go plural too: el→los, la→las — everything agrees.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: '⚑E7 Agreement is a chain',
      text: 'la casa blanca → las casas blancas: article, noun AND '
          'adjective all change together. One plural, three -s.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'the books', answer: '**los** libros'),
    CourseItem(prompt: 'the tables', answer: '**las** mesas'),
    CourseItem(prompt: 'the cities', answer: '**las** ciudades'),
    CourseItem(prompt: 'the teachers (m.)', answer: '**los** profesores'),
    CourseItem(prompt: 'two coffees', answer: 'dos **cafés**'),
    CourseItem(prompt: 'the flowers (flor)', answer: 'las **flores**'),
    CourseItem(prompt: 'the white houses', answer: 'las casas **blancas**'),
    CourseItem(prompt: 'the red cars', answer: 'los coches **rojos**'),
    CourseItem(prompt: 'three days', answer: 'tres **días**'),
    CourseItem(prompt: 'the young women (joven)', answer: 'las mujeres **jóvenes**'),
    CourseItem(prompt: 'the big books', answer: 'los libros **grandes**'),
    CourseItem(prompt: 'the hotels', answer: 'los **hoteles**'),
    CourseItem(prompt: 'the small girls', answer: 'las niñas **pequeñas**'),
    CourseItem(prompt: 'the good friends (m.)', answer: 'los **buenos** amigos'),
    CourseItem(prompt: 'the Spanish classes (la clase)', answer: '**las** clases de español'),
  ],
);

final QuizContent enEsA11ListenMeet = enEsListen(
  id: 'en_es_a1_1_listen_meet',
  title: 'Listening: Mucho gusto',
  passageTitle: 'Conoce a Daniel',
  passage:
      '¡Hola! Me llamo Daniel. Soy de Toronto, en Canadá. Tengo '
      'veintinueve años y trabajo con computadoras. Ahora vivo en la '
      'Ciudad de México. Me gusta la música y el café mexicano. ¡Mucho '
      'gusto! ¿Y tú? ¿Cómo te llamas?',
  passageTranslation:
      "Hi! My name is Daniel. I'm from Toronto, in Canada. I'm twenty-nine "
      "years old and I work with computers. Now I live in Mexico City. I "
      "like music and Mexican coffee. Nice to meet you! And you? What's "
      "your name?",
  intro: 'The text stays hidden — listen first, then answer. Replay as '
      'often as you like.',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'Catch the key words',
      text: 'Listen for de dónde (where from), años (age) and me gusta '
          '(likes). Three anchors answer everything.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'Where is Daniel from?',
      options: ['Mexico City', 'Toronto', 'Madrid'],
      correctIndex: 1,
      questionTranslation: '¿De dónde es Daniel?',
    ),
    ReadingQuestion(
      question: 'How old is he?',
      options: ['19', '29', '39'],
      correctIndex: 1,
      questionTranslation: '¿Cuántos años tiene?',
    ),
    ReadingQuestion(
      question: 'What does he like?',
      options: ['Sport and TV', 'Music and Mexican coffee', 'Books and films'],
      correctIndex: 1,
      questionTranslation: '¿Qué le gusta?',
    ),
  ],
);

final QuizContent enEsA11UnUna = enEsFill(
  id: 'en_es_a1_1_un_una',
  title: 'un / una: a, an',
  intro: 'The indefinite article agrees too: un libro, una mesa. Plural '
      'unos/unas means "some".',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: 'No article with professions',
      text: 'The mirror image of English! Soy médico, es profesora — '
          'Spanish DROPS the article before professions (⚑E26).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'a book', answer: '**un** libro'),
    CourseItem(prompt: 'a table', answer: '**una** mesa'),
    CourseItem(prompt: 'a coffee, please', answer: '**un** café, por favor'),
    CourseItem(prompt: 'a question (la pregunta)', answer: '**una** pregunta'),
    CourseItem(prompt: 'She is a teacher. (no article!)', answer: 'Es **profesora**.'),
    CourseItem(prompt: 'a day (el día)', answer: '**un** día'),
    CourseItem(prompt: 'some friends (m.)', answer: '**unos** amigos'),
    CourseItem(prompt: 'some houses', answer: '**unas** casas'),
    CourseItem(prompt: 'I am a student. (no article!)', answer: 'Soy **estudiante**.'),
    CourseItem(prompt: 'a problem (el problema)', answer: '**un** problema'),
    CourseItem(prompt: 'a city', answer: '**una** ciudad'),
    CourseItem(prompt: 'a hotel', answer: '**un** hotel'),
    CourseItem(prompt: 'He is a doctor. (no article!)', answer: 'Es **médico**.'),
    CourseItem(prompt: 'a white house', answer: '**una** casa blanca'),
    CourseItem(prompt: 'some interesting books', answer: '**unos** libros interesantes'),
  ],
);

final QuizContent enEsA11SpeakingMid = enEsSpeaking(
  id: 'en_es_a1_1_speaking_mid',
  title: 'Conversation: first hello',
  level: 'A1.1',
  topic: 'A very simple first meeting in Spanish: greet me, tell me your '
      'name, where you are from and what you do. Very slow, very basic.',
  practisePoints: [
    'Greetings: hola, buenos días, mucho gusto',
    'ser for identity: soy…, eres…, es…',
    'Numbers and age: tengo … años',
  ],
  scoringCriteria: [
    'ser conjugated for the right person',
    'Clear pure vowels',
    'Basic questions understood and answered',
  ],
  priorityErrors: [
    'English vowel reduction in Spanish words',
    'wrong person of ser',
    'articles with professions',
  ],
  mode: SpeakingMode.conversation,
  session: const SpeakingSession(
    durationMinutes: 3,
    minExchanges: 6,
    minQuestionsPerPoint: 1,
  ),
  intro: 'Mid-module checkpoint: your first Spanish conversation, run in '
      'your own AI assistant. Copy the prompt, use voice mode, then type '
      'the score back here.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Age uses tener',
      text: 'Tengo treinta años — in Spanish you HAVE your years, you '
          'aren\'t them. The number one beginner trap in reverse.',
    ),
  ],
);

final QuizContent enEsA11ReadFamily = enEsRead(
  id: 'en_es_a1_1_read_family',
  title: 'Reading: Mi familia',
  passageTitle: 'Mi familia',
  passage:
      'Esta es mi familia. Me llamo Sofía y soy de Bogotá. Mi padre se '
      'llama Andrés y es ingeniero. Mi madre se llama Carmen y es '
      'profesora. Tengo un hermano pequeño. Se llama Nico y tiene ocho '
      'años. Tenemos un gato blanco. Se llama Luna. Mi familia es '
      'pequeña pero muy alegre.',
  passageTranslation:
      'This is my family. My name is Sofía and I am from Bogotá. My '
      'father is called Andrés and he is an engineer. My mother is called '
      'Carmen and she is a teacher. I have a little brother. His name is '
      'Nico and he is eight years old. We have a white cat. Her name is '
      'Luna. My family is small but very cheerful.',
  intro: 'A short family introduction. Read the Spanish first — the '
      'English translation is behind the info button.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'se llama = is called',
      text: 'Me llamo, se llama — literally "calls himself/herself". '
          'Spanish introduces names reflexively.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '¿De dónde es Sofía?',
      options: ['De Madrid', 'De Bogotá', 'De Lima'],
      correctIndex: 1,
      questionTranslation: 'Where is Sofía from?',
    ),
    ReadingQuestion(
      question: '¿Cuántos años tiene Nico?',
      options: ['Seis', 'Ocho', 'Diez'],
      correctIndex: 1,
      questionTranslation: 'How old is Nico?',
    ),
    ReadingQuestion(
      question: '¿Cómo se llama el gato?',
      options: ['Nico', 'Luna', 'Carmen'],
      correctIndex: 1,
      questionTranslation: 'What is the cat called?',
    ),
  ],
);

final QuizContent enEsA11Hay = enEsFill(
  id: 'en_es_a1_1_hay',
  title: 'hay: there is / there are',
  intro: 'One little word for both "there is" and "there are": hay. Hay '
      'un café · Hay dos cafés — it never changes.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'One form, all amounts',
      text: 'Unlike is/are, hay is invariable: hay un libro, hay muchos '
          'libros. One worry fewer.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'There is a café on the square.', answer: '**Hay** un café en la plaza.'),
    CourseItem(prompt: 'There are two beds in the room.', answer: '**Hay** dos camas en la habitación.'),
    CourseItem(prompt: 'Is there a supermarket near here?', answer: '¿**Hay** un supermercado cerca?'),
    CourseItem(prompt: 'There is no milk.', answer: 'No **hay** leche.'),
    CourseItem(prompt: 'There are many people.', answer: '**Hay** mucha gente.'),
    CourseItem(prompt: 'There is a problem.', answer: '**Hay** un problema.'),
    CourseItem(prompt: 'Are there rooms available? (libre)', answer: '¿**Hay** habitaciones libres?'),
    CourseItem(prompt: 'There is water on the table.', answer: '**Hay** agua en la mesa.'),
    CourseItem(prompt: 'There are three banks on this street.', answer: '**Hay** tres bancos en esta calle.'),
    CourseItem(prompt: 'There is nothing here.', answer: 'No **hay** nada aquí.'),
    CourseItem(prompt: 'There is a party tonight.', answer: '**Hay** una fiesta esta noche.'),
    CourseItem(prompt: 'Is there wifi? ', answer: '¿**Hay** wifi?'),
    CourseItem(prompt: 'There are many museums in the city.', answer: '**Hay** muchos museos en la ciudad.'),
    CourseItem(prompt: 'There is a lot of traffic today.', answer: '**Hay** mucho tráfico hoy.'),
    CourseItem(prompt: 'There is no time.', answer: 'No **hay** tiempo.'),
  ],
);

final QuizContent enEsA11Colours = enEsVocab(
  id: 'en_es_a1_1_colours',
  title: 'Colours & classroom · Colores',
  intro: 'Basic colours and classroom objects. Colours are adjectives, so '
      'they agree: el libro rojo, la mesa roja.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚑E8 Adjective AFTER the noun',
      text: 'el coche rojo — the red car. Spanish puts most adjectives '
          'after the noun, the mirror of English.',
    ),
  ],
  pairs: const [
    MapEntry('red', 'rojo'),
    MapEntry('blue', 'azul'),
    MapEntry('green', 'verde'),
    MapEntry('yellow', 'amarillo'),
    MapEntry('black', 'negro'),
    MapEntry('white', 'blanco'),
    MapEntry('book', 'el libro'),
    MapEntry('pen', 'el bolígrafo'),
    MapEntry('table', 'la mesa'),
    MapEntry('chair', 'la silla'),
  ],
);

final QuizContent enEsA11Dict = enEsDict(
  id: 'en_es_a1_1_dict',
  title: 'Dictation: introductions',
  intro: 'Listen to each Spanish line and type it. Trains your ear for '
      'gender endings and the written accents.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚑E5 Accents are spelling',
      text: 'está, cómo, adiós — the written accent is part of the word. '
          'Missing it is a spelling mistake, so type it.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'My name is Ana.', answer: 'Me llamo Ana.'),
    CourseItem(prompt: 'I am from England.', answer: 'Soy de Inglaterra.'),
    CourseItem(prompt: 'I am a student.', answer: 'Soy estudiante.'),
    CourseItem(prompt: 'I have two brothers.', answer: 'Tengo dos hermanos.'),
    CourseItem(prompt: 'She is a teacher.', answer: 'Ella es profesora.'),
    CourseItem(prompt: 'This is my book.', answer: 'Este es mi libro.'),
    CourseItem(prompt: 'I am twenty years old.', answer: 'Tengo veinte años.'),
    CourseItem(prompt: 'He is a doctor.', answer: 'Él es médico.'),
    CourseItem(prompt: 'We are from Canada.', answer: 'Somos de Canadá.'),
    CourseItem(prompt: 'There is a café on the square.', answer: 'Hay un café en la plaza.'),
    CourseItem(prompt: 'Good morning! How are you?', answer: '¡Buenos días! ¿Cómo estás?'),
    CourseItem(prompt: 'The house is white.', answer: 'La casa es blanca.'),
    CourseItem(prompt: 'We are friends.', answer: 'Somos amigos.'),
    CourseItem(prompt: 'His name is Tomás.', answer: 'Se llama Tomás.'),
    CourseItem(prompt: 'There are many books.', answer: 'Hay muchos libros.'),
  ],
);

final QuizContent enEsA11BigText = enEsBigText(
  id: 'en_es_a1_1_bigtext',
  title: 'Big text: Una nueva amiga',
  passageTitle: 'Una nueva amiga',
  intro: 'A passage with gaps: type the missing form of ser, the article '
      'or hay. Read the whole text first.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'The whole module in one text',
      text: 'ser, el/la/un/una and hay — every gap is one of the module\'s '
          'big rocks. Check the gender of the noun next to each gap.',
    ),
  ],
  template:
      '¡Hola! Me llamo Emma y {{0}} de Leeds. Ahora vivo en Valencia. Mi '
      'apartamento es pequeño, pero {{1}} una terraza con flores. Mi '
      'amiga Sofía {{2}} de Bogotá. Es {{3}} — trabaja en un hospital. '
      'Los dos gatos de Sofía son {{4}}: se llaman Sol y Luna. En mi '
      'calle {{5}} un café con {{6}} mesas azules. El café {{7}} '
      'pequeño, pero el chocolate es muy bueno. Sofía y yo {{8}} buenas '
      'amigas. ¡{{9}} ciudad es fantástica!',
  blanks: [
    inputBlank('soy'),
    inputBlank('hay'),
    inputBlank('es'),
    inputBlank('enfermera', accepted: ['médica', 'doctora']),
    inputBlank('blancos', accepted: ['negros', 'pequeños']),
    inputBlank('hay'),
    inputBlank('unas'),
    inputBlank('es'),
    inputBlank('somos'),
    inputBlank('La'),
  ],
  passageTranslation:
      'Hi! My name is Emma and I am from Leeds. Now I live in Valencia. '
      'My flat is small, but there is a terrace with flowers. My friend '
      'Sofía is from Bogotá. She is a nurse — she works in a hospital. '
      'Sofía\'s two cats are white: they are called Sol and Luna. On my '
      'street there is a café with some blue tables. The café is small, '
      'but the hot chocolate is very good. Sofía and I are good friends. '
      'The city is fantastic!',
);

final QuizContent enEsA11SpeakingClose = enEsSpeaking(
  id: 'en_es_a1_1_speaking_close',
  title: 'Final conversation: who I am',
  level: 'A1.1',
  topic: 'A friendly get-to-know-you interview in Spanish: your name, '
      'age, origin, job, family and favourite colour. Very slow and '
      'simple.',
  practisePoints: [
    'Introducing yourself with ser and llamarse',
    'Age and family with tener',
    'Gender agreement on the nouns you use',
    'Simple questions back: ¿y tú? ¿de dónde eres?',
  ],
  scoringCriteria: [
    'ser and tener used for the right things',
    'Articles and adjectives agree in gender',
    'Pure vowels, no reduction',
  ],
  targetVocabulary: [
    'me llamo', 'soy de', 'tengo … años', 'mi familia', 'mucho gusto',
  ],
  priorityErrors: [
    '"soy veinte años" instead of tengo',
    'article gender mistakes',
    'English schwa in Spanish words',
  ],
  mode: SpeakingMode.interview,
  intro: 'Module A1.1 closer: a simple interview about you, in Spanish, '
      'in your AI assistant. Copy, speak, bring back the score.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Ask for repeats freely',
      text: '"¿Puedes repetir, por favor?" is perfectly A1 — and endlessly '
          'useful.',
    ),
  ],
);

/// A1.1 in chain order (sound / knowledge / listening / reading / dictation
/// interleaved; speaking checkpoint at the midpoint, closing speaking last).
final List<QuizContent> enEsA1_1 = [
  enEsA11Vowels,
  enEsA11Greetings,
  enEsA11Gender,
  enEsA11Ser,
  enEsA11SpeakIntro,
  enEsA11Numbers,
  enEsA11Plural,
  enEsA11ListenMeet,
  enEsA11UnUna,
  enEsA11SpeakingMid,
  enEsA11ReadFamily,
  enEsA11Hay,
  enEsA11Colours,
  enEsA11Dict,
  enEsA11BigText,
  enEsA11SpeakingClose,
];
