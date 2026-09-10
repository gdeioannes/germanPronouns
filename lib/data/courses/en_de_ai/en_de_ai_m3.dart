import '../../../models/quiz_content.dart';
import 'en_de_ai_builder.dart';

/// M3 · A2.1 — *Erlebnisse* (Experiences).
///
/// Can-do: tell what happened yesterday/last weekend; describe a trip;
/// give and follow directions; talk about locations and giving/receiving.
/// Grammar: Perfekt with haben/sein; dative articles & pronouns; dative
/// verbs (helfen, gefallen, gehören); dative prepositions
/// (mit/nach/bei/von/zu/aus); imperative (Sie/du); ordinals & dates.
///
/// A2 session shape: ~4 minutes, 7 exchanges, pass 50 (the manifest default).
const _a2Session = SpeakingSession(durationMinutes: 4, minExchanges: 7);

/// The Perfekt: haben/sein + participle at the end.
const List<HelpMemoryTip> _perfektTips = [
  HelpMemoryTip(
    kind: 'rule',
    title: 'The Perfekt bracket',
    text:
        'Auxiliary in position 2, participle at the very end: ich **habe** '
        'gestern Pizza **gegessen**. Regular participles are ge- + stem + '
        '-t: **gemacht**, **gekauft**, **gespielt**. Irregular ones keep '
        'ge-…-en, often with a vowel change: **gegessen**, **getrunken**, '
        '**geschrieben**, **gefahren**.',
  ),
  HelpMemoryTip(
    kind: 'rule',
    title: 'haben or sein?',
    text:
        'Movement or change of state takes sein: **ist gegangen**, **ist '
        'gefahren**, **ist geflogen**, **ist gekommen**, **ist '
        'aufgestanden** — plus the two cheats **ist geblieben** and **ist '
        'passiert**. Everything you do to something takes haben: **hat '
        'gemacht**, **hat gesehen**, **hat geholfen**.',
  ),
  HelpMemoryTip(
    kind: 'warning',
    title: 'No ge- for -ieren and be-/ver-',
    text:
        'Verbs in -ieren and inseparable prefixes (be-, ver-, er-) refuse '
        'ge-: hat **passiert** is wrong — es **ist passiert**; hat '
        '**besucht**, hat **verloren**, hat **telefoniert**. Separable '
        'verbs trap the ge- in the middle: **aufgestanden**, '
        '**eingekauft**.',
  ),
  HelpMemoryTip(
    kind: 'mnemonic',
    title: 'sein moves, haben holds',
    text:
        'If the subject travels or transforms, it is **sein**; if it just '
        'does something, **haben**. Picture the sein-verbs as a train: '
        'gehen, fahren, fliegen, kommen, bleiben all ride it.',
  ),
  HelpMemoryTip(
    kind: 'example',
    title: 'Yesterday I got up late and did nothing.',
    text:
        'Gestern **bin** ich spät **aufgestanden** und **habe** den ganzen '
        'Tag nichts **gemacht**.',
  ),
];

/// The dative: articles, pronouns, the six prepositions, the three verbs.
const List<HelpMemoryTip> _dativTips = [
  HelpMemoryTip(
    kind: 'rule',
    title: 'Dative articles',
    text:
        'der → **dem**, die → **der**, das → **dem**, plural die → **den** '
        '(+ -n on the noun: mit den Kinder**n**). Same pattern for ein: '
        '**einem**, **einer**, **einem**; and mein: **meinem**, '
        '**meiner**, **meinem**, **meinen**.',
  ),
  HelpMemoryTip(
    kind: 'rule',
    title: 'Dative pronouns',
    text:
        'ich → **mir**, du → **dir**, er → **ihm**, sie → **ihr**, es → '
        '**ihm**, wir → **uns**, ihr → **euch**, sie/Sie → '
        '**ihnen/Ihnen**. So: Hilfst du **mir**? Das Buch gehört **ihm**.',
  ),
  HelpMemoryTip(
    kind: 'mnemonic',
    title: 'Six words, always dative',
    text:
        '**mit, nach, bei, von, zu, aus** — chant them once a day. After '
        'any of the six the article is dem/der/dem, no exceptions: mit '
        '**dem** Bus, bei **der** Arbeit, zu **dem** (= **zum**) Arzt, zu '
        '**der** (= **zur**) Schule.',
  ),
  HelpMemoryTip(
    kind: 'warning',
    title: 'helfen, gefallen, gehören want the dative',
    text:
        'These verbs take a dative object where English uses a direct one: '
        'Ich helfe **dir** (never dich). Berlin gefällt **mir**. Die Jacke '
        'gehört **der** Frau. danken joins them: Ich danke **euch**.',
  ),
  HelpMemoryTip(
    kind: 'example',
    title: 'The coat belongs to my sister.',
    text: 'Der Mantel gehört **meiner Schwester**.',
  ),
];

/// Directions: the imperative and zu + dative.
const List<HelpMemoryTip> _wegTips = [
  HelpMemoryTip(
    kind: 'rule',
    title: 'The Sie-imperative',
    text:
        'Verb first, Sie right behind it: **Gehen Sie** geradeaus, '
        '**Nehmen Sie** die U-Bahn, **Biegen Sie** links ab. It is the '
        'infinitive + Sie, so there is nothing new to conjugate.',
  ),
  HelpMemoryTip(
    kind: 'rule',
    title: 'The du-imperative',
    text:
        'Drop du and the -st ending: du gehst → **Geh!**, du nimmst → '
        '**Nimm!**, du fährst → **Fahr!** (the umlaut leaves too). '
        'Stem-changers e→i keep the change: **Nimm** den Bus!',
  ),
  HelpMemoryTip(
    kind: 'warning',
    title: 'zu melts into zum / zur',
    text:
        'zu + dem = **zum**, zu + der = **zur**: **zum** Bahnhof, **zum** '
        'Rathaus, **zur** Apotheke. Saying „zu dem Bahnhof" sounds like '
        'pointing at one specific station — use **zum**.',
  ),
  HelpMemoryTip(
    kind: 'example',
    title: 'Go straight ahead, then left at the crossing.',
    text:
        '**Gehen Sie** geradeaus und **biegen Sie** an der Kreuzung links '
        'ab — der Bahnhof ist auf der rechten Seite.',
  ),
];

final List<QuizContent> enDeAiM3Quizzes = [
  enDeAiEx(
    id: 'en_de_ai_m3_words_partizip',
    title: 'Words: participle pairs',
    level: 'A2',
    mode: SpeakingMode.vocabDrill,
    session: _a2Session,
    topic:
        'Infinitive ↔ Perfekt pairs, both directions. Always demand the '
        'auxiliary with the participle — "gegangen" alone is only half an '
        'answer; I must say "ist gegangen". Re-ask my misses.',
    material:
        'Pairs to drill (infinitive = Perfekt with auxiliary):\n'
        'gehen = ist gegangen · fahren = ist gefahren · '
        'kommen = ist gekommen · fliegen = ist geflogen · '
        'bleiben = ist geblieben · aufstehen = ist aufgestanden\n'
        'machen = hat gemacht · kaufen = hat gekauft · '
        'essen = hat gegessen · trinken = hat getrunken · '
        'sehen = hat gesehen · lesen = hat gelesen · '
        'schreiben = hat geschrieben · helfen = hat geholfen · '
        'schlafen = hat geschlafen · besuchen = hat besucht',
    practisePoints: [
      'Irregular participles from memory',
      'haben or sein — the auxiliary is part of the answer',
      'Dropping the pair into a quick sentence on demand',
    ],
    scoringCriteria: [
      'correct participle form',
      'correct auxiliary every time',
      'quick, confident recall',
    ],
    priorityErrors: [
      'haben used with movement verbs',
      'invented regular participles (gegeht)',
    ],
    intro:
        'German talks about the past in the Perfekt: haben or sein plus a '
        'participle at the end of the sentence. Learn each verb, its '
        'participle and its auxiliary as one welded piece — ist gegangen, '
        'hat gemacht — and the whole module gets easy.',
    tips: _perfektTips,
  ),
  enDeAiEx(
    id: 'en_de_ai_m3_weekend_talk',
    title: 'Wie war dein Wochenende?',
    level: 'A2',
    mode: SpeakingMode.conversation,
    session: _a2Session,
    topic:
        'A weekend catch-up, strictly in the Perfekt. Ask "Wie war dein '
        'Wochenende?" and then follow up ONLY on things I have already '
        'mentioned — dig deeper instead of changing topic. Correct me only '
        'in the report, but count every present-tense escape.',
    material:
        'Useful phrases I have studied (phrase = meaning) - steer me to '
        'use them:\n'
        'ich habe ausgeschlafen = I slept in · '
        'ich habe Freunde getroffen = I met friends · '
        'wir sind ins Kino gegangen = we went to the cinema · '
        'zuerst habe ich eingekauft = first I did the shopping · '
        'danach bin ich nach Hause gefahren = after that I went home · '
        'am Sonntag habe ich nichts gemacht = on Sunday I did nothing · '
        'es hat viel Spaß gemacht = it was a lot of fun',
    practisePoints: [
      'Perfekt in free conversation, not just drills',
      'Auxiliary choice under pressure',
      'Time phrases: am Samstag, danach, zuerst, dann',
    ],
    targetVocabulary: [
      'das Wochenende',
      'zuerst',
      'danach',
      'gestern',
      'ausschlafen',
      'unternehmen',
      'treffen',
    ],
    scoringCriteria: [
      'staying in the Perfekt throughout',
      'correct participles and auxiliaries',
      'a connected story, not a list',
    ],
    priorityErrors: ['sliding back into the present tense', 'wrong auxiliary'],
    intro:
        'Everything on the weekend happened, so every sentence needs the '
        'Perfekt: Ich habe geschlafen, ich bin gefahren. String the events '
        'with zuerst, dann and danach and a list of facts becomes a story.',
    tips: [
      ..._perfektTips,
      HelpMemoryTip(
        kind: 'tip',
        title: 'Build the bracket first',
        text:
            'Start every answer with "Ich habe…" or "Ich bin…" and the '
            'participle will find its place at the end: "Ich habe am '
            'Samstag lange geschlafen."',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m3_translate_dativ',
    title: 'Translate: dative targets',
    level: 'A2',
    mode: SpeakingMode.translationDrill,
    session: _a2Session,
    topic:
        'Twelve English sentences aimed at dative prepositions and dative '
        'verbs. Serve one at a time; the endings dem/der/einem/meiner are '
        'what you grade hardest.',
    material:
        'Sentences to serve one at a time — read me only the English '
        'half; the German after "=" is the reference answer, and any '
        'other correct German is acceptable:\n'
        '1. She helps her brother. = Sie hilft ihrem Bruder.\n'
        '2. The gift is from my aunt. = Das Geschenk ist von meiner '
        'Tante.\n'
        '3. I\'m going to the doctor tomorrow. = Ich gehe morgen zum '
        'Arzt.\n'
        '4. He lives with his parents. = Er wohnt bei seinen Eltern.\n'
        '5. We ride to work with the bus. = Wir fahren mit dem Bus zur '
        'Arbeit.\n'
        '6. The jacket belongs to the woman. = Die Jacke gehört der '
        'Frau.\n'
        '7. Berlin pleases me a lot. (gefallen!) = Berlin gefällt mir '
        'sehr.\n'
        '8. After work I go home. = Nach der Arbeit gehe ich nach '
        'Hause.\n'
        '9. She comes from Switzerland. = Sie kommt aus der Schweiz.\n'
        '10. Can you help me, please? = Kannst du mir bitte helfen?\n'
        '11. I got the book from a friend. = Ich habe das Buch von einem '
        'Freund bekommen.\n'
        '12. The keys belong to him. = Die Schlüssel gehören ihm.',
    practisePoints: [
      'mit/nach/bei/von/zu/aus always take the dative',
      'Dative verbs: helfen, gefallen, gehören + dative object',
      'Dative pronouns: mir, dir, ihm, ihr, uns',
    ],
    scoringCriteria: [
      'correct dative endings',
      'the dative verbs built the German way',
      'the right preposition chosen',
    ],
    priorityErrors: [
      'accusative endings after dative prepositions',
      'gefallen/helfen built with an accusative object',
    ],
    intro:
        'Six little prepositions — mit, nach, bei, von, zu, aus — and '
        'three verbs — helfen, gefallen, gehören — always force the '
        'dative: dem, der, einem, meiner, mir, ihm. English never warns '
        'you it is coming, so this drill makes the reflex automatic.',
    tips: _dativTips,
  ),
  enDeAiEx(
    id: 'en_de_ai_m3_wo_bin_ich',
    title: 'Game: Wo bin ich?',
    level: 'A2',
    mode: SpeakingMode.wordGame,
    session: _a2Session,
    topic:
        'A guessing game about places in the city, played with dative '
        'prepositions. You describe, I guess — then we swap roles.',
    material:
        'Game rules:\n'
        '- Round type A (4 rounds): you describe a city place in 2–3 '
        'German sentences full of dative phrases ("Ich bin bei einem '
        'Arzt… Viele Leute warten mit mir…"), and I guess the place in '
        'German.\n'
        '- Round type B (4 rounds): roles swap — I describe a place with '
        'at least two dative phrases and you guess.\n'
        '- Scoring: each correct guess of mine = 10 points. Each of my '
        'descriptions = up to 15 points (5 per correct dative phrase, '
        'max 3 counted). Wrong dative endings score 0 for that phrase.\n'
        '- 8 rounds total, then convert my points to the final score.\n'
        'Useful phrases I have studied (phrase = meaning) - steer me to '
        'use them:\n'
        'ich fahre mit dem Zug = I go by train · '
        'ich warte bei der Haltestelle = I wait at the stop · '
        'ich gehe zur Kasse = I go to the checkout · '
        'ich komme aus dem Wasser = I come out of the water · '
        'viele Leute stehen bei den Gleisen = many people stand by the '
        'tracks · '
        'ich kaufe Brot von der Bäckerin = I buy bread from the baker',
    practisePoints: [
      'City-place vocabulary: der Bahnhof, die Apotheke, das Rathaus',
      'Dative phrases with mit/bei/von/zu in descriptions',
      'Guessing and describing in full sentences',
    ],
    scoringCriteria: [
      'places guessed from German-only clues',
      'correct dative endings in my descriptions',
      'staying in German both ways',
    ],
    priorityErrors: ['dative endings dropped', 'English guesses'],
    intro:
        'Every clue in this game is a dative phrase in costume: mit dem '
        'Zug, bei der Apotheke, zur Kasse. Describe a place through what '
        'you do there with mit, bei, von and zu — the endings dem and der '
        'are what score.',
    tips: [
      ..._dativTips,
      HelpMemoryTip(
        kind: 'tip',
        title: 'A clue that scores full',
        text:
            '"Ich fahre mit dem Zug. Viele Leute stehen bei den Gleisen." '
            'Two clean dative phrases — the answer (der Bahnhof) is almost '
            'a bonus.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m3_read_postkarte',
    title: 'Reading: postcard from a trip',
    level: 'A2',
    mode: SpeakingMode.readingQa,
    session: _a2Session,
    topic:
        'A holiday postcard where a few things went wrong. Ask '
        'comprehension questions in simple German; the last one is an '
        'inference question with no literal answer in the text.',
    material:
        'Passage (show it to me exactly like this):\n'
        'Liebe Oma,\n'
        'viele Grüße aus Lübeck! Die Reise hat chaotisch angefangen: '
        'Unser Zug ist mit zwei Stunden Verspätung gefahren, und dann hat '
        'es den ganzen ersten Tag geregnet. Wir sind trotzdem zur Altstadt '
        'gegangen und haben das Holstentor gesehen. Am zweiten Tag ist die '
        'Sonne gekommen, und wir sind mit einem kleinen Boot gefahren. '
        'Abends habe ich bei einem Fischrestaurant das beste Brötchen '
        'meines Lebens gegessen. Ich habe dir eine kleine Überraschung '
        'gekauft!\n'
        'Deine Marie\n'
        '\n'
        'Ask me (one at a time):\n'
        '1. Wie hat die Reise angefangen?\n'
        '2. Was haben Marie und ihre Familie am ersten Tag gemacht?\n'
        '3. Was ist am zweiten Tag anders gewesen?\n'
        '4. Was hat Marie am Abend gegessen, und wo?\n'
        '5. Die Reise war chaotisch — warum ist Marie trotzdem glücklich? '
        '(nothing to find, something to conclude!)',
    practisePoints: [
      'Reading Perfekt forms without stumbling',
      'Answering in the Perfekt about a third person',
      'Drawing a simple conclusion beyond the text',
    ],
    scoringCriteria: [
      'correct information from the text',
      'Perfekt used in the answers',
      'a sensible, text-based inference for question 5',
    ],
    priorityErrors: [
      'present tense in the answers',
      'question 5 answered off the text',
    ],
    intro:
        'A postcard is the Perfekt in its natural habitat: everything '
        'already happened. Answer about Marie in the third person — sie '
        'hat gegessen, sie ist gefahren — and note how am ersten Tag and '
        'am zweiten Tag order the story.',
    tips: [
      ..._perfektTips,
      HelpMemoryTip(
        kind: 'tip',
        title: 'Inference is allowed to be simple',
        text:
            'For question 5, weigh the days: rain and delay, then boat, '
            'sun and the best sandwich of her life. "Das Ende war schön" '
            'is a perfectly good A2 conclusion.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m3_lost_in_munich',
    title: 'Scene: lost in Munich',
    level: 'A2',
    mode: SpeakingMode.roleplay,
    session: _a2Session,
    topic:
        'You are a friendly Munich local, I am a lost tourist. I ask you '
        'for directions to three places one after another (the station, a '
        'pharmacy, the Marienplatz). You answer in the imperative — and I '
        'must confirm each route back in my own words before moving on.',
    material:
        'Useful phrases I have studied (phrase = meaning) - steer me to '
        'use them:\n'
        'Entschuldigung, wie komme ich zum Bahnhof? = excuse me, how do I '
        'get to the station? · '
        'gehen Sie geradeaus = go straight ahead · '
        'biegen Sie links ab = turn left · '
        'an der Kreuzung rechts = right at the crossing · '
        'nehmen Sie die zweite Straße = take the second street · '
        'ist es weit von hier? = is it far from here? · '
        'also, zuerst gehe ich geradeaus = so, first I go straight ahead',
    targetVocabulary: [
      'Entschuldigung, wie komme ich zu…?',
      'gehen Sie',
      'links',
      'rechts',
      'geradeaus',
      'die Kreuzung',
      'die Haltestelle',
    ],
    practisePoints: [
      'Asking for directions politely (zu + dative)',
      'Understanding Sie-imperatives: Gehen Sie…, Nehmen Sie…',
      'Confirming the route back: Also, ich gehe zuerst…',
    ],
    scoringCriteria: [
      'three complete direction exchanges',
      'each route confirmed back correctly',
      'zu/bei/mit phrases with dative endings',
    ],
    priorityErrors: [
      'routes confirmed wrongly or not at all',
      'wrong case after zu',
    ],
    intro:
        'Directions run on two gears: you ask with zu + dative — Wie '
        'komme ich zum Bahnhof? — and the answer comes back in the '
        'Sie-imperative: Gehen Sie geradeaus, biegen Sie links ab. Saying '
        'the route back in your own words is how you survive it.',
    tips: [
      ..._wegTips,
      HelpMemoryTip(
        kind: 'tip',
        title: 'The confirmation formula',
        text:
            'Repeat, compress, and end with Richtig? — locals love it: '
            '"Also: zuerst geradeaus, an der Kreuzung links, und der '
            'Bahnhof ist rechts. Richtig?"',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m3_story_beste_reise',
    title: 'Tell it: the best trip of your life',
    level: 'A2',
    mode: SpeakingMode.storytelling,
    session: _a2Session,
    topic:
        'I tell the story of the best trip of my life — real or invented — '
        'along your beats, entirely in the Perfekt. Ask two follow-up '
        'questions at the end, also to be answered in the Perfekt.',
    material:
        'Story skeleton:\n'
        '- Beat 1: departure — where to, with whom, how travelled.\n'
        '- Beat 2: arrival and first impression.\n'
        '- Beat 3: the highlight — the one moment that made the trip.\n'
        '- Beat 4: return and what I brought back (a thing or a memory).\n'
        '- Required: at least 6 different Perfekt verbs, 2 of them with '
        'sein (ist gefahren / ist geblieben…), and 3 dative-preposition '
        'phrases (mit dem Zug, bei meiner Tante, nach einem Tag…).\n'
        'Useful phrases I have studied (phrase = meaning) - steer me to '
        'use them:\n'
        'wir sind mit dem Zug gefahren = we went by train · '
        'ich bin bei meiner Tante geblieben = I stayed at my aunt’s · '
        'wir sind spät angekommen = we arrived late · '
        'das Beste ist am letzten Tag passiert = the best thing happened '
        'on the last day · '
        'ich habe ein Souvenir gekauft = I bought a souvenir · '
        'nach einer Woche sind wir zurückgefahren = after a week we went '
        'back',
    practisePoints: [
      'Sustained Perfekt narration across four beats',
      'sein-auxiliary verbs woven in naturally',
      'Dative prepositions as the glue of travel stories',
    ],
    scoringCriteria: [
      'all beats covered in order',
      'required forms present and correct',
      'a story with a real highlight, not a list',
    ],
    priorityErrors: ['present tense creeping in', 'auxiliaries chosen wrongly'],
    intro:
        'Travel stories are built from sein-verbs — bin gefahren, bin '
        'angekommen, bin geblieben — glued together by mit, zu, bei and '
        'nach. Move the plot with those and the whole story stays in the '
        'Perfekt by itself.',
    tips: [
      ..._perfektTips,
      HelpMemoryTip(
        kind: 'tip',
        title: 'sein-verbs are your movers',
        text:
            'The travel verbs are exactly the sein-verbs: bin gefahren, '
            'bin geflogen, bin angekommen, bin geblieben. Move the plot '
            'with them and the required forms take care of themselves.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m3_listen_anekdote',
    title: 'Listen & retell: the anecdote',
    level: 'A2',
    mode: SpeakingMode.listenRetell,
    session: _a2Session,
    topic:
        'You tell me a short anecdote aloud, I retell it in the Perfekt '
        'and answer three questions about it. Speak slowly and clearly; '
        'repeat the anecdote once if I ask.',
    material:
        'The piece you perform:\n'
        '- Invent a light 60-second anecdote in simple A2 German, told in '
        'the Perfekt: someone\'s small everyday adventure with a surprise '
        'at the end (a lost key found in the fridge, a wrong train that '
        'led somewhere nice…). 6–8 short sentences, no vocabulary above '
        'A2.\n'
        '- Tell it to me aloud. I may ask for ONE repetition.\n'
        'Then:\n'
        '1. I retell the anecdote in my own words, in the Perfekt.\n'
        '2. Ask me two detail questions about what happened.\n'
        '3. Ask me one inference question: why was the surprise a good '
        'or bad one for the person?',
    practisePoints: [
      'Catching a spoken story without reading it',
      'Retelling in the Perfekt with the right auxiliaries',
      'Answering detail and inference questions',
    ],
    scoringCriteria: [
      'the retelling covers the main events in order',
      'Perfekt forms correct in the retelling',
      'questions answered from the story',
    ],
    priorityErrors: [
      'key events missing from the retelling',
      'retelling in the present tense',
    ],
    intro:
        'A spoken story hangs on its participles: gefunden, gefahren, '
        'passiert. Catch the verbs as you listen, then rebuild the events '
        'in the Perfekt — er hat gesucht, er ist gefahren — in your own '
        'words.',
    tips: [
      ..._perfektTips,
      HelpMemoryTip(
        kind: 'tip',
        title: 'Catch verbs, not words',
        text:
            'While listening, hunt the participles: gefunden, gefahren, '
            'passiert. Get the verbs and the story\'s skeleton is yours — '
            'the details hang off them.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m3_write_danke',
    title: 'Write: thank you, host family',
    level: 'A2',
    mode: SpeakingMode.writing,
    session: _a2Session,
    topic:
        'A written thank-you message after a week with a German host '
        'family. Grade against the rubric in the material, and be strict '
        'about the dative verbs — they are the point.',
    material:
        'Writing task:\n'
        '- Write a 7–9 sentence thank-you message to your host family '
        'after staying with them for a week.\n'
        '- Thank them (danken + dative!), say what you liked best '
        '(gefallen + dative), mention one thing someone helped you with '
        '(helfen + dative), and one memory in the Perfekt.\n'
        '- Close with a warm goodbye and an invitation to visit you.\n'
        'Rubric (grade against this):\n'
        '- danken/gefallen/helfen each used once, each with a correct '
        'dative object (euch, Ihnen, deiner Mutter…).\n'
        '- At least two Perfekt sentences with correct auxiliaries.\n'
        '- A friendly opening and closing line.\n'
        '- Word order verb-second throughout.\n'
        'Useful phrases I have studied (phrase = meaning):\n'
        'ich danke euch für alles = thank you all for everything · '
        'das Essen hat mir sehr gefallen = I really liked the food · '
        'ihr habt mir mit dem Deutsch geholfen = you helped me with my '
        'German · '
        'die Woche bei euch war wunderbar = the week with you was '
        'wonderful · '
        'besucht mich bald! = visit me soon!',
    practisePoints: [
      'The three dative verbs in warm, real sentences',
      'Dative pronouns: euch, Ihnen, dir',
      'Perfekt memories inside a letter',
    ],
    scoringCriteria: [
      'dative verbs built correctly',
      'Perfekt sentences correct',
      'rubric points covered with a warm tone',
    ],
    priorityErrors: [
      'accusative after danken/helfen/gefallen',
      'auxiliary mistakes in the memories',
    ],
    intro:
        'Gratitude runs on the dative: German thanks, pleases and helps '
        'TO people — Ich danke euch, das Essen hat mir gefallen, ihr habt '
        'mir geholfen. Build the note around those three verbs and one '
        'Perfekt memory.',
    tips: [
      ..._dativTips,
      HelpMemoryTip(
        kind: 'rule',
        title: 'Thank TO someone',
        text:
            'German thanks, pleases and helps TO people: Ich danke '
            '**euch**. Das Essen hat **mir** gefallen. Ihr habt **mir** '
            'geholfen. Never mich after these three.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m3_gate_interview',
    title: 'Module exam: weekend & directions',
    level: 'A2',
    mode: SpeakingMode.interview,
    session: SpeakingSession(durationMinutes: 5, minExchanges: 8),
    topic:
        'The closing interview for module A2.1, mixing the two big skills: '
        'first interview me about my last weekend and a past trip '
        '(strictly Perfekt), then switch roles mid-way — describe where '
        'you "are" in a city and have me direct you to two places, '
        'imperatives and all.',
    material:
        'Useful phrases I have studied (phrase = meaning) - steer me to '
        'use them:\n'
        'am Samstag habe ich lange geschlafen = on Saturday I slept in · '
        'wir sind mit dem Zug nach Berlin gefahren = we took the train to '
        'Berlin · '
        'die Stadt hat mir sehr gefallen = I liked the city a lot · '
        'am ersten Tag hat es geregnet = on the first day it rained · '
        'gehen Sie geradeaus und dann links = go straight ahead and then '
        'left · '
        'nehmen Sie die zweite Straße rechts = take the second street on '
        'the right',
    practisePoints: [
      'Perfekt narration with correct auxiliaries',
      'Dative endings after prepositions and dative verbs',
      'Giving directions with imperatives',
      'Dates and ordinals: am ersten Mai, am zweiten Tag',
    ],
    scoringCriteria: [
      'sustained, correct Perfekt in part one',
      'usable, correct directions in part two',
      'dative endings throughout',
    ],
    priorityErrors: [
      'wrong auxiliary choice',
      'wrong participle forms',
      'dative endings wrong or missing',
    ],
    intro:
        'Two gears, one exam: tell your past in the Perfekt — habe '
        'gemacht, bin gefahren, am ersten Tag — then flip into command '
        'mode and guide with the imperative: Gehen Sie geradeaus, nehmen '
        'Sie die U-Bahn. Dative endings count in both halves.',
    tips: [
      ..._perfektTips,
      ..._wegTips,
      HelpMemoryTip(
        kind: 'tip',
        title: 'Two halves, two gears',
        text:
            'Part one is past tense — every answer starts with habe or '
            'bin. Part two is commands — Gehen Sie, Nehmen Sie. Switch '
            'gears cleanly when the AI switches roles.',
      ),
    ],
  ),
];
