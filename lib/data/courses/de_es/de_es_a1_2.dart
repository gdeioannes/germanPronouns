import '../../../models/quiz_content.dart';
import 'de_es_builder.dart';

/// Quest A1.2 — Mi vida diaria (Mein Alltag). Deutsch → Spanisch.

final QuizContent deEsA12Familia = deEsFill(
  id: 'de_es_a1_2_familia',
  title: 'La familia',
  intro: 'Die Familie auf Spanisch.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: 'los padres',
      text: '»los padres« = die Eltern (nicht »die Väter«). Gemischte Gruppe → '
          'maskuliner Plural: los hermanos = die Geschwister.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'der Vater', answer: 'el padre'),
    CourseItem(prompt: 'die Mutter', answer: 'la madre'),
    CourseItem(prompt: 'die Eltern', answer: 'los padres'),
    CourseItem(prompt: 'der Sohn', answer: 'el hijo'),
    CourseItem(prompt: 'die Tochter', answer: 'la hija'),
    CourseItem(prompt: 'der Bruder', answer: 'el hermano'),
    CourseItem(prompt: 'die Schwester', answer: 'la hermana'),
    CourseItem(prompt: 'der Großvater', answer: 'el abuelo'),
    CourseItem(prompt: 'die Großmutter', answer: 'la abuela'),
    CourseItem(prompt: 'der Onkel', answer: 'el tío'),
    CourseItem(prompt: 'die Tante', answer: 'la tía'),
    CourseItem(prompt: 'die Familie', answer: 'la familia'),
  ],
);

final QuizContent deEsA12VerbosErIr = deEsFill(
  id: 'de_es_a1_2_verbos_er_ir',
  title: 'Verbos en -er / -ir',
  intro: 'Regelmäßige Verben auf -er und -ir im Präsens.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Endungen',
      text: '-er: -o/-es/-e/-emos/-éis/-en. -ir fast gleich, nur wir/ihr: '
          '-imos/-ís.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'ich esse (comer)', answer: 'como'),
    CourseItem(prompt: 'du isst', answer: 'comes'),
    CourseItem(prompt: 'er/sie isst', answer: 'come'),
    CourseItem(prompt: 'wir essen', answer: 'comemos'),
    CourseItem(prompt: 'ihr esst', answer: 'coméis'),
    CourseItem(prompt: 'sie essen', answer: 'comen'),
    CourseItem(prompt: 'ich lebe (vivir)', answer: 'vivo'),
    CourseItem(prompt: 'wir leben', answer: 'vivimos'),
    CourseItem(prompt: 'ihr lebt', answer: 'vivís'),
    CourseItem(prompt: 'ich lese (leer)', answer: 'leo'),
    CourseItem(prompt: 'sie schreiben (escribir)', answer: 'escriben'),
  ],
);

final QuizContent deEsA12SerEstar = deEsFill(
  id: 'de_es_a1_2_ser_estar',
  title: '«ser» vs «estar»',
  intro: 'Die zwei spanischen »sein«: ser und estar (Einführung).',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'ser vs estar',
      text: 'Deutsch hat nur »sein«. SER = Identität/Herkunft/Beruf/Eigenschaft. '
          'ESTAR = Ort + (vorübergehender) Zustand. Merke: Wo bist du & wie '
          'fühlst du dich gerade → estar.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Ich bin Lehrer. (Beruf)', answer: 'Soy profesor.'),
    CourseItem(prompt: 'Ich bin müde. (Zustand)', answer: 'Estoy cansado.'),
    CourseItem(prompt: 'Sie ist nett. (Eigenschaft)', answer: 'Es simpática.'),
    CourseItem(prompt: 'Sie ist in Madrid. (Ort)', answer: 'Está en Madrid.'),
    CourseItem(prompt: 'Wir sind aus Deutschland.', answer: 'Somos de Alemania.'),
    CourseItem(prompt: 'Wir sind im Park. (Ort)', answer: 'Estamos en el parque.'),
    CourseItem(prompt: 'Es ist Montag.', answer: 'Es lunes.'),
    CourseItem(prompt: 'Das Haus ist groß.', answer: 'La casa es grande.'),
    CourseItem(prompt: 'Das Essen ist kalt. (Zustand)', answer: 'La comida está fría.'),
    CourseItem(prompt: 'Er ist Spanier.', answer: 'Es español.'),
    CourseItem(prompt: 'Sie sind (gerade) glücklich.', answer: 'Están contentos.'),
  ],
);

final QuizContent deEsA12SprechenFamilia = deEsSpeak(
  id: 'de_es_a1_2_sprechen_familia',
  title: 'Hablar: mi familia',
  intro: 'Über die Familie sprechen – hören und nachsprechen.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'mi / mis',
      text: '»mi« (Singular) / »mis« (Plural): mi hermano, mis padres.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Das ist meine Familie.', answer: 'Esta es mi familia.'),
    CourseItem(prompt: 'Ich habe einen Bruder und eine Schwester.', answer: 'Tengo un hermano y una hermana.'),
    CourseItem(prompt: 'Mein Vater heißt Thomas.', answer: 'Mi padre se llama Thomas.'),
    CourseItem(prompt: 'Meine Mutter ist Lehrerin.', answer: 'Mi madre es profesora.'),
    CourseItem(prompt: 'Ich wohne bei meinen Eltern.', answer: 'Vivo con mis padres.'),
    CourseItem(prompt: 'Mein Bruder ist 15.', answer: 'Mi hermano tiene quince años.'),
    CourseItem(prompt: 'Ich habe keine Kinder.', answer: 'No tengo hijos.'),
  ],
);

final QuizContent deEsA12Tener = deEsFill(
  id: 'de_es_a1_2_tener',
  title: '«tener» y la edad',
  intro: 'Das Verb »tener« (haben) und das Alter.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'tener',
      text: 'Alter, Hunger, Durst, Angst → mit tener, nicht »sein«: »tengo 25 '
          'años«. Unregelmäßig: e→ie (tienes, tiene, tienen).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'ich habe (tener)', answer: 'tengo'),
    CourseItem(prompt: 'du hast', answer: 'tienes'),
    CourseItem(prompt: 'er/sie hat', answer: 'tiene'),
    CourseItem(prompt: 'wir haben', answer: 'tenemos'),
    CourseItem(prompt: 'ihr habt', answer: 'tenéis'),
    CourseItem(prompt: 'sie haben', answer: 'tienen'),
    CourseItem(prompt: 'Ich bin 25 Jahre alt.', answer: 'Tengo veinticinco años.'),
    CourseItem(prompt: 'Wie alt bist du?', answer: '¿Cuántos años tienes?'),
    CourseItem(prompt: 'Ich habe Hunger.', answer: 'Tengo hambre.'),
    CourseItem(prompt: 'Ich habe einen Bruder.', answer: 'Tengo un hermano.'),
  ],
);

final QuizContent deEsA12Gustar = deEsFill(
  id: 'de_es_a1_2_gustar',
  title: 'Me gusta / «gustar»',
  intro: 'Vorlieben mit »gustar« ausdrücken.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'gustar',
      text: '»gustar« heißt »gefallen«, nicht »mögen«. Das Gemochte ist das '
          'Subjekt → Plural: »me gustAN las tapas« (»mir gefallen die Tapas«).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Mir gefällt der Kaffee.', answer: 'Me gusta el café.'),
    CourseItem(prompt: 'Dir gefällt …', answer: 'Te gusta ...'),
    CourseItem(prompt: 'Ihm/Ihr gefällt …', answer: 'Le gusta ...'),
    CourseItem(prompt: 'Uns gefällt …', answer: 'Nos gusta ...'),
    CourseItem(prompt: 'Euch gefällt …', answer: 'Os gusta ...'),
    CourseItem(prompt: 'Ihnen gefällt …', answer: 'Les gusta ...'),
    CourseItem(prompt: 'Ich mag die Tapas. (Plural)', answer: 'Me gustan las tapas.'),
    CourseItem(prompt: 'Ich reise gern.', answer: 'Me gusta viajar.'),
    CourseItem(prompt: 'Magst du Fußball?', answer: '¿Te gusta el fútbol?'),
    CourseItem(prompt: 'Mir gefällt es nicht.', answer: 'No me gusta.'),
    CourseItem(prompt: 'Mir gefällt es sehr.', answer: 'Me gusta mucho.'),
  ],
);

final QuizContent deEsA12LesenFamilia = deEsRead(
  id: 'de_es_a1_2_lesen_familia',
  title: 'Leer: Un día con la familia García',
  passageTitle: 'Un día con la familia García',
  passage:
      'La familia García vive en Sevilla. El padre, Antonio, es médico y la '
      'madre, Carmen, es profesora. Tienen dos hijos: Pablo, de diez años, y '
      'Lucía, de ocho. Por la mañana, los niños van al colegio y los padres '
      'trabajan. Por la tarde, toda la familia come junta. A Lucía le gusta '
      'mucho el chocolate, pero a Pablo le gustan más las galletas. Los fines '
      'de semana van al parque o visitan a los abuelos.',
  passageTranslation:
      'Familie García wohnt in Sevilla. Der Vater, Antonio, ist Arzt und die '
      'Mutter, Carmen, ist Lehrerin. Sie haben zwei Kinder: Pablo, 10 Jahre, '
      'und Lucía, 8. Morgens gehen die Kinder zur Schule und die Eltern '
      'arbeiten. Nachmittags isst die ganze Familie zusammen. Lucía mag '
      'Schokolade sehr, aber Pablo mag Kekse lieber. Am Wochenende gehen sie in '
      'den Park oder besuchen die Großeltern.',
  intro: 'Lies über einen Tag mit der Familie García.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'por la mañana',
      text: 'Tageszeiten mit »por«: por la mañana / por la tarde.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '¿Dónde vive la familia?',
      options: ['Madrid', 'Sevilla', 'Valencia'],
      correctIndex: 1,
      questionTranslation: 'Wo wohnt die Familie?',
    ),
    ReadingQuestion(
      question: '¿Qué hace Carmen?',
      options: ['Es médica', 'Es profesora', 'Es cocinera'],
      correctIndex: 1,
      questionTranslation: 'Was macht Carmen?',
    ),
    ReadingQuestion(
      question: '¿Qué le gusta a Lucía?',
      options: ['El chocolate', 'Las galletas', 'La fruta'],
      correctIndex: 0,
      questionTranslation: 'Was mag Lucía?',
    ),
    ReadingQuestion(
      question: '¿Qué hacen los fines de semana?',
      options: ['Trabajan', 'Van al colegio', 'Van al parque'],
      correctIndex: 2,
      questionTranslation: 'Was machen sie am Wochenende?',
    ),
  ],
);

final QuizContent deEsA12Comida = deEsFill(
  id: 'de_es_a1_2_comida',
  title: 'La comida y la bebida',
  intro: 'Essen und Trinken.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: 'Falsche Freunde',
      text: '»la cerveza« = das Bier (feminin!). »la carne« = Fleisch, nicht '
          '»Karneval«.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'das Brot', answer: 'el pan'),
    CourseItem(prompt: 'das Wasser', answer: 'el agua'),
    CourseItem(prompt: 'die Milch', answer: 'la leche'),
    CourseItem(prompt: 'der Kaffee', answer: 'el café'),
    CourseItem(prompt: 'der Wein', answer: 'el vino'),
    CourseItem(prompt: 'das Bier', answer: 'la cerveza'),
    CourseItem(prompt: 'das Fleisch', answer: 'la carne'),
    CourseItem(prompt: 'der Fisch', answer: 'el pescado'),
    CourseItem(prompt: 'das Obst', answer: 'la fruta'),
    CourseItem(prompt: 'das Gemüse', answer: 'la verdura'),
    CourseItem(prompt: 'der Käse', answer: 'el queso'),
    CourseItem(prompt: 'das Frühstück', answer: 'el desayuno'),
  ],
);

final QuizContent deEsA12Hora = deEsFill(
  id: 'de_es_a1_2_hora',
  title: 'La hora y los días',
  intro: 'Uhrzeit und Wochentage.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: 'una vs las',
      text: 'Wochentage klein (lunes). »Es la una« (1 Uhr, Singular) vs. »Son '
          'las …« (alle anderen).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Wie spät ist es?', answer: '¿Qué hora es?'),
    CourseItem(prompt: 'Es ist ein Uhr.', answer: 'Es la una.'),
    CourseItem(prompt: 'Es ist drei Uhr.', answer: 'Son las tres.'),
    CourseItem(prompt: 'Es ist halb fünf.', answer: 'Son las cuatro y media.'),
    CourseItem(prompt: 'Es ist Viertel nach zwei.', answer: 'Son las dos y cuarto.'),
    CourseItem(prompt: 'Es ist Viertel vor neun.', answer: 'Son las nueve menos cuarto.'),
    CourseItem(prompt: 'Montag', answer: 'lunes'),
    CourseItem(prompt: 'Dienstag', answer: 'martes'),
    CourseItem(prompt: 'Mittwoch', answer: 'miércoles'),
    CourseItem(prompt: 'Donnerstag', answer: 'jueves'),
    CourseItem(prompt: 'Freitag', answer: 'viernes'),
    CourseItem(prompt: 'Samstag', answer: 'sábado'),
    CourseItem(prompt: 'Sonntag', answer: 'domingo'),
    CourseItem(prompt: 'das Wochenende', answer: 'el fin de semana'),
  ],
);

final QuizContent deEsA12SprechenRestaurante = deEsSpeak(
  id: 'de_es_a1_2_sprechen_restaurante',
  title: 'Hablar: en el restaurante',
  intro: 'Im Restaurant bestellen – hören und nachsprechen.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: 'la carta',
      text: '»la carta« = Speisekarte (und »Brief«!) – nicht die (Spiel-)Karte.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Einen Tisch für zwei, bitte.', answer: 'Una mesa para dos, por favor.'),
    CourseItem(prompt: 'Die Speisekarte, bitte.', answer: 'La carta, por favor.'),
    CourseItem(prompt: 'Was empfehlen Sie?', answer: '¿Qué me recomienda?'),
    CourseItem(prompt: 'Als Vorspeise einen Salat.', answer: 'De primero, una ensalada.'),
    CourseItem(prompt: 'Für mich den Fisch.', answer: 'Para mí, el pescado.'),
    CourseItem(prompt: 'Zu trinken Wasser, bitte.', answer: 'Para beber, agua, por favor.'),
    CourseItem(prompt: 'Die Rechnung, bitte.', answer: 'La cuenta, por favor.'),
  ],
);

final QuizContent deEsA12Posesivos = deEsFill(
  id: 'de_es_a1_2_posesivos',
  title: 'Posesivos (mi/tu/su)',
  intro: 'Besitzanzeigende Begleiter.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Anpassung',
      text: 'Possessiv richtet sich nach dem Besitz, nicht dem Besitzer: mis '
          'libros. »su« = sein/ihr/Ihr (mehrdeutig).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'mein Buch', answer: 'mi libro'),
    CourseItem(prompt: 'meine Bücher', answer: 'mis libros'),
    CourseItem(prompt: 'dein Haus', answer: 'tu casa'),
    CourseItem(prompt: 'deine Eltern', answer: 'tus padres'),
    CourseItem(prompt: 'sein/ihr Auto', answer: 'su coche'),
    CourseItem(prompt: 'seine/ihre Freunde', answer: 'sus amigos'),
    CourseItem(prompt: 'unser Haus', answer: 'nuestra casa'),
    CourseItem(prompt: 'unsere Kinder', answer: 'nuestros hijos'),
    CourseItem(prompt: 'euer Auto', answer: 'vuestro coche'),
    CourseItem(prompt: 'ihr Haus (von ihnen)', answer: 'su casa'),
  ],
);

final QuizContent deEsA12IrA = deEsFill(
  id: 'de_es_a1_2_ir_a',
  title: '«ir a» + infinitivo',
  intro: 'Die nahe Zukunft mit »ir a« + Infinitiv.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'futuro próximo',
      text: 'Nahe Zukunft = ir + a + Infinitiv (wie engl. »going to«): »voy a '
          'comer« = ich werde gleich essen.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'ich gehe (ir)', answer: 'voy'),
    CourseItem(prompt: 'du gehst', answer: 'vas'),
    CourseItem(prompt: 'er/sie geht', answer: 'va'),
    CourseItem(prompt: 'wir gehen', answer: 'vamos'),
    CourseItem(prompt: 'ihr geht', answer: 'vais'),
    CourseItem(prompt: 'sie gehen', answer: 'van'),
    CourseItem(prompt: 'Ich werde Spanisch lernen.', answer: 'Voy a aprender español.'),
    CourseItem(prompt: 'Wir werden nach Madrid reisen.', answer: 'Vamos a viajar a Madrid.'),
    CourseItem(prompt: 'Was wirst du machen?', answer: '¿Qué vas a hacer?'),
    CourseItem(prompt: 'Sie werden essen.', answer: 'Van a comer.'),
  ],
);

final QuizContent deEsA12LesenMercado = deEsRead(
  id: 'de_es_a1_2_lesen_mercado',
  title: 'Leer: En el mercado',
  passageTitle: 'En el mercado',
  passage:
      'Es sábado por la mañana y Anna va al mercado de San Miguel. Quiere '
      'comprar fruta y verdura para la semana. —Buenos días, ¿qué desea? '
      '—pregunta el vendedor. —Un kilo de manzanas y medio kilo de tomates, '
      'por favor. —Son cuatro euros. ¿Algo más? —No, gracias. ¿Cuánto es todo? '
      '—Cuatro euros con cincuenta. Anna paga y vuelve a casa contenta.',
  passageTranslation:
      'Es ist Samstagmorgen und Anna geht zum Markt von San Miguel. Sie will '
      'Obst und Gemüse für die Woche kaufen. —Guten Tag, was darf es sein? '
      '—fragt der Verkäufer. —Ein Kilo Äpfel und ein halbes Kilo Tomaten, '
      'bitte. —Das sind vier Euro. Sonst noch etwas? —Nein, danke. Was macht '
      'das zusammen? —Vier Euro fünfzig. Anna zahlt und geht zufrieden nach '
      'Hause.',
  intro: 'Lies eine kurze Markt-Szene.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Preise',
      text: '»cuatro euros con cincuenta« = 4,50 €. »¿qué desea?« = höfliche '
          'Frage im Laden.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '¿Qué día es?',
      options: ['Domingo', 'Sábado', 'Lunes'],
      correctIndex: 1,
      questionTranslation: 'Welcher Tag ist es?',
    ),
    ReadingQuestion(
      question: '¿Qué compra Anna?',
      options: ['Carne y pan', 'Fruta y verdura', 'Pescado'],
      correctIndex: 1,
      questionTranslation: 'Was kauft Anna?',
    ),
    ReadingQuestion(
      question: '¿Cuánto paga en total?',
      options: ['4 €', '4,50 €', '5 €'],
      correctIndex: 1,
      questionTranslation: 'Wie viel zahlt sie insgesamt?',
    ),
    ReadingQuestion(
      question: '¿Cómo vuelve a casa?',
      options: ['Triste', 'Cansada', 'Contenta'],
      correctIndex: 2,
      questionTranslation: 'Wie geht sie nach Hause?',
    ),
  ],
);

final QuizContent deEsA12SprechenRutina = deEsSpeak(
  id: 'de_es_a1_2_sprechen_rutina',
  title: 'Hablar: mi rutina diaria',
  intro: 'Den Tagesablauf beschreiben – hören und nachsprechen.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Reflexive Verben',
      text: 'Tagesablauf mit reflexiven Verben: me levanto (aufstehen), me '
          'acuesto (ins Bett gehen).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Ich stehe um 7 auf.', answer: 'Me levanto a las siete.'),
    CourseItem(prompt: 'Ich frühstücke zu Hause.', answer: 'Desayuno en casa.'),
    CourseItem(prompt: 'Ich fahre mit der U-Bahn zur Arbeit.', answer: 'Voy al trabajo en metro.'),
    CourseItem(prompt: 'Ich esse um 2 zu Mittag.', answer: 'Como a las dos.'),
    CourseItem(prompt: 'Nachmittags lerne ich Spanisch.', answer: 'Por la tarde estudio español.'),
    CourseItem(prompt: 'Ich esse mit meiner Familie zu Abend.', answer: 'Ceno con mi familia.'),
    CourseItem(prompt: 'Ich gehe um 11 ins Bett.', answer: 'Me acuesto a las once.'),
  ],
);

final QuizContent deEsA12LesenCasa = deEsRead(
  id: 'de_es_a1_2_lesen_casa',
  title: 'Leer: La casa de Anna',
  passageTitle: 'La casa de Anna',
  passage:
      'Anna vive en un piso pequeño en el centro de Madrid. El piso tiene dos '
      'habitaciones, una cocina, un baño y un salón. En el salón hay un sofá, '
      'una mesa y muchos libros. La habitación de Anna es pequeña, pero tiene '
      'una ventana grande con mucha luz. No hay jardín, pero hay un balcón con '
      'plantas. A Anna le gusta su piso porque está cerca de la universidad.',
  passageTranslation:
      'Anna wohnt in einer kleinen Wohnung im Zentrum von Madrid. Die Wohnung '
      'hat zwei Zimmer, eine Küche, ein Bad und ein Wohnzimmer. Im Wohnzimmer '
      'gibt es ein Sofa, einen Tisch und viele Bücher. Annas Zimmer ist klein, '
      'hat aber ein großes Fenster mit viel Licht. Es gibt keinen Garten, aber '
      'einen Balkon mit Pflanzen. Anna mag ihre Wohnung, weil sie nah an der '
      'Uni liegt.',
  intro: 'Lies eine Beschreibung von Annas Wohnung.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'hay vs está',
      text: '»hay« = es gibt (Existenz) ↔ »está« = Lage. »No hay jardín, pero '
          'hay un balcón.«',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '¿Dónde está el piso?',
      options: ['A las afueras', 'En el centro de Madrid', 'En Valencia'],
      correctIndex: 1,
      questionTranslation: 'Wo liegt die Wohnung?',
    ),
    ReadingQuestion(
      question: '¿Cuántas habitaciones tiene?',
      options: ['Una', 'Dos', 'Tres'],
      correctIndex: 1,
      questionTranslation: 'Wie viele Zimmer hat sie?',
    ),
    ReadingQuestion(
      question: '¿Qué hay en el balcón?',
      options: ['Un sofá', 'Plantas', 'Una mesa'],
      correctIndex: 1,
      questionTranslation: 'Was gibt es auf dem Balkon?',
    ),
    ReadingQuestion(
      question: '¿Por qué le gusta a Anna?',
      options: ['Es grande', 'Tiene jardín', 'Está cerca de la universidad'],
      correctIndex: 2,
      questionTranslation: 'Warum gefällt sie Anna?',
    ),
  ],
);

/// Quest A1.2 in chain order.
final List<QuizContent> deEsA1_2 = [
  deEsA12Familia,
  deEsA12VerbosErIr,
  deEsA12SerEstar,
  deEsA12SprechenFamilia,
  deEsA12Tener,
  deEsA12Gustar,
  deEsA12LesenFamilia,
  deEsA12Comida,
  deEsA12Hora,
  deEsA12SprechenRestaurante,
  deEsA12Posesivos,
  deEsA12IrA,
  deEsA12LesenMercado,
  deEsA12SprechenRutina,
  deEsA12LesenCasa,
];
