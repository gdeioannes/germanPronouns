import '../../../models/quiz_content.dart';
import 'en_de_ai_builder.dart';

/// M2 · A1.2 — *Im Alltag* (Everyday life).
///
/// Can-do: describe a daily routine with times; shop for food and ask
/// prices; say what you like/don't like; make simple negative statements;
/// name days, months, appointments.
/// Grammar: accusative (articles, pronouns, kein); kein vs nicht; modal
/// verbs (können/müssen/möchten); separable verbs; possessive articles;
/// clock time; am/im/um temporal prepositions; gern/lieber.
///
/// A1 session shape: ~3 minutes, 6 exchanges, pass 50 (the manifest default).
const _a1Session = SpeakingSession(durationMinutes: 3, minExchanges: 6);

const List<HelpMemoryTip> _separableTips = [
  HelpMemoryTip(
    kind: 'rule',
    title: 'The prefix jumps to the end',
    text:
        'A separable verb splits in the present tense: the stem takes '
        'position 2, the prefix goes last. **auf**stehen → ich stehe '
        '… **auf**; **ein**kaufen → wir kaufen … **ein**; **fern**sehen → '
        'er sieht … **fern**; **an**rufen → sie ruft … **an**.',
  ),
  HelpMemoryTip(
    kind: 'warning',
    title: 'Never leave the verb glued',
    text:
        '*Ich aufstehe um sieben* is wrong twice: the prefix must split off '
        'AND travel to the very end. Correct: *Ich stehe um sieben Uhr '
        '**auf**.* Everything else — times, objects, adverbs — sits between '
        'verb and prefix.',
  ),
  HelpMemoryTip(
    kind: 'mnemonic',
    title: 'A bracket around the sentence',
    text:
        'Think of stem + prefix as an open bracket: the stem opens it in '
        'slot 2, the prefix closes it at the end. The longer the sentence, '
        'the wider the bracket stretches — but it always closes.',
  ),
  HelpMemoryTip(
    kind: 'example',
    title: 'I get up at seven and go shopping.',
    text: 'Ich stehe um sieben Uhr **auf** und kaufe dann **ein**.',
  ),
];

const List<HelpMemoryTip> _akkTips = [
  HelpMemoryTip(
    kind: 'rule',
    title: 'Only the masculine changes',
    text:
        'Accusative articles: der → **den**, ein → **einen**, kein → '
        '**keinen**. Feminine, neuter and plural stay exactly as in the '
        'nominative: die, eine, das, ein, die (Pl.). One row of the table '
        'does all the work.',
  ),
  HelpMemoryTip(
    kind: 'rule',
    title: 'Accusative pronouns',
    text:
        'ich → **mich**, du → **dich**, er → **ihn**, sie → **sie**, es → '
        '**es**, wir → **uns**, ihr → **euch**, sie/Sie → **sie/Sie**. '
        'Again only the masculine truly surprises: er becomes **ihn**.',
  ),
  HelpMemoryTip(
    kind: 'warning',
    title: 'Find the object first',
    text:
        'The subject does the action, the object receives it. *Ich sehe '
        '**den** Mann* (I see him) but *Der Mann sieht **mich*** (he sees '
        'me). *Ich sehe der Mann* is the classic beginner error — the '
        'object may never wear nominative der.',
  ),
  HelpMemoryTip(
    kind: 'mnemonic',
    title: 'The -n chain',
    text:
        'Masculine accusative loves the letter n: de**n**, eine**n**, '
        'keine**n**, ih**n**, meine**n**. Hear an object that is masculine? '
        'End the little word in -n.',
  ),
  HelpMemoryTip(
    kind: 'example',
    title: 'She buys a table and needs the key.',
    text: 'Sie kauft **einen** Tisch und braucht **den** Schlüssel.',
  ),
];

const List<HelpMemoryTip> _keinTips = [
  HelpMemoryTip(
    kind: 'rule',
    title: 'kein bends like ein',
    text:
        'kein takes exactly the endings of ein: **keinen** Käse (m., Akk.), '
        '**keine** Milch (f.), **kein** Brot (n.), and in the plural '
        '**keine** Eier — the one place kein exists where ein does not.',
  ),
  HelpMemoryTip(
    kind: 'rule',
    title: 'kein for nouns, nicht for the rest',
    text:
        'Negate a noun with ein or with no article at all → **kein**: *Ich '
        'trinke **keinen** Kaffee.* Negate a verb, adjective, or a noun with '
        'a definite article → **nicht**: *Ich arbeite **nicht**.* / *Das ist '
        '**nicht** der Chef.*',
  ),
  HelpMemoryTip(
    kind: 'warning',
    title: 'Not "nicht ein"',
    text:
        '*Ich habe nicht einen Hund* sounds like a courtroom denial. Plain '
        'everyday negation of a noun is always kein: *Ich habe **keinen** '
        'Hund.*',
  ),
  HelpMemoryTip(
    kind: 'example',
    title: 'We have no bread and no eggs today.',
    text: 'Wir haben heute **kein** Brot und **keine** Eier.',
  ),
];

const List<HelpMemoryTip> _timeTips = [
  HelpMemoryTip(
    kind: 'rule',
    title: 'um · am · im',
    text:
        '**um** + clock time (*um sieben Uhr*), **am** + day or part of day '
        '(*am Montag, am Abend* — but *in der Nacht*), **im** + month or '
        'season (*im Juli, im Winter*). Three little words cover the whole '
        'calendar.',
  ),
  HelpMemoryTip(
    kind: 'warning',
    title: 'halb looks forward',
    text:
        'German **halb zehn** means half an hour BEFORE ten, so 9:30 — not '
        '10:30. Likewise *Viertel vor zehn* = 9:45 and *Viertel nach neun* '
        '= 9:15.',
  ),
  HelpMemoryTip(
    kind: 'mnemonic',
    title: 'halb = halfway TO the hour',
    text:
        'Read halb as "halfway to": halb acht is halfway to eight, 7:30. '
        'If you translate "half past", you will be an hour late all over '
        'Germany.',
  ),
  HelpMemoryTip(
    kind: 'example',
    title: 'The film starts on Saturday at half past eight.',
    text: 'Der Film beginnt **am Samstag um halb neun**.',
  ),
];

const List<HelpMemoryTip> _modalTips = [
  HelpMemoryTip(
    kind: 'rule',
    title: 'The three A1 modals',
    text:
        'können (can): ich **kann**, du **kannst**, er **kann**, wir '
        '**können**. müssen (must): ich **muss**, du **musst**, er '
        '**muss**. möchten (would like): ich **möchte**, du **möchtest**, '
        'er **möchte**. Note: ich and er share one endingless form.',
  ),
  HelpMemoryTip(
    kind: 'rule',
    title: 'Modals build a bracket',
    text:
        'The modal takes position 2, its partner verb goes to the very end '
        'as an infinitive: *Ich **muss** heute Milch **kaufen**.* / *Du '
        '**kannst** die Küche **aufräumen**.* Everything else lives inside '
        'the bracket.',
  ),
  HelpMemoryTip(
    kind: 'warning',
    title: 'Do not conjugate the second verb',
    text:
        '*Ich möchte kaufe Brot* is wrong on both counts: the second verb '
        'stays an infinitive AND parks at the end — *Ich möchte Brot '
        '**kaufen**.*',
  ),
  HelpMemoryTip(
    kind: 'example',
    title: 'You have to buy milk and tidy the kitchen.',
    text: 'Du **musst** Milch **kaufen** und die Küche **aufräumen**.',
  ),
];

const List<HelpMemoryTip> _gernTips = [
  HelpMemoryTip(
    kind: 'rule',
    title: 'gern sits next to the verb',
    text:
        'To like DOING something, keep the verb and add **gern** right '
        'after it: *Ich koche **gern**.* *Ich sehe **gern** fern.* For '
        'preferences use **lieber**: *Ich trinke **lieber** Tee.*',
  ),
  HelpMemoryTip(
    kind: 'warning',
    title: 'Not "Ich mag kochen gern"',
    text:
        'Pick one pattern: *Ich koche **gern*** or *Ich mag Kochen* — '
        'never both at once. gern is an adverb, not a verb, so it never '
        'conjugates and never starts the sentence alone.',
  ),
  HelpMemoryTip(
    kind: 'example',
    title: 'In the evening I like watching TV, but I prefer reading.',
    text: 'Am Abend sehe ich **gern** fern, aber ich lese **lieber**.',
  ),
];

final List<QuizContent> enDeAiM2Quizzes = [
  enDeAiEx(
    id: 'en_de_ai_m2_words_routine',
    title: 'Words: routine verbs & prefixes',
    level: 'A1',
    mode: SpeakingMode.vocabDrill,
    session: _a1Session,
    topic:
        'Daily-routine verbs, many of them separable. Quiz each verb, then '
        'ask "What do you do at 7:00?"-style questions that force me to '
        'split the prefix: ich stehe um sieben Uhr auf.',
    material:
        'Words to drill (word = meaning; | marks separable prefixes):\n'
        'auf|stehen = to get up · früh|stücken = to have breakfast · '
        'ein|kaufen = to go shopping · an|fangen = to begin · '
        'fern|sehen = to watch TV · an|rufen = to call (phone) · '
        'auf|räumen = to tidy up · mit|kommen = to come along\n'
        'arbeiten = to work · kochen = to cook · schlafen = to sleep · '
        'duschen = to shower · lesen = to read · '
        'das Frühstück = breakfast · der Feierabend = end of the workday · '
        'die Arbeit = work',
    practisePoints: [
      'Recalling each verb in both directions',
      'Separable verbs in a full sentence: prefix at the end',
      'Combining verbs with exact clock times (um sieben Uhr)',
    ],
    scoringCriteria: [
      'the right verb',
      'the prefix split off and sent to the end',
      'correct present-tense endings',
    ],
    priorityErrors: [
      'prefix left glued to the verb (ich aufstehe)',
      'prefix in the wrong place',
    ],
    intro:
        'Half of German routine verbs carry a detachable prefix: in the '
        'present tense the stem sits in position 2 and the prefix falls to '
        'the very end — aufstehen becomes "Ich stehe um sieben Uhr auf."',
    tips: _separableTips,
  ),
  enDeAiEx(
    id: 'en_de_ai_m2_translate_akk',
    title: 'Translate: the accusative gauntlet',
    level: 'A1',
    mode: SpeakingMode.translationDrill,
    session: _a1Session,
    topic:
        'Twelve English sentences that pit accusative forms (den, einen, '
        'keinen, ihn) against their nominative lookalikes. Serve them one '
        'at a time and be strict about the endings.',
    material:
        'Serve me only the English half, one sentence at a time; the '
        'German after "=" is the reference answer, and any other correct '
        'German is acceptable:\n'
        '1. I see the man. = Ich sehe den Mann.\n'
        '2. The man sees me. = Der Mann sieht mich.\n'
        '3. She buys a table. = Sie kauft einen Tisch.\n'
        '4. The table is new. = Der Tisch ist neu.\n'
        '5. We have no dog. = Wir haben keinen Hund.\n'
        '6. I need the key. = Ich brauche den Schlüssel.\n'
        '7. Do you know my brother? = Kennst du meinen Bruder?\n'
        '8. My brother knows you. = Mein Bruder kennt dich.\n'
        '9. He drinks a coffee every morning. = '
        'Er trinkt jeden Morgen einen Kaffee.\n'
        '10. I don\'t drink coffee. = Ich trinke keinen Kaffee.\n'
        '11. She loves him, and he loves her. = '
        'Sie liebt ihn, und er liebt sie.\n'
        '12. We are looking for an apartment. = Wir suchen eine Wohnung.',
    practisePoints: [
      'der→den, ein→einen, kein→keinen for masculine objects',
      'Accusative pronouns: mich, dich, ihn, sie, uns',
      'Spotting which noun is the object at all',
    ],
    scoringCriteria: [
      'correct accusative endings',
      'kein vs nicht chosen correctly',
      'word order kept verb-second',
    ],
    priorityErrors: [
      'nominative used for the object (ich sehe der Mann)',
      'nicht where kein belongs',
    ],
    intro:
        'The accusative marks the direct object, and only the masculine '
        'forms actually change: der → den, ein → einen, kein → keinen, '
        'er → ihn. Twelve sentences, most of them aimed at exactly that row.',
    tips: _akkTips,
  ),
  enDeAiEx(
    id: 'en_de_ai_m2_read_imcafe',
    title: 'Reading: Im Café',
    level: 'A1',
    mode: SpeakingMode.readingQa,
    session: _a1Session,
    topic:
        'A short café ordering scene to read and answer questions about. '
        'Ask in simple German; two questions make me pull an exact price '
        'and an exact time out of the text.',
    material:
        'Passage (show it to me exactly like this):\n'
        'Es ist halb zehn am Samstagmorgen. Paul sitzt im Café Sonne und '
        'liest die Karte. Er möchte einen Milchkaffee und ein Croissant. '
        'Der Milchkaffee kostet 3,80 Euro, das Croissant kostet 2,20 Euro. '
        'Die Kellnerin sagt: "Wir haben leider kein Croissant mehr." Paul '
        'nimmt dann einen Käsekuchen. Um zehn Uhr kommt seine Freundin '
        'Mia, und sie bestellt nur ein Wasser.\n'
        '\n'
        'Ask me (one at a time):\n'
        '1. Wann sitzt Paul im Café?\n'
        '2. Was möchte Paul zuerst bestellen?\n'
        '3. Was kostet der Milchkaffee?\n'
        '4. Warum nimmt Paul einen Käsekuchen?\n'
        '5. Um wie viel Uhr kommt Mia, und was bestellt sie?',
    practisePoints: [
      'Finding exact prices and times in a text',
      'Understanding kein in context (kein Croissant mehr)',
      'Answering with accusative objects: einen Käsekuchen',
    ],
    scoringCriteria: [
      'correct information from the text',
      'prices and times said correctly',
      'full-sentence answers',
    ],
    priorityErrors: ['numbers misread or mis-said', 'answers off the text'],
    intro:
        'German times read differently from English: halb zehn is 9:30, '
        'and prices come as "drei Euro achtzig". This café scene hides '
        'both, plus a kein and two accusative objects, in six sentences.',
    tips: [
      ..._timeTips,
      HelpMemoryTip(
        kind: 'tip',
        title: 'Prices out loud',
        text:
            '3,80 Euro is said *drei Euro achtzig* — Euro in the middle, no '
            '"und", and the comma is a German decimal point.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m2_typical_tuesday',
    title: 'Your typical Tuesday',
    level: 'A1',
    mode: SpeakingMode.conversation,
    session: _a1Session,
    topic:
        'We talk through my typical Tuesday from morning to night. Enforce '
        'at least four separable verbs and three exact clock times from me; '
        'when the workday is done, steer me to my hobbies and what I do '
        'gern in the evening.',
    material:
        'Useful phrases I have studied (phrase = meaning) - steer me to '
        'use them:\n'
        'ich stehe um … auf = I get up at … · '
        'die Arbeit fängt um … an = work starts at … · '
        'ich kaufe nach der Arbeit ein = I shop after work · '
        'am Abend sehe ich fern = in the evening I watch TV · '
        'ich koche gern = I like cooking · '
        'ich lese lieber = I prefer reading · '
        'um halb elf schlafe ich = at half past ten I sleep',
    practisePoints: [
      'Separable verbs across a whole day',
      'Exact times with um and half-hours',
      'gern/lieber for likes and preferences',
    ],
    targetVocabulary: [
      'aufstehen',
      'einkaufen',
      'fernsehen',
      'anfangen',
      'das Hobby',
      'gern',
      'lieber',
      'der Feierabend',
    ],
    scoringCriteria: [
      'four separable verbs used correctly',
      'three exact times',
      'natural gern/lieber statements',
    ],
    priorityErrors: [
      'unsplit separable verbs',
      'times without um or in English order',
    ],
    intro:
        'A daily routine in German is a chain of the same melody: time '
        'first or subject first, verb in slot 2, prefix at the end — "Um '
        'sieben stehe ich auf." Add gern and lieber once the workday ends.',
    tips: [..._separableTips, ..._gernTips],
  ),
  enDeAiEx(
    id: 'en_de_ai_m2_einkaufs_taboo',
    title: 'Game: Einkaufs-Taboo',
    level: 'A1',
    mode: SpeakingMode.wordGame,
    session: _a1Session,
    topic:
        'A taboo guessing game with supermarket items. I describe, you '
        'guess. Keep it playful and never let me say the secret word.',
    material:
        'Game rules:\n'
        '- Give me 8 supermarket items one at a time, in English, e.g. '
        'apple, milk, bread, cheese, egg, tomato, butter, chocolate.\n'
        '- I must describe each item IN GERMAN without saying the German '
        'word itself (das runde, rote Obst…), and you guess it.\n'
        '- You guess it from my German = 10 points for me. I say the '
        'secret word or fall into English = 0 points for that round.\n'
        '- Bonus: +2 points per round if my description uses a correct '
        'accusative (Man kauft einen…, Ich esse keinen…).\n'
        '- 8 rounds, then convert my points to the final score.\n'
        'Useful describing phrases (phrase = meaning):\n'
        'man kauft es im Supermarkt = you buy it at the supermarket · '
        'ich esse es zum Frühstück = I eat it for breakfast · '
        'man trinkt es kalt = you drink it cold · '
        'es ist rot und rund = it is red and round · '
        'man macht daraus einen Kuchen = you make a cake out of it',
    practisePoints: [
      'Describing food with colours, sizes and simple verbs',
      'Accusative objects in the descriptions',
      'Staying in German when the exact word is missing',
    ],
    scoringCriteria: [
      'descriptions clear enough to guess',
      'correct accusative forms in descriptions',
      'no English, no secret words',
    ],
    priorityErrors: ['switching to English', 'accusative endings dropped'],
    intro:
        'Talking around a missing word is a core beginner skill — and '
        'every description here is an accusative in disguise: man kauft '
        'einen Apfel, ich esse keinen Fisch. Describe, don\'t name.',
    tips: [
      ..._akkTips,
      HelpMemoryTip(
        kind: 'tip',
        title: 'Three angles always work',
        text:
            'Colour, where you buy or eat it, and what you do with it: '
            '*Es ist weiß, ich trinke es zum Frühstück.* Sold — that\'s '
            '**die Milch**.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m2_words_kein',
    title: 'Words: food & drink with kein',
    level: 'A1',
    mode: SpeakingMode.vocabDrill,
    session: _a1Session,
    topic:
        'Food and drink vocabulary drilled through pretend shortages: ask '
        '"Do you have milk?" and I answer "Nein, ich habe keine Milch." '
        'Re-ask every item I get wrong later in the session.',
    material:
        'Words to drill (word = meaning):\n'
        'die Milch = milk · das Brot = bread · der Käse = cheese · '
        'der Apfel = apple · das Ei = egg · die Butter = butter · '
        'die Tomate = tomato · der Saft = juice · das Wasser = water · '
        'der Reis = rice · die Kartoffel = potato · das Fleisch = meat · '
        'der Zucker = sugar · die Wurst = sausage · der Tee = tea\n'
        'Drill shape: ask "Hast du …?" or "Gibt es …?" — I must answer '
        'with the right form of kein (keinen/keine/kein) and gender.',
    practisePoints: [
      'Food words with their articles',
      'kein bending like ein: keinen Käse, keine Milch, kein Brot',
      'Quick Nein-answers in full sentences',
    ],
    scoringCriteria: [
      'the right word and gender',
      'the matching kein form',
      'full-sentence answers',
    ],
    priorityErrors: ['kein form not matching gender', 'nicht used instead'],
    intro:
        'German negates nouns with kein, and kein bends exactly like ein: '
        'keinen Käse (m.), keine Milch (f.), kein Brot (n.). Fifteen '
        'foods, and every "no" must carry the form that matches the gender.',
    tips: _keinTips,
  ),
  enDeAiEx(
    id: 'en_de_ai_m2_market_roleplay',
    title: 'Scene: at the market stall',
    level: 'A1',
    mode: SpeakingMode.roleplay,
    session: _a1Session,
    topic:
        'You are a friendly market seller, I am the customer. I buy five '
        'items, ask the price of each, and politely refuse one thing you '
        'try to sell me extra (möchte/kein). End with the total and a '
        'goodbye.',
    material:
        'Useful phrases I have studied (phrase = meaning) - steer me to '
        'use them:\n'
        'ich möchte ein Kilo Äpfel = I would like a kilo of apples · '
        'was kostet die Tomate? = what does the tomato cost · '
        'das ist zu teuer = that is too expensive · '
        'nein danke, ich möchte keinen Fisch = '
        'no thanks, I don\'t want any fish · '
        'das ist alles = that is all · '
        'was macht das zusammen? = what does that come to',
    targetVocabulary: [
      'Ich möchte…',
      'Was kostet…?',
      'das Kilo',
      'der Apfel',
      'die Tomate',
      'zu teuer',
      'Das ist alles.',
    ],
    practisePoints: [
      'Ordering amounts: ein Kilo Äpfel, zwei Tomaten',
      'Asking and understanding prices',
      'Refusing politely with möchte + kein',
    ],
    scoringCriteria: [
      'five complete purchases with prices asked',
      'one polite refusal',
      'accusative in the orders',
    ],
    priorityErrors: ['refusal missing or rude', 'prices misunderstood'],
    intro:
        'Shopping German runs on two patterns: ordering with möchte plus '
        'an accusative object (Ich möchte einen Apfel), and refusing with '
        'the matching kein form (Ich möchte keinen Fisch). Buy five '
        'things, ask every price, say one kind no.',
    tips: [
      ..._keinTips,
      HelpMemoryTip(
        kind: 'example',
        title: 'A whole purchase in three lines.',
        text:
            'Ich möchte **ein Kilo** Äpfel, bitte. Was kostet **der** Käse? '
            'Danke, **das ist alles**.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m2_story_morgen',
    title: 'Tell it: a chaotic morning',
    level: 'A1',
    mode: SpeakingMode.storytelling,
    session: _a1Session,
    topic:
        'I tell the story of a chaotic morning along your four beats. Keep '
        'me in the present tense, demand separable verbs and exact times, '
        'and ask two follow-up questions at the end.',
    material:
        'Story skeleton:\n'
        '- Beat 1: I oversleep — the alarm rings at 6:30 but I get up '
        'late (aufstehen, aufwachen, exact times).\n'
        '- Beat 2: no coffee in the kitchen — I have kein… anything.\n'
        '- Beat 3: I run and still miss the bus (der Bus fährt um… ab).\n'
        '- Beat 4: a happy end of my choosing — a colleague drives me, or '
        'the boss is even later.\n'
        '- Required: at least 3 separable verbs, 2 exact clock times, and '
        'one kein-sentence.\n'
        'Useful phrases I have studied (phrase = meaning) - steer me to '
        'use them:\n'
        'der Wecker klingelt um halb sieben = '
        'the alarm rings at half past six · '
        'ich wache zu spät auf = I wake up too late · '
        'ich stehe erst um sieben auf = I only get up at seven · '
        'es gibt keinen Kaffee = there is no coffee · '
        'der Bus fährt um acht ab = the bus leaves at eight · '
        'eine Kollegin nimmt mich mit = a colleague gives me a lift',
    practisePoints: [
      'Separable verbs under story pressure',
      'Clock times woven into sentences',
      'A kein-sentence at the worst moment',
    ],
    scoringCriteria: [
      'all four beats covered in order',
      'required forms present and correct',
      'the story understandable end to end',
    ],
    priorityErrors: ['prefixes not split', 'beats skipped'],
    intro:
        'Stories at A1 stay in the present tense, and the grammar of a bad '
        'morning is this module in miniature: separable verbs (aufwachen, '
        'aufstehen, abfahren), exact times with um and halb, and one '
        'well-bent kein when the coffee runs out.',
    tips: [
      ..._separableTips,
      HelpMemoryTip(
        kind: 'tip',
        title: 'Let the times drive the plot',
        text:
            'Times are your scene changes: *Um halb sieben klingelt der '
            'Wecker. Um sieben stehe ich endlich **auf**.* Each new time '
            'is a new beat.',
      ),
    ],
  ),
  enDeAiEx(
    id: 'en_de_ai_m2_write_wg_note',
    title: 'Write: a note to your flatmate',
    level: 'A1',
    mode: SpeakingMode.writing,
    session: _a1Session,
    topic:
        'A short written note to my flatmate before I head out. Grade the '
        'note against the rubric in the material, sentence by sentence.',
    material:
        'Writing task:\n'
        '- Write a 6–8 sentence note to your flatmate: what you are going '
        'to buy, when you are back (exact time), and two things they '
        'should or must do (modal verbs!).\n'
        '- Include at least one kein-sentence about something missing in '
        'the flat.\n'
        'Rubric (grade against this):\n'
        '- Modal verbs correct, with the second verb at the end '
        '(Du musst die Küche aufräumen).\n'
        '- Accusative objects in the shopping list sentences.\n'
        '- One exact time with um.\n'
        '- The kein-sentence bends kein correctly.',
    practisePoints: [
      'Modal verbs: the second verb parks at the end',
      'Shopping objects in the accusative',
      'kein and exact times in writing',
    ],
    scoringCriteria: [
      'modal-verb sentence shape',
      'accusative endings',
      'rubric points covered',
    ],
    priorityErrors: [
      'second verb not at the end after a modal',
      'accusative endings dropped',
    ],
    intro:
        'Modal verbs do the bossing in German: the modal (kannst, musst, '
        'möchtest) takes position 2 and pushes its partner verb to the end '
        'as an infinitive — "Du musst die Küche aufräumen." Writing gives '
        'you the time to park that second verb where it belongs.',
    tips: _modalTips,
  ),
  enDeAiEx(
    id: 'en_de_ai_m2_gate_interview',
    title: 'Module exam: a day in your life',
    level: 'A1',
    mode: SpeakingMode.interview,
    session: SpeakingSession(durationMinutes: 4, minExchanges: 7),
    topic:
        'The closing interview for module A1.2: a day-in-my-life interview '
        'across the whole module — my routine with times, shopping and '
        'food, likes and dislikes with gern, appointments with am/im/um, '
        'and at least one question I must answer with kein.',
    material:
        'Useful phrases I have studied (phrase = meaning) - steer me to '
        'use them:\n'
        'ich stehe um sieben Uhr auf = I get up at seven · '
        'ich muss um acht anfangen = I have to start at eight · '
        'ich trinke keinen Kaffee = I don\'t drink coffee · '
        'am Wochenende koche ich gern = at the weekend I like cooking · '
        'ich sehe lieber fern = I prefer watching TV · '
        'im Juli habe ich Urlaub = in July I have a holiday · '
        'ich möchte einen Termin machen = I would like to make '
        'an appointment',
    practisePoints: [
      'Separable verbs and modal verbs in free answers',
      'Accusative articles and pronouns',
      'kein vs nicht chosen on the fly',
      'Times and dates with am/im/um',
    ],
    scoringCriteria: [
      'full-sentence answers',
      'accusative endings correct',
      'separable and modal verb word order',
    ],
    priorityErrors: [
      'accusative endings wrong or missing',
      'kein/nicht confused',
      'separable-verb order broken',
    ],
    intro:
        'Everything in this module lives in one ordinary day: separable '
        'verbs with the prefix last, modals bracketing a second verb, '
        'masculine objects in -en, kein matched to gender, and um/am/im '
        'for every time and date. The gate interview asks for all of it '
        'in free answers.',
    tips: [
      HelpMemoryTip(
        kind: 'rule',
        title: 'The module on one card',
        text:
            'Accusative: der→**den**, ein→**einen**, kein→**keinen**, '
            'er→**ihn**. Separable verbs: prefix last. Modals: second verb '
            'last as infinitive. Time: **um** + clock, **am** + day, '
            '**im** + month.',
      ),
      HelpMemoryTip(
        kind: 'warning',
        title: 'Slow down for the endings',
        text:
            'In the exam, one deliberate **einen** beats three rushed '
            '"ein"s. The graders here care about the last letter of the '
            'article more than your speed.',
      ),
      HelpMemoryTip(
        kind: 'example',
        title: 'I get up at seven, but on Sunday I prefer to sleep long.',
        text:
            'Ich stehe um sieben Uhr **auf**, aber am Sonntag **möchte** '
            'ich lieber lange **schlafen**.',
      ),
    ],
  ),
];
