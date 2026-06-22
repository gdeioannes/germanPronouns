import '../../../models/quiz_content.dart';
import 'de_es_builder.dart';

/// Quest B1.1 — Opiniones y deseos (Meinungen). Deutsch → Spanisch.

final QuizContent deEsB11Trabajo = deEsFill(
  id: 'de_es_b1_1_trabajo',
  title: 'El mundo del trabajo',
  intro: 'Die Arbeitswelt.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: 'Falsche Freunde',
      text: '»la oficina« = Büro (nicht »Offizier«). »el gimnasio« = '
          'Fitnessstudio – ein Gymnasium ist »el instituto«.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'die Arbeit', answer: 'el trabajo'),
    CourseItem(prompt: 'das Büro', answer: 'la oficina'),
    CourseItem(prompt: 'die Firma', answer: 'la empresa'),
    CourseItem(prompt: 'der/die Chef/in', answer: 'el jefe', accepted: ['la jefa']),
    CourseItem(prompt: 'der/die Kollege/in', answer: 'el compañero', accepted: ['la compañera']),
    CourseItem(prompt: 'das Gehalt', answer: 'el sueldo', accepted: ['el salario']),
    CourseItem(prompt: 'das Vorstellungsgespräch', answer: 'la entrevista'),
    CourseItem(prompt: 'der Lebenslauf', answer: 'el currículum'),
    CourseItem(prompt: 'die Erfahrung', answer: 'la experiencia'),
    CourseItem(prompt: 'die Besprechung', answer: 'la reunión'),
    CourseItem(prompt: 'Vollzeit', answer: 'a tiempo completo'),
    CourseItem(prompt: 'in Rente gehen', answer: 'jubilarse'),
  ],
);

final QuizContent deEsB11Futuro = deEsFill(
  id: 'de_es_b1_1_futuro',
  title: 'Futuro imperfecto',
  intro: 'Die Zukunft (werden + Infinitiv).',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Endungen',
      text: 'Endung an den ganzen Infinitiv: -é/-ás/-á/-emos/-éis/-án. '
          'Unregelmäßige Stämme: haré, tendré, vendré, diré. Auch für '
          'Vermutungen: ¿quién será?',
    ),
  ],
  items: const [
    CourseItem(prompt: 'ich werde sprechen (hablar)', answer: 'hablaré'),
    CourseItem(prompt: 'du wirst essen', answer: 'comerás'),
    CourseItem(prompt: 'er/sie wird leben', answer: 'vivirá'),
    CourseItem(prompt: 'wir werden reisen', answer: 'viajaremos'),
    CourseItem(prompt: 'sie werden arbeiten', answer: 'trabajarán'),
    CourseItem(prompt: 'Morgen werde ich anrufen.', answer: 'Mañana llamaré.'),
    CourseItem(prompt: 'ich werde machen (hacer)', answer: 'haré'),
    CourseItem(prompt: 'es wird geben (haber)', answer: 'habrá'),
    CourseItem(prompt: 'ich werde haben (tener)', answer: 'tendré'),
    CourseItem(prompt: 'ich werde kommen (venir)', answer: 'vendré'),
    CourseItem(prompt: 'ich werde sagen (decir)', answer: 'diré'),
    CourseItem(prompt: 'Wer mag das sein?', answer: '¿Quién será?'),
  ],
);

final QuizContent deEsB11SprechenPlanes = deEsSpeak(
  id: 'de_es_b1_1_sprechen_planes',
  title: 'Hablar: mis planes de futuro',
  intro: 'Über Zukunftspläne sprechen – hören und nachsprechen.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'me gustaría',
      text: '»me gustaría« (Konditional) = höflicher Wunsch – volle Behandlung '
          'in B1.2.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Nächstes Jahr suche ich Arbeit.', answer: 'El año que viene buscaré trabajo.'),
    CourseItem(prompt: 'Ich will eine Weile in Spanien leben.', answer: 'Quiero vivir en España una temporada.'),
    CourseItem(prompt: 'Ich glaube, ich mache einen Master.', answer: 'Creo que estudiaré un máster.'),
    CourseItem(prompt: 'Ich würde gern im Ausland arbeiten.', answer: 'Me gustaría trabajar en el extranjero.'),
    CourseItem(prompt: 'Eines Tages habe ich meine eigene Firma.', answer: 'Algún día tendré mi propia empresa.'),
    CourseItem(prompt: 'Wenn alles gut geht, spare ich Geld.', answer: 'Si todo va bien, ahorraré dinero.'),
    CourseItem(prompt: 'Ich weiß nicht, was ich danach mache.', answer: 'No sé qué haré después.'),
  ],
);

final QuizContent deEsB11SubjFormas = deEsFill(
  id: 'de_es_b1_1_subj_formas',
  title: 'Presente de subjuntivo: formas',
  intro: 'Die Formen des Subjuntivo bilden.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Gegenvokal',
      text: '-ar-Verben → -e (hable), -er/-ir-Verben → -a (coma, viva). '
          'Unregelmäßige aus der yo-Form: hago→haga, tengo→tenga.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'dass ich spreche (hablar)', answer: 'que hable'),
    CourseItem(prompt: 'dass du sprichst', answer: 'que hables'),
    CourseItem(prompt: 'dass er/sie spricht', answer: 'que hable'),
    CourseItem(prompt: 'dass wir sprechen', answer: 'que hablemos'),
    CourseItem(prompt: 'dass sie sprechen', answer: 'que hablen'),
    CourseItem(prompt: 'dass ich esse (comer)', answer: 'que coma'),
    CourseItem(prompt: 'dass ich lebe (vivir)', answer: 'que viva'),
    CourseItem(prompt: 'dass ich mache (hacer)', answer: 'que haga'),
    CourseItem(prompt: 'dass ich gehe (ir)', answer: 'que vaya'),
    CourseItem(prompt: 'dass ich bin (ser)', answer: 'que sea'),
    CourseItem(prompt: 'dass ich habe (tener)', answer: 'que tenga'),
    CourseItem(prompt: 'dass es gibt (haber)', answer: 'que haya'),
  ],
);

final QuizContent deEsB11SubjDeseos = deEsFill(
  id: 'de_es_b1_1_subj_deseos',
  title: 'Subjuntivo: deseos (querer que, ojalá)',
  intro: 'Wünsche und Willen mit dem Subjuntivo ausdrücken.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Auslöser + que',
      text: 'Wunsch/Wille + »que« + ANDERES Subjekt → Subjuntivo. Deutsch: »Ich '
          'will, dass du kommst« (Indikativ); Spanisch zwingt »que vengas«. '
          'Gleiches Subjekt → Infinitiv: quiero venir.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Ich will, dass du kommst.', answer: 'Quiero que vengas.'),
    CourseItem(prompt: 'Sie will, dass wir lernen.', answer: 'Quiere que estudiemos.'),
    CourseItem(prompt: 'Ich hoffe, dass es dir gut geht.', answer: 'Espero que estés bien.'),
    CourseItem(prompt: 'Hoffentlich regnet es nicht!', answer: '¡Ojalá no llueva!'),
    CourseItem(prompt: 'Ich möchte, dass du mir hilfst.', answer: 'Quiero que me ayudes.'),
    CourseItem(prompt: 'Es ist wichtig, dass du schläfst.', answer: 'Es importante que duermas.'),
    CourseItem(prompt: 'Es ist nötig, dass wir gehen.', answer: 'Es necesario que vayamos.'),
    CourseItem(prompt: 'Ich bitte dich zu warten.', answer: 'Te pido que esperes.'),
    CourseItem(prompt: 'Sie wollen, dass ich bleibe.', answer: 'Quieren que me quede.'),
    CourseItem(prompt: 'Ich will, dass du glücklich bist.', answer: 'Quiero que seas feliz.'),
    CourseItem(prompt: 'Wir hoffen, dass ihr gewinnt.', answer: 'Esperamos que ganéis.'),
  ],
);

final QuizContent deEsB11LesenTrabajo = deEsRead(
  id: 'de_es_b1_1_lesen_trabajo',
  title: 'Leer: El futuro del trabajo',
  passageTitle: 'El futuro del trabajo',
  passage:
      'En las próximas décadas, el mundo del trabajo cambiará mucho. Muchos '
      'expertos creen que la inteligencia artificial hará desaparecer algunos '
      'empleos, pero también creará otros nuevos. El teletrabajo, que se hizo '
      'popular durante la pandemia, será cada vez más normal: mucha gente '
      'trabajará desde casa varios días a la semana. Además, será fundamental '
      'aprender durante toda la vida, porque las profesiones se transformarán '
      'rápidamente. Quizás trabajemos menos horas, pero necesitaremos más '
      'flexibilidad y nuevas habilidades.',
  passageTranslation:
      'In den nächsten Jahrzehnten wird sich die Arbeitswelt stark verändern. '
      'Viele Experten glauben, dass die künstliche Intelligenz manche Jobs '
      'verschwinden lässt, aber auch neue schafft. Das Homeoffice, das während '
      'der Pandemie populär wurde, wird immer normaler: Viele Menschen werden '
      'mehrere Tage pro Woche von zu Hause arbeiten. Außerdem wird '
      'lebenslanges Lernen entscheidend sein, weil sich die Berufe schnell '
      'wandeln. Vielleicht arbeiten wir weniger Stunden, aber wir brauchen mehr '
      'Flexibilität und neue Fähigkeiten.',
  intro: 'Lies einen Text über die Zukunft der Arbeit.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Futur + Subjuntivo',
      text: 'Futuro durchgehend (cambiará, será) + Subjuntivo nach »quizás« '
          '(quizás trabajemos).',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: 'Según el texto, la inteligencia artificial…',
      options: ['solo destruirá empleos', 'destruirá y creará empleos', 'no cambiará nada'],
      correctIndex: 1,
      questionTranslation: 'Laut Text wird die KI…',
    ),
    ReadingQuestion(
      question: '¿Qué se hizo popular en la pandemia?',
      options: ['el teletrabajo', 'los viajes', 'las oficinas grandes'],
      correctIndex: 0,
      questionTranslation: 'Was wurde in der Pandemie populär?',
    ),
    ReadingQuestion(
      question: '¿Qué será fundamental?',
      options: ['trabajar más', 'aprender durante toda la vida', 'cambiar de país'],
      correctIndex: 1,
      questionTranslation: 'Was wird entscheidend sein?',
    ),
    ReadingQuestion(
      question: '¿Cómo cambiarán las profesiones?',
      options: ['lentamente', 'no cambiarán', 'rápidamente'],
      correctIndex: 2,
      questionTranslation: 'Wie werden sich die Berufe wandeln?',
    ),
    ReadingQuestion(
      question: '¿Qué necesitaremos, según el autor?',
      options: ['más flexibilidad', 'menos estudios', 'más horas'],
      correctIndex: 0,
      questionTranslation: 'Was brauchen wir laut Autor?',
    ),
  ],
);

final QuizContent deEsB11Consejos = deEsFill(
  id: 'de_es_b1_1_consejos',
  title: 'Dar consejos (recomendar que…)',
  intro: 'Ratschläge geben (mit Subjuntivo).',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Rat + que',
      text: 'Rat/Empfehlung + »que« → Subjuntivo: »te aconsejo que duermas«.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Ich rate dir, mehr zu schlafen.', answer: 'Te aconsejo que duermas más.'),
    CourseItem(prompt: 'Der Arzt empfiehlt, dass ich Sport mache.', answer: 'El médico recomienda que haga deporte.'),
    CourseItem(prompt: 'Es ist besser, dass du gehst.', answer: 'Es mejor que vayas.'),
    CourseItem(prompt: 'Ich schlage vor, dass wir warten.', answer: 'Propongo que esperemos.'),
    CourseItem(prompt: 'Du solltest weniger arbeiten.', answer: 'Es mejor que trabajes menos.'),
    CourseItem(prompt: 'Ich empfehle dir, das Buch zu lesen.', answer: 'Te recomiendo que leas el libro.'),
    CourseItem(prompt: 'Es ist gut, dass du übst.', answer: 'Es bueno que practiques.'),
    CourseItem(prompt: 'Sie raten uns, früh zu kommen.', answer: 'Nos aconsejan que vengamos pronto.'),
    CourseItem(prompt: 'Es lohnt sich, dass du es versuchst.', answer: 'Vale la pena que lo intentes.'),
    CourseItem(prompt: 'Ich rate dir, ehrlich zu sein.', answer: 'Te aconsejo que seas sincero.'),
  ],
);

final QuizContent deEsB11Imperativo = deEsFill(
  id: 'de_es_b1_1_imperativo',
  title: 'Imperativo afirmativo y negativo',
  intro: 'Befehle und Bitten – bejaht und verneint.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Verneinung = Subjuntivo',
      text: 'Verneinter Befehl = Subjuntivo: habla aber »no hables«; ven aber '
          '»no vengas«. Pronomen: bejaht angehängt (hazlo), verneint davor (no '
          'lo hagas).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Sprich! (tú)', answer: '¡Habla!'),
    CourseItem(prompt: 'Sprich nicht!', answer: '¡No hables!'),
    CourseItem(prompt: 'Iss!', answer: '¡Come!'),
    CourseItem(prompt: 'Iss nicht!', answer: '¡No comas!'),
    CourseItem(prompt: 'Komm her!', answer: '¡Ven!'),
    CourseItem(prompt: 'Komm nicht!', answer: '¡No vengas!'),
    CourseItem(prompt: 'Mach es!', answer: '¡Hazlo!'),
    CourseItem(prompt: 'Mach es nicht!', answer: '¡No lo hagas!'),
    CourseItem(prompt: 'Sagen Sie mir … (usted)', answer: 'Dígame ...'),
    CourseItem(prompt: 'Warten Sie!', answer: '¡Espere!'),
    CourseItem(prompt: 'Geh! (tú)', answer: '¡Vete!'),
    CourseItem(prompt: 'Setzt euch! (vosotros)', answer: '¡Sentaos!'),
  ],
);

final QuizContent deEsB11SprechenOpinion = deEsSpeak(
  id: 'de_es_b1_1_sprechen_opinion',
  title: 'Hablar: dar y pedir opinión',
  intro: 'Meinungen austauschen – hören und nachsprechen.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'creo que',
      text: '»creo que« + Indikativ (creo que TIENES), aber »no creo que« + '
          'Subjuntivo (no creo que tengas) – Detail in B1.2.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Meiner Meinung nach …', answer: 'En mi opinión, ...'),
    CourseItem(prompt: 'Ich glaube, du hast recht.', answer: 'Creo que tienes razón.'),
    CourseItem(prompt: 'Was denkst du?', answer: '¿Tú qué piensas?'),
    CourseItem(prompt: 'Ich stimme dir zu.', answer: 'Estoy de acuerdo contigo.'),
    CourseItem(prompt: 'Ich bin nicht einverstanden.', answer: 'No estoy de acuerdo.'),
    CourseItem(prompt: 'Einerseits … andererseits …', answer: 'Por un lado... por otro lado...'),
    CourseItem(prompt: 'Das kommt auf die Situation an.', answer: 'Depende de la situación.'),
  ],
);

final QuizContent deEsB11Dobles = deEsFill(
  id: 'de_es_b1_1_dobles',
  title: 'Pronombres dobles (se lo, me lo)',
  intro: 'Zwei Objektpronomen kombinieren.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Reihenfolge',
      text: 'Indirekt vor direkt (me lo, te lo). le/les + lo/la → »se lo« (nie '
          '»le lo«). Am bejahten Imperativ angehängt + Akzent: dámelo.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Ich gebe es dir.', answer: 'Te lo doy.'),
    CourseItem(prompt: 'Ich gebe es ihm/ihr.', answer: 'Se lo doy.'),
    CourseItem(prompt: 'Kannst du es mir schicken?', answer: '¿Puedes enviármelo?'),
    CourseItem(prompt: 'Sie hat es uns erzählt.', answer: 'Nos lo ha contado.'),
    CourseItem(prompt: 'Ich kaufe sie (Pl.) dir.', answer: 'Te las compro.'),
    CourseItem(prompt: 'Gib es mir!', answer: '¡Dámelo!'),
    CourseItem(prompt: 'Sag es ihnen!', answer: '¡Díselo!'),
    CourseItem(prompt: 'Ich schenke es ihr.', answer: 'Se lo regalo.'),
    CourseItem(prompt: 'Sie erklären es mir.', answer: 'Me lo explican.'),
    CourseItem(prompt: 'Ich bringe es euch.', answer: 'Os lo traigo.'),
  ],
);

final QuizContent deEsB11CondicReal = deEsFill(
  id: 'de_es_b1_1_condic_real',
  title: 'Condicionales reales (si + presente)',
  intro: 'Reale Bedingungen.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'si + Indikativ',
      text: 'Reale Bedingung: »si« + Indikativ Präsens (NIE Subjuntivo nach '
          'diesem si!). Hauptsatz: Präsens, Futur oder Imperativ.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Wenn es regnet, bleibe ich zu Hause.', answer: 'Si llueve, me quedo en casa.'),
    CourseItem(prompt: 'Wenn du Zeit hast, ruf mich an.', answer: 'Si tienes tiempo, llámame.'),
    CourseItem(prompt: 'Wenn ich kann, komme ich.', answer: 'Si puedo, vengo.'),
    CourseItem(prompt: 'Wenn du lernst, bestehst du.', answer: 'Si estudias, apruebas.'),
    CourseItem(prompt: 'Wenn wir früh losfahren, kommen wir pünktlich an.', answer: 'Si salimos pronto, llegamos a tiempo.'),
    CourseItem(prompt: 'Wenn du willst, helfe ich dir.', answer: 'Si quieres, te ayudo.'),
    CourseItem(prompt: 'Wenn es billig ist, kaufe ich es.', answer: 'Si es barato, lo compro.'),
    CourseItem(prompt: 'Wenn ihr Hunger habt, essen wir.', answer: 'Si tenéis hambre, comemos.'),
    CourseItem(prompt: 'Wenn das stimmt, ist es ein Problem.', answer: 'Si eso es verdad, es un problema.'),
    CourseItem(prompt: 'Wenn du nicht kommst, gehe ich allein.', answer: 'Si no vienes, voy solo.'),
  ],
);

final QuizContent deEsB11LesenCarta = deEsRead(
  id: 'de_es_b1_1_lesen_carta',
  title: 'Leer: Una carta de recomendación',
  passageTitle: 'Una carta de recomendación',
  passage:
      'A quien corresponda: Por la presente, recomiendo a la señora Laura '
      'Méndez para el puesto de diseñadora gráfica. Laura trabajó en nuestra '
      'empresa durante cuatro años y siempre demostró ser una profesional '
      'responsable y creativa. Sus compañeros la apreciaban mucho porque era '
      'amable y trabajadora. Estoy seguro de que será una excelente '
      'incorporación a cualquier equipo. Si necesitan más información, no duden '
      'en contactarme. Atentamente, Carlos Ruiz, Director de Diseño.',
  passageTranslation:
      'An die zuständige Stelle: Hiermit empfehle ich Frau Laura Méndez für die '
      'Stelle als Grafikdesignerin. Laura arbeitete vier Jahre in unserem '
      'Unternehmen und erwies sich stets als verantwortungsvolle und kreative '
      'Fachkraft. Ihre Kollegen schätzten sie sehr, weil sie freundlich und '
      'fleißig war. Ich bin sicher, dass sie eine ausgezeichnete Verstärkung '
      'für jedes Team sein wird. Wenn Sie weitere Informationen brauchen, '
      'zögern Sie nicht, mich zu kontaktieren. Mit freundlichen Grüßen, Carlos '
      'Ruiz, Designleiter.',
  intro: 'Lies ein formelles Empfehlungsschreiben.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Formell',
      text: '»A quien corresponda« / »Atentamente«. Mischung indefinido '
          '(trabajó) / imperfecto (era) / futuro (será).',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '¿Para qué puesto recomiendan a Laura?',
      options: ['Profesora', 'Diseñadora gráfica', 'Directora'],
      correctIndex: 1,
      questionTranslation: 'Für welche Stelle wird Laura empfohlen?',
    ),
    ReadingQuestion(
      question: '¿Cuánto tiempo trabajó en la empresa?',
      options: ['Dos años', 'Cuatro años', 'Diez años'],
      correctIndex: 1,
      questionTranslation: 'Wie lange arbeitete sie im Unternehmen?',
    ),
    ReadingQuestion(
      question: '¿Cómo era Laura con sus compañeros?',
      options: ['Distante', 'Amable', 'Estricta'],
      correctIndex: 1,
      questionTranslation: 'Wie war Laura zu ihren Kollegen?',
    ),
    ReadingQuestion(
      question: '¿Qué opina el autor de su futuro?',
      options: ['Será una excelente incorporación', 'No está seguro', 'No la recomienda'],
      correctIndex: 0,
      questionTranslation: 'Was meint der Autor über ihre Zukunft?',
    ),
    ReadingQuestion(
      question: 'El registro de la carta es…',
      options: ['informal', 'formal', 'humorístico'],
      correctIndex: 1,
      questionTranslation: 'Das Register des Briefes ist…',
    ),
  ],
);

final QuizContent deEsB11Sentimientos = deEsFill(
  id: 'de_es_b1_1_sentimientos',
  title: 'Expresar sentimientos (me alegro de que…)',
  intro: 'Gefühle ausdrücken (mit Subjuntivo).',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Gefühl + que',
      text: 'Gefühl + »que« + anderes Subjekt → Subjuntivo: »me alegro de que '
          'vengas«. Gleiches Subjekt → Infinitiv: me alegro de venir.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Ich freue mich, dass du kommst.', answer: 'Me alegro de que vengas.'),
    CourseItem(prompt: 'Es tut mir leid, dass du krank bist.', answer: 'Siento que estés enfermo.'),
    CourseItem(prompt: 'Ich habe Angst, dass es regnet.', answer: 'Tengo miedo de que llueva.'),
    CourseItem(prompt: 'Es nervt mich, dass er immer zu spät kommt.', answer: 'Me molesta que siempre llegue tarde.'),
    CourseItem(prompt: 'Ich finde es toll, dass du lernst.', answer: 'Me encanta que estudies.'),
    CourseItem(prompt: 'Es ist schade, dass ihr geht.', answer: 'Es una pena que os vayáis.'),
    CourseItem(prompt: 'Ich hoffe, dass alles gut wird.', answer: 'Espero que todo salga bien.'),
    CourseItem(prompt: 'Es überrascht mich, dass du das sagst.', answer: 'Me sorprende que digas eso.'),
    CourseItem(prompt: 'Ich bin froh, dass wir uns sehen.', answer: 'Me alegro de que nos veamos.'),
    CourseItem(prompt: 'Es macht mich traurig, dass du gehst.', answer: 'Me da pena que te vayas.'),
  ],
);

final QuizContent deEsB11LesenExtranjero = deEsRead(
  id: 'de_es_b1_1_lesen_extranjero',
  title: 'Leer: Estudiar en el extranjero',
  passageTitle: 'Estudiar en el extranjero',
  passage:
      'Cada vez más jóvenes deciden estudiar una temporada en el extranjero. '
      'Las ventajas son muchas: se aprende un idioma, se conocen otras culturas '
      'y se gana independencia. Sin embargo, también hay dificultades. Al '
      'principio, muchos estudiantes se sienten solos y echan de menos a su '
      'familia. Además, vivir en otro país puede ser caro. Los expertos '
      'recomiendan que los jóvenes se informen bien antes de viajar y que '
      'busquen una beca si la necesitan. A pesar de los retos, casi todos '
      'coinciden en que la experiencia merece la pena.',
  passageTranslation:
      'Immer mehr junge Leute entscheiden sich, eine Zeit lang im Ausland zu '
      'studieren. Die Vorteile sind zahlreich: Man lernt eine Sprache, lernt '
      'andere Kulturen kennen und gewinnt Unabhängigkeit. Es gibt jedoch auch '
      'Schwierigkeiten. Am Anfang fühlen sich viele Studierende allein und '
      'vermissen ihre Familie. Außerdem kann das Leben in einem anderen Land '
      'teuer sein. Experten empfehlen, dass sich die jungen Leute vor der Reise '
      'gut informieren und ein Stipendium suchen, wenn sie es brauchen. Trotz '
      'der Herausforderungen sind sich fast alle einig, dass die Erfahrung sich '
      'lohnt.',
  intro: 'Lies über das Studium im Ausland.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Subjuntivo + se',
      text: '»recomiendan que se informen / busquen« = Subjuntivo. »se aprende, '
          'se conocen« = se-impersonal (Vorschau B2).',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '¿Qué deciden cada vez más jóvenes?',
      options: ['Trabajar', 'Estudiar en el extranjero', 'Viajar menos'],
      correctIndex: 1,
      questionTranslation: 'Wofür entscheiden sich immer mehr junge Leute?',
    ),
    ReadingQuestion(
      question: '¿Cuál es una ventaja?',
      options: ['Ganar dinero', 'Aprender un idioma', 'No estudiar'],
      correctIndex: 1,
      questionTranslation: 'Was ist ein Vorteil?',
    ),
    ReadingQuestion(
      question: '¿Qué dificultad se menciona?',
      options: ['El idioma fácil', 'Sentirse solos', 'La comida'],
      correctIndex: 1,
      questionTranslation: 'Welche Schwierigkeit wird genannt?',
    ),
    ReadingQuestion(
      question: '¿Qué recomiendan los expertos?',
      options: ['No viajar', 'Informarse y buscar una beca', 'Ir sin planes'],
      correctIndex: 1,
      questionTranslation: 'Was empfehlen die Experten?',
    ),
    ReadingQuestion(
      question: 'Según el texto, la experiencia…',
      options: ['no vale la pena', 'merece la pena', 'es imposible'],
      correctIndex: 1,
      questionTranslation: 'Laut Text lohnt sich die Erfahrung…',
    ),
  ],
);

final QuizContent deEsB11SprechenEntrevista = deEsSpeak(
  id: 'de_es_b1_1_sprechen_entrevista',
  title: 'Hablar: la entrevista de trabajo',
  intro: 'Im Bewerbungsgespräch – hören und nachsprechen.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Zeitenmix',
      text: 'Mischung perfecto (he trabajado) + Konditional (serían) + Futur '
          '(sabré).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Guten Tag, sehr erfreut.', answer: 'Buenos días, encantado de conocerle.'),
    CourseItem(prompt: 'Ich habe drei Jahre als Designer gearbeitet.', answer: 'He trabajado tres años como diseñador.'),
    CourseItem(prompt: 'Ich spreche Deutsch, Englisch und Spanisch.', answer: 'Hablo alemán, inglés y español.'),
    CourseItem(prompt: 'Ich glaube, ich bin verantwortungsvoll und kreativ.', answer: 'Creo que soy responsable y creativo.'),
    CourseItem(prompt: 'Diese Stelle interessiert mich sehr.', answer: 'Me interesa mucho este puesto.'),
    CourseItem(prompt: 'Was wären meine Aufgaben?', answer: '¿Cuáles serían mis responsabilidades?'),
    CourseItem(prompt: 'Wann erfahre ich Bescheid?', answer: '¿Cuándo sabré algo?'),
  ],
);

/// Quest B1.1 in chain order.
final List<QuizContent> deEsB1_1 = [
  deEsB11Trabajo,
  deEsB11Futuro,
  deEsB11SprechenPlanes,
  deEsB11SubjFormas,
  deEsB11SubjDeseos,
  deEsB11LesenTrabajo,
  deEsB11Consejos,
  deEsB11Imperativo,
  deEsB11SprechenOpinion,
  deEsB11Dobles,
  deEsB11CondicReal,
  deEsB11LesenCarta,
  deEsB11Sentimientos,
  deEsB11LesenExtranjero,
  deEsB11SprechenEntrevista,
];
