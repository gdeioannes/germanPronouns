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

const _copyTip = HelpMemoryTip(
  kind: 'rule',
  title: 'How this course works',
  text:
      'Copy the exercise into your AI assistant (voice mode is best), do the '
      'exercise there, and paste the score it gives you back here. Stay with '
      'one assistant so your scores stay comparable.',
);

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
        'Welcome to the past tense. This drill welds each verb to its '
        'Perfekt form AND its auxiliary — learn them as one piece and the '
        'rest of the module gets easy.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'mnemonic',
        title: 'sein moves, haben holds',
        text:
            'Verbs of movement or change take sein: ist gegangen, ist '
            'gefahren, ist aufgestanden. Everything you do to something '
            'takes haben. bleiben cheats — no movement, still sein.',
      ),
    ],
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
        'The most useful German conversation there is: what you did on the '
        'weekend. The AI follows your threads, and the one rule is: '
        'everything happened, nothing happens.',
    tips: [
      _copyTip,
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
        'Sentences to serve one at a time (accept any correct German):\n'
        '1. She helps her brother.\n'
        '2. The gift is from my aunt.\n'
        '3. I\'m going to the doctor tomorrow.\n'
        '4. He lives with his parents.\n'
        '5. We ride to work with the bus.\n'
        '6. The jacket belongs to the woman.\n'
        '7. Berlin pleases me a lot. (gefallen!)\n'
        '8. After work I go home.\n'
        '9. She comes from Switzerland.\n'
        '10. Can you help me, please?\n'
        '11. I got the book from a friend.\n'
        '12. The keys belong to him.',
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
        'Twelve sentences where English gives you no hint that a dative is '
        'coming. The prepositions and three special verbs demand it — your '
        'AI checks every ending.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'mnemonic',
        title: 'Six words, always dative',
        text:
            'mit, nach, bei, von, zu, aus — chant them once a day. After '
            'any of the six: dem, der, dem. No exceptions, no mercy.',
      ),
    ],
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
        '- 8 rounds total, then convert my points to the final score.',
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
        'Hide-and-seek across a German city: your AI hides in a place and '
        'describes it in dative clues, then you hide. Every clue is a '
        'little grammar test wearing a costume.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'example',
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
        'A postcard where the trip stumbles and recovers. Four questions '
        'check you followed it; the fifth asks why Marie is happy anyway — '
        'the text never says it outright.',
    tips: [
      _copyTip,
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
        'Lost, on purpose. Ask your way to three places and — the real '
        'exercise — say each route back before you follow it. Confirming '
        'is how you survive real German directions.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'example',
        title: 'The confirmation formula',
        text:
            '"Also: zuerst geradeaus, an der Kreuzung links, und der '
            'Bahnhof ist rechts. Richtig?" Repeat, compress, and end with '
            'Richtig? — locals love it.',
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
        'phrases (mit dem Zug, bei meiner Tante, nach einem Tag…).',
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
        'Your best trip, told properly: four beats, past tense all the '
        'way, and travel\'s little words — mit, zu, bei — holding it '
        'together. Invent freely; grammar is the passport.',
    tips: [
      _copyTip,
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
        'Ears only: the AI performs a little story and you hand it back — '
        'same events, your words, past tense. One repeat is allowed, so '
        'listen like it counts.',
    tips: [
      _copyTip,
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
        '- Word order verb-second throughout.',
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
        'Gratitude runs on the dative: danken, gefallen and helfen all '
        'take it. Write the thank-you note every host family hopes for '
        'and let those three verbs carry it.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'rule',
        title: 'Thank TO someone',
        text:
            'German thanks, pleases and helps TO people: Ich danke euch. '
            'Das Essen hat mir gefallen. Ihr habt mir geholfen. Never '
            'mich after these three.',
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
        'The module gate has two faces: tell your past in the Perfekt, '
        'then guide a lost AI through a city. Pass it and A2.2 unlocks — '
        'retake freely, your best score counts.',
    tips: [
      _copyTip,
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
