import '../../../models/quiz_content.dart';
import 'de_es_builder.dart';

/// Quest A2.1 — Experiencias (Erlebnisse). Deutsch → Spanisch.

final QuizContent deEsA21Ciudad = deEsFill(
  id: 'de_es_a2_1_ciudad',
  title: 'La ciudad y los lugares',
  intro: 'Orte in der Stadt.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: 'Doppeldeutig',
      text: '»el banco« = Geldbank UND Sitzbank. »la estación« = Bahnhof UND '
          'Jahreszeit.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'die Stadt', answer: 'la ciudad'),
    CourseItem(prompt: 'die Straße', answer: 'la calle'),
    CourseItem(prompt: 'der Platz', answer: 'la plaza'),
    CourseItem(prompt: 'das Geschäft / der Laden', answer: 'la tienda'),
    CourseItem(prompt: 'der Supermarkt', answer: 'el supermercado'),
    CourseItem(prompt: 'die Bank', answer: 'el banco'),
    CourseItem(prompt: 'die Apotheke', answer: 'la farmacia'),
    CourseItem(prompt: 'das Krankenhaus', answer: 'el hospital'),
    CourseItem(prompt: 'der Bahnhof', answer: 'la estación'),
    CourseItem(prompt: 'die Kirche', answer: 'la iglesia'),
    CourseItem(prompt: 'das Museum', answer: 'el museo'),
    CourseItem(prompt: 'das Rathaus', answer: 'el ayuntamiento'),
  ],
);

final QuizContent deEsA21Perfecto = deEsFill(
  id: 'de_es_a2_1_perfecto',
  title: 'Pretérito perfecto',
  intro: 'Das Perfekt (haber + Partizip), für »heute/schon/diese Woche«.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'haber + Partizip',
      text: 'haber (he/has/ha/hemos/habéis/han) + Partizip (-ado/-ido). '
          'Unregelmäßig: hecho, visto, dicho, escrito.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'ich habe gesprochen (hablar)', answer: 'he hablado'),
    CourseItem(prompt: 'du hast gegessen (comer)', answer: 'has comido'),
    CourseItem(prompt: 'er/sie hat gelebt (vivir)', answer: 'ha vivido'),
    CourseItem(prompt: 'wir haben gearbeitet', answer: 'hemos trabajado'),
    CourseItem(prompt: 'ihr habt gereist', answer: 'habéis viajado'),
    CourseItem(prompt: 'sie haben gelernt', answer: 'han aprendido'),
    CourseItem(prompt: 'Heute habe ich viel gemacht.', answer: 'Hoy he hecho mucho.'),
    CourseItem(prompt: 'Hast du schon gegessen?', answer: '¿Ya has comido?'),
    CourseItem(prompt: 'Wir waren nie dort.', answer: 'Nunca hemos estado allí.'),
    CourseItem(prompt: 'Ich habe es gesehen.', answer: 'Lo he visto.'),
    CourseItem(prompt: 'Sie hat es gesagt.', answer: 'Lo ha dicho.'),
    CourseItem(prompt: 'Ich habe es geschrieben.', answer: 'Lo he escrito.'),
  ],
);

final QuizContent deEsA21SprechenHoy = deEsSpeak(
  id: 'de_es_a2_1_sprechen_hoy',
  title: 'Hablar: ¿Qué has hecho hoy?',
  intro: 'Den heutigen Tag erzählen – hören und nachsprechen.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'he ido',
      text: '»ir« → »he ido« (mit haber, nicht »sein«!). Reflexiv: me he '
          'levantado.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Heute bin ich um 7 aufgestanden.', answer: 'Hoy me he levantado a las siete.'),
    CourseItem(prompt: 'Ich habe Kaffee und Toast gefrühstückt.', answer: 'He desayunado café y tostadas.'),
    CourseItem(prompt: 'Ich bin zur Uni gegangen.', answer: 'He ido a la universidad.'),
    CourseItem(prompt: 'Ich habe den ganzen Morgen gelernt.', answer: 'He estudiado toda la mañana.'),
    CourseItem(prompt: 'Ich habe mit einer Freundin gegessen.', answer: 'He comido con una amiga.'),
    CourseItem(prompt: 'Heute Nachmittag habe ich Sport gemacht.', answer: 'Esta tarde he hecho deporte.'),
    CourseItem(prompt: 'Ich habe noch nicht zu Abend gegessen.', answer: 'Todavía no he cenado.'),
  ],
);

final QuizContent deEsA21IndefinidoReg = deEsFill(
  id: 'de_es_a2_1_indefinido_reg',
  title: 'Indefinido: verbos regulares',
  intro: 'Das einfache Vergangenheits-Tempos (regelmäßig), für Abgeschlossenes '
      'mit Zeitpunkt.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Endungen',
      text: '-ar: -é/-aste/-ó/-amos/-asteis/-aron. -er/-ir: '
          '-í/-iste/-ió/-imos/-isteis/-ieron.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'ich sprach (hablar)', answer: 'hablé'),
    CourseItem(prompt: 'du sprachst', answer: 'hablaste'),
    CourseItem(prompt: 'er/sie sprach', answer: 'habló'),
    CourseItem(prompt: 'wir sprachen', answer: 'hablamos'),
    CourseItem(prompt: 'ihr spracht', answer: 'hablasteis'),
    CourseItem(prompt: 'sie sprachen', answer: 'hablaron'),
    CourseItem(prompt: 'ich aß (comer)', answer: 'comí'),
    CourseItem(prompt: 'er lebte (vivir)', answer: 'vivió'),
    CourseItem(prompt: 'wir kauften', answer: 'compramos'),
    CourseItem(prompt: 'sie arbeiteten', answer: 'trabajaron'),
    CourseItem(prompt: 'Gestern arbeitete ich.', answer: 'Ayer trabajé.'),
    CourseItem(prompt: '2019 reisten wir nach Spanien.', answer: 'En 2019 viajamos a España.'),
  ],
);

final QuizContent deEsA21IndefinidoIrreg = deEsFill(
  id: 'de_es_a2_1_indefinido_irreg',
  title: 'Indefinido: irregulares',
  intro: 'Die wichtigsten unregelmäßigen Indefinido-Formen.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: 'fui = war/ging',
      text: '»ser« und »ir« sind im Indefinido identisch: »fui« = ich war / ich '
          'ging (Kontext entscheidet!). Viele ohne Akzent: tuve, hice, vine.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'ich war / ging (ser/ir)', answer: 'fui'),
    CourseItem(prompt: 'du warst / gingst', answer: 'fuiste'),
    CourseItem(prompt: 'er/sie war / ging', answer: 'fue'),
    CourseItem(prompt: 'ich machte (hacer)', answer: 'hice'),
    CourseItem(prompt: 'er machte', answer: 'hizo'),
    CourseItem(prompt: 'wir machten', answer: 'hicimos'),
    CourseItem(prompt: 'ich hatte (tener)', answer: 'tuve'),
    CourseItem(prompt: 'ich war/stand (estar)', answer: 'estuve'),
    CourseItem(prompt: 'ich konnte (poder)', answer: 'pude'),
    CourseItem(prompt: 'ich kam (venir)', answer: 'vine'),
    CourseItem(prompt: 'er gab (dar)', answer: 'dio'),
    CourseItem(prompt: 'er sagte (decir)', answer: 'dijo'),
  ],
);

final QuizContent deEsA21LesenValencia = deEsRead(
  id: 'de_es_a2_1_lesen_valencia',
  title: 'Leer: Un fin de semana en Valencia',
  passageTitle: 'Un fin de semana en Valencia',
  passage:
      'El fin de semana pasado, Anna y sus amigas fueron a Valencia en tren. '
      'Llegaron el sábado por la mañana y dejaron las maletas en el hotel. '
      'Primero visitaron la Ciudad de las Artes y las Ciencias, un edificio muy '
      'moderno. Después comieron una paella enorme cerca de la playa. Por la '
      'tarde pasearon por el centro y compraron algunos recuerdos. El domingo '
      'nadaron en el mar y volvieron a Madrid muy cansadas pero felices.',
  passageTranslation:
      'Letztes Wochenende fuhren Anna und ihre Freundinnen mit dem Zug nach '
      'Valencia. Sie kamen am Samstagmorgen an und ließen die Koffer im Hotel. '
      'Zuerst besuchten sie die Stadt der Künste und Wissenschaften, ein sehr '
      'modernes Gebäude. Danach aßen sie eine riesige Paella in der Nähe des '
      'Strandes. Nachmittags bummelten sie durch das Zentrum und kauften ein '
      'paar Souvenirs. Am Sonntag schwammen sie im Meer und kehrten sehr müde, '
      'aber glücklich nach Madrid zurück.',
  intro: 'Lies einen Reisebericht – komplett im Indefinido.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Erzählzeit',
      text: 'Eine Kette abgeschlossener Handlungen steht im Indefinido (fueron, '
          'visitaron, comieron).',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '¿Cómo fueron a Valencia?',
      options: ['En coche', 'En tren', 'En avión'],
      correctIndex: 1,
      questionTranslation: 'Wie fuhren sie nach Valencia?',
    ),
    ReadingQuestion(
      question: '¿Qué visitaron primero?',
      options: ['La playa', 'La Ciudad de las Artes', 'Un museo'],
      correctIndex: 1,
      questionTranslation: 'Was besuchten sie zuerst?',
    ),
    ReadingQuestion(
      question: '¿Qué comieron?',
      options: ['Tapas', 'Pescado', 'Paella'],
      correctIndex: 2,
      questionTranslation: 'Was aßen sie?',
    ),
    ReadingQuestion(
      question: '¿Qué hicieron el domingo?',
      options: ['Nadaron en el mar', 'Fueron de compras', 'Visitaron un museo'],
      correctIndex: 0,
      questionTranslation: 'Was machten sie am Sonntag?',
    ),
    ReadingQuestion(
      question: '¿Cómo volvieron a Madrid?',
      options: ['Tristes', 'Cansadas pero felices', 'Enfadadas'],
      correctIndex: 1,
      questionTranslation: 'Wie kehrten sie nach Madrid zurück?',
    ),
  ],
);

final QuizContent deEsA21Od = deEsFill(
  id: 'de_es_a2_1_od',
  title: 'Pronombres de OD (lo/la)',
  intro: 'Direkte Objektpronomen (lo/la/los/las).',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Vor dem Verb',
      text: 'Objektpronomen stehen vor dem Verb: »lo compro« (nicht »compro '
          'lo«). lo/la/los/las nach Genus & Zahl.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Ich sehe ihn (den Film).', answer: 'Lo veo.'),
    CourseItem(prompt: 'Ich kaufe es (das Buch).', answer: 'Lo compro.'),
    CourseItem(prompt: 'Ich kenne sie (María).', answer: 'La conozco.'),
    CourseItem(prompt: 'Wir essen sie (die Äpfel).', answer: 'Las comemos.'),
    CourseItem(prompt: 'Siehst du mich?', answer: '¿Me ves?'),
    CourseItem(prompt: 'Ich liebe dich.', answer: 'Te quiero.'),
    CourseItem(prompt: 'Ich rufe euch an.', answer: 'Os llamo.'),
    CourseItem(prompt: 'Ich besuche sie (Plural).', answer: 'Los visito.'),
    CourseItem(prompt: 'Kennst du ihn?', answer: '¿Lo conoces?'),
    CourseItem(prompt: 'Ich nehme es.', answer: 'Lo tomo.'),
  ],
);

final QuizContent deEsA21APersonal = deEsFill(
  id: 'de_es_a2_1_a_personal',
  title: 'La «a» personal',
  intro: 'Das »a« vor Personen als direktem Objekt.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'a + Person',
      text: 'Vor Personen als direktem Objekt steht »a« (im Deutschen nichts!): '
          '»veo A María«. a + el = al. Bei Sachen kein »a«.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Ich sehe Maria.', answer: 'Veo a María.'),
    CourseItem(prompt: 'Ich kenne deinen Bruder.', answer: 'Conozco a tu hermano.'),
    CourseItem(prompt: 'Wir besuchen die Großeltern.', answer: 'Visitamos a los abuelos.'),
    CourseItem(prompt: 'Ich suche den Kellner.', answer: 'Busco al camarero.'),
    CourseItem(prompt: 'Ich sehe den Film. (Sache)', answer: 'Veo la película.'),
    CourseItem(prompt: 'Ich liebe meine Mutter.', answer: 'Quiero a mi madre.'),
    CourseItem(prompt: 'Hörst du den Lehrer?', answer: '¿Escuchas al profesor?'),
    CourseItem(prompt: 'Ich esse einen Apfel. (Sache)', answer: 'Como una manzana.'),
    CourseItem(prompt: 'Sie hilft ihrer Freundin.', answer: 'Ayuda a su amiga.'),
    CourseItem(prompt: 'Ich rufe den Arzt.', answer: 'Llamo al médico.'),
  ],
);

final QuizContent deEsA21Direcciones = deEsFill(
  id: 'de_es_a2_1_direcciones',
  title: 'Transporte y direcciones',
  intro: 'Verkehrsmittel und Wegbeschreibung.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'mit dem Bus',
      text: '»mit dem Bus« = »en autobús«. »el coche« (Spanien) / »el carro« '
          '(Lateinamerika).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'das Auto', answer: 'el coche'),
    CourseItem(prompt: 'der Zug', answer: 'el tren'),
    CourseItem(prompt: 'der Bus', answer: 'el autobús'),
    CourseItem(prompt: 'die U-Bahn', answer: 'el metro'),
    CourseItem(prompt: 'das Fahrrad', answer: 'la bicicleta'),
    CourseItem(prompt: 'das Flugzeug', answer: 'el avión'),
    CourseItem(prompt: 'rechts', answer: 'a la derecha'),
    CourseItem(prompt: 'links', answer: 'a la izquierda'),
    CourseItem(prompt: 'geradeaus', answer: 'todo recto'),
    CourseItem(prompt: 'an der Ecke', answer: 'en la esquina'),
    CourseItem(prompt: 'in der Nähe', answer: 'cerca'),
    CourseItem(prompt: 'weit', answer: 'lejos'),
  ],
);

final QuizContent deEsA21SprechenDirecciones = deEsSpeak(
  id: 'de_es_a2_1_sprechen_direcciones',
  title: 'Hablar: pedir y dar direcciones',
  intro: 'Nach dem Weg fragen und ihn beschreiben.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Höfliche Befehle',
      text: 'Siga, Gire = formelle usted-Befehle (volle Behandlung im Imperativ '
          'B1.1).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Entschuldigung, wo ist der Bahnhof?', answer: 'Perdone, ¿dónde está la estación?'),
    CourseItem(prompt: 'Gibt es hier eine Bank?', answer: '¿Hay un banco por aquí?'),
    CourseItem(prompt: 'Gehen Sie geradeaus.', answer: 'Siga todo recto.'),
    CourseItem(prompt: 'Biegen Sie rechts ab.', answer: 'Gire a la derecha.'),
    CourseItem(prompt: 'Es ist links.', answer: 'Está a la izquierda.'),
    CourseItem(prompt: 'Ganz nah, fünf Minuten.', answer: 'Está muy cerca, a cinco minutos.'),
    CourseItem(prompt: 'Vielen Dank, sehr freundlich.', answer: 'Muchas gracias, muy amable.'),
  ],
);

final QuizContent deEsA21Clima = deEsFill(
  id: 'de_es_a2_1_clima',
  title: 'El tiempo (clima)',
  intro: 'Das Wetter.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'hacer',
      text: 'Wetter meist mit »hacer«: hace frío/calor/sol (»es macht Kälte«). '
          'Aber: está nublado (estar), llueve/nieva (eigene Verben).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Es ist kalt.', answer: 'Hace frío.'),
    CourseItem(prompt: 'Es ist warm/heiß.', answer: 'Hace calor.'),
    CourseItem(prompt: 'Es ist schönes Wetter.', answer: 'Hace buen tiempo.'),
    CourseItem(prompt: 'Es ist sonnig.', answer: 'Hace sol.'),
    CourseItem(prompt: 'Es regnet.', answer: 'Llueve.'),
    CourseItem(prompt: 'Es schneit.', answer: 'Nieva.'),
    CourseItem(prompt: 'Es ist windig.', answer: 'Hace viento.'),
    CourseItem(prompt: 'Es ist bewölkt.', answer: 'Está nublado.'),
    CourseItem(prompt: 'Wie ist das Wetter?', answer: '¿Qué tiempo hace?'),
    CourseItem(prompt: 'Es sind 30 Grad.', answer: 'Hace treinta grados.'),
  ],
);

final QuizContent deEsA21LesenLukas = deEsRead(
  id: 'de_es_a2_1_lesen_lukas',
  title: 'Leer: El viaje de Lukas a Madrid',
  passageTitle: 'El viaje de Lukas a Madrid',
  passage:
      'Lukas es un estudiante de Múnich que pasó un semestre en Madrid. Al '
      'principio, todo le pareció difícil: no entendía bien el acento y la '
      'gente hablaba muy rápido. Los primeros días se perdió varias veces en el '
      'metro. Pero poco a poco hizo amigos españoles y mejoró su español. Le '
      'encantó la vida en la calle: la gente cenaba muy tarde y los bares '
      'estaban llenos hasta la medianoche. Cuando volvió a Alemania, echó de '
      'menos el sol y a sus amigos madrileños.',
  passageTranslation:
      'Lukas ist ein Student aus München, der ein Semester in Madrid '
      'verbrachte. Am Anfang kam ihm alles schwierig vor: Er verstand den '
      'Akzent nicht gut und die Leute sprachen sehr schnell. Die ersten Tage '
      'verlief er sich mehrmals in der U-Bahn. Aber nach und nach fand er '
      'spanische Freunde und verbesserte sein Spanisch. Das Straßenleben '
      'begeisterte ihn: Die Leute aßen sehr spät zu Abend und die Bars waren '
      'bis Mitternacht voll. Als er nach Deutschland zurückkehrte, vermisste er '
      'die Sonne und seine Madrider Freunde.',
  intro: 'Lies über das Auslandssemester eines deutschen Studenten.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'echar de menos',
      text: '»echar de menos« = vermissen. Mischung indefinido (pasó, hizo) + '
          'imperfecto (no entendía, hablaba) – volle Behandlung in A2.2.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '¿De dónde es Lukas?',
      options: ['De Berlín', 'De Múnich', 'De Hamburgo'],
      correctIndex: 1,
      questionTranslation: 'Woher kommt Lukas?',
    ),
    ReadingQuestion(
      question: '¿Qué le resultó difícil al principio?',
      options: ['La comida', 'El acento y la rapidez', 'El metro caro'],
      correctIndex: 1,
      questionTranslation: 'Was war am Anfang schwierig?',
    ),
    ReadingQuestion(
      question: '¿Cómo mejoró su español?',
      options: ['Con clases', 'Haciendo amigos españoles', 'Viendo la tele'],
      correctIndex: 1,
      questionTranslation: 'Wie verbesserte er sein Spanisch?',
    ),
    ReadingQuestion(
      question: '¿Qué le sorprendió de la vida española?',
      options: ['Cenar muy tarde', 'Levantarse pronto', 'El frío'],
      correctIndex: 0,
      questionTranslation: 'Was überraschte ihn am spanischen Leben?',
    ),
    ReadingQuestion(
      question: '¿Qué echó de menos en Alemania?',
      options: ['La comida', 'El sol y sus amigos', 'El metro'],
      correctIndex: 1,
      questionTranslation: 'Was vermisste er in Deutschland?',
    ),
  ],
);

final QuizContent deEsA21PerfVsIndef = deEsFill(
  id: 'de_es_a2_1_perf_vs_indef',
  title: 'perfecto vs indefinido',
  intro: 'Wann Perfekt, wann Indefinido?',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Die Zeitangabe entscheidet',
      text: 'hoy/ya/esta semana/nunca → perfecto · ayer/en 2018/el año pasado → '
          'indefinido. Deutsch nutzt fast immer Perfekt!',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Heute habe ich gearbeitet.', answer: 'Hoy he trabajado.'),
    CourseItem(prompt: 'Gestern habe ich gearbeitet.', answer: 'Ayer trabajé.'),
    CourseItem(prompt: 'Diese Woche bin ich gereist.', answer: 'Esta semana he viajado.'),
    CourseItem(prompt: 'Letztes Jahr reiste ich.', answer: 'El año pasado viajé.'),
    CourseItem(prompt: 'Schon gegessen?', answer: '¿Ya has comido?'),
    CourseItem(prompt: 'Wann hast du gegessen?', answer: '¿Cuándo comiste?'),
    CourseItem(prompt: 'Ich war noch nie in Peru.', answer: 'Nunca he estado en Perú.'),
    CourseItem(prompt: '2018 war ich in Peru.', answer: 'En 2018 estuve en Perú.'),
    CourseItem(prompt: 'Heute Morgen bin ich aufgestanden.', answer: 'Esta mañana me he levantado.'),
    CourseItem(prompt: 'Vorgestern stand ich früh auf.', answer: 'Anteayer me levanté temprano.'),
  ],
);

final QuizContent deEsA21LesenFiesta = deEsRead(
  id: 'de_es_a2_1_lesen_fiesta',
  title: 'Leer: Una fiesta sorpresa',
  passageTitle: 'Una fiesta sorpresa',
  passage:
      'El sábado pasado organizamos una fiesta sorpresa para mi hermana. Por la '
      'mañana compramos comida y bebida, y decoramos el salón con globos. A las '
      'ocho llegaron todos los invitados y se escondieron. Cuando mi hermana '
      'abrió la puerta, todos gritamos «¡Sorpresa!». Ella se puso muy contenta '
      'y casi se echó a llorar. Bailamos y comimos hasta muy tarde. Fue una '
      'noche inolvidable.',
  passageTranslation:
      'Letzten Samstag organisierten wir eine Überraschungsparty für meine '
      'Schwester. Morgens kauften wir Essen und Getränke und schmückten das '
      'Wohnzimmer mit Luftballons. Um acht kamen alle Gäste und versteckten '
      'sich. Als meine Schwester die Tür öffnete, riefen alle »Überraschung!«. '
      'Sie wurde sehr froh und fing fast an zu weinen. Wir tanzten und aßen bis '
      'sehr spät. Es war eine unvergessliche Nacht.',
  intro: 'Lies, wie eine Überraschungsparty ablief.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'se puso contenta',
      text: 'Ereigniskette im Indefinido. »se puso contenta« = wurde froh '
          '(Vorschau verbos de cambio, B2).',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '¿Para quién fue la fiesta?',
      options: ['Para un amigo', 'Para su hermana', 'Para su madre'],
      correctIndex: 1,
      questionTranslation: 'Für wen war die Party?',
    ),
    ReadingQuestion(
      question: '¿Qué compraron por la mañana?',
      options: ['Globos', 'Comida y bebida', 'Regalos'],
      correctIndex: 1,
      questionTranslation: 'Was kauften sie morgens?',
    ),
    ReadingQuestion(
      question: '¿Qué hicieron los invitados al llegar?',
      options: ['Bailaron', 'Se escondieron', 'Cantaron'],
      correctIndex: 1,
      questionTranslation: 'Was machten die Gäste bei der Ankunft?',
    ),
    ReadingQuestion(
      question: '¿Cómo reaccionó la hermana?',
      options: ['Se enfadó', 'Se puso muy contenta', 'Se fue'],
      correctIndex: 1,
      questionTranslation: 'Wie reagierte die Schwester?',
    ),
    ReadingQuestion(
      question: '¿Cómo fue la noche?',
      options: ['Aburrida', 'Corta', 'Inolvidable'],
      correctIndex: 2,
      questionTranslation: 'Wie war die Nacht?',
    ),
  ],
);

final QuizContent deEsA21SprechenHotel = deEsSpeak(
  id: 'de_es_a2_1_sprechen_hotel',
  title: 'Hablar: en el hotel',
  intro: 'Im Hotel einchecken – hören und nachsprechen.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'habitación',
      text: '»habitación doble« (Doppelzimmer) / »individual« (Einzelzimmer). '
          '»dejar la habitación« = auschecken.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Ich habe eine Reservierung auf den Namen Schmidt.', answer: 'Tengo una reserva a nombre de Schmidt.'),
    CourseItem(prompt: 'Haben Sie ein Zimmer frei?', answer: '¿Tienen una habitación libre?'),
    CourseItem(prompt: 'Ein Doppelzimmer für zwei Nächte.', answer: 'Una habitación doble para dos noches.'),
    CourseItem(prompt: 'Ist das Frühstück inbegriffen?', answer: '¿El desayuno está incluido?'),
    CourseItem(prompt: 'Bis wann müssen wir auschecken?', answer: '¿A qué hora hay que dejar la habitación?'),
    CourseItem(prompt: 'Gibt es WLAN in den Zimmern?', answer: '¿Hay wifi en las habitaciones?'),
    CourseItem(prompt: 'Können Sie mir den Schlüssel geben?', answer: '¿Me puede dar la llave, por favor?'),
  ],
);

/// Quest A2.1 in chain order.
final List<QuizContent> deEsA2_1 = [
  deEsA21Ciudad,
  deEsA21Perfecto,
  deEsA21SprechenHoy,
  deEsA21IndefinidoReg,
  deEsA21IndefinidoIrreg,
  deEsA21LesenValencia,
  deEsA21Od,
  deEsA21APersonal,
  deEsA21Direcciones,
  deEsA21SprechenDirecciones,
  deEsA21Clima,
  deEsA21LesenLukas,
  deEsA21PerfVsIndef,
  deEsA21LesenFiesta,
  deEsA21SprechenHotel,
];
