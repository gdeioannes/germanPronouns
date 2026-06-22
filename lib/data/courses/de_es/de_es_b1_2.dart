import '../../../models/quiz_content.dart';
import 'de_es_builder.dart';

/// Quest B1.2 — Relatos y conjeturas (Erzählen). Deutsch → Spanisch.

final QuizContent deEsB12Tecnologia = deEsFill(
  id: 'de_es_b1_2_tecnologia',
  title: 'La tecnología',
  intro: 'Technologie.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: 'Varianten',
      text: '»el ordenador« (Spanien) / »la computadora« (Lateinamerika). »la '
          'red« = Netz/Netzwerk.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'das Handy', answer: 'el móvil'),
    CourseItem(prompt: 'der Computer', answer: 'el ordenador'),
    CourseItem(prompt: 'der Laptop', answer: 'el portátil'),
    CourseItem(prompt: 'der Bildschirm', answer: 'la pantalla'),
    CourseItem(prompt: 'die App', answer: 'la aplicación'),
    CourseItem(prompt: 'das WLAN', answer: 'el wifi'),
    CourseItem(prompt: 'die Datei', answer: 'el archivo'),
    CourseItem(prompt: 'das Passwort', answer: 'la contraseña'),
    CourseItem(prompt: 'herunterladen', answer: 'descargar'),
    CourseItem(prompt: 'hochladen', answer: 'subir'),
    CourseItem(prompt: 'die sozialen Netzwerke', answer: 'las redes sociales'),
    CourseItem(prompt: 'die Nachricht', answer: 'el mensaje'),
  ],
);

final QuizContent deEsB12Condicional = deEsFill(
  id: 'de_es_b1_2_condicional',
  title: 'Condicional simple',
  intro: 'Die »würde«-Form für Höflichkeit, Rat und Hypothese.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Konjunktiv II',
      text: 'Konditional = Infinitiv + -ía/-ías/-ía/-íamos/-íais/-ían (unreg. '
          'Stämme wie Futur: haría, tendría). Entspricht dt. »würde + '
          'Infinitiv«.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'ich würde sprechen (hablar)', answer: 'hablaría'),
    CourseItem(prompt: 'du würdest essen', answer: 'comerías'),
    CourseItem(prompt: 'er/sie würde leben', answer: 'viviría'),
    CourseItem(prompt: 'wir würden reisen', answer: 'viajaríamos'),
    CourseItem(prompt: 'sie würden arbeiten', answer: 'trabajarían'),
    CourseItem(prompt: 'Ich würde gern kommen.', answer: 'Me gustaría venir.'),
    CourseItem(prompt: 'Könntest du mir helfen?', answer: '¿Podrías ayudarme?'),
    CourseItem(prompt: 'Ich hätte gern einen Kaffee.', answer: 'Querría un café.'),
    CourseItem(prompt: 'An deiner Stelle würde ich gehen.', answer: 'Yo que tú, iría.'),
    CourseItem(prompt: 'ich würde machen (hacer)', answer: 'haría'),
    CourseItem(prompt: 'ich würde haben (tener)', answer: 'tendría'),
    CourseItem(prompt: 'Es wäre besser zu warten.', answer: 'Sería mejor esperar.'),
  ],
);

final QuizContent deEsB12SprechenCortesia = deEsSpeak(
  id: 'de_es_b1_2_sprechen_cortesia',
  title: 'Hablar: pedir con cortesía',
  intro: 'Höflich bitten – hören und nachsprechen.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Höflichkeit',
      text: 'Konditional macht Bitten höflich – wie das deutsche »könnten/würden '
          'Sie«.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Könnten Sie mir bitte helfen?', answer: '¿Podría ayudarme, por favor?'),
    CourseItem(prompt: 'Ich würde gern einen Tisch reservieren.', answer: 'Querría reservar una mesa.'),
    CourseItem(prompt: 'Würde es Ihnen etwas ausmachen, das Fenster zu öffnen?', answer: '¿Le importaría abrir la ventana?'),
    CourseItem(prompt: 'Wäre es möglich, das Datum zu ändern?', answer: '¿Sería posible cambiar la fecha?'),
    CourseItem(prompt: 'Ich würde gern mit dem Direktor sprechen.', answer: 'Me gustaría hablar con el director.'),
    CourseItem(prompt: 'Könntest du mir das Salz reichen?', answer: '¿Podrías pasarme la sal?'),
    CourseItem(prompt: 'An deiner Stelle würde ich gut überlegen.', answer: 'Yo que tú, lo pensaría bien.'),
  ],
);

final QuizContent deEsB12Pluscuamperfecto = deEsFill(
  id: 'de_es_b1_2_pluscuamperfecto',
  title: 'Pluscuamperfecto',
  intro: 'Das Vorvergangene (había + Partizip).',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Brücke',
      text: '»había« + Partizip = das, was VOR einem anderen '
          'Vergangenheitsmoment schon passiert war. Direkte Entsprechung zum '
          'dt. Plusquamperfekt!',
    ),
  ],
  items: const [
    CourseItem(prompt: 'ich hatte gesprochen (hablar)', answer: 'había hablado'),
    CourseItem(prompt: 'du hattest gegessen', answer: 'habías comido'),
    CourseItem(prompt: 'er/sie hatte gelebt', answer: 'había vivido'),
    CourseItem(prompt: 'wir hatten gemacht', answer: 'habíamos hecho'),
    CourseItem(prompt: 'sie hatten gesehen', answer: 'habían visto'),
    CourseItem(prompt: 'Als ich ankam, war er schon gegangen.', answer: 'Cuando llegué, ya se había ido.'),
    CourseItem(prompt: 'Ich hatte nie zuvor Paella gegessen.', answer: 'Nunca había comido paella antes.'),
    CourseItem(prompt: 'Sie sagte, dass sie es vergessen hatte.', answer: 'Dijo que lo había olvidado.'),
    CourseItem(prompt: 'Wir hatten das Haus schon verkauft.', answer: 'Ya habíamos vendido la casa.'),
    CourseItem(prompt: 'Hattest du das gewusst?', answer: '¿Lo habías sabido?'),
  ],
);

final QuizContent deEsB12SubjDuda = deEsFill(
  id: 'de_es_b1_2_subj_duda',
  title: 'Subjuntivo: duda y opinión (no creo que)',
  intro: 'Zweifel und verneinte Meinung mit dem Subjuntivo.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Zweifel = Subjuntivo',
      text: 'Verneinte Meinung / Zweifel / Möglichkeit → Subjuntivo (no creo que '
          'VENGA). Aber bejahte Sicherheit → Indikativ (creo que VIENE).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Ich glaube nicht, dass er kommt.', answer: 'No creo que venga.'),
    CourseItem(prompt: 'Es ist möglich, dass es regnet.', answer: 'Es posible que llueva.'),
    CourseItem(prompt: 'Ich bezweifle, dass das stimmt.', answer: 'Dudo que sea verdad.'),
    CourseItem(prompt: 'Vielleicht kommt er nicht.', answer: 'Quizás no venga.'),
    CourseItem(prompt: 'Es kann sein, dass sie es nicht weiß.', answer: 'Puede que no lo sepa.'),
    CourseItem(prompt: 'Ich denke nicht, dass es leicht ist.', answer: 'No pienso que sea fácil.'),
    CourseItem(prompt: 'Es ist unwahrscheinlich, dass sie gewinnen.', answer: 'Es improbable que ganen.'),
    CourseItem(prompt: 'ABER: Ich glaube, dass er kommt.', answer: 'Creo que viene.'),
    CourseItem(prompt: 'ABER: Es ist sicher, dass er kommt.', answer: 'Es seguro que viene.'),
    CourseItem(prompt: 'Ich bin nicht sicher, dass das gut ist.', answer: 'No estoy seguro de que sea bueno.'),
    CourseItem(prompt: 'Vielleicht haben sie recht.', answer: 'Tal vez tengan razón.'),
  ],
);

final QuizContent deEsB12LesenAnecdota = deEsRead(
  id: 'de_es_b1_2_lesen_anecdota',
  title: 'Leer: Una anécdota de viaje',
  passageTitle: 'Una anécdota de viaje',
  passage:
      'Nunca olvidaré lo que me pasó en mi primer viaje a México. Había llegado '
      'al aeropuerto muy cansado, después de doce horas de vuelo. Cuando fui a '
      'recoger mi maleta, descubrí que la aerolínea la había perdido. No tenía '
      'ropa, ni cepillo de dientes, ni nada. El empleado me dijo que no me '
      'preocupara, que la maleta llegaría al día siguiente. Esa noche dormí con '
      'la misma ropa, un poco enfadado. Pero a la mañana siguiente, un '
      'mensajero me trajo la maleta… ¡y dentro había una botella de tequila '
      'como disculpa! Desde entonces, siempre llevo lo esencial en el equipaje '
      'de mano.',
  passageTranslation:
      'Nie werde ich vergessen, was mir auf meiner ersten Reise nach Mexiko '
      'passierte. Ich war sehr müde am Flughafen angekommen, nach zwölf Stunden '
      'Flug. Als ich meinen Koffer holen wollte, stellte ich fest, dass die '
      'Fluggesellschaft ihn verloren hatte. Ich hatte keine Kleidung, keine '
      'Zahnbürste, nichts. Der Angestellte sagte mir, ich solle mir keine '
      'Sorgen machen, der Koffer komme am nächsten Tag. In jener Nacht schlief '
      'ich in derselben Kleidung, etwas verärgert. Aber am nächsten Morgen '
      'brachte mir ein Bote den Koffer… und darin war eine Flasche Tequila als '
      'Entschuldigung! Seitdem trage ich das Wichtigste immer im Handgepäck.',
  intro: 'Lies eine Reise-Anekdote.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Zeitenfolge',
      text: 'pluscuamperfecto (había llegado/perdido) für Vorvergangenes, '
          'indefinido für die Ereigniskette, indirekte Rede mit Subjuntivo (me '
          'dijo que no me preocupara).',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '¿Cómo llegó el narrador a México?',
      options: ['descansado', 'muy cansado', 'enfermo'],
      correctIndex: 1,
      questionTranslation: 'Wie kam der Erzähler in Mexiko an?',
    ),
    ReadingQuestion(
      question: '¿Qué problema tuvo?',
      options: ['perdió el avión', 'la aerolínea perdió su maleta', 'le robaron'],
      correctIndex: 1,
      questionTranslation: 'Welches Problem hatte er?',
    ),
    ReadingQuestion(
      question: '¿Qué le dijo el empleado?',
      options: ['que comprara ropa', 'que no se preocupara', 'que esperara una semana'],
      correctIndex: 1,
      questionTranslation: 'Was sagte ihm der Angestellte?',
    ),
    ReadingQuestion(
      question: '¿Qué había dentro de la maleta como disculpa?',
      options: ['dinero', 'una botella de tequila', 'una carta'],
      correctIndex: 1,
      questionTranslation: 'Was war als Entschuldigung im Koffer?',
    ),
    ReadingQuestion(
      question: '¿Qué hace ahora siempre?',
      options: ['lleva lo esencial en el equipaje de mano', 'no viaja en avión', 'lo factura todo'],
      correctIndex: 0,
      questionTranslation: 'Was macht er jetzt immer?',
    ),
  ],
);

final QuizContent deEsB12EstiloIndirecto = deEsFill(
  id: 'de_es_b1_2_estilo_indirecto',
  title: 'Estilo indirecto',
  intro: 'Die indirekte Rede.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Zeitverschiebung',
      text: 'presente→imperfecto, indefinido/perfecto→pluscuamperfecto, '
          'futuro→condicional. Bitte/Befehl → que + Imperfekt-Subjuntivo (que '
          'le ayudara).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Er sagt, dass er kommt.', answer: 'Dice que viene.'),
    CourseItem(prompt: 'Er sagte, dass er kam.', answer: 'Dijo que venía.'),
    CourseItem(prompt: 'Sie sagte, dass sie gegessen hatte.', answer: 'Dijo que había comido.'),
    CourseItem(prompt: 'Er fragte, wo ich wohne.', answer: 'Preguntó dónde vivía.'),
    CourseItem(prompt: 'Sie sagte, dass sie anrufen würde.', answer: 'Dijo que llamaría.'),
    CourseItem(prompt: 'Er bat mich, ihm zu helfen.', answer: 'Me pidió que le ayudara.'),
    CourseItem(prompt: 'Sie sagte, ich solle früh kommen.', answer: 'Dijo que viniera pronto.'),
    CourseItem(prompt: 'Er sagte, dass er nicht könne.', answer: 'Dijo que no podía.'),
    CourseItem(prompt: 'Sie fragte, ob ich Zeit habe.', answer: 'Preguntó si tenía tiempo.'),
    CourseItem(prompt: 'Er antwortete, dass er es nicht wisse.', answer: 'Respondió que no lo sabía.'),
  ],
);

final QuizContent deEsB12SubjRelativo = deEsFill(
  id: 'de_es_b1_2_subj_relativo',
  title: 'Subjuntivo en oraciones de relativo',
  intro: 'Relativsätze mit Subjuntivo.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'unbekannt = Subjuntivo',
      text: 'Bezugswort unbekannt/nicht existent → Subjuntivo (busco un piso que '
          'SEA barato). Bekannt/existent → Indikativ (tengo un piso que ES '
          'barato).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Ich suche eine Wohnung, die billig ist. (vielleicht)', answer: 'Busco un piso que sea barato.'),
    CourseItem(prompt: 'Ich habe eine Wohnung, die billig ist. (existiert)', answer: 'Tengo un piso que es barato.'),
    CourseItem(prompt: 'Ich brauche jemanden, der Spanisch spricht.', answer: 'Necesito a alguien que hable español.'),
    CourseItem(prompt: 'Gibt es hier jemanden, der helfen kann?', answer: '¿Hay alguien que pueda ayudar?'),
    CourseItem(prompt: 'Es gibt nichts, was mir gefällt.', answer: 'No hay nada que me guste.'),
    CourseItem(prompt: 'Ich kenne niemanden, der das macht.', answer: 'No conozco a nadie que haga eso.'),
    CourseItem(prompt: 'Wir wollen ein Hotel, das ruhig ist.', answer: 'Queremos un hotel que sea tranquilo.'),
    CourseItem(prompt: 'Kauf, was du willst.', answer: 'Compra lo que quieras.'),
    CourseItem(prompt: 'Ich kenne einen Mann, der dort wohnt.', answer: 'Conozco a un hombre que vive allí.'),
    CourseItem(prompt: 'Such ein Restaurant, das geöffnet hat.', answer: 'Busca un restaurante que esté abierto.'),
  ],
);

final QuizContent deEsB12MedioAmbiente = deEsFill(
  id: 'de_es_b1_2_medioambiente',
  title: 'El medio ambiente',
  intro: 'Die Umwelt.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Artikel',
      text: '»el medio ambiente« immer mit Artikel »el«. »proteger« → yo '
          'protejo (g→j vor o/a).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'die Umwelt', answer: 'el medio ambiente'),
    CourseItem(prompt: 'der Klimawandel', answer: 'el cambio climático'),
    CourseItem(prompt: 'die Umweltverschmutzung', answer: 'la contaminación'),
    CourseItem(prompt: 'der Müll', answer: 'la basura'),
    CourseItem(prompt: 'recyceln', answer: 'reciclar'),
    CourseItem(prompt: 'die erneuerbaren Energien', answer: 'las energías renovables'),
    CourseItem(prompt: 'nachhaltig', answer: 'sostenible'),
    CourseItem(prompt: 'Energie sparen', answer: 'ahorrar energía'),
    CourseItem(prompt: 'die Verschwendung', answer: 'el derroche'),
    CourseItem(prompt: 'schützen', answer: 'proteger'),
    CourseItem(prompt: 'der Treibhauseffekt', answer: 'el efecto invernadero'),
    CourseItem(prompt: 'die Tierart', answer: 'la especie'),
  ],
);

final QuizContent deEsB12SprechenAnecdota = deEsSpeak(
  id: 'de_es_b1_2_sprechen_anecdota',
  title: 'Hablar: contar una anécdota',
  intro: 'Eine Anekdote erzählen – hören und nachsprechen.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Erzählzeiten',
      text: 'imperfecto für die Kulisse (mientras paseaba), indefinido für die '
          'Wendepunkte (vi, fue, salió).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Ich erzähl dir was Unglaubliches.', answer: 'Te voy a contar una cosa increíble.'),
    CourseItem(prompt: 'Neulich, während ich spazieren ging…', answer: 'El otro día, mientras paseaba...'),
    CourseItem(prompt: 'Plötzlich sah ich etwas Seltsames.', answer: 'De repente, vi algo extraño.'),
    CourseItem(prompt: 'Es stellte sich heraus: mein Nachbar.', answer: 'Resulta que era mi vecino.'),
    CourseItem(prompt: 'Am Ende ging alles gut aus.', answer: 'Al final, todo salió bien.'),
    CourseItem(prompt: 'Du wirst es nicht glauben.', answer: 'No te lo vas a creer.'),
    CourseItem(prompt: 'Es war eine sehr lustige Situation.', answer: 'Fue una situación muy graciosa.'),
  ],
);

final QuizContent deEsB12PorPara = deEsFill(
  id: 'de_es_b1_2_por_para',
  title: 'por vs para (consolidación)',
  intro: '»por« und »para« sicher unterscheiden.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'Paare',
      text: 'trabajo PARA una empresa (Ziel) vs trabajo POR dinero (Grund). '
          'para mí (für mich) vs por mí (meinetwegen). Passiv-Urheber mit por.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Danke für deine Hilfe.', answer: 'Gracias por tu ayuda.'),
    CourseItem(prompt: 'Ich tue es für dich (deinetwegen).', answer: 'Lo hago por ti.'),
    CourseItem(prompt: 'Dieses Geschenk ist für dich.', answer: 'Este regalo es para ti.'),
    CourseItem(prompt: 'Ich habe es für 20 Euro gekauft.', answer: 'Lo compré por veinte euros.'),
    CourseItem(prompt: 'Wir kämpfen für die Freiheit.', answer: 'Luchamos por la libertad.'),
    CourseItem(prompt: 'von Cervantes geschrieben', answer: 'escrito por Cervantes'),
    CourseItem(prompt: 'Es ist zu schwer für mich.', answer: 'Es demasiado difícil para mí.'),
    CourseItem(prompt: 'Ich gehe Brot holen.', answer: 'Voy por pan.'),
    CourseItem(prompt: 'für immer', answer: 'para siempre'),
    CourseItem(prompt: 'aus Angst', answer: 'por miedo'),
    CourseItem(prompt: 'um die Prüfung zu bestehen', answer: 'para aprobar el examen'),
  ],
);

final QuizContent deEsB12LesenOpinion = deEsRead(
  id: 'de_es_b1_2_lesen_opinion',
  title: 'Leer: Carta al director',
  passageTitle: 'Carta al director',
  passage:
      'Señor director: Le escribo para expresar mi preocupación por el tráfico '
      'en el centro de nuestra ciudad. Cada mañana, miles de coches colapsan '
      'las calles y el aire es cada vez más irrespirable. Creo que el '
      'ayuntamiento debería invertir más en transporte público y crear más '
      'carriles para bicicletas. No es justo que los ciudadanos tengamos que '
      'pasar horas en atascos mientras la contaminación aumenta. Si no hacemos '
      'nada ahora, nuestros hijos pagarán las consecuencias. Espero que las '
      'autoridades tomen medidas pronto. Atentamente, una vecina preocupada.',
  passageTranslation:
      'Sehr geehrter Herr Direktor: Ich schreibe Ihnen, um meine Sorge über den '
      'Verkehr im Zentrum unserer Stadt auszudrücken. Jeden Morgen verstopfen '
      'Tausende Autos die Straßen und die Luft wird immer unerträglicher. Ich '
      'finde, die Stadtverwaltung sollte mehr in den öffentlichen Nahverkehr '
      'investieren und mehr Fahrradwege schaffen. Es ist nicht gerecht, dass '
      'wir Bürger Stunden im Stau verbringen müssen, während die '
      'Umweltverschmutzung zunimmt. Wenn wir jetzt nichts tun, werden unsere '
      'Kinder die Folgen tragen. Ich hoffe, die Behörden ergreifen bald '
      'Maßnahmen. Mit freundlichen Grüßen, eine besorgte Anwohnerin.',
  intro: 'Lies einen Leserbrief an die Zeitung.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Meinung + Subjuntivo',
      text: '»debería« (Konditional, Rat), »no es justo que… tengamos« + '
          'Subjuntivo, »espero que tomen« + Subjuntivo – alles in einem Text.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '¿De qué se queja la autora?',
      options: ['del ruido', 'del tráfico y la contaminación', 'de los impuestos'],
      correctIndex: 1,
      questionTranslation: 'Worüber beschwert sich die Autorin?',
    ),
    ReadingQuestion(
      question: '¿Qué propone?',
      options: ['más coches', 'más transporte público y carriles bici', 'cerrar la ciudad'],
      correctIndex: 1,
      questionTranslation: 'Was schlägt sie vor?',
    ),
    ReadingQuestion(
      question: '¿Quién debería invertir, según ella?',
      options: ['los ciudadanos', 'el ayuntamiento', 'las empresas'],
      correctIndex: 1,
      questionTranslation: 'Wer sollte investieren?',
    ),
    ReadingQuestion(
      question: '¿Qué pasará si no se hace nada?',
      options: ['nada', 'los hijos pagarán las consecuencias', 'subirán los precios'],
      correctIndex: 1,
      questionTranslation: 'Was passiert, wenn nichts getan wird?',
    ),
    ReadingQuestion(
      question: '¿Qué tono tiene la carta?',
      options: ['humorístico', 'crítico y formal', 'indiferente'],
      correctIndex: 1,
      questionTranslation: 'Welchen Ton hat der Brief?',
    ),
  ],
);

final QuizContent deEsB12Conectores = deEsFill(
  id: 'de_es_b1_2_conectores',
  title: 'Conectores del discurso',
  intro: 'Verbindungswörter für flüssige Texte.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'sin embargo / como',
      text: '»sin embargo« (jedoch) leitet formell einen Gegensatz ein. »como« '
          'am Satzanfang = »da/weil«: Como llovía, no salimos.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'aber / jedoch', answer: 'sin embargo'),
    CourseItem(prompt: 'obwohl', answer: 'aunque'),
    CourseItem(prompt: 'deshalb / daher', answer: 'por eso'),
    CourseItem(prompt: 'weil', answer: 'porque'),
    CourseItem(prompt: 'da / weil (Satzanfang)', answer: 'como'),
    CourseItem(prompt: 'außerdem', answer: 'además'),
    CourseItem(prompt: 'zum Beispiel', answer: 'por ejemplo'),
    CourseItem(prompt: 'das heißt / also', answer: 'es decir'),
    CourseItem(prompt: 'trotzdem', answer: 'aun así'),
    CourseItem(prompt: 'schließlich', answer: 'por último'),
    CourseItem(prompt: 'einerseits', answer: 'por un lado'),
    CourseItem(prompt: 'andererseits', answer: 'por otro lado'),
  ],
);

final QuizContent deEsB12LesenNoticia = deEsRead(
  id: 'de_es_b1_2_lesen_noticia',
  title: 'Leer: Un perro héroe',
  passageTitle: 'Un perro héroe',
  passage:
      'Un perro salvó la vida de una familia en un pueblo de Asturias la semana '
      'pasada. Según los vecinos, el animal empezó a ladrar a las tres de la '
      'madrugada, cuando un incendio se había iniciado en la cocina. Gracias a '
      'sus ladridos, la familia se despertó a tiempo y pudo salir de la casa '
      'sin heridas. Los bomberos, que llegaron media hora después, afirmaron '
      'que, si el perro no hubiera avisado, la tragedia habría sido inevitable. '
      'El alcalde del pueblo ha prometido darle una medalla al valiente animal.',
  passageTranslation:
      'Ein Hund rettete letzte Woche einer Familie in einem Dorf in Asturien '
      'das Leben. Laut den Nachbarn fing das Tier um drei Uhr morgens an zu '
      'bellen, als in der Küche ein Feuer ausgebrochen war. Dank seines Bellens '
      'wachte die Familie rechtzeitig auf und konnte das Haus unverletzt '
      'verlassen. Die Feuerwehr, die eine halbe Stunde später eintraf, '
      'bestätigte, dass die Tragödie unvermeidlich gewesen wäre, wenn der Hund '
      'nicht gewarnt hätte. Der Bürgermeister des Dorfes hat versprochen, dem '
      'tapferen Tier eine Medaille zu verleihen.',
  intro: 'Lies eine kurze Zeitungsnachricht.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Vorschau B2',
      text: '»se había iniciado« (pluscuamperfecto). »Si no hubiera avisado, '
          'habría sido…« ist ein irrealer Bedingungssatz der Vergangenheit – '
          'volle Behandlung in B2.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '¿Qué hizo el perro?',
      options: ['Despertó al vecino', 'Salvó a una familia', 'Apagó el fuego'],
      correctIndex: 1,
      questionTranslation: 'Was machte der Hund?',
    ),
    ReadingQuestion(
      question: '¿Cuándo empezó a ladrar?',
      options: ['Por la tarde', 'A las tres de la madrugada', 'Al mediodía'],
      correctIndex: 1,
      questionTranslation: 'Wann fing er an zu bellen?',
    ),
    ReadingQuestion(
      question: '¿Por qué ladraba?',
      options: ['Tenía hambre', 'Había un incendio', 'Quería salir'],
      correctIndex: 1,
      questionTranslation: 'Warum bellte er?',
    ),
    ReadingQuestion(
      question: '¿Cómo salió la familia?',
      options: ['Con heridas graves', 'Sin heridas', 'En ambulancia'],
      correctIndex: 1,
      questionTranslation: 'Wie kam die Familie heraus?',
    ),
    ReadingQuestion(
      question: '¿Qué prometió el alcalde?',
      options: ['Dinero', 'Darle una medalla', 'Una casa nueva'],
      correctIndex: 1,
      questionTranslation: 'Was versprach der Bürgermeister?',
    ),
  ],
);

final QuizContent deEsB12SprechenTelefono = deEsSpeak(
  id: 'de_es_b1_2_sprechen_telefono',
  title: 'Hablar: una llamada de teléfono',
  intro: 'Am Telefon – hören und nachsprechen.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Telefonfloskeln',
      text: '»ahora se pone« = er kommt gleich ans Telefon. »dígale« (Imperativ '
          'usted + Pronomen).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Hallo? (am Telefon)', answer: '¿Diga?'),
    CourseItem(prompt: 'Ist Pablo da, bitte?', answer: '¿Está Pablo, por favor?'),
    CourseItem(prompt: 'Hier ist Anna, könnte ich ihn sprechen?', answer: 'Soy Anna, ¿podría hablar con él?'),
    CourseItem(prompt: 'Einen Moment, er kommt gleich.', answer: 'Un momento, ahora se pone.'),
    CourseItem(prompt: 'Tut mir leid, er ist gerade nicht da.', answer: 'Lo siento, en este momento no está.'),
    CourseItem(prompt: 'Möchten Sie ihm etwas ausrichten?', answer: '¿Quiere dejarle un mensaje?'),
    CourseItem(prompt: 'Sagen Sie ihm bitte, dass ich angerufen habe.', answer: 'Dígale que le he llamado, por favor.'),
  ],
);

/// Quest B1.2 in chain order.
final List<QuizContent> deEsB1_2 = [
  deEsB12Tecnologia,
  deEsB12Condicional,
  deEsB12SprechenCortesia,
  deEsB12Pluscuamperfecto,
  deEsB12SubjDuda,
  deEsB12LesenAnecdota,
  deEsB12EstiloIndirecto,
  deEsB12SubjRelativo,
  deEsB12MedioAmbiente,
  deEsB12SprechenAnecdota,
  deEsB12PorPara,
  deEsB12LesenOpinion,
  deEsB12Conectores,
  deEsB12LesenNoticia,
  deEsB12SprechenTelefono,
];
