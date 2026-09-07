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

const _copyTip = HelpMemoryTip(
  kind: 'rule',
  title: 'How this course works',
  text:
      'Copy the exercise into your AI assistant (voice mode is best), do the '
      'exercise there, and paste the score it gives you back here. Stay with '
      'one assistant so your scores stay comparable.',
);

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
        'Module 2 opens with the verbs of your day — half of them break in '
        'two. The AI drills the words, then makes you use them in sentences '
        'so the prefix lands where it belongs: at the very end.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'rule',
        title: 'The prefix jumps to the end',
        text:
            'aufstehen becomes "Ich stehe um sieben Uhr auf." The verb goes '
            'second, the prefix goes last — everything else sits between.',
      ),
    ],
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
        'Sentences to serve one at a time (accept any correct German):\n'
        '1. I see the man.\n'
        '2. The man sees me.\n'
        '3. She buys a table.\n'
        '4. The table is new.\n'
        '5. We have no dog.\n'
        '6. I need the key.\n'
        '7. Do you know my brother?\n'
        '8. My brother knows you.\n'
        '9. He drinks a coffee every morning.\n'
        '10. I don\'t drink coffee. (kein!)\n'
        '11. She loves him, and he loves her.\n'
        '12. We are looking for an apartment.',
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
        'The accusative is the star of this module, and only the masculine '
        'words actually change — which is exactly where this drill aims. '
        'Twelve sentences, most of them traps.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'mnemonic',
        title: 'Only der becomes den',
        text:
            'In the accusative, die, das and the plurals stay put. Only the '
            'masculine changes: der→den, ein→einen, kein→keinen. One row of '
            'the table does all the work.',
      ),
    ],
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
        'A reading with numbers hiding in it: the AI shows you a café scene '
        'and asks five questions. Two answers are only right if the price '
        'and the time come out exactly.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'tip',
        title: 'halb zehn is 9:30',
        text:
            'German "halb" looks forward: halb zehn means half an hour '
            'BEFORE ten, so 9:30. Check the first sentence twice.',
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
        'A guided chat about your Tuesday. The AI keeps count: four '
        'separable verbs and three real clock times before the day may '
        'end — then it asks what you actually enjoy.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'example',
        title: 'A whole day in one shape',
        text:
            '"Um sieben Uhr stehe ich auf. Um acht fange ich an. Am Abend '
            'sehe ich gern fern." Time first, verb second, prefix last — '
            'the same melody all day long.',
      ),
    ],
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
        '- 8 rounds, then convert my points to the final score.',
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
        'A game of talking around the word — the most useful skill a '
        'beginner has. Describe eight groceries without naming them and '
        'let your AI do the guessing.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'tip',
        title: 'Three angles always work',
        text:
            'Colour, where you buy or eat it, and what you do with it: '
            '"Es ist weiß, ich trinke es zum Frühstück." Sold — that\'s '
            'die Milch.',
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
        'A vocabulary drill wearing a disguise: every answer is a polite '
        'shortage. Fifteen foods, and each "no" must carry the right form '
        'of kein.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'rule',
        title: 'kein for nouns, nicht for the rest',
        text:
            'Negating a noun with ein or no article? Use kein, bent like '
            'ein: keinen Saft, keine Butter, kein Ei. nicht negates verbs '
            'and adjectives instead.',
      ),
    ],
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
        'Market day. Buy five things, ask every price, and — the real '
        'test — say no to the sixth thing the seller pushes at you, '
        'kindly and in German.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'example',
        title: 'The polite no',
        text:
            '"Nein danke, ich möchte keinen Fisch. Das ist alles." Refusal, '
            'kein with the right ending, and a clean exit — one breath.',
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
        'one kein-sentence.',
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
        'Everyone owns this story: the morning everything went wrong. Tell '
        'it in four beats — the AI checks the grammar hides inside the '
        'chaos, not instead of it.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'tip',
        title: 'Let the times drive the plot',
        text:
            'Times are your scene changes: "Um halb sieben klingelt der '
            'Wecker. Um sieben stehe ich endlich auf." Each new time is a '
            'new beat.',
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
        'A real-life text type: the note on the kitchen table. Modal verbs '
        'do the bossing — kannst, musst, möchtest — and writing gives you '
        'time to park the second verb at the end.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'rule',
        title: 'Modals build a bracket',
        text:
            'The modal takes second position, its partner verb goes last: '
            '"Ich muss heute Milch kaufen." Everything you buy lives '
            'inside the bracket.',
      ),
    ],
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
        'The module gate: an interview about an ordinary day, which is '
        'exactly where this grammar lives. Pass it and A2.1 unlocks — '
        'retake freely, your best score counts.',
    tips: [
      _copyTip,
      HelpMemoryTip(
        kind: 'tip',
        title: 'Slow down for the endings',
        text:
            'In the exam, one deliberate "einen" beats three rushed "ein"s. '
            'The graders here care about the last letter of the article '
            'more than your speed.',
      ),
    ],
  ),
];
