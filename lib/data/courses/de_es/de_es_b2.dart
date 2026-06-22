import '../../../models/quiz_content.dart';
import 'de_es_builder.dart';

/// Quest B2 — Argumentar y matizar (Argumentieren). Deutsch → Spanisch.

final QuizContent deEsB2Sociedad = deEsFill(
  id: 'de_es_b2_sociedad',
  title: 'Política y sociedad',
  intro: 'Politik und Gesellschaft.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: 'el partido',
      text: '»el partido« = Partei UND (Sport-)Spiel. »la manifestación« = Demo.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'die Regierung', answer: 'el gobierno'),
    CourseItem(prompt: 'die Wahlen', answer: 'las elecciones'),
    CourseItem(prompt: 'die Partei', answer: 'el partido'),
    CourseItem(prompt: 'das Gesetz', answer: 'la ley'),
    CourseItem(prompt: 'der/die Bürger/in', answer: 'el ciudadano', accepted: ['la ciudadana']),
    CourseItem(prompt: 'die Gesellschaft', answer: 'la sociedad'),
    CourseItem(prompt: 'die Gleichheit', answer: 'la igualdad'),
    CourseItem(prompt: 'die Armut', answer: 'la pobreza'),
    CourseItem(prompt: 'die Arbeitslosigkeit', answer: 'el desempleo', accepted: ['el paro']),
    CourseItem(prompt: 'die Einwanderung', answer: 'la inmigración'),
    CourseItem(prompt: 'die Menschenrechte', answer: 'los derechos humanos'),
    CourseItem(prompt: 'die Demonstration', answer: 'la manifestación'),
  ],
);

final QuizContent deEsB2SubjImperf = deEsFill(
  id: 'de_es_b2_subj_imperf',
  title: 'Imperfecto de subjuntivo (formas)',
  intro: 'Den Imperfekt-Subjuntiv bilden.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'aus dem Indefinido',
      text: 'Bildung aus der 3. Pl. Indefinido: hablaron→hablara, '
          'hicieron→hiciera, tuvieron→tuviera. Zwei Formen (-ra/-se): hablara = '
          'hablase.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'dass ich spräche (hablar)', answer: 'que hablara'),
    CourseItem(prompt: 'dass du essest', answer: 'que comieras'),
    CourseItem(prompt: 'dass er/sie lebte', answer: 'que viviera'),
    CourseItem(prompt: 'dass wir machten (hacer)', answer: 'que hiciéramos'),
    CourseItem(prompt: 'dass sie wären (ser)', answer: 'que fueran'),
    CourseItem(prompt: 'dass ich hätte (tener)', answer: 'que tuviera'),
    CourseItem(prompt: 'dass ich käme (venir)', answer: 'que viniera'),
    CourseItem(prompt: 'dass es gäbe (haber)', answer: 'que hubiera'),
    CourseItem(prompt: 'dass ich könnte (poder)', answer: 'que pudiera'),
    CourseItem(prompt: 'dass ich sagte (decir)', answer: 'que dijera'),
    CourseItem(prompt: 'dass ich ginge (ir)', answer: 'que fuera'),
    CourseItem(prompt: 'dass ich wüsste (saber)', answer: 'que supiera'),
  ],
);

final QuizContent deEsB2CondicIrreal = deEsFill(
  id: 'de_es_b2_condic_irreal',
  title: 'Condicionales irreales (si tuviera…)',
  intro: 'Irreale Bedingungssätze.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Brücke zu Konjunktiv II',
      text: 'Irreal: »si« + Imperfekt-Subjuntivo, Hauptsatz im Konditional. Wie '
          'dt. »Wenn ich Geld HÄTTE, WÜRDE ich reisen«. Aber: nach diesem »si« '
          'NIE Konditional (si tuviera, nicht »si tendría«).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Wenn ich Geld hätte, würde ich reisen.', answer: 'Si tuviera dinero, viajaría.'),
    CourseItem(prompt: 'Wenn ich du wäre, würde ich gehen.', answer: 'Si yo fuera tú, iría.'),
    CourseItem(prompt: 'Wenn wir mehr Zeit hätten, …', answer: 'Si tuviéramos más tiempo, ...'),
    CourseItem(prompt: 'Wenn es nicht regnete, gingen wir raus.', answer: 'Si no lloviera, saldríamos.'),
    CourseItem(prompt: 'Wenn du kämst, wäre ich glücklich.', answer: 'Si vinieras, sería feliz.'),
    CourseItem(prompt: 'Wenn ich könnte, würde ich helfen.', answer: 'Si pudiera, ayudaría.'),
    CourseItem(prompt: 'Was würdest du tun, wenn du gewännst?', answer: '¿Qué harías si ganaras?'),
    CourseItem(prompt: 'Wenn sie es wüsste, würde sie es sagen.', answer: 'Si lo supiera, lo diría.'),
    CourseItem(prompt: 'Wenn ich mehr lernte, bestünde ich.', answer: 'Si estudiara más, aprobaría.'),
    CourseItem(prompt: 'Wenn wir reich wären, …', answer: 'Si fuéramos ricos, ...'),
    CourseItem(prompt: 'Ich würde es kaufen, wenn es billiger wäre.', answer: 'Lo compraría si fuera más barato.'),
    CourseItem(prompt: 'Wenn du mich liebtest, …', answer: 'Si me quisieras, ...'),
  ],
);

final QuizContent deEsB2SprechenArgumento = deEsSpeak(
  id: 'de_es_b2_sprechen_argumento',
  title: 'Hablar: defender una opinión',
  intro: 'Eine Meinung verteidigen – hören und nachsprechen.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'DELE B2',
      text: 'Argumentations-Bausteine für die mündliche DELE-B2-Prüfung.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Aus meiner Sicht …', answer: 'Desde mi punto de vista, ...'),
    CourseItem(prompt: 'Ich bin völlig überzeugt, dass …', answer: 'Estoy totalmente convencido de que ...'),
    CourseItem(prompt: 'Man muss bedenken, dass …', answer: 'Hay que tener en cuenta que ...'),
    CourseItem(prompt: 'Einerseits ja, andererseits …', answer: 'Por una parte sí, pero por otra ...'),
    CourseItem(prompt: 'Diese Meinung teile ich nicht.', answer: 'No comparto esa opinión.'),
    CourseItem(prompt: 'Das hängt von mehreren Faktoren ab.', answer: 'Eso depende de varios factores.'),
    CourseItem(prompt: 'Zusammenfassend …', answer: 'En conclusión, ...'),
  ],
);

final QuizContent deEsB2VerbosCambio = deEsFill(
  id: 'de_es_b2_verbos_cambio',
  title: 'Verbos de cambio (ponerse/volverse…)',
  intro: 'Die vielen Arten von »werden«.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'ein »werden«, viele Verben',
      text: 'ponerse + Adj. = plötzlich/vorübergehend (Gefühl/Farbe). volverse = '
          'radikale Wesensänderung. hacerse = allmählich/willentlich (Beruf, '
          'reich). quedarse = Resultat/Verlust (ruhig, blind).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Er wurde rot. (plötzlich)', answer: 'Se puso rojo.'),
    CourseItem(prompt: 'Sie wurde nervös.', answer: 'Se puso nerviosa.'),
    CourseItem(prompt: 'Er ist verrückt geworden. (radikal)', answer: 'Se volvió loco.'),
    CourseItem(prompt: 'Sie ist sehr egoistisch geworden.', answer: 'Se volvió muy egoísta.'),
    CourseItem(prompt: 'Er wurde Arzt. (durch Anstrengung)', answer: 'Se hizo médico.'),
    CourseItem(prompt: 'Sie wurde reich.', answer: 'Se hizo rica.'),
    CourseItem(prompt: 'Er wurde Buddhist. (Überzeugung)', answer: 'Se hizo budista.'),
    CourseItem(prompt: 'Sie blieb ruhig. (Resultat)', answer: 'Se quedó tranquila.'),
    CourseItem(prompt: 'Er erblindete. (bleibender Verlust)', answer: 'Se quedó ciego.'),
    CourseItem(prompt: 'Das Wetter wurde schlecht.', answer: 'El tiempo se puso feo.'),
    CourseItem(prompt: 'Mit der Zeit wurden sie Freunde.', answer: 'Con el tiempo, se hicieron amigos.'),
    CourseItem(prompt: 'Sie wurde traurig.', answer: 'Se puso triste.'),
  ],
);

final QuizContent deEsB2LesenDebate = deEsRead(
  id: 'de_es_b2_lesen_debate',
  title: 'Leer: ¿Energía nuclear, sí o no?',
  passageTitle: '¿Energía nuclear, sí o no?',
  passage:
      'El debate sobre la energía nuclear divide a la sociedad. Por un lado, sus '
      'defensores afirman que es una fuente limpia, porque apenas emite gases de '
      'efecto invernadero, y que podría ayudar a combatir el cambio climático. '
      'Además, una sola central produce enormes cantidades de electricidad de '
      'forma constante, algo que las renovables todavía no garantizan. Por otro '
      'lado, sus críticos advierten de los riesgos: un accidente como el de '
      'Chernóbil o Fukushima puede tener consecuencias devastadoras durante '
      'décadas. A esto se suma el problema de los residuos radiactivos, que '
      'permanecen peligrosos durante miles de años. Aunque no exista una '
      'solución perfecta, la mayoría de los expertos coincide en que '
      'necesitaremos una combinación de varias fuentes de energía. Lo '
      'importante es que la decisión se tome con información rigurosa y no con '
      'miedo.',
  passageTranslation:
      'Die Debatte über Atomenergie spaltet die Gesellschaft. Einerseits '
      'behaupten ihre Befürworter, sie sei eine saubere Quelle, weil sie kaum '
      'Treibhausgase ausstößt, und könne helfen, den Klimawandel zu bekämpfen. '
      'Außerdem produziert ein einziges Kraftwerk konstant riesige Mengen '
      'Strom, was die Erneuerbaren noch nicht garantieren. Andererseits warnen '
      'ihre Kritiker vor den Risiken: Ein Unfall wie der von Tschernobyl oder '
      'Fukushima kann jahrzehntelang verheerende Folgen haben. Hinzu kommt das '
      'Problem des radioaktiven Mülls, der Tausende Jahre gefährlich bleibt. '
      'Auch wenn es keine perfekte Lösung gibt, sind sich die meisten Experten '
      'einig, dass wir eine Kombination mehrerer Energiequellen brauchen. '
      'Wichtig ist, dass die Entscheidung mit fundierten Informationen und '
      'nicht aus Angst getroffen wird.',
  intro: 'Lies einen argumentativen Text über Atomenergie.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Argumentation',
      text: '»por un lado / por otro lado«, »aunque no exista« (Konzessiv + '
          'Subjuntivo), »lo importante es que se tome« (Subjuntivo + se-Passiv).',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '¿Qué afirman los defensores?',
      options: ['que es barata', 'que es limpia y constante', 'que no tiene riesgos'],
      correctIndex: 1,
      questionTranslation: 'Was behaupten die Befürworter?',
    ),
    ReadingQuestion(
      question: '¿Qué ventaja tiene frente a las renovables?',
      options: ['produce electricidad constante', 'no necesita agua', 'es más bonita'],
      correctIndex: 0,
      questionTranslation: 'Welchen Vorteil hat sie gegenüber Erneuerbaren?',
    ),
    ReadingQuestion(
      question: '¿Qué riesgo mencionan los críticos?',
      options: ['el ruido', 'los accidentes graves', 'el precio'],
      correctIndex: 1,
      questionTranslation: 'Welches Risiko nennen die Kritiker?',
    ),
    ReadingQuestion(
      question: '¿Cuánto tiempo son peligrosos los residuos?',
      options: ['unos días', 'miles de años', 'un siglo'],
      correctIndex: 1,
      questionTranslation: 'Wie lange ist der Müll gefährlich?',
    ),
    ReadingQuestion(
      question: '¿En qué coincide la mayoría de los expertos?',
      options: ['en prohibirla', 'en combinar varias fuentes', 'en usar solo nuclear'],
      correctIndex: 1,
      questionTranslation: 'Worin sind sich die Experten einig?',
    ),
    ReadingQuestion(
      question: 'La decisión debe tomarse…',
      options: ['con miedo', 'con información rigurosa', 'rápidamente'],
      correctIndex: 1,
      questionTranslation: 'Wie soll die Entscheidung getroffen werden?',
    ),
  ],
);

final QuizContent deEsB2SerEstarAdv = deEsFill(
  id: 'de_es_b2_ser_estar_adv',
  title: 'ser/estar avanzado (cambios de significado)',
  intro: 'Wenn ser/estar die Bedeutung des Adjektivs ändern.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Bedeutungswechsel',
      text: 'ser listo (schlau) ↔ estar listo (bereit); ser aburrido '
          '(langweilig) ↔ estar aburrido (gelangweilt); ser rico (reich) ↔ '
          'estar rico (lecker).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Er ist schlau.', answer: 'Es listo.'),
    CourseItem(prompt: 'Ich bin fertig/bereit.', answer: 'Estoy listo.'),
    CourseItem(prompt: 'Der Film ist langweilig.', answer: 'La película es aburrida.'),
    CourseItem(prompt: 'Ich bin gelangweilt.', answer: 'Estoy aburrido.'),
    CourseItem(prompt: 'Sie ist reich.', answer: 'Es rica.'),
    CourseItem(prompt: 'Das Essen ist lecker.', answer: 'La comida está rica.'),
    CourseItem(prompt: 'Er ist ein guter Mensch.', answer: 'Es bueno.'),
    CourseItem(prompt: 'Ich bin krank.', answer: 'Estoy malo.'),
    CourseItem(prompt: 'Er ist böse/gemein.', answer: 'Es malo.'),
    CourseItem(prompt: 'Die Banane ist noch grün (unreif).', answer: 'El plátano está verde.'),
    CourseItem(prompt: 'Mein Opa lebt noch.', answer: 'Mi abuelo está vivo.'),
    CourseItem(prompt: 'Er ist sehr gewitzt.', answer: 'Es muy vivo.'),
  ],
);

final QuizContent deEsB2Concesivas = deEsFill(
  id: 'de_es_b2_concesivas',
  title: 'Concesivas: aunque + subjuntivo',
  intro: 'Einräumungen mit »aunque«.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'aunque',
      text: '»aunque« + Indikativ = eingeräumte Tatsache (»obwohl«). »aunque« + '
          'Subjuntivo = Hypothese/Unsicheres (»auch wenn«).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Obwohl es regnet, gehe ich raus.', answer: 'Aunque llueve, salgo.'),
    CourseItem(prompt: 'Auch wenn es regnen sollte, gehe ich.', answer: 'Aunque llueva, saldré.'),
    CourseItem(prompt: 'Obwohl er reich ist, ist er nicht glücklich.', answer: 'Aunque es rico, no es feliz.'),
    CourseItem(prompt: 'Auch wenn er reich wäre, …', answer: 'Aunque fuera rico, ...'),
    CourseItem(prompt: 'Obwohl ich müde bin, lerne ich.', answer: 'Aunque estoy cansado, estudio.'),
    CourseItem(prompt: 'Auch wenn es schwer ist, schaffe ich es.', answer: 'Aunque sea difícil, lo conseguiré.'),
    CourseItem(prompt: 'Auch wenn es mir nicht gefällt, akzeptiere ich es.', answer: 'Aunque no me guste, lo acepto.'),
    CourseItem(prompt: 'auch wenn du nicht willst', answer: 'aunque no quieras'),
    CourseItem(prompt: 'Selbst wenn du es mir sagst, glaube ich nicht.', answer: 'Aunque me lo digas, no lo creo.'),
    CourseItem(prompt: 'Obwohl wir wenig Geld haben, …', answer: 'Aunque tenemos poco dinero, ...'),
  ],
);

final QuizContent deEsB2Pasiva = deEsFill(
  id: 'de_es_b2_pasiva',
  title: 'La voz pasiva y el «se» impersonal',
  intro: 'Passiv und »man« auf Spanisch.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'se statt werden',
      text: 'Spanisch bevorzugt die se-Passiv-/man-Konstruktion (se habla '
          'español) statt der »werden«-Passiv-Form. Echtes Passiv mit ser + '
          'Partizip v.a. schriftlich mit Urheber (fue escrito POR…).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Man spricht Spanisch.', answer: 'Se habla español.'),
    CourseItem(prompt: 'Hier verkauft man Brot.', answer: 'Aquí se vende pan.'),
    CourseItem(prompt: 'Wie schreibt man das?', answer: '¿Cómo se escribe?'),
    CourseItem(prompt: 'Man sagt, dass…', answer: 'Se dice que ...'),
    CourseItem(prompt: 'Die Häuser wurden 1990 gebaut.', answer: 'Las casas se construyeron en 1990.'),
    CourseItem(prompt: 'Man sucht Kellner.', answer: 'Se busca camarero.'),
    CourseItem(prompt: 'Das Buch wurde von García Márquez geschrieben.', answer: 'El libro fue escrito por García Márquez.'),
    CourseItem(prompt: 'Hier darf man nicht rauchen.', answer: 'Aquí no se puede fumar.'),
    CourseItem(prompt: 'Die Tür öffnete sich.', answer: 'Se abrió la puerta.'),
    CourseItem(prompt: 'In Spanien isst man spät.', answer: 'En España se come tarde.'),
  ],
);

final QuizContent deEsB2SprechenPresentar = deEsSpeak(
  id: 'de_es_b2_sprechen_presentar',
  title: 'Hablar: presentar un argumento',
  intro: 'Eine Mini-Präsentation halten – hören und nachsprechen.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Aufbau',
      text: 'Klassischer Aufbau einer DELE-B2-Mini-Präsentation: Einleitung → '
          'Argumente → Schluss.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Heute möchte ich über … sprechen.', answer: 'Hoy me gustaría hablar sobre ...'),
    CourseItem(prompt: 'Zunächst muss man sagen, dass …', answer: 'En primer lugar, hay que decir que ...'),
    CourseItem(prompt: 'Ein Argument dafür ist, dass …', answer: 'Un argumento a favor es que ...'),
    CourseItem(prompt: 'Allerdings darf man nicht vergessen, dass …', answer: 'Sin embargo, no hay que olvidar que ...'),
    CourseItem(prompt: 'Aus all dem schließe ich, dass …', answer: 'Por todo ello, considero que ...'),
    CourseItem(prompt: 'Letztendlich …', answer: 'En definitiva, ...'),
    CourseItem(prompt: 'Vielen Dank für Ihre Aufmerksamkeit.', answer: 'Muchas gracias por su atención.'),
  ],
);

final QuizContent deEsB2SubjTemporal = deEsFill(
  id: 'de_es_b2_subj_temporal',
  title: 'Subjuntivo en temporales (cuando llegue)',
  intro: 'Zeitsätze mit Zukunftsbezug.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Zukunft → Subjuntivo',
      text: 'Zeitangabe mit Zukunftsbezug → cuando/en cuanto/hasta que + '
          'Subjuntivo (cuando LLEGUE). Gegenwart/Gewohnheit → Indikativ (cuando '
          'llego). Deutsch unterscheidet das nicht.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Wenn ich ankomme, rufe ich dich an. (Zukunft)', answer: 'Cuando llegue, te llamo.'),
    CourseItem(prompt: 'Wenn ich ankam, rief ich immer an.', answer: 'Cuando llegaba, llamaba.'),
    CourseItem(prompt: 'Sobald du kannst, sag Bescheid.', answer: 'En cuanto puedas, avísame.'),
    CourseItem(prompt: 'Bis du zurückkommst, warte ich.', answer: 'Hasta que vuelvas, espero.'),
    CourseItem(prompt: 'Wenn ich groß bin, …', answer: 'Cuando sea mayor, ...'),
    CourseItem(prompt: 'Sobald sie es weiß, …', answer: 'En cuanto lo sepa, ...'),
    CourseItem(prompt: 'Bevor du gehst, iss etwas.', answer: 'Antes de que te vayas, come algo.'),
    CourseItem(prompt: 'Nachdem wir gegessen haben, gehen wir.', answer: 'Después de que comamos, salimos.'),
    CourseItem(prompt: 'Während du arbeitest, koche ich.', answer: 'Mientras trabajas, cocino.'),
    CourseItem(prompt: 'Wenn der Sommer kommt, reisen wir.', answer: 'Cuando llegue el verano, viajaremos.'),
  ],
);

final QuizContent deEsB2LesenResena = deEsRead(
  id: 'de_es_b2_lesen_resena',
  title: 'Leer: Reseña de una novela',
  passageTitle: 'Reseña de una novela',
  passage:
      '«La sombra del viento», de Carlos Ruiz Zafón, es una de esas novelas que '
      'atrapan desde la primera página. Ambientada en la Barcelona de la '
      'posguerra, cuenta la historia de Daniel, un niño que descubre un libro '
      'misterioso y queda fascinado por su autor, del que nadie parece saber '
      'nada. A medida que crece, Daniel se obsesiona con desvelar el secreto, y '
      'el lector se ve arrastrado por una trama llena de amor, intriga y '
      'personajes inolvidables. Lo mejor de la novela es su atmósfera: Zafón '
      'describe las calles de Barcelona como si fueran un personaje más. Quizá '
      'el final resulte algo previsible, pero eso no le quita mérito. Sin duda, '
      'la recomendaría a cualquiera que disfrute de las buenas historias.',
  passageTranslation:
      '»Der Schatten des Windes« von Carlos Ruiz Zafón ist einer dieser Romane, '
      'die einen ab der ersten Seite fesseln. Angesiedelt im Barcelona der '
      'Nachkriegszeit, erzählt er die Geschichte von Daniel, einem Jungen, der '
      'ein geheimnisvolles Buch entdeckt und von dessen Autor fasziniert ist, '
      'über den niemand etwas zu wissen scheint. Während er heranwächst, wird '
      'Daniel besessen davon, das Geheimnis zu lüften, und der Leser wird von '
      'einer Handlung voller Liebe, Intrige und unvergesslicher Figuren '
      'mitgerissen. Das Beste am Roman ist seine Atmosphäre: Zafón beschreibt '
      'die Straßen Barcelonas, als wären sie eine weitere Figur. Vielleicht '
      'wirkt das Ende etwas vorhersehbar, aber das schmälert seinen Wert nicht. '
      'Ohne Zweifel würde ich ihn jedem empfehlen, der gute Geschichten '
      'genießt.',
  intro: 'Lies eine Buchrezension.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Nuancen',
      text: '»como si fueran« (Imperfekt-Subjuntivo nach »como si«), »quizá el '
          'final resulte« (Subjuntivo), »a cualquiera que disfrute« (Relativ + '
          'Subjuntivo).',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '¿Dónde transcurre la novela?',
      options: ['en Madrid', 'en la Barcelona de posguerra', 'en el campo'],
      correctIndex: 1,
      questionTranslation: 'Wo spielt der Roman?',
    ),
    ReadingQuestion(
      question: '¿Qué descubre Daniel?',
      options: ['un tesoro', 'un libro misterioso', 'una carta'],
      correctIndex: 1,
      questionTranslation: 'Was entdeckt Daniel?',
    ),
    ReadingQuestion(
      question: '¿Qué es lo mejor, según el crítico?',
      options: ['los diálogos', 'la atmósfera', 'la portada'],
      correctIndex: 1,
      questionTranslation: 'Was ist laut Kritiker das Beste?',
    ),
    ReadingQuestion(
      question: '¿Qué defecto menciona?',
      options: ['es muy larga', 'el final es algo previsible', 'los personajes son planos'],
      correctIndex: 1,
      questionTranslation: 'Welchen Mangel nennt er?',
    ),
    ReadingQuestion(
      question: '¿A quién la recomienda?',
      options: ['a los niños', 'a quien disfrute de buenas historias', 'a nadie'],
      correctIndex: 1,
      questionTranslation: 'Wem empfiehlt er ihn?',
    ),
    ReadingQuestion(
      question: 'El tono de la reseña es…',
      options: ['negativo', 'muy positivo', 'neutro'],
      correctIndex: 1,
      questionTranslation: 'Der Ton der Rezension ist…',
    ),
  ],
);

final QuizContent deEsB2Modismos = deEsFill(
  id: 'de_es_b2_modismos',
  title: 'Expresiones idiomáticas y conectores',
  intro: 'Redewendungen – nicht wörtlich übersetzen!',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: 'Idiome',
      text: 'Idiome wörtlich zu nehmen führt in die Irre: »cuesta un ojo de la '
          'cara« (»kostet ein Auge aus dem Gesicht«) = es kostet ein Vermögen.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Es kostet ein Vermögen.', answer: 'Cuesta un ojo de la cara.'),
    CourseItem(prompt: 'Es regnet in Strömen.', answer: 'Llueve a cántaros.'),
    CourseItem(prompt: 'Das ist mir egal.', answer: 'Me da igual.'),
    CourseItem(prompt: 'Das ist kinderleicht.', answer: 'Es pan comido.'),
    CourseItem(prompt: 'jemanden veräppeln', answer: 'tomar el pelo'),
    CourseItem(prompt: 'kein Blatt vor den Mund nehmen', answer: 'no tener pelos en la lengua'),
    CourseItem(prompt: 'jemandem helfen / unter die Arme greifen', answer: 'echar una mano'),
    CourseItem(prompt: 'die Daumen drücken', answer: 'cruzar los dedos'),
    CourseItem(prompt: 'die Nase voll haben', answer: 'estar hasta las narices'),
    CourseItem(prompt: 'ehrlich gesagt', answer: 'la verdad es que'),
    CourseItem(prompt: 'kurz gesagt', answer: 'en pocas palabras'),
    CourseItem(prompt: 'früher oder später', answer: 'tarde o temprano'),
  ],
);

final QuizContent deEsB2LesenTeletrabajo = deEsRead(
  id: 'de_es_b2_lesen_teletrabajo',
  title: 'Leer: El teletrabajo, ¿ventaja o trampa?',
  passageTitle: 'El teletrabajo, ¿ventaja o trampa?',
  passage:
      'El teletrabajo se ha convertido en una de las grandes transformaciones '
      'del mundo laboral. Sus defensores destacan que ahorra tiempo de '
      'desplazamiento, reduce la contaminación y permite conciliar mejor la '
      'vida personal y profesional. No obstante, no todo son ventajas. Algunos '
      'trabajadores reconocen que, desde que trabajan en casa, les cuesta '
      'desconectar: el ordenador siempre está ahí y la frontera entre el '
      'trabajo y el descanso se difumina. Otros echan de menos el contacto '
      'humano con sus compañeros. Quizá la solución no sea elegir entre la '
      'oficina y el hogar, sino encontrar un modelo híbrido que combine lo '
      'mejor de ambos mundos.',
  passageTranslation:
      'Das Homeoffice ist zu einer der großen Veränderungen der Arbeitswelt '
      'geworden. Seine Befürworter heben hervor, dass es Pendelzeit spart, die '
      'Umweltverschmutzung verringert und eine bessere Vereinbarkeit von '
      'Privat- und Berufsleben ermöglicht. Dennoch sind nicht alles Vorteile. '
      'Manche Arbeitnehmer geben zu, dass es ihnen, seit sie zu Hause arbeiten, '
      'schwerfällt abzuschalten: Der Computer ist immer da und die Grenze '
      'zwischen Arbeit und Erholung verschwimmt. Andere vermissen den '
      'menschlichen Kontakt mit den Kollegen. Vielleicht besteht die Lösung '
      'nicht darin, zwischen Büro und Zuhause zu wählen, sondern ein hybrides '
      'Modell zu finden, das das Beste aus beiden Welten verbindet.',
  intro: 'Lies einen abwägenden Text über das Homeoffice.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Abwägen',
      text: '»no obstante« (jedoch), »desde que trabajan« (+ Indikativ), »quizá '
          'la solución no sea… sino…« (Subjuntivo + Kontrast).',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '¿Qué destacan los defensores?',
      options: ['que es obligatorio', 'que ahorra tiempo y contamina menos', 'que es más caro'],
      correctIndex: 1,
      questionTranslation: 'Was heben die Befürworter hervor?',
    ),
    ReadingQuestion(
      question: '¿Qué problema reconocen algunos trabajadores?',
      options: ['el ruido', 'que les cuesta desconectar', 'la falta de ordenadores'],
      correctIndex: 1,
      questionTranslation: 'Welches Problem geben manche zu?',
    ),
    ReadingQuestion(
      question: '¿Qué echan de menos otros?',
      options: ['el sueldo', 'el contacto con los compañeros', 'la oficina antigua'],
      correctIndex: 1,
      questionTranslation: 'Was vermissen andere?',
    ),
    ReadingQuestion(
      question: '¿Qué se difumina con el teletrabajo?',
      options: ['el horario fijo', 'la frontera entre trabajo y descanso', 'la conexión'],
      correctIndex: 1,
      questionTranslation: 'Was verschwimmt durch das Homeoffice?',
    ),
    ReadingQuestion(
      question: '¿Cuál podría ser la solución?',
      options: ['solo la oficina', 'solo casa', 'un modelo híbrido'],
      correctIndex: 2,
      questionTranslation: 'Was könnte die Lösung sein?',
    ),
    ReadingQuestion(
      question: 'El texto presenta el teletrabajo…',
      options: ['solo con ventajas', 'con ventajas y desventajas', 'de forma negativa'],
      correctIndex: 1,
      questionTranslation: 'Wie stellt der Text das Homeoffice dar?',
    ),
  ],
);

final QuizContent deEsB2SprechenReclamacion = deEsSpeak(
  id: 'de_es_b2_sprechen_reclamacion',
  title: 'Hablar: una reclamación',
  intro: 'Sich (formell) beschweren – hören und nachsprechen.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Beschwerde + Subjuntivo',
      text: 'Höfliche, aber bestimmte Beschwerde + Subjuntivo: »que me '
          'devolvieran« (Imperfekt-Subj. nach Konditional), »espero que lo '
          'solucionen«.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Ich möchte eine Beschwerde einreichen.', answer: 'Quería poner una reclamación.'),
    CourseItem(prompt: 'Das Produkt kam defekt an.', answer: 'El producto llegó defectuoso.'),
    CourseItem(prompt: 'Das ist nicht das, was ich bestellt hatte.', answer: 'Esto no es lo que había pedido.'),
    CourseItem(prompt: 'Ich hätte gern mein Geld zurück.', answer: 'Me gustaría que me devolvieran el dinero.'),
    CourseItem(prompt: 'Ich verlange schnellstmöglich eine Lösung.', answer: 'Exijo una solución cuanto antes.'),
    CourseItem(prompt: 'Könnte ich den Verantwortlichen sprechen?', answer: '¿Podría hablar con el responsable?'),
    CourseItem(prompt: 'Ich hoffe, Sie lösen es bald.', answer: 'Espero que lo solucionen pronto.'),
  ],
);

final QuizContent deEsB2LesenArticulo = deEsRead(
  id: 'de_es_b2_lesen_articulo',
  title: 'Leer: Artículo de opinión',
  passageTitle: 'Artículo de opinión',
  passage:
      'Vivimos conectados, pero ¿estamos más cerca? Esta es la paradoja de '
      'nuestra época. Las redes sociales prometieron unirnos y, en cierto modo, '
      'lo han hecho: hoy podemos hablar con alguien al otro lado del mundo en '
      'segundos. Sin embargo, muchos estudios sugieren que nunca nos habíamos '
      'sentido tan solos. Pasamos horas mirando las vidas perfectas de los '
      'demás y, sin darnos cuenta, comparamos nuestra realidad con una ilusión. '
      'No se trata de demonizar la tecnología, que ha traído avances '
      'extraordinarios, sino de usarla con cabeza. Quizá deberíamos '
      'preguntarnos, de vez en cuando, si la pantalla nos acerca a quienes '
      'queremos o, al contrario, nos aleja de ellos. La respuesta, '
      'probablemente, esté en nuestras manos.',
  passageTranslation:
      'Wir leben vernetzt, aber sind wir einander näher? Das ist das Paradox '
      'unserer Zeit. Die sozialen Netzwerke versprachen, uns zu verbinden, und '
      'in gewisser Weise haben sie das getan: Heute können wir in Sekunden mit '
      'jemandem auf der anderen Seite der Welt sprechen. Dennoch legen viele '
      'Studien nahe, dass wir uns nie so allein gefühlt haben. Wir verbringen '
      'Stunden damit, auf die perfekten Leben der anderen zu schauen, und '
      'vergleichen, ohne es zu merken, unsere Realität mit einer Illusion. Es '
      'geht nicht darum, die Technik zu verteufeln, die außergewöhnliche '
      'Fortschritte gebracht hat, sondern sie mit Verstand zu nutzen. '
      'Vielleicht sollten wir uns ab und zu fragen, ob der Bildschirm uns denen '
      'näherbringt, die wir lieben, oder uns im Gegenteil von ihnen entfernt. '
      'Die Antwort liegt wahrscheinlich in unseren Händen.',
  intro: 'Abschluss-Lektüre: ein Meinungsartikel (Zertifizierungs-Höhepunkt).',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'B2-Lesen',
      text: 'Rhetorische Frage, Kontrast (sin embargo), Konzession (no se trata '
          'de… sino de…) und vorsichtige Empfehlung (quizá deberíamos).',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '¿Cuál es la paradoja que plantea el autor?',
      options: ['estamos conectados pero solos', 'la tecnología es cara', 'nadie usa redes'],
      correctIndex: 0,
      questionTranslation: 'Welches Paradox stellt der Autor dar?',
    ),
    ReadingQuestion(
      question: '¿Qué prometieron las redes sociales?',
      options: ['unirnos', 'hacernos ricos', 'informarnos'],
      correctIndex: 0,
      questionTranslation: 'Was versprachen die sozialen Netzwerke?',
    ),
    ReadingQuestion(
      question: '¿Qué sugieren los estudios?',
      options: ['que somos más felices', 'que nos sentimos más solos', 'que dormimos mejor'],
      correctIndex: 1,
      questionTranslation: 'Was legen die Studien nahe?',
    ),
    ReadingQuestion(
      question: '¿Con qué comparamos nuestra realidad?',
      options: ['con el pasado', 'con una ilusión', 'con la de nuestros padres'],
      correctIndex: 1,
      questionTranslation: 'Womit vergleichen wir unsere Realität?',
    ),
    ReadingQuestion(
      question: '¿Cuál es la postura del autor sobre la tecnología?',
      options: ['hay que prohibirla', 'usarla con cabeza', 'usarla sin límites'],
      correctIndex: 1,
      questionTranslation: 'Wie steht der Autor zur Technik?',
    ),
    ReadingQuestion(
      question: '¿Dónde está la respuesta, según el final?',
      options: ['en los gobiernos', 'en nuestras manos', 'en las empresas'],
      correctIndex: 1,
      questionTranslation: 'Wo liegt laut Schluss die Antwort?',
    ),
  ],
);

/// Quest B2 in chain order (capstone reading last).
final List<QuizContent> deEsB2 = [
  deEsB2Sociedad,
  deEsB2SubjImperf,
  deEsB2CondicIrreal,
  deEsB2SprechenArgumento,
  deEsB2VerbosCambio,
  deEsB2LesenDebate,
  deEsB2SerEstarAdv,
  deEsB2Concesivas,
  deEsB2Pasiva,
  deEsB2SprechenPresentar,
  deEsB2SubjTemporal,
  deEsB2LesenResena,
  deEsB2Modismos,
  deEsB2LesenTeletrabajo,
  deEsB2SprechenReclamacion,
  deEsB2LesenArticulo,
];
