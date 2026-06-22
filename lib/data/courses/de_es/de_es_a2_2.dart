import '../../../models/quiz_content.dart';
import 'de_es_builder.dart';

/// Quest A2.2 — Describir y comparar (Beschreiben). Deutsch → Spanisch.

final QuizContent deEsA22Cuerpo = deEsFill(
  id: 'de_es_a2_2_cuerpo',
  title: 'El cuerpo y la salud',
  intro: 'Körper und Gesundheit.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'me duele',
      text: '»me duele(n)« funktioniert wie gustar – der Körperteil ist Subjekt: '
          '»me duelen los pies«. »la mano« endet auf -o, ist aber feminin!',
    ),
  ],
  items: const [
    CourseItem(prompt: 'der Kopf', answer: 'la cabeza'),
    CourseItem(prompt: 'das Auge', answer: 'el ojo'),
    CourseItem(prompt: 'die Hand', answer: 'la mano'),
    CourseItem(prompt: 'der Arm', answer: 'el brazo'),
    CourseItem(prompt: 'das Bein', answer: 'la pierna'),
    CourseItem(prompt: 'der Fuß', answer: 'el pie'),
    CourseItem(prompt: 'der Rücken', answer: 'la espalda'),
    CourseItem(prompt: 'Mir tut der Kopf weh.', answer: 'Me duele la cabeza.'),
    CourseItem(prompt: 'Ich bin krank.', answer: 'Estoy enfermo.'),
    CourseItem(prompt: 'Ich habe Fieber.', answer: 'Tengo fiebre.'),
    CourseItem(prompt: 'Ich brauche einen Arzt.', answer: 'Necesito un médico.'),
    CourseItem(prompt: 'die Erkältung', answer: 'el resfriado'),
  ],
);

final QuizContent deEsA22Imperfecto = deEsFill(
  id: 'de_es_a2_2_imperfecto',
  title: 'Pretérito imperfecto',
  intro: 'Das »Beschreibungs«-Imperfekt für Gewohnheiten und Kulisse.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Endungen',
      text: '-ar: -aba… · -er/-ir: -ía…. Nur 3 unregelmäßig: era (ser), iba '
          '(ir), veía (ver).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'ich sprach immer (hablar)', answer: 'hablaba'),
    CourseItem(prompt: 'du sprachst', answer: 'hablabas'),
    CourseItem(prompt: 'er/sie sprach', answer: 'hablaba'),
    CourseItem(prompt: 'wir sprachen', answer: 'hablábamos'),
    CourseItem(prompt: 'sie sprachen', answer: 'hablaban'),
    CourseItem(prompt: 'ich aß (comer)', answer: 'comía'),
    CourseItem(prompt: 'ich war (ser)', answer: 'era'),
    CourseItem(prompt: 'es gab (haber)', answer: 'había'),
    CourseItem(prompt: 'ich ging (ir)', answer: 'iba'),
    CourseItem(prompt: 'ich sah (ver)', answer: 'veía'),
    CourseItem(prompt: 'Früher wohnte ich in Berlin.', answer: 'Antes vivía en Berlín.'),
    CourseItem(prompt: 'Als Kind spielte ich Fußball.', answer: 'De niño jugaba al fútbol.'),
  ],
);

final QuizContent deEsA22ImpVsIndef = deEsFill(
  id: 'de_es_a2_2_imp_vs_indef',
  title: 'imperfecto vs indefinido',
  intro: 'Die zentrale Aspekt-Unterscheidung der spanischen Vergangenheit.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Aspekt',
      text: 'IMPERFECTO = Kulisse, Gewohnheit, Beschreibung. INDEFINIDO = das '
          'Ereignis. Deutsch trennt das NICHT – größte Hürde! Was passierte? → '
          'indefinido. Wie war es drumherum? → imperfecto.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Als Kind spielte ich viel.', answer: 'De niño jugaba mucho.'),
    CourseItem(prompt: 'Gestern spielte ich Tennis.', answer: 'Ayer jugué al tenis.'),
    CourseItem(prompt: 'Es war spät und es regnete.', answer: 'Era tarde y llovía.'),
    CourseItem(prompt: 'Plötzlich klingelte das Telefon.', answer: 'De repente sonó el teléfono.'),
    CourseItem(prompt: 'Ich aß, als sie ankam.', answer: 'Comía cuando ella llegó.'),
    CourseItem(prompt: 'Früher gab es kein Internet.', answer: 'Antes no había internet.'),
    CourseItem(prompt: 'Das Haus war groß und alt.', answer: 'La casa era grande y vieja.'),
    CourseItem(prompt: 'Wir lernten uns 2010 kennen.', answer: 'Nos conocimos en 2010.'),
    CourseItem(prompt: 'Jeden Tag stand sie um 6 auf.', answer: 'Cada día se levantaba a las seis.'),
    CourseItem(prompt: 'An jenem Tag stand sie um 5 auf.', answer: 'Aquel día se levantó a las cinco.'),
    CourseItem(prompt: 'Während ich las, kam er herein.', answer: 'Mientras leía, él entró.'),
  ],
);

final QuizContent deEsA22SprechenInfancia = deEsSpeak(
  id: 'de_es_a2_2_sprechen_infancia',
  title: 'Hablar: cuando era niño…',
  intro: 'Über die Kindheit erzählen – hören und nachsprechen.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Erinnerungen',
      text: 'Kindheitserinnerungen stehen im imperfecto. »íbamos« (ir, '
          'unregelmäßig).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Als Kind wohnte ich in einem Dorf.', answer: 'Cuando era niño, vivía en un pueblo.'),
    CourseItem(prompt: 'Meine Oma kochte sehr gut.', answer: 'Mi abuela cocinaba muy bien.'),
    CourseItem(prompt: 'Jeden Sommer fuhren wir ans Meer.', answer: 'Todos los veranos íbamos a la playa.'),
    CourseItem(prompt: 'Ich spielte Fußball mit Freunden.', answer: 'Jugaba al fútbol con mis amigos.'),
    CourseItem(prompt: 'Damals gab es keine Handys.', answer: 'No había móviles entonces.'),
    CourseItem(prompt: 'Meine Schule war klein.', answer: 'Mi escuela era pequeña.'),
    CourseItem(prompt: 'Ich las sehr gern.', answer: 'Me gustaba mucho leer.'),
  ],
);

final QuizContent deEsA22Comparativos = deEsFill(
  id: 'de_es_a2_2_comparativos',
  title: 'Comparativos y superlativos',
  intro: 'Vergleichen und steigern.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: '-ísimo',
      text: '»-ísimo« = absoluter Superlativ (»äußerst/sehr«): caro→carísimo. '
          'mejor/peor/mayor/menor sind unregelmäßig (nicht »más bueno«).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'größer als', answer: 'más grande que'),
    CourseItem(prompt: 'kleiner als', answer: 'más pequeño que'),
    CourseItem(prompt: 'weniger teuer als', answer: 'menos caro que'),
    CourseItem(prompt: 'so groß wie', answer: 'tan grande como'),
    CourseItem(prompt: 'besser (als)', answer: 'mejor que'),
    CourseItem(prompt: 'schlechter (als)', answer: 'peor que'),
    CourseItem(prompt: 'älter', answer: 'mayor'),
    CourseItem(prompt: 'jünger', answer: 'menor'),
    CourseItem(prompt: 'der/das größte', answer: 'el más grande'),
    CourseItem(prompt: 'Madrid ist größer als Sevilla.', answer: 'Madrid es más grande que Sevilla.'),
    CourseItem(prompt: 'super lecker', answer: 'riquísimo'),
    CourseItem(prompt: 'wunderschön', answer: 'guapísimo'),
  ],
);

final QuizContent deEsA22LesenInfancia = deEsRead(
  id: 'de_es_a2_2_lesen_infancia',
  title: 'Leer: Mi infancia en un pueblo',
  passageTitle: 'Mi infancia en un pueblo',
  passage:
      'Cuando era pequeña, vivía con mi familia en un pueblo del sur de España. '
      'Nuestra casa era blanca y tenía un patio con flores. Mi padre trabajaba '
      'en el campo y mi madre cuidaba de mis tres hermanos y de mí. No teníamos '
      'mucho dinero, pero éramos felices. En verano, los niños jugábamos en la '
      'calle hasta muy tarde, porque hacía mucho calor. Los domingos, toda la '
      'familia comía en casa de mis abuelos. Echo de menos aquellos años '
      'tranquilos.',
  passageTranslation:
      'Als ich klein war, wohnte ich mit meiner Familie in einem Dorf im Süden '
      'Spaniens. Unser Haus war weiß und hatte einen Innenhof mit Blumen. Mein '
      'Vater arbeitete auf dem Feld und meine Mutter kümmerte sich um meine '
      'drei Geschwister und mich. Wir hatten nicht viel Geld, aber wir waren '
      'glücklich. Im Sommer spielten wir Kinder bis sehr spät auf der Straße, '
      'weil es sehr heiß war. Sonntags aß die ganze Familie bei meinen '
      'Großeltern. Ich vermisse jene ruhigen Jahre.',
  intro: 'Lies eine Kindheitserinnerung – im imperfecto.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Beschreibung',
      text: 'Die ganze Beschreibung steht im imperfecto (era, tenía, jugábamos).',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '¿Dónde vivía la narradora?',
      options: ['En una ciudad', 'En un pueblo', 'En la playa'],
      correctIndex: 1,
      questionTranslation: 'Wo wohnte die Erzählerin?',
    ),
    ReadingQuestion(
      question: '¿Cómo era la casa?',
      options: ['Grande y moderna', 'Blanca con patio', 'Pequeña y oscura'],
      correctIndex: 1,
      questionTranslation: 'Wie war das Haus?',
    ),
    ReadingQuestion(
      question: '¿Dónde trabajaba el padre?',
      options: ['En una oficina', 'En el campo', 'En una tienda'],
      correctIndex: 1,
      questionTranslation: 'Wo arbeitete der Vater?',
    ),
    ReadingQuestion(
      question: '¿Por qué jugaban hasta tarde en verano?',
      options: ['Hacía calor', 'No había escuela', 'Los padres trabajaban'],
      correctIndex: 0,
      questionTranslation: 'Warum spielten sie im Sommer bis spät?',
    ),
    ReadingQuestion(
      question: '¿Qué siente ahora la narradora?',
      options: ['Alegría', 'Nostalgia', 'Enfado'],
      correctIndex: 1,
      questionTranslation: 'Was fühlt die Erzählerin jetzt?',
    ),
  ],
);

final QuizContent deEsA22Oi = deEsFill(
  id: 'de_es_a2_2_oi',
  title: 'Pronombres de OI (le/les)',
  intro: 'Indirekte Objektpronomen (le/les).',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'le → se',
      text: 'Vor lo/la wird le→»se«: »se lo doy« (nicht »le lo«). Oft '
          'verdoppelt: »LE regala flores A su madre«.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Ich gebe ihm das Buch.', answer: 'Le doy el libro.'),
    CourseItem(prompt: 'Ich schreibe ihr eine Mail.', answer: 'Le escribo un correo.'),
    CourseItem(prompt: 'Ich kaufe ihnen Geschenke.', answer: 'Les compro regalos.'),
    CourseItem(prompt: 'Sag mir die Wahrheit.', answer: 'Dime la verdad.'),
    CourseItem(prompt: 'Ich gebe es dir.', answer: 'Te lo doy.'),
    CourseItem(prompt: 'Ich gebe es ihm.', answer: 'Se lo doy.'),
    CourseItem(prompt: 'Gefällt dir das?', answer: '¿Te gusta?'),
    CourseItem(prompt: 'Ich erzähle euch alles.', answer: 'Os cuento todo.'),
    CourseItem(prompt: 'Sie schenkt ihrer Mutter Blumen.', answer: 'Le regala flores a su madre.'),
    CourseItem(prompt: 'Ich frage den Lehrer.', answer: 'Le pregunto al profesor.'),
  ],
);

final QuizContent deEsA22Gerundio = deEsFill(
  id: 'de_es_a2_2_gerundio',
  title: 'estar + gerundio',
  intro: 'Die Verlaufsform (genau jetzt im Gange).',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'genau jetzt',
      text: 'estar + Gerundium (-ando/-iendo) = genau jetzt im Verlauf. NICHT '
          'für die Zukunft nutzen (anders als Englisch)!',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Ich esse gerade.', answer: 'Estoy comiendo.'),
    CourseItem(prompt: 'Was machst du gerade?', answer: '¿Qué estás haciendo?'),
    CourseItem(prompt: 'Er arbeitet gerade.', answer: 'Está trabajando.'),
    CourseItem(prompt: 'Wir lernen gerade Spanisch.', answer: 'Estamos aprendiendo español.'),
    CourseItem(prompt: 'Sie schlafen gerade.', answer: 'Están durmiendo.'),
    CourseItem(prompt: 'Ich lese gerade ein Buch.', answer: 'Estoy leyendo un libro.'),
    CourseItem(prompt: 'Es regnet gerade.', answer: 'Está lloviendo.'),
    CourseItem(prompt: 'Ich war gerade am Kochen.', answer: 'Estaba cocinando.'),
    CourseItem(prompt: 'Sie schreibt gerade.', answer: 'Está escribiendo.'),
    CourseItem(prompt: 'Worüber redest du gerade?', answer: '¿De qué estás hablando?'),
  ],
);

final QuizContent deEsA22Ropa = deEsFill(
  id: 'de_es_a2_2_ropa',
  title: 'La ropa y las compras',
  intro: 'Kleidung und Einkaufen.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: 'abrigo vs mantel',
      text: '»el abrigo« = Mantel · »el mantel« = die Tischdecke! Klassischer '
          'falscher Freund.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'die Kleidung', answer: 'la ropa'),
    CourseItem(prompt: 'das Hemd', answer: 'la camisa'),
    CourseItem(prompt: 'die Hose', answer: 'el pantalón'),
    CourseItem(prompt: 'das Kleid', answer: 'el vestido'),
    CourseItem(prompt: 'die Schuhe', answer: 'los zapatos'),
    CourseItem(prompt: 'die Jacke', answer: 'la chaqueta'),
    CourseItem(prompt: 'der Mantel', answer: 'el abrigo'),
    CourseItem(prompt: 'Welche Größe?', answer: '¿Qué talla?'),
    CourseItem(prompt: 'Wie viel kostet es?', answer: '¿Cuánto cuesta?'),
    CourseItem(prompt: 'zu teuer', answer: 'demasiado caro'),
    CourseItem(prompt: 'im Angebot', answer: 'en oferta'),
    CourseItem(prompt: 'Ich nehme es.', answer: 'Me lo llevo.'),
  ],
);

final QuizContent deEsA22SprechenDescribir = deEsSpeak(
  id: 'de_es_a2_2_sprechen_describir',
  title: 'Hablar: describir a una persona',
  intro: 'Eine Person beschreiben – hören und nachsprechen.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'ser vs estar',
      text: 'SER für bleibende Eigenschaften (es alto, es simpático), ESTAR für '
          'momentane Zustände (está cansado).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Mein bester Freund ist groß und schlank.', answer: 'Mi mejor amigo es alto y delgado.'),
    CourseItem(prompt: 'Er hat braune Haare und grüne Augen.', answer: 'Tiene el pelo castaño y los ojos verdes.'),
    CourseItem(prompt: 'Er ist sehr nett und großzügig.', answer: 'Es muy simpático y generoso.'),
    CourseItem(prompt: 'Heute ist er etwas müde.', answer: 'Hoy está un poco cansado.'),
    CourseItem(prompt: 'Er ist immer gut gelaunt.', answer: 'Siempre está de buen humor.'),
    CourseItem(prompt: 'Er trägt Brille und kurzen Bart.', answer: 'Lleva gafas y barba corta.'),
    CourseItem(prompt: 'Er ähnelt seinem Vater.', answer: 'Se parece a su padre.'),
  ],
);

final QuizContent deEsA22PorPara = deEsFill(
  id: 'de_es_a2_2_por_para',
  title: 'por vs para (introducción)',
  intro: 'Die zwei »für« richtig wählen (Einführung).',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'por / para',
      text: 'PARA = Ziel/Zweck/Empfänger/Frist (»wofür? für wen?«). POR = '
          'Grund/Tausch/Durch/Zeitraum (»warum? wodurch?«).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'ein Geschenk für dich', answer: 'un regalo para ti'),
    CourseItem(prompt: 'Ich lerne, um zu arbeiten.', answer: 'Estudio para trabajar.'),
    CourseItem(prompt: 'Wir fahren nach Madrid. (Ziel)', answer: 'Salimos para Madrid.'),
    CourseItem(prompt: 'bis Montag (Frist)', answer: 'para el lunes'),
    CourseItem(prompt: 'Danke für alles.', answer: 'Gracias por todo.'),
    CourseItem(prompt: 'morgens (Tageszeit)', answer: 'por la mañana'),
    CourseItem(prompt: 'Ich gehe durch den Park.', answer: 'Paso por el parque.'),
    CourseItem(prompt: '100 km pro Stunde', answer: 'cien km por hora'),
    CourseItem(prompt: 'aus Liebe', answer: 'por amor'),
    CourseItem(prompt: 'zweimal pro Woche', answer: 'dos veces por semana'),
    CourseItem(prompt: 'Das ist für meine Mutter.', answer: 'Es para mi madre.'),
    CourseItem(prompt: 'telefonisch', answer: 'por teléfono'),
  ],
);

final QuizContent deEsA22LesenCorreo = deEsRead(
  id: 'de_es_a2_2_lesen_correo',
  title: 'Leer: Un correo a un amigo alemán',
  passageTitle: 'Un correo a un amigo alemán',
  passage:
      '¡Hola, Jonas! ¿Qué tal todo por Berlín? Yo estoy muy bien en Madrid. La '
      'semana pasada empecé un curso de baile y me encanta, aunque soy bastante '
      'torpe. Ayer fui con unos compañeros a un concierto de flamenco; fue '
      'increíble, aunque terminó a las dos de la mañana. Aquí la gente sale '
      'mucho y todo es más tarde que en Alemania. Todavía me cuesta '
      'acostumbrarme, pero cada día hablo mejor español. ¿Por qué no vienes a '
      'visitarme en primavera? Un abrazo, Anna.',
  passageTranslation:
      'Hallo, Jonas! Wie läuft alles in Berlin? Mir geht es sehr gut in Madrid. '
      'Letzte Woche habe ich einen Tanzkurs angefangen und er gefällt mir sehr, '
      'obwohl ich ziemlich ungeschickt bin. Gestern war ich mit ein paar '
      'Kollegen auf einem Flamenco-Konzert; es war unglaublich, obwohl es um '
      'zwei Uhr morgens endete. Hier gehen die Leute viel aus und alles ist '
      'später als in Deutschland. Es fällt mir noch schwer, mich daran zu '
      'gewöhnen, aber jeden Tag spreche ich besser Spanisch. Warum kommst du '
      'mich nicht im Frühling besuchen? Eine Umarmung, Anna.',
  intro: 'Lies eine E-Mail an einen deutschen Freund.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'me cuesta',
      text: '»me cuesta« = es fällt mir schwer. Echter Brief mit Mischung '
          'perfecto/indefinido/imperfecto + por/para.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '¿Dónde está Anna?',
      options: ['En Berlín', 'En Madrid', 'En Sevilla'],
      correctIndex: 1,
      questionTranslation: 'Wo ist Anna?',
    ),
    ReadingQuestion(
      question: '¿Qué curso empezó?',
      options: ['De cocina', 'De baile', 'De idiomas'],
      correctIndex: 1,
      questionTranslation: 'Welchen Kurs hat sie angefangen?',
    ),
    ReadingQuestion(
      question: '¿Cómo fue el concierto de flamenco?',
      options: ['Aburrido', 'Increíble', 'Corto'],
      correctIndex: 1,
      questionTranslation: 'Wie war das Flamenco-Konzert?',
    ),
    ReadingQuestion(
      question: '¿Qué le cuesta a Anna?',
      options: ['El idioma', 'Acostumbrarse al horario', 'La comida'],
      correctIndex: 1,
      questionTranslation: 'Was fällt Anna schwer?',
    ),
    ReadingQuestion(
      question: '¿Qué le propone a Jonas?',
      options: ['Visitarla en primavera', 'Llamarla', 'Escribirle'],
      correctIndex: 0,
      questionTranslation: 'Was schlägt sie Jonas vor?',
    ),
  ],
);

final QuizContent deEsA22Caracter = deEsFill(
  id: 'de_es_a2_2_caracter',
  title: 'Descripción de carácter',
  intro: 'Charaktereigenschaften.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'ser vs estar',
      text: 'Charakter = SER (es tímido). Aktuelle Stimmung = ESTAR (está '
          'nerviosa). Merke für B2: es aburrido (langweilig) ≠ está aburrido '
          '(gelangweilt).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'nett', answer: 'simpático'),
    CourseItem(prompt: 'unsympathisch', answer: 'antipático'),
    CourseItem(prompt: 'lustig', answer: 'gracioso', accepted: ['divertido']),
    CourseItem(prompt: 'ernst', answer: 'serio'),
    CourseItem(prompt: 'schüchtern', answer: 'tímido'),
    CourseItem(prompt: 'fleißig', answer: 'trabajador'),
    CourseItem(prompt: 'faul', answer: 'perezoso', accepted: ['vago']),
    CourseItem(prompt: 'großzügig', answer: 'generoso'),
    CourseItem(prompt: 'ehrlich', answer: 'honesto', accepted: ['sincero']),
    CourseItem(prompt: 'intelligent', answer: 'inteligente'),
    CourseItem(prompt: 'Er ist sehr nett.', answer: 'Es muy simpático.'),
    CourseItem(prompt: 'Heute ist sie nervös.', answer: 'Hoy está nerviosa.'),
  ],
);

final QuizContent deEsA22LesenAntes = deEsRead(
  id: 'de_es_a2_2_lesen_antes',
  title: 'Leer: Antes y ahora',
  passageTitle: 'Antes y ahora',
  passage:
      'Mi abuela siempre dice que la vida antes era muy diferente. Cuando ella '
      'era joven, no había móviles ni internet. La gente escribía cartas y '
      'esperaba semanas por una respuesta. Los niños jugaban en la calle y casi '
      'nadie tenía coche. Hoy todo es más rápido y más cómodo, pero mi abuela '
      'cree que antes la gente tenía más tiempo para hablar y para estar con la '
      'familia. «No todo lo moderno es mejor», dice siempre con una sonrisa.',
  passageTranslation:
      'Meine Oma sagt immer, dass das Leben früher ganz anders war. Als sie '
      'jung war, gab es keine Handys und kein Internet. Die Leute schrieben '
      'Briefe und warteten Wochen auf eine Antwort. Die Kinder spielten auf der '
      'Straße und fast niemand hatte ein Auto. Heute ist alles schneller und '
      'bequemer, aber meine Oma glaubt, dass die Leute früher mehr Zeit zum '
      'Reden und für die Familie hatten. »Nicht alles Moderne ist besser«, sagt '
      'sie immer mit einem Lächeln.',
  intro: 'Lies einen Vergleich von früher und heute.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Kontrast',
      text: 'Imperfecto (era, había, jugaban) für früher ↔ presente (es, hay) '
          'für heute.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'Según la abuela, la vida antes era…',
      options: ['igual', 'muy diferente', 'peor en todo'],
      correctIndex: 1,
      questionTranslation: 'Laut der Oma war das Leben früher…',
    ),
    ReadingQuestion(
      question: '¿Qué no había cuando era joven?',
      options: ['Coches', 'Móviles ni internet', 'Cartas'],
      correctIndex: 1,
      questionTranslation: 'Was gab es nicht, als sie jung war?',
    ),
    ReadingQuestion(
      question: '¿Cómo se comunicaba la gente?',
      options: ['Por teléfono', 'Escribía cartas', 'Por internet'],
      correctIndex: 1,
      questionTranslation: 'Wie kommunizierten die Leute?',
    ),
    ReadingQuestion(
      question: '¿Qué había más antes, según ella?',
      options: ['Dinero', 'Tiempo para la familia', 'Coches'],
      correctIndex: 1,
      questionTranslation: 'Wovon gab es früher mehr?',
    ),
    ReadingQuestion(
      question: '¿Qué opina de lo moderno?',
      options: ['Es siempre mejor', 'No todo es mejor', 'Es malo'],
      correctIndex: 1,
      questionTranslation: 'Was hält sie vom Modernen?',
    ),
  ],
);

final QuizContent deEsA22SprechenMedico = deEsSpeak(
  id: 'de_es_a2_2_sprechen_medico',
  title: 'Hablar: en el médico',
  intro: 'Beim Arzt – hören und nachsprechen.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'me duele',
      text: '»me duele(n)« + Körperteil. »que se mejore« = Subjuntivo-Wunsch '
          '(Vorschau B1.1).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Mir geht es nicht gut.', answer: 'No me encuentro bien.'),
    CourseItem(prompt: 'Mein Hals tut weh.', answer: 'Me duele la garganta.'),
    CourseItem(prompt: 'Ich habe Fieber und Husten.', answer: 'Tengo fiebre y tos.'),
    CourseItem(prompt: 'Seit wann fühlen Sie sich so?', answer: '¿Desde cuándo se siente así?'),
    CourseItem(prompt: 'Nehmen Sie diese Tablette zweimal täglich.', answer: 'Tómese esta pastilla dos veces al día.'),
    CourseItem(prompt: 'Sie sollten sich ausruhen und viel trinken.', answer: 'Debe descansar y beber mucha agua.'),
    CourseItem(prompt: 'Gute Besserung.', answer: 'Que se mejore pronto.'),
  ],
);

/// Quest A2.2 in chain order.
final List<QuizContent> deEsA2_2 = [
  deEsA22Cuerpo,
  deEsA22Imperfecto,
  deEsA22ImpVsIndef,
  deEsA22SprechenInfancia,
  deEsA22Comparativos,
  deEsA22LesenInfancia,
  deEsA22Oi,
  deEsA22Gerundio,
  deEsA22Ropa,
  deEsA22SprechenDescribir,
  deEsA22PorPara,
  deEsA22LesenCorreo,
  deEsA22Caracter,
  deEsA22LesenAntes,
  deEsA22SprechenMedico,
];
