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

const List<HelpMemoryTip> _wechselTips = [
  HelpMemoryTip(
    kind: 'rule',
    title: 'The nine two-way prepositions',
    text:
        '**an, auf, hinter, in, neben, über, unter, vor, zwischen** take '
        'either case. Question **wo?** (position) → dative; question '
        '**wohin?** (direction) → accusative. Same preposition, two jobs.',
  ),
  HelpMemoryTip(
    kind: 'rule',
    title: 'The article flip',
    text:
        'Dative: auf **dem** Tisch (m/n), an **der** Wand (f), in **den** '
        'Ecken (pl, +n on the noun). Accusative: auf **den** Tisch, an '
        '**die** Wand, in **das** Regal. Only masculine and the plural '
        'change loudly — listen for dem/den.',
  ),
  HelpMemoryTip(
    kind: 'mnemonic',
    title: 'Wo = rest, wohin = motion',
    text:
        'Ask yourself: is anything moving somewhere? No → dative '
        '(auf dem Tisch). Yes → accusative (auf den Tisch). The '
        'question word tells you before you answer.',
  ),
  HelpMemoryTip(
    kind: 'warning',
    title: 'Two verb families',
    text:
        'Still verbs go with the dative: **stehen, liegen, hängen, sein**. '
        'Moving verbs go with the accusative: **stellen, legen, hängen '
        '(etwas irgendwohin), setzen**. „Ich stelle die Lampe auf den '
        'Tisch" → „Die Lampe steht auf dem Tisch."',
  ),
  HelpMemoryTip(
    kind: 'example',
    title: 'I hang the picture on the wall — now it hangs on the wall.',
    text:
        'Ich hänge das Bild **an die Wand**, und jetzt hängt es '
        '**an der Wand**.',
  ),
];

const List<HelpMemoryTip> _nebensatzTips = [
  HelpMemoryTip(
    kind: 'rule',
    title: 'weil, dass, wenn send the verb to the end',
    text:
        'After these connectors the conjugated verb closes the clause: Ich '
        'bleibe zu Hause, weil es **regnet**. · Sie sagt, dass sie keine '
        'Zeit **hat**. · Wenn das Wetter gut **ist**, gehen wir raus.',
  ),
  HelpMemoryTip(
    kind: 'rule',
    title: 'wenn first: verb, verb',
    text:
        'A fronted wenn-clause counts as position 1, so the main verb '
        'follows right after the comma: Wenn ich Zeit **habe**, **rufe** '
        'ich dich an. Two verbs meet in the middle, separated only by the '
        'comma.',
  ),
  HelpMemoryTip(
    kind: 'warning',
    title: 'Perfekt pile-up: the helper goes dead last',
    text:
        'With Perfekt in a weil/dass-clause the participle comes first, '
        'then the helper: …, weil ich schlecht **geschlafen habe** — never '
        '„weil ich habe schlecht geschlafen".',
  ),
  HelpMemoryTip(
    kind: 'mnemonic',
    title: 'The comma is a door',
    text:
        'When weil, dass or wenn opens a clause, imagine the comma as a '
        'door and the verb as the last one out — it always switches off '
        'the light at the end.',
  ),
  HelpMemoryTip(
    kind: 'example',
    title: 'She is learning German because she wants to work in Berlin.',
    text:
        'Sie lernt Deutsch, weil sie in Berlin arbeiten **will**.',
  ),
];

const List<HelpMemoryTip> _komparativTips = [
  HelpMemoryTip(
    kind: 'rule',
    title: 'Climb with -er and am -sten',
    text:
        'schnell → schnell**er** → am schnell**sten**; klein → klein**er** '
        '→ am klein**sten**. One-syllable adjectives with a/o/u usually '
        'add an umlaut: alt → **ä**lter, groß → gr**ö**ßer, warm → '
        'w**ä**rmer.',
  ),
  HelpMemoryTip(
    kind: 'rule',
    title: 'The five irregular ladders',
    text:
        'gut → **besser** → am **besten** · viel → **mehr** → am '
        '**meisten** · gern → **lieber** → am **liebsten** · hoch → '
        '**höher** → am **höchsten** · nah → **näher** → am **nächsten**. '
        'Learn them as tunes, not rules.',
  ),
  HelpMemoryTip(
    kind: 'warning',
    title: 'Never „mehr" + adjective, never „wie" after -er',
    text:
        'English says „more expensive" — German says **teurer**, however '
        'long the adjective. And a comparison after the -er form takes '
        '**als**, not wie: schneller **als** ich (wie only for equality: '
        'so schnell **wie** ich).',
  ),
  HelpMemoryTip(
    kind: 'example',
    title: 'Coffee tastes better to me than tea.',
    text: 'Kaffee schmeckt mir **besser als** Tee.',
  ),
];

const List<HelpMemoryTip> _planTips = [
  HelpMemoryTip(
    kind: 'rule',
    title: 'Futur with werden',
    text:
        'werden is conjugated in position 2, the main verb waits at the '
        'end as an infinitive: ich **werde**, du **wirst**, er **wird**, '
        'wir **werden**. „Wir **werden** am Sonntag ins Museum '
        '**gehen**."',
  ),
  HelpMemoryTip(
    kind: 'rule',
    title: 'Suggesting and agreeing',
    text:
        '„**Wollen wir** ins Kino gehen?" · „**Wie wäre es mit** Sonntag?" '
        '(mit + dative!) · „Das **passt** mir gut." · „Da **kann** ich '
        'leider nicht." Suggest, reject politely, counter-suggest.',
  ),
  HelpMemoryTip(
    kind: 'warning',
    title: 'wenn-clauses stay verb-final',
    text:
        'Even mid-negotiation the rule holds: „Wenn du am Samstag '
        '**arbeitest**, gehen wir am Sonntag" — never „wenn du arbeitest '
        'am Samstag".',
  ),
  HelpMemoryTip(
    kind: 'example',
    title: 'If the museum is closed, we will go to the cinema instead.',
    text:
        'Wenn das Museum geschlossen ist, **werden** wir stattdessen ins '
        'Kino **gehen**.',
  ),
];

const List<HelpMemoryTip> _wehtunTips = [
  HelpMemoryTip(
    kind: 'rule',
    title: 'Pain arrives in the dative',
    text:
        'German pain happens TO you: „**Mir** tut der Kopf weh." The body '
        'part is the subject, the sufferer is dative: **mir, dir, ihm, '
        'ihr, uns, euch, ihnen**. Plural aches flip the verb: „Mir '
        '**tun** die Ohren weh."',
  ),
  HelpMemoryTip(
    kind: 'rule',
    title: 'The -schmerzen shortcut',
    text:
        'Every ache also works as ich habe + **-schmerzen**: '
        '**Kopfschmerzen, Halsschmerzen, Rückenschmerzen, '
        'Bauchschmerzen**. „Ich habe seit drei Tagen Halsschmerzen."',
  ),
  HelpMemoryTip(
    kind: 'warning',
    title: 'Never „ich tue weh"',
    text:
        'The English pattern „I hurt" does not translate: not „ich tue '
        'weh", not „mein Kopf tut mir weh" with ich as subject — say '
        '„**Mir tut der Kopf weh**" or „Ich **habe** Kopfschmerzen."',
  ),
  HelpMemoryTip(
    kind: 'example',
    title: 'My throat hurts and I have had a fever since yesterday.',
    text:
        '**Mir tut der Hals weh**, und ich habe seit gestern Fieber.',
  ),
];

const List<HelpMemoryTip> _alsWennTips = [
  HelpMemoryTip(
    kind: 'rule',
    title: 'als once, wenn whenever',
    text:
        'A single period or moment in the past takes **als**: „Als ich '
        'klein war". Repeated events and future/possible events take '
        '**wenn**: „Wenn ich Zeit habe". Childhood happened once — als '
        'it is.',
  ),
  HelpMemoryTip(
    kind: 'warning',
    title: 'als wears two hats',
    text:
        'als is also the „than" of comparisons: größer **als** ich. In a '
        'then-vs-now story you will need both — „**Als** ich klein war, '
        'war alles langsamer **als** heute."',
  ),
  HelpMemoryTip(
    kind: 'mnemonic',
    title: 'One photo vs a flip-book',
    text:
        'als = one photo from the past; wenn = a flip-book of repeats. If '
        'you could say „every time", it is wenn; if it happened in one '
        'stretch, it is als.',
  ),
  HelpMemoryTip(
    kind: 'example',
    title: 'When I was little, we lived in the countryside.',
    text: '**Als ich klein war**, wohnten wir auf dem Land.',
  ),
];

const List<HelpMemoryTip> _gateTips = [
  HelpMemoryTip(
    kind: 'rule',
    title: 'Describe: pick the case first',
    text:
        'Positions are still photos → dative: „Das Sofa steht **an der '
        'Wand**, das Bild hängt **über dem Bett**." Only if something '
        'moves somewhere does the accusative appear.',
  ),
  HelpMemoryTip(
    kind: 'rule',
    title: 'Compare: -er + als, irregulars from memory',
    text:
        'Berlin ist **größer als** Bonn; im Sommer ist es **wärmer**; am '
        '**liebsten** koche ich. No „mehr + adjective", no „wie" after an '
        '-er form.',
  ),
  HelpMemoryTip(
    kind: 'rule',
    title: 'Plan: werden in slot 2, verb-final after weil/wenn',
    text:
        '„Ich **werde** nächstes Jahr nach Deutschland **reisen**, weil '
        'ich mein Deutsch verbessern **will**." werden second, infinitive '
        'last, subordinate verb dead last.',
  ),
  HelpMemoryTip(
    kind: 'example',
    title: 'If the weather is good, we will hike, because I love mountains.',
    text:
        'Wenn das Wetter gut ist, **werden** wir wandern, weil ich Berge '
        '**liebe**.',
  ),
];

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
        'Nine prepositions — an, auf, hinter, in, neben, über, unter, vor, '
        'zwischen — take the dative when something IS somewhere (wo?) and '
        'the accusative when something GOES somewhere (wohin?). Same '
        'furniture, two cases: auf dem Tisch vs auf den Tisch.',
    tips: _wechselTips,
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
        'Room descriptions are still photos, so every position takes the '
        'dative after a two-way preposition — and German matches the verb '
        'to the object\'s posture: upright things stehen, flat things '
        'liegen, wall things hängen.',
    tips: [
      ..._wechselTips,
      HelpMemoryTip(
        kind: 'tip',
        title: 'Things stand, lie or hang',
        text:
            'German furniture is picky: der Schrank **steht**, der Teppich '
            '**liegt**, das Bild **hängt**. Match the verb to the '
            'object\'s posture and collect the bonus.',
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
        'Sentences to serve one at a time — read me only the English half; '
        'the German after „=" is the reference answer, and other correct '
        'German is acceptable:\n'
        '1. I\'m tired because I slept badly. = Ich bin müde, weil ich '
        'schlecht geschlafen habe.\n'
        '2. She says that she has no time. = Sie sagt, dass sie keine '
        'Zeit hat.\n'
        '3. We\'re staying home because it\'s raining. = Wir bleiben zu '
        'Hause, weil es regnet.\n'
        '4. I think that the film is boring. = Ich denke, dass der Film '
        'langweilig ist.\n'
        '5. If the weather is good, we\'ll go to the park. = Wenn das '
        'Wetter gut ist, gehen wir in den Park.\n'
        '6. He\'s happy because his team won. = Er ist glücklich, weil '
        'sein Team gewonnen hat.\n'
        '7. I know that you can\'t come. = Ich weiß, dass du nicht kommen '
        'kannst.\n'
        '8. She\'s learning German because she wants to work in Berlin. '
        '= Sie lernt Deutsch, weil sie in Berlin arbeiten will.\n'
        '9. If I have time, I\'ll call you. = Wenn ich Zeit habe, rufe '
        'ich dich an.\n'
        '10. I hope that the test isn\'t hard. = Ich hoffe, dass der '
        'Test nicht schwer ist.\n'
        '11. We\'re eating early because the restaurant closes at nine. '
        '= Wir essen früh, weil das Restaurant um neun schließt.\n'
        '12. He says that he got up at six. (Perfekt — watch the '
        'pile-up!) = Er sagt, dass er um sechs aufgestanden ist.',
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
        'weil (because), dass (that) and wenn (if/when) open subordinate '
        'clauses, and in a German subordinate clause the conjugated verb '
        'moves to the very end: Ich bin müde, weil ich schlecht '
        'geschlafen habe.',
    tips: _nebensatzTips,
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
    material:
        'Useful phrases I have studied (phrase = meaning) — steer me to '
        'use them:\n'
        'Wollen wir am Samstag ins Kino gehen? = shall we go to the '
        'cinema on Saturday? · Wie wäre es mit Sonntag? = how about '
        'Sunday? · Da habe ich leider keine Zeit = unfortunately I have '
        'no time then · den Termin verschieben = to postpone the '
        'appointment · stattdessen = instead · zuerst = first of all · '
        'Das passt mir gut = that works well for me · Wir werden zuerst '
        'frühstücken = we will have breakfast first',
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
        'German plans lean on two structures: wenn-clauses for conditions '
        '(Wenn du arbeitest, gehen wir am Sonntag — verb at the end of '
        'the wenn-part) and the werden-future for the settled plan '
        '(Wir werden um zehn frühstücken — infinitive at the end).',
    tips: _planTips,
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
        'Flat-hunting German in the wild: kalt means rent without '
        'heating, Besichtigung is the viewing, and every judgment you '
        'give needs a weil-clause with the verb at the end — Die Wohnung '
        'passt nicht, weil Haustiere verboten sind.',
    tips: [
      ..._nebensatzTips,
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
    material:
        'Useful phrases I have studied (phrase = meaning) — steer me to '
        'use them:\n'
        'Mir tut der Kopf weh = my head hurts · Mir tun die Beine weh '
        '= my legs hurt · Ich habe Halsschmerzen = I have a sore throat '
        '· seit drei Tagen = for three days · Ich fühle mich schwach '
        '= I feel weak · Wie oft nehme ich das Medikament? = how often '
        'do I take the medicine? · Geht es am Donnerstag um zehn? '
        '= does Thursday at ten work? · Gute Besserung! = get well soon!',
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
        'wehtun works backwards: the body part is the subject and the '
        'sufferer takes the dative — Mir tut der Kopf weh, and with '
        'plural aches the verb goes plural too: Mir tun die Beine weh.',
    tips: _wehtunTips,
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
        'German comparatives always bolt -er onto the adjective (never '
        '„mehr" + adjective), often add an umlaut (alt → älter), and '
        'compare with als; the superlative is am + -sten: alt, älter, '
        'am ältesten.',
    tips: _komparativTips,
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
        'once. Invented childhoods welcome.\n'
        'Useful phrases I have studied (phrase = meaning) — steer me to '
        'use them:\n'
        'Als ich klein war = when I was little · auf dem Land = in the '
        'countryside · Früher hatte ich mehr Zeit = I used to have more '
        'time · Heute ist alles anders = today everything is different · '
        'besser als früher = better than before · am liebsten = most of '
        'all · Das vermisse ich = I miss that',
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
        'One-time past periods take als (Als ich klein war…), repeated '
        'events take wenn — and a then-vs-now story runs on comparatives '
        'with als plus weil-clauses that explain the change.',
    tips: _alsWennTips,
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
        'A written room description is a still photo, so every position '
        'phrase takes the dative (an der Wand, über dem Bett) — and the '
        'dream beats reality through comparatives with als, never with '
        '„mehr" + adjective.',
    tips: [
      ..._wechselTips,
      HelpMemoryTip(
        kind: 'tip',
        title: 'Describe standing still',
        text:
            'A description is a photo, not a removal van — nothing moves, '
            'so every position phrase takes the dative: **über dem '
            'Bett**, **neben dem Fenster**, **an der Wand**.',
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
    material:
        'Useful phrases I have studied (phrase = meaning) - steer me to '
        'use them:\n'
        'an der Wand hängt … = on the wall hangs … · '
        'neben dem Fenster steht … = next to the window stands … · '
        'X ist größer als Y = X is bigger than Y · '
        'am liebsten mag ich … = I like … best of all · '
        'am Wochenende werde ich … = at the weekend I am going to … · '
        'ich habe vor, … zu … = I plan to … · '
        'mir tut der Kopf weh = my head hurts',
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
        'The A2.2 gate bundles the module\'s grammar into free speech: '
        'dative positions after two-way prepositions, comparatives with '
        'als, verb-final weil/dass/wenn-clauses and plans built with '
        'werden + infinitive.',
    tips: [
      ..._gateTips,
      HelpMemoryTip(
        kind: 'tip',
        title: 'Three movements, three checks',
        text:
            'Describing? Check the case after the preposition. Comparing? '
            'Check for **als** and the -er form. Planning? Check the verb '
            'lands last after weil and wenn. One check per movement.',
      ),
    ],
  ),
];
