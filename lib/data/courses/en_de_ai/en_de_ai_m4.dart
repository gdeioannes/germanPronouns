import '../../../models/quiz_content.dart';
import 'en_de_ai_builder.dart';

/// M4 · A2.2 — *Beschreiben & Planen* (Describe & plan).
///
/// Can-do: describe rooms/positions precisely; compare things; make plans
/// and appointments; explain simple reasons; talk about health.
/// Grammar: Wechselpräpositionen (wo+Dat/wohin+Akk); subordinate clauses
/// with weil/dass/wenn (verb-final); comparative & superlative; Futur with
/// werden (intro); wehtun + dative; als/wenn intro.
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

final List<QuizContent> enDeAiM4Quizzes = [
  enDeAiEx(
    id: 'en_de_ai_m4_words_moebel',
    title: 'Words: furniture, both cases',
    level: 'A2',
    mode: SpeakingMode.vocabDrill,
    session: _a2Session,
    topic:
        'Furniture vocabulary drilled through the two-way prepositions. '
        'Alternate two question shapes: "Wo ist die Lampe?" (dative '
        'answer) and "Wohin stelle ich die Lampe?" (accusative answer). '
        'Re-ask every item I miss, in the other case.',
    material:
        'Words to drill (word = meaning):\n'
        'der Tisch = table · der Stuhl = chair · der Schrank = wardrobe · '
        'der Teppich = carpet · der Spiegel = mirror · das Bett = bed · '
        'das Regal = shelf · das Sofa = sofa · das Fenster = window · '
        'das Bild = picture · die Lampe = lamp · die Tür = door · '
        'die Wand = wall · die Ecke = corner · die Küche = kitchen\n'
        'Drill shape: mix "Wo…?" questions (answer: auf dem Tisch, an der '
        'Wand) with "Wohin…?" questions (answer: auf den Tisch, an die '
        'Wand) — same furniture, different case.',
    practisePoints: [
      'Furniture words with their articles',
      'wo + dative: Die Lampe steht auf dem Tisch',
      'wohin + accusative: Ich stelle die Lampe auf den Tisch',
    ],
    scoringCriteria: [
      'the right word and gender',
      'the case matching the question (wo/wohin)',
      'correct preposition choice (auf/an/in/unter/neben)',
    ],
    priorityErrors: [
      'dative and accusative swapped after two-way prepositions',
      'wrong gender making the case invisible',
    ],
    intro:
        'One word list, two grammar worlds: where things ARE takes the '
        'dative, where things GO takes the accusative. Your AI keeps '
        'flipping the question until the flip feels automatic.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'mnemonic',
        title: 'Wo = rest, wohin = motion',
        text:
            'Ask yourself: is anything moving somewhere? No → dative '
            '(auf dem Tisch). Yes → accusative (auf den Tisch). The '
            'question word tells you before you answer.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m4_zimmer_memory',
    title: 'Game: Mein Zimmer, dein Zimmer',
    level: 'A2',
    mode: SpeakingMode.wordGame,
    session: _a2Session,
    topic:
        'A memory game about room descriptions. You describe your room, I '
        'reconstruct it, then I describe mine — and you check my case '
        'choice sentence by sentence.',
    material:
        'Game rules:\n'
        '- Phase 1: describe your (invented) room in exactly 6 German '
        'sentences using two-way prepositions (Das Bett steht an der '
        'Wand. Der Teppich liegt unter dem Tisch…). I may hear it twice.\n'
        '- Phase 2: I reconstruct the positions from memory — one '
        'sentence per item. Each correctly remembered position = 5 '
        'points; correct case on top = 5 more (max 60).\n'
        '- Phase 3: I describe MY room in 6 sentences. You check every '
        'sentence: right case = 5 points, wrong case = 0 and a one-line '
        'correction saved for the report (max 30).\n'
        '- Bonus 10 points if I use stehen/liegen/hängen correctly at '
        'least once each. Convert my points to the final score.',
    practisePoints: [
      'Position verbs: stehen, liegen, hängen',
      'Two-way prepositions with the dative for positions',
      'Holding six facts in memory in German',
    ],
    scoringCriteria: [
      'positions remembered correctly',
      'dative endings after position prepositions',
      'stehen/liegen/hängen matched to the object',
    ],
    priorityErrors: [
      'accusative used for still positions',
      'positions invented instead of remembered',
    ],
    intro:
        'A memory duel played with furniture: hold the AI\'s room in your '
        'head, rebuild it, then furnish your own. Every sentence is a '
        'little case exam with points on the table.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'tip',
        title: 'Things stand, lie or hang',
        text:
            'German furniture is picky: der Schrank steht, der Teppich '
            'liegt, das Bild hängt. Match the verb to the object\'s '
            'posture and collect the bonus.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m4_translate_weil',
    title: 'Translate: weil & dass, verb last',
    level: 'A2',
    mode: SpeakingMode.translationDrill,
    session: _a2Session,
    topic:
        'Twelve English sentences whose word order must be broken on the '
        'way into German: weil, dass and wenn kick the verb to the very '
        'end of their clause. Serve one at a time and grade the verb '
        'position above everything else.',
    material:
        'Sentences to serve one at a time (accept any correct German):\n'
        '1. I\'m tired because I slept badly.\n'
        '2. She says that she has no time.\n'
        '3. We\'re staying home because it\'s raining.\n'
        '4. I think that the film is boring.\n'
        '5. If the weather is good, we\'ll go to the park.\n'
        '6. He\'s happy because his team won.\n'
        '7. I know that you can\'t come.\n'
        '8. She\'s learning German because she wants to work in Berlin.\n'
        '9. If I have time, I\'ll call you.\n'
        '10. I hope that the test isn\'t hard.\n'
        '11. We\'re eating early because the restaurant closes at nine.\n'
        '12. He says that he got up at six. (Perfekt — watch the pile-up!)',
    practisePoints: [
      'weil/dass/wenn push the verb to the end of the clause',
      'The comma between main and subordinate clause',
      'wenn-first sentences: verb, verb in the middle',
    ],
    scoringCriteria: [
      'verb-final position in every subordinate clause',
      'correct connector chosen',
      'main-clause order still intact',
    ],
    priorityErrors: [
      'English word order kept after weil/dass',
      'verb-second in the wenn-clause',
    ],
    intro:
        'Here English stops helping: after weil, dass and wenn, the verb '
        'walks to the end of the line. Twelve sentences to break the old '
        'order until the new one feels natural.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'rule',
        title: 'weil sends the verb to the end',
        text:
            '"Ich bin müde, weil ich schlecht geschlafen habe." Everything '
            'after weil queues up, and the verb closes the door. In '
            'sentence 12, habe comes dead last — after the participle.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m4_weekend_plans',
    title: 'Making weekend plans',
    level: 'A2',
    mode: SpeakingMode.conversation,
    session: _a2Session,
    topic:
        'We plan a weekend together. Create TWO scheduling conflicts I '
        'must resolve ("Saturday morning you\'re busy", "the museum is '
        'closed on Sunday") — I should propose alternatives with '
        'wenn-clauses ("Wenn du am Samstag arbeitest, gehen wir am '
        'Sonntag."). Push for at least one werden-future sentence about '
        'the final plan.',
    practisePoints: [
      'wenn-clauses to handle conflicts and conditions',
      'Suggesting and agreeing: Wollen wir…? Wie wäre es mit…?',
      'Futur with werden for the settled plan',
    ],
    targetVocabulary: [
      'der Termin',
      'verschieben',
      'Zeit haben',
      'Wie wäre es mit…?',
      'zuerst',
      'stattdessen',
    ],
    scoringCriteria: [
      'both conflicts resolved with real alternatives',
      'verb-final order inside the wenn-clauses',
      'one clean werden-future about the plan',
    ],
    priorityErrors: [
      'wenn-clauses with verb-second',
      'conflicts ignored instead of resolved',
    ],
    intro:
        'Planning is negotiation, and your AI will not make it easy: two '
        'conflicts stand between you and the weekend. Solve them with '
        'wenn-sentences and seal the plan with werden.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'example',
        title: 'The plan-saving sentence',
        text:
            '"Wenn das Museum am Sonntag geschlossen ist, gehen wir '
            'stattdessen ins Kino." Condition first, comma, then the '
            'rescue — verb right after the comma.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m4_read_wohnung',
    title: 'Reading: the flat ad & the email',
    level: 'A2',
    mode: SpeakingMode.readingQa,
    session: _a2Session,
    topic:
        'Two short texts — a flat-viewing ad and a renter\'s email — read '
        'together. The final question crosses the texts: does the flat '
        'fit what the renter wants? Make me justify with weil.',
    material:
        'Text 1 — the ad (show both texts exactly like this):\n'
        'Helle 2-Zimmer-Wohnung im 3. Stock, 52 m², Balkon zum Hof. '
        'Kleine Küche, neues Bad, kein Aufzug. 5 Minuten zur U-Bahn. '
        '780 Euro kalt. Haustiere sind leider nicht erlaubt. Besichtigung '
        'am Samstag um 11 Uhr.\n'
        '\n'
        'Text 2 — the email:\n'
        'Guten Tag, ich interessiere mich für Ihre Wohnung. Ich suche '
        'etwas Helles mit Balkon, und die U-Bahn ist mir wichtiger als '
        'ein Aufzug, weil ich viel arbeite und wenig zu Hause bin. Mein '
        'Budget ist maximal 800 Euro kalt. Eine Frage habe ich: Ich habe '
        'eine kleine Katze — ist das ein Problem? Am Samstag kann ich '
        'leider erst um 14 Uhr. Mit freundlichen Grüßen, J. Weber\n'
        '\n'
        'Ask me (one at a time):\n'
        '1. Wie groß ist die Wohnung, und was kostet sie?\n'
        '2. Was ist Herrn Weber wichtiger als ein Aufzug — und warum?\n'
        '3. Welche Frage stellt Herr Weber in der E-Mail?\n'
        '4. Welches Termin-Problem gibt es am Samstag?\n'
        '5. Passt die Wohnung zu Herrn Weber? Answer with "Ja/Nein/'
        'Teilweise, weil…" and use BOTH texts.',
    practisePoints: [
      'Extracting facts from two related texts',
      'Comparing wishes against reality',
      'Justifying a judgment with weil + verb-final',
    ],
    scoringCriteria: [
      'facts pulled correctly from the right text',
      'question 5 weighs both texts (cat! time!)',
      'weil-clauses built correctly',
    ],
    priorityErrors: [
      'question 5 answered from one text only',
      'weil-clause with verb-second',
    ],
    intro:
        'Real-life reading: an ad says one thing, an email wants another. '
        'Four questions warm you up; the fifth makes you the judge — and '
        'every verdict needs a weil.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'tip',
        title: 'Make a match table in your head',
        text:
            'Balcony? Light? Price? Cat? Time? Tick each wish against the '
            'ad before question 5 — two wishes fail, and they are exactly '
            'what your weil-sentences are for.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m4_doctor_roleplay',
    title: 'Scene: at the doctor\'s',
    level: 'A2',
    mode: SpeakingMode.roleplay,
    session: _a2Session,
    topic:
        'You are a calm, friendly doctor, I am the patient. I describe '
        'three symptoms (wehtun + dative: Mir tut der Kopf weh…), you '
        'give simple advice I must show I understood, and at the end we '
        'negotiate a follow-up appointment — you reject my first '
        'suggested date so I must propose another.',
    targetVocabulary: [
      'wehtun',
      'der Kopf',
      'der Hals',
      'der Rücken',
      'die Schmerzen',
      'das Medikament',
      'der Termin',
      'Gute Besserung!',
    ],
    practisePoints: [
      'wehtun + dative: Mir tut der Hals weh / Mir tun die Beine weh',
      'Understanding advice and saying it back',
      'Negotiating a date: Geht es am Donnerstag um zehn?',
    ],
    scoringCriteria: [
      'three symptoms with correct wehtun grammar',
      'advice confirmed back in my own words',
      'the appointment negotiated to a real date and time',
    ],
    priorityErrors: [
      'wehtun built without the dative (ich tue weh…)',
      'advice nodded through without confirming',
    ],
    intro:
        'The appointment everyone dreads in a foreign language, made '
        'safe: describe what hurts, prove you understood the advice, and '
        'haggle a follow-up date. wehtun works backwards — TO you.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'rule',
        title: 'Pain arrives in the dative',
        text:
            'German pain happens TO you: "Mir tut der Kopf weh." The head '
            'is the subject, you are the dative. Plural aches flip the '
            'verb: "Mir tun die Ohren weh."',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m4_words_komparativ',
    title: 'Words: adjective pairs & comparatives',
    level: 'A2',
    mode: SpeakingMode.vocabDrill,
    session: _a2Session,
    topic:
        'Adjective pairs climbed through all three steps — alt, älter, am '
        'ältesten — then quick "compare these two things" mini-prompts '
        '(a bike and a car, coffee and tea…) where I must build the '
        'comparison sentence myself, with als.',
    material:
        'Pairs to drill (base = opposite; climb both where sensible):\n'
        'alt = jung · groß = klein · schnell = langsam · teuer = billig · '
        'warm = kalt · gut = schlecht · viel = wenig · gern = ungern · '
        'hoch = niedrig · nah = weit · schön = hässlich · '
        'leicht = schwer · laut = leise · früh = spät · stark = schwach\n'
        'Watch the irregulars: gut/besser/am besten · viel/mehr/am '
        'meisten · gern/lieber/am liebsten · hoch/höher/am höchsten · '
        'nah/näher/am nächsten — and the umlaut climbers alt/älter, '
        'groß/größer, warm/wärmer.\n'
        'Phase 2: give me two things to compare in one sentence with '
        'als, then ask for the superlative on top.',
    practisePoints: [
      'Comparative forms incl. umlauts and irregulars',
      'am + -sten for the superlative',
      'Comparing with als: schneller als, lieber als',
    ],
    scoringCriteria: [
      'correct comparative and superlative forms',
      'als (not wie) in comparisons',
      'irregular forms from memory',
    ],
    priorityErrors: [
      'mehr + adjective instead of the -er form',
      'wie used where als belongs',
    ],
    intro:
        'Fifteen adjective pairs and their ladders. German never says '
        '"more cheap" — it bolts -er onto the word and often adds an '
        'umlaut. Then you put the forms to work comparing real things.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'warning',
        title: 'No "mehr" before adjectives',
        text:
            'English says "more expensive"; German never does. It is '
            'teurer, not "mehr teuer" — every adjective climbs with -er, '
            'however long it is.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m4_story_als_ich_klein_war',
    title: 'Tell it: Als ich klein war',
    level: 'A2',
    mode: SpeakingMode.storytelling,
    session: _a2Session,
    topic:
        'I tell a then-versus-now story about my childhood along your '
        'four beats, contrasting past and present with comparatives and '
        'explaining with weil. Ask two follow-up questions at the end.',
    material:
        'Story skeleton:\n'
        '- Beat 1: where and how I lived as a child (Als ich klein '
        'war, …).\n'
        '- Beat 2: one thing I loved doing then — and why (weil…).\n'
        '- Beat 3: how my life is different now — at least 3 comparative '
        'sentences (Heute ist meine Wohnung kleiner, aber…).\n'
        '- Beat 4: one thing that is better today and one that was '
        'better then, with a weil for each.\n'
        '- Required: 3+ comparatives with als, 2+ weil-clauses '
        '(verb-final), and the opener "Als ich klein war" used at least '
        'once. Invented childhoods welcome.',
    practisePoints: [
      'Als for one-time past periods: Als ich klein war…',
      'Comparatives carrying the then/now contrast',
      'weil-clauses giving honest reasons',
    ],
    scoringCriteria: [
      'all four beats covered in order',
      'required comparatives and weil-clauses present',
      'a real contrast, not two separate lists',
    ],
    priorityErrors: [
      'wenn used where als belongs',
      'weil-clauses with verb-second',
    ],
    intro:
        'A story built on a hinge: then and now. Comparatives measure the '
        'distance, weil explains it, and "Als ich klein war" opens the '
        'door. True stories and invented ones score the same.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'rule',
        title: 'als once, wenn whenever',
        text:
            'A single period or moment in the past takes als: "Als ich '
            'klein war". Repeated or future events take wenn. Childhood '
            'happened once — als it is.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m4_write_traumzimmer',
    title: 'Write: my dream room',
    level: 'A2',
    mode: SpeakingMode.writing,
    session: _a2Session,
    topic:
        'A written description of my dream room for a design blog. Grade '
        'against the rubric in the material, counting the position '
        'phrases and comparatives explicitly in the report.',
    material:
        'Writing task:\n'
        '- Write 8 sentences describing your dream room for a design '
        'blog: what stands, lies and hangs where, and why it beats your '
        'current room.\n'
        'Rubric (grade against this):\n'
        '- At least 6 position phrases with two-way prepositions in the '
        'dative (an der Wand, neben dem Fenster, über dem Bett…).\n'
        '- At least 3 comparatives, one comparing dream room vs current '
        'room with als.\n'
        '- stehen/liegen/hängen each used at least once.\n'
        '- One weil-sentence explaining a choice.\n'
        '- Count the position phrases and comparatives in your report.',
    practisePoints: [
      'Position phrases in the dative, six of them',
      'Comparatives that sell the dream',
      'stehen/liegen/hängen matched to the furniture',
    ],
    scoringCriteria: [
      'six correct position phrases',
      'three correct comparatives',
      'rubric coverage and readable flow',
    ],
    priorityErrors: [
      'accusative endings in still positions',
      'mehr + adjective comparatives',
    ],
    intro:
        'Interior design as grammar practice: furnish a dream room in '
        'writing. Six position phrases hang the furniture, three '
        'comparatives explain why it beats the room you have.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'tip',
        title: 'Describe standing still',
        text:
            'A description is a photo, not a removal van — nothing moves, '
            'so every position phrase takes the dative: über dem Bett, '
            'neben dem Fenster, an der Wand.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m4_gate_interview',
    title: 'Module exam: describe, compare, plan',
    level: 'A2',
    mode: SpeakingMode.interview,
    session: SpeakingSession(durationMinutes: 5, minExchanges: 8),
    topic:
        'The closing interview for module A2.2, in three movements: '
        'first DESCRIBE — my room or flat with precise positions; then '
        'COMPARE — two cities, two seasons or two hobbies of my choice; '
        'then PLAN — next weekend and one bigger future plan with '
        'werden. Weave in one health question (wehtun) and demand at '
        'least two weil- or wenn-clauses along the way.',
    practisePoints: [
      'Two-way prepositions with the right case',
      'Comparatives and superlatives in free speech',
      'weil/dass/wenn with verb-final order',
      'Futur with werden for real plans',
    ],
    scoringCriteria: [
      'positions described with correct cases',
      'comparisons built with als and correct forms',
      'subordinate clauses verb-final',
    ],
    priorityErrors: [
      'wrong case after two-way prepositions',
      'verb not final after weil/dass/wenn',
      'mehr + adjective comparatives',
    ],
    intro:
        'The module gate spans everything A2.2 taught you: describe with '
        'the right case, compare with real forms, plan with werden. Pass '
        'it and B1.1 unlocks — retake freely, your best score counts.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'tip',
        title: 'Three movements, three checks',
        text:
            'Describing? Check the case after the preposition. Comparing? '
            'Check for als and the -er form. Planning? Check the verb '
            'lands last after weil and wenn. One check per movement.',
      ),
    ],
  ),
];
