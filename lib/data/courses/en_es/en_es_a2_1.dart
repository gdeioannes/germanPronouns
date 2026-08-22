import '../../../models/quiz_content.dart';
import 'en_es_builder.dart';

/// A2.1 — The past, twice. English → Spanish.
///
/// Big rocks: the preterite (regular + the key irregulars), the imperfect,
/// and the contrast English merges into one past (⚑E14); childhood
/// memories, anecdotes, and hace…que.

final QuizContent enEsA21Preterite = enEsFill(
  id: 'en_es_a2_1_preterite',
  title: 'The preterite: hablé, comí, viví',
  intro: 'Completed past actions: -ar → hablé, hablaste, habló…; -er/-ir '
      '→ comí, comiste, comió… Note the accents on yo and él (⚑E5).',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: 'hablo vs habló',
      text: 'The accent IS the tense: hablo = I speak, habló = he spoke. '
          'Type the accent or change the meaning.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'I spoke with María yesterday.', answer: '**Hablé** con María ayer.'),
    CourseItem(prompt: 'She bought bread.', answer: '**Compró** pan.'),
    CourseItem(prompt: 'We ate paella.', answer: '**Comimos** paella.'),
    CourseItem(prompt: 'He lived in Peru for two years.', answer: '**Vivió** dos años en Perú.'),
    CourseItem(prompt: 'I worked a lot last week.', answer: '**Trabajé** mucho la semana pasada.'),
    CourseItem(prompt: 'Did you eat? (tú)', answer: '¿**Comiste**?'),
    CourseItem(prompt: 'They travelled to Chile.', answer: '**Viajaron** a Chile.'),
    CourseItem(prompt: 'She wrote three letters.', answer: '**Escribió** tres cartas.'),
    CourseItem(prompt: 'I opened the window.', answer: '**Abrí** la ventana.'),
    CourseItem(prompt: 'We danced all night.', answer: '**Bailamos** toda la noche.'),
    CourseItem(prompt: 'He sold his car.', answer: '**Vendió** su coche.'),
    CourseItem(prompt: 'I drank too much coffee.', answer: '**Bebí** demasiado café.'),
    CourseItem(prompt: 'You studied a lot. (tú)', answer: '**Estudiaste** mucho.'),
    CourseItem(prompt: 'They returned home late. (volver)', answer: '**Volvieron** a casa tarde.'),
    CourseItem(prompt: 'She called me on Sunday.', answer: 'Me **llamó** el domingo.'),
  ],
);

final QuizContent enEsA21IrregularPret = enEsFill(
  id: 'en_es_a2_1_irregular_pret',
  title: 'Irregular preterites: fui, tuve, hice',
  intro: 'The most used verbs are irregular — and accentless: fui, tuve, '
      'hice, estuve, pude, dije. ser and ir share fui!',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'The top set',
      text: 'ir/ser→fui · tener→tuve · hacer→hice · estar→estuve · '
          'poder→pude · decir→dije · ver→vi · dar→di.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'I went to the cinema.', answer: '**Fui** al cine.'),
    CourseItem(prompt: 'It was a great day. (ser)', answer: '**Fue** un gran día.'),
    CourseItem(prompt: 'I had a problem.', answer: '**Tuve** un problema.'),
    CourseItem(prompt: 'She did her homework.', answer: '**Hizo** sus deberes.'),
    CourseItem(prompt: 'We were in Cusco. (estar)', answer: '**Estuvimos** en Cusco.'),
    CourseItem(prompt: 'I couldn\'t sleep.', answer: 'No **pude** dormir.'),
    CourseItem(prompt: 'He told me the truth.', answer: 'Me **dijo** la verdad.'),
    CourseItem(prompt: 'I saw that film.', answer: '**Vi** esa película.'),
    CourseItem(prompt: 'They went to the beach.', answer: '**Fueron** a la playa.'),
    CourseItem(prompt: 'She gave me a book.', answer: 'Me **dio** un libro.'),
    CourseItem(prompt: 'We did a lot yesterday.', answer: '**Hicimos** mucho ayer.'),
    CourseItem(prompt: 'I put the keys here. (poner)', answer: '**Puse** las llaves aquí.'),
    CourseItem(prompt: 'You came late. (venir, tú)', answer: '**Viniste** tarde.'),
    CourseItem(prompt: 'There was a party. (haber)', answer: '**Hubo** una fiesta.'),
    CourseItem(prompt: 'I wanted to call you. (querer)', answer: '**Quise** llamarte.'),
  ],
);

final QuizContent enEsA21Imperfect = enEsFill(
  id: 'en_es_a2_1_imperfect',
  title: 'The imperfect: hablaba, comía',
  intro: 'The background past: what USED TO happen or WAS happening. '
      '-ar → hablaba; -er/-ir → comía. Only three irregulars: era, iba, '
      'veía.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Only three irregulars',
      text: 'ser→era, ir→iba, ver→veía. Everything else is regular — the '
          'friendliest tense in Spanish.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'I used to live in the countryside.', answer: '**Vivía** en el campo.'),
    CourseItem(prompt: 'When I was a child… (ser)', answer: 'Cuando **era** niño…'),
    CourseItem(prompt: 'We used to play in the street.', answer: '**Jugábamos** en la calle.'),
    CourseItem(prompt: 'She always sang at home.', answer: 'Siempre **cantaba** en casa.'),
    CourseItem(prompt: 'It was raining.', answer: '**Llovía**.'),
    CourseItem(prompt: 'My grandmother cooked every Sunday.', answer: 'Mi abuela **cocinaba** todos los domingos.'),
    CourseItem(prompt: 'I used to go to the beach. (ir)', answer: '**Iba** a la playa.'),
    CourseItem(prompt: 'There were many trees. (haber)', answer: '**Había** muchos árboles.'),
    CourseItem(prompt: 'We used to watch cartoons. (ver)', answer: '**Veíamos** dibujos animados.'),
    CourseItem(prompt: 'He was tall and thin. (ser)', answer: '**Era** alto y delgado.'),
    CourseItem(prompt: 'The house was old. (estar → ser!)', answer: 'La casa **era** vieja.'),
    CourseItem(prompt: 'I read a lot as a teenager.', answer: '**Leía** mucho de adolescente.'),
    CourseItem(prompt: 'They lived near the sea.', answer: '**Vivían** cerca del mar.'),
    CourseItem(prompt: 'You used to have long hair. (tú)', answer: '**Tenías** el pelo largo.'),
    CourseItem(prompt: 'It was five o\'clock. (ser)', answer: '**Eran** las cinco.'),
  ],
);

final QuizContent enEsA21Contrast = enEsFill(
  id: 'en_es_a2_1_contrast',
  title: 'Preterite or imperfect? The big contrast',
  intro: 'The heart of Spanish storytelling (⚑E14): imperfect paints the '
      'scene, preterite fires the events. English "was/used to" → '
      'imperfect; one-off done deals → preterite.',
  tips: const [
    HelpMemoryTip(
      kind: 'mnemonic',
      title: 'Camera test',
      text: 'Background video → imperfect (llovía, era tarde). Snapshot '
          'click → preterite (entró, llamó, vi).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'I was sleeping when you called.', answer: '**Dormía** cuando llamaste.'),
    CourseItem(prompt: '…when you called. (the click)', answer: 'Dormía cuando **llamaste**.'),
    CourseItem(prompt: 'It was raining, so I took a taxi. (scene)', answer: '**Llovía**, así que tomé un taxi.'),
    CourseItem(prompt: '…so I took a taxi. (the click)', answer: 'Llovía, así que **tomé** un taxi.'),
    CourseItem(prompt: 'When I was ten, we moved house. (scene)', answer: 'Cuando **tenía** diez años, nos mudamos.'),
    CourseItem(prompt: '…we moved house. (the click)', answer: 'Cuando tenía diez años, nos **mudamos**.'),
    CourseItem(prompt: 'She was reading while I cooked. (both scenes)', answer: '**Leía** mientras yo cocinaba.'),
    CourseItem(prompt: 'Yesterday I saw María. (click)', answer: 'Ayer **vi** a María.'),
    CourseItem(prompt: 'As a child he was very shy. (description)', answer: 'De niño **era** muy tímido.'),
    CourseItem(prompt: 'Suddenly the phone rang. (click, sonar)', answer: 'De repente **sonó** el teléfono.'),
    CourseItem(prompt: 'The party was at Ana\'s place. (setting, ser)', answer: 'La fiesta **era** en casa de Ana.'),
    CourseItem(prompt: 'One day everything changed. (click)', answer: 'Un día todo **cambió**.'),
    CourseItem(prompt: 'We always went to the same beach. (habit)', answer: 'Siempre **íbamos** a la misma playa.'),
    CourseItem(prompt: 'But that summer we went to the mountains. (click)', answer: 'Pero ese verano **fuimos** a la montaña.'),
    CourseItem(prompt: 'I was tired and went to bed. (state + click)', answer: 'Estaba cansado y me **acosté**.'),
  ],
);

final QuizContent enEsA21SpeakStory = enEsSpeak(
  id: 'en_es_a2_1_speak_story',
  title: 'Speak: telling a story',
  intro: 'Story-opening phrases. Repeat with the rhythm of someone about '
      'to tell a good one.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'The golden skeleton',
      text: 'Era + scene, estaba + state, de repente + preterite. That '
          'template opens any Spanish anecdote.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'It was a cold winter night.', answer: 'Era una noche fría de invierno.'),
    CourseItem(prompt: 'I was coming home from work.', answer: 'Volvía a casa del trabajo.'),
    CourseItem(prompt: 'Suddenly I heard a noise.', answer: 'De repente oí un ruido.'),
    CourseItem(prompt: 'You won\'t believe what happened.', answer: 'No vas a creer lo que pasó.'),
    CourseItem(prompt: 'When I was little, I lived there.', answer: 'Cuando era pequeño, vivía allí.'),
    CourseItem(prompt: 'In the end everything went well.', answer: 'Al final todo salió bien.'),
    CourseItem(prompt: 'And you know what?', answer: '¿Y sabes qué?'),
    CourseItem(prompt: 'It was the fright of my life.', answer: 'Fue el susto de mi vida.'),
  ],
);

final QuizContent enEsA21ListenTrip = enEsListen(
  id: 'en_es_a2_1_listen_trip',
  title: 'Listening: El viaje a Oaxaca',
  passageTitle: 'Un fin de semana en Oaxaca',
  passage:
      'El mes pasado Daniel y yo fuimos a Oaxaca en autobús. El viaje '
      'duró seis horas, pero el paisaje era precioso. El sábado '
      'visitamos el mercado y comimos tlayudas. Hacía mucho calor, así '
      'que por la tarde descansamos en el hotel. El domingo compramos '
      'regalos y volvimos a casa, cansados pero muy contentos.',
  passageTranslation:
      'Last month Daniel and I went to Oaxaca by bus. The trip took six '
      'hours, but the scenery was beautiful. On Saturday we visited the '
      'market and ate tlayudas. It was very hot, so in the afternoon we '
      'rested at the hotel. On Sunday we bought presents and returned '
      'home, tired but very happy.',
  intro: 'A weekend trip told in the two pasts. Listen for which verbs '
      'paint and which ones click.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'era / hacía = scenery',
      text: 'el paisaje era precioso, hacía calor — the imperfect paints. '
          'fuimos, visitamos, compramos — the preterite moves the story.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '¿Cómo viajaron a Oaxaca?',
      options: ['En coche', 'En autobús', 'En avión'],
      correctIndex: 1,
      questionTranslation: 'How did they travel to Oaxaca?',
    ),
    ReadingQuestion(
      question: '¿Por qué descansaron por la tarde?',
      options: ['Llovía', 'Hacía mucho calor', 'Estaban enfermos'],
      correctIndex: 1,
      questionTranslation: 'Why did they rest in the afternoon?',
    ),
    ReadingQuestion(
      question: '¿Qué hicieron el domingo?',
      options: [
        'Visitaron el mercado',
        'Compraron regalos y volvieron a casa',
        'Comieron tlayudas',
      ],
      correctIndex: 1,
      questionTranslation: 'What did they do on Sunday?',
    ),
  ],
);

final QuizContent enEsA21HaceQue = enEsFill(
  id: 'en_es_a2_1_hace_que',
  title: 'hace… que: ago and for',
  intro: 'hace dos años = two years ago · Hace dos años que vivo aquí = '
      'I have lived here for two years. One little hace, two big jobs.',
  tips: const [
    HelpMemoryTip(
      kind: 'rule',
      title: 'The two patterns',
      text: 'Llegué hace una hora (ago, with preterite) · Hace un año que '
          'estudio español (for, with PRESENT — Spanish stays present!).',
    ),
  ],
  items: const [
    CourseItem(prompt: 'I arrived an hour ago.', answer: 'Llegué **hace** una hora.'),
    CourseItem(prompt: 'They moved two years ago.', answer: 'Se mudaron **hace** dos años.'),
    CourseItem(prompt: 'I have studied Spanish for a year.', answer: '**Hace** un año que estudio español.'),
    CourseItem(prompt: 'We met ten years ago. (conocerse)', answer: 'Nos conocimos **hace** diez años.'),
    CourseItem(prompt: 'She has lived here for six months.', answer: '**Hace** seis meses que vive aquí.'),
    CourseItem(prompt: 'He called five minutes ago.', answer: 'Llamó **hace** cinco minutos.'),
    CourseItem(prompt: 'How long have you worked here? ', answer: '¿Cuánto **hace** que trabajas aquí?'),
    CourseItem(prompt: 'I have known her for years. (conocer)', answer: '**Hace** años que la conozco.'),
    CourseItem(prompt: 'It rained a week ago.', answer: 'Llovió **hace** una semana.'),
    CourseItem(prompt: 'I haven\'t seen him for a long time.', answer: '**Hace** mucho que no lo veo.'),
    CourseItem(prompt: 'We bought the house a long time ago.', answer: 'Compramos la casa **hace** mucho tiempo.'),
    CourseItem(prompt: 'I have waited for twenty minutes.', answer: '**Hace** veinte minutos que espero.'),
    CourseItem(prompt: 'She left three days ago. (irse)', answer: 'Se fue **hace** tres días.'),
    CourseItem(prompt: 'It has been cold for a week.', answer: '**Hace** una semana que hace frío.'),
    CourseItem(prompt: 'They have been married for a year. (estar casados)', answer: '**Hace** un año que están casados.'),
  ],
);

final QuizContent enEsA21SpeakingMid = enEsSpeaking(
  id: 'en_es_a2_1_speaking_mid',
  title: 'Conversation: yesterday',
  level: 'A2.1',
  topic: 'A simple chat in Spanish about what I did yesterday and last '
      'weekend: where I went, what I ate, who I saw.',
  practisePoints: [
    'Preterite of regular verbs and fui/tuve/hice',
    'Imperfect for scene and weather: hacía sol, era tarde',
    'Time markers: ayer, la semana pasada, hace dos días',
  ],
  scoringCriteria: [
    'Preterite forms correct including irregulars',
    'Scene vs event tense chosen sensibly',
    'hace used for "ago"',
  ],
  priorityErrors: [
    'present used instead of past',
    'imperfect and preterite swapped on obvious clicks',
    'missing accents changing person (hablo/habló) in feedback',
  ],
  mode: SpeakingMode.conversation,
  session: const SpeakingSession(
    durationMinutes: 3,
    minExchanges: 6,
    minQuestionsPerPoint: 1,
  ),
  intro: 'Checkpoint: tell your AI assistant about yesterday, in Spanish. '
      'Copy, speak, bring back the score.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Three anchor sentences',
      text: 'Ayer fui a… Comí con… Por la noche vi… — three anchors and '
          'the conversation flows.',
    ),
  ],
);

final QuizContent enEsA21ReadChildhood = enEsRead(
  id: 'en_es_a2_1_read_childhood',
  title: 'Reading: La infancia de doña Rosa',
  passageTitle: 'La infancia de doña Rosa',
  passage:
      'Doña Rosa nació en un pueblo pequeño cerca de Valencia. Su familia '
      'tenía una huerta con naranjos. Cuando era niña, se levantaba a las '
      'seis y ayudaba a su padre antes de ir a la escuela. No había '
      'televisión, así que por las noches su abuela contaba historias. A '
      'los dieciocho años, doña Rosa se mudó a la ciudad y encontró '
      'trabajo en una panadería. Allí conoció a su marido. «Fueron años '
      'difíciles», dice, «pero también los más felices de mi vida».',
  passageTranslation:
      'Doña Rosa was born in a small village near Valencia. Her family '
      'had an orchard with orange trees. When she was a girl, she got up '
      'at six and helped her father before going to school. There was no '
      'television, so at night her grandmother told stories. At eighteen, '
      'doña Rosa moved to the city and found work in a bakery. There she '
      'met her husband. "They were hard years," she says, "but also the '
      'happiest of my life."',
  intro: 'A short biography. Watch the two pasts at work: tenía, era, '
      'había paint; nació, se mudó, conoció click.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'conocer in the preterite = met',
      text: 'conocía = knew · conoció = met (first time). Some verbs '
          'change meaning between the two pasts — collect them.',
    ),
  ],
  questions: const [
    ReadingQuestion(
      question: '¿Dónde nació doña Rosa?',
      options: [
        'En Valencia capital',
        'En un pueblo cerca de Valencia',
        'En Madrid',
      ],
      correctIndex: 1,
      questionTranslation: 'Where was doña Rosa born?',
    ),
    ReadingQuestion(
      question: '¿Qué hacía su abuela por las noches?',
      options: ['Veía la televisión', 'Contaba historias', 'Trabajaba en la huerta'],
      correctIndex: 1,
      questionTranslation: 'What did her grandmother do at night?',
    ),
    ReadingQuestion(
      question: '¿Dónde conoció a su marido?',
      options: ['En la escuela', 'En una panadería', 'En la huerta'],
      correctIndex: 1,
      questionTranslation: 'Where did she meet her husband?',
    ),
  ],
);

final QuizContent enEsA21Food = enEsVocab(
  id: 'en_es_a2_1_food',
  title: 'Food · La comida',
  intro: 'Everyday food vocabulary — with a regional note or two.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: '⚑E28 Regional menu',
      text: 'las papas (LatAm) = las patatas (Spain); el jugo (LatAm) = '
          'el zumo (Spain). Both always understood.',
    ),
  ],
  pairs: const [
    MapEntry('bread', 'el pan'),
    MapEntry('milk', 'la leche'),
    MapEntry('egg', 'el huevo'),
    MapEntry('cheese', 'el queso'),
    MapEntry('meat', 'la carne'),
    MapEntry('fish (food)', 'el pescado'),
    MapEntry('chicken', 'el pollo'),
    MapEntry('rice', 'el arroz'),
    MapEntry('vegetables', 'las verduras'),
    MapEntry('apple', 'la manzana'),
    MapEntry('juice (LatAm)', 'el jugo'),
    MapEntry('potatoes (LatAm)', 'las papas'),
  ],
);

final QuizContent enEsA21Dict = enEsDict(
  id: 'en_es_a2_1_dict',
  title: 'Dictation: in the past',
  intro: 'Listen and type. The key: hear the difference between hablo '
      'and habló — the stress carries the tense.',
  tips: const [
    HelpMemoryTip(
      kind: 'warning',
      title: '⚑E5 Stress = tense',
      text: 'TRA-ba-jo (present) vs tra-ba-JÓ (preterite). If the last '
          'syllable booms, write the accent.',
    ),
  ],
  items: const [
    CourseItem(prompt: 'Yesterday I worked a lot.', answer: 'Ayer trabajé mucho.'),
    CourseItem(prompt: 'She went to the market.', answer: 'Fue al mercado.'),
    CourseItem(prompt: 'We ate paella on Sunday.', answer: 'Comimos paella el domingo.'),
    CourseItem(prompt: 'When I was a child, I lived in Leeds.', answer: 'Cuando era niño, vivía en Leeds.'),
    CourseItem(prompt: 'It was raining a lot.', answer: 'Llovía mucho.'),
    CourseItem(prompt: 'I couldn\'t sleep.', answer: 'No pude dormir.'),
    CourseItem(prompt: 'There were many people in the square.', answer: 'Había mucha gente en la plaza.'),
    CourseItem(prompt: 'The party was fantastic.', answer: 'La fiesta fue fantástica.'),
    CourseItem(prompt: 'We arrived an hour ago.', answer: 'Llegamos hace una hora.'),
    CourseItem(prompt: 'She wrote three letters.', answer: 'Escribió tres cartas.'),
    CourseItem(prompt: 'The children played in the park.', answer: 'Los niños jugaban en el parque.'),
    CourseItem(prompt: 'I didn\'t say anything.', answer: 'No dije nada.'),
    CourseItem(prompt: 'He came home late.', answer: 'Volvió a casa tarde.'),
    CourseItem(prompt: 'My grandmother told stories.', answer: 'Mi abuela contaba historias.'),
    CourseItem(prompt: 'Suddenly the phone rang.', answer: 'De repente sonó el teléfono.'),
  ],
);

final QuizContent enEsA21BigText = enEsBigText(
  id: 'en_es_a2_1_bigtext',
  title: 'Big text: Un lunes extraño',
  passageTitle: 'Un lunes extraño',
  intro: 'Complete the story: preterite or imperfect in every gap.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'Paint or click?',
      text: 'Read the whole story first. Then per gap: background '
          'painting → imperfect; plot advancing → preterite.',
    ),
  ],
  template:
      'El lunes pasado {{0}} un día extraño. Me levanté tarde porque el '
      'despertador no {{1}}. Cuando salí de casa, {{2}} mucho frío y la '
      'calle {{3}} vacía. Caminé al trabajo y {{4}} a las diez. La '
      'oficina estaba cerrada. Entonces {{5}} un mensaje en la puerta: '
      '«Hoy es festivo». Yo no lo {{6}}. Así que {{7}} a casa, me hice '
      'un café grande y {{8}} películas todo el día. ¡{{9}} un lunes '
      'perfecto al final!',
  blanks: [
    inputBlank('fue'),
    inputBlank('sonó', accepted: ['funcionó']),
    inputBlank('hacía'),
    inputBlank('estaba'),
    inputBlank('llegué'),
    inputBlank('vi', accepted: ['leí', 'encontré']),
    inputBlank('sabía'),
    inputBlank('volví', accepted: ['regresé']),
    inputBlank('vi'),
    inputBlank('Fue'),
  ],
  passageTranslation:
      'Last Monday was a strange day. I got up late because the alarm '
      'didn\'t ring. When I left the house, it was very cold and the '
      'street was empty. I walked to work and arrived at ten. The office '
      'was closed. Then I saw a message on the door: "Today is a '
      'holiday." I didn\'t know. So I went back home, made myself a big '
      'coffee and watched films all day. It was a perfect Monday in the '
      'end!',
);

final QuizContent enEsA21SpeakingClose = enEsSpeaking(
  id: 'en_es_a2_1_speaking_close',
  title: 'Final conversation: my story',
  level: 'A2.1',
  topic: 'An interview in Spanish about your past: your childhood, your '
      'school years, a trip you loved, and what you did last weekend.',
  practisePoints: [
    'Imperfect for childhood habits: vivía, jugaba, era',
    'Preterite for events: fui, conocí, me mudé',
    'The contrast inside one story',
    'hace…que and hace + time for ago/for',
  ],
  scoringCriteria: [
    'Both pasts used, each in its role',
    'Irregular preterites correct',
    'Story connected with luego, después, al final',
  ],
  targetVocabulary: [
    'cuando era niño', 'fui', 'había', 'de repente', 'hace … años',
  ],
  priorityErrors: [
    'one single past for everything',
    'era/fue swapped on descriptions',
    'present leaking into the story',
  ],
  mode: SpeakingMode.interview,
  intro: 'Module A2.1 closer: your past, in Spanish, in your AI '
      'assistant. Copy, speak, bring back the score.',
  tips: const [
    HelpMemoryTip(
      kind: 'tip',
      title: 'One story, two cameras',
      text: 'Set the scene in imperfect, fire the events in preterite, '
          'close with al final. That structure carries any anecdote.',
    ),
  ],
);

/// A2.1 in chain order.
final List<QuizContent> enEsA2_1 = [
  enEsA21Preterite,
  enEsA21IrregularPret,
  enEsA21Imperfect,
  enEsA21Contrast,
  enEsA21SpeakStory,
  enEsA21ListenTrip,
  enEsA21HaceQue,
  enEsA21SpeakingMid,
  enEsA21ReadChildhood,
  enEsA21Food,
  enEsA21Dict,
  enEsA21BigText,
  enEsA21SpeakingClose,
];
